local br = _G["br"]
local rotationName = "Lylo"
local colors = {
    blue = "|cff4285F4",
    red = "|cffDB4437",
    yellow = "|cffF4B400",
    green = "|cff0F9D58"
}

local function createToggles()
    ThunderFocusTeaModes = {
        [1] = {
            mode = "Auto",
            value = 1,
            overlay = "Thunder Focus Tea Mode Auto",
            tip = "Thunder Focus Tea Mode Auto",
            highlight = 1,
            icon = br.player.spell.thunderFocusTea
        },
        [2] = {
            mode = "EM",
            value = 2,
            overlay = "Thunder Focus Tea Mode - Enveloping Mist",
            tip = "Thunder Focus Tea Mode - Enveloping Mist",
            highlight = 1,
            icon = br.player.spell.envelopingMist
        },
        [3] = {
            mode = "VVF",
            value = 3,
            overlay = "Thunder Focus Tea Mode - Vivify",
            tip = "Thunder Focus Tea Mode - Vivify",
            highlight = 1,
            icon = br.player.spell.vivify
        },
        [4] = {
            mode = "RM",
            value = 4,
            overlay = "Thunder Focus Tea Mode - Renewing Mist",
            tip = "Thunder Focus Tea Mode - Renewing Mist",
            highlight = 1,
            icon = br.player.spell.renewingMist
        },
        [5] = {
            mode = "RSK",
            value = 5,
            overlay = "Thunder Focus Tea Mode - Rising Sun Kick",
            tip = "Thunder Focus Tea Mode - Rising Sun Kick",
            highlight = 1,
            icon = br.player.spell.risingSunKick
        }
    }
    CreateButton("ThunderFocusTea", 4, 0)
    DetoxModes = {
        [1] = {
            mode = "On",
            value = 1,
            overlay = "Detox Enabled",
            tip = "Detox Enabled",
            highlight = 1,
            icon = br.player.spell.detox
        },
        [2] = {
            mode = "Off",
            value = 2,
            overlay = "Detox Disabled",
            tip = "Detox Disabled",
            highlight = 0,
            icon = br.player.spell.detox
        }
    }
    CreateButton("Detox", 5, 0)
end

local function createOptions()
    local optionTable

    local function rotationOptions()
        local section
        ----------------------
        --- TOGGLE OPTIONS ---
        ----------------------
        section = br.ui:createSection(br.ui.window.profile, "Toggle Keys")
        -- Single/Multi Toggle
        br.ui:createDropdownWithout(section, "Rotation Mode", br.dropOptions.Toggle, 4)
        -- Pause Toggle
        br.ui:createDropdown(section, "Pause Mode", br.dropOptions.Toggle, 6)
        br.ui:checkSectionState(section)

        section = br.ui:createSection(br.ui.window.profile, "Heal Options")
        br.ui:createSpinnerWithout(
            section,
            "Soothing Mist",
            90,
            1,
            100,
            1,
            "Health percent to cast at " .. colors.green .. "(default: 85 - enabled)"
        )
        br.ui:createSpinnerWithout(
            section,
            "Soothing Mist - Expel Harm",
            90,
            1,
            100,
            1,
            "Health percent to cast at " .. colors.green .. "(default: 90 - enabled)"
        )
        br.ui:createSpinnerWithout(
            section,
            "Soothing Mist - Vivify",
            80,
            1,
            100,
            1,
            "Health percent to cast at " .. colors.green .. "(default: 80 - enabled)"
        )
        br.ui:createSpinnerWithout(
            section,
            "Soothing Mist - Enveloping Mist",
            60,
            1,
            100,
            1,
            "Health percent to cast at " .. colors.green .. "(default: 60 - enabled)"
        )
        br.ui:createSpinner(
            section,
            "Revival",
            40,
            1,
            100,
            5,
            "Health percent to cast at " .. colors.green .. "(default: 40 - enabled)"
        )
        br.ui:createSpinnerWithout(
            section,
            "Revival % of targets",
            3,
            1,
            100,
            5,
            "Percentage of people in your group under health option to use revival " .. colors.green .. "(default: 50)"
        )
        br.ui:createSpinner(
            section,
            "Healing Elixir",
            85,
            1,
            100,
            5,
            "Health percent to cast at " .. colors.green .. "(default: 85 - enabled)"
        )
        br.ui:createSpinner(
            section,
            "Life Cocoon",
            50,
            1,
            100,
            5,
            "Health percent to cast at " .. colors.green .. "(default: 20 - enabled)"
        )
        br.ui:createSpinner(
            section,
            "Essence Font",
            75,
            1,
            100,
            5,
            "Health percent to cast at " .. colors.green .. "(default: 80 - enabled)"
        )
        br.ui:createSpinnerWithout(
            section,
            "Essence Font targets",
            5,
            1,
            40,
            1,
            "Number of hurt people before triggering spell " .. colors.green .. "(default: 5 - enabled)"
        )
        br.ui:checkSectionState(section)
        section = br.ui:createSection(br.ui.window.profile, "Made By: Lylo - Version 1.0.0")
        br.ui:createText(section, colors.red .. "Discord contact: " .. colors.green .. "LyLo#0253")
        br.ui:createText(section, colors.red .. "Required: " .. colors.yellow .. "Healing Engine > HR")
        br.ui:createText(
            section,
            colors.blue .. "Good to have: " .. colors.yellow .. "Enemies Engine > Dynamic Targeting"
        )
        br.ui:createText(section, colors.red .. "FAQ:")
        br.ui:createText(section, colors.blue .. "  1 - What are the best settings?")
        br.ui:createText(section, colors.green .. "     Go to Proving Grounds and tweek settings")
        br.ui:createText(section, colors.green .. "     until you find something you like.")
        br.ui:createText(section, colors.blue .. "  2 - What talents are supported?")
        br.ui:createText(section, colors.green .. "     Currently: Mist Wrap, Lifecycles, Healing Elixir")
        br.ui:createText(section, colors.green .. "     Summon Jade Serpent, Rising Mist.")
        br.ui:createText(section, colors.blue .. "  3 - What covenant abilities are supported?")
        br.ui:createText(section, colors.green .. "     Currently: Kyrian")
        br.ui:createText(section, colors.green .. "     get in touch to get support for other covenants.")
        br.ui:createText(section, colors.blue .. "  4 - How can I request changes?")
        br.ui:createText(section, colors.green .. "     Send a message on discord.")
        br.ui:checkSectionState(section)
    end
    optionTable = {
        {
            [1] = "Rotation Options",
            [2] = rotationOptions
        }
    }
    return optionTable
end

local variables = {}
variables.statue = {
    x = 0,
    y = 0,
    z = 0
}
variables.lastSoothingMist = nil
variables.thunderFocusTea = nil

-- required settings: healing engine : HE Active
-- required settings: enemies engine : dynamic targeting

local function runRotation()
    br.player.ui.mode.detox = br.data.settings[br.selectedSpec].toggles["Detox"]
    br.player.ui.mode.thunderFocusTea = br.data.settings[br.selectedSpec].toggles["ThunderFocusTea"]

    -- A
    -- B
    local buff = br.player.buff
    -- C
    local cast = br.player.cast
    local cd = br.player.cd
    -- D
    -- E
    -- F
    local friends = br.friend
    -- G
    -- H
    -- I
    -- J
    -- K
    -- L
    local lastSpellCast = lastSpellCast
    -- M
    -- N
    -- O
    -- P
    local player = {
        hp = br.player.health,
        unit = "player",
        moving = isMoving("player"),
        mana = br.player.power.mana.percent()
    }
    -- Q
    -- R
    -- S
    local spell = br.player.spell
    -- T
    local talent = br.player.talent
    local tanks = getTanksTable()
    -- U
    local units = {
        range5 = br.player.units.get(4) or {}
    }
    -- V
    -- X
    -- Z
    -- local functions
    local risingSunKick = function()
        if talent.risingMist and #units.range5 > 0 then
            if cast.risingSunKick(units.range5) then
                br.addonDebug("[Rising Sun Kick] : " .. UnitName(units.range5))
                return true
            else
                return false
            end
        end
    end

    local renewingMist = function()
        for i = 1, #tanks do
            if not buff.renewingMist.exists(tanks[i].unit) and UnitInRange(tanks[i].unit) then
                if cast.renewingMist(tanks[i].unit) then
                    br.addonDebug(
                        "[RenewMist]: " .. UnitName(tanks[i].unit) .. " at: " .. round2(tanks[i].hp, 2) .. "%"
                    )
                    return true
                end
            end
        end
        for i = 1, #friends do
            if not buff.renewingMist.exists(friends[i].unit) and UnitInRange(friends[i].unit) then
                if cast.renewingMist(friends[i].unit) then
                    br.addonDebug(
                        "[RenewMist]: " .. UnitName(friends[i].unit) .. " at: " .. round2(friends[i].hp, 2) .. "%"
                    )
                    return true
                end
            end
        end
    end

    if br.player.inCombat and not cast.active.essenceFont() then
        local lowest = friends[1]

        -- Thunder Focus
        if cast.able.thunderFocusTea() then
            if br.player.ui.mode.thunderFocusTea == 1 then -- Auto
                if cast.able.envelopingMist() and getLowAllies(70) < 3 and lowest.hp < 50 then -- Enveloping Mist
                    if cast.thunderFocusTea() then
                        br.addonDebug("[Thunder Focus Tea]: Enveloping Mist")
                        variables.thunderFocusTea = 2
                        return true
                    end
                elseif player.mana <= 80 and cast.able.vivify() then -- Vivify
                    if cast.thunderFocusTea() then
                        br.addonDebug("[Thunder Focus Tea]: Vivify")
                        variables.thunderFocusTea = 3
                        return true
                    end
                elseif cast.able.renewingMist() and getLowAllies(70) > 3 and not talent.risingMist then -- Renewing Mist
                    if cast.thunderFocusTea() then
                        br.addonDebug("[Thunder Focus Tea]: Renewing Mist")
                        variables.thunderFocusTea = 4
                        return true
                    end
                elseif cd.risingSunKick.ready() and cast.able.risingSunKick() and #units.range5 > 0 and talent.risingMist or #br.friend == 1 then -- Rising Sun Kick
                    if cast.thunderFocusTea() then
                        br.addonDebug("[Thunder Focus Tea]: Rising Sun Kick")
                        variables.thunderFocusTea = 5
                        return true
                    end
                else
                    variables.thunderFocusTea = nil
                end
            elseif br.player.ui.mode.thunderFocusTea == 2 then -- Enveloping Mist
                if
                    cast.able.envelopingMist() and lowest.hp <= getValue("Soothing Mist - Enveloping Mist") and
                        cast.active.soothingMist() and
                        lowest.unit == variables.lastSoothingMist.unit
                 then
                    if cast.thunderFocusTea() then
                        br.addonDebug("[Thunder Focus Tea]: Enveloping Mist")
                        return true
                    end
                end
            elseif br.player.ui.mode.thunderFocusTea == 3 then -- Vivify
                if
                    cast.able.vivify() and lowest.hp <= getValue("Soothing Mist - Vivify") and
                        cast.active.soothingMist() and
                        lowest.unit == variables.lastSoothingMist.unit
                 then
                    if cast.thunderFocusTea() then
                        br.addonDebug("[Thunder Focus Tea]: Vivify")
                        return true
                    end
                end
            elseif br.player.ui.mode.thunderFocusTea == 4 then -- Renewing Mist
                if cast.able.renewingMist() then
                    if cast.thunderFocusTea() then
                        br.addonDebug("[Thunder Focus Tea]: Renewing Mist")
                        return true
                    end
                end
            elseif br.player.ui.mode.thunderFocusTea == 5 then -- Rising Sun Kick
                if #units.range5 > 0 and cast.able.risingSunKick() then
                    if cast.thunderFocusTea() then
                        br.addonDebug("[Thunder Focus Tea]: Rising Sun Kick")
                        return true
                    end
                end
            end
        elseif lastSpellCast == spell.thunderFocusTea and buff.thunderFocusTea.exists() then
            if br.player.ui.mode.thunderFocusTea == 2 or variables.thunderFocusTea == 2 then -- Enveloping Mist
                if cast.envelopingMist(lowest.unit) then
                    br.addonDebug(
                        "[Enveloping Mist TFT]:" .. UnitName(lowest.unit) .. " at: " .. round2(lowest.hp, 2) .. "%"
                    )
                    variables.thunderFocusTea = nil
                    return true
                end
            elseif br.player.ui.mode.thunderFocusTea == 3 or variables.thunderFocusTea == 3 then -- Vivify
                if cast.vivify(lowest.unit) then
                    br.addonDebug("[Vivify TFT]:" .. UnitName(lowest.unit) .. " at: " .. round2(lowest.hp, 2) .. "%")
                    variables.thunderFocusTea = nil
                    return true
                end
            elseif br.player.ui.mode.thunderFocusTea == 4 or variables.thunderFocusTea == 4 then -- Renewing Mist
                if renewingMist() then
                    variables.thunderFocusTea = nil
                    return true
                end
            elseif br.player.ui.mode.thunderFocusTea == 5 or variables.thunderFocusTea == 5 then -- Rising Sun Kick
                if risingSunKick() then
                    variables.thunderFocusTea = nil
                    return true
                end
            else
                return false
            end
        end

        -- rising sun kick after essence font or after envelopming mist or after TFT + RSK
        if 
            cast.last.essenceFont(1) or cast.last.envelopingMist(1) or
                (cast.last.thunderFocusTea(2) and cast.last.risingSunKick(1))
         then
            if risingSunKick() then
                return true
            else
                return false
            end
        end

        -- healing elixir
        if
            isChecked("Healing Elixir") and not cast.last.healingElixir(1) and player.hp <= getValue("Healing Elixir") and
                variables.lastSoothingMist.unit ~= player.unit and
                not buff.envelopingMist.exists(player.unit)
         then
            if cast.healingElixir() then
                br.addonDebug("[Healing Elixir]:" .. UnitName(player.unit) .. " at: " .. round2(player.hp, 2) .. "%")
                return true
            end
        end

        -- Revival on everybody
        if isChecked("Revival") then
            local revivalValue = getValue("Revival")
            local lowAllies = getLowAllies(revivalValue)
            local percentageLowAllies = (lowAllies / #friends) * 100
            local revivalPercentageTargets = getValue("Revival % of targets")
            if percentageLowAllies >= revivalPercentageTargets then
                if cast.revival() then
                    br.addonDebug(
                        "[Revival]: Percentage of allies under " .. revivalValue .. ": " .. percentageLowAllies .. "%"
                    )
                    return true
                end
            end
        end

        -- Life Cocoon on low target ASAP
        if isChecked("Life Cocoon") and lowest.hp <= getValue("Life Cocoon") then
            if cast.lifeCocoon(lowest.unit) then
                br.addonDebug("[Life Cocoon]:" .. UnitName(lowest.unit) .. " at: " .. round2(lowest.hp, 2) .. "%")
                return true
            end
        end

        -- Detox
        if br.player.ui.mode.detox == 1 and cast.able.detox() and not cast.last.detox(1) then
            for i = 1, #friends do
                if
                    canDispel(friends[i].unit, spell.detox) and
                        (getLineOfSight(friends[i].unit) and getDistance(friends[i].unit) <= 40)
                 then
                    if cast.detox(friends[i].unit) then
                        br.addonDebug("[Detox]:" .. UnitName(friends[i].unit))
                        return true
                    end
                end
            end
        end

        -- Always cast renewing mist
        if renewingMist() then
            return true
        end

        -- Always have jade serpent statue active within 40 yards
        if talent.summonJadeSerpentStatue then
            local function countStatue()
                local count = 0
                for index = 1, 4 do
                    if select(1, GetTotemInfo(index)) then
                        count = count + 1
                    end
                end
                return count
            end
            local distanceToStatue =
                getDistanceToObject("player", variables.statue.x, variables.statue.y, variables.statue.z)
            local existsStatue = countStatue() > 0
            if distanceToStatue > 30 or not existsStatue then
                local px, py, pz = GetObjectPosition("player")
                px = px + math.random(-2, 2)
                py = py + math.random(-2, 2)
                if castGroundAtLocation({x = px, y = py, z = pz}, spell.summonJadeSerpentStatue) then
                    if existsStatue then
                        br.addonDebug("[Jade Serpent Statue]")
                        variables.statue = {
                            x = px,
                            y = py,
                            z = pz
                        }
                        return true
                    end
                end
            end
        end

        -- essence font
        if isChecked("Essence Font") then
            local essenceFontValue = getValue("Essence Font")
            local lowAllies = getLowAllies(essenceFontValue)
            local essenceFontTargets = getValue("Essence Font targets")
            if lowAllies >= essenceFontTargets then
                if cast.essenceFont() then
                    br.addonDebug(
                        "[Essence Font]: Allies under " ..
                            essenceFontValue .. ": " .. lowAllies .. " from " .. essenceFontTargets
                    )
                    return true
                end
            end
        end

        -- if soothing mist healed unit its full hp, stop the spell
        if
            cast.active.soothingMist() and variables.lastSoothingMist.hp >= 95 and
                variables.lastSoothingMist.unit ~= lowest.unit
         then
            if cast.cancel.soothingMist() then
                br.addonDebug(
                    "CANCELED: [Soothing Mist]:" ..
                        UnitName(variables.lastSoothingMist.unit) ..
                            " at: " .. round2(variables.lastSoothingMist.hp, 2) .. "%"
                )
            end
        end
        -- single-target healing
        if not player.moving and lowest.hp <= getValue("Soothing Mist") then
            if cast.soothingMist(lowest.unit) then
                br.addonDebug("[Soothing Mist]:" .. UnitName(lowest.unit) .. " at: " .. round2(lowest.hp, 2) .. "%")
                variables.lastSoothingMist = {
                    unit = lowest.unit,
                    hp = lowest.hp
                }
                return true
            end
        end

        if not player.moving and cast.active.soothingMist() and lowest.unit == variables.lastSoothingMist.unit then
            -- expel harm
            if
                lowest.hp <= getValue("Soothing Mist - Expel Harm") and
                    player.hp <= getValue("Soothing Mist - Expel Harm")
             then
                if cast.expelHarm() then
                    br.addonDebug("[Expel Harm]:" .. UnitName(lowest.unit) .. " at: " .. round2(lowest.hp, 2) .. "%")
                    return true
                end
            end
            -- enveloping mist
            if
                not buff.envelopingMist.exists(lowest.unit) and
                    (lowest.hp <= getValue("Soothing Mist - Enveloping Mist") or
                        (lowest.hp <= getValue("Soothing Mist - Enveloping Mist") + 20 and
                            buff.lifeCyclesEnvelopingMist.exists()))
             then
                if cast.envelopingMist(lowest.unit) then
                    br.addonDebug(
                        "[Enveloping Mist]:" .. UnitName(lowest.unit) .. " at: " .. round2(lowest.hp, 2) .. "%"
                    )
                    return true
                end
            end
            -- vivify
            if lowest.hp <= getValue("Soothing Mist - Vivify") and buff.envelopingMist.remains(lowest.unit) < 2 then
                if cast.vivify(lowest.unit) then
                    br.addonDebug("[Vivify]:" .. UnitName(lowest.unit) .. " at: " .. round2(lowest.hp, 2) .. "%")
                    return true
                end
            end
        end
    end
end

local id = 270
if br.rotations[id] == nil then
    br.rotations[id] = {}
end
tinsert(
    br.rotations[id],
    {
        name = rotationName,
        toggles = createToggles,
        options = createOptions,
        run = runRotation
    }
)
