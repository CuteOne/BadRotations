local rotationName = "Aura" -- Change to name of profile listed in options drop down

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
		section = br.ui:createSection(br.ui.window.profile,  "General - Version 1.06")
            -- Dummy DPS Test
            br.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
            -- Pig Catcher
            br.ui:createCheckbox(section, "Pig Catcher")
            -- Auto Engage
            br.ui:createCheckbox(section,"Auto Engage")
            -- Pet Management
            br.ui:createCheckbox(section, "Pet Management", "|cffFFFFFF Select to enable/disable auto pet management")
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
        --- OFFENSIVE OPTIONS ---
        -------------------------
		section = br.ui:createSection(br.ui.window.profile,  "Offensive")
			-- Agi Pot
            br.ui:createCheckbox(section, "Potion", "Use Potion")
            -- Augment
            br.ui:createCheckbox(section, "Augment", "Use Augment")
            -- Racial
			br.ui:createCheckbox(section, "Racial", "Use Racial")
			-- Trinkets
            br.ui:createCheckbox(section, "Trinkets", "Use Trinkets")
            br.ui:createSpinner(section, "Darkglare Dots", 3, 0, 4, 1, "Total number of dots needed on target to cast Darkglare (excluding UA). Standard is 3. Uncheck for auto use.")
			-- Spread agony on single target
            br.ui:createSpinner(section, "Spread Agony on ST", 3, 1, 15, 1, "Check to spread Agony when running in single target", "The amount of additionally running Agony. Standard is 3")
            -- Max Dots
			br.ui:createSpinner(section, "Agony Count", 8, 1, 15, 1, nil, "The maximum amount of running Agony. Standard is 8", true)
			br.ui:createSpinner(section, "Corruption Count", 8, 1, 15, 1, nil, "The maximum amount of running Corruption. Standard is 8", true)
			br.ui:createSpinner(section, "Siphon Life Count", 8, 1, 15, 1, nil, "The maximum amount of running Siphon Life. Standard is 8", true)
			-- No Dot units
			br.ui:createCheckbox(section, "Dot Blacklist", "Ignore certain units for dots")
			-- UA Shards
			--br.ui:createSpinner(section, "UA Shards", 5, 1, 5, 1, nil, "Use UA on Shards", true)
        br.ui:checkSectionState(section)
		-------------------------
		--- DEFENSIVE OPTIONS ---
		-------------------------
		section = br.ui:createSection(br.ui.window.profile, "Defensive")
            -- Soulstone
		    br.ui:createDropdown(section, "Soulstone", {"|cffFFFFFFTarget","|cffFFFFFFMouseover",	"|cffFFFFFFTank", "|cffFFFFFFHealer", "|cffFFFFFFHealer/Tank", "|cffFFFFFFAny"},
			1, "|cffFFFFFFTarget to cast on")
            -- Healthstone
            br.ui:createSpinner(section, "Pot/Stoned",  60,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Heirloom Neck
            br.ui:createSpinner(section, "Heirloom Neck",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
            -- Gift of The Naaru
            if br.player.race == "Draenei" then
                br.ui:createSpinner(section, "Gift of the Naaru",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            end
            -- Dark Pact
            br.ui:createSpinner(section, "Dark Pact", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
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
        -- Interrupt Options
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
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
local option
local pet
local php
local pullTimer
local shards
local spell
local talent
local tanks
local traits
local units
local use
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
--     if option.checked(OptionName) then
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
    if option.checked("Dot Blacklist") and (noDotUnits[GetObjectID(unit)] or UnitIsCharmed(unit)) then return true end
    if isTotem(unit) then return true end
    unitCreator = UnitCreator(unit)
    if unitCreator ~= nil and UnitIsPlayer(unitCreator) ~= nil and UnitIsPlayer(unitCreator) == true then return true end
    --if GetObjectID(unit) == 137119 and getBuffRemain(unit, 271965) > 0 then return true end
    return false
end
--------------------
--- Action Lists --- -- All Action List functions from SimC (or other rotation logic) here, some common ones provided
--------------------
-- Action List - Extra
actionList.Extra = function()
    -- Dummy Test
    if option.checked("DPS Testing") then
        if GetObjectExists("target") then
            if getCombatTime() >= (tonumber(option.value("DPS Testing"))*60) and isDummy() then
                StopAttack()
                ClearTarget()
                if option.checked("Pet Management") then
                    PetStopAttack()
                    PetFollow()
                end
                Print(tonumber(option.value("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
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
        if option.checked("Pot/Stoned") and inCombat and (use.able.healthstone() or canUseItem(healPot))
            and (hasHealthPot() or has.healthstone()) and php <= option.value("Pot/Stoned")
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
            if
                getOptionValue("Soulstone") == 1 and -- Target
                    UnitIsPlayer("target") and
                    UnitIsDeadOrGhost("target") and
                    GetUnitIsFriend("target", "player")
                then
                if cast.soulstone("target", "dead") then
                    br.addonDebug("Casting Soulstone")
                    return true
                end
            end
            if
                getOptionValue("Soulstone") == 2 and -- Mouseover
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
        -- Heirloom Neck
        if option.checked("Heirloom Neck") and php <= option.value("Heirloom Neck") then
            if use.able.heirloomNeck() and item.heirloomNeck ~= 0
                and item.heirloomNeck ~= item.manariTrainingAmulet
            then
                if use.heirloomNeck() then br.addonDebug("Using Heirloom Neck") return true end
            end
        end
        -- Gift of the Naaru
        if option.checked("Gift of the Naaru") and php <= option.value("Gift of the Naaru")
            and php > 0 and race == "Draenei"
        then
            if cast.racial() then br.addonDebug("Casting Racial: Gift of the Naaru") return true end
        end
        -- Dark Pact
        if option.checked("Dark Pact") and php <= option.value("Dark Pact") then
            if cast.darkPact() then br.addonDebug("Casting Dark Pact") return true end
        end
        -- Drain Life
        if option.checked("Drain Life") and php <= option.value("Drain Life") and isValidTarget("target") and not isCastingSpell(spell.drainLife) then
            if cast.drainLife() then br.addonDebug("Casting Drain Life") return true end
        end
        -- Health Funnel
        if not moving and option.checked("Health Funnel (Demon)") and getHP("pet") <= option.value("Health Funnel (Demon)") and getHP("player") >= option.value("Health Funnel (Player)") and GetObjectExists("pet") and not UnitIsDeadOrGhost("pet") then
            if cast.healthFunnel() then br.addonDebug("Casting Health Funnel") return true end
        end
        -- Unending Resolve
        if option.checked("Unending Resolve") and php <= option.value("Unending Resolve") and inCombat then
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
            if canInterrupt(thisUnit,option.value("Interrupt At")) then
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
    if useCDs() then
        --actions.cooldowns=worldvein_resonance
        if option.checked("Use Essence") and essence.worldveinResonance.active and cd.worldveinResonance.remain() <= gcdMax and buff.lifeblood.stack() < 3 then
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
        if option.checked("Potion") and (talent.darkSoul and cd.summonDarkglare.remain <= gcdMax and cd.darkSoul.remain() <= gcdMax) or (cd.summonDarkglare.remain() <= gcdMax and not talent.darkSoul) or getTTD("target") < 30 then
            if not buff.potionOfUnbridledFury.exists() and canUseItem(item.potionOfUnbridledFury) then
                if use.potionOfUnbridledFury() then br.addonDebug("Using Potion of Unbridled Fury") return end
            end
        end
        -- actions.cooldowns+=/use_items,if=cooldown.summon_darkglare.remains>70|time_to_die<20|((buff.active_uas.stack=5|soul_shard=0)&(!talent.phantom_singularity.enabled|cooldown.phantom_singularity.remains)&(!talent.deathbolt.enabled|cooldown.deathbolt.remains<=gcd|!cooldown.deathbolt.remains)&!cooldown.summon_darkglare.remains)
        if option.checked("Trinkets") and cd.summonDarkglare.remain() > 70 or getTTD("target") < 20 or ((debuff.unstableAffliction.stack() == 5 or shards == 0) and 
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
        if option.checked("Racial") and cd.summonDarkglare > gcdMax and (race == "Troll" or race == "Orc" or race == "DarkIronDwarf")
        then
            if cast.racial() then br.addonDebug("Casting Berserking") return true end
        end
        -- actions.cooldowns+=/memory_of_lucid_dreams,if=time>30
        if option.checked("Use Essence") and combatTime > 30 and essence.memoryOfLucidDreams.active and cd.memoryOfLucidDreams.remain() <= gcdMax then
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
        if option.checked("Use Essence") and (buff.darkSoul.exists() or pet.darkglare.active() or (cd.deathbolt.remain() < gcdMax or not talent.deathbolt) and cd.summonDarkglare.remain() >= 80 and essence.bloodOfTheEnemy.rank > 1) then
            if cast.bloodOfTheEnemy() then br.addonDebug("Casting Blood of the Enemy") return true end
        end
        --# Use damaging on-use trinkets more or less on cooldown, so long as the ICD they incur won't effect any other trinkets usage during cooldowns.
        --actions.cooldowns+=/use_item,name=pocketsized_computation_device,if=(cooldown.summon_darkglare.remains>=25|target.time_to_die<=30)&(cooldown.deathbolt.remains|!talent.deathbolt.enabled)
        --actions.cooldowns+=/use_item,name=rotcrusted_voodoo_doll,if=(cooldown.summon_darkglare.remains>=25|target.time_to_die<=30)&(cooldown.deathbolt.remains|!talent.deathbolt.enabled)
        --actions.cooldowns+=/use_item,name=shiver_venom_relic,if=(cooldown.summon_darkglare.remains>=25|target.time_to_die<=30)&(cooldown.deathbolt.remains|!talent.deathbolt.enabled)
        --actions.cooldowns+=/use_item,name=aquipotent_nautilus,if=(cooldown.summon_darkglare.remains>=25|target.time_to_die<=30)&(cooldown.deathbolt.remains|!talent.deathbolt.enabled)
        --actions.cooldowns+=/use_item,name=tidestorm_codex,if=(cooldown.summon_darkglare.remains>=25|target.time_to_die<=30)&(cooldown.deathbolt.remains|!talent.deathbolt.enabled)
        --actions.cooldowns+=/use_item,name=vial_of_storms,if=(cooldown.summon_darkglare.remains>=25|target.time_to_die<=30)&(cooldown.deathbolt.remains|!talent.deathbolt.enabled)
        if option.checked("Trinkets") and (cd.summonDarkglare.remain() >= 25 or getTTD("target") <= 30) and (cd.deathbolt.remain() <= gcdMax or not talent.deathbolt) then
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
        if option.checked("Use Essence") and essence.rippleInSpace.active and cd.rippleInSpace.remain() <= gcdMax then
            if cast.rippleInSpace() then br.addonDebug("Casting Ripple In Space") return true end
        end
    end
end -- End Action List - Cooldowns

-- Action List - Pre-Combat
actionList.PreCombat = function()
    if not inCombat and not (IsFlying() or IsMounted()) then
        --actions.precombat+=/summon_pet
        if option.checked("Pet Management") and not moving and level >= 5 and GetTime() - br.pauseTime > 0.5 and br.timer:useTimer("summonPet", 1) 
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
        if option.checked("Pre-Pull Timer") then
            -- Flask / Crystal
            if ((pullTimer <= getValue("Pre-Pull Timer") and pullTimer > 4 and (not equiped.azsharasFontOfPower or not canUseItem(item.azsharasFontOfPower))) or (equiped.azsharasFontOfPower and canUseItem(item.azsharasFontOfPower) and pullTimer <= 20 and pullTimer > 8)) then
                --actions.precombat=flask
                if getOptionValue("Elixir") == 1 and inRaid and not buff.greaterFlaskOfEndlessFathoms.exists() and canUseItem(item.greaterFlaskOfEndlessFathoms) then
                    if use.greaterFlaskOfEndlessFathoms() then br.addonDebug("Using Greater Flask of Endless Fathoms [Pre-Pull]") return end
                elseif getOptionValue("Elixir") == 2 and inRaid and not buff.flaskOfEndlessFathoms.exists() and canUseItem(item.flaskOfEndlessFathoms) then
                    if use.flaskOfEndlessFathoms() then br.addonDebug("Using Flask of Endless Fathoms [Pre-Pull]") return end
                end
                -- actions.precombat+=/augmentation
                if option.checked("Augment") and not buff.battleScarredAugmentRune.exists() and canUseItem(item.battleScarredAugmentRune) then
                    if use.battleScarredAugmentRune() then br.addonDebug("Using Battle-Scarred Augment Rune [Pre-Pull]") return end
                end
                if talent.grimoireOfSacrifice then
                    if cast.grimoireOfSacrifice() then br.addonDebug("Cast Grimoire Of Sacrifice [Pre-Pull]") return true end
                end
                -- actions.precombat+=/potion
                if option.checked("Potion") and not buff.potionOfUnbridledFury.exists() and canUseItem(item.potionOfUnbridledFury) then
                    if use.potionOfUnbridledFury() then br.addonDebug("Using Potion of Unbridled Fury [Pre-Pull]") return end
                end
                -- actions.precombat+=/use_item,name=azsharas_font_of_power
            elseif equiped.azsharasFontOfPower and canUseItem(item.azsharasFontOfPower) and pullTimer <= 8 and pullTimer > 4 then
                if br.timer:useTimer("Font Delay", 4) then
                    br.addonDebug("Using Font Of Azshara [Pre-Pull]")
                    useItem(169314)
                end
                -- actions.precombat+=/seed_of_corruption,if=spell_targets.seed_of_corruption_aoe>=3&!equipped.169314
            elseif not moving and pullTimer <= 3 and br.timer:useTimer("SoC Delay", 3) and #enemies.yards10t >= 2 then
                CastSpellByName(GetSpellInfo(spell.seedOfCorruption)) br.addonDebug("Casting Seed of Corruption [Pre-Pull]") return
            elseif pullTimer <= 2 and br.timer:useTimer("Haunt Delay", 2) and GetUnitExists("target") then
                if talent.haunt then    
                    CastSpellByName(GetSpellInfo(spell.haunt)) br.addonDebug("Casting Haunt [Pre-Pull]") return
                else
                    CastSpellByName(GetSpellInfo(spell.shadowBolt)) br.addonDebug("Casting Shadowbolt [Pre-Pull]") return
                end
            end
        end -- End Pre-Pull 
        if option.checked("Auto Engage") and not inCombat and isValidUnit("target") and getDistance("target") < 40 and getFacing("player","target") and br.timer:useTimer("Agony Delay", 2) then
            if cast.agony() then br.addonDebug("Casting Agony [Auto Engage]") return true end
        end
    end      
end -- End Action List - PreCombat

-- actionList.dbRefresh = function ()
--     -- actions.db_refresh=siphon_life,line_cd=15,if=(dot.siphon_life.remains%dot.siphon_life.duration)<=(dot.agony.remains%dot.agony.duration)&(dot.siphon_life.remains%dot.siphon_life.duration)<=(dot.corruption.remains%dot.corruption.duration)&dot.siphon_life.remains<dot.siphon_life.duration*1.3
--     if Line_cd(spell.siphonLife,15) and not noDotCheck("target") then
--         if (debuff.siphonLife.remain() / 15) <= (debuff.agony.remain() / 18) and (debuff.siphonLife.remain() / 15) <= (debuff.corruption.remain() / 14) and debuff.siphonLife.remain() < 19.5 then
--             if cast.siphonLife() then return true end
--         end
--     end
--     -- actions.db_refresh+=/agony,line_cd=15,if=(dot.agony.remains%dot.agony.duration)<=(dot.corruption.remains%dot.corruption.duration)&(dot.agony.remains%dot.agony.duration)<=(dot.siphon_life.remains%dot.siphon_life.duration)&dot.agony.remains<dot.agony.duration*1.3
--     if Line_cd(spell.agony, 15) and not noDotCheck("target") then
--         if (debuff.agony.remain() / 18) <= (debuff.corruption.remain() / 14) and (debuff.agony.remain() / 18) <= (debuff.siphonLife.remain() / 15) and debuff.agony.remain() < 23.4 then
--             if cast.agony() then return true end

--         end
--     end
--     -- actions.db_refresh+=/corruption,line_cd=15,if=(dot.corruption.remains%dot.corruption.duration)<=(dot.agony.remains%dot.agony.duration)&(dot.corruption.remains%dot.corruption.duration)<=(dot.siphon_life.remains%dot.siphon_life.duration)&dot.corruption.remains<dot.corruption.duration*1.3
--     if Line_cd(spell.corruption, 15) and not noDotCheck("target") then
--         if (debuff.corruption.remain() / 14) <= (debuff.agony.remain() / 18) and (debuff.corruption.remain() / 14) <= (debuff.siphonLife.remain() / 15) and debuff.corruption.remain() < 18.2 then
--             if cast.corruption() then return true end
--         end
--     end
-- end

-- actionList.dots = function ()
--     -- actions.dots=seed_of_corruption,if=dot.corruption.remains<=action.seed_of_corruption.cast_time+time_to_shard+4.2*(1-talent.creeping_death.enabled*0.15)&spell_targets.seed_of_corruption_aoe>=3+raid_event.invulnerable.up+talent.writhe_in_agony.enabled&!dot.seed_of_corruption.remains&!action.seed_of_corruption.in_flight
--     if (debuff.corruption.remain() <= cast.time.seedOfCorruption() + SeedTravelTime(thisUnit) + (debuff.agony.stack(seedTarget) > 7 and 2*gcd or 4.2))
--         and seedTargetsHit >= 3 --[[ + raid_event.invulnerable.up ]] + (talent.writheInAgony and 1 or 0) 
--         and debuff.seedOfCorruption.count() == 0 
--         and not cast.last.seedOfCorruption() then
--         if cast.seedOfCorruption(seedTarget) then br.addonDebug("Casting Seed of Corruption") return true end
--     end
--     -- actions.dots+=/agony,target_if=min:remains,if=talent.creeping_death.enabled&active_dot.agony<6&target.time_to_die>10&(remains<=gcd|cooldown.summon_darkglare.remains>10&(remains<5|!azerite.pandemic_invocation.rank&refreshable))
--     if talent.creepingDeath and agonyCount < getOptionValue("Agony Count") then
--         -- target
--         if not noDotCheck("target") and ttd("target") > 10 and (debuff.agony.remain("target") <= gcd or cd.summonDarkglare.remain() > 10 and (debuff.agony.remain("target") < 5 or not traits.pandemicInvocation.active and debuff.agony.remain("target") <= 5.4)) then
--             if cast.agony("target") then br.addonDebug("Casting Agony") return true end
--         end
--         -- maintain
--         if mode.rotation==1
--             or mode.rotation==3 and option.checked("Spread Agony on ST") and agonyCount <= 1+getOptionValue("Spread Agony on ST") then
--             for i = 1, #enemyTable40 do
--                 local thisUnit = enemyTable40[i]
--                 local agonyRemain = debuff.agony.remain(thisUnit)
--                 if agonyRemain > 0 and not noDotCheck(thisUnit) and (ttd(thisUnit) > 10 and (--[[ agonyRemain <= gcd or ]] cd.summonDarkglare.remain() > 10 and (agonyRemain < 5 or not traits.pandemicInvocation.active and agonyRemain <= 5.4))) then
--                     -- if not noDotCheck(thisUnit) then
--                         if cast.agony(thisUnit) then br.addonDebug("Casting Agony") return true end
--                     -- end
--                 end
--             end
--         end
--         -- cycle
--         -- 1 = Auto, 2 = Mult, 3 = Sing, 4 = Off
--         if mode.rotation==1
--             or mode.rotation==2
--             or mode.rotation==3 and option.checked("Spread Agony on ST") and agonyCount < 1+getOptionValue("Spread Agony on ST") then
--             for i = 1, #enemyTable40 do
--                 local thisUnit = enemyTable40[i]
--                 local agonyRemain = debuff.agony.remain(thisUnit)
--                 if ttd(thisUnit) > 10 and not noDotCheck(thisUnit) and (--[[ agonyRemain <= gcd or ]] cd.summonDarkglare.remain() > 10 and (agonyRemain < 5 or not traits.pandemicInvocation.active and agonyRemain <= 5.4)) then
--                     -- if not noDotCheck(thisUnit) then
--                         if cast.agony(thisUnit) then br.addonDebug("Casting Agony") return true end
--                     -- end
--                 end
--             end
--         end
--     end
--     -- actions.dots+=/agony,target_if=min:remains,if=!talent.creeping_death.enabled&active_dot.agony<8&target.time_to_die>10&(remains<=gcd|cooldown.summon_darkglare.remains>10&(remains<5|!azerite.pandemic_invocation.rank&refreshable))
--     if not talent.creepingDeath and agonyCount <= getOptionValue("Agony Count") then
--         -- target
--         if ttd(thisUnit) > 10 and not noDotCheck("target") and (debuff.agony.remain("target") <= gcd or (cd.summonDarkglare.remain() > 10 or not CDOptionEnabled("Darkglare")) and (debuff.agony.remain("target") <= 5.4 or not traits.pandemicInvocation.active and debuff.agony.remain("target") <= 5.4)) then
--             if cast.agony("target") then br.addonDebug("Casting Agony") return true end
--         end
--         -- maintain
--         if mode.rotation==1
--             or mode.rotation==2
--             or mode.rotation==3 and option.checked("Spread Agony on ST") and agonyCount <= 1+getOptionValue("Spread Agony on ST") then
--             for i = 1, #enemyTable40 do
--                 local thisUnit = enemyTable40[i]
--                 local agonyRemain = debuff.agony.remain(thisUnit)
--                 if agonyRemain > 0 and not noDotCheck(thisUnit) and (--[[ agonyRemain <= gcd or ]] (cd.summonDarkglare.remain() > 10 or not CDOptionEnabled("Darkglare")) and (agonyRemain <= 5.4 or not traits.pandemicInvocation.active and agonyRemain <= 5.4)) then
--                     -- if not noDotCheck(thisUnit) then
--                         if cast.agony(thisUnit) then br.addonDebug("Casting Agony") return true end
--                     -- end
--                 end
--             end
--         end
--         -- cycle
--         if mode.rotation==1
--             or mode.rotation==2
--             or mode.rotation==3 and option.checked("Spread Agony on ST") and agonyCount < 1+getOptionValue("Spread Agony on ST") then
--             for i = 1, #enemyTable40 do
--                 local thisUnit = enemyTable40[i]
--                 local agonyRemain = debuff.agony.remain(thisUnit)
--                 if ttd(thisUnit) > 10 and not noDotCheck(thisUnit) and (--[[ agonyRemain <= gcd or ]] (cd.summonDarkglare.remain() > 10 or not CDOptionEnabled("Darkglare")) and (agonyRemain <= 5.4 or not traits.pandemicInvocation.active and agonyRemain <= 5.4)) then
--                     -- if not noDotCheck(thisUnit) then
--                         if cast.agony(thisUnit) then br.addonDebug("Casting Agony") return true end
--                     -- end
--                 end
--             end
--         end
--     end
--     -- actions.dots+=/siphon_life,target_if=min:remains,if=(active_dot.siphon_life<8-talent.creeping_death.enabled-spell_targets.sow_the_seeds_aoe)&target.time_to_die>10&refreshable&(!remains&spell_targets.seed_of_corruption_aoe=1|cooldown.summon_darkglare.remains>soul_shard*action.unstable_affliction.execute_time)
--     if (siphonLifeCount < getOptionValue("Siphon Life Count") - (talent.creepingDeath and 1 or 0) - seedTargetsHit) then
--         -- target
--         if ttd("target") > 10 and not noDotCheck("target") and debuff.siphonLife.remain("target") <= 4.5 and (not debuff.siphonLife.exists("target") and seedTargetsHit==1 or ((cd.summonDarkglare.remain() > shards * cast.time.unstableAffliction()) or not CDOptionEnabled("Darkglare"))) then
--                 if cast.siphonLife("target") then br.addonDebug("Casting Siphon Life") return true end
--         end
--     end
--     if (siphonLifeCount <= getOptionValue("Siphon Life Count") - (talent.creepingDeath and 1 or 0) - seedTargetsHit) then
--         -- maintain
--         if mode.rotation==1 or mode.rotation==2 then
--             for i = 1, #enemyTable40 do
--                 local thisUnit = enemyTable40[i]
--                 local siphonLifeRemain = debuff.siphonLife.remain(thisUnit)
--                 if siphonLifeRemain > 0 and not noDotCheck(thisUnit) and (ttd(thisUnit) > 10 and siphonLifeRemain <= 4.5 and (not debuff.siphonLife.exists(thisUnit) and seedTargetsHit==1 or ((cd.summonDarkglare.remain() > shards * cast.time.unstableAffliction()) or not CDOptionEnabled("Darkglare")))) then
--                     -- if not noDotCheck(thisUnit) then
--                         if cast.siphonLife(thisUnit) then br.addonDebug("Casting Siphon Life") return true end
--                     -- end
--                 end
--             end
--         end
--     end
--     if (siphonLifeCount < getOptionValue("Siphon Life Count") - (talent.creepingDeath and 1 or 0) - seedTargetsHit) then
--         -- cycle
--         if mode.rotation==1 or mode.rotation==2 then
--             for i = 1, #enemyTable40 do
--                 local thisUnit = enemyTable40[i]
--                 local siphonLifeRemain = debuff.siphonLife.remain(thisUnit)
--                 if ttd(thisUnit) > 10 and not noDotCheck(thisUnit) and siphonLifeRemain <= 4.5 and (not debuff.siphonLife.exists(thisUnit) and seedTargetsHit==1 or ((cd.summonDarkglare.remain() > shards * cast.time.unstableAffliction()) or not CDOptionEnabled("Darkglare"))) then
--                     -- if not noDotCheck(thisUnit) then
--                         if cast.siphonLife(thisUnit) then br.addonDebug("Casting Siphon Life") return true end
--                     -- end
--                 end
--             end
--         end
--     end
--     -- actions.dots+=/corruption,cycle_targets=1,if=spell_targets.seed_of_corruption_aoe<3+raid_event.invulnerable.up+talent.writhe_in_agony.enabled&(remains<=gcd|cooldown.summon_darkglare.remains>10&refreshable)&target.time_to_die>10
--     -- target
--     if seedTargetsHit < 3 --[[ + raid_event.invulnerable.up ]] + (talent.writheInAgony and 1 or 0) then
--         if not noDotCheck("target") and (debuff.corruption.remain("target") <= gcd or (cd.summonDarkglare.remain() > 10 or not CDOptionEnabled("Darkglare")) and debuff.corruption.remain("target") <= 4.2) and ttd("target") > 10 then
--             if cast.able.corruption() then
--                 if cast.corruption("target") then return true end
--             end
--         end
--     end
--     -- maintain
--     if mode.rotation==1 or mode.rotation==2 then
--         if corruptionCount <= getOptionValue("Corruption Count") then
--             if seedTargetsHit < 3 --[[ + raid_event.invulnerable.up ]] + (talent.writheInAgony and 1 or 0) then
--                 for i = 1, #enemyTable40 do
--                     local thisUnit = enemyTable40[i]
--                     local corruptionRemain = debuff.corruption.remain(thisUnit)
--                     if corruptionRemain > 0 and not noDotCheck(thisUnit) and ((--[[ corruptionRemain <= gcd or ]] (cd.summonDarkglare.remain() > 10 or not CDOptionEnabled("Darkglare")) and corruptionRemain <= 4.2) and ttd(thisUnit) > 10) then
--                         -- if not noDotCheck(thisUnit) then
--                             if cast.able.corruption() then
--                                 if cast.corruption(thisUnit) then return true end
--                             end
--                         -- end
--                     end
--                 end
--             end
--         end
--     end
--     -- cycle
--     if mode.rotation==1 or mode.rotation==2 then
--         if corruptionCount < getOptionValue("Corruption Count") then
--             if seedTargetsHit < 3 --[[ + raid_event.invulnerable.up ]] + (talent.writheInAgony and 1 or 0) then
--                 for i = 1, #enemyTable40 do
--                     local thisUnit = enemyTable40[i]
--                     local corruptionRemain = debuff.corruption.remain(thisUnit)
--                     if not noDotCheck(thisUnit) and (--[[ corruptionRemain <= gcd or ]] (cd.summonDarkglare.remain() > 10 or not CDOptionEnabled("Darkglare")) and corruptionRemain <= 4.2) and ttd(thisUnit) > 10 then
--                         -- if not noDotCheck(thisUnit) then
--                             if cast.able.corruption() then
--                                 if cast.corruption(thisUnit) then return true end
--                             end
--                         -- end
--                     end
--                 end
--             end
--         end
--     end
-- end

-- actionList.fillers = function ()
-- -- actions.fillers=unstable_affliction,line_cd=15,if=cooldown.deathbolt.remains<=gcd*2&spell_targets.seed_of_corruption_aoe=1+raid_event.invulnerable.up&cooldown.summon_darkglare.remains>20
--     if Line_cd(spell.unstableAffliction,15) and cd.deathbolt.remain() <= gcd * 2 and seedTargetsHit > 1 and cd.summonDarkglare.remain() > 20 then
--         if cast.unstableAffliction() then br.addonDebug("Casting Unstable Affliction") return true end
--     end
--     -- actions.fillers+=/call_action_list,name=db_refresh,if=talent.deathbolt.enabled&spell_targets.seed_of_corruption_aoe=1+raid_event.invulnerable.up&(dot.agony.remains<dot.agony.duration*0.75|dot.corruption.remains<dot.corruption.duration*0.75|dot.siphon_life.remains<dot.siphon_life.duration*0.75)&cooldown.deathbolt.remains<=action.agony.gcd*4&cooldown.summon_darkglare.remains>20
--     if talent.deathbolt and seedTargetsHit == 1 and (debuff.agony.remain() < agonyDuration * 0.75 or debuff.corruption.remain() < corruptionDuration * 0.75 or debuff.siphonLife.remain() < siphonLifeDuration * 0.75) and cd.deathbolt.remain() <= gcd * 4 and cd.summonDarkglare.remain() > 20 then
--         if actionList_db_refresh() then return true end
--     end
--     -- actions.fillers+=/call_action_list,name=db_refresh,if=talent.deathbolt.enabled&spell_targets.seed_of_corruption_aoe=1+raid_event.invulnerable.up&cooldown.summon_darkglare.remains<=soul_shard*action.agony.gcd+action.agony.gcd*3&(dot.agony.remains<dot.agony.duration*1|dot.corruption.remains<dot.corruption.duration*1|dot.siphon_life.remains<dot.siphon_life.duration*1)
--     if talent.deathbolt and seedTargetsHit == 1 and cd.summonDarkglare.remain() <= shards * gcd + gcd * 3 and (debuff.agony.remain() < agonyDuration * 1 or debuff.corruption.remain() < corruptionDuration * 1 or debuff.siphonLife.remain() < siphonLifeDuration * 1) then
--         if actionList_db_refresh() then return true end
--     end
--     -- actions.fillers+=/deathbolt,if=cooldown.summon_darkglare.remains>=30+gcd|cooldown.summon_darkglare.remains>140
--     if talent.deathbolt then 
--         if (cd.summonDarkglare.remain() >= 30 + gcd) or (cd.summonDarkglare.remain() > 140) then
--             if cast.deathbolt() then br.addonDebug("Casting Deathbolt") return true end
--         end
--     end
--     -- actions.fillers+=/shadow_bolt,if=buff.movement.up&buff.nightfall.remains
--     if talent.nightfall and moving and buff.nightfall.exists() then
--         if cast.shadowBolt() then br.addonDebug("Casting Shadow Bolt") return true end
--     end
--     -- actions.fillers+=/agony,if=buff.movement.up&!(talent.siphon_life.enabled&(prev_gcd.1.agony&prev_gcd.2.agony&prev_gcd.3.agony)|prev_gcd.1.agony)
--     if moving and not noDotCheck("target") and (not ((talent.siphonLife and (cast.last.agony(1) or cast.last.agony(2) or cast.last.agony(3))) or not talent.siphonLife and cast.last.agony(1)) or talent.absoluteCorruption) then
--         if cast.agony() then br.addonDebug("Casting Agony") return true end
--     end
--     -- actions.fillers+=/siphon_life,if=buff.movement.up&!(prev_gcd.1.siphon_life&prev_gcd.2.siphon_life&prev_gcd.3.siphon_life)
--     if moving and not noDotCheck("target") and not (cast.last.siphonLife()) then
--         if cast.siphonLife() then br.addonDebug("Casting Siphon Life") return true end
--     end
--     -- actions.fillers+=/corruption,if=buff.movement.up&!prev_gcd.1.corruption&!talent.absolute_corruption.enabled
--     if moving and not noDotCheck("target") and not cast.last.corruption() and (not talent.absoluteCorruption or not debuff.corruption.exists()) then
--         if cast.corruption() then br.addonDebug("Casting Corruption") return true end
--     end
--     -- actions.fillers+=/drain_life,if=(buff.inevitable_demise.stack>=40-(spell_targets.seed_of_corruption_aoe-raid_event.invulnerable.up>2)*20&(cooldown.deathbolt.remains>execute_time|!talent.deathbolt.enabled)&(cooldown.phantom_singularity.remains>execute_time|!talent.phantom_singularity.enabled)&(cooldown.dark_soul.remains>execute_time|!talent.dark_soul_misery.enabled)&(cooldown.vile_taint.remains>execute_time|!talent.vile_taint.enabled)&cooldown.summon_darkglare.remains>execute_time+10|buff.inevitable_demise.stack>10&target.time_to_die<=10)
--     if option.checked("Drain Life Trait") and not cast.last.drainLife(1) and not isCastingSpell(234153) then
--         if (buff.inevitableDemise.stack() >= (40 - (seedTargetsHit > 2 and 1 or 0) * 20)
--             and ((cd.deathbolt.remain() > drainLifeTime or not talent.deathbolt) or not CDOptionEnabled("Darkglare"))
--             and (cd.phantomSingularity.remain() > drainLifeTime or not talent.phantomSingularity) 
--             and ((cd.darkSoul.remain() > drainLifeTime or not talent.darkSoul) or not CDOptionEnabled("Darkglare")) 
--             and (cd.vileTaint.remain() > drainLifeTime or not talent.vileTaint) 
--             and (cd.summonDarkglare.remain() > drainLifeTime + 10 or not CDOptionEnabled("Darkglare"))
--             or buff.inevitableDemise.stack() > 10 and ttd("target") <= 10) then
--             if cast.drainLife() then br.addonDebug("Casting Drain Life") return true end
--         end
--     end
--     -- actions.fillers+=/haunt
--     if talent.haunt then
--         if cast.haunt() then br.addonDebug("Casting Haunt") return true end
--     end
--     -- actions.fillers+=/drain_soul,interrupt_global=1,chain=1,interrupt=1,cycle_targets=1,if=target.time_to_die<=gcd
--     -- actions.fillers+=/drain_soul,target_if=min:debuff.shadow_embrace.remains,chain=1,interrupt_if=ticks_remain<5,interrupt_global=1,if=talent.shadow_embrace.enabled&variable.maintain_se&!debuff.shadow_embrace.remains
--     -- actions.fillers+=/drain_soul,target_if=min:debuff.shadow_embrace.remains,chain=1,interrupt_if=ticks_remain<5,interrupt_global=1,if=talent.shadow_embrace.enabled&variable.maintain_se
--     -- actions.fillers+=/drain_soul,interrupt_global=1,chain=1,interrupt=1
--     if talent.drainSoul then
--         if cast.drainSoul() then br.addonDebug("Casting Drain Soul") return true end
--     end
--     -- actions.fillers+=/shadow_bolt,cycle_targets=1,if=talent.shadow_embrace.enabled&variable.maintain_se&!debuff.shadow_embrace.remains&!action.shadow_bolt.in_flight
--     -- actions.fillers+=/shadow_bolt,target_if=min:debuff.shadow_embrace.remains,if=talent.shadow_embrace.enabled&variable.maintain_se
--     -- actions.fillers+=/shadow_bolt
--     if cast.shadowBolt() then br.addonDebug("Casting Shadow Bolt") return true end
-- end

actionList.multi = function()
    -- Seed of Corruption
    if not moving and not cast.last.seedOfCorruption() and not debuff.seedOfCorruption.exists(seedTarget) then
        if cast.seedOfCorruption(seedTarget) then br.addonDebug("Casting Seed of Corruption") return true end
    end
    -- Phantom Singularity
    if talent.phantomSingularity then
        if cast.phantomSingularity() then br.addonDebug("Casting Phantom Singularity") return true end
    end
    -- Vile Taint
    if talent.vileTaint then
        if cast.vileTaint(nil,"aoe",1,8,true) then br.addonDebug("Casting Vile Taint") return true end
    end
    -- Focused Azerite Beam
    if option.checked("Use Essence") and essence.focusedAzeriteBeam.active and cd.focusedAzeriteBeam.remain() <= gcdMax
    and ((essence.focusedAzeriteBeam.rank < 3 and not moving) or essence.focusedAzeriteBeam.rank >= 3) and (getEnemiesInRect(2,25,isChecked("Show Drawings"),false) >= getOptionValue("Azerite Beam Units") or (isBoss("target") and getDistance("player","target") <= 25 and getFacing("player","target", 5))) 
    then
        if cast.focusedAzeriteBeam() then
            br.addonDebug("Casting Focused Azerite Beam")
            return 
        end
    end
    -- Purifying Blast
    if option.checked("Use Essence") and essence.purifyingBlast.active and cd.purifyingBlast.remain() <= gcdMax then
        if cast.purifyingBlast("best", nil, minCount, 40) then br.addonDebug("Casting Purifying Blast") return true end
    end
    -- Reaping Flame
    if option.checked("Use Essence") and essence.reapingFlames.active and cd.reapingFlames.remain() <= gcdMax then
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
            if not noDotCheck(thisUnit) and  debuff.agony.refresh(thisUnit) and getTTD(thisUnit) > debuff.agony.remain(thisUnit) + (2/spellHaste)  then
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
    if option.checked("Use Essence") and essence.rippleInSpace.active and cd.rippleInSpace.remain() <= gcdMax then
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
    option                                        = br.player.option
    pet                                           = br.player.pet
    php                                           = br.player.health
    pullTimer                                     = br.DBM:getPulltimer()
    shards                                        = br.player.power.soulShards.frac()
    spell                                         = br.player.spell
    talent                                        = br.player.talent
    traits                                        = br.player.traits
    tanks                                         = getTanksTable()
    units                                         = br.player.units
    use                                           = br.player.use
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
    -- Enemies
    enemies.get(5) -- Makes a varaible called, enemies.yards5
    enemies.get(10,"target")
    enemies.get(40) -- Makes a varaible called, enemies.yards40

    -- Profile Specific Locals
    if actionList.PetManagement == nil then
        loadSupport("PetCuteOne")
        actionList.PetManagement = br.rotations.support["PetCuteOne"]
    end

    -- Pet Data
    if mode.petSummon == 1 and HasAttachedGlyph(spell.summonImp) then summonId = 58959
    elseif mode.petSummon == 1 then summonId = 416
    elseif mode.petSummon == 2 and HasAttachedGlyph(spell.summonVoidwalker) then summonId = 58960
    elseif mode.petSummon == 2 then summonId = 1860
    elseif mode.petSummon == 3 then summonId = 417
    elseif mode.petSummon == 4 then summonId = 1863 end

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

    if debuff.unstableAffliction == nil then debuff.unstableAffliction = {} end

		function debuff.unstableAffliction.stack(unit)
			local uaStack = 0
			if unit == nil then
				if GetUnitExists("target") then unit = "target"
				else return 0
				end
			end
			for i=1,40 do
				local _,_,_,_,_,_,buffCaster,_,_,buffSpellID = UnitDebuff(unit,i)
				if (buffSpellID == 233490 or buffSpellID == 233496 or buffSpellID == 233497 or
				buffSpellID == 233498 or buffSpellID == 233499) and GetUnitIsUnit(buffCaster, "player") then uaStack = uaStack + 1 end
			end
			return uaStack
		end

		function debuff.unstableAffliction.remain(unit)
			local remain = 0
			if unit == nil then
				if GetUnitExists("target") then unit = "target"
				else return 999
				end
			end
			for i=1,40 do
				local _,_,_,_,_,buffExpire,buffCaster,_,_,buffSpellID = UnitDebuff(unit,i)
				if (buffSpellID == 233490 or buffSpellID == 233496 or buffSpellID == 233497 or
				buffSpellID == 233498 or buffSpellID == 233499) and GetUnitIsUnit(buffCaster, "player") then
					if (buffExpire - GetTime()) > remain then remain = (buffExpire - GetTime()) end
				end
			end
			return remain
        end
        
    local function totalDots()
        local dots = 0
        if GetUnitExists("target") then 
            dots = corruptionCount + agonyCount + siphonLifeCount + debuff.phantomSingularity.count()
        end
        return dots
    end

    -- SimC specific variables
    --actions=variable,name=use_seed,value=talent.sow_the_seeds.enabled&spell_targets.seed_of_corruption_aoe>=3+raid_event.invulnerable.up|talent.siphon_life.enabled&spell_targets.seed_of_corruption>=5+raid_event.invulnerable.up|spell_targets.seed_of_corruption>=8+raid_event.invulnerable.up
    if talent.sowTheSeeds and ((not talent.siphonLife and #enemies.yards10t >= 2) or (talent.siphonLife and #enemies.yards10t >= 4) or (#enemies.yards10t >= 8)) then
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
    (talent.sowTheSeeds and 1 or 0) and (#enemies.yards10t > 1 and 1 or 0))+((talent.siphonLife and 1 or 0) and (not talent.creepingDeath and 1 or 0) and (not talent.drainSoul and 1 or 0))
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
         -----------------
        --- Pet Logic ---
        -----------------
        if actionList.PetManagement() then return true end
        -----------------------
        --- Extras Rotation ---
        -----------------------
        if actionList.Extra() then return true end
        -----------------
        --- Defensive ---
        -----------------
        if actionList.Defensive() then return true end
        ------------------
        --- Pre-Combat ---
        ------------------
        if actionList.PreCombat() then return true end
        -----------------------------
        --- In Combat - Rotations ---
        -----------------------------
        if inCombat and not profileStop and (not cast.current.drainLife() or (cast.current.drainLife() and php > 80)) then
            ------------------------------
            --- In Combat - Interrupts ---
            ------------------------------
            if actionList.Interrupts() then return true end
            if isChecked("Shadowfury Key") and SpecificToggle("Shadowfury Key") and not GetCurrentKeyBoardFocus() then
                if CastSpellByName(GetSpellInfo(spell.shadowfury),"cursor") then br.addonDebug("Casting Shadow Fury") return end 
            end
             -----------------
            ---  AMR APL  ---
            -----------------
            --Potion
             -- actions.cooldowns+=/potion,if=(talent.dark_soul_misery.enabled&cooldown.summon_darkglare.up&cooldown.dark_soul.up)|cooldown.summon_darkglare.up|target.time_to_die<30
             if option.checked("Potion") and useCDs() and pet.darkglare.active() then
                if not buff.potionOfUnbridledFury.exists() and canUseItem(item.potionOfUnbridledFury) then
                    if use.potionOfUnbridledFury() then br.addonDebug("Using Potion of Unbridled Fury [Pre-Pull]") return end
                end
            end
            -- Racial
            if option.checked("Racial") and useCDs() and pet.darkglare.active() and (race == "Troll" or race == "Orc" or race == "DarkIronDwarf") then
                if cast.racial() then br.addonDebug("Casting Berserking") return true end
            end
            -- Trinkets
            if option.checked("Trinkets") and useCDs() and pet.darkglare.active() then
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
            if option.checked("Use Essence") and useCDs() and essence.guardianOfAzeroth.active and cd.guardianOfAzeroth.remain() <= gcdMax and pet.darkglare.active() then
                if cast.guardianOfAzeroth() then br.addonDebug("Casting Guardian of Azeroth") return true end
            end
            -- Haunt
            if not moving and talent.haunt and not debuff.haunt.exists("target") then
                if cast.haunt("target") then br.addonDebug("Casting Haunt") return true end
            end
            -- Blood of the Enemy
            if option.checked("Use Essence") and useCDs() and (buff.darkSoul.exists() or pet.darkglare.active() or cd.summonDarkglare.remain() >= 80 ) then
                if cast.bloodOfTheEnemy() then br.addonDebug("Casting Blood of the Enemy") return true end
            end
            -- The Unbound Force
            if option.checked("Use Essence") and essence.theUnboundForce.active and cd.theUnboundForce.remain() <= gcdMax and (cd.summonDarkglare.remain > gcdMax or not useCDs())
                and buff.recklessForce.exists() 
            then
                if cast.theUnboundForce() then br.addonDebug("Casting The Unbound Force") return true end
            end
            -- Summon Darkglare
            if getTTD("target") >= 20 and useCDs() and cd.summonDarkglare.remain() <= gcdMax and ((option.checked("Darkglare Dots") and totalDots() >= option.value("Darkglare Dots")) or (not option.checked("Darkglare Dots") and debuff.agony.exists("target") 
            and (debuff.siphonLife.exists("target") or not talent.siphonLife) and debuff.corruption.exists("target"))) and (shards == 0 or debuff.unstableAffliction.stack("target") == 5)
            then
                CastSpellByName(GetSpellInfo(spell.summonDarkglare))
                br.addonDebug("Casting Darkglare")
                --if cast.summonDarkglare() then return true end
                return true
            end
            -- Unstable Affliction
            if not moving and cd.summonDarkglare.remain() < 8 and (debuff.unstableAffliction.stack("target") < 5  and debuff.agony.remain("target") > shards * gcdMax and debuff.corruption.remain("target") > shards * gcdMax and (debuff.siphonLife.remain("target") > shards *gcdMax or not talent.siphonLife)) then
                if cast.unstableAffliction() then br.addonDebug("Casting Unstable Affliction [1]") return true end
            end
            -- Multi Target
            if #enemies.yards10t >= 3 and mode.single ~= 1 then
                if actionList.multi() then return true end
            end
            -- Agony
            if traits.pandemicInvocation.active then
                if agonyCount < option.value("Spread Agony on ST") then
                    for i = 1, #enemies.yards40 do
                        local thisUnit = enemies.yards40[i]
                        if not noDotCheck(thisUnit) and debuff.agony.remain(thisUnit) < 5 and getTTD(thisUnit) > debuff.agony.remain(thisUnit) + (2/spellHaste) then
                            if cast.agony(thisUnit) then br.addonDebug("Casting Agony [Pandemic Invocation]") return true end
                        end
                    end
                end
            else
                if agonyCount < option.value("Spread Agony on ST") then
                    for i = 1, #enemies.yards40 do
                        local thisUnit = enemies.yards40[i]
                        if not noDotCheck(thisUnit) and  debuff.agony.refresh(thisUnit) and getTTD(thisUnit) > debuff.agony.remain(thisUnit) + (2/spellHaste) then
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
                        if not noDotCheck(thisUnit) and debuff.corruption.remain(thisUnit) < 5 and getTTD(thisUnit) > debuff.corruption.remain(thisUnit) + (2/spellHaste) then
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
            -- Unstable Affliction
            if not moving then
                if traits.cascadingCalamity.active then
                    if debuff.unstableAffliction.remain("target") > 1.5 and not buff.cascadingCalamity.exists() and (cd.summonDarkglare.remain() > 30 or not useCDs()) then
                        if cast.unstableAffliction() then br.addonDebug("Casting Unstable Affliction [2]") return true end
                    end
                end
                if debuff.unstableAffliction.stack("target") < 5 and ((debuff.unstableAffliction.remain("target")< gcdMax and (cd.summonDarkglare.remain() > 30 or not useCDs())) or shards >= 4) then
                    if cast.unstableAffliction() then br.addonDebug("Casting Unstable Affliction [3]") return true end
                end
            end
            -- Deathbolt
            if talent.deathbolt and cd.summonDarkglare.remain() > 30 then
                if cast.deathbolt() then br.addonDebug("Casting Deathbolt") return true end
            end
            -- Worldvein Resonance
            if option.checked("Use Essence") and essence.worldveinResonance.active and cd.worldveinResonance.remain() <= gcdMax and  (cd.summonDarkglare.remain() > 30 or not useCDs()) then
                if cast.worldveinResonance() then br.addonDebug("Casting Worldvein Resonance") return true end
            end
            -- Phantom Singularity
            if talent.phantomSingularity then
                if cast.phantomSingularity() then br.addonDebug("Casting Phantom Singularity") return true end
            end
            -- Vile Taint
            if not moving and talent.vileTaint then
                if cast.vileTaint(nil,"aoe",1,8,true) then br.addonDebug("Casting Vile Taint") return true end
            end
            -- Focused Azerite Beam
            if cd.summonDarkglare.remains() > 10 and option.checked("Use Essence") and essence.focusedAzeriteBeam.active and cd.focusedAzeriteBeam.remain() <= gcdMax
            and ((essence.focusedAzeriteBeam.rank < 3 and not moving) or essence.focusedAzeriteBeam.rank >= 3) and (getEnemiesInRect(2,25,isChecked("Show Drawings"),false) >= getOptionValue("Azerite Beam Units") or (isBoss("target") and getDistance("player","target") <= 20 and getFacing("player","target", 5))) 
            then
                if cast.focusedAzeriteBeam() then
                    br.addonDebug("Casting Focused Azerite Beam")
                    return 
                end
            end
            -- Purifying Blast
            if option.checked("Use Essence") and essence.purifyingBlast.active and cd.purifyingBlast.remain() <= gcdMax and (#enemies.yards10t >= 2 or useCDs()) then
                local minCount = useCDs() and 1 or 3
                if cast.purifyingBlast("best", nil, minCount, 40) then br.addonDebug("Casting Purifying Blast") return true end
            end
            -- Reaping Flame
            if option.checked("Use Essence") and essence.reapingFlames.active and cd.reapingFlames.remain() <= gcdMax then
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
            if option.checked("Use Essence") and essence.rippleInSpace.active and cd.rippleInSpace.remain() <= gcdMax then
                if cast.rippleInSpace() then br.addonDebug("Casting Ripple In Space") return true end
            end
            -- Memory of Lucid Dreams
            if option.checked("Use Essence") and useCDs() and essence.memoryOfLucidDreams.active and cd.memoryOfLucidDreams.remain() <= gcdMax and shards < 4 then
                if cast.memoryOfLucidDreams() then br.addonDebug("Casting Memory of Lucid Dreams") return true end
            end
            -- Drain Soul
            if not moving and talent.drainSoul then
                if cast.drainSoul() then br.addonDebug("Casting Drain Soul") return true end
            end
            -- Shadow Bolt
            if not moving and (cd.summonDarkglare.remain() > gcdMax or not useCDs() or (option.checked("Darkglare Dots") and totalDots() < option.value("Darkglare Dots"))) then
                if cast.shadowBolt() then br.addonDebug("Casting Shadow Bolt") return true end
            end
            -- Agony
            if moving then
                if agonyCount < option.value("Agony Count") then
                    for i = 1, #enemies.yards40 do
                        local thisUnit = enemies.yards40[i]
                        local agonyRemain = debuff.agony.remain(thisUnit)
                        if not noDotCheck(thisUnit) and ttd(thisUnit) > 10 then
                            if cast.agony(thisUnit) then br.addonDebug("Casting Agony") return true end
                        end
                    end
                end
            end
            ---------------------------
            --- SimulationCraft APL ---
            ---------------------------                
            -- --actions+=/call_action_list,name=cooldowns
            -- if actionList.Cooldown() then return true end
            -- -- actions+=/drain_soul,interrupt_global=1,chain=1,cycle_targets=1,if=target.time_to_die<=gcd&soul_shard<5
            -- if talent.drainSoul and getTTD("target") <= gcdMax and shards < 5 then
            --     if cast.drainSoul() then br.addonDebug("Casting Drain Soul") return true end
            -- end
            -- -- actions+=/haunt,if=spell_targets.seed_of_corruption_aoe<=2+raid_event.invulnerable.up
            -- if not noDotCheck("target") and #enemies.yards10t <= 1 then
            --     if cast.haunt() then br.addonDebug("Casting Haunt") return true end
            -- end
            -- --actions+=/summon_darkglare,if=summon_darkglare,if=dot.agony.ticking&dot.corruption.ticking&(buff.active_uas.stack=5|soul_shard=0|dot.phantom_singularity.remains&dot.phantom_singularity.remains<=gcd)&(!talent.phantom_singularity.enabled|dot.phantom_singularity.remains)&(!talent.deathbolt.enabled|cooldown.deathbolt.remains<=gcd|!cooldown.deathbolt.remains|spell_targets.seed_of_corruption_aoe>1+raid_event.invulnerable.up)
            -- if CDOptionEnabled("Darkglare") then
            --     if debuff.agony.exists() 
            --         and debuff.corruption.exists() 
            --         and (debuff.unstableAffliction.stack("target") >= 5 or shards == 0) 
            --         and (not talent.phantomSingularity or debuff.phantomSingularity.exists()) 
            --         and (not talent.deathbolt or cd.deathbolt.remain() <= gcd or cd.deathbolt.remain() <= 0 or seedTargetsHit > 1) 
            --     then
            --         CastSpellByName(GetSpellInfo(spell.summonDarkglare))
            --         br.addonDebug("Casting Darkglare")
            --         --if cast.summonDarkglare() then return true end
            --         return true
            --     end
            -- end
            -- -- actions+=/deathbolt,if=cooldown.summon_darkglare.remains&spell_targets.seed_of_corruption_aoe=1+raid_event.invulnerable.up&(!essence.vision_of_perfection.minor&!azerite.dreadful_calling.rank|cooldown.summon_darkglare.remains>30)
            -- if (cd.summonDarkglare.remain() > gcdMax or not CDOptionEnabled("Darkglare")) and 
            --     (not essence.visionOfPerfection.minor and not traits.dreadfulCalling.active or (cd.summonDarkglare.remain() > 30 or not CDOptionEnabled("Darkglare"))) 
            -- then
            --     if cast.deathbolt() then br.addonDebug("Casting Death Bolt") return true end
            -- end            
            -- -- actions+=/the_unbound_force,if=buff.reckless_force.remains
            -- if essence.theUnboundForce.active and cd.theUnboundForce.remains() <= gcdMax and buff.recklessForce.exists() and getDistance("target") <= 3 then
            --     if cast.theUnboundForce() then br.addonDebug("Casting The Unbound Force") return true end
            -- end
            -- -- actions+=/agony,target_if=min:dot.agony.remains,if=remains<=gcd+action.shadow_bolt.execute_time&target.time_to_die>8
            -- if not noDotCheck("target") and debuff.agony.remain() <= gcdMax + cast.time.shadowBolt() and ttd("target") > 8 then
            --     if cast.agony() then br.addonDebug("Casting Agony") return true end
            -- end
            
            -- -- actions+=/memory_of_lucid_dreams,if=time<30
            -- if essence.memoryOfLucidDreams.active and cd.memoryOfLucidDreams.remain() <= gcdMax and combatTime() < 30 then
            --     if cast.memoryOfLucidDreams() then br.addonDebug("Casting Memory of Lucid Dreams") return true end
            -- end
            -- --# Temporary fix to make sure azshara's font doesn't break darkglare usage.
            -- --actions+=/agony,line_cd=30,if=time>30&cooldown.summon_darkglare.remains<=15&equipped.169314
            -- if not noDotCheck("target") and Line_cd(spell.agony, 30) and combatTime > 30 and (cd.summonDarkglare.remain() <= 15 or not CDOptionEnabled("Darkglare")) and equiped.azsharasFontOfPower() then
            --     if cast.agony() then br.addonDebug("Casting Agony") return true end
            -- end
            -- --actions+=/corruption,line_cd=30,if=time>30&cooldown.summon_darkglare.remains<=15&equipped.169314&!talent.absolute_corruption.enabled&(talent.siphon_life.enabled|spell_targets.seed_of_corruption_aoe>1&spell_targets.seed_of_corruption_aoe<=3)
            -- if not noDotCheck("target") and Line_cd(spell.corruption,30) and combatTime > 30 and (cd.summonDarkglare.remain() <= 15 or not CDOptionEnabled("Darkglare")) and equiped.azsharasFontOfPower() and not talent.absoluteCorruption and
            --     (talent.siphonLife or #enemies.yards10t >0 and #enemies.yards10t <= 2) 
            -- then
            --     if cast.corruption() then br.addonDebug("Casting Corruption") return true end
            -- end
            -- -- actions+=/siphon_life,line_cd=30,if=time>30&cooldown.summon_darkglare.remains<=15&equipped.169314
            -- if not noDotCheck("target") and talent.siphonLife and Line_cd(spell.siphonLife, 30) and combatTime > 30 and (cd.summonDarkglare.remain() <= 15 or not CDOptionEnabled("Darkglare")) and equiped.azsharasFontOfPower() then
            --     if cast.siphonLife() then br.addonDebug("Casting Siphon Life") return true end
            -- end

            -- -- actions+=/drain_soul,target_if=min:debuff.shadow_embrace.remains,cancel_if=ticks_remain<5,if=talent.shadow_embrace.enabled&variable.maintain_se&debuff.shadow_embrace.remains&debuff.shadow_embrace.remains<=gcd*2
            -- --actions+=/shadow_bolt,target_if=min:debuff.shadow_embrace.remains,if=talent.shadow_embrace.enabled&variable.maintain_se&debuff.shadow_embrace.remains&debuff.shadow_embrace.remains<=execute_time*2+travel_time&!action.shadow_bolt.in_flight
            -- if talent.shadowEmbrace and maintainSE and debuff.shadowEmbrace.exists("target") and debuff.shadowEmbrace.remain() <= cast.time.shadowBolt*2 and not cast.last.shadowBolt() then
            --     if cast.shadowBolt() then br.addonDebug("Casting Shadow Bolt") return true end
            -- end
            -- --actions+=/phantom_singularity,target_if=max:target.time_to_die,if=time>35&target.time_to_die>16*spell_haste&(!essence.vision_of_perfection.minor&!azerite.dreadful_calling.rank|cooldown.summon_darkglare.remains>45+soul_shard*azerite.dreadful_calling.rank|cooldown.summon_darkglare.remains<15*spell_haste+soul_shard*azerite.dreadful_calling.rank)
            -- if combatTime > 35 and getTTD("target") > 16 * spellHaste and (not essence.visionOfPerfection.minor and not traits.dreadfulCalling.active 
            --     or cd.summonDarkglare.remains > 45 + shards * traits.dreadfulCalling.rank or cd.summonDarkglare.remain() < 15 * spellHaste + shards * traits.dreadfulCalling.rank)
            -- then
            --     if cast.phantomSingularity() then br.addonDebug("Casting Phantom Singularity") return true end
            -- end
            -- -- actions+=/unstable_affliction,target_if=min:contagion,if=!variable.use_seed&soul_shard=5
            -- if not useSeed and shards == 5 then
            --     if cast.unstableAffliction() then br.addonDebug("Casting Unstable Affliction") return true end
            -- end
            -- -- actions+=/seed_of_corruption,if=variable.use_seed&soul_shard=5
            -- if useSeed and shards == 5 then
            --     if cast.seedOfCorruption() then br.addonDebug("Casting Seed of Corruption") return true end
            -- end
            -- -- actions+=/call_action_list,name=dots
            -- if actionList.dots then return true end
            -- -- actions+=/vile_taint,target_if=max:target.time_to_die,if=time>15&target.time_to_die>=10&(cooldown.summon_darkglare.remains>30|cooldown.summon_darkglare.remains<10&dot.agony.remains>=10&dot.corruption.remains>=10&(dot.siphon_life.remains>=10|!talent.siphon_life.enabled))
            -- if talent.vileTaint and combatTime > 15 and getTTD("target") >= 10 and (cd.summonDarkglare.remain() > 30 or 
            --     ((cd.summonDarkglare.remain() < 10 or not CDOptionEnabled("Darkglare")) and debuff.agony.remain("target") >= 10 and debuff.corruption.remain("target") >=10 and (debuff.siphonLife.remain("target") >= 10 or not talent.siphonLife)))
            -- then
            --     if cast.vileTaint(nil,"aoe",1,8,true) then br.addonDebug("Casting Vile Taint") return true end
            -- end
            -- -- actions+=/use_item,name=azsharas_font_of_power,if=time<=3
            -- if equiped.azsharasFontOfPower() and not UnitBuffID("player",296962) then
            --     if UnitCastingInfo("player") then
            --         SpellStopCasting()
            --     end
            --     use.azsharasFontOfPower()
            --     br.addonDebug("Using Azshara's Font of Power")
            --     return
            -- end
            -- -- actions+=/phantom_singularity,if=time<=35
            -- if talent.phantomSingularity and combatTime <= 35 then
            --     if cast.phantomSingularity() then br.addonDebug("Casting Phantom Singularity") return true end
            -- end
            -- -- actions+=/vile_taint,if=time<15
            -- if talent.vileTaint and combatTime < 15 then
            --     if cast.vileTaint(nil,"aoe",1,8,true) then br.addonDebug("Casting Vile Taint") return true end
            -- end
            -- --actions+=/guardian_of_azeroth,if=(cooldown.summon_darkglare.remains<15+soul_shard*azerite.dreadful_calling.enabled|(azerite.dreadful_calling.rank|essence.vision_of_perfection.rank)&time>30&target.time_to_die>=210)&(dot.phantom_singularity.remains|dot.vile_taint.remains|!talent.phantom_singularity.enabled&!talent.vile_taint.enabled)|target.time_to_die<30+gcd
            -- if (combatTime > 30 and getTTD("target") >= 210) or (debuff.phantomSingularity.exists() or debuff.vileTaint.exists() or 
            --     (not talent.phantomSingularity and not talent.vileTaint) or getTTD("target") < 30 + gcdMax)
            -- then
            --     if cast.guardianOfAzeroth() then br.addonDebug("Casting Guardian Of Azeroth") return true end
            -- end
            -- -- actions+=/dark_soul,if=cooldown.summon_darkglare.remains<15+soul_shard*azerite.dreadful_calling.enabled&(dot.phantom_singularity.remains|dot.vile_taint.remains)
            -- if talent.darkSoul and CDOptionEnabled("Dark Soul") and cd.summonDarkglare.remain() < 15 + shards * (traits.dreadfulCalling.active and 1 or 0) and (debuff.phantomSingularity.exists() or debuff.vileTaint.exists()) then
            --     if cast.darkSoul() then br.addonDebug("Casting Dark Soul") return true end
            -- end
            -- -- actions+=/berserking
            -- if CDOptionEnabled("Racial") and not moving and (race == "Orc" or race == "Troll" or race == "DarkIronDwarf" or race=="MagharOrc" or (race == "BloodElf" and energyDeficit > 15 + energyRegen)) then
            --     if castSpell("player",racial,false,false,false) then return true end
            -- end
            -- -- actions+=/call_action_list,name=spenders
            -- if actionList.spenders then return true end
            -- -- actions+=/call_action_list,name=fillers
            -- if actionList.fillers then return true end
        end -- End In Combat Rotation
    end -- Pause
    return true
end -- End runRotation
local id = 0 -- Change to the spec id profile is for.
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})