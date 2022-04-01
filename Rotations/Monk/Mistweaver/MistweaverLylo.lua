local rotationName = "LyLo-v2"


local Colors = {
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


local function reader(...)
    local timeStamp,
    param,
    hideCaster,
    source,
    sourceName,
    sourceFlags,
    sourceRaidFlags,
    destination,
    destName,
    destFlags,
    destRaidFlags,
    theSpell,
    spellName,
    _,
    spellType = br._G.CombatLogGetCurrentEventInfo()
    if br.GetUnitIsUnit(sourceName, "player") and param == "SPELL_MISSED" and spellType == "IMMUNE" and
        not br._G.UnitIsPlayer(destination) and (theSpell == br.player.spell.paralysis or theSpell == br.player.spell.legSweep) then
        br.data.settings[br.selectedSpec][br.selectedProfile]["LyloMWImmuneList"][br.getCurrentZoneId().. ":"..destName .. ":" .. theSpell] = true
    end
end
----------------
---------------
--- Toggles ---
---------------
local Toggles = {}
local function createToggles()
    local frame = br._G.CreateFrame("Frame")
    frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    frame:SetScript("OnEvent", reader)
    br.data.settings[br.selectedSpec][br.selectedProfile]["LyloMWImmuneList"] = br.data.settings[br.selectedSpec][br.selectedProfile]["LyloMWImmuneList"] or {}
    --------------------------------------------------------------
    local RotationModes = {
        [1] = {
            mode = "OFF",
            value = 1,
            overlay = "Nothing",
            tip = "Nothing",
            highlight = 0,
            icon = "132311"
        },
        [2] = {
            mode = "AUTO",
            value = 2,
            overlay = "Auto usage of DPS / HEAL",
            tip = "Auto usage of DPS / HEAL",
            highlight = 1,
            icon = "892827"
        },
        [3] = {
            mode = "HEAL",
            value = 3,
            overlay = "Will use Heal",
            tip = "Healing",
            highlight = 1,
            icon = br.player.spell.soothingMist
        },
        [4] = {
            mode = "DPS",
            value = 4,
            overlay = "Will use DPS",
            tip = "KILLING",
            highlight = 1,
            icon = br.player.spell.risingSunKick
        }
    };
    br.ui:createToggle(RotationModes, "Rotation", 1, 0)
    Toggles.RotationModes = {
        Off = function()
            return br.data.settings[br.selectedSpec].toggles["Rotation"] == 1
        end,
        Auto = function()
            return br.data.settings[br.selectedSpec].toggles["Rotation"] == 2
        end,
        Heal = function()
            return br.data.settings[br.selectedSpec].toggles["Rotation"] == 3
        end,
        DPS = function()
            return br.data.settings[br.selectedSpec].toggles["Rotation"] == 4
        end,
        SetOff = function() 
            br._G.RunMacroText("/br toggle Rotation 1") 
        end
    }
    --------------------------------------------------------------
    local DetoxModes = {
        [1] = {
            mode = "On",
            value = 1,
            overlay = "Detox Enabled",
            tip = "Auto Detox",
            highlight = 1,
            icon = br.player.spell.detox
        },
        [2] = {
            mode = "Off",
            value = 2,
            overlay = "Detox Disabled",
            tip = "Auto Detox OFF",
            highlight = 0,
            icon = 132311
        }
    };
    br.ui:createToggle(DetoxModes, "Detox", 2, 0)
    Toggles.DetoxModes = {
        On = function()
            return br.data.settings[br.selectedSpec].toggles["Detox"] == 1
        end,
        Off = function()
            return br.data.settings[br.selectedSpec].toggles["Detox"] == 2
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
        AddOption(Page, tostring(Colors.Monk) .. "Monk Spells")
        Options.TouchOfDeath = AddOption(Page, tostring(Colors.Rare) .. "Touch of Death", {
            Default = true,
            Tooltip = "Enable auto usage"
        })
        Options.TrashTouchOfDeathLife = AddOption(Page, "- Trash: ToD - MaxHP", {
            Default = true,
            Tooltip = "Enable this manual spell"
        }, {
            Default = 50,
            Min = 1,
            Max = 5000,
            Step = 1,
            Tooltip = "Max Health of enemy (in thousands) | 10 = 10k"
        })
        Options.Revival = AddOption(Page, tostring(Colors.Rare) .. "Revival", {
            Default = true,
            Tooltip = "Enable auto usage"
        })
        Page = tostring(Colors.Monk) .. "Offensive"
        AddOption(Page, "General")
        Options.IgnoreHealthAncientTeachings = AddOption(Page, "- Ancient Teachings - Ignore Missing Health", {
            Default = true,
            Tooltip = "Should ignore missing health of friends to dps when using Ancient Teachings"
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
        Options.LegSweep = AddOption(Page, tostring(Colors.Rare) .. "Leg Sweep", {
            Default = false,
            Tooltip = "Use This Spell"
        })
        Options.Paralysis = AddOption(Page, tostring(Colors.Rare) .. "Paralysis", {
            Default = false,
            Tooltip = "Use This Spell"
        })

        
        Page = tostring(Colors.Monk) .. "Extra"
        AddOption(Page, "Use the following macros")
        AddOption(Page, Colors.Legendary .. "/br toggle Rotation 1")
        AddOption(Page, Colors.Legendary .. "/br toggle Rotation 2")
        AddOption(Page, Colors.Legendary .. "/br toggle Rotation 3")

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
local debuff
local enemies
local friends
local gcd
local lowestUnit
local spell
local talent
local unit
local runeforge
local player

local target = "target"
local tanks
local tankUnit

local healingValues = {
    gustOfMist = 0,
    vivify = 0,
    vivifyRenewingMist = 0,
    envelopingMist = 0,
    envelopingBreath = 0,
    envelopingMistThunderFocusTea = 0,
    expelHarm = 0,
    lifeCocoon = 0,
    revival = 0,
    soothingMist = 0,
    essenceFont = 0,
    tigerPalm = 0,
    blackoutKick = 0,
    risingSunKick = 0
}
local revivalLimit = 1

local ChiJiDuration
local JadeSerpentStatueDuration
local YulonDuration

local soothingMistUnit
local mysticTouchCount
local mysticTouchUnit

local resistance = 0.85


-------------------
---- FUNCTIONS ----
-------------------
local HealingValues = {
    GetGustOfMistHealing = function (theUnit)
        local healing = healingValues.gustOfMist
        if buff.essenceFont.exists(theUnit) then
            healing = healing + healingValues.gustOfMist
        end
        if buff.envelopingMist.exists(theUnit) then
            if talent.mistWrap then
                healing = healing * 1.4
            else
                healing = healing * 1.3
            end
        end
        if buff.envelopingBreath.exists(theUnit) then
            healing = healing * 1.1
        end
        if buff.lifeCocoon.exists(theUnit) then
            healing = healing * 1.5
        end
        if buff.prideful.exists("player") then
            healing = healing * 1.3
        end
        return healing
    end,
    GetVivifyHealing = function (theUnit, hasEnvelopingMist)
        hasEnvelopingMist = hasEnvelopingMist or false
        local healing = healingValues.vivify + healingValues.gustOfMist
        if buff.renewingMist.exists(theUnit) then
            healing = healing + healingValues.vivify
            if runeforge.tearOfMorning.equiped then
                healing = healing * 1.2
            end
        end
        if buff.essenceFont.exists(theUnit) then
            healing = healing + healingValues.gustOfMist
        end
        if buff.envelopingMist.exists(theUnit) or hasEnvelopingMist then
            if talent.mistWrap then
                healing = healing * 1.4
            else
                healing = healing * 1.3
            end
        end
        if buff.envelopingBreath.exists(theUnit) or (hasEnvelopingMist and (ChiJiDuration > 0 or YulonDuration > 0)) then
            healing = healing * 1.1
        end
        if buff.lifeCocoon.exists(theUnit) then
            healing = healing * 1.5
        end
        if buff.prideful.exists("player") then
            healing = healing * 1.3
        end
        return healing
    end,
    GetVivifyRenewingMistHealing = function (theUnit)
        local healing = healingValues.vivifyRenewingMist
        if runeforge.tearOfMorning.equiped then
            healing = healing * 1.2
        end
        if buff.envelopingMist.exists(theUnit) then
            if talent.mistWrap then
                healing = healing * 1.4
            else
                healing = healing * 1.3
            end
        end
        if buff.envelopingBreath.exists(theUnit) then
            healing = healing * 1.1
        end
        if buff.lifeCocoon.exists(theUnit) then
            healing = healing * 1.5
        end
        if buff.prideful.exists("player") then
            healing = healing * 1.3
        end
        return healing
    end,
    GetEnvelopingMistHealing = function (theUnit)
        local healing = healingValues.envelopingMist + healingValues.gustOfMist
        if buff.essenceFont.exists(theUnit) then
            healing = healing + healingValues.gustOfMist
        end
        if buff.envelopingMist.exists(theUnit) then
            if talent.mistWrap then
                healing = healing * 1.4
            else
                healing = healing * 1.3
            end
        end
        if buff.envelopingBreath.exists(theUnit) then
            healing = healing * 1.1
        end
        if buff.lifeCocoon.exists(theUnit) then
            healing = healing * 1.5
        end
        if YulonDuration > 0 or ChiJiDuration > 0 then
            healing = healing + healingValues.envelopingBreath
        end
        if buff.prideful.exists("player") then
            healing = healing * 1.3
        end
        return healing
    end,
    GetExpelHarm = function (theUnit)
        local healing = healingValues.expelHarm + healingValues.gustOfMist
        if buff.essenceFont.exists(theUnit) then
            healing = healing + healingValues.gustOfMist
        end
        if buff.envelopingMist.exists(theUnit) then
            if talent.mistWrap then
                healing = healing * 1.4
            else
                healing = healing * 1.3
            end
        end
        if buff.envelopingBreath.exists(theUnit) then
            healing = healing * 1.1
        end
        if buff.lifeCocoon.exists(theUnit) then
            healing = healing * 1.5
        end
        if buff.prideful.exists("player") then
            healing = healing * 1.3
        end
        return healing
    end,
    GetSoothingMistHealing = function (theUnit)
        local healing = healingValues.soothingMist
        if buff.envelopingMist.exists(theUnit) then
            if talent.mistWrap then
                healing = healing * 1.4
            else
                healing = healing * 1.3
            end
        end
        if buff.envelopingBreath.exists(theUnit) then
            healing = healing * 1.1
        end
        if buff.lifeCocoon.exists(theUnit) then
            healing = healing * 1.5
        end
        if buff.prideful.exists("player") then
            healing = healing * 1.3
        end
        return healing
    end,
}


-- 2284	Sanguine Depths
-- 2285	Spires of Ascension
-- 2286	The Necrotic Wake
-- 2287	Halls of Atonement
-- 2289	Plaguefall
-- 2290	Mists of Tirna Scithe
-- 2291	De Other Side
-- 2293	Theater of Pain
-- NewSpecialWarningDispel(329110, "Healer", nil, 2, 1, 2)
-- NewSpecialWarningDispel(spellId, optionDefault, ...)
---- newSpecialWarning(self, "dispel", spellId, nil, optionDefault, ...)
-- newSpecialWarning(self, announceType, spellId, stacks, optionDefault, optionName, optionVersion, runSound, hasVoice, difficulty)
local MonkFlags = { -- Mistweaver Monk
    ["Healer"] = true,
    ["Melee"] = true,
    ["Ranged"] = true,
    ["ManaUser"] = true,
    ["SpellCaster"] = true,
    ["RaidCooldown"] = true, -- Revival
    ["RemovePoison"] = true,
    ["RemoveDisease"] = true,
    ["RemoveMagic"] = true,
    ["RemoveCurse"] = false,
    ["MagicDispeller"] = false,
    ["RemoveEnrage"] = false

}



local mythicListDetox = {
    [0] = {
        {spellID = 240443, flag = "RemoveMagic", stack = 3, onlyUseOnTankIf = true},
    },

    [1148] = {
        {spellID = 145206, flag = "RemoveMagic"}
    },

    -- Tazavesh
    [2441] = {
        -- mod:NewSpecialWarningDispel(349954, "RemoveMagic", nil, nil, 1, 2)
        {spellID = 349954, flag = "RemoveMagic"},
        -- mod:NewSpecialWarningDispel(355915, "RemoveMagic", nil, nil, 1, 2)--Interrogation Specialist
        {spellID = 355915, flag = "RemoveMagic"},
        -- mod:NewSpecialWarningDispel(355980, "MagicDispeller", nil, nil, 1, 2)--Support Officer
        {spellID = 355980, flag = "MagicDispeller"},
    },

    -- Sanguine Depths
    [2284] = {
        -- mod:NewSpecialWarningDispel(328494, "RemoveCurse", nil, nil, 1, 2)
        {spellID = 328494, flag = "RemoveCurse"},
        -- mod:NewSpecialWarningDispel(321038, "RemoveMagic", nil, nil, 1, 2)
        {spellID = 321038, flag = "RemoveMagic"},
        -- 326836-Curse
        {spellID = 326836, flag = "RemoveCurse"},
        -- 336277-Curse
        {spellID = 336277, flag = "RemoveCurse"},
        -- 328494-Curse
        {spellID = 328494, flag = "RemoveCurse"},
    },
    -- Spires of Ascension
    [2285] = {
        -- mod:NewSpecialWarningDispel(317936, "MagicDispeller", nil, nil, 1, 2)
        {spellID = 317936, flag = "MagicDispeller"},
        -- mod:NewSpecialWarningDispel(317963, "RemoveMagic", nil, nil, 1, 2)
        {spellID = 317963, flag = "RemoveMagic"},
        -- mod:NewSpecialWarningDispel(317661, "RemoveMagic", nil, nil, 1, 2)
        {spellID = 317661, flag = "RemoveMagic"},
        -- mod:NewSpecialWarningDispel(328331, "RemoveMagic", nil, nil, 1, 2)
        {spellID = 328331, flag = "RemoveMagic"}
    },
    -- The Necrotic Wake
    [2286] = {
        -- mod:NewSpecialWarningDispel(320012, "RemoveEnrage", nil, nil, 1, 2)
        {spellID = 320012, flag = "RemoveEnrage"},
        -- mod:NewSpecialWarningDispel(335141, "MagicDispeller", nil, nil, 1, 2)
        {spellID = 335141, flag = "MagicDispeller"},
        -- mod:NewSpecialWarningDispel(338353, "RemoveDisease", nil, nil, 1, 2)
        {spellID = 338353, flag = "RemoveDisease"},
        -- mod:NewSpecialWarningDispel(323347, false, nil, nil, 1, 2)--Opt it for now, since dispel timing is less black and white
        {spellID = 323347, flag = "RemoveMagic", stack = 5},
        {spellID = 320788, flag = "RemoveMagic", range = 16},
        -- 321821-Disease
        {spellID = 321821, flag = "RemoveDisease"},
        -- 324293-Magic
        {spellID = 324293, flag = "RemoveMagic"},
        -- 328664-Magic
        {spellID = 328664, flag = "RemoveMagic"},

    },
    -- 	Halls of Atonement
    [2287] = {
        -- mod:NewSpecialWarningDispel(319603, "RemoveCurse", nil, nil, 1, 2)
        {spellID = 319603, flag = "RemoveCurse"},
        -- mod:NewSpecialWarningDispel(322977, "RemoveMagic", nil, nil, 1, 2)
        {spellID = 322977, flag = "RemoveMagic"},
        -- 325701-Magic
        {spellID = 325701, flag = "RemoveMagic"},
        -- 325876-Curse
        {spellID = 325876, flag = "RemoveCurse"}
    },
    -- 	Plaguefall
    [2289] = {
        -- mod:NewSpecialWarningDispel(328015, "MagicDispeller", nil, nil, 1, 2)
        {spellID = 328015, flag = "MagicDispeller"},
        -- mod:NewSpecialWarningDispel(324652, "RemoveDisease", nil, nil, 1, 2)
        {spellID = 324652, flag = "RemoveDisease"},
        -- mod:NewSpecialWarningDispel(325552, "RemovePoison", nil, nil, 1, 2)
        {spellID = 325552, flag = "RemovePoison"},
        -- mod:NewSpecialWarningDispel(319070, "RemoveDisease", nil, nil, 1, 2)
        {spellID = 319070, flag = "RemoveDisease"},
        -- mod:NewSpecialWarningDispel(329110, "Healer", nil, 2, 1, 2)
        {spellID = 329110, flag = "Healer"},
        {spellID = 331399, flag = "RemoveDisease", notUseOnTank = true, stack = 3},
        {spellID = 322410, flag = "RemoveMagic"},
        {spellID = 328501, flag = "RemoveDisease"},
        {spellID = 320512, flag = "RemoveDisease"},
        {spellID = 327882, flag = "RemoveDisease"},
        {spellID = 328180, flag = "RemoveMagic"}
    },
    -- Mists of Tirna Scithe
    [2290] = {
        -- mod:NewSpecialWarningDispel(322557, "RemoveMagic", nil, nil, 1, 2)
        {spellID = 322557, flag = "RemoveMagic"},
        -- mod:NewSpecialWarningDispel(324914, "MagicDispeller", nil, nil, 1, 2)
        {spellID = 324914, flag = "MagicDispeller"},
        -- mod:NewSpecialWarningDispel(324776, "MagicDispeller", nil, nil, 1, 2)
        {spellID = 324776, flag = "MagicDispeller"},
        -- mod:NewSpecialWarningDispel(325224, "RemoveMagic", nil, nil, 1, 2)
        {spellID = 325224, flag = "RemoveMagic"},
        -- mod:NewSpecialWarningDispel(326046, "MagicDispeller", nil, nil, 1, 2)
        {spellID = 326046, flag = "MagicDispeller"},
        -- mod:NewSpecialWarningDispel(323137, false, nil, 2, 1, 2)--Off by default
        -- { spellID = 323137, false}--Off by default?maybe?
        -- 321968-Magic
        {spellID = 321968, flag = "RemoveMagic"},
        -- 322557-Magic
        {spellID = 322557, flag = "RemoveMagic"},
        -- 324859-Magic
        {spellID = 324859, flag = "RemoveMagic"},
        -- 326092-Poison
        {spellID = 326092, flag = "RemovePoison"},
    },
    -- De Other Side
    [2291] = {
        -- mod:NewSpecialWarningDispel(333227, "RemoveEnrage", nil, nil, 1, 2)
        {spellID = 333227, flag = "RemoveEnrage"},
        -- mod:NewSpecialWarningDispel(332666, "MagicDispeller", nil, nil, 1, 2)
        {spellID = 332666, flag = "MagicDispeller"}
    },
    -- Theater of Pain
    [2293] = {
        -- mod:NewSpecialWarningDispel(341902, "MagicDispeller", nil, nil, 1, 2)
        {spellID = 341902, flag = "MagicDispeller"},
        -- mod:NewSpecialWarningDispel(333241, "RemoveEnrage", nil, nil, 1, 2)
        {spellID = 333241, flag = "RemoveEnrage"},
        -- mod:NewSpecialWarningDispel(319626, "RemoveMagic", nil, nil, 1, 2)
        {spellID = 319626, flag = "RemoveMagic"},
        -- mod:NewSpecialWarningDispel(324085, "RemoveEnrage", nil, nil, 1, 2)
        {spellID = 324085, flag = "RemoveEnrage"},
        -- mod:NewSpecialWarningDispel(320272, "MagicDispeller", nil, nil, 1, 2)
        {spellID = 320272, flag = "MagicDispeller"}
    }
}

local FunctionsUtilities = {
    IsValidToDetox = function (theDebuff, dispelUnit)
        if not MonkFlags[theDebuff.flag] then
            return false
        end
        if theDebuff.stack and br.getDebuffStacks(dispelUnit.unit, theDebuff.spellID) < theDebuff.stack then
            return false
        end
        if theDebuff.range and #br.getAllies(dispelUnit.unit, theDebuff.range) ~= 1 then
            return false
        end
        if theDebuff.notUseOnTank and unit.role(dispelUnit.unit) == "TANK" then
            return false
        end
        return true
    end,
    IsUnitImmune = function (unitGUID, spellID)
        return br.data.settings[br.selectedSpec][br.selectedProfile]["LyloMWImmuneList"][br.getCurrentZoneId().. ":" ..br._G.UnitName(unitGUID) .. ":" .. spellID] or false
    end,
    IsAuraActive = function (theUnit, spellID)
        for i = 1, 40 do
            local _, _, _, _, _, _, _, _, _, buffSpellID = br._G.UnitBuff(theUnit, i, "player")
            if buffSpellID == spellID then
                return true
            end
        end
        return false
    end,
    IsPause = function ()
        return br.pause(true) or br.player.unit.mounted() or br.player.unit.flying() or br.getBuffRemain("player", 307195) > 0 or Toggles.RotationModes.Off()
    end,
    GetMissingHP = function (theUnit)
        if unit.deadOrGhost(theUnit) then
            return 0
        end
        if unit.distance("player", theUnit) > 40 then
            return 0
        end
        if not unit.exists(theUnit) then
            return 0
        end
        local actualHealth = unit.health(theUnit) + br._G.UnitGetIncomingHeals(theUnit)
        local missingHealth = unit.healthMax(theUnit) - actualHealth
        if missingHealth <= healingValues.envelopingMist * 3 and buff.envelopingMist.remains(theUnit) >= 3 then
            -- print(missingHealth)
            missingHealth = missingHealth - healingValues.envelopingMist * 3
            -- print(missingHealth)
        end
        if missingHealth < 0 then
            missingHealth = 0
        end
        return missingHealth
    end,
    ShouldApplyMysticTouch = function ()
        return #enemies.yards8 - mysticTouchCount >= 2
    end,
    Attack = function (theUnit)
        if unit.deadOrGhost("target") or unit.distance("target") >= 5 then
            br._G.ClearTarget()
        end
        if theUnit == "target" then theUnit = br._G.UnitGUID(theUnit) end
        if theUnit == nil then
            theUnit = enemies.yards5[1]
        end
        if br._G.UnitGUID(target) ~= theUnit then
           br._G.TargetUnit(theUnit)
           br._G.StartAttack(theUnit)
        end
    end
}
FunctionsUtilities.CountMissingHPFromAllies = function (value, unitTable)
    local lowAllies = 0
    for i = 1, #unitTable do
        if FunctionsUtilities.GetMissingHP(unitTable[i].unit) >= value then
            lowAllies = lowAllies + 1
        end
    end
    return lowAllies
end

local VariablesUtilities = {
    LoadBadRotation = function ()
        player              = br.player
        buff                = player.buff
        cast                = player.cast
        cd                  = player.cd
        charges             = player.charges
        debuff              = player.debuff
        enemies             = player.enemies
        gcd                 = player.gcd
        spell               = player.spell
        talent              = player.talent
        unit                = player.unit
        runeforge           = player.runeforge

        player.health           = unit.health()
        player.maxHealth        = unit.healthMax()
        player.versatility      = 1 + ((GetCombatRatingBonus(CR_VERSATILITY_DAMAGE_DONE) + GetVersatilityBonus(CR_VERSATILITY_DAMAGE_DONE)) / 100)
        player.mastery          = select(1, GetMasteryEffect("player"))
        player.spellPower       = GetSpellBonusDamage(4)
        
        lowestUnit      = unit.lowest(40)

        friends         = br.friend

        enemies.get(5)--enemies.yards5
        enemies.get(5, "player", false, true)
        enemies.get(6)--enemies.yards6
        enemies.get(8)--enemies.yards8
        enemies.get(20)--enemies.yards20
        enemies.get(40)--enemies.yards20

        mysticTouchCount = debuff.mysticTouch.refreshCount(8)
        for i = 1, #friends do
            if friends[i] then
                if friends[i].class == "Monk" and friends[i].unit ~= "player" then
                    mysticTouchCount = 99
                    break;
                end
            end
        end
        mysticTouchUnit = debuff.mysticTouch.lowest(5)

        JadeSerpentStatueDuration = 0
        YulonDuration = 0
        ChiJiDuration = 0

        tankUnit = "player"
        tanks = br.getTanksTable()
        if #tanks > 0 then
            tankUnit = tanks[1].unit
        end

        player.mana         = player.power.mana.percent()
        if buff.prideful.exists("player") then
            player.mana = 100
        end
    end,
    LoadTotemEstimateDurations = function ()
        for index = 1, 4 do
            local exists, totemName, startTime, duration, _ = GetTotemInfo(index)
            if exists and totemName ~= nil then
                local estimateDuration = br.round2(startTime + duration - GetTime())
                if string.find(totemName, "Jade") then
                    JadeSerpentStatueDuration = estimateDuration
                elseif string.find(totemName, "Yu'lon") then
                    YulonDuration = estimateDuration
                elseif string.find(totemName, "Chi") then
                    ChiJiDuration = estimateDuration
                end
            end
        end
    end,
    LoadSoothingMistUnit = function ()
        soothingMistUnit = nil
        for i = 1, #friends do
            local tempUnit = friends[i]
            if FunctionsUtilities.IsAuraActive(tempUnit.unit, 115175) then
                soothingMistUnit = tempUnit.unit
                break
            end
        end
    end,
    LoadHealingVariables = function ()
-- https://www.wowhead.com/spell=115151/renewing-mist

        -- https://www.wowhead.com/spell=191894
        healingValues.gustOfMist = (0.001 + (player.mastery / 100)) * player.spellPower * player.versatility
        -- https://www.wowhead.com/spell=116670
        healingValues.vivify = 1.41 * player.spellPower * player.versatility
        healingValues.vivifyRenewingMist = 1.04 * player.spellPower * player.versatility
        -- https://www.wowhead.com/spell=124682
        healingValues.envelopingMist = 0.6 * player.spellPower * player.versatility
        -- https://www.wowhead.com/spell=343655
        healingValues.envelopingBreath = 0.3 * player.spellPower * player.versatility
        -- https://www.wowhead.com/spell=116680
        healingValues.envelopingMistThunderFocusTea = 2.8 * player.spellPower * player.versatility
        -- https://www.wowhead.com/spell=322101
        healingValues.expelHarm = 1.2 * player.spellPower * player.versatility
        -- https://www.wowhead.com/spell=116849
        healingValues.lifeCocoon = 0.6 * player.maxHealth * player.versatility
        -- https://www.wowhead.com/spell=115310
        healingValues.revival = 2.83 * player.spellPower * player.versatility
        -- https://www.wowhead.com/spell=115175
        healingValues.soothingMist = 0.55 * player.spellPower * player.versatility
        -- https://www.wowhead.com/spell=191837
        healingValues.essenceFont = 0.472 * player.spellPower * player.versatility
        -- https://www.wowhead.com/spell=100780
        healingValues.tigerPalm = 0.27027 * player.spellPower * player.versatility * resistance * (250 / 100)
        -- https://www.wowhead.com/spell=100784
        healingValues.blackoutKick = 0.77 * player.spellPower * player.versatility * resistance * (250 / 100)
        -- https://www.wowhead.com/spell=107428
        -- 143.8%-12%
        healingValues.risingSunKick = 1.90800 * player.spellPower * player.versatility * resistance * (250 / 100)
    end
}


local ExtraActions = {
    RunDetox = function()
        if Toggles.DetoxModes.Off() then
            return false
        end
        if cd.detox.exists() then
            return false
        end
        if unit.hp(lowestUnit) <= 15 then
            return false
        end
        if soothingMistUnit ~= nil then
            return false
        end
        local instanceID = br.getCurrentZoneId()
        local debuffsIDs = mythicListDetox[0]
        if mythicListDetox[instanceID] then
            for k, v in pairs(mythicListDetox[instanceID]) do
                debuffsIDs[k] = v
            end
        end
        for j = 1, #debuffsIDs do
            local theDebuff = debuffsIDs[j]
            for i = 1, #friends do
                local dispelUnit = friends[i]
                if FunctionsUtilities.IsValidToDetox(theDebuff, dispelUnit) then
                    if br.UnitDebuffID(dispelUnit.unit, theDebuff.spellID) and br.getLineOfSight(dispelUnit.unit) and br.getDistance(dispelUnit.unit) <= 40 then
                        return cast.detox(dispelUnit.unit)
                    end
                end
            end
        end
    end,
    RunInterrupt = function ()
        if unit.hp(lowestUnit) <= 40 then
            return false
        end
        if Toggles.InterruptModes.On() then
            if Options.LegSweep:Checked() and cd.legSweep.ready() and cast.able.legSweep() then
                local temp = _G.foreach(enemies.yards6, function(index, enemyGUID)
                    if unit.interruptable(enemyGUID, Options.InterruptAt:Value()) and not FunctionsUtilities.IsUnitImmune(enemyGUID, spell.legSweep) then
                        return cast.legSweep("player")
                    end
                end)
                if temp then return temp end
            end
            -- Paralysis
            if Options.Paralysis:Checked() and cd.paralysis.ready() then
                local temp = _G.foreach(enemies.yards20, function(index, enemyGUID)
                    if br._G.UnitChannelInfo(enemyGUID) and not FunctionsUtilities.IsUnitImmune(enemyGUID, spell.paralysis) then
                        return cast.paralysis(enemyGUID)
                    end
                end)
                if temp then return temp end
            end
        end
    end,
    TouchOfDeathFinish = function(TheUnit)
        br._G.SpellStopCasting()
        br._G.StartAttack(TheUnit)
        if cast.touchOfDeath(TheUnit) then
            return true
        end
    end,
    Manual = function ()
        if Options.ManualRingOfPeace:Checked() and Options.ManualRingOfPeace:Toggled() then
            if talent.ringOfPeace and cd.ringOfPeace.ready() then
                if br._G.IsUsableSpell(spell.ringOfPeace) then
                    br._G.CastSpellByName(br._G.GetSpellInfo(spell.ringOfPeace), "cursor")
                    return true
                end
            end
            return false
        end
    end
}
ExtraActions.KillWithTouchOfDeath = function(TheUnit)
    if unit.facing("player", TheUnit) then
        if br._G.UnitIsPlayer(TheUnit) then
            if unit.hp(TheUnit) <= 15 then return ExtraActions.TouchOfDeathFinish(TheUnit) end
        elseif unit.isBoss(TheUnit) then
            if unit.health("player") > unit.health(TheUnit) then
                return ExtraActions.TouchOfDeathFinish(TheUnit)
            end
        elseif Options.TrashTouchOfDeathLife:Checked() and
            unit.health("player") > unit.health(TheUnit) and
            unit.healthMax(TheUnit) >= Options.TrashTouchOfDeathLife:Value() * 1000 then
            return ExtraActions.TouchOfDeathFinish(TheUnit)
        end
    end
end

local ActionList = {
    RunAlways = function ()
        if cd.lifeCocoon.ready() and FunctionsUtilities.GetMissingHP(lowestUnit) >= healingValues.lifeCocoon and unit.inCombat() and unit.hp(lowestUnit) <= 30 then
            return cast.lifeCocoon(lowestUnit)
        end
        if cast.active.essenceFont() then
            if #friends > 5 then
                return true
            elseif gcd <= 0.1 then
                br._G.SpellStopCasting()
            elseif gcd > 0.1 then
                return true
            end
        end
        -- Self Healing
        if talent.healingElixir and br.timer:useTimer("healingElixir", 0.5) and unit.inCombat() then
            if (charges.healingElixir.count() > 1 and player.health <= 75 and soothingMistUnit == nil) or (charges.healingElixir.count() > 0 and player.health <= 45 and soothingMistUnit == nil) then
                return cast.healingElixir("player")
            end
        end
        -- Healthstone
        if Options.Healthstone:Checked() and player.health <= Options.Healthstone:Value() and br.hasItem(5512) then
            if br.canUseItem(5512) then
                br.useItem(5512)
            end
        end
        if gcd <= 0.1 then
            if #friends == 5 then
                revivalLimit = 3
            elseif #friends > 5 then
                revivalLimit = 8
            end
            -- Revival
            if cd.revival.ready() and Options.Revival:Checked() and FunctionsUtilities.CountMissingHPFromAllies(healingValues.revival * 2, friends) >= revivalLimit and unit.inCombat() then
                return cast.revival()
            end
            -- Essence font
            if not cast.active.essenceFont() and cd.essenceFont.ready() and not cast.active.vivify() and soothingMistUnit == nil and player.mana >= 35 and
            buff.essenceFont.remains(lowestUnit) <= 2 and FunctionsUtilities.CountMissingHPFromAllies(3000, friends) >= revivalLimit then
                return cast.essenceFont("player")
            end
            -- Fortifying Brew
            if cd.fortifyingBrew.ready() and unit.inCombat() and Options.FortifyingBrew:Checked() and player.health <= Options.FortifyingBrew:Value()  then
                return cast.fortifyingBrew("player")
            end
            -- Expel Harm
            if cd.expelHarm.ready() and unit.inCombat() and unit.hp(lowestUnit) >= 50 and FunctionsUtilities.GetMissingHP("player") >= HealingValues.GetExpelHarm("player") and
                    soothingMistUnit == nil and ChiJiDuration == 0 then
                return cast.expelHarm("player")
            end
            -- Dampen Harm
            if talent.dampenHarm and Options.DampenHarm:Checked() and player.health <= Options.DampenHarm:Value() and cd.dampenHarm.ready() then
                return cast.dampenHarm("player")
            end
            -- Diffuse Magic
            if talent.diffuseMagic and Options.DiffuseMagic:Checked() and player.health <=  Options.DiffuseMagic:Value() and cd.diffuseMagic.ready() then
                return cast.diffuseMagic("player")
            end
            -- Interrupt
            if ExtraActions.RunInterrupt() then
                return
            end
            -- Explosive Affix
            -- TODO, move this to DG UTILS
            if soothingMistUnit == nil then
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if unit.isExplosive(thisUnit) and (unit.hp(lowestUnit) >= 40 or br.getCastTimeRemain(thisUnit) <= 2) then
                        if unit.distance(thisUnit) <= 5 and cd.tigerPalm.ready() and cast.able.tigerPalm(thisUnit) then
                            br._G.FaceDirection(thisUnit, true)
                            return cast.tigerPalm(thisUnit)
                        end
                        if not player.isMoving and cd.cracklingJadeLightning.ready() and cast.able.cracklingJadeLightning(thisUnit) then
                            br._G.FaceDirection(thisUnit, true)
                            return cast.cracklingJadeLightning(thisUnit)
                        end
                    end
                end
            end

            if cd.touchOfDeath.ready() and unit.hp(lowestUnit) >= 40 then
                if Options.TouchOfDeath:Checked() then
                    _G.foreach(enemies.yards5, function(index, enemyGUID)
                        -- 174773
                        if unit.id(enemyGUID) ~= 174773 then
                            if ExtraActions.KillWithTouchOfDeath(enemyGUID) then return true end
                        end
                    end)
                end
            end
            -- Detox
            if cast.timeSinceLast.detox() > 6 and ExtraActions.RunDetox() then
                return true
            end

            -- Renewing Mist
            if charges.renewingMist.exists() and cd.renewingMist.ready() and soothingMistUnit == nil and ChiJiDuration == 0 and unit.hp(lowestUnit) > 40 then
                for i = 1, #friends do
                    local tempUnit = friends[i]
                    if not buff.renewingMist.exists(tempUnit.unit) then
                        return cast.renewingMist(tempUnit.unit)
                    end
                end
            end
            -- Refreshing Jade Wind
            -- TODO
            -- if talent.summonJadeSerpentStatue then
            --     local px, py, pz = br._G.ObjectPosition("player")
            --     local distance = br._G.GetDistanceBetweenPositions(px, py, pz, jadeSerpentStatue.x, jadeSerpentStatue.y, jadeSerpentStatue.z)
            --     -- Jade Statue Soothing Mist
            --     if cast.timeSinceLast.soothingMist() > 7 and soothingMistUnit == nil and distance < 35 and totemInfoJadeSerpentStatueDuration > 0 then
            --         br._G.C_Timer.After(0.8, function()
            --             br._G.SpellStopCasting()
            --         end)
            --         return cast.soothingMist(lowestUnit)
            --     end
            --     if cd.summonJadeSerpentStatue.ready() and unit.hp(lowestUnit) >= 75 then
            --         if distance > 38 or totemInfoJadeSerpentStatueDuration <= 5 then
            --             px = px + math.random(-2, 2)
            --             py = py + math.random(-2, 2)
            --             if br.castGroundAtLocation({x = px, y = py, z = pz}, spell.summonJadeSerpentStatue) then
            --                 return true
            --             end
            --         end
            --     end
            -- end
        end
        return false
    end,
    RunHealRotation = function()
        if gcd <= 0.1 then
            -- AOE
            if not cast.active.vivify() then
                local countUnitsWithRenewingMistUnderHealth = 0
                for i = 1, #friends do
                    local tempUnit = friends[i]
                    if buff.renewingMist.exists(tempUnit.unit) and FunctionsUtilities.GetMissingHP(tempUnit.unit) >= HealingValues.GetVivifyRenewingMistHealing(tempUnit.unit) then
                        countUnitsWithRenewingMistUnderHealth = countUnitsWithRenewingMistUnderHealth + 1
                    end
                end
                if not buff.renewingMist.exists(lowestUnit) then
                    countUnitsWithRenewingMistUnderHealth = countUnitsWithRenewingMistUnderHealth + 1
                end
                if countUnitsWithRenewingMistUnderHealth >= 2 then
                    if soothingMistUnit == nil then
                        if FunctionsUtilities.GetMissingHP(lowestUnit) >= HealingValues.GetVivifyHealing(lowestUnit) * 2 + HealingValues.GetSoothingMistHealing(lowestUnit) * 2 then
                            if player.mana <= 75 and talent.manaTea and cd.manaTea.ready() then
                                cast.manaTea("player")
                            end
                            -- print("Casting Soothing Mist AOE")
                            return cast.soothingMist(lowestUnit)
                        end
                    else
                        if buff.envelopingMist.remains(soothingMistUnit) < 2 then
                            local totalHeal = HealingValues.GetSoothingMistHealing(soothingMistUnit) * 2 + HealingValues.GetEnvelopingMistHealing(soothingMistUnit) * 2 +
                                                                                                           HealingValues.GetVivifyHealing(soothingMistUnit, true) * 2
                            if FunctionsUtilities.GetMissingHP(soothingMistUnit) >= totalHeal then
                                -- print("Enveloping Mist AOE Soothing Mist")
                                if cd.thunderFocusTea.ready() and FunctionsUtilities.GetMissingHP(soothingMistUnit) >= totalHeal + healingValues.envelopingMistThunderFocusTea then
                                    cast.thunderFocusTea("player")
                                end
                                return cast.envelopingMist(soothingMistUnit)
                            end
                        end
                        if FunctionsUtilities.GetMissingHP(soothingMistUnit) >= HealingValues.GetSoothingMistHealing(soothingMistUnit) + HealingValues.GetVivifyHealing(soothingMistUnit) then
                            -- print("Vivify AOE Soothing Mist")
                            return cast.vivify(soothingMistUnit)
                        end
                    end
                end
            end
            -- ST
            if soothingMistUnit ~= nil and soothingMistUnit ~= lowestUnit and (unit.hp(soothingMistUnit) >= 75 or unit.hp(soothingMistUnit) - unit.hp(lowestUnit) >= 25) then
                br._G.SpellStopCasting()
            end
            if not cast.active.vivify() and soothingMistUnit == nil and (
                        (FunctionsUtilities.GetMissingHP(lowestUnit) >= HealingValues.GetSoothingMistHealing(lowestUnit) * 2 + HealingValues.GetEnvelopingMistHealing(lowestUnit)
                                                                                                                         * 2 + HealingValues.GetVivifyHealing(lowestUnit, true)) or
                        #br.getEnemies(tankUnit, 10, true) >= 3 or (FunctionsUtilities.GetMissingHP(lowestUnit) >= HealingValues.GetSoothingMistHealing(lowestUnit)
                                                                                                                    * 2 + HealingValues.GetEnvelopingMistHealing(lowestUnit) * 4)) then
                if player.mana <= 75 and talent.manaTea and cd.manaTea.ready() then
                    cast.manaTea("player")
                end
                -- print("Casting Soothing Mist ST")
                return cast.soothingMist(lowestUnit)
            end
            if soothingMistUnit ~= nil then
                if buff.envelopingMist.remains(soothingMistUnit) < 2 then
                    local totalHeal = HealingValues.GetSoothingMistHealing(soothingMistUnit) + HealingValues.GetEnvelopingMistHealing(soothingMistUnit) * 2 + HealingValues.GetVivifyHealing(soothingMistUnit, true)
                    if FunctionsUtilities.GetMissingHP(soothingMistUnit) >= totalHeal then
                        -- print("Enveloping Mist ST Soothing Mist")
                        if cd.thunderFocusTea.ready() and FunctionsUtilities.GetMissingHP(soothingMistUnit) >= totalHeal + healingValues.envelopingMistThunderFocusTea then
                            cast.thunderFocusTea("player")
                        end
                        return cast.envelopingMist(soothingMistUnit)
                    end
                    totalHeal = HealingValues.GetSoothingMistHealing(soothingMistUnit) + HealingValues.GetEnvelopingMistHealing(soothingMistUnit) * 4
                    if FunctionsUtilities.GetMissingHP(soothingMistUnit) >= totalHeal then
                        -- print("Enveloping Mist ST Soothing Mist")
                        if cd.thunderFocusTea.ready() and FunctionsUtilities.GetMissingHP(soothingMistUnit) >= totalHeal + healingValues.envelopingMistThunderFocusTea then
                            cast.thunderFocusTea("player")
                        end
                        return cast.envelopingMist(soothingMistUnit)
                    end
                    if soothingMistUnit == tankUnit and #br.getEnemies(tankUnit, 10, true) >= 3 then
                        return cast.envelopingMist(soothingMistUnit)
                    end
                end
                if FunctionsUtilities.GetMissingHP(soothingMistUnit) >= HealingValues.GetSoothingMistHealing(soothingMistUnit) + HealingValues.GetVivifyHealing(soothingMistUnit) then
                    -- print("Vivify ST Soothing Mist")
                    return cast.vivify(soothingMistUnit)
                end
            end
            if soothingMistUnit == nil and not cast.active.vivify() and FunctionsUtilities.GetMissingHP(lowestUnit) >= HealingValues.GetVivifyHealing(lowestUnit) then
                -- print("Vivify ST: Missing Health: " .. FunctionsUtilities.GetMissingHP(lowestUnit) .. " Expected to heal: " .. HealingValues.GetVivifyHealing(lowestUnit))
                return cast.vivify(lowestUnit)
            end
        end
        return false
    end,
    RunDamageRotationChiJi = function()
        if gcd <= 0.1 then
            if cd.envelopingMist.ready() then
                if buff.invokeChiJiTheRedCrane.stack() == 3 or (ChiJiDuration == 0 and buff.invokeChiJiTheRedCrane.stack() > 0 and not player.moving) then
                    local theUnit
                    for i = 1, #friends do
                        local tempUnit = friends[i]
                        if buff.envelopingMist.remains(tempUnit.unit) < 2 and theUnit == nil then
                            theUnit = tempUnit.unit
                        end
                    end
                    if theUnit == nil then
                        theUnit = lowestUnit
                    end
                    if cd.thunderFocusTea.ready() and FunctionsUtilities.GetMissingHP(theUnit) >= HealingValues.GetEnvelopingMistHealing(theUnit) + healingValues.envelopingMistThunderFocusTea then
                        cast.thunderFocusTea("player")
                    end
                    return cast.envelopingMist(theUnit)
                end
            end
            -- essence font legendary?
            if cd.risingSunKick.ready() then
                return cast.risingSunKick(mysticTouchUnit)
            end

            if cd.blackoutKick.ready() then
                if (buff.invokeChiJiTheRedCrane.stack() == 0 and buff.teachingsOfTheMonastery.stack() == 3) or
                    (buff.invokeChiJiTheRedCrane.stack() == 0 and buff.teachingsOfTheMonastery.stack() == 2) or
                    (buff.invokeChiJiTheRedCrane.stack() == 1 and buff.teachingsOfTheMonastery.stack() == 1) then
                    return cast.blackoutKick(mysticTouchUnit)
                end
            end

            if cd.spinningCraneKick.ready() and not cast.active.spinningCraneKick() and #enemies.yards8 - mysticTouchCount >= 3 then
                return cast.spinningCraneKick("player")
            end
            if cd.tigerPalm.ready() and buff.teachingsOfTheMonastery.stack() < 3 then
                return cast.tigerPalm(mysticTouchUnit)
            end
            if buff.invokeChiJiTheRedCrane.stack() < 3 then
                return cast.spinningCraneKick("player")
            end
        end
        return false
    end,
    RunDamageRotationAncientTeachingsOfTheMonastery = function()
        if gcd <= 0.1 then
            if cd.spinningCraneKick.ready() and not cast.active.spinningCraneKick() and #enemies.yards8 - mysticTouchCount >= 3 then
                return cast.spinningCraneKick("player")
            end
            if (not buff.ancientTeachingOfTheMonastery.exists() or buff.ancientTeachingOfTheMonastery.remains() <= 3) and cd.essenceFont.ready() then
                return cast.essenceFont("player")
            end
            if cd.risingSunKick.ready() and (FunctionsUtilities.GetMissingHP(lowestUnit) >= healingValues.risingSunKick or Options.IgnoreHealthAncientTeachings:Checked()) then
                if cd.thunderFocusTea.ready() then
                    cast.thunderFocusTea("player")
                end
                return cast.risingSunKick(mysticTouchUnit)
            end
            if cd.blackoutKick.ready() then
                if (buff.teachingsOfTheMonastery.stack() == 3 and FunctionsUtilities.GetMissingHP(lowestUnit) >= healingValues.blackoutKick * 4) or
                    (buff.teachingsOfTheMonastery.stack() == 2 and FunctionsUtilities.GetMissingHP(lowestUnit) >= healingValues.blackoutKick * 3) or
                    (buff.teachingsOfTheMonastery.stack() == 1 and FunctionsUtilities.GetMissingHP(lowestUnit) >= healingValues.blackoutKick * 2 and not talent.spiritOfTheCrane) or
                    (buff.teachingsOfTheMonastery.stack() == 0 and FunctionsUtilities.GetMissingHP(lowestUnit) >= healingValues.blackoutKick * 1 and not talent.spiritOfTheCrane) or 
                    Options.IgnoreHealthAncientTeachings:Checked() then
                    return cast.blackoutKick(mysticTouchUnit)
                end
            end
            if (FunctionsUtilities.GetMissingHP(lowestUnit) >= healingValues.tigerPalm or Options.IgnoreHealthAncientTeachings:Checked()) or buff.teachingsOfTheMonastery.stack() < 3 then
                if cd.tigerPalm.ready() then
                    return cast.tigerPalm(mysticTouchUnit)
                end
            end
            return cast.spinningCraneKick("player")
        end
        return false
    end,
    RunDamageRotationFallenOrder = function()
        if gcd <= 0.1 then
            if cd.spinningCraneKick.ready() and not cast.active.spinningCraneKick() and #enemies.yards8 - mysticTouchCount >= 3 then
                return cast.spinningCraneKick("player")
            end
            if cd.risingSunKick.ready() then
                return cast.risingSunKick(mysticTouchUnit)
            end
            if cd.spinningCraneKick.ready() and not cast.active.spinningCraneKick() then
                return cast.spinningCraneKick("player")
            end
        end
        return false
    end,
    RunDamageRotationNormal = function()
        if gcd <= 0.1 then
            if cd.spinningCraneKick.ready() and not cast.active.spinningCraneKick() and #enemies.yards8 - mysticTouchCount >= 3 then
                return cast.spinningCraneKick("player")
            end
            if cd.risingSunKick.ready() then
                return cast.risingSunKick(mysticTouchUnit)
            end
            if not talent.spiritOfTheCrane or (talent.spiritOfTheCrane and buff.teachingsOfTheMonastery.stack() == 3) then
                if cd.blackoutKick.ready() then
                    return cast.blackoutKick(mysticTouchUnit)
                end
            end
            if #enemies.yards8 >= 3 and (not talent.spiritOfTheCrane or (talent.spiritOfTheCrane and player.mana >= 75)) then
                if cd.spinningCraneKick.ready() and not cast.active.spinningCraneKick() then
                    return cast.spinningCraneKick("player")
                end
            else
                if cd.tigerPalm.ready() then
                    return cast.tigerPalm(mysticTouchUnit)
                end
            end
        end
        return false
    end,
}

----------------
--- ROTATION ---
----------------
local function runRotation()
    
    if not Options then
        print("Open Rotation Options")
        return false
    end
    if FunctionsUtilities.IsPause() then
        return
    end

    VariablesUtilities.LoadBadRotation()
    VariablesUtilities.LoadTotemEstimateDurations()
    VariablesUtilities.LoadSoothingMistUnit()
    VariablesUtilities.LoadHealingVariables()

    if ExtraActions.Manual() then
        return
    end

    if Toggles.RotationModes.DPS() or
    (Toggles.RotationModes.Auto() and
        (FunctionsUtilities.GetMissingHP(lowestUnit) < HealingValues.GetVivifyHealing(lowestUnit) or
        (ChiJiDuration > 0 or buff.invokeChiJiTheRedCrane.stack() > 0))) then
        FunctionsUtilities.Attack(mysticTouchUnit)
        -- ....
        if ActionList.RunAlways() then
            return true
        elseif FunctionsUtilities.ShouldApplyMysticTouch() then
            return cast.spinningCraneKick("player")
        elseif unit.distance(target) <= 5 then
            if ChiJiDuration > 0 or buff.invokeChiJiTheRedCrane.stack() > 0 then
                if ActionList.RunDamageRotationChiJi() then
                    return true
                end
                return false
            elseif buff.fallenOrder.exists("player") then
                if ActionList.RunDamageRotationFallenOrder() then
                    return true
                end
                return false
            elseif runeforge.ancientTeachingsOfTheMonastery.equiped then
                if ActionList.RunDamageRotationAncientTeachingsOfTheMonastery() then
                    return true
                end
                return false
            else
                return ActionList.RunDamageRotationNormal()
            end
        end
        -- ....
    end

    if Toggles.RotationModes.Heal() or
    (Toggles.RotationModes.Auto() and FunctionsUtilities.GetMissingHP(lowestUnit) >= HealingValues.GetVivifyHealing(lowestUnit)) then
        return ActionList.RunAlways() or ActionList.RunHealRotation()
    end

end

local id = 270
if br.rotations[id] == nil then br.rotations[id] = {} end

tinsert(br.rotations[id], {
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation
})
