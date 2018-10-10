local rotationName = "Fengshen" -- Change to name of profile listed in options drop down

---------------
--- Toggles ---
---------------
local function createToggles() -- Define custom toggles
	-- Cooldown Button
	CooldownModes = {
	[1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.holyAvenger},
	[2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.auraMastery},
	[3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.absolution}
	};
	CreateButton("Cooldown",1,0)
	-- Defensive Button
	DefensiveModes = {
	[1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.divineProtection},
	[2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.blessingOfProtection}
	};
	CreateButton("Defensive",2,0)
	-- Interrupt Button
	InterruptModes = {
	[1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.hammerOfJustice},
	[2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.hammerOfJustice}
	};
	CreateButton("Interrupt",3,0)
	-- Cleanse Button
	CleanseModes = {
	[1] = { mode = "On", value = 1 , overlay = "Cleanse Enabled", tip = "Cleanse Enabled", highlight = 1, icon = br.player.spell.cleanse },
	[2] = { mode = "Off", value = 2 , overlay = "Cleanse Disabled", tip = "Cleanse Disabled", highlight = 0, icon = br.player.spell.cleanse }
	};
	CreateButton("Cleanse",4,0)
	-- DPS
	DPSModes = {
	[1] = { mode = "On", value = 1 , overlay = "DPS Enabled", tip = "DPS Enabled", highlight = 1, icon = br.player.spell.judgment },
	[2] = { mode = "Off", value = 2 , overlay = "DPS Disabled", tip = "DPS Disabled", highlight = 0, icon = br.player.spell.judgment }
	};
	CreateButton("DPS",5,0)
end

---------------
--- OPTIONS ---
---------------
local function createOptions()
	local optionTable

	local function rotationOptions()
		-----------------------
		--- GENERAL OPTIONS --- -- Define General Options
		-----------------------
		section = br.ui:createSection(br.ui.window.profile,  "General")
		br.ui:createCheckbox(section,"OOC Healing","|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFout of combat healing|cffFFBB00.",1)
		-- Necrotic Rot
		br.ui:createSpinner (section, "Necrotic Rot", 40, 0, 100, 1, "","|cffFFFFFFNecrotic Rot Stacks does not healing the unit", true)
		-- Mastery bonus
		br.ui:createCheckbox(section,"Mastery bonus","|cff15FF00Give priority to the nearest player...(Only in Raid effective)")
		-- Blessing of Freedom
		br.ui:createCheckbox(section, "Blessing of Freedom")
		-- Pre-Pull Timer
		br.ui:createSpinner(section, "Pre-Pull Timer",  5,  0,  20,  1,  "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
		-- Auto Beacon
		br.ui:createCheckbox(section, "Auto Beacon")
		-- Redemption
		br.ui:createDropdown(section, "Redemption", {"|cffFFFFFFTarget","|cffFFFFFFMouseover"}, 1, "","|cffFFFFFFSelect Redemption Mode.")
		-- Critical
		br.ui:createSpinner (section, "Critical HP", 30, 0, 100, 5, "","|cffFFFFFFHealth Percent to Critical Heals")
		-- Overhealing Cancel
		br.ui:createSpinner (section, "Overhealing Cancel", 95, 0, 100, 5, "","|cffFFFFFFSet Desired Threshold at which you want to prevent your own casts")
		br.ui:checkSectionState(section)
		-------------------------
		------ DEFENSIVES -------
		-------------------------
		section = br.ui:createSection(br.ui.window.profile, "Defensive")
		-- Pot/Stone
		br.ui:createSpinner (section, "Pot/Stoned", 30, 0, 100, 5, "","|cffFFFFFFHealth Percent to Cast At")
		br.ui:createSpinner (section, "Divine Protection", 60, 0, 100, 5, "","|cffFFFFFFHealth Percent to Cast At")
		br.ui:createSpinner (section, "Divine Shield", 20, 0, 100, 5, "","|cffFFFFFFHealth Percent to Cast At")
		-- Gift of The Naaru
		if br.player.race == "Draenei" then
			br.ui:createSpinner(section, "Gift of The Naaru",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
		end
		-- Divine Shield + Aura of Sacrifice
		br.ui:createDropdown(section,"Divine Shield + Aura of Sacrifice Key", br.dropOptions.Toggle, 6, "","|cffFFFFFFDivine Shield + Aura of Sacrifice usage.")
		-- Divine Shield + Hand Of Reckoning
		br.ui:createDropdown(section,"Divine Shield + Hand Of Reckoning Key", br.dropOptions.Toggle, 6, "","|cffFFFFFFDivine Shield + Hand Of Reckoning usage.")
		br.ui:checkSectionState(section)
		-------------------------
		--- INTERRUPT OPTIONS ---
		-------------------------
		section = br.ui:createSection(br.ui.window.profile, "Interrupts")
		--Hammer of Justice
		br.ui:createCheckbox(section, "Hammer of Justice")
		-- Blinding Light
		br.ui:createCheckbox(section, "Blinding Light")
		-- Interrupt Percentage
		br.ui:createSpinner(section,  "InterruptAt",  95,  0,  95,  5,  "","|cffFFBB00Cast Percentage to use at.")
		br.ui:checkSectionState(section)
		-------------------------
		------ COOL  DOWNS ------
		-------------------------
		section = br.ui:createSection(br.ui.window.profile, "Cool Downs")
		-- Trinkets
		br.ui:createSpinner(section, "Trinket 1",  70,  0,  100,  5,  "Health Percent to Cast At")
		br.ui:createSpinnerWithout(section, "Min Trinket 1 Targets",  3,  1,  40,  1,  "","Minimum Trinket 1 Targets(This includes you)", true)
		br.ui:createSpinner(section, "Trinket 2",  70,  0,  100,  5,  "Health Percent to Cast At")
		br.ui:createSpinnerWithout(section, "Min Trinket 2 Targets",  3,  1,  40,  1,  "","Minimum Trinket 2 Targets(This includes you)", true)
		-- Lay on Hands
		br.ui:createSpinner(section, "Lay on Hands", 20, 0, 100, 5, "","|cffFFFFFFHealth Percent to Cast At")
		br.ui:createDropdownWithout(section, "Lay on Hands Target", {"|cffFFFFFFAll","|cffFFFFFFTanks", "|cffFFFFFFSelf"}, 1, "|cffFFFFFFTarget for LoH")
		-- Blessing of Protection
		br.ui:createSpinner(section, "Blessing of Protection", 20, 0, 100, 5, "","|cffFFFFFFHealth Percent to Cast At")
		br.ui:createDropdownWithout(section, "BoP Target", {"|cffFFFFFFAll","|cffFFFFFFTanks","|cffFFFFFFHealer/Damage", "|cffFFFFFFSelf"}, 3, "|cffFFFFFFTarget for BoP")
		-- Blessing of Sacrifice
		br.ui:createSpinner(section, "Blessing of Sacrifice", 40, 0, 100, 5, "","|cffFFFFFFHealth Percent to Cast At")
		br.ui:createDropdownWithout(section, "BoS Target", {"|cffFFFFFFAll","|cffFFFFFFTanks","|cffFFFFFFDamage"}, 2, "|cffFFFFFFTarget for BoS")
		-- Avenging Wrath
		br.ui:createSpinner(section, "Avenging Wrath", 50, 0, 100, 5, "","|cffFFFFFFHealth Percent to Cast At")
		br.ui:createSpinner(section, "Avenging Wrath Targets",  4,  0,  40,  1,  "","|cffFFFFFFMinimum Avenging Wrath Targets", true)
		-- Holy Avenger
		br.ui:createSpinner(section, "Holy Avenger", 60, 0, 100, 5, "","|cffFFFFFFHealth Percent to Cast At")
		br.ui:createSpinner(section, "Holy Avenger Targets",  3,  0,  40,  1,  "","|cffFFFFFFMinimum Holy Avenger Targets", true)
		-- Aura Mastery
		br.ui:createSpinner(section, "Aura Mastery",  50,  0,  100,  5,  "","|cffFFFFFFHealth Percent to Cast At")
		br.ui:createSpinner(section, "Aura Mastery Targets",  3,  0,  40,  1,  "","|cffFFFFFFMinimum Aura Mastery Targets", true)
		br.ui:checkSectionState(section)
		-------------------------
		---- SINGLE TARGET ------
		-------------------------
		section = br.ui:createSection(br.ui.window.profile, "Single Target Healing")
		--Flash of Light
		br.ui:createSpinner(section, "Flash of Light",  70,  0,  100,  5,  "","|cffFFFFFFHealth Percent to Cast At")
		br.ui:createSpinner(section, "FoL Tanks",  70,  0,  100,  5,  "","|cffFFFFFFTanks Health Percent to Cast At", true)
		br.ui:createSpinner(section, "FoL Infuse",  70,  0,  100,  5,  "","|cffFFFFFFIn Infuse buff Health Percent to Cast At", true)
		--Holy Light
		br.ui:createSpinner(section, "Holy Light",  85,  0,  100,  5,  "","|cffFFFFFFHealth Percent to Cast At")
		br.ui:createDropdownWithout(section, "Holy Light Infuse", {"|cffFFFFFFNormal","|cffFFFFFFOnly Infuse"}, 2, "|cffFFFFFFOnly Use Infusion Procs.")
		--Holy Shock
		br.ui:createSpinner(section, "Holy Shock", 80, 0, 100, 5, "","|cffFFFFFFHealth Percent to Cast At")
		--Bestow Faith
		br.ui:createSpinner(section, "Bestow Faith", 80, 0, 100, 5, "","|cffFFFFFFHealth Percent to Cast At")
		br.ui:createDropdownWithout(section, "Bestow Faith Target", {"|cffFFFFFFAll","|cffFFFFFFTanks","|cffFFFFFFSelf","|cffFFFFFFSelf+LotM"}, 4, "|cffFFFFFFTarget for BF")
		-- Light of the Martyr
		br.ui:createSpinner(section, "Light of the Martyr", 40, 0, 100, 5, "","|cffFFFFFFHealth Percent to Cast At")
		br.ui:createSpinner(section, "Moving LotM", 80, 0, 100, 5, "","|cffFFFFFFisMoving Health Percent to Cast At")
		br.ui:createSpinner(section, "LoM after FoL", 60, 0, 100, 5, "","|cffFFFFFFHealth Percent to Cast At")
		br.ui:createDropdownWithout(section, "LoM after FoL Target", {"|cffFFFFFFTanks","|cffFFFFFFAll"}, 1, "|cffFFFFFFTarget for LoM after FoL")
		br.ui:createSpinner(section, "LotM player HP limit", 50, 0, 100, 5, "","|cffFFFFFFLight of the Martyr Self HP limit", true)
		br.ui:checkSectionState(section)
		-------------------------
		------ AOE HEALING ------
		-------------------------
		section = br.ui:createSection(br.ui.window.profile, "AOE Healing")
		-- Rule of Law
		br.ui:createSpinner(section, "Rule of Law",  70,  0,  100,  5,  "","|cffFFFFFFHealth Percent to Cast At")
		br.ui:createSpinner(section, "RoL Targets",  3,  0,  40,  1,  "","|cffFFFFFFMinimum RoL Targets", true)
		-- Light of Dawn
		br.ui:createSpinner(section, "Light of Dawn",  90,  0,  100,  5,  "","|cffFFFFFFHealth Percent to Cast At")
		br.ui:createSpinner(section, "LoD Targets",  3,  0,  40,  1,  "","|cffFFFFFFMinimum LoD Targets", true)
		-- Beacon of Virtue
		br.ui:createSpinner(section, "Beacon of Virtue", 80, 0, 100, 5, "","|cffFFFFFFHealth Percent to Cast At")
		br.ui:createSpinner(section, "BoV Targets",  3,  0,  40,  1,  "","|cffFFFFFFMinimum BoV Targets", true)
		-- Holy Prism
		br.ui:createSpinner(section, "Holy Prism", 90, 0, 100, 5, "","|cffFFFFFFHealth Percent to Cast At")
		br.ui:createSpinner(section, "Holy Prism Targets",  3,  0,  40,  1,  "","|cffFFFFFFMinimum Holy Prism Targets", true)
		-- Light's Hammer
		br.ui:createSpinner(section, "Light's Hammer", 80, 0, 100, 5, "","|cffFFFFFFHealth Percent to Cast At")
		br.ui:createSpinner(section, "Light's Hammer Targets",  3,  0,  40,  1,  "","|cffFFFFFFMinimum Light's Hammer Targets", true)
		br.ui:createDropdown(section,"Light's Hammer Key", br.dropOptions.Toggle, 6, "","|cffFFFFFFLight's Hammer usage.")
		br.ui:checkSectionState(section)
		-------------------------
		---------- DPS ----------
		-------------------------
		section = br.ui:createSection(br.ui.window.profile, "DPS")
		br.ui:createCheckbox(section, "Auto Focus target")
		br.ui:createSpinner(section, "DPS", 70, 0, 100, 5, "","|cffFFFFFFMinimum Health to DPS")
		-- Consecration
		br.ui:createSpinner(section, "Consecration",  1,  0,  40,  1,  "","|cffFFFFFFMinimum Consecration Targets")
		-- Holy Prism
		br.ui:createSpinner(section, "Holy Prism Damage",  3,  0,  40,  1,  "","|cffFFFFFFMinimum Holy Prism Targets")
		-- Light's Hammer
		br.ui:createSpinner(section, "Light's Hammer Damage",  3,  0,  40,  1,  "","|cffFFFFFFMinimum Light's Hammer Targets")
		-- Judgement
		br.ui:createCheckbox(section, "Judgement")
		-- Holy Shock
		br.ui:createCheckbox(section, "Holy Shock Damage")
		-- Crusader Strike
		br.ui:createCheckbox(section, "Crusader Strike")
		br.ui:checkSectionState(section)
	end
	optionTable = {{
	[1] = "Rotation Options",
	[2] = rotationOptions,
	}}
	return optionTable
end

----------------
--- ROTATION ---
----------------

local function runRotation()
	-- if br.timer:useTimer("debugHoly", 0.1) then --change "debugFury" to "debugSpec" (IE: debugFire)
		--Print("Running: "..rotationName)

		---------------
		--- Toggles --- -- List toggles here in order to update when pressed
		---------------
		UpdateToggle("Rotation",0.25)
		UpdateToggle("Cooldown",0.25)
		UpdateToggle("Defensive",0.25)
		UpdateToggle("Interrupt",0.25)
		UpdateToggle("Cleanse",0.25)
		br.player.mode.cleanse = br.data.settings[br.selectedSpec].toggles["Cleanse"]
		UpdateToggle("DPS",0.25)
		br.player.mode.DPS = br.data.settings[br.selectedSpec].toggles["DPS"]
		--------------
		--- Locals ---
		--------------
		-- local artifact                                      = br.player.artifact
		-- local combatTime                                    = getCombatTime()
		-- local cd                                            = br.player.cd
		-- local falling, swimming, flying, moving             = getFallTime(), IsSwimming(), IsFlying(), GetUnitSpeed("player")>0
		-- local healPot                                       = getHealthPot()
		-- local level                                         = br.player.level
		-- local lowestHP                                      = br.friend[1].unit
		-- local lowest                                        = br.friend[1]
		-- local mana                                          = br.player.powerPercentMana
		-- local perk                                          = br.player.perk
		-- local power, powmax, powgen                         = br.player.power.mana.amount(), br.player.power.mana.max(), br.player.power.mana.regen()
		-- local ttm                                           = br.player.power.mana.ttm()
		--------------
		-- Player
		--------------
		local buff                                          = br.player.buff
		local cast                                          = br.player.cast
		local php                                           = br.player.health
		local spell                                         = br.player.spell
		local talent                                        = br.player.talent
		local gcd                                           = br.player.gcd
		local charges                                       = br.player.charges
		local debuff                                        = br.player.debuff
		local drinking                                      = getBuffRemain("player",192002) == 0 and getBuffRemain("player",167152) == 0 and getBuffRemain("player",192001) == 0
		local inCombat                                      = br.player.inCombat
		local inInstance                                    = br.player.instance=="party"
		local inRaid                                        = br.player.instance=="raid"
		local race                                          = br.player.race
		local racial                                        = br.player.getRacial()
		local traits                                        = br.player.traits
		-------------
		-- Raid
		-------------
		local tanks                                         = getTanksTable()
		local lowest                                        = br.friend[1]
		local friends                                       = friends or {}
		-------------
		-- Enemies
		-------------
		local enemies                                       = br.player.enemies
		local lastSpell                                     = lastSpellCast
		local resable                                       = UnitIsPlayer("target") and UnitIsDeadOrGhost("target") and GetUnitIsFriend("target","player")
		local mode                                          = br.player.mode
		local pullTimer                                     = br.DBM:getPulltimer()
		local units                                         = br.player.units
		local LightCount                                    = 0
		local FaithCount                                    = 0

		if traits.breakingDawn then
			lightOfDawn_distance =40
		else
			lightOfDawn_distance =15
		end
		if buff.ruleOfLaw.exists("player") then
			lightOfDawn_distance_coff =1.5
			master_coff =1.5
		else
			lightOfDawn_distance_coff =1
			master_coff =1.0
		end
		if not isCastingSpell(spell.flashOfLight) then
			BOV = nil
		end
		if not isCastingSpell(spell.flashOfLight) and not isCastingSpell(spell.holyLight) then
			healing_obj = nil
		end
		units.get(5)
		units.get(8)
		units.get(15)
		units.get(30)
		units.get(40)
		enemies.get(5)
		enemies.get(8)
		enemies.get(10)
		enemies.get(15)
		enemies.get(30)
		enemies.get(40)
		friends.yards40 = getAllies("player",40*master_coff)

		-- Beacon of Virtue
		if isChecked("Beacon of Virtue") and talent.beaconOfVirtue and not IsMounted() then
			for i= 1, #br.friend do
			if GetUnitIsVisible(br.friend[i].unit) then
				local lowHealthCandidates = getUnitsToHealAround(br.friend[i].unit,30,getValue("Beacon of Virtue"),#br.friend)
					if (BOV ~= nil and isCastingSpell(spell.flashOfLight)) or (#lowHealthCandidates >= getValue("BoV Targets") and isCastingSpell(spell.flashOfLight)) or
					(#lowHealthCandidates >= getValue("BoV Targets") and isMoving("player") and cast.able.beaconOfVirtue() and GetSpellCooldown(20473) < gcd) then
						if CastSpellByName(GetSpellInfo(200025),lowest.unit) then return end
					end
				end
			end
		end
		-- Temple of Sethraliss
		if GetObjectID("target") == 133392 and inCombat then
			if getHP("target") < 100 and getBuffRemain("target",274148) == 0 then
				if GetSpellCooldown(20473) == 0 then
					if CastSpellByName(GetSpellInfo(20473),"target") then return end
				end
				if php >= getOptionValue("LotM player HP limit") then
					if CastSpellByName(GetSpellInfo(183998),"target") then return end
				end
				if GetSpellCooldown(20473) ~= 0 then
					if CastSpellByName(GetSpellInfo(19750),"target") then return end
				end
			end
		end
		bossHelper()
		-----------------
		--- Rotations ---
		-----------------
		local function overhealingcancel()
			-- Overhealing Cancel
			if isChecked("Overhealing Cancel") and healing_obj ~= nil then
				if getHP(healing_obj) > getValue("Overhealing Cancel") and (isCastingSpell(spell.flashOfLight) or isCastingSpell(spell.holyLight)) then
					SpellStopCasting()
					healing_obj = nil
					Print("Cancel casting...")
				end
			end
		end
		local function key()
			-- Divine Shield + Aura of Sacrifice
			if isChecked("Divine Shield + Aura of Sacrifice Key") and (SpecificToggle("Divine Shield + Aura of Sacrifice Key") and not GetCurrentKeyBoardFocus()) then
				if buff.divineShield.exists() and talent.auraOfSacrifice then
					if cast.auraMastery() then return end
				end
				if cast.divineShield() then return end
			end
			-- Light's Hammer
			if isChecked("Light's Hammer Key") and (SpecificToggle("Light's Hammer Key") and not GetCurrentKeyBoardFocus()) then
				CastSpellByName(GetSpellInfo(spell.lightsHammer),"cursor")
				return
			end
			-- Divine Shield + Hand Of Reckoning
			if isChecked("Divine Shield + Hand Of Reckoning Key") and (SpecificToggle("Divine Shield + Hand Of Reckoning Key") and not GetCurrentKeyBoardFocus()) then
				if buff.divineShield.exists() then
					if cast.handOfReckoning() then return end
				end
				if cast.divineShield() then return end
			end
		end
		local function PrePull()
			-- Pre-Pull Timer
			if isChecked("Pre-Pull Timer") then
				if pullTimer <= getOptionValue("Pre-Pull Timer") then 
					if canUse(142117) and not buff.prolongedPower.exists() then
						useItem(142117);
						return true
					end
				end
			end
		end
		----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		-- Defensive ---------- Defensive ---------- Defensive ---------- Defensive ---------- Defensive ---------- Defensive ---------- Defensive --------- Defensive --------- Defensive
		----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		local function actionList_Defensive()
			if useDefensive() then
				if isChecked("Pot/Stoned") and php <= getValue("Pot/Stoned") and (hasHealthPot() or hasItem(5512)) then
					if canUse(5512) then
						useItem(5512)
					elseif canUse(getHealthPot()) then
						useItem(getHealthPot())
					end
				end
				-- Gift of the Naaru
				if isChecked("Gift of The Naaru") and php <= getOptionValue("Gift of The Naaru") and php > 0 and race == "Draenei" then
					if castSpell("player",racial,false,false,false) then return end
				end
				-- Divine Shield
				if isChecked("Divine Shield") and cast.able.divineShield() then
					if php <= getOptionValue("Divine Shield") then
						if cast.divineShield() then return end
					end
				end
				--	Divine Protection
				if isChecked("Divine Protection") and cast.able.divineProtection() and not buff.divineShield.exists("player") then
					if php <= getOptionValue("Divine Protection") then
						if cast.divineProtection() then return end
					elseif buff.blessingOfSacrifice.exists("player") then
						if cast.divineProtection() then return end
					end
				end
				-- Blessing of Freedom
				if isChecked("Blessing of Freedom") and cast.able.blessingOfFreedom() and hasNoControl(spell.blessingOfFreedom) then
					if cast.blessingOfFreedom("player") then return end
				end
			end
		end
		----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		-- CanIRess ----------- CanIRess ----------- CanIRess ----------- CanIRess ----------- CanIRess ----------- CanIRess ----------- CanIRess ----------- CanIRess ----------- Cleanse
		----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		local function CanIRess()
			if isChecked("Redemption") then
				if getOptionValue("Redemption")==1 and not isMoving("player") and resable and UnitInRange("target") then
					if cast.redemption("target","dead") then return end
				end
				if getOptionValue("Redemption")==2 and not isMoving("player") and resable and UnitInRange("mouseover") then
					if cast.redemption("mouseover","dead") then return end
				end
			end
		end
		----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		-- BossEncounterCase ----------- BossEncounterCase ----------- BossEncounterCase ----------- BossEncounterCase ----------- BossEncounterCase ----------- BossEncounterCase -------
		----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		local function BossEncounterCase()
			local blessingOfFreedomCase = nil
			local blessingOfProtectionCase = nil
			local hammerOfJusticeCase = nil
			for i = 1, #br.friend do
				if getDebuffRemain(br.friend[i].unit,268896) ~= 0 or getDebuffRemain(br.friend[i].unit,264526) ~= 0 or getDebuffRemain(br.friend[i].unit,258058) ~= 0 then
					blessingOfFreedomCase = br.friend[i].unit
				end
				if getDebuffRemain(br.friend[i].unit,255421) ~= 0 or getDebuffRemain(br.friend[i].unit,256038) ~= 0 or getDebuffRemain(br.friend[i].unit,260741) ~= 0 then
					blessingOfProtectionCase = br.friend[i].unit
				end
				if UnitIsCharmed(br.friend[i].unit) and getDistance(br.friend[i].unit) <= 10 then
					hammerOfJusticeCase = br.friend[i].unit
				end
			end
			-- Blessing of Freedom
			if cast.able.blessingOfFreedom() then
				if getDebuffRemain("TANK",267899) ~= 0 or getDebuffRemain("TANK",257478) ~= 0 then
					if cast.blessingOfFreedom("TANK") then return end
				end
				if blessingOfFreedomCase ~= nil then
					if cast.blessingOfFreedom(blessingOfFreedomCase) then return end
				end
			end
			-- Blessing of Protection
			if cast.able.blessingOfProtection() then
				if blessingOfProtectionCase ~= nil then
					if cast.blessingOfProtection(blessingOfProtectionCase) then return end
				end
			end
			if cast.able.hammerOfJustice() then
				for i = 1, #enemies.yards10 do
					local thisUnit = enemies.yards10[i]
					local distance = getDistance(thisUnit)
					if (GetObjectID(thisUnit) == 131009 or GetObjectID(thisUnit) == 134388 or GetObjectID(thisUnit) == 129758) and distance <= 10 then
						if cast.hammerOfJustice(thisUnit) then return end
					end
				end
				if hammerOfJusticeCase ~= nil then
					if cast.hammerOfJustice(hammerOfJusticeCase) then return end
				end
			end
		end
		----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		-- Cleanse ----------- Cleanse ----------- Cleanse ----------- Cleanse ----------- Cleanse ----------- Cleanse ----------- Cleanse ----------- Cleanse ----------- Cleanse -------
		----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		local function Cleanse()
			-- Cleanse
			if br.player.mode.cleanse == 1 and cast.able.cleanse() then
				for i = 1, #friends.yards40 do
					if (getDebuffRemain(br.friend[i].unit,275014) >= 2 or getDebuffRemain(br.friend[i].unit,261440) >= 2) and #getAllies(br.friend[i].unit,6) < 2 then
						if cast.cleanse(br.friend[i].unit) then return end
					end
					if getDebuffRemain(br.friend[i].unit,275014) == 0 and getDebuffRemain(br.friend[i].unit,261440) == 0 and getDebuffRemain(br.friend[i].unit,270920) == 0
					and getDebuffRemain(br.friend[i].unit,277498) == 0 then
						if canDispel(br.friend[i].unit,spell.cleanse) then
							if cast.cleanse(br.friend[i].unit) then return end
						end
					end
				end
			end
		end
		----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		-- Interrupt --------- Interrupt --------- Interrupt --------- Interrupt --------- Interrupt --------- Interrupt --------- Interrupt --------- Interrupt --------- Interrupt -----
		----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		local function Interrupt()
			if useInterrupts() then
				for i = 1, #enemies.yards10 do
					local thisUnit = enemies.yards10[i]
					local distance = getDistance(thisUnit)
					if canInterrupt(thisUnit,getOptionValue("InterruptAt")) and distance <= 10 then
						-- Hammer of Justice
						if isChecked("Hammer of Justice") and cast.able.hammerOfJustice() then
							if cast.hammerOfJustice(thisUnit) then return end
						end
						-- Blinding Light
						if isChecked("Blinding Light") and cast.able.blindingLight() then
							if cast.blindingLight() then return end
						end
					end
				end
			end
		end
		----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		-- Beacon ---------- Beacon ---------- Beacon ---------- Beacon ---------- Beacon ---------- Beacon ---------- Beacon ---------- Beacon ---------- Beacon ---------- Beacon ------
		----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		local function Beacon()
			local beaconOfLightinRaid = nil
			local beaconOfLightTANK = nil
			local beaconOfFaithTANK = nil
			local beaconOfFaithplayer = nil
			LightCount = 0
			FaithCount = 0
			for i=1, #br.friend do
				if buff.beaconOfLight.exists(br.friend[i].unit) then
					LightCount = LightCount + 1
				end
				if buff.beaconOfFaith.exists(br.friend[i].unit) then
					FaithCount = FaithCount + 1
				end
			end
			for i=1, #br.friend do
				if UnitInRange(br.friend[i].unit) then
					if (br.friend[i].role == "TANK" or UnitGroupRolesAssigned(br.friend[i].unit) == "TANK") and GetUnitIsUnit(br.friend[i].unit,"boss1target")
						and not buff.beaconOfLight.exists(br.friend[i].unit) and not buff.beaconOfFaith.exists(br.friend[i].unit) then
						beaconOfLightinRaid = br.friend[i].unit
					end
					if LightCount < 1 and not buff.beaconOfLight.exists(br.friend[i].unit) and not buff.beaconOfFaith.exists(br.friend[i].unit) and (br.friend[i].role == "TANK" or UnitGroupRolesAssigned(br.friend[i].unit) == "TANK") then
						beaconOfLightTANK = br.friend[i].unit
					end
					if FaithCount < 1 and not buff.beaconOfLight.exists(br.friend[i].unit) and not buff.beaconOfFaith.exists(br.friend[i].unit) and (br.friend[i].role == "TANK" or UnitGroupRolesAssigned(br.friend[i].unit) == "TANK") then
						beaconOfFaithTANK = br.friend[i].unit
					elseif FaithCount < 1 and not inRaid and not buff.beaconOfLight.exists(br.friend[i].unit) and not buff.beaconOfFaith.exists(br.friend[i].unit) then
						beaconOfFaithplayer = br.friend[i].unit
					end
				end
			end
			if inRaid and beaconOfLightinRaid ~= nil then
				if cast.beaconOfLight(beaconOfLightinRaid) then return end
			end
			if beaconOfLightTANK ~= nil then
				if cast.beaconOfLight(beaconOfLightTANK) then return end
			end
			if talent.beaconOfFaith then
				if beaconOfFaithTANK ~= nil then
					if cast.beaconOfFaith(beaconOfFaithTANK) then return end
				end
				if beaconOfFaithplayer ~= nil then
					if cast.beaconOfFaith(beaconOfFaithplayer) then return end
				end
			end
		end
		----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		--Cooldowns ------- Cooldowns -------Cooldowns ------- Cooldowns ------- Cooldowns ------- Cooldowns ------- Cooldowns ------- Cooldowns ------- Cooldowns ------- Cooldowns -----
		----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		local function Cooldowns()
			local layOnHandsall = nil
			local layOnHandsTANK = nil
			local blessingOfProtectionall = nil
			local blessingOfProtectionTANK = nil
			local blessingOfProtectionHD = nil
			local blessingOfSacrificeall = nil
			local blessingOfSacrificeTANK = nil
			local blessingOfSacrificeDAMAGER = nil
			for i = 1, #br.friend do
				if UnitInRange(br.friend[i].unit) then
					if br.friend[i].hp <= getValue ("Lay on Hands") and getDebuffStacks(br.friend[i].unit,209858) < getValue("Necrotic Rot") then
						layOnHandsall = br.friend[i].unit
					end
					if br.friend[i].hp <= getValue ("Lay on Hands") and (br.friend[i].role == "TANK" or UnitGroupRolesAssigned(br.friend[i].unit) == "TANK") and getDebuffStacks(br.friend[i].unit,209858) < getValue("Necrotic Rot") then
						layOnHandsTANK = br.friend[i].unit
					end
					if br.friend[i].hp <= getValue ("Blessing of Protection") then
						blessingOfProtectionall = br.friend[i].unit
					end
					if br.friend[i].hp <= getValue ("Blessing of Protection") and (br.friend[i].role == "TANK" or UnitGroupRolesAssigned(br.friend[i].unit) == "TANK") then
						blessingOfProtectionTANK = br.friend[i].unit
					end
					if br.friend[i].hp <= getValue ("Blessing of Protection") and (UnitGroupRolesAssigned(br.friend[i].unit) == "HEALER" or UnitGroupRolesAssigned(br.friend[i].unit) == "DAMAGER") then
						blessingOfProtectionHD = br.friend[i].unit
					end
					if br.friend[i].hp <= getValue ("Blessing of Sacrifice") and not GetUnitIsUnit(br.friend[i].unit,"player") then
						blessingOfSacrificeall = br.friend[i].unit
					end
					if br.friend[i].hp <= getValue ("Blessing of Sacrifice") and (br.friend[i].role == "TANK" or UnitGroupRolesAssigned(br.friend[i].unit) == "TANK") then
						blessingOfSacrificeTANK = br.friend[i].unit
					end
					if br.friend[i].hp <= getValue ("Blessing of Sacrifice") and UnitGroupRolesAssigned(br.friend[i].unit) == "DAMAGER" then
						blessingOfSacrificeDAMAGER = br.friend[i].unit
					end
				end
			end
			-- Lay on Hands
			if isChecked("Lay on Hands") and cast.able.layOnHands() then
				if getOptionValue("Lay on Hands Target") == 1 then
					if layOnHandsall ~= nil then
						if cast.layOnHands(layOnHandsall) then return end
					end
				elseif getOptionValue("Lay on Hands Target") == 2 then
					if layOnHandsTANK ~= nil then
						if cast.layOnHands(layOnHandsTANK) then return end
					end
				elseif getOptionValue("Lay on Hands Target") == 3 and getDebuffRemain("player",267037) == 0 then
					if php <= getValue("Lay on Hands") then
						if cast.layOnHands("player") then return end
					end
				end
			end
			-- Blessing of Protection
			if isChecked("Blessing of Protection") and cast.able.blessingOfProtection() and not isBoss("boss1") then
				if getOptionValue("BoP Target") == 1 then
					if blessingOfProtectionall ~= nil then
						if cast.blessingOfProtection(blessingOfProtectionall) then return end
					end
				elseif getOptionValue("BoP Target") == 2 then
					if blessingOfProtectionTANK ~= nil then
						if cast.blessingOfProtection(blessingOfProtectionTANK) then return end
					end
				elseif getOptionValue("BoP Target") == 3 then
					if  blessingOfProtectionHD ~= nil then
						if cast.blessingOfProtection(blessingOfProtectionHD) then return end
					end
				elseif getOptionValue("BoP Target") == 4 then
					if php <= getValue("Blessing of Protection") then
						if cast.blessingOfProtection("player") then return end
					end
				end
			end
			-- Blessing of Sacrifice
			if isChecked("Blessing of Sacrifice") and cast.able.blessingOfSacrifice() then
				if getOptionValue("BoS Target") == 1 then
					if blessingOfSacrificeall ~= nil then
						if cast.blessingOfSacrifice(blessingOfSacrificeall) then return end
					end
				elseif getOptionValue("BoS Target") == 2 then
					if blessingOfSacrificeTANK ~= nil then
						if cast.blessingOfSacrifice(blessingOfSacrificeTANK) then return end
					end
				elseif getOptionValue("BoS Target") == 3 then
					if blessingOfSacrificeDAMAGER ~= nil then
						if cast.blessingOfSacrifice(blessingOfSacrificeDAMAGER) then return end
					end
				end
			end
			-- Trinkets
			if isChecked("Trinket 1") and getLowAllies(getValue("Trinket 1")) >= getValue("Min Trinket 1 Targets") then
				if canUse(13) then
					useItem(13)
					return true
				end
			end
			if isChecked("Trinket 2") and getLowAllies(getValue("Trinket 2")) >= getValue("Min Trinket 2 Targets") then
				if canUse(14) then
					useItem(14)
					return true
				end
			end
			-- Holy Avenger
			if isChecked("Holy Avenger") and cast.able.holyAvenger() and talent.holyAvenger then
				if getLowAllies(getValue"Holy Avenger") >= getValue("Holy Avenger Targets") then
					if cast.holyAvenger() then return end
				end
			end
			-- Avenging Wrath
			if isChecked("Avenging Wrath") and cast.able.avengingWrath() and not talent.avengingCrusader then
				if getLowAllies(getValue"Avenging Wrath") >= getValue("Avenging Wrath Targets") then
					if cast.avengingWrath() then return end
				end
			end
			-- Aura Mastery
			if isChecked("Aura Mastery") and cast.able.auraMastery() then
				if getLowAllies(getValue"Aura Mastery") >= getValue("Aura Mastery Targets") then
					if cast.auraMastery() then return end
				end
			end
			if isChecked("Light's Hammer") and cast.able.lightsHammer() and talent.lightsHammer and not isMoving("player") then
				if getLowAllies(getValue("Light's Hammer")) >= getValue("Light's Hammer Targets") then
					if castGroundAtBestLocation(spell.lightsHammer, 20, 0, 40, 0, "heal") then return end
				end
			end
		end
		----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		-- DPS ----------- DPS ----------- DPS ----------- DPS ----------- DPS ----------- DPS ----------- DPS ----------- DPS ----------- DPS ----------- DPS ----------- DPS -----------
		----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		local function DPS()
			if (mode.DPS == 1 and isChecked("DPS") and lowest.hp > getValue("DPS")) or buff.avengingCrusader.exists() then
				if isChecked("Auto Focus target") and not UnitExists("target") and not UnitIsDeadOrGhost("focustarget") and UnitAffectingCombat("focustarget") and hasThreat("focustarget") then
					TargetUnit("focustarget")
				end
				-- Start Attack
				if getDistance(units.dyn5) <= 5 then
					StartAttack(units.dyn5)
				end
				--Consecration
				if isChecked("Consecration") and cast.able.consecration() and #enemies.yards5 >= getValue("Consecration") and getDebuffRemain(units.dyn8,204242) == 0 and not isMoving("player") and not buff.avengingCrusader.exists() then
					if cast.consecration() then return end
				end
				-- Holy Prism
				if isChecked("Holy Prism Damage") and talent.holyPrism and ast.able.holyPrism() and #enemies.yards15 >= getValue("Holy Prism Damage") and php < 95 then
				if cast.holyPrism("player") then return end
				end
				-- Light's Hammer
				if isChecked("Light's Hammer Damage") and talent.lightsHammer and ast.able.lightsHammer() and not isMoving("player") then
				if cast.lightsHammer("best",nil,getValue("Light's Hammer Damage"),10) then return end
				end
				-- Judgement
				if isChecked("Judgement") and cast.able.judgment() and getFacing("player",units.dyn30) and getDistance(units.dyn30) <= 30 then
					if cast.judgment(units.dyn30) then return end
				end
				-- Holy Shock
				if isChecked("Holy Shock Damage") and cast.able.holyShock() and getFacing("player",units.dyn40) and getDistance(units.dyn40) <= 40 then
					if cast.holyShock("target") then return end
				end
				-- Crusader Strike
				if isChecked("Crusader Strike") and cast.able.crusaderStrike() and getFacing("player",units.dyn5) and getDistance(units.dyn5) <= 5 then
					if talent.crusadersMight and GetSpellCooldown(20473) > 1.5 then
						if cast.crusaderStrike(units.dyn5) then return end
					elseif not talent.crusadersMight and (charges.crusaderStrike.count() == 2 or debuff.judgement.exists(units.dyn5) or (charges.crusaderStrike.count() >= 1 and charges.crusaderStrike.recharge() < 3)) then
						if cast.crusaderStrike(units.dyn5) then return end
					elseif buff.avengingCrusader.exists() then
						if cast.crusaderStrike(units.dyn5) then return end
					end
				end
			end
		end
		----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		--AOEHealing ------ AOEHealing ------AOEHealing ------ AOEHealing ------ AOEHealing ------ AOEHealing ------ AOEHealing ------ AOEHealing ------ AOEHealing ----- AOEHealing -----
		----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		local function AOEHealing()
			-- Rule of Law
			if isChecked("Rule of Law") and cast.able.ruleOfLaw() and talent.ruleOfLaw and not buff.ruleOfLaw.exists("player") then
				if getLowAllies(getValue("Rule of Law")) >= getValue("RoL Targets") then
					if cast.ruleOfLaw() then return end
				end
			end
			-- Holy Prism
			if isChecked("Holy Prism") and talent.holyPrism and cast.able.holyPrism() and inCombat then
				for i = 1, #enemies.yards40 do
				local thisUnit = enemies.yards40[i]
				local lowHealthCandidates = getUnitsToHealAround(thisUnit,15,getValue("Holy Prism"),#br.friend)
					if #lowHealthCandidates >= getValue("Holy Prism Targets") then
						if cast.holyPrism(thisUnit) then return true end
					end
				end
			end
			--Beacon of Virtue
			if isChecked("Beacon of Virtue") and cast.able.beaconOfVirtue() and talent.beaconOfVirtue and not isMoving("player") and getDebuffRemain("player",240447) == 0 then
				if getLowAllies(getValue("Beacon of Virtue")) >= getValue("BoV Targets") then
					if lowest.hp <= getValue("Beacon of Virtue") then
						if cast.flashOfLight(lowest.unit) then BOV = lowest.unit return end
					end
				end
			end
			-- Judgement
			if isChecked("Judgement") and cast.able.judgment() and not GetUnitIsFriend(units.dyn30, "player") and inCombat and getFacing("player",units.dyn30) and getDistance(units.dyn30) <= 30 then
				if talent.judgmentOfLight and not debuff.judgmentoflight.exists(units.dyn30) then
					if cast.judgment(units.dyn30) then return end
				end
			end
			-- Light of Dawn
			if isChecked("Light of Dawn") and cast.able.lightOfDawn() then
				if healConeAround(getValue("LoD Targets"),getValue("Light of Dawn"),90,lightOfDawn_distance * lightOfDawn_distance_coff,5 * lightOfDawn_distance_coff) then
					if cast.lightOfDawn() then return end
				end
			end
		end
		----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		--SingleTarget ------ SingleTarget ------SingleTarget ------ SingleTarget ------ SingleTarget ------ SingleTarget ------ SingleTarget ------ SingleTarget ------ SingleTarget ----
		----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		local function SingleTarget()
			local holyShock10 = nil
			local holyShock20 = nil
			local holyShock30 = nil
			local holyShock40 = nil
			local lightOfTheMartyrDS = nil
			local lightOfTheMartyrHS = nil
			local lightOfTheMartyrTANK = nil
			local lightOfTheMartyrHP = nil
			local flashOfLightTANK = nil
			local flashOfLightInfuse10 = nil
			local flashOfLight10 = nil
			local flashOfLightInfuse20 = nil
			local flashOfLight20 = nil
			local flashOfLightInfuse30 = nil
			local flashOfLight30 = nil
			local flashOfLightInfuse40 = nil
			local flashOfLight40 = nil
			local lightOfTheMartyrBF10 = nil
			local lightOfTheMartyrBF20 = nil
			local lightOfTheMartyrBF30 = nil
			local lightOfTheMartyrBF40 = nil
			local holyLight10 = nil
			local holyLight20 = nil
			local holyLight30 = nil
			local holyLight40 = nil
			local lightOfTheMartyrM10 = nil
			local lightOfTheMartyrM20 = nil
			local lightOfTheMartyrM30 = nil
			local lightOfTheMartyrM40 = nil
			for i = 1, #br.friend do
				if UnitInRange(br.friend[i].unit) then
					if br.friend[i].hp <= getValue("Holy Shock") and not buff.beaconOfFaith.exists(br.friend[i].unit) and not buff.beaconOfVirtue.exists(br.friend[i].unit) and getDistance(br.friend[i].unit) <= (10*master_coff) then
						holyShock10 = br.friend[i].unit
					end
					if br.friend[i].hp <= getValue("Holy Shock") and not buff.beaconOfFaith.exists(br.friend[i].unit) and not buff.beaconOfVirtue.exists(br.friend[i].unit) and getDistance(br.friend[i].unit) <= (20*master_coff) then
						holyShock20 = br.friend[i].unit
					end
					if br.friend[i].hp <= getValue("Holy Shock") and not buff.beaconOfFaith.exists(br.friend[i].unit) and not buff.beaconOfVirtue.exists(br.friend[i].unit) and getDistance(br.friend[i].unit) <= (30*master_coff) then
						holyShock30 = br.friend[i].unit
					end
					if br.friend[i].hp <= getValue("Holy Shock") and getDebuffStacks(br.friend[i].unit,209858) < getValue("Necrotic Rot") then
						holyShock40 = br.friend[i].unit
					end
					if br.friend[i].hp <= 90 and buff.divineShield.exists("player") and not GetUnitIsUnit(br.friend[i].unit,"player") then
						lightOfTheMartyrDS = br.friend[i].unit
					end
					if  br.friend[i].hp <= getValue ("LoM after FoL") and (br.friend[i].role == "TANK" or UnitGroupRolesAssigned(br.friend[i].unit) == "TANK") and GetSpellCooldown(20473) >= gcd then
						lightOfTheMartyrTANK = br.friend[i].unit
					end
					if  br.friend[i].hp <= getValue ("LoM after FoL") and GetSpellCooldown(20473) >= gcd and not GetUnitIsUnit(br.friend[i].unit,"player") then
						lightOfTheMartyrHS = br.friend[i].unit
					end
					if br.friend[i].hp <= getValue ("Light of the Martyr") and not GetUnitIsUnit(br.friend[i].unit,"player") and getDebuffStacks(br.friend[i].unit,209858) < getValue("Necrotic Rot") then
						lightOfTheMartyrHP = br.friend[i].unit
					end
					if br.friend[i].hp <= getValue("FoL Tanks") and (br.friend[i].role == "TANK" or UnitGroupRolesAssigned(br.friend[i].unit) == "TANK") and getDebuffStacks(br.friend[i].unit,209858) < getValue("Necrotic Rot") then
						flashOfLightTANK = br.friend[i].unit
					end
					if br.friend[i].hp <= getValue("FoL Infuse") and getDistance(br.friend[i].unit) <= (10*master_coff) and buff.infusionOfLight.remain("player") > 1.5 then
						flashOfLightInfuse10 = br.friend[i].unit
					elseif br.friend[i].hp <= getValue("Flash of Light") and getDistance(br.friend[i].unit) <= (10*master_coff) then
						flashOfLight10 = br.friend[i].unit
					end
					if br.friend[i].hp <= getValue("FoL Infuse") and getDistance(br.friend[i].unit) <= (20*master_coff) and buff.infusionOfLight.remain("player") > 1.5 then
						flashOfLightInfuse20 = br.friend[i].unit
					elseif br.friend[i].hp <= getValue("Flash of Light") and getDistance(br.friend[i].unit) <= (20*master_coff) then
						flashOfLight20 = br.friend[i].unit
					end
					if br.friend[i].hp <= getValue("FoL Infuse") and getDistance(br.friend[i].unit) <= (30*master_coff) and buff.infusionOfLight.remain("player") > 1.5 then
						flashOfLightInfuse30 = br.friend[i].unit
					elseif br.friend[i].hp <= getValue("Flash of Light") and getDistance(br.friend[i].unit) <= (30*master_coff) then
						flashOfLight30 = br.friend[i].unit
					end
					if br.friend[i].hp <= getValue("FoL Infuse") and getDebuffStacks(br.friend[i].unit,209858) < getValue("Necrotic Rot") and buff.infusionOfLight.remain("player") > 1.5 then
						flashOfLightInfuse40 = br.friend[i].unit
					elseif br.friend[i].hp <= getValue("Flash of Light") and getDebuffStacks(br.friend[i].unit,209858) < getValue("Necrotic Rot") then
						flashOfLight40 = br.friend[i].unit
					end
					if br.friend[i].hp <= getValue("Bestow Faith") and not GetUnitIsUnit(br.friend[i].unit,"player") and getDistance(br.friend[i].unit) <= (10*master_coff) then
						lightOfTheMartyrBF10 = br.friend[i].unit
					end
					if br.friend[i].hp <= getValue("Bestow Faith") and not GetUnitIsUnit(br.friend[i].unit,"player") and getDistance(br.friend[i].unit) <= (20*master_coff) then
						lightOfTheMartyrBF20 = br.friend[i].unit
					end
					if br.friend[i].hp <= getValue("Bestow Faith") and not GetUnitIsUnit(br.friend[i].unit,"player") and getDistance(br.friend[i].unit) <= (30*master_coff) then
						lightOfTheMartyrBF30 = br.friend[i].unit
					end
					if br.friend[i].hp <= getValue ("Bestow Faith") and not GetUnitIsUnit(br.friend[i].unit,"player") and getDebuffStacks(br.friend[i].unit,209858) < getValue("Necrotic Rot") then
						lightOfTheMartyrBF40 = br.friend[i].unit
					end
					if br.friend[i].hp <= getValue("Holy Light") and getDistance(br.friend[i].unit) <= (10*master_coff) then
						holyLight10 = br.friend[i].unit
					end
					if br.friend[i].hp <= getValue("Holy Light") and getDistance(br.friend[i].unit) <= (10*master_coff) then
						holyLight20 = br.friend[i].unit
					end
					if br.friend[i].hp <= getValue("Holy Light") and getDistance(br.friend[i].unit) <= (10*master_coff) then
						holyLight30 = br.friend[i].unit
					end
					if br.friend[i].hp <= getValue("Holy Light") and br.friend[i].hp >= getValue("Critical HP") and getDebuffStacks(br.friend[i].unit,209858) < getValue("Necrotic Rot") then
						holyLight40 = br.friend[i].unit
					end
					if br.friend[i].hp <= getValue("Moving LotM") and not GetUnitIsUnit(br.friend[i].unit,"player") and getDistance(br.friend[i].unit) <= (10*master_coff) then
						lightOfTheMartyrM10 = br.friend[i].unit
					end
					if br.friend[i].hp <= getValue("Moving LotM") and not GetUnitIsUnit(br.friend[i].unit,"player") and getDistance(br.friend[i].unit) <= (20*master_coff) then
						lightOfTheMartyrM20 = br.friend[i].unit
					end
					if br.friend[i].hp <= getValue("Moving LotM") and not GetUnitIsUnit(br.friend[i].unit,"player") and getDistance(br.friend[i].unit) <= (30*master_coff) then
						lightOfTheMartyrM30 = br.friend[i].unit
					end
					if br.friend[i].hp <= getValue("Moving LotM") and not GetUnitIsUnit(br.friend[i].unit,"player") and getDebuffStacks(br.friend[i].unit,209858) < getValue("Necrotic Rot") then
						lightOfTheMartyrM40 = br.friend[i].unit
					end
				end
			end
			-- Holy Shock
			if isChecked("Holy Shock") and (cast.able.holyShock() or isCastingSpell(spell.flashOfLight)) then
				if php <= getValue("Critical HP") then
					if cast.holyShock("player") then return end
				end
				if #tanks > 0 then
					if tanks[1].hp <= getValue("Critical HP") and getDebuffStacks(tanks[1].unit,209858) < getValue("Necrotic Rot") then
						if cast.holyShock(tanks[1].unit) then return end
					end
				end
				if lowest.hp <= getValue("Critical HP") and getDebuffStacks(lowest.unit,209858) < getValue("Necrotic Rot") then
					if cast.holyShock(lowest.unit) then return end
				end
				if inRaid and isChecked("Mastery bonus") then
					if holyShock10 ~= nil then
						if cast.holyShock(holyShock10) then return end
					end
					if holyShock20 ~= nil then
						if cast.holyShock(holyShock20) then return end
					end
					if holyShock30 ~= nil then
						if cast.holyShock(holyShock30) then return end
					end
				end
				if holyShock40 ~= nil then
					if cast.holyShock(holyShock40) then return end
				end
			end
			-- Divine Shield and Light of the Martyr
			if lightOfTheMartyrDS ~= nil and php <= getValue ("Critical HP") then
				if cast.lightOfTheMartyr(lightOfTheMartyrDS) then return end
			end
			if isChecked("LoM after FoL") and isCastingSpell(spell.flashOfLight) and php >= getOptionValue("LotM player HP limit") then
				if getOptionValue("LoM after FoL Target") == 1 and lightOfTheMartyrTANK ~= nil then
					if CastSpellByName(GetSpellInfo(183998),lightOfTheMartyrTANK) then return end
				elseif 	getOptionValue("LoM after FoL Target") == 2 and lightOfTheMartyrHS ~= nil then
					if CastSpellByName(GetSpellInfo(183998),lightOfTheMartyrHS) then return end
				end
			end
			-- Light of Martyr
			if lightOfTheMartyrHP ~= nil and isChecked("Light of the Martyr") and php >= getOptionValue("LotM player HP limit") then
				if cast.lightOfTheMartyr(lightOfTheMartyrHP) then return end
			end
			-- Bestow Faith
			if isChecked("Bestow Faith") and cast.able.bestowFaith() and talent.bestowFaith then
				if getOptionValue("Bestow Faith Target") == 1 then
					if lowest.hp <= getValue ("Bestow Faith") and UnitInRange(lowest.unit) then
						if cast.bestowFaith(lowest.unit) then return end
					end
				elseif getOptionValue("Bestow Faith Target") == 2 and #tanks > 0 and UnitInRange(tanks[1].unit) then
					if tanks[1].hp <= getValue ("Bestow Faith") then
						if cast.bestowFaith(tanks[1].unit) then return end
					end
				elseif 	getOptionValue("Bestow Faith Target") == 3 then
					if php <= getValue ("Bestow Faith") then
						if cast.bestowFaith("player") then return end
					end
				elseif 	getOptionValue("Bestow Faith Target") == 4 then
					if lowest.hp <= getValue ("Bestow Faith") then
						if cast.bestowFaith("player") then return end
					end
				end
			end
			-- Flash of Light
			if isChecked("Flash of Light")  and cast.able.flashOfLight() and not isMoving("player") and getDebuffRemain("player",240447) == 0 then
				if php <= getValue("Critical HP") then
					if cast.flashOfLight("player") then return end
				end
				if #tanks > 0 then
					if tanks[1].hp <= getValue("Critical HP") and getDebuffStacks(tanks[1].unit,209858) < getValue("Necrotic Rot") then
						if cast.flashOfLight(tanks[1].unit) then healing_obj = tanks[1].unit return end
					end
				end
				if lowest.hp <= getValue("Critical HP") and getDebuffStacks(lowest.unit,209858) < getValue("Necrotic Rot") then
					if cast.flashOfLight(lowest.unit) then healing_obj = lowest.unit return end
				end
				if flashOfLightTANK ~= nil then
					if cast.flashOfLight(flashOfLightTANK) then healing_obj = flashOfLightTANK return end
				end
				if inRaid and isChecked("Mastery bonus") then
					if flashOfLightInfuse10 ~= nil then
						if cast.flashOfLight(flashOfLightInfuse10) then healing_obj = flashOfLightInfuse10 return end
					end
					if flashOfLight10 ~= nil then
						if cast.flashOfLight(flashOfLight10) then healing_obj = flashOfLight10 return end
					end
					if flashOfLightInfuse20 ~= nil then
						if cast.flashOfLight(flashOfLightInfuse20) then healing_obj = flashOfLightInfuse20 return end
					end
					if flashOfLight20 ~= nil then
						if cast.flashOfLight(flashOfLight20) then healing_obj = flashOfLight20 return end
					end
					if flashOfLightInfuse30 ~= nil then
						if cast.flashOfLight(flashOfLightInfuse30) then healing_obj = flashOfLightInfuse30 return end
					end
					if flashOfLight30 ~= nil then
						if cast.flashOfLight(flashOfLight30) then healing_obj = flashOfLight30 return end
					end
				end
				if flashOfLightInfuse40 ~= nil then
					if cast.flashOfLight(flashOfLightInfuse40) then healing_obj = flashOfLightInfuse40 return end
				end
				if flashOfLight40 ~= nil then
					if cast.flashOfLight(flashOfLight40) then healing_obj = flashOfLight40 return end
				end
			end
			-- Light of Martyr and Bestow Faith
			if isChecked("Light of the Martyr") and php >= 80 and buff.bestowFaith.exists("player") and getOptionValue("Bestow Faith Target") == 4 then
				if inRaid and isChecked("Mastery bonus") then
					if lightOfTheMartyrBF10 ~= nil then
						if cast.lightOfTheMartyr(lightOfTheMartyrBF10) then return end
					end
					if lightOfTheMartyrBF20 ~= nil then
						if cast.lightOfTheMartyr(lightOfTheMartyrBF20) then return end
					end
					if lightOfTheMartyrBF30 ~= nil then
						if cast.lightOfTheMartyr(lightOfTheMartyrBF30) then return end
					end
				end
				if lightOfTheMartyrBF40 ~= nil then
					if cast.lightOfTheMartyr(lightOfTheMartyrBF40) then return end
				end
			end
			-- Holy Light
			if isChecked("Holy Light") and cast.able.holyLight() and not isMoving("player") and getDebuffRemain("player",240447) == 0 and (getOptionValue("Holy Light Infuse") == 1 or (getOptionValue("Holy Light Infuse") == 2 and buff.infusionOfLight.remain() > 1 and GetSpellCooldown(20473) > 0 and lastSpell ~= spell.flashOfLight)) then
				if inRaid and isChecked("Mastery bonus") then
					if holyLight10 ~= nil then
						if cast.holyLight(holyLight10) then healing_obj = holyLight10 return end
					end
					if holyLight20 ~= nil then
						if cast.holyLight(holyLight20) then healing_obj = holyLight20 return end
					end
					if holyLight30 ~= nil then
						if cast.holyLight(holyLight30) then healing_obj = holyLight30 return end
					end
				end
				if holyLight40 ~= nil then
					if cast.holyLight(holyLight40) then healing_obj = holyLight40 return end
				end
			end
			-- Moving Martyr
			if isChecked("Moving LotM") and isMoving("player") and php >= getOptionValue("LotM player HP limit") then
				if #tanks > 0 then
					if tanks[1].hp <= getValue("Critical HP") and getDebuffStacks(tanks[1].unit,209858) < getValue("Necrotic Rot") then
						if cast.lightOfTheMartyr(tanks[1].unit) then return end
					end
				end
				if lowest.hp <= getValue("Critical HP") and not GetUnitIsUnit(lowest.unit,"player") and getDebuffStacks(lowest.unit,209858) < getValue("Necrotic Rot") then
					if cast.lightOfTheMartyr(lowest.unit) then return end
				end
				if inRaid and isChecked("Mastery bonus") then
					if lightOfTheMartyrM10 ~= nil then
						if cast.lightOfTheMartyr(lightOfTheMartyrM10) then return end
					end
					if lightOfTheMartyrM20 ~= nil then
						if cast.lightOfTheMartyr(lightOfTheMartyrM20) then return end
					end
					if lightOfTheMartyrM30 ~= nil then
						if cast.lightOfTheMartyr(lightOfTheMartyrM30) then return end
					end
				end
				if lightOfTheMartyrM40 ~= nil then
					if cast.lightOfTheMartyr(lightOfTheMartyrM40) then return end
				end
			end
			-- Crusader Strike
			if isChecked("Crusader Strike") and cast.able.crusaderStrike() and not GetUnitIsFriend(units.dyn5, "player") and getFacing("player",units.dyn5) and getDistance(units.dyn5) <= 5 then
				if talent.crusadersMight and GetSpellCooldown(20473) > 1.5 then
					if cast.crusaderStrike(units.dyn5) then return end
				elseif talent.crusadersMight and GetSpellCooldown(85222) > 1.5 then
					if cast.crusaderStrike(units.dyn5) then return end
				end
			end
			-- Judgement
			if isChecked("Judgement") and cast.able.judgment() and not GetUnitIsFriend(units.dyn30, "player") and getFacing("player",units.dyn30) and getDistance(units.dyn30) <= 30 then
				if talent.fistOfJustice and GetSpellCooldown(853) > 1.5 then
					if cast.judgment(units.dyn30) then return end
				end
			end
		end
		---------------------------------
		--- Out Of Combat - Rotations ---
		---------------------------------
		if not inCombat and (not IsMounted() or buff.divineSteed.exists()) and not isCastingSpell(spell.redemption) and not isCastingSpell(spell.absolution) and drinking and not UnitDebuffID("player",188030) then
			key()
			PrePull()
			CanIRess()
			Cleanse()
			if isChecked("OOC Healing") then
				if isChecked("Auto Beacon") and not talent.beaconOfVirtue then Beacon() end
				AOEHealing()
				SingleTarget()
			end
		end
		-----------------------------
		--- In Combat - Rotations ---
		-----------------------------
		if inCombat and (not IsMounted() or buff.divineSteed.exists()) and not isCastingSpell(spell.redemption) and not isCastingSpell(spell.absolution) and drinking and not UnitDebuffID("player",188030) then
			key()
			BossEncounterCase()
			overhealingcancel()
			actionList_Defensive()
			Cleanse()
			Interrupt()
			if isChecked("Auto Beacon") and not talent.beaconOfVirtue then Beacon() end
			if useCDs() then Cooldowns() end
			DPS()
			AOEHealing()
			SingleTarget()
		end
	-- end
end -- End runRotation
--if isChecked("Boss Helper") then
--      bossManager()
--end
local id = 65
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
name = rotationName,
toggles = createToggles,
options = createOptions,
run = runRotation,
})
