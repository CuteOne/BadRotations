local _, br = ...
---------------------------------------------------------------------------------------------------
-- Rotation Log
---------------------------------------------------------------------------------------------------
-- What the rotation cast, from where in the profile, and what the game answered:
--   Announcements  every spell BR sends is a Profile Debug line at the end of the rotation tick,
--                  named by where the profile asked for it ("Casting Faerie Fire (Combat 1059)"),
--                  so two calls of the same spell can be told apart without a ui.debug line. When
--                  the profile says it itself with ui.debug("Casting ...") in the same tick, its
--                  line is the announcement ("Casting Faerie Fire [Filler]").
--   Rows           once the game answers (the cast succeeded, failed, was interrupted, or nothing
--                  came within ANSWER_WAIT), a row goes to BRRotation.log and to the Rotation Log
--                  window (Bot Options > Debug Options). Spells the player casts are rows too.
br.log.rotation = br.log.rotation or {}
local rotation = br.log.rotation
local log = br.log

local ANSWER_WAIT = 3    -- seconds after a send (or after its cast ends) before a row says "no answer"
local ERROR_WAIT = 0.5   -- a red error this soon before a failed cast is its reason
local WINDOW_ROWS = 300  -- rows the window keeps

local GetTime, wipe, tremove = br._G.GetTime, br._G.wipe, table.remove
local rowLine = log:file("BRRotation.log")

---------------------------------------------------------------------------------------------------
-- Where in the profile: function ranges per profile file
---------------------------------------------------------------------------------------------------
local sources = {} -- chunk name (the file name the loader gives loadstring) -> { {first, last, name} }

-- A line that starts a function, and the name to show for it
local function functionName(line)
	return line:match("^%s*actionList%.([%w_]+)%s*=%s*function")
		or line:match('^%s*actionList%[%s*"([^"]+)"%s*%]%s*=%s*function')
		or line:match("^%s*local%s+function%s+([%w_]+)")
		or line:match("^%s*function%s+([%w_.:]+)%s*%(")
		or line:match("^%s*local%s+([%w_]+)%s*=%s*function")
end

--- Indexes a profile file's functions (ProfileLoader, as it loads the file). A function runs from
-- its first line to the "end" at the same indent, as BR's profiles are written.
function rotation:registerSource(chunkName, text)
	if type(chunkName) ~= "string" or type(text) ~= "string" then return end
	local ranges, open, n = {}, {}, 0
	for line in (text .. "\n"):gmatch("([^\n]*)\n") do
		n = n + 1
		line = line:gsub("\r$", "")
		local name = functionName(line)
		if name then
			-- one-line functions end on their own line
			if line:find("%f[%w]end[%s%),;]*$") and not line:find("function%s*%(.*%)%s*$") then
				ranges[#ranges + 1] = { first = n, last = n, name = name }
			else
				open[#open + 1] = { first = n, indent = line:match("^(%s*)"), name = name }
			end
		elseif #open > 0 then
			local indent = line:match("^(%s*)end%f[%W]")
			if indent ~= nil and indent == open[#open].indent then
				local range = tremove(open)
				range.last = n
				ranges[#ranges + 1] = range
			end
		end
	end
	sources[chunkName] = ranges
end

-- The innermost indexed function holding a line
local function enclosing(chunkName, lineNumber)
	local best
	for _, range in ipairs(sources[chunkName] or {}) do
		if range.first <= lineNumber and lineNumber <= range.last and (best == nil or range.first > best.first) then
			best = range
		end
	end
	return best and best.name
end

--- Where the profile asked for what is running now: up to the two nearest profile frames,
-- outermost first ("CasterForm 890 › casterCast 233"), or nil outside a profile.
function rotation.site()
	local frames = {}
	for level = 3, 40 do
		local _, location = pcall(error, "", level)
		local chunk, lineNumber = tostring(location):match('^%[string "(.-)"%]:(%d+):')
		if chunk and sources[chunk] then
			lineNumber = tonumber(lineNumber)
			frames[#frames + 1] = (enclosing(chunk, lineNumber) or chunk) .. " " .. lineNumber
			if #frames == 2 then break end
		end
	end
	if #frames == 0 then return nil end
	if #frames == 2 then return frames[2] .. " › " .. frames[1] end
	return frames[1]
end

---------------------------------------------------------------------------------------------------
-- Sends and answers
---------------------------------------------------------------------------------------------------
local pending = {}  -- sends this tick, not yet announced
local awaiting = {} -- sends waiting for the game's answer
local sent = 0      -- sends this session (the row number)
local announcing = false
local lastError, lastErrorAt = nil, 0

local function unitName(unit)
	if unit == nil then return nil end
	local name = br._G.UnitName(unit)
	return name and log.printable(name) or tostring(unit)
end

local function combatTime()
	local combat = br.functions and br.functions.combat
	return combat and combat.getCombatTime and combat:getCombatTime() or 0
end

--- A spell BR just sent (System/Functions/Cast/Helpers.lua; Dispatch.lua for pet abilities).
-- spellID is nil for a send by name.
function rotation:sent(spellID, spellName, unit)
	sent = sent + 1
	-- spells sent at the player (self buffs, roars and other self-centred casts) say "self"
	local target = unit == "player" and "self" or unitName(unit)
	local entry = { n = sent, spellID = spellID, name = log.printable(spellName), target = target,
		at = GetTime(), combat = combatTime(), site = rotation.site() }
	pending[#pending + 1] = entry
	awaiting[#awaiting + 1] = entry
end

--- A Profile Debug line (br.log:debug): "Casting <spell>..." in the tick that spell was sent is
-- that send's label ("Casting Faerie Fire [Filler]")
function rotation:label(text)
	if announcing or #pending == 0 or type(text) ~= "string" or text:sub(1, 8) ~= "Casting " then return end
	local said = log.plain(text:sub(9))
	local lower = said:lower()
	for i = #pending, 1, -1 do
		local entry = pending[i]
		if entry.label == nil and lower:sub(1, #entry.name) == entry.name:lower() then
			entry.label = said
			return
		end
	end
end

-- The row for a send (or a cast of the player's) and how it ended. kind picks the result's color:
-- "success", "error" or "warning" (log.colors). Kept plain (the file, copying) and colored (the window).
local rows, rowNext = {}, 1
local function addRow(entry, result, kind)
	local c = log.colors
	local who = entry.n and ("#" .. entry.n) or "you"
	local time = ("%6.1fs"):format(entry.combat or 0)
	local spell = entry.label or entry.name
	local plain = ("%s %s  %s%s  %s%s"):format(who, time, spell, entry.target and (" → " .. entry.target) or "",
		result, entry.site and ("  (" .. entry.site .. ")") or "")
	local colored = ("%s %s  %s%s  %s%s"):format(
		(entry.n and c.muted or br.ui.colors.class) .. who .. "|r", c.muted .. time .. "|r",
		c.text .. spell .. "|r", entry.target and (c.muted .. " → |r" .. log.highlight(entry.target)) or "",
		c[kind] .. result .. "|r", entry.site and (c.muted .. "  (" .. entry.site .. ")|r") or "")
	rowLine(plain)
	rows[rowNext] = { plain = plain, colored = colored }
	rowNext = rowNext % WINDOW_ROWS + 1
	rotation:refreshWindow()
end

--- End of a rotation tick (Player:startRotation): announces the sends the profile didn't, and
-- gives up on answers that didn't come
function rotation:endTick()
	if #pending > 0 then
		announcing = true
		for _, entry in ipairs(pending) do
			if entry.label == nil then
				log:debug("Casting " .. entry.name .. (entry.site and (" (" .. entry.site .. ")") or ""))
			end
		end
		announcing = false
		wipe(pending)
	end
	local now = GetTime()
	for i = #awaiting, 1, -1 do
		local entry = awaiting[i]
		if now - entry.at > ANSWER_WAIT then
			tremove(awaiting, i)
			addRow(entry, "no answer", "warning")
		end
	end
end

-- The send a cast event is about: the oldest waiting one for that spell, by ID or by name (a send by
-- name has no ID, and can come back as another rank)
local function findAwaiting(spellID)
	local name
	for i = 1, #awaiting do
		local entry = awaiting[i]
		if entry.spellID ~= nil and entry.spellID == spellID then return i end
		name = name or log.printable(br.functions.spell:getName(spellID) or "")
		if entry.name == name then return i end
	end
end

-- Spells of the player's that aren't casts worth a row: auto attack, auto shot / wand
local function isAutomatic(spellID)
	local autoAttack = br.functions.spell.getHighestSpellID and br.functions.spell:getHighestSpellID("autoAttack")
	if autoAttack ~= nil and spellID == autoAttack then return true end
	local name = br.functions.spell:getName(spellID)
	return name ~= nil and br._G.C_Spell.IsAutoRepeatSpell and br._G.C_Spell.IsAutoRepeatSpell(name) or false
end

local events = br._G.CreateFrame("Frame")
events:RegisterEvent("UNIT_SPELLCAST_START")
events:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
events:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
events:RegisterEvent("UNIT_SPELLCAST_FAILED")
events:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED")
events:RegisterEvent("UI_ERROR_MESSAGE")
-- UNIT_SPELLCAST_*: unit, castGUID, spellID; UI_ERROR_MESSAGE: errorType, message
events:SetScript("OnEvent", function(_, event, a, b, c)
	if event == "UI_ERROR_MESSAGE" then
		lastError, lastErrorAt = b ~= nil and log.plain(b) or nil, GetTime()
		return
	end
	local unit, spellID = a, c
	if unit ~= "player" or spellID == nil or not br.functions or not br.functions.spell then return end
	if event == "UNIT_SPELLCAST_START" then
		-- a cast with a cast time answers when it ends: wait from then
		local i = findAwaiting(spellID)
		local endMS = i and select(5, br._G.UnitCastingInfo("player"))
		if endMS then awaiting[i].at = math.max(awaiting[i].at, br.functions.misc:plainNumber(endMS) / 1000) end
		return
	end
	local i = findAwaiting(spellID)
	local entry = i and tremove(awaiting, i)
	if event == "UNIT_SPELLCAST_SUCCEEDED" or event == "UNIT_SPELLCAST_CHANNEL_START" then
		if entry == nil then
			-- the player's own cast
			if not br._G.IsPlayerSpell or not br._G.IsPlayerSpell(spellID) or isAutomatic(spellID) then return end
			entry = { name = log.printable(br.functions.spell:getName(spellID) or tostring(spellID)),
				target = unitName("target"), combat = combatTime() }
		end
		addRow(entry, event == "UNIT_SPELLCAST_CHANNEL_START" and "channelling" or "done", "success")
	elseif entry ~= nil then
		local reason = (lastError and GetTime() - lastErrorAt <= ERROR_WAIT) and (": " .. lastError) or ""
		if event == "UNIT_SPELLCAST_INTERRUPTED" then
			addRow(entry, "interrupted" .. reason, "warning")
		else
			addRow(entry, "failed" .. reason, "error")
		end
	end
end)

---------------------------------------------------------------------------------------------------
-- The window
---------------------------------------------------------------------------------------------------
--- The rows, oldest first, as plain text (colored: as the window shows them)
function rotation:rows(colored)
	local list = {}
	for i = 0, WINDOW_ROWS - 1 do
		local row = rows[(rowNext + i - 1) % WINDOW_ROWS + 1]
		if row then list[#list + 1] = colored and row.colored or row.plain end
	end
	return list
end

-- The window's text box, when it's built and shown
local function windowBox()
	local box = br.ui and br.ui.window and br.ui.window.debug
	if box and box.parent and box.parent.frame and box.parent.frame:IsShown() then return box end
end

function rotation:refreshWindow()
	local box = windowBox()
	if box == nil then return end
	local colored = rotation:rows(true)
	if #colored == 0 then colored = { "Nothing cast yet this session." } end
	-- shown colored; clicking in to copy shows the plain text (br.ui:createWindow's copy box)
	box.settings.text = table.concat(colored, "\n")
	box.plainText = table.concat(rotation:rows(), "\n")
	-- while the player is selecting text to copy, the new rows wait until they click out
	if not box.editBox:HasFocus() then box:SetText(box.settings.text) end
end
