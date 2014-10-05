-----------------------------
--[[spellCastingUnits Table]]
spellCastingUnits = { };

---------------------------
--[[ Interrupts Reader --]]
local interruptsFrame = CreateFrame('Frame');
interruptsFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
interruptsFrame:RegisterEvent("UNIT_SPELLCAST_SENT");
interruptsFrame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED");
interruptsFrame:RegisterEvent("UNIT_SPELLCAST_FAILED");
function interruptsReader(self, event, ...)
    if event == "COMBAT_LOG_EVENT_UNFILTERED" then
--1st Param	2nd Param	3rd Param	4th Param	5th Param	6th Param	7th Param		8th Param	9th Param	10th Param	11th Param
--timestamp	event		hideCaster	sourceGUID	sourceName	sourceFlags	sourceRaidFlags	destGUID	destName	destFlags	destRaidFlags
    	local timestamp 	= select(1,...);
    	local event 		= select(2,...);
		local sourceGUID 	= select(4,...);
		local sourceName	= select(5,...);
		local destGUID		= select(8,...);
        local destName 		= select(9,...);
		local spellID 		= select(12,...);

	    -- Table cleaner, skip if # is 0 as it mean table is empty.
	    if #spellCastingUnits > 0 then
	    	tableAmountBeforeIteration = #spellCastingUnits
	    	-- i start at 0 because i want to start my iteration at #spellCastingUnits(last)-0 entry
			for i = 0, tableAmountBeforeIteration do
				-- my row should be the last row 1st and then last second 2nd and so on...
				currentRow = tableAmountBeforeIteration-i
				-- if the row exist(just in case) and the stored time is lower than the GetTime() this cast should be over.
				if spellCastingUnits[currentRow] and spellCastingUnits[currentRow].endTime and spellCastingUnits[currentRow].endTime < GetTime() then
					-- if yes then we remove that row.
					tremove(spellCastingUnits, currentRow);
				else
					-- as our table is sorted, from bottom we start removing and when they are still casting we break out.
					break;
				end
			end
		end


        if sourceGUID ~= nil then
	        ---------------
	        --[[ IsCasting Enemy --]]
	        --if BadBoy_data["Check Interrupts"] == 1 then
	        	--if source ~= UnitGUID("player") then
	        		if event == "SPELL_CAST_START" then

				        -- Prepare GUID to be reused via UnitID
				        ISetAsUnitID(sourceGUID,"thisUnit");

				        -- find our EndTime
				        endTime = select(6,UnitCastingInfo("thisUnit"))
				        sourceClass = select(3,UnitClass("thisUnit"))
				        -- if endTime found then divide by 1000 to match GetTime() values
				        if endTime ~= nil then
				        	endTime = endTime/1000
				        	if destName == nil then destName = "|cffFFFFFFNo Target" end

				        	-- Send to table
		        			--[[in table we need GUID,name,spell,target,endTime]]
		        			tinsert(spellCastingUnits, { guid = sourceGUID, sourceName = sourceName, spell = spellID, targetGUID = destGUID, targetName = destName, endTime = endTime, class = sourceClass })
	        			end

						-- Sorting with the endTime
						table.sort(spellCastingUnits, function(x,y)
							-- if both value exists then
							if x.endTime and y.endTime then 
								-- place higher above
								return x.endTime > y.endTime;
							-- otherwise place empty at bottom
							elseif x.endTime then 
								return true;
							elseif y.endTime then 
								return false; 
							end
						end)	
	        		end
	        	--end
	        --end
	    end


    end

	-------------------------------------------------
	--[[ SpellCast Sents (used to define target) --]]
	if event == "UNIT_SPELLCAST_SENT" then
		-- print(...)
	end

	-----------------------------
	--[[ SpellCast Succeeded --]]
	if event == "UNIT_SPELLCAST_SUCCEEDED" then
		-- print(...)
	end

	-----------------------------
	--[[ Spell Failed Immune --]]
	if event == "SPELL_FAILED_IMMUNE" then
		-- print(...)
	end
end
interruptsFrame:SetScript("OnEvent", interruptsReader)


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
				spellsTable = {
					[1] = { }, -- Warrior
					[2] = { }, -- Paladin
--[[ -- Paladin
 105421,  -- Blinding Light         --dis -- instant -- self -- 10 -- gcd = 0
 115752,  -- Blinding Light (Glyph of Blinding Light)   -- stun -- instant -- self -- 10 -- gcd = 0
 105593,  -- Fist of Justice         -- stun -- instant -- range -- 20 -- gcd = 1.5
 853,  -- Hammer of Justice        -- stun -- instant -- range -- 10 -- gcd = 1.5
 119072,  -- Holy Wrath          -- stun -- instant -- self -- 10 -- gcd = 1.5
 20066,  -- Repentance          -- stun -- cast -- range -- 30 -- gcd = 1.5
 10326,  -- Turn Evil          -- fear -- cast -- range -- 20 -- gcd = 1.5	]]			
					[3] = { }, -- Hunter
					[4] = { }, -- Rogue
					[5] = { }, -- Priest
					[6] = { 
						[1] = { spell = 108194, spellType = "silence", spellSpeed = 1, spellRange = 30 },  -- Asphyxiate -- Silence -- Instant -- Ranged -- 30 -- GCD = 1
						[2] = { spell = 91800, spellType = "stun", spellSpeed = 0, spellRange = 5 },  -- Gnaw (Ghoul) -- Stun -- Instant -- Melee -- 5 -- GCD = 0
						[3] = { spell = 91797, spellType = "stun", spellSpeed = 0, spellRange = 5 },  -- Monstrous Blow (Dark Transformation) -- Stun -- Instant -- Melee -- 5 -- GCD = 0
					}, -- DeathKnight
					[7] = { }, -- Shaman
					[8] = { }, -- Mage
--[[ Mage
 118271,  -- Combustion Impact        -- stun -- instant -- range -- 40 -- gcd = 0
 44572,  -- Deep Freeze          -- stun -- instant -- range -- 35 -- gcd = 1.5
 31661,  -- Dragon's Breath         -- disor -- instant -- self -- 0 -- gcd = 1.5
 118,  -- Polymorph          -- disor -- cast -- range -- 30 -- gcd = 1.5
 61305,  -- Polymorph: Black Cat        ^
 28272,  -- Polymorph: Pig         ^
 61721,  -- Polymorph: Rabbit        ^
 61780,  -- Polymorph: Turkey        ^
 28271,  -- Polymorph: Turtle        ^
 82691,  -- Ring of Frost         -- stun -- instant -- range -- 100 -- gcd = 0]]					
					[9] = { }, -- Warlock
					[10] = { -- Monk
						[1] = { -- Brewmaster
							[1] = { spell = 123393, spellType = "disorient", spellSpeed = 1, spellRange = 20 }, -- Breath of Fire (Glyph of Breath of Fire)   --disor -- instant -- self -- 0 -- gcd = 0
							[2] = { spell = 126451, spellType = "stun", spellSpeed = 1, spellRange = 30 }, -- Clash -- stun -- instant -- self -- 0 -- gcd = 0
							[3] = { spell = 122242, spellType = "stun", spellSpeed = 1, spellRange = 30 }, -- Clash -- stun -- instant -- self -- 0 -- gcd = 0
							[4] = { spell = 119392, spellType = "stun", spellSpeed = 1, spellRange = 30 }, -- Charging Ox Wave -- stun -- instant -- self -- 0 -- gcd = 1
							[5] = { spell = 119381, spellType = "stun", spellSpeed = 1, spellRange = 5 }, -- Leg Sweep -- stun -- instant -- self -- 5 -- gcd = 1
							[6] = { spell = 115078, spellType = "sleep", spellSpeed = 1, spellRange = 20 }, -- Paralysis -- stun -- instant -- range -- 20 -- gcd= 1
						},
						[2] = { -- Mistweaver
							[1] = { spell = 119381, spellType = "stun", spellSpeed = 1, spellRange = 5 }, -- Leg Sweep -- stun -- instant -- self -- 5 -- gcd = 1
							[2] = { spell = 115078, spellType = "sleep", spellSpeed = 1, spellRange = 20 }, -- Paralysis -- stun -- instant -- range -- 20 -- gcd= 1
						},		
						[3] = { -- Windwalker
							[1] = { spell = 120086, spellType = "stun", spellSpeed = 1, spellRange = 5 }, -- Fists of Fury -- stun -- channel -- melee -- 5 -- gcd = 0
							[2] = { spell = 119381, spellType = "stun", spellSpeed = 1, spellRange = 5 }, -- Leg Sweep -- stun -- instant -- self -- 5 -- gcd = 1
							[3] = { spell = 115078, spellType = "sleep", spellSpeed = 1, spellRange = 20 }, -- Paralysis -- stun -- instant -- range -- 20 -- gcd= 1
						}
					},
					[11] = { -- Druid
						[1] = { -- Moonkin
							[1] = { spell = 33786, spellType = "cast", spellSpeed = 1.5, spellRange = 20 }, -- Cyclone -- Invul -- Cast -- Ranged -- 20 -- GCD = 1.5
							[2] = { spell = 2637, spellType = "cast", spellSpeed = 1.5, spellRange = 30 }, -- Hibernate -- Asleep -- cast -- ranged -- 30 -- gcd = 1.5
							[3] = { spell = 5211, spellType = "stun", spellSpeed = 1.5, spellRange = 5 }, -- Mighty Bash -- stun -- instant -- melee -- 5 -- gcd = 1.5
							[4] = { spell = 102546, spellType = "stun", spellSpeed = 1, spellRange = 5 }, -- Pounce (Incarnation) -- stun -- instant -- melee -- 5 -- gcd = 1
						},
						[2] = { -- Kitty
							[1] = { spell = 22570, spellType = "stun", spellSpeed = 1, spellRange = 5 }, -- Maim -- stun -- instant -- melee -- 5 -- gcd = 1
							[2] = { spell = 5211, spellType = "stun", spellSpeed = 1.5, spellRange = 5 }, -- Mighty Bash -- stun -- instant -- melee -- 5 -- gcd = 1.5
							[3] = { spell = 9005, spellType = "stun", spellSpeed = 1, spellRange = 5 }, -- Pounce -- stun -- instant -- melee -- 5 -- gcd = 1
						},
						[3] = { -- Bear
							[1] = { spell = 113801, spellType = "stun", spellSpeed = 1.5, spellRange = 5 }, -- Bash (Force of Nature) -- Stun -- Instant -- Melee -- 5 -- GCD = 1.5
							[2] = { spell = 102795, spellType = "stun", spellSpeed = 1.5, spellRange = 5 }, -- Bear Hug -- Stun -- Instant -- Melee -- 5 -- GCD = 1.5
							[3] = { spell = 99, spellType = "disorient", spellSpeed = 1.5, spellRange = 10 }, -- Disorienting Roar -- Disor -- Instant -- Ranged -- Self 10 -- GCD = 1.5
							[4] = { spell = 5211, spellType = "stun", spellSpeed = 1.5, spellRange = 5 }, -- Mighty Bash -- stun -- instant -- melee -- 5 -- gcd = 1.5
							[5] = { spell = 102546, spellType = "stun", spellSpeed = 1, spellRange = 5 }, -- Pounce (Incarnation) -- stun -- instant -- melee -- 5 -- gcd = 1
						},
						[4] = { -- Resto
							[1] = { spell = 33786, spellType = "cast", spellSpeed = 1.5, spellRange = 20 }, -- Cyclone -- Invul -- Cast -- Ranged -- 20 -- GCD = 1.5
							[2] = { spell = 2637, spellType = "cast", spellSpeed = 1.5, spellRange = 30 }, -- Hibernate -- Asleep -- cast -- ranged -- 30 -- gcd = 1.5
							[3] = { spell = 5211, spellType = "stun", spellSpeed = 1.5, spellRange = 5 }, -- Mighty Bash -- stun -- instant -- melee -- 5 -- gcd = 1.5
							[4] = { spell = 102546, spellType = "stun", spellSpeed = 1, spellRange = 5 }, -- Pounce (Incarnation) -- stun -- instant -- melee -- 5 -- gcd = 1
							[5] = { spell = 110698, spellType = "stun", spellSpeed = 1.5, spellRange = 10 }, -- Hammer of Justice (Paladin) -- stun -- instant -- range -- 10 -- gcd = 1.5
							[6] = { spell = 113004, spellType = "stun", spellSpeed = 1.5, spellRange = 8 }, -- Intimidating Roar (Fleeing in Fear - Warrior) -- fear -- instant -- range -- 8 -- gcd = 1.5
							[7] = { spell = 113056, spellType = "stun", spellSpeed = 0, spellRange = 15 }, -- Intimidating Roar (Cowering in Fear - Warrior) -- root -- instant -- range -- 15 -- gcd = 0
						}
					}
				}
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




