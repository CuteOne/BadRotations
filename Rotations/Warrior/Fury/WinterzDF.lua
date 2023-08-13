-------------------------------------------------------
-- Author = Winterz
-- Patch = 10.0
--    Patch should be the latest patch you've updated the rotation for (i.e., 9.2.5)
-- Coverage = 70%
--    Coverage should be your estimated percent coverage for class mechanics (i.e., 100%)
-- Status = Full
--    Status should be one of: Full, Limited, Sporadic, Inactive, Unknown
-- Readiness = Raid
--    Readiness should be one of: Raid, NoRaid, Basic, Development, Untested
-------------------------------------------------------
-- Required: Fill above fields to populate README.md --
-------------------------------------------------------

local rotationName = "WinterzDF" -- Change to name of profile listed in options drop down
--
--
--
--
---------------
--- Toggles ---
---------------
local function createToggles()
    -- Rotation Button
    local RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of #enemies.yards8 in range.", highlight = 1, icon = br.player.spell.whirlwind },
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.bladestorm },
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.ragingBlow },
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.enragedRegeneration}
    }
    br.ui:createToggle(RotationModes,"Rotation", 1, 0)
    -- Cooldown Button
    local CooldownModes = {
        [1] = {
            mode = "Auto",
            value = 1,
            overlay = "Cooldowns Automated",
            tip = "Automatic Cooldowns - Boss Detection.",
            highlight = 1,
            icon = br.player.spell.recklessness
        },
        [2] = {
            mode = "On",
            value = 2,
            overlay = "Cooldowns Enabled",
            tip = "Cooldowns used regardless of target.",
            highlight = 0,
            icon = br.player.spell.recklessness
        },
        [3] = {
            mode = "Off",
            value = 3,
            overlay = "Cooldowns Disabled",
            tip = "No Cooldowns will be used.",
            highlight = 0,
            icon = br.player.spell.piercingHowl
        }
    }
    br.ui:createToggle(CooldownModes,"Cooldown", 2, 0)
    -- Defensive Button
    local DefensiveModes = {
        [1] = {
            mode = "On",
            value = 1,
            overlay = "Defensive Enabled",
            tip = "Includes Defensive Cooldowns.",
            highlight = 1,
            icon = br.player.spell.enragedRegeneration
        },
        [2] = {
            mode = "Off",
            value = 2,
            overlay = "Defensive Disabled",
            tip = "No Defensives will be used.",
            highlight = 0,
            icon = br.player.spell.enragedRegeneration
        }
    }
    br.ui:createToggle(DefensiveModes,"Defensive", 3, 0)
    -- Interrupt Button
    local InterruptModes = {
        [1] = {
            mode = "On",
            value = 1,
            overlay = "Interrupts Enabled",
            tip = "Includes Basic Interrupts.",
            highlight = 1,
            icon = br.player.spell.pummel
        },
        [2] = {
            mode = "Off",
            value = 2,
            overlay = "Interrupts Disabled",
            tip = "No Interrupts will be used.",
            highlight = 0,
            icon = br.player.spell.pummel
        }
    }
    br.ui:createToggle(InterruptModes,"Interrupt", 4, 0)

end

---------------
--- OPTIONS ---
---------------
local function createOptions()
    local rotationKeys = {"None", GetBindingKey("Rotation Function 1"), GetBindingKey("Rotation Function 2"), GetBindingKey("Rotation Function 3"), GetBindingKey("Rotation Function 4"), GetBindingKey("Rotation Function 5")}
    local optionTable
    local section
    local function rotationOptions()
        -----------------------
        --- GENERAL OPTIONS ---
        -----------------------
        section = br.ui:createSection(br.ui.window.profile, "General - \124cffffff00Version 2.0.0\124r")
        -- Battle Shout
        br.ui:createCheckbox(section, "Battle Shout", "Automatic Battle Shout for Party Memebers")
        -- Berserker Rage
        br.ui:createCheckbox(section, "Berserker Rage", "Check to use Berserker Rage")
        br.ui:checkSectionState(section)
        ------------------------
        --- COOLDOWN OPTIONS ---
        ------------------------
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
        -- Trinkets
        br.ui:createDropdown(section, "Trinkets", {"Always", "With Reck"}, 1, "How to use Trinkets")
        -- Racials
        br.ui:createCheckbox(section, "Racials")
        if br.player.covenant.nightFae.active then
            -- Ancient Aftershock Units
            br.ui:createSpinner(section, "Ancient Aftershock AoE Units", 3, 1, 10, 1, "Number of units to use NF Ability on")
        -- Aftershock SingleTarget
            br.ui:createCheckbox(section, "Use Aftershock in ST")
        end
        if br.player.covenant.kyrian.active then
        -- Spear of Bastion Units
        br.ui:createSpinner(section, "Spear of Bastion Units", 3, 1, 10, 1, "Number of units to use Spear of Bastion on")
        end
        -- Dragons Roar
        br.ui:createSpinner(section, "Odyns Fury Units", 3, 1, 10, 1, "Number of units to use Odyns Fury on")
        -- Bloodrage
        -- br.ui:createCheckbox(section, "Bloodrage")
        -- Recklessness
        br.ui:createDropdownWithout(section, "Recklessness", {"Always", "Cooldown"}, 1, "Desired usage of spell.")
        br.ui:createCheckbox(section, "Avatar")
        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
        -- Healing Module
        br.player.module.BasicHealing(section)
        -- Enraged Regeneration
        br.ui:createSpinner(section, "Enraged Regeneration", 60, 0, 100, 5, "Health Percentage to use at.")
        -- high prio BT during Enraged
        br.ui:createCheckbox(section, "Prio BT during Enraged", "Do we prioritize BT for healing during ER?")
        -- Intimidating Shout
        br.ui:createSpinner(section, "Intimidating Shout", 60, 0, 100, 5, "Health Percentage to use at.")
        -- Rallying Cry
        br.ui:createSpinner(section, "Rallying Cry Units", 5, 0, 40, 1, "Number of Units below HP Value")
        br.ui:createSpinnerWithout(section, "Rallying Cry HP", 60, 0, 100, 5, "HP of Teammates to use RC")
        -- Storm Bolt
        br.ui:createSpinner(section, "Storm Bolt", 60, 0, 100, 5, "Health Percentage to use at.")
        -- Victory Rush
        br.ui:createSpinner(section, "Victory Rush", 60, 0, 100, 5, "Health Percentage to use at.")
        -- Ignore Pain
        br.ui:createSpinner(section, "Ignore Pain", 30, 0, 100, 5, "Health Percentage to use at.")
        br.ui:createSpinner(section, "Piercing Howl Defense", 20, 0, 100, 5, "Health Percentage to use at.")
        br.ui:checkSectionState(section)
        -------------------------
        --- INTERRUPT OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
        br.ui:createCheckbox(section, "Storm Bolt Logic", "Stun specific Spells and Mobs")
        -- Pummel
        br.ui:createCheckbox(section, "Pummel")
        -- Intimidating Shout
        br.ui:createCheckbox(section, "Intimidating Shout - Int")
        -- Storm Bolt
        br.ui:createCheckbox(section, "Storm Bolt - Int")
        -- Interrupt Percentage
        br.ui:createSpinner(section, "Interrupt At", 0, 0, 95, 5, "Cast Percentage to use at.")
        br.ui:checkSectionState(section)
    end
    local function mplusoptions()
        section = br.ui:createSection(br.ui.window.profile, "M+ Settings")
        -- m+ Rot
        br.ui:createSpinner(section, "Piercing Howl for Necrotic", 20, 0, 100, 1, "Enables/Disables PH")
        -- Smart Spell reflect
        br.ui:createCheckbox(section, "Smart Spell Reflect", "Auto reflect spells in instances")
        br.ui:createSpinnerWithout(section, "Smart Spell Reflect Percent", 90, 0, 95, 5, "Spell reflect when spell is X % complete, ex. 90 = 90% complete")
        br.ui:createCheckbox(section, "Shattering Throw", "Finds best targets with absorbs to Shattering Throw on.")
        br.ui:checkSectionState(section)
    end
    optionTable = {
        {
            [1] = "Rotation Options",
            [2] = rotationOptions
        },
        {
            [1] = "\124cffff6060M+ Options\124r",
            [2] = mplusoptions,
        }
    }
    return optionTable
end

--------------
--- Locals ---
--------------
-- BR API Locals - Many of these are located from System/API, this is a sample of commonly used ones but no all inclusive
local buff
local cast
local cd
local charges
local enemies
local gcdMax
local healPot
local inCombat
local level
local mode
local moving
local equiped
local php
local race
local rage
local runeforge
local spell
local talent
local units
local ui
local module
local debug
local massacreTalent
local filler
local var
local unit

-- Any variables/functions made should have a local here to prevent possible conflicts with other things.


-----------------
--- Functions --- -- List all profile specific custom functions here
-----------------
local reflectID = {
    --De Other Side
    [322736] = "Piercing Barb",
    [320230] = "Explosive Contrivance",
    [327646] = "Soulcrusher",
    [334076] = "Shadowcore",
    --Mists of Tirna Scithe
    [322557] = "Soul Split",
    [322767] = "Spirit Bolt",
    [326319] = "Spirit Bolt again",
    [325021] = "Mistveil Tear",
    [325223] = "Anima Injection",
    [325418] = "Volatile Acid",
    [326092] = "Debilitating Poison",
    --The Necrotic Wake
    [334748] = "Drain Fluids",
    [328146] = "Fetid Gas",
    [320462] = "Necrotic Bolt",
    [328667] = "Frostbolt Volley",
    [323347] = "Clinging Darkness",
    [320788] = "Frozen Binds",
    --Plaguefall
    [324527] = "Plaguestomp",
    [329110] = "Slime Injection",
    [322491] = "Plague Rot",
    [328475] = "Enveloping Webbing",
    [328002] = "Hurl Spores",
    [328094] = "Pestilence Bolt",
    [334926] = "Wretched Phlegm",
    [320512] = "Corroded Claws",
    --Sanguine Depths
    [321038] = "Wrack Soul",
    [321249] = "Shadow Claws",
    [328593] = "Agonize",
    [322554] = "Castigate",
    [326712] = "Dark Bolt",
    [326827] = "Dread Bindings",
    --Halls of Atonement
    [338003] = "Wicked Bolt",
    [326829] = "Wicked Bolt again",
    [323538] = "Bolt of Power",
    [328791] = "Ritual of Woe",
    --Spires of Ascension
    [323804] = "Dark Seeker",
    [317661] = "Insidious Venom",
    [317959] = "Dark Lash",
    [327647] = "Infernal Strike",
    [323195] = "Purifying Blast",
    [324608] = "Charged Stomp",
    --Theater of Pain
    [320120] = "Plague Bolt",
    [320300] = "Necromantic Bolt",
    [330784] = "Necrotic Bolt",
    [330810] = "Bind Soul",
    [324079] = "Reaping Scythe",
    [330875] = "Spirit Frost",
    --Castle Nathria
    --Huntsman
    [334797] = "Rip Soul",
    --LadyInerva
    [331573] = "Unconscionable Guilt"
}

local StormBoltSpell_list = {
    -- The Necrotic Wake
    [320822] = true, -- Final Bargain
    [321807] = true, -- Boneflay
    [334747] = true, -- Throw Flesh
    -- Mists of Tirna Scithe
    [322569] = true, -- Hand of Thros
    [324987] = true, -- Mistveil Bite
    [317936] = true, -- Forsworn Doctrine
    [317661] = true, -- Insidious Venom
    -- Halls of Atonement
    [326450] = true, -- Loyal Beasts
    [325701] = true, -- Siphon Life
    -- De Other Side
    [332329] = true, -- Devoted Sacrafice
    [332671] = true, -- Bladestorm
    [332156] = true, -- Spinning Up
    [334664] = true, -- Frightened Cries
    --Plaguefall
    [328177] = true, -- Fungi Storm
    [321935] = true, -- Withering Filth
    [328429] = true, -- Crushing Embrace
    [336451] = true, -- Bulwark of Maldraxxus
    [328651] = true, -- Call Venomfang
    [328400] = true, -- Stealthlings
    -- Sanguine Depths
    [322169] = true, -- Growing Mistrust
    -- Theater of Pain
    [333540] = true, -- Opportunity Strikes
    [330586] = true -- Devour Flesh
}

local Storm_unitList = {
    -- The Necrotic Wake
    [320822] = "Final Bargain",
    -- Sanguine Depths
    [334326] = "Bludgeoning Bash",
    -- Spires of Ascension
    [317936] = "Forsworn Doctrine"
}

local Shattering_absorbID = {
    -- Mists of Tirna Scithe
    [324776] = { BUFF_ID = "324776" }, -- bramblethorn-coat"
    [326046] = { BUFF_ID = "326046" }, --Stimulate Resistance",
    -- The Necrotic Wake
    [319290] = { BUFF_ID = "319290" }, --"Meatshield",
    [321754] = { BUFF_ID = "321754" }, --"Icebound Aegis",
    -- Spires of Ascension
    [327416] = { BUFF_ID = "327416" } --Recharge Anima"
}

local function already_stunned(Unit)
    if Unit == nil then
        return false
    end
    local already_stunned_list = {
        [47481] = "Gnaw",
        [5211] = "Mighty Bash",
        [22570] = "Maim",
        [19577] = "Intimidation",
        [119381] = "Leg Sweep",
        [853] = "Hammer of Justice",
        [408] = "Kidney Shot",
        [1833] = "Cheap Shot",
        [199804] = "Between the eyes",
        [107570] = "Storm Bolt",
        [46968] = "Shockwave",
        [221562] = "Asphyxiate",
        [91797] = "Monstrous Blow",
        [179057] = "Chaos Nova",
        [211881] = "Fel Eruption",
        [1822] = "Rake",
        [192058] = "Capacitor Totem",
        [118345] = "Pulverize",
        [89766] = "Axe Toss",
        [30283] = "Shadowfury",
        [1122] = "Summon Infernal",
    }
    for i = 1, #already_stunned_list do
        --  Print(select(10, UnitDebuff(Unit, i)))
        local debuffSpellID = select(10, br._G.UnitDebuff(Unit, i))
        if debuffSpellID == nil then
            return false
        end
        --    Print(tostring(already_stunned_list[tonumber(debuffSpellID)]))
        if already_stunned_list[tonumber(debuffSpellID)] ~= nil then
            return true
        end
    end
    return false
end
--------------------
--- Action Lists --- -- All Action List functions from SimC (or other rotation logic) here, some common ones provided
--------------------
local actionList = {} -- Table for holding action lists.
-- Action List - Extra
actionList.Extra = function()
    -- Battle Shout Check
    if br.timer:useTimer("BSTimer", math.random(15,40)) then
      if br.isChecked("Battle Shout") then
          if cast.able.battleShout() and not br.player.covenant.nightFae.active or (br.player.covenant.nightFae.active and not shaped) then
              for i = 1, #br.friend do
                  local thisUnit = br.friend[i].unit
                  if not br.GetUnitIsDeadOrGhost(thisUnit)
                          and br.getDistance(thisUnit) < 100
                          and br.getBuffRemain(thisUnit, spell.battleShout) < 60
                  then
                      if cast.battleShout() then
                          return true
                      end
                  end
              end
          end
      end
    end

    -- Berserker Rage
      if br.isChecked("Berserker Rage") and cast.able.berserkerRage() and br.hasNoControl(spell.berserkerRage) then
          if cast.berserkerRage() then
              return
          end
      end
    -- Shattering Throw
    if br.isChecked("Shattering Throw") then
        if cd.shatteringThrow.ready()
                and not moving
                and cast.able.shatteringThrow() then
            for i = 1, #enemies.yards30 do
                local thisUnit = enemies.yards30[i]
                local ID = br._G.ObjectID(thisUnit)
                local shatterUnit = Shattering_absorbID[ID]
                if shatterUnit ~= nil and br.getBuffRemain(thisUnit, shatterUnit.BUFF_ID) > 0 then
                    if cast.shatteringThrow(thisUnit) then
                        return true
                    end
                end
            end
        end
    end
end-- End Action List - Extra
-- Action List - Defensive
actionList.Defensive = function()
    if br.useDefensive() then
        -- Healthstone/Health Potion
        module.BasicHealing()
        -- Enraged Regeneration
        if br.isChecked("Enraged Regeneration") and cast.able.enragedRegeneration() and php <= br.getOptionValue("Enraged Regeneration") then
            if cast.enragedRegeneration() then
                return
            end
        end

        -- Intimidating Shout
        if br.isChecked("Intimidating Shout") and cast.able.intimidatingShout() and php <= br.getOptionValue("Intimidating Shout") then
            if cast.intimidatingShout() then
                return
            end
        end

        -- Rallying Cry
        if br.isChecked("Rallying Cry Units") and cast.able.rallyingCry() and br.getLowAllies(br.getValue("Rallying Cry HP")) >= br.getValue("Rallying Cry Units") then
            if cast.rallyingCry() then
                return
            end
        end

        -- Storm Bolt
        if br.isChecked("Storm Bolt") and cast.able.stormBolt() and php <= br.getOptionValue("Storm Bolt") then
            if cast.stormBolt() then
                return
            end
        end

        -- Ignore Pain
        if br.isChecked("Ignore Pain") and cast.able.ignorePain() and rage > 60 and php <= br.getOptionValue("Ignore Pain") and not buff.ignorePain.exists("player") then
            if cast.ignorePain("player") then
                return
            end
        end

        -- Piercing Howl
        if br.isChecked("Piercing Howl Defense") and php <= br.getOptionValue("Piercing Howl Defense") and inCombat then
            if cast.piercingHowl("player") then
                return
            end
        end

        -- Victory Rush
        if br.isChecked("Victory Rush") and (cast.able.victoryRush() or cast.able.impendingVictory()) and php <= br.getOptionValue("Victory Rush") and buff.victorious.exists("player") then
            if talent.impendingVictory then
                if cast.impendingVictory() then
                    return
                end
            else
                if cast.victoryRush() then
                    return
                end
            end
        end

        -- Smart Spell Reflect
        if br.isChecked("Smart Spell Reflect") and cd.spellReflection.ready() then
            for i = 1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                local _, _, _, startCast, endCast, _, _, _, spellcastID = br._G.UnitCastingInfo(thisUnit)
                    if (select(3, br._G.UnitCastID(thisUnit)) == br._G.ObjectPointer("player") or select(4, br._G.UnitCastID(thisUnit)) == br._G.ObjectPointer("player"))
                        and reflectID[spellcastID]
                        and (((br._G.GetTime() * 1000) - startCast) / (endCast - startCast) * 100) > br.getOptionValue("Smart Spell Reflect Percent") then
                                if cast.spellReflection() then
                                    br.addonDebug("[CD] Spell Reflecting:" .. br._G.UnitName(thisUnit) .. "/" .. tostring(spellCastID))
                                    return
                                end
                    end
            end
        end
    end
end -- End Action List - Defensive
-- Action List - Interrrupt
actionList.Interrupt = function()
    if br.useInterrupts() then
        if br.isChecked("Storm Bolt Logic") and cd.stormBolt.ready() then
            if cast.able.stormBolt() then
                for i = 1, #enemies.yards20 do
                    local thisUnit = enemies.yards20[i]
                    local unitDist = br.getDistance(thisUnit)
                        if (Storm_unitList[br.GetObjectID(thisUnit)] ~= nil or StormBoltSpell_list[select(9, br._G.UnitCastingInfo(thisUnit))] ~= nil or StormBoltSpell_list[select(7, br._G.GetSpellInfo(br._G.UnitChannelInfo(thisUnit)))] ~= nil) and br.getBuffRemain(thisUnit, 226510) == 0 and unitDist <= 18 then
                            if cast.stormBolt(thisUnit) then
                                return true
                             end
                        end
                end
        end
    end
        for i = 1, #enemies.yards20 do
            local thisUnit = enemies.yards20[i]
            local distance = br.getDistance(thisUnit)
            if br.canInterrupt(thisUnit, br.getOptionValue("Interrupt At")) then
                -- Pummel
                if br.isChecked("Pummel") and cast.able.pummel(thisUnit) and distance < 5 then
                    if cast.pummel(thisUnit) then
                        return
                    end
                end
                -- Intimidating Shout
                if br.isChecked("Intimidating Shout - Int") and cast.able.intimidatingShout() and distance < 8 then
                    if cast.intimidatingShout() then
                        return
                    end
                end
                -- Storm Bolt
                if br.isChecked("Storm Bolt - Int") and cast.able.stormBolt(thisUnit) and distance < 20 then
                    if cast.stormBolt(thisUnit) then
                        return
                    end
                end
            end
        end
    end
end -- End Action List - Interrupt
-- Action List ST
actionList.ST = function()
        -- Prio BT during Enraged
        if br.isChecked("Prio BT during Enraged") and buff.enragedRegeneration.exists("player") then
            if cast.bloodthirst() then
                return
            end
        end
        -- Recklessness
        if not buff.recklessness.exists("player")
        and (br.getOptionValue("Recklessness") == 1 or (br.getOptionValue("Recklessness") == 2
        and br.useCDs()))
        and mode.cooldown ~= 3
        and #enemies.yards5 > 0 then
            if cast.recklessness() then
                return
            end
        end
        -- Avatar
        if cast.able.avatar() and not buff.avatar.exists("player") and br.isChecked("Avatar") and mode.cooldown ~= 3 and #enemies.yards5 > 0 then
            if cast.avatar() then ui.debug("Casting Avatar")
                return
            end
        end
        -- Rampage
        if buff.recklessness.exists("player") or (rage >= 85) or not buff.enrage.exists("player") then
            if cast.rampage() then
                return
            end
        end
        -- Crushing blow
        if cast.able.crushingBlow() and (equiped.tier(28) >= 2 or charges.crushingBlow.count() == 2) then
            if cast.crushingBlow() then ui.debug("Casting Crushing Blow [ST - 2 Charges]")
                return
            end
        end

        -- condemn MASSACRE test
        if br.player.covenant.venthyr.active then
            for i = 1, #enemies.yards5 do
                local thisUnit = enemies.yards5[i]
                if ((br.getHP(thisUnit) >80 or buff.suddenDeath.exists("player")) or (talent.massacre and br.getHP(thisUnit) <= 35)) then
                    if br._G.CastSpellByName(br._G.GetSpellInfo(330325), enemies.yards5[i]) then debug("Condemn MASSACRE Multitarget")
                        return
                    end
                end
            end
        end
        -- condemn NON-massacre
        if br.player.covenant.venthyr.active then
            for i = 1, #enemies.yards5 do
                local thisUnit = enemies.yards5[i]
                if (br.getHP(thisUnit) >80 or buff.suddenDeath.exists("player")) then
                    if br._G.CastSpellByName(br._G.GetSpellInfo(317485), enemies.yards5[i]) then debug("Condemn Non-Massacre Multitarget")
                        return
                    end
                end
            end
        end
        -- EXECUTE MASSACRE
        if not br.player.covenant.venthyr.active then
            for i = 1, #enemies.yards5 do
                local thisUnit = enemies.yards5[i]
                if br.getFacing("player",thisUnit) and talent.massacre and br.getHP(thisUnit) <= 35 or buff.suddenDeath.exists("player") and (buff.enrage.exists("player") or rage <= 70) then
                    if cast.executeMassacre(thisUnit) then debug("Execute Massacre")
                        return
                    end
                end
            end
        end
        -- Execute non-MASSACRE
        if not br.player.covenant.venthyr.active then
            for i = 1, #enemies.yards5 do
                local thisUnit = enemies.yards5[i]
                if br.getFacing("player",thisUnit) and br.getHP(thisUnit) <= 20 and (buff.enrage.exists("player") or rage <= 70) then
                    if cast.execute(thisUnit) then debug("Execute NON Massacre")
                        return
                    end
                end
            end
        end
        -- Spear of Bastion
        if cast.able.spearOfBastion("best",nil,1, 5) and br.isChecked("Spear of Bastion Units") and buff.enrage.exists("player") and mode.cooldown ~= 3 then
            if cast.spearOfBastion("best",nil, 1, 5) then ui.debug("Spear ST")
                return
            end
        end
        -- Onslaught
        if (rage <= 85) and buff.enrage.exists("player") then
            if cast.onslaught() then
                return
            end
        end
        -- Raging Blow
        if charges.ragingBlow.count() >= 2 and buff.enrage.exists("player") then
            if cast.ragingBlow() then
                return
            end
        end

        -- Low Prio Bloodthirst
        if cast.bloodthirst() then
            return
        end
        -- Ancient Aftershock ST
        if (br.isChecked("Use Aftershock in ST") and br.isBoss("target")) and cast.able.ancientAftershock(units.dyn12, "cone", 1, 12) and buff.enrage.exists("player") then
            if cast.ancientAftershock(units.dyn12, "cone", 1, 12) then debug("Aftershock SINGLETARGET!!")
                return
            end
        end
        -- Raging Blow Dump
        if cast.ragingBlow() then
            return
        end

        -- whirlwind filler
        if filler then
            if cast.whirlwind(units.dyn5, "aoe", 1, 5) then debug("WW ST Filler")
                return
            end
        end
end-- End of ST List
-- Action List AOE
actionList.AOE = function()
-- BT if Fresh Meat and not Enraged   test later
        -- Fresh Meat test
        if not buff.enrage.exists("player") and talent.freshMeat and br.getCombatTime() < 3 then
            if cast.bloodthirst() then
                return
            end
        end
        -- Ancient Aftershock
        if br.isChecked("Ancient Aftershock AoE Units") and cast.able.ancientAftershock(units.dyn12, "cone", 1, 12) and #enemies.yards12c >= br.getOptionValue("Ancient Aftershock AoE Units") and buff.enrage.exists("player") and (buff.recklessness.exists("player") or cd.recklessness.remain() > 5) then
            if cast.ancientAftershock(units.dyn12, "cone", 1, 12) then debug("Aftershock!!")
                return
            end
        end
        -- Maintain Whirlwind buff
        if not buff.whirlwind.exists("player") then
            if cast.whirlwind(units.dyn5, "aoe", 1, 5) then debug("WW MT Maintain")
                return
            end
        end
        -- WW spam > 5 targets with merciless bonegrinder
        if cast.able.whirlwind("player","aoe",1,8) and buff.mercilessBonegrinder.exists() and #enemies.yards8 > 5 then
        if cast.whirlwind("player","aoe",1,8) then ui.debug("Casting Whirlwind [ST - Merciless Bonegrinder]") return true end
        end
        -- Spear of Bastion
        if cast.able.spearOfBastion("best",nil,2, 5) and br.isChecked("Spear of Bastion Units") and mode.cooldown ~= 3 then
            if cast.spearOfBastion("best",nil, 2, 5) then ui.debug("Spear AOE")
                return
            end
        end
        -- Recklessness
        if not buff.recklessness.exists()
        and (cd.spearOfBastion.remain() > 5)
        and (br.getOptionValue("Recklessness") == 1 or (br.getOptionValue("Recklessness") == 2
        and br.useCDs())) and mode.cooldown ~= 3
        and #enemies.yards5 > 0 then
            if cast.recklessness() then
                return
            end
        end
        -- Avatar
        if cast.able.avatar() and not buff.avatar.exists("player") and br.isChecked("Avatar") and mode.cooldown ~= 3 and #enemies.yards5 > 0 then
            if cast.avatar() then ui.debug("Casting Avatar")
                return
            end
        end
        -- Odyns Fury
        if buff.enrage.exists("player") and br.isChecked("Odyns Fury Units") and #enemies.yards12 >= br.getOptionValue("Odyns Fury Units") and mode.cooldown ~= 3 then
            if cast.odynsFury() then
                return
            end
        end
        -- Rampage
        if buff.whirlwind.exists("player") and (buff.recklessness.exists("player") or (not buff.enrage.exists("player") or (rage >= 85)) or (buff.frenzy.remain() < 2)) then
            if cast.rampage() then
                return
            end
        end
        -- Crushing blow
        if cast.able.crushingBlow() and (equiped.tier(28) >= 2 or charges.crushingBlow.count() == 2) then
            if cast.crushingBlow() then ui.debug("Casting Crushing Blow [AoE - 2 Charges]")
                return
            end
        end

        -- crushing blow if tier set // actions.single_target+=/crushing_blow,if=set_bonus.tier28_2pc|charges=2|(buff.recklessness.up&variable.execute_phase&talent.massacre.enabled)
        if cast.able.crushingBlow() and (equiped.tier(28) >= 2 or charges.crushingBlow.count() >= 2 or (buff.recklessness.exists() and (br.getHP("target") <= 35) and talent.massacre)) then
            if cast.crushingBlow() then ui.debug("Casting Crushing Blow [AoE - >=2 Charges]")
                return
            end
        end

                -- condemn MASSACRE test
        if br.player.covenant.venthyr.active then
            for i = 1, #enemies.yards5 do
                local thisUnit = enemies.yards5[i]
                if buff.whirlwind.exists("player") and ((br.getHP(thisUnit) >80 or buff.suddenDeath.exists("player")) or (talent.massacre and br.getHP(thisUnit) <= 35)) then
                    if cast.condemnMassacre(thisUnit) then debug("Condemn MASSACRE Multitarget")
                        return
                    end
                end
            end
        end
        -- condemn NON-massacre
        if br.player.covenant.venthyr.active then
            for i = 1, #enemies.yards5 do
                local thisUnit = enemies.yards5[i]
                if buff.whirlwind.exists("player") and (br.getHP(thisUnit) >80 or buff.suddenDeath.exists("player")) then
                    if cast.condemn(thisUnit) then debug("Condemn Non-Massacre Multitarget")
                        return
                    end
                end
            end
        end


        -- EXECUTE MASSACRE
        if not br.player.covenant.venthyr.active then
            for i = 1, #enemies.yards5 do
                local thisUnit = enemies.yards5[i]
                if buff.whirlwind.exists("player") and br.getFacing("player",thisUnit) and cast.able.executeMassacre() and talent.massacre and br.getHP(thisUnit) <= 35 or buff.suddenDeath.exists("player") and (buff.enrage.exists("player") or rage <= 70) then
                    if cast.executeMassacre(thisUnit) then debug("Execute Massacre Multitarget")
                        return
                    end
                end
            end
        end
        -- Execute non-MASSACRE
        if not br.player.covenant.venthyr.active then
            for i = 1, #enemies.yards5 do
                local thisUnit = enemies.yards5[i]
                if buff.whirlwind.exists("player") and br.getFacing("player",thisUnit) and cast.able.execute() and br.getHP(thisUnit) <= 20 and (buff.enrage.exists("player") or rage <= 70) then
                    if cast.execute(thisUnit) then debug("Execute non-Massacre Multitarget")
                        return
                    end
                end
            end
        end
                -- Onslaught
        if (rage <= 85) and buff.enrage.exists("player") then
            if cast.onslaught() then
                return
            end
        end
        -- Merciless Bonegrinder up to 5 targets
        if cast.able.whirlwind("player","aoe",1,8) and buff.mercilessBonegrinder.exists() then
            if cast.whirlwind("player","aoe",1,8) then ui.debug("Casting Whirlwind [ST - Merciless Bonegrinder]") return true end
        end
        -- Raging Blow
        if buff.whirlwind.exists("player") and charges.ragingBlow.count() >= 2 and buff.enrage.exists("player") then
            if cast.ragingBlow() then debug("RB @ 2 stacks MT")
                return
            end
        end

        -- Low Prio Bloodthirst
        if buff.whirlwind.exists("player") then
            if cast.bloodthirst() then
                return
            end
        end

        -- Raging Blow Dump
        if buff.whirlwind.exists("player") then
            if cast.ragingBlow() then
                return
            end
        end
end -- End of AOE List
-- Action List - Cooldowns
actionList.Cooldown = function()
    if br.isChecked("Trinkets") and (br.getOptionValue("Trinkets") == 1 or (br.getOptionValue("Trinkets") == 2 and buff.recklessness.remain("player") >3)) and inCombat and br.canUseItem(13) then
        if br.useItem(13) then debug("Using Trinket 1")
            return
        end
    end
    if br.isChecked("Trinkets") and (br.getOptionValue("Trinkets") == 1 or (br.getOptionValue("Trinkets") == 2 and buff.recklessness.remain("player") >3)) and inCombat and br.canUseItem(14) then
        if br.useItem(14) then debug("Using Trinket 2")
            return
        end
    end
    if br.isChecked("Racials") and mode.cooldown ~= 4 and buff.recklessness.exists("player") then
        if race == "Orc" or race == "Troll" or race == "LightforgedDraenei" or race=="MagharOrc" then
            if cast.racial("player") then
                return
            end
        end
    end
end -- End Action List - Cooldowns

-- Action List - Pre-Combat
actionList.PreCombat = function()
    if not unit.inCombat() and not (unit.flying() or unit.mounted() or unit.taxi()) then -- Only run when not in combat and not flying/mounted/taxi
        if ui.checked("Pre-Pull Timer") and ui.pullTimer() <= ui.value("Pre-Pull Timer") then
            -- Logic based on pull timers (IE: DBM/BigWigs)
        end -- End Pre-Pull
        if unit.valid("target") then -- Abilities below this only used when target is valid
            -- Start Attack
            if unit.distance("target") < 5 then -- Starts attacking if enemy is within 5yrds
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
local function runRotation() -- This is the main profile loop, any below this point is ran every cycle, everything above is ran only once during initialization.
    ---------------------
    --- Define Locals ---
    ---------------------
    -- BR API Locals - These are the same as the locals above just defined for use.
    buff                                              = br.player.buff
    cast                                              = br.player.cast
    cd                                                = br.player.cd
    charges                                           = br.player.charges
    enemies                                           = br.player.enemies
    gcdMax                                            = br.player.gcdMax
	healPot                                           = br.getHealthPot()
    inCombat                                          = br.player.inCombat
    level                                             = br.player.level
    mode                                              = br.player.ui.mode
    moving                                            = br._G.GetUnitSpeed("player") > 0
    php                                               = br.player.health
    race                                              = br.player.race
    rage                                              = br.player.power.rage.amount()
    runeforge                                         = br.player.runeforge
    spell                                             = br.player.spell
    talent                                            = br.player.talent
    units                                             = br.player.units
    ui                                                = br.player.ui
    module 										      = br.player.module
    debug                                             = br.addonDebug
    massacreTalent                                    = talent.massacre and 1.5 or 0
    filler                                            = cd.bloodthirst.remain() > (gcdMax / 2) and cd.ragingBlow.remain() > (gcdMax / 2) and true or false
    var                                               = br.player.variables
    unit                                              = br.player.unit
    equiped                                           = br.player.equiped

    -- Explanations on the Units and Enemies functions can be found in System/API/Units.lua and System/API/Enemies.lua
    -------------
    --- Units ---
    -------------
    units.get(5)
    units.get(8)

    ---------------
    --- Enemies ---
    ---------------
    enemies.get(5)
    enemies.get(8)
    enemies.get(12)
    enemies.get(15)
    enemies.get(20)
    enemies.get(30)
    enemies.get(40)
    enemies.cone.get(45, 12, false, false)

    ------------------------
    --- Custom Variables ---
    ------------------------
    -- Any other local variable from above would also need to be defined here to be use.
    if var.profileStop == nil then var.profileStop = false end -- Trigger variable to help when needing to stop a profile.


    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Profile Stop | Pause
    if not unit.inCombat() and not unit.exists("target") and var.profileStop then -- Reset profile stop once stopped
        var.profileStop = false
    elseif (unit.inCombat() and var.profileStop) or ui.pause() or unit.mounted() or unit.flying() or ui.mode.rotation == 4 then -- If profile triggered to stop go here until it has.
        return true
    else -- Profile is free to perform actions
        --------------
        --- Extras ---
        --------------
        if actionList.Extra() then return true end -- This runs the Extra Action List and anything in it will run in or out of combat, this generally contains utility functions.
        -----------------
        --- Defensive ---
        -----------------
        if actionList.Defensive() then return true end -- This runs the Defensive Action List and anything in it will run in or out of combat, this generally contains defensive functions.
        ------------------
        --- Pre-Combat ---
        ------------------
        if actionList.PreCombat() then return true end  -- This runs the Pre-Combat Action List and anything in it will run in or out of combat, this generally includes functions that prepare for or start combat.
        -----------------
        --- In Combat ---
        -----------------
        if unit.inCombat() and unit.valid("target") and not var.profileStop then -- Everything below this line only run if you are in combat and the selected target is validated and not triggered to stop.
            ------------------
            --- Interrupts ---
            ------------------
            if actionList.Interrupt() then return true end -- This runs the Interrupt Action List, this generally contains interrupt functions.
            ------------------
            --- Cooldowns  ---
            ------------------
            if actionList.Cooldown() then return true end -- This runs Cooldown List
            ------------
            --- Main ---
            ------------
            -- Start Attack - This will start auto attacking your target if it's within 5yrds and valid
            if unit.distance("target") <= 5 then
                if cast.able.autoAttack("target") then
                    if cast.autoAttack("target") then ui.debug("Casting Auto Attack [Pre-Combat]") return true end
                end
            end
            if ((mode.rotation == 1 and #enemies.yards8 >= 2) or (mode.rotation == 2 and #enemies.yards8 > 0)) then
                --print("multi")
                if actionList.AOE() then return end
            end
            if ((mode.rotation == 1 and #enemies.yards8 < 2) or (mode.rotation == 3 and #enemies.yards8 > 0)) then
                --print("single")
                if actionList.ST() then return end
            end
        end -- End In Combat Rotation
    end -- Pause
end -- End runRotation
local id = 72
if br.rotations[id] == nil then br.rotations[id] = {} end
br._G.tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})