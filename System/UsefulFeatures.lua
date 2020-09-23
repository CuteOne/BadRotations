function br:AcceptQueues()
	if getOptionCheck("Accept Queues") then
		-- Accept Queues
		if randomReady == nil then
			randomReady = math.random(8,15)
		end
		-- add some randomness
		if readyToAccept and readyToAccept <= GetTime() - 5 then
			AcceptProposal(); readyToAccept = nil; randomReady = nil
		end
	end
end
------------------------------------------------------------------------------------------------------------------------
-- idTip by Silverwind
local hooksecurefunc, select, UnitBuff, UnitDebuff, UnitAura, UnitGUID, GetGlyphSocketInfo, tonumber, strfind =
	hooksecurefunc, select, UnitBuff, UnitDebuff, UnitAura, UnitGUID, GetGlyphSocketInfo, tonumber, strfind
local types = {
	spell       = "SpellID:",
	item        = "ItemID:",
	glyph       = "GlyphID:",
	unit        = "NPC ID:",
	quest       = "QuestID:",
	talent      = "TalentID:",
	achievement = "AchievementID:"
}
local function addLine(tooltip, id, type, noEmptyLine)
	local found = false
	-- Check if we already added to this tooltip. Happens on the talent frame
	for i = 1,15 do
		local frame = _G[tooltip:GetName() .. "TextLeft" .. i]
		local text
		if frame then text = frame:GetText() end
		if text and text == type then found = true break end
	end
	if not found then
		if not noEmptyLine then tooltip:AddLine(" ") end
		tooltip:AddDoubleLine(type, "|cffffffff" .. id)
		tooltip:Show()
	end
end
-- All types, primarily for linked tooltips
local function onSetHyperlink(self, link)
	local type, id = string.match(link,"^(%a+):(%d+)")
	if not type or not id then return end
	if type == "spell" or type == "enchant" or type == "trade" then
		addLine(self, id, types.spell)
	elseif type == "glyph" then
		addLine(self, id, types.glyph)
	elseif type == "talent" then
		addLine(self, id, types.talent)
	elseif type == "quest" then
		addLine(self, id, types.quest)
	elseif type == "achievement" then
		addLine(self, id, types.achievement)
	elseif type == "item" then
		addLine(self, id, types.item)
	end
end
hooksecurefunc(ItemRefTooltip, "SetHyperlink", onSetHyperlink)
hooksecurefunc(GameTooltip, "SetHyperlink", onSetHyperlink)
-- Spells
hooksecurefunc(GameTooltip, "SetUnitBuff", function(self, ...)
	local id = select(10, UnitBuff(...))
	if id then addLine(self, id, types.spell) end
end)
hooksecurefunc(GameTooltip, "SetUnitDebuff", function(self,...)
	local id = select(10, UnitDebuff(...))
	if id then addLine(self, id, types.spell) end
end)
hooksecurefunc(GameTooltip, "SetUnitAura", function(self,...)
	local id = select(10, UnitAura(...))
	if id then addLine(self, id, types.spell) end
end)
hooksecurefunc("SetItemRef", function(link, ...)
	local id = tonumber(link:match("spell:(%d+)"))
	if id then addLine(ItemRefTooltip, id, types.spell) end
end)
GameTooltip:HookScript("OnTooltipSetSpell", function(self)
	local id = select(3, self:GetSpell())
	if id then addLine(self, id, types.spell) end
end)
-- NPCs
GameTooltip:HookScript("OnTooltipSetUnit", function(self)
	if C_PetBattles.IsInBattle() then return end
	local unit = select(2, self:GetUnit())
	if isChecked("Unit ID In Tooltip") and unit then
		local guid = UnitGUID(unit) or ""
		local id   = tonumber(guid:match("-(%d+)-%x+$"), 10)
		local type = guid:match("%a+")
		-- ID 970 seems to be used for players
		if id and type ~= "Player" then addLine(GameTooltip, id, types.unit) end
	end
end)
-- Items
local function attachItemTooltip(self)
	local link = select(2, self:GetItem())
	if link then
		local id = select(3, strfind(link, "^|%x+|Hitem:(%-?%d+):(%d+):(%d+).*"))
		if id then addLine(self, id, types.item) end
	end
end
GameTooltip:HookScript("OnTooltipSetItem", attachItemTooltip)
ItemRefTooltip:HookScript("OnTooltipSetItem", attachItemTooltip)
ItemRefShoppingTooltip1:HookScript("OnTooltipSetItem", attachItemTooltip)
ItemRefShoppingTooltip2:HookScript("OnTooltipSetItem", attachItemTooltip)
ShoppingTooltip1:HookScript("OnTooltipSetItem", attachItemTooltip)
ShoppingTooltip2:HookScript("OnTooltipSetItem", attachItemTooltip)
-- Glyphs -- Commented out due to Legion
-- hooksecurefunc(GameTooltip, "SetGlyph", function(self, ...)
-- 	local id = select(4, GetGlyphSocketInfo(...))
-- 	if id then addLine(self, id, types.glyph) end
-- end)
-- hooksecurefunc(GameTooltip, "SetGlyphByID", function(self, id)
-- 	if id then addLine(self, id, types.glyph) end
-- end)
-- Achievement Frame Tooltips
local f = CreateFrame("frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(_, _, what)
	if what == "Blizzard_AchievementUI" then
		for i,button in ipairs(AchievementFrameAchievementsContainer.buttons) do
			button:HookScript("OnEnter", function()
				GameTooltip:SetOwner(button, "ANCHOR_NONE")
				GameTooltip:SetPoint("TOPLEFT", button, "TOPRIGHT", 0, 0)
				addLine(GameTooltip, button.id, types.achievement, true)
				GameTooltip:Show()
			end)
			button:HookScript("OnLeave", function()
				GameTooltip:Hide()
			end)
		end
	end
end)
local petAbilityTooltipID = false;
local orig_SharedPetBattleAbilityTooltip_SetAbility = SharedPetBattleAbilityTooltip_SetAbility
function SharedPetBattleAbilityTooltip_SetAbility(self, abilityInfo, additionalText)
	orig_SharedPetBattleAbilityTooltip_SetAbility(self, abilityInfo, additionalText)
	petAbilityTooltipID = abilityInfo:GetAbilityID()
end
PetBattlePrimaryAbilityTooltip:HookScript('OnShow', function(self)
	local name = self.Name:GetText()
	self.Name:SetText(name .. ' (ID: ' .. petAbilityTooltipID .. ')')
end)
------------------------------------------------------------------------------------------------------------------------
-- LibStub
-- $Id: LibStub.lua 76 2007-09-03 01:50:17Z mikk $
-- LibStub is a simple versioning stub meant for use in Libraries.  http://www.wowace.com/wiki/LibStub for more info
-- LibStub is hereby placed in the Public Domain
-- Credits: Kaelten, Cladhaire, ckknight, Mikk, Ammo, Nevcairiel, joshborke
local LIBSTUB_MAJOR, LIBSTUB_MINOR = "LibStub", 2  -- NEVER MAKE THIS AN SVN REVISION! IT NEEDS TO BE USABLE IN ALL REPOS!
local LibStub = _G[LIBSTUB_MAJOR]
-- Check to see is this version of the stub is obsolete
if not LibStub or LibStub.minor < LIBSTUB_MINOR then
	LibStub = LibStub or {libs = {}, minors = {} }
	_G[LIBSTUB_MAJOR] = LibStub
	LibStub.minor = LIBSTUB_MINOR
	-- LibStub:NewLibrary(major, minor)
	-- major (string) - the major version of the library
	-- minor (string or number ) - the minor version of the library
	--
	-- returns nil if a newer or same version of the lib is already present
	-- returns empty library object or old library object if upgrade is needed
	function LibStub:NewLibrary(major, minor)
		assert(type(major) == "string", "Bad argument #2 to `NewLibrary' (string expected)")
		minor = assert(tonumber(strmatch(minor, "%d+")), "Minor version must either be a number or contain a number.")
		local oldminor = self.minors[major]
		if oldminor and oldminor >= minor then return nil end
		self.minors[major], self.libs[major] = minor, self.libs[major] or {}
		return self.libs[major], oldminor
	end
	-- LibStub:GetLibrary(major, [silent])
	-- major (string) - the major version of the library
	-- silent (boolean) - if true, library is optional, silently return nil if its not found
	--
	-- throws an error if the library can not be found (except silent is set)
	-- returns the library object if found
	function LibStub:GetLibrary(major, silent)
		if not self.libs[major] and not silent then
			error(("Cannot find a library instance of %q."):format(tostring(major)), 2)
		end
		return self.libs[major], self.minors[major]
	end
	-- LibStub:IterateLibraries()
	--
	-- Returns an iterator for the currently registered libraries
	function LibStub:IterateLibraries()
		return pairs(self.libs)
	end
	setmetatable(LibStub, { __call = LibStub.GetLibrary })
end

function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end
