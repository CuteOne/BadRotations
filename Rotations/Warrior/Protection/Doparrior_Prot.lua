--Version 1.1.5
-- Big thank yous to Laks, Panglo, Kuu, and Ashley <333
local rotationName = "Doparrior_Prot"

---------------
--- Toggles ---
---------------
local function createToggles()
    -- Rotation Button
    local RotationModes = {
        [1] = { mode = "Auto", value = 1, overlay = "Automatic Rotation", tip = "Enable Rotation", highlight = 0, icon = br.player.spell.shieldSlam },
        [2] = { mode = "Off", value = 2, overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.enragedRegeneration }
    }
    br.ui:createToggle(RotationModes, "Rotation", 1, 0)
    -- Cooldown Button
    local CooldownModes = {
        [1] = { mode = "Auto", value = 1, overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Based on settings", highlight = 0, icon = br.player.spell.avatar },
        [2] = { mode = "On", value = 2, overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.avatar },
        [3] = { mode = "Off", value = 3, overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.avatar }
    }
    br.ui:createToggle(CooldownModes, "Cooldown", 2, 0)
    -- Defensive Button
    local DefensiveModes = {
        [1] = { mode = "On", value = 1, overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 0, icon = br.player.spell.shieldWall },
        [2] = { mode = "Off", value = 2, overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.shieldWall }
    }
    br.ui:createToggle(DefensiveModes, "Defensive", 3, 0)
    -- Interrupt Button
    local InterruptModes = {
        [1] = { mode = "On", value = 1, overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 0, icon = br.player.spell.pummel },
        [2] = { mode = "Off", value = 2, overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.pummel }
    }
    br.ui:createToggle(InterruptModes, "Interrupt", 4, 0)
    -- Movement Button
    local MoverModes = {
        [1] = { mode = "On", value = 1, overlay = "Mover Enabled", tip = "Will use Charge/Heroic Leap.", highlight = 0, icon = br.player.spell.charge },
        [2] = { mode = "Off", value = 2, overlay = "Mover Disabled", tip = "Will NOT use Charge/Heroic Leap.", highlight = 0, icon = br.player.spell.charge }
    }
    br.ui:createToggle(MoverModes, "Mover", 5, 0)
    local TauntModes = {
        [1] = { mode = "Dun", value = 1, overlay = "Taunt only in Dungeon", tip = "Taunt will be used in dungeons.", highlight = 0, icon = br.player.spell.taunt },
        [2] = { mode = "All", value = 2, overlay = "Auto Taunt Enabled", tip = "Taunt will be used everywhere.", highlight = 0, icon = br.player.spell.taunt },
        [3] = { mode = "Off", value = 3, overlay = "Auto Taunt Disabled", tip = "Taunt will not be used.", highlight = 0, icon = br.player.spell.taunt }
    }
    br.ui:createToggle(TauntModes, "Taunt", 6, 0)
    -- Tankbuster Button
    local TankbusterModes = {
        [1] = { mode = "On", value = 1, overlay = "M+ Tankbuster Enabled", tip = "Will use Shield Block to Mitigate Tank Busters", highlight = 0, icon = br.player.spell.shieldBlock },
        [2] = { mode = "Off", value = 2, overlay = "M+ Tankbuster Disabled", tip = "Will NOT use Shield Block to Mitigate Tank Busters", highlight = 0, icon = br.player.spell.shieldBlock }
    }
    br.ui:createToggle(TankbusterModes, "Tankbuster", 0, 1)
    -- Defensive/Aggressive Button
    local AggressionModes = {
        [1] = { mode = "Offense", value = 1, overlay = "Offense", tip = "Uses revenge regardless of rage pool settings when Shield Slam and TC are on CD.", highlight = 1, icon = br.player.spell.revenge },
        [2] = { mode = "Defense", value = 2, overlay = "Defense", tip = "Uses rage pool configuration to pool rage for SB/IP and only use revenge (no proc) on rage dump.", highlight = 1, icon = br.player.spell.ignorePain }
    }
    br.ui:createToggle(AggressionModes, "Aggression", 1, 1)

    -- AutoPot Button
    local PotsModes = {
        [1] = { mode = "On", value = 1, overlay = "Use Pots", tip = "Use Pots", highlight = 1, icon = 2259 },
        [2] = { mode = "Off", value = 2, overlay = "Use Pots", tip = "Use Pots", highlight = 0, icon = 2259 },
    }
    br.ui:createToggle(PotsModes, "Pots", 6, 1)

    -- Soulshape Button
    if br.player.covenant.nightFae.active then
        local SoulshaperModes = {
            [1] = { mode = "Moving", value = 1, overlay = "Moving Enabled", tip = "Will soulshape when movement detected not mounted and out of combat", highlight = 1, icon = br.player.spell.soulshape },
            [2] = { mode = "Hold", value = 2, overlay = "Hold Enabled", tip = "Will soulshape when key is held down", highlight = 0, icon = br.player.spell.soulshape }
        }
        br.ui:createToggle(SoulshaperModes, "Soulshaper", 5, 1)
    end

    -- Kyrian Steward Button
    if br.player.covenant.kyrian.active then
        local StewardModes = {
            [1] = { mode = "On", value = 1, overlay = "PoS Enabled", tip = "Will auto summon your steward for phial of serenity when you run out, will also auto use Phial based on your settings.", highlight = 1, icon = br.player.spell.summonSteward },
            [2] = { mode = "Off", value = 2, overlay = "PoS Disabled", tip = "Will not auto summon your steward. (Useful for dungeons like NW)", highlight = 0, icon = br.player.spell.summonSteward }
        }
        br.ui:createToggle(StewardModes, "Steward", 5, 1)
    end

end

---------------
--- OPTIONS ---
---------------
local function createOptions()
    local optionTable
    local section
    local function rotationOptions()
        -----------------------
        --- GENERAL OPTIONS ---
        -----------------------
        section = br.ui:createSection(br.ui.window.profile, "General - Version 1.1.5")
            br.ui:createCheckbox(section, "Open World Defensives", "Use this checkbox to ensure defensives are used while in Open World")
            -- Berserker Rage
            br.ui:createCheckbox(section, "Berserker Rage", "Check to use Berserker Rage")
            -- Shout Check
            br.ui:createCheckbox(section, "Battle Shout", "Enable automatic party buffing")
        br.ui:checkSectionState(section)
        -------------------------
        --- Legendary OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Legendary Support [WIP]")
            -- Reprisal
            br.ui:createCheckbox(section, "Reprisal Support", "Uses charge/intervene automatically to keep up Shield Block.")
            br.ui:createCheckbox(section, "Reprisal - Melee Intervene", "Uses charge/intervene automatically to keep up Shield Block.")
            br.ui:createDropdownWithout(section, "Reprisal - Charge Intervene Key", br.dropOptions.Toggle, 6, "Intervene to ally based on Min/Max Distance and then charge to refresh reprisal")
            br.ui:createSpinnerWithout(section, "Reprisal - Min Distance", 10, 8, 25, 1, "|cffFFBB00Set to desired yards to Intervene Charge Intervene combo. Min: 8 / Max: 25")
            br.ui:createSpinnerWithout(section, "Reprisal - Max Distance", 20, 8, 25, 1, "|cffFFBB00Set to desired yards to Intervene Charge Intervene combo. Min: 8 / Max: 25")
        br.ui:checkSectionState(section)
        ------------------------
        --- MOVEMENT OPTIONS ---
        ------------------------
        section = br.ui:createSection(br.ui.window.profile, "Movement")
            if br.player.covenant.nightFae.active then
                -- Auto Soulshape
                br.ui:createCheckbox(section, "Auto Soulshape", "|cff0070deCheck this to automatically control SS transformation based on toggle bar setting.")
                br.ui:createCheckbox(section, "Auto Flicker", "Check to use Flicker while Soulshaped")
                br.ui:createDropdownWithout(section, "Soulshape Key", br.dropOptions.Toggle, 6, "|cff0070deSet key to hold down for SS")
            end
            -- Charge
            br.ui:createCheckbox(section, "Charge", "Check to use Charge")
            br.ui:createCheckbox(section, "OOC Charge")
            -- Heroic Leap
            br.ui:createDropdownWithout(section, "Heroic Leap Useage", br.dropOptions.Toggle, 6, "Set auto usage (No Hotkey) or desired hotkey to use Heroic Leap.")
            br.ui:createDropdownWithout(section, "Heroic Leap - Target", { "Best", "Target", "Heroic Charge" }, 1, "Desired Target of Heroic Leap")
            br.ui:createSpinnerWithout(section, "Heroic Charge - Min Distance", 15, 8, 25, 1, "|cffFFBB00Set to desired yards to Heroic Leap out for Charge/Leap Combo. Min: 8 / Max: 25 / Interval: 1")
        br.ui:checkSectionState(section)
        -------------------------
        --- RAGE OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Rage Config")
            -- Rage Pooling
            br.ui:createSpinnerWithout(section, "Rage Pooling", 80, 1, 100, 1, "|cffFFFFFF Set amount of rage to pool before using Revenge/Execute.")
        br.ui:checkSectionState(section)
        -------------------------
        --- OFFENSIVE OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Offensive")
            -- Aoe Threshold
            br.ui:createSpinnerWithout(section, "AoE Threshold", 3, 1, 10, 1, "Set number of units to prioritise Thunderclaps, and Revenge over Execute")
            if br.player.covenant.nightFae.active then
                -- Ancient Aftershock Units
                br.ui:createSpinnerWithout(section, "Ancient Aftershock Units", 3, 1, 10, 1, "Number of units to use Ancient Aftershock on")
            end
            if br.player.covenant.venthyr.active then
                -- Condemn
                br.ui:createCheckbox(section, "Condemn", "Will use condemn instead of ignore pain when a nearby target's health is over 80% or under 20%.")
            end
            if br.player.covenant.kyrian.active then
                -- Spear of Bastion Units
                br.ui:createSpinner(section, "Spear of Bastion Units", 3, 1, 10, 1, "Number of units to use Spear of Bastion on")
            end
            -- Dragons Roar
            br.ui:createCheckbox(section, "Dragon Roar")
            -- Heroic Throw
            br.ui:createCheckbox(section, "Heroic Throw - Ranged DPS", "Use heroic throw for DPS when more than 8yds away from target and nothing to hit in melee.")
            br.ui:createCheckbox(section, "Heroic Throw - Aggro", "Use heroic throw for aggro and when no active threat targets are in range.")
            br.ui:createCheckbox(section, "Heroic Throw - Explosive", "Use heroic throw for to snipe explosives in range.")
            -- Ravager
            br.ui:createCheckbox(section, "Ravager", "Finds best targets to throw ravager while you're not moving.")
            -- Shattering Throw
            br.ui:createCheckbox(section, "Shattering Throw", "Finds best targets with absorbs to Shattering Throw on.")
            -- Shockwave
            br.ui:createSpinner(section, "Shockwave - Units", 7, 1, 10, 1, "|cffFFBB00Minimal units to cast on.")
        br.ui:checkSectionState(section)
        ------------------------
        --- COOLDOWN OPTIONS ---
        ------------------------
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
            -- Conquerors Banner
            if br.player.covenant.necrolord.active then
                br.ui:createCheckbox(section, "Conqueror's Banner")
            end
            -- Challenging Shout
            br.ui:createSpinnerWithout(section, "Challenging Shout - Units", 5, 0, 10, 1, "|cffFFFFFFAmount of enemies not aggro'd to you and near you to cast Challenging Shout on")
            -- Avatar
            br.ui:createDropdownWithout(section, "Avatar - CD", { "Always", "When CDs Up", "On unit count", "Never" }, 1)
            br.ui:createSpinnerWithout(section, "Avatar Mob Count", 5, 0, 10, 1, "|cffFFFFFFEnemies needed to cast Avatar")
            br.ui:createCheckbox(section, "Avatar - Racials", "Automatically Use racials with Avatar")
            if br.player.race == "Vulpera" then
                -- Auto Vulpera Heal
                br.ui:createSpinner(section, "Vulpera Racial Heal", 85, 1, 100, 1, "|cffFFFFFF Set to health percent to use Bag of Tricks on self")
            end
        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
            -- Necrolord Stuff
            if br.player.covenant.necrolord.active then
                br.ui:createDropdownWithout(section, "Fleshcraft Key", br.dropOptions.Toggle, 6, "Fleshcraft on Hold")
                -- Fleshcraft
                br.ui:createSpinner(section, "Fleshcraft - HP", 85, 1, 100, 1, "|cffFFFFFF Set to health percent to use Fleshcraft")
                br.ui:createSpinnerWithout(section, "Fleshcraft - Units", 3, 1, 10, 1, "Set number of units to use Fleshcraft")
            end
            -- Demoralizing Shout
            br.ui:createDropdown(section, "Demo Shout Useage", { "Always", "When CDs are enabled", "On unit count", "HP", "Rage Generator", "Never" }, 1)
            br.ui:createSpinnerWithout(section, "Demo Shout - HP", 65, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
            br.ui:createSpinnerWithout(section, "Demo Shout - Rage", 65, 0, 100, 5, "|cffFFBB00Minimum rage to cast Demo Shout for Booming Voice")
            br.ui:createSpinnerWithout(section, "Demo Shout - Unit Count", 3, 1, 10, 1, "Set number of units to prioritise Demo Shout")
            -- Last Stand
            br.ui:createDropdownWithout(section, "Last Stand Useage", { "Always", "HP", "Never" }, 1)
            br.ui:createSpinnerWithout(section, "Last Stand - HP", 65, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
            -- Ignore Pain
            br.ui:createDropdownWithout(section, "Ignore Pain Useage", { "Always", "IP if SB on CD", "HP", "Never" }, 1)
            br.ui:createSpinnerWithout(section, "Ignore Pain - HP", 90, 1, 100, 1, "|cffFFFFFF Set to personal HP percent to start considering using Ignore Pain")
            br.ui:createSpinnerWithout(section, "Ignore Pain - Time Remain", 2, 1, 12, 1, "|cffFFFFFF Set (in seconds) time remaining on ignore pain before refresh.")
            -- Rallying Cry
            br.ui:createSpinner(section, "Rallying Cry", 45, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
            -- Shield Block
            br.ui:createSpinner(section, "Shield Block - HP", 65, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
            br.ui:createSpinner(section, "Shield Block - Unit Count", 3, 1, 10, 1, "Set number of units to prioritise Shield Block")
            --br.ui:createSpinnerWithout(section, "Shield Block - Hold Charges", 1, 0, 2, 1, "|cffFFBB00Number of Shield Block charges the rotation will hold for manual use or tankbuster.");
            br.ui:createSpinnerWithout(section, "Shield Block - Time Remain", 10, 1, 12, 1, "|cffFFFFFF Set (in seconds) time remaining on shield block before refresh.")
            -- Shield Wall
            br.ui:createSpinner(section, "Shield Wall", 45, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
            -- Smart Spell reflect
            br.ui:createCheckbox(section, "Smart Spell Reflect", "Auto reflect spells in instances")
            br.ui:createSpinnerWithout(section, "Smart Spell Reflect Percent", 90, 0, 95, 5, "Spell reflect when spell is X % complete, ex. 90 = 90% complete")
            -- Victory Rush
            br.ui:createSpinnerWithout(section, "Victory Rush - HP", 90, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
        br.ui:checkSectionState(section)
        -------------------------
        --- UTILITY OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Utility")
            -- Engi Belt stuff thanks to Lak
            br.ui:createSpinner(section, "Engineering Belt", 45, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
            if br.player.covenant.kyrian.active then
                -- Phial of Serenity
                br.ui:createDropdown(section, "Phial of Serenity Useage", { "HP", "Necrotic Stacks", "Grievous Stacks" }, 1)
                br.ui:createSpinnerWithout(section, "Phial of Serenity - HP", 35, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
                br.ui:createSpinnerWithout(section, "Phial of Serenity - Necrotic Stacks", 40, 0, 100, 5, "|cffFFBB00Number of stacks before using POS to remove stacks.")
                br.ui:createSpinnerWithout(section, "Phial of Serenity - Grievous Stacks", 2, 0, 4, 5, "|cffFFBB00Number of stacks before using POS to remove stacks")
            end
            -- Healthstone
            br.ui:createSpinner(section, "Healthstone/Potion", 35, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
            -- Pots
            br.ui:createDropdownWithout(section, "Pots - 1 target (Boss)", { "None", "Potion of Spectral Strength", "Potion of Phantom Fire" }, 1, "", "Use Pot when Avatar is up")
            br.ui:createDropdownWithout(section, "Pots - 2-3 targets", { "None", "Potion of Spectral Strength", "Potion of Phantom Fire", "Potion of Empowered Exorcisms" }, 1, "", "Use Pot when Avatar is up")
            br.ui:createDropdownWithout(section, "Pots - 4+ target", { "None", "Potion of Spectral Strength", "Potion of Phantom Fire", "Potion of Empowered Exorcisms" }, 1, "", "Use Pot when Avatar is up")
            -- Trinkets
            br.ui:createDropdownWithout(section, "Trinkets", { "Always", "When CDs are enabled", "Never", "With Avatar" }, 1, "Decide when Trinkets will be used.")
            br.ui:createDropdownWithout(section, "Trinket 1 Mode", { "|cffFFFFFFNormal", "|cffFFFFFFGround", "|cffFFFFFFUse on HP" }, 1, "", "|cffFFFFFFSelect Trinkets mode.")
            br.ui:createDropdownWithout(section, "Trinket 2 Mode", { "|cffFFFFFFNormal", "|cffFFFFFFGround", "|cffFFFFFFUse on HP" }, 1, "", "|cffFFFFFFSelect Trinkets mode.")
            br.ui:createSpinnerWithout(section, "Trinket on Health", 65, 1, 100, 1, "|cffFFFFFF Set to health percent to use Trinket")
        br.ui:checkSectionState(section)
        -------------------------
        --- INTERRUPT OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
            -- Storm Bolt Logic
            br.ui:createCheckbox(section, "Storm Bolt Logic", "Stun specific Spells and Mobs")
            if br.player.covenant.nightFae.active then
                -- Ancient Aftershock Interrupt
                br.ui:createCheckbox(section, "Ancient Aftershock - Int", "Stun specific Spells and Mobs")
            end
            -- Intimidating Shout
            br.ui:createCheckbox(section, "Intimidating Shout - Int")
            -- Pummel
            br.ui:createCheckbox(section, "Pummel")
            -- Shockwave
            br.ui:createCheckbox(section, "Shockwave - Int")
            -- Storm Bolt
            br.ui:createCheckbox(section, "Storm Bolt - Int")
            -- Interrupt Percentage
            br.ui:createSpinner(section, "Interrupt At", 0, 0, 95, 5, "|cffFFBB00Cast Percentage to use at.")
        br.ui:checkSectionState(section)
    end
    optionTable = {
        {
            [1] = "Rotation Options",
            [2] = rotationOptions
        }
    }
    return optionTable
end

-- Ignore Pain Check Engine || (Credit: panglo)
local function ipCapCheck()
    if br.player.buff.ignorePain.exists() then
        local ipValue = tonumber((select(1, br._G.GetSpellDescription(190456):match("%d+%S+%d"):gsub("%D", ""))), 10)
        local ipMax = math.floor(ipValue * 1.3)
        local ipCurrent = tonumber((select(16, br.UnitBuffID("player", 190456))), 10)
        if ipCurrent == nil then
            ipCurrent = 0
            return
        end
        if ipCurrent <= (ipMax * 0.2) or br.player.buff.ignorePain.remain() <= (br.player.gcd * br.getValue("Ignore Pain - Time Remain")) then
            ---print("We're below IP Health Threshold, and IP below cap or IP about to expire")
            return true
        else
            --print("dont cast IP")
            return false
        end
    else
        --print("IP not on")
        return true
    end
end

local function getMaxTTD()
    local highTTD = 0
    local mobs = br.player.enemies.get(5)
    local mob_count = #mobs
    if mob_count > 6 then
        mob_count = 6
    end
    for i = 1, mob_count do
        if br.getTTD(mobs[i]) > highTTD and br.getTTD(mobs[i]) < 999 and not br.isExplosive(mobs[i]) then
            highTTD = br.getTTD(mobs[i])
        end
    end
    return tonumber(highTTD)
end

----------------
--- ROTATION ---
----------------
local function runRotation()
    if br.timer:useTimer("br.addonDebugProtection", 0.1) then
        --Print("Running: "..rotationName)

        ---------------
        --- Toggles ---
        ---------------
        br.UpdateToggle("Rotation", 0.25)
        br.UpdateToggle("Cooldown", 0.25)
        br.UpdateToggle("Defensive", 0.25)
        br.UpdateToggle("Interrupt", 0.25)
        br.UpdateToggle("Mover", 0.25)
        br.UpdateToggle("Taunt", 0.25)
        br.UpdateToggle("Holdcd", 0.25)
        br.UpdateToggle("Soulshaper", 0.25)
        br.UpdateToggle("Steward", 0.25)
        br.UpdateToggle("Aggression", 0.25)
        br.player.ui.mode.mover = br.data.settings[br.selectedSpec].toggles["Mover"]
        br.player.ui.mode.taunt = br.data.settings[br.selectedSpec].toggles["Taunt"]
        br.player.ui.mode.Aggression = br.data.settings[br.selectedSpec].toggles["Aggression"]
        br.player.ui.mode.Steward = br.data.settings[br.selectedSpec].toggles["Steward"]
        br.player.ui.mode.Soulshaper = br.data.settings[br.selectedSpec].toggles["Soulshaper"]
        br.player.ui.mode.tankbuster = br.data.settings[br.selectedSpec].toggles["Tankbuster"]

        --------------
        --- Locals ---
        --------------
        local buff = br.player.buff
        local cast = br.player.cast
        local cd = br.player.cd
        local charges = br.player.charges
        local enemies = br.player.enemies
        local gcd = br.player.gcd
        local gcdMax = br.player.gcdMax
        local healPot = br.getHealthPot()
        local inCombat = br.player.inCombat
        local inInstance = br.player.instance == "party"
        local mode = br.player.ui.mode
        local php = br.player.health
        local race = br.player.race
        local rage = br.player.power.rage.amount()
        local shaped = br.player.buff.soulshape.exists()
        local spell = br.player.spell
        local talent = br.player.talent
        local ttd = br.getTTD
        local units = br.player.units
        local ui = br.player.ui
        local hasAggro = br._G.UnitThreatSituation("player")
        if hasAggro == nil then
            hasAggro = 0
        end
        if br.timersTable then
            wipe(br.timersTable)
        end
        local moving = br.isMoving("player")
        local unit = br.player.unit

        units.get(5)
        units.get(8)

        enemies.get(5, nil, nil, nil, spell.pummel)
        enemies.get(5, "target") -- enemies.yards5t
        enemies.get(8, nil, nil, nil, spell.intimidatingShout)
        enemies.get(8)
        enemies.get(10)
        enemies.get(12)
        enemies.get(12, "target") -- enemies.yards12t
        enemies.get(20)
        enemies.get(25)
        enemies.get(30, nil, nil, nil, spell.taunt)
        enemies.get(40)

        if br.leftCombat == nil then
            br.leftCombat = GetTime()
        end
        if br.profileStop == nil then
            br.profileStop = false
        end

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
            [330875] = "Spirit Frost"
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

        local DoNotTank_unitList = {
            [174773] = "Spiteful Shade",
            [120651] = "Explosives",
            -- Plaguefall
            [170927] = "Erupting Ooze",
            [165010] = "Congealed Slime",
            -- Mists of Tirna Scythe
            [165108] = "Illusionary Clone",
            [165251] = "Illusionary Vulpin",
            [165560] = "Gormling Larva",
            -- Halls of Atonement
            [165913] = "Ghastly Parishioner"

        }

        local Shattering_absorbID = {
            -- Mists of Tirna Scithe
            [324776] = { BUFF_ID = "324776" }, -- bramblethorn-coat"
            [326046] = { BUFF_ID = "326046" }, --Stimulate Resistance",
            -- The Necrotic Wake
            [319290] = { BUFF_ID = "319290" }, --"Meatshield",
            -- Spires of Ascension
            [327416] = { BUFF_ID = "327416" } --Recharge Anima"
        }

        local tankBusterList = {
            [164406] =  "shriekwing",
            [165067] = "margore",
            [164407] = "sludgefist",
            [168113] = "general-grashaal",
            [168112] = "general-kaal",
            [164451] = "dessia-the-decapitator",
            [170690] = "diseased-horror",
            [167534] = "rek-the-hardened",
            [167538] = "dokigg-the-brutalizer",
            [162317] = "gorechop",
            [162329] = "xav-the-unfallen",
            [165946] = "mordretha-the-endless-empress",
            [167532] = "heavin-the-breaker",
            [164558] = "hakkar-the-soulflayer",
            [164555] = "millificent-manastorm",
            [166608] = "muehzala",
            [171184] = "mythresh-skys-talons",
            [167964] = "4-rf-4-rf",
            [173714] = "mistveil-nightblossom",
            [165408] = "halkias",
            [164557] = "shard-of-halkias",
            [165415] = "toiling-groundskeeper",
            [164563] = "vicious-gargon",
            [164266] = "domina-venomblade",
            [162100] = "kryxis-the-voracious",
            [162102] = "grand-proctor-beryllia",
            [162057] = "chamber-sentinel",
            [168594] = "chamber-sentinel",
            [162059] = "kin-tara",
            [162691] = "blightbone",
            [162689] = "surgeon-stitchflesh",
            [162693] = "nalthor-the-rimebinder",
            [164578] = "stitchfleshs-creation",
            [172981] = "kyrian-stitchwerk",
            [163621] = "goregrind" 
        }

        -- Soulshape NF
        local function soulShape_NF()
            if br.isChecked("Auto Soulshape")
                    and not (br._G.IsMounted() or br._G.IsFlying())
            then
                if mode.Soulshaper == 1 then
                    if #enemies.yards20 == 0
                            and not inCombat
                            and moving
                    then
                        if not shaped
                                and cd.soulshape.ready()
                        then
                            br._G.CastSpellByName(br._G.GetSpellInfo(spell.soulshape), "player")
                            br.addonDebug("[AUTO] Casting Soulshape")
                        elseif shaped
                                and cd.flicker.ready()
                                and moving
                                and br.isChecked("Auto Flicker")
                        then
                            br._G.CastSpellByName(br._G.GetSpellInfo(spell.flicker), "player")
                            br.addonDebug("[AUTO] Casting Flicker")
                        end
                    end
                elseif mode.Soulshaper == 2 then
                    if not shaped
                            and moving
                            and cd.soulshape.ready()
                    then
                        if br.SpecificToggle("Soulshape Key") and not br._G.GetCurrentKeyBoardFocus() then
                            br._G.CastSpellByName(br._G.GetSpellInfo(spell.soulshape), "player")
                            br.addonDebug("[KEY] Casting Soulshape")
                        end
                    elseif shaped
                            and cd.flicker.ready()
                            and moving
                            and br.isChecked("Auto Flicker")
                    then
                        if br.SpecificToggle("Soulshape Key") and not br._G.GetCurrentKeyBoardFocus() then
                            br._G.CastSpellByName(br._G.GetSpellInfo(spell.flicker), "player")
                            br.addonDebug("[KEY] Casting Flicker")
                        end
                    end
                end
            end
        end

        -- Main Tank Function || (Credit: Panglo)
        local function mainTank()
            if (#enemies.yards30 >= 1 and (hasAggro >= 2))
                    or br.isChecked("Open World Defensives")
            then
                return true
            else
                return false
            end
        end

        ------ Action Lists ------

        local function actionList_Extras()
            -- Fleshcraft Key
            if br.SpecificToggle("Fleshcraft Key")
                    and cd.fleshcraft.ready()
                    and not br._G.GetCurrentKeyBoardFocus()
            then
                if cast.fleshcraft("player") then
                    return true
                end
            end

            -- Kyrian Steward
            if mode.Steward == 1 then
                if br.player.covenant.kyrian.active 
                        and not br.hasItem(177278)
                        and cast.able.summonSteward()
                then
                    if cast.summonSteward() then
                        return true
                    end
                end
            end

            --Tank buster
            if mode.tankbuster == 1 and inInstance and inCombat then
                for i = 1, #enemies.yards30 do
                    local thisUnit = enemies.yards30[i]
                    if br._G.UnitThreatSituation("player", thisUnit) == 3 and br._G.UnitCastingInfo("target") then
                        if br.lists.tankBuster[select(9, br._G.UnitCastingInfo("target"))] ~= nil then
                            if cast.able.shieldBlock() 
                                    and mainTank() 
                                    and (not buff.shieldBlock.exists() or (buff.shieldBlock.remain() <= (gcd * 1.5))) 
                                    and rage >= 30 
                            then
                                if cast.shieldBlock() then
                                    br.addonDebug("[TANKBUST] Shield Block")
                                    return true
                                end
                            end
                        end
                    end
                end
            end

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

            -- Shattering Throw
            if br.isChecked("Shattering Throw") then
                if cd.shatteringThrow.ready()
                        and not moving
                        and cast.able.shatteringThrow()
                then
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

            -- Trinkets
            if inCombat and (br.getOptionValue("Trinkets") == 1 or (buff.avatar.exists() and br.getOptionValue("Trinkets") == 4)) then
                if br.canTrinket(13) and br.getOptionValue("Trinket 1 Mode") == 1 then
                    br.useItem(13)
                elseif br.canTrinket(13) and br.getOptionValue("Trinket 1 Mode") == 2 then
                    br.useItemGround("target", 13, 40, 0, nil)
                elseif br.canTrinket(13) and br.getOptionValue("Trinket 1 Mode") == 3 and php <= br.getValue("Trinket on Health") then
                    br.useItem(13)
                end

                if br.canTrinket(14) and br.getOptionValue("Trinket 2 Mode") == 1 then
                    br.useItem(14)
                elseif br.canTrinket(14) and br.getOptionValue("Trinket 2 Mode") == 2 then
                    br.useItemGround("target", 14, 40, 0, nil)
                elseif br.canTrinket(14) and br.getOptionValue("Trinket 2 Mode") == 3 and php <= br.getValue("Trinket on Health") then
                    br.useItem(14)
                end
            end

            -- Reprisal Leggo Shenanigans
            if br.isChecked("Reprisal Support") then
                if br.player.runeforge.reprisal.equiped
                        and #br.friend > 1
                        and inCombat
                        and inInstance
                        and mainTank()
                then
                    -- Intervene Melee to Refresh SB
                    if br.isChecked("Reprisal - Melee Intervene")
                            and cd.intervene.ready()
                            and not buff.revenge.exists()
                            and (not buff.shieldBlock.exists() or buff.shieldBlock.remain() <= (gcd * br.getValue("Shield Block - Time Remain")))
                    then
                        for i = 1, #br.friend do
                            local thisUnit = br.friend[i].unit
                            if br.getDistance(thisUnit) >= 0 and br.getDistance(thisUnit) <= 5 then
                                if cast.intervene(thisUnit) then
                                    br.addonDebug("[REPRISAL]Intervene Melee - Refresh shield block, and Revenge!")
                                    return true
                                end
                            end
                        end
                    end
                    -- Intervene Ranged to Refresh SB and Charge Back
                    if br.SpecificToggle("Reprisal - Charge Intervene Key") and not br._G.GetCurrentKeyBoardFocus() then
                        if cd.intervene.ready() and charges.charge.count() >= 1 then
                            for i = 1, #br.friend do
                                local thisUnit = br.friend[i].unit
                                if not br.GetUnitIsUnit(thisUnit, "player")
                                        and br.getDistance(thisUnit) >= br.getOptionValue("Reprisal - Min Distance")
                                        and br.getDistance(thisUnit) <= br.getOptionValue("Reprisal - Max Distance")
                                then
                                    if cast.intervene(thisUnit) then
                                        br.addonDebug("[REPRISAL]Intervene Ranged - Refresh shield block")
                                        return true
                                    end
                                    if br.isValidUnit("target")
                                            and br.getLineOfSight("player", "target")
                                            and br.getDistance("target") >= 8
                                    then
                                        if cast.charge("target") then
                                            br.addonDebug("[REPRISAL] - Charging target")
                                            return true
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end

        local function actionList_offGCD()
            if br.pause(true)
                    or (br._G.IsMounted()
                    or br._G.IsFlying()
                    or br._G.UnitOnTaxi("player")
                    or br._G.UnitInVehicle("player"))
                    or mode.rotation == 2
            then
                return true
            else
                if inCombat
                        and not br.isCastingSpell(spell.fleshcraft)
                then
                    -- Ignore Pain if checks are met, if covenant=venthyr then dont use ignore pain in favor of condemn
                    if br.getOptionValue("Ignore Pain Useage") == 1
                            or (br.getOptionValue("Ignore Pain Useage") == 2 and charges.shieldBlock.count() == 0)
                            or (br.getOptionValue("Ignore Pain Useage") == 3 and php <= br.getOptionValue("Ignore Pain - HP"))
                    then
                        if cast.able.ignorePain()
                                and rage >= 40
                                and mainTank()
                                and ipCapCheck()
                                and not cast.last.ignorePain()
                                and (not mode.Aggression == 1 or (mode.Aggression == 1 and php <= br.getOptionValue("Ignore Pain - HP")))
                                and not br.player.covenant.venthyr.active or (br.player.covenant.venthyr.active and (br.getHP("target") > 20 or br.getHP("target") < 80))
                        then
                            --print("dumping IP")
                            br._G.CastSpellByName(GetSpellInfo(190456))
                            br.addonDebug("[DEF] Casting Ignore Pain")
                        end
                    end

                    -- Use Off GCD Offensive CD's
                    if br.useCDs() and #enemies.yards5 >= 1 and getMaxTTD() >= 20 then
                        -- avatar
                        if br.getOptionValue("Avatar - CD") == 1 or br.isBoss("target") then
                            if cast.avatar() then
                                br.addonDebug("[CD] Always be Avatar'n")
                                return true
                            end
                        elseif br.getOptionValue("Avatar - CD") == 2 and (cd.ravager.ready() or not talent.ravager) and (not br.player.covenant.nightFae.active or (br.player.covenant.nightFae.active and (cd.ancientAftershock.remain() < 15 or cd.ancientAftershock.remain() > 33))) then
                            if cast.avatar() then
                                br.addonDebug("[CD] Avatar w/CDs")
                                return true
                            end
                        elseif br.getOptionValue("Avatar - CD") == 3 and #enemies.yards8 >= br.getOptionValue("Avatar Mob Count") then
                            if cast.avatar() then
                                br.addonDebug("[CD] Avatar AoE")
                                return true
                            end
                        end
                    end

                    -- Use Off GCD Defensive CD's
                    if br.useDefensive() then
                        -- Smart Spell Reflect
                        if br.isChecked("Smart Spell Reflect")
                                and cd.spellReflection.ready()
                        then
                            for i = 1, #enemies.yards40 do
                                local thisUnit = enemies.yards40[i]
                                local _, _, _, startCast, endCast, _, _, _, spellcastID = br._G.UnitCastingInfo(thisUnit)
                                if (select(3, br._G.UnitCastID(thisUnit)) == br._G.ObjectPointer("player") or select(4, br._G.UnitCastID(thisUnit)) == br._G.ObjectPointer("player"))
                                        and reflectID[spellcastID]
                                        and (((br._G.GetTime() * 1000) - startCast) / (endCast - startCast) * 100) > br.getOptionValue("Smart Spell Reflect Percent")
                                then
                                    if cast.spellReflection() then
                                        br.addonDebug("[CD] Spell Reflecting:" .. br._G.UnitName(thisUnit) .. "/" .. tostring(spellCastID))
                                        return
                                    end
                                end
                            end
                        end

                        -- Le Shield Block
                        for i = 1, #enemies.yards30 do
                            if tankBusterList[br.GetObjectID(enemies.yards30[i])] then
                                shieldHoldCharge = 1
                            else
                                shieldHoldCharge = 0
                            end

                            if charges.shieldBlock.count() > shieldHoldCharge
                                    and (not br.isChecked("Shield Block - Unit Count") or (br.isChecked("Shield Block - Unit Count") and #enemies.yards5 >= br.getOptionValue("Shield Block - Unit Count")))
                                    and (not br.isChecked("Shield Block - HP") or (br.isChecked("Shield Block - HP") and php <= br.getOptionValue("Shield Block - HP")))
                                    and mainTank()
                                    and ((talent.bolster and not buff.lastStand.exists()) or not talent.bolster) -- Bolster
                                    and (not buff.shieldBlock.exists() or buff.shieldBlock.remain() <= (gcd * br.getValue("Shield Block - Time Remain"))) -- Extension/Missing
                            then
                                if cast.shieldBlock() then
                                    br.addonDebug("[DEF] Shield Block")
                                    return
                                end
                            end
                        end

                        
                        -- Last Stand
                        if cast.able.lastStand()
                                and (talent.bolster or br.getOptionValue("Last Stand Useage") == 1)
                                or (br.getOptionValue("Last Stand Useage") == 2 and php <= br.getOptionValue("Last Stand - HP"))
                                and not (buff.shieldBlock.exists() or buff.shieldWall.exists())
                                and mainTank()
                        then
                            if cast.lastStand() then
                                return true
                            end
                        end

                        -- Shield Wall
                        if br.isChecked("Shield Wall")
                                and cast.able.shieldWall()
                                and php <= br.getOptionValue("Shield Wall")
                                and cd.lastStand.remain() > 0
                                and not buff.lastStand.exists()
                        then
                            if cast.shieldWall() then
                                return
                            end
                        end
                    end

                    -- Berserker Rage
                    if br.isChecked("Berserker Rage")
                            and cast.able.berserkerRage()
                            and br.hasNoControl(spell.berserkerRage)
                    then
                        if cast.berserkerRage() then
                            return
                        end
                    end

                    -- Pummel
                    if br.useInterrupts()
                            and cd.pummel.ready()
                    then
                        for i = 1, #enemies.yards5 do
                            local thisUnit = enemies.yards5[i]
                            local unitDist = br.getDistance(thisUnit)
                            if not br.isExplosive(thisUnit)
                                    and br.canInterrupt(thisUnit, br.getOptionValue("Interrupt At"))
                            then
                                if br.isChecked("Pummel")
                                        and unitDist < 6
                                then
                                    if cast.pummel(thisUnit) then
                                        return
                                    end
                                end
                            end
                        end
                    end

                    -- Aggro Engine
                    if inInstance and mainTank() and inCombat then
                        local NonAggroCount = 0
                        -- lets check 8 yards only, or 12?
                        local aggroList
                        if talent.unstoppableForce then
                            aggroList = enemies.get(12)
                        else
                            aggroList = enemies.get(8)
                        end

                        for i = 1, #aggroList do
                            local thisUnit = aggroList[i]
                            if br._G.UnitThreatSituation("player", thisUnit) ~= nil and br._G.UnitThreatSituation("player", thisUnit) <= 2
                                    and br._G.UnitAffectingCombat(thisUnit)
                                    and not br.isExplosive(thisUnit)
                            then
                                NonAggroCount = NonAggroCount + 1
                            end
                        end
                        if NonAggroCount > br.getValue("Challenging Shout - Units") and cd.challengingShout.ready() then
                            if cast.challengingShout() then
                                br.addonDebug("[AGGRO] Challenging Shout")
                                NonAggroCount = 0
                            end
                        end
                        if NonAggroCount > 2 and cd.thunderClap.ready() then
                            br._G.CastSpellByName(GetSpellInfo(spell.thunderClap))
                            br.addonDebug("[AGGRO] Thunderclap")
                        end -- end thunderclap/aoe taunt

                        -- Auto Taunt
                        if (mode.taunt == 2 or mode.taunt == 1 and inInstance) and cd.taunt.ready() then
                            for i = 1, #enemies.yards30 do
                                local thisUnit = enemies.yards30[i]
                                if br._G.UnitThreatSituation("player", thisUnit) ~= nil and br._G.UnitAffectingCombat(thisUnit) and br._G.UnitThreatSituation("player", thisUnit) <= 1 then
                                    local mobTarget = br.getUnitID(br._G.UnitTarget(thisUnit))
                                    if mobTarget ~= 98237 and mobTarget ~= 51229 and mobTarget ~= 1964 and mobTarget ~= 61056
                                            and not DoNotTank_unitList[br.GetObjectID(thisUnit)] then
                                        -- Taunt
                                        if cast.taunt(thisUnit) then
                                            br.addonDebug("[AGGRO] Taunt on: " .. br._G.UnitName(thisUnit))
                                            return true
                                        end
                                    end
                                end
                            end
                        end
                        -- Heroic Throw
                        if (ui.checked("Heroic Throw - Aggro")
                                or ui.checked("Heroic Throw - Explosive")
                                or (ui.checked("Heroic Throw - Ranged DPS")))
                        then
                            for i = 1, #enemies.yards30 do
                                local thisUnit = enemies.yards30[i]
                                if ((ui.checked("Heroic Throw - Aggro") and (br._G.UnitThreatSituation("player", thisUnit) ~= nil and br._G.UnitThreatSituation("player", thisUnit) <= 2 and not cast.last.heroicThrow() and not DoNotTank_unitList[br.GetObjectID(thisUnit)])) 
                                or (ui.checked("Heroic Throw - Explosive") and br.isExplosive(thisUnit)) or (ui.checked("Heroic Throw - Ranged DPS")))
                                then
                                    if br.getDistance("player", thisUnit) > 8
                                            and br.getFacing("player", thisUnit, 45)
                                    then
                                        if cast.heroicThrow(thisUnit) then
                                            br.addonDebug("[THROW] Casting Heroic Throw on: " .. br._G.UnitName(thisUnit))
                                            return
                                        end
                                    end
                                end
                            end
                        end -- end heroicThrow
                    end -- end aggro
                end
            end
        end

        local function actionList_Interrupts()
            if br.useInterrupts() then
                -- Storm Bolt
                if br.isChecked("Storm Bolt Logic")
                        and cd.stormBolt.ready()
                then
                    if cast.able.stormBolt() then
                        for i = 1, #enemies.yards20 do
                            local thisUnit = enemies.yards20[i]
                            local unitDist = br.getDistance(thisUnit)
                            if (Storm_unitList[br.GetObjectID(thisUnit)] ~= nil or StormBoltSpell_list[select(9, br._G.UnitCastingInfo(thisUnit))] ~= nil or StormBoltSpell_list[select(7, br._G.GetSpellInfo(br._G.UnitChannelInfo(thisUnit)))] ~= nil) and br.getBuffRemain(thisUnit, 226510) == 0 and unitDist <= 10 then
                                if cast.stormBolt(thisUnit) then
                                    return true
                                end
                            end
                        end
                    end
                end
                -- Intimidating Shout/Shockwave
                if (br.isChecked("Intimidating Shout - Int") or br.isChecked("Shockwave - Int")) then
                    for i = 1, #enemies.yards20 do
                        local thisUnit = enemies.yards20[i]
                        local unitDist = br.getDistance(thisUnit)
                        -- local targetMe = br.GetUnitIsUnit("player", thisUnit) or false
                        if (Storm_unitList[br.GetObjectID(thisUnit)] ~= nil or StormBoltSpell_list[select(9, br._G.UnitCastingInfo(thisUnit))] ~= nil or StormBoltSpell_list[select(7, br._G.GetSpellInfo(br._G.UnitChannelInfo(thisUnit)))] ~= nil) and br.getBuffRemain(thisUnit, 226510) == 0 then
                            if br.isChecked("Intimidating Shout - Int")
                                    and unitDist <= 8
                                    and not moving
                                    and cd.intimidatingShout.ready()
                            then
                                if cast.intimidatingShout() then
                                    br.addonDebug("[INT] Intimidating Shout")
                                    return true
                                end
                            end
                            if br.isChecked("Shockwave - Int")
                                    and unitDist < 10
                                    and cd.shockwave.ready()
                            then
                                if cast.shockwave() then
                                    br.addonDebug("[INT] Shockwave")
                                    return true
                                end
                            end
                            if br.isChecked("Ancient Aftershock - Int")
                                    and br.getFacing("player", thisUnit, 45)
                                    and unitDist < 12
                                    and cast.able.ancientAftershock(thisUnit, "cone", 1, 12)
                            then
                                if cast.ancientAftershock(thisUnit, "cone", 1, 12) then
                                    br.addonDebug("[INT] Ancient Aftershock")
                                    return true
                                end
                            end
                        end
                    end
                end
            end
        end

        local function actionList_Movement()
            if mode.mover == 1 then
                -- Heroic Leap (Auto/Hotkey Useage)
                if not br.SpecificToggle("Heroic Leap Useage") or (br.SpecificToggle("Heroic Leap Useage") and not br._G.GetCurrentKeyBoardFocus()) then
                    -- Best Location
                    if br.getOptionValue("Heroic Leap - Target") == 1 then
                        if cast.able.heroicLeap() then
                            if cast.heroicLeap("best", nil, 1, 8) then
                                br.addonDebug("Casting Heroic Leap @Best")
                                return
                            end
                        end
                        -- Best Target
                    elseif br.getOptionValue("Heroic Leap - Target") == 2 then
                        if cast.able.heroicLeap() and br.getDistance("target") >= 8 then
                            if cast.heroicLeap("target", "ground") then
                                br.addonDebug("Casting Heroic Leap @Target")
                                return
                            end
                        end
                        -- Heroic Charge
                    elseif br.getOptionValue("Heroic Leap - Target") == 3 then
                        if cast.able.heroicLeap() and charges.charge.count() > 0 and inCombat then
                            for i = 1, #br.friend do
                                local thisUnit = br.friend[i].unit
                                if not br.GetUnitIsUnit(thisUnit, "player")
                                        and br.getDistance(thisUnit) >= br.getOptionValue("Heroic Charge - Min Distance")
                                then
                                    if cast.heroicLeap(thisUnit, "ground") then
                                        br.addonDebug("Casting Heroic Leap for Charge, Ally Leaped to: " .. br._G.UnitName(thisUnit) .. ":)")
                                        return
                                    end
                                end
                            end
                        end
                    end
                end

                -- charge
                if br.isChecked("OOC Charge") then
                    if cd.charge.ready()
                            and br.isValidUnit("target")
                            and br.getLineOfSight("player", "target")
                            and br.getDistance("target") >= 8
                    then
                        if cast.charge("target") then
                            br.addonDebug("[OOC] Charging Target")
                            return
                        end
                    end
                end
            end
        end -- End Action List - Movement

        local function actionList_Defensives()
            if br.useDefensive() then
                --Victory Rush
                if php <= br.getValue("Victory Rush - HP")
                        and cast.able.victoryRush()
                then
                    if cast.victoryRush() then
                        return true
                    end
                end
                -- Engineering Belt
                -- belt on player hp
                if br.isChecked("Engineering Belt")
                        and php <= br.getOptionValue("Engineering Belt")
                        and br.canUseItem(6)
                then
                    br._G.UseItemByName(_G.GetInventoryItemID("player", 6), "target")
                end
                -- Healthstones/Pots
                if br.isChecked("Healthstone/Potion")
                        and php <= br.getOptionValue("Healthstone/Potion")
                        and inCombat
                        and (br.hasHealthPot() or br.hasItem(5512) or br.hasItem(166799))
                then
                    if br.canUseItem(5512) then
                        br.useItem(5512)
                    elseif br.canUseItem(healPot) then
                        br.useItem(healPot)
                    elseif br.hasItem(166799) and br.canUseItem(166799) then
                        br.useItem(166799)
                    end
                end

                -- Phial of Serenity
                if mode.Steward == 1 then
                        -- Heal
                    if br.getOptionValue("Phial of Serenity Useage") == 1
                            and php <= br.getOptionValue("Phial of Serenity - HP") 
                            and inCombat 
                            and br.hasItem(177278) 
                    then
                        if br.canUseItem(177278) then
                            br.useItem(177278)
                        end
                        -- Remove Necrotic
                    elseif br.getOptionValue("Phial of Serenity Useage") == 2
                            and inInstance
                            and inCombat
                            and br.hasItem(177278)
                            and br.getDebuffStacks("player", 209858) >= br.getValue("Phial of Serenity - Necrotic Stacks")
                    then
                        if br.canUseItem(177278) then
                            br.useItem(177278)
                        end
                        -- Remove Grievous
                    elseif br.getOptionValue("Phial of Serenity Useage") == 3
                            and inInstance
                            and inCombat
                            and br.hasitem(177278)
                            and br.getDebuffStacks("player", 240559) >= br.getValue("Phial of Serenity - Grievous Stacks")
                    then
                        if br.canUseItem(177278) then
                            br.useItem(177278)
                        end
                    end
                end

                -- Fleshcraft
                if br.isChecked("Fleshcraft - HP")
                        and cd.fleshcraft.ready()
                        and #enemies.yards8 >= br.getValue("Fleshcraft - Units")
                        and php <= br.getValue("Fleshcraft - HP")
                        and cast.able.fleshcraft()
                then
                    if cast.fleshcraft("player") then
                        return true
                    end
                end
                -- Rallying Cry on Health
                if br.isChecked("Rallying Cry")
                        and cd.rallyingCry.ready()
                        and php <= br.getOptionValue("Rallying Cry")
                then
                    if cast.rallyingCry() then
                        return true
                    end
                end
                -- Shockwave on Unit Count
                if br.isChecked("Shockwave - Units")
                        and cd.shockwave.ready()
                        and cast.able.shockwave(units.dyn10, "cone", br.getOptionValue("Shockwave - Units"), 10)
                        and not moving
                then
                    if cast.shockwave(units.dyn10, "cone", br.getOptionValue("Shockwave - Units"), 10) then
                        return true
                    end
                end
            end
        end

        local function actionList_Cooldowns()
            -- use_items,if=cooldown.avatar.remains<=gcd|buff.avatar.up
            --Use Trinkets
            if inCombat
                    and (br.getOptionValue("Trinkets") == 2
                    or (buff.avatar.exists() and br.getOptionValue("Trinkets") == 4))
            then
                -- Trinket 1
                if br.canTrinket(13) and br.getOptionValue("Trinket 1 Mode") == 1 then
                    br.useItem(13)
                elseif br.canTrinket(13) and br.getOptionValue("Trinket 1 Mode") == 2 then
                    br.useItemGround("target", 13, 40, 0, nil)
                end
                -- Trinket 2
                if br.canTrinket(14) and br.getOptionValue("Trinket 2 Mode") == 1 then
                    br.useItem(14)
                elseif br.canTrinket(14) and br.getOptionValue("Trinket 2 Mode") == 2 then
                    br.useItemGround("target", 14, 40, 0, nil)
                end
            end
            -- CD Racials on Avatar
            if br.isChecked("Avatar - Racials")
                    and buff.avatar.exists()
                    and (race == "Orc" or race == "Troll" or race == "LightforgedDraenei" or (race == "Vulpera" and php > br.getOptionValue("Vulpera Racial Heal")))
            then
                if cast.racial() then
                    return true
                end
            end

            -- Vulpera Racial Heal
            if br.isChecked("Vulpera Racial Heal")
                    and race == "Vulpera"
                    and php <= br.getOptionValue("Vulpera Racial Heal")
            then
                if cast.racial("player") then
                    return true
                end
            end

            -- potion,if=buff.avatar.up|target.time_to_die<25 || (Credit: Laks)
            if mode.pots == 1 then
                local auto_pot
                if #enemies.yards8 == 1 and br.isBoss("target") then
                    auto_pot = br.getOptionValue("Pots - 1 target (Boss)")
                elseif #enemies.yards8 >= 2 and #enemies.yards8 <= 3 then
                    auto_pot = br.getOptionValue("Pots - 2-3 targets")
                elseif #enemies.yards8 >= 4 then
                    auto_pot = br.getOptionValue("Pots - 4+ target")
                end

                if auto_pot ~= 1
                        and buff.avatar.remain() > 12
                then
                    if auto_pot == 2 and br.canUseItem(171275) then
                        br._G.UseItemByName(171275, "player")
                    elseif auto_pot == 3 and #enemies.yards8 >= 2 and #enemies.yards8 <= 3 and br.canUseItem(171349) then
                        br._G.UseItemByName(171349, "player")
                    elseif auto_pot == 4 and #enemies.yards8 >= 4 and br.canUseItem(171352) then
                        br._G.UseItemByName(171352, "player")
                    end
                end
            end

            -- demoralizing_shout,if=talent.booming_voice.enabled
            if inCombat and cd.demoralizingShout.ready() then
                if #enemies.yards10 >= 1 
                        and (not talent.boomingVoice or (talent.boomingVoice and rage <= 100))
                then
                    if br.getOptionValue("Demo Shout Useage") == 1 then
                        br._G.CastSpellByName(GetSpellInfo(spell.demoralizingShout))
                        br.addonDebug("[CD] Demoralizing Shout- Always")
                        return true
                    elseif br.getOptionValue("Demo Shout Useage") == 2 then
                        if buff.avatar.exists() then
                            br._G.CastSpellByName(GetSpellInfo(spell.demoralizingShout))
                            br.addonDebug("[CD] Demoralizing Shout - On Avatar")
                            return true
                        end
                    elseif br.getOptionValue("Demo Shout Useage") == 3 then 
                        if #enemies.yards10 >= br.getOptionValue("Demo Shout - Unit Count") then
                            br._G.CastSpellByName(GetSpellInfo(spell.demoralizingShout))
                            br.addonDebug("[CD] Demoralizing Shout - Unit Count")
                            return true
                        end
                    elseif br.getOptionValue("Demo Shout Useage") == 4 then
                        if php <= br.getOptionValue("Demo Shout - HP") then
                            br._G.CastSpellByName(GetSpellInfo(spell.demoralizingShout))
                            br.addonDebug("[CD] Demoralizing Shout - On HP")
                            return true
                        end
                    elseif br.getOptionValue("Demo Shout Useage") == 5 then
                        if rage <= br.getOptionValue("Demo Shout - Rage") then
                            br._G.CastSpellByName(GetSpellInfo(spell.demoralizingShout))
                            br.addonDebug("[CD] Demoralizing Shout - Rage Generator")
                            return true
                        end
                    end
                end
            end

            -- Covenant abilities
            -- Ancient Aftershock | thnx Winterz
            if cd.ancientAftershock.ready()
                    and cast.able.ancientAftershock(units.dyn12, "cone", 1, 12)
                    and (not br.getOptionValue("Avatar - CD") == 2 or (br.getOptionValue("Avatar - CD") == 2 and (buff.avatar.exists() or cd.avatar.remain() >= 90)) or (br.isBoss("target") or (#enemies.yards12 == 1 and ttd("target") >= 15)))
                    and not moving
            then
                if cast.ancientAftershock(units.dyn12, "cone", 1, 12) then
                    br.addonDebug("[COV] Ancient Aftershock")
                    return true
                end
            end

            -- Spear of Bastion
            if ui.checked("Spear of Bastion Units") 
                    and cd.spearOfBastion.ready() 
                    and br.getCombatTime() > 2
            then
                if
                ((br.getOptionValue("Avatar - CD") == 2 and (buff.avatar.exists() or cd.avatar.remain() >= 60) or br.getOptionValue("Avatar - CD") ~= 2)
                        or br.isBoss("target")
                        or #enemies.yards12 >= ui.value("Spear of Bastion Units")
                )
                        and not moving and getMaxTTD() >= 10 then
                    if br.createCastFunction("best", false, br.getValue("Spear of Bastion Units"), 8, spell.spearOfBastion, nil, true) then
                        br.addonDebug("[COV] Spear of Bastion")
                        return true
                    end
                end
            end

            -- Conquerors Banner
            if br.isChecked("Conqueror's Banner")
                    and cd.conquerorsBanner.ready()
                    and br.player.covenant.necrolord.active
            then
                if cast.conquerorsBanner() then
                    br.addonDebug("[COV] Conqueror's Banner")
                    return true
                end
            end

            -- ravager
            if br.isChecked("Ravager")
                    and cast.able.ravager()
                    and not br.isExplosive("target")
                    and talent.ravager
                    and (
                    (br.getOptionValue("Avatar - CD") == 2 and (buff.avatar.exists() or cd.avatar.remain() >= 90) or br.getOptionValue("Avatar - CD") ~= 2)
                            or br.isBoss("target")
                            or #enemies.yards12 == 1)
                    and getMaxTTD() >= 15
                    and not moving then
                if br.createCastFunction("best", false, 1, 8, spell.ravager, nil, true) then
                    br.addonDebug("[DPS] Ravager")
                    return true
                end
            end

            -- run_action_list,name=aoe,if=spell_targets.thunder_clap>=3

            -- all_action_list,name=Rotation
        end


        local function actionList_Rotation()

            local ragePooling = rage > br.getValue("Rage Pooling")
            
            local aggressiveRevenge = nil
            if mode.Aggression == 1
                    and not br.isExplosive("target")
                    and br.getHP("target") > 20
                    and br.getSpellCD(spell.thunderClap) > gcd
                    and br.getSpellCD(spell.shieldSlam) > gcd
            then
                aggressiveRevenge = true
            end

            -- dragon_roar
            if talent.dragonRoar
                    and br.isChecked("Dragon Roar")
                    and not br.isExplosive("target")
                    and cd.dragonRoar.ready()
                    and not moving
            then
                if cast.dragonRoar() then
                    br.addonDebug("[DPS] Dragon Roar")
                    return true
                end
            end

            -- shield_slam
            if cd.shieldSlam.ready()
                    and #enemies.yards5 >= 1
                    and cast.able.shieldSlam
                    and br.getFacing("player", units.dyn5)
                    and (buff.shieldBlock.exists() or (br.getSpellCD(spell.thunderClap) >= gcd))
            then
                if cast.shieldSlam(units.dyn5) then
                    br.addonDebug("[DPS] Shield Slam")
                    return true
                end
            end

            -- execute
            if not br.player.covenant.venthyr.active then
                local execList = enemies.get(5)
                if execList ~= nil and #execList > 0 and #execList <= 3 then
                    for i = 1, #execList do
                        local execUnit = execList[i]
                        if unit.hp(execUnit) < 20 and br.getFacing("player", execUnit) then
                            if br._G.CastSpellByName(br._G.GetSpellInfo(spell.execute), execUnit) then
                                br.addonDebug("[DPS] Execute")
                                return true
                            end
                        end
                    end
                end
            else
                -- Condemn
                if br.player.covenant.venthyr.active
                        and br.isChecked("Condemn")
                then
                    local condemnList = enemies.get(5)
                    if condemnList ~= nil and #condemnList > 0 then
                        for i = 1, #condemnList do
                            local condemnUnit = condemnList[i]
                            if (unit.hp(condemnUnit) <= 20 or unit.hp(condemnUnit) >= 80) and br.getFacing("player", condemnUnit) then
                                br._G.CastSpellByID(317349, condemnUnit)
                                br.addonDebug("[DPS] Condemn")
                            end
                        end
                    end
                end
            end

            -- revenge me brah
            if #enemies.yards5 >= 1 
                    and cast.able.revenge(units.dyn5, "cone", 1, 5)
                    and (((ragePooling and br.getHP("target") > 20) or (br.player.covenant.venthyr.active and ragePooling and (br.getHP("target") >= 20 or br.getHP("target") <= 80))) or buff.revenge.exists() or aggressiveRevenge) 
            then
                if cast.revenge(units.dyn5, "cone", 1, 5) then
                    br.addonDebug("[DPS] Revenge")
                    return true
                end
            else
                if cd.thunderClap.ready() and rage <= 95 then
                    if talent.unstoppableForce and buff.avatar.exists()
                            or #enemies.yards8 >= br.getOptionValue("AoE Threshold")
                            or not cd.shieldSlam.ready() and not buff.revenge.exists()
                    then
                        br._G.CastSpellByName(br._G.GetSpellInfo(spell.thunderClap))
                        br.addonDebug("[DPS] Aggressive Thunderclap")
                        return true
                    end
                end
            end

            -- devastate
            if not talent.devastator then
                if cd.shieldSlam.remain() > (gcdMax / 2)
                        and (br.isExplosive("target") or cd.thunderClap.remain() > (gcdMax / 2))
                then
                    if cast.devastate() then
                        br.addonDebug("[DPS] Devestate")
                        return true
                    end
                end
            end

            -- thunder_clap
            if cd.thunderClap.ready() then
                br._G.CastSpellByName(br._G.GetSpellInfo(spell.thunderClap))
                br.addonDebug("[NEVER] Thunderclap")
                return true
            end
        end -- end action_list rotation


        -- charge
        if br.isChecked("Charge") and mode.mover == 1 and inCombat then
            if cd.charge.ready()
                    and br.isValidUnit("target")
                    and br.getLineOfSight("player", "target")
                    and br.getDistance("target") >= 8
            then
                if cast.charge("target") then
                    br.addonDebug("[In Combat] Charging Target")
                    return
                end
            end
        end

        -----------------
        --- Rotations ---
        -----------------
        -- Off GCD Action List
        if actionList_offGCD() then
            return
        end

        --- Pause
        if br.pause(true)
                or (br._G.IsMounted() or br._G.IsFlying() or br._G.UnitOnTaxi("player") or br._G.UnitInVehicle("player"))
                or mode.rotation == 2
                or br.isCastingSpell(spell.fleshcraft)
        then
            return true
        else
            -- OOC Rotation
            if not inCombat
                    and not (br._G.IsMounted() or br._G.IsFlying() or br._G.UnitOnTaxi("player") or br._G.UnitInVehicle("player"))
            then
                if actionList_Extras() then
                    return
                end
                if actionList_Movement() then
                    return
                end
                if br.player.covenant.nightFae.active then
                    if soulShape_NF() then
                        return
                    end
                end
            end
            -- In-Combat Rotation
            if inCombat and br.profileStop == false
                    and not (br._G.IsMounted() or br._G.IsFlying())
                    and #enemies.yards8 >= 1
            then
                --Auto attack
                if not br._G.IsAutoRepeatSpell(br._G.GetSpellInfo(6603)) and #enemies.yards5 >= 1 then
                    br._G.StartAttack()
                end
                if actionList_Extras() then
                    return
                end
                if actionList_Interrupts() then
                    return
                end
                if actionList_Defensives() then
                    return
                end
                if actionList_Movement() then
                    return
                end
                if actionList_Cooldowns() then
                    return
                end
                if actionList_Rotation() then
                    return
                end
            end
        end
        --br.pause
    end
    --timer
end
--runrotation
local id = 73
if br.rotations[id] == nil then
    br.rotations[id] = {}
end
tinsert(
        br.rotations[id],
        {
            name = rotationName,
            toggles = createToggles,
            options = createOptions,
            run = runRotation
        }
)
