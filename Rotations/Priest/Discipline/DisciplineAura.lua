local rotationName = "Aura (Bizkut 8.0)"

--------------
--- COLORS ---
--------------
local colorGreen    = "|cff00FF00"
local colorRed      = "|cffFF0000"
local colorWhite    = "|cffFFFFFF"

---------------
--- Toggles ---
---------------
local function createToggles()
    -- Healer Button
    HealerModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Auto Rotation", tip = "HPS and DPS rotation used.", highlight = 1, icon = br.player.spell.shadowMend},
        [2] = { mode = "ATO", value = 2 , overlay = "Atonement Rotation", tip = "Atonement will keep applied within limit regardless of HP threshold.", highlight = 0, icon = br.player.spell.shiningForce},
        [3] = { mode = "DPS", value = 3 , overlay = "DPS Rotation", tip = "DPS only rotation used.", highlight = 0, icon = br.player.spell.penance},
        [4] = { mode = "Off", value = 4 , overlay = "Atonement Disabled", tip = "Disable Atonement", highlight = 0, icon = br.player.spell.penance}
    };
    CreateButton("Healer",1,0)
    -- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.divineStar },
        [2] = { mode = "On", value = 2 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.divineStar },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.divineStar }
    };
    CreateButton("Cooldown",2,0)
    -- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.powerWordBarrier},
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.powerWordBarrier}
    };
    CreateButton("Defensive",3,0)
    HaloModes = {
        [1] = { mode = "On", value = 1 , overlay = "Halo Enabled", tip = "Halo Enabled.", highlight = 1, icon = br.player.spell.halo},
        [2] = { mode = "Off", value = 2 , overlay = "Halo Disabled", tip = "Halo Disabled.", highlight = 0, icon = br.player.spell.halo}
    };
    CreateButton("Halo",4,0)
    BurstModes = {
        [1] = { mode = "On", value = 1 , overlay = "Burst Enabled", tip = "Burst Atonement enabled when getting Innervate/Symbol of Hope.", highlight = 1, icon = br.player.spell.powerWordRadiance},
        [2] = { mode = "Off", value = 2 , overlay = "Burst Disabled", tip = "Burst Atonement disabled when getting Innervate/Symbol of Hope.", highlight = 0, icon = br.player.spell.powerWordRadiance}
    };
    CreateButton("Burst",5,0)
    -- Decurse Button
    DecurseModes = {
        [1] = { mode = "On", value = 1 , overlay = "Decurse Enabled", tip = "Decurse Enabled", highlight = 1, icon = br.player.spell.purify },
        [2] = { mode = "Off", value = 2 , overlay = "Decurse Disabled", tip = "Decurse Disabled", highlight = 0, icon = br.player.spell.purify }
    };
    CreateButton("Decurse",6,0)
    -- Interrupt Button
    InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.psychicScream },
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.psychicScream }
    };
    CreateButton("Interrupt",7,0)
end

---------------
--- OPTIONS ---
---------------
local function createOptions()
    local optionTable

    local function rotationOptions()
        -------------------------
        -------- UTILITY --------
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Utility")
            -- OOC Healing
            br.ui:createCheckbox(section,"OOC Healing","|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFout of combat healing|cffFFBB00.",1)
            br.ui:createSpinner(section,"OOC Penance", 95, 0, 100, 5,"|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFout of combat penance healing|cffFFBB00.")
            -- Dispel Magic
            br.ui:createCheckbox(section,"Dispel Magic","|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFDispel Magic usage|cffFFBB00.")
            -- Mass Dispel
            br.ui:createDropdown(section, "Mass Dispel", br.dropOptions.Toggle, 1, colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.." Mass Dispel usage.")
            --Body and Soul
            br.ui:createCheckbox(section, "Body and Soul")
            --Angelic Feather
            br.ui:createCheckbox(section, "Angelic Feather")
            --Fade
            br.ui:createSpinner(section, "Fade",  95,  0,  100,  1,  "|cffFFFFFFHealth Percent to Cast At. Default: 95")
            --Shining Force
            br.ui:createSpinner(section, "Shining Force",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At. Default: 50")
            --Psychic Scream
            br.ui:createSpinner(section, "Psychic Scream",  40,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At. Default: 40")
            --Leap Of Faith
            br.ui:createSpinner(section, "Leap Of Faith",  20,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At. Will never use on tank. Default: 20")
            --Dominant Mind
            br.ui:createSpinner(section, "Dominant Mind",  5,  0,  10,  1,  "|cffFFFFFFMinimum Dominant Mind Targets. Default: 5")
            --Resurrection
            br.ui:createCheckbox(section, "Resurrection")
            br.ui:createDropdownWithout(section, "Resurrection - Target", {"|cff00FF00Target","|cffFF0000Mouseover","|cffFFBB00Auto"}, 1, "|cffFFFFFFTarget to cast on")
        br.ui:checkSectionState(section)
        -------------------------
        ---- SINGLE TARGET ------
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Single Target Healing")
            --Atonement
            br.ui:createSpinnerWithout(section, "Atonement HP",  95,  0,  100,  1,  "|cffFFFFFFApply Atonement using Power Word: Shield and Power Word: Radiance. Health Percent to Cast At. Default: 95")
            --Alternate Heal & Damage
            br.ui:createSpinner(section, "Alternate Heal & Damage",  1,  1,  5,  1,  "|cffFFFFFFAlternate Heal & Damage. How many Atonement applied before back to doing damage. Default: 1")
            --Power Word: Shield
           -- br.ui:createSpinner(section, "Power Word: Shield", 99, 0, 100, 1, "","Health Percent to Cast At. Default: 99")
           -- br.ui:createDropdownWithout(section, "PW:S Target", {"|cffFFFFFFPlayer","|cffFFFFFFTarget", "|cffFFFFFFMouseover", "|cffFFFFFFTank", "|cffFFFFFFHealer", "|cffFFFFFFHealer/Tank", "|cffFFFFFFAny"}, 7, "|cffFFFFFFcast Power Word: Shield Target")
            --Shadow Mend
            br.ui:createSpinner(section, "Shadow Mend",  65,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At. Only cast to players without Atonement buff. Default: 65")
            --Shadow Mend Emergency
            br.ui:createSpinner(section, "Shadow Mend Emergency",  35,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At. Will be casted to any members. Default: 35")
            --Shadow Mend Emergency Self
            br.ui:createSpinner(section, "Shadow Mend Emergency Self",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At. Will be casted to self only. Default: 50")
            --Penance Heal
            br.ui:createSpinner(section, "Penance Heal",  60,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At. Default: 60")
            --Debuff Shadow Mend/Penance Heal
            br.ui:createCheckbox(section, "Debuff Helper", "|cffFFFFFFHelp mitigate a few known debuff")
            --Pain Suppression Tank
            br.ui:createSpinner(section, "Pain Suppression Tank",  30,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At. Default: 30")
            --Pain Suppression
            br.ui:createSpinner(section, "Pain Suppression",  15,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At. Default: 15")
        br.ui:checkSectionState(section)
        -------------------------
        ------ AOE HEALING ------
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "AOE Healing")
            --Power Word: Radiance
            br.ui:createSpinner(section, "Power Word: Radiance",  70,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At. Default: 70")
            br.ui:createSpinnerWithout(section, "PWR Targets",  3,  0,  40,  1,  "|cffFFFFFFMinimum PWR Targets. Default: 3")
            --Shadow Covenant
            br.ui:createSpinner(section, "Shadow Covenant",  85,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At. Default: 85")
            br.ui:createSpinnerWithout(section, "Shadow Covenant Targets",  4,  0,  40,  1,  "|cffFFFFFFMinimum Shadow Covenant Targets. Default: 4")
            --Halo
            br.ui:createSpinner(section, "Halo",  90,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At. Default: 90")
            br.ui:createSpinnerWithout(section, "Halo Targets",  5,  0,  40,  1,  "|cffFFFFFFMinimum Halo Targets. Default: 5")
        br.ui:checkSectionState(section)
        -------------------------
        ----- DAMAGE OPTIONS ----
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Damage")
            --Shadow Word: Pain/Purge The Wicked
            br.ui:createCheckbox(section, "Shadow Word: Pain/Purge The Wicked")
            --Schism
            br.ui:createCheckbox(section, "Schism")
            --Penance
            br.ui:createCheckbox(section, "Penance")
            --Power Word: Solace
            br.ui:createCheckbox(section, "Power Word: Solace")
            --Smite
            br.ui:createCheckbox(section, "Smite")
            --Divine Star
            br.ui:createSpinner(section, "Divine Star",  3,  0,  10,  1,  "|cffFFFFFFMinimum Divine Star Targets. Default: 3")
            --Halo Damage
            br.ui:createSpinner(section, "Halo Damage",  3,  0,  10,  1,  "|cffFFFFFFMinimum Halo Damage Targets. Default: 3")
            --Mindbender
            br.ui:createSpinner(section, "Mindbender",  80,  0,  100,  5,  "|cffFFFFFFMana Percent to Cast At. Default: 80")
            --Shadowfiend
            br.ui:createSpinner(section, "Shadowfiend",  80,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At. Default: 80")
            br.ui:createSpinnerWithout(section, "Shadowfiend Targets",  3,  0,  40,  1,  "|cffFFFFFFMinimum Shadowfiend Targets. Default: 3")
        br.ui:checkSectionState(section)
        -------------------------
        ------- COOLDOWNS -------
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
            --Disable CD during Speed: Slow on Chromatic Anomaly
            br.ui:createCheckbox(section, "Disable CD during Speed: Slow","|cffFFFFFFDisable CD during Speed: Slow debuff on Chromatic Anomaly")
            --High Botanist Tel'arn Parasitic Fetter dispel helper. Dispel 8 yards from allies
            br.ui:createCheckbox(section, "Parasitic Fetter Dispel Helper","|cffFFFFFFHigh Botanist Tel'arn Parasitic Fetter dispel helper")
            --Drink
            br.ui:createSpinner(section, "Drink",   50,  0,  100,  5,   "|cffFFFFFFMinimum mana to drink Ley-Enriched Water. Default: 50")
            --Pre Pot
            br.ui:createSpinner(section, "Pre-Pot Timer",  3,  1,  10,  1,  "|cffFFFFFFSet to desired time for Pre-Pot using Potion of Prolonged Power (DBM Required). Second: Min: 1 / Max: 10 / Interval: 1. Default: 3")
            --Pre-pull Opener
            br.ui:createSpinner(section, "Pre-pull Opener",  12,  10,  15,  1,  "|cffFFFFFFSet to desired time for Pre-pull Atonement blanket (DBM Required). Second: Min: 10 / Max: 15 / Interval: 1. Default: 12")
            --Int Pot
            br.ui:createSpinner(section, "Prolonged Pot",  50,  0,  100,  5,  "|cffFFFFFFUse Potion of Prolonged Power. Default: 50")
            br.ui:createSpinnerWithout(section, "Pro Pot Targets",  3,  0,  40,  1,  "|cffFFFFFFMinimum Prolonged Pot Targets. Default: 3")
            --Mana Potion
            br.ui:createSpinner(section, "Mana Potion",  30,  0,  100,  5,  "|cffFFFFFFMana Percent to use Ancient Mana Potion. Default: 30")
            --Trinkets
            br.ui:createSpinner(section, "Trinket 1",  70,  0,  100,  5,  "Health Percent to Cast At. Default: 70")
            br.ui:createSpinnerWithout(section, "Min Trinket 1 Targets",  3,  1,  40,  1,  "","Minimum Trinket 1 Targets(This includes you). Default: 3", true)
            br.ui:createSpinner(section, "Trinket 2",  70,  0,  100,  5,  "Health Percent to Cast At. Default: 70")
            br.ui:createSpinnerWithout(section, "Min Trinket 2 Targets",  3,  1,  40,  1,  "","Minimum Trinket 2 Targets(This includes you). Default: 3", true)
            --Touch of the Void
            if hasEquiped(128318) then
                br.ui:createCheckbox(section,"Touch of the Void")
            end
            --Rapture when get Innervate
            br.ui:createCheckbox(section, "Rapture when get Innervate", "|cffFFFFFFCast Rapture and PWS when get Innervate/Symbol of Hope. Default: Unchecked")
            --Rapture
            br.ui:createSpinner(section, "Rapture",  60,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At. Default: 60")
            br.ui:createSpinnerWithout(section, "Rapture Targets",  3,  0,  40,  1,  "|cffFFFFFFMinimum Rapture Targets. Default: 3")
            --Power Word: Barrier
            br.ui:createSpinner(section, "Power Word: Barrier",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At. Default: 50")
            br.ui:createSpinnerWithout(section, "PWB Targets",  3,  0,  40,  1,  "|cffFFFFFFMinimum PWB Targets. Default: 3")
            --Luminous Barrier
            br.ui:createSpinner(section, "Luminous Barrier", 30, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At. Default: 30")
            br.ui:createSpinnerWithout(section, "LB Targets", 3, 0, 40, 1, "|cffFFFFFFMinimum LB Targets. Default: 3")
            --Evangelism
            br.ui:createSpinner(section, "Evangelism",  70,  0,  100,  1,  "|cffFFFFFFHealth Percent to Cast At. Default: 70")
            br.ui:createSpinnerWithout(section, "Evangelism Targets",  3,  0,  40,  1,  "|cffFFFFFFTarget count to Cast At. Default: 3")
            br.ui:createSpinnerWithout(section, "Atonement for Evangelism",  3,  0,  40,  1,  "|cffFFFFFFMinimum Atonement count to Cast At. Default: 3")
        br.ui:checkSectionState(section)
        -------------------------
        ------- DEFENSIVE -------
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
        -- Desperate Prayer
            br.ui:createSpinner(section, "Desperate Prayer", 40, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At. Default: 40")
        -- Healthstone
            br.ui:createSpinner(section, "Pot/Stoned",  35,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At. Default: 35")
        -- Heirloom Neck
            br.ui:createSpinner(section, "Heirloom Neck",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.. Default: 60");
        -- Gift of The Naaru
            if br.player.race == "Draenei" then
                br.ui:createSpinner(section, "Gift of the Naaru",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At. Default: 50")
            end
        br.ui:checkSectionState(section)
        -- Interrupt Options
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
        -- Shining Force - Int
            br.ui:createCheckbox(section,"Shining Force - Int")
        -- Psychic Scream - Int
            br.ui:createCheckbox(section,"Psychic Scream - Int")
        -- Quaking Palm - Int
            br.ui:createCheckbox(section,"Quaking Palm - Int")
        -- Interrupt Percentage
            br.ui:createSpinner(section, "Interrupt At",  0,  0,  95,  5,  "|cffFFFFFFCast Percent to Cast At. Default: 0")
        br.ui:checkSectionState(section)
        -- Toggle Key Options
        section = br.ui:createSection(br.ui.window.profile, "Toggle Keys")
        -- Single/Multi Toggle
            br.ui:createDropdown(section, "Healer Mode", br.dropOptions.Toggle,  4)
        -- Cooldown Key Toggle
            br.ui:createDropdown(section, "Cooldown Mode", br.dropOptions.Toggle,  3)
        -- Defensive Key Toggle
            br.ui:createDropdown(section, "Defensive Mode", br.dropOptions.Toggle,  6)
        -- Pause Toggle
            br.ui:createDropdown(section, "Pause Mode", br.dropOptions.Toggle,  6)
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
    if br.timer:useTimer("debugDiscipline", 0.1) then
        --Print("Running: "..rotationName)

---------------
--- Toggles --- -- List toggles here in order to update when pressed
---------------
        UpdateToggle("Healer",0.25)
        UpdateToggle("Cooldown",0.25)
        UpdateToggle("Defensive",0.25)
        UpdateToggle("Halo",0.25)
        UpdateToggle("Burst",0.25)
        UpdateToggle("Decurse",0.25)
        UpdateToggle("Interrupt",0.25)
        br.player.mode.healer = br.data.settings[br.selectedSpec].toggles["Healer"]
        br.player.mode.halo = br.data.settings[br.selectedSpec].toggles["Halo"]
        br.player.mode.burst = br.data.settings[br.selectedSpec].toggles["Burst"]
        br.player.mode.decurse = br.data.settings[br.selectedSpec].toggles["Decurse"]

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
        local friends                                       = friends or {}
        local gcd                                           = br.player.gcd
        local healPot                                       = getHealthPot()
        local inCombat                                      = br.player.inCombat
        local inInstance                                    = br.player.instance=="party"
        local inRaid                                        = br.player.instance=="raid"
        local lastSpell                                     = lastSpellCast
        local level                                         = br.player.level
        local lootDelay                                     = getOptionValue("LootDelay")
        local lowestHP                                      = br.friend[1].unit
        local mana                                          = getMana("player")
        local mode                                          = br.player.mode
        local perk                                          = br.player.perk
        local php                                           = br.player.health
        local power, powmax, powgen                         = br.player.power.mana.amount(), br.player.power.mana.max(), br.player.power.mana.regen()
        local pullTimer                                     = br.DBM:getPulltimer()
        local race                                          = br.player.race
        local racial                                        = br.player.getRacial()
        local solo                                          = br.player.instance=="none"
        local spell                                         = br.player.spell
        local talent                                        = br.player.talent
        local ttd                                           = getTTD
        local traits                                        = br.player.traits
        local ttm                                           = br.player.power.mana.ttm()
        local units                                         = br.player.units
        local lowest                                        = {}    --Lowest Unit
        lowest.hp                                           = br.friend[1].hp
        lowest.role                                         = br.friend[1].role
        lowest.unit                                         = br.friend[1].unit
        lowest.range                                        = br.friend[1].range
        lowest.guid                                         = br.friend[1].guid
        local tank                                          = {}    --Tank

        units.get(5)
        units.get(30)
        units.get(40)
        enemies.get(24)
        enemies.get(30)
        enemies.get(40)
        friends.yards40 = getAllies("player",40)

        atonementCount = 0
        for i=1, #br.friend do
            local atonementRemain = getBuffRemain(br.friend[i].unit,spell.buffs.atonement,"player") or 0 -- 194384
            if atonementRemain > 0 then
                atonementCount = atonementCount + 1
            end
        end

        if not healCount then
            healCount = 0
        end

        local freeMana                                      = buff.innervate.exists() or buff.symbolOfHope.exists()
        local freeCast                                      = freeMana or mode.healer == 3 or mana > 90
        local epTrinket                                     = hasEquiped(140805) and getBuffRemain("player", 225766) > 1
        local norganBuff                                    = not isMoving("player") or UnitBuffID("player", 236373) -- Norgannon's Foresight buff

        if leftCombat == nil then leftCombat = GetTime() end
        if profileStop == nil then profileStop = false end

        local totalHealth = 0
        local avg
        local function avgHealth()
            avg = 0
            for i=1, #br.friend do
                totalHealth = totalHealth + br.friend[i].hp
            end
            avg = totalHealth/#br.friend
            return avg
        end




--------------------
--- Action Lists ---
--------------------
        -- Velen's Future Sight
        function actionList_CheckVelen()
            if hasEquiped(144258) then
                if GetItemCooldown(144258)==0 then
                    useItem(144258)
                end
            end
        end
        -- Mitigate heavy damage
        function actionList_MitigateDamage(u)
            if (isChecked("Alternate Heal & Damage") and healCount < getValue("Alternate Heal & Damage")) or not isChecked("Alternate Heal & Damage") then
                if norganBuff then
                    if getBuffRemain(br.friend[u].unit, spell.buffs.atonement, "player") < 1 then
                        if cast.powerWordShield(br.friend[u].unit) then
                            if cast.shadowMend(br.friend[u].unit) then
                                healCount = healCount + 1
                            end
                        end
                    elseif cast.shadowMend(br.friend[u].unit) then
                        healCount = healCount + 1
                    end
                elseif isMoving("player") and getSpellCD(spell.penance) <= 0 then
                    if cast.penance(br.friend[u].unit) then
                        healCount = healCount + 1
                    end
                end
            end
        end
        -- Action List - Interrupts
        function actionList_Interrupts()
            if useInterrupts() then
                for i=1, #enemies.get(40) do
                    thisUnit = enemies.get(40)[i]
                    if canInterrupt(thisUnit,getOptionValue("Interrupt At")) then
                -- Shining Force - Int
                        if isChecked("Shining Force - Int") and getDistance(thisUnit) < 40 then
                            if cast.shiningForce() then return end
                        end
                -- Psychic Scream - Int
                        if isChecked("Psychic Scream - Int") and getDistance(thisUnit) < 8 then
                            if cast.psychicScream() then return end
                        end
                -- Quaking Palm
                        if isChecked("Quaking Palm - Int") and getDistance(thisUnit) < 5 then
                            if cast.quakingPalm(thisUnit) then return end
                        end
                    end
                end
            end -- End useInterrupts check
        end -- End Action List - Interrupts
        --Check Atonement
        function actionList_CheckAtonement()
            if buff.rapture.exists("player") then
                for i = 1, #br.friend do
                    if mode.healer == 1 or mode.healer == 2 or (mode.healer == 3 and UnitIsUnit(br.friend[i].unit,"player")) then
                        if getBuffRemain(br.friend[i].unit, spell.buffs.atonement, "player") < 1 then
                            if cast.powerWordShield(br.friend[i].unit) then return end
                        end
                    end
                end
            end
            -- Getting Innervate/Symbol of Hope. Don't waste it
            if not buff.rapture.exists("player") and mode.burst == 1 and freeMana then
                for i = 1, #br.friend do
                    if mode.healer == 1 or mode.healer == 2 or (mode.healer == 3 and UnitIsUnit(br.friend[i].unit,"player")) then
                        if getBuffRemain(br.friend[i].unit, spell.buffs.atonement, "player") < 1 and not buff.powerWordShield.exists(br.friend[i].unit) then
                            if cast.powerWordShield(br.friend[i].unit) then return end
                        end
                    end
                end
                healCount = healCount + 1
            end
            if traits.giftOfForgiveness.rank() > 0 and #br.friend >= 3 and avgHealth() >= getValue("Atonement HP") then
                if atonementCount < 3 then
                    for i = 1, #br.friend do
                        if getBuffRemain(br.friend[i].unit, spell.buffs.atonement, "player") < 1 and not buff.powerWordShield.exists(br.friend[i].unit) then
                            if cast.powerWordShield(br.friend[i].unit) then return end
                        end
                    end
                end
            end
            if not buff.rapture.exists("player") and ((isChecked("Alternate Heal & Damage") and healCount < getValue("Alternate Heal & Damage")) or (mode.healer == 2 and (inCombat or #enemies.get(40) > 0)) or not isChecked("Alternate Heal & Damage")) then
                for i = 1, #br.friend do
                    if mode.healer == 2 or epTrinket or (getBuffRemain("player", spell.buffs.atonement, "player") < 1 and UnitIsUnit(br.friend[i].unit,"player")) then
                        actionList_SpreadAtonement(i)
                    elseif br.friend[i].hp <= getValue("Atonement HP") then
                        if mode.healer == 1 or (mode.healer == 3 and UnitIsUnit(br.friend[i].unit,"player")) then
                            actionList_SpreadAtonement(i)
                        end
                    end
                end
            end
            --Shadow Mend Emergency
            --Shadow Mend Emergency Self
            if isChecked("Shadow Mend Emergency") then
                for i = 1, #br.friend do
                    if br.friend[i].hp <= getValue("Shadow Mend Emergency") then
                        if mode.healer == 1 or mode.healer == 2 or (mode.healer == 3 and UnitIsUnit(br.friend[i].unit,"player")) then
                            if cast.shadowMend(br.friend[i].unit) then return end
                        end
                    end
                end
            end
            if isChecked("Shadow Mend Emergency Self") then
                if php <= getValue("Shadow Mend Emergency Self") then
                    if cast.shadowMend("player") then return end
                end
            end
        end
        --Spread Atonement
        function actionList_SpreadAtonement(u)
            if getLineOfSight("player",br.friend[u].unit) and (inInstance or inRaid or inCombat or isInPvP() or not solo) and mode.healer ~= 4 then
                -- Ephemeral Paradox trinket with Temporal Shift buff
                if epTrinket and not freeMana and norganBuff then
                    if cast.shadowMend(lowest.unit) then
                        healCount = healCount + 1
                    end
                end
                --Power Word Shield
                if getBuffRemain(br.friend[u].unit, spell.buffs.atonement, "player") < 1 and (not norganBuff or charges.powerWordRadiance.count() == 0 or mode.healer ~= 2 or (mode.healer == 2 and #br.friend - atonementCount < 3)) and not buff.powerWordShield.exists(br.friend[u].unit) and not solo and br.friend[u].hp <= getValue("Atonement HP") then
                    if cast.powerWordShield(br.friend[u].unit) then
                        healCount = healCount + 1
                    end
                elseif mode.healer == 2 and #br.friend - atonementCount >= 3 and charges.powerWordRadiance.count() >= 1 and norganBuff and not cast.last.powerWordRadiance() then
                    if cast.powerWordRadiance(lowest.unit) then
                        healCount = healCount + 1
                    end
                end
            end
        end
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
        -- Heirloom Neck
                if isChecked("Heirloom Neck") and php <= getOptionValue("Heirloom Neck") then
                    if hasEquiped(122668) then
                        if GetItemCooldown(122668)==0 then
                            useItem(122668)
                        end
                    end
                end
        -- Gift of the Naaru
                if isChecked("Gift of the Naaru") and php <= getOptionValue("Gift of the Naaru") and php > 0 and br.player.race == "Draenei" then
                    if cast.giftOfTheNaaru() then return end
                end
                if isChecked("Desperate Prayer") and php <= getOptionValue("Desperate Prayer") then
                    if cast.desperatePrayer() then return end
                end
            end -- End Defensive Toggle
        end -- End Action List - Defensive
        -----------------
        --- COOLDOWNS ---
        -----------------
        function actionList_Cooldowns()
            if useCDs() then
                if isChecked("Disable CD during Speed: Slow") and UnitDebuffID("player",207011) then
                    return --Speed: Slow debuff during the Chromatic Anomaly encounter
                else
                    --Racials
                    --blood_fury
                    --arcane_torrent
                    --berserking
                    if (br.player.race == "Orc" or br.player.race == "Troll" or br.player.race == "Blood Elf") then
                        if br.player.castRacial() then return end
                    end
                    --potion,name=prolonged_power
                    if isChecked("Prolonged Pot") and canUse(142117) and not solo then
                        if getLowAllies(getValue("Prolonged Pot")) >= getValue("Pro Pot Targets") then
                            useItem(142117)
                        end
                    end
                    --Touch of the Void
                    if isChecked("Touch of the Void") and getDistance(units.dyn5)<5 then
                        if hasEquiped(128318) then
                            if GetItemCooldown(128318)==0 then
                                useItem(128318)
                            end
                        end
                    end
                    -- Mana Potion
                    if isChecked("Mana Potion") and mana <= getValue("Mana Potion")then
                        if hasItem(127835) then
                            useItem(127835)
                            return true
                        end
                    end
                    --Trinkets
                    if isChecked("Trinket 1") and canUse(13) and getLowAllies(getValue("Trinket 1")) >= getValue("Min Trinket 1 Targets") then
                        useItem(13)
                        return true
                    end
                    if isChecked("Trinket 2") and canUse(14) and getLowAllies(getValue("Trinket 2")) >= getValue("Min Trinket 2 Targets") then
                        useItem(14)
                        return true
                    end
                    -- Rapture when getting Innervate/Symbol
                    if isChecked("Rapture when get Innervate") and freeMana then
                        if cast.rapture() then return end
                    end
                    --Rapture
                    if isChecked("Rapture") then
                        if getLowAllies(getValue("Rapture")) >= getValue("Rapture Targets") then
                            if cast.rapture() then return end
                        end
                    end
                    --Luminous Barrier
                    if isChecked("Luminous Barrier") and talent.luminousBarrier and (mode.healer == 1 or mode.healer == 2) then
                        if getLowAllies(getValue("Luminous Barrier")) >= getValue("LB Targets") then
                            if cast.luminousBarrier(lowest.unit) then return end
                        end
                    end
                    --Power Word: Barrier
                    if isChecked("Power Word: Barrier") and not talent.luminousBarrier and (mode.healer == 1 or mode.healer == 2) then
                        if getLowAllies(getValue("Power Word: Barrier")) >= getValue("PWB Targets") then
                            if cast.powerWordBarrier(lowest.unit) then return end
                        end
                    end
                    --Evangelism
                    if isChecked("Evangelism") and talent.evangelism and (atonementCount >= getValue("Atonement for Evangelism") or (not inRaid and atonementCount >= 5)) and not buff.rapture.exists("player") and not freeMana then
                        if getLowAllies(getValue("Evangelism")) >= getValue("Evangelism Targets") then
                            if cast.evangelism() then return end
                        end
                    end
                end
            end
        end -- End Action List - Cooldowns
        -- Action List - Pre-Combat
        function actionList_PreCombat()
            prepullOpener = inRaid and isChecked("Pre-pull Opener") and pullTimer <= getOptionValue("Pre-pull Opener") and not buff.rapture.exists("player")
            if isChecked("Pre-Pot Timer") and (pullTimer <= getOptionValue("Pre-Pot Timer") or prepullOpener) and canUse(142117) and not solo then
                useItem(142117)
            end
             -- Pre-pull Opener
            if prepullOpener then
                if not openerTime then
                    openerTime = GetTime()
                end
                if pullTimer > 5 then
                    for i = 1, #br.friend do
                        actionList_SpreadAtonement(i)
                    end
                end
                if pullTimer < 5 and charges.powerWordRadiance.count() >= 1 and #br.friend - atonementCount >= 3 and not cast.last.powerWordRadiance() then
                    for i = 1, charges.powerWordRadiance.count() do
                        cast.powerWordRadiance(lowest.unit)
                    end
                elseif mana < 90 then
                    useItem(138292)
                end
            end
            if not isMoving("player") and isChecked("Drink") and mana <= getOptionValue("Drink") and canUse(138292) then
                useItem(138292)
            end
        end  -- End Action List - Pre-Combat
        --OOC
        function actionList_OOCHealing()
            if isChecked("OOC Healing") and (not inCombat or #getEnemies("player", 40) < 1) then -- ooc or in combat but nothing to attack
                for i = 1, #br.friend do
                    if UnitDebuffID(br.friend[i].unit,225484) or UnitDebuffID(br.friend[i].unit,240559) or UnitDebuffID(br.friend[i].unit,209858) then
                        flagDebuff = br.friend[i].guid
                    end
                    if isChecked("OOC Penance") and getSpellCD(spell.penance) <= 0 then
                        if br.friend[i].hp <= getValue("OOC Penance") then
                            if mode.healer == 1 or mode.healer == 2 or (mode.healer == 3 and UnitIsUnit(br.friend[i].unit,"player")) then
                                if cast.penance(br.friend[i].unit) then return end
                            end
                        end
                    end
                    if norganBuff and (br.friend[i].hp < 90 or flagDebuff == br.friend[i].guid) and lastSpell ~= spell.shadowMend then
                        if getBuffRemain(br.friend[i].unit, spell.buffs.atonement, "player") < 1 and not buff.powerWordShield.exists(br.friend[i].unit) then
                            if cast.powerWordShield(br.friend[i].unit) then
                                if cast.shadowMend(br.friend[i].unit) then return true end
                            end
                        elseif cast.shadowMend(br.friend[i].unit) then return true end
                    elseif (br.friend[i].hp < 95 or flagDebuff == br.friend[i].guid) and not buff.powerWordShield.exists(br.friend[i].unit) then
                        if cast.powerWordShield(br.friend[i].unit) then return true end
                    end
                    flagDebuff = nil
                end
            end
        end
        --AOE Healing
        function actionList_AOEHealing()
            --Shadow Covenant
            if isChecked("Shadow Covenant") and talent.shadowCovenant and (mode.healer == 1 or mode.healer == 2) then
                if getLowAllies(getValue("Shadow Covenant")) >= getValue("Shadow Covenant Targets") and lastSpell ~= spell.shadowCovenant then
                    if cast.shadowCovenant(lowest.unit) then return end
                end
            end
            --Power Word: Radiance
            if isChecked("Power Word: Radiance") and (mode.healer == 1 or mode.healer == 2) and charges.powerWordRadiance.count() >= 1 and norganBuff and not cast.last.powerWordRadiance() then
                if getLowAllies(getValue("Power Word: Radiance")) >= getValue("PWR Targets") then
                    if cast.powerWordRadiance(lowest.unit) then
                        healCount = healCount + 1
                    end
                end
            end
            --Halo
            if isChecked("Halo") and mode.halo == 1 and norganBuff and not buff.rapture.exists("player") then
                if getLowAllies(getValue("Halo")) >= getValue("Halo Targets") then
                    if cast.halo(lowest.unit) then return end
                end
            end
        end
        --Single Target Defence
        function actionList_SingleTargetDefence()
            --Leap Of Faith
            if isChecked("Leap Of Faith") and (mode.healer == 1 or mode.healer == 2) and inCombat then
                for i = 1, #br.friend do
                    if br.friend[i].hp <= getValue("Leap Of Faith") and not UnitIsUnit(br.friend[i].unit,"player") and UnitGroupRolesAssigned(br.friend[i].unit) ~= "TANK" then
                        if cast.leapOfFaith(br.friend[i].unit) then return end
                    end
                end
            end
            --Pain Suppression Tank
            if isChecked("Pain Suppression Tank") and (mode.healer == 1 or mode.healer == 2) and inCombat then
                for i = 1, #br.friend do
                    if br.friend[i].hp <= getValue("Pain Suppression Tank") and getBuffRemain(br.friend[i].unit, spell.painSuppression, "player") < 1 and UnitGroupRolesAssigned(br.friend[i].unit) == "TANK" then
                        if cast.painSuppression(br.friend[i].unit) then
                            actionList_MitigateDamage(i)
                        end
                    end
                end
            end
            --Pain Suppression
            if isChecked("Pain Suppression") and inCombat then
                for i = 1, #br.friend do
                    if br.friend[i].hp <= getValue("Pain Suppression") and getBuffRemain(br.friend[i].unit, spell.painSuppression, "player") < 1 then
                        if mode.healer == 1 or mode.healer == 2 or (mode.healer == 3 and UnitIsUnit(br.friend[i].unit,"player")) then
                            if cast.painSuppression(br.friend[i].unit) then
                                actionList_MitigateDamage(i)
                            end
                        end
                    end
                end
            end
            --Psychic Scream
            if isChecked("Psychic Scream") and inCombat then
                if php <= getValue("Psychic Scream") then
                    if cast.psychicScream() then return end
                end
            end
            --Shining Force
            if isChecked("Shining Force") and talent.shiningForce and inCombat then
                if getLowAllies(getValue("Shining Force")) >= 1 then
                    if mode.healer == 1 or mode.healer == 2 or (mode.healer == 3 and UnitIsUnit(lowest.unit,"player")) then
                        if cast.shiningForce(lowest.unit) then return end
                    end
                end
            end
            --Power Word: Shield
            --if isChecked("Power Word: Shield") and getSpellCD(spell.powerWordShield) <= 0 and not buff.rapture.exists("player") then
            --     -- Player
            --     if getOptionValue("PW:S Target") == 1 then
            --         if php <= getValue("Power Word: Shield") and not buff.powerWordShield.exists("player") then
            --             if cast.powerWordShield("player") then
            --                 healCount = healCount + 1
            --             end
            --         end
            --         -- Target
            --     elseif getOptionValue("PW:S Target") == 2 then
            --         if getHP("target") <= getValue("Power Word: Shield") and not buff.powerWordShield.exists("target") then
            --             if cast.powerWordShield("target") then
            --                 healCount = healCount + 1
            --             end
            --         end
            --         -- Mouseover
            --     elseif getOptionValue("PW:S Target") == 3 then
            --         if getHP("mouseover") <= getValue("Power Word: Shield") and not buff.powerWordShield.exists("mouseover") then
            --             if cast.powerWordShield("mouseover") then
            --                 healCount = healCount + 1
            --             end
            --         end
            --     elseif lowest.hp <= getValue("Power Word: Shield") and not buff.powerWordShield.exists(lowest.unit) then
            --         -- Tank
            --         if getOptionValue("PW:S Target") == 4 then
            --             if (lowest.role) == "TANK" then
            --                 if cast.powerWordShield(lowest.unit) then
            --                     healCount = healCount + 1
            --                 end
            --             end
            --         -- Healer
            --         elseif getOptionValue("PW:S Target") == 5 then
            --             if (lowest.role) == "HEALER" then
            --                 if cast.powerWordShield(lowest.unit) then
            --                     healCount = healCount + 1
            --                 end
            --             end
            --         -- Healer/Tank
            --         elseif getOptionValue("PW:S Target") == 6 then
            --             if (lowest.role) == "HEALER" or (lowest.role) == "TANK" then
            --                 if cast.powerWordShield(lowest.unit) then
            --                     healCount = healCount + 1
            --                 end
            --             end
            --         -- Any
            --         elseif  getOptionValue("PW:S Target") == 7 and not solo then
            --             if cast.powerWordShield(lowest.unit) then
            --                 healCount = healCount + 1
            --             end
            --         end
            --     end
            -- end
        end
        --Single Target Heal
        function actionList_SingleTargetHeal()
            if isMoving("player") then
                if not runningTime then runningTime = GetTime()
                end
                if isChecked("Angelic Feather") and talent.angelicFeather and (not buff.angelicFeather.exists("player") or GetTime() > runningTime + 5) then
                    if cast.angelicFeather("player") then
                        runningTime = GetTime()
                        RunMacroText("/stopspelltarget")
                    end
                end
                -- Power Word: Shield Body and Soul
                if isChecked("Body and Soul") and talent.bodyAndSoul and not buff.bodyAndSoul.exists("player") then
                    if cast.powerWordShield("player") then return end
                end
            end
            -- Dispel Magic
            if isChecked("Dispel Magic") and canDispel("target",spell.dispelMagic) and not isBoss() and GetObjectExists("target") then
                if cast.dispelMagic("target") then return end
            end
            -- Mass Dispel
            if norganBuff and isChecked("Mass Dispel") and (SpecificToggle("Mass Dispel") and not GetCurrentKeyBoardFocus()) then
                CastSpellByName(GetSpellInfo(spell.massDispel),"cursor")
                return true
            end
            --Resurrection
            if isChecked("Resurrection") and not inCombat and not isMoving("player") then
                if getOptionValue("Resurrection - Target") == 1
                    and UnitIsPlayer("target") and UnitIsDeadOrGhost("target") and UnitIsFriend("target","player")
                then
                    if cast.resurrection("target","dead") then return end
                end
                if getOptionValue("Resurrection - Target") == 2
                    and UnitIsPlayer("mouseover") and UnitIsDeadOrGhost("mouseover") and UnitIsFriend("mouseover","player")
                then
                    if cast.resurrection("mouseover","dead") then return end
                end
                if getOptionValue("Resurrection - Target") == 3 then
                    for i =1, #br.friend do
                        if UnitIsPlayer(br.friend[i].unit) and UnitIsDeadOrGhost(br.friend[i].unit) and lastSpell ~= spell.resurrection then
                            if cast.resurrection(br.friend[i].unit) then return end
                        end
                    end
                end
            end
            --Purify
            if mode.decurse == 1 then
                for i = 1, #br.friend do
                    --High Botanist Tel'arn Parasitic Fetter dispel helper
                    if isChecked("Parasitic Fetter Dispel Helper Raid") and UnitDebuffID(br.friend[i].unit,218304) then
                        if #getAllies(br.friend[i].unit,15) < 2 then
                            if cast.purify(br.friend[i].unit) then return end
                        end
                    elseif UnitDebuffID(br.friend[i].unit,145206) then
                        if cast.purify(br.friend[i].unit) then return end
                    else
                        for n = 1,40 do
                            local buff,_,count,bufftype,duration = UnitDebuff(br.friend[i].unit, n)
                            if buff then
                                if (bufftype == "Disease" or bufftype == "Magic") and (mode.healer == 1 or mode.healer == 2 or (mode.healer == 3 and UnitIsUnit(br.friend[i].unit,"player"))) then
                                    if getSpellCD(spell.purify) > 1 and norganBuff then
                                        if castGround(br.friend[i].unit, spell.massDispel, 30) then return end
                                    elseif cast.purify(br.friend[i].unit) then return end
                                end
                            end
                        end
                    end
                end
            end
            --Debuff Shadow Mend/Penance Heal
            if isChecked("Debuff Helper") and getSpellCD(spell.penance) > 0 then
                for i = 1, #br.friend do
                    if getBuffRemain(br.friend[i].unit, spell.buffs.atonement, "player") > 1 then
                        if (br.friend[i].hp <= 90 and UnitDebuffID(br.friend[i].unit,225484)) or (br.friend[i].hp <= 90 and UnitDebuffID(br.friend[i].unit,240559)) or UnitDebuffID(br.friend[i].unit,200238) then
                            if mode.healer == 1 or mode.healer == 2 or (mode.healer == 3 and UnitIsUnit(br.friend[i].unit,"player")) then
                                actionList_MitigateDamage(i)
                            end
                        end
                    end
                end
            end
            --Shadow Mend
            if isChecked("Shadow Mend") then
                for i = 1, #br.friend do
                    if br.friend[i].hp <= getValue("Shadow Mend") and getBuffRemain(br.friend[i].unit, spell.buffs.atonement, "player") < 1 then
                        if mode.healer == 1 or mode.healer == 2 or (mode.healer == 3 and UnitIsUnit(br.friend[i].unit,"player")) then
                            if cast.shadowMend(br.friend[i].unit) then return end
                        end
                    end
                end
            end
            --Penance Heal
            if isChecked("Penance Heal") and getSpellCD(spell.penance) <= 0 then
                for i = 1, #br.friend do
                    if br.friend[i].hp <= getValue("Penance Heal") then
                        if mode.healer == 1 or mode.healer == 2 or (mode.healer == 3 and UnitIsUnit(br.friend[i].unit,"player")) then
                            if cast.penance(br.friend[i].unit) then return end
                        end
                    end
                end
            end
            --Fade
            if isChecked("Fade") then
                if php <= getValue("Fade") and not solo then
                    if cast.fade() then return end
                end
            end
        end
        ------------
        -- DAMAGE --
        ------------
        function actionList_Damage()
            if (not buff.rapture.exists("player") and inRaid) or not inRaid then
                --Shadow Word: Pain/Purge The Wicked
                if isChecked("Shadow Word: Pain/Purge The Wicked") and (getSpellCD(spell.penance) > 0 or (getSpellCD(spell.penance) <= 0 and debuff.purgeTheWicked.count() == 0 and debuff.shadowWordPain.count() == 0)) then
                    if talent.purgeTheWicked and (lastSpell ~= spell.purgeTheWicked or debuff.purgeTheWicked.count() == 0) then
                        for i = 1, #enemies.get(40) do
                            local thisUnit = enemies.get(40)[i]
                            if UnitIsUnit(thisUnit,"target") or hasThreat(thisUnit) or isDummy(thisUnit) then
                                if debuff.purgeTheWicked.remain(thisUnit) < gcd then
                                    if cast.purgeTheWicked(thisUnit,"aoe") then
                                        ptwDebuff = thisUnit
                                        healCount = 0
                                    end
                                end
                            end
                        end
                    end
                    if not talent.purgeTheWicked and (lastSpell ~= spell.shadowWordPain or debuff.shadowWordPain.count() == 0) then
                        for i = 1, #enemies.get(40) do
                            local thisUnit = enemies.get(40)[i]
                            if UnitIsUnit(thisUnit,"target") or hasThreat(thisUnit) or isDummy(thisUnit) then
                                if debuff.shadowWordPain.remain(thisUnit) < gcd then
                                    if cast.shadowWordPain(thisUnit,"aoe") then
                                        ptwDebuff = thisUnit
                                        healCount = 0
                                    end
                                end
                            end
                        end
                    end
                end
                --Schism
                if talent.schism and isChecked("Schism") and mana > 20 and norganBuff then
                    if not debuff.schism.exists(schismBuff) then
                        schismBuffnew = units.dyn40
                    end
                    if UnitIsUnit(schismBuffnew,"target") or hasThreat(schismBuffnew) or isDummy(schismBuffnew) then
                        if debuff.schism.remain(schismBuffnew) < gcd then
                            if cast.schism(schismBuffnew) then
                                schismBuff = schismBuffnew
                                healCount = 0
                            end
                        end
                    end
                end
                if debuff.purgeTheWicked.count() > 0 and not debuff.purgeTheWicked.exists(ptwDebuff) then
                    for i = 1, #enemies.get(40) do
                        local thisUnit = enemies.get(40)[i]
                        if debuff.purgeTheWicked.exists(thisUnit) then
                            ptwDebuff = thisUnit
                            return true
                        end
                    end
                end
                --Penance
                if isChecked("Penance") then
                    penanceTarget = units.dyn40
                    if penanceTarget ~= nil then
                        if debuff.schism.exists(schismBuff) then
                            penanceTarget = schismBuff
                        end
                        if ptwDebuff and isValidUnit(ptwDebuff) then
                            penanceTarget = ptwDebuff
                        end
                        if not UnitIsFriend(penanceTarget,"player") then
                            if cast.penance(penanceTarget) then
                                healCount = 0
                            end
                        end
                    end
                end
                --Mindbender
                if isChecked("Mindbender") and mana <= getValue("Mindbender") then
                    if debuff.schism.exists(schismBuff) then
                        if cast.mindbender(schismBuff) then
                             healCount = 0
                        end
                    end
                    if cast.mindbender() then
                         healCount = 0
                    end
                end
               --Shadowfiend
                if isChecked("Shadowfiend") then
                    if getLowAllies(getValue("Shadowfiend")) >= getValue("Shadowfiend Targets") then
                        if debuff.schism.exists(schismBuff) then
                            if cast.shadowfiend(schismBuff) then
                                 healCount = 0
                            end
                        end
                        if cast.shadowfiend() then
                             healCount = 0
                        end
                    end
                end
                --PowerWordSolace
                if isChecked("Power Word: Solace") then
                    if debuff.schism.exists(schismBuff) then
                        if cast.powerWordSolace(schismBuff) then
                            healCount = 0
                        end
                    end
                    if cast.powerWordSolace() then
                        healCount = 0
                    end
                end
                --Divine Star
                if isChecked("Divine Star") and talent.divineStar then
                    if getEnemiesInCone(24,45) >= getOptionValue("Divine Star") then
                        if cast.divineStar() then
                            healCount = 0
                        end
                    end
                end
                --Halo Damage
                if isChecked("Halo Damage") and talent.halo and mode.halo == 1 and norganBuff then
                    if #enemies.get(30) >= getOptionValue("Halo Damage") then
                        if cast.halo() then
                            healCount = 0
                        end
                    end
                end
                --Smite
                if isChecked("Smite") and norganBuff and getSpellCD(spell.penance) > 0 then
                    if mana > 20 or freeCast then
                        if debuff.schism.exists(schismBuff) then
                            if cast.smite(schismBuff) then
                                healCount = 0
                            end
                        end
                        if cast.smite() then
                            healCount = 0
                        end
                    end
                end
                --Dominant Mind
                if isChecked("Dominant Mind") and talent.dominantMind and norganBuff then
                    if #enemies.dyn30 >= getOptionValue("Dominant Mind") then
                        if cast.mindControl() then return end
                    end
                end
            end
        end
-----------------
--- Rotations ---
-----------------
        -- Pause
        if pause() or mode.rotation == 4 or UnitDebuffID("player",240447) or (getBuffRemain("player", 192001) > 0 and mana < 100) or getBuffRemain("player", 192002) > 10 or (getBuffRemain("player", 192002) > 0 and mana < 100) or getBuffRemain("player", 188023) > 0 or getBuffRemain("player", 175833) > 0 then
            return true
        else
---------------------------------
--- Out Of Combat - Rotations ---
---------------------------------
            if not inCombat and not IsMounted() then
                actionList_PreCombat()
                actionList_CheckAtonement()
                actionList_SingleTargetHeal()
                actionList_SingleTargetDefence()
                actionList_OOCHealing()
            end -- End Out of Combat Rotation
-----------------------------
--- In Combat - Rotations ---
-----------------------------
            if inCombat and not IsMounted() then
                actionList_Interrupts()
                actionList_CheckAtonement()
                actionList_Defensive()
                actionList_Cooldowns()
                actionList_SingleTargetDefence()
                actionList_SingleTargetHeal()
                actionList_AOEHealing()
                actionList_Damage()
                actionList_OOCHealing()
            end -- End In Combat Rotation
        end -- Pause
    end -- End Timer
end -- End runRotation
local id = 256
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
