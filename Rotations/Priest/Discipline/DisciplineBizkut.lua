local rotationName = "Bizkut"

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
        [1] = { mode = "Auto", value = 1 , overlay = "Auto Rotation", tip = "HPS and DPS rotation used.", highlight = 1, icon = br.player.spell.plea},
        [2] = { mode = "ATO", value = 2 , overlay = "Atonement Rotation", tip = "Atonement will keep applied within limit regardless of HP threshold.", highlight = 0, icon = br.player.spell.shiningForce},
        [3] = { mode = "DPS", value = 3 , overlay = "DPS Rotation", tip = "DPS only rotation used.", highlight = 0, icon = br.player.spell.penance},
        [4] = { mode = "Off", value = 4 , overlay = "Rotation Disabled", tip = "Disable Rotation", highlight = 0, icon = br.player.spell.penance}
    };
    CreateButton("Healer",1,0)
    -- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.powerInfusion },
        [2] = { mode = "On", value = 2 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.powerInfusion },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.powerInfusion }
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
end

---------------
--- OPTIONS ---
---------------
local function createOptions()
    local optionTable

    local function rotationOptions()
        -------------------------
        -------- ARTIFACT -------
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Artifact")
            --Light's Wrath
            br.ui:createSpinner(section, "Light's Wrath",  80,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At. Default: 80") 
            br.ui:createSpinnerWithout(section, "Light's Wrath Targets",  3,  0,  40,  1,  "|cffFFFFFFMinimum Light's Wrath Targets. Default: 3")
            --Save Overloaded with Light for CD
            br.ui:createCheckbox(section, "Save Overloaded with Light for CD")
            --Only use on Boss with Overloaded with Light
            br.ui:createCheckbox(section, "Only use on Boss with Overloaded with Light")
            --Always use on Boss
            br.ui:createCheckbox(section, "Always use on Boss")
        br.ui:checkSectionState(section)
        -------------------------
        -------- UTILITY --------
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Utility")
            --Purify
            br.ui:createCheckbox(section, "Purify")
            -- Mass Dispel
            br.ui:createDropdown(section, "Mass Dispel", br.dropOptions.Toggle, 1, colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.." Mass Dispel usage.")
            --Body and Soul
            br.ui:createCheckbox(section, "Body and Soul")
            --Angelic Feather
            br.ui:createCheckbox(section, "Angelic Feather","|cffFFFFFFThis is weird")
            --Fade
            br.ui:createSpinner(section, "Fade",  99,  0,  100,  1,  "|cffFFFFFFHealth Percent to Cast At. Default: 99")
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
            br.ui:createSpinnerWithout(section, "Atonement HP",  90,  0,  100,  1,  "|cffFFFFFFApply Atonement using Power Word: Shield, Plea and Power Word: Radiance. Health Percent to Cast At. Default: 90")
            --Power Word: Shield
            br.ui:createSpinnerWithout(section, "Power Word: Shield",  99,  0,  100,  1,  "|cffFFFFFFHealth Percent to Cast At. Default: 99")
            --Max Atonement when Rapture/PWS
            br.ui:createSpinnerWithout(section, "Max Atonement when Rapture/PWS",  15,  0,  40,  1,  "|cffFFFFFFMaximum Atonement to burst when Rapture/PWS. Default: 15")
            --Max Atonement
            br.ui:createSpinnerWithout(section, "Max Atonement",  5,  0,  40,  1,  "|cffFFFFFFMaximum Atonement to keep at a time. Default: 5")
            --Max Plea
            br.ui:createSpinnerWithout(section, "Max Plea",  5,  0,  40,  1,  "|cffFFFFFFMaximum Atonement before we avoid using Plea as it becomes too expensive. Default: 5")
            --Debuff Shadow Mend/Penance Heal
            br.ui:createSpinner(section, "Debuff Shadow Mend/Penance Heal",  70,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At. Default: 70")
            --Penance Heal
            br.ui:createSpinner(section, "Penance Heal",  60,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At. Default: 60")
            --Shadow Mend
            br.ui:createSpinner(section, "Shadow Mend",  65,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At. Only cast to players without Atonement buff. Default: 65")
            --Shadow Mend Emergency
            br.ui:createSpinner(section, "Shadow Mend Emergency",  35,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At. Will be casted to any members. Default: 35")
            --Clarity of Will
            br.ui:createSpinner(section, "Clarity of Will",  75,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At. Default: 75")
            --Pain Suppression Tank
            br.ui:createSpinner(section, "Pain Suppression Tank",  30,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At. Default: 30")
            --Pain Suppression
            br.ui:createSpinner(section, "Pain Suppression",  15,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At. Default: 15")
        br.ui:checkSectionState(section)
        -------------------------
        ------ AOE HEALING ------
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "AOE Healing")
            --Power Infusion
            br.ui:createSpinner(section, "Power Infusion",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At. Default: 50")
            br.ui:createSpinnerWithout(section, "Power Infusion Targets",  3,  0,  40,  1,  "|cffFFFFFFMinimum Power Infusion Targets. Default: 3")
            --Rapture
            br.ui:createSpinner(section, "Rapture",  60,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At. Default: 60")
            br.ui:createSpinnerWithout(section, "Rapture Targets",  3,  0,  40,  1,  "|cffFFFFFFMinimum Rapture Targets. Default: 3")
            --Power Word: Radiance
            br.ui:createSpinner(section, "Power Word: Radiance",  70,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At. Default: 70")
            br.ui:createSpinnerWithout(section, "PWR Targets",  3,  0,  40,  1,  "|cffFFFFFFMinimum PWR Targets. Default: 3")
            --Power Word: Barrier
            br.ui:createSpinner(section, "Power Word: Barrier",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At. Default: 50")
            br.ui:createSpinnerWithout(section, "PWB Targets",  3,  0,  40,  1,  "|cffFFFFFFMinimum PWB Targets. Default: 3")
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
            br.ui:createSpinner(section, "Shadow Word: Pain/Purge The Wicked",  3,  0,  10,  1,  "|cffFFFFFFMaximum Shadow Word: Pain/Purge The Wicked buff to keep at a time. Default: 3")
            --Schism
            br.ui:createCheckbox(section, "Schism")
            --Penance
            br.ui:createCheckbox(section, "Penance")
            --Power Word: Solace
            br.ui:createCheckbox(section, "Power Word: Solace")
            --Smite
            br.ui:createSpinner(section, "Smite",  5,  0,  40,  1,  "|cffFFFFFFMinimum Atonement for casting Smite. Default: 5")
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
            --Boss helper at Xavius. Darkening Soul/Blackening Soul Helper
            br.ui:createSpinner(section, "Darkening Soul/Blackening Soul Helper",  3,  0,  10,  1,  "|cffFFFFFFDebuff stack before dispel in Dream Simulacrum at Xavius. Default: 3")
            --Disable CD during Speed: Slow on Chromatic Anomaly
            br.ui:createCheckbox(section, "Disable CD during Speed: Slow","|cffFFFFFFDisable CD during Speed: Slow debuff on Chromatic Anomaly")
            --High Botanist Tel'arn Parasitic Fetter dispel helper. Dispel 8 yards from allies
            br.ui:createCheckbox(section, "Parasitic Fetter Dispel Helper","|cffFFFFFFHigh Botanist Tel'arn Parasitic Fetter dispel helper")
            --Drink
            br.ui:createSpinner(section, "Drink",   50,  0,  100,  5,   "|cffFFFFFFMinimum mana to drink Ley-Enriched Water. Default: 50")
            --Pre Pot
            br.ui:createSpinner(section, "Pre-Pot Timer",  3,  1,  10,  1,  "|cffFFFFFFSet to desired time for Pre-Pot using Potion of Prolonged Power (DBM Required). Min: 1 / Max: 10 / Interval: 1. Default: 3")
            --Int Pot
            br.ui:createCheckbox(section,"Prolonged Pot","|cffFFFFFFUse Potion of Prolonged Power")
            --Trinkets
            br.ui:createCheckbox(section,"Trinkets")
            --Touch of the Void
            if hasEquiped(128318) then
                br.ui:createCheckbox(section,"Touch of the Void")
            end
            --Mindbender/Shadowfiend
            br.ui:createCheckbox(section, "Mindbender/Shadowfiend","|cffFFFFFFAlways cast Mindbender or Shadowfiend on CD")
            --Power Infusion CD
            br.ui:createCheckbox(section, "Power Infusion CD","|cffFFFFFFAlways use Power Infusion on CD")
            --Rapture and PW:S
            br.ui:createCheckbox(section, "Rapture and PW:S","|cffFFFFFFAlways cast Rapture and apply Power Word: Shield to all players on CD")
            --Power Word: Barrier CD
            br.ui:createCheckbox(section, "Power Word: Barrier CD", "|cffFFFFFFAlways cast Power Word: Barrier on CD")
            --Divine Star CD
            br.ui:createCheckbox(section, "Divine Star CD","|cffFFFFFFAlways use Divine Star on CD")
            --Halo CD
            br.ui:createCheckbox(section, "Halo CD","|cffFFFFFFAlways use Halo on CD")
        br.ui:checkSectionState(section)
        -------------------------
        ------- DEFENSIVE -------
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
        -- Healthstone
            br.ui:createSpinner(section, "Pot/Stoned",  35,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At. Default: 35")
        -- Heirloom Neck
            br.ui:createSpinner(section, "Heirloom Neck",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.. Default: 60");
        -- Gift of The Naaru
            if br.player.race == "Draenei" then
                br.ui:createSpinner(section, "Gift of the Naaru",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At. Default: 50")
            end
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
        br.player.mode.healer = br.data.settings[br.selectedSpec].toggles["Healer"]
        br.player.mode.halo = br.data.settings[br.selectedSpec].toggles["Halo"]
        br.player.mode.burst = br.data.settings[br.selectedSpec].toggles["Burst"]
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
        local lastSpell                                     = lastSpellCast
        local level                                         = br.player.level
        local lootDelay                                     = getOptionValue("LootDelay")
        local lowestHP                                      = br.friend[1].unit
        local mode                                          = br.player.mode
        local perk                                          = br.player.perk        
        local php                                           = br.player.health
        local power, powmax, powgen                         = br.player.power.amount.mana, br.player.power.mana.max, br.player.power.regen
        local pullTimer                                     = br.DBM:getPulltimer()
        local race                                          = br.player.race
        local racial                                        = br.player.getRacial()
        local recharge                                      = br.player.recharge
        local solo                                          = br.player.instance=="none"
        local spell                                         = br.player.spell
        local talent                                        = br.player.talent
        local ttd                                           = getTTD
        local ttm                                           = br.player.power.ttm
        local units                                         = units or {}
        local lowest                                        = {}    --Lowest Unit
        lowest.hp                                           = br.friend[1].hp
        lowest.role                                         = br.friend[1].role
        lowest.unit                                         = br.friend[1].unit
        lowest.range                                        = br.friend[1].range
        lowest.guid                                         = br.friend[1].guid                      
        local tank                                          = {}    --Tank

        units.dyn30 = br.player.units(30)
        units.dyn40 = br.player.units(40)
        enemies.dyn24 = br.player.enemies(24)
        enemies.dyn30 = br.player.enemies(30)
        enemies.dyn40 = br.player.enemies(40)

        atonementCount = 0
        for i=1, #br.friend do
            local atonementRemain = getBuffRemain(br.friend[i].unit,spell.buffs.atonement,"player") or 0 -- 194384
            if atonementRemain > 0 then
                atonementCount = atonementCount + 1
            end
        end

        if leftCombat == nil then leftCombat = GetTime() end
        if profileStop == nil then profileStop = false end

--------------------
--- Action Lists ---
--------------------
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
                        useItem(142117)
                    end
                    --Power Infusion
                    if isChecked("Power Infusion CD") then
                        if cast.powerInfusion() then return end
                    end
                    --Touch of the Void
                    if isChecked("Touch of the Void") and getDistance(br.player.units.dyn5)<5 then
                        if hasEquiped(128318) then
                            if GetItemCooldown(128318)==0 then
                                useItem(128318)
                            end
                        end
                    end
                    --Trinkets
                    if isChecked("Trinkets") then
                        if canUse(13) then
                            useItem(13)
                        end
                        if canUse(14) then
                            useItem(14)
                        end
                    end
                    if isChecked("Power Word: Barrier CD") then
                        if cast.powerWordBarrier(lowest.unit) then return end
                    end
                    --Rapture and PW:S
                    if isChecked("Rapture and PW:S") then
                        if isChecked("Power Infusion CD") and not buff.powerInfusion.exists("player") then
                            if cast.powerInfusion() then return end
                        end
                        if cast.rapture() then return end
                        if buff.rapture.exists("player") then
                            if mode.healer == 1 or mode.healer == 2 then
                                for i = 1, #br.friend do
                                    actionList_SpreadAtonement(br.friend[i].unit)
                                end
                            end
                            if mode.healer == 3 then
                                actionList_SpreadAtonement("player")
                            end
                        end
                    end
                    --Mindbender/Shadowfiend
                    if isChecked("Mindbender/Shadowfiend") then
                        if cast.mindbender() then return end
                        if cast.shadowfiend() then return end
                    end
                    --Only use on Boss with Overloaded with Light
                    --Always use on Boss
                    if isChecked("Always use on Boss") or (isChecked("Only use on Boss with Overloaded with Light") and getBuffRemain("player",spell.buffs.overloadedWithLight) ~= 0) then
                        if getSpellCD(spell.lightsWrath) == 0 then
                            if mode.healer == 1 or mode.healer == 2 then
                                for i = 1, #br.friend do
                                    actionList_SpreadAtonement(br.friend[i].unit)
                                end
                            end
                            if isBoss("target") and getDistance("player","target") < 40 and ((inRaid and atonementCount >= getOptionValue("Max Atonement")) or (inInstance and atonementCount >= 5)) or (not inInstance and not inRaid) then
                                if cast.schism("target") then return end
                                if talent.schism and schismBuff == thisUnit then 
                                    if cast.lightsWrath("target") then return end
                                end
                                if not talent.schism or not isChecked("Schism") or schismBuff == nil then
                                    if cast.lightsWrath("target") then return end
                                end
                            end
                        end
                    end
                    --Divine Star CD
                    if isChecked("Divine Star CD") and isBoss("target") and getDistance("player","target") < 24 and getFacing("player","target",10) then
                        if cast.divineStar() then return end
                    end
                    --Halo CD
                    if isChecked("Halo CD") and isBoss("target") and getDistance("player","target") < 30 and mode.halo == 1 then
                        if cast.halo() then return end
                    end
                end
            end
        end -- End Action List - Cooldowns
        -- Action List - Pre-Combat
        function actionList_PreCombat()
            if isMoving("player") then
                if isChecked("Angelic Feather") and talent.angelicFeather and not buff.angelicFeather.exists("player") then
                    if cast.angelicFeather("player") then
                        RunMacroText("/stopspelltarget")
                    end
                end
                -- Power Word: Shield Body and Soul
                if isChecked("Body and Soul") and talent.bodyAndSoul then
                    if cast.powerWordShield("player") then return end
                end
            end
            if isChecked("Pre-Pot Timer") and pullTimer <= getOptionValue("Pre-Pot Timer") and canUse(142117) and not solo then
                useItem(142117)
            end
            if isChecked("Drink") and getMana("player") <= getOptionValue("Drink") and canUse(138292) and not IsResting() and GetTime()-leftCombat > lootDelay+2 then
                useItem(138292)
            end
        end  -- End Action List - Pre-Combat
        --Spread Atonement
        function actionList_SpreadAtonement(friendUnit)
            --Spread Atonement
            if not buff.powerWordShield.exists(friendUnit) or getBuffRemain(friendUnit, spell.buffs.atonement, "player") < 1 then
                if getSpellCD(spell.powerWordShield) <= 0 and not buff.powerWordShield.exists(friendUnit) then
                    if buff.rapture.exists("player") and atonementCount <= getValue("Max Atonement when Rapture/PWS") then
                        if atonementCount >= getValue("Max Atonement when Rapture/PWS") or getBuffRemain(friendUnit, spell.buffs.atonement, "player") < 1 then
                            if cast.powerWordShield(friendUnit) then return end
                        end
                    elseif atonementCount < getOptionValue("Max Atonement") and getBuffRemain(friendUnit, spell.buffs.atonement, "player") < 1 then
                        if cast.powerWordShield(friendUnit) then return end
                    end
                end
                if not buff.powerWordShield.exists(friendUnit) and getBuffRemain(friendUnit, spell.buffs.atonement, "player") < 1 and mode.burst == 1 and (UnitBuffID("player",29166) or UnitBuffID("player",64901)) then
                    if cast.powerWordRadiance(friendUnit) then return end
                end
                if atonementCount < getOptionValue("Max Plea") and atonementCount < getOptionValue("Max Atonement") and not buff.powerWordShield.exists(friendUnit) and getBuffRemain(friendUnit, spell.buffs.atonement, "player") < 1 then
                    if cast.plea(friendUnit) then return end     
                end
                if ((not inRaid and atonementCount < 5) or inRaid) and lastSpell ~= spell.powerWordRadiance and atonementCount >= getOptionValue("Max Plea") and atonementCount < getOptionValue("Max Atonement") and not buff.powerWordShield.exists(friendUnit) and getBuffRemain(friendUnit, spell.buffs.atonement, "player") < 1 then
                    if cast.powerWordRadiance(friendUnit) then return end
                end
            end
        end
        --AOE Healing
        function actionList_AOEHealing()
            --Power Word: Barrier
            if isChecked("Power Word: Barrier") and (mode.healer == 1 or mode.healer == 2) then
                if getLowAllies(getValue("Power Word: Barrier")) >= getValue("PWB Targets") then
                    if cast.powerWordBarrier(lowest.unit) then return end
                end
            end
            --Shadow Covenant
            if isChecked("Shadow Covenant") and talent.shadowCovenant and (mode.healer == 1 or mode.healer == 2) then
                if getLowAllies(getValue("Shadow Covenant")) >= getValue("Shadow Covenant Targets") and lastSpell ~= spell.shadowCovenant then
                    if cast.shadowCovenant(lowest.unit) then return end
                end
            end
            --Power Infusion
            if isChecked("Power Infusion") then
                if getLowAllies(getValue("Power Infusion")) >= getValue("Power Infusion Targets") then
                    if cast.powerInfusion() then return end
                end
            end
            --Rapture
            if isChecked("Rapture") then
                if getLowAllies(getValue("Rapture")) >= getValue("Rapture Targets") then
                    if cast.rapture() then return end
                end
            end
            if getSpellCD(spell.rapture) <= 0 and mode.burst == 1 and (UnitBuffID("player",29166) or UnitBuffID("player",64901)) then
                if cast.rapture() then return end
            end
            if buff.rapture.exists("player") then
                if mode.healer == 1 or mode.healer == 2 then
                    for i = 1, #br.friend do
                        actionList_SpreadAtonement(br.friend[i].unit)
                    end
                end
                if mode.healer == 3 then
                    actionList_SpreadAtonement("player")
                end
            end
            --Power Word: Radiance
            if isChecked("Power Word: Radiance") and (mode.healer == 1 or mode.healer == 2) then
                if getLowAllies(getValue("Power Word: Radiance")) >= getValue("PWR Targets") and lastSpell ~= spell.powerWordRadiance and getBuffRemain(lowest.unit, spell.buffs.atonement, "player") < 1 then
                    if cast.powerWordRadiance(lowest.unit) then return end
                end
            end
            --Halo
            if isChecked("Halo") and mode.halo == 1 then
                if getLowAllies(getValue("Halo")) >= getValue("Halo Targets") then
                    if cast.halo(lowest.unit) then return end
                end
            end
        end
        --Single Target Defence
        function actionList_SingleTargetDefence()
            for i = 1, #br.friend do
                if UnitGroupRolesAssigned(br.friend[i].unit) == "TANK" then
                    tankUnit = br.friend[i].unit
                end
                --Leap Of Faith
                if isChecked("Leap Of Faith") and (mode.healer == 1 or mode.healer == 2) then
                    if php > br.friend[i].hp and br.friend[i].hp <= getValue("Leap Of Faith") and UnitGroupRolesAssigned(br.friend[i].unit) ~= "TANK" then
                        if cast.leapOfFaith(br.friend[i].unit) then return end
                    end
                end
                --Pain Suppression Tank
                if isChecked("Pain Suppression Tank") and (mode.healer == 1 or mode.healer == 2) then
                    if br.friend[i].hp <= getValue("Pain Suppression Tank") and getBuffRemain(br.friend[i].unit, spell.painSuppression, "player") < 1 and UnitGroupRolesAssigned(br.friend[i].unit) == "TANK" then
                        if cast.painSuppression(br.friend[i].unit) then return end
                    end
                end
                --Pain Suppression
                if isChecked("Pain Suppression") then
                    if br.friend[i].hp <= getValue("Pain Suppression") and getBuffRemain(br.friend[i].unit, spell.painSuppression, "player") < 1 then
                        if mode.healer == 1 or mode.healer == 2 then
                            if cast.painSuppression(br.friend[i].unit) then return end
                        end
                        if mode.healer == 3 and br.friend[i].unit == "player" then
                            if cast.painSuppression("player") then return end
                        end
                    end
                end
                --Psychic Scream
                if isChecked("Psychic Scream") then
                    if php <= getValue("Psychic Scream") then
                        if cast.psychicScream() then return end
                    end
                end
                --Shining Force
                if isChecked("Shining Force") and talent.shiningForce then
                    if br.friend[i].hp <= getValue("Shining Force") then
                        if mode.healer == 1 or mode.healer == 2 then
                            if cast.shiningForce(br.friend[i].unit) then return end
                        end
                        if mode.healer == 3 and br.friend[i].unit == "player" then
                            if cast.shiningForce("player") then return end
                        end
                    end
                end
                --Clarity of Will
                if isChecked("Clarity of Will") and talent.clarityOfWill then
                    if br.friend[i].hp <= getValue("Clarity of Will") and lastSpell ~= spell.clarityOfWill and not isMoving("player") and getBuffRemain(br.friend[i].unit, spell.buffs.clarityOfWill, "player") == 0 and buff.powerWordShield.exists(br.friend[i].unit) and br.friend[i].unit == lowest.unit then
                        if mode.healer == 1 or mode.healer == 2 then
                            if cast.clarityOfWill(br.friend[i].unit) then return end
                        end
                        if mode.healer == 3 and br.friend[i].unit == "player" then
                            if cast.clarityOfWill("player") then return end
                        end
                    end
                end
                --Power Word: Shield
                if br.friend[i].hp <= getValue("Power Word: Shield") and not buff.powerWordShield.exists(br.friend[i].unit) and getSpellCD(spell.powerWordShield) <= 0 then
                    if mode.healer == 1 or mode.healer == 2 then
                        if tankUnit == nil or br.friend[i].unit == tankUnit or buff.powerWordShield.remain(tankUnit) > select(2,GetSpellCooldown(spell.powerWordShield)) then
                            if cast.powerWordShield(br.friend[i].unit) then return end
                        end
                    end
                    if mode.healer == 3 and br.friend[i].unit == "player" then
                        if cast.powerWordShield("player") then return end
                    end
                end
            end
        end
        --Single Target Heal
        function actionList_SingleTargetHeal()
            -- Mass Dispel
            if not isMoving("player") and isChecked("Mass Dispel") and (SpecificToggle("Mass Dispel") and not GetCurrentKeyBoardFocus()) then
                CastSpellByName(GetSpellInfo(spell.massDispel),"cursor")
                return true
            end
            --Resurrection
            if isChecked("Resurrection") and not inCombat then
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
            for i = 1, #br.friend do
                --Purify
                if isChecked("Purify") or isChecked("Debuff Shadow Mend/Penance Heal") then
                    for n = 1,40 do
                        local buff,_,_,count,bufftype,duration = UnitDebuff(br.friend[i].unit, n)
                        if buff then
                            if (bufftype == "Curse" or bufftype == "Magic") and lastSpell ~= spell.purify and isChecked("Purify") then
                                --High Botanist Tel'arn Parasitic Fetter dispel helper
                                if isChecked("Parasitic Fetter Dispel Helper") and UnitDebuffID(br.friend[i].unit,218304) then
                                    if #getAllies(br.friend[i].unit,8) < 2 then
                                        if cast.purify(br.friend[i].unit) then return end
                                    end
                                --Xavius dispel helper
                                elseif isChecked("Darkening Soul/Blackening Soul Helper") and (getDebuffStacks(br.friend[i].unit,206651) >= 1 or getDebuffStacks(br.friend[i].unit,209158) >= 1) then
                                    local debuffStack = getValue("Darkening Soul/Blackening Soul Helper")
                                    if UnitDebuffID("player",206005) and (getDebuffStacks(br.friend[i].unit,206651) >= debuffStack or getDebuffStacks(br.friend[i].unit,209158) >= debuffStack) then
                                        if cast.purify(br.friend[i].unit) then return end
                                    end
                                elseif mode.healer == 1 or mode.healer == 2 then
                                        if cast.purify(br.friend[i].unit) then return end
                                elseif mode.healer == 3 and br.friend[i].unit == "player" then
                                        if cast.purify("player") then return end
                                end
                            end
                            if br.friend[i].hp <= getValue("Debuff Shadow Mend/Penance Heal") and isChecked("Debuff Shadow Mend/Penance Heal") and not UnitDebuffID(br.friend[i].unit,187464) and not UnitDebuffID(br.friend[i].unit,207011) and lastSpell ~= spell.shadowMend then
                                if mode.healer == 1 or mode.healer == 2 then
                                    if isMoving("player") and talent.thePenitent then
                                        if cast.penance(br.friend[i].unit) then return end
                                    end
                                    if inCombat and getSpellCD(spell.penance) <= 0 then
                                        actionList_SpreadAtonement(br.friend[i].unit)
                                        actionList_SpreadAtonement(lowest.unit)
                                        if schismBuff then
                                            if cast.penance(schismBuff) then return end
                                        end
                                        if ptwBuff then
                                            if cast.penance(ptwBuff) then return end
                                        end
                                        if cast.penance() then return end
                                    else
                                        if cast.shadowMend(br.friend[i].unit) then return end
                                    end
                                end
                                if mode.healer == 3 and br.friend[i].unit == "player" then
                                    if isMoving("player") and talent.thePenitent then
                                        if cast.penance("player") then return end
                                    end
                                    if inCombat and getSpellCD(spell.penance) <= 0 then
                                        actionList_SpreadAtonement("player")
                                        if schismBuff then
                                            if cast.penance(schismBuff) then return end
                                        end
                                        if ptwBuff then
                                            if cast.penance(ptwBuff) then return end
                                        end
                                        if cast.penance() then return end
                                    else
                                        if cast.shadowMend("player") then return end
                                    end
                                end
                            end
                        end
                    end
                end
                --Penance Heal
                if isChecked("Penance Heal") and talent.thePenitent then
                    if br.friend[i].hp <= getValue("Penance Heal") then
                        if mode.healer == 1 or mode.healer == 2 then
                            if cast.penance(br.friend[i].unit) then return end
                        end
                        if mode.healer == 3 and br.friend[i].unit == "player" then
                            if cast.penance("player") then return end
                        end
                    end
                end
                --Shadow Mend Emergency
                if isChecked("Shadow Mend Emergency") then
                    if br.friend[i].hp <= getValue("Shadow Mend Emergency") then
                        if mode.healer == 1 or mode.healer == 2 then
                            if cast.shadowMend(br.friend[i].unit) then return end
                        end
                        if mode.healer == 3 and br.friend[i].unit == "player" then
                            if cast.shadowMend("player") then return end
                        end
                    end
                end
                --Shadow Mend
                if isChecked("Shadow Mend") then
                    if br.friend[i].hp <= getValue("Shadow Mend") and (not inCombat or getBuffRemain(br.friend[i].unit, spell.buffs.atonement, "player") < 1) then
                        if mode.healer == 1 or mode.healer == 2 then
                            if inCombat and getSpellCD(spell.penance) <= 0 then
                                actionList_SpreadAtonement(br.friend[i].unit)
                                if schismBuff then
                                    if cast.penance(schismBuff) then return end
                                end
                                if ptwBuff then
                                    if cast.penance(ptwBuff) then return end
                                end
                                if cast.penance() then return end
                            else
                                if cast.shadowMend(br.friend[i].unit) then return end
                            end
                        end
                        if mode.healer == 3 and br.friend[i].unit == "player" then
                            if inCombat and getSpellCD(spell.penance) <= 0 then
                                actionList_SpreadAtonement("player")
                                if schismBuff then
                                    if cast.penance(schismBuff) then return end
                                end
                                if ptwBuff then
                                    if cast.penance(ptwBuff) then return end
                                end
                                if cast.penance() then return end
                            else
                                if cast.shadowMend("player") then return end
                            end
                        end
                    end
                end
                --Atonement
                if br.friend[i].hp <= getValue("Atonement HP") then
                    if mode.healer == 1 then
                        actionList_SpreadAtonement(br.friend[i].unit)
                    end
                    if mode.healer == 3 and br.friend[i].unit == "player" then
                        actionList_SpreadAtonement("player")
                    end
                end
                if mode.healer == 2 or (mode.burst == 1 and (UnitBuffID("player",29166) or UnitBuffID("player",64901))) then
                    actionList_SpreadAtonement(br.friend[i].unit)
                end
                --Fade
                if isChecked("Fade") then                         
                    if php <= getValue("Fade") then
                        if cast.fade() then return end     
                    end
                end
            end
        end
        ------------
        -- DAMAGE --
        ------------
        function actionList_Damage()
            --Schism
            if isChecked("Schism") and getMana("player") > 20 then
                if ttd("target") > debuff.schism.duration("target") and debuff.schism.refresh("target") then
                    if cast.schism("target") then return end
                end
            end
            schismBuff = nil
            for i = 1, #enemies.dyn40 do
                local thisUnit = enemies.dyn40[i]
                if UnitIsUnit(thisUnit,"target") or hasThreat(thisUnit) or isDummy(thisUnit) then
                    if debuff.schism.exists(thisUnit) then
                        schismBuff = thisUnit
                    end
                end
            end
            --Shadow Word: Pain/Purge The Wicked
            if isChecked("Shadow Word: Pain/Purge The Wicked") then
                ptwBuffcount = 0
                swpBuffcount = 0
                ptwBuff = nil
                for i = 1, #enemies.dyn40 do
                    local thisUnit = enemies.dyn40[i]
                    if UnitIsUnit(thisUnit,"target") or hasThreat(thisUnit) or isDummy(thisUnit) then
                        local ptwBuffRemain = debuff.purgeTheWicked.duration(thisUnit) or 0
                        if ptwBuffRemain > 0 then
                            ptwBuffcount = ptwBuffcount + 1
                        end
                        local swpBuffRemain = debuff.shadowWordPain.duration(thisUnit) or 0
                        if swpBuffRemain > 0 then
                            swpBuffcount = swpBuffcount + 1
                        end
                    end
                end
                if talent.purgeTheWicked then
                    for i = 1, #enemies.dyn40 do
                        local thisUnit = enemies.dyn40[i]
                        if UnitIsUnit(thisUnit,"target") or hasThreat(thisUnit) or isDummy(thisUnit) then
                            if ttd(thisUnit) > debuff.purgeTheWicked.duration(thisUnit) and debuff.purgeTheWicked.refresh(thisUnit) and ptwBuffcount < getValue("Shadow Word: Pain/Purge The Wicked") then
                                if schismBuff == thisUnit or not talent.schism or not isChecked("Schism") or schismBuff == nil then
                                    if cast.purgeTheWicked(thisUnit) then
                                        ptwBuff = thisUnit
                                    end
                                end
                            end
                        end
                    end
                end
                if not talent.purgeTheWicked then
                    for i = 1, #enemies.dyn40 do
                        local thisUnit = enemies.dyn40[i]
                        if UnitIsUnit(thisUnit,"target") or hasThreat(thisUnit) or isDummy(thisUnit) then
                            if ttd(thisUnit) > debuff.shadowWordPain.duration(thisUnit) and debuff.shadowWordPain.refresh(thisUnit) and swpBuffcount < getValue("Shadow Word: Pain/Purge The Wicked") then
                                if cast.shadowWordPain(thisUnit) then
                                    swpBuff = thisUnit
                                end
                            end
                        end
                    end
                end
            end
            --Penance
            if isChecked("Penance") then
                if schismBuff then
                    if cast.penance(schismBuff) then return end
                end
                if ptwBuff then
                    if cast.penance(ptwBuff) then return end   
                end
                if cast.penance() then return end
            end
            --Mindbender
            if isChecked("Mindbender") and getMana("player") <= getValue("Mindbender") then
                if schismBuff then
                    if cast.mindbender(schismBuff) then return end
                end
                if cast.mindbender() then return end
            end
           --Shadowfiend
            if isChecked("Shadowfiend") then
                if getLowAllies(getValue("Shadowfiend")) >= getValue("Shadowfiend Targets") then
                    if schismBuff then
                        if cast.shadowfiend(schismBuff) then return end
                    end
                    if cast.shadowfiend() then return end    
                end
            end
            --PowerWordSolace
            if isChecked("Power Word: Solace") then
                if schismBuff then
                    if cast.powerWordSolace(schismBuff) then return end
                end
                if cast.powerWordSolace() then return end
            end
            --Light's Wrath
            if isChecked("Light's Wrath") and getSpellCD(spell.lightsWrath) == 0 then
                if getLowAllies(getValue("Light's Wrath")) >= getValue("Light's Wrath Targets") then
                    if isChecked("Save Overloaded with Light for CD") and getBuffRemain("player",spell.buffs.overloadedWithLight) ~= 0 then
                        return false
                    end
                    for i = 1, #enemies.dyn40 do
                        local thisUnit = enemies.dyn40[i]
                        if schismBuff == thisUnit or schismBuff == nil then
                            if not inInstance and not inRaid then
                                if talent.schism then
                                    if cast.lightsWrath(thisUnit) then return end
                                end
                                if not talent.schism or not isChecked("Schism") then
                                    if cast.lightsWrath() then return end
                                end
                            end
                            if mode.healer == 1 or mode.healer == 2 then
                                for i = 1, #br.friend do
                                    actionList_SpreadAtonement(br.friend[i].unit)
                                end
                                if (inRaid and atonementCount >= getOptionValue("Max Atonement")) or (not inRaid and atonementCount >= 5) then
                                    if talent.schism then
                                        if cast.lightsWrath(thisUnit) then return end
                                    end
                                    if not talent.schism or not isChecked("Schism") then
                                        if cast.lightsWrath() then return end
                                    end
                                end
                            end
                            if mode.healer == 3 then
                                if talent.schism then
                                    if cast.lightsWrath(thisUnit) then return end
                                end
                                if not talent.schism or not isChecked("Schism Raid") then
                                    if cast.lightsWrath() then return end
                                end
                            end
                        end
                    end
                end
            end
            --Divine Star
            if isChecked("Divine Star") and talent.divineStar then
                if #enemies.dyn24 >= getOptionValue("Divine Star") and getFacing("player","target",10) then
                    if cast.divineStar() then return end
                end
            end
            --Halo Damage
            if isChecked("Halo Damage") and talent.halo and mode.halo == 1 then
                if #enemies.dyn30 >= getOptionValue("Halo Damage") then
                    if cast.halo() then return end
                end
            end
            --Smite
            if isChecked("Smite") then
                if (getMana("player") > 20 and ((not inInstance and not inRaid) or atonementCount >= getValue("Smite"))) or (mode.burst == 1 and (UnitBuffID("player",29166) or UnitBuffID("player",64901))) and lastSpell ~= spell.smite then
                    if schismBuff then
                        if cast.smite(schismBuff) then return end
                    end
                    if cast.smite() then return end
                end
            end
            --Dominant Mind
            if isChecked("Dominant Mind") and talent.dominantMind then
                if #enemies.dyn30 >= getOptionValue("Dominant Mind") then
                    if cast.mindControl() then return end
                end
            end
        end
-----------------
--- Rotations ---
-----------------
        -- Pause
        if pause() or mode.rotation == 4 or mode.healer == 4 then
            return true
        else
---------------------------------
--- Out Of Combat - Rotations ---
---------------------------------
            if not inCombat and not IsMounted() and (getBuffRemain("player", 192001) < 1 or getMana("player") == 100) and getBuffRemain("player", 192002) < 10 and getBuffRemain("player", 188023) < 1 and getBuffRemain("player", 175833) < 1 then
                actionList_PreCombat()
                actionList_SingleTargetHeal()
            end -- End Out of Combat Rotation
-----------------------------
--- In Combat - Rotations --- 
-----------------------------
            if inCombat and not IsMounted() then
                actionList_Defensive()
                actionList_Cooldowns()
                actionList_SingleTargetDefence()
                actionList_SingleTargetHeal()
                actionList_AOEHealing()
                actionList_Damage()
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
