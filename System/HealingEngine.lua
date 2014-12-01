--[[---------------------------------------------------------------------------------------------------
-----------------------------------------Bubba's Healing Engine--------------------------------------]]
if not metaTable1 then

	local _MyClass = select(3,UnitClass("player"));

	-- localizing the commonly used functions while inside loops
	local getDistance, GetSpellInfo, tinsert, tremove, UnitDebuff, UnitHealth, UnitHealthMax, UnitExists, UnitGUID = getDistance, GetSpellInfo, tinsert, tremove, UnitDebuff, UnitHealth, UnitHealthMax, UnitExists, UnitGUID
	nNova = {} -- This is our main Table that the world will see
	memberSetup = {} -- This is one of our MetaTables that will be the default user/contructor
	memberSetup.cache = { } -- This is for the cache Table to check against
	metaTable1 = {} -- This will be the MetaTable attached to our Main Table that the world will see

	metaTable1.__call = function(_, ...) -- (_, forceRetable, excludePets, onlyInRange) [Not Implemented]
		local group =  IsInRaid() and "raid" or "party" -- Determining if the UnitID will be raid or party based
		local groupSize = IsInRaid() and GetNumGroupMembers() or GetNumGroupMembers() - 1 -- If in raid, we check the entire raid. If in party, we remove one from max to account for the player.
		if group == "party" then tinsert(nNova, memberSetup:new("player")) end -- We are creating a new User for player if in a Group
		for i=1, groupSize do -- start of the loop to read throught the party/raid
			local groupUnit = group..i
			local groupMember = memberSetup:new(groupUnit)
			if groupMember then tinsert(nNova, groupMember) end -- Inserting a newly created Unit into the Main Frame
		end
	end

	metaTable1.__index =  {-- Setting the Metamethod of Index for our Main Table
		name = "Healing Table",
		author = "Bubba",
	}

	-- Creating a default Unit to default to on a check
	memberSetup.__index = {
		name = "noob",
		hp = 100,
		unit = "noob",
		role = "NOOB",
		range = false,
		guid = 0,
		guidsh = 0,
	}

	-- If ever somebody enters or leaves the raid, wipe the entire Table
	local updateHealingTable = CreateFrame("frame", nil)
	updateHealingTable:RegisterEvent("GROUP_ROSTER_UPDATE")
	updateHealingTable:SetScript("OnEvent", function()
		table.wipe(nNova);
		table.wipe(memberSetup.cache);
		SetupTables()
	end)

	-- This is for those NPC units that need healing. Compare them against our list of Unit ID's
	local function SpecialHealUnit(tar)
		for i=1, #novaEngineTables.SpecialHealUnitList do
			if getGUID(tar) == novaEngineTables.SpecialHealUnitList[i] then
				return true
			end
		end
	end

	-- We are checking if the user has a Debuff we either can not or don't want to heal them
	local function CheckBadDebuff(tar)
		for i=1, #novaEngineTables.BadDebuffList do
			if UnitDebuff(tar, GetSpellInfo(novaEngineTables.BadDebuffList[i])) or 
			UnitBuff(tar, GetSpellInfo(novaEngineTables.BadDebuffList[i]))
			then
				return false
			end
		end
		return true
	end

	local function CheckCreatureType(tar)
		local CreatureTypeList = {"Critter", "Totem", "Non-combat Pet", "Wild Pet"}
		for i=1, #CreatureTypeList do
			if UnitCreatureType(tar) == CreatureTypeList[i] then return false end
		end
		if not UnitIsBattlePet(tar) and not UnitIsWildBattlePet(tar) then return true else return false end
	end

	-- Verifying the target is a Valid Healing target
	function HealCheck(tar)
		if ((UnitIsVisible(tar)
		  and not UnitIsCharmed(tar)
		  and UnitReaction("player",tar) > 4
		  and not UnitIsDeadOrGhost(tar)
		  and UnitIsConnected(tar))
		  or novaEngineTables.SpecialHealUnitList[tonumber(select(2,getGUID(tar)))] ~= nil	or (isChecked("Heal Pets") == true and UnitIsOtherPlayersPet(tar) or UnitGUID(tar) == UnitGUID("pet")))
		  and CheckBadDebuff(tar)
		  and CheckCreatureType(tar)
		  and getLineOfSight("player", tar)
		then return true 
		else return false end
	end

	function memberSetup:new(unit)
		-- Seeing if we have already cached this unit before
		if memberSetup.cache[getGUID(unit)] then return false end
		local o = {}
		setmetatable(o, memberSetup)
		if unit and type(unit) == "string" then
			o.unit = unit
		end

		-- This is the function for Dispel checking built into the player itself.
		function o:Dispel()
			for i = 1, #novaEngineTables.DispelID do
				if UnitDebuff(o.unit,GetSpellInfo(novaEngineTables.DispelID[i].id)) ~= nil and novaEngineTables.DispelID[i].id ~= nil then
					if select(4,UnitDebuff(o.unit,GetSpellInfo(novaEngineTables.DispelID[i].id))) >= novaEngineTables.DispelID[i].stacks then
						if novaEngineTables.DispelID[i].range ~= nil then
							if #getAllies(o.unit,novaEngineTables.DispelID[i].range) > 1 then
								return false
							end
						end
						return true
					end
				end
			end
			return false
		end

		-- We are checking the HP of the person through their own function.
		function o:CalcHP()
--			print("calculating HP")
			local incomingheals;
			if isChecked("No Incoming Heals") ~= true and UnitGetIncomingHeals(o.unit,"player") ~= nil then incomingheals = UnitGetIncomingHeals(o.unit,"player"); else incomingheals = 0; end
			local nAbsorbs;
			if isChecked("No Absorbs") ~= true then nAbsorbs = ( 25*UnitGetTotalAbsorbs(o.unit)/100 ); else nAbsorbs = 0; end
			local PercentWithIncoming = 100 * ( UnitHealth(o.unit) + incomingheals + nAbsorbs ) / UnitHealthMax(o.unit);
			if o.role == "TANK" then PercentWithIncoming = PercentWithIncoming - 5; end -- Using the group role assigned to the Unit
			if HealCheck(o.unit) ~= true then PercentWithIncoming = 250; end -- Place Dead players at the end of the list
			if o.dispel then PercentWithIncoming = PercentWithIncoming - 2; end -- Using Dispel Check to see if we should give bonus weight
			if o.threat == 3 then PercentWithIncoming = PercentWithIncoming - 3; end
			if o.guidsh == 72218  then PercentWithIncoming = PercentWithIncoming - 5 end -- Tank in Proving Grounds
			local ActualWithIncoming = ( UnitHealthMax(o.unit) - ( UnitHealth(o.unit) + incomingheals ) )
 			if not UnitInRange(o.unit) and getDistance(o.unit) > 42.98 and not UnitIsUnit("player", o.unit) then PercentWithIncoming = 250; end
			-- Malkorok
			local SpecificHPBuffs = {
				{ buff = 142865 , value = select(15,UnitDebuffID(o.unit,142865)) }, -- Strong Ancient Barrier (Green)
				{ buff = 142864 , value = select(15,UnitDebuffID(o.unit,142864)) }, -- Ancient Barrier (Yellow)
				{ buff = 142863 , value = select(15,UnitDebuffID(o.unit,142863)) }, -- Weak Ancient Barrier (Red)
			};
			if UnitDebuffID(o.unit, 142861) ~= nil then -- If Miasma found
				for i = 1, #SpecificHPBuffs do -- start nomber of buff iteration
					if UnitDebuffID(o.unit, SpecificHPBuffs[i].buff) ~= nil then -- if buff found
						if SpecificHPBuffs[i].value ~= nil then
							PercentWithIncoming = 100 + (SpecificHPBuffs[i].value/UnitHealthMax(o.unit)*100); -- we set its amount + 100 to make sure its within 50-100 range
							break;
						end
					end
				end
				PercentWithIncoming = PercentWithIncoming/2 -- no mather what as long as we are on miasma buff our life is cut in half so unshielded ends up 0-50
			end

			-- Debuffs HP compensation
			for i = 1, #novaEngineTables.SpecificHPDebuffs do
				if UnitDebuffID(o.unit, novaEngineTables.SpecificHPDebuffs[i].debuff) ~= nil then
					PercentWithIncoming = PercentWithIncoming - novaEngineTables.SpecificHPDebuffs[i].value
				end
			end
			if isChecked("Blacklist") == true and BadBoy_data.blackList ~= nil then
				for i = 1, #BadBoy_data.blackList do
					if o.guid == BadBoy_data.blackList[i].guid then
						PercentWithIncoming, ActualWithIncoming, nAbsorbs = PercentWithIncoming + getValue("Blacklist") , ActualWithIncoming + getValue("Blacklist") , nAbsorbs + getValue("Blacklist")
						break;
					end
				end
			end
			return PercentWithIncoming, ActualWithIncoming, nAbsorbs
		end

		function o:nGUID()
	  		local nShortHand = ""
	  		if UnitExists(unit) then
	    		targetGUID = UnitGUID(unit)
	    		nShortHand = UnitGUID(unit):sub(-5)
	  		end
	  		return targetGUID, nShortHand
		end

		-- Updating the values of the Unit
		function o:UpdateUnit()
			o.name = UnitName(o.unit) -- return Name of unit
			o.guid = o:nGUID() -- return real GUID of unit

			local roleFinder = roleFinder
			if UnitGroupRolesAssigned(o.unit) == "NONE" then
				if novaEngineTables.roleTable[UnitName(o.unit)] ~= nil then
					o.role = novaEngineTables.roleTable[UnitName(o.unit)]
				end
			else
				o.role = UnitGroupRolesAssigned(o.unit)
			end -- role from raid frame
			o.guidsh = select(2, o:nGUID()) -- Short GUID of unit for the SetupTable
			o.dispel = o:Dispel(o.unit) -- return true if unit should be dispelled
			o.threat = UnitThreatSituation(o.unit) -- Unit's threat situation(1-4)
			o.hp = o:CalcHP() -- Unit HP
			o.absorb = select(3, o:CalcHP()) -- Unit Absorb
			o.target = tostring(o.unit).."target" -- Target's target
			memberSetup.cache[select(2, getGUID(o.unit))] = o -- Add unit to SetupTable
		end

		-- Adding the user and functions we just created to this cached version in case we need it again
		-- This will also serve as a good check for if the unit is already in the table easily
		--print(UnitName(unit), select(2, getGUID(unit)))
		memberSetup.cache[select(2, o:nGUID())] = o
		return o
	end

	-- Setting up the tables on either Wipe or Initial Setup
	function SetupTables() -- Creating the cache (we use this to check if some1 is already in the table)
		setmetatable(nNova, metaTable1) -- Set the metaTable of Main to Meta
		function nNova:Update(MO)
			local MouseoverCheck = true
			-- This is for special situations, IE world healing or NPC healing in encounters
			if isChecked("Special Heal") == true then SpecialTargets = {"mouseover","target","focus"} else SpecialTargets = {} end
			for p=1, #SpecialTargets do
				-- Checking if Unit Exists and it's possible to heal them
				if UnitExists(SpecialTargets[p]) and HealCheck(SpecialTargets[p]) then
					if not memberSetup.cache[select(2, getGUID(SpecialTargets[p]))] then
						local SpecialCase = memberSetup:new(SpecialTargets[p])
						if SpecialCase then
							-- Creating a new user, if not already tabled, will return with the User
							for j=1, #nNova do
								if nNova[j].unit == SpecialTargets[p] then
									-- Now we add the Unit we just created to the Main Table
									for k,v in pairs(memberSetup.cache) do
										if nNova[j].guidsh == k then
											memberSetup.cache[k] = nil
										end
									end
									tremove(nNova, j)
									break
								end
							end
						end
						tinsert(nNova, SpecialCase)
						novaEngineTables.SavedSpecialTargets[SpecialTargets[p]] = select(2,getGUID(SpecialTargets[p]))
					end
				end
			end

			for p=1, #SpecialTargets do
				local removedTarget = false
				for j=1, #nNova do
					-- Trying to find a case of the unit inside the Main Table to remove
					if nNova[j].unit == SpecialTargets[p] and (nNova[j].guid ~= 0 and nNova[j].guid ~= UnitGUID(SpecialTargets[p])) then
						tremove(nNova, j)
						removedTarget = true
						break
					end
				end
				if removedTarget == true then
					for k,v in pairs(memberSetup.cache) do
						-- Now we're trying to find that unit in the Cache table to remove
						if SpecialTargets[p] == v.unit then
							memberSetup.cache[k] = nil
						end
					end
				end
			end

			for i=1, #nNova do
				-- We are updating all of the User Info (Health/Range/Name)
				nNova[i]:UpdateUnit()
			end

			-- We are sorting by Health first
			table.sort(nNova, function(x,y)
				return x.hp < y.hp
			end)

			-- Sorting with the Role
			if isChecked("Sorting with Role") then
				table.sort(nNova, function(x,y)
					if x.role and y.role then return x.role > y.role
					elseif x.role then return true
					elseif y.role then return false end
				end)
	        end
			if isChecked("Special Priority") == true then
			 	if UnitExists("focus") and memberSetup.cache[select(2, getGUID("focus"))] then
					table.sort(nNova, function(x)
						if x.unit == "focus" then
							return true
						else
							return false
						end
					end);
				end
				if UnitExists("target") and memberSetup.cache[select(2, getGUID("target"))] then
					table.sort(nNova, function(x)
						if x.unit == "target" then
							return true
						else
							return false
						end
					end)
				end
				if UnitExists("mouseover") and memberSetup.cache[select(2, getGUID("mouseover"))] then
					table.sort(nNova, function(x)
						if x.unit == "mouseover" then
							return true
						else
							return false
						end
					end)
				end
			end
		end
		-- We are creating the initial Main Table
		nNova()
	end
	-- We are setting up the Tables for the first time
	SetupTables()
end











































































































