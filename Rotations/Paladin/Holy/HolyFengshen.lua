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
        --    br.ui:createCheckbox(section, "Boss Helper")
        -- Blessing of Freedom
            br.ui:createCheckbox(section, "Blessing of Freedom")	
	    -- Pre-Pull Timer	
		    br.ui:createSpinner(section, "Pre-Pull Timer",  5,  0,  20,  1,  "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
        --Beacon of Light
            br.ui:createCheckbox(section, "Beacon of Light")
		--Beacon of Faith
			br.ui:createCheckbox(section, "Beacon of Faith")
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
        ---- SINGLE TARGET ------
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Single Target Healing")
            --Flash of Light
            br.ui:createSpinner(section, "Flash of Light",  70,  0,  100,  5,  "","|cffFFFFFFHealth Percent to Cast At")
            br.ui:createDropdownWithout(section, "FoL Infuse", {"|cffFFFFFFNormal","|cffFFFFFFOnly Infuse"}, 1, "|cffFFFFFFOnly Use Infusion Procs.")
            --Holy Light
            br.ui:createSpinner(section, "Holy Light",  85,  0,  100,  5,  "","|cffFFFFFFHealth Percent to Cast At")
            br.ui:createDropdownWithout(section, "Holy Light Infuse", {"|cffFFFFFFNormal","|cffFFFFFFOnly Infuse"}, 2, "|cffFFFFFFOnly Use Infusion Procs.")
            --Holy Shock
            br.ui:createSpinner(section, "Holy Shock", 90, 0, 100, 5, "","|cffFFFFFFHealth Percent to Cast At")
            --Bestow Faith
            br.ui:createSpinner(section, "Bestow Faith", 80, 0, 100, 5, "","|cffFFFFFFHealth Percent to Cast At")
            br.ui:createDropdownWithout(section, "Bestow Faith Target", {"|cffFFFFFFAll","|cffFFFFFFTanks","|cffFFFFFFSelf+LotM"}, 3, "|cffFFFFFFTarget for BF")
            -- Light of the Martyr
            br.ui:createSpinner(section, "Light of the Martyr", 40, 0, 100, 5, "","|cffFFFFFFHealth Percent to Cast At")
            br.ui:createSpinner(section, "Moving LotM", 80, 0, 100, 5, "","|cffFFFFFFisMoving Health Percent to Cast At")
			br.ui:createSpinner(section, "LotM player HP limit", 30, 0, 100, 5, "","|cffFFFFFFLight of the Martyr Self HP limit", true)
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
            -- Tyr's Deliverance
            br.ui:createSpinner(section, "Tyr's Deliverance", 70, 0, 100, 5, "","|cffFFFFFFHealth Percent to Cast At")
			br.ui:createSpinner(section, "Tyr's Deliverance Targets",  3,  0,  40,  1,  "","|cffFFFFFFMinimum TD Targets", true)
        -- Beacon of Virtue
            br.ui:createSpinner(section, "Beacon of Virtue", 80, 0, 100, 5, "","|cffFFFFFFHealth Percent to Cast At")
            br.ui:createSpinner(section, "BoV Targets",  3,  0,  40,  1,  "","|cffFFFFFFMinimum BoV Targets", true)
		-- Holy Prism
            br.ui:createSpinner(section, "Holy Prism", 80, 0, 100, 5, "","|cffFFFFFFHealth Percent to Cast At")
            br.ui:createSpinner(section, "Holy Prism Targets",  3,  0,  40,  1,  "","|cffFFFFFFMinimum Holy Prism Targets", true)
		-- Light's Hammer
            br.ui:createSpinner(section, "Light's Hammer", 80, 0, 100, 5, "","|cffFFFFFFHealth Percent to Cast At")
            br.ui:createSpinner(section, "Light's Hammer Targets",  3,  0,  40,  1,  "","|cffFFFFFFMinimum Light's Hammer Targets", true)
            br.ui:createDropdown(section,"Light's Hammer Key", br.dropOptions.Toggle, 6, "","|cffFFFFFFLight's Hammer usage.", true)
		-- Divine Shield and Light of the Martyr
            br.ui:createSpinner(section, "Divine Shield + LotM",  30, 0, 100, 5, "","|cffFFFFFFHealth Percent to Cast At")
            br.ui:createSpinner(section, "Divine Shield + LotM Targets",  3,  0,  40,  1,  "","|cffFFFFFFMinimum Divine Shield + LotM Targets", true)
        br.ui:checkSectionState(section)
        -------------------------
        ---------- DPS ----------
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "DPS")
            br.ui:createSpinner(section, "DPS", 70, 0, 100, 5, "","|cffFFFFFFMinimum Health to DPS")
            -- Consecration
            br.ui:createSpinner(section, "Consecration",  1,  0,  40,  1,  "","|cffFFFFFFMinimum Consecration Targets")
			-- Blinding Light
            br.ui:createSpinner(section, "Blinding Light Damage", 4, 0, 10, 1, "","|cffFFFFFFMinimum Blinding Light Targets")			
            -- Holy Prism
            br.ui:createSpinner(section, "Holy Prism Damage",  3,  0,  40,  1,  "","|cffFFFFFFMinimum Holy Prism Targets")
            -- Light's Hammer
            br.ui:createSpinner(section, "Light's Hammer Damage",  3,  0,  40,  1,  "","|cffFFFFFFMinimum Light's Hammer Targets")
            -- Judgement
            br.ui:createCheckbox(section, "Judgement")
            -- Holy Shock
            br.ui:createCheckbox(section, "Judgement Damage")
            -- Crusader Strike
            br.ui:createCheckbox(section, "Crusader Strike")
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
            br.ui:createSpinner(section, "Blessing of Sacrifice", 30, 0, 100, 5, "","|cffFFFFFFHealth Percent to Cast At")
            br.ui:createDropdownWithout(section, "BoS Target", {"|cffFFFFFFAll","|cffFFFFFFTanks","|cffFFFFFFDamage"}, 3, "|cffFFFFFFTarget for BoS")			
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
local healing_obj = nil

local function runRotation()
    if br.timer:useTimer("debugHoly", 0.1) then --change "debugFury" to "debugSpec" (IE: debugFire)
        --Print("Running: "..rotationName)

---------------
--- Toggles --- -- List toggles here in order to update when pressed
---------------
        UpdateToggle("Rotation",0.25)
        UpdateToggle("Cooldown",0.25)
        UpdateToggle("Defensive",0.25)
        UpdateToggle("Interrupt",0.25)
        br.player.mode.cleanse = br.data.settings[br.selectedSpec].toggles["Cleanse"]
		br.player.mode.DPS = br.data.settings[br.selectedSpec].toggles["DPS"]
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
        local enemies                                       = enemies or {}
        local falling, swimming, flying, moving             = getFallTime(), IsSwimming(), IsFlying(), GetUnitSpeed("player")>0
        local gcd                                           = br.player.gcd
        local healPot                                       = getHealthPot()
        local inCombat                                      = br.player.inCombat
        local inInstance                                    = br.player.instance=="party"
        local inRaid                                        = br.player.instance=="raid"
        local level                                         = br.player.level
        local lowestHP                                      = br.friend[1].unit
        local lowest                                        = br.friend[1]		
        local mana                                          = br.player.powerPercentMana
        local mode                                          = br.player.mode
        local perk                                          = br.player.perk
        local php                                           = br.player.health
        local power, powmax, powgen                         = br.player.power.amount.mana, br.player.power.mana.max, br.player.power.regen
        local pullTimer                                     = br.DBM:getPulltimer()
        local race                                          = br.player.race
        local racial                                        = br.player.getRacial()
        local recharge                                      = br.player.recharge
        local spell                                         = br.player.spell
        local talent                                        = br.player.talent
        local ttm                                           = br.player.power.ttm
        local units                                         = units or {}	
        local LightCount                                    = 0
        local FaithCount                                    = 0		
		
		
		
        units.dyn5 = br.player.units(5)
        units.dyn15 = br.player.units(15)
        units.dyn30 = br.player.units(30)
        units.dyn40 = br.player.units(40)
        units.dyn30AoE = br.player.units(30,true)
        enemies.yards8 = br.player.enemies(8)
        enemies.yards10 = br.player.enemies(10)
        enemies.yards15 = br.player.enemies(15)
        enemies.yards30 = br.player.enemies(30)
        enemies.yards40 = br.player.enemies(40)

        local lowest                                        = {}    --Lowest Unit
        lowest.hp                                           = br.friend[1].hp
        lowest.role                                         = br.friend[1].role
        lowest.unit                                         = br.friend[1].unit
        lowest.range                                        = br.friend[1].range
        lowest.guid                                         = br.friend[1].guid
        local lowestTank                                    = {}    --Tank                                    
        local tHp                                           = 95
        local averageHealth                                 = 100

        if leftCombat == nil then leftCombat = GetTime() end
        if profileStop == nil then profileStop = false end

--------------------
--- Action Lists ---
--------------------
		-- Pre-Pull Timer
			if isChecked("Pre-Pull Timer") and pullTimer <= getOptionValue("Pre-Pull Timer") then
                if pullTimer <= getOptionValue("Pre-Pull Timer") then
                    if canUse(142117) and not buff.prolongedPower.exists() then
                        useItem(142117);
                            return true
                            end
                        end
		            end		
        local function actionList_Defensive()
            if useDefensive() then
                if isChecked("Pot/Stoned") and php <= getValue("Pot/Stoned") and inCombat and (hasHealthPot() or hasItem(5512))
                then
                    if canUse(5512) then
                        useItem(5512)
                    elseif canUse(getHealthPot()) then
                        useItem(getHealthPot())
                    end
                end
                if isChecked("Divine Protection") then
                    if php <= getOptionValue("Divine Protection") and inCombat then
                        if cast.divineProtection() then return end
					elseif buff.blessingOfSacrifice.exists("player") then
					    if cast.divineProtection() then return end
                    end
                end
                if isChecked("Divine Shield") then
                    if php <= getOptionValue("Divine Shield") and not debuff.forbearance.exists("player") and inCombat then
                        if cast.divineShield() then return end				
                    end
				end
                    if isChecked("Blessing of Freedom") and hasNoControl("player") then
                        if cast.blessingOfFreedom() then return end
                    end				
			    end
		    end	
-----------------
--- Rotations ---
-----------------
        if not IsMounted() or buff.divineSteed.exists() then
            if actionList_Defensive() then return end
             -- Redemption
            if isChecked("Redemption") then
                if getOptionValue("Redemption") == 1 and UnitIsPlayer("target") and UnitIsDeadOrGhost("target") and UnitIsFriend("target","player") then
                    if cast.redemption("target") then return end
                end
                if getOptionValue("Redemption") == 2 and UnitIsPlayer("mouseover") and UnitIsDeadOrGhost("mouseover") and UnitIsFriend("mouseover","player") then
                    if cast.redemption("mouseover") then return end
                end
            end
            if br.player.mode.cleanse == 1 then
                for i = 1, #br.friend do
                    if UnitIsPlayer(br.friend[i].unit) then
                        for n = 1,40 do
                            local buff,_,_,count,bufftype,duration = UnitDebuff(br.friend[i].unit, n)
                            if buff then
                                if bufftype == "Disease" or bufftype == "Magic" or bufftype == "Poison" then
                                    if cast.cleanse(br.friend[i].unit) then return end
                                end
                            end
                        end
                    end
                end
            end
            -- Interrupt
            if useInterrupts() then
                for i=1, #getEnemies("player",10) do
                    thisUnit = getEnemies("player",10)[i]
                    distance = getDistance(thisUnit)
                    if canInterrupt(thisUnit,getOptionValue("InterruptAt")) then
                        if distance <= 10 then
        -- Hammer of Justice
            if isChecked("Hammer of Justice") and GetSpellCooldown(853) == 0 then
                if cast.hammerOfJustice(thisUnit) then return end
                end
        -- Blinding Light
            if isChecked("Blinding Light") and distance < 10 then
                if cast.blindingLight() then return end							
                end
            end
        end
	end	
end -- End Interrupt Check
            -- Beacon of Light on Tank
            if isChecked("Beacon of Light") and not talent.beaconOfVirtue then
			 if inRaid and (UnitThreatSituation("player", "target") ~= nil or (UnitExists("target") and isDummy("target"))) and UnitAffectingCombat("player") then
				local bossUnit = nil
				local bossTarget = nil				
				for v=1, #enemies.yards40 do				
                    if isBoss(enemies.yards40[v]) then
						bossUnit = enemies.yards40[v]
					end
				end								
				for i=1, #br.friend do
					local threat  = nil
					if  bossUnit ~= nil then
						threat = UnitThreatSituation(br.friend[i].unit , bossUnit)
						if threat ~= nil then
						end
					end				
					if  bossUnit ~= nil and threat ~= nil and threat >= 3 then
						if (br.friend[i].role == "TANK" or UnitGroupRolesAssigned(br.friend[i].unit) == "TANK") and UnitAffectingCombat(br.friend[i].unit) 
						and not buff.beaconOfLight.exists(br.friend[i].unit) and not buff.beaconOfFaith.exists(br.friend[i].unit) then
							CastSpellByName(GetSpellInfo(53563),br.friend[i].unit)
						end
					end
				end
			end
			    LightCount = 0
                for i=1, #br.friend do
                    if buff.beaconOfLight.exists(br.friend[i].unit) then
                        LightCount = LightCount + 1
                    end
                end				
                for i = 1, #br.friend do
				    if LightCount < 1 and not buff.beaconOfLight.exists(br.friend[i].unit) and not buff.beaconOfFaith.exists(br.friend[i].unit) and UnitGroupRolesAssigned(br.friend[i].unit) == "TANK" then
					    if cast.beaconOfLight(br.friend[i].unit) then return end
					end
				end			
		    end	
            -- Beacon of Faith on Off Tank
            if isChecked("Beacon of Faith") and talent.beaconOfFaith then
			    FaithCount = 0
                for i=1, #br.friend do
                    if buff.beaconOfFaith.exists(br.friend[i].unit) then
                        FaithCount = FaithCount + 1
                    end
                end
				for i = 1, #br.friend do
				    if FaithCount < 1 and not buff.beaconOfLight.exists(br.friend[i].unit) and not buff.beaconOfFaith.exists(br.friend[i].unit) and UnitGroupRolesAssigned(br.friend[i].unit) == "TANK" then
					    if cast.beaconOfFaith(br.friend[i].unit) then return end
				    elseif FaithCount < 1 and not inRaid and not buff.beaconOfLight.exists(br.friend[i].unit) and not buff.beaconOfFaith.exists(br.friend[i].unit) then	
				        if cast.beaconOfFaith(br.friend[i].unit) then return end
					end
				end
			end	
            ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
            -- DPS ----------- DPS ----------- DPS ----------- DPS ----------- DPS ----------- DPS ----------- DPS ----------- DPS ----------- DPS ----------- DPS ----------- DPS -----------
            ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
            if mode.DPS == 1 and isChecked("DPS") and lowest.hp >= getValue("DPS") and not UnitIsFriend("target", "player") then
                --Consecration
                if isChecked( "Consecration") and #enemies.yards8 >= getValue( "Consecration") and not isMoving("player") then
                    if cast.consecration() then return end
                end
                -- Blinding Light
                if isChecked("Blinding Light Damage") and #enemies.yards10 >= getOptionValue("Blinding Light Damage") and inCombat then
                    if cast.blindingLight() then return end
                end
                -- Holy Prism
                if isChecked("Holy Prism Damage") and talent.holyPrism and #enemies.yards15 >= getValue("Holy Prism Damage") and php < 90 then
                    if cast.holyPrism(units.dyn15) then return end
                end
                -- Light's Hammer
                if isChecked("Light's Hammer Damage") and talent.lightsHammer and not isMoving("player") and #enemies.yards10 >= getValue("Light's Hammer Damage") then
                    if cast.lightsHammer("best",nil,1,10) then return end
                end
                -- Judgement
                if isChecked("Judgement") then
                    if cast.judgment(units.dyn40) then return end
                end
                -- Holy Shock
                if isChecked("Judgement Damage") then
                    if cast.holyShock(units.dyn40) then return end
                end
                -- Crusader Strike
                if isChecked("Crusader Strike") and (charges.crusaderStrike == 2 or debuff.judgement.exists(units.dyn5) or (charges.crusaderStrike >= 1 and recharge.crusaderStrike < 3)) then
                    if cast.crusaderStrike(units.dyn5) then return end
                end
            end
            -- Cool downs
            if inCombat then
                ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                --Cooldowns ----- Cooldowns -----Cooldowns ----- Cooldowns ----- Cooldowns ----- Cooldowns ----- Cooldowns ----- Cooldowns ----- Cooldowns ----- Cooldowns ----- Cooldowns ----- 
                ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                -- Lay on Hands
                if isChecked("Lay on Hands") and GetSpellCooldown(633) == 0 then
                    if getOptionValue("Lay on Hands Target") == 1 then
                        for i = 1, #br.friend do
                            if br.friend[i].hp <= getValue ("Lay on Hands") and not debuff.forbearance.exists(br.friend[i].unit) then
                                if isCastingSpell(spell.holyLight) then
                                    SpellStopCasting()
                                end
                                if cast.layOnHands(br.friend[i].unit) then return end
                            end
                        end
                    elseif getOptionValue("Lay on Hands Target") == 2 then
                        for i = 1, #br.friend do
                            if br.friend[i].hp <= getValue ("Lay on Hands") and not debuff.forbearance.exists(br.friend[i].unit) and UnitGroupRolesAssigned(br.friend[i].unit) == "TANK" then
                                if cast.layOnHands(br.friend[i].unit) then return end
                            end
                        end
                    elseif getOptionValue("Lay on Hands Target") == 3 then
                        if php <= getValue("Lay on Hands") and not debuff.forbearance.exists("player") then
                            if cast.layOnHands("player") then return end
                        end
                    end
                end
                -- 保护祝福
                if isChecked("Blessing of Protection") and GetSpellCooldown(1022) == 0 then
                    if getOptionValue("BoP Target") == 1 then
                        for i = 1, #br.friend do
                            if br.friend[i].hp <= getValue ("Blessing of Protection") and not debuff.forbearance.exists(br.friend[i].unit) then
                                if isCastingSpell(spell.holyLight) then
                                    SpellStopCasting()
                                end
                                if cast.blessingOfProtection(br.friend[i].unit) then return end
                            end
                        end
                    elseif getOptionValue("BoP Target") == 2 then
                        for i = 1, #br.friend do
                            if br.friend[i].hp <= getValue ("Blessing of Protection") and not debuff.forbearance.exists(br.friend[i].unit) and UnitGroupRolesAssigned(br.friend[i].unit) == "TANK" then
                                if cast.blessingOfProtection(br.friend[i].unit) then return end
                            end
                        end
					elseif getOptionValue("BoP Target") == 3 then
                        for i = 1, #br.friend do
                            if br.friend[i].hp <= getValue ("Blessing of Protection") and not debuff.forbearance.exists(br.friend[i].unit) and (UnitGroupRolesAssigned(br.friend[i].unit) == "HEALER" or UnitGroupRolesAssigned(br.friend[i].unit) == "DAMAGER") then
                                if cast.blessingOfProtection(br.friend[i].unit) then return end
                            end
                        end					
                    elseif getOptionValue("BoP Target") == 4 then
                        if php <= getValue("Blessing of Protection") and not debuff.forbearance.exists("player") then
                            if cast.blessingOfProtection("player") then return end
                        end
                    end
                end
                -- Blessing of Sacrifice
                if isChecked("Blessing of Sacrifice") and GetSpellCooldown(6940) == 0 then
                    if getOptionValue("BoS Target") == 1 then
                        for i = 1, #br.friend do
                            if br.friend[i].hp <= getValue ("Blessing of Sacrifice") and not debuff.forbearance.exists(br.friend[i].unit) then
                                if isCastingSpell(spell.holyLight) then
                                    SpellStopCasting()
                                end
                                if cast.blessingOfSacrifice(br.friend[i].unit) then return end
                            end
                        end
                    elseif getOptionValue("BoS Target") == 2 then
                        for i = 1, #br.friend do
                            if br.friend[i].hp <= getValue ("Blessing of Sacrifice") and not debuff.forbearance.exists(br.friend[i].unit) and UnitGroupRolesAssigned(br.friend[i].unit) == "TANK" then
                                if cast.blessingOfSacrifice(br.friend[i].unit) then return end
                            end
                        end
                    elseif getOptionValue("BoS Target") == 3 then
                        for i = 1, #br.friend do
                            if br.friend[i].hp <= getValue ("Blessing of Sacrifice") and not debuff.forbearance.exists(br.friend[i].unit) and UnitGroupRolesAssigned(br.friend[i].unit) == "DAMAGER" then
                                if cast.blessingOfSacrifice(br.friend[i].unit) then return end
                            end
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
				-- Flash of Light
				for i = 1, #br.friend do
				    if not isMoving("player") and br.friend[i].hp <= getValue("Overhealing Cancel") and buff.theLightSaves.exists("player") and (buff.beaconOfLight.exists(br.friend[i].unit) or buff.beaconOfFaith.exists(br.friend[i].unit)) then
                        if cast.flashOfLight(br.friend[i].unit) then
							healing_obj = br.friend[i].unit
							return
						end
					end
				end	
			    -- Divine Shield and Light of the Martyr
				if isChecked("Divine Shield + LotM") and not debuff.forbearance.exists("player") and getLowAllies(getValue"Divine Shield + LotM") >= getValue("Divine Shield + LotM Targets") then
				    if php <= 100 then
					    if cast.divineShield() then return end
					end
				end	
					for i = 1, #br.friend do
                        if br.friend[i].hp <= 100 and buff.divineShield.exists("player") and not UnitIsUnit(br.friend[i].unit,"player") then
                            if cast.lightOfTheMartyr(br.friend[i].unit) then return end
						end
					end					
				-- Rule of Law
				if isChecked("Rule of Law") and talent.ruleOfLaw and not buff.ruleOfLaw.exists("player") then
				    if getLowAllies(getValue"Rule of Law") >= getValue("RoL Targets") then
					    if cast.ruleOfLaw() then return end
					end
				end	
                -- Tyr's Deliverance
                if isChecked("Tyr's Deliverance") and not isMoving("player") then
                    if getLowAllies(getValue"Tyr's Deliverance") >= getValue("Tyr's Deliverance Targets") then
                        if cast.tyrsDeliverance() then return end
                    end
				end	
                -- Avenging Wrath
                if isChecked("Avenging Wrath") and not buff.auraMastery.exists("player") and GetSpellCooldown(31842) == 0 then
                    if getLowAllies(getValue"Avenging Wrath") >= getValue("Avenging Wrath Targets") then
                        if isCastingSpell(spell.holyLight) then
                            SpellStopCasting()
                        end    
                        if cast.avengingWrath() then return end
                    end
                end
                -- Holy Avenger
                if isChecked("Holy Avenger") and talent.holyAvenger then
                   if getLowAllies(getValue"Holy Avenger") >= getValue("Holy Avenger Targets") then
                        if cast.holyAvenger() then return end
                    end
                end
                -- Aura Mastery
                if isChecked("Aura Mastery") and not buff.avengingWrath.exists("player") then
                    if getLowAllies(getValue"Aura Mastery") >= getValue("Aura Mastery Targets") then
                        if cast.auraMastery() then return end
                    end
                end
            end
            -- Holy Prism
            if isChecked("Holy Prism") and talent.holyPrism then
                if getLowAllies(getValue"Holy Prism") >= getValue("Holy Prism Targets") then
                    if cast.holyPrism(units.dyn15) then return end
                end
            end
            -- Light of Dawn
            if isChecked("Light of Dawn") then
                 for i = 1, #br.friend do
                    if br.friend[i].hp <= getValue("Light of Dawn") then
                        local lowHealthCandidates = getUnitsToHealAround(br.friend[i].unit,15,getValue("Light of Dawn"),#br.friend)
                        if #lowHealthCandidates >= getValue("LoD Targets") and getFacing("player",br.friend[i].unit) then
                            if GetSpellCooldown(85222) == 0 then
                            CastSpellByName(GetSpellInfo(85222),br.friend[i].unit)
                            end
                        end
                    end
                end
            end
            --Beacon of Virtue
            if talent.beaconOfVirtue and isChecked("Beacon of Virtue") then
                for i= 1, #br.friend do
                    if not buff.beaconOfVirtue.exists(br.friend[i].unit)  then
                        local lowHealthCandidates = getUnitsToHealAround(br.friend[i].unit,30,getValue("Beacon of Virtue"),#br.friend)
                        if #lowHealthCandidates >= getValue("BoV Targets") then
                            if cast.beaconOfVirtue(br.friend[i].unit) then return end
                        end
                    end
                end
            end			
			-- Light's Hammer
            if (SpecificToggle("Light's Hammer Key") and not GetCurrentKeyBoardFocus()) then
                    CastSpellByName(GetSpellInfo(spell.lightsHammer),"cursor")
                    return
                end			
			if isChecked("Light's Hammer") and talent.lightsHammer and not isMoving("player") then
			    if getLowAllies(getValue("Light's Hammer")) >= getValue("Light's Hammer Targets") then
				    if castGroundAtBestLocation(spell.lightsHammer, 20, 0, 40, 0, "heal") then return end
				end
			end	
            -- Bestow Faith
            if isChecked("Bestow Faith") and talent.bestowFaith then
                if getOptionValue("Bestow Faith Target") == 1 then
                    for i = 1, #br.friend do
                        if br.friend[i].hp <= getValue ("Bestow Faith") then
                            if cast.bestowFaith(br.friend[i].unit) then return end
                        end
                    end
                elseif getOptionValue("Bestow Faith Target") == 2 then
                    for i = 1, #br.friend do
                        if br.friend[i].hp <= getValue ("Bestow Faith") and UnitGroupRolesAssigned(br.friend[i].unit) == "TANK" then
                            if cast.bestowFaith(br.friend[i].unit) then return end
                        end
                    end
				elseif 	getOptionValue("Bestow Faith Target") == 3 then
				    for i = 1, #br.friend do
					    if br.friend[i].hp <= getValue ("Bestow Faith") then
						    if cast.bestowFaith("player") then return end
						end
						if br.friend[i].hp <= getValue ("Bestow Faith") and php >= getOptionValue("LotM player HP limit") and not UnitIsUnit(br.friend[i].unit,"player") and buff.bestowFaith.exists("player") then
						    if cast.lightOfTheMartyr(br.friend[i].unit) then return end
						end	
					end
				end
			end	
            -- Judgement
			if not UnitIsFriend("target", "player") and inCombat then
			    if talent.judgmentOfLight and not debuff.judgmentoflight.exists(units.dyn40) then
				    if cast.judgment(units.dyn40) then return end
                elseif talent.fistOfJustice and GetSpellCooldown(853) > 0 then
                    if cast.judgment(units.dyn40) then return end
				end
			end	
			-- Crusader Strike
            if talent.crusadersMight and GetSpellCooldown(20473) > 1 and not UnitIsFriend("target", "player") and inCombat then
                if cast.crusaderStrike(units.dyn5) then return end
            end				
            -- Holy Shock		
            if isChecked("Holy Shock") then
                for i = 1, #br.friend do
				    if isChecked("Critical HP") and br.friend[i].hp <= getValue("Critical HP") then
                        if cast.holyShock(br.friend[i].unit) then return end
				    elseif inRaid and php <= 80 and not buff.beaconOfLight.exists("player") and not buff.beaconOfFaith.exists("player") then
					    if cast.holyShock("player") then return end
				    elseif br.friend[i].hp <= getValue("Holy Shock")  and not buff.beaconOfLight.exists(br.friend[i].unit) and not buff.beaconOfFaith.exists(br.friend[i].unit) then
                        if cast.holyShock(br.friend[i].unit) then return end
                    elseif br.friend[i].hp <= getValue("Holy Shock") then
                        if cast.holyShock(br.friend[i].unit) then return end
                    end
                end
            end			
            -- Light of Martyr
            if isChecked("Light of the Martyr") and php >= getOptionValue("LotM player HP limit") then
                for i = 1, #br.friend do
                    if br.friend[i].hp <= getValue ("Light of the Martyr") and not UnitIsUnit(br.friend[i].unit,"player") then
                        if cast.lightOfTheMartyr(br.friend[i].unit) then return end
                    end
                end
            end
            -- Flash of Light
            if isChecked("Flash of Light") and not isMoving("player") and (getOptionValue("FoL Infuse") == 1 or (getOptionValue("FoL Infuse") == 2 and buff.infusionOfLight.exists("player"))) then
                for i = 1, #br.friend do
				    if isChecked("Critical HP") and br.friend[i].hp <= getValue("Critical HP") then
                        if cast.flashOfLight(br.friend[i].unit) then
							healing_obj = br.friend[i].unit
							return
						end					
                    elseif br.friend[i].hp <= getValue("Flash of Light") and not buff.beaconOfLight.exists(br.friend[i].unit) and not buff.beaconOfFaith.exists(br.friend[i].unit) then
                        if cast.flashOfLight(br.friend[i].unit) then
							healing_obj = br.friend[i].unit
							return
						end
					elseif br.friend[i].hp <= getValue("Flash of Light") then
					    if cast.flashOfLight(br.friend[i].unit) then 
							healing_obj = br.friend[i].unit
							return
						end
					end	
                end
				
            end
            -- Holy Light
            if isChecked("Holy Light") and not isMoving("player") and (getOptionValue("Holy Light Infuse") == 1 or (getOptionValue("Holy Light Infuse") == 2 and buff.infusionOfLight.exists("player") and GetSpellCooldown(20473) > 0 )) then                 
                for i = 1, #br.friend do
                    if br.friend[i].hp <= getValue("Holy Light") and not buff.beaconOfLight.exists(br.friend[i].unit) and not buff.beaconOfFaith.exists(br.friend[i].unit) then
                        if cast.holyLight(br.friend[i].unit) then
							healing_obj = br.friend[i].unit
							return
						end
					elseif br.friend[i].hp <= getValue("Holy Light") then
					    if cast.holyLight(br.friend[i].unit) then
							healing_obj = br.friend[i].unit
							return
						end
					end	
                end
            end
            -- Emergency Martyr Heals
            if isChecked("Moving LotM") and isMoving("player") and php >= getOptionValue("LotM player HP limit") then
                for i = 1, #br.friend do
                    if br.friend[i].hp <= getValue("Moving LotM") and not UnitIsUnit(br.friend[i].unit,"player") then
                        if cast.lightOfTheMartyr(br.friend[i].unit) then return end
                    end
                end
            end
			-- Overhealing Cancel
		    if isChecked("Overhealing Cancel") and healing_obj ~= nil then
			    if getHP(healing_obj) >= getValue("Overhealing Cancel") and (isCastingSpell(spell.flashOfLight) or isCastingSpell(spell.holyLight)) then
				    SpellStopCasting()
				    healing_obj = nil
				    Print("Cancel casting...")
			    end
		    end             
        end -- Test Mode      
    end -- End Timer
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
