-- Icy veins: http://www.icy-veins.com/wow/holy-paladin-pve-healing-guide
-- SimC
-- # Executed before combat begins. Accepts non-harmful actions only.

-- actions.precombat+=/blessing_of_kings,if=(!aura.str_agi_int.up)&(aura.mastery.up)
-- actions.precombat+=/blessing_of_might,if=!aura.mastery.up
-- actions.precombat+=/seal_of_insight
-- actions.precombat+=/beacon_of_light,target=healing_target

-- # Executed every time the actor is available.

-- actions+=/blood_fury
-- actions+=/berserking
-- actions+=/arcane_torrent

-- actions=mana_potion,if=mana.pct<=75
-- actions+=/auto_attack
-- actions+=/lay_on_hands,if=incoming_damage_5s>health.max*0.7
-- actions+=/judgment,if=talent.selfless_healer.enabled&buff.selfless_healer.stack<3
-- actions+=/word_of_glory,if=holy_power>=3
-- actions+=/wait,if=target.health.pct>=75&mana.pct<=10
-- actions+=/holy_shock,if=holy_power<=3
-- actions+=/flash_of_light,if=target.health.pct<=30
-- actions+=/judgment,if=holy_power<3
-- actions+=/lay_on_hands,if=mana.pct<5
-- actions+=/holy_light






-- holy prism
-- in order to get the best results out of our holy prism for holy, we will need to calc best scenario of
-- 5 users in 15 yards around a given units that have the lowest hp

-- will first need to target a enemy unit then
-- compare health to user selected threshold
-- test its position agains mobs position and calc range(we need to find a way to refresh that only once per cast or something)
-- add it to a table of valid units around a mob
-- calc the table best results coefficients
-- if it beat previous best table then we keep that new one
-- table will look like
--	prismBestTable = {
--		coefficient = wise maths to find best case,
--		heavilyDamagedUnits = number of units under 30% hp,
--		missingHealthUnits = number of units under threshold,
--		totalmissingHealth = total health missing in range of unit,
--		unit = enemyFH tag
--	}
-- function will need to find positions trought crossing x-y so we need to gather units positions
-- we can get enemy position in bb.enemy and the players positions trought bb.friend


--[[On GCD Out of Combat]]


-- blessing_of_kings,if=(!aura.str_agi_int.up)&(aura.mastery.up)
-- blessing_of_might,if=!aura.mastery.up
-- seal_of_insight
-- beacon_of_light,target=healing_target
--[[Beacon Of Light]]

-- snapshot_stats

if select(3, UnitClass("player")) == 2 then
  function PaladinHoly()
    -- Init Holy specific funnctions, toggles and configs.
    if currentConfig ~= "Holy Gabbz & CML" then
      PaladinHolyFunctions()
      PaladinHolyToggles()
      PaladinHolyOptions()
      currentConfig = "Holy Gabbz & CML"
    end

    -- Locals Variables
    _HolyPower = UnitPower("player", 9)

    -- We should start with analysing who to heal so we know what todo later
    --	We should get all tanks and have them
    -- 	Then lowest non tank
    -- 	Then best AoE Heal candidate, for each possible spell we have, Light Of Dawn, Holy Radiance and Holy Shock with Daybreak.
    -- 	Then we need to see who we have beaconed
    --	Then we need to get dispell targets.

    -- 	We should calcualte best healing options and considere mana levels
    -- What different healing roles can we have
    --	Tank healer, beacon on both tanks and heal them or if they are above 90 heal lowest raid unit.
    --		When tanks are getting lower then we switch to heal them
    -- How do we handle beacons, so if we have light and faith, if one of them are full health and we are healing a non tank?
    -- If we switch beacon it cost 1K mana but we heal for 50%
    -- We start with tank healing, ie beacon on both tanks, heal raid if tanks are above a configured value in options, if below start focusing on tanks.
    --[[Lowest]]

    lowestHP, lowestUnit, lowestTankHP, lowestTankUnit, highestTankHP, highestTankUnit, averageHealth = 100, "player", 100, "player", 100, "player", 0

    for i = 1, #bb.friend do
      if bb.friend[i].role == "TANK" then
        if bb.friend[i].hp < lowestTankHP then
          lowestTankHP = bb.friend[i].hp
          lowestTankUnit = bb.friend[i].unit
        end
      end
      if bb.friend[i].hp < lowestHP then
        lowestHP = bb.friend[i].hp
        lowestUnit = bb.friend[i].unit
      end
      averageHealth = averageHealth + bb.friend[i].hp
    end
    averageHealth = averageHealth/#bb.friend

    --iterate one more time to get highest hp tank
    for i = 1, #bb.friend do
      if bb.friend[i].role == "TANK" then
        if bb.friend[i].unit ~= lowestTankUnit then
          highestTankHP = bb.friend[i].hp
          highestTankUnit = bb.friend[i].unit
        end
      end
    end

    --[[Set Main Healing Tank]]
    if IsLeftAltKeyDown() then -- Set focus, ie primary healing target with left alt and mouseover target
      if UnitIsFriend("player","mouseover") and not UnitIsDeadOrGhost("mouseover") then
        RunMacroText("/focus mouseover")
    end
    end
    local favoriteTank = { name = "NONE" , health = 0}
    if UnitIsDeadOrGhost("focus") then
      if favoriteTank.name ~= "NONE" then
        favoriteTank = { name = "NONE" , health = 0}
        ClearFocus()
      end
    end
    if UnitExists("focus") == nil and favoriteTank.name == "NONE" then
      for i = 1, # bb.friend do
        if UnitIsDeadOrGhost("focus") == nil and bb.friend[i].role == "TANK" and UnitHealthMax(bb.friend[i].unit) > favoriteTank.health then
          favoriteTank = { name = UnitName(bb.friend[i].unit), health = UnitHealthMax(bb.friend[i].unit) }
          RunMacroText("/focus "..favoriteTank.name)
        end
      end
    end

    -- Food/Invis Check   Hm here we are checking if we should abort the rotation pulse due to if we are a vehicle or some stuff
    if canRun() ~= true or UnitInVehicle("Player") then
      return false
    end

    if IsLeftShiftKeyDown() then -- Pause the script, keybind in wow shift+1 etc for manual cast
      return true
    end

    --[[Off GCD in combat]]
    if UnitAffectingCombat("player") or IsLeftControlKeyDown() then -- Only heal if we are in combat or if left control is down for out of combat rotation
      if castingUnit() then -- Do not interrupt if we are already casting
        return false
    end

    if BeaconOfLight() then 	-- Set Beacon of Light and faith on correct target
      return true
    end

    if not UnitAffectingCombat("player") then
      if preCombatHandlingHoly() then
        return true
      end
    end

    if castDispell() then
      return true
    end

    --[[Auto Attack if in melee]]
    if isInMelee() and getFacing("player","target") == true then
      RunMacroText("/startattack")
    end

    --Todo: Layon hands is just values, we need to add logic regarding who
    if castLayOnHands() then
      return true
    end

    --if unit is critical low
    --	Holy Light if we have Infusion of Light buff
    --	Holy Shock on CD
    --	Flash of Light and do a beacon switch?
    -- Todo: Need to set this in options
    if lowestTankHP < getValue("Critical Health Level") or lowestHP < getValue("Critical Health Level") then
      if UnitBuffID("player",_InfusionOfLight) then
        if castHolyLight(40) then
          return true
        end
      end
      if canCast(_HolyShock) then
        if castHolyShock(nil, 40) then
          return true
        end
      end
      if castFlashOfLight(nil, 40) then
        return true
      end
    end

    if castHolyPrism(nil) then
      return true
    end

    -- AoE healing
    if castAoEHeals() then
      return true
    end

    --[[holy_shock,if=holy_power<=3]] -- Should add not cast if 5 HoPo
    if getOptionCheck("Holy Shock") and _HolyPower < 5 and castHolyShock(nil, getValue("Holy Shock"))  then
      return true
    end

    --Todo Need to add a check if we have 5 then use it
    if getOptionCheck("Eternal Flame") and castEternalFlame(getValue("Eternal Flame")) then
      return true
    end

    --[[flash_of_light,if=target.health.pct<=30]]
    if isChecked("Flash Of Light") and castFlashOfLight(nil, getValue("Flash Of Light")) then
      return true
    end

    if getOptionCheck("Holy Prism") and HolyPrism(getValue("Holy Prism")) then
      return true
    end

    if getOptionCheck("Holy Light") and castHolyLight(getValue("Holy Light")) then
      return true
    end
    -- Crusader strik for HoPo
    end
  end
end
