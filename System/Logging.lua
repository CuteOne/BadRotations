local _, br = ...
---------------------------------------------------------------------------------------------------
-- Logging
---------------------------------------------------------------------------------------------------
-- All of BR's output:
--   Chat          br._G.print (info), br.log:warning, br.log:error, br.log:say (a labelled line),
--                 br.log:more (a continuation line); see "Chat" below for the look.
--   Log files     br.log:file(name, cap) gives a function that adds a line to <WoW folder>\<name>
--                 (BRLoot.log, ...), written for reading between sessions. Lines are buffered and
--                 written once a second, when combat ends and on logout/reload: writing a line used
--                 to read and rewrite the whole file (up to 256 KB) on the game's thread.
--   Chat record   br.log:chat(text) keeps every line BR prints in chat: in BRChat.log and in the
--                 last RECENT_LINES lines, which /br log shows in a window to copy from, so copying
--                 out of chat doesn't depend on a chat addon.
-- Every line is made printable here (a value the game flags secret prints as <SECRET> and can't be
-- written to a file), with color codes and links reduced to their text.
br.log = br.log or {}
local log = br.log

local LOG_MAX_BYTES = 262144 -- a file keeps its newest lines up to this size
local FLUSH_EVERY = 1        -- seconds between writes
local DEFAULT_CAP = 2000     -- lines per file per session, unless the file asks for another (a runaway guard)
local CHAT_CAP = 3000        -- BRChat.log lines per session
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
	state.pending[#state.pending + 1] = ("%.1f "):format(GetTime()) .. log.plain(text)
	dirty = true
end

--- The function that adds a line to <WoW folder>\<name>. cap: lines per session (DEFAULT_CAP).
function log:file(name, cap)
	fileState(name, cap)
	return function(text) log:write(name, text) end
end

--- Writes the buffered lines. Each file is read afresh first (unlockers' WriteFile can't append),
-- so lines removed from it while the game runs stay removed. Without the unlocker's file functions
-- the lines wait (each file's cap bounds them).
function log:flush()
	if not dirty then return end
	local writeFile, readFile, wowDirectory = br._G.WriteFile, br._G.ReadFile, br._G.GetWoWDirectory
	if writeFile == nil or readFile == nil or wowDirectory == nil then return end
	dirty = false
	local folder = wowDirectory()
	for name, state in pairs(files) do
		if #state.pending > 0 then
			local path = folder .. "\\" .. name
			local ok, current = pcall(readFile, path)
			if not ok or type(current) ~= "string" then current = "" end
			local added = tconcat(state.pending, "\n") .. "\n"
			if not state.started then
				state.started = true
				added = sessionHeader .. "\n" .. added
			end
			local content = current .. added
			if #content > LOG_MAX_BYTES then
				local cut = content:find("\n", #content - LOG_MAX_BYTES / 2, true)
				content = content:sub((cut or 0) + 1)
			end
			pcall(writeFile, path, content, false)
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
	label = "|cffFFDD11",
	highlight = "|cffFFDD11",
	text = "|cffFFFFFF",
}

--- text in the highlight color, for names and values inside a line
function log.highlight(text)
	return log.colors.highlight .. tostring(text) .. "|r"
end

--- The one chat print: the tag, then msg; recorded (BRChat.log, /br log) without the tag.
function br._G.print(msg)
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

--- A Profile Debug line: what the rotation did
function log:debug(text) debugLine(text, false) end

--- A System Debug line: BR's own reasoning and state
function log:systemDebug(text) debugLine(text, true) end

---------------------------------------------------------------------------------------------------
-- Chat record
---------------------------------------------------------------------------------------------------
local chatLine = log:file("BRChat.log", CHAT_CAP)
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

-- /br log: the recorded chat lines in a window, selected, ready for Ctrl+C
local copyWindow, copyBox
function log:showRecent()
	local DiesalGUI = _G.LibStub and _G.LibStub("DiesalGUI-1.0", true)
	if DiesalGUI == nil then return end
	if copyWindow == nil then
		copyWindow = DiesalGUI:Create("Window")
		copyWindow:SetTitle(((br.ui and br.ui.colors and br.ui.colors.class) or "") .. "BadRotations", "Chat log - Ctrl+C copies")
		copyWindow.settings.width = 640
		copyWindow.settings.height = 420
		copyWindow.settings.header = true
		copyWindow.settings.footer = true
		copyWindow.frame:SetClampedToScreen(true)
		copyWindow:ApplySettings()
		copyBox = DiesalGUI:Create("ScrollingEditBox")
		copyWindow:AddChild(copyBox)
		copyBox:SetParent(copyWindow.content)
		copyBox:SetAllPoints(copyWindow.content)
		copyBox.settings.contentPadding = { 4, 4, 4, 4 }
		copyBox:ApplySettings()
		copyBox:SetEventListener("OnEscapePressed", function() copyBox.editBox:ClearFocus() end)
	end
	local lines = log:recentChat()
	local text = #lines > 0 and tconcat(lines, "\n") or "Nothing printed yet this session."
	-- The box puts this text back when it loses focus, so typing in it changes nothing
	copyBox.settings.text = text
	copyBox:SetText(text)
	copyWindow:Show()
	copyBox.editBox:SetFocus()
	copyBox.editBox:HighlightText()
end

---------------------------------------------------------------------------------------------------
-- Flushing
---------------------------------------------------------------------------------------------------
br._G.C_Timer.NewTicker(FLUSH_EVERY, function() log:flush() end)
local flushEvents = br._G.CreateFrame("Frame")
flushEvents:RegisterEvent("PLAYER_REGEN_ENABLED") -- a fight's lines, right when it ends
flushEvents:RegisterEvent("PLAYER_LOGOUT")        -- also on /reload
flushEvents:SetScript("OnEvent", function() log:flush() end)

-- Lines from files that load before BR's chat exists (Expansions/shared.lua), printed once every
-- file has loaded: the tag's class color (System/UI/Colors.lua) isn't set until later in the TOC
br._G.C_Timer.After(0, function()
	for _, message in ipairs(br.earlyMessages or {}) do br._G.print(message) end
	br.earlyMessages = nil
end)
