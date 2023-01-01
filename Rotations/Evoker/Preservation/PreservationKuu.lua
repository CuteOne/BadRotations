-------------------------------------------------------
-- Author = Kuukuu
-- Patch = 10.0
--    Patch should be the latest patch you've updated the rotation for (i.e., 9.2.5)
-- Coverage = 30%
--    Coverage should be your estimated percent coverage for class mechanics (i.e., 100%)
-- Status = Sporadic
--    Status should be one of: Full, Limited, Sporadic, Inactive, Unknown
-- Readiness = Development
--    Readiness should be one of: Raid, NoRaid, Basic, Development, Untested
-------------------------------------------------------
-- Required: Fill above fields to populate README.md --
-------------------------------------------------------
local rotationName = "Preserved Kuu"

---------------
--- Toggles ---
---------------
local function createToggles()
    -- Cooldown Button
    local CreateButton = br["CreateButton"]
    br.CooldownModes = {
        [1] = {
            mode = "Auto",
            value = 1,
            overlay = "Cooldowns Automated",
            tip = "Automatic Cooldowns - Boss Detection",
            highlight = 1,
            icon = br.player.spell.furyOfTheAspects
        },
        [2] = {
            mode = "On",
            value = 1,
            overlay = "Cooldowns Enabled",
            tip = "Cooldowns used regardless of target",
            highlight = 0,
            icon = br.player.spell.furyOfTheAspects
        },
        [3] = {
            mode = "Off",
            value = 3,
            overlay = "Cooldowns Disabled",
            tip = "No Cooldowns will be used",
            highlight = 0,
            icon = br.player.spell.furyOfTheAspects
        }
    }
    CreateButton("Cooldown", 1, 0)
    -- Defensive Button
    br.DefensiveModes = {
        [1] = {
            mode = "On",
            value = 1,
            overlay = "Defensive Enabled",
            tip = "Includes Defensive Cooldowns",
            highlight = 1,
            icon = br.player.spell.obsidianScales
        },
        [2] = {
            mode = "Off",
            value = 2,
            overlay = "Defensive Disabled",
            tip = "No Defensives will be used",
            highlight = 0,
            icon = br.player.spell.obsidianScales
        }
    }
    CreateButton("Defensive", 2, 0)
    -- Decurse Button
    br.DecurseModes = {
        [1] = {
            mode = "On",
            value = 1,
            overlay = "Decurse Enabled",
            tip = "Decurse Enabled",
            highlight = 1,
            icon = br.player.spell.naturalize
        },
        [2] = {
            mode = "Off",
            value = 2,
            overlay = "Decurse Disabled",
            tip = "Decurse Disabled",
            highlight = 0,
            icon = br.player.spell.naturalize
        }
    }
    CreateButton("Decurse", 3, 0)
    -- Interrupt Button
    br.InterruptModes = {
        [1] = {
            mode = "On",
            value = 1,
            overlay = "Interrupts Enabled",
            tip = "Includes Basic Interrupts.",
            highlight = 1,
            icon = br.player.spell.quell
        },
        [2] = {
            mode = "Off",
            value = 2,
            overlay = "Interrupts Disabled",
            tip = "No Interrupts will be used.",
            highlight = 0,
            icon = br.player.spell.quell
        }
    }
    CreateButton("Interrupt", 4, 0)
    -- DPS Button
    br.DPSModes = {
        [2] = {
            mode = "On",
            value = 1,
            overlay = "DPS Enabled",
            tip = "DPS Enabled",
            highlight = 1,
            icon = br.player.spell.deepBreath
        },
        [1] = {
            mode = "Off",
            value = 2,
            overlay = "DPS Disabled",
            tip = "DPS Disabled",
            highlight = 0,
            icon = br.player.spell.emeraldBlossom
        }
    }
    CreateButton("DPS", 5, 0)
end

--------------
--- COLORS ---
--------------
local colorBlue = "|cff00CCFF"
local colorGreen = "|cff00FF00"
local colorRed = "|cffFF0000"
local colorWhite = "|cffFFFFFF"
local colorGold = "|cffFFDD11"
local colorYellow = "|cffFFFF00"

---------------
--- OPTIONS ---
---------------
local function createOptions()
    local optionTable

    local function rotationOptions()
        local section
        -- General Options
        section = br.ui:createSection(br.ui.window.profile, "General - Version 0.0.2")
        br.ui:createCheckbox(section, "OOC Healing",
            "|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFout of combat healing|cffFFBB00.", 1)
        -- Pre-Pull Timer
        br.ui:createSpinner(section, "Pre-Pull Timer", 5, 0, 20, 1,
            "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
        br.ui:createSpinner(section, "Raid Boss Helper", 70, 0, 100, 5,
            "Minimum party member health to focus on healing raid bosses")
        -- Bursting Stack
        br.ui:createSpinnerWithout(section, "Bursting", 1, 1, 10, 1, "",
            "|cffFFFFFFWhen Bursting stacks are above this amount, CDs will be triggered.")
        br.ui:createDropdown(section, "DPS Key", br.dropOptions.Toggle, 6,
            "Set a key for using DPS")
        -- DPS Save mana
        br.ui:createSpinnerWithout(section, "DPS Save mana", 40, 0, 100, 5, "|cffFFFFFFMana Percent to Stop DPS")
        -- Return
        br.ui:createDropdown(section, "Return",
            {"|cffFFFF00Selected Target", "|cffFF0000Mouseover Target", "|cffFFBB00Auto"}, 1,
            "|ccfFFFFFFTarget to Cast On")

        br.ui:createCheckbox(section, "Pig Catcher", "Catch the freehold Pig in the ring of booty")
        br.ui:checkSectionState(section)
        -- Cooldown Options
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
        --  Mana Potion
        br.ui:createSpinner(section, "Mana Potion", 50, 0, 100, 1, "Mana Percent to Cast At")
        -- Racial
        br.ui:createCheckbox(section, "Racial")
        -- Trinkets
        br.ui:createSpinner(section, "Trinket 1", 70, 0, 100, 5, "Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Min Trinket 1 Targets", 3, 1, 40, 1, "",
            "Minimum Trinket 1 Targets(This includes you)", true)
        br.ui:createDropdownWithout(section, "Trinket 1 Mode",
            {"|cffFFFFFFNormal", "|cffFFFFFFTarget", "|cffFFFFFFGround"}, 1, "", "")
        br.ui:createSpinner(section, "Trinket 2", 70, 0, 100, 5, "Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Min Trinket 2 Targets", 3, 1, 40, 1, "",
            "Minimum Trinket 2 Targets(This includes you)", true)
        br.ui:createDropdownWithout(section, "Trinket 2 Mode",
            {"|cffFFFFFFNormal", "|cffFFFFFFTarget", "|cffFFFFFFGround"}, 1, "", "")
        -- Dream Flight
        br.ui:createSpinner(section, "Dream Flight", 60, 0, 100, 5, "Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Dream Flight Targets", 3, 0, 40, 1, "Minimum Dream Flight Targets")
        -- Rewind
        br.ui:createSpinner(section, "Rewind", 50, 0, 100, 5, "Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Rewind Targets", 3, 0, 40, 1, "Minimum Rewind Targets")
        br.ui:createCheckbox(section, "Tip the Scales")
        br.ui:checkSectionState(section)
        -- -- Covenant Options
        -- section = br.ui:createSection(br.ui.window.profile, "Covenant Options")
        -- br.ui:createDropdown(section, "Convoke Spirits", {"DPS", "HEAL", "BOTH", "Manual"}, 3, "How to use Convoke Spirits")
        -- br.ui:createSpinnerWithout(section, "Convoke Heal", 40, 0, 100, 5, "Health Percent to Cast At")
        -- br.ui:createSpinnerWithout(section, "Convoke Heal Targets", 1, 0, 40, 1, "Minimum Convoke Targets")
        -- br.ui:createCheckbox(section, "Ravenous Frenzy")
        -- br.ui:createSpinner(section, "Adaptive Swarm", 2, 0, 10, 1, "Max Swarm Targets")
        -- br.ui:checkSectionState(section)
        -- Defensive Options
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
        -- Healthstone
        -- Basic Healing Module
        br.player.module.BasicHealing(section)
        br.ui:checkSectionState(section)
        -- Interrupts Options
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
        -- Tail Swipe
        -- br.ui:createCheckbox(section, "Tail Swipe")
        br.ui:createCheckbox(section, "Quell")
        -- Interrupt Percentage
        br.ui:createSpinner(section, "InterruptAt", 95, 0, 95, 5, "|cffFFBB00Cast Percentage to use at.")
        br.ui:checkSectionState(section)
        -- Healing Options
        section = br.ui:createSection(br.ui.window.profile, "Healing")
        br.ui:createSpinner(section, "Emerald Blossom", 50, 0, 100, 5, "Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Emerald Blossom Targets", 3, 0, 40, 1, "Minimum Emerald Blossom Targets")
        br.ui:createSpinner(section, "Verdant Embrace", 50, 0, 100, 5, "Health Percent to Cast At")
        br.ui:createSpinner(section, "Dream Breath", 50, 0, 100, 5, "Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Dream Breath Targets", 3, 0, 40, 1, "Minimum Dream Breath Targets")
        br.ui:createSpinner(section, "Spiritbloom", 50, 0, 100, 5, "Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Spiritbloom Targets", 3, 0, 40, 1, "Minimum Spiritbloom Targets")
        br.ui:createSpinner(section, "Reversion", 30, 0, 100, 5, "Health Percent to Cast At")
		br.ui:createDropdownWithout(
			section,
			"Reversion Target",
			{
				"|cffFFFFFFPlayer",
				"|cffFFFFFFTarget",
				"|cffFFFFFFMouseover",
				"|cffFFFFFFTank",
				"|cffFFFFFFHealer",
				"|cffFFFFFFHealer/Tank",
				"|cffFFFFFFAny"
			},
			7,
			"|cffFFFFFFcast Reversion Target"
		)
        br.ui:createSpinner(section, "Echo", 50, 0, 100, 5, "Health Percent to Cast At")
        br.ui:createSpinner(section, "Living Flame", 30, 0, 100, 5, "|cffFFBB00Health Percentage to use at")
        br.ui:checkSectionState(section)
        -- Toggle Key Options
        section = br.ui:createSection(br.ui.window.profile, "Toggle Keys")
        -- Pause Toggle
        br.ui:createDropdownWithout(section, "DPS Mode", br.dropOptions.Toggle, 6)
        br.ui:createDropdownWithout(section, "Decurse Mode", br.dropOptions.Toggle, 6)
        br.ui:checkSectionState(section)
    end
    optionTable = {{
        [1] = "Rotation Options",
        [2] = rotationOptions
    }}
    return optionTable
end

----------------
--- ROTATION ---
---------------_

local function runRotation()
    -- if br.timer:useTimer("debugRestoration", 0.1) then
    -- print("Running: "..rotationName)
    --------------
    --- Locals ---
    --------------
    -- local artifact                                      = br.player.artifact
    -- local combatTime                                    = br.getCombatTime()
    -- local cd 										   = br.player.cd
    -- local charges                                       = br.player.charges
    -- local perk                                          = br.player.perk
    -- local gcd                                           = br.player.gcd
    -- local lastSpell                                     = lastSpellCast
    -- local lowest                                        = br.friend[1]
    local buff = br.player.buff
    local cast = br.player.cast
    local cd = br.player.cd
    local charges = br.player.charges
    local combo = br.player.power.comboPoints.amount()
    local covenant = br.player.covenant
    local debuff = br.player.debuff
    local drinking = br.getBuffRemain("player", 192002) ~= 0 or br.getBuffRemain("player", 167152) ~= 0 or
                         br.getBuffRemain("player", 192001) ~= 0 or br.getBuffRemain("player", 314646) ~= 0
    local resable = br._G.UnitIsPlayer("target") and br._G.UnitIsDeadOrGhost("target") and
                        br.GetUnitIsFriend("target", "player") and br._G.UnitInRange("target")
    local deadtar = br.GetUnitIsDeadOrGhost("target") or br.isDummy()
    local hastar = hastar or br.GetObjectExists("target")
    local enemies = br.player.enemies
    local friends = friends or {}
    local falling, swimming, flying = br.getFallTime(), br._G.IsSwimming(), br._G.IsFlying()
    local moving = br.isMoving("player") ~= false or br.player.moving
    local gcdMax = br.player.gcdMax
    local healPot = br.getHealthPot()
    local inCombat = br.isInCombat("player")
    local inInstance = br.player.instance == "party"
    local inRaid = br.player.instance == "raid"
    local stealthed = br.UnitBuffID("player", 5215) ~= nil
    local level = br.player.level
    local mana = br.player.power.mana.percent()
    local mode = br.player.ui.mode
    local php = br.player.health
    local power, powmax, powgen = br.player.power.mana.amount(), br.player.power.mana.max(),
        br.player.power.mana.regen()
    local pullTimer = br.DBM:getPulltimer()
    local race = br.player.race
    local racial = br.player.getRacial()
    local runeforge = br.player.runeforge
    local spell = br.player.spell
    local talent = br.player.talent
    local unit = br.player.unit
    local units = br.player.units
    local tanks = br.getTanksTable()
    local ttd = br.getTTD
    local burst = nil

    units.get(5)
    units.get(8)

    enemies.get(5)
    enemies.get(5, "player", false, true)
    enemies.get(8)
    enemies.get(8, "target")
    enemies.get(25)
    enemies.get(40)
    friends.yards40 = br.getAllies("player", 40)

    if inInstance and select(3, br._G.GetInstanceInfo()) == 8 then
        for i = 1, #tanks do
            local ourtank = tanks[i].unit
            local Burststack = br.getDebuffStacks(ourtank, 240443)
            if Burststack >= br.getOptionValue("Bursting") then
                burst = true
                break
            else
                burst = false
            end
        end
    end

    local lowest = {}
    lowest.unit = "player"
    lowest.hp = 100
    for i = 1, #br.friend do
        if br.friend[i].hp < lowest.hp then
            lowest = br.friend[i]
        end
    end

    local empoweredLevel = 0

    -- local function BossEncounterCase()
    -- 	-- Temple of Sethraliss
    -- 	if
    -- 		br.isChecked("Raid Boss Helper") and lowest.hp > br.getOptionValue("Raid Boss Helper") and br.player.eID and
    -- 			(br.player.eID == 2127 or br.player.eID == 2418 or br.player.eID == 2402)
    -- 	 then
    -- 		for i = 1, br._G.GetObjectCount() do
    -- 			local thisUnit = br._G.GetObjectWithIndex(i)
    -- 			local ID = br.GetObjectID(thisUnit)
    -- 			if ID == 133392 or ID == 171577 or ID == 173112 or ID == 165759 or ID == 165778 then
    -- 				local healObject = thisUnit
    -- 				if
    -- 					br.getHP(healObject) < 100 and
    -- 						((ID == 133392 and br.getBuffRemain(healObject, 274148) == 0) or ID == 171577 or ID == 173112 or
    -- 							((ID == 165759 or ID == 165778) and not br.shadeUp))
    -- 				 then
    -- 					if talent.germination and not buff.rejuvenationGermination.exists(healObject) then
    -- 						clearform()
    -- 						br._G.CastSpellByName(br._G.GetSpellInfo(774), healObject)
    -- 						return true
    -- 					end
    -- 					if not buff.rejuvenation.exists(healObject) then
    -- 						clearform()
    -- 						br._G.CastSpellByName(br._G.GetSpellInfo(774), healObject)
    -- 						return true
    -- 					end
    -- 					if buff.rejuvenation.exists(healObject) then
    -- 						clearform()
    -- 						br._G.CastSpellByName(br._G.GetSpellInfo(8936), healObject)
    -- 						return true
    -- 					end
    -- 				end
    -- 			end
    -- 		end
    -- 	end
    -- 	if inInstance then
    -- 		for i = 1, #br.friend do
    -- 			-- Jagged Nettles and Dessication logic
    -- 			if br.getDebuffRemain(br.friend[i].unit, 260741) ~= 0 or br.getDebuffRemain(br.friend[i].unit, 267626) ~= 0 then
    -- 				if br.getSpellCD(18562) == 0 and count_hots(br.friend[i].unit) > 0 then
    -- 					clearform()
    -- 					if cast.swiftmend(br.friend[i].unit) then
    -- 						br.addonDebug("Casting Swiftmend (Jagged Nettles)")
    -- 						return true
    -- 					end
    -- 				end
    -- 				if br.getSpellCD(18562) > gcdMax then
    -- 					if not moonkin then
    -- 						clearform()
    -- 					end
    -- 					if cast.regrowth(br.friend[i].unit) then
    -- 						br.addonDebug("Casting Regrowth")
    -- 						return true
    -- 					end
    -- 				end
    -- 			end
    -- 			-- Devour
    -- 			if br.getDebuffRemain(br.friend[i].unit, 255421) ~= 0 and br.friend[i].hp <= 90 then
    -- 				if br.getSpellCD(102342) == 0 then
    -- 					clearform()
    -- 					if cast.ironbark(br.friend[i].unit) then
    -- 						br.addonDebug("Casting Ironbark")
    -- 						return true
    -- 					end
    -- 				end
    -- 				if not moonkin then
    -- 					clearform()
    -- 				end
    -- 				if cast.regrowth(br.friend[i].unit) then
    -- 					br.addonDebug("Casting Regrowth")
    -- 					return true
    -- 				end
    -- 			end
    -- 		end
    -- 	end
    -- end

    -- Action List - Extras
    local function actionList_Extras()
        -- Return
        if br.isChecked("Return") and not inCombat and not br.isMoving("player") and br.timer:useTimer("Resurrect", 4) then
            if br.getOptionValue("Return") == 1 and br._G.UnitIsPlayer("target") and br.GetUnitIsDeadOrGhost("target") and
                br.GetUnitIsFriend("target", "player") then
                if cast.returnEvoker("target", "dead") then
                    br.addonDebug("Casting Return")
                    return true
                end
            end
            if br.getOptionValue("Return") == 2 and br._G.UnitIsPlayer("mouseover") and
                br.GetUnitIsDeadOrGhost("mouseover") and br.GetUnitIsFriend("mouseover", "player") then
                if cast.returnEvoker("mouseover", "dead") then
                    br.addonDebug("Casting Return")
                    return true
                end
            end
            if br.getOptionValue("Return") == 3 then
                local deadPlayers = {}
                for i = 1, #br.friend do
                    if br._G.UnitIsPlayer(br.friend[i].unit) and br.GetUnitIsDeadOrGhost(br.friend[i].unit) then
                        br._G.tinsert(deadPlayers, br.friend[i].unit)
                    end
                end
                if #deadPlayers > 1 then
                    if cast.massReturn() then
                        br.addonDebug("Casting Mass Return")
                        return true
                    end
                elseif #deadPlayers == 1 then
                    if cast.returnEvoker(deadPlayers[1], "dead") then
                        br.addonDebug("Casting Return (Auto)")
                        return true
                    end
                end
            end
        end
    end -- End Action List - Extras

    -- Action List - Pre-Combat
    local function actionList_PreCombat()
        if br.isChecked("Pig Catcher") then
            br.bossHelper()
        end
        -- Pre-Pull Timer
        if br.isChecked("Pre-Pull Timer") then
            if br.PullTimerRemain() <= br.getOptionValue("Pre-Pull Timer") then
                if br.hasItem(166801) and br.canUseItem(166801) then
                    br.addonDebug("Using Sapphire of Brilliance")
                    br.useItem(166801)
                end
                if br.canUseItem(142117) and not buff.prolongedPower.exists() then
                    br.addonDebug("Using Prolonged Power Pot")
                    br.useItem(142117)
                end
            end
        end
    end -- End Action List - Pre-Combat

    local function actionList_Defensive()
        if br.useDefensive() then
            -- Obsidian Scales
            if br.isChecked("Obsidian Scales") then
                if php <= br.getOptionValue("Obsidian Scales") then
                    if cast.obsidianScales() then
                        br.addonDebug("Casting Obsidian Scales")
                        return true
                    end
                end
            end
            -- Healthstone
            if br.isChecked("Healthstone") and php <= br.getOptionValue("Healthstone") and
                (br.hasHealthPot() or br.hasItem(5512) or br.hasItem(166799)) then
                if br.canUseItem(5512) then
                    br.addonDebug("Using Healthstone")
                    br.useItem(5512)
                elseif br.canUseItem(healPot) then
                    br.addonDebug("Using Health Pot")
                    br.useItem(healPot)
                elseif br.hasItem(166799) and br.canUseItem(166799) then
                    br.addonDebug("Using Emerald of Vigor")
                    br.useItem(166799)
                end
            end
        end -- End Defensive Toggle
    end -- End Action List - Defensive

    -- Interrupt
    local function actionList_Interrupts()
        if br.useInterrupts() then
            for i = 1, #enemies.yards25 do
                local thisUnit = enemies.yards25[i]
                if br.canInterrupt(thisUnit, br.getOptionValue("InterruptAt")) then
                    -- Quell
                    if br.isChecked("Quell") and talent.quell and br.getFacing("player", thisUnit) then
                        if cast.quell() then
                            br.addonDebug("Casting Quell")
                            return true
                        end
                    end
                end
            end
        end
    end

    local function actionList_Cooldowns()
        if br.useCDs() then
            -- Trinkets
            if br.isChecked("Trinket 1") and br.canTrinket(13) and not br.hasEquiped(165569, 13) and
                not br.hasEquiped(160649, 13) and not br.hasEquiped(158320, 13) then
                if br.getOptionValue("Trinket 1 Mode") == 1 then
                    if br.getLowAllies(br.getValue("Trinket 1")) >= br.getValue("Min Trinket 1 Targets") or burst ==
                        true then
                        br.useItem(13)
                        br.addonDebug("Using Trinket 1")
                        return true
                    end
                elseif br.getOptionValue("Trinket 1 Mode") == 2 then
                    if (lowest.hp <= br.getValue("Trinket 1") or burst == true) and lowest.hp ~= 250 then
                        br._G.UseItemByName(_G.GetInventoryItemID("player", 13), lowest.unit)
                        br.addonDebug("Using Trinket 1 (Target)")
                        return true
                    end
                elseif br.getOptionValue("Trinket 1 Mode") == 3 and #tanks > 0 then
                    for i = 1, #tanks do
                        -- get the tank's target
                        local tankTarget = br._G.UnitTarget(tanks[i].unit)
                        if tankTarget ~= nil then
                            -- get players in melee range of tank's target
                            local meleeFriends = br.getAllies(tankTarget, 5)
                            -- get the best ground circle to encompass the most of them
                            local loc = nil
                            if #meleeFriends < 12 then
                                loc = br.getBestGroundCircleLocation(meleeFriends, 4, 6, 10)
                            else
                                local meleeHurt = {}
                                for j = 1, #meleeFriends do
                                    if meleeFriends[j].hp < br.getValue("Trinket 1") then
                                        br._G.tinsert(meleeHurt, meleeFriends[j])
                                    end
                                end
                                if #meleeHurt >= br.getValue("Min Trinket 1 Targets") or burst == true then
                                    loc = br.getBestGroundCircleLocation(meleeHurt, 2, 6, 10)
                                end
                            end
                            if loc ~= nil then
                                br.useItem(13)
                                br.addonDebug("Using Trinket 1 (Ground)")
                                local px, py, pz = br._G.ObjectPosition("player")
                                loc.z = select(3,
                                    br._G.TraceLine(loc.x, loc.y, loc.z + 5, loc.x, loc.y, loc.z - 5, 0x110)) -- Raytrace correct z, Terrain and WMO hit
                                if loc.z ~= nil and br._G.TraceLine(px, py, pz + 2, loc.x, loc.y, loc.z + 1, 0x100010) ==
                                    nil and br._G.TraceLine(loc.x, loc.y, loc.z + 4, loc.x, loc.y, loc.z, 0x1) == nil then -- Check z and LoS, ignore terrain and m2 collisions
                                    br._G.ClickPosition(loc.x, loc.y, loc.z)
                                    return true
                                end
                            end
                        end
                    end
                end
            end
            if br.isChecked("Trinket 2") and br.canTrinket(14) and not br.hasEquiped(165569, 14) and
                not br.hasEquiped(160649, 14) and not br.hasEquiped(158320, 14) then
                if br.getOptionValue("Trinket 2 Mode") == 1 then
                    if br.getLowAllies(br.getValue("Trinket 2")) >= br.getValue("Min Trinket 2 Targets") or burst ==
                        true then
                        br.useItem(14)
                        br.addonDebug("Using Trinket 2")
                        return true
                    end
                elseif br.getOptionValue("Trinket 2 Mode") == 2 then
                    if (lowest.hp <= br.getValue("Trinket 2") or burst == true) and lowest.hp ~= 250 then
                        br._G.UseItemByName(_G.GetInventoryItemID("player", 14), lowest.unit)
                        br.addonDebug("Using Trinket 2 (Target)")
                        return true
                    end
                elseif br.getOptionValue("Trinket 2 Mode") == 3 and #tanks > 0 then
                    for i = 1, #tanks do
                        -- get the tank's target
                        local tankTarget = br._G.UnitTarget(tanks[i].unit)
                        if tankTarget ~= nil then
                            -- get players in melee range of tank's target
                            local meleeFriends = br.getAllies(tankTarget, 5)
                            -- get the best ground circle to encompass the most of them
                            local loc = nil
                            if #meleeFriends < 12 then
                                loc = br.getBestGroundCircleLocation(meleeFriends, 4, 6, 10)
                            else
                                local meleeHurt = {}
                                for j = 1, #meleeFriends do
                                    if meleeFriends[j].hp < br.getValue("Trinket 2") then
                                        br._G.tinsert(meleeHurt, meleeFriends[j])
                                    end
                                end
                                if #meleeHurt >= br.getValue("Min Trinket 2 Targets") or burst == true then
                                    loc = br.getBestGroundCircleLocation(meleeHurt, 2, 6, 10)
                                end
                            end
                            if loc ~= nil then
                                br.useItem(14)
                                br.addonDebug("Using Trinket 2 (Ground)")
                                br._G.ClickPosition(loc.x, loc.y, loc.z)
                                return true
                            end
                        end
                    end
                end
            end
            -- Mana Potion
            if br.isChecked("Mana Potion") and mana <= br.getValue("Mana Potion") then
                if br.hasItem(127835) then
                    br.useItem(127835)
                    br.addonDebug("Using Mana Potion")
                end
            end
            -- Dream Flight
            if br.isChecked("Dream Flight") and talent.dreamFlight and not moving then
                if br.getLowAllies(br.getValue("Dream Flight")) >= br.getValue("Dream Flight Targets") or burst == true then
                    if cast.dreamFlight() then
                        br.addonDebug("Casting Dream Flight")
                        return true
                    end
                end
            end
            -- Rewind
            if br.isChecked("Rewind") then
                if br.getLowAllies(br.getValue("Rewind")) >= br.getValue("Rewind Targets") or burst == true then
                    if cast.rewind() then
                        br.addonDebug("Casting Rewind")
                        return true
                    end
                end
            end
        end -- End useCooldowns check
    end -- End Action List - Cooldowns

    local function actionList_Decurse()
        -- Naturalize
        if mode.decurse == 1 then
            for i = 1, #friends.yards40 do
                if br.canDispel(br.friend[i].unit, spell.naturalize) then
                    if cast.naturalize(br.friend[i].unit) then
                        br.addonDebug("Casting Naturalize")
                        return true
                    end
                end
            end
        end
    end

    -- AOE Healing
    local function actionList_AOEHealing()
        -- Emerald Blossom
        if br.isChecked("Emerald Blossom") then
            for i = 1, #br.friend do
                if br._G.UnitInRange(br.friend[i].unit) or br._G.UnitIsUnit(br.friend[i].unit, "player") then
                    local lowHealthCandidates = br.getUnitsToHealAround(br.friend[i].unit, 10,
                        br.getValue("Emerald Blossom"), #br.friend)
                    if #lowHealthCandidates >= br.getValue("Emerald Blossom Targets") then
                        if cast.emeraldBlossom(br.friend[i].unit) then
                            br.addonDebug("Casting Emerald Blossom")
                            return true
                        end
                    end
                end
            end
        end
        -- Verdant Embrace
        if br.isChecked("Verdant Embrace") and lowest.hp <= br.getValue("Verdant Embrace" ) then
            if cast.verdantEmbrace(lowest.unit) then
                br.addonDebug("Casting Verdant Embrace")
                return true
            end
        end
        -- Dream Breath
        if br.isChecked("Dream Breath") and talent.dreamBreath and not moving then
            if br.healConeAround(br.getValue("Dream Breath Targets"), br.getValue("Dream Breath"), 90, 30, 0) then
                if cast.dreamBreath() then
                    br.addonDebug("Casting Dream Breath")
                    empoweredLevel = 1
                    return true
                end
            end
        end
        -- Spiritbloom
        if br.isChecked("Spiritbloom") and talent.spiritBloom and not moving then
            for i = 1, #br.friend do
                if br._G.UnitInRange(br.friend[i].unit) or br._G.UnitIsUnit(br.friend[i].unit, "player") then
                    local lowHealthCandidates = br.getUnitsToHealAround(br.friend[i].unit, 30,
                        br.getValue("Spiritbloom"), #br.friend)
                    if #lowHealthCandidates >= br.getValue("Spiritbloom Targets") then
                        if cast.spiritbloom(br.friend[i].unit) then
                            br.addonDebug("Casting Spiritbloom")
                            empoweredLevel = 4
                            return true
                        end
                    end
                end
            end
        end  

    end

    -- Single Target
    local function actionList_SingleTarget()
        -- Reversion
        if br.isChecked("Reversion") and charges.reversion.count() > 0 then
            if br.getOptionValue("Reversion Target") == 1 then
                if php <= br.getValue("Reversion") and not buff.reversion.exists("player") then
                    if cast.reversion("player") then
                        br.addonDebug("Casting Reversion")
                        return true
                    end
                end
            elseif br.getOptionValue("Reversion Target") == 2 then
                if br.getHP("target") <= br.getValue("Reversion") and not buff.reversion.exists("target") then
                    if cast.reversion("target") then
                        br.addonDebug("Casting Reversion")
                        return true
                    end
                end
            elseif br.getOptionValue("Reversion Target") == 3 then
                if br.getHP("mouseover") <= br.getValue("Reversion") and not buff.reversion.exists("mouseover") then
                    if cast.reversion("mouseover") then
                        br.addonDebug("Casting Reversion")
                        return true
                    end
                end
            elseif br.getOptionValue("Reversion Target") == 4 then
                for i = 1, #tanks do
                    if tanks[i].hp <= br.getValue("Reversion") and br.getDistance(tanks[i].unit) <= 40 and not buff.reversion.exists(tanks[i].unit) then
                        if cast.reversion(tanks[i].unit) then
                            br.addonDebug("Casting Reversion")
                            return true
                        end
                    end
                end
            elseif br.getOptionValue("Reversion Target") == 5 then
                for i = 1, #br.friend do
                    if br.friend[i].hp <= br.getValue("Reversion") and br._G.UnitGroupRolesAssigned(br.friend[i].unit) ==
                        "HEALER" and not buff.reversion.exists(br.friend[i].unit) then
                        if cast.reversion(br.friend[i].unit) then
                            br.addonDebug("Casting Reversion")
                            return true
                        end
                    end
                end
            elseif br.getOptionValue("Reversion Target") == 6 then
                for i = 1, #br.friend do
                    if br.friend[i].hp <= br.getValue("Reversion") and
                        (br._G.UnitGroupRolesAssigned(br.friend[i].unit) == "HEALER" or br.friend[i].role == "HEALER" or
                            br.friend[i].role == "TANK" or br._G.UnitGroupRolesAssigned(br.friend[i].unit) == "TANK") and not buff.reversion.exists(br.friend[i].unit) then
                        if cast.reversion(br.friend[i].unit) then
                            br.addonDebug("Casting Reversion")
                            return true
                        end
                    end
                end
            elseif br.getOptionValue("Reversion Target") == 7 then
                if lowest.hp <= br.getValue("Reversion") and not buff.reversion.exists(lowest.unit) then
                    if cast.reversion(lowest.unit) then
                        br.addonDebug("Casting Reversion")
                        return true
                    end
                end
            end
        end
        -- Echo
        if br.isChecked("Echo") and not moving then
            for i = 1, #br.friend do
                if not buff.echo.exists(br.friend[i].unit) and br.friend[i].hp <= br.getValue("Echo") then
                    if cast.echo(br.friend[i].unit) then
                        br.addonDebug("Casting Echo")
                        return true
                    end
                end
            end
        end
        -- Verdant Embrace
        if br.isChecked("Verdant Embrace") and lowest.hp <= br.getValue("Verdant Embrace" ) then
            if cast.verdantEmbrace(lowest.unit) then
                br.addonDebug("Casting Verdant Embrace")
                return true
            end
        end
         -- Spiritbloom
         if br.isChecked("Spiritbloom") and not moving then
            for i = 1, #br.friend do
                if br._G.UnitInRange(br.friend[i].unit) or br._G.UnitIsUnit(br.friend[i].unit, "player") then
                    local lowHealthCandidates = br.getUnitsToHealAround(br.friend[i].unit, 30,
                    br.getValue("Spiritbloom"), #br.friend)
                    if #lowHealthCandidates >= br.getValue("Spiritbloom Targets") then
                        if cast.spiritbloom(br.friend[i].unit) then
                            br.addonDebug("Casting Spiritbloom")
                            empoweredLevel = 4
                            return true
                        end
                    end
                end
            end
        end  
        if br.isChecked("Living Flame") and lowest.hp <= br.getValue("Living Flame") and not moving then
            if cast.livingFlame(lowest.unit) then
                br.addonDebug("Casting Living Flame")
                return true
            end
        end
    end

    -- Action List - DPS
    local function actionList_DPS() 
        if cd.fireBreath.remain() <= gcdMax and not moving and br.getEnemiesInCone(45,25) > 0 then
            if cast.fireBreath() then
                br.addonDebug("Casting Fire Breath")
                empoweredLevel = 1
                return true
            end
        end
        if (br.getEssence("player") >= 3 or buff.essenceBurst.exists("player")) and not moving then
            if cast.disintegrate() then
                br.addonDebug("Casting Disintegrate")
                return true
            end
        end
        if not moving then
            if cast.livingFlame() then
                br.addonDebug("Casting Living Flame")
                return true
            end
        end
        if moving then 
            if cast.azureStrike() then
                br.addonDebug("Casting Azure Strike")
                return true
            end
        end
    end -- End Action List - DPS

    if br.data.settings[br.selectedSpec][br.selectedProfile]["HE ActiveCheck"] == false and
        br.timer:useTimer("Error delay", 0.5) then
        br._G.print("Detecting Healing Engine is not turned on.  Please activate Healing Engine to use this profile.")
        return true
    end

    local function getEmpowerStage(unit)
        local stage = 0
        local _, _, _, startTime, _, _, _, _, _, totalStages = br._G.UnitChannelInfo(unit)
        if totalStages and totalStages > 0 then
            startTime = startTime / 1000 -- Doing this here so we don't divide by 1000 every loop index
            local currentTime = GetTime() -- If you really want to get time each loop, go for it. But the time difference will be miniscule for a single frame loop
            local stageDuration = 0
            for i = 1, totalStages do
                stageDuration = stageDuration + br._G.GetUnitEmpowerStageDuration(unit, i - 1) / 1000
                if startTime + stageDuration > currentTime then
                    break -- Break early so we don't keep checking, we haven't hit this stage yet
                end
                stage = i
            end
        end
        return stage
    end
    -----------------
    --- Rotations ---
    -----------------
    -- Pause
    if br.pause(true) or stealthed or drinking or cd.global.remains() > 0 then
        return true
    else
        if moving and empoweredLevel ~= 0 then
            empoweredLevel = 0;
        end
        local channel = UnitChannelInfo("player")
        if channel then
            if getEmpowerStage("player") >= empoweredLevel then
                br._G.CastSpellByName(channel)
                empoweredLevel = 0;
            end
        end
        ---------------------------------
        --- Out Of Combat - Rotations ---
        ---------------------------------
        if not inCombat and not channel then
            if actionList_Extras() then
                return true
            end
            if actionList_PreCombat() then
                return true
            end
            if actionList_Decurse() then
                return true
            end
            if br.isChecked("OOC Healing") then
                if actionList_AOEHealing() then
                    return true
                end
                if actionList_SingleTarget() then
                    return true
                end
            end
        end -- End Out of Combat Rotation
        -----------------------------
        --- In Combat - Rotations ---
        -----------------------------
        if inCombat then
            if not channel then
                if br.SpecificToggle("DPS Key") and not br._G.GetCurrentKeyBoardFocus() and br.isChecked("DPS Key") then
                    if actionList_DPS() then
                        return true
                    end
                else
                    if actionList_Defensive() then
                        return true
                    end
                    if actionList_Cooldowns() then
                        return true
                    end
                    if actionList_Interrupts() then
                        return true
                    end
                    if actionList_Decurse() then
                        return true
                    end
                    if actionList_AOEHealing() then
                        return true
                    end
                    if actionList_SingleTarget() then
                        return true
                    end
                    if not br.isChecked("DPS Key") and mode.dPS == 2 then
                        if not br.GetUnitExists("target") or
                            (br.GetUnitIsDeadOrGhost("target") and not br.GetUnitIsFriend("target")) and #enemies.yards40 ~=
                            0 and br.getOptionValue("Target Dynamic Target") then
                            br._G.TargetUnit(enemies.yards40[1])
                        end
                        if br.GetUnitExists("target") and not br.GetUnitIsFriend("target") then
                            if actionList_DPS() then
                                return true
                            end
                        end
                    end
                end
            end
        end -- End In Combat Rotation
    end -- Pause
    -- end -- End Timer
end -- End runRotation
local id = 1468
if br.rotations[id] == nil then
    br.rotations[id] = {}
end
br._G.tinsert(br.rotations[id], {
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation
})
