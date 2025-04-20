-------------------------------------------------------
-- Author = ChefLyfe
-- Patch = 11.0.2
--    Patch should be the latest patch you've updated the rotation for (i.e., 9.2.5)
-- Coverage = 70%
--    Coverage should be your estimated percent coverage for class mechanics (i.e., 100%)
-- Status = Limited
--    Status should be one of: Full, Limited, Sporadic, Inactive, Unknown
-- Readiness = Basic
--    Readiness should be one of: Raid, NoRaid, Basic, Development, Untested
-------------------------------------------------------
-- Required: Fill above fields to populate README.md --
-------------------------------------------------------

local rotationName = "ChefLyfe"

---------------
--- Toggles ---
---------------
local function createToggles()
    -- Rotation Button
    local rotationButton = {
        [1] = { mode = "Auto", value = 1, overlay = "Automatic Rotation", tip = "Enables DPS Rotation", highlight = 1, icon = br.player.spells.deathStrike},
        [2] = { mode = "Off", value = 2, overlay = "DPS Rotation Disabled", tip = "Disables DPS Rotation", highlight = 0, icon = br.player.spells.deathStrike}
    }
    br.ui:createToggle(rotationButton, "Rotation", 1, 0)
    -- Cooldown Button
    local cooldownButton = {
        [1] = { mode = "Auto", value = 1, overlay = "Automatic Cooldowns", tip = "Automatic Cooldown Usage", highlight = 1, icon = br.player.spells.vampiricBlood},
        [2] = { mode = "On", value = 2, overlay = "Enabled Cooldowns", tip = "Cooldown Usage Enabled", highlight = 0, icon = br.player.spells.vampiricBlood},
        [3] = { mode = "Off", value = 3, overlay = "Disabled Cooldowns", tip = "No Cooldowns will be used", highlight = 0, icon = br.player.spells.vampiricBlood}
    }
    br.ui:createToggle(cooldownButton, "Cooldown", 2, 0)
    -- Defensive Button
    local defensiveButton = {
        [1] = { mode = "On", value = 1, overlay = "Defensive Enabled", tip = "Will use defensive abilities", highlight = 1, icon = br.player.spells.iceboundFortitude},
        [2] = { mode = "Off", value = 2, overlay = "Defensive Disabled", tip = "Will not use defensive abilities", highlight = 0, icon = br.player.spells.iceboundFortitude}
    }
    br.ui:createToggle(defensiveButton, "Defensive", 3, 0)
    -- Interrupt Button
    local interruptButton = {
        [1] = { mode = "On", value = 1, overlay = "Interrupts Enabled", tip = "Will use interrupts", highlight = 1, icon = br.player.spells.mindFreeze},
        [2] = { mode = "Off", value = 2, overlay = "Interrupts Disabled", tip = "Will not use interrupts", highlight = 0, icon = br.player.spells.mindFreeze}
    }
    br.ui:createToggle(interruptButton, "Interrupt", 4, 0)
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
        section = br.ui:createSection(br.ui.window.profile, "General")
            -- Leveling Mode
            br.ui:createCheckbox(section, "Leveling Mode", "Enable optimal rotation for leveling characters", true)
            -- Pre-Pull Timer
            br.ui:createSpinner(section, "Pre-Pull Timer", 5, 1, 10, 1, "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
            -- Death Grip Usage
            br.ui:createDropdownWithout(section, "Death Grip Usage", {
                "Off", "Interrupt", "Taunt", "Both"
            }, 3, "Select how to use Death Grip")
            
            -- Death Grip Range
            br.ui:createSpinner(section, "Death Grip Range", 25, 5, 40, 5, "|cffFFFFFFSet to desired range for Death Grip usage. Min: 5 / Max: 40 / Interval: 5")
            
            -- Death Grip Target Options
            br.ui:createDropdownWithout(section, "Death Grip Target", {
                "Any", "Caster", "Healer"
            }, 1, "Select priority targets for Death Grip")
            -- Bone Shield Stacks
            br.ui:createSpinner(section, "Bone Shield Stacks", 7, 1, 10, 1, "|cffFFFFFFSet to desired minimum Bone Shield stacks. Min: 1 / Max: 10 / Interval: 1")
            -- Anti-Magic Shell
            br.ui:createCheckbox(section, "Anti-Magic Shell")
            -- Dancing Rune Weapon
            br.ui:createCheckbox(section, "Dancing Rune Weapon")
            -- Hero Tree Selection
            br.ui:createDropdownWithout(section, "Hero Tree", {
                "Deathbringer", "Sanlayn"
            }, 1, "Select your Hero Tree specialization")
            -- Debug Info
            br.ui:createCheckbox(section, "Show Debug Info", "Show detailed level and ability info in chat")
            -- Basic Trinkets Module
            br.player.module.BasicTrinkets(nil, section)
        br.ui:checkSectionState(section)
        ------------------------
        --- COOLDOWN OPTIONS --- -- Define Cooldown Options
        ------------------------
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
            -- Vampiric Blood HP
            br.ui:createSpinner(section, "Vampiric Blood", 50, 0, 100, 5, "|cffFFFFFFHP Percent to Cast At")
            -- Icebound Fortitude HP
            br.ui:createSpinner(section, "Icebound Fortitude", 30, 0, 100, 5, "|cffFFFFFFHP Percent to Cast At")
            -- Tombstone HP
            br.ui:createSpinner(section, "Tombstone", 60, 0, 100, 5, "|cffFFFFFFHP Percent to Cast At")
            -- Bonestorm
            br.ui:createCheckbox(section, "Bonestorm", "Use Bonestorm when available")
            -- Abomination Limb
            br.ui:createCheckbox(section, "Abomination Limb", "Use Abomination Limb when available")
            -- Potion Usage
            br.ui:createCheckbox(section, "Potion", "Use Potion with Dancing Rune Weapon")
        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS --- -- Define Defensive Options
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
            -- Basic Healing Module
            br.player.module.BasicHealing(section)
            -- Death Strike Low HP
            br.ui:createSpinner(section, "Death Strike Low HP", 50, 0, 100, 5, "|cffFFFFFFHP Percent to Cast At")
            -- Death Strike High RP
            br.ui:createSpinner(section, "Death Strike High RP", 80, 0, 100, 5, "|cffFFFFFFRP Percent to Cast At")
            -- Death Strike with Coagulopathy
            br.ui:createCheckbox(section, "Death Strike with Coagulopathy", "Prioritize Death Strike when Coagulopathy buff is active")
        br.ui:checkSectionState(section)
        -------------------------
        --- INTERRUPT OPTIONS --- -- Define Interrupt Options
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
            -- Interrupt Percentage
            br.ui:createSpinner(section, "Interrupt At", 0, 0, 95, 5, "|cffFFFFFFCast Percentage to use at.")
            -- Mind Freeze
            br.ui:createCheckbox(section, "Mind Freeze")
            -- Asphyxiate
            br.ui:createCheckbox(section, "Asphyxiate")
            br.ui:createText(section, "Death Grip can be configured in the General section")
        br.ui:checkSectionState(section)
        ----------------------
        --- TOGGLE OPTIONS --- -- Define Toggle Options
        ----------------------
        section = br.ui:createSection(br.ui.window.profile, "Toggle Keys")
            -- Single/Multi Toggle
            br.ui:createDropdown(section, "Rotation Mode", br.dropOptions.Toggle, 4)
            --Cooldown Key Toggle
            br.ui:createDropdown(section, "Cooldown Mode", br.dropOptions.Toggle, 3)
            --Defensive Key Toggle
            br.ui:createDropdown(section, "Defensive Mode", br.dropOptions.Toggle, 6)
            -- Interrupts Key Toggle
            br.ui:createDropdown(section, "Interrupt Mode", br.dropOptions.Toggle, 6)
            -- Pause Toggle
            br.ui:createDropdown(section, "Pause Mode", br.dropOptions.Toggle, 6)
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
-- BR API Locals
local buff
local cast
local cd
local charges
local debuff
local enemies
local module
local power
local talent
local ui
local unit
local units
local var = {}
-- Profile Specific Locals
local actionList = {}
var.haltProfile = false
var.profileStop = false
-- Custom Variables
var.boneShieldRefreshValue = 7
var.heartbreaker = 0
var.rpDeficitThreshold = 15
var.playerLevel = 0

-- Level Requirements for Abilities
local levelRequirements = {
    -- Basic Abilities
    autoAttack = 1,
    bloodPlague = 1, -- Available through skills like Blood Boil
    heartStrike = 10,
    deathStrike = 10,
    bloodBoil = 10,
    marrowrend = 10,
    deathsCaress = 15,
    deathGrip = 25,
    antiMagicShell = 22,
    mindFreeze = 33,
    iceboundFortitude = 38,
    vampiricBlood = 55,
    dancingRuneWeapon = 57,
    bloodTap = 58,
    consumption = 60,
    bonestorm = 60,
    tombstone = 60,
    runeTap = 60,
    abominationLimb = 60,
    soulReaper = 60,
    asphyxiate = 60,
    blooddrinker = 60,
    raiseDead = 60,
    reapersmark = 70
}

--------------------
--- Action Lists ---
--------------------
-- Action List - Extra
actionList.Extra = function()
    -- Death Grip as Taunt or Both (modes 3 or 4)
    local gripMode = br.data.settings[br.selectedSpec][br.selectedProfile]["Death Grip Usage"] or 3
    if cast.able.deathGrip() and var.playerLevel >= levelRequirements.deathGrip and (gripMode == 3 or gripMode == 4) then
        for i = 1, #enemies.yards40 do
            local thisUnit = enemies.yards40[i]
            local shouldGrip = false
            
            -- Range check
            local gripRange = br.data.settings[br.selectedSpec][br.selectedProfile]["Death Grip Range"] or 25
            if unit.distance(thisUnit) > 8 and unit.distance(thisUnit) < gripRange then
                -- Check target priority based on selection
                local targetPriority = br.data.settings[br.selectedSpec][br.selectedProfile]["Death Grip Target"] or 1
                if targetPriority == 1 then -- Any target
                    shouldGrip = true
                elseif targetPriority == 2 and unit.isCaster(thisUnit) then -- Caster priority
                    shouldGrip = true
                elseif targetPriority == 3 and unit.isHealer(thisUnit) then -- Healer priority
                    shouldGrip = true
                end
                
                -- Valid target found, cast Death Grip
                if shouldGrip then
                    if cast.deathGrip(thisUnit) then ui.debug("Casting Death Grip [Taunt]") return true end
                end
            end
        end
    end
end -- End Action List - Extra

-- Action List - Defensive
actionList.Defensive = function()
    if ui.mode.defensive == 1 then
        -- Basic Healing Module
        module.BasicHealing()
        
        -- Anti-Magic Shell - Available at level 22
        if ui.checked("Anti-Magic Shell") and cast.able.antiMagicShell() and var.playerLevel >= levelRequirements.antiMagicShell then
            for i = 1, #enemies.yards30 do
                local thisUnit = enemies.yards30[i]
                if unit.isCasting(thisUnit) and unit.isUnit(thisUnit, "target") then
                    if cast.antiMagicShell() then ui.debug("Casting Anti-Magic Shell [Defensive]") return true end
                end
            end
        end
        
        -- Vampiric Blood - Available at level 55
        if ui.checked("Vampiric Blood") and cast.able.vampiricBlood() and var.playerLevel >= levelRequirements.vampiricBlood and unit.hp() <= ui.value("Vampiric Blood") then
            if cast.vampiricBlood() then ui.debug("Casting Vampiric Blood [Defensive]") return true end
        end
        
        -- Icebound Fortitude - Available at level 38
        if ui.checked("Icebound Fortitude") and cast.able.iceboundFortitude() and var.playerLevel >= levelRequirements.iceboundFortitude and unit.hp() <= ui.value("Icebound Fortitude") then
            if cast.iceboundFortitude() then ui.debug("Casting Icebound Fortitude [Defensive]") return true end
        end
        
        -- Death Strike Low HP - Available at level 10
        if ui.checked("Death Strike Low HP") and cast.able.deathStrike() and var.playerLevel >= levelRequirements.deathStrike and unit.hp() <= ui.value("Death Strike Low HP") then
            if cast.deathStrike() then ui.debug("Casting Death Strike [Defensive - Low HP]") return true end
        end
        
        -- Death Strike High RP - Available at level 10
        if ui.checked("Death Strike High RP") and cast.able.deathStrike() and var.playerLevel >= levelRequirements.deathStrike and power.runicPower.percent() >= ui.value("Death Strike High RP") then
            if cast.deathStrike() then ui.debug("Casting Death Strike [Defensive - High RP]") return true end
        end
        
        -- Tombstone - Available at level 60
        if ui.checked("Tombstone") and cast.able.tombstone() and var.playerLevel >= levelRequirements.tombstone and unit.hp() <= ui.value("Tombstone") and buff.boneShield.stack() >= 5 then
            if cast.tombstone() then ui.debug("Casting Tombstone [Defensive]") return true end
        end
    end
end -- End Action List - Defensive

-- Action List - Interrupts
actionList.Interrupts = function()
    if ui.mode.interrupt == 1 then
        for i = 1, #enemies.yards30 do
            local thisUnit = enemies.yards30[i]
            if unit.interruptable(thisUnit, ui.value("Interrupt At")) then
                -- Death Grip as interrupt (mode 2 or mode 4) - Available at level 25
                local gripMode = br.data.settings[br.selectedSpec][br.selectedProfile]["Death Grip Usage"] or 3
                local gripRange = br.data.settings[br.selectedSpec][br.selectedProfile]["Death Grip Range"] or 25
                if (gripMode == 2 or gripMode == 4) and 
                   cast.able.deathGrip(thisUnit) and var.playerLevel >= levelRequirements.deathGrip and 
                   unit.distance(thisUnit) > 8 and unit.distance(thisUnit) < gripRange 
                then
                    if cast.deathGrip(thisUnit) then ui.debug("Casting Death Grip [Interrupt]") return true end
                end
                -- Mind Freeze - Available at level 33
                if ui.checked("Mind Freeze") and cast.able.mindFreeze(thisUnit) and var.playerLevel >= levelRequirements.mindFreeze and unit.distance(thisUnit) < 15 then
                    if cast.mindFreeze(thisUnit) then ui.debug("Casting Mind Freeze [Interrupt]") return true end
                end
                -- Asphyxiate - Available at level 60
                if ui.checked("Asphyxiate") and cast.able.asphyxiate(thisUnit) and var.playerLevel >= levelRequirements.asphyxiate and unit.distance(thisUnit) < 20 then
                    if cast.asphyxiate(thisUnit) then ui.debug("Casting Asphyxiate [Interrupt]") return true end
                end
            end
        end
    end
end -- End Action List - Interrupts

-- Action List - Cooldowns
actionList.Cooldowns = function()
    if (ui.mode.cooldown == 1 and unit.exists("target") and unit.isBoss("target")) or ui.mode.cooldown == 2 then
        -- Module - Combat Potion Up
        module.CombatPotionUp()
        
        -- Reaper's Mark (if available) - Level 70 ability
        if cast.able.reapersmark() and var.playerLevel >= levelRequirements.reapersmark then
            if cast.reapersmark() then ui.debug("Casting Reaper's Mark [Cooldown]") return true end
        end
        
        -- Dancing Rune Weapon - Available at level 57
        if ui.checked("Dancing Rune Weapon") and cast.able.dancingRuneWeapon() and var.playerLevel >= levelRequirements.dancingRuneWeapon then
            if cast.dancingRuneWeapon() then ui.debug("Casting Dancing Rune Weapon [Cooldown]") return true end
        end
        
        -- Bonestorm (with conditions) - Available at level 60
        if ui.checked("Bonestorm") and cast.able.bonestorm() and var.playerLevel >= levelRequirements.bonestorm and buff.boneShield.stack() >= 5 and buff.deathAndDecay.exists() then
            if cast.bonestorm() then ui.debug("Casting Bonestorm [Cooldown]") return true end
        end
        
        -- Tombstone (with conditions) - Available at level 60
        if cast.able.tombstone() and var.playerLevel >= levelRequirements.tombstone and buff.boneShield.stack() >= 8 and buff.deathAndDecay.exists() and cd.dancingRuneWeapon.remains() >= 25 then
            if cast.tombstone() then ui.debug("Casting Tombstone [Cooldown]") return true end
        end
        
        -- Abomination Limb (when not in DRW) - Available at level 60
        if ui.checked("Abomination Limb") and cast.able.abominationLimb() and var.playerLevel >= levelRequirements.abominationLimb and not buff.dancingRuneWeapon.exists() then
            if cast.abominationLimb() then ui.debug("Casting Abomination Limb [Cooldown]") return true end
        end
    end
end -- End Action List - Cooldowns

-- Action List - PreCombat
actionList.PreCombat = function()
    if not unit.inCombat() and not (unit.flying() or unit.mounted() or unit.taxi()) then -- Only run when not in combat and not flying/mounted/taxi
        -- Module - Phial Up
        module.PhialUp()
        
        -- Module - Imbue Up
        module.ImbueUp()
        
        -- Pre-pull Logic
        if ui.checked("Pre-Pull Timer") and ui.pullTimer() <= ui.value("Pre-Pull Timer") then
            -- Death's Caress (from SimC APL) - Available at level 15
            if cast.able.deathsCaress() and var.playerLevel >= levelRequirements.deathsCaress then
                if cast.deathsCaress() then ui.debug("Casting Death's Caress [Pre-Combat]") return true end
            end
        end -- End Pre-Pull
        
        if unit.valid("target") then -- Abilities below this only used when target is valid
            -- Death Grip - Available at level 25
            local gripMode = br.data.settings[br.selectedSpec][br.selectedProfile]["Death Grip Usage"] or 3
            if (gripMode == 3 or gripMode == 4) and 
               cast.able.deathGrip("target") and var.playerLevel >= levelRequirements.deathGrip and 
               not unit.isDummy("target") and unit.distance("target") > 8 and 
               unit.distance("target") < (br.data.settings[br.selectedSpec][br.selectedProfile]["Death Grip Range"] or 25) and 
               (not unit.moving("target") or (unit.moving("target") and not unit.facing("target", "player")))
            then
                if cast.deathGrip("target") then ui.debug("Casting Death Grip [Pre-Combat]") return true end
            end
            
            -- Start Attack
            if unit.distance("target") < 5 then -- Starts attacking if enemy is within 5yrds
                if cast.able.autoAttack("target") then
                    if cast.autoAttack("target") then ui.debug("Casting Auto Attack [Pre-Combat]") return true end
                end
            end
        end -- End Has Target check
    end -- End No Combat
end -- End Action List - PreCombat

-- Action List - Racials
actionList.Racials = function()
    -- Blood Fury
    if unit.race() == "Orc" and cast.able.bloodFury() and buff.dancingRuneWeapon.exists() then
        if cast.bloodFury() then ui.debug("Casting Blood Fury [Racials]") return true end
    end
    -- Berserking
    if unit.race() == "Troll" and cast.able.berserking() and buff.dancingRuneWeapon.exists() then
        if cast.berserking() then ui.debug("Casting Berserking [Racials]") return true end
    end
    -- Ancestral Call
    if unit.race() == "MagharOrc" and cast.able.ancestralCall() and buff.dancingRuneWeapon.exists() then
        if cast.ancestralCall() then ui.debug("Casting Ancestral Call [Racials]") return true end
    end
    -- Fireblood
    if unit.race() == "DarkIronDwarf" and cast.able.fireblood() and buff.dancingRuneWeapon.exists() then
        if cast.fireblood() then ui.debug("Casting Fireblood [Racials]") return true end
    end
    -- Arcane Torrent
    if unit.race() == "BloodElf" and cast.able.racial() and power.runicPower.deficit() > 20 then
        if cast.racial() then ui.debug("Casting Arcane Torrent [RP Generator]") return true end
    end
end -- End Action List - Racials

-- Action List - Standard APL (Deathbringer)
actionList.Deathbringer = function()
    -- Death Strike - Avoid capping RP - Available at level 10
    if cast.able.deathStrike() and var.playerLevel >= levelRequirements.deathStrike and power.runicPower.deficit() < var.rpDeficitThreshold then
        if cast.deathStrike() then ui.debug("Casting Death Strike [RP Management]") return true end
    end
    
    -- Marrowrend to maintain Bone Shield - Available at level 10
    if cast.able.marrowrend() and var.playerLevel >= levelRequirements.marrowrend and buff.boneShield.stack() < var.boneShieldRefreshValue then
        if cast.marrowrend() then ui.debug("Casting Marrowrend [Bone Shield]") return true end
    end
    
    -- Blood Boil during Dancing Rune Weapon - Blood Boil available at level 10, DRW at 57
    if cast.able.bloodBoil() and var.playerLevel >= levelRequirements.bloodBoil and buff.dancingRuneWeapon and buff.dancingRuneWeapon.exists() then
        if cast.bloodBoil() then ui.debug("Casting Blood Boil [DRW]") return true end
    end
    
    -- Soul Reaper on target - Available at level 60
    if cast.able.soulReaper() and var.playerLevel >= levelRequirements.soulReaper and cd.dancingRuneWeapon.remains() > 0 then
        if cast.soulReaper() then ui.debug("Casting Soul Reaper [Combat]") return true end
    end
    
    -- Blooddrinker if not in DRW and few enemies - Available at level 60
    if cast.able.blooddrinker() and var.playerLevel >= levelRequirements.blooddrinker and not (buff.dancingRuneWeapon and buff.dancingRuneWeapon.exists()) and (not enemies.yards8 or #enemies.yards8 <= 2) then
        if cast.blooddrinker() then ui.debug("Casting Blooddrinker [Combat]") return true end
    end
    
    -- Death Strike (regular usage) - Available at level 10
    if cast.able.deathStrike() and var.playerLevel >= levelRequirements.deathStrike then
        if cast.deathStrike() then ui.debug("Casting Death Strike [Regular]") return true end
    end
    
    -- Consumption - Available at level 60
    if cast.able.consumption() and var.playerLevel >= levelRequirements.consumption then
        if cast.consumption() then ui.debug("Casting Consumption [Combat]") return true end
    end
    
    -- Blood Boil with high charges - Available at level 10
    if cast.able.bloodBoil() and var.playerLevel >= levelRequirements.bloodBoil and charges.bloodBoil and charges.bloodBoil.count and charges.bloodBoil.count() >= 1 then
        if cast.bloodBoil() then ui.debug("Casting Blood Boil [Charges]") return true end
    end
    
    -- Heart Strike with available runes - Available at level 10
    if cast.able.heartStrike() and var.playerLevel >= levelRequirements.heartStrike then
        local runeAmount = 0
        if power.runes and power.runes.amount and type(power.runes.amount) == "function" then
            runeAmount = power.runes.amount()
        end
        if runeAmount >= 1 then
            if cast.heartStrike() then ui.debug("Casting Heart Strike [Combat]") return true end
        end
    end
    
    -- Blood Boil as filler - Available at level 10
    if cast.able.bloodBoil() and var.playerLevel >= levelRequirements.bloodBoil then
        if cast.bloodBoil() then ui.debug("Casting Blood Boil [Filler]") return true end
    end
    
    -- Heart Strike as absolute filler - Available at level 10
    if cast.able.heartStrike() and var.playerLevel >= levelRequirements.heartStrike then
        if cast.heartStrike() then ui.debug("Casting Heart Strike [Filler]") return true end
    end
    
    -- Death's Caress to build Bone Shield - Available at level 15
    if cast.able.deathsCaress() and var.playerLevel >= levelRequirements.deathsCaress and buff.boneShield.stack() < 11 then
        if cast.deathsCaress() then ui.debug("Casting Death's Caress [Bone Shield]") return true end
    end
end -- End Action List - Deathbringer

-- Action List - Sanlayn APL 
actionList.Sanlayn = function()
    -- Heart Strike with Infliction of Sorrow (check if buff exists first) - Level 10
    if cast.able.heartStrike() and var.playerLevel >= levelRequirements.heartStrike and buff.inflictionOfSorrow and buff.inflictionOfSorrow.exists() then
        if cast.heartStrike() then ui.debug("Casting Heart Strike [Infliction of Sorrow]") return true end
    end
    
    -- Heart Strike with Vampiric Strike (check if buff exists first) - Level 10
    if cast.able.heartStrike() and var.playerLevel >= levelRequirements.heartStrike and buff.vampiricStrike and buff.vampiricStrike.exists() then
        if cast.heartStrike() then ui.debug("Casting Heart Strike [Vampiric Strike]") return true end
    end
    
    -- Blooddrinker when not in DRW - Level 60
    if cast.able.blooddrinker() and var.playerLevel >= levelRequirements.blooddrinker and not (buff.dancingRuneWeapon and buff.dancingRuneWeapon.exists()) and (not enemies.yards8 or #enemies.yards8 <= 2) then
        if cast.blooddrinker() then ui.debug("Casting Blooddrinker [Sanlayn]") return true end
    end
    
    -- Death Strike for RP management - Level 10
    if cast.able.deathStrike() and var.playerLevel >= levelRequirements.deathStrike and power.runicPower.deficit() < var.rpDeficitThreshold then
        if cast.deathStrike() then ui.debug("Casting Death Strike [RP Management]") return true end
    end
    
    -- Marrowrend for Bone Shield - Level 10
    if cast.able.marrowrend() and var.playerLevel >= levelRequirements.marrowrend and buff.boneShield.stack() < var.boneShieldRefreshValue and power.runicPower.deficit() > 20 then
        if cast.marrowrend() then ui.debug("Casting Marrowrend [Bone Shield]") return true end
    end
    
    -- Death Strike - Level 10
    if cast.able.deathStrike() and var.playerLevel >= levelRequirements.deathStrike then
        if cast.deathStrike() then ui.debug("Casting Death Strike [Sanlayn]") return true end
    end
    
    -- Heart Strike with spare runes - Level 10
    if cast.able.heartStrike() and var.playerLevel >= levelRequirements.heartStrike then
        local runeAmount = 0
        if power.runes and power.runes.amount and type(power.runes.amount) == "function" then
            runeAmount = power.runes.amount()
        end
        if runeAmount > 1 then
            if cast.heartStrike() then ui.debug("Casting Heart Strike [Spare Runes]") return true end
        end
    end
    
    -- Consumption - Level 60
    if cast.able.consumption() and var.playerLevel >= levelRequirements.consumption then
        if cast.consumption() then ui.debug("Casting Consumption [Sanlayn]") return true end
    end
    
    -- Blood Boil - Level 10
    if cast.able.bloodBoil() and var.playerLevel >= levelRequirements.bloodBoil then
        if cast.bloodBoil() then ui.debug("Casting Blood Boil [Sanlayn]") return true end
    end
    
    -- Heart Strike filler - Level 10
    if cast.able.heartStrike() and var.playerLevel >= levelRequirements.heartStrike then
        if cast.heartStrike() then ui.debug("Casting Heart Strike [Sanlayn Filler]") return true end
    end
end -- End Action List - Sanlayn

-- Action List - High Priority Actions
actionList.HighPriority = function()
    -- Blood Tap (if low on runes and charges available) - Available at level 58
    if cast.able.bloodTap() and var.playerLevel >= levelRequirements.bloodTap then
        local runeAmount = 0
        if power.runes and power.runes.amount and type(power.runes.amount) == "function" then
            runeAmount = power.runes.amount()
        end
        local tapCharges = 0
        if charges.bloodTap and charges.bloodTap.count and type(charges.bloodTap.count) == "function" then
            tapCharges = charges.bloodTap.count()
        end
        
        if runeAmount <= 2 and tapCharges >= 1 then
            if cast.bloodTap() then ui.debug("Casting Blood Tap [High Priority]") return true end
        end
    end
    
    -- Raise Dead - Available at level 60
    if cast.able.raiseDead() and var.playerLevel >= levelRequirements.raiseDead then 
        if cast.raiseDead() then ui.debug("Casting Raise Dead [High Priority]") return true end
    end
    
    -- Death's Caress if Bone Shield about to expire - Available at level 15
    if cast.able.deathsCaress() and var.playerLevel >= levelRequirements.deathsCaress and buff.boneShield.remains() < unit.gcd(true) * 2 then
        if cast.deathsCaress() then ui.debug("Casting Death's Caress [High Priority]") return true end
    end
    
    -- Death Strike if Coagulopathy buff about to expire - Available at level 10
    if cast.able.deathStrike() and var.playerLevel >= levelRequirements.deathStrike and buff.coagulopathy and buff.coagulopathy.exists and buff.coagulopathy.exists() and buff.coagulopathy.remains and buff.coagulopathy.remains() <= unit.gcd(true) * 2 then
        if cast.deathStrike() then ui.debug("Casting Death Strike [Coagulopathy]") return true end
    end
    
    -- Death and Decay - Always available
    if cast.able.deathAndDecay("target", "ground") and (not buff.deathAndDecay or not buff.deathAndDecay.exists()) then
        if cast.deathAndDecay("target", "ground") then ui.debug("Casting Death and Decay [High Priority]") return true end
    end
    
    -- Blood Boil if Blood Plague about to expire - Available at level 10
    if cast.able.bloodBoil() and var.playerLevel >= levelRequirements.bloodBoil and debuff.bloodPlague and unit.valid("target") and debuff.bloodPlague.exists and debuff.bloodPlague.exists("target") and debuff.bloodPlague.remains and debuff.bloodPlague.remains("target") < unit.gcd(true) * 2 then
        if cast.bloodBoil() then ui.debug("Casting Blood Boil [Blood Plague]") return true end
    end
    
    -- Soul Reaper on low health enemy - Available at level 60
    if cast.able.soulReaper() and var.playerLevel >= levelRequirements.soulReaper and enemies.yards8 and #enemies.yards8 > 0 and unit.exists("target") and unit.hp("target") <= 35 and unit.ttd("target") > 5 then
        if cast.soulReaper() then ui.debug("Casting Soul Reaper [Execute]") return true end
    end
    
    -- Rune Tap with excess runes - Available at level 60
    if cast.able.runeTap() and var.playerLevel >= levelRequirements.runeTap then
        local runeAmount = 0
        if power.runes and power.runes.amount and type(power.runes.amount) == "function" then
            runeAmount = power.runes.amount()
        end
        if runeAmount > 3 then
            if cast.runeTap() then ui.debug("Casting Rune Tap [High Priority]") return true end
        end
    end
end -- End Action List - High Priority

----------------
--- ROTATION ---
----------------
local function runRotation()
    -----------------------------
    --- INITIALIZATION  START ---
    -----------------------------
    -- Define and Initialize Locals
    buff                                                = br.player.buff
    cast                                                = br.player.cast
    cd                                                  = br.player.cd
    charges                                             = br.player.charges
    debuff                                              = br.player.debuff
    enemies                                             = br.player.enemies
    module                                              = br.player.module
    power                                               = br.player.power
    talent                                              = br.player.talent
    ui                                                  = br.player.ui
    unit                                                = br.player.unit
    units                                               = br.player.units
    var.haltProfile                                     = false
    
    -- Get player level
    var.playerLevel = unit.level()
    
    -- Output debug info if enabled
    if ui.checked("Show Debug Info") then
        ui.debug("Player Level: " .. tostring(var.playerLevel))
        
        -- Output current available spells based on level
        ui.debug("Available Core Abilities: " .. 
            (var.playerLevel >= levelRequirements.heartStrike and "Heart Strike, " or "") ..
            (var.playerLevel >= levelRequirements.bloodBoil and "Blood Boil, " or "") ..
            (var.playerLevel >= levelRequirements.deathStrike and "Death Strike, " or "") ..
            (var.playerLevel >= levelRequirements.marrowrend and "Marrowrend, " or "") ..
            (var.playerLevel >= levelRequirements.deathsCaress and "Death's Caress, " or "") ..
            "Basic Attacks")
            
        -- Output defensive abilities
        ui.debug("Available Defensives: " .. 
            (var.playerLevel >= levelRequirements.antiMagicShell and "Anti-Magic Shell, " or "") ..
            (var.playerLevel >= levelRequirements.iceboundFortitude and "Icebound Fortitude, " or "") ..
            (var.playerLevel >= levelRequirements.vampiricBlood and "Vampiric Blood, " or "") ..
            "Basic Defenses")
    end

    -- Update variables
    if talent.heartbreaker then
        var.heartbreaker = 1
    else
        var.heartbreaker = 0
    end
    
    -- RP Deficit Threshold calculation - Base value
    var.rpDeficitThreshold = 15
    
    -- Talent adjustments
    if talent.relishInBlood then var.rpDeficitThreshold = var.rpDeficitThreshold + 10 end
    if talent.runicAttenuation then var.rpDeficitThreshold = var.rpDeficitThreshold + 3 end
    
    -- Enemies count adjustment - safely check if table exists and has elements
    if talent.heartbreaker and enemies.yards8 and #enemies.yards8 > 0 then 
        var.rpDeficitThreshold = var.rpDeficitThreshold + (#enemies.yards8 * 2)
    end
    
    -- Units
    units.get(5) -- Makes a variable called, units.dyn5
    units.get(8) -- Makes a variable called, units.dyn8
    units.get(15) -- Makes a variable called, units.dyn15
    units.get(30) -- Makes a variable called, units.dyn30
    units.get(40) -- Makes a variable called, units.dyn40
    
    -- Enemies
    enemies.get(5) -- Makes a variable called, enemies.yards5
    enemies.get(8) -- Makes a variable called, enemies.yards8
    enemies.get(10) -- Makes a variable called, enemies.yards10
    enemies.get(15) -- Makes a variable called, enemies.yards15
    enemies.get(20) -- Makes a variable called, enemies.yards20
    enemies.get(30) -- Makes a variable called, enemies.yards30
    enemies.get(40) -- Makes a variable called, enemies.yards40
    
    -- Profile Stop | Pause
    if not unit.inCombat() and not unit.exists("target") and var.profileStop then -- Reset profile stop once stopped
        var.profileStop = false
    elseif (unit.inCombat() and var.profileStop) or ui.pause() or unit.mounted() or unit.flying() or ui.mode.rotation == 2 then -- If profile triggered to stop go here until it has.
        return true
    end
    
    ---------------------------
    --- INITIALIZATION END ---
    ---------------------------
    
    -- Run Actionlists
    --------------
    --- Extras ---
    --------------
    if actionList.Extra() then return true end
    
    -----------------
    --- Defensive ---
    -----------------
    if actionList.Defensive() then return true end
    
    ------------------
    --- Pre-Combat ---
    ------------------
    if actionList.PreCombat() then return true end
    
    -----------------
    --- In Combat ---
    -----------------
    if unit.inCombat() and unit.valid("target") and not var.profileStop then
        ------------------
        --- Interrupts ---
        ------------------
        if actionList.Interrupts() then return true end
        
        --------------
        --- Main ----
        --------------
        -- Auto Attack
        if cast.able.autoAttack("target") and unit.distance("target") < 5 then
            if cast.autoAttack("target") then ui.debug("Casting Auto Attack [Combat]") return true end
        end
        
        -- Vampiric Blood when not active
        if ui.checked("Vampiric Blood") and cast.able.vampiricBlood() and var.playerLevel >= levelRequirements.vampiricBlood and not buff.vampiricBlood.exists() then
            if cast.vampiricBlood() then ui.debug("Casting Vampiric Blood [Combat]") return true end
        end
        
        -- Racial Abilities
        if actionList.Racials() then return true end
        
        -- Cooldowns
        if actionList.Cooldowns() then return true end
        
        -- High Priority Actions
        if actionList.HighPriority() then return true end
        
        -- Main Rotation based on selected Hero Tree
        local heroTree = br.data.settings[br.selectedSpec][br.selectedProfile]["HeroTree"] or 1
        if heroTree == 1 then
            -- Deathbringer APL
            if actionList.Deathbringer() then return true end
        else
            -- Sanlayn APL
            if actionList.Sanlayn() then return true end
        end
    end -- End In Combat Rotation
end -- End runRotation

local id = 250 -- Blood Death Knight spec ID
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})