-------------------------------------------------------
-- Author = CuteOne
-- Patch = 9.2.5
--    Patch should be the latest patch you've updated the rotation for (i.e., 9.2.5)
-- Coverage = 100%
--    Coverage should be your estimated percent coverage for class mechanics (i.e., 100%)
-- Status = Limited
--    Status should be one of: Full, Limited, Sporadic, Inactive, Unknown
-- Readiness = Basic
--    Readiness should be one of: Raid, NoRaid, Basic, Development, Untested
-------------------------------------------------------
-- Required: Fill above fields to populate README.md --
-------------------------------------------------------

local rotationName = "CuteOne"

---------------
--- Toggles ---
---------------
local function createToggles()
    -- Rotation Button
    local RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell.cleave },
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.whirlwind },
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.mortalStrike },
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.victoryRush}
    };
    br.ui:createToggle(RotationModes,"Rotation",1,0)
    -- Cooldown Button
    local CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.avatar },
        [2] = { mode = "On", value = 2 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 1, icon = br.player.spell.avatar },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.avatar }
    };
    br.ui:createToggle(CooldownModes,"Cooldown",2,0)
    -- Defensive Button
    local DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.dieByTheSword },
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.dieByTheSword }
    };
    br.ui:createToggle(DefensiveModes,"Defensive",3,0)
    -- Interrupt Button
    local InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.pummel },
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.pummel }
    };
    br.ui:createToggle(InterruptModes,"Interrupt",4,0)
    -- Movement Button
    local MoverModes = {
        [1] = { mode = "On", value = 1 , overlay = "Mover Enabled", tip = "Will use Charge/Heroic Leap.", highlight = 1, icon = br.player.spell.charge },
        [2] = { mode = "Off", value = 2 , overlay = "Mover Disabled", tip = "Will NOT use Charge/Heroic Leap.", highlight = 0, icon = br.player.spell.charge }
    };
    br.ui:createToggle(MoverModes,"Mover",5,0)
end

---------------
--- OPTIONS ---
---------------
local function createOptions()
    local optionTable

    local function rotationOptions()
        local section
        -----------------------
        --- GENERAL OPTIONS ---
        -----------------------
        section = br.ui:createSection(br.ui.window.profile,  "General")
            -- Dummy DPS Test
            br.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
            -- Pre-Pull Timer
            br.ui:createSpinner(section, "Pre-Pull Timer",  5,  1,  10,  1,  "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
            -- Battle Cry
            br.ui:createCheckbox(section, "Battle Shout")
            -- Berserker Rage
            br.ui:createCheckbox(section,"Berserker Rage", "Check to use Berserker Rage")
            -- Charge
            br.ui:createCheckbox(section,"Charge", "Check to use Charge")
			-- Heroic Throw
            br.ui:createCheckbox(section,"Heroic Throw", "Check to use Heroic Throw out of range")
            -- Taunt
            br.ui:createCheckbox(section,"Solo Taunt", "Only uses Taunt when not in a group.")
        br.ui:checkSectionState(section)
        ------------------------
        --- COOLDOWN OPTIONS ---
        ------------------------
        section = br.ui:createSection(br.ui.window.profile,  "Cooldowns")
            local alwaysCdAoENever = {"Always", "|cff008000AOE", "|cffffff00AOE/CD", "|cff0000ffCD", "|cffff0000Never"}
            -- Flask Up Module
            br.player.module.FlaskUp("Agility", section)
            -- Racial
            br.ui:createDropdownWithout(section, "Racial", alwaysCdAoENever, 4, "|cffFFFFFFWhen to use Racial.")
            -- Basic Trinkets Module
            br.player.module.BasicTrinkets(nil, section)
            -- Avatar
            br.ui:createDropdownWithout(section, "Avatar", alwaysCdAoENever, 4, "|cffFFFFFFWhen to use Avatar.")
            -- Bladestorm
            br.ui:createDropdownWithout(section, "Bladestorm", alwaysCdAoENever, 3, "|cffFFFFFFWhen to use Bladestorm.")
            -- Colossus Smash / Warbreaker
            br.ui:createDropdownWithout(section, "Colossus Smash / Warbreaker", alwaysCdAoENever, 4, "|cffFFFFFFWhen to use Colossus Smash / Warbreaker.")
            -- Deadly Calm
            br.ui:createDropdownWithout(section, "Deadly Calm", alwaysCdAoENever, 4, "|cffFFFFFFWhen to use Deadly Calm.")
            -- Ravager
            br.ui:createDropdownWithout(section, "Ravager", alwaysCdAoENever, 3, "|cffFFFFFFWhen to use Ravager.")
            -- Covenant
            br.ui:createDropdownWithout(section, "Covenant", alwaysCdAoENever, 3, "|cffFFFFFFWhen to use Covenant Ability.")
        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
            local defTooltip = "|cffFFBB00Health Percentage to use at."
            -- Basic Healing Module
            br.player.module.BasicHealing(section)
            -- Defensive Stance
            br.ui:createSpinner(section, "Defensive Stance",  60,  0,  100,  5,  defTooltip)
            -- Die By The Sword
            br.ui:createSpinner(section, "Die By The Sword",  60,  0,  100,  5,  defTooltip)
            -- Ignore Pain
            br.ui:createSpinner(section, "Ignore Pain", 60, 0, 100, 5, defTooltip)
            -- Intimidating Shout
            br.ui:createSpinner(section, "Intimidating Shout",  60,  0,  100,  5,  defTooltip)
            -- Rallying Cry
            br.ui:createSpinner(section, "Rallying Cry",  60,  0,  100,  5, defTooltip)
            -- Victory Rush
            br.ui:createSpinner(section, "Victory Rush", 60, 0, 100, 5, defTooltip)
        br.ui:checkSectionState(section)
        -------------------------
        --- INTERRUPT OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
            -- Pummel
            br.ui:createCheckbox(section,"Pummel")
            -- Intimidating Shout
            br.ui:createCheckbox(section,"Intimidating Shout - Int")
            -- Storm Bolt Logic
            br.ui:createCheckbox(section, "Storm Bolt Logic", "Stun specific Spells and Mobs")
            -- Interrupt Percentage
            br.ui:createSpinner(section,  "Interrupt At",  70,  0,  95,  5,  "|cffFFBB00Cast Percentage to use at.")
        br.ui:checkSectionState(section)
        ----------------------
        --- TOGGLE OPTIONS ---
        ----------------------
        section = br.ui:createSection(br.ui.window.profile,  "Toggle Keys")
            -- Single/Multi Toggle
            br.ui:createDropdownWithout(section,  "Rotation Mode", br.dropOptions.Toggle,  4)
            --Cooldown Key Toggle
            br.ui:createDropdownWithout(section,  "Cooldown Mode", br.dropOptions.Toggle,  3)
            --Defensive Key Toggle
            br.ui:createDropdownWithout(section,  "Defensive Mode", br.dropOptions.Toggle,  6)
            -- Interrupts Key Toggle
            br.ui:createDropdownWithout(section,  "Interrupt Mode", br.dropOptions.Toggle,  6)
            -- Mover Toggle
            br.ui:createDropdownWithout(section,  "Mover Mode", br.dropOptions.Toggle,  6)
            -- Pause Toggle
            br.ui:createDropdown(section,  "Pause Mode", br.dropOptions.Toggle,  6)
        br.ui:checkSectionState(section)
    end
    optionTable = {
        {
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
local conduit
local covenant
local debuff
local enemies
local module
local race
local rage
local rageDeficit
local runeforge
local talent
local ui
local unit
local units
local var

--------------------
--- Action Lists ---
--------------------
local actionList = {}
-- Action List - Extras
actionList.Extras = function()
    -- Dummy Test
    if ui.checked("DPS Testing") then
        if unit.exists("target") then
            if unit.combatTime() >= (tonumber(ui.value("DPS Testing"))*60) and unit.isDummy() then
                unit.stopAttack()
                unit.clearTarget()
                ui.print(tonumber(ui.value("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
                var.profileStop = true
            end
        end
    end -- End Dummy Test
    -- Battle Shout
    if ui.checked("Battle Shout") and cast.able.battleShout() then
        for i = 1, #br.friend do
            local thisUnit = br.friend[i].unit
            if not unit.deadOrGhost(thisUnit) and unit.distance(thisUnit) < 100 and buff.battleShout.remain(thisUnit) < 600 then
                if cast.battleShout() then ui.debug("Casting Battle Shout") return true end
            end
        end
    end
    -- Berserker Rage
    if ui.checked("Berserker Rage") and cast.able.berserkerRage() and cast.noControl.berserkerRage() then
        if cast.berserkerRage() then ui.debug("Casting Berserker Rage") return true end
    end
    -- Piercing Howl
    if ui.checked("Piercing Howl") then
        for i=1, #enemies.yards15 do
            local thisUnit = enemies.yards15[i]
            if cast.able.piercingHowl(thisUnit) and unit.moving(thisUnit) and not unit.facing(thisUnit,"player") and unit.distance(thisUnit) >= 5 then
                if cast.piercingHowl(thisUnit) then ui.debug("Casting Piercing Howl") return true end
            end
        end
    end
end -- End Action List - Extra

-- Action List - Defensive
actionList.Defensive = function()
    if ui.useDefensive() then
        local useDefensive = function(op)
            return unit.inCombat() and unit.hp() <= ui.value(op)
        end
        -- Basic Healing Module
        module.BasicHealing()
        -- Defensive Stance
        if ui.checked("Defensive Stance") and cast.able.defensiveStance() then
            if useDefensive("Defensive Stance") and not buff.defensiveStance.exists() then
                if cast.defensiveStance() then ui.debug("Casting Defensive Stance") return end
            elseif buff.defensiveStance.exists() and unit.hp() > ui.value("Defensive Stance") then
                if cast.defensiveStance() then debug("Casting Defensive Stance") return end
            end
        end
        -- Die By The Sword
        if ui.checked("Die By The Sword") and cast.able.dieByTheSword() and useDefensive("Die By The Sword") then
            if cast.dieByTheSword() then debug("Casting Die By The Sword") return end
        end
        -- Ignore Pain
        if ui.checked("Ignore Pain") and cast.able.ignorePain() and useDefensive("Ignore Pain") and rage >= 40 then
            if cast.ignorePain() then ui.debug("Casting Ignore Pain") return true end
        end
        -- Intimidating Shout
        if ui.checked("Intimidating Shout") and cast.able.intimidatingShout() and useDefensive("Intimidating Shout") then
            if cast.intimidatingShout() then ui.debug("Casting Intimidating Shout") return true end
        end
        -- Rallying Cry
        if ui.checked("Rallying Cry") and cast.able.rallyingCry() and useDefensive("Rallying Cry") then
            if cast.rallyingCry() then ui.debug("Casting Rallying Cry") return true end
        end
        -- Spell Reflection
        if ui.checked("Spell Reflection") and cast.able.spellReflection() and useDefensive("Spell Relection") then
            for i = 1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                if (cast.timeRemain(thisUnit) < 5 or cast.inFlight.spellReflection(thisUnit)) then
                    if cast.spellReflection() then ui.debug("Casting Spell Reflection") return true end
                end
            end
        end
        -- Storm Bolt
        if ui.checked("Storm Bolt") and cast.able.stormBolt() and useDefensive("Storm Bolt") then
            if cast.stormBolt() then ui.debug("Casting Storm Bolt") return true end
        end
        -- Victory Rush
        if ui.checked("Victory Rush") and (cast.able.victoryRush() or cast.able.impendingVictory())
            and unit.inCombat() and buff.victorious.exists()
        then
            for i = 1, #enemies.yards5f do
                local thisUnit = enemies.yards5f[i]
                if unit.hp() <= ui.value("Victory Rush") or buff.victorious.remain() < unit.gcd(true) or unit.ttd(thisUnit) < unit.gcd(true) then
                    if talent.impendingVictory then
                        if cast.impendingVictory(thisUnit) then ui.debug("Casting Impending Victory") return true end
                    else
                        if cast.victoryRush(thisUnit) then ui.debug("Casting Victory Rush") return true end
                    end
                end
            end
        end
    end -- End Defensive Check
end -- End Action List - Defensive

-- Action List - Interrupts
actionList.Interrupts = function()
    if ui.useInterrupt() then
        for i=1, #enemies.yards20 do
            local thisUnit = enemies.yards20[i]
            local distance = unit.distance(thisUnit)
            if unit.interruptable(thisUnit,ui.value("Interrupt At")) then
                -- Pummel
                if ui.checked("Pummel") and cast.able.pummel(thisUnit) and distance < 5 then
                    if cast.pummel(thisUnit) then ui.debug("Casting Pummel") return true end
                end
                -- Intimidating Shout
                if ui.checked("Intimidating Shout - Int") and cast.able.intimidatingShout() and distance < 8 then
                    if cast.intimidatingShout() then ui.debug("Casting Intimidating Shout [Int]") return true end
                end
                -- Storm Bolt
                if ui.checked("Storm Bolt - Int") and cast.able.stormBolt(thisUnit) and distance < 20 then
                    if cast.stormBolt(thisUnit) then ui.debug("Casting Storm Bolt [Int]") return true end
                end
            end
        end
    end
end -- End Action List - Interrupts

-- Action List - Execute
actionList.Execute = function()
    -- Deadly Calm
    -- deadly_calm
    if ui.alwaysCdAoENever("Deadly Calm",3,8) and cast.able.deadlyCalm() then
        if cast.deadlyCalm() then ui.debug("Casting Deadly Calm [Execute]") return true end
    end
    -- Cancel Buff - Bladestorm
    -- cancel_buff,name=bladestorm,if=spell_targets.whirlwind=1&gcd.remains=0&(rage>75|rage>50&buff.recklessness.up)
    if cast.current.bladestorm() and #enemies.yards8 == 1 and unit.gcd() == 0 and (rage > 75 or (rage > 50 and buff.recklessness.exists())) then
        var.cancelBladestorm = true
        return true
    end
    -- Avatar
    -- avatar,if=gcd.remains=0|target.time_to_die<20
    if ui.alwaysCdAoENever("Avatar") and cast.able.avatar() and (unit.gcd() == 0 or unit.ttd(units.dyn5) < 20) then
        if cast.avatar() then ui.debug("Casting Avatar [Execute]") return true end
    end
    -- Execute
    -- execute,if=buff.ashen_juggernaut.up&buff.ashen_juggernaut.remains<gcd&conduit.ashen_juggernaut.rank>1
    if cast.able.execute() and buff.ashenJuggernaut.exists() and buff.ashenJuggernaut.remains() < unit.gcd(true) and conduit.ashenJuggernaut.rank > 1 then
        if cast.execute() then ui.debug("Casting Execute [Execute - Ashen Juggernaut]") return true end
    end
    -- Ravager
    -- ravager
    if ui.alwaysCdAoENever("Ravager",1,8) and cast.able.ravager("best",nil,1,8) then
        if cast.ravager("best",nil,1,8) then ui.debug("Casting Ravager [Execute]") return true end
    end
    -- Rend
    -- rend,if=remains<=gcd&(!talent.warbreaker.enabled&cooldown.colossus_smash.remains<4|talent.warbreaker.enabled&cooldown.warbreaker.remains<4)&target.time_to_die>12
    if cast.able.rend() and debuff.rend.remains() < unit.gcd(true) and unit.ttd(units.dyn5) > 12
        and ((not talent.warbreaker and cd.colossusSmash.remains() < 4) or (talent.warbreaker and cd.warbreaker.remains() < 4))
    then
        if cast.rend() then ui.debug("Casting Rend [Execute]") return true end
    end
    -- Warbreaker
    -- warbreaker
    if ui.alwaysCdAoENever("Colossus Smash / Warbreaker",1,8) and cast.able.warbreaker("player","aoe",1,8) then
        if cast.warbreaker("player","aoe",1,8) then ui.debug("Casting Warbreaker [Execute]") return true end
    end
    -- Colossus Smash
    -- colossus_smash
    if ui.alwaysCdAoENever("Colossus Smash / Warbreaker",1,5) and cast.able.colossusSmash() then
        if cast.colossusSmash() then ui.debug("Casting Colossus Smash [Execute]") return true end
    end
    -- Ancient Aftershock
    -- ancient_aftershock,if=debuff.colossus_smash.up
    if covenant.nightFae.active and ui.alwaysCdAoENever("Covenant",1,12) and cast.able.ancientAftershock("player","cone",1,12) and debuff.colossusSmash.exists(units.dyn5) then
        if cast.ancientAftershock("player","cone",1,12) then ui.debug("Casting Ancient Aftershock [Execute]") return true end
    end
    -- Overpower
    -- overpower,if=charges=2
    if cast.able.overpower() and charges.overpower.count() == 2 then
        if cast.overpower() then ui.debug("Casting Overpower [Execute - 2x Overpower]") return true end
    end
    -- Cleave
    -- cleave,if=spell_targets.whirlwind>1&dot.deep_wounds.remains<gcd
    if cast.able.cleave("player","cone",1,8) and ui.useAOE(8,2) and debuff.deepWounds.remains() <= unit.gcd(true) then
        if cast.cleave("player","cone",1,8) then ui.debug("Casting Cleave [Execute - Deep Wounds Expire Soon]") return true end
    end
    -- Mortal Strike
    -- mortal_strike,if=dot.deep_wounds.remains<=gcd|runeforge.enduring_blow|buff.overpower.stack=2&debuff.exploiter.stack=2|buff.battlelord.up
    if cast.able.mortalStrike() and (debuff.deepWounds.remains() < unit.gcd(true) or runeforge.enduringBlow.equiped
        or (buff.overpower.stack() == 2 and debuff.exploiter.stack() == 2) or buff.battlelord.exists())
    then
        if cast.mortalStrike() then ui.debug("Casting Mortal Strike [Execute]") return true end
    end
    -- Skullsplitter
    -- skullsplitter,if=rage<45
    if cast.able.skullsplitter() and rage < 45 then
        if cast.skullsplitter() then ui.debug("Casting Skullsplitter [Execute]") return true end
    end
    -- Bladestorm
    -- bladestorm,if=buff.deadly_calm.down&(rage<20|!runeforge.sinful_surge&rage<50)
    if ui.alwaysCdAoENever("Bladestorm",3,8) and cast.able.bladestorm("player","aoe",1,8) and not buff.deadlyCalm.exists()
        and (rage < 20 or (not runeforge.sinfulSurge.equiped and rage < 50))
    then
        if cast.bladestorm("player","aoe",1,8) then ui.debug("Casting Bladestorm [Execute]") return true end
    end
    -- Overpower
    -- overpower
    if cast.able.overpower() then
        if cast.overpower() then ui.debug("Casting Overpower [Execute]") return true end
    end
    -- Execute
    -- execute
    if cast.able.execute() then
        if cast.execute() then ui.debug("Casting Execute [Execute]") return true end
    end
end -- End Action List - Execute

-- Action List - HAC
actionList.HAC = function()
    -- Skullsplitter
    -- skullsplitter,if=rage<60&buff.deadly_calm.down
    if cast.able.skullsplitter() and rage < 60 and not buff.deadlyCalm.exists() then
        if cast.skullsplitter() then ui.debug("Casting Skullsplitter [HAC]") return true end
    end
    -- Avatar
    -- avatar,if=cooldown.colossus_smash.remains<1
    if ui.alwaysCdAoENever("Avatar") and cast.able.avatar() and cd.colossusSmash.remains() < 1 then
        if cast.avatar() then ui.debug("Casting Avatar [HAC]") return true end
    end
    -- Warbreaker
    -- warbreaker
    if ui.alwaysCdAoENever("Colossus Smash / Warbreaker",1,8) and cast.able.warbreaker("player","aoe",1,8) then
        if cast.warbreaker("player","aoe",1,8) then ui.debug("Casting Warbreaker [HAC]") return true end
    end
    -- Colossus Smash
    -- colossus_smash
    if ui.alwaysCdAoENever("Colossus Smash / Warbreaker",1,5) and cast.able.colossusSmash() then
        if cast.colossusSmash() then ui.debug("Casting Colossus Smash [HAC]") return true end
    end
    -- Cleave
    -- cleave,if=dot.deep_wounds.remains<=gcd
    if cast.able.cleave("player","cone",1,8) and debuff.deepWounds.remains() <= unit.gcd(true) then
        if cast.cleave("player","cone",1,8) then ui.debug("Casting Cleave [HAC - Deep Wounds Expire Soon]") return true end
    end
    -- Ancient Aftershock
    -- ancient_aftershock
    if covenant.nightFae.active and ui.alwaysCdAoENever("Covenant",1,12) and cast.able.ancientAftershock("player","cone",1,12) then
        if cast.ancientAftershock("player","cone",1,12) then ui.debug("Casting Ancient Aftershock [HAC]") return true end
    end
    -- Bladestorm
    -- bladestorm
    if ui.alwaysCdAoENever("Bladestorm",3,8) and cast.able.bladestorm("player","aoe",1,8) then
        if cast.bladestorm("player","aoe",1,8) then ui.debug("Casting Bladestorm [HAC]") return true end
    end
    -- Ravager
    -- ravager
    if ui.alwaysCdAoENever("Ravager",1,8) and cast.able.ravager("best",nil,1,8) then
        if cast.ravager("best",nil,1,8) then ui.debug("Casting Ravager [HAC]") return true end
    end
    -- Rend
    -- rend,if=remains<=duration*0.3&buff.sweeping_strikes.up
    if cast.able.rend() and debuff.rend.refresh() and buff.sweepingStrikes.exists() then
        if cast.rend() then ui.debug("Casting Rend [HAC]") return true end
    end
    -- Cleave
    -- cleave
    if cast.able.cleave("player","cone",1,8) then
        if cast.cleave("player","cone",1,8) then ui.debug("Casting Cleave [HAC]") return true end
    end
    -- Mortal Strike
    -- mortal_strike,if=buff.sweeping_strikes.up|dot.deep_wounds.remains<gcd&!talent.cleave.enabled
    if cast.able.mortalStrike() and (buff.sweepingStrikes.exists() or (debuff.deepWounds.remains() < unit.gcd(true) and not talent.cleave)) then
        if cast.mortalStrike() then ui.debug("Casting Mortal Strike [HAC]") return true end
    end
    -- Overpower
    -- overpower,if=talent.dreadnaught.enabled
    if cast.able.overpower() and talent.dreadnaught then
        if cast.overpower() then ui.debug("Casting Overpower [HAC]") return true end
    end
    -- Execute
    -- execute,if=buff.sweeping_strikes.up
    if cast.able.execute() and buff.sweepingStrikes.exists() then
        if cast.execute() then ui.debug("Casting Execute [HAC - Sweeping Strikes]") return true end
    end
    -- Execute
    -- execute,if=buff.sudden_death.react
    if cast.able.execute() and buff.suddenDeath.exists() then
        if cast.execute() then ui.debug("Casting Execute [HAC - Sudden Death]") return true end
    end
    -- Overpower
    -- overpower
    if cast.able.overpower() then
        if cast.overpower() then ui.debug("Casting Overpower [HAC]") return true end
    end
    -- Whirlwind
    -- whirlwind
    if cast.able.whirlwind("player","aoe",1,8) then
        if cast.whirlwind("player","aoe",1,8) then ui.debug("Casting Whirlwind [HAC]") return true end
    end
end -- End Action List - HAC

-- ACtion List - Single
actionList.Single = function()
    -- Rend
    -- rend,if=remains<=gcd
    if cast.able.rend() and debuff.rend.remain(units.dyn5) <= unit.gcd(true) then
        if cast.rend() then ui.debug("Casting Rend [ST - Expire Soon]") return true end
    end
    -- Avatar
    -- avatar,if=gcd.remains=0
    if ui.alwaysCdAoENever("Avatar") and cast.able.avatar() and unit.gcd() == 0 then
        if cast.avatar() then ui.debug("Casting Avatar [ST]") return true end
    end
    -- Ravager
    -- ravager
    if ui.alwaysCdAoENever("Ravager",1,8) and cast.able.ravager("best",nil,1,8) then
        if cast.ravager("best",nil,1,8) then ui.debug("Casting Ravager [ST]") return true end
    end
    -- Warbreaker
    -- warbreaker
    if ui.alwaysCdAoENever("Colossus Smash / Warbreaker",1,8) and cast.able.warbreaker("player","aoe",1,8) then
        if cast.warbreaker("player","aoe",1,8) then ui.debug("Casting Warbreaker [ST]") return true end
    end
    -- Colossus Smash
    -- colossus_smash
    if ui.alwaysCdAoENever("Colossus Smash / Warbreaker",1,5) and cast.able.colossusSmash() then
        if cast.colossusSmash() then ui.debug("Casting Colossus Smash [ST]") return true end
    end
    -- Ancient Aftershock
    -- ancient_aftershock,if=debuff.colossus_smash.up
    if covenant.nightFae.active and ui.alwaysCdAoENever("Covenant",1,12) and cast.able.ancientAftershock("player","cone",1,12) and debuff.colossusSmash.exists(units.dyn5) then
        if cast.ancientAftershock("player","cone",1,12) then ui.debug("Casting Ancient Aftershock [ST]") return true end
    end
    -- Overpower
    -- overpower,if=charges=2
    if cast.able.overpower() and charges.overpower.count() == 2 then
        if cast.overpower() then ui.debug("Casting Overpower [ST - 2x Overpower]") return true end
    end
    -- Mortal Strike
    -- mortal_strike,if=runeforge.enduring_blow|runeforge.battlelord|buff.overpower.stack>=2
    if cast.able.mortalStrike() and (runeforge.enduringBlow.equiped or runeforge.battlelord.equiped or buff.overpower.stack() >= 2) then
        if cast.mortalStrike() then ui.debug("Casting Mortal Strike [ST - Legendary/2x Overpower]") return true end
    end
    -- Execute
    -- execute,if=buff.sudden_death.react
    if cast.able.execute() and buff.suddenDeath.exists() then
        if cast.execute() then ui.debug("Casting Execute [ST]") return true end
    end
    -- Skullsplitter
    -- skullsplitter,if=rage.deficit>45&buff.deadly_calm.down
    if cast.able.skullsplitter() and rageDeficit > 45 and not buff.deadlyCalm.exists() then
        if cast.skullsplitter() then ui.debug("Casting Skullsplitter [ST]") return true end
    end
    -- Bladestorm
    -- bladestorm,if=buff.deadly_calm.down&rage<30
    if ui.alwaysCdAoENever("Bladestorm",3,8) and cast.able.bladestorm("player","aoe",1,8) and not buff.deadlyCalm.exists() and rage < 30 then
        if cast.bladestorm("player","aoe",1,8) then ui.debug("Casting Bladestorm [ST]") return true end
    end
    -- Deadly Calm
    -- deadly_calm
    if ui.alwaysCdAoENever("Deadly Calm",3,5) and cast.able.deadlyCalm() then
        if cast.deadlyCalm() then ui.debug("Casting Deadly Calm [ST]") return true end
    end
    -- Overpower
    -- overpower
    if cast.able.overpower() then
        if cast.overpower() then ui.debug("Casting Overpower [ST]") return true end
    end
    -- Mortal Strike
    -- mortal_strike
    if cast.able.mortalStrike() then
        if cast.mortalStrike() then ui.debug("Casting Mortal Strike [ST]") return true end
    end
    -- Rend
    -- rend,if=remains<duration*0.3
    if cast.able.rend() and debuff.rend.refresh() then
        if cast.rend() then ui.debug("Casting Rend [ST]") return true end
    end
    -- Cleave
    -- cleave,if=spell_targets.whirlwind>1
    if cast.able.cleave("player","cone",1,8) and ui.useAOE(8,2) then
        if cast.cleave("player","cone",1,8) then ui.debug("Casting Cleave [ST]") return true end
    end
    -- Whirlwind
    -- whirlwind,if=talent.fervor_of_battle.enabled|spell_targets.whirlwind>4|spell_targets.whirlwind>2&buff.sweeping_strikes.down
    if cast.able.whirlwind("player","aoe",1,8) and (talent.fervorOfBattle or ui.useAOE(8,5) or (ui.useAOE(8,3) and not buff.sweepingStrikes.exists())) then
        if cast.whirlwind("player","aoe",1,8) then ui.debug("Casting Whirlwind [ST]") return true end
    end
    -- Slam
    -- slam,if=!talent.fervor_of_battle.enabled&(rage>50|debuff.colossus_smash.up|!runeforge.enduring_blow)
    if cast.able.slam() and not talent.fervorOfBattle and (rage > 50 or debuff.colossusSmash.exists(units.dyn5) or not runeforge.enduringBlow.equiped) then
        if cast.slam() then ui.debug("Casting Slam [ST]") return true end
    end
end -- End Action List - Single

-- Action List - PreCombat
actionList.PreCombat = function()
    if not unit.inCombat() and not (unit.flying() or unit.mounted() or unit.taxi()) then
        -- Flask Up Module
        -- flask
        module.FlaskUp("Agility")
        -- Augmentation
        -- augmentation
        if ui.checked("Pre-Pull Timer") and ui.pullTimer() <= ui.value("Pre-Pull Timer") then
            -- Potion
            -- potion
            -- if ui.checked("Potion") and br.canUseItem(142117) and unit.instance("raid") then
            --     if feralSpiritRemain > 5 and not buff.prolongedPower.exists() then
            --         br.useItem(142117)
            --     end
            -- end
        end -- End Pre-Pull
        if unit.valid("target") then
            -- Charge
            -- charge
            if ui.mode.mover == 1 and ui.checked("Charge") and cast.able.charge("target") then
                if cast.charge("target") then ui.debug("Casting Charge") return true end
            end
            -- Taunt
            if ui.checked("Solo Taunt") and cast.able.taunt("target") and unit.solo()
                and (not cast.able.charge("target") or unit.distance("target") < 8) and unit.distance("target") < 25
            then
                if cast.taunt("target") then ui.debug("Casting Taunt") return true end
            end
            -- Start Attack
            if unit.distance("target") < 5 then
                if cast.able.autoAttack("target") then
                    if cast.autoAttack("target") then ui.debug("Casting Auto Attack [Pre-Combat]") return true end
                end
            end
        end
    end -- End No Combat
end -- End Action List - PreCombat

----------------
--- ROTATION ---
----------------
local function runRotation()

--------------
--- Locals ---
--------------
    buff        = br.player.buff
    cast        = br.player.cast
    cd          = br.player.cd
    charges     = br.player.charges
    conduit     = br.player.conduit
    covenant    = br.player.covenant
    debuff      = br.player.debuff
    enemies     = br.player.enemies
    module      = br.player.module
    race        = br.player.race
    rage        = br.player.power.rage.amount()
    rageDeficit = br.player.power.rage.deficit()
    runeforge   = br.player.runeforge
    talent      = br.player.talent
    ui          = br.player.ui
    unit        = br.player.unit
    units       = br.player.units
    var         = br.player.variables

    units.get(5)
    units.get(8)
    units.get(8,true)
    enemies.get(5)
    enemies.get(5,"player",false,true) -- makes enemies.yards5f
    enemies.get(8)
    enemies.get(8,"target")
    enemies.get(8,"player",false,true) -- makes enemies.yards8f
    enemies.get(20)

    ------------------------
    --- Custom Variables ---
    ------------------------
    if var.cancelBladestorm == nil or (var.cancelBladestorm and not cast.current.bladestorm()) then var.cancelBladestorm = false end
    if var.profileStop == nil then var.profileStop = false end

    if var.cancelBladestorm and cast.current.bladestorm() then
        if cast.cancel.bladestorm() then ui.debug("|cffFF0000Canceling Bladestorm") var.cancelBladestorm = false return true end
    end
-----------------
--- Rotations ---
-----------------
---------------------
--- Begin Profile ---
---------------------
    -- Profile Stop | Pause
    if not unit.inCombat() and not unit.exists("target") and var.profileStop then
        var.profileStop = false
    elseif (unit.inCombat() and var.profileStop==true) or ui.pause() or unit.mounted() or unit.flying() or ui.mode.rotation == 4 then
        return true
    else
        -----------------------
        --- Extras Rotation ---
        -----------------------
        if actionList.Extras() then return true end
        --------------------------
        --- Defensive Rotation ---
        --------------------------
        if actionList.Defensive() then return true end
        ---------------------------
        --- Pre-Combat Rotation ---
        ---------------------------
        if actionList.PreCombat() then return true end
        --------------------------
        --- In Combat Rotation ---
        --------------------------
        if unit.inCombat() and unit.valid("target") and not var.profileStop then
            ------------------------------
            --- In Combat - Interrupts ---
            ------------------------------
            if actionList.Interrupts() then return true end
            ------------------------
            --- In Combat - Main ---
            ------------------------
            -- Start Attack
            if unit.distance("target") <= 5 then
                if cast.able.autoAttack("target") then
                    if cast.autoAttack("target") then ui.debug("Casting Auto Attack") return true end
                end
            end
            -- Charge
            -- charge
            if ui.mode.mover == 1 and ui.checked("Charge") and cast.able.charge(units.dyn5) then
                if cast.charge(units.dyn5) then ui.debug("Casting Charge") return true end
            end
            -- Potion
            -- potion,if=gcd.remains=0&debuff.colossus_smash.remains>8|target.time_to_die<25
            -- Action List - Interrupts
            if actionList.Interrupts() then return true end
            -- Racials
            if ui.alwaysCdNever("Racial") and cast.able.racial() then
                -- Blood Fury (Orc)
                -- blood_fury,if=debuff.colossus_smash.up
                if race == "Orc" and cast.able.bloodFury() and debuff.colossusSmash.exists(units.dyn5) then
                    if cast.bloodFury() then ui.debug("Casting Blood Fury") return true end
                end
                -- Berserking (Troll)
                -- berserking,if=debuff.colossus_smash.remains>6
                if race == "Troll" and cast.able.berserking() and debuff.colossusSmash.remain(units.dyn5) > 6 then
                    if cast.berserking() then ui.debug("Casting Berserking") return true end
                end
                -- Arcane Torrent (Blood Elf)
                -- arcane_torrent,if=cooldown.mortal_strike.remains>1.5&rage<50
                if race == "BloodElf" and cast.able.arcaneTorrent() and cd.mortalStrike.remains() > 1.5 and rage < 50 then
                    if cast.arcaneTorrent() then ui.debug("Casting Arcane Torrent") return true end
                end
                -- Light's Judgment (Lightforged Draenei)
                -- lights_judgment,if=debuff.colossus_smash.down&cooldown.mortal_strike.remains
                if race == "LightforgedDraenei" and cast.able.lightsJudgment() and not debuff.colossusSmash.exists(units.dyn5) and cd.mortalStrike.exists() then
                    if cast.lightsJudgment() then ui.debug("Casting Light's Judgement") return true end
                end
                -- Fireblood (Dark Iron Dwarf)
                -- fireblood,if=debuff.colossus_smash.up
                if race == "DarkIronDwarf" and cast.able.fireblood() and debuff.colossusSmash.exists(units.dyn5) then
                    if cast.fireblood() then ui.debug("Casting Fireblood") return true end
                end
                -- Ancestral Call (Maghar Orc)
                -- ancestral_call,if=debuff.colossus_smash.up
                if race == "MagharOrc" and cast.able.ancestralCall() and debuff.colossusSmash.exists(units.dyn5) then
                    if cast.ancestralCall() then ui.debug("Casting Ancestral Call") return true end
                end
                -- bag_of_tricks,if=debuff.colossus_smash.down&cooldown.mortal_strike.remains
            end
            -- Trinkets
            -- use_item,name=scars_of_fraternal_strife
            -- use_item,name=gavel_of_the_first_arbiter
            if #enemies.yards5 > 0 and unit.standingTime() >= 2 then
                module.BasicTrinkets()
            end
            -- Sweeping Strikes
            -- sweeping_strikes,if=spell_targets.whirlwind>1&(cooldown.bladestorm.remains>15|talent.ravager.enabled)
            if cast.able.sweepingStrikes() and ui.useAOE(8,2) and (cd.bladestorm.remains() > 15 or talent.ravager) then
                if cast.sweepingStrikes() then ui.debug("Casting Sweeping Strikes") return true end
            end
            -- Run Action List - Execute
            -- run_action_list,name=execute,if=(talent.massacre.enabled&target.health.pct<35)|target.health.pct<20|(target.health.pct>80&covenant.venthyr)
            if (talent.massacre and unit.hp(units.dyn5) < 35) or unit.hp(units.dyn5) < 20 or (unit.hp() > 80 and covenant.venthyr.active) then
                if actionList.Execute() then return true end
            end
            -- Run Action List - HAC
            -- run_action_list,name=hac,if=raid_event.adds.exists
            if ui.useAOE(8,3) then
                if actionList.HAC() then return true end
            end
            -- Run Action List - Single Target
            -- run_action_list,name=single_target
            if actionList.Single() then return true end
            -- Heroic Throw
            if ui.checked("Heroic Throw") and cast.able.heroicThrow() then
                if cast.heroicThrow() then ui.debug("Casting Heroic Throw") return true end
            end
        end -- End Combat Rotation
    end -- Pause
end -- runRotation
local id = 71
if br.rotations[id] == nil then br.rotations[id] = {} end
br._G.tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
