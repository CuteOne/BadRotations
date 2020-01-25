local rotationName = "CuteOne"

---------------
--- Toggles ---
---------------
local function createToggles()
-- Rotation Button
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell.cleave },
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.whirlwind },
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.mortalStrike },
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.victoryRush}
    };
    CreateButton("Rotation",1,0)
-- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.avatar },
        [2] = { mode = "On", value = 2 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 1, icon = br.player.spell.avatar },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.avatar }
    };
    CreateButton("Cooldown",2,0)
-- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.dieByTheSword },
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.dieByTheSword }
    };
    CreateButton("Defensive",3,0)
-- Interrupt Button
    InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.pummel },
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.pummel }
    };
    CreateButton("Interrupt",4,0)
-- Movement Button
    MoverModes = {
        [1] = { mode = "On", value = 1 , overlay = "Mover Enabled", tip = "Will use Charge/Heroic Leap.", highlight = 1, icon = br.player.spell.charge },
        [2] = { mode = "Off", value = 2 , overlay = "Mover Disabled", tip = "Will NOT use Charge/Heroic Leap.", highlight = 0, icon = br.player.spell.charge }
    };
    CreateButton("Mover",5,0)
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
            -- Opener
            br.ui:createCheckbox(section, "Opener", "|cffFFBB00Will cast Warbreaker, Skullsplitter & Bladestorm at pull (CDs inc.).")
            -- Dummy DPS Test
            br.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFBB00Set to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
            -- Pre-Pull Timer
            br.ui:createSpinner(section, "Pre-Pull Timer",  5,  1,  10,  1,  "|cffFFBB00Set to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
            -- Battle Cry
            br.ui:createCheckbox(section, "Battle Shout")
            -- Berserker Rage
            br.ui:createCheckbox(section,"Berserker Rage", "Check to use Berserker Rage")
            -- Charge
            br.ui:createCheckbox(section,"Charge", "Check to use Charge")
			-- Heroic Throw
            br.ui:createCheckbox(section,"Heroic Throw", "Check to use Heroic Throw out of range")
            -- Heroic Leap
            br.ui:createDropdown(section,"Heroic Leap", br.dropOptions.Toggle, 6, "Set auto usage (No Hotkey) or desired hotkey to use Heroic Leap.")
            br.ui:createDropdown(section,"Heroic Leap - Target",{"Best","Target"},1,"Desired Target of Heroic Leap")
            br.ui:createSpinner(section, "Heroic Charge",  15,  8,  25,  1,  "|cffFFBB00Set to desired yards to Heroic Leap out to. Min: 8 / Max: 25 / Interval: 1")
            -- Heart Essence
            br.ui:createCheckbox(section, "Use Essence")
        br.ui:checkSectionState(section)
        ------------------------
        ---   DPS SETTINGS   ---
        ------------------------
        section = br.ui:createSection(br.ui.window.profile,  "DPS Settings")
            -- Sweeping Strikes
            br.ui:createCheckbox(section,"Sweeping Strikes", "|cffFFBB00Will use Sweeping Strikes when more than 1 target is available.")
            -- Warbreaker
            br.ui:createSpinner(section,"Warbreaker",  3,  1,  10,  1,  "|cffFFBB00Set to desired targets to use Warbreaker. Min: 1 / Max: 10 / Interval: 1")
            -- Colossus Smash
            br.ui:createSpinner(section,"Colossus Smash",  3,  1,  10,  1,  "|cffFFBB00Set to desired targets to use Colossus Smash. Min: 1 / Max: 10 / Interval: 1")
            -- Hamstring
            br.ui:createCheckbox(section,"Hamstring", "|cffFFBB00Will use Hamstring.")
            -- Bladestorm
            br.ui:createSpinner(section, "Bladestorm",  3,  1,  10,  1,  "|cffFFBB00Set to desired targets to use Bladestorm when set to AOE. Min: 1 / Max: 10 / Interval: 1")            
            -- Azerite Beam Units
            br.ui:createSpinnerWithout(section, "Azerite Beam Units", 3, 1, 10, 1, "|cffFFBB00Number of Targets to use Azerite Beam on.")
            br.ui:checkSectionState(section)
        ------------------------
        --- COOLDOWN OPTIONS ---
        ------------------------
        section = br.ui:createSection(br.ui.window.profile,  "Cooldowns")
            -- Avatar
            br.ui:createCheckbox(section, "Avatar")
            -- Ravager
            br.ui:createDropdownWithout(section,"Ravager",{"Best","Target","Never"},1,"Desired Target of Ravager")
            -- Potion
            br.ui:createDropdown(section, "Potion", {"None", "Battle Potion of Strength", "Superior Battle Potion of Strength"},1,"|cffFFBB00Will use Potions.")
            -- Flask / Crystal
            br.ui:createCheckbox(section, "Flask / Crystal", "|cffFFBB00Will use Flask of the Undertow")
            -- Racial
            br.ui:createCheckbox(section, "Racial")
            -- Trinkets
            br.ui:createDropdownWithout(section, "Trinkets", {"|cff00FF00Everything","|cffFFFF00Cooldowns","|cffFF0000Never"}, 1, "|cffFFBB00When to use trinkets.")
        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
            -- Healthstone
            br.ui:createSpinner(section, "Healthstone/Potion",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            -- Heirloom Neck
            br.ui:createSpinner(section, "Heirloom Neck",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            -- Gift of The Naaru
            if br.player.race == "Draenei" then
                br.ui:createSpinner(section, "Gift of the Naaru",  50,  0,  100,  5,  "|cffFFBB00Health Percent to Cast At")
            end
            -- Defensive Stance
            br.ui:createSpinner(section, "Defensive Stance",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            -- Die By The Sword
            br.ui:createSpinner(section, "Die By The Sword",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            -- Intimidating Shout
            br.ui:createSpinner(section, "Intimidating Shout",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            -- Rallying Cry
            br.ui:createSpinner(section, "Rallying Cry",  60,  0,  100,  5, "|cffFFBB00Health Percentage to use at.")
            -- Victory Rush
            br.ui:createSpinner(section, "Victory Rush", 60, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
        br.ui:checkSectionState(section)
        -------------------------
        --- INTERRUPT OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
            -- Pummel
            br.ui:createCheckbox(section,"Pummel")
            -- Intimidating Shout
            br.ui:createCheckbox(section,"Intimidating Shout - Int")
            -- Storm Bolt Logic
            br.ui:createCheckbox(section, "Storm Bolt Logic", "Stun specific Spells and Mobs")
            -- Interrupt Percentage
            br.ui:createSpinner(section,  "InterruptAt",  70,  0,  95,  5,  "|cffFFBB00Cast Percentage to use at.")
        br.ui:checkSectionState(section)
        ----------------------
        --- TOGGLE OPTIONS ---
        ----------------------
        section = br.ui:createSection(br.ui.window.profile,  "Toggle Keys")
            -- Single/Multi Toggle
            br.ui:createDropdownWithout(section,  "Rotation Mode", br.dropOptions.Toggle,  4)
            --Cooldown Key Toggle
            br.ui:createDropdownWithout(section,  "Cooldown Mode", br.dropOptions.Toggle,  3)
            --Defensive Key Toggle
            br.ui:createDropdownWithout(section,  "Defensive Mode", br.dropOptions.Toggle,  6)
            -- Interrupts Key Toggle
            br.ui:createDropdownWithout(section,  "Interrupt Mode", br.dropOptions.Toggle,  6)
            -- Mover Toggle
            br.ui:createDropdownWithout(section,  "Mover Mode", br.dropOptions.Toggle,  6)
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
    if br.timer:useTimer("debugArms", 0) then
        --Print("Running: "..rotationName)

---------------
--- Toggles ---
---------------
        UpdateToggle("Rotation",0.25)
        UpdateToggle("Cooldown",0.25)
        UpdateToggle("Defensive",0.25)
        UpdateToggle("Interrupt",0.25)
        UpdateToggle("Mover",0.25)
        br.player.mode.mover = br.data.settings[br.selectedSpec].toggles["Mover"]
--------------
--- Locals ---
--------------
        local buff                                          = br.player.buff
        local cast                                          = br.player.cast
        local combatTime                                    = getCombatTime()
        local cd                                            = br.player.cd
        local charges                                       = br.player.charges
        local debuff                                        = br.player.debuff
        local debug                                         = br.addonDebug
        local enemies                                       = br.player.enemies
        local equiped                                       = br.player.equiped
        local essence                                       = br.player.essence
        local gcd                                           = br.player.gcd
        local gcdMax                                        = br.player.gcdMax
        local hastar                                        = hastar or GetObjectExists("target")
        local heirloomNeck                                  = 122667 or 122668
        local inCombat                                      = br.player.inCombat
        local inRaid                                        = br.player.instance == "raid"
        local level                                         = br.player.level
        local mode                                          = br.player.mode
        local opener                                        = br.player.opener
        local php                                           = getHP("player")
        local power                                         = br.player.power.rage.amount()
        local pullTimer                                     = br.DBM:getPulltimer()
        local race                                          = br.player.race
        local rage                                          = br.player.power.rage.amount()
        local spell                                         = br.player.spell
        local talent                                        = br.player.talent
        local traits                                        = br.player.traits
        local units                                         = br.player.units
        local use                                           = br.player.use  
        local ttd                                           = getTTD

        units.get(5)
        units.get(8)
        units.get(8,true)
        enemies.get(8)
        enemies.get(8,"target")
        enemies.get(8,"player",false,true) -- makes enemies.yards8f
        enemies.get(20)
        enemies.yards8r = getEnemiesInRect(10,20,false) or 0


        if profileStop == nil then profileStop = false end

        -- Opener Reset
        if (not inCombat and not GetObjectExists("target")) or opener.complete == nil then
            opener.count = 0
            opener.OPN1 = false
            opener.WB1 = false
            opener.SS1 = false
            opener.BS1 = false
            opener.complete = false
        end

        local Storm_unitList = {
            [131009] = "Spirit of Gold",
            [134388] = "A Knot of Snakes",
            [129758] = "Irontide Grenadier"
        }

        -- Heroic Leap for Charge (Credit: TitoBR)
        local function heroicLeapCharge()
            local thisUnit = units.dyn5
            local sX, sY, sZ = GetObjectPosition(thisUnit)
            local hitBoxCompensation = UnitCombatReach(thisUnit) / GetDistanceBetweenObjects("player",thisUnit)
            local yards = getOptionValue("Heroic Charge") + hitBoxCompensation
            for deg = 0, 360, 45 do
                local dX, dY, dZ = GetPositionFromPosition(sX, sY, sZ, yards, deg, 0)
                if TraceLine(sX, sY, sZ + 2.25, dX, dY, dZ + 2.25, 0x10) == nil and cd.heroicLeap.remain() == 0 and charges.charge.count() > 0 then
                    if not IsAoEPending() then
                        CastSpellByName(GetSpellInfo(spell.heroicLeap))
                        -- cast.heroicLeap("player")
                    end
                    if IsAoEPending() then
                        ClickPosition(dX,dY,dZ)
                        break
                    end
                end
            end
        end
--------------------
--- Action Lists ---
--------------------
    -- Action list - Extras
        function actionList_Extra()
        -- Dummy Test
            if isChecked("DPS Testing") then
                if GetObjectExists("target") then
                    if getCombatTime() >= (tonumber(getOptionValue("DPS Testing"))*60) and isDummy() then
                        StopAttack()
                        ClearTarget()
                        Print(tonumber(getOptionValue("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
                        profileStop = true
                    end
                end
            end -- End Dummy Test
        -- Battle Shout
            if isChecked("Battle Shout") and cast.able.battleShout() then
                for i = 1, #br.friend do
                    local thisUnit = br.friend[i].unit
                    if not UnitIsDeadOrGhost(thisUnit) and getDistance(thisUnit) < 100 and buff.battleShout.remain(thisUnit) < 600 then
                        if cast.battleShout() then debug("Casting Battle Shout") return end
                    end
                end
            end
        -- Berserker Rage
            if isChecked("Berserker Rage") and hasNoControl(spell.berserkerRage) then
                if cast.berserkerRage() then debug("Casting Berserker Rage") return end
            end
        end -- End Action List - Extra
    -- Action List - Defensive
        function actionList_Defensive()
            if useDefensive() then
            -- Healthstone/Health Potion
                if isChecked("Healthstone/Potion") and php <= getOptionValue("Healthstone/Potion")
                    and inCombat and (hasHealthPot() or hasItem(5512))
                then
                    if canUseItem(5512) then debug("Using Healthstone")
                        useItem(5512)
                    elseif canUseItem(getHealthPot()) then debug("Using Health Potion")
                        useItem(getHealthPot())
                    end
                end
            -- Heirloom Neck
                if isChecked("Heirloom Neck") and php <= getOptionValue("Heirloom Neck") then
                    if hasEquiped(heirloomNeck) then 
                        if canUseItem(heirloomNeck) then debug("Using Heirloom Neck")
                            useItem(heirloomNeck)
                        end
                    end
                end
            -- Gift of the Naaru
                if isChecked("Gift of the Naaru") and cast.able.racial() and php <= getOptionValue("Gift of the Naaru") and race=="Draenei" and cd.giftOfTheNaaru.remain() == 0 then
                    if cast.racial() then debug("Casting Gift of the Naaru") return end
                end
            -- Defensive Stance
                if isChecked("Defensive Stance") and cast.able.defensiveStance() then
                    if php <= getOptionValue("Defensive Stance") and not buff.defensiveStance.exists() then
                        if cast.defensiveStance() then debug("Casting Defensive Stance") return end
                    elseif buff.defensiveStance.exists() and php > getOptionValue("Defensive Stance") then
                        if cast.defensiveStance() then debug("Casting Defensive Stance") return end
                    end
                end
            -- Die By The Sword
                if isChecked("Die By The Sword") and cast.able.dieByTheSword() and inCombat and php <= getOptionValue("Die By The Sword") then
                    if cast.dieByTheSword() then debug("Casting Die By The Sword") return end
                end
            -- Intimidating Shout
                if isChecked("Intimidating Shout") and cast.able.intimidatingShout() and inCombat and php <= getOptionValue("Intimidating Shout") then
                    if cast.intimidatingShout() then debug("Casting Intimidating Shout") return end
                end
            -- Rallying Cry
                if isChecked("Rallying Cry") and cast.able.rallyingCry() and inCombat and php <= getOptionValue("Rallying Cry") then
                    if cast.rallyingCry() then debug("Rallying Cry") return end
                end
            -- Victory Rush
                if isChecked("Victory Rush") and (cast.able.victoryRush() or cast.able.impendingVictory()) and inCombat and php <= getOptionValue("Victory Rush") and buff.victorious.exists() then
                    if talent.impendingVictory then
                        if cast.impendingVictory() then debug("Casting Impending Victory") return end
                    else
                        if cast.victoryRush() then debug("Casting Victory Rush") return end
                    end
                end
            end -- End Defensive Check
        end -- End Action List - Defensive
    -- Action List - Interrupts
        function actionList_Interrupts()
            if useInterrupts() then
                if isChecked("Storm Bolt Logic") then
                    if cast.able.stormBolt() then
                        local Storm_list = {
                            274400,
                            274383,
                            257756,
                            276292,
                            268273,
                            256897,
                            272542,
                            272888,
                            269266,
                            258317,
                            258864,
                            259711,
                            258917,
                            264038,
                            253239,
                            269931,
                            270084,
                            270482,
                            270506,
                            270507,
                            267433,
                            267354,
                            268702,
                            268846,
                            268865,
                            258908,
                            264574,
                            272659,
                            272655,
                            267237,
                            265568,
                            277567,
                            265540,
                            268202,
                            258058,
                            257739
                        }
                        for i = 1, #enemies.yards20 do
                            local thisUnit = enemies.yards20[i]
                            local distance = getDistance(thisUnit)
                            for k, v in pairs(Storm_list) do
                                if (Storm_unitList[GetObjectID(thisUnit)] ~= nil or UnitCastingInfo(thisUnit) == GetSpellInfo(v) or UnitChannelInfo(thisUnit) == GetSpellInfo(v)) and getBuffRemain(thisUnit, 226510) == 0 and distance <= 20 then
                                    if cast.stormBolt(thisUnit) then debug("Casting Storm Bolt")
                                        return 
                                    end
                                end
                            end
                        end
                    end
                end
                for i=1, #enemies.yards20 do
                    thisUnit = enemies.yards20[i]
                    distance = getDistance(thisUnit)
                    if canInterrupt(thisUnit,getOptionValue("InterruptAt")) then
                    -- Pummel
                        if isChecked("Pummel") and cast.able.pummel(thisUnit) and distance < 5 then
                            if cast.pummel(thisUnit) then debug("Casting Pummel") return end
                        end
                    -- Intimidating Shout
                        if isChecked("Intimidating Shout - Int") and cast.able.intimidatingShout() and distance < 8 then
                            if cast.intimidatingShout() then debug("Casting Intimidating Shout") return end
                        end
                    end
                end   
            end
        end -- End Action List - Interrupts
    -- Action List - Cooldowns
        function actionList_Cooldowns()
            if getDistance(units.dyn5) < 5 and useCDs() then
            -- Potion
                -- potion
                if isChecked("Potion") and getOptionValue("Potion") == 1 and inRaid and useCDs() and use.able.battlePotionOfStrength()
                then debug("Using Battle Potion of Strength")
                    use.battlePotionOfStrength()
                    else
                        if isChecked("Potion") and getOptionValue("Potion") == 2 and inRaid and useCDs() and use.able.superiorBattlePotionOfStrength()
                        then debug("Using Superior Battle Potion of Strength")
                            use.superiorBattlePotionOfStrength()
                        end
                    end
            -- Racials
                -- actions+=/blood_fury,if=debuff.colossus_smash.up
                -- actions+=/berserking,if=debuff.colossus_smash.up
                -- actions+=/arcane_torrent,if=debuff.colossus_smash.down&cooldown.mortal_strike.remains>1.5&rage<50
                -- actions+=/lights_judgment,if=debuff.colossus_smash.down
                -- actions+=/fireblood,if=debuff.colossus_smash.up
                -- actions+=/ancestral_call,if=debuff.colossus_smash.up
                if isChecked("Racial") and cast.able.racial()
                    or level < 50 and (race == "Orc" or race == "Troll" or race == "DarkIronDwarf" or race == "MagharOrc")
                    and ((race == "BloodElf" and cd.mortalStrike.remain() > 1.5 and power < 50) or race == "LightforgedDraenei")
                then
                    if race == "LightforgedDraenei" then
                        if cast.racial("target","ground") then debug("Casting Racial @Target") return true end
                    else
                        if cast.racial("player") then debug("Casting Racial @Player") return true end
                    end
                end
            -- Avatar
                -- avatar,if=cooldown.colossus_smash.remains<8|(talent.warbreaker.enabled&cooldown.warbreaker.remains<8)
                if isChecked("Avatar") and cast.able.avatar() then
                    if (talent.warbreaker and cd.warbreaker.remain() < 8) or talent.cleave or talent.collateralDamage then
                        if cast.avatar() then debug("Casting Avatar") return end
                    end
                end
            end
            -- Trinkets
            if (getOptionValue("Trinkets") == 1 or (getOptionValue("Trinkets") == 2 and useCDs())) and getDistance(units.dyn5) < 5 then
                for i = 13, 14 do
                    if use.able.slot(i) then
                        -- All Others
                        -- use_items,if=time>20|!equipped.ramping_amplitude_gigavolt_engine|!equipped.vision_of_demise
                        if combatTime > 20 or not (equiped.azsharasFontOfPower(i) or equiped.ashvanesRazorCoral(i) or equiped.visionOfDemise(i)
                            or equiped.rampingAmplitudeGigavoltEngine(i) or equiped.bygoneBeeAlmanac(i)
                            or equiped.jesHowler(i) or equiped.galecallersBeak(i) or equiped.grongsPrimalRage(i))
                        then debug("Using Trinket [Slot: "..i.."]")
                            use.slot(i)
                        end
                        --actions+=/use_item,name=ashvanes_razor_coral,if=!debuff.razor_coral_debuff.up|(target.health.pct<30.1&debuff.conductive_ink_debuff.up)|(!debuff.conductive_ink_debuff.up&(buff.memory_of_lucid_dreams.up|(debuff.colossus_smash.up&!essence.memory_of_lucid_dreams.major)))
                        if equiped.ashvanesRazorCoral(i) and not debuff.razorCoral.exists() or (getHP(units.dyn5) < 30 and debuff.conductiveInk.exists()) or (not debuff.conductiveInk.exists() and buff.memoryOfLucidDreams.exists()) or debuff.colossusSmash.exists(units.dyn5) and not essence.memoryOfLucidDreams.major
                        then debug("Using Ashvane's Razor Coral Trinket [Slot: "..i.."]")
                            use.slot(i)
                        end
                    end
                end
            end
        end -- End Action List - Cooldowns
        -- Essences
         function actionList_Essences()
             if isChecked("Use Essence") then
                 -- Memory of Lucid Dreams
                 --actions+=/memory_of_lucid_dreams,if=!talent.warbreaker.enabled&cooldown.colossus_smash.remains<3|cooldown.warbreaker.remains<3
                 if useCDs() and cast.able.memoryOfLucidDreams() and not talent.warbreaker or cd.warbreaker.remain() < 3 then
                     if cast.memoryOfLucidDreams() then debug("Casting Memory of Lucid Dreams")return end
                 end
                 -- actions+=/blood_of_the_enemy,if=buff.test_of_might.up|(debuff.colossus_smash.up&!azerite.test_of_might.enabled)
                 if useCDs() and cast.able.bloodOfTheEnemy() and buff.testOfMight.exists() and not traits.testOfMight.active and debuff.colossusSmash.exists(units.dyn5) then
                     if cast.bloodOfTheEnemy() then debug("Casting Blood of The Enemy") return end
                 end
                 -- actions+=/guardian_of_azeroth,if=cooldown.colossus_smash.remains<10
                 if useCDs() and cast.able.guardianOfAzeroth() and debuff.colossusSmash.remain(units.dyn5) < 10 then
                    if cast.guardianOfAzeroth() then debug("Casting Guardian of Azeroth") return end
                 end
                -- actions+=/the_unbound_force,if=buff.reckless_force.up
                if cast.able.theUnboundForce() and buff.recklessForce.exists() then
                    if cast.theUnboundForce() then debug("Casting The Unbound Force") return end
                end
                -- actions+=/focused_azerite_beam,if=!debuff.colossus_smash.up&!buff.test_of_might.up
                if cast.able.focusedAzeriteBeam() and not buff.testOfMight.exists() and (#enemies.yards8f >= getOptionValue("Azerite Beam Units") or (useCDs() and #enemies.yards8f > 0)) then
                    local minCount = useCDs() and 1 or getOptionValue("Azerite Beam Units")
                    if cast.focusedAzeriteBeam(nil,"cone",minCount, 8) then debug("Casting Azerite Beam") return true end    
                end
                --actions+=/concentrated_flame,if=!debuff.colossus_smash.up&!buff.test_of_might.up&dot.concentrated_flame_burn.remains=0
                if cast.able.concentratedFlame() and essence.concentratedFlame.active and cd.concentratedFlame.remain() <= gcd and (not debuff.concentratedFlame.exists("target") and not cast.last.concentratedFlame()
                or charges.concentratedFlame.timeTillFull() < gcd) and not buff.testOfMight.exists() and not debuff.colossusSmash.exists(units.dyn5) then
                    if cast.concentratedFlame() then debug("Casting Concentrated Flame") return end
                end
                --actions+=/purifying_blast,if=!debuff.colossus_smash.up&!buff.test_of_might.up
                if useCDs() and cast.able.purifyingBlast() and not buff.testOfMight.exists() and not debuff.colossusSmash.exists(units.dyn5) then
                    if cast.purifyingBlast("best", nil, 1, 8) then debug("Casting Purifying Blast") return true end
                end
                --actions+=/worldvein_resonance,if=!debuff.colossus_smash.up&!buff.test_of_might.up
                if cast.able.worldveinResonance() and not buff.testOfMight.exists() and not debuff.colossusSmash.exists(units.dyn5) then
                    if cast.worldveinResonance() then debug("Casting Worldvein Resonance") return end
                end
                --actions+=/worldvein_resonance,if=!debuff.colossus_smash.up&!buff.test_of_might.up
                if useCDs() and cast.able.rippleInSpace() and not buff.testOfMight.exists() and not debuff.colossusSmash.exists(units.dyn5) then
                    if cast.rippleInSpace() then debug("Casting Ripple In Space") return end
                end
                --actions+=/reaping_flames,if=!debuff.colossus_smash.up&!buff.test_of_might.up
                if useCDs() and cast.able.reapingFlames() and not buff.testOfMight.exists() and not debuff.colossusSmash.exists(units.dyn5) then
                    if cast.reapingFlames() then debug("Casting Reaping Flames") return end
                end
             end
         end
    -- Action List - Pre-Combat
        function actionList_PreCombat()
        -- Flask / Crystal
        -- flask,type=flask_of_the_seventh_demon
            if getOptionValue("Elixir") == 1 and inRaid and not buff.flaskOfTheUndertow.exists() and use.able.flaskOfTheUndertow() then
                if buff.whispersOfInsanity.exists() then buff.whispersOfInsanity.cancel() end
                if buff.felFocus.exists() then buff.felFocus.cancel() end
                if use.flaskOfTheUndertow() then debug("Using Flask of The Undertow") return true end
            end
        end  -- End Action List - Pre-Combat
    -- Action List - Movement
        function actionList_Movement()
            if mode.mover == 1 then
        -- Heroic Leap
                -- heroic_leap
                if isChecked("Heroic Leap") and cast.able.heroicLeap() 
                    and (getOptionValue("Heroic Leap")== 6 or (SpecificToggle("Heroic Leap")
                    and not GetCurrentKeyBoardFocus()))
                then debug("Casting Heroic Leap @Cursor")
                    CastSpellByName(GetSpellInfo(spell.heroicLeap), "cursor") return
                end    
                    -- Best Location
                    if isChecked("Heroic Leap - Target") and getOptionValue("Heroic Leap - Target") == 1 then
                        if cast.heroicLeap("best",nil,1,8) then debug("Casting Heroic Leap @Best") return end
                    end
                    -- Target
                    if isChecked("Heroic Leap - Target") and getOptionValue("Heroic Leap - Target") == 2 and getDistance("target") >= 8 then
                        if cast.heroicLeap("target","ground") then debug("Casting Heroic Leap @Target") return end
                    end
                
        -- Charge
                -- charge
                if isChecked("Charge") and cast.able.charge("target") and getDistance("target") >= 8 then
                    if (cd.heroicLeap.remain() > 0 and cd.heroicLeap.remain() < 43) 
		                or (talent.boundingStride and cd.heroicLeap.remain() > 0 and cd.heroicLeap.remain() < 28)
                        or not isChecked("Heroic Leap") or level < 26 
                    then
                        if cast.charge("target") then debug("Casting Charge") return end
                    end
                end
        -- Heroic Throw
                if isChecked("Heroic Throw") and not cast.last.heroicLeap() and cast.able.heroicThrow("target")
                    and getDistance("target") >= 8 and (cast.last.charge() or charges.charge.count() == 0)
                then
                    if cast.heroicThrow("target") then debug("Casting Heroic Throw") return end
                end        
        -- Hamstring
                if isChecked("Hamstring") and cast.able.hamstring() and not debuff.hamstring.exists("target")
                    and not getFacing("target","player") and getDistance("target") < 5 and GetUnitSpeed("target")>0
                then
                    if cast.hamstring("target") then debug("Casting Hamstring") return end
                end
            end
        end -- End Action List - Movement
        -- Action List - Opener
        function actionList_Opener()
            -- Start Attack
            -- auto_attack
            if isChecked("Opener") and isBoss("target") and not opener.complete then
                if isValidUnit("target") and getDistance("target") < 5
                    and getFacing("player","target") and getSpellCD(61304) == 0
                then
                    -- Begin
                    if not opener.OPN1 then
                        Print("Starting Opener")
                        opener.count = opener.count + 1
                        opener.OPN1 = true
                    -- Warbreaker
                    elseif opener.OPN1 and not opener.WB1 then
                        if cd.warbreaker.remain() > gcd then
                            castOpenerFail("warbreaker","WB1",opener.count)
                        elseif cast.able.warbreaker() then
                            castOpener("warbreaker","WB1",opener.count)
                        end
                        opener.count = opener.count + 1
                        return
                    -- Skullsplitter
                    elseif opener.WB1 and not opener.SS1 then
                        if cd.skullsplitter.remain() > gcd then
                            castOpenerFail("skullsplitter","SS1",opener.count)
                        elseif cast.able.skullsplitter() then
                            castOpener("skullsplitter","SS1",opener.count)
                        end
                        opener.count = opener.count + 1
                        return
                    -- Bladestorm
                    elseif opener.SS1 and not opener.BS1 then
                        if cd.bladestorm.remain() > gcd then
                            castOpenerFail("bladestorm","BS1",opener.count)
                        elseif cast.able.bladestorm() then
                            castOpener("bladestorm","BS1",opener.count)
                        end
                        opener.count = opener.count + 1
                        return
                    elseif opener.BS1 then
                        Print("Opener Complete")
                        opener.count = 0
                        opener.complete = true
                    end
                end
            elseif (UnitExists("target") and not isBoss("target")) or not isChecked("Opener") then
                opener.complete = true
            end
        end -- End Action List - Opener

        -- Action List - Single
        function actionList_Single()
        -- Skullsplitter
            -- skullsplitter,if=rage<60&(!talent.deadly_calm.enabled|buff.deadly_calm.down)
            if cast.able.skullsplitter() and (rage < 60 and (not talent.deadlyCalm or not buff.deadlyCalm.exists())) then
                if cast.skullsplitter() then debug("Casting Skullsplitter") return end
            end
        -- Warbreaker
            -- warbreaker,if=raid_event.adds.up|raid_event.adds.in>40|(raid_event.adds.in>20&talent.anger_management.enabled)
            if (mode.rotation ~= 2 and #enemies.yards8 > 0)	
            and cast.able.warbreaker() and isChecked("Warbreaker") and talent.warbreaker 
            then
                if cast.warbreaker() then debug("Casting Warbreaker") return end
            end
        -- Colossus Smash
            -- warbreaker,if=raid_event.adds.up|raid_event.adds.in>40|(raid_event.adds.in>20&talent.anger_management.enabled)
            if (mode.rotation ~= 2 and #enemies.yards8 >= 0) 
            and cast.able.colossusSmash() and isChecked("Colossus Smash") and not talent.warbreaker 
            then
                if cast.colossusSmash() then debug("Casting ColossusSmash") return end
            end  
        -- Bladestorm
        --actions.single_target+=/bladestorm,if=cooldown.mortal_strike.remains&(!talent.deadly_calm.enabled|buff.deadly_calm.down)&((debuff.colossus_smash.up&!azerite.test_of_might.enabled)|buff.test_of_might.up)&buff.memory_of_lucid_dreams.down&rage<40
            if (mode.rotation ~= 2 and #enemies.yards8 > 0)	
                and cast.able.bladestorm() and isChecked("Bladestorm") 
                and ((debuff.colossusSmash.remain(units.dyn5) > 4.5 and not traits.testOfMight.active) or buff.testOfMight.exists())
                and not talent.ravager and cd.mortalStrike.remain() > 0
                and (not talent.deadlyCalm or not buff.deadlyCalm.exists())
                and cast.able.execute()
                
            then
                if cast.bladestorm() then debug("Bladestorm @Rage: ".. power) return end
            end
        -- Overpower
        --actions.single_target+=/overpower,if=(rage<30&buff.memory_of_lucid_dreams.up&debuff.colossus_smash.up)|(rage<70&buff.memory_of_lucid_dreams.down)
            if cast.able.overpower() and (rage < 30 and buff.memoryOfLucidDreams.exists() and debuff.colossusSmash.exists()) 
            or (rage < 70 and not buff.memoryOfLucidDreams.exists()) then
                if cast.overpower() then debug("Casting Overpower") return end
            end
            -- overpower,if=azerite.seismic_wave.rank=3
            if cast.able.overpower() and traits.seismicWave.rank == 3 then
                if cast.overpower() then debug("Casting Overpower") return end
            end
        -- Overpower
            -- overpower
            if cast.able.overpower() then
                if cast.overpower() then debug("Casting Overpower") return end
            end
        -- Mortal Strike
            -- mortal_strike
            if cast.able.mortalStrike() and debuff.deepWounds.remain() <= 2 or rage >= 40 then
                if cast.mortalStrike() then debug("Casting Mortal Strike") return end
            end
        -- Execute
            -- execute,if=buff.sudden_death.react
            if talent.massacre and getHP(units.dyn5) <= 35 or not talent.massacre and getHP(units.dyn5) <= 20 then
                if cast.able.execute() and rage >= 60 
                and (buff.suddenDeath.exists() or not buff.suddenDeath.exists()) then
                    if cast.execute() then debug("Casting Execute @Rage: " .. power) return end
                end
            end
        -- Whirlwind
            -- whirlwind,if=talent.fervor_of_battle.enabled&(buff.deadly_calm.up|rage>=60)
            if cast.able.whirlwind(nil,"aoe") and (cd.mortalStrike.remain() > 1 and rage > 30)
            and ((talent.massacre and getHP(units.dyn5) > 35) or (not talent.massacre and getHP(units.dyn5) > 20)) 
            and debuff.deepWounds.exists(units.dyn5) then
                if cast.whirlwind(nil,"aoe") then debug("Whirlwind - @Rage: " .. power) return end
            end
        -- Whirlwind
            -- whirlwind,if=debuff.colossus_smash.up|(buff.crushing_assault.up&talent.fervor_of_battle.enabled)
            if cast.able.whirlwind(nil,"aoe") and (cd.mortalStrike.remain() > 1 and rage > 30) and debuff.colossusSmash.exists(units.dyn5) 
            and ((talent.massacre and getHP(units.dyn5) > 35) or (not talent.massacre and getHP(units.dyn5) > 20))
            and (talent.fervorOfBattle or buff.crushingAssault.exists()) and debuff.deepWounds.exists(units.dyn5) then
                if cast.whirlwind(nil,"aoe") then debug("Whirlwind - @Rage: " .. power) return end
            end
            -- whirlwind,if=buff.deadly_calm.up|rage>60
            if cast.able.whirlwind(nil,"aoe") and (buff.deadlyCalm.exists() and (cd.mortalStrike.remain() > 1 and rage > 30)) and debuff.deepWounds.exists(units.dyn5)
            and ((talent.massacre and getHP(units.dyn5) > 35) or (not talent.massacre and getHP(units.dyn5) > 20)) then
                if cast.whirlwind(nil,"aoe") then debug("Whirlwind - @Rage: " .. power) return end
            end
        -- Slam
            -- slam,if=!talent.fervor_of_battle.enabled&(!azerite.test_of_might.enabled|debuff.colossus_smash.up|buff.deadly_calm.up|rage>=60)
            if cast.able.slam() and buff.crushingAssault.exists() then
                if cast.slam() then debug("Casting Slam (CA Buff)") return end
                else
                    if cast.able.slam() and (not traits.testOfMight.active 
                    or buff.deadlyCalm.exists()) and debuff.colossusSmash.exists(units.dyn5) then
                    if cast.slam() then debug("Casting Slam @Rage: " .. power) return end
                end
            end
            -- Rend
            -- rend,if=remains<=duration*0.3&debuff.colossus_smash.down
            if cast.able.rend() and (debuff.rend.refresh(units.dyn5)) and not debuff.colossusSmash.exists(units.dyn5) then
                if cast.rend() then debug("Casting Rend")return end
            end
        -- Ravager
            -- ravager,if=!buff.deadly_calm.up&(cooldown.colossus_smash.remains<2|(talent.warbreaker.enabled&cooldown.warbreaker.remains<2))
            if cast.able.ravager() and not buff.deadlyCalm.exists() or (talent.warbreaker and cd.warbreaker.remain() < 2) and (getOptionValue("Ravager") == 1 or (getOptionValue("Ravager") == 2 and useCDs()))
                
            then
                -- Best Location
                if getOptionValue("Ravager") == 1 then
                    if cast.ravager("best",nil,1,8) then debug("Casting Ravager @Best")return end
                end
                -- Target
                if getOptionValue("Ravager") == 2 then
                    if cast.ravager("target","ground") then debug("Casting Ravager @Target") return end
                end
            end
        -- Deadly Calm
            -- deadly_calm
            if cast.able.deadlyCalm() then
                if cast.deadlyCalm() then debug("Casting Deadly Calm") return end
            end
        -- Cleave
            -- cleave,if=spell_targets.whirlwind>2
            if talent.cleave and cast.able.cleave(nil,"aoe") and ((mode.rotation == 1 and #enemies.yards8f > 2) or (mode.rotation == 2 and #enemies.yards8f > 2)) then
                if cast.cleave(nil,"aoe") then debug("Casting Cleave") return end
            end
        end -- End Action List - Single
    -- Action List - MultiTarget
        function actionList_FiveTarget()
        -- Warbreaker
            -- warbreaker,if=raid_event.adds.up|raid_event.adds.in>40|(raid_event.adds.in>20&talent.anger_management.enabled)
            if (mode.rotation ~= 3 and #enemies.yards8 >= getOptionValue("Warbreaker")) 
            and cast.able.warbreaker() and isChecked("Warbreaker") and talent.warbreaker 
            then
                if cast.warbreaker() then debug("Casting Warbreaker") return end
            end
        -- Colossus Smash
            -- warbreaker,if=raid_event.adds.up|raid_event.adds.in>40|(raid_event.adds.in>20&talent.anger_management.enabled)
            if (mode.rotation ~= 3 and #enemies.yards8 >= getOptionValue("Colossus Smash")) 
            and cast.able.colossusSmash() and isChecked("Colossus Smash") and not talent.warbreaker 
            then
                if cast.colossusSmash() then debug("Casting ColossusSmash") return end
            end            
        -- Cleave
            -- cleave
            if talent.cleave and cast.able.cleave(nil,"aoe") and #enemies.yards8f > 2 then
                if cast.cleave(nil,"aoe") then debug("Casting Cleave") return end
            end
        -- Sweeping Strikes
            -- sweeping_strikes,if=spell_targets.whirlwind>1&(cooldown.bladestorm.remains>10|cooldown.colossus_smash.remains>8|azerite.test_of_might.enabled)
            if isChecked("Sweeping Strikes") and cast.able.sweepingStrikes() and #enemies.yards8 > 1 and mode.rotation ~= 3
                and (cd.bladestorm.remain() > 10 or traits.testOfMight.active or cd.warbreaker.remain() > 8
                or (not isChecked("Bladestorm") or #enemies.yards8 < getOptionValue("Bladestorm")))
            then
                if cast.sweepingStrikes() then debug("Casting Sweeping Strikes") return end
            end
        -- Overpower
            -- overpower
            if cast.able.overpower() then
                if cast.overpower() then debug("Casting Overpower") return end
            end
        -- Bladestorm
            --bladestorm,if=buff.sweeping_strikes.down&(!talent.deadly_calm.enabled|buff.deadly_calm.down)&((debuff.colossus_smash.remains>4.5&!azerite.test_of_might.enabled)|buff.test_of_might.up)
            if (mode.rotation ~= 3 and #enemies.yards8 >= getOptionValue("Bladestorm")) 
            and cast.able.bladestorm() and isChecked("Bladestorm")
            and ((debuff.colossusSmash.remain(units.dyn5) > 4.5 and not traits.testOfMight.active) or buff.testOfMight.exists())
            and not talent.ravager and cd.mortalStrike.remain() > 0
            and (not talent.deadlyCalm or not buff.deadlyCalm.exists())
            and cast.able.execute()
            then
                if cast.bladestorm() then debug("Bladestorm @Rage: ".. power) return end
            end
        -- Mortal Strike
            -- mortal_strike
            if cast.able.mortalStrike() and debuff.deepWounds.remain(units.dyn8AOE) <= 2 or rage >= 40 then
                if cast.mortalStrike() then debug("Casting Mortal Strike") return end
            end
        -- Execute
            -- execute,if=(!talent.cleave.enabled&dot.deep_wounds.remains<2)|(buff.sudden_death.react|buff.stone_heart.react)&(buff.sweeping_strikes.up|cooldown.sweeping_strikes.remains>8)
            if talent.massacre and getHP(units.dyn8AOE) <= 35 or not talent.massacre and getHP(units.dyn8AOE) <= 20 then
                if cast.able.execute() and rage >= 60 
                and (buff.suddenDeath.exists() or not buff.suddenDeath.exists()) then
                    if cast.execute() then debug("Casting Execute @Rage: " .. power) return end
                end
            end
        -- Whirlwind
            -- whirlwind,if=debuff.colossus_smash.up|(buff.crushing_assault.up&talent.fervor_of_battle.enabled)
            if cast.able.whirlwind(nil,"aoe") and cd.mortalStrike.remain() > 1 and debuff.colossusSmash.exists(units.dyn8AOE) or (buff.crushingAssault.exists() and talent.fervorOfBattle) 
            and ((talent.massacre and getHP(units.dyn8AOE) > 35) or (not talent.massacre and getHP(units.dyn8AOE) > 20)) 
            and debuff.deepWounds.exists(units.dyn8AOE) then
                if cast.whirlwind(nil,"aoe") then debug("Whirlwind - @Rage: " .. power) return end
            end
             -- whirlwind,if=buff.deadly_calm.up|rage>60
            if cast.able.whirlwind(nil,"aoe") and cd.mortalStrike.remain() > 1 and buff.deadlyCalm.exists() 
            and ((talent.massacre and getHP(units.dyn8AOE) > 35) or (not talent.massacre and getHP(units.dyn8AOE) > 20)) 
            and debuff.deepWounds.exists(units.dyn8AOE) then
                if cast.whirlwind(nil,"aoe") then debug("Whirlwind - @Rage: " .. power) return end
            end
             -- whirlwind
            if cast.able.whirlwind(nil,"aoe") and cd.mortalStrike.remain() > 1 
            and ((talent.massacre and getHP(units.dyn8AOE) > 35) or (not talent.massacre and getHP(units.dyn8AOE) > 20)) 
            and debuff.deepWounds.exists(units.dyn8AOE) then
                if cast.whirlwind(nil,"aoe") then debug("Whirlwind - @Rage: " .. power) return end
            end
        -- Skullsplitter
            -- skullsplitter,if=rage<60&(!talent.deadly_calm.enabled|buff.deadly_calm.down)
            if cast.able.skullsplitter() and (rage < 60 and (not talent.deadlyCalm or not buff.deadlyCalm.exists())) then
                if cast.skullsplitter() then debug("Skullsplitter @Rage: " .. power) return end
            end
        -- Ravager
            -- ravager,if=(!talent.warbreaker.enabled|cooldown.warbreaker.remains<2)
            if cast.able.ravager() and not talent.warbreaker or cd.warbreaker.remain() < 2 and (getOptionValue("Ravager") == 1 or (getOptionValue("Ravager") == 2 and useCDs()))
                
            then
                -- Best Location
                if getOptionValue("Ravager") == 1 then
                    if cast.ravager("best",nil,1,8) then debug("Casting Ravager @Best") return end
                end
                -- Target
                if getOptionValue("Ravager") == 2 then
                    if cast.ravager("target","ground") then debug("Casting Ravager @Target") return end
                end
            end
        -- Deadly Calm
            -- deadly_calm
            if cast.able.deadlyCalm() then
                if cast.deadlyCalm() then debug("Deadly Clam") return end
            end

        -- Slam
            -- slam,if=!talent.fervor_of_battle.enabled&(!azerite.test_of_might.enabled|debuff.colossus_smash.up|buff.deadly_calm.up|rage>=60)
            if cast.able.slam() and buff.crushingAssault.exists() then
                if cast.slam() then debug("Casting Slam (CA Buff)") return end
                else
                    if cast.able.slam() and (not traits.testOfMight.active 
                    or buff.deadlyCalm.exists()) and debuff.colossusSmash.exists(units.dyn5) then
                    if cast.slam() then debug("Casting Slam @Rage: " .. power) return end
                end
            end
        end -- End Action List - Five Target
-----------------
--- Rotations ---
-----------------
---------------------
--- Begin Profile ---
---------------------
    -- Profile Stop | Pause
        if not inCombat and not hastar and profileStop==true then
            profileStop = false
        elseif (inCombat and profileStop==true) or pause() or mode.rotation==4 then
            return true
        else
            if actionList_Extra() then return end
            if actionList_Defensive() then return end
            if actionList_Movement() then return end
---------------------------------
--- Out Of Combat - Rotations ---
---------------------------------
            if not inCombat and isValidUnit("target") then
                if actionList_PreCombat() then return end
                if getDistance("target")<5 then
                    if not IsCurrentSpell(6603) then
                        StartAttack("target")
                    end
                else
            -- Action List - Movement
                    -- run_action_list,name=movement,if=movement.getDistance(units.dyn5)>5
                    -- if getDistance("target") >= 8 then
                        if actionList_Movement() then return end
                    -- end
                end
            end
            -- Opener
            if actionList_Opener() then return true end

-----------------------------
--- In Combat - Rotations ---
-----------------------------
            if inCombat and isValidUnit(units.dyn5) then
            -- Auto Attack
            --auto_attack
            -- if IsCurrentSpell(6603) and not GetUnitIsUnit(units.dyn5,"target") then
            --     StopAttack()
            -- else
            --     StartAttack(units.dyn5)
            -- end
            if not IsCurrentSpell(6603) then
                StartAttack(units.dyn5)
            end
            -- Action List - Movement
            -- run_action_list,name=movement,if=movement.getDistance(units.dyn5)>5
            -- if getDistance(units.dyn8) > 8 then
            if actionList_Movement() then return end
            -- end
            -- Action List - Interrupts
            if actionList_Interrupts() then return end
            -- Action List - Essences
            if actionList_Essences() then return end
            -- Action List - Cooldowns
            if actionList_Cooldowns() then return end
            -- Action List - Five Target
               -- run_action_list,name=five_target,if=spell_targets.whirlwind>4
                if ((mode.rotation == 1 and #enemies.yards8 >= 2) or (mode.rotation == 2 and #enemies.yards8 > 0)) then
                    if actionList_FiveTarget() then return end
                end
            -- Action List - Single
                -- run_action_list,name=single_target
                if ((mode.rotation == 1 and #enemies.yards8 < 2) or (mode.rotation == 3 and #enemies.yards8 > 0)) then
                    if actionList_Single() then return end
                end
            end -- End Combat Rotation
        end -- Pause
    end -- End Timer
end -- runRotation
local id = 71
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
