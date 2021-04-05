--Version 1.0.0
-- Big thank yous to Laks, Panglo, Kuu, and Ashley <333
local rotationName = "Doparrior_Prot"

---------------
--- Toggles ---
---------------
local function createToggles()
    -- Rotation Button
    local RotationModes = {
        [1] = {mode = "Auto", value = 1, overlay = "Automatic Rotation", tip = "Enable Rotation", highlight = 1, icon = br.player.spell.thunderClap},
        [2] = {mode = "Off", value = 2, overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.enragedRegeneration}
    }
    br.ui:createToggle(RotationModes,"Rotation", 1, 0)
    -- Cooldown Button
    local CooldownModes = {
        [1] = {mode = "Auto", value = 1, overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Based on settings", highlight = 1, icon = br.player.spell.avatar},
        [2] = {mode = "On", value = 2, overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.avatar},
        [3] = {mode = "Off", value = 3, overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.avatar}
    }
    br.ui:createToggle(CooldownModes,"Cooldown", 2, 0)
    -- Defensive Button
    local DefensiveModes = {
        [1] = {mode = "On", value = 1, overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.shieldWall},
        [2] = {mode = "Off", value = 2, overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.shieldWall}
    }
    br.ui:createToggle(DefensiveModes,"Defensive", 3, 0)
    -- Interrupt Button
    local InterruptModes = {
        [1] = {mode = "On", value = 1, overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.pummel},
        [2] = {mode = "Off", value = 2, overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.pummel}
    }
    br.ui:createToggle(InterruptModes,"Interrupt", 4, 0)
    -- Movement Button
    local MoverModes = {
        [1] = {mode = "On", value = 1, overlay = "Mover Enabled", tip = "Will use Charge/Heroic Leap.", highlight = 1, icon = br.player.spell.charge},
        [2] = {mode = "Off", value = 2, overlay = "Mover Disabled", tip = "Will NOT use Charge/Heroic Leap.", highlight = 0, icon = br.player.spell.charge}
    }
    br.ui:createToggle(MoverModes,"Mover", 5, 0)
    local TauntModes = {
        [1] = {mode = "Dun", value = 1, overlay = "Taunt only in Dungeon", tip = "Taunt will be used in dungeons.", highlight = 1, icon = br.player.spell.taunt},
        [2] = {mode = "All", value = 2, overlay = "Auto Taunt Enabled", tip = "Taunt will be used everywhere.", highlight = 1, icon = br.player.spell.taunt},
        [3] = {mode = "Off", value = 3, overlay = "Auto Taunt Disabled", tip = "Taunt will not be used.", highlight = 0, icon = br.player.spell.taunt}
    }
    br.ui:createToggle(TauntModes,"Taunt", 6, 0)
    -- Tankbuster Button
    local TankbusterModes = {
        [1] = {mode = "On", value = 1, overlay = "M+ Tankbuster Enabled", tip = "Will use Shield Block to Mitigate Tank Busters", highlight = 1, icon = br.player.spell.shieldBlock},
        [2] = {mode = "Off", value = 2, overlay = "M+ Tankbuster Disabled", tip = "Will NOT use Shield Block to Mitigate Tank Busters", highlight = 0, icon = br.player.spell.shieldBlock}
    }
    br.ui:createToggle(TankbusterModes,"Tankbuster", 0, 1)
-- Defensive/Aggressive Button
    local AggressionModes = {
        [1] = {mode = "On", value = 1, overlay = "Offense", tip = "Uses revenge regardless of rage pool settings when Shield Slam and TC are on CD.", highlight = 1, icon = br.player.spell.revenge},
        [2] = {mode = "Off", value = 2, overlay = "Defense", tip = "Uses rage pool configuration to pool rage for SB/IP and only use revenge (no proc) on rage dump.", highlight = 0, icon = br.player.spell.shieldBlock}
    }
    br.ui:createToggle(AggressionModes,"Aggression", 1, 1)

    -- AutoPot Button
    local PotsModes = {
        [1] = { mode = "On", value = 1, overlay = "Use Pots", tip = "Use Pots", highlight = 0, icon = 2259 },
        [2] = { mode = "Off", value = 2, overlay = "Use Pots", tip = "Use Pots", highlight = 0, icon = 2259 },
    }
    br.ui:createToggle(PotsModes,"Pots", 5, 1)

    -- Soulshape Button
    if br.player.covenant.nightFae.active then
        local SoulshaperModes = {
            [1] = {mode = "Moving", value = 1, overlay = "Moving Enabled", tip = "Will soulshape when movement detected not mounted and out of combat", highlight = 1, icon = br.player.spell.soulshape},
            [2] = {mode = "Hold", value = 2, overlay = "Hold Enabled", tip = "Will soulshape when key is held down", highlight = 0, icon = br.player.spell.soulshape}
        }
        br.ui:createToggle(SoulshaperModes,"Soulshaper", 6, 1)
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
        section = br.ui:createSection(br.ui.window.profile, "General - Version 1.000")
            br.ui:createCheckbox(section, "Open World Defensives", "Use this checkbox to ensure defensives are used while in Open World")
            -- Berserker Rage
            br.ui:createCheckbox(section, "Berserker Rage", "Check to use Berserker Rage")
            -- Shout Check
            br.ui:createCheckbox(section, "Battle Shout", "Enable automatic party buffing")
        br.ui:checkSectionState(section)
        ------------------------
        --- MOVEMENT OPTIONS ---
        ------------------------
        section = br.ui:createSection(br.ui.window.profile, "Movement")
            if br.player.covenant.nightFae.active then
                -- Auto Soulshape
                br.ui:createCheckbox(section, "Auto Soulshape", "|cff0070deCheck this to automatically control SS transformation based on toggle bar setting.")
                br.ui:createCheckbox(section,"Auto Flicker", "Check to use Flicker while Soulshaped")
                br.ui:createDropdownWithout(section, "Soulshape Key", br.dropOptions.Toggle, 6, "|cff0070deSet key to hold down for SS")
            end
            -- Charge
            br.ui:createCheckbox(section,"Charge", "Check to use Charge")
            br.ui:createCheckbox(section, "Charge OoC")
            -- Heroic Leap
            br.ui:createDropdown(section,"Heroic Leap", br.dropOptions.Toggle, 6, "Set auto usage (No Hotkey) or desired hotkey to use Heroic Leap.")
            br.ui:createDropdown(section,"Heroic Leap - Target",{"Best","Target"},1,"Desired Target of Heroic Leap")
            br.ui:createSpinner(section, "Heroic Charge",  15,  8,  25,  1,  "|cffFFBB00Set to desired yards to Heroic Leap out for Charge/Leap Combo. Min: 8 / Max: 25 / Interval: 1")
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
                br.ui:createSpinnerWithout(section, "Ancient Aftershock Units", 3, 1, 10, 1, "Number of units to use NF Ability on")
            end
            -- Heroic Throw
            br.ui:createCheckbox(section, "Auto Heroic Throw", "Use heroic throw for aggro and when no active threat targets are in range.")
            -- Auto Ravager
            br.ui:createCheckbox(section, "Auto Ravager", "Finds best targets to throw ravager while you're not moving.")
            -- Dragons Roar
            br.ui:createCheckbox(section, "Dragon Roar")
            -- Shockwave
            br.ui:createSpinner(section, "Shockwave - Units", 7, 1, 10, 1, "|cffFFBB00Minimal units to cast on.")

        br.ui:checkSectionState(section)
        ------------------------
        --- COOLDOWN OPTIONS ---
        ------------------------
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
            -- Conquerors Banner
            if br.player.covenant.necrolord.active then
                br.ui:createCheckbox(section, "Conqeror's Banner")
            end
            -- Avatar
            br.ui:createDropdown(section, "Avatar - CD", {"Always", "When CDs are available", "On unit count", "Never"}, 1)
            br.ui:createSpinnerWithout(section, "Avatar Mob Count", 5, 0, 10, 1, "|cffFFFFFFEnemies to cast Avatar when using AUTO CDS")
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
                -- Auto Fleshcraft
                br.ui:createSpinner(section, "Fleshcraft on Health", 85, 1, 100, 1, "|cffFFFFFF Set to health percent to use Fleshcraft")
                -- FC Unit Threshold
                br.ui:createSpinnerWithout(section, "Minimum Unit Count", 3, 1, 10, 1, "Set number of units to use Fleshcraft")
            end
            -- Demoralizing Shout
            br.ui:createDropdown(section, "Demo Shout Useage", {"Always", "When CDs are enabled", "On unit count", "Never"}, 1)
            br.ui:createSpinnerWithout(section, "Demo Shout - Unit Count", 3, 1, 10, 1, "Set number of units to prioritise Demo Shout")
            -- Last Stand
            br.ui:createDropdown(section, "Last Stand Useage", {"Always", "On Health Percent"}, 1)
            br.ui:createSpinnerWithout(section, "Last Stand - HP", 65, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
            -- Ignore Pain
            br.ui:createSpinnerWithout(section, "Ignore Pain - HP", 90, 1, 100, 1, "|cffFFFFFF Set to personal HP percent to start considering using Ignore Pain")
            br.ui:createSpinnerWithout(section, "Ignore Pain - Time Remain", 2, 1, 12, 1, "|cffFFFFFF Set (in seconds) time remaining on ignore pain before refresh.")
            -- Rallying Cry
            br.ui:createSpinner(section, "Rallying Cry", 45, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
            -- Shield Block
            br.ui:createSpinner(section, "Shield Block", 85, 1, 100, 1, "|cffFFFFFF Set to health percent to use Shield Block on self")
            br.ui:createSpinnerWithout(section, "Hold Shield Block", 1, 0, 2, 1, "|cffFFBB00Number of Shield Block charges the rotation will hold for manual use or tankbuster.");
            br.ui:createSpinnerWithout(section, "Shield Block - Time Remain", 6, 1, 12, 1, "|cffFFFFFF Set (in seconds) time remaining on shield block before refresh.")
            -- Shield Wall
            br.ui:createSpinner(section, "Shield Wall", 45, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
            -- Smart Spell reflect
            br.ui:createCheckbox(section, "Smart Spell Reflect", "Auto reflect spells in instances")
            br.ui:createSpinnerWithout(section, "Smart Spell Reflect Percent", 90, 0, 95, 5, "Spell reflect when spell is X % complete, ex. 90 = 90% complete")
            -- Victory Rush
            br.ui:createSpinnerWithout(section, "Victory Rush HP", 90, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
        br.ui:checkSectionState(section)
        -------------------------
        --- INTERRUPT OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
            -- Storm Bolt Logic
            br.ui:createCheckbox(section, "Storm Bolt Logic", "Stun specific Spells and Mobs")
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
        -------------------------
        --- UTILITY OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Utility")
            -- Engi Belt stuff thanks to Lak
            br.ui:createSpinner(section, "Engineering Belt", 45, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
            -- Healthstone
            br.ui:createSpinner(section, "Healthstone/Potion", 35, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
            -- Pots
            br.ui:createDropdownWithout(section, "Pots - 1 target (Boss)", { "None", "Potion of Spectral Strength", "Potion of Phantom Fire" }, 1, "", "Use Pot when Avatar is up")
            br.ui:createDropdownWithout(section, "Pots - 2-3 targets", { "None", "Potion of Spectral Strength", "Potion of Phantom Fire", "Potion of Empowered Exorcisms" }, 1, "", "Use Pot when Avatar is up")
            br.ui:createDropdownWithout(section, "Pots - 4+ target", { "None", "Potion of Spectral Strength", "Potion of Phantom Fire", "Potion of Empowered Exorcisms" }, 1, "", "Use Pot when Avatar is up")
            -- Trinkets
            br.ui:createDropdownWithout(section, "Trinkets", {"Always", "When CDs are enabled", "Never", "With Avatar"}, 1, "Decide when Trinkets will be used.")
            br.ui:createDropdownWithout(section, "Trinket 1 Mode", {"|cffFFFFFFNormal", "|cffFFFFFFGround", "|cffFFFFFFUse on HP"}, 1, "", "|cffFFFFFFSelect Trinkets mode.")
            br.ui:createDropdownWithout(section, "Trinket 2 Mode", {"|cffFFFFFFNormal", "|cffFFFFFFGround", "|cffFFFFFFUse on HP"}, 1, "", "|cffFFFFFFSelect Trinkets mode.")
            br.ui:createSpinnerWithout(section, "Trinket on Health", 65, 1, 100, 1, "|cffFFFFFF Set to health percent to use Trinket")
        br.ui:checkSectionState(section)

        -------------------------
        --- Legendary OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Legendary Support [WIP]")
            -- Reprisal
            br.ui:createCheckbox(section, "Reprisal Support", "Uses charge/intervene automatically to keep up Shield Block.")
            br.ui:createCheckbox(section, "Reprisal - Melee Intervene", "Uses charge/intervene automatically to keep up Shield Block.")
            br.ui:createCheckbox(section, "Reprisal - Ranged Charge Intervene", "Uses charge/intervene automatically to keep up Shield Block.")
            br.ui:createSpinnerWithout(section, "Reprisal - Min Distance",  10,  1,  25,  1,  "|cffFFBB00Set to desired yards to Ranged Charge Intervene combo. Min: 1 / Max: 25 / Interval: 1")
            br.ui:createSpinnerWithout(section, "Reprisal - Max Distance",  20,  1,  25,  1,  "|cffFFBB00Set to desired yards to Ranged Charge Intervene combo. Min: 1 / Max: 25 / Interval: 1")
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
        local ipValue = tonumber((select(1, GetSpellDescription(190456):match("%d+%S+%d"):gsub("%D", ""))), 10)
        local ipMax = math.floor(ipValue * 1.3)
        local ipCurrent = tonumber((select(16, br.UnitBuffID("player", 190456))), 10)
        if ipCurrent == nil then
            ipCurrent = 0
            return
        end
        if br.player.health <= br.getValue("Ignore Pain - HP") 
                and (ipCurrent <= (ipMax * 0.2) 
                    or br.player.buff.ignorePain.remain() <= (br.player.gcd * br.getValue("Ignore Pain - Time Remain"))) 
        then
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
        br.UpdateToggle("Aggression", 0.25)
        br.player.ui.mode.mover = br.data.settings[br.selectedSpec].toggles["Mover"]
        br.player.ui.mode.taunt = br.data.settings[br.selectedSpec].toggles["Taunt"]
        br.player.ui.mode.Soulshaper = br.data.settings[br.selectedSpec].toggles["Aggression"]
        br.player.ui.mode.Soulshaper = br.data.settings[br.selectedSpec].toggles["Soulshaper"]
        br.player.ui.mode.tankbuster = br.data.settings[br.selectedSpec].toggles["Tankbuster"]

        --------------
        --- Locals ---
        --------------
        local buff = br.player.buff
        local cast = br.player.cast
        local combatTime = br.getCombatTime()
        local cd = br.player.cd
        local charges = br.player.charges
        local deadMouse = br.GetUnitIsDeadOrGhost("mouseover")
        local deadtar, attacktar, hastar, playertar = deadtar or br.GetUnitIsDeadOrGhost("target"), attacktar or br._G.UnitCanAttack("target", "player"), hastar or br.GetObjectExists("target"), br._G.UnitIsPlayer("target")
        local debuff = br.player.debuff
        local enemies = br.player.enemies
        local falling, swimming, flying, moving = br.getFallTime(), IsSwimming(), br._G.IsFlying(), br._G.GetUnitSpeed("player") > 0
        local friendly = friendly or br.GetUnitIsFriend("target", "player")
        local gcd = br.player.gcd
        local gcdMax = br.player.gcdMax
        local healPot = br.getHealthPot()
        local inCombat = br.player.inCombat
        local inInstance = br.player.instance == "party"
        local inRaid = br.player.instance == "raid"
        local lowestHP = br.friend[1].unit
        local mode = br.player.ui.mode
        local perk = br.player.perk
        local php = br.player.health
        local playerMouse = br._G.UnitIsPlayer("mouseover")
        local power, powerMax, powerGen = br.player.power.rage.amount(), br.player.power.rage.max(), br.player.power.rage.regen()
        local pullTimer = br.DBM:getPulltimer()
        local race = br.player.race
        local runeforge = br.player.runeforge
        local racial = br.player.getRacial()
        local rage, powerDeficit = br.player.power.rage.amount(), br.player.power.rage.deficit()
        local solo = br.player.instance == "none"
        local shaped = br.player.buff.soulshape.exists()
        local spell = br.player.spell
        local talent = br.player.talent
        local thp = br.getHP("target")
        local ttd = br.getTTD
        local ttm = br.player.power.rage.ttm()
        local units = br.player.units
        local unit  = br.player.unit
        local hasAggro = br._G.UnitThreatSituation("player")
        if hasAggro == nil then
            hasAggro = 0
        end
        if br.timersTable then
            wipe(br.timersTable)
        end

        units.get(5)
        units.get(8)

        enemies.get(5, nil, nil, nil, spell.pummel)
        enemies.get(8, nil, nil, nil, spell.intimidatingShout)
        enemies.get(8)
        enemies.get(10)
        enemies.get(12)
        enemies.get(12, "target") -- enemies.yards12t    
        enemies.get(20)
        enemies.get(30, nil, nil, nil, spell.taunt)

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
            [320788] = "Enveloping Webbing",
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

        local absorbID = {
            -- Mists of Tirna Scithe
            [324776] = "Bramblethorn Coat",
            [326046] = "Stimulate Resistance",
            -- The Necrotic Wake
            [319290] = "Meatshield",
            -- Spires of Ascension
            [327416] = "Recharge Anima"
        }

        -- Heroic Leap for Charge (Credit: TitoBR)
        local function heroicLeapCharge()
            local thisUnit = "target"
            local x1, y1, z1 = br.GetObjectPosition("player")
            local hitBoxCompensation = max(5, br._G.UnitCombatReach("player") + br._G.UnitCombatReach(thisUnit))
            local yards = br.getOptionValue("Heroic Charge") + hitBoxCompensation
            for deg = 0, 360, 45 do
                local dX, dY, dZ = br._G.GetPositionFromPosition(x1, y1, z1, yards, deg, 0)
                if br._G.TraceLine(x1, y1, z1 + 2.25, dX, dY, dZ + 2.25, 0x10) == nil and cd.heroicLeap.remain() == 0 and charges.charge.count() > 0 then
                    if not br._G.IsAoEPending() then
                        br._G.CastSpellByName(GetSpellInfo(spell.heroicLeap))
                        -- cast.heroicLeap("player")
                    end
                    if br._G.IsAoEPending() then
                        br._G.ClickPosition(dX,dY,dZ)
                        break
                    end
                end
            end
        end

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
                            br.addonDebug("[OOC] Casting Soulshape")
                        elseif br.isChecked("Auto Flicker") then
                            if shaped 
                                    and cd.flicker.ready() 
                            then
                                br._G.CastSpellByName(br._G.GetSpellInfo(spell.flicker), "player")
                                br.addonDebug("[OOC] Casting Flicker")
                            end
                        end
                    end
                elseif mode.Soulshaper == 2 then
                    if not shaped 
                            and moving
                            and cd.soulshape.ready()
                    then
                        if br.SpecificToggle("Soulshape Key") and not br._G.GetCurrentKeyBoardFocus() then
                            br._G.CastSpellByName(br._G.GetSpellInfo(spell.soulshape), "player")
                            br.addonDebug("Casting Soulshape")
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
            if br.SpecificToggle("Fleshcraft Key") and not br._G.GetCurrentKeyBoardFocus() then
                if cast.fleshcraft("player") then
                    return
                end
            end

            --Tank buster
            if mode.tankbuster == 1 and inInstance and inCombat then
                for i = 1, #enemies.yards30 do
                    local thisUnit = enemies.yards30[i]    
                    if br._G.UnitThreatSituation("player", thisUnit) == 3 and UnitCastingInfo("target") then
                        if br.lists.tankBuster[select(9, UnitCastingInfo("target"))] ~= nil then
                            if cast.able.shieldBlock() and mainTank() and (not buff.shieldBlock.exists() or (buff.shieldBlock.remain() <= (gcd * 1.5))) and rage >= 30 then
                                if cast.shieldBlock() then
                                    br.addonDebug("[TANKBUST] Shield Block")
                                    return
                                end
                            end
                        end
                    end
                end
            end

            -- Battle Shout Check
            if br.isChecked("Battle Shout") and cast.able.battleShout() then
                for i = 1, #br.friend do
                    local thisUnit = br.friend[i].unit
                    if not br.GetUnitIsDeadOrGhost(thisUnit) and br.getDistance(thisUnit) < 100 and br.getBuffRemain(thisUnit, spell.battleShout) < 60 then
                        if cast.battleShout() then
                            return
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
                    and notSolo
                    and inCombat
                    and mainTank()
                then
                    -- Intervene Melee to Refresh SB
                    if br.isChecked("Reprisal - Melee Intervene") 
                            and cd.intervene.ready()
                            and php <= br.getValue("Shield Block")
                            and rage <= 80
                            and (not buff.shieldBlock.exists() or buff.shieldBlock.remain() <= (gcd * br.getValue("Shield Block - Time Remain"))) 
                    then
                        for i = 1, #br.friend do
                            if not br.GetUnitIsUnit(br.friend[i].unit, "player") 
                                    and br.getDistance(br.friend[i].unit) >= 1 
                                    and br.getDistance(br.friend[i].unit) <= 5 
                            then
                                if cast.intervene(br.friend[i].unit) then
                                    br.addonDebug("[REPRISAL]Intervene Melee - Refresh shield block")
                                    return true
                                end
                            end
                        end
                    end
                    -- Intervene Ranged to Refresh SB and Charge Back
                    if br.isChecked("Reprisal - Ranged Charge Intervene") then
                        if cd.intervene.ready()
                                and charges.charge.count() > 1 
                                and rage <= 60
                                and (not buff.shieldBlock.exists() or buff.shieldBlock.remain() <= (gcd * br.getValue("Shield Block - Time Remain"))) 
                        then
                            for i = 1, #br.friend do
                                if not br.GetUnitIsUnit(br.friend[i].unit, "player") 
                                        and br.getDistance(br.friend[i].unit) >= br.getOptionValue("Reprisal - Min Distance") 
                                        and br.getDistance(br.friend[i].unit) <= br.getOptionValue("Reprisal - Max Distance") 
                                then
                                    if cast.intervene(br.friend[i].unit) then
                                        br.addonDebug("[REPRISAL]Intervene Ranged - Refresh shield block")
                                        return
                                    end
                                end
                            end
                        end
                        if not cd.intervene.ready() 
                                and br.getDistance("target") >= 8
                                and cd.charge.ready() 
                        then
                            if cast.charge("target") then 
                                return 
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
                    or br.isCastingSpell(spell.fleshcraft) 
            then
                return true
            else
                if inCombat 
                    and not br.isCastingSpell(spell.fleshcraft) 
                then 
                    -- Ignore Pain if checks are met
                    if cast.able.ignorePain() 
                            and rage >= 40
                            and mainTank() 
                            and ipCapCheck() 
                    then
                        --print("dumping IP")
                        br._G.CastSpellByName(GetSpellInfo(190456))
                    end
                    -- Use Off GCD Offensive CD's
                    if br.useCDs() and #enemies.yards5 >= 1 then
                        if br.isChecked("Avatar") then
                            --print("cd avatar")
                            if cast.avatar() then
                                return
                            end
                        end
                    end
                    -- Use Off GCD Defensive CD's
                    if br.useDefensive() then
                        -- Smart Spell Reflect
                        if br.isChecked("Smart Spell Reflect") then
                            for i = 1, #enemies.yards30 do
                                local thisUnit = enemies.yards30[i]
                                local _, _, _, startCast, endCast, _, _, _, spellcastID = br._G.UnitCastingInfo(thisUnit)

                                if br._G.UnitTarget("player") and reflectID[spellcastID] and (((GetTime() * 1000) - startCast) / (endCast - startCast) * 100) > br.getOptionValue("Smart Spell Reflect Percent") then
                                    if cast.spellReflection() then
                                        return
                                    end
                                end
                            end
                        end
                        -- Le Shield Block
                        if br.isChecked("Shield Block") 
                                and rage >= 30 
                                and cast.able.shieldBlock() 
                                and charges.shieldBlock.count() > br.getValue("Hold Shield Block") 
                                and php <= br.getValue("Shield Block")
                                and mainTank()
                                and ((talent.bolster and not buff.lastStand.exists()) or not talent.bolster) -- Bolster
                                and (not buff.shieldBlock.exists() or buff.shieldBlock.remain() <= (gcd * br.getValue("Shield Block - Time Remain")) or php <= br.getValue("Shield Block - Critical HP")) -- Extension/Missing
                        then
                            if cast.shieldBlock() then
                                return
                            end
                        end

                        -- Bolster Last Stand Filler
                        if (talent.bolster or br.getOptionValue("Last Stand Useage") == 1) 
                                and not (buff.shieldBlock.exists() or buff.shieldWall.exists()) 
                                and mainTank() 
                        then
                            if cast.lastStand() then
                                return
                            end
                        end

                        -- Off GCD Shield Wall
                        if br.isChecked("Shield Wall") 
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
                            and br.hasNoControl(spell.berserkerRage) 
                    then
                        if cast.berserkerRage() then
                            return
                        end
                    end

                    -- Pummel
                    for i = 1, #enemies.yards20 do
                        local thisUnit = enemies.yards20[i]
                        local unitDist = br.getDistance(thisUnit)
                        if not br.isExplosive(thisUnit) and br.canInterrupt(thisUnit, br.getOptionValue("Interrupt At")) then
                            if br.isChecked("Pummel") and unitDist < 6 then
                                if cast.pummel(thisUnit) then
                                    return
                                end
                            end
                        end
                    end

                    -- Taunt
                    if mode.taunt == 1 and inInstance then
                        for i = 1, #enemies.yards30 do
                            local thisUnit = enemies.yards30[i]
                            if br._G.UnitThreatSituation("player", thisUnit) ~= nil and br._G.UnitThreatSituation("player", thisUnit) <= 2 and br._G.UnitAffectingCombat(thisUnit) then
                                if cast.taunt(thisUnit) then
                                    return
                                end
                            end
                        end
                    end 
                    if mode.taunt == 2 then
                        for i = 1, #enemies.yards30 do
                            local thisUnit = enemies.yards30[i]
                            if br._G.UnitThreatSituation("player", thisUnit) ~= nil 
                                    and br._G.UnitThreatSituation("player", thisUnit) <= 2 
                                    and br._G.UnitAffectingCombat(thisUnit) 
                            then
                                if cast.taunt(thisUnit) then
                                    return
                                end
                            end
                        end
                    end -- End Taunt

                    -- Heroic Throw Aggro
                    if br.isChecked("Auto Heroic Throw") then
                        for i = 1, #enemies.yards30 do
                            local thisUnit = enemies.yards30[i]
                            if not unit.isTanking(thisUnit) 
                                    and br.getDistance("player", thisUnit) >= 8 
                                    and br._G.UnitThreatSituation("player", thisUnit) ~= nil
                                    and br._G.UnitThreatSituation("player", thisUnit) <= 2
                                    and br._G.UnitAffectingCombat(thisUnit)
                                    and not unit.isExplosive(thisUnit) 
                            then
                                if cast.heroicThrow(thisUnit) then 
                                    br.addonDebug("[AGGRO] Casting Heroic Throw")
                                    return
                                end
                            end
                        end
                    end  
                    -- Heroic Throw Ranged
                    if br.isChecked("Auto Heroic Throw") then
                        if #enemies.yards8 <= 0
                                and br.getDistance("player", "target") >= 8 
                                and not unit.isExplosive("target") 
                        then
                            if cast.heroicThrow("target") then 
                                br.addonDebug("[DPS] Casting Heroic Throw")
                                return
                            end
                        end
                    end
                end
            end
        end
        
        local function actionList_Interrupts()
            if br.useInterrupts() then
                -- Storm Bolt
                if br.isChecked("Storm Bolt Logic") then
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
                        local targetMe = br.GetUnitIsUnit("player", thisUnit) or false
                        if (Storm_unitList[br.GetObjectID(thisUnit)] ~= nil or StormBoltSpell_list[select(9, br._G.UnitCastingInfo(thisUnit))] ~= nil or StormBoltSpell_list[select(7, br._G.GetSpellInfo(br._G.UnitChannelInfo(thisUnit)))] ~= nil) and br.getBuffRemain(thisUnit, 226510) == 0 then
                            if br.isChecked("Intimidating Shout - Int") and unitDist <= 8 then
                                if cast.intimidatingShout() then
                                    return
                                end
                            end
                            if br.isChecked("Shockwave - Int") and unitDist < 10 then
                                if cast.shockwave() then
                                    return
                                end
                            end
                        end
                    end
                end
            end
        end
    
        local function actionList_Movement()
            if mode.mover == 1 then
                -- Best Location
                if br.isChecked("Heroic Leap - Target") 
                        and br.getOptionValue("Heroic Leap - Target") == 1 
                then
                    if cast.heroicLeap("best",nil,1,8) then 
                        br.addonDebug("Casting Heroic Leap @Best") 
                        return 
                    end
                end
                -- Target
                if br.isChecked("Heroic Leap - Target") 
                        and br.getOptionValue("Heroic Leap - Target") == 2 
                        and br.getDistance("target") >= 8 
                then
                    if cast.heroicLeap("target","ground") then 
                        br.addonDebug("Casting Heroic Leap @Target") 
                        return 
                    end
                end
                -- charge
                if br.isChecked("Charge") 
                        and cast.able.charge("target") 
                        and br.getDistance("target") >= 8 
                then
                    if cd.charge.ready() then
                        if cast.charge("target") then 
                            return 
                        end
                    end    
                end
            end
        end -- End Action List - Movement

        local function actionList_Defensives()
            if br.useDefensive() then
                --Victory Rush
                if php <= br.getValue("Victory Rush HP") 
                        and cast.able.victoryRush() 
                then
                    if cast.victoryRush() then
                        return
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
                -- Fleshcraft
                if br.isChecked("Fleshcraft on Health") 
                        and #enemies.yards8 >= br.getValue("Minimum Unit Count") 
                        and php <= br.getValue("Fleshcraft on Health") 
                        and cast.able.fleshcraft() 
                then
                    if cast.fleshcraft("player") then
                        return
                    end
                end
                -- Demo on CD
                if br.isChecked("Demoralizing Shout") 
                        and php <= br.getOptionValue("Demoralizing Shout") 
                        and br.getOptionValue("Demo Shout Useage") == 1 
                then
                    if cast.demoralizingShout() then
                        return
                    end
                end
                -- Last Stand on health
                if br.getOptionValue("Last Stand Useage") == 2 
                        and php <= br.getOptionValue("Last Stand - HP") 
                then
                    if cast.lastStand() then
                        return
                    end
                end
                -- Rallying Cry on Health
                if br.isChecked("Rallying Cry") 
                        and php <= br.getOptionValue("Rallying Cry") 
                then
                    if cast.rallyingCry() then
                        return
                    end
                end
                -- Shockwave on Unit Count
                if br.isChecked("Shockwave - Units") 
                        and #enemies.yards8 >= br.getOptionValue("Shockwave - Units") 
                        and not moving 
                then
                    if cast.shockwave() then
                        return
                    end
                end
            end
        end

        local function actionList_RageDump()
            -- ignore_pain,if=target.health.pct>20&!covenant.venthyr,line_cd=15
                -- Prioritize Execute over Ignore Pain as a rage dump below 20%

            -- ignore_pain,if=target.health.pct>20&target.health.pct<80&covenant.venthyr,line_cd=15
                -- Venthyr Condemn has 2 execute windows, 20% and 80%

            if not br.isExplosive("target") 
                    and rage >= br.getValue("Rage Pooling") 
                    and (not ipCapCheck() or not mainTank()) 
            then
                if #enemies.yards8 < 3 
                        and br.getHP("target") <= 20 
                        and not br._G.UnitIsPlayer(units.dyn8) 
                        and br.getFacing("player", units.dyn8) 
                then
                    if cast.execute(units.dyn8) then
                        br.addonDebug("[RAGEDUMP] Execute")
                        return
                    end
                end
                if br.getHP("target") > 20 
                        and cast.able.revenge(units.dyn5, "cone", 1, 5)  
                then
                    if cast.revenge() then
                        br.addonDebug("[RAGEDUMP] Revenge - @ This Rage:" .. tostring(rage))
                        return
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
                    return
                end
            end

            -- Vulpera Racial Heal
            if br.isChecked("Vulpera Racial Heal") 
                    and race == "Vulpera" 
                    and php <= br.getOptionValue("Vulpera Racial Heal")
            then
                if cast.racial("player") then
                    return
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
            if br.getOptionValue("Demo Shout Useage") == 1 
                    and rage <= 100 
                    and not moving 
            then
                if cast.demoralizingShout() then
                    return
                end
            end

            -- avatar
            if br.isChecked("Avatar - CD")
                    and not br.getOptionValue("Avatar - CD") == 4
                    and br.isBoss("target")
                        or (br.getOptionValue("Avatar - CD") == 3 and #enemies.yards8 >= br.getOptionValue("Avatar Mob Count")) 
                        or (br.getOptionValue("Avatar - CD") == 2 and cd.ravager.ready())
                        or (br.getOptionValue("Avatar - CD") == 1)
            then
                if cast.avatar() then
                    br.addonDebug("[CD] Avatar")
                    return
                end
            end   

            -- Covenant abilities            
            -- Ancient Aftershock | thnx Winterz
            if cd.ancientAftershock.ready() 
                    and cast.able.ancientAftershock(units.dyn12, "cone", 1, 12) 
                    and (#enemies.yards12 >= br.getOptionValue("Ancient Aftershock Units") or br.isBoss("target") or (#enemies.yards12 == 1 and ttd("target") >= 25))
                    and not moving
            then
                if cast.ancientAftershock(units.dyn12, "cone", 1, 12) then 
                    br.addonDebug("[COV] Ancient Aftershock")
                    return
                end
            end

            -- Conquerors Banner
            if br.isChecked("Conqueror's Banner") 
                    and br.player.covenant.necrolord.active 
            then
                if cast.conquerorsBanner() then
                    br.addonDebug("[CD] Conqueror's Banner")
                    return
                end
            end        

            -- shield_block,if=buff.shield_block.down
            if br.isChecked("Shield Block") 
                    and rage >= 30 
                    and cast.able.shieldBlock() 
                    and charges.shieldBlock.count() > br.getValue("Hold Shield Block") 
                    and php <= br.getValue("Shield Block")
                    and mainTank() 
                    and ((talent.bolster and not buff.lastStand.exists()) or not talent.bolster)
                    and (not buff.shieldBlock.exists() or buff.shieldBlock.remain() <= (gcd * br.getValue("Shield Block - Time Remain")))
            then
                if cast.shieldBlock() then
                    return
                end
            end

            -- run_action_list,name=aoe,if=spell_targets.thunder_clap>=3

            -- all_action_list,name=Rotation
        end

        local function actionList_Rotation()
            -- ravager
            if br.isChecked("Auto Ravager") 
                    and not br.isExplosive("target") 
                    and talent.ravager 
                    and not moving
            then
                if cast.ravager("best", false, 1, 8) then
                    return
                end
            end

            -- dragon_roar
            if not br.isExplosive("target") 
                    and br.isChecked("Dragon Roar") 
                    and not moving 
            then
                if cast.dragonRoar() then
                    return
                end
            end

            -- shield_slam,if=buff.shield_block.up
            if not br._G.UnitIsPlayer(units.dyn8) 
                and br.getFacing("player", units.dyn8)
                and buff.shieldBlock.exists() 
            then
                if cast.shieldSlam(units.dyn8) then
                    br.addonDebug("[DPS] Boosted Shield Slam")
                    return
                end
            end

            -- thunder_clap,if=(spell_targets.thunder_clap>1|cooldown.shield_slam.remains)&talent.unstoppable_force.enabled&buff.avatar.up
            if not br.isExplosive("target") 
                    and not cd.shieldSlam.ready()
                    and ((talent.unstoppableForce and buff.avatar.exists()) or #enemies.yards8 >= br.getOptionValue("AoE Threshold")) 
            then
                if cast.thunderClap() then
                    br.addonDebug("[DPS] Unstoppable Thunderclap")
                    return
                end
            end

            -- shield_slam
            if not br._G.UnitIsPlayer(units.dyn8) 
                    and br.getFacing("player", units.dyn8) 
            then
                if cast.shieldSlam(units.dyn8) then
                    br.addonDebug("[DPS] Shield Slam")
                    return
                end
            end

            -- execute
            if #enemies.yards8 < br.getOptionValue("AoE Threshold")  
                    and br.getHP("target") <= 20 
                    and not br._G.UnitIsPlayer(units.dyn8) 
                    and br.getFacing("player", units.dyn8) 
            then
                if cast.execute("target") then
                    br.addonDebug("[DPS] Execute")
                    return
                end
            end

            -- revenge,if=rage>80&target.health.pct>20|buff.revenge.up
            if not br.isExplosive("target")
                    and cast.able.revenge(units.dyn5, "cone", 1, 5) 
                    and (br.getHP("target") > 20 and rage >= br.getValue("Rage Pooling")) or buff.revenge.exists() 
            then
                if cast.revenge() then
                    br.addonDebug("[RAGEDUMP/PROC] Revenge")
                    return
                end
            end

            -- thunder_clap
            if not br.isExplosive("target") 
                    and not cd.shieldSlam.ready()
                    and cd.thunderClap.ready()
            then
                br._G.CastSpellByName(GetSpellInfo(spell.thunderClap))
                br.addonDebug("[DPS] Thunderclap")
                return true
            end

            -- revenge
            if mode.Aggression == 1
                    and not br.isExplosive("target") 
                    and br.getHP("target") > 20
                    and not cd.thunderClap.ready()
                    and not cd.shieldSlam.ready()
                    and cast.able.revenge(units.dyn5, "cone", 1, 5) 
            then
                if cast.revenge() then
                    br.addonDebug("[DPS] Aggressive Revenge")
                    return
                end
            end

            -- devastate
            if not talent.devestator then
                if cd.shieldSlam.remain() > (gcdMax / 2) 
                        and (br.isExplosive("target") or cd.thunderClap.remain() > (gcdMax / 2)) 
                then
                    if cast.devastate() then
                        return
                    end
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
        if br.player.covenant.nightFae.active 
                and not inCombat 
        then
            if soulShape_NF() then
                return
            end
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
                if rage >= br.getValue("Rage Pooling") 
                        or not mainTank()
                then
                    if actionList_RageDump() then
                        return
                    end
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
