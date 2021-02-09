local rotationName = "Aura" 

---------------
--- Toggles ---
---------------
local function createToggles()
-- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.healingTideTotem},
        [2] = { mode = "On", value = 2 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.healingTideTotem},
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.healingTideTotem}
    };
    CreateButton("Cooldown",1,0)
-- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.astralShift},
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.astralShift}
    };
    CreateButton("Defensive",2,0)
-- Interrupt Button
    InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.windShear},
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.windShear}
    };
    CreateButton("Interrupt",3,0)
-- Decurse Button
    DecurseModes = {
        [1] = { mode = "On", value = 1 , overlay = "Decurse Enabled", tip = "Decurse Enabled", highlight = 1, icon = br.player.spell.purifySpirit },
        [2] = { mode = "Off", value = 2 , overlay = "Decurse Disabled", tip = "Decurse Disabled", highlight = 0, icon = br.player.spell.purifySpirit }
    };
    CreateButton("Decurse",4,0)
-- DPS Button
    DPSModes = {
        [1] = { mode = "On", value = 1 , overlay = "DPS Enabled", tip = "DPS Enabled", highlight = 1, icon = br.player.spell.lightningBolt },
        [2] = { mode = "Off", value = 2 , overlay = "DPS Disabled", tip = "DPS Disabled", highlight = 0, icon = br.player.spell.healingSurge }
    };
    CreateButton("DPS",5,0)
    -- Ghost Wolf Button
    GhostWolfModes = {
        [1] = { mode = "Moving", value = 1, overlay = "Moving Enabled", tip = "Will Ghost Wolf when movement detected", highlight = 1, icon = br.player.spell.ghostWolf},
        [2] = { mode = "Hold", value = 2, overlay = "Hold Enabled", tip = "Will Ghost Wolf when key is held down", highlight = 0, icon = br.player.spell.ghostWolf},
    };
    CreateButton("GhostWolf",6,0)
    -- Healing Rain Button
    HealingRModes = {
        [1] = { mode = "On", value = 1, overlay = "Healing Rain Enabled", tip = "Will use Healing Rain", highlight = 1, icon = br.player.spell.healingRain},
        [2] = { mode = "Off", value = 2, overlay = "Healing Rain Disabled", tip = "Will not use Healing Rain", highlight = 0, icon = br.player.spell.healingRain},
    };
    CreateButton("HealingR",7,0)
end

--------------
--- COLORS ---
--------------
    local colorBlue     = "|cff00CCFF"
    local colorGreen    = "|cff00FF00"
    local colorRed      = "|cffFF0000"
    local colorWhite    = "|cffFFFFFF"
    local colorGold     = "|cffFFDD11"

---------------
--- OPTIONS ---
---------------
local function createOptions()
    local optionTable

    local function rotationOptions()
        local section
    -- General Options
        section = br.ui:createSection(br.ui.window.profile, "General - Version 1.02")
            br.ui:createCheckbox(section,"OOC Healing","|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFout of combat healing|cffFFBB00.")
        -- Dummy DPS Test
            br.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
        -- Pre-Pull Timer
            br.ui:createSpinner(section, "Pre-Pull Timer",  5,  1,  10,  1,  "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
        -- Ghost Wolf
            br.ui:createCheckbox(section, "Auto Ghost Wolf", "|cff0070deCheck this to automatically control GW transformation based on toggle bar setting.")
            br.ui:createDropdownWithout(section, "Ghost Wolf Key",br.dropOptions.Toggle,6,"|cff0070deSet key to hold down for Ghost Wolf")
        -- Water Walking
            br.ui:createCheckbox(section,"Water Walking")
        -- Earth Shield
            br.ui:createCheckbox(section,"Earth Shield")
        -- Water Shield
            br.ui:createCheckbox(section,"Water Shield")
        -- Temple of Seth
            br.ui:createSpinner(section, "Temple of Seth", 80, 0, 100, 5, "|cffFFFFFFMinimum Health to Heal Seth NPC. Default: 80")
        -- Bursting Stack
            br.ui:createSpinnerWithout(section, "Bursting", 1, 1, 10, 1, "", "|cffFFFFFFWhen Bursting stacks are above this amount, CDs/AoE Healing will be triggered.")
        -- DPS Threshold
            br.ui:createSpinnerWithout(section, "DPS Threshold", 50, 0, 100, 5, "|cffFFFFFFMinimum Health to stop DPS. Default: 50" )
        -- Mana Pot
            br.ui:createSpinner(section, "Mana Pot", 30, 0, 100, 5, "|cffFFFFFFWill use mana pot if mana below this value. Default: 30")

            br.ui:createCheckbox(section, "Pig Catcher", "Catch the freehold Pig in the ring of booty")
        br.ui:checkSectionState(section)
    -- -- Burst Damage Options
        section = br.ui:createSection(br.ui.window.profile, "Raid Burst Damage Options")
            br.ui:createSpinner(section, "Burst Count", 1, 1, 10, 1, "Set which burst damage (ie. Grong Tantrum/Opulence Wail) number you need to cover with CDs.  Uncheck to use CDs whenever available.")
        br.ui:checkSectionState(section)
    -- Essence Options
        section = br.ui:createSection(br.ui.window.profile, "Essence Options")
        --Concentrated Flame
            br.ui:createSpinner(section, "Concentrated Flame", 75, 0, 100, 5, colorWhite.."Will cast Concentrated Flame if party member is below value. Default: 75")
        --Memory of Lucid Dreams
            br.ui:createCheckbox(section, "Lucid Dreams")
        -- Ever-Rising Tide
            br.ui:createDropdown(section, "Ever-Rising Tide", { "Always", "Pair with CDs", "Based on Health" }, 1, "When to use this Essence")
            br.ui:createSpinner(section, "Ever-Rising Tide - Mana", 30, 0, 100, 5, "", "Min mana to use")
            br.ui:createSpinner(section, "Ever-Rising Tide - Health", 30, 0, 100, 5, "", "Health threshold to use")
        -- Well of Existence
            br.ui:createCheckbox(section, "Well of Existence")
        -- Life Binder's Invocation
            br.ui:createSpinner(section, "Life-Binder's Invocation", 85, 1, 100, 5, "Health threshold to use")
            br.ui:createSpinnerWithout(section, "Life-Binder's Invocation Targets", 5, 1, 40, 1, "Number of targets to use")
        br.ui:checkSectionState(section)
    -- Cooldown Options
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
         -- Racial
            br.ui:createCheckbox(section,"Racial")
        -- Trinkets
            br.ui:createSpinner(section, "Trinket 1", 70, 0, 100, 5, "Health Percent to Cast At")
            br.ui:createSpinnerWithout(section, "Min Trinket 1 Targets", 3, 1, 40, 1, "", "Minimum Trinket 1 Targets(This includes you)", true)
            br.ui:createDropdownWithout(section, "Trinket 1 Mode", { "|cffFFFFFFNormal", "|cffFFFFFFTarget", "|cffFFFFFFGround" }, 1, "", "")
            br.ui:createSpinner(section, "Trinket 2", 70, 0, 100, 5, "Health Percent to Cast At")
            br.ui:createSpinnerWithout(section, "Min Trinket 2 Targets", 3, 1, 40, 1, "", "Minimum Trinket 2 Targets(This includes you)", true)
            br.ui:createDropdownWithout(section, "Trinket 2 Mode", { "|cffFFFFFFNormal", "|cffFFFFFFTarget", "|cffFFFFFFGround" }, 1, "", "")
            br.ui:createSpinner(section, "Revitalizing Voodoo Totem", 75, 0 , 100, 5, "|cffFFFFFFHealth Percent to Cast At. Default: 75")
            br.ui:createSpinner(section, "Inoculating Extract", 75, 0 , 100, 5, "|cffFFFFFFHealth Percent to Cast At. Default: 75")
            br.ui:createSpinner(section,"Ward of Envelopment", 75, 0 , 100, 5, "|cffFFFFFFHealth Percent to Cast At. Default: 75")
        -- Cloudburst Totem
            br.ui:createSpinner(section, "Cloudburst Totem",  90,  0,  100,  5,  "Health Percent to Cast At") 
            br.ui:createSpinnerWithout(section, "Cloudburst Totem Targets",  3,  0,  40,  1,  "Minimum Cloudburst Totem Targets (excluding yourself)")
        -- Ascendance
            br.ui:createSpinner(section,"Ascendance",  60,  0,  100,  5,  "Health Percent to Cast At")
            br.ui:createSpinnerWithout(section, "Ascendance Targets",  3,  0,  40,  1,  "Minimum Ascendance Targets (excluding yourself)")
        -- Healing Tide Totem
            br.ui:createSpinner(section, "Healing Tide Totem",  50,  0,  100,  5,  "Health Percent to Cast At") 
            br.ui:createSpinnerWithout(section, "Healing Tide Totem Targets",  3,  0,  40,  1,  "Minimum Healing Tide Totem Targets (excluding yourself)")
            -- Spirit Link Totem
            br.ui:createSpinner(section, "Spirit Link Totem",  50,  0,  100,  5,  "Health Percent to Cast At") 
            br.ui:createSpinnerWithout(section, "Spirit Link Totem Targets",  3,  0,  40,  1,  "Minimum Spirit Link Totem Targets")
        -- Ancestral Protection Totem
            br.ui:createSpinner(section, "Ancestral Protection Totem",  70,  0,  100,  5,  "Health Percent to Cast At")
            br.ui:createSpinnerWithout(section, "Ancestral Protection Totem Targets",  3,  0,  40,  1,  "Minimum Ancestral Protection Totem Targets")
        br.ui:checkSectionState(section)
    -- Defensive Options
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
        -- Healthstone
            br.ui:createSpinner(section, "Healthstone",  30,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
        -- Heirloom Neck
            br.ui:createSpinner(section, "Heirloom Neck",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
        -- Gift of The Naaru
            if br.player.race == "Draenei" then
                br.ui:createSpinner(section, "Gift of the Naaru",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            end
        -- Astral Shift
            br.ui:createSpinner(section, "Astral Shift",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
        -- Purge
            br.ui:createDropdown(section,"Purge", {"|cffFFFF00Selected Target","|cffFFBB00Auto"}, 1, "|ccfFFFFFFTarget to Cast On")
            br.ui:createSpinnerWithout(section,"Purge Min Mana", 50,0,100,5, "|cffFFFFFFMinimum Mana to Use Purge At")
        -- Capacitor Totem
            br.ui:createSpinner(section, "Capacitor Totem - HP", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
            br.ui:createSpinner(section, "Capacitor Totem - AoE", 5, 0, 10, 1, "|cffFFFFFFNumber of Units in 5 Yards to Cast At")
        -- Earthen Wall Totem
            br.ui:createSpinner(section, "Earthen Wall Totem",  95,  0,  100,  5,  "Health Percent to Cast At") 
            br.ui:createSpinnerWithout(section, "Earthen Wall Totem Targets",  1,  0,  40,  1,  "Minimum Earthen Wall Totem Targets")
            -- Ancestral Spirit
            br.ui:createDropdown(section, "Ancestral Spirit", {"|cffFFFF00Selected Target","|cffFF0000Mouseover Target","|cffFFBB00Auto"}, 1, "|ccfFFFFFFTarget to Cast On")
        br.ui:checkSectionState(section)
    -- Interrupt Options
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
        -- Wind Shear
            br.ui:createCheckbox(section,"Wind Shear")
        -- Capacitor Totem
            br.ui:createCheckbox(section,"Capacitor Totem")
        -- Interrupt Percentage
            br.ui:createSpinner(section, "Interrupt At",  0,  0,  95,  5,  "|cffFFFFFFCast Percent to Cast At")
        br.ui:checkSectionState(section)
    -- Manual Keys
        section = br.ui:createSection(br.ui.window.profile, "Manual Keys")
        -- Healing Rain
            br.ui:createDropdown(section,"Healing Rain Key", br.dropOptions.Toggle, 6, colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.." Healing Rain manual usage.")
        -- Spirit Link
            br.ui:createDropdown(section,"Spirit Link Totem Key", br.dropOptions.Toggle, 6, colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.." Spirit Link Totem manual usage.")
        -- Ascendance
            br.ui:createDropdown(section,"Ascendance Key", br.dropOptions.Toggle, 6, colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.." Ascendance manual usage.")
        -- Healing Tide Totem
            br.ui:createDropdown(section,"Healing Tide Key", br.dropOptions.Toggle, 6, colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.." Healing Tide Totem manual usage.")
        -- Tremor Totem
            br.ui:createDropdown(section,"Tremor Totem Key", br.dropOptions.Toggle, 6, colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.." Tremor Totem manual usage.")
        br.ui:checkSectionState(section)
    -- Healing Options
        section = br.ui:createSection(br.ui.window.profile, "Healing")
        -- Healing Rain
            br.ui:createSpinner(section, "Healing Rain",  80,  0,  100,  5,  "Health Percent to Cast At") 
            br.ui:createSpinnerWithout(section, "Healing Rain Targets",  2,  0,  40,  1,  "Minimum Healing Rain Targets")
            br.ui:createCheckbox(section,"Healing Rain on Melee", "Cast on Melee only")
            br.ui:createCheckbox(section,"Healing Rain on CD", "Requires Healing Rain on Melee to be checked to work")
        -- Downpour
            br.ui:createSpinner(section, "Downpour", 70, 0 , 100, 5, "Health Percent to Cast At")
            br.ui:createSpinnerWithout(section, "Downpour Targets",  2,  0,  40,  1,  "Minimum Downpour Targets")
            br.ui:createCheckbox(section,"Downpour on Melee", "Cast on Melee only")
        -- Riptide
            br.ui:createSpinner(section, "Riptide",  90,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
        -- Healing Stream Totem
            br.ui:createSpinner(section, "Healing Stream Totem",  80,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
        -- Unleash Life
            br.ui:createSpinner(section, "Unleash Life",  80,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
        -- Healing Wave
            br.ui:createSpinner(section, "Healing Wave",  70,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
        -- Healing Surge
            br.ui:createSpinner(section, "Healing Surge",  60,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
        -- Chain Heal
            br.ui:createSpinner(section, "Chain Heal",  70,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            br.ui:createDropdownWithout(section, "Chain Heal Logic", {"|cffFFFF00New(Possible FPS Drops!)","|cffFF0000Old"}, 1, "|ccfFFFFFFLogic to use for CH")
            br.ui:createSpinnerWithout(section, "Chain Heal Targets",  3,  0,  40,  1,  "Minimum Chain Heal Targets")  
        -- Wellspring
            br.ui:createSpinner(section, "Wellspring",  80,  0,  100,  5,  "Health Percent to Cast At") 
            br.ui:createSpinnerWithout(section, "Wellspring Targets",  3,  0,  40,  1,  "Minimum Wellspring Targets")
        br.ui:checkSectionState(section)
    -- Toggle Key Options
        section = br.ui:createSection(br.ui.window.profile, "Toggle Keys")
        -- Single/Multi Toggle
            br.ui:createDropdown(section, "Rotation Mode", br.dropOptions.Toggle,  4)
        -- Cooldown Key Toggle
            br.ui:createDropdown(section, "Cooldown Mode", br.dropOptions.Toggle,  3)
        -- Defensive Key Toggle
            br.ui:createDropdown(section, "Defensive Mode", br.dropOptions.Toggle,  6)
        -- Interrupts Key Toggle
            br.ui:createDropdown(section, "Interrupt Mode", br.dropOptions.Toggle,  6)
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
    if br.timer:useTimer("debugRestoration", 0.1) then
        --print("Running: "..rotationName)
--------------
--- Locals ---
--------------
        local buff                                          = br.player.buff
        local cast                                          = br.player.cast
        local charges                                       = br.player.charges
        local deadMouse, hasMouse, playerMouse              = UnitIsDeadOrGhost("mouseover"), GetObjectExists("mouseover"), UnitIsPlayer("mouseover")
        local deadtar, playertar                            = UnitIsDeadOrGhost("target"), UnitIsPlayer("target")
        local combatTime                                    = getCombatTime()
        local cd                                            = br.player.cd
        local debuff                                        = br.player.debuff
        local drinking                                      = UnitBuff("player",192001) ~= nil or UnitBuff("player",225737) ~= nil
        local essence                                       = br.player.essence
        local gcd                                           = br.player.gcd
        local gcdMax                                        = br.player.gcdMax
        local healPot                                       = getHealthPot()
        local inCombat                                      = br.player.inCombat
        local inInstance                                    = br.player.instance=="party"
        local inRaid                                        = br.player.instance=="raid"
        local falling, swimming, flying, moving             = getFallTime(), IsSwimming(), IsFlying(), GetUnitSpeed("player")>0
        local lastSpell                                     = lastSpellCast
        local level                                         = br.player.level
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
        local tanks                                         = getTanksTable()
        local wolf                                          = br.player.buff.ghostWolf.exists()
        local ttd                                           = getTTD
        local ttm                                           = br.player.power.mana.ttm()
        local units                                         = br.player.units
        local enemies                                       = br.player.enemies
        local friends                                       = friends or {}
        local burst = nil

        units.get(8)
        units.get(40)
        enemies.get(5)
        enemies.get(8)
        enemies.get(8,"target")
        enemies.get(10)
        enemies.get(10,"target")
        enemies.get(20)
        enemies.get(30)
        enemies.get(40)
        friends.yards8 = getAllies("player",8)
        friends.yards25 = getAllies("player",25)
        friends.yards40 = getAllies("player",40)
        
        local lowest = {}
        lowest.unit = "player"
        lowest.hp = 100
        for i = 1, #br.friend do
            if br.friend[i].hp < lowest.hp then
                lowest = br.friend[i]
            end
        end

        if inInstance and select(3, GetInstanceInfo()) == 8 then
            for i = 1, #tanks do
                local ourtank = tanks[i].unit
                local Burststack = getDebuffStacks(ourtank, 240443)
                if Burststack >= getOptionValue("Bursting") then
                    burst = true
                    break
                else 
                    burst = false
                end
            end
        end

        local dpsSpells = {spell.lightningBolt, spell.chainLightning, spell.lavaBurst,spell.flameShock}
        local movingCheck = not isMoving("player") and not IsFalling() or (isMoving and buff.spiritwalkersGrace.exists("player"))
--------------------
--- Action Lists ---
--------------------
    -- Action List - Extras
        local function actionList_Extras()
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
        -- Water Walking
            if falling > 1.5 and buff.waterWalking.exists() then
                CancelUnitBuffID("player", spell.waterWalking)
            end
            if isChecked("Water Walking") and not inCombat and IsSwimming() and not buff.waterWalking.exists() then
                if cast.waterWalking() then br.addonDebug("Casting Waterwalking") return end
            end
            -- Ancestral Spirit
            if isChecked("Ancestral Spirit") and not inCombat and movingCheck and br.timer:useTimer("Resurrect", 4) then
                if getOptionValue("Ancestral Spirit")==1 and UnitIsPlayer("target") and UnitIsDeadOrGhost("target") and GetUnitIsFriend("target","player") then
                    if cast.ancestralSpirit("target","dead") then br.addonDebug("Casting Ancestral Spirit") return true end
                end
                if getOptionValue("Ancestral Spirit")==2 and UnitIsPlayer("mouseover") and UnitIsDeadOrGhost("mouseover") and GetUnitIsFriend("mouseover","player") then
                    if cast.ancestralSpirit("mouseover","dead") then br.addonDebug("Casting Ancestral Spirit") return true end
                end
                if getOptionValue("Ancestral Spirit") == 3 then
                    local deadPlayers = {}
                    for i =1, #br.friend do
                        if UnitIsPlayer(br.friend[i].unit) and UnitIsDeadOrGhost(br.friend[i].unit) then
                            tinsert(deadPlayers,br.friend[i].unit)
                        end
                    end
                    if #deadPlayers > 1 then
                        if cast.ancestralVision() then br.addonDebug("Casting Ancestral Vision") return true end
                    elseif #deadPlayers == 1 then
                        if cast.ancestralSpirit(deadPlayers[1],"dead") then br.addonDebug("Casting Ancestral Spirit") return true end
                    end
                end
            end
        end -- End Action List - Extras	
    -- Action List - Defensive
        local function actionList_Defensive()
            -- Earth Shield
            if cast.able.earthShield() then
                -- check if shield already exists
                local foundShield = false
                if isChecked("Earth Shield") then
                    for i = 1, #br.friend do
                        if buff.earthShield.exists(br.friend[i].unit) then
                            foundShield = true
                        end
                    end
                    -- if no shield found, apply to focus if exists
                    if foundShield == false then
                        if GetUnitExists("focus") == true then
                            if not buff.earthShield.exists("focus") then
                                if cast.earthShield("focus") then br.addonDebug("Casting Earth Shield") return end
                            end
                        else
                            for i = 1, #tanks do
                                if not buff.earthShield.exists(tanks[i].unit) and getDistance(tanks[i].unit) <= 40 then
                                    if cast.earthShield(tanks[i].unit) then br.addonDebug("Casting Earth Shield") return end
                                end
                            end
                        end
                    end
                end
            end
            -- Water Shield
            if isChecked("Water Shield") and not buff.waterShield.exists() then
                if cast.waterShield() then
                end    
            end
            -- Temple of Seth
            if inCombat and isChecked("Temple of Seth") and br.player.eID and br.player.eID == 2127 then
                for i = 1, GetObjectCountBR() do
                    local thisUnit = GetObjectWithIndex(i)
                    if GetObjectID(thisUnit) == 133392 then
                        sethObject = thisUnit
                        if getHP(sethObject) < 100 and getBuffRemain(sethObject,274148) == 0 and lowest.hp >= getValue("Temple of Seth") then
                            if not buff.riptide.exists(sethObject) then
                                CastSpellByName(GetSpellInfo(61295),sethObject)
                                br.addonDebug("Casting Riptide")
                                return
                        --cast.riptide("target") then return true end
                            end
                            if getHP(sethObject) < 50 and movingCheck then
                                CastSpellByName(GetSpellInfo(8004),sethObject)
                                br.addonDebug("Casting Healing Surge")
                                return
                        --if cast.healingSurge("target") then return true end
                            else
                                if movingCheck then
                                    CastSpellByName(GetSpellInfo(77472),sethObject)
                                    br.addonDebug("Casting Healing Wave")
                                    return
                                end
                        --if cast.healingWave("target") then return true end
                            end
                        end
                    end
                end
            end
            if useDefensive() then
            -- Healthstone
			if isChecked("Healthstone") and php <= getOptionValue("Healthstone") and (hasHealthPot() or hasItem(5512) or hasItem(166799)) then
				if canUseItem(5512) then
					br.addonDebug("Using Healthstone")
					useItem(5512)
				elseif canUseItem(healPot) then
					br.addonDebug("Using Health Pot")
					useItem(healPot)
				elseif hasItem(166799) and canUseItem(166799) then
					br.addonDebug("Using Emerald of Vigor")
					useItem(166799)
				end
			end
            -- Heirloom Neck
                if isChecked("Heirloom Neck") and php <= getOptionValue("Heirloom Neck") then
                    if hasEquiped(122668) then
                        if GetItemCooldown(122668)==0 then
                            useItem(122668)
                            br.addonDebug("Using Heirloom Neck")
                            return
                        end
                    end
                end
            -- Gift of the Naaru
                if isChecked("Gift of the Naaru") and php <= getOptionValue("Gift of the Naaru") and php > 0 and br.player.race == "Draenei" then
                    if castSpell("player",racial,false,false,false) then br.addonDebug("Casting Gift of the Naaru") return end
                end
            -- Astral Shift
                if isChecked("Astral Shift") and php <= getOptionValue("Astral Shift") and inCombat then
                    if cast.astralShift() then br.addonDebug("Casting Astral Shift") return end
                end
                -- Earthen Wall Totem
                if isChecked("Earthen Wall Totem") and talent.earthenWallTotem then
                    if castWiseAoEHeal(br.friend,spell.earthenWallTotem,20,getValue("Earthen Wall Totem"),getValue("Earthen Wall Totem Targets"),6,false,true) then br.addonDebug("Casting Earthen Wall Totem") return end
                end
                    -- Capacitor Totem
                if cd.capacitorTotem.remain() <= gcd then
                    if isChecked("Capacitor Totem - HP") and php <= getOptionValue("Capacitor Totem - HP") and inCombat and lastSpell ~= spell.capacitorTotem and #enemies.yards5 > 0 then
                        if cast.capacitorTotem("player") then br.addonDebug("Casting Capacitor Totem") return end
                    end
                    if isChecked("Capacitor Totem - AoE") and #enemies.yards5 >= getOptionValue("Capacitor Totem - AoE") and inCombat and lastSpell ~= spell.capacitorTotem then
                        if cast.capacitorTotem("player") then br.addonDebug("Casting Capacitor Totem") return end
                    end
                end
            end -- End Defensive Toggle
        end -- End Action List - Defensive
    -- Action List - Interrupts
        local function actionList_Interrupts()
            if useInterrupts() then
                for i=1, #enemies.yards30 do
                    thisUnit = enemies.yards30[i]
                    if canInterrupt(thisUnit,getOptionValue("Interrupt At")) then
        -- Wind Shear
                        if isChecked("Wind Shear") then
                            if cast.windShear(thisUnit) then br.addonDebug("Casting Wind Shear") return end
                        end
        -- Capacitor Totem
                        if isChecked("Capacitor Totem") then
                            if cast.capacitorTotem(thisUnit) then br.addonDebug("Casting Capacitor Totem") return end
                        end
                    end
                end
            end -- End useInterrupts check
        end -- End Action List - Interrupts
        local function ghostWolf()
            -- Ghost Wolf
            if not (IsMounted() or IsFlying()) and isChecked("Auto Ghost Wolf") then
               if mode.ghostWolf == 1 then
                   if ((#enemies.yards20 == 0 and not inCombat) or (#enemies.yards10 == 0 and inCombat)) and isMoving("player") and not buff.ghostWolf.exists() and not buff.spiritwalkersGrace.exists() then
                       if cast.ghostWolf() then br.addonDebug("Casting Ghost Wolf") end
                   elseif movingCheck and buff.ghostWolf.exists() and br.timer:useTimer("Delay",0.5) then
                       RunMacroText("/cancelAura Ghost Wolf")
                   end
               elseif mode.ghostWolf == 2 then
                   if not buff.ghostWolf.exists() and isMoving("player") then 
                       if SpecificToggle("Ghost Wolf Key")  and not GetCurrentKeyBoardFocus() then
                           if cast.ghostWolf() then br.addonDebug("Casting Ghost Wolf") end
                       end
                   elseif buff.ghostWolf.exists() then
                       if SpecificToggle("Ghost Wolf Key") then
                           return
                       else
                           if br.timer:useTimer("Delay",0.25) then
                               RunMacroText("/cancelAura Ghost Wolf")
                           end
                       end
                   end
               end        
           end
       end
        -- Action List - Pre-Combat
        function actionList_PreCombat()
            if isChecked("Pig Catcher") then
                bossHelper()
            end
            prepullOpener = inRaid and isChecked("Pre-pull Opener") and pullTimer <= getOptionValue("Pre-pull Opener") 
            -- Sapphire of Brilliance
            if prepullOpener then
                if hasItem(166801) and canUseItem(166801) then
                    br.addonDebug("Using Sapphire of Brilliance")
                    useItem(166801)
                end
            end
            -- Healing Rain
            if movingCheck and cd.healingRain.remain() <= gcd then
                if (SpecificToggle("Healing Rain Key") and not GetCurrentKeyBoardFocus()) and isChecked("Healing Rain Key") then
                    if CastSpellByName(GetSpellInfo(spell.healingRain),"cursor") then br.addonDebug("Casting Healing Rain") return end 
                end
            end
        -- Riptide
            if isChecked("Riptide") then
                for i = 1, #br.friend do
                    if lowest.hp <= getValue("Riptide") and buff.riptide.remain(lowest.unit) < 5.4 then
                        if cast.riptide(lowest.unit) then br.addonDebug("Casting Riptide") return end     
                    end
                end
            end
        -- Healing Stream Totem
           if isChecked("Healing Stream Totem") and cd.healingStreamTotem.remain() <= gcd and not talent.cloudburstTotem then
               -- for i = 1, #br.friend do                           
                    if lowest.hp <= getValue("Healing Stream Totem") then
                        if cast.healingStreamTotem(lowest.unit) then br.addonDebug("Casting Healing Stream Totem") return end     
                    end
               -- end
            end
        -- Healing Surge
            if isChecked("Healing Surge") and movingCheck then
               -- for i = 1, #br.friend do                           
                    if lowest.hp <= getValue("Healing Surge") and (buff.tidalWaves.exists() or level < 34) then
                        if cast.healingSurge(lowest.unit) then br.addonDebug("Casting Healing Surge") return end     
                    end
              --  end
            end
        -- Healing Wave
            if isChecked("Healing Wave") and movingCheck then
             --   for i = 1, #br.friend do                           
                    if lowest.hp <= getValue("Healing Wave") and (buff.tidalWaves.exists() or level < 34) then
                        if cast.healingWave(lowest.unit) then br.addonDebug("Casting Healing Wave") return end     
                    end
             --   end
            end
        -- Chain Heal
            if isChecked("Chain Heal") and movingCheck then
                if getOptionValue("Chain Heal Logic") == 1 then
                    if chainHealUnits(spell.chainHeal,15,getValue("Chain Heal"),getValue("Chain Heal Targets")) then br.addonDebug("Casting Chain Heal") return true end
                elseif getOptionValue("Chain Heal Logic") == 2 then
                    if castWiseAoEHeal(br.friend,spell.chainHeal,15,getValue("Chain Heal"),getValue("Chain Heal Targets"),5,false,true) then br.addonDebug("Casting Chain Heal") return end
                end
            end
            -- Healing Surge
            if isChecked("Healing Surge") and movingCheck then
                if lowest.hp <= 50 then
                    if cast.healingSurge(lowest.unit) then br.addonDebug("Casting Healing Surge") return end     
                end
            end
            if isChecked("Healing Wave") and movingCheck and not burst then
                if lowest.hp <= 65 then
                    if cast.healingWave(lowest.unit) then br.addonDebug("Casting Healing Wave") return end     
                end
            end
        end  -- End Action List - Pre-Combat
    -- Action List - DPS
        local function actionList_DPS()
        -- Lava Burst - Lava Surge
            if buff.lavaSurge.exists() then
                if debuff.flameShock.exists("target") then
                    if cast.lavaBurst() then br.addonDebug("Casting Lava Burst") return true end
                else
                    for i = 1, #enemies.yards40 do
                        local thisUnit = enemies.yards40[i]
                        if debuff.flameShock.exists(thisUnit) then
                            if cast.lavaBurst(thisUnit) then br.addonDebug("Casting Lava Burst") return true end
                        end
                    end
                end
            end
        -- Flameshock
            for i = 1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                if not debuff.flameShock.exists(thisUnit) then
                    if cast.flameShock(thisUnit) then br.addonDebug("Casting Flame Shock") return end
                end
            end
        -- Lava Burst
            if debuff.flameShock.remain(units.dyn40) > getCastTime(spell.lavaBurst) or level < 20 and movingCheck then
                if cast.lavaBurst() then br.addonDebug("Casting Lava Burst") return end
            end
		-- Chain Lightning
			if #enemies.yards10t >= 2 and movingCheck then 		
                if cast.chainLightning() then br.addonDebug("Casting Chain Lightning") return end		
			end			
        -- Lightning Bolt
            if movingCheck then
                if cast.lightningBolt() then br.addonDebug("Casting Lightning Bolt") return end
            end
        end -- End Action List - DPS
        local function actionList_Explosive()
            --Flameshock
            if not debuff.flameShock.exists("target") then
                if cast.flameShock() then br.addonDebug("Casting Flame Shock") return end
            end
            --Lavaburst (Lava Surge Buff)
            if buff.lavaSurge.exists() and debuff.flameShock.exists("target") then
                if cast.Lavaburst then br.addonDebug("Casting Lava Burst") return end
            end
        end
        local function actionList_AMR()
             -- Healing Rain
             if movingCheck and cd.healingRain.remain() <= gcd then
                if (SpecificToggle("Healing Rain Key") and not GetCurrentKeyBoardFocus()) and isChecked("Healing Rain Key") then
                    if CastSpellByName(GetSpellInfo(spell.healingRain),"cursor") then br.addonDebug("Casting Healing Rain") return end 
                end
            end
            --Spirit Link Key
            if (SpecificToggle("Spirit Link Totem Key") and not GetCurrentKeyBoardFocus()) and isChecked("Spirit Link Totem Key") then
                if CastSpellByName(GetSpellInfo(spell.spiritLinkTotem),"cursor") then br.addonDebug("Casting Spirit Link Totem") return end 
            end
            -- Coastal Mana Potion
            if isChecked("Mana Pot") and power <= getOptionValue("Mana Pot")
                and inCombat and  hasItem(152495)
            then
                if canUseItem(152495) then
                    useItem(152495)
                    br.addonDebug("Using Coastal Mana Pot")
                    return
                end
            end
        -- Ascendance Key
            if (SpecificToggle("Ascendance Key") and not GetCurrentKeyBoardFocus()) and isChecked("Ascendance Key") then
                if cast.ascendance() then br.addonDebug("Casting Ascendance") return end
            end
            -- Tremor Totem Key
            if (SpecificToggle("Tremor Totem Key") and not GetCurrentKeyBoardFocus()) and isChecked("Tremor Totem Key") then
                if cast.tremorTotem("player") then br.addonDebug("Casting Tremor Totem") return end
            end
            -- Healing Tide Key
            if (SpecificToggle("Healing Tide Key") and not GetCurrentKeyBoardFocus()) and isChecked("Healing Tide Key") then
                if cast.healingTideTotem() then br.addonDebug("Casting Healing Tide Totem") return end
            end
            -- Spirit Link Totem
            if isChecked("Spirit Link Totem") and useCDs() and not moving and cd.spiritLinkTotem.remain() <= gcd then
                if raidBurstInc and (not isChecked("Burst Count") or (isChecked("Burst Count") and burstCount == getOptionValue("Burst Count"))) then
                    local nearHealer = getAllies("player",10)
                    -- get the best ground circle to encompass the most of them
                    local loc = nil
                    if #nearHealer >= getValue("Spirit Link Totem Targets") then
                        if #nearHealer < 12 then
                            loc = getBestGroundCircleLocation(nearHealer,getValue("Spirit Link Totem Targets"),40,10)
                            if loc ~= nil then
                                if castGroundAtLocation(loc, spell.spiritLinkTotem) then br.addonDebug("Casting Spirit Link Totem") return true end
                            end
                        else
                            if castWiseAoEHeal(nearHealer,spell.spiritLinkTotem,10,100,getValue("Spirit Link Targets"),40,true, true) then br.addonDebug("Casting Spirit Link Totem") return end
                        end
                    end
                else
                    if castWiseAoEHeal(br.friend,spell.spiritLinkTotem,12,getValue("Spirit Link Totem"),getValue("Spirit Link Totem Targets"),40,false,true) then br.addonDebug("Casting Spirit Link Totem") return end
                end
            end
        -- Ancestral Protection Totem
            if isChecked("Ancestral Protection Totem") and useCDs() and cd.ancestralProtectionTotem.remain() <= gcd then
                if castWiseAoEHeal(br.friend,spell.ancestralProtectionTotem,20,getValue("Ancestral Protection Totem"),getValue("Ancestral Protection Totem Targets"),10,false,false) then br.addonDebug("casting Ancestral Protection Totem") return end
            end
        -- Earthen Wall Totem
            if isChecked("Earthen Wall Totem") and talent.earthenWallTotem and cd.earthenWallTotem.remain() <= gcd then
                if castWiseAoEHeal(br.friend,spell.earthenWallTotem,20,getValue("Earthen Wall Totem"),getValue("Earthen Wall Totem Targets"),6,false,true) then br.addonDebug("Casting Earthen Wall Totem") return end
            end
        -- Purify Spirit
            if br.player.ui.mode.decurse == 1 and cd.purifySpirit.remain() <= gcd then
                for i = 1, #friends.yards40 do
                    if canDispel(br.friend[i].unit,spell.purifySpirit) then
                        if cast.purifySpirit(br.friend[i].unit) then br.addonDebug("Casting Purify Spirit") return end
                    end
                end
            end
            -- Racial Buff
            if useCDs() then
                if (race == "Troll" or race == "Orc" or race == "MagharOrc" or race == "DarkIronDwarf" or race == "LightforgedDraenei") then
                    if race == "LightforgedDraenei" then
                    if cast.racial("target","ground") then br.addonDebug("Casting Racial") return true end
                    else
                    if cast.racial("player") then br.addonDebug("Casting Racial") return true end
                    end
                end
            end
        -- Trinkets
			if isChecked("Revitalizing Voodoo Totem") and hasEquiped(158320) and lowest.hp < getValue("Revitalizing Voodoo Totem") then
				if GetItemCooldown(158320) <= gcdMax then
					UseItemByName(158320, lowest.unit)
					br.addonDebug("Using Revitalizing Voodoo Totem")
				end
			end
			if isChecked("Inoculating Extract") and hasEquiped(160649) and lowest.hp < getValue("Inoculating Extract") then
				if GetItemCooldown(160649) <= gcdMax then
					UseItemByName(160649, lowest.unit)
					br.addonDebug("Using Inoculating Extract")
				end
			end
			if isChecked("Ward of Envelopment") and hasEquiped(165569) and GetItemCooldown(165569) <= gcdMax then
				-- get melee players
				for i = 1, #tanks do
					-- get the tank's target
					local tankTarget = UnitTarget(tanks[i].unit)
					if tankTarget ~= nil then
						-- get players in melee range of tank's target
						local meleeFriends = getAllies(tankTarget, 5)
						-- get the best ground circle to encompass the most of them
						local loc = nil
						if #meleeFriends >= 8 then
							loc = getBestGroundCircleLocation(meleeFriends, 4, 6, 10)
						else
							local meleeHurt = {}
							for j = 1, #meleeFriends do
								if meleeFriends[j].hp < 75 then
									tinsert(meleeHurt, meleeFriends[j])
								end
							end
							if #meleeHurt >= 2 then
								loc = getBestGroundCircleLocation(meleeHurt, 2, 6, 10)
							end
						end
						if loc ~= nil then
							useItem(165569)
							local px,py,pz = ObjectPosition("player")
							   loc.z = select(3,TraceLine(loc.x, loc.y, loc.z+5, loc.x, loc.y, loc.z-5, 0x110)) -- Raytrace correct z, Terrain and WMO hit
							   if loc.z ~= nil and TraceLine(px, py, pz+2, loc.x, loc.y, loc.z+1, 0x100010) == nil and TraceLine(loc.x, loc.y, loc.z+4, loc.x, loc.y, loc.z, 0x1) == nil then -- Check z and LoS, ignore terrain and m2 collisions 
								ClickPosition(loc.x, loc.y, loc.z)
								br.addonDebug("Using Ward of Envelopment")
								return
							end
						end
					end
				end
			end
			--Pillar of the Drowned Cabal
			if hasEquiped(167863) and canUseItem(16) then
				if not UnitBuffID(lowest.unit,295411) and lowest.hp < 75 then
					UseItemByName(167863,lowest.unit)
					br.addonDebug("Using Pillar of Drowned Cabal")
				end
			end
			if isChecked("Trinket 1") and canTrinket(13) and not hasEquiped(165569,13) and not hasEquiped(160649,13) and not hasEquiped(158320,13) and not hasEquiped(169314,13) then
				if getOptionValue("Trinket 1 Mode") == 1 then
					if getLowAllies(getValue("Trinket 1")) >= getValue("Min Trinket 1 Targets") or burst == true then
						useItem(13)
						br.addonDebug("Using Trinket 1")
						return true
					end
					elseif getOptionValue("Trinket 1 Mode") == 2 then
						if (lowest.hp <= getValue("Trinket 1") or burst == true) and lowest.hp ~= 250 then
						UseItemByName(GetInventoryItemID("player", 13), lowest.unit)
						br.addonDebug("Using Trinket 1 (Target)")
						return true
						end
					elseif getOptionValue("Trinket 1 Mode") == 3 and #tanks > 0 then
						for i = 1, #tanks do
							-- get the tank's target
							local tankTarget = UnitTarget(tanks[i].unit)
							if tankTarget ~= nil then
							-- get players in melee range of tank's target
							local meleeFriends = getAllies(tankTarget, 5)
							-- get the best ground circle to encompass the most of them
							local loc = nil
							if #meleeFriends < 12 then
								loc = getBestGroundCircleLocation(meleeFriends, 4, 6, 10)
							else
								local meleeHurt = {}
								for j = 1, #meleeFriends do
								if meleeFriends[j].hp < getValue("Trinket 1") then
									tinsert(meleeHurt, meleeFriends[j])
								end
								end
								if #meleeHurt >= getValue("Min Trinket 1 Targets") or burst == true then
								loc = getBestGroundCircleLocation(meleeHurt, 2, 6, 10)
								end
							end
							if loc ~= nil then
								useItem(13)
								br.addonDebug("Using Trinket 1 (Ground)")
								local px,py,pz = ObjectPosition("player")
								loc.z = select(3,TraceLine(loc.x, loc.y, loc.z+5, loc.x, loc.y, loc.z-5, 0x110)) -- Raytrace correct z, Terrain and WMO hit
								if loc.z ~= nil and TraceLine(px, py, pz+2, loc.x, loc.y, loc.z+1, 0x100010) == nil and TraceLine(loc.x, loc.y, loc.z+4, loc.x, loc.y, loc.z, 0x1) == nil then -- Check z and LoS, ignore terrain and m2 collisions
									ClickPosition(loc.x, loc.y, loc.z)
									return true
								end
							end
						end
					end
				end
			end
			if isChecked("Trinket 2") and canTrinket(14) and not hasEquiped(165569,14) and not hasEquiped(160649,14) and not hasEquiped(158320,14) and not hasEquiped(169314,13) then
				if getOptionValue("Trinket 2 Mode") == 1 then
					if getLowAllies(getValue("Trinket 2")) >= getValue("Min Trinket 2 Targets") or burst == true then
						useItem(14)
						br.addonDebug("Using Trinket 2")
						return true
					end
					elseif getOptionValue("Trinket 2 Mode") == 2 then
						if (lowest.hp <= getValue("Trinket 2") or burst == true) and lowest.hp ~= 250 then
						UseItemByName(GetInventoryItemID("player", 14), lowest.unit)
						br.addonDebug("Using Trinket 2 (Target)")
						return true
						end
					elseif getOptionValue("Trinket 2 Mode") == 3 and #tanks > 0 then
						for i = 1, #tanks do
							-- get the tank's target
							local tankTarget = UnitTarget(tanks[i].unit)
							if tankTarget ~= nil then
							-- get players in melee range of tank's target
							local meleeFriends = getAllies(tankTarget, 5)
							-- get the best ground circle to encompass the most of them
							local loc = nil
							if #meleeFriends < 12  then
								loc = getBestGroundCircleLocation(meleeFriends, 4, 6, 10)
							else
								local meleeHurt = {}
								for j = 1, #meleeFriends do
								if meleeFriends[j].hp < getValue("Trinket 2") then
									tinsert(meleeHurt, meleeFriends[j])
								end
								end
								if #meleeHurt >= getValue("Min Trinket 2 Targets") or burst == true then
								loc = getBestGroundCircleLocation(meleeHurt, 2, 6, 10)
								end
							end
							if loc ~= nil then
								useItem(14)
								br.addonDebug("Using Trinket 2 (Ground)")
								ClickPosition(loc.x, loc.y, loc.z)
								return true
							end
						end
					end
				end
            end
            if isChecked("Life-Binder's Invocation") and essence.lifeBindersInvocation.active and cd.lifeBindersInvocation.remain() <= gcd and getLowAllies(getOptionValue("Life-Binder's Invocation")) >= getOptionValue("Life-Binder's Invocation Targets") then
                if cast.lifeBindersInvocation() then
                    br.addonDebug("Casting Life-Binder's Invocation")
                    return true
                end
            end
            if isChecked("Ever-Rising Tide") and essence.overchargeMana.active and cd.overchargeMana.remain() <= gcd and getOptionValue("Ever-Rising Tide - Mana") <= mana then
                if getOptionValue("Ever-Rising Tide") == 1 then
                    if cast.overchargeMana() then
                        return
                    end
                end
                if getOptionValue("Ever-Rising Tide") == 2 then
                    if buff.ascendance.exists() or buff.cloudburstTotem.exists() or (HTTimer ~= nil or HTTimer ~= 0) or burst == true then
                        if cast.overchargeMana() then
                            return
                        end
                    end
                end
                if getOptionValue("Ever-Rising Tide") == 3 then
                    if lowest.hp < getOptionValue("Ever Rising Tide - Health") or burst == true then
                        if cast.overchargeMana() then
                            return
                        end
                    end
                end
            end
        -- Healing Tide Totem
            if isChecked("Healing Tide Totem") and useCDs() and not buff.ascendance.exists() and cd.healingTideTotem.remain() <= gcd then
                if getLowAllies(getValue("Healing Tide Totem")) >= getValue("Healing Tide Totem Targets") or burst == true or (raidBurstInc and (not isChecked("Burst Count") or (isChecked("Burst Count") and burstCount == getOptionValue("Burst Count")))) then    
                    if cast.healingTideTotem() then br.addonDebug("Casting Healing Tide Totem") HTTimer = GetTime() return end    
                end
            end
        -- Ascendance
            if isChecked("Ascendance") and useCDs() and talent.ascendance and cd.ascendance.remain() <= gcd and (not HTTimer or GetTime() - HTTimer > 10) then
                if getLowAllies(getValue("Ascendance")) >= getValue("Ascendance Targets") or burst == true or (raidBurstInc and (not isChecked("Burst Count") or (isChecked("Burst Count") and burstCount == getOptionValue("Burst Count")))) then    
                    if cast.ascendance() then br.addonDebug("Casting Ascendance") return end    
                end
            end
        --  Lucid Dream
            if isChecked("Lucid Dreams") and essence.memoryOfLucidDreams.active and mana <= 85 and getSpellCD(298357) <= gcd then
                if cast.memoryOfLucidDreams("player") then br.addonDebug("Casting Memory of Lucid Dreams") return end
            end
            -- Cloud Burst Totem
            if isChecked("Cloudburst Totem") and talent.cloudburstTotem and not buff.cloudburstTotem.exists() and cd.cloudburstTotem.remain() <= gcd and inCombat and #enemies.yards40 > 0 then
                if getLowAllies(getValue("Cloudburst Totem")) >= getValue("Cloudburst Totem Targets") then
                    if cast.cloudburstTotem("player") then
                        br.addonDebug("Casting Cloud Burst Totem")
                        ChatOverlay(colorGreen.."Cloudburst Totem!")
                        return
                    end
                end
            end
            -- Healing Rain
            if movingCheck and cd.healingRain.remain() <= gcd and br.timer:useTimer("HR Delay",5) then
                if isChecked("Healing Rain") and not buff.healingRain.exists() and mode.healingR == 1 then
                    if isChecked("Healing Rain on Melee") then
                        -- get melee players
                        for i=1, #tanks do
                            -- get the tank's target
                            local tankTarget = UnitTarget(tanks[i].unit)
                            if tankTarget ~= nil and getDistance(tankTarget,"player") < 40 then
                                -- get players in melee range of tank's target
                                local meleeFriends = getAllies(tankTarget,5)
                                -- get the best ground circle to encompass the most of them
                                local loc = nil
                                if isChecked("Healing Rain on CD") then
                                    -- CastGroundHeal(spell.healingRain, meleeFriends)
                                    -- return
                                    if #meleeFriends >= getValue("Healing Rain Targets") then
                                        if #meleeFriends < 12 then
                                            loc = getBestGroundCircleLocation(meleeFriends,getValue("Healing Rain Targets"),6,10)
                                        else
                                            if castWiseAoEHeal(meleeFriends,spell.healingRain,10,100,getValue("Healing Rain Targets"),6,true, true) then br.addonDebug("Casting Healing Rain") return end
                                        end
                                    end
                                else
                                    local meleeHurt = {}
                                    for j=1, #meleeFriends do
                                        if meleeFriends[j].hp < getValue("Healing Rain") then
                                            tinsert(meleeHurt,meleeFriends[j])
                                        end
                                    end
                                    if #meleeHurt >= getValue("Healing Rain Targets") then
                                        if #meleeHurt < 12 then
                                            loc = getBestGroundCircleLocation(meleeHurt,getValue("Healing Rain Targets"),6,10)
                                        else
                                            if castWiseAoEHeal(meleeHurt,spell.healingRain,10,getValue("Healing Rain"),getValue("Healing Rain Targets"),6,true, true) then br.addonDebug("Casting Healing Rain") return end
                                        end
                                    end
                                end
                                if loc ~= nil then
                                    if castGroundAtLocation(loc, spell.healingRain) then br.addonDebug("Casting Healing Rain (Cast Ground)") return true end
                                end
                            end
                        end
                    else
                        if castWiseAoEHeal(br.friend,spell.healingRain,10,getValue("Healing Rain"),getValue("Healing Rain Targets"),6,true, true) then br.addonDebug("Casting Healing Rain (Wise AoE)") return end
                    end
                end
            end	
            -- Wellspring
            if isChecked("Wellspring") and cd.wellspring.remain() <= gcd and movingCheck then
                if healConeAround(getValue("Wellspring Targets"), getValue("Wellspring"), 90, 30, 0) then br.addonDebug("Casting Wellspring") return end
                --if castWiseAoEHeal(br.friend,spell.wellspring,20,getValue("Wellspring"),getValue("Wellspring Targets"),6,true,true) then br.addonDebug("Casting Wellspring") return end
            end
            -- Downpour
            if cd.downpour.remain() <= gcd and movingCheck then
                if isChecked("Downpour") then
                    if isChecked("Downpour on Melee") then
                        -- get melee players
                        for i=1, #tanks do
                            -- get the tank's target
                            local tankTarget = UnitTarget(tanks[i].unit)
                            if tankTarget ~= nil and getDistance(tankTarget) <= 40 then
                                -- get players in melee range of tank's target
                                local meleeFriends = getAllies(tankTarget,5)
                                -- get the best ground circle to encompass the most of them
                                local loc = nil
                                local meleeHurt = {}
                                for j=1, #meleeFriends do
                                    if meleeFriends[j].hp < getValue("Downpour") then
                                        tinsert(meleeHurt,meleeFriends[j])
                                    end
                                end
                                if #meleeHurt >= getValue("Downpour Targets") then
                                    if #meleeHurt < 12 then
                                        loc = getBestGroundCircleLocation(meleeHurt,getValue("Downpour Targets"),6,10)
                                    else
                                        if castWiseAoEHeal(meleeHurt,spell.downpour,10,getValue("Downpour"),getValue("Downpour Targets"),6,true, true) then br.addonDebug("Casting Downpour") return end
                                    end            
                                end
                                if loc ~= nil then
                                    if castGroundAtLocation(loc, spell.downpour) then br.addonDebug("Casting Downpour") return true end
                                end
                            end
                        end
                    else
                        if castWiseAoEHeal(br.friend,spell.downpour,10,getValue("Downpour"),getValue("Downpour Targets"),6,true, true) then br.addonDebug("Casting Downpour") return end
                    end
                end 
            end
        -- Unleash Life
            if isChecked("Unleash Life") and talent.unleashLife and not hasEquiped(137051) and cd.unleashLife.remain() <= gcd then
              --  for i = 1, #br.friend do                           
                    if lowest.hp <= getValue("Unleash Life") then
                        if cast.unleashLife() then br.addonDebug("Casting Unleash Life") return end     
                    end
              --  end
            end
        -- Concentrated Flame
            if isChecked("Concentrated Flame") and essence.concentratedFlame.active and getSpellCD(295373) <= gcd then
                if lowest.hp <= getValue("Concentrated Flame") then
                    if cast.concentratedFlame(lowest.unit) then br.addonDebug("Casting Concentrated Flame") return end
                end
            end
            -- Refreshment
            if isChecked("Well of Existence") and essence.refreshment.active and cd.refreshment.remain() <= gcd and UnitBuffID("player",296138) and select(16,UnitBuffID("player",296138,"EXACT")) >= 15000 and lowest.hp <= getValue("Healing Wave") then
                if cast.refreshment(lowest.unit) then br.addonDebug("Casting Refreshment") return true end
            end
            -- Healing Surge (2 stacks)
            if isChecked("Healing Surge") and movingCheck then
                if lowest.hp <= getValue("Healing Surge") and buff.tidalWaves.stack() == 2 then
                    if cast.healingSurge(lowest.unit) then br.addonDebug("Casting Healing Surge") return end     
                end
            end
            -- Healing Wave
            if isChecked("Healing Wave") and movingCheck and not burst then
                if lowest.hp <= getValue("Healing Wave") and buff.tidalWaves.stack() == 2 then
                    if cast.healingWave(lowest.unit) then br.addonDebug("Casting Healing Wave") return end     
                end
            end
        -- Chain Heal
            if isChecked("Chain Heal") and movingCheck then
                if talent.unleashLife and talent.highTide then
                    if cast.unleashLife(lowest.unit) then return end
                    if buff.unleashLife.remain() > 2 then
                        if getOptionValue("Chain Heal Logic") == 1 then
                            if chainHealUnits(spell.chainHeal,15,getValue("Chain Heal"),getValue("Chain Heal Targets")+1) then br.addonDebug("Casting Chain Heal") return true end
                        elseif getOptionValue("Chain Heal Logic") == 2 then
                            if castWiseAoEHeal(br.friend,spell.chainHeal,15,getValue("Chain Heal"),getValue("Chain Heal Targets")+1,5,false,true) then br.addonDebug("Casting Chain Heal") return end
                        end
                    end
                elseif talent.highTide then
                    if getOptionValue("Chain Heal Logic") == 1 then
                        if chainHealUnits(spell.chainHeal,15,getValue("Chain Heal"),getValue("Chain Heal Targets")+1) then br.addonDebug("Casting Chain Heal") return true end
                    elseif getOptionValue("Chain Heal Logic") == 2 then
                        if castWiseAoEHeal(br.friend,spell.chainHeal,15,getValue("Chain Heal"),getValue("Chain Heal Targets")+1,5,false,true) then br.addonDebug("Casting Chain Heal") return end
                    end
                else
                    if getOptionValue("Chain Heal Logic") == 1 then
                        if chainHealUnits(spell.chainHeal,15,getValue("Chain Heal"),getValue("Chain Heal Targets")) then br.addonDebug("Casting Chain Heal") return true end
                    elseif getOptionValue("Chain Heal Logic") == 2 then
                        if castWiseAoEHeal(br.friend,spell.chainHeal,15,getValue("Chain Heal"),getValue("Chain Heal Targets"),5,false,true) then br.addonDebug("Casting Chain Heal") return end
                    end
                end
            end
        -- Healing Stream Totem
            if isChecked("Healing Stream Totem") and cd.healingStreamTotem.remain() <= gcd and movingCheck and not talent.cloudburstTotem then                        
                if lowest.hp <= getValue("Healing Stream Totem") then
                    if not talent.echoOfTheElements then
                        if cast.healingStreamTotem(lowest.unit) then br.addonDebug("Casting Healing Stream Totem") return end
                    elseif talent.echoOfTheElements and (not HSTime or GetTime() - HSTime > 15) then
                        if cast.healingStreamTotem(lowest.unit) then
                            br.addonDebug("Casting Healing Stream Totem")
                            HSTime = GetTime()
                            return true 
                        end
                    end 
                end
            end
        -- Riptide
            if isChecked("Riptide") then
                if not buff.tidalWaves.stack() == 2 and level >= 34 then
                    if cast.riptide(lowest.unit) then br.addonDebug("Casting Riptide") return end
                end
               for i = 1, #br.friend do
                    if lowest.hp <= getValue("Riptide") and buff.riptide.remain(lowest.unit) < 5.4 then
                        if cast.riptide(lowest.unit) then br.addonDebug("Casting Riptide") return end     
                    end
               end
            end
        -- Healing Wave
            if isChecked("Healing Wave") and movingCheck and not burst then
             --   for i = 1, #br.friend do                           
                    if lowest.hp <= getValue("Healing Wave") and (buff.tidalWaves.exists() or level < 100) then
                        if cast.healingWave(lowest.unit) then br.addonDebug("Casting Healing Wave") return end     
                    end
              --  end
            end
            -- Chain Heal
            if isChecked("Chain Heal") and movingCheck then
                if getOptionValue("Chain Heal Logic") == 1 then
                    if chainHealUnits(spell.chainHeal,15,getValue("Chain Heal"),2) then br.addonDebug("Casting Chain Heal") return true end
                elseif getOptionValue("Chain Heal Logic") == 2 then
                    if castWiseAoEHeal(br.friend,spell.chainHeal,15,getValue("Chain Heal"),2,5,false,true) then br.addonDebug("Casting Chain Heal") return end
                end
            end
            -- Healing Surge
            if isChecked("Healing Surge") and movingCheck then
                if lowest.hp <= 50 then
                    if cast.healingSurge(lowest.unit) then br.addonDebug("Casting Healing Surge") return end     
                end
            end
            if isChecked("Healing Wave") and movingCheck and not burst then
                if lowest.hp <= 65 then
                    if cast.healingWave(lowest.unit) then br.addonDebug("Casting Healing Wave") return end     
                end
            end
        end
-----------------
--- Rotations ---
-----------------
        if br.data.settings[br.selectedSpec][br.selectedProfile]['HE ActiveCheck'] == false and br.timer:useTimer("Error delay",0.5) then
            Print("Detecting Healing Engine is not turned on.  Please activate Healing Engine to use this profile.")
            return
        end
        ghostWolf()
        if inCombat then
           if IsAoEPending()then SpellStopTargeting() br.addonDebug(colorRed.."Canceling Spell") end
        end
        -- Pause
        if pause() then
            return true
        else 
---------------------------------
--- Out Of Combat - Rotations ---
---------------------------------
            if not inCombat and not IsMounted() and not drinking then
                if (buff.ghostWolf.exists() and mode.ghostWolf == 1) or not buff.ghostWolf.exists() then
                    actionList_Extras()
                    if isChecked("OOC Healing") then
                        actionList_PreCombat()
                    end
                    -- Purify Spirit
                    if br.player.ui.mode.decurse == 1 and cd.purifySpirit.remain() <= gcd then
                        for i = 1, #friends.yards40 do
                            if canDispel(br.friend[i].unit,spell.purifySpirit) then
                                if cast.purifySpirit(br.friend[i].unit) then br.addonDebug("Casting Purify Spirit") return end
                            end
                        end
                    end
                end
            end -- End Out of Combat Rotation
-----------------------------
--- In Combat - Rotations --- 
-----------------------------
            if inCombat and not IsMounted() and not drinking then
                if (buff.ghostWolf.exists() and mode.ghostWolf == 1) or not buff.ghostWolf.exists() then
                    actionList_Defensive()
                    actionList_Interrupts()
                    actionList_AMR()
                    -- Purge
                    if isChecked("Purge") and lowest.hp > getOptionValue("DPS Threshold") and power >= getOptionValue("Purge Min Mana") then
                        if getOptionValue("Purge") == 1 then
                            if canDispel("target",spell.purge) and GetObjectExists("target") then
                                if cast.purge("target") then br.addonDebug("Casting Purge") return true end
                            end
                        elseif getOptionValue("Purge") == 2 then
                            for i = 1, #enemies.yards30 do
                                local thisUnit = enemies.yards30[i]
                                if canDispel(thisUnit,spell.purge) then
                                    if cast.purge(thisUnit) then br.addonDebug("Casting Purge") return true end
                                end
                            end
                        end
                    end
                    if hasItem(166801) and canUseItem(166801) then
                        br.addonDebug("Using Sapphire of Brilliance")
                        useItem(166801)
                    end
                    if br.player.ui.mode.dPS == 1 and GetUnitExists("target") and UnitCanAttack("player","target") and getFacing("player","target") and lowest.hp > getOptionValue("DPS Threshold") then
                        if isExplosive("target") then
                            actionList_Explosive()
                        else
                            actionList_DPS()
                        end
                    end
                    if movingCheck and br.player.ui.mode.dPS == 1 then
                        if cast.lightningBolt() then br.addonDebug("Casting Lightning Bolt") return end
                    end
                end
            end -- End In Combat Rotation
        end -- Pause
    end -- End Timer
end -- End runRotation 
--local id = 264
local id = 0
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
