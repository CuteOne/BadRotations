local rotationName = "LyLo-v2"

local Toggles = {}
---------------
--- Toggles ---
---------------
local function createToggles()
    local RotationModes = {
        [1] = {
            mode = "Auto",
            value = 1,
            overlay = "Automatic Rotation",
            tip = "Swaps between Single and Multiple based on number of #enemies.yards8 in range.",
            highlight = 1,
            icon = br.player.spell.spinningCraneKick
        },
        [2] = {
            mode = "Mult",
            value = 2,
            overlay = "Multiple Target Rotation",
            tip = "Multiple target rotation used.",
            highlight = 1,
            icon = br.player.spell.fistsOfFury
        },
        [3] = {
            mode = "Sing",
            value = 3,
            overlay = "Single Target Rotation",
            tip = "Single target rotation used.",
            highlight = 1,
            icon = br.player.spell.tigerPalm
        }
    };
    br.ui:createToggle(RotationModes, "Rotation", 1, 0)
    Toggles.RotationModes = {
        Auto = function()
            return br.data.settings[br.selectedSpec].toggles["Rotation"] == 1
        end,
        Multi = function()
            return br.data.settings[br.selectedSpec].toggles["Rotation"] == 2
        end,
        Sing = function()
            return br.data.settings[br.selectedSpec].toggles["Rotation"] == 3
        end
    }
    --------------------------------------------------------------
    local BurstModes = {
        [1] = {
            mode = "Off",
            value = 1,
            overlay = "Not Using Full Burst",
            tip = "Full burst not queued",
            highlight = 0,
            icon = 132311
        },
        [2] = {
            mode = "Full",
            value = 2,
            overlay = "Will use Full Burst",
            tip = "Xuen + SEF + Bonedust Brew",
            highlight = 1,
            icon = br.player.spell.invokeXuenTheWhiteTiger
        },
        [3] = {
            mode = "Mini",
            value = 3,
            overlay = "Will use Mini Burst",
            tip = "SEF + Bonedust Brew",
            highlight = 1,
            icon = br.player.spell.stormEarthAndFire
        }
    };
    br.ui:createToggle(BurstModes, "Burst", 0, 1)
    Toggles.BurstModes = {
        Full = function()
            return br.data.settings[br.selectedSpec].toggles["Burst"] == 2
        end,
        Mini = function()
            return br.data.settings[br.selectedSpec].toggles["Burst"] == 3
        end,
        SetOff = function() br._G.RunMacroText("/br toggle Burst 1") end
    }
    --------------------------------------------------------------
    local CooldownModes = {
        [1] = {
            mode = "On",
            value = 1,
            overlay = "Cooldowns Enabled",
            tip = "Automatic Cooldowns",
            highlight = 1,
            icon = br.player.spell.invokeXuenTheWhiteTiger
        },
        [2] = {
            mode = "Off",
            value = 2,
            overlay = "Cooldowns Disabled",
            tip = "No Cooldowns will be used.",
            highlight = 0,
            icon = 132311
        }
    };
    br.ui:createToggle(CooldownModes, "Cooldown", 2, 0)
    Toggles.CooldownModes = {
        On = function()
            return br.data.settings[br.selectedSpec].toggles["Cooldown"] == 1
        end,
        Off = function()
            return br.data.settings[br.selectedSpec].toggles["Cooldown"] == 2
        end
    }
    --------------------------------------------------------------
    local DefensiveModes = {
        [1] = {
            mode = "On",
            value = 1,
            overlay = "Defensive Enabled",
            tip = "Includes Defensive Cooldowns.",
            highlight = 1,
            icon = br.player.spell.fortifyingBrew
        },
        [2] = {
            mode = "Off",
            value = 2,
            overlay = "Defensive Disabled",
            tip = "No Defensives will be used.",
            highlight = 0,
            icon = 132311
        }
    };
    br.ui:createToggle(DefensiveModes, "Defensive", 3, 0)
    Toggles.DefensiveModes = {
        On = function()
            return br.data.settings[br.selectedSpec].toggles["Defensive"] == 1
        end,
        Off = function()
            return br.data.settings[br.selectedSpec].toggles["Defensive"] == 2
        end
    }
    --------------------------------------------------------------
    local InterruptModes = {
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
            icon = 132311
        }
    };
    br.ui:createToggle(InterruptModes, "Interrupt", 4, 0)
    Toggles.InterruptModes = {
        On = function()
            return br.data.settings[br.selectedSpec].toggles["Interrupt"] == 1
        end,
        Off = function()
            return br.data.settings[br.selectedSpec].toggles["Interrupt"] == 2
        end
    }
end

local Colors = {
    PinkLavander = "|cff" .. "CDB4DB",
    OrchidPink = "|cff" .. "ffc8dd",
    NadeshikoPink = "|cff" .. "ffafcc",
    UranianBlue = "|cff" .. "bde0fe",
    BabyBlueEyes = "|cff" .. "a2d2ff",

    Monk = "|cff" .. "00FF98",
    Poor = "|cff" .. "9d9d9d",
    Common = "|cff" .. "ffffff",
    Uncommon = "|cff" .. "1eff00",
    Rare = "|cff" .. "0070dd",
    Epic = "|cff" .. "a335ee",
    Legendary = "|cff" .. "ff8000",
    Artifact = "|cff" .. "e6cc80",
    Heirloom = "|cff" .. "00ccff",
    Error = "|cff" .. "FF5252",
    Success = "|cff" .. "4CAF50",
    Warning = "|cff" .. "FFC107"
}

---------------
--- OPTIONS ---
---------------
local Options
local function createOptions()

    ---@param Page string
    ---@param Title string
    ---@param Check table
    ---@param Value table
    ---@param Value2 table
    ---@param Select table
    ---@param Select2 table
    local function AddOption(Page, Title, Check, Value, Value2, Select, Select2)
        local function indexOf(array, value)
            for i, v in ipairs(array) do
                if v == value then return i end
            end
            return nil
        end

        -- if Options[Page][Title] then
        --    Options[Page][Title] = nil
        -- end
        -- local ThePage = br.ui:createSection(br.ui.window.profile, Page)
        local ThePage = Options[Page] or
                            br.ui:createSection(br.ui.window.profile, Page)
        Options[Page] = ThePage
        if Check and not Value and not Select2 and not Select then
            br.ui:createCheckbox(ThePage, Title, Check.Tooltip, Check.Default)
        elseif Check and Value and Value2 then
            -- min,max,step,number,tooltip
            br.ui:createDoubleSpinner(ThePage, Title, {
                min = Value.Min,
                max = Value.Max,
                step = Value.Step,
                number = Value.Default,
                tooltip = Value.Tooltip
            }, {
                min = Value2.Min,
                max = Value2.Max,
                step = Value2.Step,
                number = Value2.Default,
                tooltip = Value2.Tooltip
            }, false)
        elseif Check and Value and not Select2 then
            br.ui:createSpinner(ThePage, Title, Value.Default, Value.Min,
                                Value.Max, Value.Step, Check.Tooltip,
                                Value.Tooltip)
        elseif not Check and Value and not Select2 then
            br.ui:createSpinnerWithout(ThePage, Title, Value.Default, Value.Min,
                                       Value.Max, Value.Step, nil, Value.Tooltip)
        elseif not Check and not Value and Select then
            br.ui:createDropdownWithout(ThePage, Title, Select.Options,
                                        indexOf(Select.Options, Select.Default),
                                        Select.Tooltip)
        elseif not Check and not Value and Select2 then
            br.ui:createDropdownWithout(ThePage, Title, Select2.Options,
                                        indexOf(Select2.Options, Select2.Default),
                                        Select2.Tooltip)
        elseif not Check and Value and Select2 then
            br.ui:createSpinnerWithDropdown(ThePage, Title, {
                min = Value.Min,
                max = Value.Max,
                step = Value.Step,
                number = Value.Default,
                tooltip = Value.Tooltip
            }, {
                itemlist = Select2.Options,
                default = indexOf(Select2.Options, Select2.Default),
                tooltip = Select2.Tooltip,
                tooltipDrop = Select2.Tooltip
            }, true)
        elseif Check and Select then
            br.ui:createDropdown(ThePage, Title, Select.Options,
                                 indexOf(Select.Options, Select.Default),
                                 Check.Tooltip, Select.Tooltip)
        else
            br.ui:createText(ThePage, Title)
        end
        br.ui:checkSectionState(ThePage)

        local ReturnOption = {}
        function ReturnOption:Checked()
            return
                br.data.settings[br.selectedSpec][br.selectedProfile][Title ..
                    "Check"] or false
        end
        function ReturnOption:Value()
            return
                br.data.settings[br.selectedSpec][br.selectedProfile][Title ..
                    "Status"] or
                    br.data.settings[br.selectedSpec][br.selectedProfile][Title ..
                        "1Status"]
        end
        function ReturnOption:Value2()
            return
                br.data.settings[br.selectedSpec][br.selectedProfile][Title ..
                    "2Status"]
        end
        function ReturnOption:Select()
            return
                Select.Options[br.data.settings[br.selectedSpec][br.selectedProfile][Title ..
                    "Drop"]]
        end
        function ReturnOption:Select2()
            return
                Select.Options[br.data.settings[br.selectedSpec][br.selectedProfile][Title ..
                    "2Drop"]]
        end
        function ReturnOption:Toggled()
            if not br._G.GetCurrentKeyBoardFocus() then
                if self:Select() == "LeftCtrl" then
                    return br._G.IsLeftControlKeyDown()
                elseif self:Select() == "LeftShift" then
                    return br._G.IsLeftShiftKeyDown()
                elseif self:Select() == "RightCtrl" then
                    return br._G.IsRightControlKeyDown()
                elseif self:Select() == "RightShift" then
                    return br._G.IsRightShiftKeyDown()
                elseif self:Select() == "RightAlt" then
                    return br._G.IsRightAltKeyDown()
                elseif self:Select() == "None" then
                    return false
                elseif self:Select() == "MMouse" then
                    return br._G.GetKeyState(0x04) and true or false
                elseif self:Select() == "Mouse4" then
                    return br._G.GetKeyState(0x05) and true or false
                elseif self:Select() == "Mouse5" then
                    return br._G.GetKeyState(0x06) and true or false
                end
            end
            return false
        end
        return ReturnOption
    end

    local optionTable

    local function rotationOptions()
        Options = {}
        local Page = "Manual Options"
        Options.ManualRingOfPeace = AddOption(Page, "- Ring of Peace", {
            Default = true,
            Tooltip = "Enable this manual spell"
        }, nil, nil, {
            Default = "None",
            Options = br.dropOptions.Toggle,
            Tooltip = "Select key to bind with this auto use"
        })

        Page = tostring(Colors.Monk) .. "CD Manager"
        AddOption(Page, tostring(Colors.Artifact) .. "Covenant")
        Options.Covenant = AddOption(Page, tostring(Colors.NadeshikoPink) ..
                                         "Covenant Spell", {
            Default = true,
            Tooltip = "Enable auto usage"
        })
        -- Options.BossCovenant = AddOption(
        --        Page,
        --        "- Boss: Covenant Spell",
        --        nil,
        --        { Default = 1, Min = 1, Max = 20, Step = 1, Tooltip = "Number of units" },
        --        nil,
        --        nil,
        --        { Default = "CD", Options = { "Always", "CD" }, Tooltip = "Preferred mode" }
        -- )
        -- Options.TrashCovenant = AddOption(
        --        Page,
        --        "- Trash: Covenant Spell",
        --        nil,
        --        {
        --            Default = 2,
        --            Min = 1,
        --            Max = 20,
        --            Step = 0.5,
        --            Tooltip = "Minimum remaining Health of all units | 1 = 100k"
        --        },
        --        nil,
        --        nil,
        --        { Default = "CD", Options = { "Always", "CD" }, Tooltip = "Preferred mode" }
        -- )
        AddOption(Page, tostring(Colors.Monk) .. "Monk Spells")
        -- Options.InvokeXuen = AddOption(
        --        Page,
        --        tostring(Colors.NadeshikoPink) .. "Invoke Xuen",
        --        { Default = true, Tooltip = "Enable auto usage" }
        -- )
        -- Options.BossInvokeXuen = AddOption(
        --        Page,
        --        "- Boss: Xuen",
        --        nil,
        --        { Default = 1, Min = 1, Max = 20, Step = 1, Tooltip = "Number of units" },
        --        nil,
        --        nil,
        --        { Default = "CD", Options = { "Always", "CD" }, Tooltip = "Preferred mode" }
        -- )
        -- Options.TrashInvokeXuen = AddOption(
        --        Page,
        --        "- Trash: Xuen",
        --        nil,
        --        {
        --            Default = 2,
        --            Min = 1,
        --            Max = 20,
        --            Step = 0.5,
        --            Tooltip = "Minimum remaining Health of all units | 1 = 100k"
        --        },
        --        nil,
        --        nil,
        --        { Default = "CD", Options = { "Always", "CD" }, Tooltip = "Preferred mode" }
        -- )
        Options.StormEarthFire = AddOption(Page,
                                           tostring(Colors.NadeshikoPink) ..
                                               "Storm, Earth, and Fire", {
            Default = true,
            Tooltip = "Enable auto usage"
        })
        -- Options.BossStormEarthFire = AddOption(
        --        Page,
        --        "- Boss: SEF",
        --        nil,
        --        { Default = 1, Min = 1, Max = 20, Step = 1, Tooltip = "Number of units" },
        --        nil,
        --        nil,
        --        { Default = "CD", Options = { "Always", "CD" }, Tooltip = "Preferred mode" }
        -- )
        Options.TrashStormEarthFire = AddOption(Page, "- Trash: SEF", {
            Default = true,
            Tooltip = "Enable this manual spell"
        }, {
            Default = 2,
            Min = 1,
            Max = 20,
            Step = 1,
            Tooltip = "Number of units"
        }, {
            Default = 10,
            Min = 1,
            Max = 100,
            Step = 1,
            Tooltip = "Min health of each unit | 1 = 10k"
        }, nil, nil)
        Options.TouchOfDeath = AddOption(Page,
                                         tostring(Colors.NadeshikoPink) ..
                                             "Touch of Death", {
            Default = true,
            Tooltip = "Enable auto usage"
        })
        -- Options.BossTouchOfDeath = AddOption(
        --        Page,
        --        "- Boss: ToD",
        --        nil,
        --        nil,
        --        nil,
        --        { Default = "Always", Options = { "Always", "CD" }, Tooltip = "Preferred mode" }
        -- )
        -- Options.TrashTouchOfDeath = AddOption(
        --        Page,
        --        "- Trash: ToD",
        --        nil,
        --        nil,
        --        nil,
        --        { Default = "CD", Options = { "Always", "CD" }, Tooltip = "Preferred mode" }
        -- )
        Options.TrashTouchOfDeathLife = AddOption(Page, "- Trash: ToD - MaxHP",
                                                  {
            Default = true,
            Tooltip = "Enable this manual spell"
        }, {
            Default = 50,
            Min = 1,
            Max = 5000,
            Step = 1,
            Tooltip = "Max Health of enemy (in thousands) | 10 = 10k"
        })

        Page = tostring(Colors.Monk) .. "Defensive"
        AddOption(Page, "General")
        Options.Healthstone = AddOption(Page, "- Healthstone", {
            Default = true,
            Tooltip = "Auto usage of Healthstone"
        }, {
            Default = 30,
            Min = 1,
            Max = 100,
            Step = 1,
            Tooltip = "Health % to use"
        })
        AddOption(Page, tostring(Colors.Monk) .. "Monk Spells")
        Options.TouchOfKarma = AddOption(Page, "- Touch Of Karma", {
            Default = true,
            Tooltip = "Auto usage of Touch Of Karma"
        }, {
            Default = 70,
            Min = 1,
            Max = 100,
            Step = 1,
            Tooltip = "Health % to use"
        })
        Options.DampenHarm = AddOption(Page, "- Dampen Harm", {
            Default = true,
            Tooltip = "Auto usage of Dampen Harm"
        }, {
            Default = 40,
            Min = 1,
            Max = 100,
            Step = 1,
            Tooltip = "Health % to use"
        })
        Options.DiffuseMagic = AddOption(Page, "- Diffuse Magic", {
            Default = true,
            Tooltip = "Auto usage of Diffuse Magic"
        }, {
            Default = 40,
            Min = 1,
            Max = 100,
            Step = 1,
            Tooltip = "Health % to use"
        })
        Options.FortifyingBrew = AddOption(Page, "- Fortifying Brew", {
            Default = true,
            Tooltip = "Auto usage of Fortifying Brew"
        }, {
            Default = 30,
            Min = 1,
            Max = 100,
            Step = 1,
            Tooltip = "Health % to use"
        })
        Page = tostring(Colors.Monk) .. "Interrupt"
        Options.InterruptAt = AddOption(Page, "**Interrupt at %", nil, {
            Default = 80,
            Min = 1,
            Max = 100,
            Step = 1,
            Tooltip = "Interrupt at"
        })
        Options.LegSweep = AddOption(Page, tostring(Colors.BabyBlueEyes) ..
                                         "Leg Sweep", {
            Default = false,
            Tooltip = "Use This Spell"
        })
        Options.SpearHandStrike = AddOption(Page,
                                            tostring(Colors.BabyBlueEyes) ..
                                                "Spear Hand Strike", {
            Default = false,
            Tooltip = "Use This Spell"
        })
        Options.Paralysis = AddOption(Page, tostring(Colors.BabyBlueEyes) ..
                                          "Paralysis", {
            Default = false,
            Tooltip = "Use This Spell"
        })

        Page = tostring(Colors.Monk) .. "Extra"
        AddOption(Page, "Use the following macros")
        AddOption(Page, Colors.Success .. "Full Burst")
        AddOption(Page,
                  Colors.Poor .. "#showtooltip Invoke Xuen, the White Tiger")
        AddOption(Page, Colors.Legendary .. "/br toggle Burst 2")
        AddOption(Page, Colors.Success .. "Mini Burst")
        AddOption(Page, Colors.Poor .. "#showtooltip Bonedust Brew")
        AddOption(Page, Colors.Legendary .. "/br toggle Burst 3")
        Page = tostring(Colors.Monk) .. "Dev"
        Options.Debug = AddOption(Page, "Debug",
                                  {Default = false, Tooltip = "Enable Debug"})

    end
    optionTable = {{[1] = "Rotation Options", [2] = rotationOptions}}
    return optionTable
end

-----------------
--- VARIABLES ---
-----------------
local buff
local cast
local cd
local charges
local chi
local chiMax
local energy
local energyTimeToMax
local enemies
local equipped
local health
local module
local player
local spell
local target
local markOfTheCraneCount
local lowestMoK
local lowestMoKRemains
local talent
local ui
local unit
local units
local use
local xuenExists
local xuenHold
local fofExecute
local rskDuration

local bossEncounter
local trashStormEarthFireCondition

local instanceID

local DromanOulfarran
local IngraMaloch
local IllusionaryVulpin
local IllusionaryClone
local Mistcaller

local counter

local exists, totemName, startTime, duration, _

local findEnemyById = function(id)
    local enemy = _G.foreach(enemies.yards20, function(index, enemyGUID)
        if unit.id(enemyGUID) == id then return enemyGUID end
    end)
    return enemy or nil
end

local function IsSafeToWhirlingDragonPunch()
    if findEnemyById(176581) then return false end
    return true
end

local function debug(message) if Options.Debug:Checked() then print(message) end end

local function comboStrike(spellID)
    return br.player.variables.lastCombo ~= spellID
end

local function ToD(enemy)
    local function doIT(victim)
        br._G.SpellStopCasting()
        br._G.StartAttack(victim)
        br._G.CastSpellByName(br._G.GetSpellInfo(spell.touchOfDeath), victim)
    end

    if unit.facing(player, enemy) then
        if br._G.UnitIsPlayer(enemy) then
            if unit.hp(enemy) <= 15 then return doIT(enemy) end
        elseif unit.isBoss(enemy) then
            if unit.health(player.unit) > unit.health(enemy) then
                return doIT(enemy)
            end
        elseif Options.TrashTouchOfDeathLife:Checked() and
            unit.health(player.unit) > unit.health(enemy) and
            br._G.UnitHealthMax(enemy) >= Options.TrashTouchOfDeathLife:Value() *
            1000 then
            return doIT(enemy)
        end
    end
end

ImmuneList = ImmuneList or {}
local function isImmune(unitGUID, spellID)
    if ImmuneList[br._G.UnitName(unitGUID) .. spellID] then return true end
end

local function cdSef()
    -- actions.cd_sef=invokeXuenTheWhiteTiger,
    -- if=!xuenHold and cooldown.risingSunKick.remains<2 and cooldown.bonedustBrew.remains<2
    if cd.invokeXuenTheWhiteTiger.ready() and Toggles.BurstModes.Full() then
        if not xuenHold and cd.risingSunKick.remains() < 2 and
            (cd.bonedustBrew.remains() < 2 or buff.bonedustBrew.exists()) then
            debug("14")
            if Options.StormEarthFire:Checked() and
                charges.stormEarthAndFire.frac() >= 1 then
                cast.stormEarthAndFire(target)
                cast.stormEarthAndFireFixate(target)
            end
            local InscrutableQuantumDevice = 179350
            if br.canUseItem(InscrutableQuantumDevice) then
                br.useItem(InscrutableQuantumDevice)
            end
            return cast.invokeXuenTheWhiteTiger(target)
        end
    end
    -- actions.cd_sef+=/bonedustBrew,
    -- if=chi>=2 and (cooldown.stormEarthAndFire.charges>0 or cooldown.stormEarthAndFire.remains>10) and
    -- (xuenExists or cooldown.invokeXuenTheWhiteTiger.remains>10 or xuenHold) or
    -- (chi>=2 and xuenExists and (cooldown.stormEarthAndFire.charges>0 or buff.stormEarthAndFire.up))
    if cd.bonedustBrew.ready() and cd.risingSunKick.remains() < 2 and
        (Toggles.BurstModes.Full() or Toggles.BurstModes.Mini()) then
        if chi >= 2 and
            (charges.stormEarthAndFire.frac() > 0 or
                cd.stormEarthAndFire.remains() > 10) and
            (xuenExists or cd.invokeXuenTheWhiteTiger.remains() > 10 or xuenHold) or
            (chi >= 2 and xuenExists and
                (charges.stormEarthAndFire.frac() > 0 or
                    buff.stormEarthAndFire.exists())) then
            debug("15")
            if Options.StormEarthFire:Checked() and
                charges.stormEarthAndFire.frac() >= 1 then
                cast.stormEarthAndFire(target)
                cast.stormEarthAndFireFixate(target)
            end
            return cast.bonedustBrew(target)
        end
    end

    -- actions.cd_sef+=/stormEarthAndFireFixate,if=conduit.coordinated_offensive.enabled
    if cast.able.stormEarthAndFireFixate(target) then
        debug("16")
        cast.stormEarthAndFireFixate(target)
    end
    -- actions.cd_sef+=/stormEarthAndFire,
    -- if=cooldown.stormEarthAndFire.charges=2
    if Options.StormEarthFire:Checked() and not buff.stormEarthAndFire.exists() then
        if charges.stormEarthAndFire.frac() >= 1.9 and
            (bossEncounter or trashStormEarthFireCondition) then
            debug("17")
            cast.stormEarthAndFire(target)
            -- actions.cd_sef+=/stormEarthAndFire,
            -- if=debuff.bonedustBrew_debuff.up and
            -- (xuenExists or xuenHold or cooldown.invokeXuenTheWhiteTiger.remains>cooldown.stormEarthAndFire.timeTillFull() or
            -- cooldown.invokeXuenTheWhiteTiger.remains>30)
        end
        if buff.bonedustBrew.exists() and
            (xuenExists or xuenHold or cd.invokeXuenTheWhiteTiger.remains() >
                charges.stormEarthAndFire.timeTillFull() or
                cd.invokeXuenTheWhiteTiger.remains() > 30) then
            if not buff.stormEarthAndFire.exists() and
                (bossEncounter or trashStormEarthFireCondition) then
                debug("18")
                cast.stormEarthAndFire(target)
            end
        end
    end
    -- actions.cd_sef+=/use_item,name=inscrutable_quantum_device,if=xuenExists or cooldown.invokeXuenTheWhiteTiger.remains>60
    if xuenExists or (cd.invokeXuenTheWhiteTiger.remains() > 60 and
        (buff.stormEarthAndFire.exists() or buff.bonedustBrew.exists())) then
        local InscrutableQuantumDevice = 179350
        if br.canUseItem(InscrutableQuantumDevice) then
            debug("19")
            br.useItem(InscrutableQuantumDevice)
        end
    end
    -- actions.cd_sef+=/fleshcraft,if=debuff.bonedustBrew_debuff.down
    if Options.Covenant:Checked() and cd.fleshcraft.ready() and
        not unit.moving() then
        if not buff.bonedustBrew.exists() and not xuenExists and
            not buff.stormEarthAndFire.exists() then
            debug("20")
            return cast.fleshcraft()
        end
    end
end

local function extra()
    if chiMax - chi <= 1 then
        if comboStrike(spell.spinningCraneKick) and #enemies.yards8 >= 1 then
            return cast.spinningCraneKick(player)
        end
        if comboStrike(spell.blackoutKick) then
            return cast.blackoutKick(target)
        end
    end
    -- 5 chi
    -- spinningCraneKick
    -- blackoutKick
end

local function st()
    -- actions+=/call_action_list,name=st,if=active_enemies<3
    if #enemies.yards8 < 3 or Toggles.RotationModes:Sing() then
        -- actions.st=whirlingDragonPunch,if=raid_event.adds.in>cooldown.whirlingDragonPunch.duration*0.8 or raid_event.adds.up
        if talent.whirlingDragonPunch and IsSafeToWhirlingDragonPunch() and
            cd.whirlingDragonPunch.ready() and cd.risingSunKick.exists() and
            cd.fistsOfFury.exists() then
            debug("21")
            return cast.whirlingDragonPunch(player)
        end
        -- actions.st+=/spinningCraneKick,if=combo_strike and buff.danceOfChiJi.up and (raid_event.adds.in>buff.danceOfChiJi.remains-2 or raid_event.adds.up)
        if comboStrike(spell.spinningCraneKick) and buff.danceOfChiJi.exists() then
            debug("22")
            return cast.spinningCraneKick(player)
        end
        -- actions.st+=/risingSunKick,if=cooldown.serenity.remains>1 or !talent.serenity and (cooldown.weaponsOfOrder.remains>4 or !covenant.kyrian)
        if cd.risingSunKick.ready() and chi >= 2 then
            debug("23")
            return cast.risingSunKick(target)
        end
        -- actions.st+=/fistsOfFury,
        -- if=(energyTimeToMax>execute_time-1 or chiMax-chi<=1 or buff.stormEarthAndFire.remains<execute_time+1) or debuff.bonedustBrew_debuff.up
        if (energyTimeToMax > fofExecute - 1 or chiMax - chi <= 1 or
            buff.stormEarthAndFire.remains() < fofExecute + 1) or
            buff.bonedustBrew.exists() then
            if cd.fistsOfFury.ready() and chi >= 3 then
                debug("24")
                return cast.fistsOfFury()
            end
        end
        -- actions.st+=/fistOfTheWhiteTiger,if=chi<3
        if talent.fistOfTheWhiteTiger and cd.fistOfTheWhiteTiger.ready() and
            energy >= 40 then
            if chi < 3 then
                debug("25")
                return cast.fistOfTheWhiteTiger(target)
            end
        end
        -- actions.st+=/expelHarm,if=chiMax-chi>=1
        if cd.expelHarm.ready() and energy >= 15 then
            if chiMax - chi >= 1 then
                debug("26")
                return cast.expelHarm(player)
            end
        end
        -- actions.st+=/chiBurst,if=chi.max-chi>=1&active_enemies=1|chi.max-chi>=2&active_enemies>=2
        if talent.chiBurst and cd.chiBurst.ready() and not unit.moving() then
            if chiMax - chi >= 1 then
                debug("27")
                return cast.chiBurst(player)
            end
        end
        -- actions.st+=/tigerPalm,if=combo_strike and chiMax-chi>=2 and buff.stormEarthAndFire.down
        if comboStrike(spell.tigerPalm) and chiMax - chi >= 2 and
            not buff.stormEarthAndFire.exists() then
            if energy >= 50 then
                debug("28")
                return cast.tigerPalm(target)
            end
        end
        -- actions.st+=/blackoutKick,
        -- if=combo_strike and (cooldown.risingSunKick.remains>1
        -- and cooldown.fistsOfFury.remains>1 or cooldown.risingSunKick.remains<3 and cooldown.fistsOfFury.remains>3
        -- and chi>2 or cooldown.risingSunKick.remains>3 and cooldown.fistsOfFury.remains<3
        -- and chi>3 or chi>5 or buff.bok_proc.up)
        if comboStrike(spell.blackoutKick) and
            (cd.risingSunKick.remains() > 1 and cd.fistsOfFury.remains() > 1 or
                cd.risingSunKick.remains() < 3 and cd.fistsOfFury.remains() > 3 and
                chi > 2 or cd.risingSunKick.remains() > 3 and
                cd.fistsOfFury.remains() < 3 and chi > 3 or chi > 5 or
                buff.blackoutKick.exists()) then
            if buff.blackoutKick.exists() or chi >= 2 then
                debug("29")
                return cast.blackoutKick(target)
            end
        end
        -- actions.st+=/tigerPalm,if=combo_strike and chiMax-chi>=2
        if comboStrike(spell.tigerPalm) and chiMax - chi >= 2 then
            if energy >= 50 then
                debug("30")
                return cast.tigerPalm(target)
            end
        end
        -- actions.st+=/arcaneTorrent,if=chiMax-chi>=1
        if chiMax - chi >= 1 then
            if br.isKnown(spell.arcaneTorrent) and
                br.getSpellCD(spell.arcaneTorrent) == 0 then
                return br.castSpell(player, spell.arcaneTorrent)
            end
        end
        -- actions.st+=/blackoutKick,if=combo_strike and cooldown.fistsOfFury.remains<3 and chi=2 and cast.last.tigerPalm(1) and energyTimeToMax<1
        if comboStrike(spell.blackoutKick) and cd.fistsOfFury.remains() < 3 and
            chi == 2 and cast.last.tigerPalm(1) and energyTimeToMax < 1 then
            if buff.blackoutKick.exists() or chi >= 2 then
                debug("31")
                return cast.blackoutKick(target)
            end
        end
        -- actions.st+=/blackoutKick,if=combo_strike and energyTimeToMax<2 and (chiMax-chi<=1 or cast.last.tigerPalm(1))
        if comboStrike(spell.blackoutKick) and energyTimeToMax < 2 and
            (chiMax - chi <= 1 or cast.last.tigerPalm(1)) then
            if buff.blackoutKick.exists() or chi >= 2 then
                debug("32")
                return cast.blackoutKick(target)
            end
        end
    end
end

local function aoe()
    -- actions+=/call_action_list,name=aoe,if=active_enemies>=3
    if #enemies.yards8 >= 3 or Toggles.RotationModes:Multi() then
        -- actions.aoe=whirlingDragonPunch
        if talent.whirlingDragonPunch and IsSafeToWhirlingDragonPunch() and
            cd.whirlingDragonPunch.ready() and cd.risingSunKick.exists() and
            cd.fistsOfFury.exists() then
            debug("4")
            return cast.whirlingDragonPunch(player)
        end
        -- actions.aoe+=/spinningCraneKick,if=combo_strike and (buff.danceOfChiJi.up or debuff.bonedustBrew_debuff.up)
        if comboStrike(spell.spinningCraneKick) and
            (buff.danceOfChiJi.exists() or
                (chi >= 2 and buff.bonedustBrew.exists())) then
            debug("5")
            return cast.spinningCraneKick(player)
        end
        -- actions.aoe+=/fistsOfFury,if=energyTimeToMax>execute_time or chiMax-chi<=1
        if cd.fistsOfFury.ready() and chi >= 3 then
            if energyTimeToMax > fofExecute or chiMax - chi <= 1 then
                debug("6")
                return cast.fistsOfFury()
            end
        end
        -- actions.aoe+=/risingSunKick,if=(talent.whirlingDragonPunch and cooldown.risingSunKick.duration>cooldown.whirlingDragonPunch.remains+4) and (cooldown.fistsOfFury.remains>3 or chi>=5)
        if cd.risingSunKick.ready() and chi >= 2 then
            if (talent.whirlingDragonPunch and rskDuration >
                cd.whirlingDragonPunch.remains() + 4) and
                (cd.fistsOfFury.remains() > 3 or chi >= 5) then
                debug("7")
                return cast.risingSunKick(target)
            end
        end
        -- actions.aoe+=/expelHarm,if=chiMax-chi>=1
        if cd.expelHarm.ready() and energy >= 15 then
            if chiMax - chi >= 1 then
                debug("8")
                return cast.expelHarm(player)
            end
        end
        -- actions.aoe+=/fistOfTheWhiteTiger,if=chiMax-chi>=3
        if talent.fistOfTheWhiteTiger and cd.fistOfTheWhiteTiger.ready() and
            energy >= 40 then
            if chiMax - chi >= 3 then
                debug("9")
                return cast.fistOfTheWhiteTiger(target)
            end
        end
        -- actions.aoe+=/chiBurst,if=chiMax-chi>=2
        if talent.chiBurst and cd.chiBurst.ready() and not unit.moving() then
            if chiMax - chi >= 2 then
                debug("10")
                return cast.chiBurst(player)
            end
        end
        -- actions.aoe+=/tigerPalm,if=chiMax-chi>=2 and (!talent.hit_combo or combo_strike)
        if chiMax - chi >= 2 and comboStrike(spell.tigerPalm) then
            debug("11")
            return cast.tigerPalm(target)
        end
        -- actions.aoe+=/arcaneTorrent,if=chiMax-chi>=1
        if chiMax - chi >= 1 then
            if br.isKnown(spell.arcaneTorrent) and
                br.getSpellCD(spell.arcaneTorrent) == 0 then
                return br.castSpell(player, spell.arcaneTorrent)
            end
        end
        -- actions.aoe+=/spinningCraneKick,
        -- if=combo_strike and cooldown.bonedustBrew.remains>2 and
        -- (chi>=5 or cooldown.fistsOfFury.remains>6 or cooldown.fistsOfFury.remains>3 and chi>=3
        -- and energyTimeToMax<1 or energyTimeToMax<=(3+3*cooldown.fistsOfFury.remains<5) or buff.stormEarthAndFire.up)
        if comboStrike(spell.spinningCraneKick) and cd.bonedustBrew.remains() >
            2 and
            (chi >= 5 or cd.fistsOfFury.remains() > 6 or
                cd.fistsOfFury.remains() > 3 and chi >= 3 and energyTimeToMax <
                1 or energyTimeToMax <=
                (3 + 3 * (cd.fistsOfFury.remains() < 5 and 1 or 0)) or
                buff.stormEarthAndFire.exists()) then
            debug("12")
            return cast.spinningCraneKick(player)
        end
        -- actions.aoe+=/blackoutKick,
        -- if=combo_strike and (buff.bok_proc.up and cast.last.tigerPalm(1)
        -- and chi=2 and cooldown.fistsOfFury.remains<3 or chiMax-chi<=1
        -- and prev_gcd.1.spinningCraneKick and energyTimeToMax<3)
        if comboStrike(spell.blackoutKick) and
            (buff.blackoutKick.exists() and cast.last.tigerPalm(1) and chi == 2 and
                cd.fistsOfFury.remains() < 3 or chiMax - chi <= 1 and
                cast.last.spinningCraneKick(1) and energyTimeToMax < 3) then
            debug("13")
            return cast.blackoutKick(target)
        end
    end
end

local function cdManual()
    if chi >= 2 and cd.risingSunKick.remains() < 2 then
        if Toggles.BurstModes.Full() and cd.invokeXuenTheWhiteTiger.ready() then
            if Options.StormEarthFire:Checked() and
                charges.stormEarthAndFire.frac() >= 1 then
                cast.stormEarthAndFire(target)
                cast.stormEarthAndFireFixate(target)
            end
            local InscrutableQuantumDevice = 179350
            if br.canUseItem(InscrutableQuantumDevice) then
                br.useItem(InscrutableQuantumDevice)
            end
            return cast.invokeXuenTheWhiteTiger(target)
        end
        if (Toggles.BurstModes.Full() or Toggles.BurstModes.Mini()) and
            cd.bonedustBrew.ready() then
            if Options.StormEarthFire:Checked() and
                charges.stormEarthAndFire.frac() >= 1 then
                cast.stormEarthAndFire(target)
                cast.stormEarthAndFireFixate(target)
            end
            return cast.bonedustBrew(target)
        end
    end
end

----------------
--- ROTATION ---
----------------
local function runRotation()
    -- BR API Locals
    do
        buff = br.player.buff
        cast = br.player.cast
        cd = br.player.cd
        charges = br.player.charges
        chi = br.player.power.chi.amount()
        chiMax = br.player.power.chi.max()
        energy = br.player.power.energy.amount()
        energyTimeToMax = br.player.power.energy.ttm()
        enemies = br.player.enemies
        equipped = br.player.equiped
        health = br.player.health
        module = br.player.module
        player = "player"
        spell = br.player.spell
        target = "target"
        markOfTheCraneCount = br._G.GetSpellCount(spell.spinningCraneKick)
        lowestMoK = br.player.debuff.markOfTheCrane.lowest(5, "remain")
        lowestMoKRemains = br.player.debuff.markOfTheCrane.duration(lowestMoK)
        talent = br.player.talent
        ui = br.player.ui
        unit = br.player.unit
        units = br.player.units
        use = br.player.use
        -- Units
        -- units.get(5)--units.dyn5
        -- units.get(40)--units.dyn40
        -- Enemies
        enemies.get(5) -- #enemies.yards5
        enemies.get(6) -- #enemies.yards6
        enemies.get(8) -- #enemies.yards8
        enemies.get(20) -- #enemies.yards20
        -- Variables
        xuenExists = false
        xuenHold = false
        fofExecute = 4 - (4 * (br._G.GetHaste() / 100))
        rskDuration = 10 - (10 * (br._G.GetHaste() / 100))

        bossEncounter = br._G.UnitExists("boss1")
        trashStormEarthFireCondition = false
        if lowestMoKRemains <= 5 and
            (markOfTheCraneCount <= 5 or markOfTheCraneCount < #enemies.yards5) then
            target = lowestMoK
        end
    end

    -- DG Utils
    do
        instanceID = br.getCurrentZoneId()
        -- 2284	Sanguine Depths
        if instanceID == 2284 then

            -- 2285	Spires of Ascension
        elseif instanceID == 2285 then
            if talent.diffuseMagic and cd.diffuseMagic.ready() then
                -- Burden of Knowledge - 317963
                -- Insidious Venom - 323636
                -- Internal Strife - 327648
                -- Dark Lance - 327481
                -- Lost Confidence - 322818
                if br.UnitDebuffID(player, 317963) or
                    br.UnitDebuffID(player, 323636) or
                    br.UnitDebuffID(player, 327648) or
                    br.UnitDebuffID(player, 327481) or
                    br.UnitDebuffID(player, 322818) then
                    if cast.diffuseMagic(player) then end
                end
            end

            -- 2286	The Necrotic Wake
        elseif instanceID == 2286 then

            -- 2287	Halls of Atonement
        elseif instanceID == 2287 then

            -- 2289	Plaguefall
        elseif instanceID == 2289 then

            -- 2290	Mists of Tirna Scithe
        elseif instanceID == 2290 then
            if talent.diffuseMagic and cd.diffuseMagic.ready() then
                --  Anima Injection - 325223
                if br.UnitDebuffID(player, 325223) then
                    if cast.diffuseMagic(player) then end
                end
            end
            -- 2397	Ingra Maloch
            -- 2392	Mistcaller
            -- 2393	Tred'ova
            if br.player.eID == 2397 then
                DromanOulfarran = findEnemyById(164804)
                IngraMaloch = findEnemyById(164567)

                -- When npc 164804 is enemy, attack only this one
                if DromanOulfarran and unit.canAttack(DromanOulfarran) then
                    target = DromanOulfarran
                    -- Keep Mark of the crane on 164567
                    if IngraMaloch and
                        br.player.debuff.markOfTheCrane.duration(IngraMaloch) <=
                        3 then target = IngraMaloch end
                end
            elseif br.player.eID == 2392 then
                IllusionaryVulpin = findEnemyById(165251)
                IllusionaryClone = findEnemyById(165108)
                Mistcaller = findEnemyById(170217)
                if IllusionaryVulpin and cd.paralysis.ready() and
                    not br.isCCed(IllusionaryVulpin) then
                    return cast.paralysis(IllusionaryVulpin)
                end
                if IllusionaryClone and unit.id(target) == 170217 then
                    target = IllusionaryClone
                end
            end

            -- 2291	De Other Side
        elseif instanceID == 2291 then
            if talent.diffuseMagic and cd.diffuseMagic.ready() then
                -- Shadow Word: Pain - 34942
                if br.UnitDebuffID(player, 34942) then
                    if cast.diffuseMagic(player) then end
                end
            end

            -- 2293	Theater of Pain
        elseif instanceID == 2293 then
            if talent.diffuseMagic and cd.diffuseMagic.ready() then
                -- Soul Corruption - 333708
                -- Phantasmal Parasite - 319626
                if br.UnitDebuffID(player, 333708) or
                    br.UnitDebuffID(player, 319626) then
                    if cast.diffuseMagic(player) then end
                end
            end

        end
    end
    ----------

    if not Options then
        print("Open Rotation Options")
        -- br.ui:toggleWindow("profile")
        -- br.ui:closeWindow("profile")
        -- br.player:createOptions()
        -- br.player:createToggles()
        return false
    end

    if Options.TrashStormEarthFire:Checked() then
        counter = 0
        _G.foreach(enemies.yards20, function(index, enemyGUID)
            if unit.health(enemyGUID) >= Options.TrashStormEarthFire:Value2() *
                10000 then counter = counter + 1 end
        end)
        trashStormEarthFireCondition = counter >=
                                           Options.TrashStormEarthFire:Value()
    end

    for index = 1, 4 do
        exists, totemName, startTime, duration, _ = GetTotemInfo(index)
        if exists and totemName ~= nil then
            if string.find(totemName, "Xuen") then
                xuenExists = true
                break
            end
        end
    end

    if Toggles.BurstModes.Full() and cd.invokeXuenTheWhiteTiger.remains() >= 5 and
        cd.bonedustBrew.remains() >= 5 then Toggles.BurstModes.SetOff() end
    if Toggles.BurstModes.Mini() and cd.bonedustBrew.remains() >= 5 then
        Toggles.BurstModes.SetOff()
    end

    -- Manual Options
    if Options.ManualRingOfPeace:Checked() and
        Options.ManualRingOfPeace:Toggled() then
        if talent.ringOfPeace and cd.ringOfPeace.ready() then
            if br._G.IsUsableSpell(spell.ringOfPeace) then
                br._G.CastSpellByName(br._G.GetSpellInfo(spell.ringOfPeace),
                                      "cursor")
                return true
            else
                return false
            end
        end
    end

    if not unit.exists(target) or not unit.facing(player, target) or
        not br._G.UnitCanAttack(player, target) or unit.deadOrGhost(target) or
        br._G.IsMounted() then
        -- debug("target")
        return false
    end

    if Toggles.InterruptModes:On() and Options.SpearHandStrike:Checked() and
        cd.spearHandStrike.ready() then
        _G.foreach(enemies.yards5, function(index, enemyGUID)
            if unit.interruptable(enemyGUID, Options.InterruptAt:Value()) then
                return cast.spearHandStrike(enemyGUID)
            end
        end)
    end

    if Toggles.DefensiveModes:On() and br.timer:useTimer("defensives", 1) then
        if Options.Healthstone:Checked() and health <=
            Options.Healthstone:Value() and br.hasItem(5512) then
            if br.canUseItem(5512) then br.useItem(5512) end
        end
        if Options.TouchOfKarma:Checked() and health <=
            Options.TouchOfKarma:Value() and cd.touchOfKarma.ready() then
            if cast.touchOfKarma(target) then end
        end
        if talent.dampenHarm and Options.DampenHarm:Checked() and health <=
            Options.DampenHarm:Value() and cd.dampenHarm.ready() then
            if cast.dampenHarm(player) then end
        end
        if talent.diffuseMagic and Options.DiffuseMagic:Checked() and health <=
            Options.DiffuseMagic:Value() and cd.diffuseMagic.ready() then
            if cast.diffuseMagic(player) then end
        end
        if Options.FortifyingBrew:Checked() and health <=
            Options.FortifyingBrew:Value() and cd.fortifyingBrew.ready() then
            if cast.fortifyingBrew(player) then end
        end
    end

    if unit.gcd() > 0 then
        -- debug("GCD")
        return false
    end

    if Options.TouchOfDeath:Checked() then
        _G.foreach(enemies.yards5, function(index, enemyGUID)
            -- 174773
            if unit.id(enemyGUID) ~= 174773 then
                if ToD(enemyGUID) then return true end
            end
        end)
    end
    --

    if Toggles.InterruptModes:On() then
        if Options.LegSweep:Checked() and cd.legSweep.ready() and
            cast.able.legSweep() then
            local temp = _G.foreach(enemies.yards6, function(index, enemyGUID)
                if unit.interruptable(enemyGUID, Options.InterruptAt:Value()) and
                    not isImmune(enemyGUID, spell.legSweep) then
                    return cast.legSweep()
                end
            end)
            if temp then return temp end
        end
        -- Paralysis
        if Options.Paralysis:Checked() and cd.paralysis.ready() then
            local temp = _G.foreach(enemies.yards20, function(index, enemyGUID)
                if br._G.UnitChannelInfo(enemyGUID) and
                    not isImmune(enemyGUID, spell.paralysis) then
                    return cast.paralysis(enemyGUID)
                end
            end)
            if temp then return temp end
        end
    end

    -- actions.st+=/fleshcraft,interrupt_immediate=1,interrupt_if=buff.volatile_solvent_humanoid.up|energy.time_to_max<3|cooldown.rising_sun_kick.remains<2|cooldown.fists_of_fury.remains<2,if=soulbind.volatile_solvent&buff.storm_earth_and_fire.down&debuff.bonedust_brew_debuff.down
    if cast.current.fleshcraft() and #enemies.yards8 >= 1 then
        if energyTimeToMax < 3 or cd.risingSunKick.remains() < 2 or
            cd.fistsOfFury.remains() < 2 then br._G.SpellStopCasting() end
    end

    if cast.current.fistsOfFury() or cast.current.chiBurst() or
        cast.current.fleshcraft() then return false end
    br._G.StartAttack(target)

    ---------------------
    --- Begin Profile ---
    ---------------------
    -- debug("-----Begin-----")
    -- actions.precombat+=/variable,name=xuen_on_use_trinket,op=set,value=equipped.inscrutable_quantum_device or equipped.gladiators_badge or equipped.wrathstone or equipped.overcharged_anima_battery or equipped.shadowgrasp_totem
    if xuenExists then end

    -- # Executed every time the actor is available.
    -- actions=auto_attack
    -- actions+=/variable,name=hold_xuen,op=set,value=
    -- cooldown.stormEarthAndFire.timeTillFull()>15or  (cooldown.stormEarthAndFire.charges=0)
    xuenHold = (charges.stormEarthAndFire.timeTillFull() < 15 and
                   charges.stormEarthAndFire.timeTillFull() >= 3) or
                   charges.stormEarthAndFire.frac() == 0

    -- actions+=/fistOfTheWhiteTiger,if=chiMax-chi>=3 and (energyTimeToMax<1 or energyTimeToMax<4 and cooldown.fistsOfFury.remains<1.5 or cooldown.weaponsOfOrder.remains<2) and !debuff.bonedustBrew_debuff.up
    if talent.fistOfTheWhiteTiger and cd.fistOfTheWhiteTiger.ready() and energy >=
        40 then
        if chiMax - chi >= 3 and
            (energyTimeToMax < 1 or energyTimeToMax < 4 and
                cd.fistsOfFury.remains() < 1.5) and
            not buff.bonedustBrew.exists() then
            debug("1")
            return cast.fistOfTheWhiteTiger(target)
        end
    end
    -- actions+=/expelHarm,if=chiMax-chi>=1 and (energyTimeToMax<1 or cooldown.serenity.remains<2 or energyTimeToMax<4 and cooldown.fistsOfFury.remains<1.5 or cooldown.weaponsOfOrder.remains<2) and !buff.bonedustBrew.up
    if cd.expelHarm.ready() and energy >= 15 then
        if chiMax - chi >= 1 and
            (energyTimeToMax < 1 or energyTimeToMax < 4 and
                cd.fistsOfFury.remains() < 1.5) and
            not buff.bonedustBrew.exists() then
            debug("2")
            return cast.expelHarm(player)
        end
    end
    -- actions+=/tigerPalm,if=combo_strike and chiMax-chi>=2 and (energyTimeToMax<1 or cooldown.serenity.remains<2 or energyTimeToMax<4 and cooldown.fistsOfFury.remains<1.5 or cooldown.weaponsOfOrder.remains<2) and !debuff.bonedustBrew_debuff.up
    if energy >= 50 then
        if comboStrike(spell.tigerPalm) and chiMax - chi >= 2 and
            (energyTimeToMax < 1 or energyTimeToMax < 4 and
                cd.fistsOfFury.remains() < 1.5) and
            not buff.bonedustBrew.exists() then
            debug("3")
            return cast.tigerPalm(target)
        end
    end

    if Toggles.CooldownModes:On() then

        local _cfSef = cdSef()
        debug("CD_SEF")
        if _cfSef then return _cfSef end

        local _cfManual = cdManual()
        debug("CD_MANUAL")
        if _cfManual then return _cfManual end
    end

    if Toggles.RotationModes:Auto() or Toggles.RotationModes:Multi() then

        local _aoe = aoe()
        debug("AOE")
        if _aoe then return _aoe end
    end

    if Toggles.RotationModes:Auto() or Toggles.RotationModes:Sing() then

        debug("ST")
        local _st = st()
        if _st then return _st end
    end

    debug("extra")
    local _extra = extra()
    if _extra then return _extra end

    debug("-----Nothing-----")

end

local id = 269
if br.rotations[id] == nil then br.rotations[id] = {} end

tinsert(br.rotations[id], {
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation
})
