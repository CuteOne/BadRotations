local br = _G["br"]
local rotationName = "Lylo"
local colors = {
    blue    = "|cff4285F4",
    red     = "|cffDB4437",
    yellow  = "|cffF4B400",
    green   = "|cff0F9D58"
}

local variables = {
    lastSoothingMist = nil,
    thunderFocusTea = nil,
    statue = {
        x = 0,
        y = 0,
        z = 0
    },
    sectionValues = {
        renewingMist                    = "Renewing Mist",
        soothingMist                    = "Soothing Mist",
        soothingMistExpelHarm           = "Soothing Mist - Expel Harm",
        soothingMistVivify              = "Soothing Mist - Vivify",
        soothingMistEnvelopingMist      = "Soothing Mist - Enveloping Mist",
        revival                         = "Revival",
        revivalTargets                  = "Revival targets",
        invokeYulon                     = "Invoke Yu'lon",
        invokeYulonTargets              = "Invoke Yu'lon - Targets",
        yulonEnvelopingBreath           = "Yu'lon - Enveloping Breath",
        yulonEnvelopingBreathTargets    = "Yu'lon - Enveloping Breath - Targets",
        healingElixir                   = "Healing Elixir",
        lifeCocoon                      = "Life Cocoon",
        essenceFont                     = "Essence Font",
        essenceFontTargets              = "Essence Font - Targets",
        dpsThreshold                    = "DPS Threshold",
        cracklingJadeLightning          = "Crackling Jade Lightning",
        touchOfDeathMode                = "Touch Of Death Mode",
        weaponsOfOrder                  = "Weapons of Order",
        weaponsOfOrderTargets           = "Weapons of Order - Targets",
        tigersLust                      = "Tiger's Lust",
        fortifyingBrew                  = "Fortifying Brew",
        arcaneTorrent                   = "Arcane Torrent",
        lowManaAt                       = "Low mana at",
        paralysis                       = "Paralysis",
        legSweep                        = "Leg Sweep",
        ringOfPeace                     = "Ring of Peace",
        interruptAt                     = "Interrupt At",
        outOfCombat                     = {
            vivify                      = "OOC - Vivify",
            renewingMist                = "OOC - Renewing Mist",
            essenceFont                 = "OOC - Essence Font",
            essenceFontTargets          = "OOC - Essence Font targets"
        },
        version                         = "1.3.1"
    }
}

local function createToggles()
    InterruptModes = {
        [1] = { mode = "On", value = 1, overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.paralysis },
        [2] = { mode = "Off", value = 2, overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.paralysis }
    }
    CreateButton("Interrupt", 1, 0)
    DPSModes = {
        [1] = { mode = "On", value = 1, overlay = "DPS On", tip = "Auto DPS Enabled", highlight = 1, icon = br.player.spell.tigerPalm },
        [2] = { mode = "Off", value = 2, overlay = "DPS Off", tip = "Auto DPS Disabled", highlight = 0, icon = br.player.spell.tigerPalm }
    }
    CreateButton("DPS", 2, 0)
    ThunderFocusTeaModes = {
        [1] = { mode = "Auto", value = 1, overlay = "Thunder Focus Tea Mode Auto", tip = "Thunder Focus Tea Mode Auto", highlight = 1, icon = br.player.spell.thunderFocusTea },
        [2] = { mode = "EM", value = 2, overlay = "Thunder Focus Tea Mode - Enveloping Mist", tip = "Thunder Focus Tea Mode - Enveloping Mist", highlight = 1, icon = br.player.spell.envelopingMist },
        [3] = { mode = "VVF", value = 3, overlay = "Thunder Focus Tea Mode - Vivify", tip = "Thunder Focus Tea Mode - Vivify", highlight = 1, icon = br.player.spell.vivify },
        [4] = { mode = "RM", value = 4, overlay = "Thunder Focus Tea Mode - Renewing Mist", tip = "Thunder Focus Tea Mode - Renewing Mist", highlight = 1, icon = br.player.spell.renewingMist },
        [5] = { mode = "RSK", value = 5, overlay = "Thunder Focus Tea Mode - Rising Sun Kick", tip = "Thunder Focus Tea Mode - Rising Sun Kick", highlight = 1, icon = br.player.spell.risingSunKick }
    }
    CreateButton("ThunderFocusTea", 3, 0)
    DetoxModes = {
        [1] = { mode = "On", value = 1, overlay = "Detox Enabled", tip = "Detox Enabled", highlight = 1, icon = br.player.spell.detox },
        [2] = { mode = "Off", value = 2, overlay = "Detox Disabled", tip = "Detox Disabled", highlight = 0, icon = br.player.spell.detox }
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
        br.ui:createSpinnerWithout( section,    variables.sectionValues.renewingMist,                 95, 1, 100, 5, "Health percent to cast at "                     .. colors.green .. "(default: 95 - enabled)")
        br.ui:createSpinnerWithout( section,    variables.sectionValues.soothingMist,                 85, 1, 100, 5, "Health percent to cast at "                     .. colors.green .. "(default: 85 - enabled)")
        br.ui:createSpinnerWithout( section,    variables.sectionValues.soothingMistExpelHarm,        80, 1, 100, 5, "Health percent to cast at "                     .. colors.green .. "(default: 80 - enabled)")
        br.ui:createSpinnerWithout( section,    variables.sectionValues.soothingMistVivify,           80, 1, 100, 5, "Health percent to cast at "                     .. colors.green .. "(default: 80 - enabled)")
        br.ui:createSpinnerWithout( section,    variables.sectionValues.soothingMistEnvelopingMist,   65, 1, 100, 5, "Health percent to cast at "                     .. colors.green .. "(default: 65 - enabled)")
        br.ui:createSpinner(        section,    variables.sectionValues.revival,                      40, 1, 100, 5, "Health percent to cast at "                     .. colors.green .. "(default: 40 - enabled)")
        br.ui:createSpinnerWithout( section,    variables.sectionValues.revivalTargets,               2,  1, 50,  1, "Number of hurt people before triggering spell " .. colors.green .. "(default: 02 - enabled)")
        br.ui:createSpinner(        section,    variables.sectionValues.invokeYulon,                  55, 1, 100, 5, "Health percent to cast at "                     .. colors.green .. "(default: 55 - enabled)")
        br.ui:createSpinnerWithout( section,    variables.sectionValues.invokeYulonTargets,           2,  1, 50,  1, "Number of hurt people before triggering spell " .. colors.green .. "(default: 02 - enabled)")
        br.ui:createSpinnerWithout( section,    variables.sectionValues.yulonEnvelopingBreath,        80, 1, 100, 5, "Health percent to cast at "                     .. colors.green .. "(default: 80 - enabled)")
        br.ui:createSpinnerWithout( section,    variables.sectionValues.yulonEnvelopingBreathTargets, 2,  1, 50,  1, "Number of hurt people before triggering spell " .. colors.green .. "(default: 02 - enabled)")
        br.ui:createSpinner(        section,    variables.sectionValues.healingElixir,                85, 1, 100, 5, "Health percent to cast at "                     .. colors.green .. "(default: 85 - enabled)")
        br.ui:createSpinner(        section,    variables.sectionValues.lifeCocoon,                   30, 1, 100, 5, "Health percent to cast at "                     .. colors.green .. "(default: 30 - enabled)")
        br.ui:createSpinner(        section,    variables.sectionValues.essenceFont,                  60, 1, 100, 5, "Health percent to cast at "                     .. colors.green .. "(default: 60 - enabled)")
        br.ui:createSpinnerWithout( section,    variables.sectionValues.essenceFontTargets,           3,  1, 40,  1, "Number of hurt people before triggering spell " .. colors.green .. "(default: 03 - enabled)")
        br.ui:createSpinner(        section,    variables.sectionValues.weaponsOfOrder,               60, 1, 100, 5, "Health percent to cast at "                     .. colors.green .. "(default: 60 - enabled)")
        br.ui:createSpinnerWithout( section,    variables.sectionValues.weaponsOfOrderTargets,        2,  1, 40,  1, "Number of hurt people before triggering spell " .. colors.green .. "(default: 02 - enabled)")
        br.ui:checkSectionState(section)

        section = br.ui:createSection(br.ui.window.profile, "Out Of Combat Heal Options")
        br.ui:createSpinner(        section,    variables.sectionValues.outOfCombat.vivify,             90, 1, 100, 5, "Health percent to cast at "                     .. colors.green .. "(default: 90 - enabled)")
        br.ui:createSpinner(        section,    variables.sectionValues.outOfCombat.renewingMist,       95, 1, 100, 5, "Health percent to cast at "                     .. colors.green .. "(default: 95 - enabled)")
        br.ui:createSpinner(        section,    variables.sectionValues.outOfCombat.essenceFont,        90, 1, 100, 5, "Health percent to cast at "                     .. colors.green .. "(default: 90 - enabled)")
        br.ui:createSpinnerWithout( section,    variables.sectionValues.outOfCombat.essenceFontTargets, 3,  1, 40,  1, "Number of hurt people before triggering spell " .. colors.green .. "(default: 03 - enabled)")
        br.ui:checkSectionState(section)

        section = br.ui:createSection(br.ui.window.profile, "DPS Options")
        br.ui:createSpinnerWithout(     section, variables.sectionValues.dpsThreshold,           85, 1, 100, 5, "Health limit where we focus on getting kicks in " .. colors.green .. "(default: 85 - enabled)")
        br.ui:createCheckbox(           section, variables.sectionValues.cracklingJadeLightning, "Enables" .. "/" .. "Disables " .. "the use of Crackling Jade Lightning ".. colors.green .. "(default: disabled)")
        br.ui:createDropdownWithout(    section, variables.sectionValues.touchOfDeathMode,       {colors.blue .. "Always", colors.green .. "Bosses", colors.red .. "Never"}, 2, "When to use racial ability")
        br.ui:checkSectionState(section)

        section = br.ui:createSection(br.ui.window.profile, "Other Options")
        br.ui:createSpinner(        section, variables.sectionValues.fortifyingBrew,   75, 1, 100, 5,  "Health percent to cast at "            .. colors.green .. "(default: 75 - enabled)")
        br.ui:createSpinner(        section, variables.sectionValues.arcaneTorrent,    80, 1, 100, 5,  "Mana percent to cast at "              .. colors.green .. "(default: 80 - enabled)")
        br.ui:createSpinner(        section, variables.sectionValues.lowManaAt,        60, 1, 100, 5,  "Mana percent to activate this mode "   .. colors.green .. "(default: 60 - enabled)")
        br.ui:createCheckbox(       section, variables.sectionValues.tigersLust      )
        br.player.module.BasicHealing(section)
        br.ui:checkSectionState(section)

        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
        br.ui:createCheckbox(       section, variables.sectionValues.paralysis      )
        br.ui:createCheckbox(       section, variables.sectionValues.legSweep       )
        br.ui:createCheckbox(       section, variables.sectionValues.ringOfPeace    )
        br.ui:createSpinnerWithout( section, variables.sectionValues.interruptAt     , 0, 0, 95, 5, colors.green .. "Cast Percentage to use at.")
        br.ui:checkSectionState(section)

        section = br.ui:createSection(br.ui.window.profile, "Made By: Lylo - Version " .. variables.sectionValues.version)
        br.ui:createText(section, colors.red    .. "Discord contact: " .. colors.green .. "LyLo#0253")
        br.ui:createText(section, colors.red    .. "Required: " .. colors.yellow .. "Healing Engine > HR")
        br.ui:createText(section, colors.blue   .. "Good to have: " .. colors.yellow .. "Enemies Engine > Dynamic Targeting")
        br.ui:createText(section, colors.blue   .. "Good to have: " .. colors.yellow .. "Queue Engine > Smart Queue >")
        br.ui:createText(section, colors.yellow .. "                          Leg Sweep, Ring of Peace")
        br.ui:createText(section, colors.red    .. "FAQ:")
        br.ui:createText(section, colors.blue   .. "  1 - What are the best settings?")
        br.ui:createText(section, colors.green  .. "     Go to Proving Grounds and tweek settings")
        br.ui:createText(section, colors.green  .. "     until you find something you like.")
        br.ui:createText(section, colors.blue   .. "  2 - What talents are supported?")
        br.ui:createText(section, colors.green  .. "     Currently: Mist Wrap, Tigers Lust, Lifecycles, Healing Elixir")
        br.ui:createText(section, colors.green  .. "     Summon Jade Serpent, Rising Mist.")
        br.ui:createText(section, colors.blue   .. "  3 - What covenant abilities are supported?")
        br.ui:createText(section, colors.green  .. "     Currently: Kyrian")
        br.ui:createText(section, colors.green  .. "     get in touch to get support for other covenants.")
        br.ui:createText(section, colors.blue   .. "  4 - How can I request changes?")
        br.ui:createText(section, colors.green  .. "     Send a message on discord.")
        br.ui:createText(section, colors.blue   .. "  5 - Is this good?")
        br.ui:createText(section, colors.green  .. "     I don't know, you tell me")
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



local function runRotation()
    local ui = br.player.ui

    ui.mode.detox = br.data.settings[br.selectedSpec].toggles["Detox"]
    ui.mode.thunderFocusTea = br.data.settings[br.selectedSpec].toggles["ThunderFocusTea"]
    ui.mode.dps = br.data.settings[br.selectedSpec].toggles["DPS"]

    local lowMana = 0

    if ui.checked(variables.sectionValues.lowManaAt) and br.player.power.mana.percent() <= ui.value(variables.sectionValues.lowManaAt) then
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
        essenceFont = getLowAlliesInTable(ui.value(variables.sectionValues.essenceFont) + lowMana, friends.range30),
        essenceFontOoc = getLowAlliesInTable(ui.value(variables.sectionValues.outOfCombat.essenceFont) + lowMana, friends.range30),
        revival = getLowAlliesInTable(ui.value(variables.sectionValues.revival) + lowMana, friends.range40),
        invokeYulon = getLowAlliesInTable(ui.value(variables.sectionValues.invokeYulon) + lowMana, friends.range40),
        weaponsOfOrder = getLowAlliesInTable(ui.value(variables.sectionValues.weaponsOfOrder) + lowMana, friends.range40)
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
        mana = br.player.power.mana.percent(),
        race = br.player.unit.race(),
        isFlying = IsFlying(),
        isMounted = IsMounted(),
        isMoving = isMoving("player"),
        isDrinking = getBuffRemain("player", 308433) > 0
    }
    -- Q
    -- R
    -- S
    local spell = br.player.spell
    -- T
    local talent = br.player.talent
    local tanks = getTanksTable()
    local totemInfo = {
        jadeSerpentStatueDuration = 0,
        yulonDuration = 0
    }

    for index=1,4 do
        local exists, totemName, startTime, duration, _ = GetTotemInfo(index)
        if exists and totemName ~= nil then
            local duration = round2(startTime + duration - GetTime())
            if string.find(totemName, "Jade") then
                totemInfo.jadeSerpentStatueDuration = duration
            elseif string.find(totemName, "Yu'lon") then
                totemInfo.yulonDuration = duration
            end
        end
     end
    -- U
    -- V
    -- X
    -- Z
    -- local functions
     local detailedDebugger = function (msg)
        if false then
            br.addonDebug(msg)
        end
     end

    local castRisingSunKick = function()
        if cd.risingSunKick.ready() and dynamicTarget.range5 ~= nil and cast.able.risingSunKick(dynamicTarget.range5) then
            if cast.risingSunKick(dynamicTarget.range5) then
                br.addonDebug(colors.yellow .. "[Rising Sun Kick]: " .. UnitName(dynamicTarget.range5))
                return true
            else
                br.addonDebug(colors.red .. "[Rising Sun Kick]: Failed")
                return false
            end
        end
    end   

    local castRenewingMist = function(hpThreshhold)
        local renewingMistUnit = nil
        for i = 1, #tanks do
            local tempUnit = tanks[i]
            if not buff.renewingMist.exists(tempUnit.unit) and UnitInRange(tempUnit.unit) and tempUnit.hp + lowMana <= hpThreshhold then
                renewingMistUnit = tempUnit
            end
        end
        if renewingMistUnit == nil then
            for i = 1, #friends.range40 do
                local tempUnit = friends.range40[i]
                if not buff.renewingMist.exists(tempUnit.unit) and UnitInRange(tempUnit.unit) and tempUnit.hp + lowMana <= hpThreshhold then
                    renewingMistUnit = tempUnit
                end
            end
        end
        if renewingMistUnit == nil then
            if not buff.renewingMist.exists(player.unit) and player.hp + lowMana <= hpThreshhold then
                renewingMistUnit = player
            end
        end
        if renewingMistUnit ~= nil and cast.able.renewingMist(renewingMistUnit.unit) then
            if cast.renewingMist(renewingMistUnit.unit) then
                br.addonDebug(colors.green .. "[Renewing Mist]: " .. UnitName(renewingMistUnit.unit) .. " at: " .. round2(renewingMistUnit.hp + lowMana, 2) .. "%" )
                return true
            else
                br.addonDebug(colors.red .. "[Renewing Mist]: Failed")
                return false
            end
        end
    end

    local doDamage = function()
        local doDamageAOE = function()
            -- Spinning Crane Kick
            if cast.able.spinningCraneKick() and cd.spinningCraneKick.ready() then
                if #enemies.range8 > 3 and not cast.active.spinningCraneKick() then
                    if cast.spinningCraneKick() then
                        br.addonDebug(colors.yellow .. "[Spinning Crane Kick]: enemies around: " .. #enemies.range8)
                        return true
                    end
                end
            end
        end

        local doDamage3Targets = function()
            if dynamicTarget.range5 ~= nil and #enemies.range8 == 3 then
                -- Rising Sun Kick on cooldown
                local risingSunKick = castRisingSunKick()
                if risingSunKick == true then
                    return true
                elseif risingSunKick == false then
                    return false
                end
                -- Blackout Kick at any stacks
                if cast.able.blackoutKick() and cd.blackoutKick.ready() and buff.teachingsOfTheMonastery.stack() > 1 then
                    if cast.blackoutKick(dynamicTarget.range5) then
                        br.addonDebug(colors.yellow .. "[Blackout Kick]: " .. UnitName(dynamicTarget.range5))
                        return true
                    end
                end
                -- Spinning Crane Kick
                if
                    cast.able.spinningCraneKick() and cd.spinningCraneKick.ready() and
                        not cast.active.spinningCraneKick()
                 then
                    if cast.spinningCraneKick() then
                        br.addonDebug(colors.yellow .. "[Spinning Crane Kick]: enemies around: " .. #enemies.range8)
                        return true
                    end
                end
            end
        end

        local doDamageST = function()
            if dynamicTarget.range5 ~= nil then
                -- Rising Sun Kick on cooldown
                local risingSunKick = castRisingSunKick()
                if risingSunKick == true then
                    return true
                elseif risingSunKick == false then
                    return false
                end
                -- Blackout Kick at 3 stacks
                if cast.able.blackoutKick() and cd.blackoutKick.ready() and buff.teachingsOfTheMonastery.stack() == 3 then
                    if cast.blackoutKick(dynamicTarget.range5) then
                        br.addonDebug(colors.yellow .. "[Blackout Kick]: " .. UnitName(dynamicTarget.range5))
                        return true
                    end
                end
                -- Tiger Palm
                if cast.able.tigerPalm() and cd.tigerPalm.ready() then
                    if cast.tigerPalm(dynamicTarget.range5) then
                        br.addonDebug(colors.yellow .. "[Tiger Palm]: " .. UnitName(dynamicTarget.range5))
                        return true
                    end
                end
            else
                -- Crackling Jade Lightning
                if
                    ui.checked(variables.sectionValues.cracklingJadeLightning) and cast.able.cracklingJadeLightning() and
                        cd.cracklingJadeLightning.ready()
                 then
                    if dynamicTarget.range40 ~= nil and not player.isMoving then
                        if cast.cracklingJadeLightning(dynamicTarget.range40) then
                            br.addonDebug(colors.yellow .. "[Crackling Jade Lightning]: " .. UnitName(dynamicTarget.range40))
                            return true
                        end
                    end
                end
            end
        end

        if ui.mode.dps == 1 and friends.lowest.hp >= ui.value(variables.sectionValues.dpsThreshold) then --ON
            -- Touch of Death
            local touchOfDeathMode = ui.value(variables.sectionValues.touchOfDeathMode)
            if touchOfDeathMode == 1 or (touchOfDeathMode == 2 and isBoss(dynamicTarget.range5)) then
                if cd.touchOfDeath.ready() and cast.able.touchOfDeath() and dynamicTarget.range5 ~= nil and player.hp > getHP(dynamicTarget.range5) then
                    if cast.touchOfDeath(dynamicTarget.range5) then
                        br.addonDebug(colors.yellow .. "[Touch of Death]: " .. UnitName(dynamicTarget.range5))
                        return true
                    else
                        br.addonDebug(colors.red .. "[Touch of Death]: Failed")
                        return false
                    end
                end
            end


            if doDamageAOE() or doDamage3Targets() or doDamageST() then
                return true
            end
        end
    end

    local doHealing = function()
        detailedDebugger("----INIT : doHealing-----")

        -- AOE Revival
        detailedDebugger("---- AOE Revival : doHealing-----")
        if ui.checked(variables.sectionValues.revival) and cd.revival.ready() and friends.lowAllies.revival >= ui.value(variables.sectionValues.revivalTargets) and cast.able.revival() then
            if cast.revival() then
                br.addonDebug(colors.green .. "[Revival]: Allies under " .. ui.value(variables.sectionValues.revival) .. ": " .. friends.lowAllies.revival)
                return true
            else
                br.addonDebug(colors.red .. "[Revival]: Failed")
                return false
            end
        end
        -- AOE Yulon
        detailedDebugger("---- AOE Yulon : doHealing-----")
        if ui.checked(variables.sectionValues.invokeYulon) and cd.invokeYulonTheJadeSerpent.ready() and friends.lowAllies.invokeYulon >= ui.value(variables.sectionValues.invokeYulonTargets) and cast.able.invokeYulonTheJadeSerpent() then
            if cast.invokeYulonTheJadeSerpent() then
                br.addonDebug(colors.green .. "[Invoke Yu'lon]: Allies under " ..ui.value(variables.sectionValues.invokeYulon) .. ": " .. friends.lowAllies.invokeYulon)
                return true
            else
                br.addonDebug(colors.red .. "[Invoke Yu'lon]: Failed")
                return false
            end
        end
        -- AOE Enveloping Breath
        detailedDebugger("---- AOE Enveloping Breath : doHealing-----")
        if cd.envelopingMist.ready() and totemInfo.yulonDuration > cast.time.envelopingMist() + getLatency() then
            local lowHealthAroundUnit = getUnitsToHealAround(friends.lowest.unit, 7.5, ui.value(variables.sectionValues.yulonEnvelopingBreath), 6)
            if #lowHealthAroundUnit >= ui.value(variables.sectionValues.yulonEnvelopingBreathTargets) and buff.envelopingMist.remains(friends.lowest.unit) < 2 and cast.able.envelopingMist(friends.lowest.unit) then
                if cast.envelopingMist(friends.lowest.unit) then
                    br.addonDebug(colors.green .. "[Enveloping Mist AOE]: " .. UnitName(friends.lowest.unit) .. " at: " .. round2(friends.lowest.hp, 2) .. "%")
                    return true
                else
                    br.addonDebug(colors.red .. "[Enveloping Mist AOE]: Failed")
                    return false
                end
            end
        end

        -- AOE Essence Font
        detailedDebugger("---- AOE Essence Font : doHealing-----")
        if ui.checked(variables.sectionValues.essenceFont) and cd.essenceFont.ready() and friends.lowAllies.essenceFont >= ui.value(variables.sectionValues.essenceFontTargets) and cast.able.essenceFont() then
            if cast.essenceFont() then
                br.addonDebug(colors.green .. "[Essence Font]: Allies under " ..ui.value(variables.sectionValues.essenceFont) .. ": " .. friends.lowAllies.essenceFont)
                return true
            else
                br.addonDebug(colors.red .. "[Essence Font]: Failed")
                return false
            end
        end
        -- AOE Vivify
        detailedDebugger("---- AOE Vivify : doHealing-----")
        if cast.active.soothingMist() and variables.lastSoothingMist and friends.lowest.unit == variables.lastSoothingMist.unit and
            buff.renewingMist.exists(friends.lowest.unit) and friends.lowest.hp + lowMana <= ui.value(variables.sectionValues.soothingMistVivify) and #friends.range40 >= 3
            and ((buff.renewingMist.exists(friends.range40[2].unit) and friends.range40[2].hp + lowMana <= ui.value(variables.sectionValues.soothingMistVivify) + 10 )
            or (buff.renewingMist.exists(friends.range40[3].unit) and friends.range40[3].hp + lowMana <= ui.value(variables.sectionValues.soothingMistVivify) + 10)) and cast.able.vivify(friends.lowest.unit) 
        then
                if cast.vivify(friends.lowest.unit) then
                    br.addonDebug(colors.green .. "[Vivify AOE]: " .. UnitName(friends.lowest.unit) .. " at: " .. round2(friends.lowest.hp, 2) .. "% " .. UnitName(friends.range40[2].unit) .. " at: " .. round2(friends.range40[2].hp, 2) .. "%  " .. UnitName(friends.range40[3].unit) .. " at: " .. round2(friends.range40[3].hp, 2) .. "%")
                    return true
                else
                    br.addonDebug(colors.red .. "[Vivify AOE]: Failed " .. UnitName(friends.lowest.unit) .. " at: " .. round2(friends.lowest.hp, 2) .. "% " .. UnitName(friends.range40[2].unit) .. " at: " .. round2(friends.range40[2].hp, 2) .. "%  " .. UnitName(friends.range40[3].unit) .. " at: " .. round2(friends.range40[3].hp, 2) .. "%")
                    return false
                end
        end
        -- Single Target Healing
        -- ST Life Cocoon
        detailedDebugger("---- ST Life Cocoon : doHealing-----")
        if ui.checked(variables.sectionValues.lifeCocoon) and friends.lowest.hp <= ui.value(variables.sectionValues.lifeCocoon) and cd.lifeCocoon.ready() and cast.able.lifeCocoon() then
            if cast.lifeCocoon(friends.lowest.unit) then
                br.addonDebug(colors.green .. "[Life Cocoon]:" .. UnitName(friends.lowest.unit) .. " at: " .. round2(friends.lowest.hp + lowMana, 2) .. "%")
                return true
            else
                br.addonDebug(colors.red .. "[Life Cocoon]: Failed")
                return false
            end
        end
        -- ST Detox
        detailedDebugger("---- ST Detox : doHealing-----")
        if ui.mode.detox == 1 and cd.detox.ready() and not cast.last.detox(1) and cast.able.detox() then
            for i = 1, #friends.range40 do
                local dispelUnit = friends.range40[i]
                if canDispel(dispelUnit.unit, spell.detox) and (getLineOfSight(dispelUnit.unit) and getDistance(dispelUnit.unit) <= 40) then
                    if cast.detox(dispelUnit.unit) then
                        br.addonDebug(colors.yellow .. "[Detox]:" .. UnitName(dispelUnit.unit))
                        return true
                    else
                        br.addonDebug(colors.red .. "[Detox]: Failed")
                        return false
                    end
                end
            end
        end
        -- ST Healing Elixir
        detailedDebugger("---- ST Healing Elixir : doHealing-----")
        if ui.checked(variables.sectionValues.healingElixir) and cd.healingElixir.ready() and player.hp <= ui.value(variables.sectionValues.healingElixir) and cast.able.healingElixir(player.unit) and (not cast.last.healingElixir(1) and not cast.last.healingElixir(2)) then
            if cast.healingElixir(player.unit) then
                br.addonDebug(colors.green .. "[Healing Elixir]:" .. UnitName(player.unit) .. " at: " .. round2(player.hp + lowMana, 2) .. "%")
                return true
            else
                br.addonDebug(colors.red .. "[Healing Elixir]: Failed")
                return false
            end
        end
        -- REFACTOR TODO
        detailedDebugger("----TFT : doHealing-----")
        if cast.able.thunderFocusTea() and cd.thunderFocusTea.ready() then
            if ui.mode.thunderFocusTea == 1 then -- Auto
                if cast.able.envelopingMist() and getLowAllies(70) < 3 and friends.lowest.hp + lowMana < 50 then -- Enveloping Mist
                    if cast.thunderFocusTea() then
                        br.addonDebug(colors.blue .. "[Thunder Focus Tea]: Enveloping Mist")
                        variables.thunderFocusTea = 2
                        return true
                    end
                elseif player.mana <= 80 and cast.able.vivify() then -- Vivify
                    if cast.thunderFocusTea() then
                        br.addonDebug(colors.blue .. "[Thunder Focus Tea]: Vivify")
                        variables.thunderFocusTea = 3
                        return true
                    end
                elseif cast.able.renewingMist() and getLowAllies(70) > 3 and not talent.risingMist then -- Renewing Mist
                    if cast.thunderFocusTea() then
                        br.addonDebug(colors.blue .. "[Thunder Focus Tea]: Renewing Mist")
                        variables.thunderFocusTea = 4
                        return true
                    end
                elseif
                    cd.risingSunKick.ready() and cast.able.risingSunKick() and dynamicTarget.range5 ~= nil and
                        talent.risingMist or
                        #br.friend == 1
                 then -- Rising Sun Kick
                    if cast.thunderFocusTea() then
                        br.addonDebug(colors.blue .. "[Thunder Focus Tea]: Rising Sun Kick")
                        variables.thunderFocusTea = 5
                        return true
                    end
                else
                    variables.thunderFocusTea = nil
                end
            elseif ui.mode.thunderFocusTea == 2 then -- Enveloping Mist
                if cast.able.envelopingMist() and
                        friends.lowest.hp + lowMana <= ui.value(variables.sectionValues.soothingMistEnvelopingMist) and
                        cast.active.soothingMist() and
                        variables.lastSoothingMist ~= nil and
                        friends.lowest.unit == variables.lastSoothingMist.unit then
                    if cast.thunderFocusTea() then
                        br.addonDebug(colors.blue .. "[Thunder Focus Tea]: Enveloping Mist")
                        return true
                    end
                end
            elseif ui.mode.thunderFocusTea == 3 then -- Vivify
                if
                    cast.able.vivify() and friends.lowest.hp + lowMana <= ui.value(variables.sectionValues.soothingMistVivify) and
                        cast.active.soothingMist() and
                        variables.lastSoothingMist ~= nil and
                        friends.lowest.unit == variables.lastSoothingMist.unit
                 then
                    if cast.thunderFocusTea() then
                        br.addonDebug(colors.blue .. "[Thunder Focus Tea]: Vivify")
                        return true
                    end
                end
            elseif ui.mode.thunderFocusTea == 4 then -- Renewing Mist
                if cast.able.renewingMist() then
                    if cast.thunderFocusTea() then
                        br.addonDebug(colors.blue .. "[Thunder Focus Tea]: Renewing Mist")
                        return true
                    end
                end
            elseif ui.mode.thunderFocusTea == 5 then -- Rising Sun Kick
                if dynamicTarget.range5 ~= nil and cast.able.risingSunKick() then
                    if cast.thunderFocusTea() then
                        br.addonDebug(colors.blue .. "[Thunder Focus Tea]: Rising Sun Kick")
                        return true
                    end
                end
            end
        elseif lastSpellCast == spell.thunderFocusTea and buff.thunderFocusTea.exists() then
            if ui.mode.thunderFocusTea == 2 or variables.thunderFocusTea == 2 then -- Enveloping Mist
                if cast.able.envelopingMist(friends.lowest.unit) and cd.envelopingMist.ready() and cast.envelopingMist(friends.lowest.unit) then
                    br.addonDebug(colors.green .. "[Enveloping Mist TFT]: " .. UnitName(friends.lowest.unit) .. " at: " .. round2(friends.lowest.hp + lowMana, 2) .. "%")
                    variables.thunderFocusTea = nil
                    return true
                end
            elseif ui.mode.thunderFocusTea == 3 or variables.thunderFocusTea == 3 and cd.vivify.ready() and cast.able.vivify(friends.lowest.unit) then -- Vivify
                if  cast.vivify(friends.lowest.unit) then
                    br.addonDebug(colors.green .. "[Vivify TFT]: " ..UnitName(friends.lowest.unit) .. " at: " .. round2(friends.lowest.hp + lowMana, 2) .. "%")
                    variables.thunderFocusTea = nil
                    return true
                else
                    br.addonDebug(colors.red .. "[Vivify TFT]: Failed")
                end
            elseif ui.mode.thunderFocusTea == 4 or variables.thunderFocusTea == 4 then -- Renewing Mist
                if castRenewingMist(ui.value(variables.sectionValues.renewingMist)) then
                    variables.thunderFocusTea = nil
                    return true
                end
            elseif ui.mode.thunderFocusTea == 5 or variables.thunderFocusTea == 5 then -- Rising Sun Kick
                local risingSunKick = castRisingSunKick()
                if risingSunKick == true then
                    variables.thunderFocusTea = nil
                    return true
                elseif risingSunKick == false then
                    return false
                end
            end
            br.addonDebug(colors.red .. "[TFT]: Failed")
            return false
        end
        -- TALENT Rising Sun Kick
        detailedDebugger("----TALENT Rising Sun Kick : doHealing-----")
        if dynamicTarget.range5 ~= nil and cd.risingSunKick.ready() and talent.risingMist and cast.able.risingSunKick(dynamicTarget.range5) then
            if cast.last.essenceFont(1) or cast.last.envelopingMist(1) or (cast.last.thunderFocusTea(2) and cast.last.risingSunKick(1)) then
                local risingSunKick = castRisingSunKick()
                if risingSunKick == true then
                    return true
                elseif risingSunKick == false then
                    return false
                end
            end
        end
        detailedDebugger("----ST Renewing Mist : doHealing-----")
        -- ST Renewing Mist
        local renewingMist = castRenewingMist(ui.value(variables.sectionValues.renewingMist))
        if renewingMist == true or renewingMist == false then
            return true
        end
        detailedDebugger("----TALENT Summon Jade Serpent Statue : doHealing-----")
        -- TALENT Summon Jade Serpent Statue
        if talent.summonJadeSerpentStatue and cd.summonJadeSerpentStatue.ready() and cast.able.summonJadeSerpentStatue() then
            local distanceToStatue = getDistanceToObject("player", variables.statue.x, variables.statue.y, variables.statue.z)
            if distanceToStatue > 40 or totemInfo.jadeSerpentStatueDuration <= 5 then
                local px, py, pz = GetObjectPosition("player")
                px = px + math.random(-2, 2)
                py = py + math.random(-2, 2)
                if castGroundAtLocation({x = px, y = py, z = pz}, spell.summonJadeSerpentStatue) then
                    variables.statue = {
                        x = px,
                        y = py,
                        z = pz
                    }
                    br.addonDebug(colors.yellow .. "[Jade Serpent Statue]: distance to statue: " .. distanceToStatue .. ", old totem duration: " .. totemInfo.jadeSerpentStatueDuration)
                    return true
                end
            end
        end
        detailedDebugger("----CANCEL Soothing Mist : doHealing-----")
        -- CANCEL Soothing Mist
        if cast.active.soothingMist() and variables.lastSoothingMist ~= nil and variables.lastSoothingMist.hp + lowMana >= 95 and variables.lastSoothingMist.unit == friends.lowest.unit then
            if cast.cancel.soothingMist() then
                br.addonDebug(colors.red .. "CANCELED: [Soothing Mist]: " .. UnitName(variables.lastSoothingMist.unit) .. " at: " .. round2(variables.lastSoothingMist.hp + lowMana, 2) .. "%" )
            end
        end
        detailedDebugger("----ST Soothing Mist : doHealing-----")
        -- ST Soothing Mist
        if cd.soothingMist.ready() and not player.isMoving and friends.lowest.hp + lowMana <= ui.value(variables.sectionValues.soothingMist) and cast.able.soothingMist() then
            if cast.soothingMist(friends.lowest.unit) then
                variables.lastSoothingMist = {
                    unit = friends.lowest.unit,
                    hp = friends.lowest.hp + lowMana
                }
                br.addonDebug(colors.green .. "[Soothing Mist]: " .. UnitName(friends.lowest.unit) .. " at: " .. round2(friends.lowest.hp + lowMana, 2) .. "%" )
                return true
            else
                br.addonDebug(colors.red .. "[Soothing Mist]: Failed")
                return false
            end
        end
        detailedDebugger("----ST Soothing Mist Insta Casts : doHealing-----")
        -- ST Soothing Mist Insta Casts
        if not player.isMoving and cast.active.soothingMist() and friends.lowest.unit == variables.lastSoothingMist.unit then
            -- ST Expel Harm
            if  cd.expelHarm.ready() and friends.lowest.hp + lowMana <= ui.value(variables.sectionValues.soothingMistExpelHarm) and cast.able.expelHarm() then
                if cast.expelHarm("player") then
                    br.addonDebug(colors.green .. "[Expel Harm]: " .. UnitName(friends.lowest.unit) .. " at: " .. round2(friends.lowest.hp + lowMana, 2) .. "%" )
                    return true
                else
                    br.addonDebug(colors.red .. "[Expel Harm]: Failed")
                    return false
                end
            end
            -- ST Enveloping Mist
            if cd.envelopingMist.ready() and buff.envelopingMist.remains(friends.lowest.unit) < 2 and (friends.lowest.hp + lowMana <= ui.value(variables.sectionValues.soothingMistEnvelopingMist) or (friends.lowest.hp + lowMana <= ui.value(variables.sectionValues.soothingMistEnvelopingMist) + 10 and buff.lifeCyclesEnvelopingMist.exists())) and cast.able.envelopingMist() then
                if cast.envelopingMist(friends.lowest.unit) then
                    br.addonDebug(colors.green .. "[Enveloping Mist]: " .. UnitName(friends.lowest.unit) .. " at: " .. round2(friends.lowest.hp + lowMana, 2) .. "%" )
                    return true
                else
                    br.addonDebug(colors.red .. "[Enveloping Mist]: Failed")
                    return false
                end
            end
            -- ST Vivify
            if cd.vivify.ready() and friends.lowest.hp + lowMana <= ui.value(variables.sectionValues.soothingMistVivify) and (buff.envelopingMist.remains(friends.lowest.unit) < 2 or friends.lowest.hp <= 50) and cast.able.vivify() then
                if cast.vivify(friends.lowest.unit) then
                    br.addonDebug(colors.green .. "[Vivify]: " .. UnitName(friends.lowest.unit) .. " at: " .. round2(friends.lowest.hp + lowMana, 2) .. "%")
                    return true
                else
                    br.addonDebug(colors.red .. "[Vivify]: Failed")
                    return false
                end
            end

            if friends.lowest.hp <= 90 then
                br.addonDebug("[Soothing Mist]: Continue")
                return false -- return false to not cancel soothing mist to dps
            end
        end

        detailedDebugger("----END : doHealing-----")
        return nil
    end

    local doHealingOutOfCombat = function()
        detailedDebugger("----INIT : doHealingOutOfCombat-----")
        detailedDebugger("---- OOC AOE Essence Font : doHealingOutOfCombat-----")
        if ui.checked(variables.sectionValues.outOfCombat.essenceFont) and cd.essenceFont.ready() and friends.lowAllies.essenceFontOoc >= ui.value(variables.sectionValues.outOfCombat.essenceFontTargets) and cast.able.essenceFont() then
            if cast.essenceFont() then
                br.addonDebug(colors.green .. "[OOC Essence Font]: Allies under " ..ui.value(variables.sectionValues.outOfCombat.essenceFont) .. ": " .. ui.value(variables.sectionValues.outOfCombat.essenceFontTargets))
                return true
            else
                br.addonDebug(colors.red .. "[OOC Essence Font]: Failed")
                return false
            end
        end
        detailedDebugger("----OOC ST Renewing Mist : doHealingOutOfCombat-----")
        if ui.checked(variables.sectionValues.outOfCombat.renewingMist) then
            local renewingMist = castRenewingMist(ui.value(variables.sectionValues.outOfCombat.renewingMist))
            if renewingMist == true or renewingMist == false then
                return true
            end
        end
        detailedDebugger("----OOC ST Vivify : doHealingOutOfCombat-----")
        if ui.checked(variables.sectionValues.outOfCombat.vivify) and cd.vivify.ready() and friends.lowest.hp + lowMana <= ui.value(variables.sectionValues.outOfCombat.vivify)
            and buff.envelopingMist.remains(friends.lowest.unit) < 2 and cast.able.vivify() 
        then
            if cast.vivify(friends.lowest.unit) then
                br.addonDebug(colors.green .. "[Vivify]: " .. UnitName(friends.lowest.unit) .. " at: " .. round2(friends.lowest.hp + lowMana, 2) .. "%")
                return true
            else
                br.addonDebug(colors.red .. "[Vivify]: Failed")
                return false
            end
        end
        detailedDebugger("----END : doHealingOutOfCombat-----")
    end

    local doInterrupt = function()
        if ui.useInterrupt() then
            local startTime = debugprofilestop()
            for i = 1, #enemies.range40 do
                local thisUnit = enemies.range40[i]
                local distance = br.player.unit.distance(thisUnit)
                if br.player.unit.interruptable(thisUnit, ui.value(variables.sectionValues.interruptAt)) then
                    -- Paralysis
                    if ui.checked(variables.sectionValues.paralysis) and cast.able.paralysis(thisUnit) and distance < 20 then
                        if cast.paralysis(thisUnit) then
                            ui.debug("[Paralysis] to interrupt: " .. UnitName(thisUnit))
                            return true
                        end
                    end
                    -- Ring of Peace
                    if ui.checked(variables.sectionValues.ringOfPeace) and cast.able.ringOfPeace(thisUnit, "ground") then
                        if cast.ringOfPeace(thisUnit, "ground") then
                            ui.debug("[Ring of Peace] to interrupt: " .. UnitName(thisUnit))
                            return true
                        end
                    end
                    -- Leg Sweep
                    if
                        ui.checked(variables.sectionValues.legSweep) and cast.able.legSweep(thisUnit) and
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

    if pause(true) or player.isMounted or player.isFlying or player.isDrinking then
        return true
    end

    br.player.module.BasicHealing()

    if br.player.inCombat and not cast.active.essenceFont() then
        -- Weapons of order
        if ui.checked(variables.sectionValues.weaponsOfOrder) and cd.weaponsOfOrder.ready() and friends.lowAllies.weaponsOfOrder >= ui.value(variables.sectionValues.weaponsOfOrderTargets) and cast.able.weaponsOfOrder() then
            if cast.weaponsOfOrder() then
                br.addonDebug(colors.green .. "[Weapons of Order]: Allies under " .. ui.value(variables.sectionValues.weaponsOfOrder) .. ": " .. friends.lowAllies.weaponsOfOrder)
                return true
            else
                br.addonDebug(colors.red .. "[Weapons of Order]: Failed")
                return false
            end
        end

        -- Fortifying Brew
        if cast.able.fortifyingBrew() and cd.fortifyingBrew.ready() then
            if ui.checked(variables.sectionValues.fortifyingBrew) and player.hp + lowMana <= ui.value(variables.sectionValues.fortifyingBrew) then
                if cast.fortifyingBrew() then
                    br.addonDebug(colors.yellow .. "[Fortifying Brew]: " ..UnitName(player.unit) .. " at: " .. round2(player.hp + lowMana, 2) .. "%")
                    return true
                end
            end
        end

        -- Arcane Torrent
        if ui.checked(variables.sectionValues.arcaneTorrent) and player.mana <= ui.value(variables.sectionValues.arcaneTorrent) and cast.able.racial() and player.race == "BloodElf" and dynamicTarget.range5 ~= nil then
            if cast.racial("player") then
                br.addonDebug(colors.blue .. "Casting Arcane Torrent [AoE]")
                return true
            end
        end

        -- Tiger's Lust
        if ui.checked(variables.sectionValues.tigersLust) and talent.tigersLust then
            for i = 1, #friends.range40 do
                local tempUnit = friends.range40[i]
                if cast.noControl.tigersLust(tempUnit.unit) then
                    if cast.tigersLust() then 
                        ui.debug("[Tiger's Lust]: on" .. UnitName(tempUnit.unit)) 
                        return true 
                    else
                        br.addonDebug(colors.red .. "[Tiger's Lust]: Failed")
                        return false
                    end
                end
            end
        end


        local healing = doHealing() -- will return nil if no healing was done
        if healing == true or healing == false then
            return true
        end
        if doInterrupt() then
            return true
        end
        if doDamage() then
            return true
        end
        return false

    elseif not br.player.inCombat then
        if doHealingOutOfCombat() then
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
