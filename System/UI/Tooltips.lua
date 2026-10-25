local _, br = ...
br.ui.tooltips = br.ui.tooltips or {}
local tooltips = br.ui.tooltips

------------------------------------------------------------------------------------------------------------------------
-- idTip by Silverwind
local hooksecurefunc, select, UnitGUID, tonumber, strfind =
	br.game.hooksecurefunc,
	br.game.select,
	br.game.UnitGUID,
	br.game.tonumber,
	br.game.strfind

-- Runs callback(tooltip, data) whenever a tooltip of this kind is shown: through the tooltip's old
-- OnTooltipSet* script where it still has it, else TooltipDataProcessor (newer clients drop the
-- scripts, and hooking a missing script errors). onlyThisTooltip limits the TooltipDataProcessor
-- hook to that one tooltip frame (item hooks); spell and unit hooks fire for every tooltip.
local function onTooltip(dataType, scriptName, tooltip, callback, onlyThisTooltip)
	local processor = br.game.TooltipDataProcessor
	local dataTypes = br.game.Enum and br.game.Enum.TooltipDataType
	if tooltip and tooltip.HasScript and tooltip:HasScript(scriptName) then
		tooltip:HookScript(scriptName, function(self) callback(self) end)
	elseif processor and processor.AddTooltipPostCall and dataTypes then
		processor.AddTooltipPostCall(dataTypes[dataType], function(tooltipFrame, data)
			if not onlyThisTooltip or tooltipFrame == tooltip then callback(tooltipFrame, data) end
		end)
	end
end

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
hooksecurefunc(br.game.ItemRefTooltip, "SetHyperlink", onSetHyperlink)
hooksecurefunc(br.game.GameTooltip, "SetHyperlink", onSetHyperlink)
-- The spell ID of an aura tooltip (getData: a br.api.wow aura reader), or nil when there's no aura
-- or the ID isn't a value BR may use
local function auraSpellID(getData, ...)
	local aura = getData(...)
	local id = aura and aura.spellId
	if id and br.functions.misc:canUseValue(id) then return id end
end
-- Spells
for method, getData in pairs({ SetUnitBuff = "GetBuffDataByIndex", SetUnitDebuff = "GetDebuffDataByIndex",
	SetUnitAura = "GetAuraDataByIndex" }) do
	-- SetUnitAura is the Shadowlands-era script point; other clients only have SetUnitBuff/SetUnitDebuff
	if br.game.GameTooltip[method] then
		hooksecurefunc(br.game.GameTooltip, method, function(self, ...)
			local id = auraSpellID(br.game.C_UnitAuras[getData], ...)
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
			addLine(br.game.ItemRefTooltip, id, types.spell)
		end
	end
)
-- Spell tooltips
onTooltip("Spell", "OnTooltipSetSpell", br.game.GameTooltip, function(tooltip, data)
	local id = data and data.id
	if not id and tooltip.GetSpell then id = select(2, tooltip:GetSpell()) end
	if id then addLine(tooltip, id, types.spell) end
end)
-- NPCs
local function unitTooltipHandler(tooltip)
	if br.game.C_PetBattles and br.game.C_PetBattles.IsInBattle and br.game.C_PetBattles.IsInBattle() then
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

-- Target Validation Debug: why the hovered unit isn't a valid target. When it isn't in the enemies list
-- and fails misc:enemyListCheck, that reason (the root cause); otherwise misc:isValidUnit's reason
function tooltips:targetValidationDebugHandler(tooltip)
	if not br.functions.misc:isChecked("Target Validation Debug") then
		return
	end
	if br.game.C_PetBattles and br.game.C_PetBattles.IsInBattle and br.game.C_PetBattles.IsInBattle() then
		return
	end
	-- Validation needs the unlocker's object functions
	if not (br.unlocked and br.game.GetObjectCount ~= nil) then
		return
	end
	local unit = select(2, tooltip:GetUnit())
	local unitGUID = unit and UnitGUID(unit)
	if not unitGUID then
		return
	end
	-- Only non-player units (or charmed/mind controlled players)
	if unitGUID:match("%a+") == "Player" and not br.game.UnitIsCharmed(unit) then
		return
	end
	local valid, reason = br.functions.misc:isValidUnit(unitGUID)
	if valid then
		tooltip:AddLine("Unit is Valid", 0, 1, 0)
		return
	end
	-- Not in the enemies list: why it fails the list check is the root cause, when it does
	if br.engines.enemiesEngine.units[unitGUID] == nil then
		local listed, listReason = br.functions.misc:enemyListCheck(unitGUID)
		if not listed then
			tooltip:AddLine(listReason, 1, 0, 0)
			return
		end
		tooltip:AddLine(reason or "Not valid", 1, 0, 0)
		tooltip:AddLine("Enemies list: passes (not listed yet)", 1, 0.5, 0)
		return
	end
	tooltip:AddLine(reason or "Not valid", 1, 0, 0)
end

-- Unit tooltips
onTooltip("Unit", "OnTooltipSetUnit", br.game.GameTooltip, unitTooltipHandler)
onTooltip("Unit", "OnTooltipSetUnit", br.game.GameTooltip, function(tooltip) pcall(tooltips.targetValidationDebugHandler, tooltips, tooltip) end)
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

-- Item tooltips
onTooltip("Item", "OnTooltipSetItem", br.game.GameTooltip, attachItemTooltip, true)
onTooltip("Item", "OnTooltipSetItem", br.game.ItemRefTooltip, attachItemTooltip, true)
