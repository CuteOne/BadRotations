local rotationName = "Feng"
local StunsBlackList="167876|169861|168318|165824|165919|171799|168942|167612|169893|167536|173044|167731|165137|167538|168886"
local StunSpellList="332671|326450|328177|336451|331718|331743|334708|333145|321807|334748|327130|327240|330532|328475|330423|294171|164737|330586|329224|328429|295001|296355|295001|295985|330471|329753|296748|334542|242391"
local HoJPrioList = "164702|164362|170488|165905|165251|165556"
---------------
--- Toggles ---
---------------
local function createToggles()
	-- Rotation Button
	RotationModes = {
	[1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell.avengersShield },
	[2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.avengersShield },
	[3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.judgment },
	[4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.flashOfLight }
	}
	CreateButton("Rotation",1,0)
	-- Cooldown Button
	CooldownModes = {
	[1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.avengingWrath },
	[2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.avengingWrath },
	[3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.avengingWrath }
	};
	CreateButton("Cooldown",2,0)
	-- Defensive Button
	DefensiveModes = {
	[1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.guardianOfAncientKings },
	[2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.guardianOfAncientKings }
	};
	CreateButton("Defensive",3,0)
	-- Interrupt Button
	InterruptModes = {
	[1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.hammerOfJustice },
	[2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.hammerOfJustice }
	};
	CreateButton("Interrupt",4,0)
	-- Boss Encounter Case
	BossCaseModes = {
	[1] = { mode = "On", value = 1 , overlay = "BossCase Enabled", tip = "Boss Encounter Case Enabled.", highlight = 1, icon = br.player.spell.blessingOfFreedom },
	[2] = { mode = "Off", value = 2 , overlay = "BossCase Disabled", tip = "Boss Encounter Case Disabled.", highlight = 0, icon = br.player.spell.blessingOfFreedom }
	};
	CreateButton("BossCase",5,0)
	-- Holy Power logic
	HolyPowerlogicModes = {
	[1] = { mode = "Attack", value = 1 , overlay = "Attack logic Enabled", tip = "Holy Power logic (Attack)", highlight = 1, icon = br.player.spell.shieldOfTheRighteous },
	[2] = { mode = "Defense", value = 2 , overlay = "Defense logic Enabled", tip = "Holy Power logic (Defense)", highlight = 1, icon = br.player.spell.wordOfGlory }
	};
	CreateButton("HolyPowerlogic",6,0)
	-- Auto cancel
	AutocancelModes = {
	[1] = { mode = "On", value = 1 , overlay = "Auto cancel Enabled", tip = "Auto cancel BoP and DS\n(Only In Instance and Raid)", highlight = 1, icon = br.player.spell.blessingOfProtection },
	[2] = { mode = "Off", value = 2 , overlay = "Auto cancel Disabled", tip = "Auto cancel BoP and DS Disabled", highlight = 0, icon = br.player.spell.blessingOfProtection }
	};
	CreateButton("Autocancel",7,0)
end
---------------
--- OPTIONS ---
---------------
local function createOptions()
	local optionTable

	local function rotationOptions()
		-----------------------
		--- GENERAL OPTIONS ---
		-----------------------
		section = br.ui:createSection(br.ui.window.profile,  "General")
		-- Blessing of Freedom
		br.ui:createCheckbox(section, "Blessing of Freedom")
		-- Automatic Aura replacement
		br.ui:createCheckbox(section, "Automatic Aura replacement")
		-- Taunt
		br.ui:createCheckbox(section,"Taunt","|cffFFFFFFAuto Taunt usage.")
		-- Lay On Hands
		br.ui:createSpinner(section, "OOC FoL", 50, 0, 100, 1, "", "|cffFFFFFFout of combat Flash of Light.")
		br.ui:createDropdownWithout(section, "OOC FoL Target", {"|cff00FF00Player Only","|cffFFFF00Selected Target","|cffFFFFFFPlayer and Target"}, 3, "|ccfFFFFFFTarget to Cast On")
		-- infinite Divine Steed
		br.ui:createDropdown(section, "infinite Divine Steed key", br.dropOptions.Toggle, 6)
		br.ui:checkSectionState(section)
		------------------------
		--- COOLDOWN OPTIONS ---
		------------------------
		section = br.ui:createSection(br.ui.window.profile,  "Cooldowns")
		-- Racial
		br.ui:createCheckbox(section,"Racial")
		-- Trinkets
		br.ui:createDropdown(section,"Use Trinkets 1", {"|cffFFFFFFHealth","|cffFFFF00Cooldowns","|cff00FF00Everything"}, 1, "","|cffFFFFFFWhen to use trinkets.")
		br.ui:createDropdownWithout(section,"Trinkets 1 Mode", {"|cffFFFFFFNormal","|cffFFFFFFGround"}, 1, "","|cffFFFFFFSelect Trinkets mode.")
		br.ui:createSpinnerWithout(section, "Trinkets 1",  70,  0,  100,  5,  "Health Percentage to use at")
		br.ui:createDropdown(section,"Use Trinkets 2", {"|cffFFFFFFHealth","|cffFFFF00Cooldowns","|cff00FF00Everything"}, 1, "","|cffFFFFFFWhen to use trinkets.")
		br.ui:createDropdownWithout(section,"Trinkets 2 Mode", {"|cffFFFFFFNormal","|cffFFFFFFGround"}, 1, "","|cffFFFFFFSelect Trinkets mode.")
		br.ui:createSpinnerWithout(section, "Trinkets 2",  70,  0,  100,  5,  "Health Percentage to use at")
		-- Seraphim
		br.ui:createSpinner(section, "Seraphim",  0,  0,  20,  2,  "|cffFFFFFFEnemy TTD")
		-- Avenging Wrath
		br.ui:createSpinner(section, "Avenging Wrath",  0,  0,  200,  5,  "|cffFFFFFFEnemy TTD")
		-- Holy Avenger
		br.ui:createSpinner(section, "Holy Avenger",  0,  0,  200,  5,  "|cffFFFFFFEnemy TTD")
		br.ui:createCheckbox(section, "Holy Avenger with Wings")
		br.ui:checkSectionState(section)
		-------------------------
		--- DEFENSIVE OPTIONS ---
		-------------------------
		section = br.ui:createSection(br.ui.window.profile, "Defensive")
		-- Basic Healing Module
		br.player.module.BasicHealing(section)
		-- Phial of Serenity
		br.ui:createSpinner (section, "PoS removes Necrotic", 20, 0, 50, 1, "","|cffFFFFFFNecrotic stacks Phial of Serenity to use at")
		if br.player.race == "BloodElf" then
			br.ui:createSpinner (section, "Arcane Torrent Dispel", 1, 0, 20, 1, "","|cffFFFFFFMinimum Torrent Targets")
		end
		-- Ardent Defender
		br.ui:createSpinner(section, "Ardent Defender",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at")
		-- Blinding Light
		br.ui:createSpinner(section, "Blinding Light - HP", 50, 0, 100, 5, "|cffFFFFFFHealth Percentage to use at")
		-- Cleanse Toxin
		br.ui:createDropdown(section, "Clease Toxin", {"|cff00FF00Player Only","|cffFFFF00Selected Target","|cffFFFFFFPlayer and Target","|cffFF0000Mouseover Target","|cffFFFFFFAny"}, 3, "|ccfFFFFFFTarget to Cast On")
		-- Divine Shield
		br.ui:createSpinner(section, "Divine Shield",  5,  0,  100,  5,  "|cffFFBB00Health Percentage to use at")
		-- Flash of Light
		br.ui:createSpinner(section, "Flash of Light",  50,  0,  100,  5,  "|cffFFBB00Health Percentage to use at")
		-- Guardian of Ancient Kings
		br.ui:createSpinner(section, "Guardian of Ancient Kings",  30,  0,  100,  5,  "|cffFFBB00Health Percentage to use at")
		-- Hammer of Justice
		br.ui:createSpinner(section, "Hammer of Justice - HP",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at")
		-- Word of Glory
		br.ui:createSpinner(section, "Word of Glory",  50,  0,  100,  5,  "|cffFFBB00Word of Glory to use at.")
		-- Free Word of Glory
		br.ui:createSpinnerWithout(section, "Free Word of Glory",  65,  0,  100,  5,  "|cffFFBB00Word of Glory to use at.")
		-- Hand of the Protector - on others
		br.ui:createSpinner(section, "Word of Glory - Party",  40,  0,  100,  5,  "|cffFFBB00Teammate Word of Glory to use at.")
		br.ui:createDropdownWithout(section, "WoG - Party Target", {"|cffFFFFFFOther tanks", "|cffFFFFFFHealer", "|cffFFFFFFHealer/Tank", "|cffFFFFFFAny"}, 4, "|cffFFFFFFTarget for Word of Glory")
		-- Lay On Hands
		br.ui:createSpinner(section, "Lay On Hands", 15, 0, 100, 5, "","Health Percentage to use at")
		br.ui:createDropdownWithout(section, "Lay on Hands Target", {"|cffFFFFFFPlayer","|cffFFFFFFTarget", "|cffFFFFFFMouseover", "|cffFFFFFFTank", "|cffFFFFFFHealer", "|cffFFFFFFHealer/Tank", "|cffFFFFFFHealer/Damage", "|cffFFFFFFAny"}, 8, "|cffFFFFFFTarget for Lay On Hands")
		-- Blessing of Protection
		br.ui:createSpinner(section, "Blessing of Protection", 30, 0, 100, 5, "","Health Percentage to use at")
		br.ui:createDropdownWithout(section, "Blessing of Protection Target", {"|cffFFFFFFPlayer","|cffFFFFFFTarget", "|cffFFFFFFMouseover", "|cffFFFFFFTank", "|cffFFFFFFHealer", "|cffFFFFFFHealer/Tank", "|cffFFFFFFHealer/Damage", "|cffFFFFFFAny"}, 7, "|cffFFFFFFTarget for Blessing of Protection")
		-- Blessing Of Sacrifice
		br.ui:createSpinner(section, "Blessing Of Sacrifice", 40, 0, 100, 5, "","Health Percentage to use at")
		br.ui:createDropdownWithout(section, "Blessing Of Sacrifice Target", {"|cffFFFFFFTarget", "|cffFFFFFFMouseover", "|cffFFFFFFTank", "|cffFFFFFFHealer", "|cffFFFFFFHealer/Tank", "|cffFFFFFFHealer/Damage", "|cffFFFFFFAny"}, 6, "|cffFFFFFFTarget for Blessing Of Sacrifice")
		-- Redemption
		br.ui:createDropdown(section, "Redemption", {"|cffFFFF00Selected Target","|cffFF0000Mouseover Target"}, 1, "|ccfFFFFFFTarget to Cast On")
		-- Unstable Temporal Time Shifter
		br.ui:createDropdown(section, "Engineering Revive", {"|cff00FF00Target","|cffFF0000Mouseover","|cffFFBB00Auto"}, 1, "","|cffFFFFFFTarget to use on")
		br.ui:checkSectionState(section)
		-------------------------
		--- INTERRUPT OPTIONS ---
		-------------------------
		section = br.ui:createSection(br.ui.window.profile, "Interrupts")
		-- Blinding Light
		br.ui:createSpinner(section,  "Blinding Light - INT",  2,  1,  5,  1,  "|cffFFBB00Units to use Blinding Light.")
		-- Hammer of Justice
		br.ui:createCheckbox(section, "Hammer of Justice - INT")
		-- Rebuke
		br.ui:createCheckbox(section, "Rebuke - INT")
		-- Avenger's Shield
		br.ui:createCheckbox(section, "Avenger's Shield - INT")
		-- Interrupt Percentage
		br.ui:createSpinnerWithout(section, "Interrupt At",  60,  0,  100,  5,  "|cffFFBB00Cast Percentage to use at.")
		br.ui:checkSectionState(section)
		------------------------
		--- ROTATION OPTIONS ---
		------------------------
		section = br.ui:createSection(br.ui.window.profile, "Rotation Options")
		-- Divine Toll
		br.ui:createSpinner(section, "Divine Toll",  3,  1,  5,  1,  "|cffFFBB00Units to use Divine Toll.")
		-- Avenger's Shield
		br.ui:createCheckbox(section,"Avenger's Shield")
		-- Consecration
		br.ui:createCheckbox(section,"Consecration")
		-- Blessed Hammer
		br.ui:createCheckbox(section,"Blessed Hammer")
		-- Hammer of the Righteous
		br.ui:createCheckbox(section,"Hammer of the Righteous")
		-- Judgment
		br.ui:createCheckbox(section,"Judgment")
		-- Shield of the Righteous
		br.ui:createCheckbox(section,"Shield of the Righteous")
		-- Hammer of Wrath
		br.ui:createCheckbox(section,"Hammer of Wrath")
		br.ui:checkSectionState(section)
		----------------------
		-------- LISTS -------
		----------------------
		section = br.ui:createSection(br.ui.window.profile,  "Lists")
		br.ui:createScrollingEditBoxWithout(section,"Stuns Black Units", StunsBlackList, "List of units to blacklist when Hammer of Justice", 240, 50)
		br.ui:createScrollingEditBoxWithout(section,"Stun Spells", StunSpellList, "List of spells to stun with auto stun function", 240, 50)
		br.ui:createScrollingEditBoxWithout(section,"HoJ Prio Units", HoJPrioList, "List of units to prioritize for Hammer of Justice", 240, 50)
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
	-- if br.timer:useTimer("debugProtection", math.random(0.1,0.2)) then
	--Print("Running: "..rotationName)
	--------------
	--- Locals ---
	--------------
	local holyPower     = br.player.power.holyPower.amount()
	local holyPowerMax  = br.player.power.holyPower.max()
	local artifact      = br.player.artifact
	local buff          = br.player.buff
	local cast          = br.player.cast
	local cd            = br.player.cd
	local charges       = br.player.charges
	local combatTime    = getCombatTime()
	local debuff        = br.player.debuff
	local enemies       = br.player.enemies
	local gcd           = br.player.gcd
	local gcdMax        = br.player.gcdMax
	local hastar        = GetObjectExists("target")
	local healPot       = getHealthPot()
	local inCombat      = br.player.inCombat
	local level         = br.player.level
	local inInstance    = br.player.instance=="party"
	local inRaid        = br.player.instance=="raid"
	local lowest        = br.friend[1]
	local mode          = br.player.ui.mode
	local php           = br.player.health
	local race          = br.player.race
	local racial        = br.player.getRacial()
	local resable       = UnitIsPlayer("target") and UnitIsDeadOrGhost("target") and GetUnitIsFriend("target","player")
	local solo          = GetNumGroupMembers() == 0
	local spell         = br.player.spell
	local talent        = br.player.talent
	local ttd           = getTTD("target")
	local units         = br.player.units
	local level         = br.player.level
	local module        = br.player.module
	local use           = br.player.use
	local SotR          = true
	local BoF           = true

	units.get(5)
	units.get(10)
	units.get(30)
	enemies.get(5)
	enemies.get(8)
	enemies.get(10)
	enemies.get(30)

	if profileStop == nil then profileStop = false end
	if consecrationRemain == nil then consecrationRemain = 0 end
	if cast.last.consecration() then consecrationRemain = 11.5 end
	if consecrationRemain > 0 and br.timer:useTimer("Consecration Delay",0.5) then
		consecrationRemain = consecrationRemain - 0.5
	end
	local lowestUnit = "player"
	for i = 1, #br.friend do
		local thisUnit = br.friend[i].unit
		if UnitInRange(thisUnit) and not UnitIsDeadOrGhost(thisUnit) and UnitIsVisible(thisUnit) and getLineOfSight("player",thisUnit) then
			local thisHP = getHP(thisUnit)
			local lowestHP = getHP(lowestUnit)
			if thisHP < lowestHP then
				lowestUnit = thisUnit
			end
		end
	end
	local noStunsUnits = {}
	for i in string.gmatch(getOptionValue("Stuns Black Units"), "%d+") do
		noStunsUnits[tonumber(i)] = true
	end
	local StunSpellsList = {}
	for i in string.gmatch(getOptionValue("Stun Spells"), "%d+") do
		StunSpellsList[tonumber(i)] = true
	end
	local HoJList = {}
	for i in string.gmatch(getOptionValue("HoJ Prio Units"), "%d+") do
		HoJList[tonumber(i)] = true
	end
	if (hoj_unit ~= nil and cast.last.hammerOfJustice()) or cast.last.rebuke() then
		hoj_unit = nil
	end
	-- infinite Divine Steed
	if isChecked("infinite Divine Steed key") and (SpecificToggle("infinite Divine Steed key") and not GetCurrentKeyBoardFocus()) then
		if getBuffRemain("player", 254474) <= 0.5 and not UnitAffectingCombat("player") then
			if cast.divineSteed() then return true end
			RemoveTalent(22433)
			RemoveTalent(22433)
			RemoveTalent(22434)
			RemoveTalent(22434)
			RemoveTalent(22435)
			RemoveTalent(22435)
			LearnTalent(22434)
		elseif not talent.unbreakableSpirit and not talent.cavalier and not talent.blessingOfSpellwarding then
			LearnTalent(22434)
		end
	end
	if isChecked("Automatic Aura replacement") and not castingUnit() then
		if not inInstance and not inRaid then
			if not buff.devotionAura.exists() and (not IsMounted() or buff.divineSteed.exists()) then
				if CastSpellByName(GetSpellInfo(465)) then return true end
			elseif not buff.crusaderAura.exists() and IsMounted() then
				if CastSpellByName(GetSpellInfo(32223)) then return true end
			end
		end
		if (inInstance or inRaid) and not buff.devotionAura.exists() then
			if CastSpellByName(GetSpellInfo(465)) then return true end
		end
	end
	--------------------
	--- Action Lists ---
	--------------------
	-- Action List - Extras
	local function actionList_Extras()
		-- Taunt
		if isChecked("Taunt") and cast.able.handOfReckoning() and inInstance then
			for i = 1, #enemies.yards30 do
				local thisUnit = enemies.yards30[i]
				if UnitThreatSituation("player", thisUnit) ~= nil and UnitThreatSituation("player", thisUnit) <= 2 and UnitAffectingCombat(thisUnit) and GetObjectID(thisUnit) ~= 174773 then
					if cast.handOfReckoning(thisUnit) then return true end
				end
			end
		end
		-- Auto cancel BoP and DS
		if mode.autocancel == 1 then
			if inInstance or inRaid then
				if buff.blessingOfProtection.exists() and cast.able.handOfReckoning() then
					if cast.handOfReckoning("target") then return true end
				end
				if buff.blessingOfProtection.exists() and (debuff.handOfReckoning.remain("target") < 0.2 or getDebuffRemain("player",209858) ~= 0) then
					CancelUnitBuffID("player", spell.blessingOfProtection)
				end
				if not talent.finalStand and GetObjectID("boss1") ~= 162060 and GetObjectID("boss1") ~= 164261 then
					if buff.divineShield.exists() and cast.able.handOfReckoning() then
						if cast.handOfReckoning("target") then return true end
					end
					if buff.divineShield.exists() and (debuff.handOfReckoning.remain("target") < 0.2 or getDebuffRemain("player",209858) ~= 0) then
						CancelUnitBuffID("player", spell.divineShield)
					end
				end
			end
		end
		-- Flash of Light
		if isChecked("OOC FoL") and cast.able.flashOfLight() and not inCombat and not isMoving("player") then
				-- Player
			if getOptionValue("OOC FoL Target") == 1 then
				if php <= getValue("OOC FoL") then
					if cast.flashOfLight("player") then return true end
				end
				-- Target
			elseif getOptionValue("OOC FoL Target") == 2 then
				if getHP("target") <= getValue("OOC FoL") and UnitIsPlayer("target") and GetUnitIsFriend("target","player") then
					if cast.flashOfLight("target") then return true end
				end
				-- Player and Target
			elseif getOptionValue("OOC FoL Target") == 3 then
				if php <= getValue("OOC FoL") then
					if cast.flashOfLight("player") then return true end
				elseif getHP("target") <= getValue("OOC FoL") and UnitIsPlayer("target") and GetUnitIsFriend("target","player")then
					if cast.flashOfLight("target") then return true end
				end
			end
		end
	end -- End Action List - Extras
	-- Action List - Defensives
	local function actionList_Defensive()
		if useDefensive() then
			module.BasicHealing()
			if isChecked("PoS removes Necrotic") and inInstance and getDebuffStacks("player", 209858) >= getValue("PoS removes Necrotic") and use.able.phialOfSerenity() then
				if use.phialOfSerenity() then return true end
			end
			-- Arcane Torrent
			if isChecked("Arcane Torrent Dispel") and race == "BloodElf" then
				local torrentUnit = 0
				for i=1, #enemies.yards8 do
					local thisUnit = enemies.yards8[i]
					if canDispel(thisUnit, select(7, GetSpellInfo(GetSpellInfo(69179)))) then
						torrentUnit = torrentUnit + 1
						if torrentUnit >= getOptionValue("Arcane Torrent Dispel") then
							if castSpell("player",racial,false,false,false) then return true end
							break
						end
					end
				end
			end
			-- Lay On Hands
			if isChecked("Lay On Hands") and cast.able.layOnHands() and inCombat and not buff.ardentDefender.exists() then
				-- Player
				if getOptionValue("Lay on Hands Target") == 1 then
					if php <= getValue("Lay On Hands") and not debuff.forbearance.exists("player") then
						if cast.layOnHands("player") then return true end
					end
					-- Target
				elseif getOptionValue("Lay on Hands Target") == 2 then
					if getHP("target") <= getValue("Lay On Hands") and not debuff.forbearance.exists("target") and UnitIsPlayer("target") and GetUnitIsFriend("target","player") then
						if cast.layOnHands("target") then return true end
					end
					-- Mouseover
				elseif getOptionValue("Lay on Hands Target") == 3 then
					if getHP("mouseover") <= getValue("Lay On Hands") and not debuff.forbearance.exists("mouseover") and UnitIsPlayer("mouseover") and GetUnitIsFriend("mouseover","player") then
						if cast.layOnHands("mouseover") then return true end
					end
				elseif getHP(lowestUnit) <= getValue("Lay On Hands") and not debuff.forbearance.exists(lowestUnit) then
					-- Tank
					if getOptionValue("Lay on Hands Target") == 4 then
						if UnitGroupRolesAssigned(lowestUnit) == "TANK" then
							if cast.layOnHands(lowestUnit) then return true end
						end
						-- Healer
					elseif getOptionValue("Lay on Hands Target") == 5 then
						if UnitGroupRolesAssigned(lowestUnit) == "HEALER" then
							if cast.layOnHands(lowestUnit) then return true end
						end
						-- Healer/Tank
					elseif getOptionValue("Lay on Hands Target") == 6 then
						if UnitGroupRolesAssigned(lowestUnit) == "HEALER" or UnitGroupRolesAssigned(lowestUnit) == "TANK" then
							if cast.layOnHands(lowestUnit) then return true end
						end
						-- Healer/Damager
					elseif getOptionValue("Lay on Hands Target") == 7 then
						if UnitGroupRolesAssigned(lowestUnit) == "HEALER" or UnitGroupRolesAssigned(lowestUnit) == "DAMAGER" then
							if cast.layOnHands(lowestUnit) then return true end
						end
						-- Any
					elseif  getOptionValue("Lay on Hands Target") == 8 then
						if cast.layOnHands(lowestUnit) then return true end
					end
				end
			end
			-- Divine Shield
			if isChecked("Divine Shield") and cast.able.divineShield() and not buff.ardentDefender.exists() and not buff.guardianOfAncientKings.exists() and not debuff.forbearance.exists() then
				if php <= getOptionValue("Divine Shield") and inCombat then
					if cast.divineShield() then return true end
				end
			end
			-- Word of Glory
			if php <= getOptionValue("Free Word of Glory") and (buff.divinePurpose.exists() or buff.shiningLight.exists() or buff.royalDecree.exists()) then
				SotR = false
				if cast.wordOfGlory("player") then return true end
			end
			if holyPower > 2 or buff.divinePurpose.exists() or buff.shiningLight.exists() or buff.royalDecree.exists() then
				if isChecked("Word of Glory") and php <= getOptionValue("Word of Glory") then
					SotR = false
					if cast.wordOfGlory("player") then return true end
				end
				if isChecked("Word of Glory - Party") then
					if getHP(lowestUnit) <= getOptionValue("Word of Glory - Party") and not GetUnitIsUnit(lowestUnit,"player") then
						if getOptionValue("WoG - Party Target") == 1 then
							if UnitGroupRolesAssigned(lowestUnit) == "TANK" then
								SotR = false
								if cast.wordOfGlory(lowestUnit) then return true end
							end
						elseif getOptionValue("WoG - Party Target") == 2 then
							if UnitGroupRolesAssigned(lowestUnit) == "HEALER" then
								SotR = false
								if cast.wordOfGlory(lowestUnit) then return true end
							end
						elseif getOptionValue("WoG - Party Target") == 3 then
							if UnitGroupRolesAssigned(lowestUnit) == "TANK" or UnitGroupRolesAssigned(lowestUnit) == "HEALER" then
								SotR = false
								if cast.wordOfGlory(lowestUnit) then return true end
							end
						elseif getOptionValue("WoG - Party Target") == 4 then
							SotR = false
							if cast.wordOfGlory(lowestUnit) then return true end
						end
					end
				end
				if (buff.divinePurpose.exists() and buff.divinePurpose.remain() < gcdMax) or (buff.shiningLight.exists() and buff.shiningLight.remain() < gcdMax) or (buff.royalDecree.exists() and buff.royalDecree.remain() < gcdMax) then
					SotR = false
					if cast.wordOfGlory(lowestUnit) then return true end
				end
			end
			-- Blessing of Protection
			if isChecked("Blessing of Protection") and cast.able.blessingOfProtection() and inCombat and not isBoss("boss1") then
				-- Player
				if getOptionValue("Blessing of Protection Target") == 1 then
					if php <= getValue("Blessing of Protection") and not debuff.forbearance.exists("player") then
						if cast.blessingOfProtection("player") then return true end
					end
					-- Target
				elseif getOptionValue("Blessing of Protection Target") == 2 then
					if getHP("target") <= getValue("Blessing of Protection") and not debuff.forbearance.exists("target") and UnitIsPlayer("target") and GetUnitIsFriend("target","player") then
						if cast.blessingOfProtection("target") then return true end
					end
					-- Mouseover
				elseif getOptionValue("Blessing of Protection Target") == 3 then
					if getHP("mouseover") <= getValue("Blessing of Protection") and not debuff.forbearance.exists("mouseover") and UnitIsPlayer("mouseover") and GetUnitIsFriend("mouseover","player") then
						if cast.blessingOfProtection("mouseover") then return true end
					end
				elseif getHP(lowestUnit) <= getValue("Blessing of Protection") and not debuff.forbearance.exists(lowestUnit) then
					-- Tank
					if getOptionValue("Blessing of Protection Target") == 4 then
						if UnitGroupRolesAssigned(lowestUnit) == "TANK" then
							if cast.blessingOfProtection(lowestUnit) then return true end
						end
						-- Healer
					elseif getOptionValue("Blessing of Protection Target") == 5 then
						if UnitGroupRolesAssigned(lowestUnit) == "HEALER" then
							if cast.blessingOfProtection(lowestUnit) then return true end
						end
						-- Healer/Tank
					elseif getOptionValue("Blessing of Protection Target") == 6 then
						if UnitGroupRolesAssigned(lowestUnit) == "HEALER" or UnitGroupRolesAssigned(lowestUnit) == "TANK" then
							if cast.blessingOfProtection(lowestUnit) then return true end
						end
						-- Healer/Damager
					elseif getOptionValue("Blessing of Protection Target") == 7 then
						if UnitGroupRolesAssigned(lowestUnit) == "HEALER" or UnitGroupRolesAssigned(lowestUnit) == "DAMAGER" then
							if cast.blessingOfProtection(lowestUnit) then return true end
						end
						-- Any
					elseif  getOptionValue("Blessing of Protection Target") == 8 then
						if cast.blessingOfProtection(lowestUnit) then return true end
					end
				end
			end
			-- Blessing Of Sacrifice
			if isChecked("Blessing Of Sacrifice") and cast.able.blessingOfSacrifice() and php >= 50 and inCombat then
				-- Target
				if getOptionValue("Blessing Of Sacrifice Target") == 1 then
					if getHP("target") <= getValue("Blessing Of Sacrifice") and UnitIsPlayer("target") and GetUnitIsFriend("target","player") then
						if cast.blessingOfSacrifice("target") then return true end
					end
					-- Mouseover
				elseif getOptionValue("Blessing Of Sacrifice Target") == 2 then
					if getHP("mouseover") <= getValue("Blessing Of Sacrifice") and UnitIsPlayer("mouseover") and GetUnitIsFriend("mouseover","player") then
						if cast.blessingOfSacrifice("mouseover") then return true end
					end
				elseif getHP(lowestUnit) <= getValue("Blessing Of Sacrifice") and not GetUnitIsUnit(lowestUnit,"player") and not cast.last.blessingOfProtection() then
					-- Tank
					if getOptionValue("Blessing Of Sacrifice Target") == 3 then
						if UnitGroupRolesAssigned(lowestUnit) == "TANK" then
							if cast.blessingOfSacrifice(lowestUnit) then return true end
						end
						-- Healer
					elseif getOptionValue("Blessing Of Sacrifice Target") == 4 then
						if UnitGroupRolesAssigned(lowestUnit) == "HEALER" then
							if cast.blessingOfSacrifice(lowestUnit) then return true end
						end
						-- Healer/Tank
					elseif getOptionValue("Blessing Of Sacrifice Target") == 5 then
						if UnitGroupRolesAssigned(lowestUnit) == "HEALER" or UnitGroupRolesAssigned(lowestUnit) == "TANK" then
							if cast.blessingOfSacrifice(lowestUnit) then return true end
						end
						-- Healer/Damager
					elseif getOptionValue("Blessing Of Sacrifice Target") == 6 then
						if UnitGroupRolesAssigned(lowestUnit) == "HEALER" or UnitGroupRolesAssigned(lowestUnit) == "DAMAGER" then
							if cast.blessingOfSacrifice(lowestUnit) then return true end
						end
						-- Any
					elseif  getOptionValue("Blessing Of Sacrifice Target") == 7 then
						if cast.blessingOfSacrifice(lowestUnit) then return true end
					end
				end
			end
			-- Cleanse Toxins
			if isChecked("Clease Toxin") and cast.able.cleanseToxins() and GetObjectID("boss1") ~= 164267 then
				if getOptionValue("Clease Toxin")==1 then
					if canDispel("player",spell.cleanseToxins) then
						if cast.cleanseToxins("player") then return true end
					end
				elseif getOptionValue("Clease Toxin")==2 then
					if canDispel("target",spell.cleanseToxins) then
						if cast.cleanseToxins("target") then return true end
					end
				elseif getOptionValue("Clease Toxin")==3 then
					if canDispel("player",spell.cleanseToxins) then
						if cast.cleanseToxins("player") then return true end
					elseif canDispel("target",spell.cleanseToxins) then
						if cast.cleanseToxins("target") then return true end
					end
				elseif getOptionValue("Clease Toxin")==4 then
					if canDispel("mouseover",spell.cleanseToxins) then
						if cast.cleanseToxins("mouseover") then return true end
					end
				elseif getOptionValue("Clease Toxin")==5 then
					for i = 1, #br.friend do
						if canDispel(br.friend[i].unit,spell.cleanseToxins) then
							if cast.cleanseToxins(br.friend[i].unit) then return true end
						end
					end
				end
			end
			-- Blinding Light
			if isChecked("Blinding Light - HP") and cast.able.blindingLight() and talent.blindingLight and php <= getOptionValue("Blinding Light - HP") and inCombat and #enemies.yards10 > 0 then
				if cast.blindingLight() then return true end
			end
			if isChecked("Guardian of Ancient Kings") and cast.able.guardianOfAncientKings() then
				if php <= getOptionValue("Guardian of Ancient Kings") and inCombat and not buff.ardentDefender.exists() and not buff.divineShield.exists() then
					if cast.guardianOfAncientKings() then return true end
				end
			end
			-- Ardent Defender
			if isChecked("Ardent Defender") and cast.able.ardentDefender() then
				if (php <= getOptionValue("Ardent Defender") or php <= 10) and inCombat and not buff.guardianOfAncientKings.exists() and not buff.divineShield.exists() then
					if cast.ardentDefender() then return true end
				end
			end
			-- Gift of the Naaru
			if isChecked("Gift of the Naaru") and php <= getOptionValue("Gift of the Naaru") and php > 0 and race == "Draenei" then
				if castSpell("player",racial,false,false,false) then return true end
			end
			-- Hammer of Justice
			if isChecked("Hammer of Justice - HP") and cast.able.hammerOfJustice() and php <= getOptionValue("Hammer of Justice - HP") and inCombat then
				for i = 1, #enemies.yards10 do
					local thisUnit = enemies.yards10[i]
					if not isBoss(thisUnit) and getBuffRemain(thisUnit,226510) == 0 and noStunsUnits[GetObjectID(thisUnit)] == nil then
						if cast.hammerOfJustice(thisUnit) then return true end
					end
				end
			end
			-- Redemption
			if isChecked("Redemption") and not inCombat then
				if getOptionValue("Redemption")==1 and not isMoving("player") and resable and not castingUnit() then
					if cast.redemption("target","dead") then return true end
				end
				if getOptionValue("Redemption")==2 and not isMoving("player") and resable and not castingUnit() then
					if cast.redemption("mouseover","dead") then return true end
				end
			end
			-- Blessing of Freedom
			if isChecked("Blessing of Freedom") and cast.able.blessingOfFreedom() and hasNoControl(spell.blessingOfFreedom) then
				if cast.blessingOfFreedom("player") then return true end
			end
			-- Flash of Light
			if isChecked("Flash of Light") then
				if (forceHeal or (inCombat and php <= getOptionValue("Flash of Light") / 2) or (not inCombat and php <= getOptionValue("Flash of Light"))) and not isMoving("player") then
					if cast.flashOfLight("player") then return true end
				end
			end
			-- Engineering Revive
			if isChecked("Engineering Revive") and canUseItem(184308) and not isMoving("player") and inCombat then
				if getOptionValue("Engineering Revive") == 1 and UnitIsPlayer("target") and UnitIsDeadOrGhost("target") and GetUnitIsFriend("target","player") then
					UseItemByName(184308,"target")
				elseif getOptionValue("Engineering Revive") == 2 and UnitIsPlayer("mouseover") and UnitIsDeadOrGhost("mouseover") and GetUnitIsFriend("mouseover","player") then
					UseItemByName(184308,"mouseover")
				elseif getOptionValue("Engineering Revive") == 3 then
					for i =1, #br.friend do
						if UnitIsPlayer(br.friend[i].unit) and UnitIsDeadOrGhost(br.friend[i].unit) and GetUnitIsFriend(br.friend[i].unit,"player") then
							UseItemByName(184308,br.friend[i].unit)
						end
					end
				end
			end
		end
	end -- End Action List - Defensive
	local function BossEncounterCase()
		if (GetObjectID("target") == 165759 or GetObjectID("target") == 171577 or GetObjectID("target") == 173112) and inCombat then
			if getHP("target") < 100 and (holyPower > 2 or buff.divinePurpose.exists() or buff.shiningLight.exists() or buff.royalDecree.exists()) then
				SotR = false
				if cast.wordOfGlory("target") then return true end
			end
		end
		-- Atal'ai Devoted logic
		if select(8, GetInstanceInfo()) == 2291 then
			for i = 1, #enemies.yards10 do
			local thisUnit = enemies.yards10[i]
				if UnitCastingInfo(thisUnit) == GetSpellInfo(332329) and getCastTimeRemain(thisUnit) ~=0 and getCastTimeRemain(thisUnit) < 2 and getBuffRemain(thisUnit,343503) == 0 then
					if cast.able.hammerOfJustice() then
						if cast.hammerOfJustice(thisUnit) then return true end
					end
					if cast.able.blindingLight() and talent.blindingLight then
						if cast.blindingLight() then return true end
					end
				end
			end
		end
		-- Wicked Gash or Dark Stride
		if cast.able.blessingOfProtection() and not talent.blessingOfSpellwarding then
			for i = 1, #br.friend do
				if getDebuffStacks(br.friend[i].unit,331415) > 1 or getDebuffStacks(br.friend[i].unit,324154) > 1 then
					if cast.blessingOfProtection(br.friend[i].unit) then return true end
				end
			end
		end
		-- Dark Exile
		if UnitCastingInfo("boss1") == GetSpellInfo(321894) and cast.able.blessingOfProtection() and not talent.blessingOfSpellwarding then
			if cast.blessingOfProtection("boss1target") then return true end
		end
		-- Infectious Rain
		if UnitChannelInfo("boss1") ~= GetSpellInfo(331399) and getDebuffRemain("player",331399) ~= 0 and cast.able.cleanseToxins() then
			if cast.cleanseToxins("player") then return true end
		end
		-- Will to
		if race == "Human" and getSpellCD(59752) == 0 and (getDebuffRemain("player",321893) ~= 0 or getDebuffRemain("player",331847) ~= 0 or getDebuffRemain("player",319611) ~= 0) then
			if CastSpellByName(GetSpellInfo(59752)) then return true end
		end
		-- Gloom Squall
		if getBuffRemain("player",324089) ~= 0 then
			for i = 1, #enemies.yards30 do
				local thisUnit = enemies.yards30[i]
				if (GetObjectID(thisUnit) == 162099 or GetObjectID(thisUnit) == 162133) and (UnitCastingInfo(thisUnit) == GetSpellInfo(322903) or UnitCastingInfo(thisUnit) == GetSpellInfo(324103)) then
					RunMacroText("/click ExtraActionButton1")
				end
			end
		end
		-- Hammer of Justice
		if cast.able.hammerOfJustice() then
			for i = 1, #enemies.yards10 do
				local thisUnit = enemies.yards10[i]
				if HoJList[GetObjectID(thisUnit)] ~= nil and getBuffRemain(thisUnit,343503) == 0 then
					if cast.hammerOfJustice(thisUnit) then return true end
				end
				-- Opportunity Strikes
				if UnitChannelInfo(thisUnit) == GetSpellInfo(333540) then
					if cast.hammerOfJustice(thisUnit) then return true end
				end
			end
		end
		-- Divine Toll
		if (GetObjectID("boss1") == 165946 or GetObjectID("boss1") == 164185 or GetObjectID("boss1") == 167406) and cast.able.divineToll() then
			for i = 1, #enemies.yards30 do
			local thisUnit = enemies.yards30[i]
				if GetObjectID(thisUnit) == 166524 or GetObjectID(thisUnit) == 164363 or GetObjectID(thisUnit) == 167999 then
					if cast.divineToll(thisUnit) then return true end
				end
			end
		end
		-- Blessing of Freedom
		if cast.able.blessingOfFreedom() then
			if UnitCastingInfo("boss1") == GetSpellInfo(320788) or UnitCastingInfo("boss1") == GetSpellInfo(324608) then
				BoF = false
				if cast.blessingOfFreedom("boss1target") then return true end
			end
			-- Oppressive Banner
			if (UnitCastingInfo("boss1") == GetSpellInfo(317231) or UnitCastingInfo("boss1") == GetSpellInfo(320729)) and getDebuffRemain("player",331606) ~= 0 then
				if cast.blessingOfFreedom("player") then return true end
			end
			-- Debuff
			local BoFDebuff = {330810,326827,324608,334926,292942,329326,295929,292910}
			for k,v in pairs(BoFDebuff) do
				if getDebuffRemain("player",v) ~= 0 then
					if cast.blessingOfFreedom("player") then return true end
				end
			end
		end
	end
	-- Action List - Cooldowns
	local function actionList_Cooldowns()
		-- Trinkets
		if isChecked("Use Trinkets 1") and canUseItem(13) then
			if getOptionValue("Trinkets 1 Mode") == 1 then
				if (php <= getOptionValue("Trinkets 1") and getOptionValue("Use Trinkets 1") == 1) or (getOptionValue("Use Trinkets 1") == 2 and useCDs()) or getOptionValue("Use Trinkets 1") == 3 then
					useItem(13)
					return true
				end
			elseif getOptionValue("Trinkets 1 Mode") == 2 then
				if (php <= getOptionValue("Trinkets 1") and getOptionValue("Use Trinkets 1") == 1) or (getOptionValue("Use Trinkets 1") == 2 and useCDs()) or getOptionValue("Use Trinkets 1") == 3 then
					if useItemGround("target",13,40,0,nil) then return true end
				end
			end
		end
		if isChecked("Use Trinkets 2") and canUseItem(14) then
			if getOptionValue("Trinkets 2 Mode") == 1 then
				if (php <= getOptionValue("Trinkets 2") and getOptionValue("Use Trinkets 2") == 1) or (getOptionValue("Use Trinkets 2") == 2 and useCDs()) or getOptionValue("Use Trinkets 2") == 3 then
					useItem(14)
					return true
				end
			elseif getOptionValue("Trinkets 2 Mode") == 2 then
				if (php <= getOptionValue("Trinkets 2") and getOptionValue("Use Trinkets 2") == 1) or (getOptionValue("Use Trinkets 2") == 2 and useCDs()) or getOptionValue("Use Trinkets 2") == 3 then
					if useItemGround("target",14,40,0,nil) then return true end
				end
			end
		end
		if useCDs() or burst then
			-- Racials
			if isChecked("Racial") then
				if race == "Orc" or race == "Troll" and getSpellCD(racial) == 0 then
					if castSpell("player",racial,false,false,false) then return true end
				end
			end
			if GetUnitExists(units.dyn5) then
				-- Seraphim
				if isChecked("Seraphim") and talent.seraphim and holyPower > 2 and getOptionValue("Seraphim") <= ttd then
					SotR = false
					if cast.seraphim() then return true end
				end
				-- Avenging Wrath
				if isChecked("Avenging Wrath") and cast.able.avengingWrath() and getOptionValue("Avenging Wrath") <= ttd and not buff.avengingWrath.exists() then
					if cast.avengingWrath() then return true end
				end
				-- Holy Avenger
				if isChecked("Holy Avenger") and cast.able.holyAvenger() and talent.holyAvenger and
					((not isChecked("Holy Avenger with Wings") and getOptionValue("Holy Avenger") <= ttd ) or (isChecked("Holy Avenger with Wings") and getSpellCD(31884) == 0))then
					if cast.holyAvenger() then return true end
				end
			end
		end -- End Cooldown Usage Check
	end -- End Action List - Cooldowns
	-- Action List - Interrupts
	local function actionList_Interrupts()
		if useInterrupts() then
			if isChecked("Avenger's Shield - INT") and cast.able.avengersShield() then
				for i = 1, #enemies.yards30 do
					local thisUnit = enemies.yards30[i]
					if canInterrupt(thisUnit,100) and getFacing("player",thisUnit) then
						if cast.avengersShield(thisUnit) then return true end
					end
				end
			end
			local BL_Unit = 0
			for i = 1, #enemies.yards10 do
				local thisUnit = enemies.yards10[i]
				local distance = getDistance(thisUnit)
				-- Stun Spells
				local interruptID
				if UnitCastingInfo(thisUnit) then
					interruptID = select(9,UnitCastingInfo(thisUnit))
				elseif UnitChannelInfo(thisUnit) then
					interruptID = select(8,UnitChannelInfo(thisUnit))
				end
				if interruptID ~=nil and StunSpellsList[interruptID] and getBuffRemain(thisUnit,343503) == 0 then
					if isChecked("Hammer of Justice - INT") and cast.able.hammerOfJustice() and getBuffRemain(thisUnit,226510) == 0 then
						if cast.hammerOfJustice(thisUnit) then return true end
					end
					if isChecked("Blinding Light - INT") and cast.able.blindingLight() and talent.blindingLight then
						if cast.blindingLight() then return true end
					end
				end
				if canInterrupt(thisUnit,getOptionValue("Interrupt At")) then
					-- Blinding Light
					if isChecked("Blinding Light - INT") and cast.able.blindingLight() and talent.blindingLight and getBuffRemain(thisUnit,343503) == 0 then
						if not isBoss(thisUnit) and noStunsUnits[GetObjectID(thisUnit)] == nil then
							BL_Unit = BL_Unit + 1
							if BL_Unit >= getOptionValue("Blinding Light - INT") then
								if cast.blindingLight() then return true end
							end
						end
					end
					-- Hammer of Justice
					if isChecked("Hammer of Justice - INT") and cast.able.hammerOfJustice() then
						if not isBoss(thisUnit) and getBuffRemain(thisUnit,226510) == 0 and getBuffRemain(thisUnit,343503) == 0 and noStunsUnits[GetObjectID(thisUnit)] == nil then
							if cast.hammerOfJustice(thisUnit) then hoj_unit = thisUnit return true end
						end
					end
					-- Rebuke
					if isChecked("Rebuke - INT") and cast.able.rebuke() and distance <= 5 and getFacing("player",thisUnit) and not GetUnitIsUnit(hoj_unit,thisUnit) then
						if cast.rebuke(thisUnit) then return true end
					end
				end
			end
		end
	end -- End Action List - Interrupts
	-- Action List - Opener
	local function actionList_Opener()
		if isValidUnit("target") and getFacing("player","target") then
			if isChecked("Judgment") and getDistance("target") <= 30 and not inCombat and cast.able.judgment() then
				if cast.judgment("target") then return true end
			end
			-- Start Attack
			if not IsAutoRepeatSpell(GetSpellInfo(6603)) and getDistance("target") <= 5 then
				StartAttack()
			end
		end
	end -- End Action List - Opener
	---------------------
	--- Begin Profile ---
	---------------------
	--Profile Stop | Pause
	if not inCombat and not hastar and profileStop == true then
		profileStop = false
	elseif (inCombat and profileStop == true) or IsFlying() or pause() or mode.rotation == 4 then
		return true
	else
		if actionList_Extras() then return end
		if actionList_Defensive() then return end
		if mode.bossCase == 1 then
			if BossEncounterCase() then return end
		end
		if actionList_Opener() then return end
		if inCombat and (not IsMounted() or buff.divineSteed.exists()) and profileStop==false and BoF == true and not castingUnit() then
			if actionList_Interrupts() then return end
			if actionList_Cooldowns() then return end
			----------------------------------
			--- In Combat - Begin Rotation ---
			----------------------------------
			-- Shield of the Righteous
			if isChecked("Shield of the Righteous") and cast.able.shieldOfTheRighteous() and SotR == true and (holyPower > 2 or buff.divinePurpose.exists())
				and (mode.holyPowerlogic == 1 and (buff.holyAvenger.exists() or debuff.judgment.exists(units.dyn10) or holyPower == 5 or buff.shieldOfTheRighteous.remains("player") < 2))
				or (mode.holyPowerlogic == 2 and holyPower == 5 and (getSpellCD(275779) <= gcdMax or getSpellCD(31935) <= gcdMax or (talent.blessedHammer and getSpellCD(204019) <= gcdMax) or (not talent.blessedHammer and getSpellCD(53595) <= gcdMax) or ((getHP(units.dyn30) <= 20 or buff.avengingWrath.exists()) and getSpellCD(24275) <= gcdMax))) then
				if cast.shieldOfTheRighteous(units.dyn5) then return true end
			end
			local mob30 = GetUnitExists(units.dyn30) and getFacing("player",units.dyn30)
			-- Avenger's Shield
			if isChecked("Avenger's Shield") and cast.able.avengersShield() and #enemies.yards10 >= 3 and mob30 then
				if cast.avengersShield(units.dyn30) then return true end
			end
			-- Divine Toll
			if isChecked("Divine Toll") and cast.able.divineToll() and GetObjectID("boss1") ~= 165946 and GetObjectID("boss1") ~= 164185 then
				if (#enemies.yards10 >= getValue("Divine Toll") or (isBoss(units.dyn30) and GetObjectID("boss1") ~= 167406) or (isBoss(units.dyn30) and GetObjectID("boss1") == 167406 and getHP("boss1") <= 70)) then
					if cast.divineToll(units.dyn30) then return true end
				end
			end
			-- Consecration
			if isChecked("Consecration") and cast.able.consecration() and GetUnitExists(units.dyn5) and not buff.consecration.exists() then
				if cast.consecration() then return true end
			end
			-- Judgment
			if isChecked("Judgment") and cast.able.judgment() and ((talent.crusadersJudgment and charges.judgment.frac() >= 1.99) or not talent.crusadersJudgment or not debuff.judgment.exists(units.dyn30)) and mob30 then
				if cast.judgment(units.dyn30) then return true end
			end
			-- Hammer of Wrath
			if isChecked("Hammer of Wrath") and cast.able.hammerOfWrath() and (getHP(units.dyn30) <= 20 or (level >=58 and buff.avengingWrath.exists()) or getBuffRemain("player", 345693) ~= 0) and mob30 then
				if cast.hammerOfWrath(units.dyn30) then return true end
			end
			-- Avenger's Shield
			if isChecked("Avenger's Shield") and cast.able.avengersShield() and mob30 then
				if cast.avengersShield(units.dyn30) then return true end
			end
			-- Crusader Strike
			if cast.able.crusaderStrike() and level < 14 and getFacing("player",units.dyn5) and GetUnitExists(units.dyn5) then
				if cast.crusaderStrike(units.dyn5) then return true end
			end
			-- Blessed Hammer
			if isChecked("Blessed Hammer") and cast.able.blessedHammer() and talent.blessedHammer and (#enemies.yards5 >= 1 or holyPower < 3 or (charges.blessedHammer.frac() == 3 and holyPower < 5)) then
				if cast.blessedHammer() then return true end
			end
			-- Hammer of the Righteous
			if isChecked("Hammer of the Righteous") and cast.able.hammerOfTheRighteous() and not talent.blessedHammer and getFacing("player",units.dyn5) and GetUnitExists(units.dyn5) then
				if cast.hammerOfTheRighteous(units.dyn5) then return true end
			end
			-- Consecration
			if isChecked("Consecration") and cast.able.consecration() and GetUnitExists(units.dyn5) and consecrationRemain < 5 then
				if cast.consecration() then return true end
			end
		end -- End In Combat
	end -- End Profile
	-- end -- Timer
end -- runRotation
local id = 66
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
name = rotationName,
toggles = createToggles,
options = createOptions,
run = runRotation,
})
