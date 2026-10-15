local _, br = ...
---------------------------------------------------------------------------------------------------
-- Session log
---------------------------------------------------------------------------------------------------
-- What someone helping a user needs to know before reading the other log files, in Session.log:
--   Environment   once a session, when the first profile's settings load: BR's version, the game
--                 flavor and client build, the unlocker and what it offers, the character, the
--                 locale, the other addons running.
--   Settings      every time a profile's settings load (a profile or spec change): every option
--                 of every page and the toggles, one per line.
--   Changes       every option the player changes while playing, once it settles (a spinner being
--                 scrolled or a box being typed in is one change), and every toggle change.
br.log.session = br.log.session or {}
local session = br.log.session
local log = br.log

local SETTLE = 1.5 -- seconds an option has to stay unchanged before its change is written

local line = log:file("Session.log", 6000)
local environmentWritten = false

-- Text for a setting's value
local function valueText(value)
	if type(value) == "string" then return '"' .. value .. '"' end
	if type(value) == "table" then return "{...}" end
	return tostring(value)
end

local function sortedKeys(t)
	local keys = {}
	for k in pairs(t) do keys[#keys + 1] = k end
	table.sort(keys, function(a, b) return tostring(a) < tostring(b) end)
	return keys
end

local function flavorName()
	for _, flavor in ipairs({ "Forever", "Retail", "MOP", "Cata", "Wrath", "BC", "Classic" }) do
		if br["is" .. flavor] then return flavor end
	end
	return "unknown (project " .. tostring(br._G.WOW_PROJECT_ID) .. ")"
end

local function yesNo(value) return value and "yes" or "no" end

-- The other addons loaded, by folder name
local function loadedAddons()
	local G = br._G
	local addons = G.C_AddOns or G
	local count = addons.GetNumAddOns and addons.GetNumAddOns() or 0
	local names = {}
	for i = 1, count do
		local name = addons.GetAddOnInfo(i)
		if name and name ~= br.loader.addonName and addons.IsAddOnLoaded and addons.IsAddOnLoaded(i) then
			names[#names + 1] = name
		end
	end
	return names
end

-- BR's version: from the game, or from BR's .toc when an unlocker loads BR without the game
-- knowing it as an addon
local function brVersion()
	local addons = br._G.C_AddOns or br._G
	local version = addons.GetAddOnMetadata and addons.GetAddOnMetadata(br.loader.addonName, "Version")
	if version then return version end
	local base, sep = br.functions.misc:getAddonPath()
	local ok, toc = pcall(br._G.ReadFile, base .. sep .. br.loader.addonName .. ".toc")
	return ok and type(toc) == "string" and toc:match("##%s*Version:%s*([^\r\n]+)") or "unknown"
end

-- The commit this copy comes from: written into System/Version.lua by GitHub's Download ZIP, or
-- read from the .git folder of a git clone (HEAD, then the branch's ref, loose or packed). Returns
-- the text for Session.log ("commit 4b8d33772 on master, a git clone"); nothing about who made it.
local function brCommit()
	local build = br.build
	if build and build.commit and not build.commit:find("^%$Format") then
		return ("commit %s from %s, a GitHub download"):format(build.commit:sub(1, 9), tostring(build.date))
	end
	local base, sep = br.functions.misc:getAddonPath()
	local gitDir = base .. sep .. ".git" .. sep
	local function read(name)
		local ok, text = pcall(br._G.ReadFile, gitDir .. name)
		return ok and type(text) == "string" and text or nil
	end
	local head = read("HEAD")
	if head == nil then return "commit unknown (not a git clone, and not a GitHub download)" end
	local branch = head:match("^ref:%s*refs/heads/(%S+)")
	if branch == nil then
		local detached = head:match("^(%x+)")
		return detached and ("commit %s (no branch), a git clone"):format(detached:sub(1, 9)) or "commit unknown"
	end
	local hash = (read("refs" .. sep .. "heads" .. sep .. branch:gsub("/", sep)) or ""):match("^(%x+)")
		or (read("packed-refs") or ""):match("(%x+) refs/heads/" .. branch:gsub("%p", "%%%0") .. "%f[%s]")
	return ("commit %s on %s, a git clone"):format(hash and hash:sub(1, 9) or "unknown", branch)
end

local function writeEnvironment()
	local G = br._G
	local version = brVersion() .. " (" .. brCommit() .. ")"
	local clientVersion, build, buildDate, interface = G.GetBuildInfo()
	line(("BadRotations %s on %s: client %s, build %s (%s), interface %s, locale %s"):format(tostring(version),
		flavorName(), tostring(clientVersion), tostring(build), tostring(buildDate), tostring(interface),
		tostring(G.GetLocale and G.GetLocale())))
	line(("unlocker %s: protected call %s, appends to files %s, secret values on this client %s"):format(
		tostring(br.unlockers.selected), yesNo(br.unlockers.protect ~= nil), yesNo(br.unlockers.nativeAppend),
		yesNo(br.hasSecretValues)))
	local base, sep = br.functions.misc:getAddonPath()
	line("BadRotations folder " .. base .. ", logs in " .. base .. sep .. "Logs")
	log:notePlayer("player")
	local _, race = G.UnitRace("player")
	local _, class = G.UnitClass("player")
	line(("character Me: %s %s, level %s"):format(tostring(race), tostring(class), tostring(G.UnitLevel("player"))))
	local names = loadedAddons()
	line(("other addons loaded (%d): %s"):format(#names, table.concat(names, ", ")))
end

--- A profile's settings were loaded (SettingsManagement:loadSettings): the environment the first
-- time, then every option and toggle
function session:profileLoaded(profile)
	if not environmentWritten then
		environmentWritten = true
		local ok, err = pcall(writeEnvironment)
		if not ok then line("environment: " .. tostring(err)) end
	end
	local specKey = br.loader.selectedSpec
	local specSettings = br.data.settings and br.data.settings[specKey] or {}
	local slot = specSettings[specSettings.RotationDrop or 1] or {}
	line(("profile %s, spec %s, slot %s: settings"):format(tostring(profile), tostring(specKey),
		tostring(specSettings.RotationDrop or 1)))
	for _, page in ipairs(sortedKeys(slot)) do
		local options = slot[page]
		if type(options) == "table" then
			for _, key in ipairs(sortedKeys(options)) do
				line(("  %s | %s = %s"):format(tostring(page), tostring(key), valueText(options[key])))
			end
		elseif not tostring(page):find(" Section$") then -- a section's open/closed state isn't a setting
			line(("  %s = %s"):format(tostring(page), valueText(options)))
		end
	end
	local toggles = specSettings.toggles or {}
	local parts = {}
	for _, name in ipairs(sortedKeys(toggles)) do parts[#parts + 1] = tostring(name) .. " " .. valueText(toggles[name]) end
	line("  toggles: " .. table.concat(parts, ", "))
end

-- Changes waiting to settle: "page | key" -> { value, at }
local unsettled = {}
local function writeSettled()
	local now = br._G.GetTime()
	for name, change in pairs(unsettled) do
		if now - change.at >= SETTLE then
			unsettled[name] = nil
			line(("option changed: %s = %s"):format(name, valueText(change.value)))
		end
	end
	if next(unsettled) then br._G.C_Timer.After(SETTLE, writeSettled) end
end

--- The player changed an option (br.ui.elementOptions.changed)
function session:optionChanged(page, key, value)
	local waiting = next(unsettled) ~= nil
	unsettled[tostring(page) .. " | " .. tostring(key)] = { value = value, at = br._G.GetTime() }
	if not waiting then br._G.C_Timer.After(SETTLE, writeSettled) end
end

--- A toggle changed (by the player, a keybind or the profile)
function session:toggleChanged(name, value)
	line(("toggle changed: %s = %s"):format(tostring(name), valueText(value)))
end
