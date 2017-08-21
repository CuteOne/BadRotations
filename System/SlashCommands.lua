-- Slash Commands
---------------------------------
function Print(msg)
	print(br.classColor.."[BadRotations] |cffFFFFFF"..msg)
end
commandHelp = "|cffFF0000Slash Commands"
function SlashCommandHelp(cmd,msg)
	if cmd == nil then cmd = "" end
	if msg == nil then msg = "" end
	if cmd == "Print Help" then Print(tostring(commandHelp)); return end
	commandHelp = commandHelp.."|cffFFFFFF\n        /"..cmd.."|cffFFDD11 - "..msg
end

local function toggleUI()
    local UIState = false
    if UIState == false then
    	mainButton:Click()
        BadRotationsButton:Show()
        UIState = true
    else
    	mainButton:Click()
        BadRotationsButton:Hide()
        UIState = false
    end
end

function toggle(name,index,check)
	if check == nil then check = false end
	if toggleFound == nil then toggleFound = false end
	for k, v in pairs(br.data.settings[br.selectedSpec].toggles) do
		local toggle = name --(name:gsub("^%l", string.upper))
		local name = string.lower(name)
		local k = string.lower(k)
		if name == k then
			if check then toggleFound = true; break end
			if index == nil then
				ToggleValue(toggle)
				break
			else
				ToggleToValue(toggle,index)
				break
			end
		end
	end
	if check then return toggleFound end
end

local function getStringIndex(string,index)
	local s = string
	local count = 0
	for i in string.gmatch(s, "%S+") do
		count = count + 1
		if count == index then
	    	return i
	    end
	end
	return nil
end

local function updateRate()
	print("Current Update Rate: "..getUpdateRate())
	print("Current Dynamic Target Rate: "..getEnemyUpdateRate())
end

local function forewardDisengage() -- from Stinky Twitch 
	local s, d, e = GetSpellCooldown(781) 
	if s == 0 then
		MoveForwardStart() 
		C_Timer.After(.10, function() 
			MoveForwardStop() 
			MoveBackwardStop() 
			MoveAndSteerStop() 
			JumpOrAscendStart() 
			FaceDirection(mod(ObjectFacing("player") + math.pi, math.pi * 2))
		end) 
		C_Timer.After(.25, function() 
			CastSpellByID(781) 
		end)
		MoveForwardStart() 
		C_Timer.After(.30, function() 
			MoveForwardStop() 
			MoveBackwardStop() 
			MoveAndSteerStop() 
			JumpOrAscendStart() 
			FaceDirection(mod(ObjectFacing("player") + math.pi, math.pi * 2))
		end)  
	end
end

function slashHelpList()
	SLASH_BR1, SLASH_BR2 = '/br', '/badrotations'
	SlashCommandHelp("br","Toggles BadRotations On/Off")
	SlashCommandHelp("br help","Displays this list of help commands. ***Obviously***")
	SlashCommandHelp("br blacklist","Adds/Removes mouseover unit to healing blacklist.")
	SlashCommandHelp("br blacklist dump","Prints all units currently on blacklist.")
	SlashCommandHelp("br blacklist clear","Clears the blacklist.")
	-- SlashCommandHelp("br pause hold","Pauses while held (via macro).")
	SlashCommandHelp("br pause toggle","Switches Pause On/Off")
	SlashCommandHelp("br queue clear","Clears the Spell Queue of all queued spells.")
	SlashCommandHelp("br queue add spellId","Adds the Spell to the Queue by Spell Id.")
	SlashCommandHelp("br queue remove spellId","Removes the Spell from the Queue by Spell Id.")
	SlashCommandHelp("br updaterate", "Displays Current Update Rate")
	if select(2, UnitClass("player")) == "HUNTER" then
		SlashCommandHelp("br disengage", "Assign to macro to Forward Disengage.")
	end
end

slashHelpList()
function handler(message, editbox)
    local msg = string.lower(message)
    local msg1 = getStringIndex(message,1)
    local msg2 = getStringIndex(message,2)
	local msg3 = getStringIndex(message,3)
	if msg == "" or msg == nil then
	    toggleUI()
	-- Help
	elseif msg == "help" then
		SlashCommandHelp("Print Help")
	-- Blacklist
	elseif msg1 == "blacklist" then
		if msg2 == "dump" then
			Print("|cffFF0000Blacklist:")
			if #br.data.blackList == (0 or nil) then Print("|cffFFDD11Empty") end
			if br.data.blackList then
				for i = 1, #br.data.blackList do
					Print("|cffFFDD11- "..br.data.blackList[i].name)
				end
			end
		elseif msg2 == "clear" then
			br.data.blackList = { }
			Print("|cffFF0000Blacklist Cleared")
		elseif msg2 == "mouseover" then
			if GetUnitExists("mouseover") then
				local mouseoverName = UnitName("mouseover")
				local mouseoverGUID = UnitGUID("mouseover")
				-- Now we're trying to find that unit in the blackList table to remove
				local found
				for k,v in pairs(br.data.blackList) do
					-- Now we're trying to find that unit in the Cache table to remove
					if UnitGUID("mouseover") == v.guid then
						tremove(br.data.blackList, k)
						Print("|cffFFDD11"..mouseoverName.. "|cffFF0000 Removed from Blacklist")
						found = true
						--blackList[k] = nil
					end
				end
				if not found then
					Print("|cffFFDD11"..mouseoverName.. "|cffFF0000 Added to Blacklist")
					tinsert(br.data.blackList, { guid = mouseoverGUID, name = mouseoverName})
				end
			end
		else
			Print("Invalid Option for: |cFFFF0000"..msg1.."|r try |cffFFDD11 /br help |r for available options.")
		end
	-- Pause
	elseif msg1 == "pause" then
		--[[if msg2 == "hold" then
			ChatOverlay("Profile Paused")
			return true
		else]]if msg2 == "toggle" then
			if br.data.settings[br.selectedSpec].toggles['Pause'] == 0 then
				ChatOverlay("\124cFFED0000 -- Paused -- ")
				Print("|cFFFF0000Paused")
				br.data.settings[br.selectedSpec].toggles['Pause'] = 1
			else
				ChatOverlay("\124cFF3BB0FF -- Pause Removed -- ")
				Print("|cFF3BB0FFPause Removed")
				br.data.settings[br.selectedSpec].toggles['Pause'] = 0
			end
		else
			Print("Invalid Option for: |cFFFF0000"..msg1.."|r try "..--[["|cffFFDD11 /br pause hold |r - Pauses while held (via macro) or ]]"|cffFFDD11 /br pause toggle |r - Switches Pause On/Off")
		end
	-- Toggles
	elseif msg1 == "toggle" then
		if msg2 ~= nil then
			if toggle(msg2,msg3,true) then
				toggle(msg2,msg3)
			else
				Print("Invalid Toggle: |cFFFF0000" .. msg2 .. "|r try |cffFFDD11 /br help |r for list of toggles.")
			end
		else
			Print("No Toggle Specified: Try |cffFFDD11 /br help |r for list of toggles.")
		end
	-- Queue
	elseif msg1 == "queue" then
		if isChecked("Queue Casting") then
			if msg2 == "clear" then
				if br.player.queue == nil then Print("Queue Already Cleared") end
				if #br.player.queue == 0 then Print("Queue Already Cleared") end
				if #br.player.queue > 0 then br.player.queue = {}; Print("Cleared Queue") end
			elseif msg2 == "add" then
				if msg3 == nil then
					Print("No Spell Provided to add to Queue.")
				else
					local spellName,_,_,_,_,_,spellId = GetSpellInfo(msg3)
					local target = msg4
					if spellName == nil then
	            		Print("Invalid Spell ID: |cffFFDD11 Unable to add.")
	            	else
						if #br.player.queue == 0 then
		                    tinsert(br.player.queue,{id = spellId, name = spellName, target = queueDest})
		                    Print("Added |cFFFF0000"..spellName.."|r to the queue.")
		                elseif #br.player.queue ~= 0 then
		                    for i = 1, #br.player.queue do
		                        if spellId == br.player.queue[i].id then
		                            Print("|cFFFF0000"..spellName.."|r is already queued.")
		                            break
		                        else
		                            tinsert(br.player.queue,{id = spellId, name = spellName, target = queueDest})
		                            Print("Added |cFFFF0000"..spellName.."|r to the queue.")
		                            break
		                        end
		                    end
		                end
		            end
				end
			elseif msg2 == "remove" then
				if msg3 == nil then
					Print("No Spell Provided to remove from Queue.")
				else
	            	local spellName,_,_,_,_,_,spellId = GetSpellInfo(msg3)
	            	local removedSpell = false
					if #br.player.queue ~= 0 then
		                for i = 1, #br.player.queue do
		                    if spellId == br.player.queue[i].id then
		                        tremove(br.player.queue,i)
		                        Print("Removed |cFFFF0000"..spellName.."|r from the queue.")
		                        removedSpell = true
		                        break
		                    end
		                end
		            end
		            if not removedSpell then
		            	if spellName == nil then
		            		Print("Invalid Spell ID: |cffFFDD11 Unable to remove.")
		            	else
		            		Print("Spell Not Found: Failed to remove |cFFFF0000"..spellName.."|r from the queue. ")
		            	end
		            end
		        end
			elseif msg2 == nil then
				Print("Invalid Option for: |cFFFF0000" .. msg1 .. "|r try |cffFFDD11 /br queue clear |r - Clears the Queue list or |cffFFDD11 /br queue add (spell)|r - Adds specified spell to Queue list or |cffFFDD11 /br queue remove (spell) |r - Removes specifid from Queue list.")
			end
		else
			Print("Queue Casting Disabled: |cffFFDD11 Check Bot Options to enable.")
		end
	elseif msg == "updaterate" then
		updateRate()
	elseif msg == "disengage" then
		forewardDisengage()
	else
	    Print("Invalid Command: |cFFFF0000" .. msg .. "|r try |cffFFDD11 /br help")
	end
end
SlashCmdList["BR"] = handler;
