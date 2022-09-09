local _, br = ...
-- if canCast(12345,true)
function br.canCast(SpellID,KnownSkip,MovementCheck)
	local myCooldown = br.getSpellCD(SpellID) or 0
	local lagTolerance = br.getValue("Lag Tolerance") or 0
	if (KnownSkip == true or br.isKnown(SpellID)) and _G.IsUsableSpell(SpellID) and myCooldown < 0.1
		and (MovementCheck == false or myCooldown == 0 or br.isMoving("player") ~= true or br.UnitBuffID("player",79206) ~= nil) then
		return true
	end
end

function br.castAoEHeal(spellID,numUnits,missingHP,rangeValue)
	-- i start an iteration that i use to build each units Table,which i will reuse for the next second
	if not br.holyRadianceRangeTable or not br.holyRadianceRangeTableTimer or br.holyRadianceRangeTableTimer <= _G.GetTime() - 1 then
		br.holyRadianceRangeTable = { }
		for i = 1,#br.friend do
			-- i declare a sub-table for this unit if it dont exists
			if br.friend[i].distanceTable == nil then br.friend[i].distanceTable = { } end
			-- i start a second iteration where i scan unit ranges from one another.
			for j = 1,#br.friend do
				-- i make sure i dont compute unit range to hisself.
				if not br.GetUnitIsUnit(br.friend[i].unit,br.friend[j].unit) then
					-- table the units
					br.friend[i].distanceTable[j] = { distance = br.getDistance(br.friend[i].unit,br.friend[j].unit),unit = br.friend[j].unit,hp = br.friend[j].hp }
				end
			end
		end
	end
	-- declare locals that will hold number
	local bestTarget,bestTargetUnits = 1,1
	-- now that nova range is built,i can iterate it
	local inRange,missingHealth,mostMissingHealth = 0,0,0
	for i = 1,#br.friend do
		if br.friend[i].distanceTable ~= nil then
			-- i count units in range
			for j = 1,#br.friend do
				if br.friend[i].distanceTable[j] and br.friend[i].distanceTable[j].distance < rangeValue then
					inRange = inRange + 1
					missingHealth = missingHealth + (100 - br.friend[i].distanceTable[j].hp)
				end
			end
			br.friend[i].inRangeForHolyRadiance = inRange
			-- i check if this is going to be the best unit for my spell
			if missingHealth > mostMissingHealth then
				bestTarget,bestTargetUnits,mostMissingHealth = i,inRange,missingHealth
			end
		end
	end
	if bestTargetUnits and bestTargetUnits > 3 and mostMissingHealth and missingHP and mostMissingHealth > missingHP then
		if br.castSpell(br.friend[bestTarget].unit,spellID,true,true) then return true end
	end
end
-- castGround("target",12345,40)
function br.castGround(Unit,SpellID,maxDistance,minDistance,radius,castTime)
	if radius == nil then radius = maxDistance end
	if minDistance == nil then minDistance = 0 end
	local mouselookActive = false
	if br.GetUnitExists(Unit) and br.getSpellCD(SpellID) == 0 and br.getLineOfSight("player",Unit)
	and #br.getEnemies(Unit,radius) >= #br.getEnemies(Unit,radius,true) then
		local distance = br.getDistance("player",Unit)
		if distance < maxDistance and distance >= minDistance
		then
			if br._G.IsMouselooking() then
				mouselookActive = true
				br._G.MouselookStop()
			end
			br._G.CastSpellByName(br._G.GetSpellInfo(SpellID))
			local X,Y,Z
			if castTime == nil or castTime == 0 then
				X,Y,Z = br.GetObjectPosition(Unit)
			else
				X,Y,Z = br.GetFuturePostion(Unit, castTime)
			end
			local groundDistance = br.getDistance("player",Unit,"dist4")+1
			--local distanceToGround = getGroundDistance(Unit) or 0
			if groundDistance > maxDistance then X,Y,Z = br._G.GetPositionBetweenObjects(Unit,"player",groundDistance-maxDistance) end
			br._G.ClickPosition((X + math.random() * 2),(Y + math.random() * 2),Z) --distanceToGround
			br.castPosition.x = X
			br.castPosition.y = Y
			br.castPosition.z = Z
			if mouselookActive then
				br._G.MouselookStart()
			end
			return true
		end
	end
	return false
end
--castGroundLocation(123,456,98765,40,0,8)
function br.castGroundLocation(X,Y,SpellID,maxDistance,minDistance,radius)
	if X == nil or Y == nil then return false end
	if radius == nil then radius = maxDistance end
	if minDistance == nil then minDistance = 0 end
	--local groundDistance = br.getDistance("player",Unit,"dist4")+1
	local pX, pY, Z = br.GetObjectPosition("player")
	local distance = sqrt(((X-pX)^2) + ((Y-pY)^2))
	local mouselookActive = false

	if distance < maxDistance and distance >= minDistance then
		if _G.IsMouselooking() then
			mouselookActive = true
			_G.MouselookStop()
		end
		br._G.CastSpellByName(_G.GetSpellInfo(SpellID))
		br._G.ClickPosition((X + math.random() * 2),(Y + math.random() * 2),Z) --distanceToGround
        br.castPosition.x = X
        br.castPosition.y = Y
        br.castPosition.z = Z
		if mouselookActive then
			_G.MouselookStart()
		end
		return true
	end
	return false
end
-- castGroundBetween("target",12345,40)
function br.castGroundBetween(Unit,SpellID,maxDistance)
	if br.GetUnitExists(Unit) and br.getSpellCD(SpellID) <= 0.4 and br.getLineOfSight("player",Unit) and br.getDistance("player",Unit) <= maxDistance then
		br._G.CastSpellByName(_G.GetSpellInfo(SpellID))
		local X,Y,Z = br.GetObjectPosition(Unit)
		br._G.ClickPosition(X,Y,Z,true)
		return true
	end
	return false
end
-- if shouldNotOverheal(spellCastTarget) > 80 then
function br.shouldNotOverheal(Unit)
	local myIncomingHeal,allIncomingHeal = 0,0
	if br._G.UnitGetIncomingHeals(Unit,"player") ~= nil then myIncomingHeal = br._G.UnitGetIncomingHeals(Unit,"player") end
	if br._G.UnitGetIncomingHeals(Unit) ~= nil then allIncomingHeal = br._G.UnitGetIncomingHeals(Unit) end
	allIncomingHeal = allIncomingHeal or 0
	local overheal
	if myIncomingHeal >= allIncomingHeal then
		overheal = myIncomingHeal
	else
		overheal = allIncomingHeal
	end
	local CurShield = br._G.UnitHealth(Unit)
	if br.UnitDebuffID("player",142861) then --Ancient Miasma
		CurShield = select(14,br.UnitDebuffID(Unit,142863)) or select(14,br.UnitDebuffID(Unit,142864)) or select(14,br.UnitDebuffID(Unit,142865)) or (br._G.UnitHealthMax(Unit) / 2)
		overheal = 0
	end
	local overhealth = 100 * (CurShield+ overheal ) / br._G.UnitHealthMax(Unit)
	if overhealth and overheal then
		return overhealth,overheal
	else
		return 0,0
	end
end
-- if castHealGround(_HealingRain,18,80,3) then
function br.castHealGround(SpellID,Radius,Health,NumberOfPlayers)
	if br.shouldStopCasting(SpellID) ~= true then
		local lowHPTargets,foundTargets = { },{ }
		for i = 1,#br.friend do
			if br.getHP(br.friend[i].unit) <= Health then
				if br.GetUnitIsVisible(br.friend[i].unit) and br.GetObjectExists(br.friend[i].unit) then
					local X,Y,Z = br.GetObjectPosition(br.friend[i].unit)
					_G.tinsert(lowHPTargets,{ unit = br.friend[i].unit,x = X,y = Y,z = Z })
				end
			end
		end
		if #lowHPTargets >= NumberOfPlayers then
			for i = 1,#lowHPTargets do
				for j = 1,#lowHPTargets do
					if lowHPTargets[i].unit ~= lowHPTargets[j].unit then
						if math.sqrt(((lowHPTargets[j].x-lowHPTargets[i].x)^2)+((lowHPTargets[j].y-lowHPTargets[i].y)^2)) < Radius then
							for k = 1,#lowHPTargets do
								if lowHPTargets[i].unit ~= lowHPTargets[k].unit and lowHPTargets[j].unit ~= lowHPTargets[k].unit then
									if math.sqrt(((lowHPTargets[k].x-lowHPTargets[i].x)^2)+((lowHPTargets[k].y-lowHPTargets[i].y)^2)) < Radius
										and math.sqrt(((lowHPTargets[k].x-lowHPTargets[j].x)^2)+((lowHPTargets[k].y-lowHPTargets[j].y)^2)) < Radius
									then
										_G.tinsert(foundTargets,{ unit = lowHPTargets[i].unit,x = lowHPTargets[i].x,y = lowHPTargets[i].y,z = lowHPTargets[i].z })
										_G.tinsert(foundTargets,{ unit = lowHPTargets[j].unit,x = lowHPTargets[j].x,y = lowHPTargets[j].y,z = lowHPTargets[i].z })
										_G.tinsert(foundTargets,{ unit = lowHPTargets[k].unit,x = lowHPTargets[k].x,y = lowHPTargets[k].y,z = lowHPTargets[i].z })
									end
								end
							end
						end
					end
				end
			end
			local medX,medY,medZ = 0,0,0
			if foundTargets ~= nil and #foundTargets >= NumberOfPlayers then
				for i = 1,3 do
					medX = medX + foundTargets[i].x
					medY = medY + foundTargets[i].y
					medZ = medZ + foundTargets[i].z
				end
				medX,medY,medZ = medX/3,medY/3,medZ/3
				local myX,myY = br.GetObjectPosition("player")
				if math.sqrt(((medX-myX)^2)+((medY-myY)^2)) < 40 then
					br._G.CastSpellByName(_G.GetSpellInfo(SpellID),"target")
					br._G.ClickPosition(medX,medY,medZ,true)
					if SpellID == 145205 then br.shroomsTable[1] = { x = medX,y = medY,z = medZ} end
					return true
				end
			elseif lowHPTargets~=nil and #lowHPTargets==1 and lowHPTargets[1].unit=="player" then
				local myX,myY,myZ = br.GetObjectPosition("player")
				br._G.CastSpellByName(_G.GetSpellInfo(SpellID),"target")
				br._G.ClickPosition(myX,myY,myZ,true)
				if SpellID == 145205 then br.shroomsTable[1] = { x = medX,y = medY,z = medZ} end
				return true
			end
		end
	else
		return false
	end
end
--[[castSpell(Unit,SpellID,FacingCheck,MovementCheck,SpamAllowed,KnownSkip)
Parameter 	Value
First 	 	UnitID 			Enter valid UnitID
Second 		SpellID 		Enter ID of spell to use
Third 		Facing 			True to allow 360 degrees,false to use facing check
Fourth 		MovementCheck	True to make sure player is standing to cast,false to allow cast while moving
Fifth 		SpamAllowed 	True to skip that check,false to prevent spells that we dont want to spam from beign recast for 1 second
Sixth 		KnownSkip 		True to skip br.isKnown check for some spells that are not managed correctly in wow's spell book.
Seventh 	DeadCheck 		True to skip checking for dead units. (IE: Resurrection Spells)
Eigth 		DistanceSkip    True to skip range checking.
Ninth 		usableSkip 		True to skip usability checks.
Tenth 		noCast			True to return True/False instead of casting spell.
]]
-- castSpell("target",12345,true)
--                ( 1  ,    2  ,     3     ,     4       ,      5    ,   6     ,   7     ,    8       ,   9      ,  10  )
function br.castSpell(Unit,SpellID,FacingCheck,MovementCheck,SpamAllowed,KnownSkip,DeadCheck,DistanceSkip,usableSkip,noCast)
	if br.GetObjectExists(Unit) --and betterStopCasting(SpellID) ~= true
		and (not br.GetUnitIsDeadOrGhost(Unit) or DeadCheck)
	then
		-- we create an usableSkip for some specific spells like hammer of wrath aoe mode
		if usableSkip == nil then usableSkip = false end
		-- stop if not enough power for that spell
		if usableSkip ~= true and _G.IsUsableSpell(SpellID) ~= true then return false end
		-- Table used to prevent refiring too quick
		if br.timersTable == nil then br.timersTable = {}	end
		-- default noCast to false
		if noCast == nil then noCast = false end
		-- make sure it is a known spell
		if not (KnownSkip == true or br.isKnown(SpellID)) then return false end
		-- gather our spell range information
		local spellRange = select(6,_G.GetSpellInfo(SpellID))
		if DistanceSkip == nil then DistanceSkip = false end
		if spellRange == nil or (spellRange < 4 and DistanceSkip==false) then spellRange = 4 end
		if DistanceSkip == true then spellRange = 40 end
		-- Check unit,if it's player then we can skip facing
		if (Unit == nil or br.GetUnitIsUnit("player",Unit)) -- Player
			or (Unit ~= nil and br.GetUnitIsFriend("player",Unit))  -- Ally
			or br._G.IsHackEnabled("AlwaysFacing")
		then
			FacingCheck = true
		elseif br.isSafeToAttack(Unit) ~= true then -- enemy
			return false
		end
		-- if MovementCheck is nil or false then we dont check it
		if MovementCheck == false or br.isMoving("player") ~= true
			-- skip movement check during spiritwalkers grace and aspect of the fox
			or br.UnitBuffID("player",79206) ~= nil
		then
			-- if ability is ready and in range
            -- if br.getSpellCD(SpellID) < select(4,GetNetStats()) / 1000
			if (br.getSpellCD(SpellID) < select(4,_G.GetNetStats()) / 1000) and (br.getOptionCheck("Skip Distance Check") or br.getDistance("player",Unit) <= spellRange or DistanceSkip == true or br.inRange(SpellID,Unit)) then
				-- if spam is not allowed
				if SpamAllowed == false then
					-- get our last/current cast
					if br.timersTable == nil or (br.timersTable ~= nil and (br.timersTable[SpellID] == nil or br.timersTable[SpellID] <= _G.GetTime() -0.6)) then
						if (FacingCheck == true or br.getFacing("player",Unit) == true) and (br.GetUnitIsUnit("player",Unit) or br.units[Unit] ~= nil or br.getLineOfSight("player",Unit) == true) then
							if noCast then
								return true
							else
								br.timersTable[SpellID] = _G.GetTime()
								-- currentTarget = UnitGUID(Unit) -- Not Used
								br.botCast = true -- Used by old Queue Cast
								br.botSpell = SpellID -- Used by old Queue Cast
								br._G.CastSpellByName(_G.GetSpellInfo(SpellID),Unit)
								if br._G.IsAoEPending() then
									local X,Y,Z = br._G.ObjectPosition(Unit)
									br._G.ClickPosition(X,Y,Z)
								end
								--lastSpellCast = SpellID
								-- change main button icon
								--if br.getOptionCheck("Start/Stop BadRotations") then
									br.mainButton:SetNormalTexture(select(3,_G.GetSpellInfo(SpellID)))
									br.lastSpellCast = SpellID
									br.lastSpellTarget = br._G.UnitGUID(Unit)
								--end
								return true
							end
						end
					end
				elseif (FacingCheck == true or br.getFacing("player",Unit) == true) and (br.GetUnitIsUnit("player",Unit) or br.units[Unit] ~= nil or br.getLineOfSight("player",Unit) == true) then
					if noCast then
						return true
					else
						-- currentTarget = UnitGUID(Unit) -- Not Used
						br.botCast = true
						br.botSpell = SpellID
						br._G.CastSpellByName(_G.GetSpellInfo(SpellID),Unit)
						if br._G.IsAoEPending() then
							local X,Y,Z = br._G.ObjectPosition(Unit)
							br._G.ClickPosition(X,Y,Z)
						end
						--if br.getOptionCheck("Start/Stop BadRotations") then
							br.mainButton:SetNormalTexture(select(3,_G.GetSpellInfo(SpellID)))
							br.lastSpellCast = SpellID
							br.lastSpellTarget = br._G.UnitGUID(Unit)
						--end
						return true
					end
				end
			end
		end
	end
	return false
end

--[[castSpellMacro(Unit,SpellID,FacingCheck,MovementCheck,SpamAllowed,KnownSkip)
Parameter 	Value
First 	 	UnitID 			Enter valid UnitID
Second 		SpellID 		Enter ID of spell to use
Third 		Facing 			True to allow 360 degrees,false to use facing check
Fourth 		MovementCheck	True to make sure player is standing to cast,false to allow cast while moving
Fifth 		SpamAllowed 	True to skip that check,false to prevent spells that we dont want to spam from beign recast for 1 second
Sixth 		KnownSkip 		True to skip br.isKnown check for some spells that are not managed correctly in wow's spell book.
Seventh 	DeadCheck 		True to skip checking for dead units. (IE: Resurrection Spells)
Eigth 		DistanceSkip    True to skip range checking.
Ninth 		usableSkip 		True to skip usability checks.
Tenth 		noCast			True to return True/False instead of casting spell.
]]
-- castSpell("target",12345,true)
--                ( 1  ,    2  ,     3     ,     4       ,      5    ,   6     ,   7     ,    8       ,   9      ,  10  )
function br.castSpellMacro(Unit,SpellID,FacingCheck,MovementCheck,SpamAllowed,KnownSkip,DeadCheck,DistanceSkip,usableSkip,noCast)
	if br.GetObjectExists(Unit) and br.betterStopCasting(SpellID) ~= true
		and (not br.GetUnitIsDeadOrGhost(Unit) or DeadCheck) then
		-- we create an usableSkip for some specific spells like hammer of wrath aoe mode
		if usableSkip == nil then usableSkip = false end
		-- stop if not enough power for that spell
		if usableSkip ~= true and _G.IsUsableSpell(SpellID) ~= true then return false end
		-- Table used to prevent refiring too quick
		if br.timersTable == nil then br.timersTable = {}	end
		-- default noCast to false
		if noCast == nil then noCast = false end
		-- make sure it is a known spell
		if not (KnownSkip == true or br.isKnown(SpellID)) then return false end
		-- gather our spell range information
		local spellRange = select(6,_G.GetSpellInfo(SpellID))
		if DistanceSkip == nil then DistanceSkip = false end
		if spellRange == nil or (spellRange < 4 and DistanceSkip==false) then spellRange = 4 end
		if DistanceSkip == true then spellRange = 40 end
		-- Check unit,if it's player then we can skip facing
		if (Unit == nil or br.GetUnitIsUnit("player",Unit)) or -- Player
			(Unit ~= nil and br.GetUnitIsFriend("player",Unit)) then  -- Ally
			FacingCheck = true
		elseif br.isSafeToAttack(Unit) ~= true then -- enemy
			return false
		end
		-- if MovementCheck is nil or false then we dont check it
		if MovementCheck == false or br.isMoving("player") ~= true
			-- skip movement check during spiritwalkers grace and aspect of the fox
			or br.UnitBuffID("player",79206) ~= nil
		then
			-- if ability is ready and in range
            -- if br.getSpellCD(SpellID) < select(4,GetNetStats()) / 1000
			if (br.getSpellCD(SpellID) < select(4,_G.GetNetStats()) / 1000) and (br.getOptionCheck("Skip Distance Check") or br.getDistance("player",Unit) <= spellRange or DistanceSkip == true or br.inRange(SpellID,Unit)) then
				-- if spam is not allowed
				if SpamAllowed == false then
					-- get our last/current cast
					if br.timersTable == nil or (br.timersTable ~= nil and (br.timersTable[SpellID] == nil or br.timersTable[SpellID] <= _G.GetTime() -0.6)) then
						if (FacingCheck == true or br.getFacing("player",Unit) == true) and (br.GetUnitIsUnit("player",Unit) or br.getLineOfSight("player",Unit) == true) then
							if noCast then
								return true
							else
								br.timersTable[SpellID] = _G.GetTime()
								br.currentTarget = br._G.UnitGUID(Unit)
								br._G.RunMacroText("/cast [@"..Unit.."] ".._G.GetSpellInfo(SpellID))
								--lastSpellCast = SpellID
								-- change main button icon
								--if br.getOptionCheck("Start/Stop BadRotations") then
									br.mainButton:SetNormalTexture(select(3,_G.GetSpellInfo(SpellID)))
									br.lastSpellCast = SpellID
									br.lastSpellTarget = br._G.UnitGUID(Unit)
								--end
								return true
							end
						end
					end
				elseif (FacingCheck == true or br.getFacing("player",Unit) == true) and (br.GetUnitIsUnit("player",Unit) or br.getLineOfSight("player",Unit) == true) then
					if noCast then
						return true
					else
						br.currentTarget = br._G.UnitGUID(Unit)
						br._G.RunMacroText("/cast [@"..Unit.."] ".._G.GetSpellInfo(SpellID))
						--if br.getOptionCheck("Start/Stop BadRotations") then
							br.mainButton:SetNormalTexture(select(3,_G.GetSpellInfo(SpellID)))
							br.lastSpellCast = SpellID
							br.lastSpellTarget = br._G.UnitGUID(Unit)
						--end
						return true
					end
				end -- End Spam Check
			end -- End CD/Distance Check
		end -- End Movement check
	end
	return false
end
-- Used in openers
function br.castOpener(spellIndex,flag,index,checkdistance)
	local spellCast = br.player.spell[spellIndex]
	local castable = br.player.cast.able[spellIndex]
	local castSpell = br.player.cast[spellIndex]
	local spellName = select(1,br._G.GetSpellInfo(spellCast))
	local maxRange = select(6,br._G.GetSpellInfo(spellCast))
	local cooldown = br.player.cd[spellIndex].remain()
	if not maxRange or maxRange == 0 then maxRange = 5 end
	if checkdistance == nil then checkdistance = true end
	if not checkdistance or br.getDistance("target") < maxRange then
		if (not castable() and (cooldown == 0 or cooldown > br.player.gcdMax)) then
			br.castOpenerFail(spellName,flag,index)
	        -- Print(index..": "..spellName.." (Uncastable)");
	        -- _G[flag] = true;
			-- return true
	    else
			if castSpell() then
				if br.player.opener[flag] == nil then
					br._G.print(index..": "..spellName)
					br.player.opener[flag] = true
				elseif br.player.opener[flag] ~= true then
					br._G.print(index..": "..spellName)
					br.player.opener[flag] = true
				end
				return true
			end
	    end
	end
end
function br.castOpenerFail(spellName,flag,index)
	if br.player.opener[flag] == nil then
		br._G.print(index..": "..spellName.." (Uncastable)")
		br.player.opener[flag] = true
	elseif br.player.opener[flag] ~= true then
		br._G.print(index..": "..spellName.." (Uncastable)")
		br.player.opener[flag] = true
	end
	return true
end
function br.castMouseoverHealing(Class)
	if br._G.UnitAffectingCombat("player") then
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
			if br.GetUnitExists(target) and not br._G.UnitIsPlayer(target) then
				local npcID = tonumber(string.match(br._G.UnitGUID(target),"-(%d+)-%x+$"))
				for j = 1,#npcTable do
					if npcID == npcTable[j] then
						-- Dispel
						for n = 1,40 do
							local buff,_,count,bufftype,duration = br._G.UnitDebuff(target,n)
							if buff then
								if bufftype == "Magic" or bufftype == "Curse" or bufftype == "Poison" then
									if br.castSpell(target,88423,true,false) then
										return
									end
								end
							else
								break
							end
						end
						-- Heal
						local npcHP = br.getHP(target)
						if npcHP < 100 then
							if br.castSpell(target,spellTable[Class].heal,true) then
								return
							end
						end
					end
				end
			end
		end
	end
end
function br.isCastingTime(lagTolerance)
	lagTolerance = lagTolerance or 0
	if br._G.UnitCastingInfo("player") ~= nil then
		if select(5,br._G.UnitCastingInfo("player")) - _G.GetTime() <= lagTolerance then
			return true
		end
	elseif br._G.UnitChannelInfo("player") ~= nil then
		if select(5,br._G.UnitChannelInfo("player")) - _G.GetTime() <= lagTolerance then
			return true
		end
	elseif (_G.GetSpellCooldown(_G.GetSpellInfo(61304)) ~= nil and _G.GetSpellCooldown(_G.GetSpellInfo(61304)) <= lagTolerance) then
		return true
	else
		return false
	end
end
-- if getCastTime("Healing Touch")<3 then
function br.getCastTime(spellID)
	if spellID == 202767 then
		if select(3,_G.GetSpellInfo(202767)) == 1392545 then spellID = 202767
		elseif select(3,_G.GetSpellInfo(202767)) == 1392543 then spellID = 202768
        elseif select(3,_G.GetSpellInfo(202767)) == 1392542 then spellID = 202771
        end
    end
	local castTime = select(4,_G.GetSpellInfo(spellID))/1000
	return castTime
end
function br.getCastTimeRemain(unit)
	if br._G.UnitCastingInfo(unit) ~= nil then
		return select(5,br._G.UnitCastingInfo(unit))/1000 - _G.GetTime()
	elseif br._G.UnitChannelInfo(unit) ~= nil then
		return select(5,br._G.UnitChannelInfo(unit))/1000 - _G.GetTime()
	else
		return 0
	end
end
-- if isCasting() == true then
function br.castingUnit(Unit)
	if Unit == nil then Unit = "player" end
	if br._G.UnitCastingInfo(Unit) ~= nil
		or br._G.UnitChannelInfo(Unit) ~= nil
		or (_G.GetSpellCooldown(61304) ~= nil and _G.GetSpellCooldown(61304) > 0.001) then
		return true
	else
		return false
	end
end
-- if br.isCastingSpell(12345) == true then
function br.isCastingSpell(spellID,unit)
	if unit == nil then unit = "player" end
	local spellName = _G.GetSpellInfo(spellID)
	local spellCasting = br._G.UnitCastingInfo(unit)
	if spellCasting == nil then
		spellCasting = br._G.UnitChannelInfo(unit)
	end
	if tostring(spellCasting) == tostring(spellName) then
		return true
	else
		return false
	end
end
-- if isCasting(12345,"target") then
function br.isCasting(SpellID,Unit)
	if br.GetUnitIsVisible(Unit) and br._G.UnitCastingInfo(Unit) then
		if br._G.UnitCastingInfo(Unit) == _G.GetSpellInfo(SpellID) then
			return true
		end
	else
		return false
	end
end
-- if br.isCastingSpell(12345) == true then
function br.isUnitCasting(unit)
	if unit == nil then unit = "player" end
	local spellCasting = br._G.UnitCastingInfo(unit)
	if spellCasting == nil then
		spellCasting = br._G.UnitChannelInfo(unit)
	end
	if spellCasting ~= nil then
		return true
	else
		return false
	end
end

function br.createCastFunction(thisUnit,castType,minUnits,effectRng,spellID,index,predict,predictPad,enemies,debug)
    -- Invalid Spell ID Check
	if br._G.GetSpellInfo(spellID) == nil then br._G.print("Invalid Spell ID: "..spellID.." for key: "..index) end
    local spellCast = spellID
	local baseSpellID = br._G.FindBaseSpellByID(spellID)
	local overrideSpellID = br._G.FindSpellOverrideByID(spellID)
	local baseSpellName = br._G.GetSpellInfo(baseSpellID)
	local spellName,_,icon,castTime,minRange,maxRange = br._G.GetSpellInfo(spellID)
	local spellType = br.getSpellType(baseSpellName)
	if maxRange == 0 then _,_,_,_,minRange,maxRange = br._G.GetSpellInfo(baseSpellID) end
	-- Quaking helper - M+ Affix
	if br.getOptionCheck("Quaking Helper") then
		--Detect channels
		local channeledSpell = false
		local costTable = br._G.GetSpellPowerCost(spellID)
		for _, costInfo in pairs(costTable) do
			if costInfo.costPerSec > 0 then
				channeledSpell = true
			end
		end
		-- Quake check
		local quakeRemain = br.getDebuffRemain("player", 240448)
		if quakeRemain > 0 then
			if (castTime > 0 and quakeRemain <= ((castTime+300)/1000)) or (castTime == 0 and channeledSpell and quakeRemain < 1.5) then
				return false
			end
		end
	end
	--If we want to predict movement, include casttime, else 0 it
	if predict ~= nil then castTime = castTime / 1000 else castTime = 0 end
	if predictPad then
		castTime = castTime + predictPad
	end
	-- Nil Catches
	if castType == nil then castType = "norm" end
	if minUnits == nil then minUnits = 1 end
	if effectRng == nil then effectRng = 5 end
	if minRange == nil then minRange = 0 end
	if maxRange == nil or maxRange == 0 then maxRange = tonumber(effectRng) else maxRange = tonumber(maxRange) end
	if debug == nil then debug = false end
	-- We should already have enemies counts, so let's get them instead of calculating them again.
	if enemies == nil then
		if (castType == "norm" or castType == "pet") and br.player.enemies["yards"..effectRng.."f"] ~= nil then enemies = #br.player.enemies["yards"..effectRng.."f"] end
		if castType == "cone" and br.player.enemies["yards"..effectRng.."c"] ~= nil then enemies = #br.player.enemies["yards"..effectRng.."c"] end
		if castType == "rect" and br.player.enemies["yards"..effectRng.."r"] ~= nil then enemies = #br.player.enemies["yards"..effectRng.."r"] end
		if castType == "aoe" then
			if thisUnit == "player" and br.player.enemies["yards"..effectRng] ~= nil then
				enemies = #br.player.enemies["yards"..effectRng]
			elseif br.player.enemies["yards"..effectRng.."t"] ~= nil then
				enemies = #br.player.enemies["yards"..effectRng.."t"]
			end
		end
	end
	-- Lighter Cast Spell
	local function castingSpell(thisUnit, spellID, spellName, icon, castType, printReport, debug)
		if br._G.UnitHealth(thisUnit) > 0 or castType == "dead" then
			-- Debug Only
			if debug then return true end
			-- Cast Spell
			br.botCast = true -- Used by old Queue Cast
			br.botSpell = spellID -- Used by old Queue Cast
			-- Condemn Patch (Blizz is an small indie developer!)
			if spellID == br.player.spell.condemn or spellID == br.player.spell.condemnMassacre then spellName = br._G.GetSpellInfo(br.player.spell.execute) end
			br._G.CastSpellByName(spellName,thisUnit)
			if br._G.IsAoEPending() then
				local X,Y,Z = br._G.ObjectPosition(thisUnit)
				br._G.ClickPosition(X,Y,Z)
			end
			-- change main button icon
			br.mainButton:SetNormalTexture(icon)
			-- Update Last Cast
			br.lastSpellCast = spellID
			br.lastSpellTarget = br._G.UnitGUID(thisUnit)
			return true
		end
		return false
	end
	-- Talent Check
	local function hasTalent(spellID)
		for k,v in pairs(br.player.spell.talents) do
			if spellID == v then return br.player.talent[k] end
		end
		return true
	end
	-- Essence Check - BfA
	local function hasEssence()
		local essence = br.player.essence
		if essence[index] == nil then return true end
		if essence[index].id == nil then return true end
		return essence[index].active
	end
	-- Queen's Court - BfA
	local function queensCourtCastCheck(spellID)
		local queensCourtEncounter = br.UnitDebuffID("player",304409) -- EJ_GetEncounterInfo(2311)
		return queensCourtEncounter == nil or (queensCourtEncounter ~= nil and br.lastCastTable.tracker[1] ~= spellID)
	end
	-- Base Spell Availablility Check
	if (baseSpellID == spellID or overrideSpellID == spellID) and br._G.IsUsableSpell(spellID) and not select(2,br._G.IsUsableSpell(spellID)) -- Usability Checks
	 	and br.getSpellCD(spellID) <= br:getUpdateRate() and (br.getSpellCD(61304) <= 0 or select(2,br._G.GetSpellBaseCooldown(spellID)) <= 0
		 	or (br.getCastTime(spellID) > 0 and br.getCastTimeRemain("player") <= br:getUpdateRate())) -- Cooldown Checks
		and (br.isKnown(spellID) or castType == "known" or spellID == br.player.spell.condemn or spellID == br.player.spell.condemnMassacre) -- Known/Current Checks
	 	and hasTalent(spellID) and hasEssence() and not br.isIncapacitated(spellID) and queensCourtCastCheck(spellID)
		 	and not (br._G.IsAutoRepeatSpell(br._G.GetSpellInfo(spellID)) or (spellID == 6603 and br._G.IsCurrentSpell(spellID))) -- Talent/Essence/Incapacitated/Special Checks
	 	and (thisUnit == nil or castType ~= "dead" or (thisUnit ~= nil and castType == "dead" and br._G.UnitIsDeadOrGhost(thisUnit))) -- Dead Check
	then
		if castType == "known" then castType = "norm" end
		local function printReport(debugOnly,debugReason,thisCount)
			if debugReason == nil then debugReason = "" end
			if ((br.isChecked("Display Failcasts") and not debugOnly) or br.isChecked("Cast Debug")) and not debug then
				if debugReason == "No Unit" then
					br.player.ui.debug("Spell: "..spellName.." failed to cast because there was not unit found in "..maxRange.."yrds.")
				elseif debugReason == "Below Min Units" then
					br.player.ui.debug("Spell: "..spellName.." failed to cast because there are "..thisCount.." enemies in "..maxRange.."yrds, but "..minUnits.." are needed to cast.")
				elseif debugReason == "Below Min Units Facing" then
					br.player.ui.debug("Spell: "..spellName.." failed to cast because there are "..thisCount.." enemies in "..maxRange.."yrds in front, but "..minUnits.." are needed to cast.")
				elseif debugReason == "Below Min Units Cone" then
					br.player.ui.debug("Spell: "..spellName.." failed to cast because there are "..thisCount.." enemies in "..maxRange.."yrds in an "..effectRng.."deg cone, but "..minUnits.." are needed to cast.")
				elseif debugReason == "Below Min Units Rect" then
					br.player.ui.debug("Spell: "..spellName.." failed to cast because there are "..thisCount.." enemies in "..maxRange.."yrds by "..effectRng.."yrd rectange, but "..minUnits.." are needed to cast.")
				elseif debugReason == "Not Dead" then
					br.player.ui.debug("Spell: "..spellName.." failed to cast because Unit is not dead.")
				elseif debugReason == "No Range" then
					br.player.ui.debug("Spell: "..spellName.." failed to cast because Unit is not in range.")
				elseif debugReason == "Not Safe" then
					br.player.ui.debug("Spell: "..spellName.." failed to cast because it is not safe to aoe.")
				elseif debugReason == "Invalid Unit" then
					if not br._G.UnitIsFriend(thisUnit) and br.units[thisUnit] == nil then
						br.player.ui.debug("Spell: "..spellName.." failed to cast because Unit is not player, friend, or in br.units.")
					elseif not br.getLineOfSight(thisUnit) then
						br.player.ui.debug("Spell: "..spellName.." failed to cast because Unit is out line of sight.")
					else
						br.player.ui.debug("Spell: "..spellName.." failed to cast for unknown reason.")
					end
				else
					br._G.print("|cffFF0000Error: |r Failed to cast. - "
							.."Spell: "..spellName
							..", ID: "..spellID
							..", Type: "..spellType
							..", Min Range: "..minRange
							..", Max Range: "..maxRange
							..", Distance: "..br.getDistance(thisUnit)
							..", SpellRange: "..tostring(br._G.IsSpellInRange(spellName,thisUnit) == 1)
							..", thisUnit: "..tostring(thisUnit)
					)
				end
			end
			return false
		end
		-- Attempt to determine best unit for spell's range
		-- local unitAssigned = false
		if thisUnit == nil then
			if castType == "norm" or castType == "dead" or castType == "rect" or castType == "cone" then
				thisUnit = br.getSpellUnit(baseSpellID,false,minRange,maxRange,spellType)
			elseif castType == "groundCC" or "groundLocation" then return
			else
				thisUnit = br.getSpellUnit(baseSpellID,true,minRange,maxRange,spellType)
			end
			-- if thisUnit ~= nil and thisUnit ~= "None" then unitAssigned = true end
		end
		-- Cast Ground AOE at "Best" Locaton
        if thisUnit == "best" then
			if debug then return true end
			return br.castGroundAtBestLocation(spellCast,effectRng,minUnits,maxRange,minRange,castType,castTime)
		end
		-- Cast Ground AOE at Player/Target Location
		if thisUnit == "playerGround" or thisUnit == "targetGround" or castType == "groundCC" then
			local targetUnit
			targetUnit = thisUnit == "playerGround" and "player" or "target"
			if castType == "groundCC" then targetUnit = thisUnit end
			if (br._G.IsSpellInRange(spellName,targetUnit) == 1 or br.getDistance(targetUnit) < maxRange) then
				if debug then return true end
				return br.castGroundAtUnit(spellCast,effectRng,minUnits,maxRange,minRange,castType,targetUnit)
			end
		end
		-- Cast Ground AOE at Provide X/Y Location
		if thisUnit == "groundLocation" then
			if debug then return true end
			return br.castGroundLocation(castType,minUnits,baseSpellID,maxRange,minRange,effectRng)
		end
		if thisUnit == "None" then printReport(true,"No Unit") return false end
		-- Other Cast Conditions - Require Target
		if thisUnit ~= nil and thisUnit ~= "None"
			and (br.GetUnitIsUnit(thisUnit,"player") or br.GetUnitIsFriend(thisUnit,"player") or br.units[thisUnit] ~= nil or br.getLineOfSight(thisUnit))
		then
			-- Range Check
			local inRange = function(minRange, maxRange)
				local distance = castType == "pet" and br.getDistance(thisUnit,"pet") or br.getDistance(thisUnit)
				return distance >= minRange and distance < maxRange
			end
			if br._G.IsSpellInRange(spellName,thisUnit) == 1 or inRange(minRange,maxRange) then
				-- Dead Friend
				if castType == "dead" then
					if br._G.UnitIsPlayer(thisUnit) and br.GetUnitIsDeadOrGhost(thisUnit) and br.GetUnitIsFriend(thisUnit,"player") then
						return castingSpell(thisUnit,spellID,spellName,icon,castType,printReport,debug)
					else
						return printReport(false,"Not Dead")
					end
				end
				-- AOE/ST Casts
				-- Cast Ground/Cone/Rectangle/Player AOE
				if (castType == "ground" or castType == "aoe" or castType == "cone" or castType == "rect") then
					-- Failsafe, incase we were unable to retrieve enemies counts
					local enemyCount = enemies
						or ((castType == "ground" or castType == "aoe") and #br.getEnemies("player",maxRange))
						or (castType == "cone" and br.getEnemiesInCone(180,effectRng))
						or (castType == "rect" and br.getEnemiesInRect(effectRng,maxRange))
						or 0
					if enemyCount >= minUnits and br.isSafeToAoE(spellID,thisUnit,effectRng,minUnits,castType,enemyCount) then
						if castType == "ground" then
							if debug then return true end
							return br.castGround(thisUnit,spellCast,maxRange,minRange,effectRng,castTime)
						else
							return castingSpell(thisUnit,spellID,spellName,icon,castType,printReport,debug)
						end
					else
						return printReport(false,"Below Min Units",enemyCount)
					end
				end
				-- Cast Non-AOE
				if (castType == "norm" or castType == "pet") and ((castType == "norm" and br.getFacing("player",thisUnit)) or (castType == "pet" and br.getFacing("pet",thisUnit))
					or spellType == "Helpful" or spellType == "Unknown")
				then
					-- Failsafe, incase we were unable to retrieve enemies counts
					local enemyFacingCount = enemies or #br.getEnemies("player",maxRange,false,true) or 0
					if (minUnits == 1 and br._G.IsSpellInRange(spellName,thisUnit) == 1) or (enemyFacingCount >= minUnits) or spellType == "Helpful" or spellType == "Unknown" then
						return castingSpell(thisUnit,spellID,spellName,icon,castType,printReport,debug)
					else
						return printReport(false,"Below Min Units Facing",enemyFacingCount)
					end
				end
				return false
			else
				return printReport(false,"No Range")
			end
		else
			return printReport(false,"Invalid Unit")
		end
		return printReport()
    end
	return false
end

-- Cast Spell Queue
function br.castQueue()
	-- Catch for spells not registering on Combat log
	if br.player ~= nil then
		if br.player.queue ~= nil and #br.player.queue > 0 and not br._G.IsAoEPending() then
			for i=1, #br.player.queue do
				local thisUnit = br.player.queue[i].target
				local debug = br.player.queue[i].debug
				local minUnits = br.player.queue[i].minUnits
				local effectRng = br.player.queue[i].effectRng
				local spellID = br.player.queue[i].id
				if br.createCastFunction(thisUnit,debug,minUnits,effectRng,spellID) then return end
			end
		end
	end
	return
end
