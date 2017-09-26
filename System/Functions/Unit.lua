function GetObjectExists(Unit)
	if Unit == nil then return false end
	if FireHack then
        if Unit == "target" or Unit == "targettarget" then
            if not GetUnitExists(Unit) then return false end
        end
		return ObjectExists(Unit)
	else
		return false
	end
end
function GetUnit(Unit)
	if Unit ~= nil and GetObjectExists(Unit) then
		if (EWT or Toolkit_GetVersion ~= nil) then
			return Unit
		elseif FireHack and not (EWT or Toolkit_GetVersion ~= nil) then
			return ObjectIdentifier(Unit)
		end
	end
	return nil
end
function GetUnitExists(Unit)
	if Unit == nil then return false end
	return UnitExists(Unit)
end
function GetUnitIsVisible(Unit)
	if Unit == nil then return false end
	return UnitIsVisible(Unit)
end
function GetObjectFacing(Unit)
    if FireHack and GetObjectExists(Unit) then
        return ObjectFacing(Unit)
    else
        return false
    end
end
function GetObjectPosition(Unit)
    if FireHack and GetObjectExists(Unit) then
        return ObjectPosition(Unit)
    else
        return 0, 0, 0
    end
end
function GetObjectType(Unit)
    if FireHack and GetObjectExists(Unit) then
        return ObjectTypes(Unit)
    else
        return 65561
    end
end
function GetObjectIndex(Index)
    if FireHack and GetObjectExists(GetObjectWithIndex(Index)) then
        return GetObjectWithIndex(Index)
    else
        return 0
    end
end
-- function GetObjectCountBR()
-- 	if FireHack then
--     	return GetObjectCount()
--     else
--     	return 0
--     end
-- end
function GetObjectID(Unit)
	if FireHack and GetObjectExists(Unit) then
		return ObjectID(Unit)
	else
		return 0
	end
end
--[[ OLD pcall functions
function GetObjectExists(Unit)
	if select(2,pcall(GetObjectExists,Unit)) == true then
		return true
	else
		return false
	end
end
function GetObjectFacing(Unit)
	if GetObjectExists(Unit) then
		return select(2,pcall(ObjectFacing,Unit))
	else
		return false
	end
end
function GetObjectPosition(Unit)
	if GetObjectExists(Unit) then
		return select(2,pcall(ObjectPosition,Unit))
	else
		return false
	end
end
function GetObjectType(Unit)
	if GetObjectExists(Unit) then
		return select(2,pcall(ObjectTypes,Unit))
	else
		return false
	end
end
function GetObjectIndex(Index)
	if GetObjectExists(select(2,pcall(GetObjectWithIndex,Index))) then
		return select(2,pcall(GetObjectWithIndex,Index))
	else
		return false
	end
end
function GetObjectCountBR()
	return select(2,pcall(GetObjectCount))
end
]]

function UnitIsTappedByPlayer(mob)
	-- if UnitTarget("player") and mob == UnitTarget("player") then return true end
	-- if UnitAffectingCombat(mob) and UnitTarget(mob) then
	--    	mobPlaceHolderOne = UnitTarget(mob)
	--    	mobPlaceHolderOne = UnitCreator(mobPlaceHolderOne) or mobPlaceHolderOne
	--    	if UnitInParty(mobPlaceHolderOne) then return true end
	-- end
	-- return false
	if UnitIsTapDenied(mob)==false then
		return true
	else
		return false
	end
end
function getSpellUnit(spellCast)
	local spellName,_,_,_,_,maxRange = GetSpellInfo(spellCast)
	local spellType = getSpellType(spellName)
	if maxRange == nil or maxRange == 0 then maxRange = 5 end
    if spellType == "Helpful" then
        thisUnit = "player"
    elseif spellType == "Harmful" or spellType == "Both" then  
        thisUnit = br.player.units(maxRange) 
    elseif spellType == "Unknown" and getDistance(br.player.units(maxRange)) < maxRange then
        if castSpell(br.player.units(maxRange),spellCast,false,false,false,false,false,false,false,true) then 
            thisUnit = br.player.units(maxRange)
        elseif castSpell("player",spellCast,false,false,false,false,false,false,false,true) then
            thisUnit = "player"
        end 
    end
    return thisUnit
end
-- if getCreatureType(Unit) == true then
function getCreatureType(Unit)
	local CreatureTypeList = {"Critter","Totem","Non-combat Pet","Wild Pet"}
	for i=1,#CreatureTypeList do
		if UnitCreatureType(Unit) == CreatureTypeList[i] then
			return false
		end
	end
	if not UnitIsBattlePet(Unit) and not UnitIsWildBattlePet(Unit) then
		return true
	else
		return false
	end
end
-- if getFacing("target","player") == false then
function getFacing(Unit1,Unit2,Degrees)
	if Degrees == nil then
		Degrees = 90
	end
	if Unit2 == nil then
		Unit2 = "player"
	end
	if GetObjectExists(Unit1) and GetUnitIsVisible(Unit1) and GetObjectExists(Unit2) and GetUnitIsVisible(Unit2) then
		local Angle1,Angle2,Angle3
		local Angle1 = GetObjectFacing(Unit1)
		local Angle2 = GetObjectFacing(Unit2)
		local Y1,X1,Z1 = GetObjectPosition(Unit1)
		local Y2,X2,Z2 = GetObjectPosition(Unit2)
		if Y1 and X1 and Z1 and Angle1 and Y2 and X2 and Z2 and Angle2 then
			local deltaY = Y2 - Y1
			local deltaX = X2 - X1
			Angle1 = math.deg(math.abs(Angle1-math.pi*2))
			if deltaX > 0 then
				Angle2 = math.deg(math.atan(deltaY/deltaX)+(math.pi/2)+math.pi)
			elseif deltaX <0 then
				Angle2 = math.deg(math.atan(deltaY/deltaX)+(math.pi/2))
			end
			if Angle2-Angle1 > 180 then
				Angle3 = math.abs(Angle2-Angle1-360)
			elseif Angle1-Angle2 > 180 then
				Angle3 = math.abs(Angle1-Angle2-360)
			else
				Angle3 = math.abs(Angle2-Angle1)
			end
			-- return Angle3
			if Angle3 < Degrees then
				return true
			else
				return false
			end
		end
	end
end
function getGUID(unit)
	local nShortHand = ""
	if GetObjectExists(unit) then
		if UnitIsPlayer(unit) then
			targetGUID = UnitGUID(unit)
			nShortHand = string.sub(UnitGUID(unit),-5)
		else
			targetGUID = string.match(UnitGUID(unit),"-(%d+)-%x+$")
			nShortHand = string.sub(UnitGUID(unit),-5)
		end
	end
	return targetGUID,nShortHand
end
-- if getHP("player") then
function getHP(Unit)
	if GetObjectExists(Unit) then
		if UnitIsEnemy("player", Unit) then
			return 100*UnitHealth(Unit)/UnitHealthMax(Unit)
		else
			if not UnitIsDeadOrGhost(Unit) and GetUnitIsVisible(Unit) then
				for i = 1,#br.friend do
					if br.friend[i].guidsh == string.sub(UnitGUID(Unit),-5) then
						return br.friend[i].hp
					end
				end
				if getOptionCheck("Incoming Heals") == true and UnitGetIncomingHeals(Unit,"player") ~= nil then
					return 100*(UnitHealth(Unit)+UnitGetIncomingHeals(Unit,"player"))/UnitHealthMax(Unit)
				else
					return 100*UnitHealth(Unit)/UnitHealthMax(Unit)
				end
			end
		end
	end
	return 0
end
-- if getHPLossPercent("player",5) then
function getHPLossPercent(unit,sec)
	local unit = unit
	local sec = sec
	local currentHP = getHP(unit)
	if unit == nil then unit = "player" end
	if sec == nil then sec = 1 end
	if snapHP == nil then snapHP = 0 end
	if br.timer:useTimer("Loss Percent", sec) then
		snapHP = currentHP
	end
	if snapHP < currentHP then
		return 0
	else
		return snapHP - currentHP
	end
end

-- if getBossID("boss1") == 71734 then
function getBossID(BossUnitID)
	return GetObjectID(BossUnitID)
end
function getUnitID(Unit)
	if GetObjectExists(Unit) and GetUnitIsVisible(Unit) then
		local id = select(6,strsplit("-", UnitGUID(Unit) or ""))
		return tonumber(id)
	end
	return 0
end
-- if isAlive([Unit]) == true then
function isAlive(Unit)
	local Unit = Unit or "player"
	if UnitIsDeadOrGhost(Unit) == false then
		return true
	end
end
function isInstanceBoss(unit)
	if IsInInstance() then
		local lockTimeleft, isPreviousInstance, encountersTotal, encountersComplete = GetInstanceLockTimeRemaining();
		for i=1,encountersTotal do
			if unit == "player" then
				local bossList = select(1,GetInstanceLockTimeRemainingEncounter(i))
				Print(bossList)
			end
			if GetObjectExists(unit) then
				local bossName = GetInstanceLockTimeRemainingEncounter(i)
				local targetName = UnitName(unit)
				-- Print("Target: "..targetName.." | Boss: "..bossName.." | Match: "..tostring(targetName == bossName))
				if targetName == bossName then return true end
			end
		end
		for i = 1, 5 do
			local bossNum = "boss"..i
			if UnitIsUnit(bossNum,unit) then return true end
		end
	end
	return false
end
-- isBoss()
function isBoss(unit)
	if unit==nil then unit="target" end
	if GetUnitExists(unit) then
		local npcID = string.match(UnitGUID(unit),"-(%d+)-%x+$")
		-- local bossCheck = LibStub("LibBossIDs-1.0").BossIDs[tonumber(npcID)] or false
		-- local bossCheck = br.player.BossIDs[tonumber(npcID)] or false
		local bossCheck = isInstanceBoss(unit)
		if ((UnitClassification(unit) == "rare" and UnitHealthMax(unit)>(4*UnitHealthMax("player")))
			or UnitClassification(unit) == "rareelite"
			or UnitClassification(unit) == "worldboss"
			or (UnitClassification(unit) == "elite" and UnitHealthMax(unit)>(4*UnitHealthMax("player")) and select(2,IsInInstance())~="raid")--UnitLevel(unit) >= UnitLevel("player")+3)
			or UnitLevel(unit) < 0)
				and not UnitIsTrivial(unit)
				and select(2,IsInInstance())~="party"
		then
			return true
		elseif bossCheck or isDummy(unit) then
			return true
		else
			return false
		end
	else
		return false
	end
end
function isCritter(Unit) -- From LibBabble
	if Unit == nil then Unit = "target" end
	local unitType = UnitCreatureType(Unit)
	return unitType == "Critter"
		or unitType == "Kleintier"
		or unitType == "Bestiole"
		or unitType == "동물"
		or unitType == "Alma"
		or unitType == "Bicho"
		or unitType == "Animale"
		or unitType == "Существо"
		or unitType == "小动物"
		or unitType == "小動物"
end
-- Dummy Check
function isDummy(Unit)
	if Unit == nil then
		Unit = "target"
	end
	if GetObjectExists(Unit) and UnitGUID(Unit) then
		local dummies = {
		-- Misc/Unknown
			[79987]  = "Training Dummy", 	          -- Location Unknown
			[92169]  = "Raider's Training Dummy",     -- Tanking (Eastern Plaguelands)
			[96442]  = "Training Dummy", 			  -- Damage (Location Unknown)
			[109595] = "Training Dummy",              -- Location Unknown
			[113963] = "Raider's Training Dummy", 	  -- Damage (Location Unknown)
		-- Level 1
			[17578]  = "Hellfire Training Dummy",     -- Lvl 1 (The Shattered Halls)
			[60197]  = "Training Dummy",              -- Lvl 1 (Scarlet Monastery)
			[64446]  = "Training Dummy",              -- Lvl 1 (Scarlet Monastery)
		-- Level 3
			[44171]  = "Training Dummy",              -- Lvl 3 (New Tinkertown, Dun Morogh)
			[44389]  = "Training Dummy",              -- Lvl 3 (Coldridge Valley)
			[44848]  = "Training Dummy", 			  -- Lvl 3 (Camp Narache, Mulgore)
			[44548]  = "Training Dummy",              -- Lvl 3 (Elwynn Forest)
			[44614]  = "Training Dummy",              -- Lvl 3 (Teldrassil, Shadowglen)
			[44703]  = "Training Dummy", 			  -- Lvl 3 (Ammen Vale)
			[44794]  = "Training Dummy", 			  -- Lvl 3 (Dethknell, Tirisfal Glades)
			[44820]  = "Training Dummy",              -- Lvl 3 (Valley of Trials, Durotar)
			[44937]  = "Training Dummy",              -- Lvl 3 (Eversong Woods, Sunstrider Isle)
			[48304]  = "Training Dummy",              -- Lvl 3 (Kezan)
		-- Level 55
			[32541]  = "Initiate's Training Dummy",   -- Lvl 55 (Plaguelands: The Scarlet Enclave)
			[32545]  = "Initiate's Training Dummy",   -- Lvl 55 (Eastern Plaguelands)
		-- Level 60
			[32666]  = "Training Dummy",              -- Lvl 60 (Siege of Orgrimmar, Darnassus, Ironforge, ...)
		-- Level 65
			[32542]  = "Disciple's Training Dummy",   -- Lvl 65 (Eastern Plaguelands)
		-- Level 70
			[32667]  = "Training Dummy",              -- Lvl 70 (Orgrimmar, Darnassus, Silvermoon City, ...)
		-- Level 75
			[32543]  = "Veteran's Training Dummy",    -- Lvl 75 (Eastern Plaguelands)
		-- Level 80
			[31144]  = "Training Dummy",              -- Lvl 80 (Orgrimmar, Darnassus, Ironforge, ...)
			[32546]  = "Ebon Knight's Training Dummy",-- Lvl 80 (Eastern Plaguelands)
		-- Level 85
			[46647]  = "Training Dummy",              -- Lvl 85 (Orgrimmar, Stormwind City)
		-- Level 90
			[67127]  = "Training Dummy",              -- Lvl 90 (Vale of Eternal Blossoms)
		-- Level 95
			[79414]  = "Training Dummy",              -- Lvl 95 (Broken Shore, Talador)
		-- Level 100
			[87317]  = "Training Dummy",              -- Lvl 100 (Lunarfall, Frostwall) - Damage
			[87321]  = "Training Dummy",              -- Lvl 100 (Stormshield) - Healing
			[87760]  = "Training Dummy",              -- Lvl 100 (Frostwall) - Damage
			[88289]  = "Training Dummy",              -- Lvl 100 (Frostwall) - Healing
			[88316]  = "Training Dummy",              -- Lvl 100 (Lunarfall) - Healing
			[88835]  = "Training Dummy",              -- Lvl 100 (Warspear) - Healing
			[88906]  = "Combat Dummy",                -- Lvl 100 (Nagrand)
			[88967]  = "Training Dummy",              -- Lvl 100 (Lunarfall, Frostwall)
			[89078]  = "Training Dummy",              -- Lvl 100 (Frostwall, Lunarfall)
		-- Levl 100 - 110
			[92164]  = "Training Dummy", 			  -- Lvl 100 - 110 (Dalaran) - Damage
			[92165]  = "Dungeoneer's Training Dummy", -- Lvl 100 - 110 (Eastern Plaguelands) - Damage
			[92167]  = "Training Dummy",              -- Lvl 100 - 110 (The Maelstrom, Eastern Plaguelands, The Wandering Isle)
			[92168]  = "Dungeoneer's Training Dummy", -- Lvl 100 - 110 (The Wandering Isles, Easter Plaguelands)
			[100440] = "Training Bag", 				  -- Lvl 100 - 110 (The Wandering Isles)
			[100441] = "Dungeoneer's Training Bag",   -- Lvl 100 - 110 (The Wandering Isles)
			[102045] = "Rebellious Wrathguard",       -- Lvl 100 - 110 (Dreadscar Rift) - Dungeoneer
			[102048] = "Rebellious Felguard",         -- Lvl 100 - 110 (Dreadscar Rift)
			[102052] = "Rebellious Imp", 			  -- Lvl 100 - 110 (Dreadscar Rift) - AoE
			[103402] = "Lesser Bulwark Construct",    -- Lvl 100 - 110 (Hall of the Guardian)
			[103404] = "Bulwark Construct",           -- Lvl 100 - 110 (Hall of the Guardian) - Dungeoneer
			[107483] = "Lesser Sparring Partner",     -- Lvl 100 - 110 (Skyhold)
			[107555] = "Bound Void Wraith",           -- Lvl 100 - 110 (Netherlight Temple)
			[107557] = "Training Dummy",              -- Lvl 100 - 110 (Netherlight Temple) - Healing
			[108420] = "Training Dummy",              -- Lvl 100 - 110 (Stormwind City, Durotar)
			[111824] = "Training Dummy", 			  -- Lvl 100 - 110 (Azsuna)
			[113674] = "Imprisoned Centurion",        -- Lvl 100 - 110 (Mardum, the Shattered Abyss) - Dungeoneer
			[113676] = "Imprisoned Weaver", 	      -- Lvl 100 - 110 (Mardum, the Shattered Abyss)
			[113687] = "Imprisoned Imp",              -- Lvl 100 - 110 (Mardum, the Shattered Abyss) - Swarm
			[113858] = "Training Dummy",              -- Lvl 100 - 110 (Trueshot Lodge) - Damage
			[113859] = "Dungeoneer's Training Dummy", -- Lvl 100 - 110 (Trueshot Lodge) - Damage
			[113862] = "Training Dummy",              -- Lvl 100 - 110 (Trueshot Lodge) - Damage
			[113863] = "Dungeoneer's Training Dummy", -- Lvl 100 - 110 (Trueshot Lodge) - Damage
			[113871] = "Bombardier's Training Dummy", -- Lvl 100 - 110 (Trueshot Lodge) - Damage
			[113966] = "Dungeoneer's Training Dummy", -- Lvl 100 - 110 - Damage
			[113967] = "Training Dummy",              -- Lvl 100 - 110 (The Dreamgrove) - Healing
			[114832] = "PvP Training Dummy",          -- Lvl 100 - 110 (Stormwind City)
			[114840] = "PvP Training Dummy",          -- Lvl 100 - 110 (Orgrimmar)
		-- Level 102
			[87318]  = "Dungeoneer's Training Dummy", -- Lvl 102 (Lunarfall) - Damage
			[87322]  = "Dungeoneer's Training Dummy", -- Lvl 102 (Stormshield) - Tank
			[87761]  = "Dungeoneer's Training Dummy", -- Lvl 102 (Frostwall) - Damage
			[88288]  = "Dungeoneer's Training Dummy", -- Lvl 102 (Frostwall) - Tank
			[88314]  = "Dungeoneer's Training Dummy", -- Lvl 102 (Lunarfall) - Tank
			[88836]  = "Dungeoneer's Training Dummy", -- Lvl 102 (Warspear) - Tank
			[93828]  = "Training Dummy",              -- Lvl 102 (Hellfire Citadel)
			[97668]  = "Boxer's Trianing Dummy",      -- Lvl 102 (Highmountain)
			[98581]  = "Prepfoot Training Dummy",     -- Lvl 102 (Highmountain)
		-- Level ??
			[24792]  = "Advanced Training Dummy",     -- Lvl ?? Boss (Location Unknonw)
			[30527]  = "Training Dummy", 		      -- Lvl ?? Boss (Location Unknonw)
			[31146]  = "Raider's Training Dummy",     -- Lvl ?? (Orgrimmar, Stormwind City, Ironforge, ...)
			[87320]  = "Raider's Training Dummy",     -- Lvl ?? (Lunarfall, Stormshield) - Damage
			[87329]  = "Raider's Training Dummy",     -- Lvl ?? (Stormshield) - Tank
			[87762]  = "Raider's Training Dummy",     -- Lvl ?? (Frostwall, Warspear) - Damage
			[88837]  = "Raider's Training Dummy",     -- Lvl ?? (Warspear) - Tank
			[92166]  = "Raider's Training Dummy",     -- Lvl ?? (The Maelstrom, Dalaran, Eastern Plaguelands, ...) - Damage
			[101956] = "Rebellious Fel Lord",         -- lvl ?? (Dreadscar Rift) - Raider
			[103397] = "Greater Bulwark Construct",   -- Lvl ?? (Hall of the Guardian) - Raider
			[107202] = "Reanimated Monstrosity", 	  -- Lvl ?? (Broken Shore) - Raider
			[107484] = "Greater Sparring Partner",    -- Lvl ?? (Skyhold)
			[107556] = "Bound Void Walker",           -- Lvl ?? (Netherlight Temple) - Raider
			[113636] = "Imprisoned Forgefiend",       -- Lvl ?? (Mardum, the Shattered Abyss) - Raider
			[113860] = "Raider's Training Dummy",     -- Lvl ?? (Trueshot Lodge) - Damage
			[113864] = "Raider's Training Dummy",     -- Lvl ?? (Trueshot Lodge) - Damage
			[70245]  = "Training Dummy",              -- Lvl ?? (Throne of Thunder)
			[113964] = "Raider's Training Dummy",     -- Lvl ?? (The Dreamgrove) - Tanking
		}
		if dummies[tonumber(string.match(UnitGUID(Unit),"-(%d+)-%x+$"))] then --~= nil 
			return true
		end
	end
end
-- if isEnnemy([Unit])
function isEnnemy(Unit)
	local Unit = Unit or "target"
	if UnitCanAttack(Unit,"player") then
		return true
	else
		return false
	end
end