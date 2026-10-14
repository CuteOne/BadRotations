local _, br = ...
---------------------------------------------------------------------------------------------------
-- Logging
---------------------------------------------------------------------------------------------------
-- Where BR's output goes besides the game's chat window:
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

--- Text as it can be printed and written: flagged text rebuilt (misc:plainText), color codes and
-- link markup reduced to the text. A line holding a value BR can't read says so instead.
function log.plain(text)
	local ok, plain = pcall(function()
		local value = tostring(text)
		local misc = br.functions and br.functions.misc
		if misc and misc.plainText then value = misc:plainText(value) end
		value = value:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", ""):gsub("|H.-|h(.-)|h", "%1"):gsub("|T.-|t", "")
		return value
	end)
	return ok and plain or "(a line holding a value BR can't read)"
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
