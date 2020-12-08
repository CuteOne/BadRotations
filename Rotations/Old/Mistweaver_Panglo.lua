local rotationName = "Panglo"

if rotationName == "Panglo" then
	ticker = C_Timer.NewTicker(1, function()
		local start, duration, enabled, modRate = GetSpellCooldown(191837)
		if upwellingStacksPanglo == nil then upwellingStacksPanglo = 0 end
		if br.player.talent.upwelling then
			if duration <= 4 and upwellingStacksPanglo <= 18 then
				--print(upwellingStacksPanglo)
				upwellingStacksPanglo = upwellingStacksPanglo + 1
			end
			if duration >= 5 then
				--print("reset")
				upwellingStacksPanglo = 0
			end
		end
	end)
end

local function createToggles() -- Define custom toggles
-- Rotation Button
RotationModes = {
	[1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "/reload to avoid upwelling timer issues", highlight = 1, icon = br.player.spell.spinningCraneKick },
	[2] = { mode = "Off", value = 2 , overlay = "Automatic Rotation Off", tip = "Rotation will not run", highlight = 0, icon = br.player.spell.effuse}
};
CreateButton("Rotation",1,0)
-- Cooldown Button
CooldownModes = {
	[1] = {  mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns will be used.", highlight = 1, icon = br.player.spell.revival },
	[2] = {  mode = "Off", value = 2 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.revival }	
};
CreateButton("Cooldown",2,0)
-- Defensive Button
DefensiveModes = {
	[1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.dampenHarm },
	[2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.dampenHarm }
};
CreateButton("Defensive",3,0)
-- Interrupt Button
InterruptModes = {
	[1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.legSweep },
	[2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.legSweep }
};
CreateButton("Interrupt",4,0)
--Detox Button
DetoxModes = {
	[1] = { mode = "On", value = 1 , overlay = "Detox Enabled", tip = "Detox Enabled", highlight = 1, icon = br.player.spell.detox },
	[2] = { mode = "Off", value = 2 , overlay = "Detox Disabled", tip = "Detox Disabled", highlight = 0, icon = br.player.spell.detox }
};
CreateButton("Detox",5,0)
-- DPS Button
DPSModes = {
	[1] = { mode = "On", value = 1 , overlay = "DPS Enabled", tip = "DPS Enabled", highlight = 1, icon = br.player.spell.blackoutKick },
	[2] = { mode = "Off", value = 2 , overlay = "DPS Disabled", tip = "DPS Disabled", highlight = 0, icon = br.player.spell.soothingMist }
};
CreateButton("DPS",6,0)
end

local function createOptions()
	local optionTable

	local function rotationOptions()
		-----------------------
		--- GENERAL OPTIONS --- -- Define General Options
		-----------------------
		section = br.ui:createSection(br.ui.window.profile,  "General")
		--Boss Helper
		br.ui:createCheckbox(section, "Boss Helper", "Literally just catches a pig in freehold")
		--Temple of Seth
		br.ui:createCheckbox(section, "Temple of Sethraliss Logic","Will heal the NPC when manually selected")
		--Soothing Mist Instant Cast
		br.ui:createCheckbox(section, "Soothing Mist Instant Cast","Will always try to use Soothing Mist before casting EM to utilize Instant Casts.")
		--OOC Healing
		br.ui:createSpinner(section, "OOC Healing",  95,  0,  100,  5,  "Health Percent to Cast At")
		br.ui:createDropdown(section,"Ham Sandwich (Single)", br.dropOptions.Toggle, 6, "Keeps your target alive!")
		-- br.ui:createDropdown(section,"Ham Sandwich (AoE)", br.dropOptions.Toggle, 6, "Keeps your Party alive!")
		br.ui:checkSectionState(section)
		------------------------
		--- Cooldown OPTIONS ---
		------------------------
		section = br.ui:createSection(br.ui.window.profile,  "Cooldowns")
		-- Surging Mists
		br.ui:createSpinnerWithout(section, "Surging Mist", 30, 0 , 100, 5)
        --Mana Tea
		br.ui:createSpinner(section, "Mana Tea",  70,  0,  100,  5, "Mana Percent to Cast At")
		--Thunder Focus Tea
		br.ui:createSpinner(section, "Thunder Focus Tea",  75,  0,  100,  5,  "Use Thunder Focus Tea when someone is below this health percent")
		br.ui:createDropdownWithout(section, "Thunder Focus Tea Options", {"Enveloping Mist","Renewing Mists","Vivify"}, 3, "Select TFT Usage")
		br.ui:createSpinnerWithout(section, "TFT EM",  75,  0,  100,  5,  "Cast EM with TFT at health percent")
		br.ui:createSpinnerWithout(section, "TFT RM",  85,  0,  100,  5,  "Cast RM with TFT at health percent")
		br.ui:createSpinnerWithout(section, "TFT Vivify",  85,  0,  100,  5,  "Cast Vivify with TFT at health percent")
		-- Revival
		br.ui:createSpinner(section, "Revival",  60,  0,  100,  5,  "Health Percent to Cast At")
		br.ui:createSpinnerWithout(section, "Revival Targets",  5,  0,  40,  1,  "Minimum Revival Targets")
		--ChiJI
		br.ui:createSpinner(section, "Chi Ji",  80,  0,  100,  5,  "Health Percent to Cast At")
		br.ui:createSpinnerWithout(section, "Chi Ji Targets",  5,  0,  40,  1,  "Minimum Revival Targets")
		--Trinket
		br.ui:createCheckbox(section, "Use Trinkets With Values below")
		br.ui:createSpinnerWithout(section,"Use Trinket 1", 50, 0, 100, 5, "Trinket in slot 1 when lowest unit below value")
        br.ui:createSpinnerWithout(section,"Use Trinket 2", 50, 0, 100, 5, "Trinket in slot 1 when lowest unit below value")
        --Special Trinket Cases
        br.ui:createSpinner(section,"Revitalizing Voodoo Totem", 80, 0, 100, 1, "Uses this Trinket when Tank's HP Falls below this set.")
		br.ui:createSpinner(section,"Use Inoculating Extract", 50, 0, 100, 5, "Place Trinket in slot 1 to use")
		br.ui:createDropdownWithout(section, "Target for Inoculating Extract", {"Any", "Tank"}, 1)
		br.ui:checkSectionState(section)
		-------------------------
		--- Defensive Options ---
		-------------------------
		section = br.ui:createSection(br.ui.window.profile,  "Defensive Options")
		--Healing Elixir
		br.ui:createSpinner(section, "Healing Elixir",  45,  0,  100,  5,  "Health Percent to Cast At")
		--Dampen Harm / Diffuse Magic
		br.ui:createSpinner(section, "Dampen Harm / Diffuse Magic",  35,  0,  100,  5,  "Health Percent to Cast At")
		br.ui:createSpinner(section, "Healthstone",  30,  0,  100,  5,  "Health Percent to Cast At")
		br.ui:createSpinner(section, "Fortifying Brew",  40,  0,  100,  1,  "Enables FB", "Health Percent to Cast At")
		br.ui:checkSectionState(section)
		-------------------------
		--- INTERRUPT OPTIONS ---
		-------------------------
		section = br.ui:createSection(br.ui.window.profile, "Interrupts")
		--Quaking Palm
		br.ui:createCheckbox(section, "Quaking Palm")
		-- Paralysis
		br.ui:createCheckbox(section, "Paralysis")
		-- Leg Sweep
		br.ui:createCheckbox(section, "Leg Sweep")
		-- Interrupt Percentage
		br.ui:createSpinner(section,  "InterruptAt",  0,  0,  95,  5,  "|cffFFBB00Cast Percentage to use at.")
		br.ui:checkSectionState(section)
		-------------------------
		---- SINGLE TARGET ------
		-------------------------
		section = br.ui:createSection(br.ui.window.profile, "Single Target Healing")
		--Life Cocoon
		br.ui:createSpinner(section, "Life Cocoon",  30,  0,  100,  5,  "Health Percent to Cast At")
		--br.ui:createDropdownWithout(section, "Life Cocoon Mode", {"|cffFFFFFFTanks","|cffFFFFFFEveryone"}, 1, "|cffFFFFFFLife Cocoon usage.")
		--Soothing Mist
		br.ui:createSpinner(section, "Soothing Mist",  85,  0,  100,  5,  "Health Percent to Cast At")
		--Renewing Mist
		br.ui:createSpinner(section, "Renewing Mist",  99,  0,  100,  1,  "Health Percent to Cast At")
		--Enveloping Mist
		br.ui:createSpinner(section, "Enveloping Mist",  70,  0,  100,  5,  "Health Percent to Cast At")
		--Enveloping Mist Tanks
		br.ui:createCheckbox(section, "EM Tanks Only","Only Cast Enveloping Mist on Tanks. Excludes TFT Usage.")
		--Vivify
		br.ui:createSpinner(section, "Vivify",  60,  0,  100,  5,  "Health Percent to Cast At")
		--Jade Statue
		br.ui:createDropdown(section, "Summon Jade Serpent", {"Player","Target","Tank"}, 3,"Enables Use of Summon Jade Serpent.", "Use Summon Jade Serpent at location of.")
		br.ui:checkSectionState(section)
		-------------------------
		------ Life Cycles ------
		-------------------------
		section = br.ui:createSection(br.ui.window.profile, "Lifecycles Options")
		--Enveloping Mist Lifecycles
		br.ui:createSpinnerWithout(section, "Enveloping Mist Lifecycles",  70,  0,  100,  5,  "Health Percent to Cast At")
		--Vivify Lifecycles
		br.ui:createSpinnerWithout(section, "Vivify Lifecycles",  60,  0,  100,  5,  "Health Percent to Cast At")
		br.ui:checkSectionState(section)
		-------------------------
		------ AOE HEALING ------
		-------------------------
		section = br.ui:createSection(br.ui.window.profile, "AOE Healing")
		--Refreshing Jade Wind
		br.ui:createSpinner(section, "Refreshing Jade Wind",  95,  0,  100,  5,  "Health Percent to Cast At")
		-- Essence Font
		br.ui:createSpinner(section, "Essence Font",  80,  0,  100,  5,  "Health Percent to Cast At")
		br.ui:createSpinnerWithout(section, "EF Targets",  6,  0,  40,  1,  "Minimum Essence Font Targets")
		br.ui:createSpinnerWithout(section, "EF Minimum Mana",  40,  0,  100,  5,  "Minimum Mana to cast")
		br.ui:createSpinner(section, "Essence Font Upwelling", 18, 1, 18, 5, "Will wait until we are at this many stacks of EF before casting.")
		--chi burst
		br.ui:createSpinner(section,"Chi Burst Units", 3, 0, 15, 1)
		br.ui:createSpinnerWithout(section, "Chi Burst HP", 70, 0, 100, 5)
		br.ui:checkSectionState(section)
		-------------------------
		------ DPS Options ------
		-------------------------
		section = br.ui:createSection(br.ui.window.profile, "DPS Options")
		br.ui:createSpinnerWithout(section, "DPS Mode",  90,  0,  100,  5,  "Will DPS if in range and Lowest HP of Party is above threshold")
		br.ui:createCheckbox(section, "Crackling Jade Lightning","Enables".."/".."Disables ".."the use of Crackling Jade Lightning.")
		br.ui:createCheckbox(section, "Rising Sun Kick", "Enables".."/".."Disables ".." use of Rising Sun Kick on DPS rotation")
		br.ui:createCheckbox(section, "Spinning Crane Kick", "Enables".."/".."Disables ".." use of Spinning Crane Kick on DPS rotation")
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
	if br.timer:useTimer("debugMistweaver", 0.1) then 
		---------------
		--- Toggles ---
		---------------
		UpdateToggle("Rotation",0.25)
		UpdateToggle("Cooldown",0.25)
		UpdateToggle("Defensive",0.25)
		UpdateToggle("Interrupt",0.25)
		UpdateToggle("Detox",0.25)
		UpdateToggle("DPS",0.25)
		br.player.ui.mode.detox = br.data.settings[br.selectedSpec].toggles["Detox"]
		br.player.ui.mode.dps = br.data.settings[br.selectedSpec].toggles["DPS"]
		--------------
		--- Locals ---
		--------------
		local artifact                                      = br.player.artifact
		local buff                                          = br.player.buff
		local cast                                          = br.player.cast
		local combatTime                                    = getCombatTime()
		local cd                                            = br.player.cd
		local charges                                       = br.player.charges
		local debuff                                        = br.player.debuff
		local enemies                                       = br.player.enemies
		local falling, swimming, flying, moving             = getFallTime(), IsSwimming(), IsFlying(), GetUnitSpeed("player")>0
		local gcd                                           = br.player.gcd
		local healPot                                       = getHealthPot()
		local inCombat                                      = br.player.inCombat
		local inInstance                                    = br.player.instance=="party"
		local inRaid                                        = br.player.instance=="raid"
		local level                                         = br.player.level
		local lowestHP                                      = br.friend[1].unit
		local mana                                          = br.player.power.mana.percent()
		local mode                                          = br.player.ui.mode
		local perk                                          = br.player.perk
		local php                                           = br.player.health
		local power, powmax, powgen                         = br.player.power.mana.amount(), br.player.power.mana.max(), br.player.power.mana.regen()
		local pullTimer                                     = br.DBM:getPulltimer()
		local race                                          = br.player.race
		local racial                                        = br.player.getRacial()
		local spell                                         = br.player.spell
		local talent                                        = br.player.talent
		local ttm                                           = br.player.power.mana.ttm()
		local units                                         = br.player.units
		local lowest                                        = {}    --Lowest Unit
		lowest.hp                                           = br.friend[1].hp
		lowest.role                                         = br.friend[1].role
		lowest.unit                                         = br.friend[1].unit
		lowest.range                                        = br.friend[1].range
		lowest.guid                                         = br.friend[1].guid
		local tank                                          = {}    --Tank
		local averageHealth                                 = 100
		local JSF											= 0
		local detox                                   	    = 0
		local enemies                                       = br.player.enemies
		local lastSpell                                     = lastSpellCast
		local resable                                       = UnitIsPlayer("target") and UnitIsDeadOrGhost("target") and GetUnitIsFriend("target","player")
		local mode                                          = br.player.ui.mode
		local pullTimer                                     = br.DBM:getPulltimer()
		local units                                         = br.player.units
		local tanks                                         = getTanksTable()
		if leftCombat == nil then leftCombat = GetTime() end
		if profileStop == nil then profileStop = false end		
		units.dyn5 = units.get(5)
		units.dyn8 = units.get(8)
		units.dyn15 = units.get(15)
		units.dyn30 = units.get(30)
		units.dyn40 = units.get(40)
		units.dyn5AoE = units.get(5,true)
		units.dyn30AoE = units.get(30,true)
		units.dyn40AoE = units.get(40,true)
		enemies.yards5 = enemies.get(5)
		enemies.yards8 = enemies.get(8)
		enemies.yards10 = enemies.get(10)
		enemies.yards15 = enemies.get(15)
		enemies.yards20 = enemies.get(20)
		enemies.yards30 = enemies.get(30)
		enemies.yards40 = enemies.get(40)

		--wipe timers table
		if timersTable then
			wipe(timersTable)
		end



		---Making Lunch
		if SpecificToggle("Ham Sandwich (Single)") and GetUnitExists("mouseover") then
			local hamName = UnitName("mouseover")
			local msg = "Saving your ass " .. hamName

			if getBuffRemain("mouseover", spell.soothingMist, "EXACT") == 0 and not isMoving("player") then
				if cast.soothingMist("mouseover") then return end
			end
			if getBuffRemain("mouseover", spell.soothingMist, "EXACT") > 1 and getBuffRemain("mouseover", spell.envelopingMist, "player") < 2 then
				if cast.envelopingMist("mouseover") then return end
			end
			if getBuffRemain("mouseover", spell.envelopingMist, "player") >= 2 then
				if cast.vivify("mouseover") then 
				--SendChatMessage(msg,"YELL",nil,hamName) 
				return end
			end
		end
		-- ---Making Lunch
		-- if SpecificToggle("Ham Sandwich (AoE)") then
		-- 	for i = 1, #br.friend do
		-- 		if getBuffRemain("target", spell.soothingMist, "EXACT") == 0 and not isMoving("player") then
		-- 			if cast.soothingMist("target") then return end
		-- 		end

		-- 		if getBuffRemain("target", spell.soothingMist, "EXACT") > 1 and getBuffRemain("target", spell.envelopingMist, "player") < 2 then
		-- 			if cast.envelopingMist("target") then return end
		-- 		end

		-- 		if getBuffRemain("target", spell.envelopingMist, "player") >= 2 then
		-- 			if cast.vivify("target") then return end
		-- 		end
		-- 	end
		-- end
		--------------------
		--- Action Lists ---
		--------------------
		local function actionlist_Interrupts()
			if useInterrupts() then
				for i=1, #enemies.yards20 do
					thisUnit = enemies.yards20[i]
					distance = getDistance(thisUnit)
					if canInterrupt(thisUnit,getOptionValue("InterruptAt")) then
							-- Quaking Palm
							if isChecked("Quaking Palm") and not isCastingSpell(spell.essenceFont) then
								if cast.quakingPalm(thisUnit) then return end
							end
							-- Leg Sweep
							if isChecked("Leg Sweep") and not isCastingSpell(spell.essenceFont) then
								if cast.legSweep(thisUnit) then return end
							end
						
						-- Paralysis
						if isChecked("Paralysis") and not isCastingSpell(spell.essenceFont) then
							if cast.paralysis(thisUnit) then return end
						end
					end
				end
			end -- End Interrupt Check	
		end--end interrupts
		
		local function Extras()
			if GetMinimapZoneText() == "The Festering Core" then 
				for i = 1, #enemies.yards40 do
					local thisUnit = enemies.yards40[i]
					local endtime,_,_,_,spellID = select(5,UnitCastingInfo(thisUnit))	
						if spellID == 263307 then
							if ((endtime/1000) - GetTime()) < 0.5 then
								SpellStopCasting() return true
							end
						end
					
				end
			end
			-- Temple of Sethraliss
			if GetObjectID("target") == 133392 and inCombat and isChecked("Temple of Sethraliss Logic") then
				if getHP("target") < 100 and getBuffRemain("target",274148) == 0 then
					if GetSpellCooldown(115175) == 0 and getBuffRemain("target",115175,"EXACT") == 0 then
						CastSpellByName(GetSpellInfo(115175),"target") return true
					elseif getBuffRemain("target",115175,"EXACT") > 1 and getBuffRemain("target",124682) < 1 then
						CastSpellByName(GetSpellInfo(124682),"target") return true
					elseif getBuffRemain("target",115175,"EXACT") > 1 and getBuffRemain("target",124682) > 1 then
						CastSpellByName(GetSpellInfo(116670),"target") return true
					end
				end
			end	
			--Jade Statue
			if isChecked("Summon Jade Serpent") and br.friend[1].hp >= 55 and talent.summonJadeSerpentStatue then
				--player
				if getOptionValue("Summon Jade Serpent") == 1 then
					param = "player"
					--target
				elseif getOptionValue("Summon Jade Serpent") == 2 and GetObjectExists("target") then
					param = "target"
					--tank
				elseif getOptionValue("Summon Jade Serpent") == 3 and #getTanksTable() > 0 then
					local tanks = getTanksTable()
					param = tanks[1].unit
				else
					param = "player"
				end
				if tsPX == nil or tsPY == nil then
					tsPX, tsPY, tsPZ = GetObjectPosition(param)
					if cast.summonJadeSerpentStatue(param) then return end
				elseif getDistanceToObject("player",tsPX,tsPY,tsPZ) > 40 then
					tsPX, tsPY, tsPZ = GetObjectPosition(param)
					if cast.summonJadeSerpentStatue(param) then return end
				end
			end		
		end--end extras
	
		local function OoC_Healing()
			for i = 1, #br.friend do
				if isChecked("OOC Healing") and not inCombat and not UnitIsDeadOrGhost("player") and not IsMounted() then
					--EM OoC
					if not buff.lifeCyclesVivify.exists("player") then
						if br.friend[i].hp <= getValue("OOC Healing") and getBuffRemain(br.friend[i].unit, spell.envelopingMist, "player") < 2 then
							if getBuffRemain(br.friend[i].unit, spell.soothingMist, "EXACT") == 0 and not isMoving("player") then
								if cast.soothingMist(br.friend[i].unit) then return end
							end
							if getBuffRemain(br.friend[i].unit, spell.soothingMist, "EXACT") > 1 then
								if cast.envelopingMist(br.friend[i].unit) then return end
							end
						end
					end
					-- Vivify OoC
					if br.friend[i].hp <= getValue("OOC Healing") and not isMoving("player") then
						if getBuffRemain(br.friend[i].unit, spell.soothingMist, "EXACT") == 0 and not isMoving("player") then
							if cast.soothingMist(br.friend[i].unit) then return end
						end
						if getBuffRemain(br.friend[i].unit, spell.soothingMist, "EXACT") > 1 then
							if cast.vivify(br.friend[i].unit) then return end 
						end
					end
				end-- end combat check for OOC healing 
			end
		end -- end OoC_Healing

		local function shhhhh()
			if cast.thunderFocusTea() then return end
			if cast.risingSunKick() then return end
			if cast.blackoutKick() then return end
			if cast.tigerPalm() then return end
		end

		local function Cooldowns()
			--Life Cocoon
			for i = 1, #br.friend do
				if isChecked("Life Cocoon") then
					if br.friend[1].hp <= getValue("Life Cocoon") and getBuffRemain(br.friend[1].unit, spell.lifeCocoon, "player") < 1 then
						if cast.lifeCocoon(br.friend[1].unit) then return end
					end
				end
			end
			--Revival
			for i = 1, #br.friend do
				if isChecked("Revival") then
					if getLowAllies(getValue("Revival")) >= getValue("Revival Targets") then
						if cast.revival() then return end
					end
				end
			end
			--Chi Ji
			for i = 1, #br.friend do
				if isChecked("Chi Ji") then
					if getLowAllies(getValue("Chi Ji")) >= getValue("Chi Ji Targets") then
						if cast.invokeChiJi() then return end
					end
				end
			end
			--Mana Tea
			if isChecked("Mana Tea") and talent.manaTea then
				if mana <= getValue("Mana Tea") then
					if cast.manaTea("player") then return end
				end
			end
			-- Thunder Focus Tea Check
			for i = 1, #br.friend do
				if isChecked("Thunder Focus Tea") and GetSpellCooldown(spell.thunderFocusTea) == 0 then
					if br.friend[1].hp <= getValue("Thunder Focus Tea") then
						if cast.thunderFocusTea() then return end
					end
				end
			end
			-- Thunder Focus Tea Cast
			for i = 1, #br.friend do
				if isChecked("Thunder Focus Tea") and GetSpellCooldown(spell.thunderFocusTea) == 0 then
					--Envoloping Mist
					if getOptionValue("Thunder Focus Tea Options") == 1 and br.friend[1].hp <= getValue("TFT EM") then
						if isChecked("Soothing Mist Instant Cast") and getBuffRemain(br.friend[1].unit, spell.soothingMist, "EXACT") == 0 and not isMoving("player") then
							if cast.soothingMist(br.friend[1].unit) then return true end
						end
						if isChecked("Soothing Mist Instant Cast") and getBuffRemain(br.friend[1].unit, spell.soothingMist, "EXACT") > 1 and buff.thunderFocusTea.remain("player") >= 1 then
							if cast.envelopingMist(br.friend[1].unit) then return end
						end
						if not isChecked("Soothing Mist Instant Cast") and buff.thunderFocusTea.remain("player") >= 1 then
							if cast.envelopingMist(br.friend[1].unit) then return end
						end
					end
					--Renewing Mists
					if getOptionValue("Thunder Focus Tea Options") == 2 and br.friend[i].hp <= getValue("TFT RM") then
						if buff.thunderFocusTea.remain("player") >= 1 then
							if cast.renewingMist(br.friend[i].unit) then return end
						end
					end
					--Vivify
					if getOptionValue("Thunder Focus Tea Options") == 3 and br.friend[1].hp <= getValue("TFT Vivify") and buff.thunderFocusTea.remain("player") >= 1 then
							if cast.vivify(br.friend[1].unit) then return end
					end
				end--end TFT cast
			end
		end -- end CDS

		local function Single_Target()
			--Trinkets
			if talent.spiritOfTheCrane then
				if cast.blackoutKick() then return end
			end
			for i = 1, #br.friend do
				if isChecked("Use Trinkets With Values below") then
					if br.friend[1].hp < getValue("Use Trinket 1") and canUseItem(13) then
						useItem(13) return
					end
					if br.friend[1].hp < getValue("Use Trinket 2") and canUseItem(14) then
						useItem(14) return
					end
				end
			end
			for i = 1, #br.friend do
				if isChecked("Use Inoculating Extract") and hasEquiped(160649) then
					if getOptionValue("Target for Inoculating Extract") == 1 then
						if br.friend[1].hp <= getValue("Use Inoculating Extract") then
							UseItemByName(160649,br.friend[1].unit)
						end
						if getOptionValue("Target for Inoculating Extract") == 2 and #tanks > 0 and tanks[1].hp <= getValue("Use Inoculating Extract") then
							UseItemByName(160649,tanks[1].unit)
						end
					end
				end
				if isChecked("Revitalizing Voodoo Totem") and #tanks > 0 and tanks[1].hp <= getValue("Revitalizing Voodoo Totem") then 
					if hasEquiped(158320) and canUseItem(158320) then
						UseItemByName(158320,tanks[1].unit)
					end
				end
			end
			-- 2 stack RM
			for i = 1, #br.friend do
				if isChecked("Renewing Mist") and charges.renewingMist.count() == 2 then
					if br.friend[i].hp <= getValue("Renewing Mist")
						and getBuffRemain(br.friend[i].unit, spell.renewingMist, "player") < 1 then
						if cast.renewingMist(br.friend[i].unit) then return end
					end
				end
			end
			-- Enveloping Mist
			if not talent.lifecycles then
				for i = 1, #br.friend do
					if br.friend[1].hp <= getValue("Enveloping Mist") then
						if isChecked("EM Tanks Only") and #tanks > 0 and tanks[1].hp <= getValue("Enveloping Mist") then
							if isChecked("Soothing Mist Instant Cast") and getBuffRemain(tanks[1].unit,115175,"EXACT") == 0 and not isMoving("player") then
								if cast.soothingMist(tanks[1].unit) then return end
							end
							if isChecked("Soothing Mist Instant Cast") and getBuffRemain(tanks[1].unit,115175,"EXACT") > 1 and getBuffRemain(br.friend[1].unit, spell.envelopingMist, "player") < 2 then
								if cast.envelopingMist(tanks[1].unit) then return end
							end
							if not isChecked("Soothing Mist Instant Cast") and getBuffRemain(br.friend[1].unit, spell.envelopingMist, "player") < 2 and not isMoving("player") then
								if cast.envelopingMist(tanks[1].unit) then return end
							end
						end
						if not isChecked("EM Tanks Only") and br.friend[1].hp <= getValue("Enveloping Mist") then
							if isChecked("Soothing Mist Instant Cast") and getBuffRemain(br.friend[1].unit, spell.soothingMist, "EXACT") == 0 then
								if cast.soothingMist(br.friend[1].unit) then return end
							end
							if isChecked("Soothing Mist Instant Cast") and getBuffRemain(br.friend[1].unit, spell.soothingMist, "EXACT") > 1 and getBuffRemain(br.friend[1].unit, spell.envelopingMist, "player") < 2  then
								if cast.envelopingMist(br.friend[1].unit) then return end
							end
							if not isChecked("Soothing Mist Instant Cast") and getBuffRemain(br.friend[1].unit, spell.envelopingMist, "player") < 2  then
								if cast.envelopingMist(br.friend[1].unit) then return end
							end
						end
					end
				end
			end
			--Surging Mist
			for i = 1, #br.friend do
				if br.friend[1].hp <= getValue("Surging Mist") then
					if cast.surgingMist(br.friend[1].unit) then return end
				end
			end
			-- Vivify 
			if not talent.lifecycles then
				for i = 1, #br.friend do
					if br.friend[1].hp <= getValue("Vivify") and (isCastingSpell(spell.soothingMist) or not (cast.active.vivify() or cast.last.vivify(br.friend[1].unit))) then
						if cast.vivify(br.friend[1].unit) then return end
					end
				end
			end
			-- Soothing Mist 2
			for i = 1, #br.friend do
				if isChecked("Soothing Mist") then
					if br.friend[1].hp <= getValue("Soothing Mist") and getBuffRemain(br.friend[1].unit, spell.soothingMist, "EXACT") == 0 and not isMoving("player") then
						if cast.soothingMist(br.friend[1].unit) then return true end
					end
				end
			end
			-- Renewing Mists
			for i = 1, #br.friend do
				if isChecked("Renewing Mist") then
					if br.friend[i].hp <= getValue("Renewing Mist")
						and getBuffRemain(br.friend[i].unit, spell.renewingMist, "player") < 1 then
						if cast.renewingMist(br.friend[i].unit) then return end
					end
				end
			end
			--chi wave
			for i = 1, #br.friend do
				if cast.able.chiWave() then
					if cast.chiWave(br.friend[1].unit) then return end
				end
			end
		end -- end Single Target Healing
		
		local function AoE_Healing()
			--Refreshing Jade Wind
			for i = 1, #br.friend do
				if isChecked("Refreshing Jade Wind") and GetSpellCooldown(196725) == 0 then
					if br.friend[1].hp <= getValue("Refreshing Jade Wind") then
						if cast.refreshingJadeWind("player") then return end
					end
				end
			end
			--Essence Font with Upwelling
			if isChecked("Essence Font Upwelling") and talent.upwelling then 
				if mana >= getValue("EF Minimum Mana") then
					if upwellingStacksPanglo >= getValue("Essence Font Upwelling") then
						if getLowAllies(getValue("Essence Font")) >= getValue("EF Targets") then
							if cast.essenceFont() then return end
						end
					end
				end
			end
			--Essence Font
			if isChecked("Essence Font") and not talent.upwelling then
				if mana >= getValue("EF Minimum Mana") then
					if getLowAllies(getValue("Essence Font")) >= getValue("EF Targets") then
						if cast.essenceFont() then return end
					end
				end
			end
			-- Chi Burst
			if isChecked("Chi Burst Units") and getUnitsInRect(7,47,false,getOptionValue("Chi Burst HP")) >= getOptionValue("Chi Burst Units") then
				if cast.chiBurst("player") then return end
			end
		end--end AOE Action List

		local function lifecycles()
			-- Renewing Mists
			for i = 1, #br.friend do
				if isChecked("Renewing Mist") and charges.renewingMist.count() == 2 then
					if br.friend[i].hp <= getValue("Renewing Mist")
						and getBuffRemain(br.friend[i].unit, spell.renewingMist, "player") < 1 then
						if cast.renewingMist(br.friend[i].unit) then return end
					end
				end
			end			
			-- Enveloping Mist Life Cycles
			for i = 1, #br.friend do
				if br.friend[1].hp <= getValue("Enveloping Mist Lifecycles") and buff.lifeCyclesEnvelopingMist.exists() then
					if isChecked("EM Tanks Only") and #tanks > 0 and tanks[1].hp <= getValue("Enveloping Mist Lifecycles") then
						if isChecked("Soothing Mist Instant Cast") and getBuffRemain(tanks[1].unit,115175,"EXACT") == 0 and not isMoving("player") then
							if cast.soothingMist(tanks[1].unit) then return true end
						end
						if isChecked("Soothing Mist Instant Cast") and getBuffRemain(tanks[1].unit,115175,"EXACT") > 1 and getBuffRemain(br.friend[1].unit, spell.envelopingMist, "player") < 2 then
							if cast.envelopingMist(tanks[1].unit) then return end
						end
						if not isChecked("Soothing Mist Instant Cast") and getBuffRemain(br.friend[1].unit, spell.envelopingMist, "player") < 2 then
							if cast.envelopingMist(tanks[1].unit) then return end
						end
					end
					if not isChecked("EM Tanks Only") and br.friend[1].hp <= getValue("Enveloping Mist Lifecycles") then
						if isChecked("Soothing Mist Instant Cast") and getBuffRemain(br.friend[1].unit, spell.soothingMist, "EXACT") == 0 and not isMoving("player") then
							if cast.soothingMist(br.friend[1].unit) then return true end
						end
						if isChecked("Soothing Mist Instant Cast") and getBuffRemain(br.friend[1].unit, spell.soothingMist, "EXACT") > 1 and getBuffRemain(br.friend[1].unit, spell.envelopingMist, "player") < 2 then
							if cast.envelopingMist(br.friend[1].unit) then return end
						end
						if not isChecked("Soothing Mist Instant Cast") and getBuffRemain(br.friend[1].unit, spell.envelopingMist, "player") < 2 then
							if cast.envelopingMist(br.friend[1].unit) then return end
						end
					end
				end
			end
			-- Vivify Lifecycles
			for i = 1, #br.friend do
				if br.friend[1].hp <= getValue("Vivify Lifecycles") and (isCastingSpell(spell.soothingMist) or not (cast.active.vivify() or cast.last.vivify(br.friend[1].unit))) then
					if cast.vivify(br.friend[1].unit) then return end
				end
			end
			-- Renewing Mists
			for i = 1, #br.friend do
				if isChecked("Renewing Mist") then
					if br.friend[i].hp <= getValue("Renewing Mist")
						and getBuffRemain(br.friend[i].unit, spell.renewingMist, "player") < 1 then
						if cast.renewingMist(br.friend[i].unit) then return end
					end
				end
			end
		end -- end lifecycles rotation

		local function manaTea()
			if buff.manaTea.exists("player") then
				-- Mana tea EF
				if isChecked("Essence Font") and not talent.upwelling then
					if mana >= getValue("EF Minimum Mana") then
						if getLowAllies(getValue("Essence Font")) >= getValue("EF Targets") then
							if cast.essenceFont() then return end
						end
					end
				end
				-- Renewing Mists
				for i = 1, #br.friend do
					if isChecked("Renewing Mist") and charges.renewingMist.count() == 2 then
						if br.friend[i].hp <= getValue("Renewing Mist")
							and getBuffRemain(br.friend[i].unit, spell.renewingMist, "player") < 1 then
							if cast.renewingMist(br.friend[i].unit) then return end
						end
					end
				end
					-- Enveloping Mist
				for i = 1, #br.friend do
					if br.friend[1].hp <= (getValue("Enveloping Mist") *1.1) and not talent.lifecycles then
						if isChecked("EM Tanks Only") and #tanks > 0 and tanks[1].hp <= getValue("Enveloping Mist") then
							if isChecked("Soothing Mist Instant Cast") and getBuffRemain(tanks[1].unit,115175,"EXACT") == 0 and not isMoving("player") then
								if cast.soothingMist(tanks[1].unit) then return true end
							end
							if isChecked("Soothing Mist Instant Cast") and getBuffRemain(tanks[1].unit,115175,"EXACT") > 1 and getBuffRemain(br.friend[1].unit, spell.envelopingMist, "player") < 2 then
								if cast.envelopingMist(tanks[1].unit) then return end
							end
							if not isChecked("Soothing Mist Instant Cast") and getBuffRemain(br.friend[1].unit, spell.envelopingMist, "player") < 2 then
								if cast.envelopingMist(tanks[1].unit) then return end
							end
						end
						if not isChecked("EM Tanks Only") and br.friend[1].hp <= (getValue("Enveloping Mist") * 1.1) then
							if isChecked("Soothing Mist Instant Cast") and getBuffRemain(br.friend[1].unit, spell.soothingMist, "EXACT") == 0 and not isMoving("player") then
								if cast.soothingMist(br.friend[1].unit) then return true end
							end
							if isChecked("Soothing Mist Instant Cast") and getBuffRemain(br.friend[1].unit, spell.soothingMist, "EXACT") > 1 and getBuffRemain(br.friend[1].unit, spell.envelopingMist, "player") < 2 then
								if cast.envelopingMist(br.friend[1].unit) then return end
							end
							if not isChecked("Soothing Mist Instant Cast") and getBuffRemain(br.friend[1].unit, spell.envelopingMist, "player") < 2 then
								if cast.envelopingMist(br.friend[1].unit) then return end
							end
						end
					end
				end
				-- Vivify 
				for i = 1, #br.friend do
					if br.friend[1].hp <= (getValue("Vivify") *1.1) and not talent.lifecycles then
						if br.friend[1].hp <= getValue("Vivify") and (isCastingSpell(spell.soothingMist) or not (cast.active.vivify() or cast.last.vivify(br.friend[1].unit))) then
								if cast.vivify(br.friend[1].unit) then return end
						end
					end
				end
				-- Renewing Mists
				for i = 1, #br.friend do
					if isChecked("Renewing Mist") then
						if br.friend[i].hp <= getValue("Renewing Mist")
							and getBuffRemain(br.friend[i].unit, spell.renewingMist, "player") < 1 then
							if cast.renewingMist(br.friend[i].unit) then return end
						end
					end
				end
			end
		end--end mana tea rotation

		local function dps_actionlist() -- Very secret function for Mistweavers only
			if br.player.ui.mode.dps == 1 then
				if br.friend[1].hp >= getValue("DPS Mode") then
					if talent.risingThunder then
						if cast.risingSunKick() then return end
					end
					if talent.spiritOfTheCrane or buff.teachingsOfTheMonastery.stack() == 3 then
						if cast.blackoutKick() then return end
					end
					if isChecked("Spinning Crane Kick") and #enemies.yards8 >= 3 and not isCastingSpell(spell.spinningCraneKick) then
						if cast.spinningCraneKick("player") then return end
					end
					if isChecked("Rising Sun Kick") then 
						if cast.risingSunKick() then return end
					end
					if cast.tigerPalm() then return true end
					if #enemies.yards10 == 0 and not isCastingSpell(spell.cracklingJadeLightning) and isChecked("Crackling Jade Lightning") and not isMoving("player") then
						if cast.cracklingJadeLightning() then return true end
					end
				end
			end
		end -- Enemy is dead?

		local function Defensive()
			if useDefensive() then
				--detox
				if br.player.ui.mode.detox == 1 then
					for i = 1, #br.friend do
						if inInstance and ((getDebuffRemain(br.friend[i].unit,275014) > 2 and #getAllies(br.friend[i].unit,6) < 2) or (getDebuffRemain(br.friend[i].unit,252781) > 2 and #getAllies(br.friend[i].unit,9) < 2)) then
							if cast.detox(br.friend[i].unit) then return end
						elseif (not inInstance or (inInstance and getDebuffRemain(br.friend[i].unit,275014) == 0 and getDebuffRemain(br.friend[i].unit,252781) == 0)) and not UnitIsCharmed(br.friend[i].unit) then
							if canDispel(br.friend[i].unit,spell.detox) then
								if cast.detox(br.friend[i].unit) then return end
							end
						end
					end
				end		
				--Healing Elixir
				if isChecked("Healing Elixir") and talent.healingElixir then
					if php <= getValue("Healing Elixir") then
						if cast.healingElixir("player") then return end
					end
				end
				--Dampen Harm
				if isChecked("Dampen Harm") and talent.dampenHarm then
					if php <= getValue("Dampen Harm") then
						if cast.dampenHarm("player") then return end
					end
				end
				--Fortifying Brew
				if isChecked("Fortifying Brew") and php <= getValue("Fortifying Brew") and cd.fortifyingBrew.remain() == 0 then
					if cast.fortifyingBrew() then return end
				end
				--Healthstone
				if isChecked("Healthstone") and php <= getOptionValue("Healthstone") and inCombat and (hasHealthPot() or hasItem(5512) or hasItem(166799)) then
                    if canUseItem(5512) then
                        useItem(5512)
                    elseif canUseItem(healPot) then
                        useItem(healPot)
                    elseif hasItem(166799) and canUseItem(166799) then
                        useItem(166799)
                    end
                end
			end--End defensive check
		end-- end defensives

		if not pause(true) then 
			if not inCombat and not isCastingSpell(spell.essenceFont) then
				if isChecked("OOC Healing") then
					if OoC_Healing() then return end
				end
			elseif inCombat and profileStop==false and not isCastingSpell(spell.essenceFont) then 
				if br.player.ui.mode.dps == 1 and lowest.hp > getOptionValue("DPS Mode") then
					if dps_actionlist() then return end
				else
					if buff.wayOfTheCrane.exists() then
						if shhhhh() then return end
					else 
						if Extras() then return end
						if Defensive() then return end
						if actionlist_Interrupts() then return end
						if Cooldowns() then return end
						if buff.manaTea.exists() then
							if manaTea() then return end
						end
						if not buff.manaTea.exists() then
							if AoE_Healing() then return end
							if talent.lifecycles then
								if lifecycles() then return end
							end
							if Single_Target() then return end
						end
					end
				end
			end
		end
	end -- end timer
end -- End Run rotation

local id = 0 --270
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
	name = rotationName,
	toggles = createToggles,
	options = createOptions,
	run = runRotation,
})
