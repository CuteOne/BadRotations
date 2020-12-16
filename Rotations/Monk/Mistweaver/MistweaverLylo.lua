local br = _G["br"]
local rotationName = "Lylo"
local colors = {
    blue = "|cff4285F4",
    red = "|cffDB4437",
    yellow = "|cffF4B400",
    green = "|cff0F9D58"
}

local function createToggles()
    InterruptModes = {
        [1] = {
            mode = "On",
            value = 1,
            overlay = "Interrupts Enabled",
            tip = "Includes Basic Interrupts.",
            highlight = 1,
            icon = br.player.spell.paralysis
        },
        [2] = {
            mode = "Off",
            value = 2,
            overlay = "Interrupts Disabled",
            tip = "No Interrupts will be used.",
            highlight = 0,
            icon = br.player.spell.paralysis
        }
    }
    CreateButton("Interrupt", 1, 0)
    DPSModes = {
        [1] = {
            mode = "On",
            value = 1,
            overlay = "DPS On",
            tip = "Auto DPS Enabled",
            highlight = 1,
            icon = br.player.spell.tigerPalm
        },
        [2] = {
            mode = "Off",
            value = 2,
            overlay = "DPS Off",
            tip = "Auto DPS Disabled",
            highlight = 0,
            icon = br.player.spell.tigerPalm
        }
    }
    CreateButton("DPS", 2, 0)
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
    CreateButton("ThunderFocusTea", 3, 0)
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
    CreateButton("Detox", 4, 0)
end

local function createOptions()
    local optionTable

    local function rotationOptions()
        local section
        ----------------------
        --- TOGGLE OPTIONS ---
        ----------------------
        section = br.ui:createSection(br.ui.window.profile, "Heal Options")
        br.ui:createSpinnerWithout(
            section,
            "Renewing Mist",
            95,
            1,
            100,
            1,
            "Health percent to cast at " .. colors.green .. "(default: 95 - enabled)"
        )
        br.ui:createSpinnerWithout(
            section,
            "Soothing Mist",
            85,
            1,
            100,
            1,
            "Health percent to cast at " .. colors.green .. "(default: 85 - enabled)"
        )
        br.ui:createSpinnerWithout(
            section,
            "Soothing Mist - Expel Harm",
            80,
            1,
            100,
            1,
            "Health percent to cast at " .. colors.green .. "(default: 80 - enabled)"
        )
        br.ui:createSpinnerWithout(
            section,
            "Soothing Mist - Vivify",
            75,
            1,
            100,
            1,
            "Health percent to cast at " .. colors.green .. "(default: 75 - enabled)"
        )
        br.ui:createSpinnerWithout(
            section,
            "Soothing Mist - Enveloping Mist",
            65,
            1,
            100,
            1,
            "Health percent to cast at " .. colors.green .. "(default: 65 - enabled)"
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
            "Revival targets",
            3,
            1,
            50,
            1,
            "Number of hurt people before triggering spell " .. colors.green .. "(default: 3 - enabled)"
        )
        br.ui:createSpinner(
            section,
            "Invoke Yu'lon",
            55,
            1,
            100,
            5,
            "Health percent to cast at " .. colors.green .. "(default: 55 - enabled)"
        )
        br.ui:createSpinnerWithout(
            section,
            "Invoke Yu'lon targets",
            2,
            1,
            50,
            1,
            "Number of hurt people before triggering spell " .. colors.green .. "(default: 2 - enabled)"
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
            30,
            1,
            100,
            5,
            "Health percent to cast at " .. colors.green .. "(default: 30 - enabled)"
        )
        br.ui:createSpinner(
            section,
            "Essence Font",
            60,
            1,
            100,
            5,
            "Health percent to cast at " .. colors.green .. "(default: 60 - enabled)"
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

        section = br.ui:createSection(br.ui.window.profile, "DPS Options")
        br.ui:createCheckbox(
            section,
            "Crackling Jade Lightning",
            "Enables" .. "/" .. "Disables " .. "the use of Crackling Jade Lightning."
        )
        br.ui:checkSectionState(section)

        section = br.ui:createSection(br.ui.window.profile, "Other Options")
        br.ui:createSpinner(
            section,
            "Fortifying Brew",
            75,
            1,
            100,
            5,
            "Health percent to cast at " .. colors.green .. "(default: 75 - enabled)"
        )
        br.ui:createSpinner(
            section,
            "Arcane Torrent",
            80,
            1,
            100,
            5,
            "Mana percent to cast at " .. colors.green .. "(default: 80 - enabled)"
        )
        br.ui:createSpinner(
            section,
            "Low mana at",
            50,
            1,
            100,
            5,
            "Mana percent to activate, " .. colors.green .. "(default: 50 - enabled)"
        )
        -- Basic Healing Module
        br.player.module.BasicHealing(section)
        br.ui:checkSectionState(section)


        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
        br.ui:createCheckbox(section, "Paralysis")
        br.ui:createCheckbox(section, "Leg Sweep")
        br.ui:createCheckbox(section, "Ring of Peace")
        br.ui:createSpinnerWithout(section, "Interrupt At", 0, 0, 95, 5, colors.green .. "Cast Percentage to use at.")
        br.ui:checkSectionState(section)

        section = br.ui:createSection(br.ui.window.profile, "Made By: Lylo - Version 1.0.0")
        br.ui:createText(section, colors.red .. "Discord contact: " .. colors.green .. "LyLo#0253")
        br.ui:createText(section, colors.red .. "Required: " .. colors.yellow .. "Healing Engine > HR")
        br.ui:createText(
            section,
            colors.blue .. "Good to have: " .. colors.yellow .. "Enemies Engine > Dynamic Targeting"
        )
        br.ui:createText(section, colors.blue .. "Good to have: " .. colors.yellow .. "Queue Engine > Smart Queue >")
        br.ui:createText(section, colors.yellow .. "                          Leg Sweep, Ring of Peace")
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
        br.ui:createText(section, colors.blue .. "  5 - Is this good?")
        br.ui:createText(section, colors.green .. "     I don't know, you tell me")
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
variables.weaponsOfOrderTicks = 0

-- required settings: healing engine : HE Active
-- required settings: enemies engine : dynamic targeting

local function runRotation()
    local ui = br.player.ui

    ui.mode.detox = br.data.settings[br.selectedSpec].toggles["Detox"]
    ui.mode.thunderFocusTea = br.data.settings[br.selectedSpec].toggles["ThunderFocusTea"]
    ui.mode.dps = br.data.settings[br.selectedSpec].toggles["DPS"]

    local lowMana = 0

    if ui.checked("Low mana at") and br.player.power.mana.percent() <= ui.value("Low mana at") then
        lowMana = 10
    end
    -- A
    -- B
    local buff = br.player.buff
    -- C
    local cast = br.player.cast
    local cd = br.player.cd
    -- D
    local dynamicTarget = {
        range5 = br.player.units.get(5),
        range40 = br.player.units.get(40)
    }
    -- E
    local enemies = {
        range8 = br.player.enemies.get(8),
        range40 = br.player.enemies.get(40)
    }
    -- F
    local friends = {
        -- Soothing Mist, Vivify, Enveloping Mist, Renewing Mist, Life Cocoon, Invoke Yu'lon, Revival, Detox
        range40 = getAllies("player", 40),
        -- Essence Font
        range30 = getAllies("player", 30),
        -- Lowest
        lowest = br.friend[1]
    }
    friends.lowAllies = {
        essenceFont = getLowAlliesInTable(ui.value("Essence Font") + lowMana, friends.range30),
        revival = getLowAlliesInTable(ui.value("Revival") + lowMana, friends.range40),
        invokeYulon = getLowAlliesInTable(ui.value("Invoke Yu'lon") + lowMana, friends.range40),
        weaponsOfOrder = getLowAlliesInTable(50, friends.range40)
    }
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
        mana = br.player.power.mana.percent(),
        race = br.player.unit.race()
    }
    -- Q
    -- R
    -- S
    local spell = br.player.spell
    -- T
    local talent = br.player.talent
    local tanks = getTanksTable()
    -- U
    -- V
    -- X
    -- Z
    -- local functions
    local castRisingSunKick = function()
        if cast.able.risingSunKick(dynamicTarget.range5) and cd.risingSunKick.ready() then
            if talent.risingMist and dynamicTarget.range5 ~= nil then
                if cast.risingSunKick(dynamicTarget.range5) then
                    br.addonDebug("[Rising Sun Kick]: " .. UnitName(dynamicTarget.range5))
                    return true
                end
            end
        end
        return false
    end

    local castRenewingMist = function()
        local renewingMistUnit = nil
        for i = 1, #tanks do
            local tempUnit = tanks[i]
            if
                not buff.renewingMist.exists(tempUnit.unit) and UnitInRange(tempUnit.unit) and
                    tempUnit.hp <= ui.value("Renewing Mist")
             then
                renewingMistUnit = tempUnit
            end
        end
        if renewingMistUnit == nil then
            for i = 1, #friends.range40 do
                local tempUnit = friends.range40[i]
                if
                    not buff.renewingMist.exists(tempUnit.unit) and UnitInRange(tempUnit.unit) and
                        tempUnit.hp <= ui.value("Renewing Mist")
                 then
                    renewingMistUnit = tempUnit
                end
            end
        end
        if renewingMistUnit == nil then
            if
                not buff.renewingMist.exists(player.unit) and UnitInRange(player.unit) and
                    player.hp <= ui.value("Renewing Mist")
             then
                renewingMistUnit = player
            end
        end
        if renewingMistUnit ~= nil then
            if cast.able.renewingMist(renewingMistUnit.unit) then
                if cast.renewingMist(renewingMistUnit.unit) then
                    br.addonDebug(
                        "[Renewing Mist]: " ..
                            UnitName(renewingMistUnit.unit) ..
                                " at: " .. round2(renewingMistUnit.hp + lowMana, 2) .. "%"
                    )
                    return true
                end
            end
        end
        return false
    end

    local doDamage = function()
        local doDamageAOE = function()
            -- Spinning Crane Kick
            if cast.able.spinningCraneKick() and cd.spinningCraneKick.ready() then
                if #enemies.range8 > 3 and not cast.active.spinningCraneKick() then
                    if cast.spinningCraneKick() then
                        br.addonDebug("[Spinning Crane Kick]: enemies around: " .. #enemies.range8)
                        return true
                    end
                end
            end
        end

        local doDamage3Targets = function()
            if dynamicTarget.range5 ~= nil and #enemies.range8 == 3 then
                -- Rising Sun Kick on cooldown
                if castRisingSunKick() then
                    return true
                end
                -- Blackout Kick at any stacks
                if cast.able.blackoutKick() and cd.blackoutKick.ready() and buff.teachingsOfTheMonastery.stack() > 1 then
                    if cast.blackoutKick(dynamicTarget.range5) then
                        br.addonDebug("[Blackout Kick]: " .. UnitName(dynamicTarget.range5))
                        return true
                    end
                end
                -- Spinning Crane Kick
                if
                    cast.able.spinningCraneKick() and cd.spinningCraneKick.ready() and
                        not cast.active.spinningCraneKick()
                 then
                    if cast.spinningCraneKick() then
                        br.addonDebug("[Spinning Crane Kick]: enemies around: " .. #enemies.range8)
                        return true
                    end
                end
            end
        end

        local doDamageST = function()
            if dynamicTarget.range5 ~= nil then
                -- Rising Sun Kick on cooldown
                if castRisingSunKick() then
                    return true
                end
                -- Blackout Kick at 3 stacks
                if cast.able.blackoutKick() and cd.blackoutKick.ready() and buff.teachingsOfTheMonastery.stack() == 3 then
                    if cast.blackoutKick(dynamicTarget.range5) then
                        br.addonDebug("[Blackout Kick]: " .. UnitName(dynamicTarget.range5))
                        return true
                    end
                end
                -- Tiger Palm
                if cast.able.tigerPalm() and cd.tigerPalm.ready() then
                    if cast.tigerPalm(dynamicTarget.range5) then
                        br.addonDebug("[Tiger Palm]: " .. UnitName(dynamicTarget.range5))
                        return true
                    end
                end
            else
                -- Crackling Jade Lightning
                if
                    ui.checked("Crackling Jade Lightning") and cast.able.cracklingJadeLightning() and
                        cd.cracklingJadeLightning.ready()
                 then
                    if dynamicTarget.range40 ~= nil and not player.moving then
                        if cast.cracklingJadeLightning(dynamicTarget.range40) then
                            br.addonDebug("[Crackling Jade Lightning]: " .. UnitName(dynamicTarget.range40))
                            return true
                        end
                    end
                end
            end
        end

        if ui.mode.dps == 1 then --ON
            -- Touch of Death
            if cast.able.touchOfDeath() and cd.touchOfDeath.ready() then
                if dynamicTarget.range5 ~= nil and player.hp > getHP(dynamicTarget.range5) then
                    if cast.touchOfDeath(dynamicTarget.range5) then
                        br.addonDebug("[Touch of Death]: " .. UnitName(dynamicTarget.range5))
                        return true
                    end
                end
            end

            if doDamageAOE() or doDamage3Targets() or doDamageST() then
                return true
            end
        end
    end

    local castWeaponsOfOrder = function()
        if cast.able.weaponsOfOrder() and cd.weaponsOfOrder.ready() then
            if variables.weaponsOfOrderTicks > 10 then
                if cast.weaponsOfOrder() then
                    br.addonDebug(colors.blue .. "[Weapons of order]")
                    return true
                end
            elseif friends.lowAllies.weaponsOfOrder > 2 or friends.lowest.hp < 50 then
                variables.weaponsOfOrderTicks = variables.weaponsOfOrderTicks + 1
            else
                variables.weaponsOfOrderTicks = 0
            end
        end
    end

    local doHealing = function()
        -- Thunder Focus
        if cast.able.thunderFocusTea() and cd.thunderFocusTea.ready() then
            if ui.mode.thunderFocusTea == 1 then -- Auto
                if cast.able.envelopingMist() and getLowAllies(70) < 3 and friends.lowest.hp + lowMana < 50 then -- Enveloping Mist
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
                elseif
                    cd.risingSunKick.ready() and cast.able.risingSunKick() and dynamicTarget.range5 ~= nil and
                        talent.risingMist or
                        #br.friend == 1
                 then -- Rising Sun Kick
                    if cast.thunderFocusTea() then
                        br.addonDebug("[Thunder Focus Tea]: Rising Sun Kick")
                        variables.thunderFocusTea = 5
                        return true
                    end
                else
                    variables.thunderFocusTea = nil
                end
            elseif ui.mode.thunderFocusTea == 2 then -- Enveloping Mist
                if
                    cast.able.envelopingMist() and
                        friends.lowest.hp + lowMana <= ui.value("Soothing Mist - Enveloping Mist") and
                        cast.active.soothingMist() and
                        variables.lastSoothingMist ~= nil and
                        friends.lowest.unit == variables.lastSoothingMist.unit
                 then
                    if cast.thunderFocusTea() then
                        br.addonDebug("[Thunder Focus Tea]: Enveloping Mist")
                        return true
                    end
                end
            elseif ui.mode.thunderFocusTea == 3 then -- Vivify
                if
                    cast.able.vivify() and friends.lowest.hp + lowMana <= ui.value("Soothing Mist - Vivify") and
                        cast.active.soothingMist() and
                        variables.lastSoothingMist ~= nil and
                        friends.lowest.unit == variables.lastSoothingMist.unit
                 then
                    if cast.thunderFocusTea() then
                        br.addonDebug("[Thunder Focus Tea]: Vivify")
                        return true
                    end
                end
            elseif ui.mode.thunderFocusTea == 4 then -- Renewing Mist
                if cast.able.renewingMist() then
                    if cast.thunderFocusTea() then
                        br.addonDebug("[Thunder Focus Tea]: Renewing Mist")
                        return true
                    end
                end
            elseif ui.mode.thunderFocusTea == 5 then -- Rising Sun Kick
                if dynamicTarget.range5 ~= nil and cast.able.risingSunKick() then
                    if cast.thunderFocusTea() then
                        br.addonDebug("[Thunder Focus Tea]: Rising Sun Kick")
                        return true
                    end
                end
            end
        elseif lastSpellCast == spell.thunderFocusTea and buff.thunderFocusTea.exists() then
            if ui.mode.thunderFocusTea == 2 or variables.thunderFocusTea == 2 then -- Enveloping Mist
                if
                    cast.able.envelopingMist(friends.lowest.unit) and cd.envelopingMist.ready() and
                        cast.envelopingMist(friends.lowest.unit)
                 then
                    br.addonDebug(
                        "[Enveloping Mist TFT]: " ..
                            UnitName(friends.lowest.unit) .. " at: " .. round2(friends.lowest.hp + lowMana, 2) .. "%"
                    )
                    variables.thunderFocusTea = nil
                    return true
                end
            elseif ui.mode.thunderFocusTea == 3 or variables.thunderFocusTea == 3 then -- Vivify
                if cast.able.vivify(friends.lowest.unit) and cd.vivify.ready() and cast.vivify(friends.lowest.unit) then
                    br.addonDebug(
                        "[Vivify TFT]: " ..
                            UnitName(friends.lowest.unit) .. " at: " .. round2(friends.lowest.hp + lowMana, 2) .. "%"
                    )
                    variables.thunderFocusTea = nil
                    return true
                end
            elseif ui.mode.thunderFocusTea == 4 or variables.thunderFocusTea == 4 then -- Renewing Mist
                if castRenewingMist() then
                    variables.thunderFocusTea = nil
                    return true
                end
            elseif ui.mode.thunderFocusTea == 5 or variables.thunderFocusTea == 5 then -- Rising Sun Kick
                if castRisingSunKick() then
                    variables.thunderFocusTea = nil
                    return true
                end
            end
            return false
        end

        -- Force Cast of Rising Sun Kick after Essence Font or Enveloping Mist or (Thunder Focus Tea Mode and Rising Sun Kick)
        if dynamicTarget.range5 ~= nil and cast.able.risingSunKick(dynamicTarget.range5) and cd.risingSunKick.ready() then
            if
                cast.last.essenceFont(1) or cast.last.envelopingMist(1) or
                    (cast.last.thunderFocusTea(2) and cast.last.risingSunKick(1))
             then
                if castRisingSunKick() then
                    return true
                else
                    return false
                end
            end
        end

        -- Healing Elixir with prevent of double cast
        if cast.able.healingElixir() and cd.healingElixir.ready() then
            if
                not cast.last.healingElixir(1) and ui.checked("Healing Elixir") and
                    player.hp <= ui.value("Healing Elixir") and
                    variables.lastSoothingMist ~= nil and
                    variables.lastSoothingMist.unit ~= player.unit and
                    not buff.envelopingMist.exists(player.unit)
             then
                if cast.healingElixir() then
                    br.addonDebug(
                        "[Healing Elixir]:" .. UnitName(player.unit) .. " at: " .. round2(player.hp + lowMana, 2) .. "%"
                    )
                    return true
                end
            end
        end

        -- Invoke Yu'lon
        if cast.able.invokeYulonTheJadeSerpent() and cd.invokeYulonTheJadeSerpent.ready() then
            if ui.checked("Invoke Yu'lon") then
                local invokeYulonTargets = ui.value("Invoke Yu'lon targets")
                if friends.lowAllies.invokeYulon >= invokeYulonTargets then
                    if cast.invokeYulonTheJadeSerpent() then
                        br.addonDebug(
                            "[Invoke Yu'lon]: Allies under " ..
                                ui.value("Invoke Yu'lon") .. ": " .. friends.lowAllies.invokeYulon
                        )
                        return true
                    end
                end
            end
        end

        -- Revival on everybody
        if cast.able.revival() and cd.revival.ready() then
            if ui.checked("Revival") then
                local revivalTargets = ui.value("Revival targets")
                if friends.lowAllies.revival >= revivalTargets then
                    if cast.revival() then
                        br.addonDebug(
                            "[Revival]: Allies under " .. ui.value("Revival") .. ": " .. friends.lowAllies.revival
                        )
                        return true
                    end
                end
            end
        end

        -- Life Cocoon on low target ASAP
        if cast.able.lifeCocoon() and cd.lifeCocoon.ready() then
            if ui.checked("Life Cocoon") and friends.lowest.hp + lowMana <= ui.value("Life Cocoon") then
                if cast.lifeCocoon(friends.lowest.unit) then
                    br.addonDebug(
                        "[Life Cocoon]:" ..
                            UnitName(friends.lowest.unit) .. " at: " .. round2(friends.lowest.hp + lowMana, 2) .. "%"
                    )
                    return true
                end
            end
        end

        -- Detox
        if cast.able.detox() and cd.detox.ready() then
            if ui.mode.detox == 1 and not cast.last.detox(1) then
                for i = 1, #friends.range40 do
                    local dispelUnit = friends.range40[i]
                    if
                        canDispel(dispelUnit.unit, spell.detox) and
                            (getLineOfSight(dispelUnit.unit) and getDistance(dispelUnit.unit) <= 40)
                     then
                        if cast.detox(dispelUnit.unit) then
                            br.addonDebug("[Detox]:" .. UnitName(dispelUnit.unit))
                            return true
                        end
                    end
                end
            end
        end

        -- Always cast renewing mist
        if castRenewingMist() then
            return true
        end

        -- Always have jade serpent statue active within 40 yards
        if cast.able.summonJadeSerpentStatue() and cd.summonJadeSerpentStatue.ready() then
            if talent.summonJadeSerpentStatue then
                local distanceToStatue =
                    getDistanceToObject("player", variables.statue.x, variables.statue.y, variables.statue.z)
                if distanceToStatue > 40 then
                    local px, py, pz = GetObjectPosition("player")
                    px = px + math.random(-2, 2)
                    py = py + math.random(-2, 2)
                    if castGroundAtLocation({x = px, y = py, z = pz}, spell.summonJadeSerpentStatue) then
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
        if cast.able.essenceFont() and cd.essenceFont.ready() then
            if ui.checked("Essence Font") then
                local essenceFontTargets = ui.value("Essence Font targets")
                if friends.lowAllies.essenceFont >= essenceFontTargets then
                    if cast.essenceFont() then
                        br.addonDebug(
                            "[Essence Font]: Allies under " ..
                                ui.value("Essence Font") ..
                                    ": " .. friends.lowAllies.essenceFont .. " from " .. essenceFontTargets
                        )
                        return true
                    end
                end
            end
        end

        -- if soothing mist healed unit its full hp, stop the spell
        if
            cast.active.soothingMist() and variables.lastSoothingMist ~= nil and
                variables.lastSoothingMist.hp + lowMana >= 95 and
                variables.lastSoothingMist.unit ~= friends.lowest.unit
         then
            if cast.cancel.soothingMist() then
                br.addonDebug(
                    "CANCELED: [Soothing Mist]: " ..
                        UnitName(variables.lastSoothingMist.unit) ..
                            " at: " .. round2(variables.lastSoothingMist.hp + lowMana, 2) .. "%"
                )
            end
        end

        -- single-target healing
        if cast.able.soothingMist() and cd.soothingMist.ready() then
            if not player.moving and friends.lowest.hp + lowMana <= ui.value("Soothing Mist") then
                if cast.soothingMist(friends.lowest.unit) then
                    br.addonDebug(
                        "[Soothing Mist]: " ..
                            UnitName(friends.lowest.unit) .. " at: " .. round2(friends.lowest.hp + lowMana, 2) .. "%"
                    )
                    variables.lastSoothingMist = {
                        unit = friends.lowest.unit,
                        hp = friends.lowest.hp + lowMana
                    }
                    return true
                end
            end
        end

        if not player.moving and cast.active.soothingMist() and friends.lowest.unit == variables.lastSoothingMist.unit then
            -- expel harm
            if cast.able.expelHarm() and cd.expelHarm.ready() then
                if friends.lowest.hp + lowMana <= ui.value("Soothing Mist - Expel Harm") then
                    if cast.expelHarm() then
                        br.addonDebug(
                            "[Expel Harm]: " ..
                                UnitName(friends.lowest.unit) ..
                                    " at: " .. round2(friends.lowest.hp + lowMana, 2) .. "%"
                        )
                        return true
                    end
                end
            end

            -- enveloping mist
            if cast.able.envelopingMist() and cd.envelopingMist.ready() then
                if
                    not buff.envelopingMist.exists(friends.lowest.unit) and
                        (friends.lowest.hp + lowMana <= ui.value("Soothing Mist - Enveloping Mist") or
                            (friends.lowest.hp + lowMana <= ui.value("Soothing Mist - Enveloping Mist") + 20 and
                                buff.lifeCyclesEnvelopingMist.exists()))
                 then
                    if cast.envelopingMist(friends.lowest.unit) then
                        br.addonDebug(
                            "[Enveloping Mist]: " ..
                                UnitName(friends.lowest.unit) ..
                                    " at: " .. round2(friends.lowest.hp + lowMana, 2) .. "%"
                        )
                        return true
                    end
                end
            end

            -- vivify
            if cast.able.vivify() and cd.vivify.ready() then
                if
                    friends.lowest.hp + lowMana <= ui.value("Soothing Mist - Vivify") and
                        (buff.envelopingMist.remains(friends.lowest.unit) < 2 or friends.lowest.hp <= 50)
                 then
                    if cast.vivify(friends.lowest.unit) then
                        br.addonDebug(
                            "[Vivify]: " ..
                                UnitName(friends.lowest.unit) ..
                                    " at: " .. round2(friends.lowest.hp + lowMana, 2) .. "%"
                        )
                        return true
                    end
                end
            end

            if friends.lowest.hp <= 90 then
                return false -- return false to not cancel soothing mist to dps
            end
        end

        return nil
    end

    local doInterrupt = function()
        if ui.useInterrupt() then
            local startTime = debugprofilestop()
            for i = 1, #enemies.range40 do
                local thisUnit = enemies.range40[i]
                local distance = br.player.unit.distance(thisUnit)
                if br.player.unit.interruptable(thisUnit, ui.value("Interrupt At")) then
                    -- Paralysis
                    if ui.checked("Paralysis") and cast.able.paralysis(thisUnit) and distance < 20 then
                        if cast.paralysis(thisUnit) then
                            ui.debug("[Paralysis] to interrupt: " .. UnitName(thisUnit))
                            return true
                        end
                    end
                    -- Ring of Peace
                    if ui.checked("Ring of Peace") and cast.able.ringOfPeace(thisUnit, "ground") then
                        if cast.ringOfPeace(thisUnit, "ground") then
                            ui.debug("[Ring of Peace] to interrupt: " .. UnitName(thisUnit))
                            return true
                        end
                    end
                    -- Leg Sweep
                    if
                        ui.checked("Leg Sweep") and cast.able.legSweep(thisUnit) and
                            (distance < 5 or (talent.tigerTailSweep and distance < 7))
                     then
                        if cast.legSweep(thisUnit) then
                            ui.debug("[Leg Sweep] to interrupt: " .. UnitName(thisUnit))
                            return true
                        end
                    end
                end
            end
            -- Debugging
            br.debug.cpu:updateDebug(startTime, "rotation.profile.interrupts")
        end -- End Interrupt Check
    end

    br.player.module.BasicHealing()

    if br.player.inCombat and not cast.active.essenceFont() then
        if castWeaponsOfOrder() then
            return true
        end

        -- Fortifying Brew
        if cast.able.fortifyingBrew() and cd.fortifyingBrew.ready() then
            if ui.checked("Fortifying Brew") and player.hp + lowMana <= ui.value("Fortifying Brew") then
                if cast.fortifyingBrew() then
                    br.addonDebug(
                        "[Fortifying Brew]: " ..
                            UnitName(player.unit) .. " at: " .. round2(player.hp + lowMana, 2) .. "%"
                    )
                    return true
                end
            end
        end

        -- Arcane Torrent
        if
            ui.checked("Arcane Torrent") and player.mana <= ui.value("Arcane Torrent") and cast.able.racial() and
                (player.race == "BloodElf")
         then
            if cast.racial() then
                ui.debug("Casting Arcane Torrent [AoE]")
                return true
            end
        end

        if doInterrupt() then
            return true
        end
        local healing = doHealing() -- will return nil if no healing was done
        if healing == true or healing == false then
            return true
        elseif doDamage() then
            return true
        end
        return false
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
