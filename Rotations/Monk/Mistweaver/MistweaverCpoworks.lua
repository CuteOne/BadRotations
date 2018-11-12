local rotationName = "Cpoworks" -- Change to name of profile listed in options drop down

---------------
--- Toggles ---
---------------
local function createToggles() -- Define custom toggles
-- Rotation Button
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell.spinningCraneKick },
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.spinningCraneKick },
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.tigerPalm },
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.effuse}
    };
    CreateButton("Rotation",1,0)
-- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.revival },
        [2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.revival },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.revival }
    };
    CreateButton("Cooldown",2,0)
-- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.dampenHarm },
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.dampenHarm }
    };
    CreateButton("Defensive",3,0)
-- Interrupt Button
    InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.legSweep },
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.legSweep }
    };
    CreateButton("Interrupt",4,0)
end

---------------
--- OPTIONS ---
---------------
local function createOptions()
    local optionTable

    local function rotationOptions()
        -----------------------
        --- GENERAL OPTIONS --- -- Define General Options
        -----------------------
        section = br.ui:createSection(br.ui.window.profile,  "General")
            br.ui:createCheckbox(section, "Boss Helper")
            --Healing Elixir
            br.ui:createSpinner(section, "Healing Elixir",  45,  0,  100,  5,  "Health Percent to Cast At")
            --Enveloping Mists
            br.ui:createSpinner(section, "Mana Tea",  70,  0,  100,  5,  "Mana Percent to Cast At")
            --Detox
            br.ui:createCheckbox(section, "Detox")
            --br.ui:createDropdownWithout(section, "Detox Mode", {"|cffFFFFFFMouseover","|cffFFFFFFRaid"}, 1, "|cffFFFFFFDetox usage.")
        br.ui:checkSectionState(section)
        -------------------------
        --- INTERRUPT OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
        --Quaking Palm
            br.ui:createCheckbox(section, "Quaking Palm")
        -- Paralysis
            br.ui:createCheckbox(section, "Paralysis")
        -- Leg Sweep
            br.ui:createCheckbox(section, "Leg Sweep")
        -- Interrupt Percentage
            br.ui:createSpinner(section,  "InterruptAt",  0,  0,  95,  5,  "|cffFFBB00Cast Percentage to use at.")
        br.ui:checkSectionState(section)
        -------------------------
        ---- SINGLE TARGET ------
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Single Target Healing")
            --Life Cocoon
            br.ui:createSpinner(section, "Life Cocoon",  30,  0,  100,  5,  "Health Percent to Cast At")
            --br.ui:createDropdownWithout(section, "Life Cocoon Mode", {"|cffFFFFFFTanks","|cffFFFFFFEveryone"}, 1, "|cffFFFFFFLife Cocoon usage.")
            --Thunder Focus Tea
            br.ui:createSpinner(section, "Thunder Focus Tea",  50,  0,  100,  5,  "Health Percent to Cast At")
            --Renewing Mist
            br.ui:createSpinner(section, "Renewing Mist",  99,  0,  100,  1,  "Health Percent to Cast At")
            --Enveloping Mists
            br.ui:createSpinner(section, "Enveloping Mist",  70,  0,  100,  5,  "Health Percent to Cast At")
            --Sheiluns Gift
            --[Prioritize free cast sheiulns gift]
            br.ui:createSpinner(section, "Sheiluns Gift",  80,  0,  100,  5,  "Health Percent to Cast At")
            --Effuse
            br.ui:createSpinner(section, "Effuse",  85,  0,  100,  5,  "Health Percent to Cast At")
            --Vivify
            br.ui:createSpinner(section, "Vivify",  60,  0,  100,  5,  "Health Percent to Cast At")
        br.ui:checkSectionState(section)
        -------------------------
        ------ AOE HEALING ------
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "AOE Healing")
            -- Essence Font
            br.ui:createSpinner(section, "Essence Font",  80,  0,  100,  5,  "Health Percent to Cast At")
            br.ui:createSpinner(section, "EF Targets",  6,  0,  40,  1,  "Minimum Essence Font Targets")
            -- Revival
            br.ui:createSpinner(section, "Revival",  60,  0,  100,  5,  "Health Percent to Cast At")
            br.ui:createSpinner(section, "Revival Targets",  5,  0,  40,  1,  "Minimum Revival Targets")
            --ChiJI
            br.ui:createSpinner(section, "Chi Ji",  80,  0,  100,  5,  "Health Percent to Cast At")
            br.ui:createSpinner(section, "Chi Ji Targets",  5,  0,  40,  1,  "Minimum Revival Targets")
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
    if br.timer:useTimer("debugMistweaver", 0.1) then --change "debugFury" to "debugSpec" (IE: debugFire)
        --Print("Running: "..rotationName)

---------------
--- Toggles --- -- List toggles here in order to update when pressed
---------------
        UpdateToggle("Rotation",0.25)
        UpdateToggle("Cooldown",0.25)
        UpdateToggle("Defensive",0.25)
        UpdateToggle("Interrupt",0.25)
--------------
--- Locals ---
--------------
        local artifact                                      = br.player.artifact
        local buff                                          = br.player.buff
        local cast                                          = br.player.cast
        local combatTime                                    = getCombatTime()
        local cd                                            = br.player.cd
        local charges                                       = br.player.charges
        local debuff                                        = br.player.debuff
        local enemies                                       = br.player.enemies
        local falling, swimming, flying, moving             = getFallTime(), IsSwimming(), IsFlying(), GetUnitSpeed("player")>0
        local gcd                                           = br.player.gcd
        local healPot                                       = getHealthPot()
        local inCombat                                      = br.player.inCombat
        local inInstance                                    = br.player.instance=="party"
        local inRaid                                        = br.player.instance=="raid"
        local level                                         = br.player.level
        local lowestHP                                      = br.friend[1].unit
        local mana                                          = br.player.powerPercentMana
        local mode                                          = br.player.mode
        local perk                                          = br.player.perk
        local php                                           = br.player.health
        local power, powmax, powgen                         = br.player.power.mana.amount(), br.player.power.mana.max(), br.player.power.mana.regen()
        local pullTimer                                     = br.DBM:getPulltimer()
        local race                                          = br.player.race
        local racial                                        = br.player.getRacial()
        local spell                                         = br.player.spell
        local talent                                        = br.player.talent
        local ttm                                           = br.player.power.mana.ttm()
        local units                                         = br.player.units

        local lowest                                        = {}    --Lowest Unit
        lowest.hp                                           = br.friend[1].hp
        lowest.role                                         = br.friend[1].role
        lowest.unit                                         = br.friend[1].unit
        lowest.range                                        = br.friend[1].range
        lowest.guid                                         = br.friend[1].guid
        local tank                                          = {}    --Tank
        local averageHealth                                 = 100

        if leftCombat == nil then leftCombat = GetTime() end
        if profileStop == nil then profileStop = false end

--------------------
--- Action Lists ---
--------------------

-----------------
--- Rotations ---
-----------------
---------------------------------
--- Out Of Combat - Rotations ---
---------------------------------
        if not inCombat and GetObjectExists("target") and not UnitIsDeadOrGhost("target") and UnitCanAttack("target", "player") then

        end -- End Out of Combat Rotation
-----------------------------
--- In Combat - Rotations ---
-----------------------------
    -- Action List - Interrupts
            if useInterrupts() then
                for i=1, #getEnemies("player",20) do
                    thisUnit = getEnemies("player",20)[i]
                    distance = getDistance(thisUnit)
                    if canInterrupt(thisUnit,getOptionValue("InterruptAt")) then
                        if distance < 5 then
        -- Quaking Palm
                            if isChecked("Quaking Palm") then
                                if cast.quakingPalm(thisUnit) then return end
                            end
        -- Leg Sweep
                            if isChecked("Leg Sweep") then
                                if cast.legSweep(thisUnit) then return end
                            end
                        end
        -- Paralysis
                        if isChecked("Paralysis") then
                            if cast.paralysis(thisUnit) then return end
                        end
                    end
                end
            end -- End Interrupt Check

        if inCombat then

            if isChecked("Healing Elixir") and talent.healingElixir then
                if php <= getValue("Healing Elixir") then
                    if cast.healingElixir("player") then return end
                end
            end

            if isChecked("Mana Tea") and talent.manaTea then
                if mana <= getValue("Mana Tea") then
                    if cast.manaTea("player") then return end
                end
            end

            -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
            --Single Target Healing----Single Target Healing----Single Target Healing----Single Target Healing----Single Target Healing----Single Target Healing----Single Target Healing--
            -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
            --Life Cocoon
            if isChecked("Life Cocoon") then
                for i = 1, #br.friend do
                    if br.friend[i].hp <= getValue("Life Cocoon") and getBuffRemain(br.friend[i].unit, spell.lifeCocoon, "player") < 1 then
                        -- if getValue("Life Cocoon Mode") == 1 and br.friend[i].role == "TANK" then
                        if cast.lifeCocoon(br.friend[i].unit) then return end
                        -- elseif getValue("Life Cocoon Mode") == 2 then
                        --     if cast.lifeCocoon(br.friend[i].unit) then return end
                        -- end
                    end
                end
            end
            --Sheilun's Gift
            --[It's free why 65%?  ]
            if isChecked("Sheiluns Gift") and GetSpellCount(205406) ~= nil then
                if GetSpellCount(205406) >= 5 then
                    if lowest.hp <= getValue("Sheiluns Gift") then
                        if cast.sheilunsGift(lowest.unit) then return end
                    end
                end
            end
            --Detox
            if isChecked("Detox") then
                -- if getValue("Detox Mode") == 1 then -- Mouseover
                --     if GetUnitExists("mouseover") and UnitCanAssist("player", "mouseover") then
                --         for i = 1, #br.friend do
                --             if br.friend[i].guid == UnitGUID("mouseover") and br.friend[i].dispel == true then
                --                 if cast.detox("mouseover") then return end
                --             end
                --         end
                --     end
                -- else
                -- if getValue("Detox Mode") == 2 then -- Raid
                    for i = 1, #br.friend do
                        for n = 1,40 do
                            local buff,_,count,bufftype,duration = UnitDebuff(br.friend[i].unit, n)
                            if buff then
                                if bufftype == "Curse" or bufftype == "Magic" or bufftype == "Poison" then
                                    if cast.detox(br.friend[i].unit) then return end
                                end
                            end
                        end
                    end
                -- end
            end
            --Thunder Focus Tea
            if isChecked("Thunder Focus Tea") then
                for i = 1, #br.friend do
                    if br.friend[i].hp <= getValue("Thunder Focus Tea") then
                        if cast.thunderFocusTea() then return end
                    end
                end
            end
            if isChecked("Thunder Focus Tea") then
                for i = 1, #br.friend do
                    if br.friend[i].hp <= getValue("Thunder Focus Tea") then
                        if buff.thunderFocusTea then
                            if cast.vivify(br.friend[i].unit) then return end
                        end
                    end
                end
            end
            --Renewing Mist
            if isChecked("Renewing Mist") then
                for i = 1, #br.friend do
                    if br.friend[i].hp <= getValue("Renewing Mist")
                    and getBuffRemain(br.friend[i].unit, spell.renewingMist, "player") < 1 then
                        if cast.renewingMist(br.friend[i].unit) then return end
                    end
                end
            end
            --Enveloping Mists
            if isChecked("Enveloping Mist")
            and not isCastingSpell(spell.envelopingMist) then
                if lowest.hp <= getValue("Enveloping Mist")
                and getBuffRemain(lowest.unit, spell.envelopingMist, "player") < 2 then
                    if cast.envelopingMist(lowest.unit) then return end
                end
            end
            --Vivify
            if isChecked("Vivify")
            and not isCastingSpell(spell.vivify) then
                -- if buff.upliftingTrance and lowest.hp <= getValue("Vivify") + 10 then
                --     if cast.vivify(lowest.unit) then return end
                -- else
                if lowest.hp <= getValue("Vivify") then
                    if cast.vivify(lowest.unit) then return end
                end
            end
            --Effuse
            if isChecked("Effuse")
            and not isCastingSpell(spell.effuse) then
                if lowest.hp <= getValue("Effuse") then
                    if cast.effuse(lowest.unit) then return end
                end
            end
            ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
            --AOE Healing----AOE Healing----AOE Healing----AOE Healing----AOE Healing----AOE Healing----AOE Healing----AOE Healing----AOE Healing----AOE Healing----AOE Healing----AOE Healing
            ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
            --Essence Font
            if isChecked("Essence Font") and not isCastingSpell(spell.essenceFont) then
                if getLowAllies(getValue("Essence Font")) >= getValue("EF Targets") then
                    if cast.essenceFont() then return end
                end
            end
            --Revival
            if isChecked("Revival") and not isCastingSpell(spell.essenceFont) then
                if getLowAllies(getValue("Revival")) >= getValue("Revival Targets") then
                    if cast.revival() then return end
                end
            end
            --Chi Ji
            if isChecked("Chi Ji") and not isCastingSpell(spell.essenceFont) then
                if getLowAllies(getValue("Chi Ji")) >= getValue("Chi Ji Targets") then
                    if cast.invokeChiJi(lowest.unit) then return end
                end
            end
        end -- End In Combat Rotation
    end -- End Timer
end -- End runRotation

                if isChecked("Boss Helper") then
                        bossHelper()
                end
local id = 270
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
