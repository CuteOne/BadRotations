local rotationName = "KinkDestruction"
local VerNum = "1.3.1"
local colorOrange = "|cffFF7C0A"
local colorfel = "|cff00ff00"
local colorWhite = "|cff000000"
local ExhaustionUnits="165762"
local DontDotUnits="171557"
local FearList="165251"
local var = {}

---------------
--- Toggles ---
---------------
local function createToggles()
    -- Rotation Button
    local RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell.chaosBolt},
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.rainOfFire},
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.immolate},
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.healthFunnel}
    };
    br.ui:createToggle(RotationModes,"Rotation",1,0)

    -- Cooldown Button
    local CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.summonInfernal},
        [2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.summonInfernal},
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.summonInfernal}
    };
    br.ui:createToggle(CooldownModes,"Cooldown",2,0)

    -- Defensive Button
    local DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.unendingResolve},
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.unendingResolve}
    };
    br.ui:createToggle(DefensiveModes,"Defensive",3,0)

    -- Interrupt Button
    local InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.spellLock},
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.spellLock}
    };
    br.ui:createToggle(InterruptModes,"Interrupt",4,0)

    local CataclysmModes = {
        [1] = { mode = "On", value = 1 , overlay = "Cataclysm Enabled", tip = "Will Use Cataclysm in Rotation.", highlight = 1, icon = br.player.spell.cataclysm},
        [2] = { mode = "Off", value = 2 , overlay = "Cataclysm Disabled", tip = "Will Not Use Cataclysm in Rotation.", highlight = 0, icon = br.player.spell.cataclysm}
    };
    br.ui:createToggle(CataclysmModes,"Cataclysm",5,0)

        -- Dot Blacklist button
    local DotBlacklistModes = {
        [1] = { mode = "On", value = 1 , overlay = "Dot Blacklist Enabled", tip = "Dot Blacklist Enabled.", highlight = 1, icon = br.player.spell.corruption},
        [2] = { mode = "Off", value = 2 , overlay = "Dot Blacklist Disabled", tip = "Dot Blacklist Disabled.", highlight = 0, icon = br.player.spell.corruption}
    };
    br.ui:createToggle(DotBlacklistModes,"DotBlacklist",2,1)

    --Pet summon
    local PetSummonModes = {
        [1] = { mode = "1", value = 1 , overlay = "Imp", tip = "Summon Imp", highlight = 1, icon = br.player.spell.summonImp },
        [2] = { mode = "2", value = 2 ,overlay = "Voidwalker", tip = "Summon Voidwalker.", highlight = 1, icon = br.player.spell.summonVoidwalker },
        [3] = { mode = "3", value = 3 , overlay = "Felhunter", tip = "Summon Felhunter.", highlight = 1, icon = br.player.spell.summonFelhunter },
        [4] = { mode = "4", value = 4 , overlay = "Succubus", tip = "Summon Succubus.", highlight = 1, icon = br.player.spell.summonSuccubus },
        [5] = { mode = "None", value = 5 , overlay = "No pet", tip = "Dont Summon any Pet.", highlight = 0, icon = br.player.spell.conflagrate }
    };
    br.ui:createToggle(PetSummonModes,"PetSummon",3,1)
    
    -- Burning Rush button
    local BurningRushModes = {
        [1] = { mode = "On", value = 1 , overlay = "Burning Rush Enabled", tip = "Burning Rush Enabled.", highlight = 1, icon = br.player.spell.burningRush},
        [2] = { mode = "Off", value = 2 , overlay = "Burning Rush Disabled", tip = "Burning Rush Disabled.", highlight = 0, icon = br.player.spell.burningRush}
    };
    br.ui:createToggle(BurningRushModes,"BurningRush",1,1)
end

---------------
--- OPTIONS ---
---------------
local function createOptions()

    local GeneralOptions = function()
    -- General Options
        section = br.ui:createSection(br.ui.window.profile, 
        colorWhite .. "Fire" .. 
        colorfel .. " .:|:. " .. 
        colorWhite .. "General ".. 
        colorfel.."Ver: " ..
        colorWhite .. VerNum .. 
        colorfel.." .:|:. ")
        -- Multi-Target Units
        br.ui:createSpinnerWithout(section, "Multi-Target Units", 3, 1, 25, 1, "|cffFFBB00Health Percentage to use at.")

        
        -- Burning Rush Health Cancel Percent
        br.ui:createSpinnerWithout(section, "Burning Rush Health", 79, 1, 100, 1, "|cffFFBB00Health Percentage to cancel at.")

        -- Burning Rush Health Cancel Percent
        br.ui:createSpinnerWithout(section, "Burning Rush Delay", 6, 1, 10, 0.1, "|cffFFBB00Delay between casting Burning Rush")
        -- APL
        br.ui:createDropdownWithout(section, "APL Mode", {"|cffFFFFFFSimC","|cffFFFFFFAMR"}, 1, "|cffFFFFFFSet APL Mode to use.")
        
        -- Cataclysm
        br.ui:createCheckbox(section, "Auto Target")
        -- Cataclysm
        br.ui:createCheckbox(section, "Auto Engage")
        -- No Dot units
        br.ui:createScrollingEditBoxWithout(section,"Dot Blacklist Units", dotBlacklist, "List of units to blacklist when multidotting", 240, 40)


        -- Dummy DPS Test
        br.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")

        -- -- Pre-Pull Timer
        --     br.ui:createSpinner(section, "Pre-Pull Timer",  5,  1,  10,  1,  "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
        -- -- Opener
        --     br.ui:createCheckbox(section,"Opener")
            -- Pet Management
            br.ui:createCheckbox(section, "Pet Management", "|cffFFFFFF Select to enable/disable auto pet management")

            -- Fel Domination
            br.ui:createCheckbox(section, "Fel Domination", "|cffFFFFFF Toggle the auto casting of Fel Donmination")

            -- Fel Domination on low pet health
        br.ui:createCheckbox(section, "Fel Domination New Pet", "|cffFFBB00 Toggle the auto casting of Fel Donmination when your pet is low health.")
        -- Pet Summon 
        br.ui:createSpinnerWithout(section, "FelDom Pet HP", 8, 1, 100, 0.1, "|cffFFBB00Health percent of your pet to cast Fel Domination and re-summon your pet.")
		-- Summon Pet
		--br.ui:createDropdownWithout(section, "Summon Pet", {"|cffb28cc7Felguard", "|cffb28cc7Imp", "|cffb28cc7Voidwalker", "|cffb28cc7Felhunter", "|cffb28cc7Succubus", "|cffb28cc7None"}, 1, "|cffb28cc7Select default pet to summon.")

            -- Pet - Auto Attack/Passive
            br.ui:createCheckbox(section, "Pet - Auto Attack/Passive")

        -- -- Grimoire of Service
        --     br.ui:createDropdownWithout(section, "Grimoire of Service - Pet", {"Imp","Voidwalker","Felhunter","Succubus","Felguard","None"}, 1, "|cffFFFFFFSelect pet to Grimoire.")
        --     br.ui:createDropdownWithout(section,"Grimoire of Service - Use", {"|cff00FF00Everything","|cffFFFF00Cooldowns","|cffFF0000Never"}, 1, "|cffFFFFFFWhen to use Grimoire Ability.")
            -- Multi-Dot Limit
            br.ui:createSpinnerWithout(section, "Multi-Dot Limit", 5, 0, 10, 1, "|cffFFFFFFUnit Count Limit that DoTs will be cast on.")

        --     br.ui:createSpinnerWithout(section, "Multi-Dot HP Limit", 5, 0, 10, 1, "|cffFFFFFFHP Limit that DoTs will be cast/refreshed on.")
        --     br.ui:createSpinnerWithout(section, "Immolate Boss HP Limit", 10, 1, 20, 1, "|cffFFFFFFHP Limit that Immolate will be cast/refreshed on in relation to Boss HP.")
            -- Cataclysm
            br.ui:createCheckbox(section, "Cataclysm")

            -- Use Essence
            br.ui:createCheckbox(section, "Curse of Tongues")
            
            -- Use Essence
            br.ui:createCheckbox(section, "Curse of Weakness")

            -- Cataclysm Units
            br.ui:createSpinnerWithout(section, "Cataclysm Units", 1, 1, 10, 1, "|cffFFFFFFNumber of Units Cataclysm will be cast on.")

            -- Cata with CDs
            br.ui:createCheckbox(section,"Ignore Cataclysm units when using CDs")

            -- Cataclysm Target
            br.ui:createDropdownWithout(section, "Cataclysm Target", {"Target", "Best"}, 1, "|cffFFFFFFCataclysm target")

            -- Predict movement
            br.ui:createCheckbox(section, "Predict Movement (Cata)", "|cffFFFFFF Predict movement of units for cataclysm (works best in solo/dungeons)")

            -- Rain of Fire
            br.ui:createSpinner(section, "Rain of Fire", 3, 1, 5, 1, "|cffFFFFFFUnit Count Minimum that Rain of Fire will be cast on.")

        -- -- Life Tap
        --     br.ui:createSpinner(section, "Life Tap", 30, 0, 100, 5, "|cffFFFFFFHP Limit that Life Tap will not cast below.")
        -- -- Chaos Bolt
        --     br.ui:createSpinnerWithout(section, "Chaos Bolt at Shards", 3, 2, 5, 1, "|cffFFFFFFNumber of Shards to use Chaos Bolt At.")
            br.ui:checkSectionState(section)
        end
    local CooldownOptions = function()
        -- Cooldown Options
      section = br.ui:createSection(br.ui.window.profile, 
      colorWhite .. "CDs" .. 
      colorfel .. " .:|:. " .. 
      colorWhite .. "Cooldowns ".. 
      colorfel.."Ver: " ..
      colorWhite .. VerNum .. 
      colorfel.." .:|:. ")
            -- Racial
            br.ui:createCheckbox(section,"Racial")

            -- Trinkets
            br.ui:createCheckbox(section,"Trinkets")

            -- Summon Infernal
            br.ui:createCheckbox(section,"Summon Infernal")

        br.ui:checkSectionState(section)
    end
    local DefensiveOptions = function() 
        -- Defensive Options
        section = br.ui:createSection(br.ui.window.profile, 
        colorWhite .. "DEF" .. 
        colorfel .. " .:|:. " .. 
        colorWhite .. "Defensive ".. 
        colorfel.."Ver: " ..
        colorWhite .. VerNum .. 
        colorfel.." .:|:. ")
        
            -- Basic Healing Module
            br.player.module.BasicHealing(section)

            -- FlaskUp Module
            br.player.module.FlaskUp("Intellect",section)
                        
            -- Trinkets
            br.player.module.BasicTrinkets(nil,section)
            -- Soulstone
		    br.ui:createDropdown(section, "Soulstone", {"|cffFFFFFFTarget","|cffFFFFFFMouseover","|cffFFFFFFTank", "|cffFFFFFFHealer", "|cffFFFFFFHealer/Tank", "|cffFFFFFFAny", "|cffFFFFFFPlayer"},
            1, "|cffFFFFFFTarget to cast on")

            -- Healthstone
            br.ui:createSpinner(section, "Health Funnel Cancel Cast",  85,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cancel At")
            
            -- Healthstone
            br.ui:createSpinner(section, "Drain Life Cancel Cast",  85,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cancel At")

            -- Create Healthstone
            br.ui:createCheckbox(section,"Create Healthstone", "|cffFFFFFFToggle the creation of healthstones")

            -- Shadow Bulwark
            br.ui:createSpinner(section, "Shadow Bulwark",  60,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")

            -- Cooldowns Key
            br.ui:createDropdown(section, "Cooldowns",  br.dropOptions.Toggle, 6, "|cffFFBB00Hold to cast Dark Soul/Infernal/Other cds.")

            -- Cooldowns Key
            br.ui:createDropdown(section, "Summon Infernal",  br.dropOptions.Toggle, 6, "|cffFFBB00Hold to summon infernal.")
            
            -- Demonic Gateway
            br.ui:createDropdown(section, "Demonic Gateway", br.dropOptions.Toggle, 6)

            -- Demonic Circle Summon
            br.ui:createDropdown(section, "Demonic Circle Summon", br.dropOptions.Toggle, 6)

            -- Demonic Circle Teleport
            br.ui:createDropdown(section, "Demonic Circle Teleport", br.dropOptions.Toggle, 6)

            -- Heirloom Neck
            br.ui:createSpinner(section, "Heirloom Neck",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");

            -- Gift of The Naaru
            if br.player.race == "Draenei" then
                br.ui:createSpinner(section, "Gift of the Naaru",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            end

            -- Dark Pact
            br.ui:createSpinner(section, "Dark Pact", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
            
            -- Mortal Coil 
            br.ui:createSpinner(section, "Mortal Coil",  23,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")

            -- Drain Life
            br.ui:createSpinner(section, "Drain Life", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")

            -- Health Funnel
            br.ui:createSpinner(section, "Health Funnel (Demon)", 50, 0, 100, 5, "|cffFFFFFFHealth Percent of Demon to Cast At")
            br.ui:createSpinnerWithout(section, "Health Funnel (Player)", 50, 0, 100, 5, "|cffFFFFFFHealth Percent of Player to Cast At")

            -- Unending Resolve
            br.ui:createSpinner(section, "Unending Resolve", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")

            -- Devour Magic
            br.ui:createDropdown(section,"Devour Magic", {"|cffFFFF00Selected Target","|cffFFBB00Auto"}, 1, "|ccfFFFFFFTarget to Cast On")

        br.ui:checkSectionState(section)
    end
    local InterruptOptions = function()
        -- Interrupt Options
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
            br.ui:createDropdown(section, "Shadowfury Key", br.dropOptions.Toggle, 6)
            -- Interrupt Percentage
            br.ui:createSpinner(section, "Interrupt At",  0,  0,  95,  5,  "|cffFFFFFFCast Percent to Cast At")
        br.ui:checkSectionState(section)
    end
    local ToggleKeyOptions = function()
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
        [1] = "General Options",
        [2] = GeneralOptions,
    },
    {
        [1] = "Cooldown Options",
        [2] = CooldownOptions,
        },

            {
        [1] = "Defensive Options",
        [2] = DefensiveOptions,
        },

            {
        [1] = "Interrupt Options",
        [2] = InterruptOptions,
        },

            {
        [1] = "Toggle Hotkeys",
        [2] = ToggleKeyOptions,
        },
    }
    return optionTable
end

--------------
--- Locals ---
--------------
-- BR API Locals
local buff
local cast
local cd
local charges
local debuff
local debug
local enemies
local equiped
local flying, swimming, moving
local gcdMax
local has
local healPot
local inCombat
local item
local level
local mode
local module
local opener
local ui
local pet
local php
local pullTimer
local race
local racial
local shards
local spell
local talent
local traits
local ttd
local units
local use
local solo
-- General Locals
local castSummonId = 0
local combatTime
local flashover
local havocRemain = 0
local infernalCast = GetTime()
local infernalRemain = 0
local inferno
local internalInferno
local lastSpell
local lastTargetX, lastTargetY, lastTargetZ = 0, 0, 0
local okToDoT
local petPadding = 2
local poolShards = false
local summonId = 0
local summonPet
local tanks = br.getTanksTable()
local targetMoveCheck = false

if br.lastImmo == nil then br.lastImmo = "player" end
if br.pauseTime == nil then br.pauseTime = GetTime() end

local immoTick = tonumber((select(1, GetSpellDescription(348):match("%d+"))))
if immoTick ~= nil then
    if (select(2, IsInInstance()) == "party" or select(2, IsInInstance()) == "raid") then
        immoTick = immoTick * 50
    else
        immoTick = immoTick *5
    end
end

-----------------
--- Functions ---
-----------------
    -- spellqueue ready
    local function spellQueueReady()
        --Check if we can queue cast
        local castingInfo = {br._G.UnitCastingInfo("player")}
        if castingInfo[5] then
            if (GetTime() - ((castingInfo[5] - tonumber(C_CVar.GetCVar("SpellQueueWindow")))/1000)) < 0 then
                return false
            end
        end
        return true
    end
        -- spell usable check
    local function spellUsable(spellID)
        if br.isKnown(spellID) and not select(2, IsUsableSpell(spellID)) and br.getSpellCD(spellID) == 0 then
            return true
        end
        return false
    end

function CastClick()
  if IsMouseButtonDown(1) and MainMenuBar:IsShown() then 
    local mousefocus = GetMouseFocus() 
    if mousefocus and mousefocus.feedback_action 
    then SpellCancelQueuedSpell() PQR_DelayRotation(1) end
  end
end

--------------------------------------------------

function IsHealer(t)
local class = select(2, br._G.UnitClass(t))
if (class == "DRUID" or class =="PALADIN" or class =="PRIEST" or class =="MONK" or class =="SHAMAN")
and br._G.UnitPowerMax(t) >= 290000
and not br.UnitBuffID(t, 24858)
and not br.UnitBuffID(t, 15473)
and not br.UnitBuffID(t, 324)
then
return true
end
end


    local function isMelee(unit)
        if unit == nil then unit = "target" end
        local class = select(2, br._G.UnitClass(unit))
        if (class == "DRUID" or class =="PALADIN" or class =="WARRIOR" or class =="MONK" or class =="SHAMAN" or class =="DEATHKNIGHT" or class =="ROGUE" or class =="DEMONHUNTER" )and br._G.UnitPowerMax(unit) < 70000 then
            return true
        end
    end

--------------------------------------------------
function inRange(t,spellID)
if br.GetUnitExists(t)
and IsSpellInRange(GetSpellInfo(spellID),t) == 1
	then
		return true
	end
end


    --[[local noDotUnits = {}
    for i in string.gmatch(br.getOptionValue("Dot Blacklist Units"), "%d+") do
        noDotUnits[tonumber(i)] = true
    end

    local function noDotCheck(unit)
        if mode.dbl ~= 2 then
            if (noDotUnits[br.GetObjectID(unit)] or br._G.UnitIsCharmed(unit)) then
                return true
            end
            if isTotem(unit) then
                return true
            end
            local unitCreator = br._G.UnitCreator(unit)
            if unitCreator ~= nil and br._G.UnitIsPlayer(unitCreator) ~= nil and br._G.UnitIsPlayer(unitCreator) == true then
                return true
            end
            if br.GetObjectID(unit) == 137119 and br.getBuffRemain(unit, 271965) > 0 then
                return true
            end
            return false
        end
    end]]

--------------------
--- Action Lists ---
--------------------
local actionList = {}
-- Action List - Extras
actionList.Extras = function()
    -- Dummy Test
    if ui.checked("DPS Testing") then
        if br.GetObjectExists("target") then
            if br.getCombatTime() >= (tonumber(ui.value("DPS Testing"))*60) and br.isDummy() then
                br._G.StopAttack()
                br._G.ClearTarget()
                if ui.checked("Pet Management") then
                    br._G.PetStopAttack()
                    br._G.PetFollow()
                end
                br._G.print(tonumber(ui.value("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
                br.profileStop = true
            end
        end
    end -- End Dummy Test
    if br.isChecked("Pig Catcher") then
        br.bossHelper()
    end

    -- Healthstone healer OoC
if inInstance then   
    for i = 1, #br.friend do
        if br._G.UnitIsPlayer(br.friend[i].unit) and not br.GetUnitIsDeadOrGhost(br.friend[i].unit) 
        and br.GetUnitIsFriend(br.friend[i].unit, "player") 
        and(br._G.UnitGroupRolesAssigned(br.friend[i].unit) == "HEALER" or br.friend[i].role == "HEALER")
        and not buff.soulstone.exists
        then
            if cast.soulstone(br.friend[i].unit, "dead") then
                br.addonDebug("Casting Soulstone")
                return true
            end
        end
    end
end

    -- Demonic Gateway
    if br.SpecificToggle("Demonic Gateway") and not GetCurrentKeyBoardFocus() then
        if br.timer:useTimer("DG Delay", 1) and br._G.CastSpellByName(GetSpellInfo(spell.demonicGateway),"cursor") then br.addonDebug("Casting Demonic Gateway") return end 
        if br._G.IsAoEPending() then br._G.CancelPendingSpell() end
    end

    -- Demonic Circle: Summon
    if br.SpecificToggle("Demonic Circle Summon") and not GetCurrentKeyBoardFocus() then
        if br.timer:useTimer("DC Delay", 1) then cast.demonicCircle("player") br.addonDebug("Demonic Circle (Summon)") return true end 
    end
    -- Demonic Circle: Teleport
    if br.SpecificToggle("Demonic Circle Teleport") and not GetCurrentKeyBoardFocus() then
        if br.timer:useTimer("DC Delay", 1) and buff.demonicCircle.exists() then cast.demonicTeleport("player") br.addonDebug("Demonic Circle (Summon)") return true end 
    end
end

-- Action List - Defensive
actionList.Defensive = function()
    if br.useDefensive() then
        -- Basic Healing Module
        module.BasicHealing()

        -- Soulstone
        if br.isChecked("Soulstone") and not moving and inCombat and br.timer:useTimer("Soulstone", 4) then
            if
                br.getOptionValue("Soulstone") == 1 and -- Target
                    br._G.UnitIsPlayer("target") and
                    br.GetUnitIsDeadOrGhost("target") and
                    br.GetUnitIsFriend("target", "player")
                then
                if cast.soulstone("target", "dead") then
                    br.addonDebug("Casting Soulstone")
                    return true
                end
            end
            if
                br.getOptionValue("Soulstone") == 2 and -- Mouseover
                    br._G.UnitIsPlayer("mouseover") and
                    br.GetUnitIsDeadOrGhost("mouseover") and
                    br.GetUnitIsFriend("mouseover", "player")
                then
                if cast.soulstone("mouseover", "dead") then
                    br.addonDebug("Casting Soulstone")
                    return true
                end
            end
            if br.getOptionValue("Soulstone") == 3 then -- Tank
                for i = 1, #tanks do
                    if br._G.UnitIsPlayer(tanks[i].unit) and br.GetUnitIsDeadOrGhost(tanks[i].unit) and br.GetUnitIsFriend(tanks[i].unit, "player") and br.getDistance(tanks[i].unit) <= 40 then
                        if cast.soulstone(tanks[i].unit, "dead") then
                            br.addonDebug("Casting Soulstone")
                            return true
                        end
                    end
                end
            end
            if br.getOptionValue("Soulstone") == 4 then -- Healer
                for i = 1, #br.friend do
                    if
                        br._G.UnitIsPlayer(br.friend[i].unit) and br.GetUnitIsDeadOrGhost(br.friend[i].unit) and br.GetUnitIsFriend(br.friend[i].unit, "player") and
                            (br._G.UnitGroupRolesAssigned(br.friend[i].unit) == "HEALER" or br.friend[i].role == "HEALER")
                        then
                        if cast.soulstone(br.friend[i].unit, "dead") then
                            br.addonDebug("Casting Soulstone")
                            return true
                        end
                    end
                end
            end
            if br.getOptionValue("Soulstone") == 5 then -- Tank/Healer
                for i = 1, #br.friend do
                    if
                        br._G.UnitIsPlayer(br.friend[i].unit) and br.GetUnitIsDeadOrGhost(br.friend[i].unit) and br.GetUnitIsFriend(br.friend[i].unit, "player") and
                            (br._G.UnitGroupRolesAssigned(br.friend[i].unit) == "HEALER" or br.friend[i].role == "HEALER" or br.friend[i].role == "TANK" or br._G.UnitGroupRolesAssigned(br.friend[i].unit) == "TANK")
                        then
                        if cast.soulstone(br.friend[i].unit, "dead") then
                            br.addonDebug("Casting Soulstone")
                            return true
                        end
                    end
                end
            end
            if br.getOptionValue("Soulstone") == 6 then -- Any
                for i = 1, #br.friend do
                    if br._G.UnitIsPlayer(br.friend[i].unit) and br.GetUnitIsDeadOrGhost(br.friend[i].unit) and br.GetUnitIsFriend(br.friend[i].unit, "player") then
                        if cast.soulstone(br.friend[i].unit, "dead") then
                            br.addonDebug("Casting Soulstone")
                            return true
                        end
                    end
                end
            end
        end

                    -- Mortal Coil
            if ui.checked("Mortal Coil") and php <= ui.value("Mortal Coil") then
                if cast.mortalCoil() then br.addonDebug("Casting Mortal Coil") return true end
            end

        -- Heirloom Neck
        if ui.checked("Heirloom Neck") and php <= ui.value("Heirloom Neck") then
            if use.able.heirloomNeck() and item.heirloomNeck ~= 0
                and item.heirloomNeck ~= item.manariTrainingAmulet
            then
                if use.heirloomNeck() then debug("Using Heirloom Neck") return true end
            end
        end

        -- Gift of the Naaru
        if ui.checked("Gift of the Naaru") and php <= ui.value("Gift of the Naaru")
            and php > 0 and race == "Draenei"
        then
            if cast.racial() then debug("Casting Racial: Gift of the Naaru") return true end
        end

        -- Dark Pact
        if ui.checked("Dark Pact") and php <= ui.value("Dark Pact") then
            if cast.darkPact() then debug("Casting Dark Pact") return true end
        end

        -- Drain Life
        if ui.checked("Drain Life") and php <= ui.value("Drain Life") and br.isValidTarget("target") and not br.isCastingSpell(spell.drainLife) then
            if cast.drainLife() then debug("Casting Drain Life") return true end
        end

        -- Health Funnel
        if not moving and ui.checked("Health Funnel (Demon)") and br.getHP("pet") <= ui.value("Health Funnel (Demon)") and br.getHP("player") >= ui.value("Health Funnel (Player)") and br.GetObjectExists("pet") and not br.GetUnitIsDeadOrGhost("pet") then
            if cast.healthFunnel() then debug("Casting Health Funnel") return true end
        end

        -- Unending Resolve
        if ui.checked("Unending Resolve") and php <= ui.value("Unending Resolve") and inCombat then
            if cast.unendingResolve() then debug("Casting Unending Resolve") return true end
        end

        -- Devour Magic
        if br.isChecked("Devour Magic") and (pet.active.id() == 417 or pet.active.id() == 78158) then
            if br.getOptionValue("Devour Magic") == 1 then
                if br.canDispel("target",spell.devourMagic) and br.GetObjectExists("target") then
                    br._G.CastSpellByName(GetSpellInfo(spell.devourMagic),"target") br.addonDebug("Casting Devour Magic") return true 
                end
            elseif br.getOptionValue("Devour Magic") == 2 then
                for i = 1, #enemies.yards30 do
                    local thisUnit = enemies.yards30[i]
                    if br.canDispel(thisUnit,spell.devourMagic) then
                        br._G.CastSpellByName(GetSpellInfo(spell.devourMagic),thisUnit) br.addonDebug("Casting Devour Magic") return true 
                    end
                end
            end
        end
    end -- End Defensive Toggle
end

-- Action List - Interrupts
actionList.Interrupts = function()
    if br.useInterrupts() and (pet.active.id() == 417 or pet.active.id() == 78158) then
        for i=1, #enemies.yards30 do
            local thisUnit = enemies.yards30[i]
            if br.canInterrupt(thisUnit,ui.value("Interrupt At")) then
                if pet.active.id() == 417 then
                    if cast.spellLock(thisUnit) then return true end
                elseif pet.active.id() == 78158 then
                    if cast.shadowLock(thisUnit) then return true end
                end
            end
        end
    end -- End br.useInterrupts check
end

-- Action List - Cooldowns
actionList.Cooldowns = function()
    if br.useCDs() then
        ------------------------------------------------
        -- Trinkets ------------------------------------
        ------------------------------------------------
        module.BasicTrinkets()
        -- Immolate
        -- immolate,if=talent.grimoire_of_supremacy.enabled&remains<8&cooldown.summon_infernal.remains<4.5
        if br._G.UnitHealth("target") >= immoTick and ttd("target") >= 9 and not moving and cast.able.immolate() and okToDoT and not cast.last.immolate() and (talent.grimoireOfSupremacy
            and debuff.immolate.remain("target") <= 10 and cd.summonInfernal.remain() < 4.5)
        then
            if cast.immolate() then debug("Cast Immolate [CD]") return true end
        end
        -- Conflagrate
        -- conflagrate,if=talent.grimoire_of_supremacy.enabled&cooldown.summon_infernal.remains<4.5&!buff.backdraft.up&soul_shard<4.3
        if cast.able.conflagrate() and (talent.grimoireOfSupremacy and cd.summonInfernal.remain() < 4.5
            and not buff.backdraft.exists() and shards < 4.3)
        then
            if cast.conflagrate() then debug("Cast Conflagrate [CD]") return true end
        end
        -- Summon Infernal
        -- summon_infernal
        if br.timer:useTimer("Infernal Delay", 2) and ui.checked("Summon Infernal") and br.getDistance("target") <= 30 then
            if cast.summonInfernal(nil,"aoe",1,8) then infernalCast = GetTime() debug("Cast Summon Infernal [CD]") return true end
        end
        -- Dark Soul: Instability
        -- dark_soul_instability,if=pet.infernal.active&(pet.infernal.remains<20.5|pet.infernal.remains<22&soul_shard>=3.6|!talent.grimoire_of_supremacy.enabled)
        if cast.able.darkSoulInstability() and (pet.infernal.active()
            and (infernalRemain < 20.5 or infernalRemain < 22 and shards >= 3.6
                or not talent.grimoireOfSupremacy))
        then
            if cast.darkSoulInstability() then debug("Cast Dark Soul Instability [CD]") return true end
        end
        -- Summon Infernal
        -- summon_infernal,if=target.time_to_die>cooldown.summon_infernal.duration+30
        if br.timer:useTimer("Infernal Delay", 2) and ui.checked("Summon Infernal") and (ttd("target") > cd.summonInfernal.duration() + 30) and br.getDistance("target") <= 30 then
            if cast.summonInfernal(nil,"aoe",1,8) then infernalCast = GetTime() debug("Cast Summon Infernal [CD - High TTD]") return true end
        end
        -- Summon Infernal
        -- summon_infernal,if=talent.dark_soul_instability.enabled&cooldown.dark_soul_instability.remains>target.time_to_die
        if br.timer:useTimer("Infernal Delay", 2) and ui.checked("Summon Infernal") and (talent.darkSoulInstability
            and cd.darkSoulInstability.remain() > ttd("target")) and br.getDistance("target") <= 30
        then
            if cast.summonInfernal(nil,"aoe",1,8) then infernalCast = GetTime() debug("Cast Summon Infernal [CD - Dark Soul]") return true end
        end
        -- Dark Soul: Instability
        -- dark_soul_instability,if=cooldown.summon_infernal.remains>target.time_to_die&pet.infernal.remains<20.5
        if cast.able.darkSoulInstability() and (cd.summonInfernal.remain() > ttd("target")
            and infernalRemain < 20.5)
        then
            if cast.darkSoulInstability() then debug("Cast Dark Soul Instability [CD - Infernal]") return true end
        end
        -- Summon Infernal
        -- summon_infernal,if=target.time_to_die<30
        if br.timer:useTimer("Infernal Delay", 2) and ui.checked("Summon Infernal") and (ttd("target") < 30) and br.getDistance("target") <= 30 then
            if cast.summonInfernal(nil,"aoe",1,8) then infernalCast = GetTime() debug("Cast Summon Infernal [CD - Low TTD]") return true end
        end
        -- Dark Soul: Instability
        -- dark_soul_instability,if=target.time_to_die<21&target.time_to_die>4
        if cast.able.darkSoulInstability() and (ttd("target") < 21 and ttd("target") > 4) then
            if cast.darkSoulInstability() then debug("Cast Dark Soul Instability [CD - Low TTD]") return true end
        end
        -- Potion
        -- -- potion,if=pet.infernal.active|target.time_to_die<30
        -- if cast.able.potion() and (pet.infernal.active or ttd(units.dyn40) < 30) then
        --     if cast.potion() then return true end
        -- end
        -- Racial - Troll
        -- berserking,if=pet.infernal.active&(!talent.grimoire_of_supremacy.enabled|(!essence.memory_of_lucid_dreams.major|buff.memory_of_lucid_dreams.remains)&(!talent.dark_soul_instability.enabled|buff.dark_soul_instability.remains))|target.time_to_die<=15
        if ui.checked("Racial") and cast.able.racial() and (pet.infernal.active() 
        and (not talent.grimoireOfSupremacy 
        and (not talent.darkSoulInstability or buff.darkSoulInstability.remain()))
        or ttd("target") <= 15 and race == "Troll")
        then
            if cast.racial() then debug("Cast Berserking [CD]") return true end
        end
        -- Racial - Orc
        -- blood_fury,if=pet.infernal.active&(!talent.grimoire_of_supremacy.enabled|(!essence.memory_of_lucid_dreams.major|buff.memory_of_lucid_dreams.remains)&(!talent.dark_soul_instability.enabled|buff.dark_soul_instability.remains))|target.time_to_die<=15
        if ui.checked("Racial") and cast.able.racial() and (pet.infernal.active() 
        and (not talent.grimoireOfSupremacy
        and (not talent.darkSoulInstability or buff.darkSoulInstability.remain()))
        or ttd("target") <= 15 and race == "Orc")
        then
            if cast.racial() then debug("Cast Blood Fury [CD]") return true end
        end
        -- Racial - Dark Iron Dwarf
        -- fireblood,if=pet.infernal.active&(!talent.grimoire_of_supremacy.enabled|(!essence.memory_of_lucid_dreams.major|buff.memory_of_lucid_dreams.remains)&(!talent.dark_soul_instability.enabled|buff.dark_soul_instability.remains))|target.time_to_die<=15
        if ui.checked("Racial") and cast.able.racial() and (pet.infernal.active() 
            and (not talent.grimoireOfSupremacy
            and (not talent.darkSoulInstability or buff.darkSoulInstability.remain()))
            or ttd("target") <= 15 and race == "DarkIronDwarf")
        then
            if cast.racial() then debug("Cast Fireblood [CD]") return true end
        end
        -- Item - General
        -- use_items,if=pet.infernal.active&(!talent.grimoire_of_supremacy.enabled|pet.infernal.remains<=20)|target.time_to_die<=20
        
    end
end

-- Action List - Aoe
actionList.Aoe = function()
  if spellQueueReady() then
    -- Rain Of Fire
    -- rain_of_fire,if=pet.infernal.active&(buff.crashing_chaos.down|!talent.grimoire_of_supremacy.enabled)&(!cooldown.havoc.ready|active_enemies>3)
    if (pet.infernal.active()
        and (not buff.crashingChaos.exists() or not talent.grimoireOfSupremacy)
        and (cd.havoc.exists())) and br.getDistance("target") <= 40
    then
        if br.timer:useTimer("RoF Delay", 1) and cast.rainOfFire(nil,"aoe",1,8,true) then debug("Cast Rain Of Fire [AOE - Infernal]") return true end
    end

    -- Channel Demonfire
    -- channel_demonfire,if=dot.immolate.remains>cast_time
    if not moving and cast.able.channelDemonfire() and (debuff.immolate.remain("target") > cast.time.channelDemonfire()) then
        if cast.channelDemonfire() then debug("Cast Channel Demonfire [AOE]") return true end
    end

    -- Immolate
    -- immolate,cycle_targets=1,if=remains<5&(!talent.cataclysm.enabled|cooldown.cataclysm.remains>remains)
    if not moving and cast.able.immolate() then
        for i = 1, #enemies.yards40f do
            local thisUnit = enemies.yards40f[i]
            if okToDoT and br._G.UnitHealth(thisUnit) >= immoTick and ttd(thisUnit) >= 9 and  (debuff.immolate.remain(thisUnit) <= 10 and (not ui.checked("Cataclysm") or not talent.cataclysm 
            or cd.cataclysm.remain() > debuff.immolate.remain(thisUnit))) 
            then
                if not br.GetUnitIsUnit(thisUnit,br.lastImmo) then
                    if cast.immolate(thisUnit) then debug("Cast Immolate [AOE]") br.lastImmo = thisUnit; br.lastImmoCast = GetTime() return true end
                else
                    if br.lastImmoCast == nil or GetTime() - br.lastImmoCast > 6.5 then
                        if cast.immolate(thisUnit) then debug("Cast Immolate [AOE Same Target]") br.lastImmo = thisUnit; br.lastImmoCast = GetTime() return true end
                    end
                end
            end
        end
    end

    -- Call Action List - Cooldowns
    -- call_action_list,name=cds
    if actionList.Cooldowns() then return true end

    -- Havoc
    -- havoc,cycle_targets=1,if=!(target=self.target)&active_enemies<4
    if cast.able.havoc() then
        for i = 1, #enemies.yards40f do
            local thisUnit = enemies.yards40f[i]
            if ttd(thisUnit) > 10 and (not (br.GetUnitIsUnit("target",thisUnit)) and #enemies.yards40f < 4) then
                if cast.havoc(thisUnit) then debug("Cast Havoc [AOE - Less than 4]") return true end
            end
        end
    end

    -- Chaos Bolt
    -- chaos_bolt,if=talent.grimoire_of_supremacy.enabled&pet.infernal.active&(havoc_active|talent.cataclysm.enabled|talent.inferno.enabled&active_enemies<4)
    if not moving and #enemies.yards8t < ui.value("Rain of Fire")  and cast.timeSinceLast.chaosBolt() > gcdMax
        and (talent.grimoireOfSupremacy and (pet.infernal.active() or not br.useCDs())
        and (debuff.havoc.count() > 0  or talent.cataclysm or talent.inferno and #enemies.yards40 < 4))
    then
        if cast.chaosBolt() then debug("Cast Chaos Bolt [AOE]") return true end
    end

    -- Rain of Fire
    -- rain_of_fire
    if ui.checked("Rain of Fire") and br.getDistance("target") <= 40 and #enemies.yards8t >= ui.value("Rain of Fire") then
        if br.timer:useTimer("RoF Delay", 1) and cast.rainOfFire(nil,"aoe",1,8,true) then debug("Cast Rain Of Fire [AOE]") return true end
    end

    -- Havoc
    -- havoc,cycle_targets=1,if=!(target=self.target)&(!talent.grimoire_of_supremacy.enabled|!talent.inferno.enabled|talent.grimoire_of_supremacy.enabled&pet.infernal.remains<=10)
    if cast.able.havoc() then
        for i = 1, #enemies.yards40f do
            local thisUnit = enemies.yards40f[i]
            if ttd(thisUnit) > 10 and (not (br.GetUnitIsUnit("target",thisUnit)) and (not talent.grimoireOfSupremacy
                or not talent.inferno or talent.grimoireOfSupremacy and infernalRemain <= 10))
            then
                if cast.havoc(thisUnit) then debug("Cast Rain Of Fire [AOE]") return true end
            end
        end
    end

    -- Incinerate
    -- incinerate,if=talent.fire_and_brimstone.enabled&buff.backdraft.up&soul_shard<5-0.2*active_enemies
    if not moving and cast.able.incinerate() and cast.timeSinceLast.incinerate() > gcdMax
        and (talent.fireAndBrimstone and buff.backdraft.exists() and shards < 5 - 0.2 * #enemies.yards40f)
    then
        if cast.incinerate() then debug("Cast Incinerate [AOE - Fire And Brimstone]") return true end
    end

    -- Soul Fire
    -- soul_fire
    if not moving and cast.able.soulFire() then
        if cast.soulFire() then debug("Cast Soul Fire [AOE]") return true end
    end

    -- Conflagrate
    -- conflagrate,if=buff.backdraft.down
    if cast.able.conflagrate() and (not buff.backdraft.exists()) then
        if cast.conflagrate() then debug("Cast Conflagrate [AOE]") return true end
    end

    -- Shadowburn
    -- shadowburn,if=!talent.fire_and_brimstone.enabled
    if cast.able.shadowburn() and (not talent.fireAndBrimstone) then
        if cast.shadowburn() then debug("Cast Shadowburn [AOE]") return true end
    end

    -- Incinerate
    -- incinerate
    if not moving and cast.able.incinerate() and cast.timeSinceLast.incinerate() > gcdMax then
        if cast.incinerate() then debug("Cast Incinerate [AOE]") return true end
    end 
end
end

-- Action List - GosupInfernal
actionList.GosupInfernal = function()
  if spellQueueReady() then
    -- Rain of Fire
    -- rain_of_fire,if=soul_shard=5&!buff.backdraft.up&buff.memory_of_lucid_dreams.up&buff.grimoire_of_supremacy.stack<=10
    if ui.checked("Rain of Fire") and #enemies.yards8t >= ui.value("Rain of Fire")
        and (shards == 5 and not buff.backdraft.exists() 
        and buff.grimoireOfSupremacy.stack() <= 10) and br.getDistance("target") <= 40
    then
        if br.timer:useTimer("RoF Delay", 1) and cast.rainOfFire(nil,"aoe",1,8,true) then debug("Cast Rain Of Fire [GosupInfernal]") return true end
    end

    -- Chaos Bolt
    -- chaos_bolt,if=buff.backdraft.up
    if not moving  and cast.timeSinceLast.chaosBolt() > gcdMax and (buff.backdraft.exists()) then
        if cast.chaosBolt() then debug("Cast Chaos Bolt [GosupInfernal - Backdraft]") return true end
    end

    -- chaos_bolt,if=soul_shard>=4.2-buff.memory_of_lucid_dreams.up
    if not moving  and cast.timeSinceLast.chaosBolt() > gcdMax and (shards >= 4.2) then
        if cast.chaosBolt() then debug("Cast Chaos Bolt [GosupInfernal - High Shards]") return true end
    end

    -- chaos_bolt,if=!cooldown.conflagrate.up
    if not moving  and cast.timeSinceLast.chaosBolt() > gcdMax and (not cd.conflagrate.exists()) then
        if cast.chaosBolt() then debug("Cast Chaos Bolt [GosupInfernal - Conflagrate]") return true end
    end

    -- chaos_bolt,if=cast_time<pet.infernal.remains&pet.infernal.remains<cast_time+gcd
    if not moving  and cast.timeSinceLast.chaosBolt() > gcdMax
        and (cast.time.chaosBolt() < infernalRemain and infernalRemain < cast.time.chaosBolt() + gcdMax)
    then
        if cast.chaosBolt() then debug("Cast Chaos Bolt [GosupInfernal - Infernal]") return true end
    end

    -- Conflagrate
    -- conflagrate,if=buff.backdraft.down&buff.memory_of_lucid_dreams.up&soul_shard>=1.3
    if cast.able.conflagrate() and (not buff.backdraft.exists() and shards >= 1.3)
    then
        if cast.conflagrate() then debug("Cast Conflagrate [GosupInfernal - Lucid Dreams]") return true end
    end

    -- conflagrate,if=buff.backdraft.down&!buff.memory_of_lucid_dreams.up&(soul_shard>=2.8|charges_fractional>1.9&soul_shard>=1.3)
    if cast.able.conflagrate() and (not buff.backdraft.exists() 
        and (shards >= 2.8 or charges.conflagrate.frac() > 1.9 and shards >= 1.3))
    then
        if cast.conflagrate() then debug("Cast Conflagrate [GosupInfernal - High Charges]") return true end
    end

    -- conflagrate,if=pet.infernal.remains<5
    if cast.able.conflagrate() and (infernalRemain < 5) then
        if cast.conflagrate() then debug("Cast Conflagrate [GosupInfernal - Infernal Low]") return true end
    end
    
    -- conflagrate,if=charges>1
    if cast.able.conflagrate() and (charges.conflagrate.count() > 1) then
        if cast.conflagrate() then debug("Cast Conflagrate [GosupInfernal - More Than 1 Charge]") return true end
    end

    -- Soul Fire
    -- soul_fire
    if not moving and cast.able.soulFire() then
        if cast.soulFire() then debug("Cast Soul Fire [GosupInfernal]") return true end
    end

    -- Shadowburn
    -- shadowburn
    if cast.able.shadowburn() then
        if cast.shadowburn() then debug("Cast Shadowburn [GosupInfernal]") return true end
    end

    -- Incinerate
    -- incinerate
    if not moving and cast.able.incinerate() and cast.timeSinceLast.incinerate() > gcdMax then
        if cast.incinerate() then debug("Cast Incinerate [GosupInfernal]") return true end
    end
end
end

-- Action List - Havoc
actionList.Havoc = function()
  if spellQueueReady() then
    -- Conflagrate
    -- conflagrate,if=buff.backdraft.down&soul_shard>=1&soul_shard<=4
    if cast.able.conflagrate() and ((not buff.backdraft.exists() or charges.conflagrate.count() == 2)
        and shards >= 1 and shards <= 4)
    then
        if cast.conflagrate() then debug("Cast Conflagrate [Havoc]") return true end
    end
    -- Immolate
    -- immolate,if=talent.internal_combustion.enabled&remains<duration*0.5|!talent.internal_combustion.enabled&refreshable
    if not moving and br._G.UnitHealth("target") >= immoTick and ttd("target") >= 9 and cast.able.immolate() and okToDoT and not cast.last.immolate()
        and (talent.internalCombustion and debuff.immolate.remain("target") < debuff.immolate.duration() * 0.5
            or not talent.internalCombustion and debuff.immolate.refresh("target"))
    then
        if cast.immolate() then debug("Cast Immolate [Havoc]") return true end
    end
    -- Chaos Bolt
    -- chaos_bolt,if=cast_time<havoc_remains
    if not moving  and cast.timeSinceLast.chaosBolt() > gcdMax and (cast.time.chaosBolt() < havocRemain) then
        if cast.chaosBolt() then debug("Cast Chaos Bolt [Havoc]") return true end
    end
    -- Soul Fire
    -- soul_fire
    if not moving and cast.able.soulFire() then
        if cast.soulFire() then debug("Cast Soul Fire [Havoc]") return true end
    end
    -- Shadowburn
    -- shadowburn,if=active_enemies<3|!talent.fire_and_brimstone.enabled
    if cast.able.shadowburn() and (#enemies.yards40 < 3 or not talent.fireAndBrimstone) then
        if cast.shadowburn() then debug("Cast Shadowburn [Havoc]") return true end
    end
    -- Incinerate
    -- incinerate,if=cast_time<havoc_remains
    if not moving and cast.able.incinerate() and cast.timeSinceLast.incinerate() > gcdMax and (cast.time.incinerate() < havocRemain) then
        if cast.incinerate() then debug("Cast Incinerate [Havoc]") return true end
    end
end
end

-- Action List - Opener
actionList.Opener = function()

end

-- Action List - PreCombat
actionList.PreCombat = function()
    if ui.checked("Fel Domination") and inCombat and not br.GetObjectExists("pet") or br.GetUnitIsDeadOrGhost("pet") and cd.felDomination.remain() <= gcdMax then
        if cast.felDomination() then br.addonDebug("Fel Domination") return true end
    end
    -- Summon Pet
    -- summon_pet
    if ui.checked("Pet Management") 
    and not (IsFlying() or IsMounted()) 
    and (not inCombat or buff.felDomination.exists())
    and (not moving or buff.felDomination.exists())
    and GetTime() - br.pauseTime > 0.5 and level >= 5
        and br.timer:useTimer("summonPet", 1.4)and not moving
    then
        if mode.petSummon == 5 and pet.active.id() ~= 0 then
            br._G.PetDismiss()
        end
        if (pet.active.id() == 0 or pet.active.id() ~= summonId) and (lastSpell ~= castSummonId
            or pet.active.id() ~= summonId or pet.active.id() == 0)
        then
            if mode.petSummon == 1 then
                if cast.summonImp("player") then castSummonId = spell.summonImp return true end
            elseif mode.petSummon == 2 then
                if cast.summonVoidwalker("player") then castSummonId = spell.summonVoidwalker return true end
            elseif mode.petSummon == 3 then
                if cast.summonFelhunter("player") then castSummonId = spell.summonFelhunter return true end
            elseif mode.petSummon == 4  then
                if cast.summonSuccubus("player") then castSummonId = spell.summonSuccubus return true end
            end
        end
    end

    --if UnitChannelInfo("player") == GetSpellInfo(spell.healthFunnel) and php >= ui.value ("Health Funnel Cancel Cast") then SpellStopCasting() return true end 
    --if UnitChannelInfo("player") == GetSpellInfo(spell.drainLife) and php >= ui.value("Drain Life Cancel Cast") then SpellStopCasting() return true end


        if not moving and not inCombat and br.isChecked("Soulstone") and br.getOptionValue("Soulstone") == 7 then -- Player
            if not br.GetUnitIsDeadOrGhost("player") and not moving and not inCombat then
                if cast.soulstone("player") then br.addonDebug("Casting Soulstone [Player]" ) return true end
            end
        end

        -- Create Healthstone
        if not moving and not inCombat and ui.checked("Create Healthstone") then
            if GetItemCount(5512) < 1 and br.timer:useTimer("CH", 5) then
                if cast.createHealthstone() then br.addonDebug("Casting Create Healthstone" ) return true end
            end
         end

    if not inCombat and br.isValidUnit("target") and br.getDistance("target") < 40 and br.getFacing("player","target") then
        -- Grimoire Of Sacrifice
        -- grimoire_of_sacrifice,if=talent.grimoire_of_sacrifice.enabled
        if cast.able.grimoireOfSacrifice() and (talent.grimoireOfSacrifice) then
            if cast.grimoireOfSacrifice() then debug("Cast Grimoire Of Sacrifice [Pre-Pull]") return true end
        end

        -- Pre-Pot
        -- potion
        -- Soul Fire
        -- soul_fire
        if not moving and talent.soulFire and cast.able.soulFire() and not cast.last.soulFire()  then
            if cast.soulFire("target") then debug("Cast Soul Fire [Pre-Pull]") return true end
        end

        -- Incinerate
        -- incinerate,if=!talent.soul_fire.enabled
        if not moving and not talent.soulFire and br.timer:useTimer("incDelay", 2.0) then
            if cast.incinerate("target") then debug("Cast Incinerate [Pre-Pull]") return true end
        end

        -- Conflagrate
        if moving and cast.able.conflagrate() and (not talent.soulFire) and not cast.last.conflagrate() then
            if cast.conflagrate("target") then debug("Cast Conflagrate [Pre-Pull]") return true end
        end
    end
end

actionList.Covenant = function()
                
            --actions.covenant=impending_catastrophe,if=cooldown.summon_darkglare.remains<10|cooldown.summon_darkglare.remains>50
            ---------------------------0--------------------
            -- Impending Catastrophe : Venthyr -------------
            ------------------------------------------------
            --321792
            if not moving and spellUsable(321792) and IsSpellKnown(321792) and select(2,GetSpellCooldown(321792)) <= gcdMax then
                if br._G.CastSpellByName(GetSpellInfo(321792)) then br.addonDebug("[Action:Rotation] Soul Rot (SOul Rot Active)") return true end
            end


            --actions.covenant+=/decimating_bolt,if=cooldown.summon_darkglare.remains>5&(debuff.haunt.remains>4|!talent.haunt.enabled)
            ---------------------------0--------------------
            -- Decimating Bolt : Necrolord -----------------
            ------------------------------------------------
            if not moving and spellUsable(325289) and IsSpellKnown(325289) and select(2,GetSpellCooldown(325289)) <= gcdMax then
                if br._G.CastSpellByName(GetSpellInfo(325289)) then br.addonDebug("[Action:Rotation] Soul Rot (SOul Rot Active)") return true end
            end

            --actions.covenant+=/soul_rot,if=cooldown.summon_darkglare.remains<5|cooldown.summon_darkglare.remains>50|cooldown.summon_darkglare.remains>25&conduit.corrupting_leer.enabled
            ------------------------------------------------
            -- Soul Rot : Night Fae ------------------------
            ------------------------------------------------
            if br.useCDs() and not moving and spellUsable(325640) and IsSpellKnown(325640) and select(2,GetSpellCooldown(325640)) <= gcdMax then
                if br._G.CastSpellByName(GetSpellInfo(325640)) then br.addonDebug("[Action:Rotation] Soul Rot (SOul Rot Active)") return true end
            end
            ------------------------------------------------
            -- Scouring Tithe : Kyrian ---------------------
            ------------------------------------------------
            if not moving and spellUsable(312321) and IsSpellKnown(312321) and select(2,GetSpellCooldown(312321)) <= gcdMax then
                if br._G.CastSpellByName(GetSpellInfo(312321)) then br.addonDebug("[Action:Rotation] Soul Rot (SOul Rot Active)") return true end
            end
end

actionList.ST = function()
    -- Havoc
    -- call_action_list,name=havoc,if=havoc_active&active_enemies<5-talent.inferno.enabled+(talent.inferno.enabled&talent.internal_combustion.enabled)
    if debuff.havoc.count() > 0 and #enemies.yards40f < 5 - inferno + internalInferno then
        if actionList.Havoc() then return true end
    end

    if br.isChecked("Summon Infernal") and br.SpecificToggle("Summon Infernal") and not GetCurrentKeyBoardFocus() and br.getSpellCD(spell.summonInfernal) == 0 then
        if cast.summonInfernal("cursor") then br.addonDebug("[Action:Rotation] Summmon Infernal (Hotkey)") return true end
    end 
    if br.isChecked("Cooldowns") and br.SpecificToggle("Cooldowns") and not GetCurrentKeyBoardFocus() and not moving then
        -- Trinkets
        module.BasicTrinkets()
        -- Racials
        if race == "Troll" or race == "Orc" or race == "DarkIronDwarf" then
            if cast.racial("player") then debug("[Action:Rotations] Racial") return true end
        end
        -- Covenant Abilities
        if actionList.Covenant() then return end 
        -- Dark Soul
        if cast.darkSoulInstability("player") then br.addonDebug("[Action:Rotation] Dark Soul (Hotkey)") return true end
        -- Summon Infernal
        if br.getSpellCD(spell.summonInfernal) == 0 then br._G.CastSpellByName(GetSpellInfo(spell.summonInfernal), "cursor") br.addonDebug("[Action:Rotation] Darkglare (Hotkey)") return true end 
        -- Malefic Rapture
        if not moving and shards > 2 then
            if cast.chaosBolt() then debug ("[Action:Rotation] Chaos Bolt (Hotkey)") return true end 
        end
    end

        if level < 60 then
            -- Decimating Bolt
            if spellUsable(313347) and select(2,GetSpellCooldown(313347)) <= gcdMax and not moving and ttd("target") < 15 then if br._G.CastSpellByName(GetSpellInfo(313347)) then return true end end 

                -- Kyrian: Scouring Tithe
            if spellUsable(312321) and select(2,GetSpellCooldown(312321)) <= gcdMax  and not moving and ttd(thisUnit) < 18 and shards >= 4.5 and debuff.havoc.exists(thisUnit) then if br._G.CastSpellByName(GetSpellInfo(313347),thisUnit) then return true end end 
        end
           
            -- Curse of Weakness
            for i = 1, #enemies.yards40f do
                local thisUnit = enemies.yards40f[i]
                if ui.checked("Curse of Weakness") and ttd(thisUnit) >= 6 and not br.GetUnitIsDeadOrGhost(thisUnit) and isMelee(thisUnit) and br.GetObjectExists(thisUnit) and br._G.UnitCanAttack(thisUnit,"player") and br._G.UnitIsPlayer(thisUnit) then 
                    if cast.curseOfWeakness(thisUnit) then 
                --br.addonDebug("[Action:PvP] Curse of Tongues" .. " | Name: " .. name .. " | Class: ".. class .. " | Level:" .. UnitLevel(unit) .. " | Race: " .. select(1,UnitRace(unit))) 
                return true
                    end
                end
            end

            -- Curse of Tongues
            for i = 1, #enemies.yards40f do
                local unit = enemies.yards40f[i]
                if ui.checked("Curse of Tongues") and ttd(unit) >= 6 and not br.GetUnitIsDeadOrGhost(unit) and isMelee(unit)and br.GetObjectExists(unit) and br._G.UnitCanAttack(unit,"player") and br._G.UnitIsPlayer(unit) then
                    if cast.curseOfTongues(unit) then 
                    --br.addonDebug("[Action:PvP] Curse of Tongues" .. " | Name: " .. name .. " | Class: ".. class .. " | Level:" .. UnitLevel(unit) .. " | Race: " .. select(1,UnitRace(unit))) 
                    return true
                    end
                end
            end
            -- Cataclysm
            -- cataclysm,if=!(pet.infernal.active&dot.immolate.remains+1>pet.infernal.remains)|spell_targets.cataclysm>1|!talent.grimoire_of_supremacy.enabled
            if br.timer:useTimer("Cata Delay", 2) and mode.cataclysm == 1 and ui.checked("Cataclysm") and not moving and cd.cataclysm.remain() <= gcdMax and (not (pet.infernal.active()
            and debuff.immolate.remain("target") + 1 > infernalRemain) or (#enemies.yards8t >= ui.value("Cataclysm Units")
            or (br.useCDs() and ui.checked("Ignore Cataclysm units when using CDs"))) or not talent.grimoireOfSupremacy)
            then
                if ui.value("Cataclysm Target") == 1 then
                    if ui.checked("Predict Movement (Cata)") then
                        if cast.cataclysm("target","ground",1,8,true) then
                            debug("Cast Catacylsm [Main - Target Predict]") return true
                        end
                    elseif not moving or targetMoveCheck then
                        if cast.cataclysm("target", "ground") then
                            debug("Cast Catacylsm [Main - Target]") return true
                        end
                    end
                elseif ui.value("Cataclysm Target") == 2 then
                    if br.useCDs() and ui.checked("Ignore Cataclysm units when using CDs") then
                        if ui.checked("Predict Movement (Cata)") then
                            if cast.cataclysm("best",false,1,8,true) then
                                debug("Cast Catacylsm [Main - Best Single Predict]") return true
                            end
                        else
                            if cast.cataclysm("best",false,1,8) then
                                debug("Cast Catacylsm [Main - Best Single]") return true
                            end
                        end
                    else
                        if ui.checked("Predict Movement (Cata)") then
                            if cast.cataclysm("best",false,ui.value("Cataclysm Units"),8,true) then
                                debug("Cast Catacylsm [Main - Best Min Predict]") return true
                            end
                        else
                            if cast.cataclysm("best",false,ui.value("Cataclysm Units"),8) then
                                debug("Cast Catacylsm [Main - Best Min]") return true
                            end
                        end
                    end
                end
                --if cast.cataclysm() then debug("Cast Cataclysm [Main]") return true end
            end

            -- Call Action List - AOE
            -- call_action_list,name=aoe,if=active_enemies>2
            if ((mode.rotation == 1 and #enemies.yards40f >= ui.value("Multi-Target Units")) or (mode.rotation == 2 and #enemies.yards40f > 0)) then
                if actionList.Aoe() then return true end
            end

            -- Immolate
            -- immolate,cycle_targets=1,if=refreshable&(!talent.cataclysm.enabled|cooldown.cataclysm.remains>remains)
            if not moving and cast.able.immolate() then
                for i = 1, #enemies.yards40f do
                    local thisUnit = enemies.yards40f[i]
                    if okToDoT and br._G.UnitHealth(thisUnit) >= immoTick and ttd(thisUnit) >= 9 and (debuff.immolate.remain(thisUnit) < 6 and (not ui.checked("Cataclysm") or not talent.cataclysm 
                    or cd.cataclysm.remain() > debuff.immolate.remain(thisUnit) or #enemies.yards8t < ui.value("Cataclysm Units"))) 
                    then
                        if not br.GetUnitIsUnit(thisUnit,br.lastImmo) then
                            if cast.immolate(thisUnit) then debug("Cast Immolate [Main - Multi]") br.lastImmo = thisUnit; br.lastImmoCast = GetTime() return true end
                        else
                            if br.lastImmoCast == nil or GetTime() - br.lastImmoCast > 4.5 then
                                if cast.immolate(thisUnit) then debug("Cast Immolate [Main - Multi Same Target]") br.lastImmo = thisUnit; br.lastImmoCast = GetTime() return true end
                            end
                        end
                    end
                end
            end

            -- Immolate
            -- immolate,cycle_targets=1,if=refreshable&(!talent.cataclysm.enabled|cooldown.cataclysm.remains>remains)
          --[[ if not moving and cast.able.immolate() then
                for i = 1, #enemies.yards40f do
                    local thisUnit = enemies.yards40f[i]
                    if okToDoT and br._G.UnitHealth(thisUnit) >= immoTick and ttd(thisUnit) >= 9 and (debuff.corruption.remains(thisUnit) < 7) 
                    then
                        if not br.GetUnitIsUnit(thisUnit,br.lastImmo) then
                            if cast.immolate(thisUnit) then debug("Cast Immolate [Main - Multi]") br.lastImmo = thisUnit; br.lastImmoCast = GetTime() return true end
                        else
                            if br.lastImmoCast == nil or GetTime() - br.lastImmoCast > 4.5 then
                                if cast.immolate(thisUnit) then debug("Cast Immolate [Main - Multi Same Target]") br.lastImmo = thisUnit; br.lastImmoCast = GetTime() return true end
                            end
                        end
                    end
                end
            end--]]

            -- immolate,if=talent.internal_combustion.enabled&action.chaos_bolt.in_flight&remains<duration*0.5
            if not moving and br._G.UnitHealth("target") >= immoTick and ttd("target") >= 9 and cast.able.immolate() and okToDoT and not cast.last.immolate() and (talent.internalCombustion
                and cast.inFlight.chaosBolt() and debuff.immolate.remain("target") < debuff.immolate.duration() * 0.5)
            then
                if cast.immolate() then debug("Cast Immolate [Main]") return true end
            end

            -- Call Action List - Cooldowns
            -- call_action_list,name=cds
            if actionList.Cooldowns() then return end

            if actionList.Covenant() then return end 

            -- Havoc
            -- havoc,cycle_targets=1,if=!(target=self.target)&(dot.immolate.remains>dot.immolate.duration*0.5|!talent.internal_combustion.enabled)&(!cooldown.summon_infernal.ready|!talent.grimoire_of_supremacy.enabled|talent.grimoire_of_supremacy.enabled&pet.infernal.remains<=10)
            if cast.able.havoc() then
                for i = 1, #enemies.yards40f do
                    local thisUnit = enemies.yards40f[i]
                    if ttd(thisUnit) > 10 and (not (br.GetUnitIsUnit("target",thisUnit))
                        and (debuff.immolate.remain(thisUnit) > debuff.immolate.duration() * 0.5 
                        or not talent.internalCombustion) and (cd.summonInfernal.exists()
                        or not talent.grimoireOfSupremacy or talent.grimoireOfSupremacy and infernalRemain <= 10))
                    then
                        if cast.havoc(thisUnit) then debug("Cast Havoc [Main - Multi]") return true end
                    end
                end
            end

            -- Call Action List - Gosup Infernal
            -- call_action_list,name=gosup_infernal,if=talent.grimoire_of_supremacy.enabled&pet.infernal.active
            if talent.grimoireOfSupremacy and pet.infernal.active() then
                if actionList.GosupInfernal() then return true end
            end

            -- Soul Fire
            -- soul_fire
            if not moving and cast.able.soulFire() then
                if cast.soulFire() then debug("Cast Soul Fire [Main]") return true end
            end

            -- Conflagrate
            -- conflagrate,if=buff.backdraft.down&soul_shard>=1.5-0.3*talent.flashover.enabled&!variable.pool_soul_shards
            if cast.able.conflagrate() and ((not buff.backdraft.exists() or charges.conflagrate.count() == 2)
                and shards >= 1.5 - 0.3 * flashover and not poolShards)
            then
                if cast.conflagrate() then debug("Cast Conflagrate [Main]") return true end
            end

            -- Shadow Burn
            -- shadowburn,if=soul_shard<2&(!variable.pool_soul_shards|charges>1)
            if cast.able.shadowburn() and (shards < 2 and (not poolShards or charges.shadowburn.count() > 1)) then
                if cast.shadowburn() then debug("Cast Shadowburn [Main]") return true end
            end

            -- Chaos Bolt
            -- chaos_bolt,if=(talent.grimoire_of_supremacy.enabled|azerite.crashing_chaos.enabled)&pet.infernal.active|buff.dark_soul_instability.up|buff.reckless_force.react&buff.reckless_force.remains>cast_time
            if not moving  and cast.timeSinceLast.chaosBolt() > gcdMax
                and ((talent.grimoireOfSupremacy or traits.crashingChaos.active) and pet.infernal.active() 
                or buff.darkSoulInstability.exists() or buff.recklessForce.exists()
                and buff.recklessForce.remain() > cast.time.chaosBolt())
            then
                if cast.chaosBolt() then debug("Cast Chaos Bolt [Main - Supremacy or Crashing Chaos]") return true end
            end

            -- chaos_bolt,if=buff.backdraft.up&!variable.pool_soul_shards&!talent.eradication.enabled
            if not moving  and cast.timeSinceLast.chaosBolt() > gcdMax
                and (buff.backdraft.exists() and not poolShards and not talent.eradication)
            then
                if cast.chaosBolt() then debug("Cast Chaos Bolt [Main - Backdraft]") return true end
            end

            -- chaos_bolt,if=!variable.pool_soul_shards&talent.eradication.enabled&(debuff.eradication.remains<cast_time|buff.backdraft.up)
            if not moving  and cast.timeSinceLast.chaosBolt() > gcdMax
                and (not poolShards and talent.eradication
                and (debuff.eradication.remain("target") < cast.time.chaosBolt() or buff.backdraft.exists()))
            then
                if cast.chaosBolt() then debug("Cast Chaos Bolt [Main - Eradiaction]") return true end
            end

            -- chaos_bolt,if=(soul_shard>=4.5-0.2*active_enemies)&(!talent.grimoire_of_supremacy.enabled|cooldown.summon_infernal.remains>7)
            if not moving  and cast.timeSinceLast.chaosBolt() > gcdMax
                and ((shards >= 4.5 - 0.2 * #enemies.yards40f)
                and (not talent.grimoireOfSupremacy or (cd.summonInfernal.remain() > 7 or not br.useCDs())))
            then
                if cast.chaosBolt() then debug("Cast Chaos Bolt [Main - High Shards]") return true end
            end

            -- Conflagrate
            -- conflagrate,if=charges>1
            if cast.able.conflagrate() and (charges.conflagrate.count() > 1) then
                if cast.conflagrate() then debug("Cast Conflagrate [Main - More Than 1]") return true end
            end

            -- Incinerate
            -- incinerate
            if not moving and cast.able.incinerate() and cast.timeSinceLast.incinerate() > gcdMax then
                if cast.incinerate() then debug("Cast Incinerate [Main]") return true end
            end
end


-- Action List - PreCombat
actionList.Rotation = function()


    if spellQueueReady() then

       if actionList.ST() then return true end 



    end


end


----------------
--- ROTATION ---
----------------
local function runRotation()
    ---------------
    --- Toggles ---
    ---------------
    br.UpdateToggle("Rotation", 0.25)
    br.UpdateToggle("Cooldown", 0.25)
    br.UpdateToggle("Defensive", 0.25)
    br.UpdateToggle("Interrupt", 0.25)
    br.UpdateToggle("Cataclysm", 0.25)
    br.UpdateToggle("BurningRush", 0.25)
    br.UpdateToggle("PetCommand", 0.25)
    
    br.player.ui.mode.pc = br.data.settings[br.selectedSpec].toggles["PetCommand"]
    br.player.ui.mode.cds = br.data.settings[br.selectedSpec].toggles["Cooldown"]
    br.player.ui.mode.ss = br.data.settings[br.selectedSpec].toggles["Single"]

    --------------------------------------
    --- Load Additional Rotation Files ---
    --------------------------------------
    if actionList.PetManagement == nil then
        br.loadSupport("PetCuteOne")
        actionList.PetManagement = br.rotations.support["PetCuteOne"]
    end

    --------------
    --- Locals ---
    --------------
    -- BR API
    buff                               = br.player.buff
    cast                               = br.player.cast
    cd                                 = br.player.cd
    charges                            = br.player.charges
    debuff                             = br.player.debuff
    debug                              = br.addonDebug
    enemies                            = br.player.enemies
    equiped                            = br.player.equiped
    flying, swimming, moving           = IsFlying(), IsSwimming(), br._G.GetUnitSpeed("player")>0
    gcdMax                             = br.player.gcdMax
    has                                = br.player.has
    healPot                            = br.getHealthPot()
    inCombat                           = br.player.inCombat
    inInstance                         = br.player.instance=="party"
    inRaid                             = br.player.instance=="raid"
    item                               = br.player.items
    level                              = br.player.level
    mode                               = br.player.ui.mode
    module                             = br.player.module
    opener                             = br.player.opener
    ui                                 = br.player.ui
    pet                                = br.player.pet
    php                                = br.player.health

    pullTimer                          = br.PullTimerRemain()
    race                               = br.player.race
    racial                             = br.player.getRacial()
    shards                             = br.player.power.soulShards.frac()
    spell                              = br.player.spell
    solo                               = #br.friend == 1
    talent                             = br.player.talent
    traits                             = br.player.traits
    ttd                                = br.getTTD
    units                              = br.player.units
    use                                = br.player.use

    -- General API
    combatTime                         = br.getCombatTime()
    flashover                          = talent.flashover and 1 or 0
    inferno                            = talent.inferno and 1 or 0
    internalInferno                    = (talent.inferno and talent.internalCombustion) and 1 or 0
    lastSpell                          = lastSpellCast
    summonPet                          = ui.value("Summon Pet")
    
    -- Get Best Unit for Range
    -- units.get(range, aoe)
    units.get(40)
    if range == nil then range = {} end
    range.dyn40 = br.getDistance("target") < 40
    
    -- Get List of Enemies for Range
    -- enemies.get(range, from unit, no combat, variable)
    enemies.get(8,"target")
    enemies.get(30)
    enemies.get(40)
    enemies.get(40,"player",true) -- makes enemies.yards40nc
    enemies.get(40,"player",false,true) -- makes enemies.yards40f
    
    -- General Vars
    if leftCombat == nil then leftCombat = GetTime() end
    if br.profileStop == nil then br.profileStop = false end
    if not inCombat and not br.GetUnitExists("target") and br.profileStop == true then
        br.profileStop = false
    end
    okToDoT = debuff.immolate.count() < ui.value("Multi-Dot Limit")
    
        
    --local enemies table with extra data
    local facingUnits = 0
    local enemyTable40 = { }
    if #enemies.yards40 > 0 then
        local highestHP
        local lowestHP
        local distance20Max
        local distance20Min
        for i = 1, #enemies.yards40 do
        local thisUnit = enemies.yards40[i]
        if (br.GetUnitIsUnit(thisUnit, "target")) and not br._G.UnitIsDeadOrGhost(thisUnit) then
            local enemyUnit = {}
            enemyUnit.unit = thisUnit
            enemyUnit.ttd = ttd(thisUnit)
            enemyUnit.distance = br.getDistance(thisUnit)
            enemyUnit.distance20 = math.abs(br.getDistance(thisUnit)-20)
            enemyUnit.hpabs = br._G.UnitHealth(thisUnit)
            enemyUnit.facing = br.getFacing("player",thisUnit)

            if enemyUnit.facing then facingUnits = facingUnits + 1 end
            if havocActive ~= 0 then enemyUnit.havocRemain = debuff.havoc.remain(thisUnit)
            else enemyUnit.havocRemain = 0 end

            tinsert(enemyTable40, enemyUnit)
            if highestHP == nil or highestHP < enemyUnit.hpabs then highestHP = enemyUnit.hpabs end
            if lowestHP == nil or lowestHP > enemyUnit.hpabs then lowestHP = enemyUnit.hpabs end
            if distance20Max == nil or distance20Max < enemyUnit.distance20 then distance20Max = enemyUnit.distance20 end
            if distance20Min == nil or distance20Min > enemyUnit.distance20 then distance20Min = enemyUnit.distance20 end
        end
    end
    if #enemyTable40 > 1 then
        for i = 1, #enemyTable40 do
            local hpNorm = (5-1)/(highestHP-lowestHP)*(enemyTable40[i].hpabs-highestHP)+5 -- normalization of HP value, high is good
            if hpNorm ~= hpNorm or tostring(hpNorm) == tostring(0/0) then hpNorm = 0 end -- NaN check
            local distance20Norm = (3-1)/(distance20Max-distance20Min)*(enemyTable40[i].distance20-distance20Min)+1 -- normalization of distance 20, low is good
            if distance20Norm ~= distance20Norm or tostring(distance20Norm) == tostring(0/0) then distance20Norm = 0 end -- NaN check
            local enemyScore = hpNorm + distance20Norm
            if enemyTable40[i].facing then enemyScore = enemyScore + 10 end
            if enemyTable40[i].ttd > 1.5 then enemyScore = enemyScore + 10 end
            if enemyTable40[i].havocRemain == 0 then enemyScore = enemyScore + 5 end
            enemyTable40[i].enemyScore = enemyScore
        end
        table.sort(enemyTable40, function(x,y)
            return x.enemyScore > y.enemyScore
        end)
    end
        if br.isChecked("Auto Target") and #enemyTable40 > 0 and ((br.GetUnitExists("target") and br._G.UnitIsDeadOrGhost("target") and not br.GetUnitIsUnit(enemyTable40[1].unit, "target")) or not br.GetUnitExists("target")) then
            br._G.TargetUnit(enemyTable40[1].unit)
        end
    end



    -- spellqueue ready
    local function spellQueueReady()
        --Check if we can queue cast
        local castingInfo = {br._G.UnitCastingInfo("player")}
        if castingInfo[5] then
            if (GetTime() - ((castingInfo[5] - tonumber(C_CVar.GetCVar("SpellQueueWindow")))/1000)) < 0 then
                return false
            end
        end
        return true
    end
  
    -- SimC Variables
    -- Pool Shards
    -- variable,name=pool_soul_shards,value=active_enemies>1&cooldown.havoc.remains<=10|cooldown.summon_infernal.remains<=15&(talent.grimoire_of_supremacy.enabled|talent.dark_soul_instability.enabled&cooldown.dark_soul_instability.remains<=15)|talent.dark_soul_instability.enabled&cooldown.dark_soul_instability.remains<=15&(cooldown.summon_infernal.remains>target.time_to_die|cooldown.summon_infernal.remains+cooldown.summon_infernal.duration>target.time_to_die)
    poolShards =  #enemies.yards40 > 1 and cd.havoc.remain() <= 10 or cd.summonInfernal.remain() <= 15
        and (talent.grimoireOfSupremacy or talent.darkSoulInstability and cd.darkSoulInstability.remain() <= 15)
            or talent.darkSoulInstability and cd.darkSoulInstability.remain() <= 15
            and (cd.summonInfernal.remain() > ttd("target") or cd.summonInfernal.remain() +
            cd.summonInfernal.duration() > ttd("target"))
    
    -- Pet Data
    if mode.petSummon == 1 and HasAttachedGlyph(spell.summonImp) then summonId = 58959
    elseif mode.petSummon == 1 then summonId = 416
    elseif mode.petSummon == 2 and HasAttachedGlyph(spell.summonVoidwalker) then summonId = 58960
    elseif mode.petSummon == 2 then summonId = 1860
    elseif mode.petSummon == 3 then summonId = 417
    elseif mode.petSummon == 4 then summonId = 1863 end
    if talent.grimoireOfSacrifice then petPadding = 5 end

    infernalRemain = max(0,(infernalCast + 30) - GetTime())

    if #enemies.yards40f > 0 then
        for i = 1, #enemies.yards40f do
            local thisUnit = enemies.yards40f[i]
            local thisRemain = debuff.havoc.remain(thisUnit)
            if thisRemain > havocRemain then
                havocRemain = thisRemain
            end
        end
    end

    
        --Clear last cast table ooc to avoid strange casts
        if not inCombat and #br.lastCastTable.tracker > 0 then
            wipe(br.lastCastTable.tracker)
        end

    --Target move timer
    if lastTargetX == nil then lastTargetX, lastTargetY, lastTargetZ = 0,0,0 end
        targetMoveCheck = targetMoveCheck or false
        if br.timer:useTimer("targetMove", math.random(0.2,0.8)) or combatTime < 0.2 then
            if br.GetObjectExists("target") then
            local currentX, currentY, currentZ = br.GetObjectPosition("target")
            local targetMoveDistance = math.sqrt(((currentX-lastTargetX)^2)+((currentY-lastTargetY)^2)+((currentZ-lastTargetZ)^2))
            lastTargetX, lastTargetY, lastTargetZ = br.GetObjectPosition("target")
            if targetMoveDistance < 3 then targetMoveCheck = true else targetMoveCheck = false end
        end
    end

    -- ChatOverlay("Shards: "..tostring(shards))


local function actionList_PetControl()
    if br._G.UnitExists("pet")
    and not br.GetUnitIsDeadOrGhost("pet") 
    and not br._G.UnitExists("pettarget")
    and hastar
    and inCombat
    and br.timer:useTimer("Pet Attack Delay",math.random(0.5,2))
    then
       -- PetAssistMode()
        --PetAttack()
        br._G.RunMacroText("/petattack")
    end

    if br._G.UnitExists("pet")
    and not br.GetUnitIsDeadOrGhost("pet")
    and inCombat
    and hastar and not deadtar 
    and br._G.UnitName("pettarget") ~= br._G.UnitName("target")
    and br.timer:useTimer("Summon Pet Delay",math.random(0.2,1.5))
    then
        br._G.RunMacroText("/petattack")
    end

    if not inCombat 
    and br._G.UnitExists("pet")
    and not br.GetUnitIsDeadOrGhost("pet") 
    and br._G.UnitExists("pettarget")
    and not hastar
    then    
        ---br._G.PetFollow()   
        br._G.RunMacroText("/petfollow")
        br.addonDebug("PET FOLLOW!")
    end

    -- Firebolt Spam
    if br._G.UnitExists("pettarget")
    and pet.imp.active()
    and not br.GetUnitIsDeadOrGhost("pet") 
    then
        br._G.CastSpellByName(GetSpellInfo(3110),"pettarget") 
    end
    -- Consuming Shadows Spam
    if br._G.UnitExists("pettarget")
    and pet.voidwalker.active()
    and not br.GetUnitIsDeadOrGhost("pet") 
    then
        br._G.CastSpellByName(GetSpellInfo(3716),"pettarget") 
    end
    -- Shadow Bite Spam
    if br._G.UnitExists("pettarget")
    and pet.felhunter.active()
    and not br.GetUnitIsDeadOrGhost("pet") 
    then
        br._G.CastSpellByName(GetSpellInfo(54049),"pettarget") 
    end
    -- Whiplash Spam
    if br._G.UnitExists("pettarget")
    and pet.succubus.active()
    and not br.GetUnitIsDeadOrGhost("pet") 
    then
        br._G.CastSpellByName(GetSpellInfo(6360),"pettarget") 
    end
    -- Lash of Pain
    if br._G.UnitExists("pettarget")
    and pet.succubus.active()
    and not br.GetUnitIsDeadOrGhost("pet") 
    then
        br._G.CastSpellByName(GetSpellInfo(7814),"pettarget") 
    end
end -- End of Pet Control
-- ActionList_SummonPet
local function actionList_SummonPet()
    local petPadding = 2
    if talent.grimoireOfSacrifice then
        petPadding = 5
    end

    if br.GetUnitIsDeadOrGhost("pet") then br._G.RunMacroText("/petdismiss") return end 

    if ui.checked("Fel Domination") and inCombat and not br.GetObjectExists("pet") or br.GetUnitIsDeadOrGhost("pet") and cd.felDomination.remain() <= gcdMax and not buff.grimoireOfSacrifice.exists() 
    then
        if cast.felDomination() then br.addonDebug("Fel Domination") return true end
    end

    if ui.checked("Fel Domination Pet HP%") and not moving and cd.felDomination.remain() <= gcdMax and br.getHP("pet") <= br.getOptionValue("FD Pet HP%") and (br.GetObjectExists("pet") == true and not br.GetUnitIsDeadOrGhost("pet"))
    then
        if cast.felDomination() then br.addonDebug("Fel Domination Low Pet Health") return true end
    end

    -- If we're casting pet summons 
    --  if br._G.UnitCastingInfo("Player") == GetSpellInfo() then if br._G.UnitExists("pet") and not br.GetUnitIsDeadOrGhost("pet") then br._G.SpellStopCasting()  return true end  end

    var.summonImp                   = spell.summonImp
    var.summonVoidwalker            = spell.summonVoidwalker
    var.summonFelhunter             = spell.summonFelhunter
    var.summonSuccubus              = spell.summonSuccubus

    if br.isChecked("Pet Management") and not (IsFlying() or IsMounted()) and ((not talent.grimoireOfSacrifice or not buff.demonicPower.exists()) or talent.grimoireOfSacrifice and not buff.grimoireOfSacrifice.exists("player")) and level >= 5 and br.timer:useTimer("Summon Pet Delay", br.getOptionValue("Summon Pet Delay")) and not moving then
        if (activePetId == 0 or activePetId ~= summonId) and (lastSpell ~= castSummonId or activePetId ~= summonId or activePetId == 0) then
            if mode.summonPet == 1 and (lastSpell ~= spell.summonImp or activePetId == 0) then
                if cast.summonImp("player") then castSummonId = spell.summonImp return end
            elseif mode.summonPet == 2 and (lastSpell ~= spell.summonVoidwalker or activePetId == 0) then
                if cast.summonVoidwalker("player") then castSummonId = spell.summonVoidwalker return end
            elseif mode.summonPet == 3 and (lastSpell ~= spell.summonFelhunter or activePetId == 0) then
                if cast.summonFelhunter("player") then castSummonId = spell.summonFelhunter return end
            elseif mode.summonPet == 4 and (lastSpell ~= spell.summonSuccubus or activePetId == 0) then
                if cast.summonSuccubus("player") then castSummonId = spell.summonSuccubus return end
            elseif mode.summonPet == 5 then
                br._G.RunMacroText("/petdismiss") ui.debug("Dismiss Pet")
            end
        end
    end
end -- End actionList_SummonPet()

        local function actionList_PreCombat()
        -- Summon Pet
            local petPadding = 2
            if talent.grimoireOfSacrifice then petPadding = 5 end
            -- summon_pet,if=!talent.grimoire_of_supremacy.enabled&(!talent.grimoire_of_sacrifice.enabled|buff.demonic_power.down)
            if br.isChecked("Pet Management") and not (IsFlying() or IsMounted()) and (not talent.grimoireOfSacrifice or not buff.demonicPower.exists()) and level >= 5 and br.timer:useTimer("summonPet", cast.time.summonVoidwalker() + petPadding) and not moving then
                if (activePetId == 0 or activePetId ~= summonId) and (lastSpell ~= castSummonId or activePetId ~= summonId or activePetId == 0) then
                    if summonPet == 1 and (lastSpell ~= spell.summonImp or activePetId == 0) then
                      if cast.summonImp("player") then castSummonId = spell.summonImp return end
                    elseif summonPet == 2 and (lastSpell ~= spell.summonVoidwalker or activePetId == 0) then
                      if cast.summonVoidwalker("player") then castSummonId = spell.summonVoidwalker return end
                    elseif summonPet == 3 and (lastSpell ~= spell.summonFelhunter or activePetId == 0) then
                      if cast.summonFelhunter("player") then castSummonId = spell.summonFelhunter return end
                    elseif summonPet == 4 and (lastSpell ~= spell.summonSuccubus or activePetId == 0) then
                      if cast.summonSuccubus("player") then castSummonId = spell.summonSuccubus return end
                    end
                end
            end
            -- grimoire_of_sacrifice,if=talent.grimoire_of_sacrifice.enabled
            if talent.grimoireOfSacrifice and br.isChecked("Pet Management") and br.GetObjectExists("pet") and not UnitIsDeadOrGhost("pet") then
                if cast.grimoireOfSacrifice() then return end
            end
            if not inCombat and not (IsFlying() or IsMounted()) then
            -- Flask
                -- flask,type=whispered_pact
            -- Food
                -- food,type=azshari_salad
                if (not br.isChecked("Opener") or opener == true) then
                    if useCDs() and br.isChecked("Pre-Pull Logic") and br.GetObjectExists("target") and br.getDistance("target") < 40 then
                      local incinerateExecute = cast.time.incinerate() + (br.getDistance("target")/25)
                        if pullTimer <= incinerateExecute then
                            if br.isChecked("Pre Pot") and use.able.battlePotionOfIntellect() and not buff.battlePotionOfIntellect.exists() then
                                use.battlePotionOfIntellect()
                            end
                            if ppInc == false then if cast.incinerate("target") then ppInc = true; return true end end
                        end
                    end -- End Pre-Pull
                    if br.isValidUnit("target") and br.getDistance("target") < 40 and (not br.isChecked("Opener") or opener == true) then
                -- Life Tap
                      -- life_tap,if=talent.empowered_life_tap.enabled&!buff.empowered_life_tap.remains
                      if talent.empoweredLifeTap and not buff.empoweredLifeTap.exists() then
                          if cast.lifeTap() then return end
                      end
                      -- Pet Attack/Follow
                      if br.isChecked("Pet Management") and br.GetUnitExists("target") and not UnitAffectingCombat("pet") then
                          PetAssistMode()
                          PetAttack("target")
                      end
                      -- actions.precombat+=/soul_fire
                      if talent.soulFire then
                        if cast.soulFire() then return true end
                      end
                      -- actions.precombat+=/incinerate,if=!talent.soul_fire.enabled
                      if not talent.soulFire then
                        if not moving then
                          if cast.incinerate() then return true end
                        else
                          if cast.conflagrate() then return true end
                        end
                      end
                    end
                end
            end -- End No Combat
           -- if actionList_Opener() then return end
        end -- End Action List - PreCombat
---------------------
--- Begin Profile ---
---------------------
-- Profile Stop | Pause
if not inCombat and not hastar and br.profileStop == true or br.SpecificToggle("Pause Mode") then
        br.profileStop = false
elseif inCombat and br._G.IsAoEPending() then
        br._G.SpellStopTargeting()
        br.addonDebug("Canceling Spell")
        return false
elseif (inCombat and br.profileStop == true) or UnitIsAFK("player") or IsMounted() or IsFlying() or br.pause(true) or mode.rotation ==4 then
    if not br.pause(true) and IsPetAttackActive() and br.isChecked("Pet Management") then
        br._G.PetStopAttack()
        br._G.PetFollow()
    end
    return true
else
    -- Auto Engage
    if br.isChecked("Auto Engage") and solo and not inCombat then 
        if not moving and hastar and br._G.UnitCanAttack("target", "player") and not br.GetUnitIsDeadOrGhost("target") then
            if br.timer:useTimer("target", math.random(0.2,1.5)) then
                if cast.incinerate("target") then br.addonDebug("Casting Incinerate (Pull Spell)") return end
            end
        end
    end

        -----------------
        --- Pet Logic ---
        -----------------
        if actionList.PetManagement() then return true end
        -----------------------
        --- Extras Rotation ---
        -----------------------
        if actionList.Extras() then return true end
        --------------------------
        --- Defensive Rotation ---
        --------------------------
        if (not cast.current.drainLife() or (cast.current.drainLife() and php > 80)) then
            if actionList.Defensive() then return end
        end
        ------------------------------
        --- Out of Combat Rotation ---
        ------------------------------
        if actionList_PetControl() then return end
        if actionList.PreCombat() then return true end

                local mapMythicPlusModeID, mythicPlusLevel, mythicPlustime, mythicPlusOnTime, keystoneUpgradeLevels, practiceRun = C_ChallengeMode.GetCompletionInfo()
        if not solo and not moving then
            --if mythicPlusLevel ~= 0 then
                for i = 1, #br.friend do
                    if br._G.UnitIsPlayer(br.friend[i].unit) and br.GetUnitIsFriend(br.friend[i].unit, "player") 
                    and (br._G.UnitGroupRolesAssigned(br.friend[i].unit) == "HEALER" or br.friend[i].role == "HEALER") 
                    and (not buff.soulstone.exists(br.friend[i].unit)) 
                    and br.timer:useTimer("target", 3)
                    then
                        if cast.soulstone(br.friend[i].unit) then
                            br.addonDebug("Soulstone Healer OOC [Mythic+] YEEEEEEEEEEEEEEEEET")
                            return true
                        end
                    end
                end
            --end
        end

    if solo then
        -- Burning Rush
        if buff.burningRush.exists() and not moving or buff.burningRush.exists() and php <= ui.value("Burning Rush Health") then br._G.RunMacroText("/cancelaura Burning Rush") br.addonDebug("Canceling Burning Rush") return true end 

        if mode.burningRush ~= 2 and br.timer:useTimer("Burning Rush Delay", br.getOptionValue("Burning Rush Delay")) and moving and not buff.burningRush.exists() and php > ui.value("Burning Rush Health") + 5 then if cast.burningRush() then br.addonDebug("Casting Burning Rush") return true end end

        if mode.burningRush == 3 and br.timer:useTimer("Burning Rush Delay", br.getOptionValue("Burning Rush Delay")) and not buff.burningRush.exists() and php > ui.value("Burning Rush Health") + 5 then if cast.burningRush() then br.addonDebug("Casting Burning Rush") return true end end
    end  
        
        if br.GetUnitIsDeadOrGhost("pet") then br._G.RunMacroText("/petdismiss") return end 

        if ui.checked("Fel Domination") and inCombat and not br.GetObjectExists("pet") or br.GetUnitIsDeadOrGhost("pet") and cd.felDomination.remain() <= gcdMax and not buff.grimoireOfSacrifice.exists() 
        then
            if cast.felDomination() then br.addonDebug("Fel Domination") return true end
        end

        if ui.checked("Fel Domination New Pet") and not moving and cd.felDomination.remain() <= gcdMax and br.getHP("pet") <= br.getOptionValue("FelDom Pet HP") and (br.GetObjectExists("pet") == true and not br.GetUnitIsDeadOrGhost("pet"))
        then
            if cast.felDomination() then br.addonDebug("Fel Domination Low Pet Health") return true end
        end

        -- summon_pet,if=!talent.grimoire_of_supremacy.enabled&(!talent.grimoire_of_sacrifice.enabled|buff.demonic_power.down)
        if (not inCombat and not moving) or buff.felDomination.exists() then 
            if actionList_SummonPet() then return end 
        elseif inCombat and moving and buff.felDomination.exists() then 
            if actionList_SummonPet() then return end
        end
        --------------------------
        --- In Combat Rotation ---
        --------------------------
         if inCombat or spellQueueReady() and br.profileStop == false and br.isValidUnit("target") and br.getDistance("target") < 40 then
            ------------------------------
            --- In Combat - Interrupts ---
            ------------------------------
            if actionList.Interrupts() then return true end

            if br.queueSpell then
                br.ChatOverlay("Pausing for queuecast")
                return true 
            end
            if br.isChecked("Shadowfury Key") and br.SpecificToggle("Shadowfury Key") and not GetCurrentKeyBoardFocus() then
                if br._G.CastSpellByName(GetSpellInfo(spell.shadowfury),"cursor") then br.addonDebug("Casting Shadow Fury") return end 
            end

            if actionList.Rotation() then return true end 

        end -- End Combat
    end -- End Rotation Logic
end -- End Rotation File
local id = 267
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
