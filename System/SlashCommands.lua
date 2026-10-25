local _, br = ...
br.slashCommands = br.slashCommands or {}
local slashCommands = br.slashCommands

-- Slash Commands
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
				br.game.print(tostring(command))
			else
				br.log:more(tostring(command))
			end
		end
		return
	end
	table.insert(br.slashCommands.commandHelp, "|cffFFFFFF        /" .. cmd .. "|cffFFDD11 - " .. msg)
	-- br.slashCommands.commandHelp = br.slashCommands.commandHelp .. "|cffFFFFFF\n        /" .. cmd .. "|cffFFDD11 - " .. msg
end

-- /br on its own: BadRotations on/off (the main button), and the minimap button shown
local function toggleUI()
	br.ui.toggles.mainButton:Click()
	br.ui.minimapButton.frame:Show()
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
				br.ui:ToggleValue(toggle)
				break
			else
				br.ui:ToggleToValue(toggle, index)
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
				br.ui:ToggleToValue(toggle, index2)
				return
			elseif tostring(br.data.settings[br.loader.selectedSpec].toggles[k]) == index2 then
				br.ui:ToggleToValue(toggle, index1)
				return
			else
				br.ui:ToggleToValue(toggle, index1)
				return
			end
		end
	end
	br.game.print("No toggle found with name: " .. tostring(name))
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
	br.game.print("Current Update Rate: " .. br.core:getUpdateRate())
end

local function forewardDisengage() -- from Stinky Twitch
	local s = br.game.C_Spell.GetSpellCooldown(781)
	if s and s.startTime == 0 then
		br.game.FaceDirection(br.game.mod(br.game.ObjectFacing("player") + math.pi, math.pi * 2), true)
		br.game.CastSpellByID(781)
		br.game.C_Timer.After(0.05,
			function() br.game.FaceDirection(br.game.mod(br.game.ObjectFacing("player") + math.pi, math.pi * 2), true) end)
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
	slashCommands:SlashCommandHelp("br why spell", "Shows why BR last refused a spell, IE: /br why maul")
	slashCommands:SlashCommandHelp("br cpu seconds", "Measures how much time BR's engines and profile take, IE: /br cpu 30")
	slashCommands:SlashCommandHelp("br target", "Shows the enemy BR focuses on and why: each candidate's score by part (also written to Target.log)")
	slashCommands:SlashCommandHelp("br log", "Shows BR's recent chat lines in a window to copy from (also in Chat.log)")
	slashCommands:SlashCommandHelp("br range [watch|stop]", "Checks BR's range rules against the game's for your target; watch prints each time they change")
	if select(2, br.game.UnitClass("player")) == "HUNTER" then
		slashCommands:SlashCommandHelp("br disengage", "Assign to macro to Forward Disengage.")
	end
	slashCommands:SlashCommandHelp("br healing", "Adds/Removes Target from Healing List")
	slashCommands:SlashCommandHelp("br baddebuff spellId", "Adds/Removes Debuff from Do Not Heal List")
end

slashCommands:slashHelpList()

local function handler(message, editbox)
	local msg = string.lower(message)
	-- the command word is matched without case; its arguments (spell names, toggles) keep theirs
	local msg1 = getStringIndex(message, 1)
	if msg1 then msg1 = string.lower(msg1) end
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
		br.slashCommands:SlashCommandHelp("Print Help")
	elseif msg1 == "cooldowns" then
		if not br.player then return false end
		br.ui:ToggleToValue("Cooldown", br.player.ui.mode.cooldown == 2 and 3 or 2)
	elseif msg1 == "blacklist" then
		-- Blacklist
		if msg2 == "dump" then
			br.log:say("Blacklist", "current entries:")
			if br.data.blackList == nil or #br.data.blackList == 0 then
				br.log:more("  empty")
			end
			if br.data.blackList then
				for i = 1, #br.data.blackList do
					br.log:more("  - " .. br.log.highlight(br.data.blackList[i].name))
				end
			end
		elseif msg2 == "clear" then
			br.data.blackList = {}
			br.log:say("Blacklist", "cleared")
		elseif msg2 == "mouseover" then
			if not br.data.blackList then
				br.data.blackList = {}
			end
			if br.functions.unit:GetUnitExists("mouseover") then
				local mouseoverName = br.game.UnitName("mouseover")
				local mouseoverGUID = br.game.UnitGUID("mouseover")
				-- Now we're trying to find that unit in the blackList table to remove
				local found
				for k, v in pairs(br.data.blackList) do
					-- Now we're trying to find that unit in the Cache table to remove
					if br.game.UnitGUID("mouseover") == v.guid then
						br.game.tremove(br.data.blackList, k)
						br.log:say("Blacklist", br.log.highlight(mouseoverName) .. " removed")
						found = true
						--blackList[k] = nil
					end
				end
				if not found then
					br.log:say("Blacklist", br.log.highlight(mouseoverName) .. " added")
					br.game.tinsert(br.data.blackList, { guid = mouseoverGUID, name = mouseoverName })
				end
			end
		else
			br.log:warning("Invalid option for " .. br.log.highlight(msg1) .. ", try /br help for available options.")
		end
	elseif msg1 == "pause" then
		-- Pause
		--[[if msg2 == "hold" then
			br.ui.chatOverlay:Show("Profile Paused")
			return true
		else]]
		if msg2 == "toggle" then
			if br.data.settings[br.loader.selectedSpec].toggles["Pause"] ~= 1 then
				br.ui.chatOverlay:Show("\124cFFED0000 -- Paused -- ")
				br.log:say("Pause", "on")
				br.data.settings[br.loader.selectedSpec].toggles["Pause"] = 1
				br.log.session:toggleChanged("Pause", 1)
			else
				br.ui.chatOverlay:Show("\124cFF3BB0FF -- Pause Removed -- ")
				br.log:say("Pause", "off")
				br.data.settings[br.loader.selectedSpec].toggles["Pause"] = 0
				br.log.session:toggleChanged("Pause", 0)
			end
		else
			br.game.print(
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
				br.log:warning("Invalid toggle " .. br.log.highlight(msg2) .. ", try /br help for the list of toggles.")
			end
		elseif msg2 ~= nil and msg4 ~= nil then
			toggleRange(msg2, msg3, msg4)
		else
			br.log:warning("No toggle specified, try /br help for the list of toggles.")
		end
	elseif msg1 == "queue" then
		-- Queue
		if br.player == nil then
			br.game.print("The queue is available once a rotation is loaded.")
		elseif msg2 == "clear" then
			if #br.functions.cast.queue == 0 then
				br.game.print("Queue Already Cleared")
			else
				br.game.wipe(br.functions.cast.queue)
				br.game.print("Cleared Queue")
			end
		elseif msg2 == "add" then
			if msg3 == nil then
				br.game.print("No Spell Provided to add to Queue.")
			elseif msg3 == "help" then
				br.game.print(
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
				local spellName, spellId = br.functions.spell:getName(msg3), br.functions.spell:getSpellID(msg3)
				local notOnCD = true
				if br ~= nil and br.player ~= nil and spellName ~= nil then
					notOnCD = br.functions.spell:getSpellCD(spellName) <= br.player.state.gcdMax
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
					br.log:warning("Invalid spell ID: unable to add.")
				elseif not notOnCD then
					br.log:say("Queue", br.log.highlight(spellName) .. " not added, cooldown greater than gcd")
				else
					if #br.functions.cast.queue == 0 and notOnCD then
						br.game.tinsert(
							br.functions.cast.queue,
							{
								id = spellId,
								name = spellName,
								target = targetUnit,
								castType = specialCast,
								minUnits = minCount,
								effectRng = range
							}
						)
						br.log:say("Queue", "Added " .. br.log.highlight(spellName))
					elseif #br.functions.cast.queue ~= 0 then
						for i = 1, #br.functions.cast.queue do
							if spellId == br.functions.cast.queue[i].id then
								br.log:say("Queue", br.log.highlight(spellName) .. " is already queued")
								break
							elseif notOnCD then
								br.game.tinsert(
									br.functions.cast.queue,
									{
										id = spellId,
										name = spellName,
										target = targetUnit,
										castType = specialCast,
										minUnits = minCount,
										effectRng = range
									}
								)
								br.log:say("Queue", "Added " .. br.log.highlight(spellName))
								break
							end
						end
					end
				end
			end
		elseif msg2 == "remove" then
			if msg3 == nil then
				br.game.print("No Spell Provided to remove from Queue.")
			else
				local spellName, spellId = br.functions.spell:getName(msg3), br.functions.spell:getSpellID(msg3)
				local removedSpell = false
				if #br.functions.cast.queue ~= 0 then
					for i = 1, #br.functions.cast.queue do
						if spellId == br.functions.cast.queue[i].id then
							br.game.tremove(br.functions.cast.queue, i)
							br.log:say("Queue", "Removed " .. br.log.highlight(spellName))
							removedSpell = true
							break
						end
					end
				end
				if not removedSpell then
					if spellName == nil then
						br.log:warning("Invalid spell ID: unable to remove.")
					else
						br.log:say("Queue", br.log.highlight(spellName) .. " not found in the queue")
					end
				end
			end
		elseif msg2 == nil then
			br.log:warning("Invalid option for " .. br.log.highlight(msg1) .. ", try /br queue clear (clears the queue),"
				.. " /br queue add (spell) or /br queue remove (spell).")
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
			local unitName = br.game.UnitName(unit)
			local unitGUID = br.game.UnitGUID(unit)
			if br.engines.healingEngineCollections.SpecialHealUnitList[unitGUID] ~= nil then
				br.engines.healingEngineCollections.SpecialHealUnitList[unitGUID] = nil
				br.log:say("Healing", br.log.highlight(unitName) .. " removed from the special heal list")
			else
				br.log:say("Healing", br.log.highlight(unitName) .. " added to the special heal list")
				br.engines.healingEngineCollections.SpecialHealUnitList[unitGUID] = unitName
			end
		else
			br.game.print("No Target Found.  Please Select a Target Before Adding")
		end
	elseif msg1 == "baddebuff" then
		-- Do Not Heal debuff list
		if msg2 == nil then
			br.game.print("No Spell Provided to Add")
		else
			local spellName, spellId = br.functions.spell:getName(msg2), br.functions.spell:getSpellID(msg2)
			if spellName == nil then
				br.log:warning("Invalid spell ID: unable to add.")
			else
				if br.engines.healingEngineCollections.BadDebuffList[spellId] ~= nil then
					br.engines.healingEngineCollections.BadDebuffList[spellId] = nil
					br.log:say("Healing", br.log.highlight(spellName) .. " removed from the debuff list")
				else
					br.log:say("Healing", br.log.highlight(spellName) .. " added to the debuff list")
					br.engines.healingEngineCollections.BadDebuffList[spellId] = spellName
				end
			end
		end
	elseif msg == "disengage" then
		-- Forward Disengage
		if br.game.IsLeftShiftKeyDown() then
			br.functions.cast:castByName(br.functions.spell:getName(781))
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
			if br.data.settings[br.loader.selectedSpec].toggles["Main"] == 1 then
				br.data.settings[br.loader.selectedSpec].toggles["Main"] = 0
				br.ui.toggles.mainButton:Hide()
			else
				br.data.settings[br.loader.selectedSpec].toggles["Main"] = 1
				br.ui.toggles.mainButton:Show()
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
			br.game.print(
				"Please provide one of the following options with showUI\n" ..
				"|cFFFF0000 main |r - Shows/Hides main bot options\n" ..
				"|cFFFF0000 profile |r - Shows/Hides profile options\n" ..
				"|cFFFF0000 togglebar |r - Shows/Hides toggle bar\n" ..
				"|cFFFF0000 icon |r - Shows/Hides minimap button\n"
			)
		end
	elseif msg1 == "cpu" then
		br.debug.cpu:profile(msg2)
	elseif msg1 == "range" then
		br.debug.range:probe(msg2)
	elseif msg1 == "log" then
		br.log:showRecent()
	elseif msg1 == "target" then
		-- Slash handlers run tainted; timer callbacks run protected (secret values readable), as /br why
		br.game.C_Timer.After(0, function() br.debug.target:report() end)
	elseif msg1 == "why" then
		-- Why did BR last refuse this spell? Covers cast.able checks, which never print.
		local spellText = message:match("^%s*%S+%s+(.-)%s*$")
		if spellText == nil or spellText == "" then
			br.log:say("Why", "Usage: /br why <spell>, IE: /br why maul")
			return
		end
		-- Slash handlers run outside BR's protected scripts, where Forever hides values
		-- such as movement speed (which distance reads); timer callbacks run protected,
		-- so report from one on the next frame.
		br.game.C_Timer.After(0, function()
			local entry = br.functions.cast:getRefusal(spellText)
			if entry == nil then
				br.log:say("Why", "No cast checks recorded for " .. br.log.highlight(spellText) ..
					" yet. The profile hasn't asked about it, or the name doesn't match.")
				return
			end
			local now = br.game.GetTime()
			local label = tostring(entry.name) .. " (" .. tostring(entry.spellID) .. ")"
			if entry.refusedAt then
				local detail = entry.detail and (": " .. tostring(entry.detail)) or ""
				-- A detail made from a secret value would hide the whole line when printed
				if br.game.issecretvalue and (br.game.issecretvalue(entry.detail) or br.game.issecretvalue(detail)) then
					detail = ": (details are a value the game keeps secret)"
				end
				br.log:say("Why", string.format("%s last refused %.1fs ago — %s%s",
					label, now - entry.refusedAt, br.log.highlight(tostring(entry.reason)), detail))
			else
				br.log:say("Why", label .. " has not been refused.")
			end
			if entry.passedAt then
				br.log:more(string.format("  Last passed every check %.1fs ago%s", now - entry.passedAt,
					(entry.refusedAt == nil or entry.passedAt > entry.refusedAt)
						and " (more recently than any refusal: if it still isn't cast, a profile condition or a higher line is stopping it)"
						or ""))
			else
				br.log:more("  Has never passed every check.")
			end
			-- BR's view of the target and the profile's dynamic units, since profile
			-- lines are often gated on these rather than on the cast checks.
			local function describe(thisUnit)
				if thisUnit == nil then return "none" end
				if not br.functions.unit:GetUnitExists(thisUnit) then return tostring(thisUnit) .. " (gone)" end
				return string.format("%s dist %.2f facing %s visible %s", tostring(br.game.UnitName(thisUnit)),
					br.functions.range:getDistance(thisUnit) or -1,
					tostring(br.functions.unit:getFacing("player", thisUnit)),
					tostring(br.functions.cast:isUnitVisible(thisUnit)))
			end
			br.log:more("  target: " .. describe("target"))
			-- The pieces of misc:isValidUnit, which dynamicTarget needs before it will
			-- hand the target to units.dynN.
			if br.functions.unit:GetUnitExists("target") then
				local misc = br.functions.misc
				-- One secret value (Forever hides some reads) makes the whole joined line secret, so
				-- each value is checked on its own, before and after tostring, and shown as <secret>
				local isSecret = br.game.issecretvalue
				local function try(fn)
					local ok, value = pcall(fn)
					if not ok then return "error" end
					if isSecret and isSecret(value) then
						-- A secret true / false BR may use: testing it gives a plain answer to show
						if type(value) == "boolean" and misc:canUseValue(value) then
							if value then return "true" end
							return "false"
						end
						return "<secret>"
					end
					local okText, text = pcall(tostring, value)
					if not okText or (isSecret and isSecret(text)) then return "<secret>" end
					return text
				end
				br.log:more("  target valid: " .. try(function() return misc:isValidUnit("target") end)
					.. " | enemyList " .. try(function() return misc:enemyListCheck("target") end)
					.. " | threat " .. try(function() return br.functions.combat:hasThreat("target") end)
					.. " | safe " .. try(function() return br.engines.enemiesEngineFunctions:isSafeToAttack("target") end)
					.. " | tapDenied " .. try(function() return br.game.UnitIsTapDenied("target") end)
					.. " | CC'd " .. try(function() return misc:isLongTimeCCed("target") end)
					.. " | reaction " .. try(function() return br.functions.unit:GetUnitReaction("target", "player") end))
			end
			-- Every dynamic unit the profile asked for (units.get(N) -> units.dynN), and
			-- "none" when one came back empty on the last tick.
			local units = br.player and br.player.units
			local requested = br.player and br.player.dynRequested
			if units and requested then
				local dynKeys = {}
				for key in pairs(requested) do dynKeys[#dynKeys + 1] = key end
				table.sort(dynKeys)
				for _, key in ipairs(dynKeys) do
					br.log:more("  units." .. key .. ": " .. describe(units[key]))
				end
			end
		end)
	elseif msg1 == "clean" or msg1 == "cleansettings" then
		if br.ui and br.ui.settingsManagement then
			br.game.print("Manually cleaning orphaned settings...")
			br.ui.settingsManagement:cleanSettings()
		else
			br.log:error("Settings management not available")
		end
	else
		br.log:warning("Invalid command " .. br.log.highlight(msg) .. ", try /br help")
	end
end

-- macro used to gather caster/spell/buff on our actual target
SLASH_dumpInfo1 = "/dumpinfo"
local function dumpInfo(msg, editbox)
	-- find unit in our engines
	for k, _ in pairs(br.engines.enemiesEngine.enemy) do
		if br.engines.enemiesEngine.enemy[k].guid == br.game.UnitGUID("target") then
			_G.targetInfo = {}
			_G.targetInfo.name = br.game.UnitName("target")
			local thisUnit = br.engines.enemiesEngine.enemy[k].unit
			_G.targetInfo.unitID = thisUnit.id
			local auras = br.game.C_UnitAuras
			local function auraName(info) return info and info.name end
			local buff1 = auraName(auras.GetBuffDataByIndex("target", 1))
			local buff2 = auraName(auras.GetBuffDataByIndex("target", 2))
			local deBuff1 = auraName(auras.GetDebuffDataByIndex("target", 1))
			local deBuff2 = auraName(auras.GetDebuffDataByIndex("target", 2))
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
			br.game.RunMacroText("/dump targetInfo")
			_G.targetInfo = {}
			break
		end
	end
end

br.game.SlashCmdList["BR"] = handler
br.game.SlashCmdList.dumpInfo = dumpInfo