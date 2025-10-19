local _, br = ...
br.ui.tooltips = br.ui.tooltips or {}
local tooltips = br.ui.tooltips

------------------------------------------------------------------------------------------------------------------------
-- idTip by Silverwind
local hooksecurefunc, select, UnitBuff, UnitDebuff, UnitAura, UnitGUID, _, tonumber, strfind =
	br._G.hooksecurefunc,
	br._G.select,
	br._G.UnitBuff,
	br._G.UnitDebuff,
	br._G.UnitAura,
	br._G.UnitGUID,
	br._G.GetGlyphSocketInfo,
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
		local text
		if frame then
			text = frame:GetText()
		end
		if text and text == type then
			found = true
			break
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
hooksecurefunc(ItemRefTooltip, "SetHyperlink", onSetHyperlink)
hooksecurefunc(GameTooltip, "SetHyperlink", onSetHyperlink)
-- Spells
hooksecurefunc(
	br._G.GameTooltip,
	"SetUnitBuff",
	function(self, ...)
		local id = select(10, br._G.UnitBuff(...))
		if id then
			addLine(self, id, types.spell)
		end
	end
)
hooksecurefunc(
	br._G.GameTooltip,
	"SetUnitDebuff",
	function(self, ...)
		local id = select(10, br._G.UnitDebuff(...))
		if id then
			addLine(self, id, types.spell)
		end
	end
)
hooksecurefunc(
	br._G.GameTooltip,
	"SetUnitAura",
	function(self, ...)
		local unitAura = C_UnitAuras.GetAuraDataByIndex(...) --UnitAura(...)
		local id = unitAura and unitAura.spellId or nil
		if id then
			addLine(self, id, types.spell)
		end
	end
)
hooksecurefunc(
	"SetItemRef",
	function(link, ...)
		local id = tonumber(link:match("spell:(%d+)"))
		if id then
			addLine(br._G.ItemRefTooltip, id, types.spell)
		end
	end
)
-- Spell tooltips (MoP Classic compatible)
br._G.GameTooltip:HookScript("OnTooltipSetSpell", function(self)
	local _, id = self:GetSpell()
	if id then
		addLine(self, id, types.spell)
	end
end)
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

-- Target Validation Debug Tooltip Handler
function tooltips:targetValidationDebugHandler(tooltip)
	-- Check if Target Validation Debug is enabled first
	if not br.functions.misc:isChecked("Target Validation Debug") then
		return
	end

	-- Skip during pet battles
	if br._G.C_PetBattles and br._G.C_PetBattles.IsInBattle and br._G.C_PetBattles.IsInBattle() then
		return
	end

	-- Get the unit from tooltip
	local unit = select(2, tooltip:GetUnit())
	if not unit then
		return
	end

	-- Get GUID using standard WoW API
	if not br._G.UnitGUID then
		return
	end

	local unitGUID = br._G.UnitGUID(unit)
	if not unitGUID then
		return
	end

	-- Only show debug for non-player units (or charmed/mind controlled players)
	local guidType = unitGUID:match("%a+")
	if guidType == "Player" and not br._G.UnitIsCharmed(unit) then
		return
	end

	-- Check if we have unlocker for advanced validation checks
	if not (br.unlocked and br._G.GetObjectCount ~= nil) then
		return
	end

	-- Gather all validation data
	local distance = br.functions.range:getDistance(unit, "player")
	local dummy = br.functions.unit:isDummy(unit)
	local burnUnit = br.functions.misc:getOptionCheck("Forced Burn") and br.engines.enemiesEngineFunctions:isBurnTarget(unitGUID) > 0
	local playerTarget = br.functions.unit:GetUnitIsUnit(unit, "target")
	local targeting = br.functions.misc:isTargeting(unitGUID)
	local hasThreat = br.functions.combat:hasThreat(unitGUID)
	local reaction = br.functions.unit:GetUnitReaction(unit, "player") or 10
	local isCC = br.functions.misc:getOptionCheck("Don't break CCs") and br.functions.misc:isLongTimeCCed(unitGUID)
	local isTapped = br._G.UnitIsTapDenied(unit)
	local hasDamagedTapped = isTapped and br.engines.enemiesEngine.damaged[br._G.ObjectPointer(unit)] ~= nil
	local inUnitsTable = br.engines.enemiesEngine.units[unitGUID] ~= nil
	local isFriend = br.functions.unit:GetUnitIsFriend(unit, "player")
	local isCharmed = br._G.UnitIsCharmed(unit)
	local canAttack = br._G.UnitCanAttack("player", unit)
	local isSafe = br.engines.enemiesEngineFunctions:isSafeToAttack(unitGUID)
	local hostileOnly = br.functions.misc:isChecked("Hostiles Only")
	local attackMC = br.functions.misc:isChecked("Attack MC Targets")
	local inPhase = br._G.UnitInPhase(unit)
	local los = br.functions.misc:getLineOfSight("player", unit)
	local health = br._G.UnitHealth(unit)
	local isDead = br.functions.unit:GetUnitIsDeadOrGhost(unit)
	local isCritter = br.functions.unit:isCritter(unit)
	local isPet = br.functions.unit:GetUnitIsUnit(unit, "pet")

	-- Check all conditions and only show failures
	if isDead then
		tooltip:AddLine("Dead or Ghost", 1, 0, 0)
		return
	end

	-- Phase Sync Check (debuff 310499 - Shadowlands phasing, not used in Classic)
	local targetHasPhaseDebuff = br.functions.aura:UnitDebuffID(unit, 310499)
	local playerHasPhaseDebuff = br.functions.aura:UnitDebuffID("player", 310499)
	if (targetHasPhaseDebuff and not playerHasPhaseDebuff) or (not targetHasPhaseDebuff and playerHasPhaseDebuff) then
		tooltip:AddLine("Phase Sync Failed", 1, 0, 0)
		return
	end

	if not inPhase then
		tooltip:AddLine("Not in Phase", 1, 0, 0)
		return
	end

	if not canAttack then
		tooltip:AddLine("Cannot Attack", 1, 0, 0)
		return
	end

	if health <= 0 then
		tooltip:AddLine("No Health", 1, 0, 0)
		return
	end

	if distance >= 50 then
		tooltip:AddLine("Too Far (" .. string.format("%.1f", distance) .. "yd)", 1, 0, 0)
		return
	end

	if isCritter then
		tooltip:AddLine("Is Critter", 1, 0, 0)
		return
	end

	if isPet then
		tooltip:AddLine("Is Your Pet", 1, 0, 0)
		return
	end

	-- Check if created by player (but allow hostile quest NPCs)
	local createdByPlayer = br._G.UnitCreator(unit) == br._G.ObjectPointer("player")
	local unitReaction = br._G.UnitReaction(unit, "player") or 5
	local isHostileQuestNPC = createdByPlayer and unitReaction < 4
	if createdByPlayer and not isHostileQuestNPC then
		tooltip:AddLine("Created/Summoned by You", 1, 0, 0)
		return
	end

	-- Check if water elemental
	local objectID = br.functions.unit:GetObjectID(unit)
	if objectID == 11492 then
		tooltip:AddLine("Is Water Elemental (11492)", 1, 0, 0)
		return
	end

	-- MC Check
	local mcCheck = (attackMC and (not isFriend or (isCharmed and canAttack))) or not isFriend
	if not mcCheck then
		if isFriend and not isCharmed then
			tooltip:AddLine("Is Friendly (not charmed)", 1, 0, 0)
		elseif isFriend and not attackMC then
			tooltip:AddLine("Is Charmed (MC targeting disabled)", 1, 0, 0)
		end
		return
	end

	if not los then
		tooltip:AddLine("No Line of Sight", 1, 0, 0)
		return
	end

	-- Units table or special cases (now includes threat check)
	if not (inUnitsTable or playerTarget or burnUnit or dummy or hasThreat) then
		tooltip:AddLine("Not in Units Table", 1, 0, 0)
		tooltip:AddLine("  (Not your target/burn/dummy/threat)", 1, 0.5, 0)
		return
	end

	-- CC Check
	if isCC then
		tooltip:AddLine("Is CC'd (Don't break CCs enabled)", 1, 0, 0)
		return
	end

	-- Tap Check
	if isTapped and not (dummy or burnUnit or hasDamagedTapped) then
		tooltip:AddLine("Tap Denied (Haven't damaged it)", 1, 0, 0)
		return
	end

	-- Safe to Attack Check
	if not (dummy or burnUnit or isSafe) then
		tooltip:AddLine("Not Safe to Attack", 1, 0, 0)
		tooltip:AddLine("  (CC candidate/No-touch unit)", 1, 0.5, 0)
		return
	end

	-- Reaction Check
	local reactionPass = (hostileOnly and reaction < 4) or (not hostileOnly and reaction < 5) or playerTarget or targeting
	if not reactionPass and not (dummy or burnUnit) then
		if hostileOnly then
			tooltip:AddLine("Reaction " .. reaction .. " (need <4 for Hostiles Only)", 1, 0, 0)
		else
			tooltip:AddLine("Reaction " .. reaction .. " (need <5)", 1, 0, 0)
		end
		return
	end

	-- Final validation check
	local inInstance = br._G.IsInInstance()
	local friendCount = #br.engines.healingEngine.friend
	local hasTankResult = br.functions.misc:hasTank()
	local instanceCheckForPlayerTarget = (not inInstance) or (inInstance and (friendCount == 1 or not hasTankResult))
	local provingGround = br.functions.misc:isInProvingGround()

	if br.functions.misc:isValidUnit(unitGUID) then
		tooltip:AddLine("Unit is Valid", 0, 1, 0)
	else
		-- Show why threat check failed
		if playerTarget and not instanceCheckForPlayerTarget then
			tooltip:AddLine("Not solo/no tank in instance", 1, 0, 0)
		elseif not playerTarget and not targeting and not burnUnit and not provingGround and not hasThreat then
			tooltip:AddLine("No threat conditions met", 1, 0, 0)
		else
			tooltip:AddLine("Failed validation", 1, 0, 0)
		end
	end
end

-- Register tooltip hook (MoP Classic / Classic Era compatible)
-- Note: TooltipDataProcessor may exist from other addons but doesn't work properly in Classic
-- Force use of HookScript method for MoP Classic
br._G.GameTooltip:HookScript("OnTooltipSetUnit", unitTooltipHandler)
br._G.GameTooltip:HookScript("OnTooltipSetUnit", function(tooltip) tooltips:targetValidationDebugHandler(tooltip) end)
-- Items
local function attachItemTooltip(self)
	if (self == GameTooltip or self == ItemRefTooltip) then
		local link = select(2, self:GetItem())
		if link then
			local id = select(3, strfind(link, "^|%x+|Hitem:(%-?%d+):(%d+):(%d+).*"))
			if id then
				addLine(self, id, types.item)
			end
		end
	end
end

-- Register item tooltip hooks (MoP Classic compatible)
br._G.GameTooltip:HookScript("OnTooltipSetItem", attachItemTooltip)
br._G.ItemRefTooltip:HookScript("OnTooltipSetItem", attachItemTooltip)
-- Glyphs -- Commented out due to Legion
-- hooksecurefunc(GameTooltip, "SetGlyph", function(self, ...)
-- 	local id = select(4, GetGlyphSocketInfo(...))
-- 	if id then addLine(self, id, types.glyph) end
-- end)
-- hooksecurefunc(GameTooltip, "SetGlyphByID", function(self, id)
-- 	if id then addLine(self, id, types.glyph) end
-- end)
-- Achievement Frame Tooltips
-- local f = br._G.CreateFrame("frame")
-- f:RegisterEvent("ADDON_LOADED")
-- f:SetScript(
-- 	"OnEvent",
-- 	function(_, _, what)
-- 		if what == "Blizzard_AchievementUI" then
-- 			for _, button in ipairs(br._G.AchievementFrameAchievements.ScrollBox.ScrollTarget:GetChildren()) do
-- 				button:HookScript(
-- 					"OnEnter",
-- 					function()
-- 						br._G.GameTooltip:SetOwner(button, "ANCHOR_NONE")
-- 						br._G.GameTooltip:SetPoint("TOPLEFT", button, "TOPRIGHT", 0, 0)
-- 						addLine(br._G.GameTooltip, button.id, types.achievement, true)
-- 						br._G.GameTooltip:Show()
-- 					end
-- 				)
-- 				button:HookScript(
-- 					"OnLeave",
-- 					function()
-- 						br._G.GameTooltip:Hide()
-- 					end
-- 				)
-- 			end
-- 		end
-- 	end
-- )
-- local petAbilityTooltipID = false
-- local orig_SharedPetBattleAbilityTooltip_SetAbility = br._G.SharedPetBattleAbilityTooltip_SetAbility
-- function br.SharedPetBattleAbilityTooltip_SetAbility(self, abilityInfo, additionalText)
-- 	orig_SharedPetBattleAbilityTooltip_SetAbility(self, abilityInfo, additionalText)
-- 	petAbilityTooltipID = abilityInfo:GetAbilityID()
-- end
-- br._G.PetBattlePrimaryAbilityTooltip:HookScript(
-- 	"OnShow",
-- 	function(self)
-- 		local name = self.Name:GetText()
-- 		self.Name:SetText(name .. " (ID: " .. petAbilityTooltipID .. ")")
-- 	end
-- )