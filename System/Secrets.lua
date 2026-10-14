local _, br = ...
---------------------------------------------------------------------------------------------------
-- Secret values
---------------------------------------------------------------------------------------------------
-- Clients with secret values (Retail since Midnight, WoW Forever) mark many WoW API results as
-- secret. A secret is a normal value with a flag set; whether code may use it (compare it, do
-- arithmetic with it, use it as a table key) depends on the code running, not on the value:
-- untainted code may, tainted code may not. Some unlockers let BR run untainted (a protected
-- call), some unwrap the values; with neither, BR can't use them.
--
-- On those clients every WoW function BR reads through br._G is checked here. The first result
-- BR can't use pauses BR (br.api.canPulse, checked by System/Core.lua); the calls that returned
-- such values are re-checked every 2 seconds, and BR resumes once they all return usable values.
-- BR is either fully working or paused, never running on values it can't read.
--
-- Unlockers with a protected call set br.unlockers.protect (System/Unlockers.lua). BR's frame
-- scripts (OnUpdate, OnEvent), timer callbacks and hooks then run inside it, so the whole handler
-- may use secret values, not just each call. Those are set up through br._G (CreateFrame, C_Timer,
-- hooksecurefunc, TooltipDataProcessor), which profiles read too.
-- Clients without secret values get nothing installed here.
br.secrets = br.secrets or {}
local secrets = br.secrets

local issecretvalue = br._G.issecretvalue
local canaccessvalue = br._G.canaccessvalue

-- Whether BR may use a value here: canaccessvalue answers for the code that is running.
-- issecretvalue is only the flag, which is set even on values BR's protected code may use.
function secrets.canUse(value)
	if canaccessvalue then return canaccessvalue(value) and true or false end
	if issecretvalue then return not issecretvalue(value) end
	return true
end

if not issecretvalue then return end

local canUse = secrets.canUse
local type, select, pairs, pcall, tostring = type, select, pairs, pcall, tostring
local unpack = br._G.unpack
local strbyte, strsub, strfind, strmatch = string.byte, string.sub, string.find, string.match

local mt = getmetatable(br._G)
local baseIndex = mt.__index
-- A global as BR saw it before this guard: used for the guard's own calls
local function base(key) return baseIndex(br._G, key) end

---------------------------------------------------------------------------------------------------
-- Finding values BR can't use
---------------------------------------------------------------------------------------------------
-- Tables (aura data, spell info) can hold secret fields: check spellId and the first few fields
-- rather than scanning every table in full.
local function hiddenInTable(t)
	local spellId = rawget(t, "spellId")
	if spellId ~= nil and not canUse(spellId) then return true end
	local key, value = next(t)
	for _ = 1, 4 do
		if key == nil then return false end
		if not canUse(value) then return true end
		key, value = next(t, key)
	end
	return false
end

local function hidden(value)
	if not canUse(value) then return true end
	if type(value) ~= "table" then return false end
	local ok, found = pcall(hiddenInTable, value)
	return not ok or found
end

local function anyHidden(...)
	for i = 1, select("#", ...) do
		if hidden((select(i, ...))) then return true end
	end
	return false
end

-- Text for a chat line: a flagged value (or text built from one) can't be printed
local function printable(value)
	if issecretvalue(value) then return "<secret>" end
	local ok, text = pcall(tostring, value)
	if not ok or issecretvalue(text) then return "<secret>" end
	return text
end

---------------------------------------------------------------------------------------------------
-- Pause and resume
---------------------------------------------------------------------------------------------------
local MAX_PROBES = 16
local probes, probeCount, nextCheck = {}, 0, 0
-- How many of BR's protected scripts are running (see Protected scripts)
local protectedDepth = 0

-- The first three BR files and lines on the stack, innermost first, so the pause names the code
-- that made the call. Tail calls and C frames carry no location, so they're skipped.
local function callSite()
	local debugstack = base("debugstack")
	if not debugstack then return nil end
	local sites = {}
	for line in debugstack(3, 16, 0):gmatch("[^\n]+") do
		if not strfind(line, "Secrets.lua", 1, true) and not strfind(line, "^%[tail call%]")
			and not strfind(line, "^%[C%]") then
			sites[#sites + 1] = strmatch(line, "^(.-:%d+):") or line
			if #sites == 3 then break end
		end
	end
	return sites[1] and table.concat(sites, " < ") or nil
end

-- Which addon restrictions the game has active (Combat, Encounter, Map, ...); never secret
local function activeRestrictions()
	local ok, names = pcall(function()
		local restricted, enum = base("C_RestrictedActions"), base("Enum")
		local types = enum and enum.AddOnRestrictionType
		if not (restricted and restricted.IsAddOnRestrictionActive and types) then return nil end
		local list = {}
		for name, value in pairs(types) do
			if restricted.IsAddOnRestrictionActive(value) == true then list[#list + 1] = name end
		end
		table.sort(list)
		return list
	end)
	if not ok or names == nil then return nil end
	return #names > 0 and table.concat(names, ", ") or "none"
end

local function say(text) br._G.print(text) end

local function record(name, fn, n, a1, a2, a3)
	local key = name .. "|" .. n .. "|" .. printable(a1) .. "|" .. printable(a2) .. "|" .. printable(a3)
	if probes[key] or probeCount >= MAX_PROBES then return end
	probes[key] = { fn = fn, n = n < 3 and n or 3, a1, a2, a3 }
	probeCount = probeCount + 1
	if probeCount == 1 then
		local site = callSite()
		local restrictions = activeRestrictions()
		local where = ""
		if br.unlockers.protect then
			where = (protectedDepth > 0 and " inside" or " outside") .. " BR's protected scripts"
		end
		say("Paused: " .. name .. "(" .. printable(a1) .. ") returned values BR can't use (secret)"
			.. (site and (", called from " .. site) or "") .. where
			.. (restrictions and (". Game restrictions active: " .. restrictions) or "")
			.. ". Resumes automatically once they're readable.")
	end
end

local function report(name, fn, n, a1, a2, a3, ...)
	if probeCount < MAX_PROBES and anyHidden(...) then record(name, fn, n, a1, a2, a3) end
	return ...
end

-- BR's pulse gate: false while any recorded call still returns values BR can't use.
function br.api.canPulse()
	if probeCount == 0 then return true end
	local now = base("GetTime")()
	if now < nextCheck then return false end
	nextCheck = now + 2
	for key, probe in pairs(probes) do
		local ok, stillHidden = pcall(function()
			return anyHidden(probe.fn(unpack(probe, 1, probe.n)))
		end)
		if ok and not stillHidden then
			probes[key] = nil
			probeCount = probeCount - 1
		end
	end
	if probeCount == 0 then
		say("Resumed: values are readable again.")
		return true
	end
	return false
end

---------------------------------------------------------------------------------------------------
-- Checked functions and namespaces
---------------------------------------------------------------------------------------------------
-- One wrapper per function, so BR always gets the same wrapper for the same function. Arguments
-- are passed on exactly as given (padding with nils changes what some WoW functions do).
local checkedFunctions = setmetatable({}, { __mode = "k" })
local function checked(fn, name)
	local wrapper = checkedFunctions[fn]
	if not wrapper then
		wrapper = function(...)
			local a1, a2, a3 = ...
			return report(name, fn, select("#", ...), a1, a2, a3, fn(...))
		end
		checkedFunctions[fn] = wrapper
	end
	return wrapper
end

---------------------------------------------------------------------------------------------------
-- Protected scripts
---------------------------------------------------------------------------------------------------
-- Whether BR is inside one of its protected scripts (the unlocker's protected call)
function secrets.isProtected() return protectedDepth > 0 end

-- An error in one of BR's scripts: Errors.log (System/Logging.lua), then the game's error handler
-- (BugSack), as from a normal script
local function reportError(err)
	if br.log and br.log.reportError then
		return br.log:reportError(err, br._G.debugstack and br._G.debugstack(2))
	end
	local handler = br._G.geterrorhandler()
	if handler then handler(err) end
end

local function runCaught(fn, ...)
	xpcall(fn, reportError, ...)
end

local function runProtected(fn, ...)
	protectedDepth = protectedDepth + 1
	runCaught(fn, ...)
	protectedDepth = protectedDepth - 1
end

-- The unlocker's protected call is looked up each run: BR's frames and timers exist before the
-- unlocker adapter is picked.
local protectedScripts = setmetatable({}, { __mode = "k" })
local function protected(fn)
	if type(fn) ~= "function" then return fn end
	local wrapper = protectedScripts[fn]
	if not wrapper then
		wrapper = function(...)
			local protect = br.unlockers.protect
			if protect then return protect(runProtected, fn, ...) end
			return runCaught(fn, ...)
		end
		protectedScripts[fn] = wrapper
	end
	return wrapper
end

local PROTECTED_SCRIPTS = { OnUpdate = true, OnEvent = true }
local function protectFrame(frame)
	if type(frame) ~= "table" then return frame end
	local setScript, hookScript = frame.SetScript, frame.HookScript
	frame.SetScript = function(self, event, fn, ...)
		if PROTECTED_SCRIPTS[event] then fn = protected(fn) end
		return setScript(self, event, fn, ...)
	end
	frame.HookScript = function(self, event, fn, ...)
		if PROTECTED_SCRIPTS[event] then fn = protected(fn) end
		return hookScript(self, event, fn, ...)
	end
	return frame
end

-- Functions whose callback argument is protected: [function] = wrapper
local callbackTakers = setmetatable({}, { __mode = "k" })
-- callbackAt: which argument is the callback (nil: the last one)
local function takesCallback(fn, callbackAt)
	local wrapper = callbackTakers[fn]
	if not wrapper then
		if callbackAt then
			wrapper = function(...)
				local n = select("#", ...)
				local args = { ... }
				args[callbackAt] = protected(args[callbackAt])
				return fn(unpack(args, 1, n > callbackAt and n or callbackAt))
			end
		else
			wrapper = function(...)
				local n = select("#", ...)
				local args = { ... }
				args[n] = protected(args[n])
				return fn(unpack(args, 1, n))
			end
		end
		callbackTakers[fn] = wrapper
	end
	return wrapper
end

-- C_Timer.After / NewTimer / NewTicker(duration, callback, ...)
local TIMER_FUNCTIONS = { After = true, NewTimer = true, NewTicker = true }

-- Globals BR sees replaced (not checked): [name] = function(value) -> replacement
local replaced = {
	CreateFrame = function(createFrame)
		return function(...) return protectFrame(createFrame(...)) end
	end,
	hooksecurefunc = function(hook) return takesCallback(hook) end,
	-- BR's own copy: Blizzard's table is never modified
	TooltipDataProcessor = function(processor)
		if type(processor) ~= "table" or not processor.AddTooltipPostCall then return processor end
		return setmetatable({ AddTooltipPostCall = takesCallback(processor.AddTooltipPostCall, 2) },
			{ __index = processor })
	end,
}

-- C_* namespaces: BR sees each through a proxy whose functions are checked. Reads and writes go
-- to the real table (or the expansion's proxy in br.api.wow), which is never modified by this.
local namespaceProxies = setmetatable({}, { __mode = "k" })
local function namespace(real, name)
	local proxy = namespaceProxies[real]
	if not proxy then
		proxy = setmetatable({}, {
			__index = function(_, key)
				local value = real[key]
				if type(value) ~= "function" then return value end
				if name == "C_Timer" and TIMER_FUNCTIONS[key] then return takesCallback(value, 2) end
				return checked(value, name .. "." .. tostring(key))
			end,
			__newindex = function(_, key, value) real[key] = value end,
		})
		namespaceProxies[real] = proxy
	end
	return proxy
end

-- WoW API functions are capitalised (UnitPower, GetTime, ...) and namespaces start with C_.
-- Lowercase Lua/WoW utilities (type, select, tinsert, strsplit, print, ...) return no game data
-- and pass through untouched.
local CAPITAL_A, CAPITAL_Z = 65, 90
local function guardable(key, value)
	if type(key) ~= "string" then return false end
	local kind = type(value)
	if kind == "function" then
		local first = strbyte(key, 1)
		return first ~= nil and first >= CAPITAL_A and first <= CAPITAL_Z
	end
	return kind == "table" and strsub(key, 1, 2) == "C_"
end

local function guard(key, value)
	if type(value) == "function" then return checked(value, key) end
	return namespace(value, key)
end

-- Last result per key, so a repeated read doesn't rebuild or re-test anything
local lastRead = {}
-- Functions and namespaces set on br._G (unlocker adapters, expansion shims). Kept here rather
-- than in br._G itself, so setting the same name again is checked too.
local assigned = {}

mt.__index = function(t, key)
	local value = assigned[key]
	if value ~= nil then return value end
	value = baseIndex(t, key)
	if value == nil then return nil end
	local last = lastRead[key]
	if last and last[1] == value then return last[2] end
	local result
	if replaced[key] then
		result = replaced[key](value)
	else
		result = guardable(key, value) and guard(key, value) or value
	end
	lastRead[key] = { value, result }
	return result
end

mt.__newindex = function(t, key, value)
	if guardable(key, value) then
		assigned[key] = guard(key, value)
	elseif assigned[key] ~= nil then
		-- A checked name set to something unguardable (or nil): stored plainly from now on
		assigned[key] = nil
		rawset(t, key, value)
	else
		rawset(t, key, value)
	end
end
