local _, br = ...
br.ui.tooltips = br.ui.tooltips or {}
local tooltips = br.ui.tooltips

------------------------------------------------------------------------------------------------------------------------
-- idTip by Silverwind
local hooksecurefunc, select, UnitGUID, tonumber, strfind =
	br._G.hooksecurefunc,
	br._G.select,
	br._G.UnitGUID,
	br._G.tonumber,
	br._G.strfind
local types = {
	spell = "SpellID:",
	item = "ItemID:",
	glyph = "GlyphID:",
	unit = "NPC ID:",
	quest = "QuestID:",
	talent = "TalentID:",
	achievement = "AchievementID:"
}
local function addLine(tooltip, id, type, noEmptyLine)
	local found = false
	-- Check if we already added to this tooltip. Happens on the talent frame
	for i = 1, 15 do
		local frame = _G[tooltip:GetName() .. "TextLeft" .. i]
		if frame then
			local ok, match = pcall(function()
				local text = frame:GetText()
				return text and text == type
			end)
			if ok and match then
				found = true
				break
			end
		end
	end
	if not found then
		if not noEmptyLine then
			tooltip:AddLine(" ")
		end
		tooltip:AddDoubleLine(type, "|cffffffff" .. id)
		tooltip:Show()
	end
end
-- All types, primarily for linked tooltips
local function onSetHyperlink(self, link)
	local type, id = string.match(link, "^(%a+):(%d+)")
	if not type or not id then
		return
	end
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
hooksecurefunc(_G.ItemRefTooltip, "SetHyperlink", onSetHyperlink)
hooksecurefunc(GameTooltip, "SetHyperlink", onSetHyperlink)
-- The spell ID of an aura tooltip (getData: a br.api.wow aura reader), or nil when it can't be read:
-- the aura readers throw in combat on Forever, and the ID can be secret
local function auraSpellID(getData, ...)
	local ok, id = pcall(function(...)
		local aura = getData(...)
		return aura and aura.spellId
	end, ...)
	if ok and id and br.functions.misc:canUseValue(id) then return id end
end
-- Spells
for method, getData in pairs({ SetUnitBuff = "GetBuffDataByIndex", SetUnitDebuff = "GetDebuffDataByIndex",
	SetUnitAura = "GetAuraDataByIndex" }) do
	-- SetUnitAura is the Shadowlands-era script point; other clients only have SetUnitBuff/SetUnitDebuff
	if br._G.GameTooltip[method] then
		hooksecurefunc(br._G.GameTooltip, method, function(self, ...)
			local id = auraSpellID(br.api.wow[getData], ...)
			if id then
				addLine(self, id, types.spell)
			end
		end)
	end
end
hooksecurefunc(
	"SetItemRef",
	function(link, ...)
		local id = tonumber(link:match("spell:(%d+)"))
		if id then
			addLine(br._G.ItemRefTooltip, id, types.spell)
		end
	end
)
-- Spell tooltips (uses compatibility wrapper for Retail vs Classic)
if br.api and br.api.wow and br.api.wow.HookTooltipSetSpell then
	br.api.wow.HookTooltipSetSpell(function(tooltip, id)
		addLine(tooltip, id, types.spell)
	end)
end
-- NPCs
local function unitTooltipHandler(tooltip)
	if br._G.C_PetBattles and br._G.C_PetBattles.IsInBattle and br._G.C_PetBattles.IsInBattle() then
		return
	end

	local unit = select(2, tooltip:GetUnit())
	if br.functions.misc:isChecked("Unit ID In Tooltip") and unit then
		local guid = UnitGUID(unit) or ""
		local id = tonumber(guid:match("-(%d+)-%x+$"), 10)
		local type = guid:match("%a+")
		-- ID 970 seems to be used for players
		if id and type ~= "Player" then
			addLine(tooltip, id, types.unit)
		end
	end
end

-- Target Validation Debug: why the hovered unit is or isn't a valid target (misc:isValidUnit), and when
-- it isn't in the enemies list, why it doesn't pass misc:enemyListCheck
function tooltips:targetValidationDebugHandler(tooltip)
	if not br.functions.misc:isChecked("Target Validation Debug") then
		return
	end
	if br._G.C_PetBattles and br._G.C_PetBattles.IsInBattle and br._G.C_PetBattles.IsInBattle() then
		return
	end
	-- Validation needs the unlocker's object functions
	if not (br.unlocked and br._G.GetObjectCount ~= nil) then
		return
	end
	local unit = select(2, tooltip:GetUnit())
	local unitGUID = unit and UnitGUID(unit)
	if not unitGUID then
		return
	end
	-- Only non-player units (or charmed/mind controlled players)
	if unitGUID:match("%a+") == "Player" and not br._G.UnitIsCharmed(unit) then
		return
	end
	local valid, reason = br.functions.misc:isValidUnit(unitGUID)
	if valid then
		tooltip:AddLine("Unit is Valid", 0, 1, 0)
	else
		tooltip:AddLine(reason or "Not valid", 1, 0, 0)
	end
	if br.engines.enemiesEngine.units[unitGUID] == nil then
		local listed, listReason = br.functions.misc:enemyListCheck(unitGUID)
		tooltip:AddLine(listed and "Enemies list: passes (not listed yet)" or ("Enemies list: " .. listReason), 1, 0.5, 0)
	end
end

-- Register tooltip hook (uses compatibility wrapper for Retail vs Classic)
if br.api and br.api.wow and br.api.wow.HookTooltipSetUnit then
	br.api.wow.HookTooltipSetUnit(unitTooltipHandler)
	br.api.wow.HookTooltipSetUnit(function(tooltip) pcall(tooltips.targetValidationDebugHandler, tooltips, tooltip) end)
end
-- Items
local function attachItemTooltip(self)
	if (self == GameTooltip or self == _G.ItemRefTooltip) then
		local link = select(2, self:GetItem())
		if link then
			local id = select(3, strfind(link, "^|%x+|Hitem:(%-?%d+):(%d+):(%d+).*"))
			if id then
				addLine(self, id, types.item)
			end
		end
	end
end

-- Register item tooltip hooks (uses compatibility wrapper for Retail vs Classic)
if br.api and br.api.wow and br.api.wow.HookTooltipSetItem then
	br.api.wow.HookTooltipSetItem(br._G.GameTooltip, attachItemTooltip)
	br.api.wow.HookTooltipSetItem(br._G.ItemRefTooltip, attachItemTooltip)
end
