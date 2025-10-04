local _, br = ...
br.slashCommands = br.slashCommands or {}
local slashCommands = br.slashCommands

-- Slash Commands
---------------------------------
function br._G.print(msg)
	if msg == nil then
		return
	end
	local color = ""
	if br.ui and br.ui.colors and br.ui.colors.class then
		color = br.ui.colors.class
	end
	print(color .. "[BadRotations] |r" .. tostring(msg))
end

br.slashCommands.commandHelp = { "|cffFF0000Slash Commands" }
function slashCommands:SlashCommandHelp(cmd, msg)
	if cmd == nil then
		cmd = ""
	end
	if msg == nil then
		msg = ""
	end
	if cmd == "Print Help" then
		for i = 1, #br.slashCommands.commandHelp do
			local command = br.slashCommands.commandHelp[i]
			if i == 1 then
				br._G.print(tostring(command))
			else
				print(tostring(command))
			end
		end
		return
	end
	table.insert(br.slashCommands.commandHelp, "|cffFFFFFF        /" .. cmd .. "|cffFFDD11 - " .. msg)
	-- br.slashCommands.commandHelp = br.slashCommands.commandHelp .. "|cffFFFFFF\n        /" .. cmd .. "|cffFFDD11 - " .. msg
end

local function toggleUI()
	local UIState = false
	if UIState == false then
		br.ui.toggles.mainButton:Click()
		br.ui.minimapButton.frame:Show()
		br.UIState = true
	else
		br.ui.toggles.mainButton:Click()
		br.ui.minimapButton.frame:Hide()
		br.UIState = false
	end
end

local function toggle(name, index, check)
	local toggleFound = false
	if check == nil then
		check = false
	end
	if toggleFound == nil then
		toggleFound = false
	end
	for k, _ in pairs(br.data.settings[br.loader.selectedSpec].toggles) do
		local toggle = string.upper(name) --name --(name:gsub("^%l", string.upper))
		name = string.lower(name)
		k = string.lower(k)
		if name == k then
			if check then
				toggleFound = true
				break
			end
			if index == nil then
				br.ToggleValue(toggle)
				break
			else
				br.ToggleToValue(toggle, index)
				break
			end
		end
	end
	if check then
		return toggleFound
	end
end

local function toggleRange(name, index1, index2)
	if br.data == nil then return end
	if br.data.settings == nil then return end
	if br.data.settings[br.loader.selectedSpec] == nil then return end
	if br.data.settings[br.loader.selectedSpec].toggles == nil then return end
	for k, _ in pairs(br.data.settings[br.loader.selectedSpec].toggles) do
		local toggle = string.upper(name) --name --(name:gsub("^%l", string.upper))
		name = string.lower(name)
		local lowerKey = string.lower(k)
		if name == lowerKey then
			if tostring(br.data.settings[br.loader.selectedSpec].toggles[k]) == index1 then
				br.ToggleToValue(toggle, index2)
				return
			elseif tostring(br.data.settings[br.loader.selectedSpec].toggles[k]) == index2 then
				br.ToggleToValue(toggle, index1)
				return
			else
				br.ToggleToValue(toggle, index1)
				return
			end
		end
	end
	br._G.print("No toggle found with name: " .. tostring(name))
end

local function getStringIndex(string, index)
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
	print("Current Update Rate: " .. br.engines:getUpdateRate())
end

local function forewardDisengage() -- from Stinky Twitch
	local s = br._G.C_Spell.GetSpellCooldown(781)
	if s and s.startTime == 0 then
		br._G.FaceDirection(br._G.mod(br._G.ObjectFacing("player") + math.pi, math.pi * 2), true)
		br._G.CastSpellByID(781)
		br.C_Timer.After(0.05,
			function() br._G.FaceDirection(br._G.mod(br._G.ObjectFacing("player") + math.pi, math.pi * 2), true) end)
	end
end

function slashCommands:slashHelpList()
	SLASH_BR1, SLASH_BR2 = "/br", "/badrotations"
	slashCommands:SlashCommandHelp("br", "Toggles BadRotations On/Off")
	slashCommands:SlashCommandHelp("br help", "Displays this list of help commands. ***Obviously***")
	slashCommands:SlashCommandHelp("br cooldowns", "Toggles CDs between on/off")
	slashCommands:SlashCommandHelp("br blacklist mouseover", "Adds/Removes mouseover unit to healing blacklist.")
	slashCommands:SlashCommandHelp("br blacklist dump", "Prints all units currently on blacklist.")
	slashCommands:SlashCommandHelp("br blacklist clear", "Clears the blacklist.")
	-- SlashCommandHelp("br pause hold","Pauses while held (via macro).")
	slashCommands:SlashCommandHelp("br pause toggle", "Switches Pause On/Off")
	slashCommands:SlashCommandHelp("br queue clear", "Clears the Spell Queue of all queued spells.")
	slashCommands:SlashCommandHelp("br queue add spellId", "Adds the Spell to the Queue by Spell Id.")
	slashCommands:SlashCommandHelp("br queue remove spellId", "Removes the Spell from the Queue by Spell Id.")
	slashCommands:SlashCommandHelp("br ui", "Shows a list of toggleable UI elements, IE: /br ui main")
	slashCommands:SlashCommandHelp("br updaterate", "Displays Current Update Rate")
	if select(2, br._G.UnitClass("player")) == "HUNTER" then
		slashCommands:SlashCommandHelp("br disengage", "Assign to macro to Forward Disengage.")
	end
	slashCommands:SlashCommandHelp("br healing", "Adds/Removes Target from Healing List")
	slashCommands:SlashCommandHelp("br baddebuff spellId", "Adds/Removes Debuff from Do Not Heal List")
end

slashCommands:slashHelpList()

local function handler(message, editbox)
	local msg = string.lower(message)
	local msg1 = getStringIndex(message, 1)
	local msg2 = getStringIndex(message, 2)
	local msg3 = getStringIndex(message, 3)
	local msg4 = getStringIndex(message, 4)
	local msg5 = getStringIndex(message, 5)
	local msg6 = getStringIndex(message, 6)
	local msg7 = getStringIndex(message, 7)
	local targetUnit
	local specialCast
	local minCount
	local range
	if msg == "" or msg == nil then
		-- Main On/Off
		toggleUI()
	elseif msg == "help" then
		-- Help
		br.SlashCommandHelp("Print Help")
	elseif msg1 == "cooldowns" then
		if not br.player then return false end
		if br.player.ui.mode.cooldown == 2 then
			br._G.RunMacroText("/br toggle Cooldown 3")
		else
			br._G.RunMacroText(
				"/br toggle Cooldown 2")
		end
	elseif msg1 == "blacklist" then
		-- Blacklist
		if msg2 == "dump" then
			br._G.print("|cffFF0000Blacklist:")
			if #br.data.blackList == (0 or nil) then
				br._G.print("|cffFFDD11Empty")
			end
			if br.data.blackList then
				for i = 1, #br.data.blackList do
					br._G.print("|cffFFDD11- " .. br.data.blackList[i].name)
				end
			end
		elseif msg2 == "clear" then
			br.data.blackList = {}
			br._G.print("|cffFF0000Blacklist Cleared")
		elseif msg2 == "mouseover" then
			if not br.data.blackList then
				br.data.blackList = {}
			end
			if br.functions.unit:GetUnitExists("mouseover") then
				local mouseoverName = br._G.UnitName("mouseover")
				local mouseoverGUID = br._G.UnitGUID("mouseover")
				-- Now we're trying to find that unit in the blackList table to remove
				local found
				for k, v in pairs(br.data.blackList) do
					-- Now we're trying to find that unit in the Cache table to remove
					if br._G.UnitGUID("mouseover") == v.guid then
						br._G.tremove(br.data.blackList, k)
						br._G.print("|cffFFDD11" .. mouseoverName .. "|cffFF0000 Removed from Blacklist")
						found = true
						--blackList[k] = nil
					end
				end
				if not found then
					br._G.print("|cffFFDD11" .. mouseoverName .. "|cffFF0000 Added to Blacklist")
					br._G.tinsert(br.data.blackList, { guid = mouseoverGUID, name = mouseoverName })
				end
			end
		else
			br._G.print("Invalid Option for: |cFFFF0000" ..
				msg1 .. "|r try |cffFFDD11 /br help |r for available options.")
		end
	elseif msg1 == "pause" then
		-- Pause
		--[[if msg2 == "hold" then
			br.ui.chatOverlay:Show("Profile Paused")
			return true
		else]]
		if msg2 == "toggle" then
			if br.data.settings[br.loader.selectedSpec].toggles["Pause"] == 0 then
				br.ui.chatOverlay:Show("\124cFFED0000 -- Paused -- ")
				br._G.print("|cFFFF0000Paused")
				br.data.settings[br.loader.selectedSpec].toggles["Pause"] = 1
			else
				br.ui.chatOverlay:Show("\124cFF3BB0FF -- Pause Removed -- ")
				br._G.print("|cFF3BB0FFPause Removed")
				br.data.settings[br.loader.selectedSpec].toggles["Pause"] = 0
			end
		else
			br._G.print(
				"Invalid Option for: |cFFFF0000" ..
				msg1 ..
				"|r try " --[["|cffFFDD11 /br pause hold |r - Pauses while held (via macro) or ]] ..
				"|cffFFDD11 /br pause toggle |r - Switches Pause On/Off"
			)
		end
	elseif msg1 == "toggle" then
		-- Toggles
		if msg2 ~= nil and msg4 == nil then
			if toggle(msg2, msg3, true) then
				toggle(msg2, msg3)
			else
				br._G.print("Invalid Toggle: |cFFFF0000" .. msg2 .. "|r try |cffFFDD11 /br help |r for list of toggles.")
			end
		elseif msg2 ~= nil and msg4 ~= nil then
			toggleRange(msg2, msg3, msg4)
		else
			br._G.print("No Toggle Specified: Try |cffFFDD11 /br help |r for list of toggles.")
		end
	elseif msg1 == "queue" then
		-- Queue
		if msg2 == "clear" then
			if br.player.queue == nil then
				br._G.print("Queue Already Cleared")
			end
			if #br.player.queue == 0 then
				br._G.print("Queue Already Cleared")
			end
			if #br.player.queue > 0 then
				br.player.queue = {}
				br._G.print("Cleared Queue")
			end
		elseif msg2 == "add" then
			if msg3 == nil then
				br._G.print("No Spell Provided to add to Queue.")
			elseif msg3 == "help" then
				br._G.print(
					"Queue Add Conditions\n" ..
					"Example: /br queue add 123456 player aoe 3 8\n\n" ..
					"123456 = Spell ID, this is required for queue.\n" ..
					"player = Target (optional), where to cast spell using standard macro targets or (nil, best, playerGround, targetGround, pettarget)\n" ..
					"aoe    = Cast Type (optional), if the spell you are queuing has special cast type, (nil, aoe, cone, rect, ground, dead)\n" ..
					"3 	   = Minimal Units to cast on (optional), specify the minimal number of units required to cast the spell or nil for none.\n" ..
					"8      = Spells effect range (optional), specify the damage effect range of the spell or nil for none.\n\n" ..
					'This will cast spell 123456 on "player" as an AOE once there are at least 3 units within 8 yards of the player.\n'
				)
			else
				local spellName, _, _, _, _, _, spellId = br._G.GetSpellInfo(msg3)
				local notOnCD = true
				if br ~= nil and br.player ~= nil and spellName ~= nil then
					notOnCD = br.functions.spell:getSpellCD(spellName) <= br.player.gcdMax
				end
				if msg4 ~= nil then
					targetUnit = tostring(msg4)
				end
				if msg5 ~= nil then
					specialCast = tostring(msg5)
				end
				if msg6 ~= nil then
					minCount = tonumber(msg6)
				end
				if msg7 ~= nil then
					range = tonumber(msg7)
				end
				if spellName == nil then
					br._G.print("Invalid Spell ID: |cffFFDD11 Unable to add.")
				elseif not notOnCD then
					br._G.print("Spell |cFFFF0000" .. spellName .. "|r not added, cooldown greater than gcd.")
				else
					if #br.player.queue == 0 and notOnCD then
						br._G.tinsert(
							br.player.queue,
							{
								id = spellId,
								name = spellName,
								target = targetUnit,
								castType = specialCast,
								minUnits = minCount,
								effectRng = range
							}
						)
						br._G.print("Added |cFFFF0000" .. spellName .. "|r to the queue.")
					elseif #br.player.queue ~= 0 then
						for i = 1, #br.player.queue do
							if spellId == br.player.queue[i].id then
								br._G.print("|cFFFF0000" .. spellName .. "|r is already queued.")
								break
							elseif notOnCD then
								br._G.tinsert(
									br.player.queue,
									{
										id = spellId,
										name = spellName,
										target = targetUnit,
										castType = specialCast,
										minUnits = minCount,
										effectRng = range
									}
								)
								br._G.print("Added |cFFFF0000" .. spellName .. "|r to the queue.")
								break
							end
						end
					end
				end
			end
		elseif msg2 == "remove" then
			if msg3 == nil then
				br._G.print("No Spell Provided to remove from Queue.")
			else
				local spellName, _, _, _, _, _, spellId = br._G.GetSpellInfo(msg3)
				local removedSpell = false
				if #br.player.queue ~= 0 then
					for i = 1, #br.player.queue do
						if spellId == br.player.queue[i].id then
							br._G.tremove(br.player.queue, i)
							br._G.print("Removed |cFFFF0000" .. spellName .. "|r from the queue.")
							removedSpell = true
							break
						end
					end
				end
				if not removedSpell then
					if spellName == nil then
						br._G.print("Invalid Spell ID: |cffFFDD11 Unable to remove.")
					else
						br._G.print("Spell Not Found: Failed to remove |cFFFF0000" .. spellName .. "|r from the queue. ")
					end
				end
			end
		elseif msg2 == nil then
			br._G.print(
				"Invalid Option for: |cFFFF0000" ..
				msg1 ..
				"|r try |cffFFDD11 /br queue clear |r - Clears the Queue list or |cffFFDD11 /br queue add (spell)|r - Adds specified spell to Queue list or |cffFFDD11 /br queue remove (spell) |r - Removes specifid from Queue list."
			)
		end
	elseif msg == "updaterate" then
		-- Show Update Rate
		updateRate()
	elseif msg1 == "healing" then
		-- Special Heal List
		local unit
		if br.functions.unit:GetUnitExists("mouseover") then
			unit = "mouseover"
		elseif br.functions.unit:GetUnitExists("focus") then
			unit = "focus"
		elseif br.functions.unit:GetUnitExists("target") then
			unit = "target"
		end
		if unit then
			local unitName = br._G.UnitName(unit)
			local unitGUID = br._G.UnitGUID(unit)
			if br.engines.healingEngineCollections.SpecialHealUnitList[unitGUID] ~= nil then
				br.engines.healingEngineCollections.SpecialHealUnitList[unitGUID] = nil
				br._G.print("|cffFFDD11" .. unitName .. "|cffFF0000 Removed from Special Heal List")
			else
				br._G.print("|cffFFDD11" .. unitName .. "|cffFF0000 Added to Special Heal List")
				br.engines.healingEngineCollections.SpecialHealUnitList[unitGUID] = unitName
			end
		else
			br._G.print("No Target Found.  Please Select a Target Before Adding")
		end
	elseif msg1 == "debuff" then
		-- Debuff List
		if msg2 == nil then
			br._G.print("No Spell Provided to Add")
		else
			local spellName, _, _, _, _, _, spellId = br._G.GetSpellInfo(msg3)
			if spellName == nil then
				br._G.print("Invalid Spell ID: |cffFFDD11 Unable to add.")
			else
				if br.engines.healingEngineCollections.BadDebuffList[spellId] ~= nil then
					br.engines.healingEngineCollections.BadDebuffList[spellId] = nil
					br._G.print("|cffFFDD11" .. spellName .. "|cffFF0000 Removed from Debuff List")
				else
					br._G.print("|cffFFDD11" .. spellName .. "|cffFF0000 Added to Debuff List")
					br.engines.healingEngineCollections.BadDebuffList[spellId] = spellName
				end
			end
		end
	elseif msg == "disengage" then
		-- Forward Disengage
		if br._G.IsLeftShiftKeyDown() then
			br._G.CastSpellByName(br._G.GetSpellInfo(781))
		else
			forewardDisengage()
		end
	elseif msg1 == "ui" then
		-- Updater
		-- Other
		if msg2 == "main" then
			-- Show/Hide Bot Options
			br.ui:toggleWindow("config")
		elseif msg2 == "profile" then
			-- Show/Hide Profile Option
			br.ui:toggleWindow("profile")
		elseif msg2 == "togglebar" then
			-- Show/Hide Toggle Bar
			if br._G.UnitAffectingCombat("player") then
				br._G.print(
					"Combat Lockdown detected. Unable to modify button bar. Please try again when out of combat.")
			else
				if br.data.settings[br.loader.selectedSpec].toggles["Main"] == 1 then
					br.data.settings[br.loader.selectedSpec].toggles["Main"] = 0
					br.ui.toggles.mainButton:Hide()
				else
					br.data.settings[br.loader.selectedSpec].toggles["Main"] = 1
					br.ui.toggles.mainButton:Show()
				end
			end
		elseif msg2 == "icon" then
			if br.hiddenIcon == nil or br.hiddenIcon == false then
				br.ui.minimapButton.frame:Hide()
				br.hiddenIcon = true
			else
				br.ui.minimapButton.frame:Show()
				br.hiddenIcon = false
			end
		elseif msg2 == nil then
			-- Show UI Options
			br._G.print(
				"Please provide one of the following options with showUI\n" ..
				"|cFFFF0000 main |r - Shows/Hides main bot options\n" ..
				"|cFFFF0000 profile |r - Shows/Hides profile options\n" ..
				"|cFFFF0000 togglebar |r - Shows/Hides toggle bar\n" ..
				"|cFFFF0000 icon |r - Shows/Hides minimap button\n"
			)
		end
	elseif msg1 == "update" then
		br.updater:Update()
	else
		br._G.print("Invalid Command: |cFFFF0000" .. msg .. "|r try |cffFFDD11 /br help")
	end
end

-- macro used to gather caster/spell/buff on our actual target
SLASH_dumpInfo1 = "/dumpinfo"
local function dumpInfo(msg, editbox)
	-- find unit in our engines
	for k, _ in pairs(br.engines.enemiesEngine.enemy) do
		if br.engines.enemiesEngine.enemy[k].guid == br._G.UnitGUID("target") then
			_G.targetInfo = {}
			_G.targetInfo.name = br._G.UnitName("target")
			local thisUnit = br.engines.enemiesEngine.enemy[k].unit
			_G.targetInfo.unitID = thisUnit.id
			local buff1 = br.functions.aura:UnitBuff("target", 1)
			local buff2 = br.functions.aura:UnitBuff("target", 2)
			local deBuff1 = br.functions.aura:UnitBuff("target", 1)
			local deBuff2 = br.functions.aura:UnitBuff("target", 2)
			if buff1 then
				_G.targetInfo.buff1 = buff1
			end
			if buff2 then
				_G.targetInfo.buff2 = buff2
			end
			if deBuff1 then
				_G.targetInfo.deBuff1 = deBuff1
			end
			if deBuff2 then
				_G.targetInfo.deBuff2 = deBuff2
			end
			br._G.RunMacroText("/dump targetInfo")
			_G.targetInfo = {}
			break
		end
	end
end

br._G.SlashCmdList["BR"] = handler
br._G.SlashCmdList.dumpInfo = dumpInfo