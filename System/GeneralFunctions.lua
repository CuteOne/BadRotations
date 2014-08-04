
function UnitBuffID(unit, spellID, filter)
	local spellName = GetSpellInfo(spellID)
	if filter == nil then
		return UnitBuff(unit, spellName)
	else
		local exactSearch = strfind(strupper(filter), "EXACT")
		local playerSearch = strfind(strupper(filter), "PLAYER")
		if exactSearch then
			--using the index does not support filter.
			for i=1,40 do
				local _, _, _, _, _, _, _, buffCaster, _, _, buffSpellID = UnitBuff(unit, i)
				if buffSpellID ~= nil then
					if buffSpellID == spellID then
						if (not playerSearch) or (playerSearch and (buffCaster == "player")) then
							return UnitBuff(unit, i)
						end
					end
				else
					return nil
				end
			end
		else
			--just pass the filter to UnitBuff and return.
			return UnitBuff(unit, spellName, nil, filter)
		end
	end
end

function UnitDebuffID(unit, spellID, filter)
	local spellName = GetSpellInfo(spellID)
	if filter == nil then
		return UnitDebuff(unit, spellName)
	else
		local exactSearch = strfind(strupper(filter), "EXACT")
		local playerSearch = strfind(strupper(filter), "PLAYER")

		if exactSearch then
			--using the index does not support filter.
			for i=1,40 do
				local _, _, _, _, _, _, _, buffCaster, _, _, buffSpellID = UnitDebuff(unit, i)
				if buffSpellID ~= nil then
					if buffSpellID == spellID then
						if (not playerSearch) or (playerSearch and (buffCaster == "player")) then
							return UnitDebuff(unit, i)
						end
					end
				else
					return nil
				end
			end
		else
			--just pass the filter to UnitDebuff and return.
			return UnitDebuff(unit, spellName, nil, filter)
		end
	end
end

-- if canAttack("player","target") then
function canAttack(Unit1,Unit2)
	if UnitCanAttack("player","target") == 1 then
		return true;
	else
		return false;
	end
end

-- if canDispel("target",SpellID) == true then
function canDispel(Unit,spellID)
  	local HasValidDispel = false
  	local i = 1
  	local debuff = UnitDebuffID(Unit, i)
  	while debuff do
  		local debuffType = select(5, UnitDebuffID(Unit, i))
  		local debuffid = select(11, UnitDebuffID(Unit, i)) 
  		local ClassNum = select(3, UnitClass(Unit)) 	
  		local ValidDebuffType = false	
		if ClassNum == 1 then --Warrior

		end
		if ClassNum == 2 then --Paladin

		end
		if ClassNum == 3 then --Hunter

		end
		if ClassNum == 4 then --Rogue

		end
		if ClassNum == 9 then --Priest

		end
		if ClassNum == 9 then --Death Knight

		end
		if ClassNum == 9 then --Shaman
			-- Cleanse Spirit
			if spellID == 51886 and (debuffType == "Curse") then
				ValidDebuffType = true
			end
		end
		if ClassNum == 9 then --Mage

		end
		if ClassNum == 9 then --Warlock

		end
		if ClassNum == 10 then --Monk

  		end
		if ClassNum == 11 then --Druid  			
  			-- Remove Corruption
  			if spellID == 2782 and (debuffType == "Poison" or debuffType == "Curse") then
  				ValidDebuffType = true
  			end
  			-- Nature's Cure
  			if spellID == 88423 and (debuffType == "Poison" or debuffType == "Curse" or debuffType == "Magic") then
  				ValidDebuffType = true
  			end
  			-- Symbiosis: Cleanse
  			if spellID == 122288 and (debuffType == "Poison" or debuffType == "Disease") then
  				ValidDebuffType = true
  			end
  		end		
  		-- Blackout Debuffs
  		if ValidDebuffType
  			and debuffid ~= 138732 --Ionization from Jin'rokh the Breaker - ptr
			and debuffid ~= 138733 --Ionization from Jin'rokh the Breaker - live
		then
  			HasValidDispel = true
  		end
  		i = i + 1
  		debuff = UnitDebuffID(t, i)
  	end
	return HasValidDispel
end

-- if canHeal("target") then
function canHeal(Unit)
	if IExists(UnitGUID(Unit)) and getDistance(Unit) <= 40 and UnitCanCooperate("player",Unit) 
		and not UnitIsEnemy("player",Unit) and not UnitIsCharmed(Unit) and not UnitIsDeadOrGhost(Unit) 
		and getLineOfSight(Unit) == true and not UnitDebuffID(Unit,33786) then
		return true;
	end 
	return false;
end

-- canInterrupt(80965,20) or canInterrupt(80965,0) or canInterrupt(80965)
function canInterrupt(spellID,percentint)
    local unit = "target" or "mouseover"
    local castDuration = 0
    local castTimeRemain = 0
    local castPercent = 0
    local interruptable = false
    if UnitExists(unit)
        and UnitCanAttack("player", unit) == 1 
        and not UnitIsDeadOrGhost(unit)
        and getSpellCD(spellID) 
    then
        if select(6,UnitCastingInfo(unit)) ~= nil and select(9,UnitCastingInfo(unit)) ~= nil then
            castStartTime = select(5,UnitCastingInfo(unit))
            castEndTime = select(6,UnitCastingInfo(unit))
            interruptable = true
        elseif select(6,UnitChannelInfo(unit)) ~= nil and select(8,UnitChannelInfo(unit)) == nil then
            castStartTime = select(5,UnitChannelInfo(unit))
            castEndTime = select(6,UnitChannelInfo(unit))
            interruptable = true
        else
            castStartTime = 0
            castEndTime = 0
            interruptable = false
        end
        if castEndTime > 0 and castStartTime > 0 then
            castDuration = (castEndTime - castStartTime)/1000
            castTimeRemain = ((castEndTime/1000) - GetTime())
            if percentint == nil and castPercent == 0 then 
                castPercent = math.random(5, 95)
            elseif percentint == 0 and castPercent == 0 then
                castPercent = math.random(5, 95)
            elseif percentint > 0 then 
                castPercent = percentint 
            end
        else
            castDuration = 0
            castTimeRemain = 0
            castPercent = 0
        end
        if math.ceil((castTimeRemain/castDuration)*100) <= castPercent and interruptable == true then
            return true
        else
            return false
        end
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
	  	return false;
	else
	  	return true;
	end
end

-- if canRun() then
function canRun()
	if BadBoy_data['Pause'] ~= 1 then
		if BadBoy_data["Power"] == 1 and isAlive("player") then
			if SpellIsTargeting()
			  or UnitIsDeadOrGhost("player") ~= nil
			  or UnitBuffID("player",11392) ~= nil
			  or UnitBuffID("player",80169) ~= nil 
			  or UnitBuffID("player",87959) ~= nil
			  or UnitBuffID("player",104934) ~= nil then
				return false;
			else
				return true;
			end
		end
	else
		ChatOverlay("|cffFF0000-BadBoy Paused-")
		return false;
	end
end

-- if canUse(1710) then
function canUse(itemID)
	if GetItemCount(itemID,false,false) > 0 then 
		if select(2,GetItemCooldown(itemID))==0 then
			return true;
		else
			return false;
		end
	else
		return false;
	end
end

-- useItem(12345)
function useItem(itemID)
	if GetItemCount(itemID,false,false) > 0 then 
		if select(2,GetItemCooldown(itemID))==0 then
			RunMacroText("/use "..tostring(select(1,GetItemInfo(itemId))));
		else
			return false;
		end
	else
		return false;
	end
end

-- castGround("target",12345,40);
function castGround(Unit,SpellID,maxDistance)
	if IExists(UnitGUID(Unit)) and getSpellCD(SpellID) <= 0.4 and getLineOfSight("player", Unit) and getDistance("player", Unit) <= maxDistance then
 		CastSpellByName(GetSpellInfo(SpellID),"player");
		if AreaSpellIsPending() then
		local X, Y, Z = IGetLocation(UnitGUID(Unit));
			CastAtLocation(X,Y,Z);
			return true;
		end
 	end
 	return false;
end

function canCast(SpellID,KnownSkip)
  	if (KnownSkip == true or isKnown(SpellID)) and getSpellCD(SpellID) == 0 and not (UnitPower("player") < select(4,GetSpellInfo(SpellID))) 
   	  and (MovementCheck == false or GlobalCooldown == 0 or isMoving("player") ~= true or UnitBuffID("player",79206) ~= nil) then
      	return true;
    end
end

-- castSpell("target",12345,true);
function castSpell(Unit,SpellID,FacingCheck,MovementCheck,SpamAllowed,KnownSkip)
  	if type(Unit) ~= "String" then Unit = tostring(Unit); end
  	local GlobalCooldown = select(7, GetSpellInfo(SpellID));
  	if MovementCheck == nil then MovementCheck = true; end
  	if (Unit ~= nil and UnitIsFriend("player",Unit)) then FacingCheck = true; end
  	if not (UnitPower("player") < select(4,GetSpellInfo(SpellID))) 
   	  and (MovementCheck == false or GlobalCooldown == 0 or isMoving("player") ~= true or UnitBuffID("player",79206) ~= nil)
      and getSpellCD(SpellID) == 0 and (KnownSkip == true or isKnown(SpellID)) then
    	if GlobalCooldown == 0 and (SpamAllowed == nil or SpamAllowed == false) then
      		if timersTable == nil or (timersTable ~= nil and (timersTable[SpellID] == nil or timersTable[SpellID] <= GetTime() -0.6)) then
       			if Unit ~= nil and ((UnitGUID(Unit) == UnitGUID("player") or (KnownSkip or isKnown(SpellID)) and getLineOfSight("player",Unit) == true and (FacingCheck == true or getFacing("player",Unit)))) then
         			if timersTable == nil then timersTable = {}; end
        			timersTable[SpellID] = GetTime();
        			CastSpellByName(GetSpellInfo(SpellID),Unit);
        			return true;
    			end
       			if Unit == nil then
        			if timersTable == nil then timersTable = {}; end
        			timersTable[SpellID] = GetTime();
        			CastSpellByName(GetSpellInfo(SpellID));
        			return true;
       			end
			end
		elseif Unit ~= nil and (UnitGUID(Unit) == UnitGUID("player") 
	  		  or ((IsSpellInRange(GetSpellInfo(SpellID),Unit) == 1 or getDistance("target")<8) and getLineOfSight("player",Unit) == true
	  		  and (FacingCheck == true or getFacing("player",Unit)))) then
				CastSpellByName(GetSpellInfo(SpellID),Unit);
				return true;
		end
		if Unit == nil then
			CastSpellByName(GetSpellInfo(SpellID));
      		return true;
    	end
  	end
  	return false;
end


-- if getBuffRemain("target",12345) < 3 then
function getBuffRemain(Unit,BuffID)
	if UnitBuffID(Unit,BuffID) ~= nil then
		return (select(7,UnitBuffID(Unit,BuffID)) - GetTime());
	end
	return 0;
end

-- if getBuffStacks(138756) > 0 then
function getBuffStacks(unit,BuffID)
	if UnitBuffID(unit, BuffID) then
		return (select(7, UnitBuffID(unit, BuffID)) - GetTime())
	else
		return 0
	end
end

-- if getCombatTime() <= 5 then
function getCombatTime()
	local combatStarted = BadBoy_data["Combat Started"];
	local combatTime = BadBoy_data["Combat Time"];
	if combatStarted == nil then return 0; end
	if combatTime == nil then combatTime = 0; end
	if UnitAffectingCombat("player") == 1 then
		combatTime = (GetTime() - combatStarted);
	end
	if UnitAffectingCombat("player") == nil then
		combatTime = 0;
	end
	BadBoy_data["Combat Time"] = combatTime;
	return (math.floor(combatTime*1000)/1000);
end

--if getFallTime() > 2 then
function getFallTime()
	--local fallStarted = 0
	local fallTime = 0
	if IsFalling()~=nil then
		if fallStarted == 0 then
			fallStarted = GetTime()
		end
		if fallStarted ~= nil then fallTime = (math.floor((GetTime() - fallStarted)*1000)/1000); end
	end
	if IsFalling()==nil then
		fallStarted = 0
		fallTime = 0
	end
	return fallTime
end


-- if getCombo() >= 1 then
function getCombo()
	return GetComboPoints("player");
end

-- if getCreatureType(Unit) == true then
function getCreatureType(Unit)
	local CreatureTypeList = {"Critter", "Totem", "Non-combat Pet", "Wild Pet"}
	for i=1, #CreatureTypeList do
		if UnitCreatureType(Unit) == CreatureTypeList[i] then return false; end
	end
	if not UnitIsBattlePet(Unit) and not UnitIsWildBattlePet(Unit) then return true; else return false; end
end

-- if getDebuffRemain("target",12345) < 3 then
function getDebuffRemain(Unit,DebuffID)
	if UnitDebuffID(Unit,DebuffID,"player") ~= nil then
		return (select(7,UnitDebuffID(Unit,DebuffID,"player")) - GetTime());
	end
	return 0;
end

-- if getDebuffStacks("target",138756) > 0 then
function getDebuffStacks(Unit,DebuffID)
	if UnitDebuffID(Unit, DebuffID, "player") then
		return (select(7, UnitDebuffID(Unit, DebuffID, "player")) - GetTime());
	else
		return 0;
	end
end

-- if getDistance("player","target") <= 40 then
function getDistance(Unit1,Unit2)
	if Unit2 == nil then Unit2 = "player"; end
	if IExists(UnitGUID(Unit1)) and IExists(UnitGUID(Unit2)) then
		local X1,Y1,Z1 = IGetLocation(UnitGUID(Unit1));
		local X2,Y2,Z2 = IGetLocation(UnitGUID(Unit2));
		local unitSize = 0;
		if UnitGUID(Unit1) ~= UnitGUID("player") then 
			unitSize = IGetFloatDescriptor(UnitGUID(Unit1),0x110); 
		end
		if UnitGUID(Unit2) ~= UnitGUID("player") then 
			unitSize = IGetFloatDescriptor(UnitGUID(Unit2),0x110); 
		end
		return math.sqrt(((X2-X1)^2)+((Y2-Y1)^2)+((Z2-Z1)^2))-unitSize;
	else 
		return 1000;
	end
end

-- if getFacing("target","player") == false then
function getFacing(Unit1,Unit2)
	if Unit2 == nil then Unit2 = "player"; end
	if IExists(UnitGUID(Unit1)) and IExists(UnitGUID(Unit2)) then
		local X1,Y1,Z1,Angle1 = IGetLocation(UnitGUID(Unit1));
		local X2,Y2 = IGetLocation(UnitGUID(Unit2));
		if ((X1-X2)*math.cos(-Angle1))-((Y1-Y2)*math.sin(-Angle1)) < 0 then
			return true;
		else
			return false;
		end
	else
		return false;
	end
end

-- if getHP("player") then
function getHP(Unit)
	return 100 * UnitHealth(Unit) / UnitHealthMax(Unit); 
end

-- if getMana("target") <= 15 then 
function getMana(Unit)
	return 100 * UnitPower(Unit,0) / UnitPowerMax(Unit,0); 
end

-- if getPower("target") <= 15 then 
function getPower(Unit)
	local value = 100 * UnitPower(Unit,3) / UnitPowerMax(Unit,3)
	if _MyClass == 11 and UnitBuffID("player",106951) then value = value*2 end
	return value; 
end

-- Dem Bleeds
-- In a run once environment we shall create the Tooltip that we will be reading
-- all of the spell details from
nGTT = CreateFrame( "GameTooltip", "MyScanningTooltip", nil, "GameTooltipTemplate" );
nGTT:SetOwner( WorldFrame, "ANCHOR_NONE" );
nGTT:AddFontStrings(nGTT:CreateFontString( "$parentTextLeft1", nil, "GameTooltipText" ),nGTT:CreateFontString( "$parentTextRight1", nil, "GameTooltipText" ) );
function nDbDmg(tar, spellID, player)
   	if GetCVar("DotDamage") == nil then
      	RegisterCVar("DotDamage", 0)
   	end
   	nGTT:ClearLines()
   	for i=1, 40 do
      	if UnitDebuff(tar, i, player) == GetSpellInfo(spellID) then
         	nGTT:SetUnitDebuff(tar, i, player)
         	scanText=_G["MyScanningTooltipTextLeft2"]:GetText()
         	local DoTDamage = scanText:match("([0-9]+%.?[0-9]*)")
   			--if not issecure() then print(issecure()) end -- function is called inside the profile
         	SetCVar("DotDamage", tonumber(DoTDamage))
         	return tonumber(GetCVar("DotDamage"))
      	end
   	end
end

function getTotem(Target,Radius)
	local totemsTable = { };
 	for i=1, GetTotalObjects(TYPE_UNIT) do
  		local Guid = IGetObjectListEntry(i);
  		ISetAsUnitID(Guid,"thisUnit");
		if getDistance(Target,"thisUnit") <= ((Radius + IGetFloatDescriptor(Guid,0x110))) then
			local X1,Y1,Z1 = IGetLocation(Guid);
			activeTotem = { guid = Guid, x = X1, y = Y1, z = Z1 };
			break;
		end
 	end
end

--/dump TraceLine()
-- /dump getTotemDistance("target")
function getTotemDistance(Unit1)
	if Unit1 == nil then Unit1 = "player"; end
	if activeTotem ~= nil and IExists(UnitGUID(Unit1)) and IExists(activeTotem) then
		local X1,Y1,Z1 = IGetLocation(UnitGUID(Unit1));
		local X2,Y2,Z2 = IGetLocation(activeTotem);
		if TraceLine(X1,Y1,Z1 + 2,X2,Y2,Z2 + 1, 0x10) == nil then 
			local unitSize = IGetFloatDescriptor(UnitGUID(Unit1),0x110); 
			return math.sqrt(((X2-X1)^2)+((Y2-Y1)^2)+((Z2-Z1)^2))-unitSize;
		else
			return 1000;
		end
	else 
		return 1000;
	end
end

-- /dump UnitGUID("target")
-- /dump getEnnemies("target",10)
-- if #getEnnemies("target",10) >= 3 then
function getEnnemies(Target,Radius)
	local ennemiesTable = {};
 	for i=1, GetTotalObjects(TYPE_UNIT) do
  		local Guid = IGetObjectListEntry(i);
  		ISetAsUnitID(Guid,"thisUnit");
  		if tonumber(string.sub(tostring(Guid), 5,5)) == 3 or isDummy("thisUnit") then
	  		if CheckCreatureType("thisUnit") == true then
	  			if UnitCanAttack("player","thisUnit") and not UnitIsDeadOrGhost("thisUnit") then
	  				if getDistance(Target,"thisUnit") <= ((Radius + IGetFloatDescriptor(Guid,0x110))) then
	  					GetLocation()
	   					tinsert(ennemiesTable,Guid);
	   				end
	  			end
	  		end
  		end
 	end
 	return ennemiesTable;
end

-- if getNumEnnemies("target",10) >= 3 then
function getNumEnnemies(Target,Radius)
  	local Units = 0;
  	local function CheckCreatureType(tar)
		local CreatureTypeList = {"Critter", "Totem", "Non-combat Pet", "Wild Pet"}
		for i=1, #CreatureTypeList do
			if UnitCreatureType(tar) == CreatureTypeList[i] then return false end
		end
		if not UnitIsBattlePet(tar) and not UnitIsWildBattlePet(tar) then return true else return false end
	end
 	for i=1,GetTotalObjects(TYPE_UNIT) do
  		local Guid = IGetObjectListEntry(i);
 	  	ISetAsUnitID(Guid,"thisUnit");
 	  	if tonumber(string.sub(tostring(Guid), 5,5)) == 3 or isDummy("thisUnit") then
	  		if CheckCreatureType("thisUnit") == true then
	  			if UnitCanAttack("player","thisUnit") and not UnitIsDeadOrGhost("thisUnit") then
	  				if getDistance(Target,"thisUnit") <= ((Radius + IGetFloatDescriptor(Guid,0x110))) then
	  					Units = Units+1;
	   				end
		 		end
		 	end
	 	end
 	end
 	return Units;
end

-- if getLineOfSight("target"[,"target"]) then
function getLineOfSight(Unit1,Unit2)
	if Unit2 == nil then if Unit1 == "player" then Unit2 = "target"; else Unit2 = "player"; end end
	if IExists(UnitGUID(Unit1)) and IExists(UnitGUID(Unit2)) then
		local X1,Y1,Z1 = IGetLocation(UnitGUID(Unit1));
		local X2,Y2,Z2 = IGetLocation(UnitGUID(Unit2));
		if TraceLine(X1,Y1,Z1 + 2,X2,Y2,Z2 + 2, 0x10) == nil then return true; else return false; end
	else return true;
	end
end

-- if getGround("target"[,"target"]) then
function getGround(Unit)
	if IExists(UnitGUID(Unit)) then
		local X1,Y1,Z1 = IGetLocation(UnitGUID(Unit));
		if TraceLine(X1,Y1,Z1,X1,Y1,Z1-2, 0x100) == nil then return false; else return true; end
	else 
		return false;
	end
end

-- if getPetLineOfSight("target"[,"target"]) then
function getPetLineOfSight(Unit)
	if IExists(UnitGUID("pet")) and IExists(UnitGUID(Unit)) then
		local X1,Y1,Z1 = IGetLocation(UnitGUID("pet"));
		local X2,Y2,Z2 = IGetLocation(UnitGUID(Unit));
		if TraceLine(X1,Y1,Z1 + 2,X2,Y2,Z2 + 2, 0x10) == nil then return true; else return false; end
	else return true;
	end
end

-- if getBuffStacks(138756) > 0 then
function getBuffStacks(unit,spellID)
	if UnitBuffID(unit, spellID) then
		return (select(7, UnitBuffID(unit, spellID)) - GetTime())
	else
		return 0
	end
end

-- if getDebuffStacks(138756) > 0 then
function getDebuffStacks(unit,spellID)
	if UnitDebuffID(unit, spellID, "player") then
		return (select(7, UnitDebuffID(unit, spellID, "player")) - GetTime())
	else
		return 0
	end
end

-- if getSpellCD(12345) <= 0.4 then
function getSpellCD(SpellID)
	if GetSpellCooldown(SpellID) == 0 then
		return 0
	else
		local Start ,CD = GetSpellCooldown(SpellID);
		local MyCD = Start + CD - GetTime();
		return MyCD;
	end
end

--- Round
function round2(num, idp)
  mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

-- if getTimeToDie("target") >= 6 then
function getTimeToDie(unit)
	unit = unit or "target";
	if thpcurr == nil then thpcurr = 0; end
	if thpstart == nil then thpstart = 0; end
	if timestart == nil then timestart = 0; end
	if UnitExists(unit) and not UnitIsDeadOrGhost(unit) then
		if currtar ~= UnitGUID(unit) then
			priortar = currtar;
			currtar = UnitGUID(unit);
		end
		if thpstart == 0 and timestart == 0 then
			thpstart = UnitHealth(unit);
			timestart = GetTime();
		else
			thpcurr = UnitHealth(unit);
			timecurr = GetTime();
			if thpcurr >= thpstart then
				thpstart = thpcurr;
				timeToDie = 999;
			else
				if ((timecurr - timestart)==0) or ((thpstart - thpcurr)==0) then
					timeToDie = 999;
				else
					timeToDie = round2(thpcurr/((thpstart - thpcurr) / (timecurr - timestart)),2);
				end
			end
		end
	elseif not UnitExists(unit) or currtar ~= UnitGUID(unit) then
		currtar = 0; 
		priortar = 0;
		thpstart = 0;
		timestart = 0;
		timeToDie = 0;
	end
	if timeToDie==nil then
		return 999
	else
		return timeToDie
	end
end

-- if getTimeToMax("player") < 3 then
function getTimeToMax(Unit)
  	local max = UnitPowerMax(Unit);
  	local curr = UnitPower(Unit);
  	local regen = select(2, GetPowerRegen(Unit));
  	if select(3, UnitClass("player")) == 11 and GetSpecialization() == 2 and isKnown(114107) then
   		curr2 = curr + 4*getCombo()
  	else
   		curr2 = curr
  	end
  	return (max - curr2) * (1.0 / regen);
end

-- if getRegen("player") > 15 then
function getRegen(Unit)
	local regen = select(2, GetPowerRegen(Unit));
	return 1.0 / regen;
end

-- if isAlive([Unit]) == true then
function isAlive(Unit)
	local Unit = Unit or "target";
	if UnitIsDeadOrGhost(Unit) == nil then
		return true;
	else
		return false;
	end
end


------Boss Check------
for x=1,5 do
    if UnitExists("boss1") then
        boss1 = tonumber(UnitGUID("boss1"):sub(6,10), 16)
    else
        boss1 = 0
    end
    if UnitExists("boss2") then
        boss2 = tonumber(UnitGUID("boss2"):sub(6,10), 16)
    else
        boss2 = 0
    end
    if UnitExists("boss3") then
        boss3 = tonumber(UnitGUID("boss3"):sub(6,10), 16)
    else
        boss3 = 0
    end
    if UnitExists("boss4") then
        boss4 = tonumber(UnitGUID("boss4"):sub(6,10), 16)
    else
        boss4 = 0
    end
    if UnitExists("boss5") then
        boss5 = tonumber(UnitGUID("boss5"):sub(6,10), 16)
    else
        boss5 = 0
    end
end     
BossUnits = {
    -- Cataclysm Dungeons --
    -- Abyssal Maw: Throne of the Tides
    40586,      -- Lady Naz'jar
    40765,      -- Commander Ulthok
    40825,      -- Erunak Stonespeaker
    40788,      -- Mindbender Ghur'sha
    42172,      -- Ozumat
    -- Blackrock Caverns
    39665,      -- Rom'ogg Bonecrusher
    39679,      -- Corla, Herald of Twilight
    39698,      -- Karsh Steelbender
    39700,      -- Beauty
    39705,      -- Ascendant Lord Obsidius
    -- The Stonecore
    43438,      -- Corborus
    43214,      -- Slabhide
    42188,      -- Ozruk
    42333,      -- High Priestess Azil
    -- The Vortex Pinnacle
    43878,      -- Grand Vizier Ertan
    43873,      -- Altairus
    43875,      -- Asaad
    -- Grim Batol
    39625,      -- General Umbriss
    40177,      -- Forgemaster Throngus
    40319,      -- Drahga Shadowburner
    40484,      -- Erudax
    -- Halls of Origination
    39425,      -- Temple Guardian Anhuur
    39428,      -- Earthrager Ptah
    39788,      -- Anraphet
    39587,      -- Isiset
    39731,      -- Ammunae
    39732,      -- Setesh
    39378,      -- Rajh
    -- Lost City of the Tol'vir
    44577,      -- General Husam
    43612,      -- High Prophet Barim
    43614,      -- Lockmaw
    49045,      -- Augh
    44819,      -- Siamat
    -- Zul'Aman
    23574,      -- Akil'zon
    23576,      -- Nalorakk
    23578,      -- Jan'alai
    23577,      -- Halazzi
    24239,      -- Hex Lord Malacrass
    23863,      -- Daakara
    -- Zul'Gurub
    52155,      -- High Priest Venoxis
    52151,      -- Bloodlord Mandokir
    52271,      -- Edge of Madness
    52059,      -- High Priestess Kilnara
    52053,      -- Zanzil
    52148,      -- Jin'do the Godbreaker
    -- End Time
    54431,      -- Echo of Baine
    54445,      -- Echo of Jaina
    54123,      -- Echo of Sylvanas
    54544,      -- Echo of Tyrande
    54432,      -- Murozond
    -- Hour of Twilight
    54590,      -- Arcurion
    54968,      -- Asira Dawnslayer
    54938,      -- Archbishop Benedictus
    -- Well of Eternity
    55085,      -- Peroth'arn
    54853,      -- Queen Azshara
    54969,      -- Mannoroth
    55419,      -- Captain Varo'then
    
    -- Mists of Pandaria Dungeons --
    -- Scarlet Halls
    59303,      -- Houndmaster Braun
    58632,      -- Armsmaster Harlan
    59150,      -- Flameweaver Koegler
    -- Scarlet Monastery
    59789,      -- Thalnos the Soulrender
    59223,      -- Brother Korloff
    3977,       -- High Inquisitor Whitemane
    60040,      -- Commander Durand
    -- Scholomance
    58633,      -- Instructor Chillheart
    59184,      -- Jandice Barov
    59153,      -- Rattlegore
    58722,      -- Lilian Voss
    58791,      -- Lilian's Soul
    59080,      -- Darkmaster Gandling
    -- Stormstout Brewery
    56637,      -- Ook-Ook
    56717,      -- Hoptallus
    59479,      -- Yan-Zhu the Uncasked
    -- Tempe of the Jade Serpent
    56448,      -- Wise Mari
    56843,      -- Lorewalker Stonestep
    59051,      -- Strife
    59726,      -- Peril
    58826,      -- Zao Sunseeker
    56732,      -- Liu Flameheart
    56762,      -- Yu'lon
    56439,      -- Sha of Doubt
    -- Mogu'shan Palace
    61444,      -- Ming the Cunning
    61442,      -- Kuai the Brute
    61445,      -- Haiyan the Unstoppable
    61243,      -- Gekkan
    61398,      -- Xin the Weaponmaster
    -- Shado-Pan Monastery
    56747,      -- Gu Cloudstrike
    56541,      -- Master Snowdrift
    56719,      -- Sha of Violence
    56884,      -- Taran Zhu
    -- Gate of the Setting Sun
    56906,      -- Saboteur Kip'tilak
    56589,      -- Striker Ga'dok
    56636,      -- Commander Ri'mok
    56877,      -- Raigonn
    -- Siege of Niuzao Temple
    61567,      -- Vizier Jin'bak
    61634,      -- Commander Vo'jak
    61485,      -- General Pa'valak
    62205,      -- Wing Leader Ner'onok

    -- Training Dummies --
    46647,      -- Level 85 Training Dummy
    67127,      -- Level 90 Training Dummy
    
    -- Instance Bosses --
    boss1,  --Boss 1
    boss2,  --Boss 2    
    boss3,  --Boss 3
    boss4,  --Boss 4
    boss5,  --Boss 5
}

-- isBoss()
function isBoss()
    local BossUnits = BossUnits
    
    if UnitExists("target") then
        local npcID = tonumber(UnitGUID("target"):sub(6,10), 16)
        
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
function isBuffed(UnitID,SpellID,TimeLeft) 
  	if not TimeLeft then TimeLeft = 0 end
  	--if type(SpellID) == "number" then SpellID = { SpellID } end 
	for i=1,#SpellID do 
		local spell = tostring(GetSpellInfo(SpellID[i]))
		if spell then
			local buff = select(7,UnitBuff(UnitID,spell)) 
			if buff ~= nil and ( buff == 0 or buff - GetTime() > TimeLeft ) then return true end
		end
	end
end

-- Dummy Check
function isDummy(Unit)
	if Unit == nil then Unit = "target"; else Unit = tostring(Unit) end
    dummies = {
        31146, --Raider's Training Dummy - Lvl ??
        67127, --Training Dummy - Lvl 90
        60197, --Scarlet Monastery Dummy
        46647, --Training Dummy - Lvl 85
        32546, --Ebon Knight's Training Dummy - Lvl 80
        31144, --Training Dummy - Lvl 80
        32667, --Training Dummy - Lvl 70
        32542, --Disciple's Training Dummy - Lvl 65
        32666, --Training Dummy - Lvl 60
        32545, --Initiate's Training Dummy - Lvl 55 
        32541, --Initiate's Training Dummy - Lvl 55 (Scarlet Enclave) 
    }
    for i=1, #dummies do
        if UnitExists(Unit) then
            dummyID = tonumber(UnitGUID(Unit):sub(-13, -9), 16)
        else
            dummyID = 0
        end
        if dummyID == dummies[i] then
            return true
        end 
    end
end

-- if isEnnemy([Unit])
function isEnnemy(Unit)
	local Unit = Unit or "target";
	if UnitCanAttack("player",Unit) == 1 then
		return true;
	else
		return false;
	end
end

--if isGarrMCd() then
function isGarrMCd()
	if UnitExists("target") 
		and (UnitDebuffID("target",145832)
            or UnitDebuffID("target",145171)
            or UnitDebuffID("target",145065)
            or UnitDebuffID("target",145071))
    then 
		return true
	else 
		return false 
	end
end

-- if isKnown(106832) then
function isKnown(spellID)
  local	spellName = GetSpellInfo(spellID)
  if GetSpellBookItemInfo(spellName)~=nil then
    return true
  end
  return false
end

-- if isCasting() == true then
function isCasting(Unit)
	if Unit == nil then Unit = "player" end
	if UnitCastingInfo(Unit) ~= nil
	  or UnitChannelInfo(Unit) ~= nil 
	  or (GetSpellCooldown(GetSpellInfo(61304)) ~= nil and GetSpellCooldown(GetSpellInfo(61304)) > 0.001) then 
	  	return true; else return false; 
	end
end

-- if isLooting() then
function isLooting()
	if GetNumLootItems() > 0 then
		return true
	else
		return false
	end
end

-- if isValidTarget("target") then
function isValidTarget(Unit)
	if UnitIsEnemy("player",Unit) then
		if UnitExists(Unit) and not UnitIsDeadOrGhost(Unit) then return true; else return false; end
	else
		if UnitExists(Unit) then return true; else return false; end
	end
end

-- if not isMoving("target") then
function isMoving(Unit)
	if GetUnitSpeed(Unit) > 0 then return true; else return false; end
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

-- if isInCombat("target") then
function isInCombat(Unit)
	if UnitAffectingCombat(Unit) then return true; else return false; end
end

-- if isInMelee() then
function isInMelee(Unit)
	if Unit == nil then Unit = "target"; end
	if getDistance(Unit) < 4 then return true; else return false; end
end

-- if IsInPvP() then
function isInPvP()
	local inpvp = GetPVPTimer()
	if inpvp ~= 301000 and inpvp ~= -1 then
		return true;
	else
		return false;
	end
end

-- if isSpellInRange(12345,"target") then
function isSpellInRange(SpellID,Unit)
	if IExists(UnitGUID(Unit)) then
		if IsSpellInRange(tostring(GetSpellInfo(SpellID)),Unit) == 1 then return true; end
	else 
		return false;
	end
end





function IsCastingSpell(spellID)
	local spellName = GetSpellInfo(spellID)
	local spellCasting = UnitCastingInfo("player")

	if spellCasting == nil then
		spellCasting = UnitChannelInfo("player")
	end
	if spellCasting == spellName then
		return true
	else
		return false
	end
end

function hasGlyph(glyphid)
 	for i=1, 6 do
  		if select(4, GetGlyphSocketInfo(i)) == glyphid then return true; end
 	end
 	return false;
end

function hasNoControl(spellID)
	local eventIndex = C_LossOfControl.GetNumEvents()
	while (eventIndex > 0) do
		local _, _, text = C_LossOfControl.GetEventInfo(eventIndex)
	-- Warrior
		if select(3, UnitClass("player")) == 1 then

		end
	-- Paladin
		if select(3, UnitClass("player")) == 2 then

		end
	-- Hunter
		if select(3, UnitClass("player")) == 3 then
			if text == LOSS_OF_CONTROL_DISPLAY_ROOT or text == LOSS_OF_CONTROL_DISPLAY_SNARE then
				return true
			end
		end
	-- Rogue
		if select(3, UnitClass("player")) == 4 then

		end
	-- Priest
		if select(3, UnitClass("player")) == 5 then

		end
	-- Death Knight
		if select(3, UnitClass("player")) == 6 then

		end
	-- Shaman
		if select(3, UnitClass("player")) == 7 then
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
		if select(3, UnitClass("player")) == 8 then

		end
	-- Warlock
		if select(3, UnitClass("player")) == 9 then

		end
	-- Monk
		if select(3, UnitClass("player")) == 10 then
			if text == LOSS_OF_CONTROL_DISPLAY_STUN or text == LOSS_OF_CONTROL_DISPLAY_FEAR or text == LOSS_OF_CONTROL_DISPLAY_ROOT or text == LOSS_OF_CONTROL_DISPLAY_HORROR then
				return true
			end
		end
	-- Druid
		if select(3, UnitClass("player")) == 11 then
			if text == LOSS_OF_CONTROL_DISPLAY_ROOT or text == LOSS_OF_CONTROL_DISPLAY_SNARE then
				return true
			end
		end
		eventIndex = eventIndex - 1
	end
	return false
end

-- if pause() then
function pause() --Pause
	if (IsLeftAltKeyDown() == 1 and GetCurrentKeyBoardFocus() == nil)
		or IsMounted()
		or SpellIsTargeting()
		or not UnitExists("target")
		or UnitCastingInfo("player")
		or UnitChannelInfo("player")
		or UnitIsDeadOrGhost("player")
		or UnitIsDeadOrGhost("target")
		or UnitBuffID("player",80169) -- Eating
		or UnitBuffID("player",87959) -- Drinking
		or UnitBuffID("target",117961) --Impervious Shield - Qiang the Merciless
		or UnitDebuffID("player",135147) --Dead Zone - Iron Qon: Dam'ren
		or (((UnitHealth("target")/UnitHealthMax("target"))*100) > 10 and UnitBuffID("target",143593)) --Defensive Stance - General Nagrazim
		or UnitBuffID("target",140296) --Conductive Shield - Thunder Lord / Lightning Guardian
	then 
		return true; 
	else
		return false;
	end
end

-- Adaptation of Xelper(PQR)'s Interrupt
function Interrupts()
	if BadBoy_data["Check Interrupts"] ~= true then return false; end
	local _MyInterruptValue = BadBoy_data["Box Interrupts"];
	if RandomInterrupt == nil then RandomInterrupt = math.random(45,75); end
	function InterruptSpell()
		local MyClass = UnitClass("player");
		--Warrior
		if MyClass == 1 and GetSpellInfo(6552) ~= nil and getSpellCD(6552) == 0 then return 6552;	
		-- Paladin		
		elseif MyClass == 2 and GetSpellInfo(96231) ~= nil and getSpellCD(96231) == 0 then return 96231;
		-- Hunter
		elseif MyClass == 3 and GetSpellInfo(147362) ~= nil and getSpellCD(147362) == 0 then return 147362;			
		-- Rogue
		elseif MyClass == 4 and GetSpellInfo(1766) ~= nil and getSpellCD(1766) == 0 then return 1766;
		-- Priest
		elseif MyClass == 5 and GetSpecialization("player") == 3 and GetSpellInfo(15487) ~= nil and getSpellCD(15487) == 0 then return 15487;
		-- DeathKnight	
		elseif MyClass == 6 and GetSpellInfo(80965) ~= nil and getSpellCD(80965) == 0 then return 47528;
		-- Shaman 
		elseif MyClass == 7 and GetSpellInfo(57994) ~= nil and getSpellCD(57994) == 0 then return 57994;
		-- Mage
		elseif MyClass == 8 and GetSpellInfo(2139) ~= nil and getSpellCD(2139) == 0 then return 2139;
		-- Warlock
		elseif MyClass == 9 and IsSpellKnown(19647) ~= nil and getSpellCD(19647) == 0 then return 19647;
		-- Monk 
		elseif MyClass == 10 and GetSpellInfo(116705) ~= nil and getSpellCD(116705) == 0 then return 116705;	
		-- Druid
		elseif MyClass == 11 and UnitBuffID("player", 768) ~= nil and IsPlayerSpell(80965) ~= nil and getSpellCD(80965) == 0 then return 80965;
		elseif MyClass == 11 and UnitBuffID("player", 5487) ~= nil and IsPlayerSpell(80964) ~= nil and getSpellCD(80964) == 0 then return 80964;
		elseif MyClass == 11 and GetSpecialization("player") == 1 then return 78675;
		else return 0; end   
	end   
	local interruptSpell = InterruptSpell();
	local interruptName = GetSpellInfo(interruptSpell);
	-- Interrupt Casts and Channels on Target and Focus.
	if interruptSpell ~= 0 then
		if UnitExists("target") == 1 then
			local customTarget = "target";
			local castName, _, _, _, castStartTime, castEndTime, _, _, castInterruptable = UnitCastingInfo(customTarget);
			local channelName, _, _, _, channelStartTime, channelEndTime, _, channelInterruptable = UnitChannelInfo(customTarget);
			if channelName ~= nil then
				--target is channeling a spell that is interruptable
				--load the channel variables into the cast variables to make logic a little easier.
				castName = channelName;
				castStartTime = channelStartTime;
				castEndTime = channelEndTime;
				castInterruptable = channelInterruptable;
				PQR_InterruptPercent = 0;
				IsChannel = true;
			end
			if castInterruptable == false then castInterruptable = true; else castInterruptable = false; end	
			if castInterruptable then
			  	local timeSinceStart = (GetTime() * 1000 - castStartTime) / 1000;
				local timeLeft = ((GetTime() * 1000 - castEndTime) * -1) / 1000;
				local castTime = castEndTime - castStartTime;
				local currentPercent = timeSinceStart / castTime * 100000;
			  	if IsSpellInRange(GetSpellInfo(interruptSpell), customTarget) == 1
			  	  and UnitCanAttack("player", customTarget) ~= nil then
					if currentPercent and RandomInterrupt and currentPercent < RandomInterrupt and not IsChannel then return false; end
					ChatOverlay("INTERRUPT");
					InteruptTimer = GetTime();
					RandomInterrupt = nil;
				end
			end
		end
	end
end


--[[










]]





-- if isAlive([Unit]) == true then
function isAlive(Unit)
	local Unit = Unit or "target";
	if UnitIsDeadOrGhost(Unit) == nil then
		return true;
	else
		return false;
	end
end




function isChecked(Value)
	if BadBoy_data["Check "..Value] == 1 then return true; else return false; end
end

-- if isSelected("Stormlash Totem") then
function isSelected(Value)
	if BadBoy_data["Cooldowns"] == 3 or (BadBoy_data["Check "..Value] == 1 and (BadBoy_data["Drop "..Value] == 3 or BadBoy_data["Drop "..Value] == 2 and BadBoy_data["Cooldowns"] == 2)) then return true; else return false; end
end

-- Combo get drop/box
function getValue(Value)
	if BadBoy_data["Drop "..Value] ~= nil then
		return BadBoy_data["Drop "..Value];
	elseif BadBoy_data["Box "..Value] ~= nil then
		return BadBoy_data["Box "..Value];
	else
		return 0;
	end
end


























