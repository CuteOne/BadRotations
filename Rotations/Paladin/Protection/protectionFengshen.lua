local rotationName = "PrettyBoy"
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
	[1] = { mode = "On", value = 1 , overlay = "BossCase Enabled", tip = "Boss Encounter Case Enabled.", highlight = 1, icon = br.player.spell.shieldOfTheRighteous },
	[2] = { mode = "Off", value = 2 , overlay = "BossCase Disabled", tip = "Boss Encounter Case Disabled.", highlight = 0, icon = br.player.spell.shieldOfTheRighteous }
	};
	CreateButton("BossCase",5,0)
	-- Consecration
	ConsecrationModes = {
	[2] = { mode = "On", value = 1 , overlay = "Consecration Enabled", tip = "There is no limit to cast Consecration", highlight = 1, icon = br.player.spell.consecration },
	[1] = { mode = "Off", value = 2 , overlay = "Consecration Disabled", tip = "Disabled.", highlight = 0, icon = br.player.spell.consecration }
	};
	CreateButton("Consecration",6,0)
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
		-- APL
		br.ui:createDropdownWithout(section, "APL Mode", {"|cffFFFFFFFeng","|cffFFFFFFSim"}, 1, "|cffFFFFFFSet APL Mode to use.")
		-- Blessing of Freedom
		br.ui:createCheckbox(section, "Blessing of Freedom")
		-- Auto cancel Blessing of Protection
		br.ui:createCheckbox(section, "Auto cancel BoP")		
		-- Taunt
		br.ui:createCheckbox(section,"Taunt","|cffFFFFFFAuto Taunt usage.")
		br.ui:checkSectionState(section)
		------------------------
		--- COOLDOWN OPTIONS ---
		------------------------
		section = br.ui:createSection(br.ui.window.profile,  "Cooldowns")
		-- Racial
		br.ui:createCheckbox(section,"Racial")
		-- Trinkets
		br.ui:createSpinner(section, "Trinkets HP",  70,  0,  100,  5,  "Health Percentage to use at")
		br.ui:createDropdownWithout(section, "Trinkets", {"|cff00FF001st Only","|cff00FF002nd Only","|cffFFFF00Both","|cffFF0000None"}, 1, "|cffFFFFFFSelect Trinket Usage.")
		-- Seraphim
		br.ui:createSpinner(section, "Seraphim",  0,  0,  20,  2,  "|cffFFFFFFEnemy TTD")
		-- Avenging Wrath
		br.ui:createSpinner(section, "Avenging Wrath",  0,  0,  200,  5,  "|cffFFFFFFEnemy TTD")
		-- Bastion of Light
		br.ui:createCheckbox(section,"Bastion of Light")
		br.ui:checkSectionState(section)
		-------------------------
		--- DEFENSIVE OPTIONS ---
		-------------------------
		section = br.ui:createSection(br.ui.window.profile, "Defensive")
		-- Healthstone
		br.ui:createSpinner(section, "Pot/Stoned",  30,  0,  100,  5,  "|cffFFFFFFHealth Percentage to use at")
		-- Gift of The Naaru
		if br.player.race == "Draenei" then
			br.ui:createSpinner(section, "Gift of the Naaru",  50,  0,  100,  5,  "|cffFFFFFFHealth Percentage to use at")
		end
		-- Ardent Defender
		br.ui:createSpinner(section, "Ardent Defender",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at")
		-- Blinding Light
		br.ui:createSpinner(section, "Blinding Light - HP", 50, 0, 100, 5, "|cffFFFFFFHealth Percentage to use at")
		br.ui:createSpinner(section, "Blinding Light - AoE", 3, 0, 10, 1, "|cffFFFFFFNumber of Units in 10 Yards to Cast At")
		-- Cleanse Toxin
		br.ui:createDropdown(section, "Clease Toxin", {"|cff00FF00Player Only","|cffFFFF00Selected Target","|cffFF0000Mouseover Target"}, 1, "|ccfFFFFFFTarget to Cast On")
		-- Divine Shield
		br.ui:createSpinner(section, "Divine Shield",  5,  0,  100,  5,  "|cffFFBB00Health Percentage to use at")
		-- Flash of Light
		br.ui:createSpinner(section, "Flash of Light",  50,  0,  100,  5,  "|cffFFBB00Health Percentage to use at")
		-- Guardian of Ancient Kings
		br.ui:createSpinner(section, "Guardian of Ancient Kings",  30,  0,  100,  5,  "|cffFFBB00Health Percentage to use at")
		-- Hammer of Justice
		br.ui:createSpinner(section, "Hammer of Justice - HP",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at")
		-- Light of the Protector
		br.ui:createSpinner(section, "Light of the Protector",  70,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
		-- Hand of the Protector - on others
		br.ui:createSpinner(section, "Hand of the Protector - Party",  40,  0,  100,  5,  "|cffFFBB00Teammate Health Percentage to use at.")
		-- Lay On Hands
		br.ui:createSpinner(section, "Lay On Hands", 20, 0, 100, 5, "","Health Percentage to use at")
		br.ui:createDropdownWithout(section, "Lay on Hands Target", {"|cffFFFFFFPlayer","|cffFFFFFFTarget", "|cffFFFFFFMouseover", "|cffFFFFFFTank", "|cffFFFFFFHealer", "|cffFFFFFFHealer/Tank", "|cffFFFFFFHealer/Damage", "|cffFFFFFFAny"}, 8, "|cffFFFFFFTarget for Lay On Hands")
		-- Blessing of Protection
		br.ui:createSpinner(section, "Blessing of Protection", 30, 0, 100, 5, "","Health Percentage to use at")
		br.ui:createDropdownWithout(section, "Blessing of Protection Target", {"|cffFFFFFFPlayer","|cffFFFFFFTarget", "|cffFFFFFFMouseover", "|cffFFFFFFTank", "|cffFFFFFFHealer", "|cffFFFFFFHealer/Tank", "|cffFFFFFFHealer/Damage", "|cffFFFFFFAny"}, 7, "|cffFFFFFFTarget for Blessing of Protection")
		-- Blessing Of Sacrifice
		br.ui:createSpinner(section, "Blessing Of Sacrifice", 40, 0, 100, 5, "","Health Percentage to use at")
		br.ui:createDropdownWithout(section, "Blessing Of Sacrifice Target", {"|cffFFFFFFTarget", "|cffFFFFFFMouseover", "|cffFFFFFFTank", "|cffFFFFFFHealer", "|cffFFFFFFHealer/Tank", "|cffFFFFFFHealer/Damage", "|cffFFFFFFAny"}, 6, "|cffFFFFFFTarget for Blessing Of Sacrifice")
		-- Shield of the Righteous
		br.ui:createSpinner(section, "Shield of the Righteous - HP", 60, 0 , 100, 5, "|cffFFBB00Health Percentage to use at")
		-- Redemption
		br.ui:createDropdown(section, "Redemption", {"|cffFFFF00Selected Target","|cffFF0000Mouseover Target"}, 1, "|ccfFFFFFFTarget to Cast On")
		br.ui:checkSectionState(section)
		-------------------------
		--- INTERRUPT OPTIONS ---
		-------------------------
		section = br.ui:createSection(br.ui.window.profile, "Interrupts")
		-- Blinding Light
		br.ui:createCheckbox(section, "Blinding Light - INT")
		-- Hammer of Justice
		br.ui:createCheckbox(section, "Hammer of Justice - INT")
		-- Rebuke
		br.ui:createCheckbox(section, "Rebuke - INT")
		-- Avenger's Shield
		br.ui:createCheckbox(section, "Avenger's Shield - INT")
		-- Interrupt Percentage
		br.ui:createSpinner(section,  "Interrupt At",  40,  0,  95,  5,  "|cffFFBB00Cast Percentage to use at.")
		br.ui:checkSectionState(section)
		------------------------
		--- ROTATION OPTIONS ---
		------------------------
		section = br.ui:createSection(br.ui.window.profile, "Rotation Options")
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
		br.ui:checkSectionState(section)
		----------------------
		--- TOGGLE OPTIONS ---
		----------------------
		section = br.ui:createSection(br.ui.window.profile,  "Toggle Keys")
		-- Single/Multi Toggle
		br.ui:createDropdown(section,  "Rotation Mode", br.dropOptions.Toggle,  6)
		--Cooldown Key Toggle
		br.ui:createDropdown(section,  "Cooldown Mode", br.dropOptions.Toggle,  6)
		--Defensive Key Toggle
		br.ui:createDropdown(section,  "Defensive Mode", br.dropOptions.Toggle,  6)
		-- Interrupts Key Toggle
		br.ui:createDropdown(section,  "Interrupt Mode", br.dropOptions.Toggle,  6)
		-- Consecration Key Toggle
		br.ui:createDropdown(section, "Consecration Mode", br.dropOptions.Toggle,  6)
		-- Pause Toggle
		br.ui:createDropdown(section,  "Pause Mode", br.dropOptions.Toggle,  6)
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
	if br.timer:useTimer("debugProtection", math.random(0.1,0.2)) then
		--Print("Running: "..rotationName)
		---------------
		--- Toggles ---
		---------------
		UpdateToggle("Rotation",0.25)
		UpdateToggle("Cooldown",0.25)
		UpdateToggle("Defensive",0.25)
		UpdateToggle("Interrupt",0.25)
		UpdateToggle("BossCase",0.25)
		UpdateToggle("Consecration",0.25)
		br.player.mode.BossCase = br.data.settings[br.selectedSpec].toggles["BossCase"]
		br.player.mode.Consecration = br.data.settings[br.selectedSpec].toggles["Consecration"]
		--- FELL FREE TO EDIT ANYTHING BELOW THIS AREA THIS IS JUST HOW I LIKE TO SETUP MY ROTATIONS ---

		--------------
		--- Locals ---
		--------------
		local artifact      = br.player.artifact
		local buff          = br.player.buff
		local cast          = br.player.cast
		local cd            = br.player.cd
		local charges       = br.player.charges
		local combatTime    = getCombatTime()
		local debuff        = br.player.debuff
		local enemies       = br.player.enemies
		local gcd           = br.player.gcd
		local hastar        = GetObjectExists("target")
		local healPot       = getHealthPot()
		local inCombat      = br.player.inCombat
		local level         = br.player.level
		local inInstance    = br.player.instance=="party"
		local inRaid        = br.player.instance=="raid"
		local lowest        = br.friend[1]
		local mode          = br.player.mode
		local php           = br.player.health
		local race          = br.player.race
		local racial        = br.player.getRacial()
		local resable       = UnitIsPlayer("target") and UnitIsDeadOrGhost("target") and UnitIsFriend("target","player")
		local solo          = GetNumGroupMembers() == 0
		local spell         = br.player.spell
		local talent        = br.player.talent
		local ttd           = getTTD("target")
		local units         = br.player.units

		units.dyn5 = units.get(5,true)
		units.dyn10 = units.get(10)
		units.dyn30 = units.get(30,true)
		enemies.yards5 = enemies.get(5)
		enemies.yards8 = enemies.get(8)
		enemies.yards10 = enemies.get(10)
		enemies.yards30 = enemies.get(30)

		if profileStop == nil then profileStop = false end
		if consecrationCastTime == nil then consecrationCastTime = 0 end
		if consecrationRemain == nil then consecrationRemain = 0 end
		if cast.last.consecration() then consecrationCastTime = GetTime() + 12 end
		if consecrationCastTime > GetTime() then consecrationRemain = consecrationCastTime - GetTime() else consecrationCastTime = 0; consecrationRemain = 0 end
		local lowestUnit
		lowestUnit = "player"
		for i = 1, #br.friend do
			local thisUnit = br.friend[i].unit
			local thisHP = getHP(thisUnit)
			local lowestHP = getHP(lowestUnit)
			if thisHP < lowestHP then
				lowestUnit = thisUnit
			end
		end
		-- Auto cancel Blessing of Protection
		if isChecked("Auto cancel BoP") then
			if buff.blessingOfProtection.exists() then
				if cast.handOfReckoning("target") then return end
			end		
			if buff.blessingOfProtection.exists() and getDebuffRemain("target",62124) <= 0.2 then
				RunMacroText("/cancelAura Blessing of Protection")
			end
		end
		--------------------
		--- Action Lists ---
		--------------------
		-- Action List - Extras
		local function actionList_Extras()
			-- Blessing of Freedom
			if isChecked("Blessing of Freedom") and cast.able.blessingOfFreedom() and hasNoControl(spell.blessingOfFreedom) then
				if cast.blessingOfFreedom("player") then return end
			end
			-- Taunt
			if isChecked("Taunt") and cast.able.handOfReckoning() and inInstance then
				for i = 1, #enemies.yards30 do
					local thisUnit = enemies.yards30[i]
					if UnitThreatSituation("player", thisUnit) ~= nil and UnitThreatSituation("player", thisUnit) <= 2 and UnitAffectingCombat(thisUnit) then
						if cast.handOfReckoning(thisUnit) then return end
					end
				end
			end
		end -- End Action List - Extras
		local function BossEncounterCase()
			local blessingOfFreedomCase = nil
			local blessingOfProtectionCase = nil
			local cleanseToxinsCase = nil
			local cleanseToxinsCase2 = nil
			for i = 1, #br.friend do
				if getDebuffRemain(br.friend[i].unit,264526) ~= 0 then
					blessingOfFreedomCase = br.friend[i].unit
				end
				if getDebuffRemain(br.friend[i].unit,255421) ~= 0 or getDebuffRemain(br.friend[i].unit,256038) ~= 0 then
					blessingOfProtectionCase = br.friend[i].unit
				end
				if (getDebuffRemain(br.friend[i].unit,269686) ~= 0 and UnitGroupRolesAssigned(br.friend[i].unit) == "HEALER") or getDebuffRemain(br.friend[i].unit,257777) ~= 0 then
					cleanseToxinsCase = br.friend[i].unit
				end
				if getDebuffRemain(br.friend[i].unit,261440) >= 2 and #getAllies(br.friend[i].unit,6) <= 1 then
					cleanseToxinsCase2 = br.friend[i].unit
				end
			end
			-- Flash of Light
			if GetObjectID("target") == 133392 and inCombat then
				if getHP("target") < 100 and getBuffRemain("target",274148) == 0 then
					if CastSpellByName(GetSpellInfo(19750),"target") then return end
				end
			end
			-- Hammer of Justice
			if cast.able.hammerOfJustice() then
				for i = 1, #enemies.yards10 do
					local thisUnit = enemies.yards10[i]
					local distance = getDistance(thisUnit)
					if (GetObjectID(thisUnit) == 131009 or GetObjectID(thisUnit) == 134388 or GetObjectID(thisUnit) == 129158) and distance <= 10 then
						if cast.hammerOfJustice(thisUnit) then return end
					end
				end
			end
			-- Blessing of Freedom
			if cast.able.blessingOfFreedom() then
				if getDebuffRemain("player",267899) ~= 0 or getDebuffRemain("player",268896) ~= 0 then
					if cast.blessingOfFreedom("player") then return end
				end
				if blessingOfFreedomCase ~= nil then
					if cast.blessingOfFreedom(blessingOfFreedomCase) then return end
				end
			end
			-- Blessing of Protection
			if blessingOfProtectionCase ~= nil and cast.able.blessingOfProtection() then
				if cast.blessingOfProtection(blessingOfProtectionCase) then return end
			end
			-- Cleanse Toxins
			if cast.able.cleanseToxins() then
				if cleanseToxinsCase ~= nil then
					if cast.cleanseToxins(cleanseToxinsCase) then return end
				end
				if cleanseToxinsCase2 ~= nil then
					if cast.cleanseToxins(cleanseToxinsCase2) then return end
				end
			end	
			-- Shield of the Righteous
			local Debuff={
			--debuff_id
			{255434},
			{265881},
			{264556},
			{270487},
			{274358},
			{270447},
			}
			for i=1 , #Debuff do
				local debuff_id = Debuff[i]
				if getDebuffRemain("player",debuff_id) > 1 and not buff.shieldOfTheRighteous.exists() then
					if cast.shieldOfTheRighteous() then return end
				end
			end
			local Casting={
			--spell_id	, spell_name
			{267899, 'Hindering Cleave'}, -- Shrine of the Storm
			{272457, 'Shockwave'}, -- Underrot
			{260508, 'Crush'}, -- Waycrest Manor
			{249919, 'Skewer'}, -- Atal'Dazar
			{265910, 'Tail Thrash'}, -- King's Rest
			{268586, 'Blade Combo'}, -- King's Rest
			{262277, 'Terrible Thrash'}, -- Fetid Devourer
			{265248, 'Shatter'}, -- Zek'voz
			{273316, 'Bloody Cleave'}, -- Zul, Reborn
			{273282, 'Essence Shear'}, -- Mythrax the Unraveler
			}
			for i=1 , #Casting do
				local spell_id = Casting[i][1]
				local spell_name = Casting[i][2]
				if UnitCastingInfo("target") == GetSpellInfo(spell_id) and not buff.shieldOfTheRighteous.exists() then
					if cast.shieldOfTheRighteous() then Print("damage reduction in advance..."..spell_name) return end
				end
			end
		end
		-- Action List - Defensives
		local function actionList_Defensive()
			if useDefensive() then
				-- Pot/Stoned
				if isChecked("Pot/Stoned") and php <= getOptionValue("Pot/Stoned")
					and inCombat and (hasHealthPot() or hasItem(5512))
					then
					if canUse(5512) then
						useItem(5512)
					elseif canUse(healPot) then
						useItem(healPot)
					end
				end
				-- Divine Shield
				if isChecked("Divine Shield") and cast.able.divineShield() then
					if php <= getOptionValue("Divine Shield") and inCombat then
						if cast.divineShield() then return end
					end
				end
				-- Gift of the Naaru
				if isChecked("Gift of the Naaru") and php <= getOptionValue("Gift of the Naaru") and php > 0 and race == "Draenei" then
					if castSpell("player",racial,false,false,false) then return end
				end
				-- Light of the Protector
				if isChecked("Light of the Protector") and cast.able.lightOfTheProtector() and getHP("player") <= getOptionValue("Light of the Protector") and not talent.handOfTheProtector then
					if cast.lightOfTheProtector() then return end
				elseif isChecked("Light of the Protector") and cast.able.handOfTheProtector() and getHP("player") <= getOptionValue("Light of the Protector") and talent.handOfTheProtector then
					if cast.handOfTheProtector("player") then return end
				end
				-- Hand of the Protector - Others
				if isChecked("Hand of the Protector - Party") and cast.able.handOfTheProtector() and talent.handOfTheProtector then
					if lowest.hp <= getOptionValue("Hand of the Protector - Party") then
						if cast.handOfTheProtector(lowest.unit) then return end
					end
				end
				-- Lay On Hands
				if isChecked("Lay On Hands") and cast.able.layOnHands() and inCombat then
					-- Player
					if getOptionValue("Lay on Hands Target") == 1 then
						if php <= getValue("Lay On Hands") then
							if cast.layOnHands("player") then return true end
						end
						-- Target
					elseif getOptionValue("Lay on Hands Target") == 2 then
						if getHP("target") <= getValue("Lay On Hands") then
							if cast.layOnHands("target") then return true end
						end
						-- Mouseover
					elseif getOptionValue("Lay on Hands Target") == 3 then
						if getHP("mouseover") <= getValue("Lay On Hands") then
							if cast.layOnHands("mouseover") then return true end
						end
					elseif getHP(lowestUnit) <= getValue("Lay On Hands") and UnitInRange(lowestUnit) then
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
				-- Blessing of Protection
				if isChecked("Blessing of Protection") and cast.able.blessingOfProtection() and inCombat and not isBoss("boss1") then
					-- Player
					if getOptionValue("Blessing of Protection Target") == 1 then
						if php <= getValue("Blessing of Protection") then
							if cast.blessingOfProtection("player") then return true end
						end
						-- Target
					elseif getOptionValue("Blessing of Protection Target") == 2 then
						if getHP("target") <= getValue("Blessing of Protection") then
							if cast.blessingOfProtection("target") then return true end
						end
						-- Mouseover
					elseif getOptionValue("Blessing of Protection Target") == 3 then
						if getHP("mouseover") <= getValue("Blessing of Protection") then
							if cast.blessingOfProtection("mouseover") then return true end
						end
					elseif getHP(lowestUnit) <= getValue("Blessing of Protection") and UnitInRange(lowestUnit) then
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
						if getHP("target") <= getValue("Blessing Of Sacrifice") then
							if cast.blessingOfSacrifice("target") then return true end
						end
						-- Mouseover
					elseif getOptionValue("Blessing Of Sacrifice Target") == 2 then
						if getHP("mouseover") <= getValue("Blessing Of Sacrifice") then
							if cast.blessingOfSacrifice("mouseover") then return true end
						end
					elseif getHP(lowestUnit) <= getValue("Blessing Of Sacrifice") and not UnitIsUnit(lowestUnit,"player") and UnitInRange(lowestUnit) then
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
				if isChecked("Clease Toxin") and cast.able.cleanseToxins() then
					if getOptionValue("Clease Toxin")==1 and canDispel("player",spell.cleanseToxins) and getDebuffRemain("player",261440) == 0 then
						if cast.cleanseToxins("player") then return end
					end
					if getOptionValue("Clease Toxin")==2 and canDispel("target",spell.cleanseToxins) then
						if cast.cleanseToxins("target") then return end
					end
					if getOptionValue("Clease Toxin")==3 and canDispel("mouseover",spell.cleanseToxins) then
						if cast.cleanseToxins("mouseover") then return end
					end
				end
				-- Blinding Light
				if isChecked("Blinding Light - HP") and talent.blindingLight and php <= getOptionValue("Blinding Light - HP") and inCombat and #enemies.yards10 > 0 then
					if cast.blindingLight() then return end
				end
				if isChecked("Blinding Light - AoE") and talent.blindingLight and #enemies.yards10 >= getOptionValue("Blinding Light - AoE") and inCombat then
					if cast.blindingLight() then return end
				end
				-- Shield of the Righteous
				if isChecked("Shield of the Righteous - HP") and cast.able.shieldOfTheRighteous() then
					if php <= getOptionValue("Shield of the Righteous - HP") and inCombat and not buff.shieldOfTheRighteous.exists() then
						if cast.shieldOfTheRighteous() then return end
					end
				end
				-- Guardian of Ancient Kings
				if isChecked("Guardian of Ancient Kings") and cast.able.guardianOfAncientKings() then
					if php <= getOptionValue("Guardian of Ancient Kings") and inCombat and not buff.ardentDefender.exists() and not buff.divineShield.exists() then
						if cast.guardianOfAncientKings() then return end
					end
				end
				-- Ardent Defender
				if isChecked("Ardent Defender") and cast.able.ardentDefender() then
					if (php <= getOptionValue("Ardent Defender") or php <= 10) and inCombat and not buff.guardianOfAncientKings.exists() then
						if cast.ardentDefender() then return end
					end
				end
				-- Gift of the Naaru
				if isChecked("Gift of the Naaru") and php <= getOptionValue("Gift of the Naaru") and php > 0 and race == "Draenei" then
					if castSpell("player",racial,false,false,false) then return end
				end
				-- Hammer of Justice
				if isChecked("Hammer of Justice - HP") and php <= getOptionValue("Hammer of Justice - HP") and inCombat and not isBoss(units.dyn10) then
					if cast.hammerOfJustice(units.dyn10) then return end
				end
				-- Flash of Light
				if isChecked("Flash of Light") then
					if (forceHeal or (inCombat and php <= getOptionValue("Flash of Light") / 2) or (not inCombat and php <= getOptionValue("Flash of Light"))) and not isMoving("player") then
						if cast.flashOfLight() then return end
					end
				end
				-- Redemption
				if isChecked("Redemption") and not inCombat then
					if getOptionValue("Redemption")==1 and not isMoving("player") and resable then
						if cast.redemption("target","dead") then return end
					end
					if getOptionValue("Redemption")==2 and not isMoving("player") and resable then
						if cast.redemption("mouseover","dead") then return end
					end
				end
			end
		end -- End Action List - Defensive
		-- Action List - Cooldowns
		local function actionList_Cooldowns()
			if useCDs() or burst then
				-- Trinkets
				if isChecked("Trinkets HP") and php <= getOptionValue("Trinkets HP") then
					if (getOptionValue("Trinkets") == 1 or getOptionValue("Trinkets") == 3) and canUse(13) then
						useItem(13)
					end
					if (getOptionValue("Trinkets") == 2 or getOptionValue("Trinkets") == 3) and canUse(14) then
						useItem(14)
					end
				end
				-- Racials
				if isChecked("Racial") then
					if race == "Orc" or race == "Troll" and getSpellCD(racial) == 0 then
						if castSpell("player",racial,false,false,false) then return end
					end
				end
				if getDistance(units.dyn5) <= 5 then
					-- Seraphim
					if isChecked("Seraphim") and cast.able.seraphim() and talent.seraphim and charges.shieldOfTheRighteous.frac() >= 1.99 and (getOptionValue("Seraphim") <= ttd ) then
						if cast.seraphim() then return end
					end
					-- Avenging Wrath
					if isChecked("Avenging Wrath") and cast.able.avengingWrath() and (not talent.seraphim or buff.seraphim.remain() > 15) and (getOptionValue("Avenging Wrath") <= ttd ) then
						if cast.avengingWrath() then return end
					end
					-- Bastion of Light
					if isChecked("Bastion of Light") and cast.able.bastionOfLight() and talent.bastionOfLight and (charges.shieldOfTheRighteous.frac() < 0.2) and (not talent.seraphim or buff.seraphim.exists()) then
						if cast.bastionOfLight() then return end
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
						local distance = getDistance(thisUnit)
						if canInterrupt(thisUnit,95) then
							if distance <= 30 and getFacing("player",thisUnit) then
								if CastSpellByName(GetSpellInfo(31935),thisUnit) then return end
							end
						end
					end
				end
				for i = 1, #enemies.yards10 do
					local thisUnit = enemies.yards10[i]
					local distance = getDistance(thisUnit)
					if canInterrupt(thisUnit,getOptionValue("Interrupt At")) then
						-- Hammer of Justice
						if isChecked("Hammer of Justice - INT") and cast.able.hammerOfJustice() and distance <= 10 and not isBoss(thisUnit) then
							if cast.hammerOfJustice(thisUnit) then return end
						end
						-- Rebuke
						if isChecked("Rebuke - INT") and cast.able.rebuke() and distance <= 5 then
							if cast.rebuke(thisUnit) then return end
						end
						-- Blinding Light
						if isChecked("Blinding Light - INT") and cast.able.blindingLight() and talent.blindingLight and distance <= 10 then
							if cast.blindingLight() then return end
						end
					end
				end
			end
		end -- End Action List - Interrupts
		-- Action List - PreCombat
		local function actionList_PreCombat()
			-- PreCombat abilities listed here
		end -- End Action List - PreCombat
		-- Action List - Opener
		local function actionList_Opener()
			if isValidUnit("target") then
				if isChecked("Judgment") and getDistance("target") <= 30 and getFacing("player","target") then
					if cast.judgment("target") then return end
				end
				-- Start Attack
				if getDistance("target") <= 5 then
					StartAttack("target")
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
			-----------------------
			--- Extras Rotation ---
			-----------------------
			if actionList_Extras() then return end
			---------------------------
			--- Boss Encounter Case ---
			---------------------------
			if br.player.mode.BossCase == 1 then
				if BossEncounterCase() then return end
			end
			--------------------------
			--- Defensive Rotation ---
			--------------------------
			if actionList_Defensive() then return end
			------------------------------
			--- Out of Combat Rotation ---
			------------------------------
			if actionList_PreCombat() then return end
			----------------------------
			--- Out of Combat Opener ---
			----------------------------
			if actionList_Opener() then return end
			--------------------------
			--- In Combat Rotation ---
			--------------------------
			if inCombat and not (IsMounted() or buff.divineSteed.exists()) and profileStop==false then
				------------------------------
				--- In Combat - Interrupts ---
				------------------------------
				if actionList_Interrupts() then return end
				-----------------------------
				--- In Combat - Cooldowns ---
				-----------------------------
				if actionList_Cooldowns() then return end
				----------------------------------
				--- In Combat - Begin Rotation ---
				----------------------------------
				--------------------------------
				----- In Combat - Feng APL -----
				--------------------------------
				if getOptionValue("APL Mode") == 1 then
					-- Shield of the Righteous
					if isChecked("Shield of the Righteous") and cast.able.shieldOfTheRighteous() and ((charges.shieldOfTheRighteous.frac() >= 2 and buff.avengersValor.exists()) or (charges.shieldOfTheRighteous.frac() == 3 and not buff.shieldOfTheRighteous.exists())) and getDistance(units.dyn5) <= 5 then
						if CastSpellByName(GetSpellInfo(53600)) then return end
					end
					if getDistance(units.dyn30) <= 30 and getFacing("player",units.dyn30) then
						-- Judgment
						if isChecked("Judgment") and cast.able.judgment() then
							if cast.judgment() then return end
						end
						-- Avenger's Shield
						if isChecked("Avenger's Shield") and cast.able.avengersShield() then
							if CastSpellByName(GetSpellInfo(31935)) then return end
						end
					end
					-- Consecration
					if isChecked("Consecration") and cast.able.consecration() and (#enemies.yards5 >= 1 or br.player.mode.Consecration == 2) and not buff.consecration.exists() then
						if cast.consecration() then return end
					end
					-- Blessed Hammer
					if isChecked("Blessed Hammer") and cast.able.blessedHammer() and talent.blessedHammer and #enemies.yards5 >= 1 then
						if cast.blessedHammer() then return end
					end
					-- Hammer of the Righteous
					if isChecked("Hammer of the Righteous") and cast.able.hammerOfTheRighteous() and not talent.blessedHammer and getFacing("player",units.dyn5) and getDistance(units.dyn5) <= 5 then
						if cast.hammerOfTheRighteous() then return end
					end
				end
				--------------------------------
				--- In Combat - SimCraft APL ---
				--------------------------------
				if getOptionValue("APL Mode") == 2 then
					if isChecked("Shield of the Righteous") and getDistance(units.dyn5) <= 5 and getFacing("player",units.dyn5) then
						--actions+=/shield_of_the_righteous,if=(buff.avengers_valor.up&cooldown.shield_of_the_righteous.charges_fractional>=2.5)&(cooldown.seraphim.remains>gcd|!talent.seraphim.enabled)
						if cast.able.shieldOfTheRighteous() and ((buff.avengersValor.exists() and charges.shieldOfTheRighteous.frac()>=2.5) and (cd.seraphim.remain()>gcd or not talent.seraphim)) then
							if cast.shieldOfTheRighteous() then return end
						end
						--actions+=/shield_of_the_righteous,if=(cooldown.shield_of_the_righteous.charges_fractional=3&cooldown.avenger_shield.remains>(2*gcd))
						if cast.able.shieldOfTheRighteous() and ((charges.shieldOfTheRighteous.frac()==3 and cd.avengersShield.remain()>(2*gcd))) then
							if cast.shieldOfTheRighteous() then return end
						end
						--actions+=/shield_of_the_righteous,if=(buff.avenging_wrath.up&!talent.seraphim.enabled)|buff.seraphim.up&buff.avengers_valor.up
						if cast.able.shieldOfTheRighteous() and ((buff.avengingWrath.exists() and not talent.seraphim) or buff.seraphim.exists() and buff.avengersValor.exists()) then
							if cast.shieldOfTheRighteous() then return end
						end
						--actions+=/shield_of_the_righteous,if=(buff.avenging_wrath.up&buff.avenging_wrath.remains<4&!talent.seraphim.enabled)|(buff.seraphim.remains<4&buff.seraphim.up)
						if cast.able.shieldOfTheRighteous() and ((buff.avengingWrath.exists() and buff.avengingWrath.remain()<4 and not talent.seraphim) or (buff.seraphim.remain()<4 and buff.seraphim.exists())) then
							if cast.shieldOfTheRighteous() then return end
						end
					end
					--actions+=/use_items,if=buff.seraphim.up|!talent.seraphim.enabled
					--TODO: parsing use_items
					--actions+=/lights_judgment,if=buff.seraphim.up&buff.seraphim.remains<3
					if isChecked("Racial") and cast.able.racial() and buff.seraphim.exists() and buff.seraphim.remain()<3 and race == "LightforgedDraenei" then
						if cast.racial() then return end
					end
					if getDistance(units.dyn30) <= 30 and getFacing("player",units.dyn30) then
						--actions+=/avengers_shield,if=((cooldown.shield_of_the_righteous.charges_fractional>2.5&!buff.avengers_valor.up)|active_enemies>=2)&cooldown_react
						if isChecked("Avenger's Shield") and cast.able.avengersShield() and (((charges.shieldOfTheRighteous.frac()>2.5 and not buff.avengersValor.exists()) or #enemies.yards8>=2) and cd.avengersShield.remain() == 0) then
							if cast.avengersShield() then return end
						end
						--actions+=/judgment,if=(cooldown.judgment.remains<gcd&cooldown.judgment.charges_fractional>1&cooldown_react)|!talent.crusaders_judgment.enabled
						if isChecked("Judgment") and cast.able.judgment() and ((cd.judgment.remain()<gcd and charges.judgment.frac()>1 and cd.judgment.remain() == 0) or not talent.crusadersJudgment) then
							if cast.judgment() then return end
						end
						--actions+=/avengers_shield,,if=cooldown_react
						if isChecked("Avenger's Shield") and cast.able.avengersShield() and cd.avengersShield.remain() == 0 then
							if cast.avengersShield() then return end
						end
					end
					if isChecked("Consecration") and #enemies.yards8>=1 then
					--actions+=/consecration,if=(cooldown.judgment.remains<=gcd&!talent.crusaders_judgment.enabled)|cooldown.avenger_shield.remains<=gcd&consecration.remains<gcd
						if cast.able.consecration() and ((cd.judgment.remain()<=gcd and not talent.crusadersJudgment) or cd.avengersShield.remain()<=gcd and consecrationRemain<gcd) then
							if cast.consecration() then return end
						end
					--actions+=/consecration,if=!talent.crusaders_judgment.enabled&consecration.remains<(cooldown.judgment.remains+cooldown.avengers_shield.remains)&consecration.remains<3*gcd
						if cast.able.consecration() and (not talent.crusadersJudgment and consecrationRemain<(cd.judgment.remain()+cd.avengersShield.remain()) and consecrationRemain<3*gcd) then
							if cast.consecration() then return end
						end
					end
					--actions+=/judgment,if=cooldown_react|!talent.crusaders_judgment.enabled
					if isChecked("Judgment") and cast.able.judgment() and (cd.judgment.remain() == 0 or not talent.crusadersJudgment) and getDistance(units.dyn30) <= 30 and getFacing("player",units.dyn30) then
						if cast.judgment() then return end
					end
					--actions+=/lights_judgment,if=!talent.seraphim.enabled|buff.seraphim.up
					if isChecked("Racial") and cast.able.racial() and (not talent.seraphim or buff.seraphim.exists()) and race == "LightforgedDraenei" then
						if cast.racial() then return end
					end
					if #enemies.yards5 >= 1 and getFacing("player",units.dyn5) then
						--actions+=/blessed_hammer
						if isChecked("Blessed Hammer") and cast.able.blessedHammer() then
							if cast.blessedHammer() then return end
						end
						--actions+=/hammer_of_the_righteous
						if isChecked("Hammer of the Righteous") and cast.able.hammerOfTheRighteous() then
							if cast.hammerOfTheRighteous() then return end
						end
					end
				end
			end -- End In Combat
		end -- End Profile
	end -- Timer
end -- runRotation
local id = 66
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
name = rotationName,
toggles = createToggles,
options = createOptions,
run = runRotation,
})
