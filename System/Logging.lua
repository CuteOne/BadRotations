local _, br = ...
---------------------------------------------------------------------------------------------------
-- Logging
---------------------------------------------------------------------------------------------------
-- All of BR's output:
--   Chat          br._G.print (info), br.log:warning, br.log:error, br.log:say (a labelled line),
--                 br.log:more (a continuation line); see "Chat" below for the look.
--   Log files     br.log:file(name, cap) gives a function that adds a line to BadRotations\Logs\<name>
--                 (Loot.log, ...), written for reading between sessions (a user can send the folder
--                 to whoever helps them). Lines are buffered and added to the file once a second,
--                 when combat ends and on logout/reload.
--   Chat record   br.log:chat(text) keeps every line BR prints in chat: in Chat.log and in the
--                 last RECENT_LINES lines, which /br log shows in a window to copy from, so copying
--                 out of chat doesn't depend on a chat addon.
-- Every line is made printable here (a value the game flags secret prints as <SECRET> and can't be
-- written to a file), with color codes and links reduced to their text.
br.log = br.log or {}
local log = br.log

local LOG_MAX_BYTES = 262144 -- a file bigger than this when a session starts keeps its newest half
local FLUSH_EVERY = 1        -- seconds between writes
local DEFAULT_CAP = 2000     -- lines per file per session, unless the file asks for another (a runaway guard)
local CHAT_CAP = 3000        -- Chat.log lines per session
local RECENT_LINES = 500     -- chat lines /br log shows

local GetTime, date = br._G.GetTime, br._G.date
local tconcat, wipe = table.concat, br._G.wipe

-- Every file's first lines this session start with this, so its game-time stamps can be matched
-- to the clock (the stamps are GetTime: seconds the computer has been up)
local sessionHeader = ("=== session %s, loaded at game time %.1f ==="):format(
	date and date("%Y-%m-%d %H:%M:%S") or "?", GetTime())

local UNREADABLE = "(a line holding a value BR can't read)"

--- Text as chat can show it: flagged text rebuilt (misc:plainText). A line holding a value BR
-- can't read says so instead.
function log.printable(text)
	local ok, value = pcall(function()
		local misc = br.functions and br.functions.misc
		local value = tostring(text)
		if misc and misc.plainText then value = misc:plainText(value) end
		return value .. "" -- fails here on a value BR can't use
	end)
	return ok and value or UNREADABLE
end

--- Text as it is written to a file: printable, with color codes and link markup reduced to the text
function log.plain(text)
	local ok, value = pcall(function()
		return (log.printable(text):gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", ""):gsub("|H.-|h(.-)|h", "%1"):gsub("|T.-|t", ""))
	end)
	return ok and value or UNREADABLE
end

---------------------------------------------------------------------------------------------------
-- Privacy
---------------------------------------------------------------------------------------------------
-- The log files may be sent to whoever helps a user, so nothing in them names a person: the player
-- is "Me", every other player a stand-in kept for the session ("Party2[PRIEST]", "Player5[ROGUE]"),
-- and realms, player GUIDs and the user name in file paths are left out. NPCs keep their names
-- (what was fought matters). Chat and the /br log window are the user's own: real names there.
-- Players are known from the group, and from log:notePlayer, which code writing a unit's name to
-- a file calls first.
local standIns = {}  -- player name -> what the files say instead
local names = {}     -- the names in standIns, longest first (so "Ann" doesn't cut into "Anna")
local realms = {}    -- realm names, left out once the names are replaced
local counts = {}    -- stand-ins handed out per kind (Party, Raid, Player)

local function usableText(value)
	local misc = br.functions and br.functions.misc
	return type(value) == "string" and value ~= "" and (misc == nil or misc.canUseValue == nil or misc:canUseValue(value))
end

local function standIn(name, replacement)
	if not usableText(name) or standIns[name] then return end
	standIns[name] = replacement
	names[#names + 1] = name
	table.sort(names, function(a, b) return #a > #b end)
end

local function noteRealm(realm)
	if not usableText(realm) then return end
	for i = 1, #realms do if realms[i] == realm then return end end
	realms[#realms + 1] = realm
	table.sort(realms, function(a, b) return #a > #b end)
end

--- Notes a unit that is a player, so the log files show its stand-in instead of its name. Returns
-- the stand-in (nil for an NPC or a unit that can't be read).
function log:notePlayer(unit)
	local G = br._G
	local ok, result = pcall(function()
		if unit == nil or not G.UnitIsPlayer or not G.UnitIsPlayer(unit) then return nil end
		local name, realm = G.UnitName(unit)
		if not usableText(name) then return nil end
		noteRealm(realm)
		if standIns[name] then return standIns[name] end
		if G.UnitIsUnit(unit, "player") then
			standIn(name, "Me")
			return "Me"
		end
		local kind = (G.UnitInRaid and G.UnitInRaid(unit) and "Raid")
			or (G.UnitInParty and G.UnitInParty(unit) and "Party") or "Player"
		counts[kind] = (counts[kind] or 0) + 1
		local _, class = G.UnitClass(unit)
		local replacement = kind .. counts[kind] .. (usableText(class) and ("[" .. class .. "]") or "")
		standIn(name, replacement)
		return replacement
	end)
	return ok and result or nil
end

-- The player, their realm and the group, as it changes
local function noteGroup()
	log:notePlayer("player")
	if br._G.GetRealmName then noteRealm(br._G.GetRealmName()) end
	local raid = br._G.IsInRaid and br._G.IsInRaid()
	for i = 1, raid and 40 or 4 do log:notePlayer((raid and "raid" or "party") .. i) end
end

-- A letter or digit (any byte of a non-ASCII letter counts), for whole-word matches
local function wordByte(b)
	return b ~= nil and (b >= 128 or (b >= 48 and b <= 57) or (b >= 65 and b <= 90) or (b >= 97 and b <= 122))
end

-- Every whole-word name in text replaced (withRealm: a "-Realm" after it too)
local function replaceName(text, name, replacement, withRealm)
	local parts, from = {}, 1
	while true do
		local first, last = text:find(name, from, true)
		if not first then break end
		if wordByte(text:byte(first - 1)) or wordByte(text:byte(last + 1)) then
			parts[#parts + 1] = text:sub(from, last)
		else
			if withRealm and text:sub(last + 1, last + 1) == "-" and wordByte(text:byte(last + 2)) then
				last = last + 1
				while wordByte(text:byte(last + 1)) do last = last + 1 end
			end
			parts[#parts + 1] = text:sub(from, first - 1) .. replacement
		end
		from = last + 1
	end
	if from == 1 then return text end
	parts[#parts + 1] = text:sub(from)
	return tconcat(parts)
end

local groupNoted = false
--- A file line with the people taken out (see above)
function log.private(text)
	if not groupNoted then
		groupNoted = true
		noteGroup()
	end
	for i = 1, #names do
		local name = names[i]
		if text:find(name, 1, true) then text = replaceName(text, name, standIns[name], true) end
	end
	for i = 1, #realms do
		local realm = realms[i]
		if text:find(realm, 1, true) then text = replaceName(text, realm, "<realm>") end
	end
	return (text:gsub("Player%-%d+%-%x+", "Player-<guid>")
		:gsub("([A-Za-z]:[\\/][Uu]sers[\\/])[^\\/]+", "%1<user>")
		:gsub("(/home/)[^/]+", "%1<user>")
		:gsub("(/Users/)[^/]+", "%1<user>"))
end

---------------------------------------------------------------------------------------------------
-- Log files
---------------------------------------------------------------------------------------------------
local files = {} -- name -> { cap, lines (this session), pending = {}, started, capped }
local dirty = false

local function fileState(name, cap)
	local state = files[name]
	if state == nil then
		state = { cap = cap or DEFAULT_CAP, lines = 0, pending = {}, started = false, capped = false }
		files[name] = state
	elseif cap then
		state.cap = cap
	end
	return state
end

--- Adds a line to a log file (written on the next flush). Past the file's cap one line says the
-- rest of the session is left out.
function log:write(name, text)
	local state = fileState(name)
	if state.lines >= state.cap then
		if not state.capped then
			state.capped = true
			state.pending[#state.pending + 1] = ("--- %d lines this session: the rest are left out ---"):format(state.cap)
			dirty = true
		end
		return
	end
	state.lines = state.lines + 1
	-- clock time (to match what the user remembers) and game time (to match other BR timings)
	state.pending[#state.pending + 1] = (date and date("%H:%M:%S ") or "") .. ("%.1f "):format(GetTime()) .. log.plain(text)
	dirty = true
end

--- The function that adds a line to BadRotations\Logs\<name>. cap: lines per session (DEFAULT_CAP).
function log:file(name, cap)
	fileState(name, cap)
	return function(text) log:write(name, text) end
end

-- BR's Logs folder (next to its Settings folder: misc:getAddonPath), made if it's missing
local folder, separator
local function logFolder()
	if folder then return folder, separator end
	local misc = br.functions and br.functions.misc
	if not (misc and misc.getAddonPath) or br._G.GetWoWDirectory == nil then return nil end
	local base, sep = misc:getAddonPath()
	local dir = base .. sep .. "Logs"
	if br._G.DirectoryExists and br._G.CreateDirectory and not br._G.DirectoryExists(dir) then
		pcall(br._G.CreateDirectory, dir)
	end
	folder, separator = dir, sep
	return folder, separator
end

--- Writes the buffered lines, added to the end of each file (System/Unlockers.lua: WriteFile's
-- append). A file's first write in a session trims it if it grew past LOG_MAX_BYTES, so the
-- folder stays small without anyone emptying it; each file's line cap bounds one session. Without
-- the unlocker's file functions the lines wait.
function log:flush()
	if not dirty then return end
	local writeFile, readFile = br._G.WriteFile, br._G.ReadFile
	local dir, sep = logFolder()
	if writeFile == nil or readFile == nil or dir == nil then return end
	-- Nothing is written before the player's settings are loaded, and nothing at all with
	-- Write Log Files unticked (Bot Options > Debug Options): the lines are dropped
	local specSettings = br.data and br.data.settings and br.loader and br.data.settings[br.loader.selectedSpec]
	if not (specSettings and specSettings[br.loader.selectedProfile]) then return end
	dirty = false
	local misc = br.functions and br.functions.misc
	if misc and misc.isUnchecked and misc:isUnchecked("Write Log Files") then
		for _, state in pairs(files) do wipe(state.pending) end
		return
	end
	for name, state in pairs(files) do
		if #state.pending > 0 then
			local path = dir .. sep .. name
			local added = log.private(tconcat(state.pending, "\n")) .. "\n"
			if not state.started then
				state.started = true
				local ok, current = pcall(readFile, path)
				if not ok or type(current) ~= "string" then current = "" end
				if #current > LOG_MAX_BYTES then
					local cut = current:find("\n", #current - LOG_MAX_BYTES / 2, true)
					current = current:sub((cut or 0) + 1)
				end
				pcall(writeFile, path, current .. sessionHeader .. "\n" .. added, false)
			else
				pcall(writeFile, path, added, true)
			end
			wipe(state.pending)
		end
	end
end

---------------------------------------------------------------------------------------------------
-- Chat
---------------------------------------------------------------------------------------------------
-- Every BR line in chat looks the same: the class-colored [BadRotations] tag, then an optional
-- label, then the text. Levels: info (br._G.print, no label), warning, error. Tools label their
-- lines (br.log:say("Range", ...)); debug lines are labelled System Debug / Profile Debug
-- (br.log:systemDebug, br.log:debug). Names and values in the text use one highlight color (log.highlight).
log.colors = {
	error = "|cffFF4040",
	warning = "|cffFF8800",
	success = "|cff40FF40",
	label = "|cffFFDD11",
	highlight = "|cffFFDD11",
	text = "|cffFFFFFF",
	muted = "|cff8C8C8C", -- detail a line can do without: row numbers, times, where it came from
}

--- text in the highlight color, for names and values inside a line
function log.highlight(text)
	return log.colors.highlight .. tostring(text) .. "|r"
end

--- The one chat print: the tag, then msg; recorded (Chat.log, /br log) without the tag. BR's own
--- version of print (br.api.overrides), so br._G.print and profiles' print use it.
function br.api.overrides.print(msg)
	if msg == nil then return end
	local color = (br.ui and br.ui.colors and br.ui.colors.class) or ""
	print(color .. "[BadRotations] |r" .. log.printable(msg))
	log:chat(msg)
end

--- A line that continues the one before it (a list, help), without the tag
function log:more(text)
	print(log.printable(text))
	log:chat(text)
end

--- A line with a label ("Range: ...", "Error: ...") in labelColor (gold when nil)
function log:say(label, text, labelColor)
	br._G.print((labelColor or log.colors.label) .. label .. ":|r " .. tostring(text))
end

--- Something went wrong (a file that can't load, a setting that can't be saved, a mistake in a profile)
function log:error(text) log:say("Error", text, log.colors.error) end

--- Something is off but BR carries on (a fallback was used, something was skipped)
function log:warning(text) log:say("Warning", text, log.colors.warning) end

-- Addon Debug Messages, shown by the option's choice (1 System Only, 2 Profile Only, 3 All):
--   br.log:debug        Profile Debug: what the rotation did (its casts and item uses, opener
--                       steps, combat start/end); ui.debug and shared modules acting for a profile
--   br.log:systemDebug  System Debug: BR's own reasoning and state (cast gates and refusals, the
--                       loader's stages, engines)
-- The same line again within REPEAT_GAP seconds isn't repeated ("Casting" lines within 0.05 s: a
-- spell cast twice in a row is shown twice).
local REPEAT_GAP, CAST_REPEAT_GAP = 0.1, 0.05
local lastShown, lastShownCount = {}, 0 -- full line -> GetTime it was shown; cleared when it grows

local function debugLine(msg, system)
	local misc = br.functions and br.functions.misc
	if msg == nil or misc == nil or misc.isChecked == nil or not misc:isChecked("Addon Debug Messages") then return end
	local choice = misc:getValue("Addon Debug Messages")
	if system then
		if choice ~= 1 and choice ~= 3 then return end
	elseif choice ~= 2 and choice ~= 3 then
		return
	end
	local text = tostring(msg)
	-- Flagged text BR may use prints as plain text; text BR can't read says where it came from
	if not misc:canUseValue(text) then
		local where = br.ui.elementOptions and br.ui.elementOptions.rotationLine(true) or ""
		text = "(a debug line holding a secret value, from " .. (where ~= "" and where:gsub(":%s*$", "") or "BR") .. ")"
	else
		text = misc:plainText(text)
	end
	local label = system and "System Debug" or "Profile Debug"
	local key = label .. text
	local now = GetTime()
	local gap = (not system and text:find("Casting", 1, true)) and CAST_REPEAT_GAP or REPEAT_GAP
	if lastShown[key] and now - lastShown[key] < gap then return end
	if lastShownCount >= 200 then wipe(lastShown); lastShownCount = 0 end
	if not lastShown[key] then lastShownCount = lastShownCount + 1 end
	lastShown[key] = now
	log:say(label, log.colors.text .. text, br.ui.colors.class)
end

--- A Profile Debug line: what the rotation did. "Casting ..." also labels the cast the profile just
-- sent (System/RotationLog.lua), shown or not.
function log:debug(text)
	if log.rotation then log.rotation:label(text) end
	debugLine(text, false)
end

--- A System Debug line: BR's own reasoning and state
function log:systemDebug(text) debugLine(text, true) end

---------------------------------------------------------------------------------------------------
-- Errors
---------------------------------------------------------------------------------------------------
-- BR's Lua errors (its scripts, timers, profile loading) are written to Errors.log with their stack,
-- then go on to the game's error handler (BugSack) as before. A repeated error is written in full
-- ERROR_FULL times, then counted every ERROR_EVERY.
local ERROR_FULL, ERROR_EVERY = 3, 100
local errorLine = log:file("Errors.log")
local errorCounts = {}

--- Reports a Lua error from BR's code: Errors.log, then the game's error handler. stack: where it
-- happened (debugstack from the error handler); nil leaves the stack out.
function log:reportError(err, stack)
	local text = log.plain(err)
	local count = (errorCounts[text] or 0) + 1
	errorCounts[text] = count
	if count <= ERROR_FULL then
		errorLine(("error #%d: %s"):format(count, text))
		if stack then
			for stackLine in (log.plain(stack) .. "\n"):gmatch("([^\n]*)\n") do
				if stackLine ~= "" then errorLine("    " .. stackLine) end
			end
		end
	elseif count % ERROR_EVERY == 0 then
		errorLine(("error x%d this session: %s"):format(count, text))
	end
	local handler = br._G.geterrorhandler and br._G.geterrorhandler()
	if handler then return handler(err) end
end

---------------------------------------------------------------------------------------------------
-- Chat record
---------------------------------------------------------------------------------------------------
local chatLine = log:file("Chat.log", CHAT_CAP)
local recent, recentNext = {}, 1 -- ring of the last RECENT_LINES chat lines

--- Records a line BR printed in chat (as shown, without the [BadRotations] tag).
function log:chat(text)
	local plain = log.plain(text)
	recent[recentNext] = (date and date("%H:%M:%S ") or "") .. plain
	recentNext = recentNext % RECENT_LINES + 1
	chatLine(plain)
end

--- The recorded chat lines, oldest first
function log:recentChat()
	local lines = {}
	for i = 0, RECENT_LINES - 1 do
		local line = recent[(recentNext + i - 1) % RECENT_LINES + 1]
		if line then lines[#lines + 1] = line end
	end
	return lines
end

-- /br log: the recorded chat lines in a window (br.ui:createWindow's copy box), selected, ready for Ctrl+C
function log:showRecent()
	local box = br.ui.window.chatlog
	if box == nil or box.parent == nil then
		box = br.ui:createWindow("chatlog", 640, 420, "Chat log - Ctrl+C copies", nil, "copy")
		br.ui.window.chatlog = box
	end
	local lines = log:recentChat()
	local text = #lines > 0 and tconcat(lines, "\n") or "Nothing printed yet this session."
	-- The box puts this text back when it loses focus, so typing in it changes nothing
	box.settings.text = text
	box:SetText(text)
	br.ui:showWindow("chatlog")
	box.editBox:SetFocus()
	box.editBox:HighlightText()
end

---------------------------------------------------------------------------------------------------
-- Flushing
---------------------------------------------------------------------------------------------------
br._G.C_Timer.NewTicker(FLUSH_EVERY, function() log:flush() end)
local flushEvents = br._G.CreateFrame("Frame")
flushEvents:RegisterEvent("PLAYER_REGEN_ENABLED") -- a fight's lines, right when it ends
flushEvents:RegisterEvent("GROUP_ROSTER_UPDATE")  -- new group members get their stand-ins
flushEvents:SetScript("OnEvent", function(_, event)
	if event == "GROUP_ROSTER_UPDATE" then return noteGroup() end
	log:flush()
end)

-- Lines from files that load before BR's chat exists (Expansions/Polyfills.lua), printed once every
-- file has loaded: the tag's class color (System/UI/Colors.lua) isn't set until later in the TOC
br._G.C_Timer.After(0, function()
	for _, message in ipairs(br.earlyMessages or {}) do br._G.print(message) end
	br.earlyMessages = nil
end)

-- On logout (and /reload): the last lines, after every other logout step wrote its own
br.lifecycle:onLogout(90, "log files", function() log:flush() end)
