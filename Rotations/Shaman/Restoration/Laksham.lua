local rotationName = "Laksham_resto" -- Change to name of profile listed in options drop down
-- stole a lot of code from Kuu's rotation
---------------
--- Toggles ---
---------------
local function createToggles()
    -- Define custom toggles, these are the buttons from the toggle bar
    -- Rotation Button
    local RotationModes = {
        [1] = { mode = "Auto", value = 1, overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of #enemies.yards8 in range.", highlight = 0, icon = br.player.spell.flameShock },
        [2] = { mode = "Mult", value = 2, overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.chainLightning },
        [3] = { mode = "Sing", value = 3, overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.lightningBolt },
        [4] = { mode = "Off", value = 4, overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.manaTideTotem }
    };
    br.ui:createToggle(RotationModes, "Rotation", 1, 0)
    -- Cooldown Button
    local CooldownModes = {
        [1] = { mode = "Auto", value = 1, overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 0, icon = br.player.spell.healingTideTotem },
        [2] = { mode = "On", value = 2, overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.healingTideTotem },
        [3] = { mode = "Off", value = 3, overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.healingTideTotem }
    };
    br.ui:createToggle(CooldownModes, "Cooldown", 2, 0)
    -- Defensive Button
    local DefensiveModes = {
        [1] = { mode = "On", value = 1, overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 0, icon = br.player.spell.astralShift },
        [2] = { mode = "Off", value = 2, overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.astralShift }
    };
    br.ui:createToggle(DefensiveModes, "Defensive", 3, 0)

    -- Interrupt Button
    local InterruptModes = {
        [1] = { mode = "On", value = 1, overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 0, icon = br.player.spell.windShear },
        [2] = { mode = "Off", value = 2, overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.windShear },
        [3] = { mode = "NXT", value = 3, overlay = "Use once", tip = "Use once.", highlight = 0, icon = br.player.spell.windShear }
    }
    br.ui:createToggle(InterruptModes, "Interrupt", 4, 0)

    local DecurseModes = {
        [1] = { mode = "On", value = 1, overlay = "Decurse Enabled", tip = "Decurse Enabled", highlight = 0, icon = br.player.spell.purifySpirit },
        [2] = { mode = "Off", value = 2, overlay = "Decurse Disabled", tip = "Decurse Disabled", highlight = 0, icon = br.player.spell.purifySpirit }
    }
    br.ui:createToggle(DecurseModes, "Decurse", 5, 0)


end

---------------
--- OPTIONS ---
---------------
local function createOptions()
    local optionTable

    local function rotationOptions()
        local section
        -----------------------
        --- GENERAL OPTIONS --- -- Define General Options
        -----------------------
        section = br.ui:createSection(br.ui.window.profile, "General - 1.2")
        br.ui:createDropdownWithout(section, "Ghost Wolf Key", br.dropOptions.Toggle, 6, "|cff0070deSet key to hold down for Ghost Wolf")
        br.ui:createSpinnerWithout(section, "Minimum Mana for DPS", 50, 0, 100, 5, "Lowest mana to allow for DPS")
        br.ui:createSpinnerWithout(section, "Minimum Health for DPS", 50, 0, 100, 5, "Lowest health to allow for DPS")
        br.ui:checkSectionState(section)

        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
        br.ui:createCheckbox(section, "Chain Harvest")
        br.ui:createSpinnerWithout(section, "Chain Harvest Health", 50, 0, 100, 5, "Health threshold to use for Harvest. Default: 50")
        br.ui:createSpinnerWithout(section, "Chain Harvest Targets", 3, 0, 10, 5, "How many hits before using the spell. Default: 3")
        br.ui:createSpinner(section, "Mana Tide Totem", 40, 0, 100, 5, "Drop mana tide totem when mana is under value. Default: 40")
        br.ui:createSpinner(section, "Healing Tide Totem", 50, 0, 100, 5, "Health threshold to use for Healing Tide. Default: 50")
        br.ui:createSpinnerWithout(section, "Healing Tide Totem Targets", 3, 0, 10, 5, "How many hits before using the spell. Default: 3")
        br.ui:createSpinner(section, "Ascendance", 50, 0, 100, 5, "Health threshold to use for Ascendance. Default: 50")
        br.ui:createSpinnerWithout(section, "Ascendance Targets", 3, 0, 10, 5, "How many hits before using the spell. Default: 3")
        br.ui:checkSectionState(section)

        section = br.ui:createSection(br.ui.window.profile, "Heal")
        br.ui:createSpinner(section, "Critical HP", 30, 0, 100, 5, "Will stop casting a DPS Spell if party member drops below value. Default: 30")
        br.ui:createSpinnerWithout(section, "OOC heal", 80, 0, 100, 5, "Top people off. Default: 80")
        br.ui:createSpinner(section, "Cloudburst Totem", 80, 0, 100, 5, "Health to trigger CloudBurst totem. Default: 80")
        br.ui:createSpinnerWithout(section, "Cloudburst Totem Targets", 3, 0, 10, 5, "How many hits before using the spell. Default: 3")
        br.ui:createSpinnerWithout(section, "Healing Surge", 75, 0, 100, 5, "Top people off. Default: 75")
        br.ui:createSpinnerWithout(section, "Healing Wave", 75, 0, 100, 5, "Top people off. Default: 75")
        br.ui:createSpinner(section, "Chain Heal", 70, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        br.ui:createDropdownWithout(section, "Chain Heal Mode", { "Simple", "Advanced" }, 1, "CH modes")
        br.ui:createSpinnerWithout(section, "Chain Heal Targets", 3, 0, 20, 1, "Minimum Chain Heal Targets")
        br.ui:createSpinner(section, "Healing Rain", 80, 0, 100, 5, "Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Healing Rain Targets", 2, 0, 40, 1, "Minimum Healing Rain Targets")
        br.ui:checkSectionState(section)
        section = br.ui:createSection(br.ui.window.profile, "Capacitor Totem")
        br.ui:createCheckbox(section, "Capacitor Totem - Interrupt")
        br.ui:createSpinner(section, "Capacitor Totem - AOE", 2, 0, 10, 1, "# mobs to drop totem on")
        br.ui:checkSectionState(section)
        section = br.ui:createSection(br.ui.window.profile, "M+")
        br.ui:createCheckbox(section, "Grievous Wounds")
        br.ui:createCheckbox(section, "Pride Heal")
        br.ui:checkSectionState(section)

        section = br.ui:createSection(br.ui.window.profile, "Defensive")
        br.ui:createSpinner(section, "Astral Shift", 60, 0, 100, 5, "Health to trigger Astral Shift at. Default: 60")
        br.ui:createSpinner(section, "Pot/Stoned", 30, 0, 100, 5, "", "Health Percent to Cast At")
        br.ui:checkSectionState(section)

        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
        br.ui:createDropdown(section, "Priority Mark", { "|cffffff00Star", "|cffffa500Circle", "|cff800080Diamond", "|cff008000Triangle", "|cffffffffMoon", "|cff0000ffSquare", "|cffff0000Cross", "|cffffffffSkull" }, 8, "Mark to Prioritize")
        br.ui:createSpinner(section, "Interrupt At", 0, 0, 95, 5, "|cffFFBB00Cast Percentage to use at.")
        br.ui:checkSectionState(section)
    end
    optionTable = { {
                        [1] = "Rotation Options",
                        [2] = rotationOptions,
                    } }
    return optionTable
end

--------------
--- Locals ---
--------------
-- BR API Locals - Many of these are located from System/API, this is a sample of commonly used ones but no all inclusive
local cast
local cd
local charges
local enemies
local module
local power
local buff, debuff, spell
local talent
local ui
local mode
local unit
local units
local var
local gcd
-- my stuff
local lowest

local canDPS
local burst
local Burststack = 0
local BleedFriendCount = 0
local BleedStack = 0
local CLcount = 0
local CLtarget
local healTarget
local healReason
local healTargetHealth
local use, tank, inInstance, inRaid, solo, eating, php
local someone_casting, movingCheck
local tanks
local CBTotemTimer = 0
-- Any variables/functions made should have a local here to prevent possible conflicts with other things.






--lists

local StunsBlackList = {
    -- DeOtherSide
    [171333] = "Atal'ai Devoted",
    [168942] = "Death Speaker",
    [167964] = "4.RF-4.RF",
    [166608] = "Mueh'zala",
    [169905] = "Risen Warlord",
    [168934] = "Enraged Spirit",
    [164558] = "Hakkar the Soulflayer",
    [164556] = "Millhouse Manastorm",
    [171343] = "Bladebeak Matriarch",
    [167962] = "Defunct Dental Drill",
    [164555] = "Millificent Manastorm",
    [171184] = "Mythresh, Sky's Talons",
    [164450] = "Dealer Xy'exa",
    [170572] = "Atal'ai Hoodoo Hexxer",

    -- Halls of Atonement
    [164557] = "Shard of Halkias",
    [167876] = "Inquisitor Sigar",
    [165408] = "Halkias",
    [164218] = "Lord Chamberlain",
    [174175] = "Loyal Stoneborn",
    [167612] = "Stoneborn Reaver",
    [167607] = "Stoneborn Slasher",
    [164185] = "Echelon",
    [165410] = "High Adjudicator Aleez",

    --Mists of Tirna Scithe
    [164929] = "Tirnenn Villager",
    [167111] = "Spinemaw Staghorn",
    [164926] = "Drust Boughbreaker",
    [164517] = "Tred'ova",
    [173720] = "Mistveil Gorgegullet",
    [164567] = "Ingra Maloch",
    [173655] = "Mistveil Matriarch",
    [164804] = "Droman Oulfarran",
    [173714] = "Mistveil Nightblossom",
    [164501] = "Mistcaller",

    -- Plaguefall
    [164967] = "Doctor Ickus",
    [168155] = "Plaguebound",
    [168153] = "Plagueroc",
    [163882] = "Decaying Flesh Giant",
    [163915] = "Hatchling Nest",
    [164255] = "Globgrog",
    [163894] = "Blighted Spinebreaker",
    [164266] = "Domina Venomblade",
    [169159] = "Unstable Canister",
    [169861] = "Ickor Bileflesh",
    [168396] = "Plaguebelcher",
    [168886] = "Virulax Blightweaver",
    [164267] = "Margrave Stradama",

    -- Sanguine Depths
    [162100] = "Kryxis the Voracious",
    [171799] = "Depths Warden",
    [162103] = "Executor Tarvold",
    [162038] = "Regal Mistdancer",
    [162057] = "Chamber Sentinel",
    [162099] = "General Kaal",
    [162040] = "Grand Overseer",
    [162047] = "Insatiable Brute",
    [162102] = "Grand Proctor Beryllia",
    [171376] = "Head Custodian Javlin",

    -- Spires of Ascension
    [163077] = "Azules",
    [162059] = "Kin-Tara",
    [162058] = "Ventunax",
    [162061] = "Devos",
    [162060] = "Oryphrion",
    [168681] = "Forsworn Helion",
    [168844] = "Lakesis",
    [168843] = "Klotos",
    [168845] = "Astronos",
    [168318] = "Forsworn Goliath",
    [163520] = "Forsworn Squad-Leader",

    -- The Necrotic Wave
    [164414] = "Reanimated Mage",
}

-----------------
--- Functions --- -- List all profile specific custom functions here
-----------------



local function getMaxTTD(returnType)
    local mobs = br.player.enemies.get(40)
    local highTTD = 0
    local highTTDUnit = mobs[1]
    for i = 1, #mobs do
        if br.getTTD(mobs[i]) > highTTD and br.getTTD(mobs[i]) < 999 and not br.isExplosive(mobs[i]) then
            highTTD = br.getTTD(mobs[i])
            highTTDUnit = mobs[i]
        end
    end
    if returnType == "unit" then

        return highTTDUnit
    else
        return tonumber(highTTD)
    end
end

local function round(num, numDecimalPlaces)
    local mult = 10 ^ (numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

--can we heal?  to avoid spam
local function canheal(unit)
    if br.GetUnitIsUnit(unit, "player")
            or br._G.UnitIsPlayer(unit)
            and br._G.UnitInRange(unit)
            and not br.UnitBuffID(unit, 327140) --forgeborne-reveries
            and not br.UnitBuffID(unit, 344916) -- tuft-of-smoldering-plumage
            and (not br.UnitBuffID(unit, 108978) or br.getHP(unit) < ui.value("Critical HP")) --mages ...
            and br.getLineOfSight(unit, "player")
            and not br.GetUnitIsDeadOrGhost(unit)
            and br.GetUnitIsFriend(unit, "player")
    then
        return true
    else
        return false
    end
end

--------------------
--- Action Lists --- -- All Action List functions from SimC (or other rotation logic) here, some common ones provided
--------------------
local actionList = {} -- Table for holding action lists.


actionList.heal = function()
    --heal()

    if not buff.ghostWolf.exists() and charges.riptide.count() > 0 then
        if canheal(lowest.unit) and buff.riptide.refresh(lowest.unit) then
            if cast.riptide(lowest.unit) then
                br.addonDebug("[HEAL] Riptide on lowest")
                return
            end
        end
        if #tanks > 0 and canheal(lowest.unit) and buff.riptide.refresh(tanks[1].unit) then
            if cast.riptide(tanks[1].unit) then
                br.addonDebug("[HEAL] Riptide on Tank")
                return
            end
        end
    end


    -- Cloud Burst Totem

    if ui.checked("Cloudburst Totem") and talent.cloudburstTotem and unit.inCombat()
            and #tanks > 0 and br.getCombatTime() > 1 and br.getDistance(tanks[1].unit, "player") < 32 then
        if not buff.cloudburstTotem.exists() and cd.cloudburstTotem.remain() <= gcd and #enemies.yards40 > 0 then
            if cast.cloudburstTotem() then
                CBTotemTimer = br._G.GetTime()
                br.addonDebug("[HEAL] Placing Cloud Burst Totem")
                return true
            end
            --      end
        end
        if buff.cloudburstTotem.exists() and (br._G.GetTime() - CBTotemTimer >= 7.5) then
            if br.getLowAllies(ui.value("Cloudburst Totem")) >= ui.value("Cloudburst Totem Targets")
                    or lowest.hp <= ui.value("Critical HP")
            then
                if cast.recallCloudburstTotem("player") then
                    br.addonDebug("[HEAL] Bursting CloudBurst Totem")
                    CBTotemTimer = 0
                    return true
                end
            end
        end
    end

    -- Healing Rain
    if ui.checked("Healing Rain") and not buff.healingRain.exists() and unit.inCombat()
            and movingCheck and #tanks > 0 then
        --   local healingRainTargets = 0
        if br.getLowAllies(ui.value("Healing Rain")) >= ui.value("Healing Rain Targets") then
            local rainloc = br.getBestGroundCircleLocation(br.friend, 3, 6, 10)
            if cast.healingRain("groundLocation", rainloc.x, rainloc.y, 10) then
                br.addonDebug("[HEAL] Healing rain on group")
                return true
            end
        end
    end


    -- Wellspring
    if ui.checked("Wellspring") and talent.wellspring and cd.wellspring.remain() <= gcd and movingCheck then
        if br.healConeAround(ui.value("Wellspring Targets"), ui.value("Wellspring"), 90, 30, 0) then
            if cast.wellspring() then
                br.addonDebug("Casting Wellspring")
                return true
            end
        end
    end
    -- Chain Heal
    if ui.checked("Chain Heal") and cd.chainHeal.ready() and movingCheck then
        if ui.value("Chain Heal Mode") == 1 then
            local chainhealcounter = 0
            for i = 1, #br.friend do
                if canheal(br.friend[i].unit) and br.friend[i].hp < ui.value("Chain Heal") then
                    chainhealcounter = chainhealcounter + 1
                    if chainhealcounter >= ui.value("Chain Heal Targets") then
                        if cast.chainHeal(lowest.unit) then
                            br.addonDebug("[HEAL] Chain Heal - simple")
                            return true
                        end
                    end
                end
            end
        elseif ui.value("Chain Heal Mode") == 2 then
            if talent.unleashLife and talent.highTide then
                if cast.unleashLife(lowest.unit) then
                    return true
                end
                if buff.unleashLife.remain() > 2 then
                    if br.chainHealUnits(spell.chainHeal, 15, ui.value("Chain Heal"), ui.value("Chain Heal Targets") + 1) then
                        br.addonDebug("[HEAL] Chain Heal - Advanced")
                        return true
                    end
                end
            elseif talent.highTide then
                if br.chainHealUnits(spell.chainHeal, 15, ui.value("Chain Heal"), ui.value("Chain Heal Targets") + 1) then
                    br.addonDebug("[HEAL] Chain Heal - Advanced")
                    return true
                end
            else
                if br.chainHealUnits(spell.chainHeal, 15, ui.value("Chain Heal"), ui.value("Chain Heal Targets")) then
                    br.addonDebug("[HEAL] Chain Heal - Advanced")
                    return true
                end
            end
        end
    end


    -- Healing Surge
    if movingCheck then
        if cd.healingSurge.remain() <= gcd then
            if healTarget == "none" then
                if lowest.hp <= ui.value("Healing Surge") then
                    healTarget = lowest.unit
                    healReason = "HEAL"
                end
            end
            -- Cast
            if healTarget ~= "none" then
                healTargetHealth = round(br.getHP(healTarget), 1)
                if canheal(healTarget) then
                    if cast.healingSurge(healTarget) then
                        br.addonDebug("[" .. healReason .. "] healingSurge on: " .. br._G.UnitName(healTarget) .. "/" .. healTargetHealth)
                        healTarget = "none"
                        return true
                    end
                end
            end
        end
        if cast.able.healingWave(lowest.unit) then
            -- Healing Wave
            if healTarget == "none" then
                if lowest.hp <= ui.value("Healing Wave") and canheal(lowest.unit) then
                    healTarget = lowest.unit
                    healReason = "HEAL"
                end
            end
            -- Cast
            if healTarget ~= "none" then
                healTargetHealth = round(br.getHP(healTarget), 1)
                if canheal(healTarget) then
                    if cast.healingWave(healTarget) then
                        br.addonDebug("[" .. healReason .. "] healingWave on: " .. br._G.UnitName(healTarget) .. "/" .. healTargetHealth)
                        healTarget = "none"
                        return true
                    end
                end
            end
        end
    end




    -- Downpour
    if cd.downpour.remain() <= gcd and movingCheck then
        if ui.checked("Downpour") then
            if ui.checked("Downpour on Melee") then
                -- get melee players
                for i = 1, #tanks do
                    -- get the tank's target
                    local tankTarget = br._G.UnitTarget(tanks[i].unit)
                    if tankTarget ~= nil and br.getDistance(tankTarget) <= 40 then
                        -- get players in melee range of tank's target
                        local meleeFriends = br.getAllies(tankTarget, 5)
                        -- get the best ground circle to encompass the most of them
                        local loc = nil
                        local meleeHurt = {}
                        for j = 1, #meleeFriends do
                            if meleeFriends[j].hp < ui.value("Downpour") then
                                br._G.tinsert(meleeHurt, meleeFriends[j])
                            end
                        end
                        if #meleeHurt >= ui.value("Downpour Targets") then
                            if #meleeHurt < 12 then
                                loc = br.getBestGroundCircleLocation(meleeHurt, ui.value("Downpour Targets"), 6, 10)
                            else
                                if br.castWiseAoEHeal(meleeHurt, spell.downpour, 10, ui.value("Downpour"), ui.value("Downpour Targets"), 6, true, true) then
                                    if br._G.SpellIsTargeting() then
                                        br._G.SpellStopTargeting()
                                        br.addonDebug(colorRed .. "Canceling Spell")
                                    end
                                    br.addonDebug("Casting Downpour")
                                    return true
                                end
                            end
                        end
                        if loc ~= nil then
                            if br.castGroundAtLocation(loc, spell.downpour) then
                                if br._G.SpellIsTargeting() then
                                    br._G.SpellStopTargeting()
                                    br.addonDebug(colorRed .. "Canceling Spell")
                                end
                                br.addonDebug("Casting Downpour")
                                return true
                            end
                        end
                    end
                end
            else
                if br.castWiseAoEHeal(br.friend, spell.downpour, 10, ui.value("Downpour"), ui.value("Downpour Targets"), 6, true, true) then
                    if br._G.SpellIsTargeting() then
                        br._G.SpellStopTargeting()
                        br.addonDebug(colorRed .. "Canceling Spell")
                    end
                    br.addonDebug("Casting Downpour")
                    return true
                end
            end
        end
    end
    -- Healing Stream Totem
    if not talent.cloudburstTotem and movingCheck and not buff.swirlingCurrents.exists() then
        if lowest.hp <= 95 then
            if cast.healingStreamTotem(lowest.unit) then
                br.addonDebug("Casting Healing Stream Totem")
                return true
            end
        end
    end
end

actionList.DPS = function()

    -- I want to find the target with highest hp
    --longest ttd

    if cast.able.lavaBurst() and #enemies.yards40 < 3 and movingCheck then
        for i = 1, #enemies.yards40 do
            if debuff.flameShock.remain(enemies.yards40[i]) > br.getCastTime(spell.lavaBurst)
                    and br.getTTD(enemies.yards40[i]) > br.getCastTime(spell.lavaBurst)
            then
                if cast.lavaBurst(enemies.yards40[i]) then
                    br.addonDebug("[DPS] Lava Burst!")
                    return
                end
            end
        end
    end
    -- Chain Lightning

    if #enemies.yards40 >= 1 and movingCheck then
        CLtarget = getMaxTTD("unit")
        if CLtarget then
            CLcount = enemies.get(10, CLtarget)
            if #CLcount >= 2 or mode.rotation == 3 then
                if cast.chainLightning(CLtarget) then
                    br.addonDebug("[DPS] Chain Lightning on: " .. br._G.UnitName(CLtarget) .. " #: " .. tostring(#CLcount))
                    return
                end
            else
                if cast.lightningBolt(units.dyn40) then
                    br.addonDebug("[DPS] Lightning Bolt! - " .. tostring(#CLcount))
                    return
                end
            end
        end
    end
end

actionList.extra = function()

    if not buff.ghostWolf.exists() and br.isMoving("player") then
        if br.SpecificToggle("Ghost Wolf Key") and not br._G.GetCurrentKeyBoardFocus() then
            if cast.ghostWolf() then
                br.addonDebug("[Extra] Ghost Wolf")
            end
        end
    elseif buff.ghostWolf.exists() then
        if br.SpecificToggle("Ghost Wolf Key") and not br._G.GetCurrentKeyBoardFocus() then
            return
        else
            if br.timer:useTimer("Delay", 0.25) then
                br._G.RunMacroText("/cancelAura Ghost Wolf")
            end
        end
    end

    if not buff.waterShield.exists() then
        if cast.waterShield() then
            br.addonDebug("[Extra] Water Shield")
            return
        end
    end

    if ui.checked("Mana Tide Totem") and unit.inCombat() and br.getMana("player") < ui.value("Mana Tide Totem") then
        if cast.manaTideTotem() then
            br.addonDebug("[Extra] manaTideTotem")
            return
        end
    end

    if #tanks > 0 and cd.earthShield.ready() then
        if canheal(tanks[1].unit) and not buff.earthShield.exists(tanks[1].unit) then
            if cast.earthShield(tanks[1].unit) then
                br.addonDebug("[Extra]  Earth Shield on: " .. br._G.UnitName(tanks[1].unit))
                return
            end
        end
    end

    if ui.checked("Capacitor Totem - AOE") and cd.capacitorTotem.ready() then
        if #enemies.get(8, "player") >= ui.value("Capacitor Totem - AOE") then
            if cast.capacitorTotem("player") then
                br.addonDebug("[EXTRA] Capacitor Totem - AOE(player)")
                return true
            end
        end
        if #tanks > 0 and #enemies.get(8, tanks[1].unit) >= ui.value("Capacitor Totem - AOE") then
            if cast.capacitorTotem(tanks[1].unit) then
                br.addonDebug("[EXTRA] Capacitor Totem - AOE(tank)")
                return true
            end
        end
    end
end

actionList.triage = function()

    healTarget = "none"
    healReason = "none"

    --Critical first
    if healTarget == "none" then
        if php <= ui.value("Critical HP") then
            healTarget = "player"
            healReason = "CRIT"
        end
    end
    if healTarget == "none" then
        if lowest.hp <= ui.value("Critical HP") and canheal(lowest.unit) then
            healTarget = lowest.unit
            healReason = "CRIT"
        end
    end

    if healTarget == "none" and ui.checked("Pride Heal") and br.GetObjectID("target") == 173729 then
        local prideHealTarget = "player"
        local prideHealHealth = br._G.UnitHealth("player")
        for i = 1, #br.friend do
            if canheal(br.friend[i].unit) and br._G.UnitHealth(br.friend[i].unit) < prideHealHealth then
                prideHealTarget = br.friend[i].unit
            end
        end
        if br.getHP(prideHealTarget) < ui.value("Minimum Health for DPS") then
            healTarget = prideHealTarget
            healReason = "PRIDE"
        end
    end

    if healTarget == "none" and ui.checked("Grievous Wounds") then
        --Grievous Wounds
        BleedStack = 0
        for i = 1, #br.friend do
            if br.friend[i].hp < 90 and canheal(br.friend[i].unit) then
                local CurrentBleedstack = br.getDebuffStacks(br.friend[i].unit, 240559)
                if br.getDebuffStacks(br.friend[i].unit, 240559) >= ui.value("Grievous Wounds") then
                    BleedFriendCount = BleedFriendCount + 1
                end
                if CurrentBleedstack > BleedStack then
                    BleedStack = CurrentBleedstack
                    healTarget = br.friend[i].unit
                    healReason = "GRIEV"
                end
            end
        end
    end
end

actionList.HighPrio = function()


    CLtarget = getMaxTTD("unit")
    if CLtarget then
        CLcount = enemies.get(10, CLtarget)
        if mode.rotation < 4 and (#CLcount <= 2 or mode.rotation == 3) then
            if lowest.hp > br.getValue("Critical HP") then
                if cd.flameShock.ready() then
                    for i = 1, #enemies.yards40 do
                        local thisUnit = enemies.yards40[i]
                        if not debuff.flameShock.exists(thisUnit) then
                            if cast.flameShock(thisUnit) then
                                br.addonDebug("[HighPrio] Casting Flame Shock")
                                return true
                            end
                        end
                    end
                end
                if buff.lavaSurge.exists() and charges.lavaBurst.count() > 0 then
                    for i = 1, #enemies.yards40 do
                        local thisUnit = enemies.yards40[i]
                        if debuff.flameShock.exists(thisUnit) then
                            if cast.lavaBurst(thisUnit) then
                                br.addonDebug("[HighPrio] Casting Lava Burst (Lava Surge)")
                                return true
                            end
                        end
                    end
                end
            end
        end
    end


end -- End Action List highprio

actionList.Defensive = function()

    if br.useDefensive() then
        if ui.checked("Astral Shift") and php <= ui.value("Astral Shift") and unit.inCombat() then
            if cast.astralShift() then
                br.addonDebug("Casting Astral Shift")
                return
            end
        end
        --Healthstone / Heathpots :  156634 == Silas Vial of Continuous curing / 5512 == warlock health stones
        if br.isChecked("Pot/Stoned") and php <= br.getValue("Pot/Stoned") and (br.hasHealthPot() or br.hasItem(5512) or br.hasItem(156634) or br.hasItem(177278)) then
            if br.canUseItem(5512) then
                br.useItem(5512)
            elseif br.canUseItem(177278) then
                br.useItem(177278)
            elseif br.canUseItem(171267) then
                br.useItem(171267)
            end
        end


    end


end -- End Action List - Defensive

actionList.Interrupt = function()

    if mode.interrupt == 1 or mode.interrupt == 3 and ((cd.capacitorTotem.ready() and ui.checked("Capacitor Totem - Interrupt") and cd.global.remains() == 0) or cd.windShear.ready()) then
        local interrupt_target
        local distance
        local priority_target
        local mob_count = #enemies.yards30

        if br.isChecked("Priority Mark") then
            for i = 1, mob_count do
                if br._G.GetRaidTargetIndex(enemies.yards30[i]) == br.getOptionValue("Priority Mark") then
                    priority_target = enemies.yards30[i]
                    break
                end
            end
        end
        for i = 1, mob_count do
            if priority_target ~= nil then
                interrupt_target = priority_target
            else
                interrupt_target = enemies.yards30[i]
            end

            if br.canInterrupt(interrupt_target, br.getOptionValue("Interrupt %")) then
                distance = br.getDistance(interrupt_target)
                if not (inInstance and #tanks > 0 and select(3, br._G.UnitClass(tanks[1].unit)) == 1
                        and br.hasBuff(23920, tanks[1].unit)
                        and br._G.GetUnitIsUnit(select(3, br._G.UnitCastID(interrupt_target)), tanks[1].unit)) then
                    if cd.windShear.ready() and distance < 30 and br.getFacing("player", interrupt_target) then
                        if cast.windShear(interrupt_target) then
                            br.addonDebug("[int]Kicked " .. br._G.UnitName(interrupt_target))
                            someone_casting = false
                            if mode.interrupt == 3 then
                                br._G.RunMacroText("/br toggle interrupt 2")
                            end
                            return true
                        end
                    end
                    if cd.capacitorTotem.ready() and ui.checked("Capacitor Totem - Interrupt") and cd.global.remains() == 0 then
                        if StunsBlackList[br.GetObjectID(interrupt_target)] == nil
                                and br.player.cast.timeRemain(interrupt_target) < br.getTTD(interrupt_target) then
                            if cast.capacitorTotem(interrupt_target) then
                                br.addonDebug("[int]Capacitor Totem on: " .. br._G.UnitName(interrupt_target))
                                return
                            end
                        end
                    end
                end
            end
        end
    end
end -- End Interrupt

actionList.Cooldown = function()

    -- Purify Spirit
    if mode.decurse == 1 and cd.purifySpirit.remain() <= br.player.gcd then
        for i = 1, #br.friend do
            if canheal(br.friend[i].unit) and br.canDispel(br.friend[i].unit, spell.purifySpirit) then
                if cast.purifySpirit(br.friend[i].unit) then
                    br.addonDebug("Casting Purify Spirit")
                    return true
                end
            end
        end
    end

    if cd.chainHarvest.ready() and ui.checked("Chain Harvest") and br.player.covenant.venthyr.active and movingCheck
            and (buff.cloudburstTotem.exists() or not talent.cloudburstTotem)
    then
        local chainHarvestTargetsHeal = 0
        local chainHarvestTargetsDPS = 0
        local castTarget
        for i = 1, #br.friend do
            if br.friend[i].hp <= ui.value("Chain Harvest Health") then
                chainHarvestTargetsHeal = chainHarvestTargetsHeal + 1
            end
        end
        if mode.rotation < 4 then
            for i = 1, #enemies.yards40 do
                if br.getHP(enemies.yards40[i]) >= ui.value("Chain Harvest Health") then
                    chainHarvestTargetsDPS = chainHarvestTargetsDPS + 1
                end
            end
        end
        if chainHarvestTargetsHeal + chainHarvestTargetsDPS >= ui.value("Chain Harvest Targets") then
            if chainHarvestTargetsHeal > chainHarvestTargetsDPS then
                castTarget = lowest.unit
            else
                castTarget = getMaxTTD("unit")
            end
            if castTarget then
                if cast.chainHarvest(castTarget) then
                    br.addonDebug("[COV] Casting Chain Harvest on " .. br._G.UnitName(castTarget))
                    return true
                end
            end
        end
    end

    if br.useCDs() then
        local function tideTotemExists()
            for i = 1, 4 do
                if br._G.GetTotemInfo(i) ~= nil then
                    if select(2, br._G.GetTotemInfo(i)) == "Healing Tide Totem" then
                        return true
                    end
                end
            end
            return false
        end

        if not moving and cd.spiritLinkTotem.remain() <= gcd then
            if br.castWiseAoEHeal(br.friend, spell.spiritLinkTotem, 12, 80 , 3 , 40, false, true) then
                br.addonDebug("Casting Spirit Link Totem")
                return
            end
        end
        -- Healing Tide Totem
        if ui.checked("Healing Tide Totem") and not buff.ascendance.exists() and cd.healingTideTotem.remain() <= gcd then
            if
            br.getLowAllies(ui.value("Healing Tide Totem")) >= ui.value("Healing Tide Totem Targets") or burst == true
            then
                if cast.healingTideTotem() then
                    br.addonDebug("[CD] Healing Tide Totem")
                    return
                end
            end
        end
        -- Ascendance
        if ui.checked("Ascendance") and talent.ascendance and cd.ascendance.remain() <= gcd and not tideTotemExists() then
            if br.getLowAllies(ui.value("Ascendance")) >= ui.value("Ascendance Targets") or burst == true
            then
                if cast.ascendance() then
                    br.addonDebug("[CD] Ascendance")
                    return
                end
            end
        end
    end -- end CD toggle
end -- End Action List - Cooldowns


local frame = br._G.CreateFrame("Frame")
frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
local function reader()
    local timeStamp, param, hideCaster, source, sourceName, sourceFlags, sourceRaidFlags, destination, destName, destFlags, destRaidFlags, spell, spellName, _, spellType = br._G.CombatLogGetCurrentEventInfo()
    if param == "SPELL_CAST_START" and br._G.bit.band(sourceFlags, 0x00000800) > 0 then
        br._G.C_Timer.After(0.02, function()
            someone_casting = true
            --   Print(sourceName .. " is casting " .. spellName .. " - creature[" .. tostring(bit.band(sourceFlags, 0x00000800) > 0) .. "]")
        end)
    end
end
frame:SetScript("OnEvent", reader)

local function runRotation()
    -- This is the main profile loop, any below this point is ran every cycle, everything above is ran only once during initialization.
    ---------------------
    --- Define Locals ---
    ---------------------
    -- BR API Locals - These are the same as the locals above just defined for use.
    buff = br.player.buff
    debuff = br.player.debuff
    spell = br.player.spell
    cast = br.player.cast
    cd = br.player.cd
    charges = br.player.charges
    enemies = br.player.enemies
    module = br.player.module
    power = br.player.power
    talent = br.player.talent
    ui = br.player.ui
    unit = br.player.unit
    units = br.player.units
    var = br.player.variables
    --lowest = br.friend[1]
    lowest = {}
    use = br.player.use
    tanks = br.getTanksTable()
    unit = br.player.unit
    gcd = br.player.gcd
    healTarget = "none"
    healReason = "none"
    mode = br.player.ui.mode
    php = br.player.health
    healTargetHealth = 100
    inInstance = br.player.instance == "party"
    inRaid = br.player.instance == "raid"
    solo = br.friends == 1
    eating = br.getBuffRemain("player", 192002) ~= 0 or br.getBuffRemain("player", 167152) ~= 0 or br.getBuffRemain("player", 192001) ~= 0 or br.getBuffRemain("player", 308433) ~= 0
    movingCheck = not br.isMoving("player") and not br._G.IsFalling() or (br.isMoving("player") and buff.spiritwalkersGrace.exists("player"))

    -- Explanations on the Units and Enemies functions can be found in System/API/Units.lua and System/API/Enemies.lua


    units.get(40) -- Makes a variable called, units.dyn40
    enemies.get(5) -- Makes a varaible called, enemies.yards5
    enemies.get(30) -- Makes a varaible called, enemies.yards40
    enemies.get(40) -- Makes a varaible called, enemies.yards40


    if br.shaman.resto["Healing Rain"] == nil then
        br.shaman.resto["Healing Rain"] = 0
    end

    lowest.unit = "player"
    lowest.hp = 100
    for i = 1, #br.friend do
        if canheal(br.friend[i].unit) and br.friend[i].hp < lowest.hp then
            lowest = br.friend[i]
        end
        --   ui.print(tostring(lowest.unit))
    end


    -- Begin Profile


    -- executed outside of gcd
    if not br._G.UnitCastingInfo("player") and someone_casting == true and unit.inCombat() and (mode.interrupt == 1 or mode.interrupt == 3) then
        if actionList.Interrupt() then
        end
    end

    if not br._G.IsMounted() then
        if br.pause() or eating or br.hasBuff(250873) or br.hasBuff(115834) or br.hasBuff(58984) or br.hasBuff(185710) or br.isCastingSpell(212056) then
            return true
        else
            if actionList.extra() then
                return true
            end
            if actionList.Defensive() then
                return true
            end
            if unit.inCombat() then
                if actionList.HighPrio() then
                    return true
                end
                if actionList.Cooldown() then
                    return true
                end
                actionList.triage()
                if actionList.heal() then
                    return true
                end
                if mode.rotation < 4 and lowest.hp > ui.value("Minimum Health for DPS") and br.getMana("player") > ui.value("Minimum Mana for DPS") then
                    if actionList.DPS() then
                        return true
                    end
                end
            end
            if lowest.hp <= ui.value("OOC heal") then
                if actionList.heal() then
                    return true
                end
            end
        end -- End In Combat Rotation
    end -- Pause
end -- End runRotation
local id = 264
if br.rotations[id] == nil then
    br.rotations[id] = {}
end
br._G.tinsert(
        br.rotations[id],
        {
            name = rotationName,
            toggles = createToggles,
            options = createOptions,
            run = runRotation
        }
)
