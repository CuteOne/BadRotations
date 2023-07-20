local _, br = ...
function br.read.commonReaders()
	---------------
	--[[ Readers ]]
	---------------
	-----------------------
	--[[ Bag Update ]]
	local Frame = br._G.CreateFrame("Frame")
	Frame:RegisterEvent("BAG_UPDATE")
	local function BagUpdate(self, event, ...)
		if event == "BAG_UPDATE" then
			br.bagsUpdated = true
		end
	end
	Frame:SetScript("OnEvent", BagUpdate)
	-----------------------
	--[[ Loss of control ]]
	local frame = br._G.CreateFrame("Frame")
	frame:RegisterEvent("LOSS_OF_CONTROL_UPDATE")
	local function lostControl(self, event, ...)
		-- Print(...)
	end
	frame:SetScript("OnEvent", lostControl)
	----------------
	--[[ Auto Join]]
	Frame = br._G.CreateFrame("Frame")
	Frame:RegisterEvent("LFG_PROPOSAL_SHOW")
	local function MerchantShow(self, event, ...)
		if br.getOptionCheck("Accept Queues") == true then
			if event == "LFG_PROPOSAL_SHOW" then
				br.readyToAccept = br._G.GetTime()
			end
		end
	end
	Frame:SetScript("OnEvent", MerchantShow)
	--------------
	-- --[[ Eclipse]] -- Errors in Patch 8.0 (BfA)
	-- local Frame = CreateFrame('Frame')
	-- Frame:RegisterEvent("ECLIPSE_DIRECTION_CHANGE")
	-- local function Eclipse(self, event, ...)
	-- 	if event == "ECLIPSE_DIRECTION_CHANGE" then
	-- 		if select(1,...) == "sun" then
	-- 			eclipseDirection = 1
	-- 		else
	-- 			eclipseDirection = 0
	-- 		end
	-- 	end
	-- end
	-- Frame:SetScript("OnEvent", Eclipse)
	--------------------------
	--[[ isStanding Frame --]]
	br.DontMoveStartTime = nil
	br._G.CreateFrame("Frame"):SetScript(
		"OnUpdate",
		function()
			if br._G.GetUnitSpeed("Player") == 0 then
				if not br.DontMoveStartTime then
					br.DontMoveStartTime = br._G.GetTime()
				end
				br.isMovingStartTime = 0
			else
				if br.isMovingStartTime == 0 then
					br.isMovingStartTime = br._G.GetTime()
				end
				br.DontMoveStartTime = nil
			end
		end
	)
	----------------------
	--[[ timer Frame --]]
	br._G.CreateFrame("Frame"):SetScript(
		"OnUpdate",
		function()
			if br.uiDropdownTimer ~= nil then
				br.uiTimerStarted = br._G.GetTime()
			end
			if br.uiTimerStarted and br._G.GetTime() - br.uiTimerStarted >= 0.5 then
				br._G.clearChilds(br.uiDropdownTimer)
				br.uiDropdownTimer = false
				br.uiTimerStarted = nil
			end
		end
	)
	-----------------------
	--[[ Merchant Show --]]
	Frame = br._G.CreateFrame("Frame")
	Frame:RegisterEvent("MERCHANT_SHOW")
	local function MerchantShow(self, event, ...)
		if event == "MERCHANT_SHOW" then
			if br.getOptionCheck("Auto-Sell/Repair") then
				br.SellGreys()
			end
		end
	end
	Frame:SetScript("OnEvent", MerchantShow)
	-------------------------
	--[[ Entering Combat --]]
	Frame = br._G.CreateFrame("Frame")
	Frame:RegisterEvent("PLAYER_REGEN_DISABLED")
	local function EnteringCombat(self, event, ...)
		if event == "PLAYER_REGEN_DISABLED" then
			-- here we should manage stats snapshots
			br.AgiSnap = br.getAgility()

			if br.data.settings ~= nil then
				br.data.settings[br.selectedSpec]["Combat Started"] = br._G.GetTime()
			end
			br.ChatOverlay("|cffFF0000Entering Combat")
		end
	end
	Frame:SetScript("OnEvent", EnteringCombat)
	-----------------------
	--[[ Leaving Combat --]]
	Frame = br._G.CreateFrame("Frame")
	Frame:RegisterEvent("PLAYER_REGEN_ENABLED")
	local function LeavingCombat(self, event, ...)
		if event == "PLAYER_REGEN_ENABLED" then
			-- start loot manager
			if br.lM then
				if not br._G.IsMounted("player") then
					br.lM.shouldLoot = true
					br.lM.looted = 0
				end
			end
			br.potionReuse = true
			br.AgiSnap = 0
			br.usePot = true
			br.leftCombat = br._G.GetTime()
			br.data.successCasts = 0
			br.data.failCasts = 0
			if br.data.settings ~= nil then
				br.data.settings[br.selectedSpec]["Combat Started"] = 0
			end
			br.ChatOverlay("|cff00FF00Leaving Combat")
			-- clean up out of combat
			br.Rip_sDamage = {}
			br.Rake_sDamage = {}
			br.Thrash_sDamage = {}
			br.petAttacking = false
			br.lastCastTable.line_cd = {}
			br._G.wipe(br.read.debuffTracker)
		end
	end
	Frame:SetScript("OnEvent", LeavingCombat)
	---------------------------
	--[[ UI Error Messages --]]
	Frame = br._G.CreateFrame("Frame")
	Frame:RegisterEvent("UI_ERROR_MESSAGE")
	local function UiErrorMessages(self, event, errorType, message)
		br.lastError = br._G.GetGameMessageInfo(errorType)
		br.lastErrorTime = br._G.GetTime()
		local param = br.lastError
		--br._G.print("|cffFF0000UI Error: " .. errorType .. " - " .. param)
		if param == "ERR_PET_SPELL_DEAD" then
			br.data.settings[br.selectedSpec]["Pet Dead"] = true
			br.data.settings[br.selectedSpec]["Pet Whistle"] = false
		end
		if param == "PETTAME_NOTDEAD" .. "." then
			br.data.settings[br.selectedSpec]["Pet Dead"] = false
			br.data.settings[br.selectedSpec]["Pet Whistle"] = true
		end
		if param == "SPELL_FAILED_ALREADY_HAVE_PET" then
			br.data.settings[br.selectedSpec]["Pet Dead"] = true
			br.data.settings[br.selectedSpec]["Pet Whistle"] = false
		end
		if param == "PETTAME_CANTCONTROLEXOTIC" .. "." then
			if br.data.settings[br.selectedSpec]["Box PetManager"] < 5 then
				br.data.settings[br.selectedSpec]["Box PetManager"] = br.data.settings[br.selectedSpec]["Box PetManager"] + 1
			else
				br.data.settings[br.selectedSpec]["Box PetManager"] = 1
			end
		end
		if param == "PETTAME_NOPETAVAILABLE" .. "." then
			br.data.settings[br.selectedSpec]["Pet Dead"] = false
			br.data.settings[br.selectedSpec]["Pet Whistle"] = true
		end
		if param == "SPELL_FAILED_TARGET_NO_WEAPONS" then
			br.isDisarmed = true
		end
		if param == "ERR_SPELL_FAILED_S" and br.pickPocketing then --"SPELL_FAILED_TARGET_NO_POCKETS"
			br._G.print("|cffFF0000NO POCKETS")
			br.unpickable = true
			br.pickPocketing = false
		end
		if param == "ERR_ALREADY_PICKPOCKETED" then
			br._G.print("|cffFF0000ALREADY PICKPOCKETED")
			br.unpickable = true
			br.pickPocketing = false
		end
		if errorType == "ERR_NO_LOOT" and br.pickPocketing then
			br._G.print("|cffFF0000NO LOOT")
			br.unpickable = true
			br.pickPocketing = false
		end
	end
	Frame:SetScript("OnEvent", UiErrorMessages)
	------------------------
	--[[ Spells Changed --]]
	Frame = br._G.CreateFrame("Frame")
	Frame:RegisterEvent("LEARNED_SPELL_IN_TAB")
	local function SpellsChanged(self, event, ...)
		if not br.configReloadTimer or br.configReloadTimer <= br._G.GetTime() - 1 then
			br.currentConfig, br.configReloadTimer = nil, br._G.GetTime()
		end
	end
	Frame:SetScript("OnEvent", SpellsChanged)
	--- under devlopment not working as of now
	--[[ Addon reader ]]
	-- local Frame = CreateFrame('Frame')
	-- Frame:RegisterEvent("CHAT")
	--    "GROUP_ROSTER_UPDATE",
	--    "INSTANCE_GROUP_SIZE_CHANGED",
	--     "CHAT_MSG_ADDON",
	--     "BN_CHAT_MSG_ADDON",
	--     "PLAYER_REGEN_DISABLED",
	--     "PLAYER_REGEN_ENABLED",
	--     "INSTANCE_ENCOUNTER_ENGAGE_UNIT",
	--     "UNIT_TARGETABLE_CHANGED",
	--     "UNIT_SPELLCAST_SUCCEEDED",
	--     "ENCOUNTER_START",
	--     "ENCOUNTER_END",
	--     --"SPELL_UPDATE_CHARGES",
	--     "UNIT_DIED",
	--     "UNIT_DESTROYED",
	--     "UNIT_HEALTH mouseover target focus player",
	--     "CHAT_MSG_WHISPER",
	--     "CHAT_MSG_BN_WHISPER",
	--     "CHAT_MSG_MONSTER_YELL",
	--     "CHAT_MSG_MONSTER_EMOTE",
	--     "CHAT_MSG_MONSTER_SAY",
	--     "CHAT_MSG_RAID_BOSS_EMOTE",
	--     "RAID_BOSS_EMOTE",
	--     "PLAYER_ENTERING_WORLD",
	--     "LFG_ROLE_CHECK_SHOW",
	--     "LFG_PROPOSAL_SHOW",
	--     "LFG_PROPOSAL_FAILED",
	--     "LFG_PROPOSAL_SUCCEEDED",
	--     "UPDATE_BATTLEFIELD_STATUS",
	--     "CINEMATIC_START",
	--     "LFG_COMPLETION_REWARD",
	--     --"WORLD_STATE_TIMER_START",
	--     --"WORLD_STATE_TIMER_STOP",
	--     "CHALLENGE_MODE_START",
	--     "CHALLENGE_MODE_RESET",
	--     "CHALLENGE_MODE_END",
	--     "ACTIVE_TALENT_GROUP_CHANGED",
	--     "UPDATE_SHAPESHIFT_FORM",
	--     "PARTY_INVITE_REQUEST",
	--     "LOADING_SCREEN_DISABLED"
	-- )
	-- local function addonReader(...)
	-- 	function br._G.DBM:AddMsg(text, prefix)
	-- 		prefix = prefix or (self.localization and self.localization.general.name) or "Deadly Boss Mods"
	-- 		local frame = br._G[tostring(_G.DBM.Options.ChatFrame)]
	-- 		br._G.print("!!")
	-- 		frame = frame and frame:IsShown() and frame or br._G["DEFAULT_CHAT_FRAME"]
	-- 		frame:AddMessage(("|cffff7d0a<|r|cffffd200%s|r|cffff7d0a>|r %s"):format(tostring(prefix), tostring(text)), 0.41, 0.8, 0.94)
	-- 	end
	-- 	br._G.print(...)
	-- end
	--Frame:SetScript("OnEvent", addonReader)
	TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Unit,
		function(self)
			if br.unlocked --[[EWT]] and br._G.GetObjectCount() ~= nil then
				local _, lunit = self:GetUnit()
				if not br._G.UnitIsVisible(lunit) then
					return
				end
				local unit = br._G.UnitGUID(lunit)
				local burnUnit = br.getOptionCheck("Forced Burn") and br.isBurnTarget(unit) > 0
				local playerTarget = br.GetUnitIsUnit(unit, "target")
				local targeting = br.isTargeting(unit)
				local hasThreat = br.hasThreat(unit) or targeting or br.isInProvingGround() or burnUnit
				local reaction = br.GetUnitReaction(unit, "player") or 10
				if br.isChecked("Target Validation Debug") and (not br._G.UnitIsPlayer(unit) or br._G.UnitIsCharmed(unit) or br.UnitDebuffID("player", 320102)) then
					if br.isValidUnit(unit) then
						self:AddLine("Unit is Valid", 0, 1, 0)
					elseif not br.getLineOfSight("player", unit) then
						self:AddLine("LoS Fail", 1, 0, 0)
					elseif not (br.units[unit] ~= nil or br.GetUnitIsUnit(unit, "target") or br.lists.threatBypass[br.GetObjectID(unit)] ~= nil or burnUnit) then
						self:AddLine("Not in Units Table", 1, 0, 0)
					elseif not (not br._G.UnitIsTapDenied(unit) or br.isDummy) then
						self:AddLine("Unit is Tap Denied", 1, 0, 0)
					elseif not (br.isSafeToAttack(unit) or burnUnit) then
						self:AddLine("Safe Attack Fail", 1, 0, 0)
					elseif not ((reaction < 5 and not br.isChecked("Hostiles Only")) or (br.isChecked("Hostiles Only") and (reaction < 4 or playerTarget or targeting)) or br.isDummy or burnUnit) then
						self:AddLine("Reaction Value Fail", 1, 0, 0)
					elseif
						not ((br.isChecked("Attack MC Targets") and (not br.GetUnitIsFriend(unit, "player") or (br._G.UnitIsCharmed(unit) and br._G.UnitCanAttack("player", unit)))) or
							not br.GetUnitIsFriend(unit, "player"))
					 then
						self:AddLine("MC Check Fail", 1, 0, 0)
					elseif br.getOptionCheck("Don't break CCs") and br.isLongTimeCCed(unit) then
						self:AddLine("CC Check Fail", 1, 0, 0)
					elseif not hasThreat then
						self:AddLine("Threat Fail", 1, 0, 0)
					elseif not br.enemyListCheck(unit) then
						self:AddLine("List Check Fail", 1, 0, 0)
					else
						self:AddLine("Validation Failed", 0, 0, 1)
					end
				end
			end
		end
	)
	---------------------------
	--[[ Combat Log Reader --]]
	local superReaderFrame = br._G.CreateFrame("Frame")
	superReaderFrame:RegisterEvent("CHAT_MSG_ADDON")
	superReaderFrame:RegisterEvent("PLAYER_STARTED_MOVING")
	superReaderFrame:RegisterEvent("PLAYER_STOPPED_MOVING")
	superReaderFrame:RegisterEvent("PLAYER_TOTEM_UPDATE")
	superReaderFrame:RegisterEvent("UNIT_SPELLCAST_START")
	superReaderFrame:RegisterEvent("UNIT_SPELLCAST_SENT")
	superReaderFrame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	superReaderFrame:RegisterEvent("UNIT_SPELLCAST_FAILED")
	superReaderFrame:RegisterEvent("UNIT_SPELLCAST_STOP")
	superReaderFrame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")
	superReaderFrame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
	superReaderFrame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_UPDATE")
	superReaderFrame:RegisterEvent("UNIT_SPELLCAST_EMPOWER_START")
	superReaderFrame:RegisterEvent("UNIT_SPELLCAST_EMPOWER_STOP")
	superReaderFrame:RegisterEvent("UNIT_SPELLCAST_EMPOWER_UPDATE")
	superReaderFrame:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED")
	superReaderFrame:RegisterEvent("UNIT_POWER_UPDATE")
	superReaderFrame:RegisterEvent("ENCOUNTER_START")
	superReaderFrame:RegisterEvent("ENCOUNTER_END")
	superReaderFrame:RegisterUnitEvent("AZERITE_EMPOWERED_ITEM_SELECTION_UPDATED")
	superReaderFrame:RegisterUnitEvent("AZERITE_ESSENCE_ACTIVATED")
	superReaderFrame:RegisterUnitEvent("PLAYER_EQUIPMENT_CHANGED")
	superReaderFrame:RegisterUnitEvent("PLAYER_LEVEL_UP")
	superReaderFrame:RegisterUnitEvent("PLAYER_TALENT_UPDATE")
	superReaderFrame:RegisterUnitEvent("TRAIT_CONFIG_UPDATED")
	superReaderFrame:RegisterUnitEvent("UI_ERROR_MESSAGE")
	superReaderFrame:RegisterEvent("LOADING_SCREEN_ENABLED")
	superReaderFrame:RegisterEvent("LOADING_SCREEN_DISABLED")
	local function SuperReader(self, event, ...)
		-- Azerite Essence
		if event == "AZERITE_ESSENCE_ACTIVATED" then
			br.updatePlayerInfo = true
		end
		if event == "PLAYER_EQUIPMENT_CHANGED" then
			br.equipHasChanged = true
		end
		-- Player moving
		if event == "PLAYER_STARTED_MOVING" then
			if br.player ~= nil then
				br.player.moving = true
			end
			return
		end
		if event == "PLAYER_STOPPED_MOVING" then
			if br.player ~= nil then
				br.player.moving = false
			end
			return
		end
		-- Update Player Info
		-- if event == "PLAYER_TALENT_UPDATE" and select(2, GetSpecializationInfo(GetSpecialization())) == br.selectedSpec then
		-- 	br.rotationChanged = true
		-- end
		if event == "PLAYER_TALENT_UPDATE" or event == "PLAYER_LEVEL_UP" or event == "PLAYER_EQUIPMENT_CHANGED" or event == "AZERITE_EMPOWERED_ITEM_SELECTION_UPDATED" or event == "TRAIT_CONFIG_UPDATED" then
			br.updatePlayerInfo = true
		end
		-------------------------------------------------
		--[[ SpellCast Sents (used to define target) --]]
		if event == "UNIT_SPELLCAST_SENT" then
			local SourceUnit = select(1, ...)
			local SpellName = select(2, ...)
			br.spellCastTarget = select(4, ...)
			--Print("UNIT_SPELLCAST_SENT spellCastTarget = "..spellCastTarget)
			-- local MyClass = select(2, br._G.UnitClass("player"))
			if SourceUnit == "player" then
				-- Blizz br._G.CastSpellByName bug bypass
				if SpellName == "Metamorphosis" then
					br._G.CastSpellByID(191427, "player")
				end
			end
		end

		if event == "UNIT_SPELLCAST_INTERRUPTED" then
			local SourceUnit = select(1, ...)
			-- local SpellID = select(5, ...)
			if SourceUnit == "player" then
				local MyClass = select(2, br._G.UnitClass("player"))
				if MyClass == "MAGE" then -- Mage
				end
			-- if MyClass == "MONK" then -- Monk
			-- 	local br = br._G["br"]
			-- 	local spec = br._G["GetSpecialization"]
			-- 	if br.player ~= nil and spec() == 3 and br.player.spell.fistsOfFury ~= nil then
			-- 		local cd 	= br.player.cd
			-- 		local spell = br.player.spell
			-- 		local unit 	= br.player.unit
			-- 		local var 	= br.player.variables
			-- 		local comboSpells = {
			-- 			[spell.blackoutKick]              = true,
			-- 			[spell.chiBurst]                  = true,
			-- 			[spell.chiWave]                   = true,
			-- 			[spell.cracklingJadeLightning]    = true,
			-- 			[spell.fistsOfFury]               = true,
			-- 			[spell.fistOfTheWhiteTiger]       = true,
			-- 			[spell.flyingSerpentKick]         = true,
			-- 			[spell.risingSunKick]             = true,
			-- 			[spell.rushingJadeWind]           = true,
			-- 			[spell.spinningCraneKick]         = true,
			-- 			[spell.tigerPalm]                 = true,
			-- 			[spell.touchOfDeath]              = true,
			-- 			[spell.whirlingDragonPunch]       = true,
			-- 		}
			-- 		if var.prevCombo == nil or not unit.inCombat() then var.prevCombo = 6603 end
			-- 		if var.lastCombo == nil or not unit.inCombat() then var.lastCombo = 6603 end
			-- 		if comboSpells[spell] and not (cd[spell].remain() > unit.gcd("true")) and unit.inCombat() then
			-- 			var.lastCombo = var.prevCombo
			-- 			var.prevCombo = 6603
			-- 		end
			-- 	end
			-- end
			end
		end
		-----------------------------
		--[[ SpellCast Succeeded --]]
		if event == "UNIT_SPELLCAST_START" then
			local SourceUnit = select(1, ...)
			local SpellID = select(5, ...)
			br.spellCastTarget = select(4, ...)
			if SourceUnit == "player" then
				local MyClass = br._G.UnitClass("player")
				-- Hunter
				if MyClass == 3 then
					-- Serpent Sting
					if SpellID == 1978 then
						br.LastSerpent = br._G.GetTime()
						br.LastSerpentTarget = br.spellCastTarget
					end
					-- Steady Shot Logic
					if SpellID == 56641 then
						if br.SteadyCast and br.SteadyCast >= br._G.GetTime() - 2 and br.SteadyCount == 1 then
							br.SteadyCast = br._G.GetTime()
							br.SteadyCount = 2
						else
							br.SteadyCast = br._G.GetTime()
							br.SteadyCount = 1
						end
					end
					-- Focus Generation
					if SpellID == 77767 then
						br.focusBuilt = br._G.GetTime()
					end
				end
				if MyClass == "Mage" then -- Mage
				end
			end
		end
		if event == "UNIT_SPELLCAST_STOP" then
			local SourceUnit = select(1, ...)
			-- local SpellID = select(5, ...)
			if SourceUnit == "player" then
				local MyClass = br._G.UnitClass("player")
				if MyClass == "Mage" then -- Mage
				end
			end
		end

		-----------------------------
		--[[ SpellCast Succeeded --]]
		if event == "UNIT_SPELLCAST_SUCCEEDED" then
			local SourceUnit = select(1, ...)
			br.spellCastTarget = select(4, ...)
			local SpellID = select(5, ...)
			if br.botCast == true then
				br.botCast = false
			end
			if SourceUnit ~= nil then
				if br.GetUnitIsUnit(SourceUnit, "player") then
				end
			end
			if SourceUnit == "player" then
				br.lastSucceeded = spell -- Used for lastCast tracking
				-- Queue Casting
				if br.player ~= nil then
					if #br.player.queue ~= 0 then
						for i = 1, #br.player.queue do
							if br._G.GetSpellInfo(spell) == br._G.GetSpellInfo(br.player.queue[i].id) then
								br._G.tremove(br.player.queue, i)
								if br._G.IsAoEPending() then
									br._G.SpellStopTargeting()
								end
								if not br.isChecked("Mute Queue") then
									br._G.print("Cast Success! - Removed |cFFFF0000" .. br._G.GetSpellInfo(spell) .. "|r from the queue.")
								end
								break
							end
						end
					end
				end
				---
				local MyClass = br._G.UnitClass("player")
				-- Hunter
				if MyClass == 3 then
					-- Serpent Sting
					if SpellID == 1978 then
						br.LastSerpent = br._G.GetTime()
						br.LastSerpentTarget = br.spellCastTarget
					end
					-- Steady Shot Logic
					if SpellID == 56641 then
						if br.SteadyCast and br.SteadyCast >= br._G.GetTime() - 2 and br.SteadyCount == 1 then
							br.SteadyCast = br._G.GetTime()
							br.SteadyCount = 2
						else
							br.SteadyCast = br._G.GetTime()
							br.SteadyCount = 1
						end
					end
					-- Focus Generation
					if SpellID == 77767 then
						br.focusBuilt = br._G.GetTime()
					end
				end
				if MyClass == "Mage" then -- Mage
				end
			end
		end
		--------------------------
		--[[ SpellCast Failed --]]
		if event == "UNIT_SPELLCAST_FAILED" then
			local SourceUnit = select(1, ...)
			local SpellID = select(5, ...)
			local MyClass = br._G.UnitClass("player")
			if SourceUnit == "player" and br.isKnown(SpellID) then
				-- Kill Command
				if SpellID == 34026 then
				---Print("Kill Command FAILED")
				end
				-- Whistle failed
				if SpellID == 883 or SpellID == 83242 or SpellID == 83243 or SpellID == 83244 or SpellID == 83245 then
					br.lastFailedWhistle = br._G.GetTime()
				end
			end
			if SourceUnit == "player" then
				if MyClass == "Mage" then -- Mage
				end
			end
		end
		-----------------------------
		--[[ Spell Failed Immune --]]
		if event == "SPELL_FAILED_IMMUNE" then
			local SourceUnit = select(1, ...)
			local SpellID = select(5, ...)
			br.isDisarmed = false
			if SourceUnit == "player" and br.isKnown(SpellID) then
				-- Disarm - Warrior
				if SpellID == 676 then
					br.isDisarmed = true
				end
				-- Clench - Hunter (Scorpid Pet)
				if SpellID == 50541 then
					br.isDisarmed = true
				end
				-- Dismantle - Rogue
				if SpellID == 51722 then
					br.isDisarmed = true
				end
				-- Psychic Horror - Priest
				if SpellID == 64058 then
					br.isDisarmed = true
				end
				-- Snatch - Hunter (Bird of Prey Pet)
				if SpellID == 91644 then
					br.isDisarmed = true
				end
				-- Grapple Weapon - Monk
				if SpellID == 117368 then
					br.isDisarmed = true
				end
				-- Disarm - Warlock (Voidreaver/Voidlord Pet)
				if SpellID == 118093 then
					br.isDisarmed = true
				end
				-- Ring of Peace - Monk
				if SpellID == 137461 or SpellID == 140023 then
					br.isDisarmed = true
				end
			end
		end
		if event == "UNIT_SPELLCAST_CHANNEL_START" then
			local SourceUnit = select(1, ...)
			local SpellID = select(3, ...)
			if SourceUnit == "player" then
				--Print("Channel Start")
				br.lastStarted = SpellID
			end
		end
		if event == "UNIT_SPELLCAST_CHANNEL_STOP" then
			local SourceUnit = select(1, ...)
			local SpellID = select(3, ...)
			if SourceUnit == "player" then
				--Print("Channel STOP")
				br.lastFinished = SpellID
			end
		end
		if event == "UNIT_SPELLCAST_CHANNEL_UPDATE" then
			local SourceUnit = select(1, ...)
			-- local SpellID = select(3, ...)
			if SourceUnit == "player" then
			--Print("Channel Update")
			end
		end
		if event == "UNIT_SPELLCAST_EMPOWER_START" then
			local SourceUnit = select(1, ...)
			local SpellID = select(3, ...)
			if SourceUnit == "player" then
				--Print("Channel Start")
				br.empowerID = SpellID
			end
		end
		if event == "UNIT_SPELLCAST_EMPOWER_STOP" then
			local SourceUnit = select(1, ...)
			local SpellID = select(3, ...)
			if SourceUnit == "player" then
				--Print("Channel STOP")
				br.empowerID = 0
			end
		end
		if event == "UNIT_SPELLCAST_EMPOWER_UPDATE" then
			local SourceUnit = select(1, ...)
			-- local SpellID = select(3, ...)
			if SourceUnit == "player" then
			--Print("Channel Update")
			end
		end
		if event == "UI_ERROR_MESSAGE" then
			local errorMsg = select(1, ...)
			local messageErr = select(2, ...)
			-- Print("Error "..errorMsg..": "..messageErr)
			-- 51 = "Your Pet is Dead"
			-- 203 = "Cannot attack while dead"
			-- 278 = "Your Pet is not Dead" / "Your pet is dead. Use Revive Pet"
			if errorMsg == 278 then
				local revive = br._G.GetSpellInfo(50769) -- Used for string matching error messasge.
				local match = string.find(messageErr, revive) ~= nil
				if match then
					br.deadPet = true
				else
					br.deadPet = false
				end
			end
			if not br.GetUnitIsDeadOrGhost("player") and (br.GetUnitIsDeadOrGhost("pet") or not br.GetUnitExists("pet")) and (errorMsg == 51 or errorMsg == 203) then --or errorMsg == 277 or errorMsg == 275 then
				br.deadPet = true
			-- if deadPet == false then
			-- elseif deadPet == true and br._G.UnitHealth("pet") > 0 then
			-- 	deadPet = false
			-- end
			end
		end
		if event == "ENCOUNTER_START" then
			if br.player ~= nil then
				br.player.eID = select(1, ...)
			end
		end
		if event == "ENCOUNTER_END" then
			if br.player ~= nil then
				br.player.eID = 0
			end
		end
		if event == "LOADING_SCREEN_ENABLED" and br.disableControl == false then
			br.disableControl = true
		end
		if event == "LOADING_SCREEN_DISABLED" and br.disableControl == true then
			br.disableControl = false
		end
	end
	superReaderFrame:SetScript("OnEvent", SuperReader)
end
