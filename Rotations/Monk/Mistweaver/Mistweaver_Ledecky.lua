local rotationName = "Ledecky" -- Change to name of profile listed in options drop down

--------------
--- COLORS ---
--------------
local colorBlue         = "|cff00CCFF"  
local colorGreen        = "|cff00FF00"  
local colorRed          = "|cffFF0000"  
local colorWhite        = "|cffFFFFFF"  
local colorGold         = "|cffFFDD11"  
local colordk           = "|cffC41F3B"  
local colordh           = "|cffA330C9"  
local colordrood        = "|cffFF7D0A"  
local colorhunter       = "|cffABD473"  
local colormage         = "|cff69CCF0"  
local colormonk         = "|cff00FF96"  
local colorpala         = "|cffF58CBA"  
local colorpriest       = "|cffFFFFFF"  
local colorrogue        = "|cffFFF569"  
local colorshaman       = "|cff0070DE"  
local colorwarlock      = "|cff9482C9"  
local colorwarrior      = "|cffC79C6E"  
local colorLegendary    = "|cffff8000"

---------------
--- Toggles ---
---------------
local function createToggles() -- Define custom toggles
-- Rotation Button
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell.spinningCraneKick },
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.spinningCraneKick },
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.tigerPalm },
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.effuse}
    };
    CreateButton("Rotation",1,0)
-- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.revival },
        [2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.revival },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.revival }
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
            br.ui:createCheckbox(section, "Boss Helper")
            --Healing Elixir
            br.ui:createSpinner(section, "Healing Elixir",  45,  0,  100,  5,  "Health Percent to Cast At")
            --Mana Tea
            br.ui:createSpinner(section, "Mana Tea",  70,  0,  100,  5,  "Mana Percent to Cast At")
            --Dampen Harm
            br.ui:createSpinner(section, "Dampen Harm",  35,  0,  100,  5,  "Health Percent to Cast At")			
			--Thunder Focus Tea
			br.ui:createSpinner(section, "Thunder Focus Tea",  75,  0,  100,  5,  "Use Thunder Focus Tea when someone is below this health percent")
			br.ui:createDropdownWithout(section, "Thunder Focus Tea Options", {"|cffFFFFFFEnveloping Mists","|cffFFFFFFRenewing Mists","|cffFFFFFFVivify"}, 3, "|cffFFFFFFSelect TFT Usage")
			br.ui:createSpinnerWithout(section, "TFT EM",  75,  0,  100,  5,  "Cast EM with TFT at health percent")
			br.ui:createSpinnerWithout(section, "TFT RM",  85,  0,  100,  5,  "Cast RM with TFT at health percent")
			br.ui:createSpinnerWithout(section, "TFT Vivify",  85,  0,  100,  5,  "Cast Vivify with TFT at health percent")
            --Detox
            br.ui:createCheckbox(section, "Detox")
            --Detox Wait Time
            br.ui:createSpinnerWithout(section, "Detox Wait Time",  1,  0,  100,  5,  "Rotation Intervals to wait before casting Detox. Higher number increases the time to wait before using Detox.")            
			--OOC Healing
            br.ui:createSpinner(section, "Mana Tea",  70,  0,  100,  5,  "Mana Percent to Cast At")
			br.ui:createSpinner(section, "OOC Healing",  95,  0,  100,  5,  "Health Percent to Cast At")
			br.ui:createCheckbox(section, "Temple of Sethraliss Logic","Will heal the NPC when manually selected")
			br.ui:createSpinner(section, "DPS Mode",  90,  0,  100,  5,  "Will DPS if in range and Lowest HP of Party is above threshold")
			
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
            --Enveloping Mists
            br.ui:createSpinner(section, "Enveloping Mist",  70,  0,  100,  5,  "Health Percent to Cast At")
            --Vivify
            br.ui:createSpinner(section, "Vivify",  60,  0,  100,  5,  "Health Percent to Cast At")
			--Jade Statue
			br.ui:createDropdown(section, colormage.."Summon Jade Serpent", {colorGreen.."Player",colorBlue.."Target",colorRed.."Tank"}, 3,colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.."Use of Summon Jade Serpent.", colorWhite.."Use Summon Jade Serpent at location of.")
        br.ui:checkSectionState(section)
		-------------------------
        ------ Life Cycles ------
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Lifecycles Options")		
			--Lifecycles Rotation Enabled
			br.ui:createCheckbox(section, "Enable Lifecycles Rotation","Will attempt to utilize Lifecycles Talent to maximize mana efficiency.")
            --Enveloping Mists Lifecycles
            br.ui:createSpinner(section, "Enveloping Mist Lifecycles",  70,  0,  100,  5,  "Health Percent to Cast At")		
            --Vivify Lifecycles
            br.ui:createSpinner(section, "Vivify Lifecycles",  60,  0,  100,  5,  "Health Percent to Cast At")			
		br.ui:checkSectionState(section)
        -------------------------
        ------ AOE HEALING ------
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "AOE Healing")
			--Refreshing Jade Wind
			br.ui:createSpinner(section, "Refreshing Jade Wind",  95,  0,  100,  5,  "Health Percent to Cast At")
            -- Essence Font
            br.ui:createSpinner(section, "Essence Font",  80,  0,  100,  5,  "Health Percent to Cast At")
            br.ui:createSpinnerWithout(section, "Essence Font Targets",  6,  0,  40,  1,  "Minimum Essence Font Targets")
			br.ui:createSpinnerWithout(section, "EF Minimum Mana",  40,  0,  100,  1,  "Minimum Mana to cast")
            -- Revival
            br.ui:createSpinner(section, "Revival",  60,  0,  100,  5,  "Health Percent to Cast At")
            br.ui:createSpinnerWithout(section, "Revival Targets",  5,  0,  40,  1,  "Minimum Revival Targets")
            --ChiJI
            br.ui:createSpinner(section, "Chi Ji",  80,  0,  100,  5,  "Health Percent to Cast At")
            br.ui:createSpinnerWithout(section, "Chi Ji Targets",  5,  0,  40,  1,  "Minimum Revival Targets")
        br.ui:checkSectionState(section)
        -------------------------
        ------ Debug Testing ------
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "DEBUG TESTING")
			--JSF
			br.ui:createSpinner(section, "JSF",  80,  0,  100,  5,  "Ignore. Testing Purposes Only.")
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
    if br.timer:useTimer("debugMistweaver", 0.1) then --change "debugFury" to "debugSpec" (IE: debugFire)
        --Print("Running: "..rotationName)

---------------
--- Toggles --- -- List toggles here in order to update when pressed
---------------
        UpdateToggle("Rotation",0.25)
        UpdateToggle("Cooldown",0.25)
        UpdateToggle("Defensive",0.25)
        UpdateToggle("Interrupt",0.25)
        UpdateToggle("Detox",0.25)
        br.player.mode.decurse = br.data.settings[br.selectedSpec].toggles["Detox"]
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
        local mana                                          = br.player.powerPercentMana
        local mode                                          = br.player.mode
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
		    local JSF											                      = 0
		    local detox                                         = 0

        if leftCombat == nil then leftCombat = GetTime() end
        if profileStop == nil then profileStop = false end

--------------------
--- Action Lists ---
--------------------

-----------------
--- Rotations ---
-----------------
---------------------------------
--- Out Of Combat - Rotations ---
---------------------------------
        if not inCombat and not UnitIsDeadOrGhost("player") and not IsMounted() then		
		--Enveloping Mists OOC
            if isChecked("Enveloping Mist Lifecycles") and isChecked("Enable Lifecycles Rotation") and not isCastingSpell(spell.essenceFont) and not buff.lifeCyclesVivify.exists("player") then
				if lowest.hp <= getValue("OOC Healing") and getBuffRemain(lowest.unit, spell.envelopingMist, "player") < 2 and getBuffRemain(lowest.unit,115175) > 1 then
					if getBuffRemain(lowest.unit,115175) == 0 then
						if cast.soothingMist(lowest.unit) then return end
					end
					if getBuffRemain(lowest.unit,115175) > 1 then
						if cast.envelopingMist(lowest.unit) then return end
					end
				end
			end
		--Vivify OOC
			if isChecked("Vivify Lifecycles") and isChecked("Enable Lifecycles Rotation") and not isCastingSpell(spell.essenceFont) and buff.lifeCyclesVivify.exists("player") then
				if lowest.hp <= getValue("OOC Healing") and getBuffRemain(lowest.unit,115175) > 1 then
					if getBuffRemain(lowest.unit,115175) == 0 then
						if cast.soothingMist(lowest.unit) then return end
					end
					if getBuffRemain(lowest.unit,115175) > 1 then
						if cast.vivify(lowest.unit) then return end
					end
				end
			end			
		-- Soothing Mist OOC
            if isChecked("OOC Healing") and not isCastingSpell(spell.essenceFont) then
                for i = 1, #br.friend do
                    if br.friend[i].hp <= getValue("OOC Healing") then
                        if cast.soothingMist(br.friend[i].unit) then return end
                    end
                end
            end
			
			
        end -- End Out of Combat Rotation
-----------------------------
--- In Combat - Rotations ---
-----------------------------
    -- Action List - Interrupts
            if useInterrupts() then
                for i=1, #getEnemies("player",20) do
                    thisUnit = getEnemies("player",20)[i]
                    distance = getDistance(thisUnit)
                    if canInterrupt(thisUnit,getOptionValue("InterruptAt")) then
                        if distance < 5 then
        -- Quaking Palm
                            if isChecked("Quaking Palm") and not isCastingSpell(spell.essenceFont) then
                                if cast.quakingPalm(thisUnit) then return end
                            end
        -- Leg Sweep
                            if isChecked("Leg Sweep") and not isCastingSpell(spell.essenceFont) then
                                if cast.legSweep(thisUnit) then return end
                            end
                        end
        -- Paralysis
                        if isChecked("Paralysis") and not isCastingSpell(spell.essenceFont) then
                            if cast.paralysis(thisUnit) then return end
                        end
                    end
                end
            end -- End Interrupt Check

        if inCombat then --Start
		
			----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			--Defensives--
			----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------			
		--Healing Elixir
            if isChecked("Healing Elixir") and talent.healingElixir and not isCastingSpell(spell.essenceFont) then
                if php <= getValue("Healing Elixir") then
                    if cast.healingElixir("player") then return end
                end
            end
		--Mana Tea
            if isChecked("Mana Tea") and talent.manaTea and not isCastingSpell(spell.essenceFont) then
                if mana <= getValue("Mana Tea") then
                    if cast.manaTea("player") then return end
                end
            end			
		--Dampen Harm
            if isChecked("Dampen Harm") and talent.dampenHarm and not isCastingSpell(spell.essenceFont) then
                if php <= getValue("Dampen Harm") then
                    if cast.dampenHarm("player") then return end
                end
            end			
	    -- Temple of Sethraliss
			if GetObjectID("target") == 133392 and inCombat and isChecked("Temple of Sethraliss") then
				if getHP("target") < 100 and getBuffRemain("target",274148) == 0 then
					if GetSpellCooldown(115175) == 0 and getBuffRemain("target",115175) == 0 then
						if CastSpellByName(GetSpellInfo(115175),"target") then return end
					end
					if getBuffRemain("target",115175) > 1 then
						if CastSpellByName(GetSpellInfo(124682),"target") then return end
					end
					if getBuffRemain("target",115175) > 1 and getBuffRemain("target",124682) > 1 then
						if CastSpellByName(GetSpellInfo(116670),"target") then return end
					end
				end
			end

            -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
            --Single Target Healing----Single Target Healing----Single Target Healing----Single Target Healing----Single Target Healing----Single Target Healing----Single Target Healing--
            -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
            --Life Cocoon
            if isChecked("Life Cocoon") then
                for i = 1, #br.friend do
                    if br.friend[i].hp <= getValue("Life Cocoon") and getBuffRemain(br.friend[i].unit, spell.lifeCocoon, "player") < 1 then
                        -- if getValue("Life Cocoon Mode") == 1 and br.friend[i].role == "TANK" then
                        if cast.lifeCocoon(br.friend[i].unit) then return end
                        -- elseif getValue("Life Cocoon Mode") == 2 then
                        --     if cast.lifeCocoon(br.friend[i].unit) then return end
                        -- end
                    end
                end
            end
            -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
            --Dispels--
            ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
         if br.player.mode.decurse == 1 then
             --Detox Wait Time
            if isChecked("Detox Wait Time") then
                    for i = 1, #br.friend do
                        for n = 1,40 do
                            local buff,_,count,bufftype,duration = UnitDebuff(br.friend[i].unit, n)
                            if buff then
                                if bufftype == "Disease" or bufftype == "Magic" or bufftype == "Poison" then                                                                      
                                    detox = detox + 1 
                                end
                            end
                        end
                    end
            end
            --Detox
            if isChecked("Detox") and not isCastingSpell(spell.essenceFont) and detox >= getOptionValue("Detox Wait Time") then
                    for i = 1, #br.friend do
                        for n = 1,40 do
                            local buff,_,count,bufftype,duration = UnitDebuff(br.friend[i].unit, n)
                            if buff then
                                if bufftype == "Disease" or bufftype == "Magic" or bufftype == "Poison" then
                                    if cast.detox(br.friend[i].unit) then                                
                                    detox = 0
                                    end
                                end
                            end
                        end
                    end
            end
         end
            ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
            --Thunder Focus Tea Section--
            ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			--Thunder Focus Tea Start
            if isChecked("Thunder Focus Tea") and GetSpellCooldown(spell.thunderFocusTea) == 0 then
                for i = 1, #br.friend do
                    if br.friend[i].hp <= getValue("Thunder Focus Tea") then
                        if cast.thunderFocusTea() then return end
                    end
                end
            end			
            --Thunder Focus Tea
            if isChecked("Thunder Focus Tea") and not isCastingSpell(spell.essenceFont) and GetSpellCooldown(spell.thunderFocusTea) == 0  then
                for i = 1, #br.friend do
					if getOptionValue("Thunder Focus Tea") == 1 then --Enveloping Mists TFT
						if br.friend[i].hp <= getValue("TFT EM") then
								if getBuffRemain(br.friend[i].unit,115175) == 0 then
									if cast.soothingMist(br.friend[i].unit) then return end
								end
								if getBuffRemain(br.friend[i].unit,115175) > 1 and buff.thunderFocusTea.remain("player") > 1 then
									if cast.envelopingMist(br.friend[i].unit) then return end
								end
							end
						end
						if getOptionValue("Thunder Focus Tea") == 2 then --Renewing Mists TFT	
							if br.friend[i].hp <= getValue("TFT RM") then
									if getBuffRemain(br.friend[i].unit,115175) == 0 then
										if cast.soothingMist(br.friend[i].unit) then return end
									end
									if getBuffRemain(br.friend[i].unit,115175) > 1 and buff.thunderFocusTea.remain("player") > 1 then
										if cast.renewingMists(br.friend[i].unit) then return end
									end
								end
							end							
						end
						if getOptionValue("Thunder Focus Tea") == 3 then --Vivify TFT
							if br.friend[i].hp <= getValue("TFT Vivify") then
									if getBuffRemain(br.friend[i].unit,115175) == 0 then
										if cast.soothingMist(br.friend[i].unit) then return end
									end
									if getBuffRemain(br.friend[i].unit,115175) > 1 and buff.thunderFocusTea.remain("player") > 1 then
										if cast.vivify(br.friend[i].unit) then return end
									end				
						end
					end	
			end							     
            ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
            --AOE Healing----AOE Healing----AOE Healing----AOE Healing----AOE Healing----AOE Healing----AOE Healing----AOE Healing----AOE Healing----AOE Healing----AOE Healing----AOE Healing
            ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
           --Refreshing Jade Wind
            if isChecked("Refreshing Jade Wind") and not isCastingSpell(spell.essenceFont) and GetSpellCooldown(196725) == 0 then
                if lowest.hp <= getValue("Refreshing Jade Wind") then
                    if cast.refreshingJadeWind() then return end
                end
            end
		   --Essence Font
            if isChecked("Essence Font") and not isCastingSpell(spell.essenceFont) then
                if getLowAllies(getValue("Essence Font")) >= getValue("EF Targets") then
                    if cast.essenceFont() then return end
                end
            end
            --Revival
            if isChecked("Revival") and not isCastingSpell(spell.essenceFont) then
                if getLowAllies(getValue("Revival")) >= getValue("Revival Targets") then
                    if cast.revival() then return end
                end
            end
            --Chi Ji
            if isChecked("Chi Ji") and not isCastingSpell(spell.essenceFont) then
                if getLowAllies(getValue("Chi Ji")) >= getValue("Chi Ji Targets") then
                    if cast.invokeChiJi(lowest.unit) then return end
                end
            end			
			--Jade Statue
			if isChecked(colormage.."Summon Jade Serpent") and lowest.hp >= 55 and talent.summonJadeSerpentStatue then
            --player
				if getOptionValue(colormage.."Summon Jade Serpent") == 1 then
					param = "player"
            --target
				elseif getOptionValue(colormage.."Summon Jade Serpent") == 2 and GetObjectExists("target") then
					param = "target"
            --tank
				elseif getOptionValue(colormage.."Summon Jade Serpent") == 3 and #getTanksTable() > 0 then
					local tanks = getTanksTable()
					param = tanks[1].unit
				else
					param = "player"
				end
				if tsPX == nil or tsPY == nil then
					tsPX, tsPY, tsPZ = GetObjectPosition(param)
					if cast.summonJadeSerpentStatue(param) then return true end
				elseif getDistanceToObject("player",tsPX,tsPY,tsPZ) > 40 then
					tsPX, tsPY, tsPZ = GetObjectPosition(param)
                if cast.summonJadeSerpentStatue(param) then return true end
            end
        end
			----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			--Life Cycles Rotation--
			----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
			--Renewing Mist
            if isChecked("Renewing Mist") and not isCastingSpell(spell.essenceFont) then
                for i = 1, #br.friend do
                    if br.friend[i].hp <= getValue("Renewing Mist")
                    and getBuffRemain(br.friend[i].unit, spell.renewingMist, "player") < 1 then
                        if cast.renewingMist(br.friend[i].unit) then return end
                    end
                end
            end
			--Enveloping Mists Lifecycles Start
            if isChecked("Enveloping Mist Lifecycles") and isChecked("Enable Lifecycles Rotation") and not isCastingSpell(spell.essenceFont) and not buff.lifeCyclesVivify.exists("player") then
              for i = 1, #br.friend do
			         	if br.friend[i].hp <= getValue("Enveloping Mist Lifecycles") and getBuffRemain(br.friend[i].unit, spell.envelopingMist, "player") < 1 and getBuffRemain(br.friend[i].unit,115175) > 1 then
				          if getBuffRemain(br.friend[i].unit,115175) == 0 then
				            if cast.soothingMist(br.friend[i].unit.unit) then return end
					        end
		    				  if cast.envelopingMist(br.friend[i].unit) then return end
			           	end
		       	  end
		       	end
			--Vivify Life Cycles
			if isChecked("Vivify Lifecycles") and isChecked("Enable Lifecycles Rotation") and not isCastingSpell(spell.essenceFont) and buff.lifeCyclesVivify.exists("player") and getBuffRemain("player",197916) > 1 then
	 		for i = 1, #br.friend do
				if br.friend[i].hp <= getValue("Vivify Lifecycles") and getBuffRemain(br.friend[i].unit,115175) > 1 then
				  	if getBuffRemain(br.friend[i].unit,115175) == 0 then
				  		if cast.soothingMist(br.friend[i].unit) then return end
				    	end
				    	if cast.vivify(br.friend[i].unit) then return end
				    	end
		    	end
			end
			----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			--End of Life Cycles Rotation--
			----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------           	
            --Enveloping Mists
        if isChecked("Enveloping Mist") and not isCastingSpell(spell.essenceFont) then
           for i = 1, #br.friend do
               if br.friend[i].hp <= getValue("Enveloping Mist") and getBuffRemain(br.friend[i].unit, spell.envelopingMist, "player") < 1 then
                  if getBuffRemain(br.friend[i].unit,115175) == 0 then
					           	if cast.soothingMist(br.friend[i].unit) then return end
				        	end
				         	if cast.envelopingMist(br.friend[i].unit) then return end
                   end
            end
        end
            --Vivify
          if isChecked("Vivify") and not isCastingSpell(spell.essenceFont) then
             for i = 1, #br.friend do
			         	if br.friend[i].hp <= getValue("Vivify") then
				          	if getBuffRemain(br.friend[i].unit,115175) == 0 then
						            if cast.soothingMist(br.friend[i].unit) then return end
					           end
				          	if cast.vivify(br.friend[i].unit) then return end
				             end
				    end
		    	end
			-- Soothing Mist 2
            if isChecked("Soothing Mist") and not isCastingSpell(spell.essenceFont) then
                for i = 1, #br.friend do
                    if br.friend[i].hp <= getValue("Soothing Mist") and getBuffRemain(br.friend[i].unit,115175) == 0 then
                        if cast.soothingMist(br.friend[i].unit) then return end
                    end             	
                end
		        end	
      -- Soothing Mist Debug. Temporary Fix for Jade Serpent Statue which causes rotation to freeze when the statue has soothing mist on a target we want to execute the rotation on.
      -- The only way the rotation will resume, is if it casts soothing mists on a different target other than the target we want to heal.
      -- I don't know how to fix this and if there is someone who can, please do. 
            if isChecked("JSF") and not isCastingSpell(spell.essenceFont) then
                for i = 1, #br.friend do
                    if br.friend[i].hp <= getValue("JSF") and (br.friend[i].role == "TANK" or UnitGroupRolesAssigned(br.friend[i].unit) == "TANK") and php > 95 then
                        if cast.soothingMist("player") then return end
                    end               
                end
            end 	
      ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
      --DPS Mode Section--
      ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------       
            
     --DPS Mode--
        if br.player.mode.dps == 1 then
            if lowest.hp >= getValue("DPS Mode") then
                if talent.risingThunder then
                    if cast.risingSunKick() then return true end
                end
                if  isChecked(colordh.."Spinning Crane Kick") and not talent.spiritOfTheCrane and #enemies.yards8 >= 3 and not isCastingSpell(spell.spinningCraneKick) then
                    if cast.spinningCraneKick() then return true end
                elseif #enemies.yards5 >= 1 then
                    if isChecked(colordh.."Rising Sun Kick") and cd.risingSunKick.remain()  == 0 then
                        if cast.risingSunKick() then return true end
                    end
                    if buff.teachingsOfTheMonastery.stack() == 3 then
                        if cast.blackoutKick() then return true end
                    end
                    if cast.tigerPalm() then return true end
                elseif #enemies.yards40 > 0 and not isCastingSpell(spell.cracklingJadeLighting) and isChecked(colordh.."Crackling Jade Lightning") then
                    if cast.cracklingJadeLighting() then return true end
                end
            end
        end
        return false     
            	        
        end -- End In Combat Rotation
    end -- End Timer	
end -- End runRotation

                if isChecked("Boss Helper") then
                        bossManager()
                end
local id = 270
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
