local rotationName = "Laksweaver"

local function createToggles()
    -- Define custom toggles

    -- Cooldown Button


    DPSModes = {
        [1] = { mode = "Auto", value = 1, overlay = "DPS Auto", tip = "Auto DPS Enabled", highlight = 0, icon = br.player.spell.tigerPalm },
        [2] = { mode = "Single", value = 2, overlay = "DPS Single", tip = "Single DPS Disabled", highlight = 0, icon = br.player.spell.blackoutKick },
        [3] = { mode = "Multi", value = 3, overlay = "DPS Multi", tip = "Multi DPS Enabled", highlight = 0, icon = br.player.spell.spinningCraneKick },
        [4] = { mode = "Off", value = 4, overlay = "DPS Disabled", tip = "DPS Disabled", highlight = 0, icon = br.player.spell.soothingMist }

    };
    CreateButton("DPS", 1, 0)

    CooldownModes = {
        [1] = { mode = "On", value = 1, overlay = "Cooldowns Enabled", tip = "Cooldowns will be used.", highlight = 0, icon = br.player.spell.revival },
        [2] = { mode = "Off", value = 2, overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.revival }
    };
    CreateButton("Cooldown", 2, 0)
    -- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1, overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 0, icon = br.player.spell.dampenHarm },
        [2] = { mode = "Off", value = 2, overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.dampenHarm }
    };
    CreateButton("Defensive", 3, 0)
    -- Interrupt Button
    InterruptModes = {
        [1] = { mode = "On", value = 1, overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 0, icon = br.player.spell.legSweep },
        [2] = { mode = "Off", value = 2, overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.legSweep }
    };
    CreateButton("Interrupt", 4, 0)
    --Detox Button
    DetoxModes = {
        [1] = { mode = "On", value = 1, overlay = "Detox Enabled", tip = "Detox Enabled", highlight = 0, icon = br.player.spell.detox },
        [2] = { mode = "Off", value = 2, overlay = "Detox Disabled", tip = "Detox Disabled", highlight = 0, icon = br.player.spell.detox }
    };
    CreateButton("Detox", 5, 0)
    -- DPS Button

    PrehotModes = {
        [1] = { mode = "On", value = 1, overlay = "Pre-Hot", tip = "Pre-hot Enabled", highlight = 0, icon = br.player.spell.renewingMist },
        [2] = { mode = "Off", value = 3, overlay = "Pre-Hot", tip = "Pre-hots on Tank", highlight = 0, icon = br.player.spell.renewingMist }
    };
    CreateButton("Prehot", 5, -1)

end

-- semi-globals
local last_statue_location = { x = 0, y = 0, z = 0 }
local jadeUnitsCount = 0
local jadeUnits = nil
local RM_counter = 0

---------------
--- OPTIONS ---
---------------options
local function createOptions()
    local optionTable

    local function rotationOptions()
        local section
        section = br.ui:createSection(br.ui.window.profile, "Key Options - 200421-0829")
        br.ui:createDropdownWithout(section, "DPS Key", br.dropOptions.Toggle, 6, "DPS key will override any heal/dispel logic")
        br.ui:createCheckbox(section, "WotC as part of DPS", "Use WotC as part of DPS key")

        br.ui:createDropdownWithout(section, "Heal Key", br.dropOptions.Toggle, 6, "Will ignore automated logic and heal mouseover target")
        br.ui:checkSectionState(section)

        section = br.ui:createSection(br.ui.window.profile, "Heal Options")
        br.ui:createSpinnerWithout(section, "Critical HP", 30, 0, 100, 5, "", "When to stop what we do, emergency heals!")
        br.ui:createSpinner(section, "Renewing Mist", 0, 0, 100, 1, "Health Percent to Cast At - 0 for on CD")
        br.ui:createSpinner(section, "Refreshing Jade Wind", 80, 0, 100, 5, "Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, "RJW Targets", 3, 1, 10, 1, "Minimum hurting friends")
        br.ui:createSpinner(section, "Essence Font", 80, 1, 100, 5, "Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Essence Font targets", 3, 1, 20, 5, "Number of hurt people before triggering spell")
        br.ui:createSpinner(section, "Essence Font delay(Upwelling)", 18, 1, 18, 5, "Delay in seconds fox max Upwelling bonus")
        br.ui:createSpinner(section, "Surging Mist", 70, 1, 100, 5, "Health Percent to Cast At")
        br.ui:createSpinner(section, "Vivify", 60, 1, 100, 5, "Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Vivify Spam", 3, 1, 20, 1, "Amount of Renewing Mists rolling before switching to vivify")
        br.ui:createSpinnerWithout(section, "Vivify Spam Health", 75, 1, 100, 1, "min HP to spam vivify w/RM")
        br.ui:createSpinner(section, "Enveloping Mist Tank", 50, 1, 100, 5, "Health Percent to Cast At")
        br.ui:createSpinner(section, "Enveloping Mist", 50, 1, 100, 5, "Health Percent to Cast At")
        -- br.ui:createCheckbox(section, "Soothing Mist Instant Cast", "Use Soothing Mist first for instant casts")
        br.ui:createDropdownWithout(section, "EM Casts", { "pre-soothe", "hard" }, 1, "EM Cast Mode")
        br.ui:createDropdownWithout(section, "Vivify Casts", { "pre-soothe", "hard" }, 1, "Vivify Cast Mode")

        br.ui:createSpinner(section, "Life Cocoon", 50, 1, 100, 5, "Health Percent to Cast At")
        br.ui:createSpinner(section, "Revival", 40, 1, 100, 5, "Health Percent to Cast At")
        br.ui:createSpinner(section, "Revival", 40, 1, 100, 5, "Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Revival Targets", 3, 1, 20, 5, "Number of hurt people before triggering spell")
        br.ui:createSpinner(section, "Chi Ji", 50, 1, 100, 5, "Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Chi Ji Targets", 3, 1, 20, 5, "Number of hurt people before triggering spell")
        br.ui:createSpinner(section, "Soothing Mist", 40, 1, 100, 5, "Health Percent to Cast At")
        br.ui:createCheckbox(section, "OOC Healing", "Enables/Disables out of combat healing.", 1)
        br.ui:createCheckbox(section, "Summon Jade Serpent", "Place statue yes/no")
        br.ui:checkSectionState(section)

        section = br.ui:createSection(br.ui.window.profile, "Fistweaving options")
        br.ui:createSpinnerWithout(section, "Fistweave Hots", 3, 1, 20, 5, "Num of hots before kicking")
        br.ui:createSpinnerWithout(section, "DPS Threshold", 40, 1, 100, 5, "Health limit where we focus on getting kicks in")

        br.ui:checkSectionState(section)

        section = br.ui:createSection(br.ui.window.profile, "Defensive Options")
        br.ui:createSpinner(section, "Healing Elixir /Dampen Harm / Diffuse Magic", 60, 0, 100, 5, "Health Percent to Cast At")
        br.ui:createSpinner(section, "Fortifying Brew", 45, 0, 100, 1, "Fortifying Brew", "Health Percent to Cast At")
        br.ui:createSpinner(section, "Health stone/pot", 30, 0, 100, 5, "Health Percent to Cast At")
        br.ui:checkSectionState(section)

        section = br.ui:createSection(br.ui.window.profile, "Utility Options")
        br.ui:createSpinner(section, "Mana Tea", 30, 1, 100, 1, "Mana to use tea at")
        br.ui:createCheckbox(section, "Enforce Lifecycles buff", "Ensures we only cast vivify/envelope with mana reduction buff")
        br.ui:createSpinner(section, "Use Revival as detox", 3, 1, 20, 5, "Number of hurt people before triggering spell")
        br.ui:createDropdown(section, "Tiger's Lust", { "All", "Self only", "on CD" }, 1, "Potential Tiger's lust targets")
        br.ui:createSpinner(section, "Auto Drink", 30, 0, 100, 5, "Mana to drink at")
        br.ui:createDropdown(section, "Ring of Peace", br.dropOptions.Toggle, 6, "Hold this key to cast Ring of Peace at Mouseover")
        br.ui:createSpinner(section, "Mana Potion", 50, 0, 100, 1, "Mana Percent to Cast At")
        br.ui:createSpinner(section, "Thunder Focus Tea", 50, 0, 100, 1, "Mana Percent to Cast At - 0 for on CD")
        br.ui:createDropdownWithout(section, "Thunder Focus Mode", { "Auto", "Enveloping M", "Renewing M", "Vivify", "Rising Sun Kick" }, 1, "", "")

        br.ui:checkSectionState(section)

        section = br.ui:createSection(br.ui.window.profile, "DPS")
        br.ui:createCheckbox(section, "Crackling Jade Lightning", "Enables" .. "/" .. "Disables " .. "the use of Crackling Jade Lightning.")
        br.ui:createCheckbox(section, "Rising Sun Kick", "Enables" .. "/" .. "Disables " .. " use of Rising Sun Kick on DPS rotation")
        br.ui:createCheckbox(section, "Spinning Crane Kick", "Enables" .. "/" .. "Disables " .. " use of Spinning Crane Kick on DPS rotation")
        br.ui:createCheckbox(section, "ChiBurst/ChiWave", "Enables" .. "/" .. "Disables " .. "use of ChiBurst/ChiWave as part of DPS rotation")
        br.ui:checkSectionState(section)

        section = br.ui:createSection(br.ui.window.profile, "M+")
        br.ui:createSpinner(section, "Bursting", 1, 0, 10, 4, "", "Burst Targets")
        br.ui:createCheckbox(section, "Temple of Seth heal logic", 1)
        br.ui:createCheckbox(section, "Freehold - pig", 1)
        br.ui:createCheckbox(section, "Grievous Wounds", "Grievous support")

        br.ui:checkSectionState(section)
        -- Trinkets
        section = br.ui:createSection(br.ui.window.profile, "Trinkets")
        br.ui:createSpinner(section, "Trinket 1", 70, 0, 100, 5, "Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Min Trinket 1 Targets", 3, 1, 40, 1, "", "Minimum Trinket 1 Targets(This includes you)", true)
        br.ui:createDropdownWithout(section, "Trinket 1 Mode", { "Normal", "Target", "Ground", "Pocket-Sized CP", "Mana" }, 1, "", "")
        br.ui:createSpinner(section, "Trinket 2", 70, 0, 100, 5, "Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Min Trinket 2 Targets", 3, 1, 40, 1, "", "Minimum Trinket 2 Targets(This includes you)", true)
        br.ui:createDropdownWithout(section, "Trinket 2 Mode", { "|cffFFFFFFNormal", "|cffFFFFFFTarget", "|cffFFFFFFGround", "|cffFFFFFFPocket-Sized CP", "DPS target" }, 1, "", "")
        br.ui:checkSectionState(section)

        section = br.ui:createSection(br.ui.window.profile, "Corruption")
        br.ui:createDropdownWithout(section, "Use Cloak", { "snare", "Eye", "THING", "Never" }, 4, "", "")
        br.ui:createSpinnerWithout(section, "Eye Stacks", 3, 1, 10, 1, "How many stacks before using cloak")
        br.ui:checkSectionState(section)

        -- Essences
        --"Memory of Lucid Dreams"
        section = br.ui:createSection(br.ui.window.profile, "Essences")
        br.ui:createSpinner(section, "ConcentratedFlame - Heal", 50, 0, 100, 5, "", "health to heal at")
        br.ui:createCheckbox(section, "ConcentratedFlame - DPS")
        br.ui:createSpinner(section, "Memory of Lucid Dreams", 50, 0, 100, 5, "", "mana to pop it at")
        br.ui:createDropdown(section, "Ever Rising Tide", { "Always", "Pair with CDs", "Based on health" }, 1, "When to use this essence")
        br.ui:createSpinner(section, "Ever Rising Tide - Mana", 30, 0, 100, 5, "", "min mana to use")
        br.ui:createSpinner(section, "Ever Rising Tide - Health", 30, 0, 100, 5, "", "health threshold to pop at")
        br.ui:createSpinner(section, "Well of Existence  - Health", 30, 0, 100, 5, "", "health threshold to pop at")
        br.ui:createSpinner(section, "Seed of Eonar", 80, 0, 100, 5, "Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Seed of Eonar Targets", 3, 0, 40, 1, "Minimum hurting friends")
        br.ui:checkSectionState(section)

    end
    optionTable = { {
                        [1] = "Rotation Options",
                        [2] = rotationOptions,
                    } }
    return optionTable
end

----------------
--- ROTATION ---
----------------
---
local function runRotation()

    ---------------
    --- Toggles ---
    ---------------
    --[[   --OBSOLETE
     UpdateToggle("Rotation", 0.25)
     UpdateToggle("Cooldown", 0.25)
     UpdateToggle("Defensive", 0.25)
     UpdateToggle("Interrupt", 0.25)
     UpdateToggle("Detox", 0.25)
     UpdateToggle("DPS", 0.25) ]]
    br.player.ui.mode.detox = br.data.settings[br.selectedSpec].toggles["Detox"]
    br.player.ui.mode.dps = br.data.settings[br.selectedSpec].toggles["DPS"]
    --br.player.ui.mode.prehot = br.data.settings[br.selectedSpec].toggles["prehot"]
    -------------
    --- Locals ---
    --------------
    ---
    local buff = br.player.buff
    local cast = br.player.cast
    local combatTime = getCombatTime()
    local cd = br.player.cd
    local charges = br.player.charges
    local debuff = br.player.debuff
    local drinking = getBuffRemain("player", 192002) ~= 0 or getBuffRemain("player", 167152) ~= 0 or getBuffRemain("player", 192001) ~= 0
    local enemies = br.player.enemies
    local falling, swimming, flying, moving = getFallTime(), IsSwimming(), IsFlying(), GetUnitSpeed("player") > 0
    local gcd = br.player.gcd
    local healPot = getHealthPot()
    local inCombat = br.player.inCombat
    local inInstance = br.player.instance == "party"
    local inRaid = br.player.instance == "raid"
    local level = br.player.level
    local BleedFriend = nil
    local BleedFriendCount = 0
    local BleedStack = 0
    local ttd = getTTD
    local essence = br.player.essence
    local mana = br.player.power.mana.percent()
    local mode = br.player.ui.mode
    local perk = br.player.perk
    local php = br.player.health
    local power, powmax, powgen = br.player.power.mana.amount(), br.player.power.mana.max(), br.player.power.mana.regen()
    local pullTimer = br.DBM:getPulltimer()
    local race = br.player.race
    local racial = br.player.getRacial()
    local spell = br.player.spell
    local talent = br.player.talent
    local ttd = getTTD
    local ttm = br.player.power.mana.ttm()
    local units = br.player.units
    local lowest = {}    --Lowest Unit
    lowest.hp = br.friend[1].hp
    lowest.role = br.friend[1].role
    lowest.unit = br.friend[1].unit
    lowest.range = br.friend[1].range
    lowest.guid = br.friend[1].guid
    local enemies = br.player.enemies
    local lastSpell = lastSpellCast
    local resable = UnitIsPlayer("target") and UnitIsDeadOrGhost("target") and GetUnitIsFriend("target", "player")
    local mode = br.player.ui.mode
    local pullTimer = br.DBM:getPulltimer()
    local units = br.player.units
    local tanks = getTanksTable()

    if leftCombat == nil then
        leftCombat = GetTime()
    end
    if profileStop == nil then
        profileStop = false
    end
    units.dyn5 = units.get(5)
    units.dyn8 = units.get(8)
    units.dyn15 = units.get(15)
    units.dyn30 = units.get(30)
    units.dyn40 = units.get(40)
    units.dyn5AoE = units.get(5, true)
    units.dyn30AoE = units.get(30, true)
    units.dyn40AoE = units.get(40, true)
    enemies.yards5 = enemies.get(5)
    enemies.get(5, "player", false, true)
    enemies.yards8 = enemies.get(8)
    enemies.yards10 = enemies.get(10)
    enemies.yards15 = enemies.get(15)
    enemies.yards20 = enemies.get(20)
    enemies.yards30 = enemies.get(30)
    enemies.yards40 = enemies.get(40)

    local enemy_count_facing_5 = enemies.get(5, "player", false, true)

    focustea = nil

    --functions
    local function renewingMistFunc()
        --tanks first
        if getValue("Renewing Mist") == 0 then
            if #tanks > 0 then
                for i = 1, #tanks do
                    if not buff.renewingMist.exists(tanks[i].unit) and UnitInRange(tanks[i].unit) then
                        if cast.renewingMist(tanks[i].unit) then
                            br.addonDebug("[RenewMist]:" .. UnitName(tanks[i].unit) .. " - RM on Tank")
                            return true
                        end
                    end
                end
            end
            for i = 1, #br.friend do
                if not buff.renewingMist.exists(br.friend[i].unit) and UnitInRange(br.friend[i].unit) then
                    if cast.renewingMist(br.friend[i].unit) then
                        br.addonDebug("[RenewMist]:" .. UnitName(br.friend[i].unit) .. " - Auto")
                        return true
                    end
                end
            end
        end
    end

    local function hotcountFunc()

        local hotcounter = 0
        for i = 1, #br.friend do
            local hotUnit = br.friend[i].unit

            if buff.envelopingMist.exists(hotUnit) then
                hotcounter = hotcounter + 1
            end
            if buff.essenceFont.exists(hotUnit) then
                hotcounter = hotcounter + 1
            end
            if buff.renewingMist.exists(hotUnit) then
                hotcounter = hotcounter + 1
            end
        end
        return hotcounter
    end

    local function risingSunKickFunc()
        if cast.able.risingSunKick() and isChecked("Rising Sun Kick") then
            if #enemy_count_facing_5 > 0 then
                if (talent.risingMist and hotcountFunc() >= getValue("Fistweave Hots")
                        or focustea == "kick" and buff.thunderFocusTea.exists()
                        or buff.wayOfTheCrane.exists()
                        or #br.friend == 1) then
                    --solo play
                    if cast.risingSunKick(units.dyn5) then
                        br.addonDebug("Rising Sun Kick on : " .. UnitName(units.dyn5) .. " BAMF!")
                        return true
                    end
                end
            end
        end
        if not cast.able.risingSunKick() and getHP(br.friend[1]) > getValue("DPS Threshold") and #enemy_count_facing_5 > 0 then
            if cast.able.blackoutKick() and not buff.thunderFocusTea.exists()
                    and (buff.teachingsOfTheMonastery.stack() == 1 and cd.risingSunKick.remain() < 12) or buff.teachingsOfTheMonastery.stack() == 3 then
                if cast.blackoutKick(units.dyn5) then
                    return true
                end
            end
            if cast.able.tigerPalm() and buff.teachingsOfTheMonastery.stack() < 3 or buff.teachingsOfTheMonastery.remain() < 2 then
                if cast.tigerPalm(units.dyn5) then
                    return true
                end
            end
        end
    end

    local function thunderFocusTea()

        if not cast.able.thunderFocusTea() then
            --not cd.thunderFocusTea.ready() or
            Print("I should not be here!")
        end


        -- Print(hotcountFunc())
        -- auto mode
        if isChecked("Thunder Focus Tea") and cast.able.thunderFocusTea() and not buff.thunderFocusTea.exists() then
            if cast.able.envelopingMist() and getOptionValue("Thunder Focus Mode") == 1 and burst == false and getLowAllies(70) < 3 and lowest.hp < 50 or getOptionValue("Thunder Focus Mode") == 2 then
                focustea = "singleHeal"
            end
            if cast.able.renewingMist()
                    and (getOptionValue("Thunder Focus Mode") == 1 and (burst == true or getLowAllies(70) > 3 and not talent.risingMist)
                    or getOptionValue("Thunder Focus Mode") == 3) then
                focustea = "AOEHeal"
            end
            if getOptionValue("Thunder Focus Mode") == 1 and mana <= getValue("Thunder Focus Tea") or getOptionValue("Thunder Focus Mode") == 4 and cast.able.vivify() then
                focustea = "manaEffiency"
            end
            if cast.able.risingSunKick() and #enemy_count_facing_5 > 0 and
                    (hotcountFunc() >= getValue("Fistweave Hots")
                            and ((getOptionValue("Thunder Focus Mode") == 1 and talent.risingMist)
                            or getOptionValue("Thunder Focus Mode") == 5))
                    or #br.friend == 1 then
                focustea = "kick"
            end
        end

        if focustea ~= nil and not buff.thunderFocusTea.exists() and cast.able.thunderFocusTea() then
            if (focustea == "singleHeal" and cast.able.envelopingMist() and getHP(healUnit) <= getValue("Enveloping Mist"))
                    or (focustea == "AOEHeal" and cast.able.renewingMist() and getHP(br.friend[1]) <= getValue("Renewing Mist"))
                    or (focustea == "manaEffiency" and cast.able.vivify() and getHP(br.friend[1]) < getValue("Vivify"))
                    or (focustea == "kick" and cast.able.risingSunKick() and #enemy_count_facing_5 > 0)
            then
                if cast.thunderFocusTea() then
                    br.addonDebug("[Thundertea]: " .. focustea)
                end
            end
        elseif focustea == nil then
            --     Print("ERROR ERROR")
        end


        --  Print("Focustea1: " .. focustea)
        if focustea ~= nil and buff.thunderFocusTea.exists() then
            if focustea == "singleHeal" then
                if cast.envelopingMist(lowest.unit) then
                    return true
                end
            end
            if focustea == "AOEHeal" or (focustea == "kick" and #enemy_count_facing_5 == 0) then
                if renewingMistFunc() then
                    return true
                end
            end
            if focustea == "manaEffiency" then
                if cast.vivify(lowest.unit) and not cast.last.vivify(1) and buff.thunderFocusTea.exists() then
                    --      Print("[Vivify]: ......")
                    return true
                end
            end
            if focustea == "kick" and #enemy_count_facing_5 > 0 and isChecked("Rising Sun Kick") then
                if risingSunKickFunc() then
                    return true
                end
            end
            --fallback ..do SOMETHING
            Print("!!FALLBACK!! - Report this  -" .. focustea)
            if renewingMistFunc() then
                return true
            end
            if cast.envelopingMist(lowest.unit) then
                return true
            end
        end
        --Print("really?")
        --return false
    end

    local function jadestatue()
        --Jade Statue
        local statue_buff_check = 0
        local px, py, pz
        --  Print("{x=" .. last_statue_location.x .. ",y=" .. last_statue_location.y .. ",z=" .. last_statue_location.z .. "}")
        if cast.able.summonJadeSerpentStatue() and (GetTotemTimeLeft(1) < 100 or GetTotemTimeLeft(1) == 0 or getDistanceToObject("player", last_statue_location.x, last_statue_location.y, last_statue_location.z) > 30) then
            for i = 1, #br.friend do
                if hasBuff(198533, br.friend[i].unit) then
                    statue_buff_check = 1
                end
            end
            if statue_buff_check == 0 then
                if #tanks > 0 then
                    px, py, pz = GetObjectPosition(tanks[1].unit)
                else
                    px, py, pz = GetObjectPosition("player")
                end

                px = px + math.random(-2, 2)
                py = py + math.random(-2, 2)
                if castGroundAtLocation({ x = px, y = py, z = pz }, spell.summonJadeSerpentStatue) then
                    SpellStopTargeting()
                    last_statue_location = { x = px, y = py, z = pz }
                    return true
                end
            end
        end
    end

    local function tigers_lust()
        -- Tiger's Lust
        --[[ 1 = any, 2 = self, 3 == CD]]
        if br.player.talent.tigersLust and br.player.cast.able.tigersLust() and isChecked("Tiger's Lust") then
            if getValue("Tiger's Lust") == 1 then
                for i = 1, #br.friend do
                    thisUnit = br.friend[i].unit
                    if hasNoControl(spell.tigersLust, thisUnit) then
                        if br.player.cast.tigersLust(thisUnit) then
                            return true
                        end

                    end
                end
            elseif getValue("Tiger's Lust") == 2 then
                if hasNoControl(spell.tigersLust, "player") then
                    if br.player.cast.tigersLust("Player") then
                        return true
                    end
                end
            elseif getValue("Tiger's Lust") == 3 and GetUnitSpeed("player") > 1 then
                if br.player.cast.tigersLust("Player") then
                    return true
                end
            end
        end
    end

    local HOJ_unitList = {
        [131009] = "Spirit of Gold",
        [134388] = "A Knot of Snakes",
        [129758] = "Irontide Grenadier",
        [313301] = "Thing From Beyond",
        [161895] = "More things from Beyond",


    }

    local HOJ_list = {
        [274400] = true, [274383] = true, [257756] = true, [276292] = true, [268273] = true, [256897] = true, [272542] = true, [272888] = true, [269266] = true, [258317] = true, [258864] = true,
        [259711] = true, [258917] = true, [264038] = true, [253239] = true, [269931] = true, [270084] = true, [270482] = true, [270506] = true, [270507] = true, [267433] = true, [267354] = true,
        [268702] = true, [268846] = true, [268865] = true, [258908] = true, [264574] = true, [272659] = true, [272655] = true, [267237] = true, [265568] = true, [277567] = true, [265540] = true
    }

    local function isCC(unit)
        if getOptionCheck("Don't break CCs") then
            return isLongTimeCCed(Unit)
        end
        return false
    end

    local function noDamageCheck(unit)
        if isChecked("Dont DPS spotter") and GetObjectID(unit) == 135263 then
            return true
        end
        if isCC(unit) then
            return true
        end
        if isCasting(302415, unit) then
            -- emmisary teleporting home
            return true
        end

        if hasBuff(263246, unit) then
            -- shields on first boss in temple
            return true
        end
        if hasBuff(260189, unit) then
            -- shields on last boss in MOTHERLODE
            return true
        end
        if hasBuff(261264, unit) or hasBuff(261265, unit) or hasBuff(261266, unit) then
            -- shields on witches in wm
            return true
        end
        return false --catchall
    end

    local function dps()

        -- Print("Number of enemies: "  .. tostring(#br.enemies))

        if SpecificToggle("DPS Key") and not GetCurrentKeyBoardFocus() and essence.conflict.active then
            if isChecked("WotC as part of DPS") then
                if talent.manaTea and cast.able.manaTea() and getSpellCD(216113) == 0 then
                    if cast.manaTea() then
                        return true
                    end
                end
                if getSpellCD(216113) == 0 then
                    CastSpellByID(216113, "player")
                    return true
                end
            end
        end

        if (br.player.ui.mode.dps < 4 or buff.wayOfTheCrane.exists()) and not buff.thunderFocusTea.exists() then


            local dps_mode
            if br.player.ui.mode.dps == 1 then
                dps_mode = "auto"
            elseif br.player.ui.mode.dps == 2 then
                dps_mode = "single"
            elseif br.player.ui.mode.dps == 3 then
                dps_mode = "multi"
            end

            if getDistance(units.dyn5) < 5 and #enemies.yards5 > 0 then
                StartAttack(units.dyn5)
            end





            --Print("dps_mode: " .. dps_mode)
            --[[
                        if inCombat and (isInMelee() and getFacing("player", "target") == true) then
                            StartAttack()
                        end
            ]]
            --lets check for mysticTouch debuff
            local mysticTouchCounter = 0
            if #enemies.yards8 > 0 and level >= 49 then
                for i = 1, #enemies.yards8 do
                    thisUnit = enemies.yards8[i]
                    if not noDamageCheck(thisUnit) and (not debuff.mysticTouch.exists(thisUnit) or debuff.mysticTouch.remain(thisUnit) < 1) then
                        mysticTouchCounter = mysticTouchCounter + 1
                        --Print("Counter:" .. tostring(mysticTouchCounter))
                    end
                end

                if br.player.ui.mode.dps ~= 2 and isChecked("Spinning Crane Kick") and not isCastingSpell(spell.spinningCraneKick) and
                        ((mysticTouchCounter > 0 and #enemies.yards8 > 1)
                                or #enemies.yards8 >= 4
                                or #enemy_count_facing_5 == 0) then
                    if cast.spinningCraneKick() then
                        return true
                    end
                end
            end

            if #enemy_count_facing_5 > 0 and not noDamageCheck(units.dyn5) then
                --- single target DPS
                if isChecked("Rising Sun Kick") and cast.able.risingSunKick() then
                    if risingSunKickFunc() then
                        return true
                    end
                end
                --[[
                                if cast.able.touchOfDeath() then
                                    if cast.touchOfDeath() then
                                        return true
                                    end
                                end
                ]]


                if cast.able.touchOfDeath("target") and getHP("target") < getHP("player") then
                    if cast.touchOfDeath("target") then
                        --      ui.debug("Casting Touch of Death - DIE! [Pull]")
                        return true
                    end
                end

                if (buff.teachingsOfTheMonastery.stack() == 1 and cd.risingSunKick.remain() < 12)
                        or buff.teachingsOfTheMonastery.stack() == 3
                        or level < 19 then
                    if cast.blackoutKick(units.dyn5) then
                        return
                    end
                end

                if isChecked("ChiBurst/ChiWave") then
                    if talent.chiBurst then
                        if cast.chiBurst("player") then
                            return
                        end
                    elseif talent.chiWave then
                        if cast.chiWave("player") then
                            return
                        end
                    end
                end
                if buff.teachingsOfTheMonastery.stack() < 3 or buff.teachingsOfTheMonastery.remain() < 2 then
                    if cast.tigerPalm(units.dyn5) then
                        return true
                    end
                end

            end

            if #enemies.yards10 == 0 and not isCastingSpell(spell.cracklingJadeLightning) and isChecked("Crackling Jade Lightning") and not isMoving("player") then
                if cast.cracklingJadeLightning() then
                    return true
                end
            end
        end
    end

    local function high_prio()
        --emissary stuff removed
    end

    local function heal()

        local healUnit = nil
        local specialHeal = false
        local burst = false
        local crit_count = 0
        local why = "dunno"
        local CurrentBleedstack = 0


        -- SL patch healing starts here
        healUnit = lowest.unit


        --       Print("LH: " .. lowest.hp .. tostring(cast.able.vivify()) .. "  setting:  " .. getOptionValue("Vivify"))

        -- Renewing Mists
        if isChecked("Renewing Mist")
                and cast.able.renewingMist()
                and not cast.last.thunderFocusTea(1)
                and not buff.thunderFocusTea.exists()
                and (talent.risingMist and (cd.risingSunKick.remain() < 1.5 or cd.risingSunKick.remain() > 5) or not talent.risingMist) then
            if renewingMistFunc() then
                return true
            end
        end
        -- Enveloping Mist
        if cast.able.envelopingMist() and not cast.last.envelopingMist(1) and not isMoving("player") then
            if #tanks > 0 then
                for i = 1, #tanks do
                    if getHP(tanks[i].unit) <= getValue("Enveloping Mist Tank") and not buff.envelopingMist.exists(tanks[i].unit) and cast.able.envelopingMist(tanks[i].unit) then
                        if getOptionValue("EM Casts") == 1 and not buff.soothingMist.exists(tanks[i].unit, "exact") then
                            if cast.soothingMist(tanks[i].unit) then
                                br.addonDebug("[EM-PRE]:" .. UnitName(tanks[i].unit) .. " / " .. "PRE-SOOTHE - TANK")
                                return true
                            end
                        end
                        if buff.soothingMist.exists(tanks[i].unit, "EXACT") or getOptionValue("EM Casts") == 2 then
                            if cast.envelopingMist(tanks[i].unit) then
                                br.addonDebug("[EM]:" .. UnitName(tanks[i].unit) .. " - EM on Tank")
                                return true
                            end
                        end
                    end
                end
            end
            if lowest.hp < getOptionValue("Enveloping Mist") and not buff.envelopingMist.exists(lowest.unit) then
                if cast.envelopingMist(lowest.unit) then
                    return true
                end
            end
        end


        --  Print(getHP(healUnit))
        -- Vivify
        if not isMoving("player") and (getHP(healUnit) <= getValue("Vivify") or specialHeal) then
            if talent.lifecycle and isChecked("Enforce Lifecycles buff") and buff.lifeCyclesVivify.exists() or not talent.lifecycle or not isChecked("Enforce Lifecycles buff") then
                if getOptionValue("Vivify Casts") == 1 and not buff.soothingMist.exists(healUnit, "exact") then
                    --  if isChecked("Soothing Mist Instant Cast") and not buff.soothingMist.exists(healUnit, "EXACT") then
                    if cast.soothingMist(healUnit) then
                        --      br.addonDebug("[pre-soothe]:" .. UnitName(healUnit) .. " - VIVIFY")
                        return true
                    end
                end
                if buff.soothingMist.exists(healUnit, "EXACT") or getOptionValue("Vivify Casts") == 2 then
                    if cast.vivify(healUnit) then
                        --    br.addonDebug("[Vivify]: " .. UnitName(healUnit))
                        return
                    end
                end
            end
        end --end vivify



        if cast.able.vivify() and isChecked("Vivify") and lowest.hp < getOptionValue("Vivify") then
            if cast.vivify(lowest.unit) then
                return true
            end
        end

        if 1 == 2 then
            --Bursting
            --Print("Check" ..isChecked("Bursting").."#: "..getOptionValue("Bursting"))
            if isChecked("Bursting") and inInstance and #tanks > 0 then
                local ourtank = tanks[1].unit
                local Burststack = getDebuffStacks(ourtank, 240443)
                if Burststack >= getOptionValue("Bursting") then
                    burst = true
                    why = "burst"
                else
                    burst = false
                end
            end



            -- Determining heal target / healUnit

            if isChecked("Grievous Wounds") then
                for i = 1, #br.friend do
                    local GrievUnit = br.friend[i].unit
                    CurrentBleedstack = getDebuffStacks(GrievUnit, 240559)
                    if getDebuffStacks(GrievUnit, 240559) > 0 then
                        -- Print(GrievUnit.unit)
                        BleedFriendCount = BleedFriendCount + 1
                    end
                    if CurrentBleedstack > BleedStack then
                        BleedStack = CurrentBleedstack
                        BleedFriend = GrievUnit
                    end
                end
                if BleedFriend ~= nil then
                    healUnit = BleedFriend
                    specialHeal = true
                    why = "[GRIEVOUS]"
                    --     Print("GrievTarget: " .. thisUnit.name)
                else
                    -- No Units with Griev below 90% Health
                    BleedStack = 99
                end

            end -- end grievous


            --instance logic
            if inInstance and inCombat then
                if isChecked("Temple of Seth heal logic") and br.player.eID and br.player.eID == 2127 then
                    for i = 1, GetObjectCountBR() do
                        local sethObject = GetObjectWithIndex(i)
                        if GetObjectID(sethObject) == 133392 then
                            if getHP(sethObject) < 100 and getBuffRemain(sethObject, 274148) == 0 then
                                healUnit = sethObject
                            end
                        end
                    end
                    if healUnit ~= nil and getHP(thisUnit) < 100 then
                        specialHeal = true
                        why = "Seth-Logic"
                    end
                    -- Jagged Nettles and Dessication logic / triad in WM and mummy dude in KR
                elseif (select(8, GetInstanceInfo()) == 1862 or select(8, GetInstanceInfo()) == 1762) then
                    for i = 1, #br.friend do
                        if getDebuffRemain(br.friend[i].unit, 260741) ~= 0 or getDebuffRemain(br.friend[i].unit, 267626) ~= 0 then
                            healUnit = br.friend[i].unit
                        end
                        if healUnit ~= nil and getHP(healUnit) < 90 then
                            specialHeal = true
                            why = "Jagged/Dessication"
                        end
                    end
                    -- Sacrifical Pits / Atal
                    -- Devour
                elseif select(8, GetInstanceInfo()) == 1763 then
                    for i = 1, #br.friend do
                        if (getDebuffRemain(br.friend[i].unit, 255421) or getDebuffRemain(br.friend[i].unit, 255434)) ~= 0 then
                            healUnit = br.friend[i].unit
                        end
                        if healUnit ~= nil and getHP(healUnit) < 90 then
                            specialHeal = true
                            why = "Devour"
                        end
                    end
                end
            end --end instance logic


            -- critical

            if burst == false and getValue("Critical HP") ~= 0 then
                local crit_health_base = 100
                local crit_health_current = 0
                for i = 1, #br.friend do
                    if UnitInRange(br.friend[i].unit) and br.friend[i].hp <= getValue("Critical HP") then
                        crit_count = crit_count + 1
                        if br.friend[i].hp < crit_health_base then
                            crit_health_base = br.friend[i].hp
                            healUnit = br.friend[i].unit
                            why = "[CRITICAL]"
                        end
                    end
                    if crit_count >= getOptionValue("Bursting") then
                        burst = true
                        why = "[GROUP CRITICAL]"
                    end

                end
            end



            --single heal on mouseover target override - old "HAM" mode
            if SpecificToggle("Heal Key") and GetUnitExists("mouseover") then
                healUnit = GetUnit("mouseover")
                specialHeal = true
                why = "Heal Key"
            end

            --default healUnit rollback to whoever needs it
            -- for i = 1, #br.friend do

            if healUnit == nil then
                healUnit = br.friend[1].unit
                why = "[STD]"
            end
            --br.addonDebug("Heal Target: " .. healUnit .. " at: " .. getHP(healUnit))

            --[[
                        --always kick with rising  -- fist weaving
                        if talent.risingMist then
                            if lowest.hp > getValue("Critical HP") then
                                if (buff.teachingsOfTheMonastery.stack() == 1 and cd.risingSunKick.remain() < 12) or buff.teachingsOfTheMonastery.stack() == 3 then
                                    if cast.blackoutKick(units.dyn5) then
                                        return true
                                    end
                                end
                            end
                            if cast.risingSunKick(units.dyn5) then
                                return true
                            end
                        end
            ]]
            --Life Cocoon
            if isChecked("Life Cocoon") and cast.able.lifeCocoon() and inCombat then
                if (isChecked("Bursting") and burst and getDebuffStacks("player", 240443) >= getOptionValue("Bursting"))
                        or (isChecked("Grievous Wounds") and getDebuffStacks("player", 240559) > 3)
                then
                    if cast.lifeCocoon("player") then
                        br.addonDebug(tostring(burst) .. "[LifCoc]:" .. "SELF" .. " / " .. why)
                        return true
                    end
                end
                if isChecked("Grievous Wounds") and (getDebuffStacks(healUnit, 240559) > 3 or BleedStack == 99) or not isChecked("Grievous Wounds") then
                    --override cause people leave settings on in non griev weeks
                    if (getHP(healUnit) <= getValue("Life Cocoon") or specialHeal) and not buff.lifeCocoon.exists(healUnit) then
                        if cast.lifeCocoon(healUnit) then
                            br.addonDebug(tostring(burst) .. "[LifCoc]:" .. UnitName(healUnit) .. " / " .. why .. " HP: " .. tostring(getHP(healUnit)))
                            --  Print("Bleedstack: " .. tostring(BleedStack))
                            return true
                        end
                    end
                end
            end


            -- maintain one soothing mist always, if using statue
            local soothing_counter = 0
            if inCombat and talent.summonJadeSerpentStatue and getDistanceToObject("player", last_statue_location.x, last_statue_location.y, last_statue_location.z) < 30 then

                for i = 1, #br.friend do
                    if select(7, UnitBuffID(br.friend[i].unit, 198533, "exact")) == "player" then
                        soothing_counter = soothing_counter + 1
                    end
                    --[[if buff.soothingMistJadeStatue.exists(br.friend[i].unit,"exact") then
                        soothing_counter = soothing_counter + 1
                    end]]
                    --   Print(tostring(soothing_counter))
                end
                if soothing_counter == 0 then
                    if cast.soothingMist(healUnit) then
                        br.addonDebug("[Statue Soothing] HealUnit: " .. healUnit)
                        return true
                    end
                end
            end

            if not isMoving("player") and cast.able.envelopingMist() and getHP(healUnit) <= getValue("Enveloping Mist") or specialHeal then
                if talent.lifecycle and isChecked("Enforce Lifecycles buff") and buff.lifeCyclesEnvelopingMist.exists() or not talent.lifecycle or not isChecked("Enforce Lifecycles buff") then
                    if getOptionValue("EM Casts") == 1 and not buff.soothingMist.exists(healUnit, "exact") then
                        -- if isChecked("Soothing Mist Instant Cast") and not isMoving("player") then
                        if not buff.soothingMist.exists(healUnit, "exact") then
                            if cast.soothingMist(healUnit) then
                                br.addonDebug("[pre-soothe]:" .. UnitName(healUnit) .. " EM: " .. tostring(buff.soothingMist.exists(healUnit, "EXACT")))
                                return true
                            end
                        elseif buff.envelopingMist.remains(healUnit) < 2 and (buff.soothingMist.exists(healUnit, "EXACT")) then
                            if cast.envelopingMist(healUnit) then
                                br.addonDebug("[EM1]:" .. UnitName(healUnit) .. " SM: " .. tostring(buff.soothingMist.exists(healUnit, "EXACT")))
                            end
                        end
                    elseif (getOptionValue("EM Casts") == 2 or buff.soothingMist.exists(healUnit, "exact")) and buff.envelopingMist.remains(healUnit) < 2 then
                        if cast.envelopingMist(healUnit) then
                            br.addonDebug("[EM2]:" .. UnitName(healUnit) .. " SM: " .. tostring(buff.soothingMist.exists(healUnit, "EXACT")))
                            return
                        end
                    end
                end
            end


            --Revival
            if isChecked("Revival") and cast.able.revival() then
                if isChecked("Use Revival as detox") and br.player.ui.mode.detox == 1 and not cast.last.detox() and cd.detox.exists() then
                    local detoxCounter = 0
                    for i = 1, #br.friend do
                        if canDispel(br.friend[i].unit, spell.detox) and getLineOfSight(br.friend[i].unit) and getDistance(br.friend[i].unit) <= 40 then
                            detoxCounter = detoxCounter + 1
                        end
                    end
                    if detoxCounter >= getValue("Use Revival as detox") then


                        why = "MASS DISPEL"
                        if cast.revival() then
                            br.addonDebug("[Revival]:" .. why)
                            return true
                        end
                    end
                end
                if getLowAllies(getValue("Revival")) >= getValue("Revival Targets") or burst then
                    if cast.revival() then
                        br.addonDebug(tostring(burst) .. "[Revival]:" .. UnitName(healUnit) .. " / " .. why)
                        return
                    end
                end
            end


            --vivify on targets with essence font hot
            if isChecked("Vivify") and cast.able.vivify() and buff.essenceFont.exists(healUnit) and getHP(healUnit) < 80 then
                if getOptionValue("Vivify Casts") == 1 and not buff.soothingMist.exists(healUnit, "exact") then
                    --   if isChecked("Soothing Mist Instant Cast") and not buff.soothingMist.exists(healUnit, "EXACT") then
                    if cast.soothingMist(healUnit) then
                        br.addonDebug(tostring(burst) .. "[SooMist]:" .. UnitName(healUnit) .. " / " .. "FONT-BUFF")
                        return true
                    end
                elseif buff.soothingMist.exists(healUnit, "EXACT") or getOptionValue("Vivify Casts") == 2 then
                    if cast.vivify(healUnit) then
                        br.addonDebug(tostring(burst) .. "[Vivify]:" .. UnitName(healUnit) .. " / " .. "FONT-BUFF")
                        return true
                    end
                end
            end


            --vivify if hotcount >= 5
            if isChecked("Vivify") and cast.able.vivify() and getHP(healUnit) < getValue("Vivify Spam Health") and buff.renewingMist.exists(healUnit) or specialHeal then
                RM_counter = 0
                -- local SM_counter = 0
                for i = 1, #br.friend do
                    if buff.renewingMist.exists(br.friend[i].unit) then
                        RM_counter = RM_counter + 1
                    end
                    --[[
                    if buff.soothingMist.exists(br.friend[i].unit) then
                        SM_counter = SM_counter + 1
                    end
                ]]
                end
                if RM_counter >= getValue("Vivify Spam") then
                    -- do we have a soothing mist rolling
                    if getOptionValue("Vivify Casts") == 1 and not buff.soothingMist.exists("player", "exact") then
                        --  if isChecked("Soothing Mist Instant Cast") and not buff.soothingMist.exists("player", "EXACT") then
                        if cast.soothingMist("player") then
                            br.addonDebug("[SooMist]:" .. UnitName("player") .. " / " .. "VIVIFY-SPAM - presoothe (" .. tostring(RM_counter) .. ")")
                            return true
                        end
                    end
                    if getOptionValue("Vivify Casts") == 2 or buff.soothingMist.exists("player", "exact") then
                        if cast.vivify("player") then
                            br.addonDebug(tostring(burst) .. "[Vivify]:" .. UnitName("player") .. " / " .. "VIVIFY-SPAM")
                            return true
                        end
                    end
                end
            end



            --Essence Font
            if isChecked("Essence Font") then
                if talent.upwelling and br.timer:useTimer("EssenceFont Seconds", getValue("Essence Font delay(Upwelling)")) or not talent.upwelling then
                    if getLowAllies(getValue("Essence Font")) >= getValue("Essence Font targets") or burst then
                        if cast.essenceFont() then
                            br.addonDebug(tostring(burst) .. "[E-Font]:" .. UnitName(healUnit) .. " / " .. why)
                            return true
                        end
                    end
                end
            end

            --Surging Mist
            if isChecked("Surging Mist") then
                if getHP(healUnit) <= getValue("Surging Mist") or specialHeal then
                    if cast.surgingMist(healUnit) then
                        br.addonDebug(tostring(burst) .. "[SurgMist]:" .. UnitName(healUnit) .. " / " .. why .. math.floor(tostring(getHP(healUnit))) .. "/ " .. getValue("Surging Mist"))
                        return true
                    end
                end
            end


            --all the channeling crap



            if isChecked("Soothing Mist") and not isMoving("player") then
                if getHP(healUnit) <= getValue("Soothing Mist") or specialHeal then
                    if getBuffRemain(healUnit, spell.soothingMist, "EXACT") == 0 then
                        --  and not buff.soothingMist.exists(healUnit, "exact") then
                        if cast.soothingMist(healUnit) then
                            br.addonDebug("[Sooth] Fallback: " .. UnitName(healUnit))
                            return true
                        end
                    end
                end
            end
            --  end
        end --end of heal()
    end

    local function cooldowns()
        if (SpecificToggle("Ring of Peace") and not GetCurrentKeyBoardFocus()) and isChecked("Ring of Peace") then
            if cast.able.ringOfPeace() then
                if CastSpellByName(GetSpellInfo(spell.ringOfPeace), "cursor") then
                    return true
                end
            end
        end

        -- item support
        --Wraps of wrapsOfElectrostaticPotential
        if br.player.equiped.wrapsOfElectrostaticPotential and canUseItem(br.player.items.wrapsOfElectrostaticPotential) and ttd("target") >= 10 then
            if br.player.use.wrapsOfElectrostaticPotential() then
                br.addonDebug("Using HBracers")
            end
        end
        --staff of neural
        if br.player.equiped.neuralSynapseEnhancer and canUseItem(br.player.items.neuralSynapseEnhancer) and ttd("target") >= 15
                and getDebuffStacks("player", 267034) < 2 -- not if we got stacks on last boss of shrine
        then
            if br.player.use.neuralSynapseEnhancer() then
                br.addonDebug("Using neuralSynapseEnhancer ")
            end
        end
        -- Corruption stuff
        -- 1 = snare  2 = eye  3 = thing 4 = never   -- snare = 315176
        if br.player.equiped.shroudOfResolve and canUseItem(br.player.items.shroudOfResolve) then
            if getValue("Use Cloak") == 1 and debuff.graspingTendrils.exists("player")
                    or getValue("Use Cloak") == 2 and debuff.eyeOfCorruption.stack("player") >= getValue("Eye Stacks")
                    or getValue("Use Cloak") == 3 and debuff.grandDelusions.exists("player") then
                if br.player.use.shroudOfResolve() then
                    br.addonDebug("Using shroudOfResolve")
                end
            end
        end


        --jade statue
        if isChecked("Summon Jade Serpent") and talent.summonJadeSerpentStatue and not isMoving("player") then
            if jadestatue() then
                return true
            end
        end





        --Chi Ji
        if talent.invokeChiJiTheRedCrane and isChecked("Chi Ji") then
            if getLowAllies(getValue("Chi Ji")) >= getValue("Chi Ji Targets") or burst == true then
                if cast.invokeChiJi() then
                    br.addonDebug(tostring(burst) .. "[ChiJi]")
                    return true
                end
            end
        end
        --Refreshing Jade Wind
        if talent.refreshingJadeWind and isChecked("Refreshing Jade Wind") and cast.able.refreshingJadeWind() and not buff.refreshingJadeWind.exists() then
            local refreshJadeFriends = getAllies("player", 10)
            if #refreshJadeFriends > 0 then
                for i = 1, #refreshJadeFriends do
                    jadeUnits = refreshJadeFriends[i].unit
                    if getHP(jadeUnits) < getValue("Refreshing Jade Wind") then
                        jadeUnitsCount = jadeUnitsCount + 1
                        if jadeUnitsCount >= getValue("RJW Targets") or burst then
                            if cast.refreshingJadeWind() then
                                br.addonDebug("[RefJade] - [" .. tostring(jadeUnitsCount) .. "/" .. tostring(getValue("RJW Targets")) .. "]")
                                jadeUnitsCount = 0
                                return true
                            end
                        end
                    end
                end
            end
        end


        -- Trinkets
        if isChecked("Trinket 1") and canUseItem(13) then
            if getOptionValue("Trinket 1 Mode") == 1 then
                if getLowAllies(getValue("Trinket 1")) >= getValue("Min Trinket 1 Targets") then
                    useItem(13)
                    return true
                end
            elseif getOptionValue("Trinket 1 Mode") == 2 then
                for i = 1, #br.friend do
                    if br.friend[i].hp <= getValue("Trinket 1") then
                        UseItemByName(select(1, GetInventoryItemID("player", 13)), br.friend[i].unit)
                        return true
                    end
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
                        if #meleeFriends >= 8 then
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
                            local px, py, pz = ObjectPosition("player")
                            loc.z = select(3, TraceLine(loc.x, loc.y, loc.z + 5, loc.x, loc.y, loc.z - 5, 0x110)) -- Raytrace correct z, Terrain and WMO hit
                            if loc.z ~= nil and TraceLine(px, py, pz + 2, loc.x, loc.y, loc.z + 1, 0x100010) == nil and TraceLine(loc.x, loc.y, loc.z + 4, loc.x, loc.y, loc.z, 0x1) == nil then
                                -- Check z and LoS, ignore terrain and m2 collisions
                                useItem(13)
                                ClickPosition(loc.x, loc.y, loc.z)
                                return true
                            end
                        end
                    end
                end

            end
        end
        if isChecked("Trinket 2") and canUseItem(14) then
            if getOptionValue("Trinket 2 Mode") == 1 then
                if getLowAllies(getValue("Trinket 2")) >= getValue("Min Trinket 2 Targets") then
                    useItem(14)
                    return true
                end
            elseif getOptionValue("Trinket 2 Mode") == 2 then
                for i = 1, #br.friend do
                    if br.friend[i].hp <= getValue("Trinket 2") then
                        UseItemByName(select(1, GetInventoryItemID("player", 14)), br.friend[i].unit)
                        return true
                    end
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
                        if #meleeFriends >= 8 then
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
                            local px, py, pz = ObjectPosition("player")
                            loc.z = select(3, TraceLine(loc.x, loc.y, loc.z + 5, loc.x, loc.y, loc.z - 5, 0x110)) -- Raytrace correct z, Terrain and WMO hit
                            if loc.z ~= nil and TraceLine(px, py, pz + 2, loc.x, loc.y, loc.z + 1, 0x100010) == nil and TraceLine(loc.x, loc.y, loc.z + 4, loc.x, loc.y, loc.z, 0x1) == nil then
                                -- Check z and LoS, ignore terrain and m2 collisions
                                useItem(13)
                                ClickPosition(loc.x, loc.y, loc.z)
                                return true
                            end
                        end
                    end
                end
            elseif getOptionValue("Trinket 2 Mode") == 5 then
                -- Generic fallback
                if Trinket13 ~= 168905 and Trinket13 ~= 167555 then
                    if canUseItem(13) then
                        useItem(13)
                    end
                end
                if Trinket14 ~= 168905 and Trinket14 ~= 167555 then
                    if canUseItem(14) then
                        useItem(14)
                    end
                end
            end
        end

        --pocket size computing device
        if isChecked("Trinket 1") and canUseItem(13) and getOptionValue("Trinket 1 Mode") == 4
                or isChecked("Trinket 2") and canUseItem(14) and getOptionValue("Trinket 2 Mode") == 4 then
            local Trinket13 = GetInventoryItemID("player", 13)
            local Trinket14 = GetInventoryItemID("player", 14)
            if (Trinket13 == 167555 or Trinket14 == 167555) and lowest.hp >= 60 and ttd("target") > 10
                    and not isMoving("player") and not noDamageCheck("target") and not buff.innervate.exists("player") and burst == false then
                if canUseItem(167555) then
                    br.player.use.pocketSizedComputationDevice()
                end
            end
        end


        -- Mana Potion
        if isChecked("Mana Potion") and mana <= getValue("Mana Potion") then
            if hasItem(152495) and canUseItem(152495) then
                useItem(152495)
                if hasItem(127835) and canUseItem(127835) then
                    useItem(127835)
                end
            end

            if isChecked("Auto use Pots") and burst == true then
                if hasItem(169300) and canUseItem(169300) then
                    useItem(169300)
                end
            end
        end

        -- essences/        --Essence Support
        if isChecked("ConcentratedFlame - Heal") and lowest.hp <= getValue("ConcentratedFlame - Heal") then
            if cast.concentratedFlame(lowest.unit) then
                return true
            end
        end
        if isChecked("ConcentratedFlame - DPS") and ttd("target") > 5 and not debuff.concentratedFlame.exists("target") then
            if cast.concentratedFlame("target") then
                return true
            end
        end

        --overchargeMana
        if isChecked("Ever Rising Tide") and essence.overchargeMana.active and getSpellCD(296072) <= gcd then
            if getOptionValue("Ever Rising Tide") == 1 then
                if cast.overchargeMana() then
                    return
                end
            end
            if getOptionValue("Ever Rising Tide") == 2 then
                if cd.lifeCocoon.exists() or buff.manaTea.exists() or cd.revival.exists() or burst == true then
                    if cast.overchargeMana() then
                        return
                    end
                end
            end
            if getOptionValue("Ever Rising Tide") == 3 then
                if lowest.hp < getOptionValue("Ever Rising Tide - Health") or burst == true then
                    if cast.overchargeMana() then
                        return
                    end
                end
            end
        end
        --lucid dreams
        if isChecked("Memory of Lucid Dreams") and getSpellCD(298357) <= gcd
                and mana <= getValue("Memory of Lucid Dreams") then
            if cast.memoryOfLucidDreams() then
                return
            end
        end

        --"Well of Existence  - Health"
        if isChecked("Well of Existence  - Health") and essence.refreshment.active and getSpellCD(296197) <= gcd then
            if lowest.hp < getOptionValue("Well of Existence  - Health") or burst == true then
                if cast.refreshment(lowest.unit) then
                    return true
                end
            end
        end
        --Seed of Eonar
        if isChecked("Seed of Eonar") and essence.lifeBindersInvocation.active and cast.able.lifeBindersInvocation and not moving then
            for i = 1, #br.friend do
                if UnitInRange(br.friend[i].unit) then
                    local lowHealthCandidates = getUnitsToHealAround(br.friend[i].unit, 30, getValue("Seed of Eonar"), #br.friend)
                    if #lowHealthCandidates >= getValue("Seed of Eonar Targets") and not moving or burst == true then
                        if cast.lifeBindersInvocation() then
                            return true
                        end
                    end
                end
            end
        end

        --Mana Tea
        if isChecked("Mana Tea") and talent.manaTea and not buff.wayOfTheCrane.exists() then
            if (mana <= getValue("Mana Tea") or getValue("Mana Tea") == 0) then
                if cast.manaTea("player") then
                    return
                end
            end
        end
    end

    local function Defensive()

        for i = 1, GetObjectCount() do
            local object = GetObjectWithIndex(i)
            local ID = ObjectID(object)

            local stun = 115078

            if stun ~= 0 then
                if ID == 161895 and not isLongTimeCCed(object) then
                    local x1, y1, z1 = ObjectPosition("player")
                    local x2, y2, z2 = ObjectPosition(object)
                    local distance = math.sqrt(((x2 - x1) ^ 2) + ((y2 - y1) ^ 2) + ((z2 - z1) ^ 2))
                    if distance < 10 then
                        CastSpellByName(GetSpellInfo(stun), object)
                        return true
                    end
                end
            end -- end the thing
        end

        if useDefensive() then


            if isChecked("Healing Elixir /Dampen Harm / Diffuse Magic") and php <= getValue("Healing Elixir /Dampen Harm / Diffuse Magic") then
                --Healing Elixir
                if talent.healingElixir then
                    if cast.healingElixir("player") then
                        return true
                    end
                    --Dampen Harm
                elseif talent.dampenHarm then
                    if cast.dampenHarm("player") then
                        return true
                    end
                elseif talent.diffuseMagic then
                    if cast.diffuseMagic("player") then
                        return
                    end
                end
            end

            --Fortifying Brew
            if isChecked("Fortifying Brew") and php <= getValue("Fortifying Brew") and cd.fortifyingBrew.remain() == 0 then
                if cast.fortifyingBrew() then
                    return
                end
            end
            --Healthstone
            if isChecked("Health stone/pot") and php <= getOptionValue("Health stone/pot") and inCombat and (hasHealthPot() or hasItem(5512) or hasItem(166799)) then
                if canUseItem(5512) then
                    useItem(5512)
                elseif canUseItem(healPot) then
                    useItem(healPot)
                elseif hasItem(166799) and canUseItem(166799) then
                    useItem(166799)
                end
            end
        end --End defensive check


        if br.player.ui.mode.detox == 1 and cast.able.detox() and not cast.last.detox() then
            for i = 1, #br.friend do
                if canDispel(br.friend[i].unit, spell.detox) and (getLineOfSight(br.friend[i].unit) and getDistance(br.friend[i].unit) <= 40 or br.friend[i].unit == "player") then
                    if cast.detox(br.friend[i].unit) then
                        return true
                    end
                end
            end
        end

        if tigers_lust() then
            return true
        end


    end -- end defensives


    local function interrupts()
        for i = 1, #enemies.yards20 do
            thisUnit = enemies.yards20[i]

            if isChecked("Paralysis") and (HOJ_unitList[GetObjectID(thisUnit)] ~= nil or HOJ_list[select(9, UnitCastingInfo(thisUnit))] ~= nil or HOJ_list[select(7, GetSpellInfo(UnitChannelInfo(thisUnit)))] ~= nil) and getBuffRemain(thisUnit, 226510) == 0 and distance <= 20 then
                if cast.paralysis(thisUnit) then
                    return true
                end
            end

            if useInterrupts() then
                distance = getDistance(thisUnit)
                if canInterrupt(thisUnit, getOptionValue("InterruptAt")) then

                    -- Leg Sweep
                    if isChecked("Leg Sweep") and not isCastingSpell(spell.essenceFont) then
                        if cast.legSweep(thisUnit) then
                            return
                        end
                    end
                    --[[
                             -- Paralysis
                             if isChecked("Paralysis") and not isCastingSpell(spell.essenceFont) then
                                 if cast.paralysis(thisUnit) then
                                     return
                                 end
                             end
                             ]]
                end
            end
        end -- End Interrupt Check
    end --end interrupts

    -----------------
    --- Rotations ---
    -----------------

    if pause(true) or IsMounted() or flying or drinking or isCastingSpell(spell.essenceFont) or isCasting(293491) or isCasting(212051) or hasBuff(250873) or hasBuff(115834) or hasBuff(58984) then
        return true
    else


        ---------------------------------
        --- Out Of Combat - Rotations ---
        ---------------------------------
        if not inCombat then
            --Print("test")

            --[[
                        Print("-------------")
                        Print("My Soothe: " .. tostring(select(7, UnitBuffID("target", 115175, "exact")) == "player"))
                        Print("My Statue: " .. tostring(select(7, UnitBuffID("target", 198533, "exact")) == "player"))

                        Print(tostring(buff.soothingMist.exists("target","exact")))
                        Print(tostring(buff.soothingMist.exists("target")))
                        Print("Target has my sooth - method 1: " .. tostring(getBuffRemain("target", 115175, "EXACT") ~= 0))
                        Print("Target has my sooth - method 2: " .. tostring(buff.soothingMist.exists("target")))
                        Print("Target has other sooth - method 1: " .. tostring(getBuffRemain("target", 115175) ~= 0))
                        Print("Target has STATUE sooth - method 1: " .. tostring(getBuffRemain("target", 198533, "EXACT") ~= 0))
                        Print("Target has STATUE sooth - method 2: " .. tostring(getBuffRemain("target", 198533) ~= 0))
                        --       Print("Target has STATUE sooth - method 3 - time remains: " .. getBuffRemain("target", 198533, "player"))
            ]]

            --    Print(hotcountFunc())
            --Print(tostring(mode.prehot))


            if isChecked("OOC Healing")
                    and not (IsMounted() or flying or drinking or isCastingSpell(spell.essenceFont) or isCasting(293491) or hasBuff(250873) or hasBuff(115834) or hasBuff(58984) or isLooting()) then

                if mode.prehot == 1 then
                    if renewingMistFunc() then
                        return true
                    end
                end
                if lowest.hp < 90 then
                    if heal() then
                        return true
                    end
                end
            end
            if isChecked("Tiger's Lust") then
                if tigers_lust() then
                    return true
                end
            end

            if isChecked("Freehold - pig") then
                bossHelper()
            end
            if isChecked("Auto Drink") and mana <= getOptionValue("Auto Drink") and not moving and getDebuffStacks("player", 240443) == 0 then
                --240443 == bursting
                --drink list
                --[[
                item=65499/conjured mana cookies - TW food
                item=159867/rockskip-mineral-wate (alliance bfa)
                item=163784/seafoam-coconut-water  (horde bfa)
                item=113509/conjured-mana-bun
                item=126936/sugar-crusted-fish-feast ff
                ]]
                if hasItem(65499) and canUseItem(65499) then
                    useItem(65499)
                end
                if hasItem(113509) and canUseItem(113509) then
                    useItem(113509)
                end
                if hasItem(159867) and canUseItem(159867) then
                    useItem(159867)
                end
                if hasItem(163784) and canUseItem(163784) then
                    useItem(163784)
                end
            end -- end auto-drink

            --ring out of combat
            if (SpecificToggle("Ring of Peace") and not GetCurrentKeyBoardFocus()) and isChecked("Ring of Peace") then
                if cast.able.ringOfPeace() then
                    if CastSpellByName(GetSpellInfo(spell.ringOfPeace), "cursor") then
                        return true
                    end
                end
            end


        end -- end ooc
        ---------------------------------
        --- In Combat - Rotations ---
        ---------------------------------
        if inCombat then

            if ((talent.focusedThunder and buff.thunderFocusTea.stack == 2)
                    or buff.thunderFocusTea.exists()
                    --  or cd.thunderFocusTea.ready()
                    or cast.last.thunderFocusTea(1) and not (buff.thunderFocusTea.stack() == 1 and talent.focusedThunder)) then
                if thunderFocusTea() then
                    return true
                end
            end

            -- dps key
            if (SpecificToggle("DPS Key") and not GetCurrentKeyBoardFocus()) or (buff.wayOfTheCrane.exists() and #enemies.yards8 > 0 and getHP(healUnit) >= getValue("Critical HP")) then
                if dps() then
                    return true
                end
            end
            if (lowest.hp > getValue("Critical HP") or lowest.unit == "player") then
                if Defensive() then
                    return true
                end
            end
            if high_prio() then
                return true
            end
            if cooldowns() then
                return true
            end
            if interrupts() then
                return true
            end
            if talent.risingMist and cast.able.risingSunKick() and #enemy_count_facing_5 > 0 and isChecked("Rising Sun Kick") then
                risingSunKickFunc()
                return true
            end
            if isChecked("Freehold - pig") then
                bossHelper()
            end
            if heal() then
                return true
            end
            if dps()
            then
                return true
            end


        end

    end -- end pause
end --end Runrotation

--local id = 270
local id = 0
if br.rotations[id] == nil then
    br.rotations[id] = {}
end
tinsert(br.rotations[id], {
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})



