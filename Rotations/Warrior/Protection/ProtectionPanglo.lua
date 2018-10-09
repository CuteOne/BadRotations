local rotationName = "Panglo"

---------------
--- Toggles ---
---------------
local function createToggles()
-- Rotation Button
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of #enemies.yards8 in range.", highlight = 1, icon = br.player.spell.thunderClap },
        [2] = { mode = "Off", value = 2 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.enragedRegeneration}
    };
    CreateButton("Rotation",1,0)
-- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.battleCry },
        [2] = { mode = "On", value = 2 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.battleCry },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.battleCry }
    };
    CreateButton("Cooldown",2,0)
-- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.shieldWall },
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.shieldWall }
    };
    CreateButton("Defensive",3,0)
-- Interrupt Button
    InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.pummel },
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.pummel }
    };
    CreateButton("Interrupt",4,0)
-- Movement Button
    MoverModes = {
        [1] = { mode = "On", value = 1 , overlay = "Mover Enabled", tip = "Will use Charge/Heroic Leap.", highlight = 1, icon = br.player.spell.charge },
        [2] = { mode = "Off", value = 2 , overlay = "Mover Disabled", tip = "Will NOT use Charge/Heroic Leap.", highlight = 0, icon = br.player.spell.charge }
    };
    CreateButton("Mover",5,0)
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
            -- Berserker Rage
            br.ui:createCheckbox(section,"Berserker Rage", "Check to use Berserker Rage")
            -- Heroic Leap
            br.ui:createDropdown(section,"Heroic Leap", br.dropOptions.Toggle, 6, "Set auto usage (No Hotkey) or desired hotkey to use Heroic Leap.")
            br.ui:createDropdownWithout(section,"Heroic Leap - Target",{"Best","Target"},1,"Desired Target of Heroic Leap")
            -- Pre-Pull Timer
            br.ui:createSpinner(section, "Pre-Pull Timer",  5,  1,  10,  1,  "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
            -- High Rage Revenge
            br.ui:createSpinner(section, "High Rage Revenge", 3, 1, 10, 1, "|cffFFFFFF Set to number of units to use Revenge at when above 90 Rage.")
			-- Taunt
			br.ui:createCheckbox(section,"Taunt","|cffFFFFFFAuto Taunt usage.")
		br.ui:checkSectionState(section)
        ------------------------
        --- COOLDOWN OPTIONS ---
        ------------------------
        section = br.ui:createSection(br.ui.window.profile,  "Cooldowns")
            -- Agi Pot
            br.ui:createCheckbox(section,"Str-Pot")
            -- Flask / Crystal
            br.ui:createCheckbox(section,"Flask / Crystal")
            -- Racials
            br.ui:createCheckbox(section,"Racial")
            -- Trinkets
            br.ui:createCheckbox(section,"Trinkets")
            -- Avatar
            br.ui:createCheckbox(section,"Avatar")
            -- Avatar Spinner
            br.ui:createSpinnerWithout(section, "Avatar Mob Count",  5,  0,  10,  1,  "|cffFFFFFFEnemies to cast Avatar on.")
            -- Demoralizing Shout
            br.ui:createCheckbox(section,"Demoralizing Shout - CD")
            -- Ravager
            br.ui:createCheckbox(section,"Ravager")
            -- Shockwave
            br.ui:createCheckbox(section,"Shockwave")
        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
            -- Healthstone
            br.ui:createSpinner(section, "Healthstone/Potion",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            -- Demoralizing Shout
            br.ui:createSpinner(section, "Demoralizing Shout",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            -- Last Stand
            br.ui:createSpinner(section, "Last Stand",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            -- Rallying Cry
            br.ui:createSpinner(section, "Rallying Cry",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            -- Shield Wall
            br.ui:createSpinner(section, "Shield Wall",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            -- Shockwave
            br.ui:createSpinner(section, "Shockwave - HP", 60, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
            br.ui:createSpinner(section, "Shockwave - Units", 3, 1, 10, 1, "|cffFFBB00Minimal units to cast on.")
            -- Spell Reflection
            br.ui:createSpinner(section, "Spell Reflection",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            -- Storm Bolt
            br.ui:createSpinner(section, "Storm Bolt", 60, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
            -- Victory Rush
            br.ui:createSpinner(section, "Victory Rush", 60, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
        br.ui:checkSectionState(section)
        -------------------------
        --- INTERRUPT OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
            -- Pummel
            br.ui:createCheckbox(section,"Pummel")
            -- Intimidating Shout
            br.ui:createCheckbox(section,"Intimidating Shout - Int")
            -- Shockwave
            br.ui:createCheckbox(section,"Shockwave - Int")
            -- Storm Bolt
            br.ui:createCheckbox(section,"Storm Bolt - Int")
            -- Interrupt Percentage
            br.ui:createSpinner(section,  "InterruptAt",  0,  0,  95,  5,  "|cffFFBB00Cast Percentage to use at.")
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
    if br.timer:useTimer("debugProtection", 0.1) then
        --Print("Running: "..rotationName)

---------------
--- Toggles ---
---------------
        UpdateToggle("Rotation",0.25)
        UpdateToggle("Cooldown",0.25)
        UpdateToggle("Defensive",0.25)
        UpdateToggle("Interrupt",0.25)
        UpdateToggle("Mover",0.25)
        br.player.mode.mover = br.data.settings[br.selectedSpec].toggles["Mover"]

--------------
--- Locals ---
--------------
        local addsExist                                     = false
        local addsIn                                        = 999
        local artifact                                      = br.player.artifact
        local buff                                          = br.player.buff
        local cast                                          = br.player.cast
        local combatTime                                    = getCombatTime()
        local cd                                            = br.player.cd
        local charges                                       = br.player.charges
        local deadMouse                                     = UnitIsDeadOrGhost("mouseover")
        local deadtar, attacktar, hastar, playertar         = deadtar or UnitIsDeadOrGhost("target"), attacktar or UnitCanAttack("target", "player"), hastar or GetObjectExists("target"), UnitIsPlayer("target")
        local debuff                                        = br.player.debuff
        local enemies                                       = br.player.enemies
        local falling, swimming, flying, moving             = getFallTime(), IsSwimming(), IsFlying(), GetUnitSpeed("player")>0
        local friendly                                      = friendly or UnitIsFriend("target", "player")
        local gcd                                           = br.player.gcd
        local hasMouse                                      = GetObjectExists("mouseover")
        local healPot                                       = getHealthPot()
        local heirloomNeck                                  = 122667 or 122668
        local inCombat                                      = br.player.inCombat
        local inInstance                                    = br.player.instance=="party"
        local inRaid                                        = br.player.instance=="raid"
        local level                                         = br.player.level
        local lootDelay                                     = getOptionValue("LootDelay")
        local lowestHP                                      = br.friend[1].unit
        local mode                                          = br.player.mode
        local perk                                          = br.player.perk
        local php                                           = br.player.health
        local playerMouse                                   = UnitIsPlayer("mouseover")
        local power, powerMax, powerGen                     = br.player.power.rage.amount(), br.player.power.rage.max(), br.player.power.rage.regen()
        local pullTimer                                     = br.DBM:getPulltimer()
        local race                                          = br.player.race
        local racial                                        = br.player.getRacial()
        local rage, powerDeficit                            = br.player.power.rage.amount(), br.player.power.rage.deficit()
        local solo                                          = br.player.instance=="none"
        local spell                                         = br.player.spell
        local talent                                        = br.player.talent
        local thp                                           = getHP("target")
        local ttd                                           = getTTD
        local ttm                                           = br.player.power.rage.ttm()
        local units                                         = br.player.units

        units.get(5)
        units.get(8)
        enemies.get(5)
        enemies.get(8)
        enemies.get(30)
        enemies.get(40)

        if leftCombat == nil then leftCombat = GetTime() end
        if profileStop == nil then profileStop = false end

        -- ChatOverlay(round2(getDistance2("target"),2)..", "..round2(getDistance3("target"),2)..", "..round2(getDistance4("target"),2)..", "..round2(getDistance("target"),2))

--------------------
--- Action Lists ---
--------------------
    -- Action list - Extras
        function actionList_Extra()
            -- Berserker Rage
            if isChecked("Berserker Rage") and hasNoControl(spell.berserkerRage) then
                if cast.berserkerRage() then return end
            end
            --Taunt
          	if isChecked("Taunt") and inInstance then
          		for i = 1, #enemies.yards30 do
          			local thisUnit = enemies.yards30[i]
          			if UnitThreatSituation("player", thisUnit) ~= nil and UnitThreatSituation("player", thisUnit) <= 2 and UnitAffectingCombat(thisUnit) then
          				if cast.taunt(thisUnit) then return end
          			end
          		end
          	end

			end -- End Action List - Extra
    -- Action List - Defensive
        function actionList_Defensive()
            if useDefensive() then
            -- Healthstone/Health Potion
                if isChecked("Healthstone/Potion") and php <= getOptionValue("Healthstone/Potion")
                    and inCombat and (hasHealthPot() or hasItem(5512))
                then
                    if canUse(5512) then
                        useItem(5512)
                    elseif canUse(getHealthPot()) then
                        useItem(getHealthPot())
                    end
                end
            -- Demoralizing Shout
                -- demoralizing_shout,if=incoming_damage_2500ms>health.max*0.20
                if inCombat and isChecked("Demoralizing Shout") and php <= getOptionValue("Demoralizing Shout") then
                    if cast.demoralizingShout() then return end
                end
            -- Last Stand
                -- last_stand,if=incoming_damage_2500ms>health.max*0.50
                if inCombat and isChecked("Last Stand") and php <= getOptionValue("Last Stand") then
                    if cast.lastStand() then return end
                end
			-- Rallying Cry
				if inCombat and isChecked("Rallying Cry") and php <= getOptionValue("Rallying Cry") then
					if cast.rallyingCry() then return end
				end
            -- Shield Wall
                -- shield_wall,if=incoming_damage_2500ms>health.max*0.50&!cooldown.last_stand.remain()s=0
                if inCombat and isChecked("Shield Wall") and php <= getOptionValue("Shield Wall") and cd.lastStand.remain() > 0 then
                    if cast.shieldWall() then return end
                end
            -- Shockwave
                if inCombat and ((isChecked("Shockwave - HP") and php <= getOptionValue("Shockwave - HP")) or (isChecked("Shockwave - Units") and #enemies.yards8 >= getOptionValue("Shockwave - Units"))) then
                    if cast.shockwave() then return end
                end
            -- Spell Reflection
                -- spell_reflection,if=incoming_damage_2500ms>health.max*0.20
                if inCombat and isChecked("Spell Reflection") and php <= getOptionValue("Spell Reflection") then
                    if cast.spellReflection() then return end
                end
            -- Storm Bolt
                if inCombat and isChecked("Storm Bolt") and php <= getOptionValue("Storm Bolt") then
                    if cast.stormBolt() then return end
                end
            -- Victory Rush
                if inCombat and isChecked("Victory Rush") and php <= getOptionValue("Victory Rush") and buff.victorious.exists() then
                    if cast.victoryRush() then return end
                end
            -- Impending Victory
                if inCombat and isChecked("Victory Rush") and php <= getOptionValue("Victory Rush") then
                    if cast.victoryRush() then return end
                end

            end -- End Defensive Check
        end -- End Action List - Defensive
    -- Action List - Interrupts
        function actionList_Interrupts()
            if useInterrupts() then
                for i=1, #enemies.yards40 do
                    thisUnit = enemies.yards40[i]
                    unitDist = getDistance(thisUnit)
                    targetMe = GetUnitIsUnit("player",thisUnit) or false
                    if canInterrupt(thisUnit,getOptionValue("InterruptAt")) then
                    -- Pummel
                        if isChecked("Pummel") and unitDist < 5 then
                            if cast.pummel(thisUnit) then return end
                        end
                    -- Shockwave
                        if isChecked("Shockwave - Int") and unitDist < 10 then
                            if cast.shockwave() then return end
                        end
                    -- Storm Bolt
                        if isChecked("Storm Bolt - Int") and unitDist < 20 then
                            if cast.stormBolt() then return end
                        end
                    end
                end
            end
        end -- End Action List - Interrupts
    -- Action List - Cooldowns
        function actionList_Cooldowns()
            if useCDs() and getDistance("target") < 5 then
        -- Trinkets
                if isChecked("Trinkets") then
                    if canTrinket(13) then
                        useItem(13)
                    end
                    if canTrinket(14) then
                        useItem(14)
                    end
                end
        -- Avatar
                -- avatar,if=buff.battle_cry.up|(target.time_to_die<(cooldown.battle_cry.remain()s+10))
                if isChecked("Avatar") and (#enemies.yards8 >= getOptionValue("Avatar Mob Count")) then
                        if cast.avatar() then return end
                end
                if isChecked("Racial") then
                    if (race == "Orc" or race == "Troll") or (race == "BloodElf" and power < powerMax - 40) then
                        if castSpell("target",racial,false,false,false) then return end
                    end
                end
            end
        end
    -- Action List - Pre-Combat
        function actionList_PreCombat()
        -- Flask
            -- flask,type=greater_draenic_strength_flask
            if isChecked("Str-Pot") then
                if inRaid and canFlask and flaskBuff==0 and not UnitBuffID("player",176151) then
                    useItem(br.player.flask.wod.strengthBig)
                    return true
                end
                if flaskBuff==0 then
                    if br.player.useCrystal() then return end
                end
            end
            -- food,type=pickled_eel
            -- stance,choose=battle
            -- if not buff.battleStance and php > getOptionValue("Defensive Stance") then
            --     if br.player.castBattleStance() then return end
            -- end
            -- snapshot_stats
            -- potion,name=draenic_strength
            if useCDs() and inRaid and isChecked("Str-Pot") and isChecked("Pre-Pull Timer") and pullTimer <= getOptionValue("Pre-Pull Timer") then
                if canUse(109219) then
                    useItem(109219)
                end
            end
        end  -- End Action List - Pre-Combat
    -- Action List - Movement
        function actionList_Movement()
            if mode.mover == 1 then
        -- Charge
                -- charge
                if (cd.heroicLeap.remain() > 0 and cd.heroicLeap.remain() < 43) or level < 26 then
                    if isValidUnit("target") or (UnitIsFriend("target") and level >= 28) then
                        if level < 28 then
                            if cast.charge("target") then return end
                        else
                            if cast.intercept("target") then return end
                        end
                    end
                end
                if isValidUnit("target") then
        -- Heroic Leap
                    -- heroic_leap
                    if isChecked("Heroic Leap") and (getOptionValue("Heroic Leap")==6 or (SpecificToggle("Heroic Leap") and not GetCurrentKeyBoardFocus())) then
                        -- Best Location
                        if getOptionValue("Heroic Leap - Target")==1 then
                            if cast.heroicLeap("best",false,1,8) then return end
                        end
                        -- Target
                        if getOptionValue("Heroic Leap - Target")==2 then
                            if cast.heroicLeap("target","ground") then return end
                        end
                    end
        -- Storm Bolt
                    -- storm_bolt
                    if cast.stormBolt("target") then return end
        -- Heroic Throw
                    -- heroic_throw
                    if ((lastSpell == spell.charge or charges.charge.count() == 0) and level < 28) or ((lastSpell == spell.intercept or charges.intercept.count() == 0) and level >= 28) then
                        if cast.heroicThrow("target") then return end
                    end
                end
            end
        end
    -- Action List - Main
        function actionList_Main()
        -- Shield Block
            -- shield_block,if=!buff.neltharions_fury.up&((cooldown.shield_slam.remain()s<6&!buff.shield_block.up)|(cooldown.shield_slam.remain()s<6+buff.shield_block.remain()s&buff.shield_block.up))
            if not buff.shieldBlock.exists() and power > 30
            then
                if cast.shieldBlock() then return end
            end
        -- Demoralizing Shout
            -- demoralizing_shout,if=talent.booming_voice.enabled&buff.battle_cry.up
            if isChecked("Demoralizing Shout - CD") and powerDeficit >= 45 then
                if talent.boomingVoice then
                    if cast.demoralizingShout() then return end
                end
            end
        -- Ravager
            -- ravager,if=talent.ravager.enabled&buff.battle_cry.up
            if useCDs() and isChecked("Ravager") then
                if talent.ravager then
                    if cast.ravager("best",false,1,8) then return end
                end
            end
        -- Ignore Pain
            -- ignore_pain,if=(!talent.vengeance.enabled&buff.renewed_fury.remains<=0)|(!talent.vengeance.enabled&rage.deficit>=40)|(buff.vengeance_ignore_pain.up)|(talent.vengeance.enabled&!buff.vengeance_ignore_pain.up&!buff.vengeance_revenge.up&rage<30&!buff.revenge.react)
            if (talent.vengeance and cast.able.ignorePain() and ((buff.vengeanceIgnorePain.exists())
                or (talent.vengeance and not buff.vengeanceIgnorePain.exists() and not buff.vengeanceRevenge.exists() and rage < 50 and not buff.revenge.exists())
				or (php <= 25 and power > 45))) or (power >= 55 and not buff.ignorePain.exists())
            then
                if cast.ignorePain() then return end
            end
        -- Shield Slam
            -- shield_slam,if=(!(cooldown.shield_block.remains<=gcd.max*2&!buff.shield_block.up)&talent.heavy_repercussions.enabled)|!talent.heavy_repercussions.enabled
                if cast.shieldSlam() then return end
        -- Thunder Clap
            -- thunder_clap
            if talent.cracklingThunder then
                if cast.thunderClap("player",nil,1,12) then return end
            else
                if cast.thunderClap("player",nil,1,8) then return end
            end
        -- Revenge
            -- revenge,if=(talent.vengeance.enabled&buff.revenge.react&!buff.vengeance_ignore_pain.up)|(buff.vengeance_revenge.up&rage>=59)|(talent.vengeance.enabled&!buff.vengeance_ignore_pain.up&!buff.vengeance_revenge.up&rage>=69)|(!talent.vengeance.enabled&buff.revenge.react)
            if (talent.vengeance and buff.revenge.exists() and not buff.vengeanceIgnorePain.exists())
                or (buff.vengeanceRevenge.exists() and power >= 59)
                or (talent.vengeance and not buff.vengeanceIgnorePain.exists() and not buff.vengeanceRevenge.exists() and power >= 69)
                or (not talent.vengeance and buff.revenge.exists())
                or (isChecked("High Rage Revenge") and power > 90 and #enemies.yards8 >= getOptionValue("High Rage Revenge"))
            then
                if cast.revenge() then return end
            end
        -- Devastate
            -- devastate
            if cast.devastate() then return end
        end -- End Action List - Single
-----------------
--- Rotations ---
-----------------
        if actionList_Extra() then return end
        if actionList_Defensive() then return end
        -- Pause
        if pause() or (UnitExists("target") and (UnitIsDeadOrGhost("target") or not UnitCanAttack("target", "player"))) or mode.rotation == 2 then
            return true
        else
---------------------------------
--- Out Of Combat - Rotations ---
---------------------------------
            if not inCombat and not IsMounted() and isValidUnit("target") then
                if actionList_PreCombat() then return end
                if getDistance(units.dyn5)<5 then
                    StartAttack()
                else
            -- Action List - Movement
                    -- run_action_list,name=movement,if=movement.getDistance(units.dyn5)>5
                    if getDistance("target") >= 8 then
                        if actionList_Movement() then return end
                    end
                end
            end
-----------------------------
--- In Combat - Rotations ---
-----------------------------
            if inCombat and not IsMounted() and isValidUnit("target") then
            -- Auto Attack
                --auto_attack
                if getDistance(units.dyn5) < 5 then
                    StartAttack()
                end
            -- Action List - Movement
                -- run_action_list,name=movement,if=movement.getDistance(units.dyn5)>5
                if getDistance(units.dyn8) > 8 then
                    if actionList_Movement() then return end
                end
            -- Action List - Interrupts
                if actionList_Interrupts() then return end
            -- Action List - Cooldowns
                if actionList_Cooldowns() then return end
            -- Action List - Main
                if actionList_Main() then return end
            end -- End Combat Rotation
        end -- Pause
    end -- End Timer
end -- End runRotation
local id = 73
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
