

-------------------------------
--[[spellCastersTable Table]]
spellCastersTable = { };

---------------------------
--[[ Interrupts Reader --]]
local interruptsFrame = CreateFrame('Frame')
interruptsFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
function interruptsReader(self, event, ...)
    if event == "COMBAT_LOG_EVENT_UNFILTERED" then
    	--1st Param	2nd Param	3rd Param	4th Param	5th Param	6th Param	7th Param		8th Param	9th Param	10th Param	11th Param
--timestamp	event		hideCaster	sourceGUID	sourceName	sourceFlags	sourceRaidFlags	destGUID	destName	destFlags	destRaidFlags
    	local timestamp 	= select(1,...)
    	local event 		= select(2,...)
		local sourceGUID 	= select(4,...)
		local sourceName	= select(5,...)
		local destGUID		= select(8,...)
        local destName 		= select(9,...)
		local spellID 		= select(12,...)




        if sourceGUID then
	        ---------------
	        if isChecked("Interrupts Handler") then

	        	if source ~= UnitGUID("player") then

					if event == "SPELL_CAST_SUCCESS" then
						for i = 1, #spellCastersTable do
							if spellCastersTable[i] and sourceGUID == spellCastersTable[i].guid then
								tremove(spellCastersTable, i)
							end
						end
					end 

					if event == "SPELL_INTERRUPT" then
						for i = 1, #spellCastersTable do
							if spellCastersTable[i] and destGUID == spellCastersTable[i].guid then
								tremove(spellCastersTable, i)
							end
						end
					end

	        		if event == "SPELL_CAST_START" then
	        			local thisUnit
				        -- Prepare GUID to be reused via UnitID
				        for i = 1, #enemiesTable do
				        	if sourceGUID == enemiesTable[i].guid then
				        		thisUnit = enemiesTable[i].unit
				        		local candidate = isInteruptCandidate(thisUnit.unit,spellID)
				        		if candidate == true or not isChecked("Only Known Units") then
							        -- gather our infos
							        local spellName,castLenght,castEnd,notInterruptible,castOrChan = getCastingInfo(thisUnit)

							        -- make sure to define values
							        destName = destName or "|cffFFFFFFNo Target"
							        if destGUID == "" then
							        	destGUID = "|cffFFFFFFNo Target"
							        end
							        -- Send to table
					        		--in table we need GUID,name,spell,target,endTime
									-- we also need to add its casting infos
		  							local unitCasting, unitCastLenght, unitCastTime, unitCanntBeInterrupt, unitCastType = getCastingInfo(thisUnit)
					        		
					        		tinsert(spellCastersTable, 
					        			{ 
					        				cast = spellID,
					        				castType = unitCastType,
						        			canInterupt = unitCanntBeInterrupt == false,
						        			castEnd = unitCastTime,
						        			castLenght = unitCastLenght,
						        			distance = getDistance("player",thisUnit),
						        			guid = sourceGUID,
						        			id = enemiesTable[i].id,
						        			shouldInterupt = candidate,
						        			sourceGUID = sourceGUID,
						        			sourceName = sourceName,
						        			spellName = unitCasting,
						        			targetGUID = destGUID,
						        			targetName = destName,
						        			unit = enemiesTable[i].unit,
					        			}
					        		)     			

									-- Sorting with the endTime
									table.sort(spellCastersTable, function(x,y)
										-- if both value exists then
										if x.endTime and y.endTime then 
											-- place higher above
											return x.endTime > y.endTime;
										-- otherwise place empty at bottom
										elseif x.endTime then 
											return true
										elseif y.endTime then 
											return false
										end
									end)
									-- we first build up the table and then we come back to find who is near who
									getCastersAround(10)	
								end
			        		end				        	
			        	end
					end
	        	end
	        end
	    end
    end
end
-- pulse frame on event
interruptsFrame:SetScript("OnEvent", interruptsReader)

--[[           ]]   --[[           ]]    --[[           ]]
--[[           ]]   --[[           ]]    --[[           ]]
--[[]]              --[[]]        		       --[[ ]]
--[[]]   --[[  ]]	--[[           ]]          --[[ ]]
--[[]]     --[[]]	--[[]]        		       --[[ ]]
--[[           ]]   --[[           ]]          --[[ ]]
--[[           ]]   --[[           ]]          --[[ ]]

-- function to gather casters in a given radius around a given unit
function getCastersAround(Range)
	for i = 1, #spellCastersTable do
		local thatCaster = spellCastersTable[i]
		-- dummy var
		local enemyCastersAround = 0
		for j = 1, #spellCastersTable do
			thisCaster = spellCastersTable[j]
			-- if more than 0.25 remains on unit cast and its in range we count it
			if (thisCaster.castEnd - GetTime() > 0.25 or thisCaster.castType == "chan") and 
			  getRealDistance(thatCaster.unit,thisCaster.unit) < Range then
				enemyCastersAround = enemyCastersAround + 1
			end
		end
		-- add dummy var to spellCastersTable
		thatCaster.castersAround = enemyCastersAround
	end
end

-- returns name of cast/channel and casting("cast") or channelling("chan") /dump getCastingInfo("target")
function getCastingInfo(unit)
	-- if its a spell we return casting informations
	if UnitCastingInfo(unit) ~= nil then
		local unitCastName,_,_,_,unitCastStart,unitCastEnd,_,unitCastID,unitCastNotInteruptible = UnitCastingInfo(unit)
		return unitCastName, getCastLenght(unitCastStart,unitCastEnd),unitCastEnd/1000,unitCastNotInteruptible,"cast"
	-- if its achannel we return channel info
	elseif UnitChannelInfo(unit) ~= nil then
		local unitCastName,_,_,_,unitCastStart,unitCastEnd,_,unitCastID,unitCastNotInteruptible = UnitChannelInfo(unit)
		return unitCastName,getCastLenght(unitCastStart,unitCastEnd),unitCastEnd/1000,unitCastNotInteruptible,"chan"
	-- otherwise we return bad dummy vars
	else
		return false, 250, 250, true, "nothing"
	end
end

-- casting informations
function getCastLenght(castStart,castEnd)
	return (castEnd-castStart)/1000
end
function getTimeUntilCastEnd(castEnd)
	return math.floor((castEnd/1000 - GetTime())*100)/100
end

--[[           ]]	--[[           ]]
--[[           ]]	--[[           ]]
	 --[[ ]]		--[[ ]]
	 --[[ ]]		--[[           ]]
	 --[[ ]]				  --[[ ]]
--[[           ]]	--[[           ]]
--[[           ]]	--[[           ]]

-- check if a unit is a casting candidate according to its unitID and its current spell cast
function isInteruptCandidate(Unit,SpellID)
	local unitID = getUnitID(Unit)
	for i = 1, #interruptCandidates do
		thisCandidate = interruptCandidates[i]
		if thisCandidate.unitID == 0 or unitID == thisCandidate.unitID then
			if thisCandidate.spell == 0 or GetSpellInfo(SpellID) == GetSpellInfo(thisCandidate.spell) then
				return true
			end
		end
	end
	return false
end

--[[Modes]]
	--[[Toggleable between modes]]
		--[[Mode1. Manual Interrupts]]
		--[[Mode2. Interrupt All]]
		--[[Mode3. What to Interrupt According to filters]]
			--[[filters1. Whitelist, ie only interrupt this spells]]
			--[[filters2. Blacklist, ie interrupt all except this spells]]
		--[[Mode4 Who to interupt according to filter/toogle]]
			--[[Who1. Current Target]]
			--[[Who2. UnitIDs(Focus, MouseOver, ToT etc)]]
			--[[Who3. Everyone in the world including your mom]]
		--[[With What]]
			--[[List of Spells that can be used to interrupt per classes with cooldown informations and availabilty]]
				--[[classe1. Warrior(Dusrupting Shout, Pummel, Spell Reflect, Mass Spell Reflect)]]
				--[[Paladin(Rebuke, Fist of Justice, Blinding Light, Avengers Shield)]]


		--[[When to interrupt]]
			--[[Start or End]]
				--[[Normaly you will interrupt as quick as possible(channels for sure)]]
				--[[But sometimes we want to interrupt as lat as possible]]
			--[[React Time to make sure that we are hiding that we are botting]]
				--[[ie wait 0.x seconds before interrupting so we are acting humanly.]]

--[[The functionality for the interrupt module could look something like this
Rotation checks if the user want us to interupt, it then calls a sub function that handles the class specific interrupt logic. The class specific funtion first checks what the config is and then do a call to a generic Interuppt handler that checks if there is someone casting something we should interrupt and returns a target if there is a valid one. The class specific then checks according to his config which spells to try to use]]

--[[Rotations: 
Check if user wants us to Interrupt
If yes then call ClassInterrupt Function]]

--[[ClassInterrupt function:
Read the Toggle values
Call InterruptHandler with config values]]

--[[InterupptHandler:
Check who to interrupt(All, Target, etc)
For each applicable unit check if they cast spell according to filter(All, Whitelist, Blacklist) within the react time defined.
If true then return target]]

--[[ClassInterrupt:
If return is a valid target then for each spell defined in the config check if it is possible to use spell to interrupt.]]

--[[This design/functionality would be a very good interrupt function for the bot and cater for 90% of the need. Blacklist is perhaps good to have more then must have. If we are very ambitious we could even do a spell priority, ie what spell to itnerrupt instead of just stopping checking when we find a valid target(scenario if target cast a spell that are medium dangerous and our focus is casting a very dangerous spell we would want to interrupt the focus) IE the spell is used to select which target insead of target order.]]

--[[Also it could be good to use events here to get a list of targets that are casting instead of looping through all units. So we could create an event handler that handles a list of units that are currently casting. For performance sake i mean.]]




