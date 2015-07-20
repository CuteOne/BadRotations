function GetObjectExists(Unit)
	if select(2,pcall(ObjectExists,Unit)) == true then
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
		return select(2,pcall(ObjectType,Unit))
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
function GetObjectCountBB()
	return select(2,pcall(GetObjectCount))
end

function castInterrupt(SpellID,Percent,Unit)
if Unit == nil then Unit = "target" end
	if GetObjectExists(Unit) then
		local castName, _, _, _, castStartTime, castEndTime, _, _, castInterruptable = UnitCastingInfo(Unit)
		local channelName, _, _, _, channelStartTime, channelEndTime, _, channelInterruptable = UnitChannelInfo(Unit)
		-- first make sure we will be able to cast the spell
		if canCast(SpellID,false,false) == true then
			-- make sure we cover melee range
			local allowedDistance = select(6,GetSpellInfo(SpellID))
			if allowedDistance < 5 then
				allowedDistance = 5
			end
			--check for cast
			if channelName ~= nil then
				--target is channeling a spell that is interruptable
				--load the channel variables into the cast variables to make logic a little easier.
				castName = channelName
				castStartTime = channelStartTime
				castEndTime = channelEndTime
				castInterruptable = channelInterruptable
			end
			--This is actually Not Interruptable... so lets swap it around to use in the positive.
			if castInterruptable == false then
				castInterruptable = true
			else
				castInterruptable = false
			end
			--we can't attack the target.
			if UnitCanAttack("player",Unit) == nil then
				return false
			end
			if castInterruptable then
				--target is casting something that is interruptable.
				--the following 2 variables are named logically... value is in seconds.
				local timeSinceStart = (GetTime() * 1000 - castStartTime) / 1000
				local timeLeft = ((GetTime() * 1000 - castEndTime) * -1) / 1000
				local castTime = castEndTime - castStartTime
				local currentPercent = timeSinceStart / castTime * 100000
				--interrupt percentage check
				if currentPercent >= Percent then
					return false
				end
				--cast the spell
				if getDistance("player",Unit) < allowedDistance then
					if castSpell(Unit,SpellID,false,false) then
						return true
					end
				end
			end
		end
	end
	return false
end

function IGetLocation(Unit)
	return GetObjectPosition(Unit)
end
function UnitBuffID(unit,spellID,filter)
	local spellName = GetSpellInfo(spellID)
	if filter == nil then
		return UnitBuff(unit,spellName)
	else
		local exactSearch = strfind(strupper(filter),"EXACT")
		local playerSearch = strfind(strupper(filter),"PLAYER")
		if exactSearch then
			for i=1,40 do
				local _,_,_,_,_,_,_,buffCaster,_,_,buffSpellID = UnitBuff(unit,i)
				if buffSpellID ~= nil then
					if buffSpellID == spellID then
						if (not playerSearch) or (playerSearch and (buffCaster == "player")) then
							return UnitBuff(unit,i)
						end
					end
				else
					return nil
				end
			end
		else
			return UnitBuff(unit,spellName,nil,filter)
		end
	end
end
function UnitDebuffID(unit,spellID,filter)
	local spellName = GetSpellInfo(spellID)
	if filter == nil then
		return UnitDebuff(unit,spellName)
	else
		local exactSearch = strfind(strupper(filter),"EXACT")
		local playerSearch = strfind(strupper(filter),"PLAYER")
		if exactSearch then
			for i=1,40 do
				local _,_,_,_,_,_,_,buffCaster,_,_,buffSpellID = UnitDebuff(unit,i)
				if buffSpellID ~= nil then
					if buffSpellID == spellID then
						if (not playerSearch) or (playerSearch and (buffCaster == "player")) then
							return UnitDebuff(unit,i)
						end
					end
				else
					return nil
				end
			end
		else
			return UnitDebuff(unit,spellName,nil,filter)
		end
	end
end
-- if canAttack("player","target") then
function canAttack(Unit1,Unit2)
	if Unit1 == nil then
		Unit1 = "player"
	end
	if Unit2 == nil then
		Unit2 = "target"
	end
	return UnitCanAttack(Unit1,Unit2)
end
-- if canCast(12345,true)
function canCast(SpellID,KnownSkip,MovementCheck)
	local myCooldown = getSpellCD(SpellID) or 0
	local lagTolerance = getValue("Lag Tolerance") or 0
	if (KnownSkip == true or isKnown(SpellID)) and IsUsableSpell(SpellID) and myCooldown < 0.1
		and (MovementCheck == false or myCooldown == 0 or isMoving("player") ~= true or UnitBuffID("player",79206) ~= nil) then
		return true
	end
end
function canDisarm(Unit)
	if DisarmedTarget == nil then DisarmedTarget = 0 end
	if isDisarmed == true then
		if UnitExists(Unit) and UnitGUID(Unit)~=DisarmedTarget then
			DisarmedTarget = UnitGUID(Unit)
			return false
		else
			isDisarmed = false
			return true
		end
	end
	if not isInCombat("player") or UnitExists(Unit) then
		if not isInCombat("player") or UnitGUID(Unit)~=DisarmedTarget then
			isDisarmed = false
			return true
		end
	end
end
-- if canDispel("target",SpellID) == true then
function canDispel(Unit,spellID)
	local HasValidDispel = false
	local ClassNum = select(3,UnitClass("player"))
	if ClassNum == 1 then --Warrior
		typesList = { }
	end
	if ClassNum == 2 then --Paladin
		typesList = { }
	end
	if ClassNum == 3 then --Hunter
		typesList = { }
	end
	if ClassNum == 4 then --Rogue
		-- Cloak of Shadows
		if spellID == 31224 then typesList = { "Poison","Curse","Disease","Magic" } end
	end
	if ClassNum == 5 then --Priest
		typesList = { }
	end
	if ClassNum == 6 then --Death Knight
		typesList = { }
	end
	if ClassNum == 7 then --Shaman
		if spellID == 51886 then typesList = { "Curse" } end -- Cleanse Spirit
	end
	if ClassNum == 8 then --Mage
		typesList = { }
	end
	if ClassNum == 9 then --Warlock
		typesList = { }
	end
	if ClassNum == 10 then --Monk
		-- Detox
		if spellID == 115450 then typesList = { "Poison","Disease" } end
		-- Diffuse Magic
		if spellID == 122783 then typesList = { "Magic" } end
	end
	if ClassNum == 11 then --Druid
		-- Remove Corruption
		if spellID == 2782 then typesList = { "Poison","Curse" } end
		-- Nature's Cure
		if spellID == 88423 then typesList = { "Poison","Curse","Magic" } end
		-- Symbiosis: Cleanse
		if spellID == 122288 then typesList = { "Poison","Disease" } end
	end
	local function ValidType(debuffType)
		if typesList == nil then
			return false
		else
			for i = 1,#typesList do
				if typesList[i] == debuffType then
					return true
				else
					return false
				end
			end
		end
	end
	local ValidDebuffType = false
	local i = 1
	while UnitDebuff(Unit,i) do
		local _,_,_,_,debuffType,_,_,_,_,_,debuffid = UnitDebuff(Unit,i)
		-- Blackout Debuffs
		if debuffType and ValidType(debuffType)
			and debuffid ~= 138732 --Ionization from Jin'rokh the Breaker - ptr
			and debuffid ~= 138733 --Ionization from Jin'rokh the Breaker - live
		then
			HasValidDispel = true
			break
		end
		i = i + 1
	end
	return HasValidDispel
end
-- if canHeal("target") then
function canHeal(Unit)
	if UnitExists(Unit) and UnitInRange(Unit) == true and UnitCanCooperate("player",Unit)
		and not UnitIsEnemy("player",Unit) and not UnitIsCharmed(Unit) and not UnitIsDeadOrGhost(Unit)
		and getLineOfSight(Unit) == true and not UnitDebuffID(Unit,33786) then
		return true
	end
	return false
end
-- canInterrupt("target",20)
function canInterrupt(unit,percentint)
	local unit = unit or "target"
	local castDuration = 0
	local castTimeRemain = 0
	local castPercent = 0 -- Possible to set hard coded value
	local channelDelay = 0.4 -- Delay to mimick human reaction time for channeled spells
	local interruptable = false
	local castType = "spellcast" -- Handle difference in logic if the spell is cast or being channeles
	if UnitExists(unit)
		and UnitCanAttack("player",unit)
		and not UnitIsDeadOrGhost(unit)
	then
		if select(6,UnitCastingInfo(unit)) and not select(9,UnitCastingInfo(unit)) then --Get spell cast time
			castStartTime = select(5,UnitCastingInfo(unit))
			castEndTime = select(6,UnitCastingInfo(unit))
			interruptable = true
			castType = "spellcast"
		elseif select(6,UnitChannelInfo(unit)) and select(8,UnitChannelInfo(unit)) then -- Get spell channel time
			castStartTime = select(5,UnitChannelInfo(unit))
			castEndTime = select(6,UnitChannelInfo(unit))
			interruptable = true
			castType = "spellchannel"
		else
			castStartTime = 0
			castEndTime = 0
			interruptable = false
		end
		if castEndTime > 0 and castStartTime > 0 then
			castDuration = (castEndTime - castStartTime)/1000
			castTimeRemain = ((castEndTime/1000) - GetTime())
			if percentint == nil and castPercent == 0 then
				castPercent = math.random(75,95) --  I am not sure that this is working,we are doing this check every pulse so its different randoms each time
			elseif percentint == 0 and castPercent == 0 then
				castPercent = math.random(75,95)
			elseif percentint > 0 then
				castPercent = percentint
			end
		else
			castDuration = 0
			castTimeRemain = 0
			castPercent = 0
		end
		if castType == "spellcast" then
			if math.ceil((castTimeRemain/castDuration)*100) <= castPercent and interruptable == true then
				return true
			end
		end
		if castType == "spellchannel" then
			if (GetTime() - castStartTime/1000) > channelDelay and interruptable == true then
				return true
			end
		end
		return false
	end
end
-- if canPrepare() then
function canPrepare()
	if UnitBuffID("player",104934) -- Eating (Feast)
		or UnitBuffID("player",80169) -- Eating
		or UnitBuffID("player",87959) -- Drinking
		or UnitBuffID("player",11392) -- 18 sec Invis Pot
		or UnitBuffID("player",3680) -- 15 sec Invis pot
		or UnitBuffID("player",5384) -- Feign Death
		or IsMounted() then
		return false
	else
		return true
	end
end
-- if canRun() then
function canRun()
	if getOptionCheck("Pause") ~= 1 then
		if getOptionCheck("Start/Stop BadBoy") and isAlive("player") then
			if SpellIsTargeting()
				--or UnitInVehicle("Player")
				or (IsMounted() and getUnitID("target") ~= 56877 and not UnitBuffID("player",164222) and not UnitBuffID("player",165803) and not UnitBuffID("player",157059) and not UnitBuffID("player",157060))
				or UnitBuffID("player",11392) ~= nil
				or UnitBuffID("player",80169) ~= nil
				or UnitBuffID("player",87959) ~= nil
				or UnitBuffID("player",104934) ~= nil
				or UnitBuffID("player",9265) ~= nil then -- Deep Sleep(SM)
				return nil
			else
				return true
			end
		end
	else
		ChatOverlay("|cffFF0000-BadBoy Paused-")
		return false
	end
end
-- if canUse(1710) then
function canUse(itemID)
	if hasHealthPot() then Pot = healPot; else Pot = 0 end
	local goOn = true
	local DPSPotionsSet = {
		[1] = {Buff = 105702, Item = 76093}, -- Int
		[2] = {Buff = 156423, Item = 109217}, -- Agi - Draenor
		[3] = {Buff = 105706, Item = 76095}, -- Str
		[4] = {Buff = nil,    Item = 5512}, --Healthstone
		[5] = {Buff = nil,    Item = Pot}, --Healing Pot
	}
	for i = 1, #DPSPotionsSet do
		if DPSPotionsSet[i].Item == itemID then
			if potionUsed then
				if potionUsed <= GetTime() - 60000 then
					goOn = false
				else
					if potionUsed > GetTime() - 60000 and potionReuse == true then
						goOn = true
					end
					if potionReuse == false then
						goOn = false
					end
				end
			end
		end
	end
	if goOn == true and GetItemCount(itemID,false,false) > 0 then
		if select(2,GetItemCooldown(itemID))==0 then
			return true
		else
			return false
		end
	else
		return false
	end
end
-- if canTrinket(13) then
function canTrinket(trinketSlot)
	if trinketSlot == 13 or trinketSlot == 14 then
		if trinketSlot == 13 and GetInventoryItemCooldown("player",13)==0 then
			return true
		end
		if trinketSlot == 14 and GetInventoryItemCooldown("player",14)==0 then
			return true
		end
	else
		return false
	end
end
function castAoEHeal(spellID,numUnits,missingHP,rangeValue)
	-- i start an iteration that i use to build each units Table,which i will reuse for the next second
	if not holyRadianceRangeTable or not holyRadianceRangeTableTimer or holyRadianceRangeTable <= GetTime() - 1 then
		holyRadianceRangeTable = { }
		for i = 1,#nNova do
			-- i declare a sub-table for this unit if it dont exists
			if nNova[i].distanceTable == nil then nNova[i].distanceTable = { } end
			-- i start a second iteration where i scan unit ranges from one another.
			for j = 1,#nNova do
				-- i make sure i dont compute unit range to hisself.
				if not UnitIsUnit(nNova[i].unit,nNova[j].unit) then
					-- table the units
					nNova[i].distanceTable[j] = { distance = getDistance(nNova[i].unit,nNova[j].unit),unit = nNova[j].unit,hp = nNova[j].hp }
				end
			end
		end
	end
	-- declare locals that will hold number
	local bestTarget,bestTargetUnits = 1,1
	-- now that nova range is built,i can iterate it
	local inRange,missingHealth,mostMissingHealth = 0,0,0
	for i = 1,#nNova do
		if nNova[i].distanceTable ~= nil then
			-- i count units in range
			for j = 1,#nNova do
				if nNova[i].distanceTable[j] and nNova[i].distanceTable[j].distance < rangeValue then
					inRange = inRange + 1
					missingHealth = missingHealth + (100 - nNova[i].distanceTable[j].hp)
				end
			end
			nNova[i].inRangeForHolyRadiance = inRange
			-- i check if this is going to be the best unit for my spell
			if missingHealth > mostMissingHealth then
				bestTarget,bestTargetUnits,mostMissingHealth = i,inRange,missingHealth
			end
		end
	end
	if bestTargetUnits and bestTargetUnits > 3 and mostMissingHealth and missingHP and mostMissingHealth > missingHP then
		if castSpell(nNova[bestTarget].unit,spellID,true,true) then return true end
	end
end
-- castGround("target",12345,40)
function castGround(Unit,SpellID,maxDistance)
	if UnitExists(Unit) and getSpellCD(SpellID) == 0 and getLineOfSight("player",Unit)
		and getDistance("player",Unit) <= maxDistance then
		CastSpellByName(GetSpellInfo(SpellID),"player")
		if IsAoEPending() then
			--local distanceToGround = getGroundDistance(Unit) or 0
			local X,Y,Z = GetObjectPosition(Unit)
			ClickPosition(X,Y,Z,true) --distanceToGround
			return true
		end
	end
	return false
end
-- castGroundBetween("target",12345,40)
function castGroundBetween(Unit,SpellID,maxDistance)
	if UnitExists(Unit) and getSpellCD(SpellID) <= 0.4 and getLineOfSight("player",Unit) and getDistance("player",Unit) <= maxDistance then
		CastSpellByName(GetSpellInfo(SpellID),"player")
		if IsAoEPending() then
			local X,Y,Z = GetObjectPosition(Unit)
			ClickPosition(X,Y,Z,true)
			return true
		end
	end
	return false
end
-- if shouldNotOverheal(spellCastTarget) > 80 then
function shouldNotOverheal(Unit)
	local myIncomingHeal,allIncomingHeal = 0,0
	if UnitGetIncomingHeals(Unit,"player") ~= nil then myIncomingHeal = UnitGetIncomingHeals(Unit,"player") end
	if UnitGetIncomingHeals(Unit) ~= nil then allIncomingHeal = UnitGetIncomingHeals(Unit) end
	local allIncomingHeal = UnitGetIncomingHeals(Unit) or 0
	local overheal = 0
	if myIncomingHeal >= allIncomingHeal then
		overheal = myIncomingHeal
	else
		overheal = allIncomingHeal
	end
	local CurShield = UnitHealth(Unit)
	if UnitDebuffID("player",142861) then --Ancient Miasma
		CurShield = select(15,UnitDebuffID(Unit,142863)) or select(15,UnitDebuffID(Unit,142864)) or select(15,UnitDebuffID(Unit,142865)) or (UnitHealthMax(Unit) / 2)
		overheal = 0
	end
	local overhealth = 100 * (CurShield+ overheal ) / UnitHealthMax(Unit)
	if overhealth and overheal then
		return overhealth,overheal
	else
		return 0,0
	end
end
-- if castHealGround(_HealingRain,18,80,3) then
function castHealGround(SpellID,Radius,Health,NumberOfPlayers)
	if shouldStopCasting(SpellID) ~= true then
		local lowHPTargets,foundTargets = { },{ }
		for i = 1,#nNova do
			if nNova[i].hp <= Health then
				if UnitIsVisible(nNova[i].unit) and GetObjectExists(nNova[i].unit) then
					local X,Y,Z = GetObjectPosition(nNova[i].unit)
					tinsert(lowHPTargets,{ unit = nNova[i].unit,x = X,y = Y,z = Z })
				end end end
		if #lowHPTargets >= NumberOfPlayers then
			for i = 1,#lowHPTargets do
				for j = 1,#lowHPTargets do
					if lowHPTargets[i].unit ~= lowHPTargets[j].unit then
						if math.sqrt(((lowHPTargets[j].x-lowHPTargets[i].x)^2)+((lowHPTargets[j].y-lowHPTargets[i].y)^2)) < Radius then
							for k = 1,#lowHPTargets do
								if lowHPTargets[i].unit ~= lowHPTargets[k].unit and lowHPTargets[j].unit ~= lowHPTargets[k].unit then
									if math.sqrt(((lowHPTargets[k].x-lowHPTargets[i].x)^2)+((lowHPTargets[k].y-lowHPTargets[i].y)^2)) < Radius and math.sqrt(((lowHPTargets[k].x-lowHPTargets[j].x)^2)+((lowHPTargets[k].y-lowHPTargets[j].y)^2)) < Radius then
										tinsert(foundTargets,{ unit = lowHPTargets[i].unit,x = lowHPTargets[i].x,y = lowHPTargets[i].y,z = lowHPTargets[i].z })
										tinsert(foundTargets,{ unit = lowHPTargets[j].unit,x = lowHPTargets[j].x,y = lowHPTargets[j].y,z = lowHPTargets[i].z })
										tinsert(foundTargets,{ unit = lowHPTargets[k].unit,x = lowHPTargets[k].x,y = lowHPTargets[k].y,z = lowHPTargets[i].z })
									end end end end end end end
			local medX,medY,medZ = 0,0,0
			if foundTargets ~= nil and #foundTargets >= NumberOfPlayers then
				for i = 1,3 do
					medX = medX + foundTargets[i].x
					medY = medY + foundTargets[i].y
					medZ = medZ + foundTargets[i].z
				end
				medX,medY,medZ = medX/3,medY/3,medZ/3
				local myX,myY = GetObjectPosition("player")
				if math.sqrt(((medX-myX)^2)+((medY-myY)^2)) < 40 then
					CastSpellByName(GetSpellInfo(SpellID),"player")
					if IsAoEPending() then
						ClickPosition(medX,medY,medZ,true)
						if SpellID == 145205 then shroomsTable[1] = { x = medX,y = medY,z = medZ} end
						return true
					end end end end end
	return false
end
-- getLatency()
function getLatency()
	local lag = ((select(3,GetNetStats()) + select(4,GetNetStats())) / 1000)
	if lag < .05 then
		lag = .05
	elseif lag > .4 then
		lag = .4
	end
	return lag
end
--[[castSpell(Unit,SpellID,FacingCheck,MovementCheck,SpamAllowed,KnownSkip)
Parameter 	Value
First 	 	UnitID 			Enter valid UnitID
Second 		SpellID 		Enter ID of spell to use
Third 		Facing 			True to allow 360 degrees,false to use facing check
Fourth 		MovementCheck	True to make sure player is standing to cast,false to allow cast while moving
Fifth 		SpamAllowed 	True to skip that check,false to prevent spells that we dont want to spam from beign recast for 1 second
Sixth 		KnownSkip 		True to skip isKnown check for some spells that are not managed correctly in wow's spell book.
]]
-- castSpell("target",12345,true)
--                ( 1  ,    2  ,     3     ,     4       ,      5    ,   6     ,   7     ,    8       ,   9    )
function castSpell(Unit,SpellID,FacingCheck,MovementCheck,SpamAllowed,KnownSkip,DeadCheck,DistanceSkip,usableSkip)
	if GetObjectExists(Unit) and betterStopCasting(SpellID) ~= true
		and (not UnitIsDeadOrGhost(Unit) or DeadCheck) then
		-- we create an usableSkip for some specific spells like hammer of wrath aoe mode
		if usableSkip == nil then
			usableSkip = false
		end
		-- stop if not enough power for that spell
		if usableSkip ~= true and IsUsableSpell(SpellID) ~= true then
			return false
		end
		-- Table used to prevent refiring too quick
		if timersTable == nil then
			timersTable = {}
		end
		-- make sure it is a known spell
		if not (KnownSkip == true or isKnown(SpellID)) then return false end
		-- gather our spell range information
		local spellRange = select(6,GetSpellInfo(SpellID))
		if DistanceSkip == nil then DistanceSkip = false end
		if spellRange == nil or (spellRange < 4 and DistanceSkip==false) then spellRange = 4 end
		if DistanceSkip == true then spellRange = 40 end
		-- Check unit,if it's player then we can skip facing
		if (Unit == nil or UnitIsUnit("player",Unit)) or -- Player
			(Unit ~= nil and UnitIsFriend("player",Unit)) then  -- Ally
			FacingCheck = true
		elseif isSafeToAttack(Unit) ~= true then -- enemy
			return false
		end
		-- if MovementCheck is nil or false then we dont check it
		if MovementCheck == false or isMoving("player") ~= true
			-- skip movement check during spiritwalkers grace and aspect of the fox
			or UnitBuffID("player",79206) ~= nil then
			-- if ability is ready and in range
			if getSpellCD(SpellID) == 0 and (getOptionCheck("Skip Distance Check") or getDistance("player",Unit) <= spellRange or DistanceSkip == true) then
				-- if spam is not allowed
				if SpamAllowed == false then
					-- get our last/current cast
					if timersTable == nil or (timersTable ~= nil and (timersTable[SpellID] == nil or timersTable[SpellID] <= GetTime() -0.6)) then
						if (FacingCheck == true or getFacing("player",Unit) == true) and (UnitIsUnit("player",Unit) or getLineOfSight("player",Unit) == true) then
							timersTable[SpellID] = GetTime()
							currentTarget = UnitGUID(Unit)
							CastSpellByName(GetSpellInfo(SpellID),Unit)
							--lastSpellCast = SpellID
							-- change main button icon
							if getOptionCheck("Start/Stop BadBoy") then
								mainButton:SetNormalTexture(select(3,GetSpellInfo(SpellID)))
								lastSpellCast = SpellID
							end
							return true
						end
					end
				elseif (FacingCheck == true or getFacing("player",Unit) == true) and (UnitIsUnit("player",Unit) or getLineOfSight("player",Unit) == true) then
					currentTarget = UnitGUID(Unit)
					CastSpellByName(GetSpellInfo(SpellID),Unit)
					if getOptionCheck("Start/Stop BadBoy") then
						mainButton:SetNormalTexture(select(3,GetSpellInfo(SpellID)))
						lastSpellCast = SpellID
					end
					return true
				end
			end
		end
	end
	return false
end
function castMouseoverHealing(Class)
	if UnitAffectingCombat("player") then
		local spellTable = {
			["Druid"] = { heal = 8936,dispel = 88423 }
		}
		local npcTable = {
			71604,-- Contaminated Puddle- Immerseus - SoO
			71995,-- Norushen
			71996,-- Norushen
			72000,-- Norushen
			71357,-- Wrathion
		}
		local SpecialTargets = { "mouseover","target","focus"}
		local dispelid = spellTable[Class].dispel
		for i = 1,#SpecialTargets do
			local target = SpecialTargets[i]
			if UnitExists(target) and not UnitIsPlayer(target) then
				local npcID = tonumber(string.match(UnitGUID(target),"-(%d+)-%x+$"))
				for i = 1,#npcTable do
					if npcID == npcTable[i] then
						-- Dispel
						for n = 1,40 do
							local buff,_,_,count,bufftype,duration = UnitDebuff(target,n)
							if buff then
								if bufftype == "Magic" or bufftype == "Curse" or bufftype == "Poison" then
									if castSpell(target,88423,true,false) then
										return
									end
								end
							else
								break
							end
						end
						-- Heal
						local npcHP = getHP(target)
						if npcHP < 100 then
							if castSpell(target,spellTable[Class].heal,true) then
								return
							end
						end
					end
				end
			end
		end
	end
end
--Calculate Agility
function getAgility()
	local AgiBase,AgiStat,AgiPos,AgiNeg = UnitStat("player",2)
	local Agi = AgiBase + AgiPos + AgiNeg
	return Agi
end
-- if getBuffDuration("target",12345) < 3 then
function getBuffDuration(Unit,BuffID,Source)
	if UnitBuffID(Unit,BuffID,Source) ~= nil then
		return select(6,UnitBuffID(Unit,BuffID,Source))*1
	end
	return 0
end
-- if getBuffRemain("target",12345) < 3 then
function getBuffRemain(Unit,BuffID,Source)
	if UnitBuffID(Unit,BuffID,Source) ~= nil then
		return (select(7,UnitBuffID(Unit,BuffID,Source)) - GetTime())
	end
	return 0
end
-- if getBuffStacks(138756) > 0 then
function getBuffStacks(unit,BuffID,Source)
	if UnitBuffID(unit,BuffID,Source) then
		return (select(4,UnitBuffID(unit,BuffID,Source)))
	else
		return 0
	end
end
-- if getCharges(115399) > 0 then
function getCharges(spellID)
	return select(1,GetSpellCharges(spellID))
end
function getChi(Unit)
	return UnitPower(Unit,12)
end
function getChiMax(Unit)
	return UnitPowerMax(Unit,12)
end
-- if getCombatTime() <= 5 then
function getCombatTime()
	local combatStarted = BadBoy_data["Combat Started"]
	local combatTime = BadBoy_data["Combat Time"]
	if combatStarted == nil then
		return 0
	end
	if combatTime == nil then
		combatTime = 0
	end
	if UnitAffectingCombat("player") == true then
		combatTime = (GetTime() - combatStarted)
	else
		combatTime = 0
	end
	BadBoy_data["Combat Time"] = combatTime
	return (math.floor(combatTime*1000)/1000)
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
-- if getCombo() >= 1 then
function getCombo()
	return GetComboPoints("player")
end
-- if getDebuffDuration("target",12345) < 3 then
function getDebuffDuration(Unit,DebuffID,Source)
	if UnitDebuffID(Unit,DebuffID,Source) ~= nil then
		return select(6,UnitDebuffID(Unit,DebuffID,Source))*1
	end
	return 0
end
-- if getDebuffRemain("target",12345) < 3 then
function getDebuffRemain(Unit,DebuffID,Source)
	if UnitDebuffID(Unit,DebuffID,Source) ~= nil then
		return (select(7,UnitDebuffID(Unit,DebuffID,Source)) - GetTime())
	end
	return 0
end
-- if getDebuffStacks("target",138756) > 0 then
function getDebuffStacks(Unit,DebuffID,Source)
	if UnitDebuffID(Unit,DebuffID,Source) then
		return (select(4,UnitDebuffID(Unit,DebuffID,Source)))
	else
		return 0
	end
end
-- if getDistance("player","target") <= 40 then
function getDistance(Unit1,Unit2)
	-- If both units are visible
	if GetObjectExists(Unit1) and UnitIsVisible(Unit1) == true and (Unit2 == nil or (GetObjectExists(Unit2) and UnitIsVisible(Unit2) == true)) then
		-- If Unit2 is nil we compare player to Unit1
		if Unit2 == nil then
			Unit2 = Unit1
			Unit1 = "player"
		end
		-- if unit1 is player, we can use our lib to get precise range
		if Unit1 == "player" and (isDummy(Unit2) or UnitCanAttack(Unit2,"player") == true) then
			return rc:GetRange(Unit2) or 1000
				-- else, we use FH positions
		else
			local X1,Y1,Z1 = GetObjectPosition(Unit1)
			local X2,Y2,Z2 = GetObjectPosition(Unit2)
			return math.sqrt(((X2-X1)^2) + ((Y2-Y1)^2) + ((Z2-Z1)^2)) - ((UnitCombatReach(Unit1)) + (UnitCombatReach(Unit2)))
		end
	else
		return 100
	end
end
function getRealDistance(Unit1,Unit2)
	if GetObjectExists(Unit1) and UnitIsVisible(Unit1) == true
		and GetObjectExists(Unit2) and UnitIsVisible(Unit2) == true then

		local X1,Y1,Z1 = GetObjectPosition(Unit1)
		local X2,Y2,Z2 = GetObjectPosition(Unit2)
		return math.sqrt(((X2-X1)^2) + ((Y2-Y1)^2) + ((Z2-Z1)^2)) - (UnitCombatReach(Unit1) + UnitCombatReach(Unit2))
	else
		return 100
	end
end
function getDistanceToObject(Unit1,X2,Y2,Z2)
	if Unit1 == nil then
		Unit1 = "player"
	end
	if GetObjectExists(Unit1) and UnitIsVisible(Unit1) then
		local X1,Y1 = GetObjectPosition(Unit1)
		return math.sqrt(((X2-X1)^2) + ((Y2-Y1)^2) + ((Z2-Z1)^2))
	else
		return 100
	end
end
-- findTarget(10,true,1)   will find closest target in 10 yard front that have more or equal to 1%hp
function findTarget(range,facingCheck,minimumHealth)
	if enemiesTable ~= nil then
		for i = 1,#enemiesTable do
			if enemiesTable[i].distance <= range then
				if FacingCheck == false or getFacing("player",enemiesTable[i].unit) == true then
					if not minimumHealth or minimumHealth and minimumHealth >= enemiesTable[i].hp then
						TargetUnit(enemiesTable[i].unit)
					end
				end
			else
				break
			end
		end
	end
end
--if getFallTime() > 2 then
function getFallTime()
	if fallStarted==nil then fallStarted = 0 end
	if fallTime==nil then fallTime = 0 end
	if IsFalling() then
		if fallStarted == 0 then
			fallStarted = GetTime()
		end
		if fallStarted ~= 0 then
			fallTime = (math.floor((GetTime() - fallStarted)*1000)/1000)
		end
	end
	if not IsFalling() then
		fallStarted = 0
		fallTime = 0
	end
	return fallTime
end
-- if getFacing("target","player") == false then
function getFacing(Unit1,Unit2,Degrees)
	if Degrees == nil then
		Degrees = 90
	end
	if Unit2 == nil then
		Unit2 = "player"
	end
	if GetObjectExists(Unit1) and UnitIsVisible(Unit1) and GetObjectExists(Unit2) and UnitIsVisible(Unit2) then
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
			else
				Angle3 = math.abs(Angle2-Angle1)
			end
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
		if not UnitIsDeadOrGhost(Unit) and UnitIsVisible(Unit) then
			for i = 1,#nNova do
				if nNova[i].guidsh == string.sub(UnitGUID(Unit),-5) then
					return nNova[i].hp
				end
			end
			if getOptionCheck("No Incoming Heals") ~= true and UnitGetIncomingHeals(Unit,"player") ~= nil then
				return 100*(UnitHealth(Unit)+UnitGetIncomingHeals(Unit,"player"))/UnitHealthMax(Unit)
			else
				return 100*UnitHealth(Unit)/UnitHealthMax(Unit)
			end
		end
	end
	return 0
end
-- if getLowAllies(60) > 3 then
function getLowAllies(Value)
	local lowAllies = 0
	for i = 1,#nNova do
		if nNova[i].hp < Value then
			lowAllies = lowAllies + 1
		end
	end
	return lowAllies
end
-- if getLowAlliesInTable(60, nNove) > 3 then
function getLowAlliesInTable(Value, unitTable)
	local lowAllies = 0
	for i = 1,#unitTable do
		if unitTable[i].hp < Value then
			lowAllies = lowAllies + 1
		end
	end
	return lowAllies
end
-- if getMana("target") <= 15 then
function getMana(Unit)
	return 100 * UnitPower(Unit,0) / UnitPowerMax(Unit,0)
end
-- if getPower("target") <= 15 then
function getPower(Unit)
	local value = value
	if select(3,UnitClass("player")) == 11 or select(3,UnitClass("player")) == 4 then
		if UnitBuffID("player",135700) then
			value = 999
		elseif UnitBuffID("player",106951) then
			value = UnitPower(Unit)*2
		else
			value = UnitPower(Unit)
		end
	else
		value = 100 * UnitPower(Unit) / UnitPowerMax(Unit)
	end
	return value
end
function getRecharge(spellID)
	local charges,maxCharges,chargeStart,chargeDuration = GetSpellCharges(spellID)
	if charges then
		if charges < maxCharges then
			chargeEnd = chargeStart + chargeDuration
			return chargeEnd - GetTime()
		end
		return 0
	end
end
--/dump TraceLine()
-- /dump getTotemDistance("target")
function getTotemDistance(Unit1)
	if Unit1 == nil then
		Unit1 = "player"
	end
	if activeTotem ~= nil and UnitIsVisible(Unit1) then
		for i = 1,GetObjectCountBB() do
			--print(UnitGUID(ObjectWithIndex(i)))
			if activeTotem == UnitGUID(GetObjectIndex(i)) then
				X2,Y2,Z2 = GetObjectPosition(GetObjectIndex(i))
			end
		end
		local X1,Y1,Z1 = GetObjectPosition(Unit1)
		TotemDistance = math.sqrt(((X2-X1)^2)+((Y2-Y1)^2)+((Z2-Z1)^2))
		--print(TotemDistance)
		return TotemDistance
	else
		return 1000
	end
end
-- if getBossID("boss1") == 71734 then
function getBossID(BossUnitID)
	return getUnitID(BossUnitID)
end
function getUnitID(Unit)
	if GetObjectExists(Unit) and UnitIsVisible(Unit) then
		local id = select(6,strsplit("-", UnitGUID(Unit) or ""))
		return tonumber(id)
	end
	return 0
end
-- if getNumEnemies("target",10) >= 3 then
function getNumEnemies(Unit,Radius)
	return #getEnemies(Unit,Radius)
end
-- if getLineOfSight("target"[,"target"]) then
function getLineOfSight(Unit1,Unit2)
	if Unit2 == nil then
		if Unit1 == "player" then
			Unit2 = "target"
		else
			Unit2 = "player"
		end
	end
	local skipLoSTable = {
		76585,-- Ragewing
		77692, -- Kromog
		77182, -- Oregorger
		--86644, -- Ore Crate from Oregorger boss
	}
	for i = 1,#skipLoSTable do
		if getUnitID(Unit1) == skipLoSTable[i] or getUnitID(Unit2) == skipLoSTable[i] then
			return true
		end
	end
	if GetObjectExists(Unit1) and UnitIsVisible(Unit1) and GetObjectExists(Unit2) and UnitIsVisible(Unit2) then
		local X1,Y1,Z1 = GetObjectPosition(Unit1)
		local X2,Y2,Z2 = GetObjectPosition(Unit2)
		if TraceLine(X1,Y1,Z1 + 2,X2,Y2,Z2 + 2, 0x10) == nil then
			return true
		else
			return false
		end
	else
		return true
	end
end
-- if getGround("target"[,"target"]) then
function getGround(Unit)
	if GetObjectExists(Unit) and UnitIsVisible(Unit) then
		local X1,Y1,Z1 = GetObjectPosition(Unit)
		if TraceLine(X1,Y1,Z1,X1,Y1,Z1-2, 0x10) == nil and TraceLine(X1,Y1,Z1,X1,Y1,Z1-2, 0x100) == nil then
			return nil
		else
			return true
		end
	end
end
function getGroundDistance(Unit)
	if GetObjectExists(Unit) and UnitIsVisible(Unit) then
		local X1,Y1,Z1 = GetObjectPosition(Unit)
		for i = 1,100 do
			if TraceLine(X1,Y1,Z1,X1,Y1,Z1-i/10, 0x10) ~= nil or TraceLine(X1,Y1,Z1,X1,Y1,Z1-i/10, 0x100) ~= nil then
				return i/10
			end
		end
	end
end
-- if getPetLineOfSight("target"[,"target"]) then
function getPetLineOfSight(Unit)
	if GetObjectExists(Unit) and UnitIsVisible("pet") and UnitIsVisible(Unit) then
		local X1,Y1,Z1 = GetObjectPosition("pet")
		local X2,Y2,Z2 = GetObjectPosition(Unit)
		if TraceLine(X1,Y1,Z1 + 2,X2,Y2,Z2 + 2, 0x10) == nil then
			return true
		else
			return false
		end
	else
		return true
	end
end
-- if getSpellCD(12345) <= 0.4 then
function getSpellCD(SpellID)
	if GetSpellCooldown(SpellID) == 0 then
		return 0
	else
		local Start ,CD = GetSpellCooldown(SpellID)
		local MyCD = Start + CD - GetTime()
		if getOptionCheck("Latency Compensation") then
			MyCD = MyCD - getLatency()
		end
		return MyCD
	end
end
--- Round
function round2(num,idp)
	mult = 10^(idp or 0)
	return math.floor(num * mult + 0.5) / mult
end
-- if getTalent(8) == true then
function getTalent(Row,Column)
	return select(4,GetTalentInfo(Row,Column,GetActiveSpecGroup())) or false
end
-- if getTimeToDie("target") >= 6 then
function getTimeToDie(unit)
	unit = unit or "target"
	if thpcurr == nil then
		thpcurr = 0
	end
	if thpstart == nil then
		thpstart = 0
	end
	if timestart == nil then
		timestart = 0
	end
	if GetObjectExists(unit) and UnitIsVisible(unit) and not UnitIsDeadOrGhost(unit) then
		if currtar ~= UnitGUID(unit) then
			priortar = currtar
			currtar = UnitGUID(unit)
		end
		if thpstart == 0 and timestart == 0 then
			thpstart = UnitHealth(unit)
			timestart = GetTime()
		else
			thpcurr = UnitHealth(unit)
			timecurr = GetTime()
			if thpcurr >= thpstart then
				thpstart = thpcurr
				timeToDie = 999
			else
				if ((timecurr - timestart)==0) or ((thpstart - thpcurr)==0) then
					timeToDie = 999
				else
					timeToDie = round2(thpcurr/((thpstart - thpcurr) / (timecurr - timestart)),2)
				end
			end
		end
	elseif not GetObjectExists(unit) or not UnitIsVisible(unit) or currtar ~= UnitGUID(unit) then
		currtar = 0
		priortar = 0
		thpstart = 0
		timestart = 0
		timeToDie = 0
	end
	if timeToDie==nil then
		return 999
	else
		return timeToDie
	end
end
-- if getTimeTo("target",20) < 10 then
function getTimeTo(unit,percent)
	unit = unit or "target"
	perchp = (UnitHealthMax(unit) / 100 * percent)
	if ttpthpcurr == nil then
		ttpthpcurr = 0
	end
	if ttpthpstart == nil then
		ttpthpstart = 0
	end
	if ttptimestart == nil then
		ttptimestart = 0
	end
	if GetObjectExists(unit) and UnitIsVisible(unit) and not UnitIsDeadOrGhost(unit) then
		if ttpcurrtar ~= UnitGUID(unit) then
			ttppriortar = currtar
			ttpcurrtar = UnitGUID(unit)
		end
		if ttpthpstart == 0 and ttptimestart == 0 then
			ttpthpstart = UnitHealth(unit)
			ttptimestart = GetTime()
		else
			ttpthpcurr = UnitHealth(unit)
			ttptimecurr = GetTime()
			if ttpthpcurr >= ttpthpstart then
				ttpthpstart = ttpthpcurr
				timeToPercent = 999
			else
				if ((timecurr - timestart)==0) or ((thpstart - thpcurr)==0) then
					timeToPercent = 999
				elseif ttpthpcurr < perchp then
					timeToPercent = 0
				else
					timeToPercent = round2((ttpthpcurr - perchp)/((ttpthpstart - ttpthpcurr) / (ttptimecurr - ttptimestart)),2)
				end
			end
		end
	elseif not GetObjectExists(unit) or not UnitIsVisible(unit) or ttpcurrtar ~= UnitGUID(unit) then
		ttpcurrtar = 0
		ttppriortar = 0
		ttpthpstart = 0
		ttptimestart = 0
		ttptimeToPercent = 0
	end
	if timeToPercent==nil then
		return 999
	else
		return timeToPercent
	end
end
-- if getTimeToMax("player") < 3 then
function getTimeToMax(Unit)
	local max = UnitPowerMax(Unit)
	local curr = UnitPower(Unit)
	local regen = select(2,GetPowerRegen(Unit))
	if select(3,UnitClass("player")) == 11 and GetSpecialization() == 2 and isKnown(114107) then
		curr2 = curr + 4*getCombo()
	else
		curr2 = curr
	end
	return (max - curr2) * (1.0 / regen)
end
-- if getRegen("player") > 15 then
function getRegen(Unit)
	local regen = select(2,GetPowerRegen(Unit))
	return 1.0 / regen
end
-- if getVengeance() >= 50000 then
function getVengeance()
	local VengeanceID = 0
	if select(3,UnitClass("player")) == 1 then VengeanceID = 93098 -- Warrior
	elseif select(3,UnitClass("player")) == 2 then VengeanceID = 84839 -- Paladin
	elseif select(3,UnitClass("player")) == 6 then VengeanceID = 93099 -- DK
	elseif select(3,UnitClass("player")) == 10 then VengeanceID = 120267 -- Monk
	elseif select(3,UnitClass("player")) == 11 then VengeanceID = 84840 -- Druid
	end
	if UnitBuff("player",VengeanceID) then
		return select(15,UnitAura("player",GetSpellInfo(VengeanceID)))
	end
	return 0
end
function hasBloodLust()
	if UnitBuffID("player",2825)        -- Bloodlust
		or UnitBuffID("player",80353)       -- Timewarp
		or UnitBuffID("player",32182)       -- Heroism
		or UnitBuffID("player",90355)       -- Ancient Hysteria
		or UnitBuffID("player",146555)      -- Drums of Rage
	then
		return true
	else
		return false
	end
end
-- if hasGlyph(1234) == true then
function hasGlyph(glyphid)
	for i=1,6 do
		if select(4,GetGlyphSocketInfo(i)) == glyphid or select(6,GetGlyphSocketInfo(i)) == glyphid then
			return true
		end
	end
	return false
end
-- if hasNoControl(12345) == true then
function hasNoControl(spellID)
	local eventIndex = C_LossOfControl.GetNumEvents()
	while (eventIndex > 0) do
		local _,_,text = C_LossOfControl.GetEventInfo(eventIndex)
		-- Warrior
		if select(3,UnitClass("player")) == 1 then
		end
		-- Paladin
		if select(3,UnitClass("player")) == 2 then
		end
		-- Hunter
		if select(3,UnitClass("player")) == 3 then
			if text == LOSS_OF_CONTROL_DISPLAY_ROOT or text == LOSS_OF_CONTROL_DISPLAY_SNARE then
				return true
			end
		end
		-- Rogue
		if select(3,UnitClass("player")) == 4 then
		end
		-- Priest
		if select(3,UnitClass("player")) == 5 then
		end
		-- Death Knight
		if select(3,UnitClass("player")) == 6 then
			if spellID == 49039 --Lichborne
				and (text == LOSS_OF_CONTROL_DISPLAY_CHARM
				or text == LOSS_OF_CONTROL_DISPLAY_FEAR
				or text == LOSS_OF_CONTROL_DISPLAY_SLEEP)
			then
				return true
			end
			if spellID == 108201 --Desecrated Ground
				and (text == LOSS_OF_CONTROL_DISPLAY_ROOT
				or text == LOSS_OF_CONTROL_DISPLAY_SNARE)
			then
				return true
			end
		end
		-- Shaman
		if select(3,UnitClass("player")) == 7 then
			if spellID == 8143 --Tremor Totem
				and	(text == LOSS_OF_CONTROL_DISPLAY_STUN
				or text == LOSS_OF_CONTROL_DISPLAY_FEAR
				or text == LOSS_OF_CONTROL_DISPLAY_SLEEP)
			then
				return true
			end
			if spellID == 108273 --Windwalk Totem
				and (text == LOSS_OF_CONTROL_DISPLAY_ROOT or text == LOSS_OF_CONTROL_DISPLAY_SNARE)
			then
				return true
			end
		end
		-- Mage
		if select(3,UnitClass("player")) == 8 then
		end
		-- Warlock
		if select(3,UnitClass("player")) == 9 then
		end
		-- Monk
		if select(3,UnitClass("player")) == 10 then
			if text == LOSS_OF_CONTROL_DISPLAY_STUN or text == LOSS_OF_CONTROL_DISPLAY_FEAR or text == LOSS_OF_CONTROL_DISPLAY_ROOT or text == LOSS_OF_CONTROL_DISPLAY_HORROR then
				return true
			end
		end
		-- Druid
		if select(3,UnitClass("player")) == 11 then
			if text == LOSS_OF_CONTROL_DISPLAY_ROOT or text == LOSS_OF_CONTROL_DISPLAY_SNARE then
				return true
			end
		end
		eventIndex = eventIndex - 1
	end
	return false
end
-- if isAlive([Unit]) == true then
function isAlive(Unit)
	local Unit = Unit or "player"
	if UnitIsDeadOrGhost(Unit) == false then
		return true
	end
end
-- isBoss()
function isBoss()
	------Boss Check------
	for x=1,5 do
		if UnitExists("boss1") then
			boss1 = tonumber(string.match(UnitGUID("boss1"),"-(%d+)-%x+$"))
		else
			boss1 = 0
		end
		if UnitExists("boss2") then
			boss2 = tonumber(string.match(UnitGUID("boss2"),"-(%d+)-%x+$"))
		else
			boss2 = 0
		end
		if UnitExists("boss3") then
			boss3 = tonumber(string.match(UnitGUID("boss3"),"-(%d+)-%x+$"))
		else
			boss3 = 0
		end
		if UnitExists("boss4") then
			boss4 = tonumber(string.match(UnitGUID("boss4"),"-(%d+)-%x+$"))
		else
			boss4 = 0
		end
		if UnitExists("boss5") then
			boss5 = tonumber(string.match(UnitGUID("boss5"),"-(%d+)-%x+$"))
		else
			boss5 = 0
		end
	end
	BossUnits = {
		-- Cataclysm Dungeons --
		-- Abyssal Maw: Throne of the Tides
		40586,-- Lady Naz'jar
		40765,-- Commander Ulthok
		40825,-- Erunak Stonespeaker
		40788,-- Mindbender Ghur'sha
		42172,-- Ozumat
		-- Blackrock Caverns
		39665,-- Rom'ogg Bonecrusher
		39679,-- Corla,Herald of Twilight
		39698,-- Karsh Steelbender
		39700,-- Beauty
		39705,-- Ascendant Lord Obsidius
		-- The Stonecore
		43438,-- Corborus
		43214,-- Slabhide
		42188,-- Ozruk
		42333,-- High Priestess Azil
		-- The Vortex Pinnacle
		43878,-- Grand Vizier Ertan
		43873,-- Altairus
		43875,-- Asaad
		-- Grim Batol
		39625,-- General Umbriss
		40177,-- Forgemaster Throngus
		40319,-- Drahga Shadowburner
		40484,-- Erudax
		-- Halls of Origination
		39425,-- Temple Guardian Anhuur
		39428,-- Earthrager Ptah
		39788,-- Anraphet
		39587,-- Isiset
		39731,-- Ammunae
		39732,-- Setesh
		39378,-- Rajh
		-- Lost City of the Tol'vir
		44577,-- General Husam
		43612,-- High Prophet Barim
		43614,-- Lockmaw
		49045,-- Augh
		44819,-- Siamat
		-- Zul'Aman
		23574,-- Akil'zon
		23576,-- Nalorakk
		23578,-- Jan'alai
		23577,-- Halazzi
		24239,-- Hex Lord Malacrass
		23863,-- Daakara
		-- Zul'Gurub
		52155,-- High Priest Venoxis
		52151,-- Bloodlord Mandokir
		52271,-- Edge of Madness
		52059,-- High Priestess Kilnara
		52053,-- Zanzil
		52148,-- Jin'do the Godbreaker
		-- End Time
		54431,-- Echo of Baine
		54445,-- Echo of Jaina
		54123,-- Echo of Sylvanas
		54544,-- Echo of Tyrande
		54432,-- Murozond
		-- Hour of Twilight
		54590,-- Arcurion
		54968,-- Asira Dawnslayer
		54938,-- Archbishop Benedictus
		-- Well of Eternity
		55085,-- Peroth'arn
		54853,-- Queen Azshara
		54969,-- Mannoroth
		55419,-- Captain Varo'then
		-- Mists of Pandaria Dungeons --
		-- Scarlet Halls
		59303,-- Houndmaster Braun
		58632,-- Armsmaster Harlan
		59150,-- Flameweaver Koegler
		-- Scarlet Monastery
		59789,-- Thalnos the Soulrender
		59223,-- Brother Korloff
		3977,-- High Inquisitor Whitemane
		60040,-- Commander Durand
		-- Scholomance
		58633,-- Instructor Chillheart
		59184,-- Jandice Barov
		59153,-- Rattlegore
		58722,-- Lilian Voss
		58791,-- Lilian's Soul
		59080,-- Darkmaster Gandling
		-- Stormstout Brewery
		56637,-- Ook-Ook
		56717,-- Hoptallus
		59479,-- Yan-Zhu the Uncasked
		-- Tempe of the Jade Serpent
		56448,-- Wise Mari
		56843,-- Lorewalker Stonestep
		59051,-- Strife
		59726,-- Peril
		58826,-- Zao Sunseeker
		56732,-- Liu Flameheart
		56762,-- Yu'lon
		56439,-- Sha of Doubt
		-- Mogu'shan Palace
		61444,-- Ming the Cunning
		61442,-- Kuai the Brute
		61445,-- Haiyan the Unstoppable
		61243,-- Gekkan
		61398,-- Xin the Weaponmaster
		-- Shado-Pan Monastery
		56747,-- Gu Cloudstrike
		56541,-- Master Snowdrift
		56719,-- Sha of Violence
		56884,-- Taran Zhu
		-- Gate of the Setting Sun
		56906,-- Saboteur Kip'tilak
		56589,-- Striker Ga'dok
		56636,-- Commander Ri'mok
		56877,-- Raigonn
		-- Siege of Niuzao Temple
		61567,-- Vizier Jin'bak
		61634,-- Commander Vo'jak
		61485,-- General Pa'valak
		62205,-- Wing Leader Ner'onok
		-- Training Dummies --
		46647,-- Level 85 Training Dummy
		67127,-- Level 90 Training Dummy
		-- Instance Bosses --
		boss1,--Boss 1
		boss2,--Boss 2
		boss3,--Boss 3
		boss4,--Boss 4
		boss5,--Boss 5
	}
	local BossUnits = BossUnits
	if UnitExists("target") then
		local npcID = tonumber(string.match(UnitGUID("target"),"-(%d+)-%x+$"))--tonumber(UnitGUID("target"):sub(6,10),16)
		if (UnitClassification("target") == "rare" or UnitClassification("target") == "rareelite" or UnitClassification("target") == "worldboss" or (UnitClassification("target") == "elite" and UnitLevel("target") >= UnitLevel("player")+3) or UnitLevel("target") < 0)
			--and select(2,IsInInstance())=="none"
			and not UnitIsTrivial("target")
		then
			return true
		else
			for i=1,#BossUnits do
				if BossUnits[i] == npcID then
					return true
				end
			end
			return false
		end
	else
		return false
	end
end
--- if isBuffed()
function isBuffed(UnitID,SpellID,TimeLeft,Filter)
	if not TimeLeft then TimeLeft = 0 end
	if type(SpellID) == "number" then SpellID = { SpellID } end
	for i=1,#SpellID do
		local spell,rank = GetSpellInfo(SpellID[i])
		if spell then
			local buff = select(7,UnitBuff(UnitID,spell,rank,Filter))
			if buff and ( buff == 0 or buff - GetTime() > TimeLeft ) then return true end
		end
	end
end
function isCastingTime(lagTolerance)
	local lagTolerance = 0
	if UnitCastingInfo("player") ~= nil then
		if select(6,UnitCastingInfo("player")) - GetTime() <= lagTolerance then
			return true
		end
	elseif UnitChannelInfo("player") ~= nil then
		if select(6,UnitChannelInfo("player")) - GetTime() <= lagTolerance then
			return true
		end
	elseif (GetSpellCooldown(GetSpellInfo(61304)) ~= nil and GetSpellCooldown(GetSpellInfo(61304)) <= lagTolerance) then
		return true
	else
		return false
	end
end
function getCastTimeRemain(unit)
	if UnitCastingInfo(unit) ~= nil then
		return select(6,UnitCastingInfo(unit)) - GetTime()
	elseif UnitChannelInfo(unit) ~= nil then
		return select(6,UnitChannelInfo(unit)) - GetTime()
	else
		return 0
	end
end
-- if isCasting() == true then
function castingUnit(Unit)
	if Unit == nil then Unit = "player" end
	if UnitCastingInfo(Unit) ~= nil
		or UnitChannelInfo(Unit) ~= nil
		or (GetSpellCooldown(61304) ~= nil and GetSpellCooldown(61304) > 0.001) then
		return true
	else
		return false
	end
end
-- if isCastingSpell(12345) == true then
function isCastingSpell(spellID,unit)
	if unit == nil then unit = "player" end
	local spellName = GetSpellInfo(spellID)
	local spellCasting = UnitCastingInfo(unit)
	if spellCasting == nil then
		spellCasting = UnitChannelInfo(unit)
	end
	if spellCasting == spellName then
		return true
	else
		return false
	end
end
-- if isDeBuffed("target",{123,456,789},2,"player") then
function isDeBuffed(UnitID,DebuffID,TimeLeft,Filter)
	if not TimeLeft then
		TimeLeft = 0
	end
	if type(DebuffID) == "number" then
		DebuffID = { DebuffID }
	end
	for i=1,#DebuffID do
		local spell,rank = GetSpellInfo(DebuffID[i])
		if spell then
			local debuff = select(7,UnitDebuff(UnitID,spell,rank,Filter))
			if debuff and ( debuff == 0 or debuff - GetTime() > TimeLeft ) then
				return true
			end
		end
	end
end
-- UnitGUID("target"):sub(-15,-10)
-- Dummy Check
function isDummy(Unit)
	if Unit == nil then
		Unit = "target"
	end
	if GetObjectExists(Unit) and UnitGUID(Unit) then
		local dummies = {
			[87329] = "Raider's Training Dummy", -- Lvl ?? (Stormshield - Tank)
			[88837] = "Raider's Training Dummy", -- Lvl ?? (Warspear - Tank)
			[87320] = "Raider's Training Dummy", -- Lvl ?? (Stormshield - Damage)
			[87762] = "Raider's Training Dummy", -- Lvl ?? (Warspear - Damage)
			[31146] = "Raider's Training Dummy", -- Lvl ?? (Ogrimmar,Stormwind,Darnassus,...)
			[70245] = "Training Dummy", -- Lvl ?? (Throne of Thunder)
			[87760] = "Training Dummy", -- Lvl 100 (Garrison - Portal Tower)
			[88314] = "Dungeoneer's Training Dummy", -- Lvl 102 (Lunarfall - Tank)
			[88288] = "Dungeoneer's Training Dummy", -- Lvl 102 (Frostwall - Tank)
			[88836] = "Dungeoneer's Training Dummy", -- Lvl 102 (Warspear - Tank)
			[87322] = "Dungeoneer's Training Dummy ", -- Lvl 102 (Stormshield,Warspear - Tank)
			[87317] = "Dungeoneer's Training Dummy", -- Lvl 102 (Lunarfall - Damage)
			[87318] = "Dungeoneer's Training Dummy", -- Lvl 102 (Lunarfall - Damage)
			[87761] = "Dungeoneer's Training Dummy", -- Lvl 102 (Frostwall - Damage)
			[88906] = "Combat Dummy", -- Lvl 100 (Nagrand)
			[89078] = "Training Dummy", -- Lvl 100 (Lunarfall,Frostwall)
			[87321] = "Training Dummy", -- Lvl 100 (Stormshield,Warspear - Healing)
			[88835] = "Training Dummy", -- Lvl 100 (Warspear - Healing)
			[88967] = "Training Dummy", -- Lvl 100 (Lunarfall,Frostwall)
			[88316] = "Training Dummy", -- Lvl 100 (Lunarfall - Healing)
			[88289] = "Training Dummy", -- Lvl 100 (Frostwall - Healing)
			[79414] = "Training Dummy", -- Lvl 95 (Talador)
			[67127] = "Training Dummy", -- Lvl 90 (Vale of Eternal Blossoms)
			[46647] = "Training Dummy", -- Lvl 85 (Orgrimmar,Stormwind)
			[32546] = "Ebon Knight's Training Dummy", -- Lvl 80 (Eastern Plaguelands)
			[31144] = "Training Dummy", -- Lvl 80 (Orgrimmar,Darnassus,Ruins of Gileas,...)
			[32543] = "Veteran's Training Dummy", -- Lvl 75 (Eastern Plaguelands)
			[32667] = "Training Dummy", -- Lvl 70 (Darnassus,Silvermoon,Orgrimar,...)
			[32542] = "Disciple's Training Dummy", -- Lvl 65 (Eastern Plaguelands)
			[32666] = "Training Dummy", -- Lvl 60 (Orgrimmar,Ironforge,Darnassus,...)
			[32541] = "Initiate's Training Dummy", -- Lvl 55 (Scarlet Enclave)
			[32545] = "Initiate's Training Dummy", -- Lvl 55 (Eastern Plaguelands)
			[60197] = "Scarlet Monastery Dummy",
			[64446] = "Scarlet Monastery Dummy",
		}
		if dummies[tonumber(string.match(UnitGUID(Unit),"-(%d+)-%x+$"))] ~= nil then
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
--if isGarrMCd() then
function isGarrMCd(Unit)
	if Unit == nil then
		Unit = "target"
	end
	if UnitExists(Unit)
		and (UnitDebuffID(Unit,145832)
		or UnitDebuffID(Unit,145171)
		or UnitDebuffID(Unit,145065)
		or UnitDebuffID(Unit,145071)) then
		return true
	else
		return false
	end
end
-- if isInCombat("target") then
function isInCombat(Unit)
	if UnitAffectingCombat(Unit) then
		return true
	else
		return false
	end
end
-- if isInDraenor() then
function isInDraenor()
	local tContains = tContains
	local currentMapID = GetCurrentMapAreaID()
	local draenorMapIDs =
		{
			962,-- Draenor
			978,-- Ashran
			941,-- Frostfire Ridge
			976,-- Frostwall
			949,-- Gorgrond
			971,-- Lunarfall
			950,-- Nagrand
			947,-- Shadowmoon Valley
			948,-- Spires of Arak
			1009,-- Stormshield
			946,-- Talador
			945,-- Tanaan Jungle
			970,-- Tanaan Jungle - Assault on the Dark Portal
			1011,-- Warspear
		}
	if (tContains(draenorMapIDs,currentMapID)) then
		return true
	else
		return false
	end
end
-- if isInMelee() then
function isInMelee(Unit)
	if Unit == nil then
		Unit = "target"
	end
	if getDistance(Unit) < 4 then
		return true
	else
		return false
	end
end
-- if IsInPvP() then
function isInPvP()
	local inpvp = GetPVPTimer()
	if inpvp ~= 301000 and inpvp ~= -1 then
		return true
	else
		return false
	end
end
-- if isKnown(106832) then
function isKnown(spellID)
	local spellName = GetSpellInfo(spellID)
	if GetSpellBookItemInfo(tostring(spellName)) ~= nil then
		return true
	end
	if IsPlayerSpell(tonumber(spellID)) == true then
		return true
	end
	return false
end
--if isLongTimeCCed("target") then
-- CCs with >=20 seconds
function isLongTimeCCed(Unit)
	if Unit == nil then
		return false
	end
	local longTimeCC = {
		339,	-- Druid - Entangling Roots
		102359,	-- Druid - Mass Entanglement
		1499,	-- Hunter - Freezing Trap
		19386,	-- Hunter - Wyvern Sting
		118,	-- Mage - Polymorph
		115078,	-- Monk - Paralysis
		20066,	-- Paladin - Repentance
		10326,	-- Paladin - Turn Evil
		9484,	-- Priest - Shackle Undead
		605,	-- Priest - Dominate Mind
		6770,	-- Rogue - Sap
		2094,	-- Rogue - Blind
		51514,	-- Shaman - Hex
		710,	-- Warlock - Banish
		5782,	-- Warlock - Fear
		5484,	-- Warlock - Howl of Terror
		115268,	-- Warlock - Mesmerize
		6358,	-- Warlock - Seduction
	}
	for i=1,#longTimeCC do
		--local checkCC=longTimeCC[i]
		if UnitDebuffID(Unit,longTimeCC[i])~=nil then
			return true
		end
	end
	return false
end
-- if isLooting() then
function isLooting()
	if GetNumLootItems() > 0 then
		return true
	else
		return false
	end
end
function getLoot2()
	if looted == nil then looted = 0 end
	if lM:emptySlots() then
		for i=1,GetObjectCountBB() do
			if GetObjectExists(i) and bit.band(GetObjectType(i), ObjectTypes.Unit) == 8 then
				local thisUnit = GetObjectIndex(i)
				local hasLoot,canLoot = CanLootUnit(UnitGUID(thisUnit))
				local inRange = getRealDistance("player",thisUnit) < 2
				if UnitIsDeadOrGhost(thisUnit) then
					if hasLoot and canLoot and inRange and (canLootTimer == nil or canLootTimer <= GetTime()-0.5)--[[getOptionValue("Auto Loot"))]] then
						if GetCVar("autoLootDefault") == "0" then
							SetCVar("autoLootDefault", "1")
							InteractUnit(thisUnit)
							if isLooting() then
								return true
							end
							canLootTimer = GetTime()
							SetCVar("autoLootDefault", "0")
							looted = 1
							return
						else
							InteractUnit(thisUnit)
							if isLooting() then
								return true
							end
							canLootTimer = GetTime()
							looted = 1
						end
					end
				end
			end
		end
		if UnitExists("target") and UnitIsDeadOrGhost("target") and looted==1 and not isLooting() then
			ClearTarget()
			looted=0
		end
	else
		ChatOverlay("Bags are full, nothing will be looted!")
	end
end
-- if not isMoving("target") then
function isMoving(Unit)
	if GetUnitSpeed(Unit) > 0 then
		return true
	else
		return false
	end
end
-- if IsMovingTime(5) then
function IsMovingTime(time)
	if time == nil then time = 1 end
	if GetUnitSpeed("player") > 0 then
		if IsRunning == nil then
			IsRunning = GetTime()
			IsStanding = nil
		end
		if GetTime() - IsRunning > time then
			return true
		end
	else
		if IsStanding == nil then
			IsStanding = GetTime()
			IsRunning = nil
		end
		if GetTime() - IsStanding > time then
			return false
		end
	end
end
function isPlayer(Unit)
	if UnitExists(Unit) ~= true then
		return false
	end
	if UnitIsPlayer(Unit) == true then
		return true
	elseif UnitIsPlayer(Unit) ~= true then
		local playerNPC = {
			[72218] = "Oto the Protector",
			[72219] = "Ki the Asssassin",
			[72220] = "Sooli the Survivalist",
			[72221] = "Kavan the Arcanist"
		}
		if playerNPC[tonumber(string.match(UnitGUID(Unit),"-(%d+)-%x+$"))] ~= nil then
			return true
		end
	else
		return false
	end
end
function getStandingTime()
	return DontMoveStartTime and GetTime() - DontMoveStartTime or nil
end
--
function isStanding(Seconds)
	return IsFalling() == false and DontMoveStartTime and getStandingTime() >= Seconds or false
end
-- if IsStandingTime(5) then
function IsStandingTime(time)
	if time == nil then time = 1 end
	if not IsFalling() and GetUnitSpeed("player") == 0 then
		if IsStanding == nil then
			IsStanding = GetTime()
			IsRunning = nil
		end
		if GetTime() - IsStanding > time then
			return true
		end
	else
		if IsRunning == nil then
			IsRunning = GetTime()
			IsStanding = nil
		end
		if GetTime() - IsRunning > time then
			return false
		end
	end
end
-- if isCasting(12345,"target") then
function isCasting(SpellID,Unit)
	if GetObjectExists(Unit) and UnitIsVisible(Unit) then
		if isCasting(tostring(GetSpellInfo(SpellID)),Unit) == 1 then
			return true
		end
	else
		return false
	end
end
-- if isValidTarget("target") then
function isValidTarget(Unit)
	if UnitIsEnemy("player",Unit) then
		if UnitExists(Unit) and not UnitIsDeadOrGhost(Unit) then
			return true
		else
			return false
		end
	else
		if UnitExists(Unit) then
			return true
		else
			return false
		end
	end
end
-- Dem Bleeds
-- In a run once environment we shall create the Tooltip that we will be reading
-- all of the spell details from
nGTT = CreateFrame( "GameTooltip","MyScanningTooltip",nil,"GameTooltipTemplate" )
nGTT:SetOwner( WorldFrame,"ANCHOR_NONE" )
nGTT:AddFontStrings(nGTT:CreateFontString( "$parentTextLeft1",nil,"GameTooltipText" ),nGTT:CreateFontString( "$parentTextRight1",nil,"GameTooltipText" ) )
function nDbDmg(tar,spellID,player)
	if GetCVar("DotDamage") == nil then
		RegisterCVar("DotDamage",0)
	end
	nGTT:ClearLines()
	for i=1,40 do
		if UnitDebuff(tar,i,player) == GetSpellInfo(spellID) then
			nGTT:SetUnitDebuff(tar,i,player)
			scanText=_G["MyScanningTooltipTextLeft2"]:GetText()
			local DoTDamage = scanText:match("([0-9]+%.?[0-9]*)")
			--if not issecure() then print(issecure()) end -- function is called inside the profile
			--SetCVar("DotDamage",tonumber(DoTDamage))
			return tonumber(DoTDamage)
			--return tonumber(GetCVar("DotDamage"))
		end
	end
end
-- if pause() then
function pause()
	if SpecificToggle("Pause Mode") == nil or getValue("Pause Mode") == 6 then
		pausekey = IsLeftAltKeyDown()
	else
		pausekey = SpecificToggle("Pause Mode")
	end
	if isChecked("DPS Testing")~=nil then
		if GetObjectExists("target") and isInCombat("player") then
			if getCombatTime() >= (tonumber(getOptionValue("DPS Testing"))*60) and isDummy() then
				StopAttack()
				ClearTarget()
				print(tonumber(getOptionValue("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
				profileStop = true
			else
				profileStop = false
			end
		elseif not isInCombat("player") and profileStop==true then
			if GetObjectExists("target") then
				StopAttack()
				ClearTarget()
				profileStop=false
			end
		end
	end
	if (pausekey and GetCurrentKeyBoardFocus() == nil)
		or profileStop
		or (IsMounted() and getUnitID("target") ~= 56877 and not UnitBuffID("player",164222) and not UnitBuffID("player",165803) and not UnitBuffID("player",157059) and not UnitBuffID("player",157060))
		or SpellIsTargeting()
		or (not UnitCanAttack("player","target") and not UnitIsPlayer("target") and UnitExists("target"))
		or UnitCastingInfo("player")
		or UnitChannelInfo("player")
		or UnitIsDeadOrGhost("player")
		or (UnitIsDeadOrGhost("target") and not UnitIsPlayer("target"))
		or UnitBuffID("player",80169) -- Eating
		or UnitBuffID("player",87959) -- Drinking
		or UnitBuffID("target",117961) --Impervious Shield - Qiang the Merciless
		or UnitDebuffID("player",135147) --Dead Zone - Iron Qon: Dam'ren
		or (((UnitHealth("target")/UnitHealthMax("target"))*100) > 10 and UnitBuffID("target",143593)) --Defensive Stance - General Nagrazim
		or UnitBuffID("target",140296) --Conductive Shield - Thunder Lord / Lightning Guardian
	then
		ChatOverlay("Profile Paused")
		return true
	end
end
-- feed a var
function toggleTrueNil(var)
	if _G[var] ~= true then
		_G[var] = true
	else
		_G[var] = nil
	end
end
-- useItem(12345)
function useItem_old(itemID)
	if GetItemCount(itemID) > 0 then
		if select(2,GetItemCooldown(itemID))==0 then
			local itemName = GetItemInfo(itemID)
			RunMacroText("/use "..itemName)
			return true
		end
	end
	return false
end
-- useItem(12345)
function useItem(itemID)
	--Anti-Spam--
	local spamDelayTime = 1
	if spamDelay == nil then
	 spamDelay = GetTime()
	end

	if GetItemCount(itemID) > 0 then
		if select(2,GetItemCooldown(itemID))==0 then
			if GetTime() > spamDelay then
				local itemName = GetItemInfo(itemID)
				UseItemByName(select(1,UseItemByName(itemID)))
				spamDelay = GetTime() + spamDelayTime 
				return true
			end
		end
	end
	return false
end
function spellDebug(Message)
	if imDebugging == true and getOptionCheck("Debugging Mode") then
		ChatOverlay(Message)
	end
end
-- if isChecked("Debug") then
function isChecked(Value)
	--print(BadBoy_data.options[GetSpecialization()]["profile"..Value.."Check"])
	if BadBoy_data.options[GetSpecialization()] and BadBoy_data.options[GetSpecialization()][Value.."Check"] == 1 then
		return true
	end
end
-- if isSelected("Stormlash Totem") then
function isSelected(Value)
	if BadBoy_data["Cooldowns"] == 3 or (isChecked(Value)
		and (getValue(Value) == 3 or (getValue(Value) == 2 and BadBoy_data["Cooldowns"] == 2))) then
		return true
	end
end
-- if getValue("player") <= getValue("Eternal Flame") then
function getValue(Value)
	if BadBoy_data.options[GetSpecialization()] then
		if BadBoy_data.options[GetSpecialization()][Value.."Status"] ~= nil then
			return BadBoy_data.options[GetSpecialization()][Value.."Status"]
		elseif BadBoy_data.options[GetSpecialization()][Value.."Drop"] ~= nil then
			return BadBoy_data.options[GetSpecialization()][Value.."Drop"]
		else
			return 0
		end
	end
end
-- used to gather informations from the bot options frame
function getOptionCheck(Value)
	if BadBoy_data.options[GetSpecialization()] and BadBoy_data.options[GetSpecialization()][Value.."Check"] == 1 then
		return true
	end
end
function getOptionValue(Value)
	if BadBoy_data.options[GetSpecialization()] and BadBoy_data.options[GetSpecialization()][Value.."Status"] then
		return BadBoy_data.options[GetSpecialization()][Value.."Status"]
	elseif BadBoy_data.options[GetSpecialization()] and BadBoy_data.options[GetSpecialization()][Value.."Drop"] then
		return BadBoy_data.options[GetSpecialization()][Value.."Drop"]
	else
		return 0
	end
end
--[[Health Potion Table]]
function hasHealthPot()
	healthPot = { }
	for i = 1, 4 do
		for x = 1, GetContainerNumSlots(i) do
			local itemID = GetContainerItemID(i,x)
			if itemID~=nil then
				local ItemName = select(1,GetItemInfo(itemID))
				local MinLevel = select(5,GetItemInfo(itemID))
				local ItemType = select(7,GetItemInfo(itemID))
				local ItemEffect = select(1,GetItemSpell(itemID))
				if ItemType == select(7,GetItemInfo(2459)) then
					if strmatch(ItemEffect,strmatch(tostring(select(1,GetItemSpell(76097))),"%a+")) then
						local ItemCount = GetItemCount(itemID)
						local ItemCooldown = GetItemCooldown(itemID)
						if MinLevel<=UnitLevel("player") and ItemCooldown == 0 then
							tinsert(healthPot,
								{
									item = itemID,
									itemName = ItemName,
									minLevel = MinLevel,
									itemType = ItemType,
									itemEffect = ItemEffect,
									itemCount = ItemCount
								}
							)
						end
					end
				end
			end
			table.sort(healthPot, function(x,y)
				return x.minLevel and y.minLevel and x.minLevel > y.minLevel or false
			end)
		end
	end
	if healthPot[1]==nil then
		healPot=0
		return false
	else
		healPot=healthPot[1].item
		return true
	end
end
--[[Taunts Table!! load once]]
tauntsTable = {
	{ spell = 143436,stacks = 1 },--Immerseus/71543               143436 - Corrosive Blast                             == 1x
	{ spell = 146124,stacks = 3 },--Norushen/72276                146124 - Self Doubt                                  >= 3x
	{ spell = 144358,stacks = 1 },--Sha of Pride/71734            144358 - Wounded Pride                               == 1x
	{ spell = 147029,stacks = 3 },--Galakras/72249                147029 - Flames of Galakrond                         == 3x
	{ spell = 144467,stacks = 2 },--Iron Juggernaut/71466         144467 - Ignite Armor                                >= 2x
	{ spell = 144215,stacks = 6 },--Kor'Kron Dark Shaman/71859    144215 - Froststorm Strike (Earthbreaker Haromm)     >= 6x
	{ spell = 143494,stacks = 3 },--General Nazgrim/71515         143494 - Sundering Blow                              >= 3x
	{ spell = 142990,stacks = 12 },--Malkorok/71454                142990 - Fatal Strike                                == 12x
	{ spell = 143426,stacks = 2 },--Thok the Bloodthirsty/71529   143426 - Fearsome Roar                               == 2x
	{ spell = 143780,stacks = 2 },--Thok (Saurok eaten)           143780 - Acid Breath                                 == 2x
	{ spell = 143773,stacks = 3 },--Thok (Jinyu eaten)            143773 - Freezing Breath                             == 3x
	{ spell = 143767,stacks = 2 },--Thok (Yaungol eaten)          143767 - Scorching Breath                            == 2x
	{ spell = 145183,stacks = 3 } --Garrosh/71865                 145183 - Gripping Despair                            >= 3x
}
--[[Taunt function!! load once]]
function ShouldTaunt()
	--[[Normal boss1 taunt method]]
	if not UnitIsUnit("player","boss1target") then
		for i = 1,#tauntsTable do
			if not UnitDebuffID("player",tauntsTable[i].spell) and UnitDebuffID("boss1target",tauntsTable[i].spell) and getDebuffStacks("boss1target",tauntsTable[i].spell) >= tauntsTable[i].stacks then
				TargetUnit("boss1")
				return true
			end
		end
	end
	--[[Swap back to Wavebinder Kardris]]
	if getBossID("target") ~= 71858 then
		if UnitDebuffID("player",144215) and getDebuffStacks("player",144215) >= 6 then
			if getBossID("boss1") == 71858 then
				TargetUnit("boss1")
				return true
			else
				TargetUnit("boss2")
				return true
			end
		end
	end
end

-- if TierScan("T17")>=2 then
function TierScan(thisTier)
	local equippedItems = 0;
	local myClass = select(2,UnitClass("player"));
	local thisTier = string.upper(thisTier);
	local sets = {
		["T17"] = {
			["DRUID"] = {
				115540, -- chest
				115541, -- hands
				115542, -- head
				115543, -- legs
				115544, -- shoulder
			},
			["DEATH KNIGHT"] = {
				115535, -- legs
				115536, -- shoulder
				115537, -- chest
				115538, -- hands
				115539, -- head
			},
			["HUNTER"] = {
				115545, -- head
				115546, -- legs
				115547, -- shoulder
				115548, -- chest
				115549, -- hands
			},
			["MAGE"] = {
				115550, -- chest
				115551, -- shoulder
				155552, -- hands
				155553, -- head
				155554, -- legs
			},
			["MONK"] = {
				115555, -- hands
				115556, -- head
				115557, -- legs
				115558, -- chest
				115559, -- shoulder
			},
			["PALADIN"] = {
				115565, -- shoulder
				115566, -- chest
				115567, -- hands
				115568, -- head
				115569, -- legs
			},
			["PRIEST"] = {
				115560, -- chest
				115561, -- shoulder
				115562, -- hands
				115563, -- head
				115564, -- legs
			},
			["ROGUE"] = {
				115570, -- chest
				115571, -- hands
				115572, -- head
				115573, -- legs
				115574, -- shoulder
			},
			["SHAMAN"] = {
				115575, -- legs
				115576, -- shoulder
				115577, -- chest
				115578, -- hands
				115579, -- head
			},
			["WARLOCK"] = {
				115585, -- hands
				115586, -- head
				115587, -- legs
				115588, -- chest
				115589, -- shoulder
			},
			["WARRIOR"] = {
				115580, -- legs
				115581, -- shoulder
				115582, -- chest
				115583, -- hands
				115584, -- head
			},
		},
		["T18"] = {
			["DRUID"] = {
				124246, -- chest
				124255, -- hands
				124261, -- head
				124267, -- legs
				124272, -- shoulder
			},
			["DEATH KNIGHT"] = {
				124317, -- chest
				124327, -- hands
				124332, -- head
				124338, -- legs
				124344, -- shoulder
			},
			["HUNTER"] = {
				124284, -- chest
				124292, -- hands
				124296, -- head
				124301, -- legs
				124307, -- shoulder
			},
			["MAGE"] = {
				124171, -- chest
				124154, -- hands
				124160, -- head
				124165, -- legs
				124177, -- shoulder
			},
			["MONK"] = {
				124247, -- chest
				124256, -- hands
				124262, -- head
				124268, -- legs
				124273, -- shoulder
			},
			["PALADIN"] = {
				124318, -- chest
				124328, -- hands
				124333, -- head
				124339, -- legs
				124345, -- shoulder
			},
			["PRIEST"] = {
				124172, -- chest
				124155, -- hands
				124161, -- head
				124166, -- legs
				124178, -- shoulder
			},
			["ROGUE"] = {
				124248, -- chest
				124257, -- hands
				124263, -- head
				124269, -- legs
				124274, -- shoulder
			},
			["SHAMAN"] = {
				124303, -- chest
				124293, -- hands
				124297, -- head
				124302, -- legs
				124308, -- shoulder
			},
			["WARLOCK"] = {
				124173, -- chest
				124156, -- hands
				124162, -- head
				124167, -- legs
				124179, -- shoulder
			},
			["WARRIOR"] = {
				124319, -- chest
				124329, -- hands
				124334, -- head
				124340, -- legs
				124346, -- shoulder
			},
		},
	}
	-- scan every items
	for i=1, 19 do
		-- if there is an item in that slot
		if GetInventoryItemID("player", i) ~= nil then
			-- compare to items in our items list
			for j = 1, 5 do
				--print(sets[thisTier][myClass][j]) 
				if GetItemInfo(GetInventoryItemID("player", i)) == GetItemInfo(sets[thisTier][myClass][j]) then
					equippedItems = equippedItems + 1;
				end
			end
		end
	end
	return equippedItems;
end