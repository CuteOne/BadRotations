local rotationName = "Kinkold"
local rotationVer  = "v1.4.6"
local dsInterrupt = false
----------------------------------------------------
-- Credit to Aura for this rotation's base.
----------------------------------------------------

----------------------------------------------------
-- Credit and huge thanks to:
----------------------------------------------------
--[[

Damply#3489

.G.#1338 

Netpunk | Ben#7486 


--]]

----------------------------------------------------
-- on Discord!
----------------------------------------------------

---------------
--- Toggles ---
---------------
local function createToggles() -- Define custom toggles
    -- Rotation Button
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of #enemies.yards8 in range.", highlight = 1, icon = br.player.spell.agony},
        -- [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.bladestorm },
        -- [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.furiousSlash },
        [2] = { mode = "Off", value = 2 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.healthFunnel}
    };
    CreateButton("Rotation",1,0)
    -- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.summonDarkglare},
        [2] = { mode = "On", value = 2 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.summonDarkglare},
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.summonDarkglare}
    };
    CreateButton("Cooldown",2,0)
    -- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.unendingResolve},
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.unendingResolve}
    };
    CreateButton("Defensive",3,0)
    -- Interrupt Button
    InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.fear},
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.fear}
    };
    CreateButton("Interrupt",4,0)
    --Pet summon
    PetSummonModes = {
        [1] = { mode = "1", value = 1 , overlay = "Imp", tip = "Summon Imp", highlight = 1, icon = br.player.spell.summonImp },
        [2] = { mode = "2", value = 2 ,overlay = "Voidwalker", tip = "Summon Voidwalker", highlight = 1, icon = br.player.spell.summonVoidwalker },
        [3] = { mode = "3", value = 3 , overlay = "Felhunter", tip = "Summon Felhunter", highlight = 1, icon = br.player.spell.summonFelhunter },
        [4] = { mode = "4", value = 4 , overlay = "Succubus", tip = "Summon Succubus", highlight = 1, icon = br.player.spell.summonSuccubus },
        [5] = { mode = "None", value = 5 , overlay = "No pet", tip = "Dont Summon any Pet", highlight = 0, icon = br.player.spell.conflagrate }
    };
    CreateButton("PetSummon",5,0)
    -- Single Target Focus
    SingleModes = {
        [1] = { mode = "On", value = 1, overlay = "Single Target Focus", tip = "Single Target Focus", highlight = 1, icon = br.player.spell.shadowBolt},
        [2] = { mode = "Off", value = 2, overlay = "Multi Target Focus", tip = "Multi Target Focus", highlight = 1, icon = br.player.spell.agony}
    };
    CreateButton("Single",6,0)
end

-- function br.ui:createCDOption(parent, text, tooltip, hideCheckbox)
-- 	local cooldownModes = {"Always", "Always Boss", "OnCooldown", "OnCooldown Boss"}
-- 	local tooltipDrop = cPurple.."Always"..cWhite..": Will only use the ability even if the Cooldown Toggle is "..cRed.."Disabled"..cWhite..[[. 
-- ]]..cPurple.."Always Boss"..cWhite..": Will only use the ability even if the Cooldown Toggle is "..cRed.."Disabled"..cWhite.." as long as the current target is a Boss"..[[. 
-- ]]..cPurple.."OnCooldown"..cWhite..": Will only use the ability if the Cooldown Toggle is "..cGreen.."Enabled"..cWhite..[[. 
-- ]]..cPurple.."OnCooldown Boss"..cWhite..": Will only use the ability if the Cooldown Toggle is "..cGreen.."Enabled"..cWhite.." and Target is a Boss."
-- 	br.ui:createDropdown(parent, text, cooldownModes, 3, tooltip, tooltipDrop, hideCheckbox)
-- end

---------------
--- OPTIONS ---
---------------
local function createOptions ()
	local optionTable

	local function rotationOptions ()
		-----------------------
		--- GENERAL OPTIONS ---
		-----------------------
        section = br.ui:createSection(br.ui.window.profile,  "Affliction .:|:. General ".. ".:|:. ".. rotationVer)
            -- Multi-Target Units
            br.ui:createSpinnerWithout(section, "Multi-Target Units", 3, 1, 25, 1, "|cffFFBB00Health Percentage to use at.")

            -- APL
            br.ui:createDropdownWithout(section, "APL Mode", {"|cffFFBB00SimC", "|cffFFBB00Leveling"}, 1, "|cffFFBB00Set APL Mode to use.")

            -- Dummy DPS Test
            br.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")

            -- Pig Catcher
            br.ui:createCheckbox(section, "Pig Catcher")

            -- Auto Engage
            br.ui:createCheckbox(section,"Auto Engage")

            -- Pet Management
            br.ui:createCheckbox(section, "Pet Management", "|cffFFFFFF Select to enable/disable auto pet management")

            -- Fel Domination
            br.ui:createCheckbox(section, "Fel Domination", "|cffFFFFFF Toggle the auto casting of Fel Donmination")

            -- Pet - Auto Attack/Passive
            br.ui:createCheckbox(section, "Pet - Auto Attack/Passive")

            -- Use Essence
            br.ui:createCheckbox(section, "Use Essence")

            -- Concentrated Flame
            br.ui:createSpinnerWithout(section, "Concentrated Flame", 50, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")

            -- Azerite Beam Units
            br.ui:createSpinnerWithout(section, "Azerite Beam Units", 3, 1, 10, 1, "|cffFFBB00Number of Targets to use Azerite Beam on.")

            -- Flask
            br.ui:createDropdownWithout(section,"Elixir", {"Greater Flask of Endless Fathoms","Flask of Endless Fathoms","None"}, 1, "|cffFFFFFFSet Elixir to use.")

            -- Pre-Pull Timer
            br.ui:createSpinner(section, "Pre-Pull Timer", 2, 0, 10, 0.1, "Set desired time offset to opener (DBM Required). Min: 0 / Max: 10 / Interval: 0.1")
            
        br.ui:checkSectionState(section)

        ----------------------
		--- TOGGLE OPTIONS ---
		----------------------
		section = br.ui:createSection(br.ui.window.profile,  "Toggle Keys")
        -- Single/Multi Toggle
            br.ui:createDropdownWithout(section, "Rotation Mode", br.dropOptions.Toggle,  6)
            --Cooldown Key Toggle
            br.ui:createDropdownWithout(section, "Cooldown Mode", br.dropOptions.Toggle,  6)
            --Defensive Key Toggle
            br.ui:createDropdownWithout(section, "Defensive Mode", br.dropOptions.Toggle,  6)
            -- Interrupts Key Toggle
            br.ui:createDropdownWithout(section, "Interrupt Mode", br.dropOptions.Toggle,  6)  
        br.ui:checkSectionState(section)

        -------------------------
        --- Damage Over Time  ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile,  "Affliction .:|:. DoTs")
            -- Unstable Affliction Mouseover
            -- No Dot units
            br.ui:createCheckbox(section, "Mousever UA", "Toggles casting unstable Affliction to your mouseover target")

            -- Max Dots
            br.ui:createSpinner(section, "Agony Count", 8, 1, 25, 1, "The maximum amount of running Agony. Standard is 8")   
            br.ui:createSpinner(section, "Corruption Count", 8, 1, 25, 1, "The maximum amount of running Corruption. Standard is 8")
            br.ui:createSpinner(section, "Siphon Life Count", 8, 1, 25, 1, "The maximum amount of running Siphon Life. Standard is 8")
            
			-- No Dot units
            br.ui:createCheckbox(section, "Dot Blacklist", "Ignore certain units for dots")

            -- Darkglare dots
            br.ui:createSpinner(section, "Darkglare Dots", 3, 0, 4, 1, "Total number of dots needed on target to cast Darkglare (excluding UA). Standard is 3. Uncheck for auto use.")

			-- Spread agony on single target
            br.ui:createSpinner(section, "Spread Agony on ST", 3, 1, 15, 1, "Check to spread Agony when running in single target", "The amount of additionally running Agony. Standard is 3")
        br.ui:checkSectionState(section)

		-------------------------
        --- OFFENSIVE OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile,  "Affliction .:|:. Offensive")
            -- Darkglare
            br.ui:createDropdown(section, "Darkglare", {"|cffFFFFFFAuto", "|cffFFFFFFMax-Dot Duration",	"|cffFFFFFFOn Cooldown"}, 1, "|cffFFFFFFWhen to cast Darkglare")

			-- Agi Pot
            br.ui:createCheckbox(section, "Potion", "Use Potion")

            -- Augment
            br.ui:createCheckbox(section, "Augment", "Use Augment")

            -- Racial
            br.ui:createCheckbox(section, "Racial", "Use Racial")
            
			-- Trinkets
            br.ui:createCheckbox(section, "Trinkets", "Use Trinkets")

            -- Blood oF The Enemy
            br.ui:createCheckbox(section, "Blood oF The Enemy", "Use Blood of the enemy, line it up with darkglare")

            -- Malefic Rapture
            br.ui:createSpinner(section, "Malefic Rapture TTD", 20, 1, 100, 1, "The TTD to be <= to inside a raid/instance to start casting MR to burn")

            -- Malefic Rapture
            br.ui:createSpinner(section, "Malefic Rapture BloodLust", "Cast Malefic Rapture during bloodlust if you have at least 1 shard")

            -- Haunt TTD
            br.ui:createSpinner(section, "Haunt TTD", 6, 1, 15, 1, "The TTD before casting Haunt")

            -- Drain Soul Canceling
            --br.ui:createSpinner(section, "Drain Soul Clipping", 4, 1, 5, 1, "The tick of Drain Soul to cancel the cast at (5-6 ticks total)", true)

            -- Unstable Affliction Priority Mark
            --br.ui:createDropdown(section, "Priority Unit", { "|cffffff00Star", "|cffffa500Circle", "|cff800080Diamond", "|cff008000Triangle", "|cffffffffMoon", "|cff0000ffSquare", "|cffff0000Cross", "|cffffffffSkull" }, 8, "Mark to Prioritize",true)



            -- Seed of Corruption
            --br.ui:createSpinner(section, "Seed of Corruption Unit", 4, 1, 15, 1, nil, "Unit count to cast Seed of Corruption at", true)

            
			-- UA Shards
			--br.ui:createSpinner(section, "UA Shards", 5, 1, 5, 1, nil, "Use UA on Shards", true)
        br.ui:checkSectionState(section)
		-------------------------
		--- DEFENSIVE OPTIONS ---
		-------------------------
		section = br.ui:createSection(br.ui.window.profile, "Affliction .:|:. Defensive")
            -- Soulstone
		    br.ui:createDropdown(section, "Soulstone", {"|cffFFFFFFTarget","|cffFFFFFFMouseover","|cffFFFFFFTank", "|cffFFFFFFHealer", "|cffFFFFFFHealer/Tank", "|cffFFFFFFAny", "|cffFFFFFFPlayer"},
            1, "|cffFFFFFFTarget to cast on")
            
            --- Healthstone Creation
            br.ui:createSpinner(section, "Create Healthstone",  3,  0,  3,  5,  "|cffFFFFFFToggle creating healthstones, and how many in bag before creating more")

            -- Healthstone
            br.ui:createSpinner(section, "Pot/Stoned",  45,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")

            -- Demonic Gateway
            br.ui:createDropdown(section, "Demonic Gateway", br.dropOptions.Toggle, 6)

            -- Heirloom Neck
            br.ui:createSpinner(section, "Heirloom Neck",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")

            -- Gift of The Naaru
            if br.player.race == "Draenei" then
                br.ui:createSpinner(section, "Gift of the Naaru",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            end

            -- Dark Pact
            br.ui:createSpinner(section, "Dark Pact", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")

            -- Mortal Coil 
            br.ui:createSpinner(section, "Mortal Coil",  23,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")

            -- Drain Life
            br.ui:createSpinner(section, "Drain Life", 48, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")

            -- Health Funnel
            br.ui:createSpinner(section, "Health Funnel (Demon)", 50, 0, 100, 5, "|cffFFFFFFHealth Percent of Demon to Cast At")

            br.ui:createSpinnerWithout(section, "Health Funnel (Player)", 50, 0, 100, 5, "|cffFFFFFFHealth Percent of Player to Cast At")

            -- Unending Resolve
            br.ui:createSpinner(section, "Unending Resolve", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")

            -- Devour Magic
            br.ui:createDropdown(section,"Devour Magic", {"|cffFFFF00Selected Target","|cffFFBB00Auto"}, 1, "|ccfFFFFFFTarget to Cast On")

        br.ui:checkSectionState(section)
        -- Interrupt Options
        section = br.ui:createSection(br.ui.window.profile, "Affliction .:|:. Interrupts")
            br.ui:createDropdown(section, "Shadowfury Key", br.dropOptions.Toggle, 6)

            -- Interrupt Percentage
            br.ui:createSpinner(section, "Interrupt At",  0,  0,  95,  5,  "|cffFFFFFFCast Percent to Cast At")

        br.ui:checkSectionState(section)
	end
	optionTable = {{
		[1] = "Rotation Options",
		[2] = rotationOptions,
	}}
	return optionTable
end

--------------
--- Locals ---
--------------
-- BR API Locals - Many of these are located from System/API, this is a sample of commonly used ones but no all inclusive
local buff
local cast
local cd
local debuff
local charges
local enemies
local essence
local equiped
local gcd
local gcdMax
local has
local inCombat
local item
local level
local mode
local moving 
local ui
local pet
-- Warlock Combat Log Reader
local cl
local dsTicks
local maxdsTicks
local php
local pullTimer
local shards
local spell
local talent
local tanks
local cd
local traits
local units
local use
local inInstance
local inRaid
-- General Locals - Common Non-BR API Locals used in profiles
local agonyCount
local castSummonId = 0
local combatTime
local corruptionCount
local haltProfile
local hastar
local healPot
local profileStop
local siphonLifeCount
local spellHaste
local summonId = 0
local summonPet
local ttd
local seedTarget
-- Profile Specific Locals - Any custom to profile locals
local shards
local useSeed
local padding
local maintainSE
local actionList = {}

-----------------
--- Functions --- -- List all profile specific custom functions here
-----------------
if br.pauseTime == nil then br.pauseTime = GetTime() end

-- local function CDOptionEnabled (OptionName)
--     local OptionValue = getOptionValue(OptionName)
--     -- Always				Will use the ability even if CDs are disabled.
--     -- Always Boss			Will use the ability even if CDs are disabled as long as the current target is a Boss.
--     -- OnCooldown			Will only use the ability if the Cooldown Toggle is Enabled.
--     -- OnCooldown Boss		Will only use the ability if the Cooldown Toggle is Enabled and Target is a Boss.
--     if ui.checked(OptionName) then
--         if OptionValue == 1 then
--             return true
--         end
--         if OptionValue == 2 then
--             return isBoss_local()
--         end
--         if OptionValue == 3 then
--             return mode.cooldown == 1
--         end
--         if OptionValue == 4 then
--             return mode.cooldown == 1 and isBoss_local()
--         end
--     end
-- end

 -- Blacklist dots
 local noDotUnits = {
    [135824]=true, -- Nerubian Voidweaver
    [139057]=true, -- Nazmani Bloodhexer
    [129359]=true, -- Sawtooth Shark
    [129448]=true, -- Hammer Shark
    [134503]=true, -- Silithid Warrior
    [137458]=true, -- Rotting Spore
    [139185]=true, -- Minion of Zul
    [120651]=true, -- Explosive
}
local function noDotCheck(unit)
    if ui.checked("Dot Blacklist") and (noDotUnits[GetObjectID(unit)] or UnitIsCharmed(unit)) then return true end
    if isTotem(unit) then return true end
    unitCreator = UnitCreator(unit)
    if unitCreator ~= nil and UnitIsPlayer(unitCreator) ~= nil and UnitIsPlayer(unitCreator) == true then return true end
    --if GetObjectID(unit) == 137119 and getBuffRemain(unit, 271965) > 0 then return true end
    return false
end
--------------------
--- Action Lists --- -- All Action List functions from SimC (or other rotation logic) here, some common ones provided
-- Action List - Pre-Combat
actionList.Leveling = function()
    if level >= 10 then     


    if level >= 27 then
    -- Seed of Corruption
    for i = 1, #enemies.yards40 do
        local thisUnit = enemies.yards40[i]
        local thisHP = getHP(thisUnit)
        if (not moving 
        and not debuff.seedOfCorruption.exists(thisUnit)
        or not debuff.seedOfCorruption.exists(thisUnit) 
        and thisHP > 80) or thisHP <= 20 or getTTD(thisUnit,20) >= 10
        then
            if cast.seedOfCorruption(thisUnit) then br.addonDebug("Casting Seed of Corruption") return true end
        end
    end
end

        -- Unstable Affliction
        if level >= 13 then
            unstableAfflictionFUCK()

            if ui.checked("Mousever UA") 
            and UnitExists("mouseover")
            and not UnitIsDeadOrGhost("mouseover")
            then 
                unstableAfflictionFUCK("mouseover")
            end
        end

            -- Agony
            if traits.pandemicInvocation.active then
                if agonyCount < ui.value("Spread Agony on ST") then
                    for i = 1, #enemies.yards40 do
                        local thisUnit = enemies.yards40[i]
                        if not noDotCheck(thisUnit) and debuff.agony.remain(thisUnit) <= 5.4 and getTTD(thisUnit) > debuff.agony.remain(thisUnit) + (2/spellHaste) then
                            if cast.agony(thisUnit) then br.addonDebug("Casting Agony [Pandemic Invocation]") return true end
                        end
                    end
                end
            else
                if agonyCount < ui.value("Spread Agony on ST") then
                    for i = 1, #enemies.yards40 do
                        local thisUnit = enemies.yards40[i]
                        if not noDotCheck(thisUnit) and debuff.agony.refresh(thisUnit) and getTTD(thisUnit) > debuff.agony.remain(thisUnit) + (2/spellHaste) then
                            if cast.agony(thisUnit) then br.addonDebug("Casting Agony [Refresh]") return true end
                        end
                    end
                end
            end

            -- Corruption
            if traits.pandemicInvocation.active and not talent.absoluteCorruption then
                if corruptionCount < 2 then
                    for i = 1, #enemies.yards40 do
                        local thisUnit = enemies.yards40[i]
                        if not noDotCheck(thisUnit) and debuff.corruption.remain(thisUnit) <= 5.4 and getTTD(thisUnit) > debuff.corruption.remain(thisUnit) + (2/spellHaste) then
                            if cast.corruption(thisUnit) then br.addonDebug("Casting Corruption [Pandemic Invocation]") return true end
                        end
                    end
                end
            elseif not talent.absoluteCorruption then
                if corruptionCount < 2 then
                    for i = 1, #enemies.yards40 do
                        local thisUnit = enemies.yards40[i]
                        if not noDotCheck(thisUnit) and  debuff.corruption.refresh(thisUnit) and getTTD(thisUnit) > debuff.corruption.remain(thisUnit) + (2/spellHaste) then
                            if cast.corruption(thisUnit) then br.addonDebug("Casting Corruption [Refresh]") return true end
                        end
                    end
                end
            elseif talent.absoluteCorruption then
                if corruptionCount < 2 then
                    for i = 1, #enemies.yards40 do
                        local thisUnit = enemies.yards40[i]
                        if not noDotCheck(thisUnit) and  not debuff.corruption.exists(thisUnit) and not debuff.seedOfCorruption.exists(thisUnit) then
                            if cast.corruption(thisUnit) then br.addonDebug("Casting Corruption [Absolute Corruption]") return true end
                        end
                    end
                end
            end

            -- Siphon Life
            if talent.siphonLife then
                if traits.pandemicInvocation.active then
                    if siphonLifeCount < 2 then
                        for i = 1, #enemies.yards40 do
                            local thisUnit = enemies.yards40[i]
                            if not noDotCheck(thisUnit) and debuff.siphonLife.remain(thisUnit) < 5 and getTTD(thisUnit) > debuff.siphonLife.remain(thisUnit) + (3/ 1 + spellHaste) then
                                if cast.siphonLife(thisUnit) then br.addonDebug("Casting Siphon Life [Pandemic Invocation]") return true end
                            end
                        end
                    end
                else
                    if siphonLifeCount < 2 then
                        for i = 1, #enemies.yards40 do
                            local thisUnit = enemies.yards40[i]
                            if not noDotCheck(thisUnit) and  debuff.siphonLife.refresh(thisUnit) and getTTD(thisUnit) > debuff.siphonLife.remain(thisUnit) + (3/spellHaste) then
                                if cast.siphonLife(thisUnit) then br.addonDebug("Casting Siphon Life [Refresh]") return true end
                            end
                        end
                    end
                end
            end

            if level >= 42 and useCDs() or isBoss("target") or getTTD("target") >= 15 then
                if cast.able.summonDarkglare() 
                and getDistance("target") <= 40 
                and shards > 0
                then
                    if debuff.agony.exists("target") 
                    and debuff.corruption.exists("target") 
                    and debuff.unstableAffliction.exists("target")
                    then
                        if cast.summonDarkglare() then return true end 
                    end
                end
            end

            -- Haunt
            if level >= 45 then
                if talent.haunt and cast.able.haunt() and getTTD("target") >= ui.value("Haunt TTD") then if cast.haunt() then return true end end 
            end

            if level >= 40 then
                -- Mortal Coil
                if talent.mortalCoil and ui.checked("Mortal Coil") and php <= ui.value("Mortal Coil") then
                    if cast.mortalCoil() then br.addonDebug("Casting Mortal Coil") return true end
                end
            end


            if level >= 35 and useCDs() or isBoss("target") or getTTD("target") >= 15 then
                -- Phantom Singularity
                if talent.phantomSingularity and cd.phantomSingularity.remain() <= gcdMax and cast.able.phantomSingularity() then
                    if cast.phantomSingularity() then return true end 
                end
                -- Vile Taint
                if talent.vileTaint and cd.vileTaint.remain() <= gcdMax and cast.able.vileTaint() then
                    if cast.vileTaint() then return true end 
                end
            end

            -- Malefic Grasp
            if level >= 11 then
                if cast.able.maleficRapture() 
                and getDistance("target") <= 40 
                and shards > 0
                then
                    if debuff.agony.exists("target") 
                    and debuff.corruption.exists("target") 
                    or debuff.unstableAffliction.exists("target")
                    and getTTD("target") > gcdMax + cast.time.maleficRapture()
                    then
                        if cast.maleficRapture() then return true end 
                    end
                end
            end

            -- Shadowbolt filler
            if cast.able.shadowBolt2() and not moving or buff.nightfall.exists() then if cast.shadowBolt2() then return true end end

    end
end


--------------------
-- Action List - Extra
actionList.Extra = function()
    -- Dummy Test
    if ui.checked("DPS Testing") then
        if GetObjectExists("target") then
            if getCombatTime() >= (tonumber(ui.value("DPS Testing"))*60) and isDummy() then
                StopAttack()
                ClearTarget()
                if ui.checked("Pet Management") then
                    PetStopAttack()
                    PetFollow()
                end
                Print(tonumber(ui.value("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
                profileStop = true
            end
        end
    end -- End Dummy Test
    if isChecked("Pig Catcher") then
        bossHelper()
    end
end -- End Action List - Extra

-- Action List - Defensive
actionList.Defensive = function()
    if useDefensive() then
        -- Pot/Stoned
        if ui.checked("Pot/Stoned") and inCombat and (use.able.healthstone() or canUseItem(healPot))
            and (hasHealthPot() or has.healthstone()) and php <= ui.value("Pot/Stoned")
        then
            if use.able.healthstone() then
                if use.healthstone() then br.addonDebug("Using Healthstone") return true end
            elseif canUseItem(healPot) then
                useItem(healPot)
                br.addonDebug("Using Health Potion")
            end
        end

        -- Soulstone
        if isChecked("Soulstone") and not moving and inCombat and br.timer:useTimer("Soulstone", 4) then
            if getOptionValue("Soulstone") == 1 and -- Target
                    UnitIsPlayer("target") and
                    UnitIsDeadOrGhost("target") and
                    GetUnitIsFriend("target", "player")
                then
                if cast.soulstone("target", "dead") then
                    br.addonDebug("Casting Soulstone")
                    return true
                end
            end

            if getOptionValue("Soulstone") == 2 and -- Mouseover
                    UnitIsPlayer("mouseover") and
                    UnitIsDeadOrGhost("mouseover") and
                    GetUnitIsFriend("mouseover", "player")
                then
                if cast.soulstone("mouseover", "dead") then
                    br.addonDebug("Casting Soulstone")
                    return true
                end
            end

            if getOptionValue("Soulstone") == 3 then -- Tank
                for i = 1, #tanks do
                    if UnitIsPlayer(tanks[i].unit) and UnitIsDeadOrGhost(tanks[i].unit) and GetUnitIsFriend(tanks[i].unit, "player") and getDistance(tanks[i].unit) <= 40 then
                        if cast.soulstone(tanks[i].unit, "dead") then
                            br.addonDebug("Casting Soulstone")
                            return true
                        end
                    end
                end
            end

            if getOptionValue("Soulstone") == 4 then -- Healer
                for i = 1, #br.friend do
                    if
                        UnitIsPlayer(br.friend[i].unit) and UnitIsDeadOrGhost(br.friend[i].unit) and GetUnitIsFriend(br.friend[i].unit, "player") and
                            (UnitGroupRolesAssigned(br.friend[i].unit) == "HEALER" or br.friend[i].role == "HEALER")
                        then
                        if cast.soulstone(br.friend[i].unit, "dead") then
                            br.addonDebug("Casting Soulstone")
                            return true
                        end
                    end
                end
            end

            if getOptionValue("Soulstone") == 5 then -- Tank/Healer
                for i = 1, #br.friend do
                    if
                        UnitIsPlayer(br.friend[i].unit) and UnitIsDeadOrGhost(br.friend[i].unit) and GetUnitIsFriend(br.friend[i].unit, "player") and
                            (UnitGroupRolesAssigned(br.friend[i].unit) == "HEALER" or br.friend[i].role == "HEALER" or br.friend[i].role == "TANK" or UnitGroupRolesAssigned(br.friend[i].unit) == "TANK")
                        then
                        if cast.soulstone(br.friend[i].unit, "dead") then
                            br.addonDebug("Casting Soulstone")
                            return true
                        end
                    end
                end
            end

            if getOptionValue("Soulstone") == 6 then -- Any
                for i = 1, #br.friend do
                    if UnitIsPlayer(br.friend[i].unit) and UnitIsDeadOrGhost(br.friend[i].unit) and GetUnitIsFriend(br.friend[i].unit, "player") then
                        if cast.soulstone(br.friend[i].unit, "dead") then
                            br.addonDebug("Casting Soulstone")
                            return true
                        end
                    end
                end
            end
        end

        -- Demonic Gateway
        if isChecked("Demonic Gateway") 
        and SpecificToggle("Demonic Gateway") 
        and not GetCurrentKeyBoardFocus() 
        then
            if br.timer:useTimer("RoF Delay", 1) and cast.demonicGateway(nil,"aoe",1,8,true) then br.addonDebug("Casting Demonic Gateway") return end 
        end
        
        --[[ if getDistance("target") <= 40 then
            if br.timer:useTimer("RoF Delay", 1) and cast.demonicGateway(nil,"aoe",1,8,true) then br.addonDebug("Cast Demonic Gateway") return true end
        end--]]

        -- Heirloom Neck
        if ui.checked("Heirloom Neck") and php <= ui.value("Heirloom Neck") then
            if use.able.heirloomNeck() and item.heirloomNeck ~= 0
                and item.heirloomNeck ~= item.manariTrainingAmulet
            then
                if use.heirloomNeck() then br.addonDebug("Using Heirloom Neck") return true end
            end
        end

        -- Gift of the Naaru
        if ui.checked("Gift of the Naaru") and php <= ui.value("Gift of the Naaru")
            and php > 0 and race == "Draenei"
        then
            if cast.racial() then br.addonDebug("Casting Racial: Gift of the Naaru") return true end
        end

        -- Dark Pact
        if ui.checked("Dark Pact") and php <= ui.value("Dark Pact") then
            if cast.darkPact() then br.addonDebug("Casting Dark Pact") return true end
        end

        -- Mortal Coil
        if ui.checked("Mortal Coil") and php <= ui.value("Mortal Coil") then
            if cast.mortalCoil() then br.addonDebug("Casting Mortal Coil") return true end
        end

        -- Drain Life
        if ui.checked("Drain Life") and php <= ui.value("Drain Life") and not isCastingSpell(spell.drainLife) then
            if cast.drainLife() then br.addonDebug("Casting Drain Life") return true end
        end

        -- Health Funnel
        if not moving and ui.checked("Health Funnel (Demon)") and getHP("pet") <= ui.value("Health Funnel (Demon)") and getHP("player") >= ui.value("Health Funnel (Player)") and GetObjectExists("pet") and not UnitIsDeadOrGhost("pet") then
            if cast.healthFunnel() then br.addonDebug("Casting Health Funnel") return true end
        end

        -- Unending Resolve
        if ui.checked("Unending Resolve") and php <= ui.value("Unending Resolve") and inCombat then
            if cast.unendingResolve() then br.addonDebug("Casting Unending Resolve") return true end
        end

        -- Devour Magic
        if isChecked("Devour Magic") and (pet.active.id() == 417 or pet.active.id() == 78158) then
            if getOptionValue("Devour Magic") == 1 then
                if canDispel("target",spell.devourMagic) and GetObjectExists("target") then
                    CastSpellByName(GetSpellInfo(spell.devourMagic),"target") br.addonDebug("Casting Devour Magic")  
                end
            elseif getOptionValue("Devour Magic") == 2 then
                for i = 1, #enemies.yards30 do
                    local thisUnit = enemies.yards30[i]
                    if canDispel(thisUnit,spell.devourMagic) then
                        CastSpellByName(GetSpellInfo(spell.devourMagic),thisUnit) br.addonDebug("Casting Devour Magic") 
                    end
                end
            end
        end 
    end -- End Defensive Toggle
end

-- Action List - Interrupts
actionList.Interrupts = function()
    if useInterrupts() and (pet.active.id() == 417 or pet.active.id() == 78158) then
        for i=1, #enemies.yards40 do
            local thisUnit = enemies.yards40[i]
            if canInterrupt(thisUnit,ui.value("Interrupt At")) then
                if pet.active.id() == 417 then
                    if cast.spellLock(thisUnit) then end
                elseif pet.active.id() == 78158 then
                    if cast.shadowLock(thisUnit) then  end
                end
            end
        end
    end -- End useInterrupts check
end

-- Action List - Cooldowns
actionList.Cooldown = function()
        --actions.cooldowns=worldvein_resonance
        if ui.checked("Use Essence") and essence.worldveinResonance.active and cd.worldveinResonance.remain() <= gcdMax and buff.lifeblood.stack() < 3 then
            if cast.worldveinResonance() then br.addonDebug("Casting Worldvein Resonance") return end
        end

        -- actions.cooldowns+=/use_item,name=azsharas_font_of_power,if=(!talent.phantom_singularity.enabled|cooldown.phantom_singularity.remains<4*spell_haste|!cooldown.phantom_singularity.remains)&cooldown.summon_darkglare.remains<19*spell_haste+soul_shard*azerite.dreadful_calling.rank&dot.agony.remains&dot.corruption.remains&(dot.siphon_life.remains|!talent.siphon_life.enabled)
        if (not talent.phantomSingularity or cd.phantomSingularity.remain() < 4* spellHaste) and cd.summonDarkglare.remain() < 19 * spellHaste + (shards * traits.dreadfulCalling.rank) 
            and debuff.agony.exists("target") and debuff.corruption.exists("target") and (debuff.siphonLife.exists("target") or not talent.siphonLife)
        then
            if equiped.azsharasFontOfPower and canUseItem(item.azsharasFontOfPower) then
                if br.timer:useTimer("Font Delay", 4) then
                    br.addonDebug("Using Font Of Azshara")
                    useItem(169314)
                end
            end
        end

        -- actions.cooldowns+=/potion,if=(talent.dark_soul_misery.enabled&cooldown.summon_darkglare.up&cooldown.dark_soul.up)|cooldown.summon_darkglare.up|target.time_to_die<30
        if ui.checked("Potion") and (talent.darkSoul and cd.summonDarkglare.remain <= gcdMax and cd.darkSoul.remain() <= gcdMax) or (cd.summonDarkglare.remain() <= gcdMax and not talent.darkSoul) or getTTD("target") < 30 then
            if not buff.potionOfUnbridledFury.exists() and canUseItem(item.potionOfUnbridledFury) then
                if use.potionOfUnbridledFury() then br.addonDebug("Using Potion of Unbridled Fury") return end
            end
        end

        -- actions.cooldowns+=/use_items,if=cooldown.summon_darkglare.remains>70|time_to_die<20|((buff.active_uas.stack=5|soul_shard=0)&(!talent.phantom_singularity.enabled|cooldown.phantom_singularity.remains)&(!talent.deathbolt.enabled|cooldown.deathbolt.remains<=gcd|!cooldown.deathbolt.remains)&!cooldown.summon_darkglare.remains)
        if ui.checked("Trinkets") and cd.summonDarkglare.remain() > 70 or getTTD("target") < 20 or ((shards == 0) and 
            (not talent.phantomSingularity or cd.phantomSingularity.remain() > gcdMax) and (not talent.deathbolt or cd.deathbolt.remain <= gcdMax) and cd.summonDarkglare.remain <= gcdMax)
        then
            local mainHand = GetInventorySlotInfo("MAINHANDSLOT")
            if canUseItem(mainHand) and equiped.neuralSynapseEnhancer(mainHand) then
                use.slot(mainHand)
                br.addonDebug("Using Neural Synapse Enhancer")
            end
            for i = 13, 14 do
                if use.able.slot(i) and not (equiped.azsharasFontOfPower(i) or equiped.pocketSizedComputationDevice(i)
                    or equiped.rotcrustedVoodooDoll(i) or equiped.shiverVenomRelic(i) or equiped.aquipotentNautilus(i)
                    or equiped.tidestormCodex(i) or equiped.vialOfStorms(i)) 
                then
                    if use.slot(i) then br.addonDebug("Using Trinket in slot "..i.." [CD]") end
                end
            end
        end

        -- actions.cooldowns+=/fireblood,if=!cooldown.summon_darkglare.up
        -- actions.cooldowns+=/blood_fury,if=!cooldown.summon_darkglare.up
        if ui.checked("Racial") and cd.summonDarkglare > gcdMax and (race == "Troll" or race == "Orc" or race == "DarkIronDwarf")
        then
            if cast.racial() then br.addonDebug("Casting Berserking") return true end
        end

        -- actions.cooldowns+=/memory_of_lucid_dreams,if=time>30
        if ui.checked("Use Essence") and combatTime > 30 and essence.memoryOfLucidDreams.active and cd.memoryOfLucidDreams.remain() <= gcdMax then
            if cast.memoryOfLucidDreams() then br.addonDebug("Casting Memory of Lucid Dreams") return true end
        end

        -- actions.cooldowns+=/dark_soul,if=target.time_to_die<20+gcd|talent.sow_the_seeds.enabled&cooldown.summon_darkglare.remains>=cooldown.summon_darkglare.duration-10
        if talent.darkSoul() and not moving and cd.summonDarkglare.remain() >= 20 then
            if cast.darkSoul() then br.addonDebug("Casting Dark Soul") return true end
        end 

        -- Guardian of Azeroth
        if essence.guardianOfAzeroth.active and cd.guardianOfAzeroth.remain() <= gcdMax and pet.darkglare.active() then
            if cast.guardianOfAzeroth() then br.addonDebug("Casting Guardian of Azeroth") return true end
        end

        -- actions.cooldowns+=/blood_of_the_enemy,if=pet.darkglare.remains|(!cooldown.deathbolt.remains|!talent.deathbolt.enabled)&cooldown.summon_darkglare.remains>=80&essence.blood_of_the_enemy.rank>1
        if ui.checked("Use Essence") or ui.checked("Blood oF The Enemy") and (buff.darkSoul.exists() or pet.darkglare.active() or (cd.deathbolt.remain() < gcdMax or not talent.deathbolt) and cd.summonDarkglare.remain() >= 80 and essence.bloodOfTheEnemy.rank > 1) then
            if cast.bloodOfTheEnemy() then br.addonDebug("Casting Blood of the Enemy") return true end
        end


        --# Use damaging on-use trinkets more or less on cooldown, so long as the ICD they incur won't effect any other trinkets usage during cooldowns.
        --actions.cooldowns+=/use_item,name=pocketsized_computation_device,if=(cooldown.summon_darkglare.remains>=25|target.time_to_die<=30)&(cooldown.deathbolt.remains|!talent.deathbolt.enabled)
        --actions.cooldowns+=/use_item,name=rotcrusted_voodoo_doll,if=(cooldown.summon_darkglare.remains>=25|target.time_to_die<=30)&(cooldown.deathbolt.remains|!talent.deathbolt.enabled)
        --actions.cooldowns+=/use_item,name=shiver_venom_relic,if=(cooldown.summon_darkglare.remains>=25|target.time_to_die<=30)&(cooldown.deathbolt.remains|!talent.deathbolt.enabled)
        --actions.cooldowns+=/use_item,name=aquipotent_nautilus,if=(cooldown.summon_darkglare.remains>=25|target.time_to_die<=30)&(cooldown.deathbolt.remains|!talent.deathbolt.enabled)
        --actions.cooldowns+=/use_item,name=tidestorm_codex,if=(cooldown.summon_darkglare.remains>=25|target.time_to_die<=30)&(cooldown.deathbolt.remains|!talent.deathbolt.enabled)
        --actions.cooldowns+=/use_item,name=vial_of_storms,if=(cooldown.summon_darkglare.remains>=25|target.time_to_die<=30)&(cooldown.deathbolt.remains|!talent.deathbolt.enabled)
        if ui.checked("Trinkets") and (cd.summonDarkglare.remain() >= 25 or getTTD("target") <= 30) and (cd.deathbolt.remain() <= gcdMax or not talent.deathbolt) then
            for i = 13, 14 do
                if use.able.slot(i) and (equiped.azsharasFontOfPower(i) or equiped.pocketSizedComputationDevice(i)
                    or equiped.rotcrustedVoodooDoll(i) or equiped.shiverVenomRelic(i) or equiped.aquipotentNautilus(i)
                    or equiped.tidestormCodex(i) or equiped.vialOfStorms(i)) 
                then
                    if use.slot(i) then br.addonDebug("Using Trinket in slot "..i.." [CD]") return true end
                end
            end
        end

        --actions.cooldowns+=/ripple_in_space
        if ui.checked("Use Essence") and essence.rippleInSpace.active and cd.rippleInSpace.remain() <= gcdMax then
            if cast.rippleInSpace() then br.addonDebug("Casting Ripple In Space") return true end
        end
end -- End Action List - Cooldowns

actionList.Opener = function()
    opener = true
        -- actions.cooldowns+=/potion,if=(talent.dark_soul_misery.enabled&cooldown.summon_darkglare.up&cooldown.dark_soul.up)|cooldown.summon_darkglare.up|target.time_to_die<30
        if ui.checked("Potion") and (talent.darkSoul and cd.summonDarkglare.remain <= gcdMax and cd.darkSoul.remain() <= gcdMax) or (cd.summonDarkglare.remain() <= gcdMax and not talent.darkSoul) or getTTD("target") < 30 then
            if not buff.potionOfUnbridledFury.exists() and canUseItem(item.potionOfUnbridledFury) then
                if use.potionOfUnbridledFury() then br.addonDebug("Using Potion of Unbridled Fury") return end
            end
        end

        if not debuff.agony.exists("target") then if cast.agony() then return true end end
        if not debuff.unstableAffliction.exists("target") then if cast.unstableAffliction() then return true end end
        if not debuff.corruption.exists("target") then if cast.corruption() then return true end end

        if talent.darkSoul
        and cd.darkSoul.remain() <= gcdMax 
        then
            if cast.darkSoul() then return true end
        end

        if cast.able.vileTaint()
        and cd.vileTaint.remain() <= gcdMax
        then
            if cast.vileTaint() then return true end 
        end

        if cast.able.summonDarkglare()
        and cd.summonDarkglare.remain() <= gcdMax
        then
            if cast.summonDarkglare() then return true end 
        end

        if cast.able.summonDarkglare()
        and cd.vileTaint.remain() <= gcdMax
        then
            if cast.summonDarkglare() then return true end 
        end

end


-- Action List - Pre-Combat
actionList.PreCombat = function()
    -- Fel Domination
    if ui.checked("Fel Domination") and inCombat
    and not GetObjectExists("pet") or UnitIsDeadOrGhost("pet")
    and cd.felDomination.remain() <= gcdMax
    then
        if cast.felDomination() then br.addonDebug("Fel Domination") return true end
    end
 
    --actions.precombat+=/summon_pet
    if ui.checked("Pet Management") 
    and (not inCombat or buff.felDomination.exists())
    and (not moving or buff.felDomination.exists())
    and level >= 5 and GetTime() - br.pauseTime > 0.5 and br.timer:useTimer("summonPet", 1) 
    then
        if mode.petSummon == 5 and pet.active.id() ~= 0 then
            PetDismiss()
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

    if not (inCombat and not (IsFlying() or IsMounted())) then
        if getOptionValue("Soulstone") == 7 then -- Player
            if not UnitIsDeadOrGhost("player") then
                if cast.soulstone("player") then br.addonDebug("Casting Soulstone [Player]" ) return true end
            end
        end

        -- Create Healthstone
        if ui.checked("Create Healthstone") and GetItemCount(5512) < 1 or itemCharges(5512) < 3 then
            if cast.createHealthstone() then br.addonDebug("Casting Create Healthstone" ) return true end
        end

        if ui.checked("Pre-Pull Timer") then
            -- Flask / Crystal
            if ((pullTimer <= getValue("Pre-Pull Timer") and pullTimer > 4 and (not equiped.azsharasFontOfPower or not canUseItem(item.azsharasFontOfPower))) or (equiped.azsharasFontOfPower and canUseItem(item.azsharasFontOfPower) and pullTimer <= 20 and pullTimer > 8)) then
                --actions.precombat=flask
                if getOptionValue("Elixir") == 1 and inRaid and not buff.greaterFlaskOfEndlessFathoms.exists() and canUseItem(item.greaterFlaskOfEndlessFathoms) then
                    if use.greaterFlaskOfEndlessFathoms() then br.addonDebug("Using Greater Flask of Endless Fathoms [Pre-Pull]") return end
                elseif getOptionValue("Elixir") == 2 and inRaid and not buff.flaskOfEndlessFathoms.exists() and canUseItem(item.flaskOfEndlessFathoms) then
                    if use.flaskOfEndlessFathoms() then br.addonDebug("Using Flask of Endless Fathoms [Pre-Pull]") return end
                end

                -- actions.precombat+=/augmentation
                if ui.checked("Augment") and not buff.battleScarredAugmentRune.exists() and canUseItem(item.battleScarredAugmentRune) then
                    if use.battleScarredAugmentRune() then br.addonDebug("Using Battle-Scarred Augment Rune [Pre-Pull]") return end
                end

                if talent.grimoireOfSacrifice then
                    if cast.grimoireOfSacrifice() then br.addonDebug("Cast Grimoire Of Sacrifice [Pre-Pull]") return true end
                end

                -- actions.precombat+=/potion
                if ui.checked("Potion") and not buff.potionOfUnbridledFury.exists() and canUseItem(item.potionOfUnbridledFury) then
                    if use.potionOfUnbridledFury() then br.addonDebug("Using Potion of Unbridled Fury [Pre-Pull]") return end
                end

                -- actions.precombat+=/use_item,name=azsharas_font_of_power
            elseif equiped.azsharasFontOfPower and canUseItem(item.azsharasFontOfPower) and pullTimer <= 8 and pullTimer > 4 then
                if br.timer:useTimer("Font Delay", 4) then
                    br.addonDebug("Using Font Of Azshara [Pre-Pull]")
                    useItem(169314)
                end

                -- actions.precombat+=/seed_of_corruption,if=spell_targets.seed_of_corruption_aoe>=3&!equipped.169314
            elseif not moving and pullTimer <= 3 and br.timer:useTimer("SoC Delay", 3) and #enemies.yards10t >= 3 then
                CastSpellByName(GetSpellInfo(spell.seedOfCorruption)) br.addonDebug("Casting Seed of Corruption [Pre-Pull]") return
            elseif pullTimer <= 2 and br.timer:useTimer("Haunt Delay", 2) and GetUnitExists("target") then
                if talent.haunt then    
                    CastSpellByName(GetSpellInfo(spell.haunt)) br.addonDebug("Casting Haunt [Pre-Pull]") return
                else
                    CastSpellByName(GetSpellInfo(spell.shadowBolt)) br.addonDebug("Casting Shadowbolt [Pre-Pull]") return
                end
            end
        end -- End Pre-Pull 
        if ui.checked("Auto Engage") and not inCombat and getDistance("target") <= 40 and getFacing("player","target") and br.timer:useTimer("Agony Delay", 2) then
            if cast.agony() then br.addonDebug("Casting Agony [Auto Engage]") return true end
        end
    end      
end -- End Action List - PreCombat

    function unstableAfflictionFUCK(unit)
        if unit == nil then unit = "target" end
        if moving then return false end

        if debuff.unstableAffliction.remain(unit) <= 6.8
        and debuff.agony.exists("target") and (debuff.corruption.exists("target") 
        and (debuff.siphonLife.exists("target") or not talent.siphonLife)) then
           if cast.unstableAffliction(unit) then br.addonDebug("Casting Unstable Affliction") return true end
        end
    end

actionList.Fillers = function()
    if debuff.agony.remain("target") > 5.8 and debuff.corruption.exists("target") and debuff.unstableAffliction.remain("target") > 7.2 then
    if not moving and not cast.current.drainSoul() and not debuff.vileTaint.exists("target") and shards > 0 or debuff.vileTaint.exists("target") and debuff.vileTaint.remain("target") < 2 and shards < 1 then
        if cast.drainSoul() then
        dsInterrupt = true
        return true end
    end
end
end

actionList.multi = function()
    -- Seed of Corruption
    if #enemies.yards10t >= 15   then
    for i = 1, #enemies.yards40 do
        local thisUnit = enemies.yards40[i]
        local thisHP = getHP(thisUnit)
        if (not moving 
        and not debuff.seedOfCorruption.exists(thisUnit)
        or not debuff.seedOfCorruption.exists(thisUnit) 
        and thisHP > 80) or thisHP <= 20 or getTTD(thisUnit,20) >= 10
        then
            if cast.seedOfCorruption(thisUnit) then br.addonDebug("Casting Seed of Corruption") return true end
        end
    end
end

    -- Phantom Singularity
    if talent.phantomSingularity then if cast.phantomSingularity() then br.addonDebug("Casting Phantom Singularity") return true end end

    -- Vile Taint
    if talent.vileTaint and shards > 1 and getTTD("target") >= gcdMax + 6 then
        if cast.vileTaint(nil,"aoe",1,8,true) then br.addonDebug("Casting Vile Taint") return true end
    end

    if inCombat and talent.sowTheSeeds and #enemies.yards10t >= 3 and shards > 0 then
        if cast.maleficRapture(units.dyn40) then br.addonDebug("Casting Malefic Rapture (Sow the Seeds)") return true end 
    end

    -- Focused Azerite Beam
    if ui.checked("Use Essence") and essence.focusedAzeriteBeam.active and cd.focusedAzeriteBeam.remain() <= gcdMax
    and ((essence.focusedAzeriteBeam.rank < 3 and not moving) or essence.focusedAzeriteBeam.rank >= 3) 
    and (getEnemiesInRect(2,25,isChecked("Show Drawings"),false) >= getOptionValue("Azerite Beam Units") or (isBoss("target") and getDistance("player","target") <= 25 and getFacing("player","target", 5))) 
    then
        if cast.focusedAzeriteBeam() then
            br.addonDebug("Casting Focused Azerite Beam")
            return 
        end
    end

    -- Purifying Blast
    if ui.checked("Use Essence") and essence.purifyingBlast.active and cd.purifyingBlast.remain() <= gcdMax then
        if cast.purifyingBlast("best", nil, minCount, 40) then br.addonDebug("Casting Purifying Blast") return true end
    end

    -- Reaping Flame
    if ui.checked("Use Essence") and essence.reapingFlames.active and cd.reapingFlames.remain() <= gcdMax then
        for i = 1, #enemies.yards40 do
            local thisUnit = enemies.yards40[i]
            local thisHP = getHP(thisUnit)
            if ((essence.reapingFlames.rank >= 2 and thisHP > 80) or thisHP <= 20 or getTTD(thisUnit,20) > 30) then
                if cast.reapingFlames(thisUnit) then br.addonDebug("Casting Reaping Flames") return true end
            end
        end
    end

    -- Agony
    if agonyCount < getOptionValue("Agony Count") then
        for i = 1, #enemies.yards40 do
            local thisUnit = enemies.yards40[i]
            if not noDotCheck(thisUnit) and debuff.agony.refresh(thisUnit) and getTTD(thisUnit) > debuff.agony.remain(thisUnit) + (2/spellHaste)  then
                if cast.agony(thisUnit) then br.addonDebug("Casting Agony [Multi]") return true end
            end
        end
    end

    -- Siphon Life
    if siphonLifeCount < getOptionValue("Siphon Life Count") then
        for i = 1, #enemies.yards40 do
            local thisUnit = enemies.yards40[i]
            if not noDotCheck(thisUnit) and debuff.siphonLife.refresh(thisUnit) and getTTD(thisUnit) > debuff.siphonLife.remain(thisUnit) + (3/spellHaste)  then
                if cast.siphonLife(thisUnit) then br.addonDebug("Casting Siphon Life [Multi]") return true end
            end
        end
    end

    -- Ripple In Space
    if ui.checked("Use Essence") and essence.rippleInSpace.active and cd.rippleInSpace.remain() <= gcdMax then
        if cast.rippleInSpace() then br.addonDebug("Casting Ripple In Space") return true end
    end
end

----------------
--- ROTATION ---
----------------
local function runRotation()
    ---------------------
    --- Define Locals ---
    ---------------------
    -- BR API Locals
    buff                                          = br.player.buff
    cast                                          = br.player.cast
    cd                                            = br.player.cd
    debuff                                        = br.player.debuff
    enemies                                       = br.player.enemies
    essence                                       = br.player.essence
    equiped                                       = br.player.equiped
    gcd                                           = br.player.gcd
    gcdMax                                        = br.player.gcdMax
    has                                           = br.player.has
    inCombat                                      = br.player.inCombat
    item                                          = br.player.items
    level                                         = br.player.level
    mode                                          = br.player.ui.mode
    moving                                        = GetUnitSpeed("player") > 0
    ui                                            = br.player.ui
    pet                                           = br.player.pet
    php                                           = br.player.health
    pullTimer                                     = br.DBM:getPulltimer()
    shards                                        = br.player.power.soulShards.frac()
    -- Warlock Combat Log Reader
    cl                                            = br.read
    spell                                         = br.player.spell
    talent                                        = br.player.talent
    traits                                        = br.player.traits
    tanks                                         = getTanksTable()
    units                                         = br.player.units
    use                                           = br.player.use
    inInstance                                    = br.player.unit.instance() == "party"
    inRaid                                        = br.player.unit.instance() == "raid"
    -- General Locals
    agonyCount                                    = br.player.debuff.agony.count()
    combatTime                                    = getCombatTime()
    hastar                                        = GetObjectExists("target")
    corruptionCount								  = br.player.debuff.corruption.count()
    healPot                                       = getHealthPot()
    profileStop                                   = profileStop or false
    seedTarget                                    = getBiggestUnitCluster(40,10)
    siphonLifeCount                               = br.player.debuff.siphonLife.count()
    spellHaste                                    = (1 + (GetHaste()/100))
    ttd                                           = getTTD
    haltProfile                                   = (inCombat and profileStop) or (IsMounted() or IsFlying()) or pause() or mode.rotation==2
    -- Units
    units.get(5) -- Makes a variable called, units.dyn5
    units.get(40) -- Makes a variable called, units.dyn40
    units.get(15) -- Makes a variable called, units.dyn15
    -- Enemies
    enemies.get(5) -- Makes a varaible called, enemies.yards5
    enemies.get(10,"target")

    -- Profile Specific Locals
    if actionList.PetManagement == nil then
        loadSupport("PetCuteOne")
        actionList.PetManagement = br.rotations.support["PetCuteOne"]
    end

    -- spellqueue ready
    local function spellQueueReady()
        --Check if we can queue cast
        local castingInfo = {UnitCastingInfo("player")}
        if castingInfo[5] then
            if (GetTime() - ((castingInfo[5] - tonumber(C_CVar.GetCVar("SpellQueueWindow")))/1000)) < 0 then
                return false
            end
        end
        return true
    end

    -- Pet Data
    if mode.petSummon == 1 and HasAttachedGlyph(spell.summonImp) then summonId = 58959
    elseif mode.petSummon == 1 then summonId = 416
    elseif mode.petSummon == 2 and HasAttachedGlyph(spell.summonVoidwalker) then summonId = 58960
    elseif mode.petSummon == 2 then summonId = 1860
    elseif mode.petSummon == 3 then summonId = 417
    elseif mode.petSummon == 4 then summonId = 1863 end

    local seedTarget = seedTarget or "target"
    local dsTarget
    local seedHit = 0
    local seedCorruptionExist = 0
    local seedTargetCorruptionExist = 0
    local seedTargetsHit = 1
    local lowestShadowEmbrace = lowestShadowEmbrace or "target"
    local enemyTable40 = enemies.get(40, "player", true)

    local inBossFight = false
    for i = 1, #enemyTable40 do
        local thisUnit = enemyTable40[i].unit
        if isBoss(thisUnit) then
            inBossFight = true
        end
        if talent.shadowEmbrace and debuff.shadowEmbrace.exists(thisUnit) then
            if debuff.shadowEmbrace.exists(lowestShadowEmbrace) then
                shadowEmbraceRemaining = debuff.shadowEmbrace.remain(lowestShadowEmbrace)
            else
                shadowEmbraceRemaining = 40
            end
            if debuff.shadowEmbrace.remain(thisUnit) < shadowEmbraceRemaining then
                lowestShadowEmbrace = thisUnit
            end
        end
        local unitAroundUnit = getEnemies(thisUnit, 10, true)
        if mode.seed == 1 and getFacing("player",thisUnit) and #unitAroundUnit > seedTargetsHit and ttd(thisUnit) > 8 then
            seedHit = 0
            seedCorruptionExist = 0
            for q = 1, #unitAroundUnit do
                local seedAoEUnit = unitAroundUnit[q]
                if ttd(seedAoEUnit) > cast.time.seedOfCorruption()+3 then seedHit = seedHit + 1 end
                if debuff.corruption.exists(seedAoEUnit) then seedCorruptionExist = seedCorruptionExist + 1 end
            end
            if seedHit > seedTargetsHit or (GetUnitIsUnit(thisUnit, "target") and seedHit >= seedTargetsHit) then
                seedTarget = thisUnit
                seedTargetsHit = seedHit
                seedTargetCorruptionExist = seedCorruptionExist
            end
        end
        if getFacing("player",thisUnit) and ttd(thisUnit) <= gcd and getHP(thisUnit) < 80 then
            dsTarget = thisUnit
        end
    end

    --- line_cd can be used to force a length of time, in seconds, to pass after executing an action before it can be executed again. In the example below, the second line can execute even while the first line is being delayed because of line_cd.
    -- @return false if spell was cast within the given period
    --Credits Raven
    local function Line_cd (spellid, seconds)
        if br.lastCast.line_cd then
            if br.lastCast.line_cd[spellid] then
                if br.lastCast.line_cd[spellid] + seconds >= GetTime() then
                    return false
                end
            end
        end
        return true
    end

   --[[local priorityTarget
    local mob_count = #enemies.yards40
    -- Set Priority Target
    if isChecked("Priority Unit") then
        for i = 1, mob_count do
            if inInstance or InRaid and GetRaidTargetIndex(enemies.yards40[i]) == getOptionValue("Priority Unit") then
                priorityTarget = enemies.yards40[i]
                break
            end
        end
    end--]]

    local function totalDots()
        local dots = 0
        if GetUnitExists("target") then 
            dots = corruptionCount + agonyCount + siphonLifeCount + debuff.phantomSingularity.count()
        end
        return dots
    end

    -- SimC specific variables
    --actions=variable,name=use_seed,value=talent.sow_the_seeds.enabled&spell_targets.seed_of_corruption_aoe>=3+raid_event.invulnerable.up|talent.siphon_life.enabled&spell_targets.seed_of_corruption>=5+raid_event.invulnerable.up|spell_targets.seed_of_corruption>=8+raid_event.invulnerable.up
    if talent.sowTheSeeds and ((not talent.siphonLife and #enemies.yards10t >= 3) or (talent.siphonLife and #enemies.yards10t >= 8) or (#enemies.yards10t >= 7)) then
        useSeed = true
    else
        useSeed = false
    end
    
    --actions+=/variable,name=padding,op=set,value=action.shadow_bolt.execute_time*azerite.cascading_calamity.enabled
    padding = cast.time.shadowBolt() * (traits.cascadingCalamity.active and 1 or 0)
    -- actions+=/variable,name=padding,op=reset,value=gcd,if=azerite.cascading_calamity.enabled&(talent.drain_soul.enabled|talent.deathbolt.enabled&cooldown.deathbolt.remains<=gcd)
    if traits.cascadingCalamity.active and (talent.drainSoul or talent.deathbolt and cd.deathbolt.remain() <= gcd) then
        padding = gcd
    end

    --actions+=/variable,name=maintain_se,value=spell_targets.seed_of_corruption_aoe<=1+talent.writhe_in_agony.enabled+talent.absolute_corruption.enabled*2+(talent.writhe_in_agony.enabled&talent.sow_the_seeds.enabled&spell_targets.seed_of_corruption_aoe>2)+(talent.siphon_life.enabled&!talent.creeping_death.enabled&!talent.drain_soul.enabled)+raid_event.invulnerable.up
    maintainSE = (talent.writheInAgony and 1 or 0) + (talent.absoluteCorruption and 1 or 0) * 2 + ((talent.writheInAgony and 1 or 0) and 
    (talent.sowTheSeeds and 1 or 0) and (#enemies.yards10t > 2 and 1 or 0))+((talent.siphonLife and 1 or 0) and (not talent.creepingDeath and 1 or 0) and (not talent.drainSoul and 1 or 0))
    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Profile Stop | Pause
    if not inCombat and not hastar and profileStop then
        profileStop = false
    elseif haltProfile then
        br.pauseTime = GetTime()
        return true
    else
        ---------------------------------
        --- Out Of Combat - Rotations ---
        ---------------------------------
        
        ------------------------------------------------
        -- PET MANAGEMENT ------------------------------
        ------------------------------------------------
        if actionList.PetManagement() then return true end

        ------------------------------------------------
        -- UTILITY -------------------------------------
        ------------------------------------------------
        if actionList.Extra() then return true end

        ------------------------------------------------
        -- DEFENSIVE -----------------------------------
        ------------------------------------------------
        if actionList.Defensive() then return true end

        ------------------------------------------------
        -- PRE-COMBAT ----------------------------------
        ------------------------------------------------
        if actionList.PreCombat() then return true end

        -----------------------------
        --- In Combat - Rotations ---
        -----------------------------
        if inCombat and not profileStop and (not cast.current.drainLife() or (cast.current.drainLife() and php > 80)) and not cast.current.drainSoul() or cast.current.drainSoul() and dsInterrupt == true then

          if getOptionValue("APL Mode") == 1 then
            ------------------------------
            --- In Combat - Interrupts ---
            ------------------------------
            if actionList.Interrupts() then return true end

                if debuff.agony.remain("target") > 5.8 and debuff.corruption.exists("target") and debuff.unstableAffliction.remain("target") > 7.2 then
            if dsTarget ~= nil and (not cast.current.drainSoul() or (cast.current.drainSoul() and dsInterrupt)) and not moving and shards < 5 and not debuff.vileTaint.exists("target") and shards > 0 or debuff.vileTaint.exists("target") and debuff.vileTaint.remain("target") < 1.5 then
            if cast.drainSoul(dsTarget) then
                dsInterrupt = false
                return true
            end
        end
    end

         --[[  if opener == false and ui.checked("Opener") and isBoss("target") or getTTD("target") >= 20 or isDummy() then
                if actionList_Opener() then return true end
            end--]]

            -- Shadowfury
            --[[if isChecked("Shadowfury Key") 
            and SpecificToggle("Shadowfury Key") and not GetCurrentKeyBoardFocus() then
                if br.timer:useTimer("RoF Delay", 1) and cast.shadowFury(nil,"aoe",1,8,true) then br.addonDebug("Casting Shadow Fury") return end 
            end--]]
            -----------------
            ---  AMR APL  ---
            -----------------
            --Potion
             -- actions.cooldowns+=/potion,if=(talent.dark_soul_misery.enabled&cooldown.summon_darkglare.up&cooldown.dark_soul.up)|cooldown.summon_darkglare.up|target.time_to_die<30
             if ui.checked("Potion") and useCDs() and pet.darkglare.active() then
                if not buff.potionOfUnbridledFury.exists() and canUseItem(item.potionOfUnbridledFury) then
                    if use.potionOfUnbridledFury() then br.addonDebug("Using Potion of Unbridled Fury [Pre-Pull]") return end
                end
            end

            -- Racial
            if ui.checked("Racial") and useCDs() and pet.darkglare.active() and (race == "Troll" or race == "Orc" or race == "DarkIronDwarf") then
                if cast.racial() then br.addonDebug("Casting Berserking") return true end
            end

            -- Trinkets
            if ui.checked("Trinkets") and useCDs() and pet.darkglare.active() then
                local mainHand = GetInventorySlotInfo("MAINHANDSLOT")
                if canUseItem(mainHand) and equiped.neuralSynapseEnhancer(mainHand) then
                    use.slot(mainHand)
                    br.addonDebug("Using Neural Synapse Enhancer")
                end
                for i = 13, 14 do
                    if use.able.slot(i) and not (equiped.azsharasFontOfPower(i) or equiped.pocketSizedComputationDevice(i)
                        or equiped.rotcrustedVoodooDoll(i) or equiped.shiverVenomRelic(i) or equiped.aquipotentNautilus(i)
                        or equiped.tidestormCodex(i) or equiped.vialOfStorms(i) or equiped.hummingBlackDragonscale(i)) 
                    then
                        if use.slot(i) then br.addonDebug("Using Trinket in slot "..i.." [CD]") return true end
                    end
                end
            end

            -- Death bolt
            if talent.deathbolt and cast.last.summonDarkglare(3) then
                if cast.deathbolt() then br.addonDebug("Casting Deathbolt") return true end
            end

            -- Dark Soul
            if talent.darkSoul and useCDs() or isChecked("Cooldowns Hotkey") and SpecificToggle("Cooldowns Hotkey") and not moving and pet.darkglare.active() then
                if cast.darkSoul() then br.addonDebug("Casting Dark Soul") return true end
            end 

            -- Guardian of Azeroth
            if ui.checked("Use Essence") and useCDs() or isBoss("target") and essence.guardianOfAzeroth.active and cd.guardianOfAzeroth.remain() <= gcdMax and pet.darkglare.active() then
                if cast.guardianOfAzeroth() then br.addonDebug("Casting Guardian of Azeroth") return true end
            end

            -- Haunt
            if not moving and talent.haunt and not debuff.haunt.exists("target") and getTTD("target") >= ui.value("Haunt TTD") then
                if cast.haunt("target") then br.addonDebug("Casting Haunt") return true end
            end

            -- Blood of the Enemy
            if ui.checked("Use Essence") and useCDs() and (buff.darkSoul.exists() or pet.darkglare.active() or cd.summonDarkglare.remain() >= 80 ) then
                if cast.bloodOfTheEnemy() then br.addonDebug("Casting Blood of the Enemy") return true end
            end

            -- Blood of the Enemy
            if ui.checked("Blood oF The Enemy") and useCDs() or isChecked("Cooldowns Hotkey") and SpecificToggle("Cooldowns Hotkey") and (buff.darkSoul.exists() or pet.darkglare.active() or cd.summonDarkglare.remain() >= 80 ) then
                if cast.bloodOfTheEnemy() then br.addonDebug("Casting Blood of the Enemy") return true end
            end

            -- The Unbound Force
            if ui.checked("Use Essence") and essence.theUnboundForce.active and cd.theUnboundForce.remain() <= gcdMax and (cd.summonDarkglare.remain > gcdMax or not useCDs())
                and buff.recklessForce.exists() 
            then
                if cast.theUnboundForce() then br.addonDebug("Casting The Unbound Force") return true end
            end

            -- Summon Darkglare
            if GetSpellCooldown(205180) == 0 and isKnown(205180) and useCDs()
            and cd.summonDarkglare.remain() <= gcdMax 
            and ((ui.checked("Darkglare Dots") and totalDots() >= ui.value("Darkglare Dots")) or (not ui.checked("Darkglare Dots"))) 
            then    
                -- If we have auto selected, check if we're in an instance or raid. Or we have Max-Dots selected. 
                if (ui.checked("Darkglare") and getOptionValue("Darkglare") == 1 and inInstance or inRaid) 
                or (ui.checked("Darkglare") and getOptionValue("Darkglare") == 2)
                and (debuff.unstableAffliction.exists("target")
                and (debuff.agony.remain("target") >= 15 
                and ((debuff.siphonLife.remain("target") > 10 or not talent.siphonLife)) 
                and (debuff.corruption.remain("target") > 10 or talent.absoluteCorruption and debuff.corruption.exists("target"))))
                then
                    CastSpellByName(GetSpellInfo(spell.summonDarkglare))
                    br.addonDebug("Casting Darkglare (Maximum Dots)")
                end

                -- If we have On CD selected or we're not in a raid/instance. 
                if ui.checked("Darkglare") and getOptionValue("Darkglare") == 3 
                or ui.checked("Darkglare") and getOptionValue("Darkglare") == 1 and not inInstance and not inRaid
                and isKnown(205180) and GetSpellCooldown(205180) == 0 and (shards == 0) 
                then
                    CastSpellByName(GetSpellInfo(spell.summonDarkglare))
                    br.addonDebug("Casting Darkglare (Maximum Dots)")
                end
                --if cast.summonDarkglare() then return true end
                return true
            end
            end

            -- Shadowfury
            if isChecked("Shadowfury Key") 
            and SpecificToggle("Shadowfury Key") and not GetCurrentKeyBoardFocus() then
                if CastSpellByName(GetSpellInfo(spell.shadowfury),"cursor") then br.addonDebug("Casting Shadow Fury") return end 
            end
            -----------------
            ---  AMR APL  ---
            -----------------
            --Potion
             -- actions.cooldowns+=/potion,if=(talent.dark_soul_misery.enabled&cooldown.summon_darkglare.up&cooldown.dark_soul.up)|cooldown.summon_darkglare.up|target.time_to_die<30
            if ui.checked("Potion") and useCDs() or isChecked("Cooldowns Hotkey") and SpecificToggle("Cooldowns Hotkey") and pet.darkglare.active() then
                if not buff.potionOfUnbridledFury.exists() and canUseItem(item.potionOfUnbridledFury) then
                    if use.potionOfUnbridledFury() then br.addonDebug("Using Potion of Unbridled Fury [Pre-Pull]") return end
                end
            end

            -- Racial
            if ui.checked("Racial") and useCDs() and pet.darkglare.active() and (race == "Troll" or race == "Orc" or race == "DarkIronDwarf") then
                if cast.racial() then br.addonDebug("Casting Berserking") return true end
            end

            -- Trinkets
            if ui.checked("Trinkets") and useCDs() and pet.darkglare.active() then
                local mainHand = GetInventorySlotInfo("MAINHANDSLOT")
                if canUseItem(mainHand) and equiped.neuralSynapseEnhancer(mainHand) then
                    use.slot(mainHand)
                    br.addonDebug("Using Neural Synapse Enhancer")
                end
                for i = 13, 14 do
                    if use.able.slot(i) and not (equiped.azsharasFontOfPower(i) or equiped.pocketSizedComputationDevice(i)
                        or equiped.rotcrustedVoodooDoll(i) or equiped.shiverVenomRelic(i) or equiped.aquipotentNautilus(i)
                        or equiped.tidestormCodex(i) or equiped.vialOfStorms(i) or equiped.hummingBlackDragonscale(i)) 
                    then
                        if use.slot(i) then br.addonDebug("Using Trinket in slot "..i.." [CD]") return true end
                    end
                end
            end

            -- Death bolt
            if talent.deathbolt and cast.last.summonDarkglare(3) then
                if cast.deathbolt() then br.addonDebug("Casting Deathbolt") return true end
            end

            -- Dark Soul
            if talent.darkSoul and useCDs() and not moving and pet.darkglare.active() then
                if cast.darkSoul() then br.addonDebug("Casting Dark Soul") return true end
            end 

            -- Guardian of Azeroth
            if ui.checked("Use Essence") and useCDs() and essence.guardianOfAzeroth.active and cd.guardianOfAzeroth.remain() <= gcdMax and pet.darkglare.active() then
                if cast.guardianOfAzeroth() then br.addonDebug("Casting Guardian of Azeroth") return true end
            end

            -- Blood of the Enemy
            if ui.checked("Use Essence") and useCDs() and (buff.darkSoul.exists() or pet.darkglare.active() or cd.summonDarkglare.remain() >= 80 ) then
                if cast.bloodOfTheEnemy() then br.addonDebug("Casting Blood of the Enemy") return true end
            end

            -- The Unbound Force
            if ui.checked("Use Essence") and essence.theUnboundForce.active and cd.theUnboundForce.remain() <= gcdMax and (cd.summonDarkglare.remain > gcdMax or not useCDs())
                and buff.recklessForce.exists() 
            then
                if cast.theUnboundForce() then br.addonDebug("Casting The Unbound Force") return true end
            end

            -- Unstable Affliction
            unstableAfflictionFUCK()
            if ui.checked("Mousever UA") 
            and UnitExists("mouseover")
            and not UnitIsDeadOrGhost("mouseover")
            then 
                unstableAfflictionFUCK("mouseover")
            end
            

            -- Agony
            if agonyCount < ui.value("Spread Agony on ST") then
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if not noDotCheck(thisUnit) and debuff.agony.remain(thisUnit) <= 6 and getTTD(thisUnit) > debuff.agony.remain(thisUnit) + (2/spellHaste) then
                        if cast.agony(thisUnit) then br.addonDebug("Casting Agony [Refresh]") return true end
                    end
                end
            end
                
            -- Corruption
            if not talent.absoluteCorruption then
                if corruptionCount < 2 then
                    for i = 1, #enemies.yards40 do
                        local thisUnit = enemies.yards40[i]
                        if not noDotCheck(thisUnit) and debuff.corruption.remain(thisUnit) <= 4.2 and getTTD(thisUnit) > debuff.corruption.remain(thisUnit) + (2/spellHaste) then
                            if cast.corruption(thisUnit) then br.addonDebug("Casting Corruption [Pandemic Invocation]") return true end
                        end
                    end
                end
            elseif not talent.absoluteCorruption then
                if corruptionCount < 2 then
                    for i = 1, #enemies.yards40 do
                        local thisUnit = enemies.yards40[i]
                        if not noDotCheck(thisUnit) and  debuff.corruption.refresh(thisUnit) <= 4.2 and getTTD(thisUnit) > debuff.corruption.remain(thisUnit) + (2/spellHaste) then
                            if cast.corruption(thisUnit) then br.addonDebug("Casting Corruption [Refresh]") return true end
                        end
                    end
                end
            elseif talent.absoluteCorruption then
                if corruptionCount < 2 then
                    for i = 1, #enemies.yards40 do
                        local thisUnit = enemies.yards40[i]
                        if not noDotCheck(thisUnit) and  not debuff.corruption.exists(thisUnit) and not debuff.seedOfCorruption.exists(thisUnit) then
                            if cast.corruption(thisUnit) then br.addonDebug("Casting Corruption [Absolute Corruption]") return true end
                        end
                    end
                end
            end

            -- Siphon Life
            if talent.siphonLife then
                if siphonLifeCount < 2 then
                    for i = 1, #enemies.yards40 do
                        local thisUnit = enemies.yards40[i]
                        if not noDotCheck(thisUnit) and  debuff.siphonLife.remain(thisUnit) <= 4.5 and getTTD(thisUnit) > debuff.siphonLife.remain(thisUnit) + (3/spellHaste) then
                            if cast.siphonLife(thisUnit) then br.addonDebug("Casting Siphon Life [Refresh]") return true end
                        end
                    end
                end
            end
            
            -- Haunt
            if not moving
            and talent.haunt 
            and not debuff.haunt.exists("target") 
            and getTTD("target") >= ui.value("Haunt TTD")
            and (debuff.unstableAffliction.exists("target")
            and debuff.agony.exists("target")and debuff.corruption.exists("target")
            and getTTD("target") > gcdMax + cast.time.vileTaint()
            and ((debuff.siphonLife.exists("target") or not talent.siphonLife)) 
            and (debuff.corruption.exists("target")  or talent.absoluteCorruption and debuff.corruption.exists("target")))
            then
                if cast.haunt("target") then br.addonDebug("Casting Haunt") return true end
            end
    
            -- Multi Target
            if #enemies.yards10t >= ui.value("Multi-Target Units") and mode.single ~= 1 then 
                if actionList.multi() then return true end 
            end

            -- Deathbolt
            if talent.deathbolt and cd.summonDarkglare.remain() > 30 then
                if cast.deathbolt() then br.addonDebug("Casting Deathbolt") return true end
            end

            -- Worldvein Resonance
            if ui.checked("Use Essence") and essence.worldveinResonance.active and cd.worldveinResonance.remain() <= gcdMax and  (cd.summonDarkglare.remain() > 30 or not useCDs()) then
                if cast.worldveinResonance() then br.addonDebug("Casting Worldvein Resonance") return true end
            end

            -- Phantom Singularity
            if talent.phantomSingularity and not moving and shards > 0 then
                if cast.phantomSingularity() then br.addonDebug("Casting Phantom Singularity") return true end
            end

            -- Vile Taint
            if not moving and talent.vileTaint and shards > 1
            and (debuff.unstableAffliction.remain("target") > gcdMax + 7.5
            and debuff.agony.remain("target") > gcdMax + 3 and debuff.corruption.remain("target") > gcdMax + 3
            and getTTD("target") > gcdMax + cast.time.vileTaint() + 3
            and ((debuff.siphonLife.remain("target") > gcdMax + 3 or not talent.siphonLife)) 
            and (debuff.corruption.remain("target") > gcdMax + 3  or talent.absoluteCorruption and debuff.corruption.exists("target")))
            then
                if cast.vileTaint(nil,"aoe",1,8,true) then br.addonDebug("Casting Vile Taint") return true end
            end

            -- Malefic Rapture
            if not moving and getDistance("target") <= 40
            and (debuff.agony.exists("target") 
            --and getTTD("target") >= gcdMax + cast.time.maleficRapture()
            and ((debuff.unstableAffliction.exists("target") and debuff.siphonLife.exists("target") or not talent.siphonLife)) 
            and (debuff.corruption.exists("target") or talent.absoluteCorruption and debuff.corruption.exists("target"))) 
            then
                -- Vile Taint not talented
                --if not talent.vileTaint or debuff.vileTaint.remains("target") > gcdMax then if cast.maleficRapture() then br.addonDebug("Casting Malefic Rapture (Vile Taint) 1") return true end end

                -- Malefic Rapture Vile Taint
                if talent.vileTaint and debuff.vileTaint.remains("target") >= gcdMax + cast.time.vileTaint() or cd.vileTaint.remain() > 12 
                then
                    if cast.maleficRapture() then br.addonDebug("Casting Malefic Rapture (Vile Taint) 1") return true end 
                end
               
                -- Phantom Singularity
                -- actions+=/malefic_rapture,if=talent.phantom_singularity.enabled&(dot.phantom_singularity.ticking||cooldown.phantom_singularity.remains>12||soul_shard>3)
                if talent.phantomSingularity and debuff.phantomSingularity.remains("target") >= gcdMax + cast.time.phantomSingularity()
                or (cd.phantomSingularity.remain() > 12) 
                then
                    if cast.maleficRapture() then br.addonDebug("Casting Malefic Rapture (Phantom Singularity)") return true end 
                end

                if ui.checked("Malefic Rapture BloodLust") 
                and hasBloodLust() 
                and shards > 0
                then
                    if cast.maleficRapture() then br.addonDebug("Casting Malefic Rapture (BloodLust)") return true end 
                end

                -- Capped on shards.
                if shards > 4 then if cast.maleficRapture() then br.addonDebug("Casting Malefic Rapture (Full Shards)") return true end end 

                if ui.checked("Malefic Rapture TTD") and useCDs() and inInstance or inRaid and ttd("target") <= ui.checked("Malefic Rapture TTD") and shards > 1 then if cast.maleficRapture() then br.addonDebug("Casting Malefic Rapture (Burn Phase)") return true end end
            end
            

            -- Focused Azerite Beam
            if cd.summonDarkglare.remains() > 10 and ui.checked("Use Essence") and essence.focusedAzeriteBeam.active and cd.focusedAzeriteBeam.remain() <= gcdMax
            and ((essence.focusedAzeriteBeam.rank < 3 and not moving) or essence.focusedAzeriteBeam.rank >= 3) and (getEnemiesInRect(2,25,isChecked("Show Drawings"),false) >= getOptionValue("Azerite Beam Units") or (isBoss("target") and getDistance("player","target") <= 20 and getFacing("player","target", 5))) 
            then
                if cast.focusedAzeriteBeam() then
                    br.addonDebug("Casting Focused Azerite Beam")
                    return 
                end
            end

            -- Purifying Blast
            if ui.checked("Use Essence") and essence.purifyingBlast.active and cd.purifyingBlast.remain() <= gcdMax and (#enemies.yards10t >= 2 or useCDs()) then
                local minCount = useCDs() and 1 or 3
                if cast.purifyingBlast("best", nil, minCount, 40) then br.addonDebug("Casting Purifying Blast") return true end
            end

            -- Reaping Flame
            if ui.checked("Use Essence") and essence.reapingFlames.active and cd.reapingFlames.remain() <= gcdMax then
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    local thisHP = getHP(thisUnit)
                    if ((essence.reapingFlames.rank >= 2 and thisHP > 80) or thisHP <= 20 or getTTD(thisUnit,20) > 30) then
                        if cast.reapingFlames(thisUnit) then br.addonDebug("Casting Reaping Flames") return true end
                    end
                end
            end

            -- Concentrated Flame Damage
            if isChecked("Use Essence") and essence.concentratedFlame.active and php >= getOptionValue("Concentrated Flame") and cd.concentratedFlame.remain() <= gcdMax then
                if cast.concentratedFlame("target") then br.addonDebug("Casting Concentrated Flame Damage") return true end
            end
            
            -- Drain Life
            if not moving and buff.inevitableDemise.stack() >= 45 and br.timer:useTimer("ID Delay", 5) then
                if cast.drainLife() then br.addonDebug("Casting Drain Life") return true end
            end

            -- Azshard's Font of Power/Cyclotronic Blast
            if useCDs() and not moving then
                for i = 13, 14 do
                    if use.able.slot(i) and (equiped.azsharasFontOfPower(i) or equiped.pocketSizedComputationDevice(i)) then
                        if use.slot(i) then br.addonDebug("Using Trinket in slot "..i.." [CD]") end
                    end
                end
            end

            -- Ripple in Space
            if ui.checked("Use Essence") and essence.rippleInSpace.active and cd.rippleInSpace.remain() <= gcdMax then
                if cast.rippleInSpace() then br.addonDebug("Casting Ripple In Space") return true end
            end

            -- Memory of Lucid Dreams
            if ui.checked("Use Essence") and useCDs() and essence.memoryOfLucidDreams.active and cd.memoryOfLucidDreams.remain() <= gcdMax and shards < 4 then
                if cast.memoryOfLucidDreams() then br.addonDebug("Casting Memory of Lucid Dreams") return true end
            end

            -- Malefic Rapture
            if not moving and level >= 45 then
                -- Vile Taint not talented
                if not talent.vileTaint or debuff.vileTaint.remains("target") > gcdMax + cast.time.maleficRapture() then if cast.maleficRapture() then br.addonDebug("Casting Malefic Rapture (Vile Taint) 2") return true end end
            end

            --if not smartCancel() and br.dsTicks <= ui.value("Drain Soul Smart Cancel") or br.dsTicks >= 5 then if cast.drainSoul() then br.addonDebug("Clipped Drain Soul 2") return true end end

            -- Drain Soul
            --[[if shards < 5 and getTTD("target") <= gcdMax and cd.vileTaint.remain() > gcdMax + 13 then  
            if not moving and talent.drainSoul and cast.timeSinceLast.drainSoul() > gcdMax + 4
            and (debuff.unstableAffliction.remain("target") > gcdMax + 8 and debuff.agony.remain("target") > gcdMax + 6
            and ((debuff.siphonLife.remain("target") > gcdMax + 3 or not talent.siphonLife)) 
            and (debuff.corruption.remain("target") < gcdMax + 3 or talent.absoluteCorruption and debuff.corruption.exists("target")))
            then
                if cast.drainSoul() then br.addonDebug("Casting Drain Soul") return true end
            end
        end--]]
            if actionList.Fillers() then return true end 

            -- Shadow Bolt
            if not moving and not talent.drainSoul 
            and not debuff.vileTaint.exists("target") and (debuff.unstableAffliction.exists("target") and debuff.agony.exists("target")
            and ((debuff.siphonLife.exists("target") or not talent.siphonLife)) 
            and (debuff.corruption.exists("target") or talent.absoluteCorruption and debuff.corruption.exists("target"))) 
            then
                if cast.shadowBolt2() then br.addonDebug("Casting Shadow Bolt") return true end
            end

            -- Agony
            if moving then
                if agonyCount < ui.value("Agony Count") then
                    for i = 1, #enemies.yards40 do
                        local thisUnit = enemies.yards40[i]
                        local agonyRemain = debuff.agony.remain(thisUnit)
                        if not noDotCheck(thisUnit) and ttd(thisUnit) > 10 then
                            if cast.agony(thisUnit) then br.addonDebug("Casting Agony") return true end
                        end
                    end
                end
            end
        else
            if actionList.Leveling() then return true end 
        end
    end -- Pause
    return true
end -- End runRotation


function smartCancel()
	-- Drain Soul Failsafe
    if ui.checked("Drain Soul Smart Cancel") then
			if UnitChannelInfo("player") == GetSpellInfo(spell.drainSoul) and  br.dsTicks <  br.maxdsTicks - 1 then return false end
		else
			if UnitChannelInfo("player") == GetSpellInfo(spell.drainSoul) and  br.dsTicks <= ui.value("Drain Soul Smart Cancel") then return false end
		end
	return true
end

local id = 265 -- Change to the spec id profile is for.
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
