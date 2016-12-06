local rotationName = "CuteOne"

---------------
--- Toggles ---
---------------
local function createToggles()
-- Rotation Button
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell.howlingBlast },
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.howlingBlast },
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.icyTouch },
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.deathPact}
    };
    CreateButton("Rotation",1,0)
-- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.empowerRuneWeapon },
        [2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.empowerRuneWeapon },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.empowerRuneWeapon }
    };
    CreateButton("Cooldown",2,0)
-- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.iceboundFortitude },
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.iceboundFortitude }
    };
    CreateButton("Defensive",3,0)
-- Interrupt Button
    InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.mindFreeze },
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.mindFreeze }
    };
    CreateButton("Interrupt",4,0)
-- Cleave Button
    CleaveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Cleaving Enabled", tip = "Rotation will cleave targets.", highlight = 1, icon = br.player.spell.howlingBlast },
        [2] = { mode = "Off", value = 2 , overlay = "Cleaving Disabled", tip = "Rotation will not cleave targets", highlight = 0, icon = br.player.spell.icyTouch }
    };
    CreateButton("Cleave",5,0)
end

---------------
--- OPTIONS ---
---------------
local function createOptions()
    local optionTable

    local function rotationOptions()
        -----------------------
        --- GENERAL OPTIONS ---
        -----------------------
        section = br.ui:createSection(br.ui.window.profile,  "General")
            -- Dummy DPS Test
            br.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
            -- Mouseover Targeting
            br.ui:createCheckbox(section,"Mouseover Targeting","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFmouseover target validation.|cffFFBB00.")            
            -- Death Grip
            br.ui:createCheckbox(section,"Death Grip")
            -- Gorefiend's Crasp
            br.ui:createCheckbox(section,"Gorefiend's Grasp")
            -- Pre-Pull Timer
            br.ui:createSpinner(section, "Pre-Pull Timer",  5,  1,  10,  1,  "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
        br.ui:checkSectionState(section)
        ------------------------
        --- COOLDOWN OPTIONS ---
        ------------------------
        section = br.ui:createSection(br.ui.window.profile,  "Cooldowns")
            -- Legendary Ring
            br.ui:createDropdown(section,  "Legendary Ring", br.dropOptions.CD,  2, "Enable or Disable usage of Legendary Ring.")
            -- Strength Potion
            br.ui:createCheckbox(section,"Str-Pot")
            -- Flask / Crystal
            br.ui:createCheckbox(section,"Flask / Crystal")
            -- Trinkets
            br.ui:createCheckbox(section,"Trinkets")
            -- Empower Rune Weapon
            br.ui:createCheckbox(section,"Empower Rune Weapon")
        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
            -- Healthstone
            br.ui:createSpinner(section, "Healthstone",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            -- Heirloom Neck
            br.ui:createSpinner(section, "Heirloom Neck",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            -- Blood Presence
            br.ui:createSpinner(section, "Blood Presence",  75,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Death Strike
            br.ui:createSpinner(section, "Death Strike",  75,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Icebound Fortitude
            br.ui:createSpinner(section, "Icebound Fortitude",  75,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Lichbourne
            br.ui:createCheckbox(section,"Lichborne")
            -- Anti-Magic Shell/Zone
            br.ui:createSpinner(section, "Anti-Magic Zone",  75,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            br.ui:createSpinner(section, "Anti-Magic Shell",  75,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Death Pact
            br.ui:createSpinner(section, "Death Pact",  75,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Death Siphon
            br.ui:createSpinner(section, "Death Siphon",  75,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Conversion
            br.ui:createSpinner(section, "Conversion",  75,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Remorseless Winter
            br.ui:createSpinner(section, "Remorseless Winter",  75,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Desecrated Ground
            br.ui:createCheckbox(section,"Desecrated Ground")
        br.ui:checkSectionState(section)
        -------------------------
        --- INTERRUPT OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
            -- Mind Freeze
            br.ui:createCheckbox(section,"Mind Freeze")
            -- Asphyxiate
            br.ui:createCheckbox(section,"Asphyxiate")
            -- Strangulate
            br.ui:createCheckbox(section,"Strangulate")
            -- Dark Simulacrum
            br.ui:createCheckbox(section,"Dark Simulacrum")
            -- Interrupt Percentage
            br.ui:createSpinner(section,  "InterruptAt",  0,  0,  95,  5,  "|cffFFBB00Cast Percentage to use at.")
        br.ui:checkSectionState(section)
        ----------------------
        --- TOGGLE OPTIONS ---
        ----------------------
        section = br.ui:createSection(br.ui.window.profile,  "Toggle Keys")
            -- Single/Multi Toggle
            br.ui:createDropdown(section,  "Rotation Mode", br.dropOptions.Toggle,  4)
            --Cooldown Key Toggle
            br.ui:createDropdown(section,  "Cooldown Mode", br.dropOptions.Toggle,  3)
            --Defensive Key Toggle
            br.ui:createDropdown(section,  "Defensive Mode", br.dropOptions.Toggle,  6)
            -- Interrupts Key Toggle
            br.ui:createDropdown(section,  "Interrupt Mode", br.dropOptions.Toggle,  6)
            -- Cleave Toggle
            br.ui:createDropdown(section,  "Cleave Mode", br.dropOptions.Toggle,  6)
            -- Pause Toggle
            br.ui:createDropdown(section,  "Pause Mode", br.dropOptions.Toggle,  6)
        br.ui:checkSectionState(section)
    end
    optionTable = {{
        [1] = "Rotation Options",
        [2] = rotationOptions,
    }}
    return optionTable
end

----------------
--- ROTATION ---
----------------
local function runRotation()
    if br.timer:useTimer("debugFrost", 0.1) then
        --print("Running: "..rotationName)

---------------
--- Toggles ---
---------------
        UpdateToggle("Rotation",0.25)
        UpdateToggle("Cooldown",0.25)
        UpdateToggle("Defensive",0.25)
        UpdateToggle("Interrupt",0.25)
        UpdateToggle("Cleave",0.25)
--------------
--- Locals ---
--------------
        local attacktar         = UnitCanAttack("target", "player")
        local buff              = br.player.buff
        local castingSimSpell   = isSimSpell()
        local cd                = br.player.cd
        local charges           = br.player.charges
        local deadtar           = UnitIsDeadOrGhost("target") or isDummy()
        local debuff            = br.player.debuff
        local disease           = br.player.disease
        local dynTar5AoE        = br.player.units.dyn5AoE
        local dynTar30AoE       = br.player.units.dyn30AoE
        local dynTable5AoE      = (br.data['Cleave']==1 and br.enemy) or { [1] = {["unit"]=dynTar5AoE, ["distance"] = getDistance(dynTar5AoE)}} 
        local dynTable30AoE     = (br.data['Cleave']==1 and br.enemy) or { [1] = {["unit"]=dynTar30AoE, ["distance"] = getDistance(dynTar30AoE)}} 
        local glyph             = br.player.glyph
        local inCombat          = br.player.inCombat
        local level             = br.player.level
        local moving            = GetUnitSpeed("player")>0
        local oneHand, twoHand  = IsEquippedItemType("One-Hand"), IsEquippedItemType("Two-Hand")
        local party             = select(2,IsInInstance())=="party"
        local php               = br.player.health
        local power             = br.player.power
        local pullTimer         = br.DBM:getPulltimer()
        local raid              = select(2,IsInInstance())=="raid"
        local rune              = br.player.rune.count
        local runeFrac          = br.player.rune.percent
        local simSpell          = br.im.simulacrumSpell
        local solo              = select(2,IsInInstance())=="none"
        local profileStop       = false
        local swimming          = IsSwimming()
        local talent            = br.player.talent
        local thp               = getHP("target")
    -- Profile Stop
        if inCombat and profileStop==true then
            return true
        else
            profileStop=false
        end
--------------------
--- Action Lists ---
--------------------
    -- Action List - Extras
        function actionList_Extras()
        -- Dummy Test
            if isChecked("DPS Testing") then
                if GetObjectExists("target") then
                    if getCombatTime() >= (tonumber(getValue("DPS Testing"))*60) and isDummy() then
                        profileStop = true
                        StopAttack()
                        ClearTarget()
                        print(tonumber(getValue("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
                        return true
                    end
                end
            end
        end -- End Action List - Extras
    -- Action List - Utility
        function actionList_Utility()

        end -- End Action List - Utility
    -- Action List - Defensive
        function actionList_Defensive()
            if useDefensive() and not IsMounted() then

            end -- End Use Defensive Check
        end -- End Action List - Defensive
    -- Action List - Interrupts
        function actionList_Interrupts()
            if useInterrupts() then
  
            end -- End Use Interrupts Check
        end -- End Action List - Interrupts
    -- Action List - Cooldowns
        function actionList_Cooldowns()
            if useCDs() then
        -- Potion
                -- potion,name=draenic_strength,if=target.time_to_die<=30|(target.time_to_die<=60&buff.pillar_of_frost.up)
                if raid and (getTimeToDie(br.player.units.dyn5)<=30 or (getTimeToDie(br.player.units.dyn5)<=60 and buff.pillarOfFrost)) then
                    -- Draenic Strength Potion
                    if isChecked("Str-Pot") and canUse(109219) then
                        useItem(109219)
                    end
                    -- -- Commander's Draenic Strength Potion
                    -- if canUse(br.player.spell.strengthPotGarrison) then
                    --     useItem(br.player.spell.strengthPotGarrison)
                    -- end
                end
        -- Racial: Orc Blood Fury | Troll Berserking | Blood Elf Arcane Torrent
                -- blood_fury,sync=tigers_fury | berserking,sync=tigers_fury | arcane_torrent,sync=tigers_fury
                if (br.player.race == "Orc" or br.player.race == "Troll" or br.player.race == "Blood Elf") then
                    if br.player.castRacial() then return end
                end
            end -- End Use Cooldowns Check
        end -- End Action List - Cooldowns
    -- Action List - Pre-Combat
        function actionList_PreCombat()
        -- Flask / Crystal
            -- flask,type=greater_draenic_strength_flask
            if isChecked("Flask / Crystal") and not (IsFlying() or IsMounted()) then
                if (raid or solo) and not (buff.strenthFlaskLow or buff.strengthFlaskBig) then--Draenor Str Flasks
                    if not UnitBuffID("player",176151) and canUse(118922) then --Draenor Insanity Crystal
                        if br.player.useCrystal() then return end
                    end
                end
            end
        -- food,type=buttered_sturgeon
            if isChecked("Pre-Pull Timer") and pullTimer <= getOptionValue("Pre-Pull Timer") then

            end -- Pre-Pull
        -- Start Attack
            if attacktar and not deadtar and getDistance("target")<5 and not inCombat then
                StartAttack()
            end
        end -- End Action List - PreCombat
---------------------
--- Out Of Combat ---
---------------------
        if pause() or br.data['AoE']==4 then
            return true
        else
            if actionList_Extras() then return end
            if actionList_Utility() then return end
            if actionList_Defensive() then return end
            if actionList_PreCombat() then return end
            if not inCombat and ObjectExists("target") and not UnitIsDeadOrGhost("target") and UnitCanAttack("target", "player") then
                if getDistance("target")<5 then
                    StartAttack()
                end
            end
-----------------
--- In Combat ---
-----------------
            if inCombat then
            -- Auto Attack
                -- auto_attack
                if ObjectExists("target") then
                    StartAttack()
                end
                if actionList_Interrupts() then return end  
            end -- End Combat Check
        end -- End Rotation Pause
    end -- End Timer
end -- runRotation
local id = 251
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
