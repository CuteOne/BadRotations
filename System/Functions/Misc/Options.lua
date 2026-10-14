local _, br = ...
-- Profile and base options: where each lives, defaults, lookups, and key options that clash.
---@class br.functions.misc
br.functions.misc = br.functions.misc or {}
local misc = br.functions.misc
-- Option index: where each option lives (storage page) and its default, recorded by the UI
-- elements as they are created (br.ui:createCheckbox / createSpinner / createDropdown / ...).
-- Lookups go straight to the option's page instead of searching every page.
local optionIndex = {}      -- [option key, e.g. "Auto Loot Check"] = page

local optionDefaults = {}   -- [page] = { [option key] = default }

local fallbackPages = {}    -- pages found by searching before the option was registered

local missingOptions = {}   -- [option key] = time it was last searched for and not found

local missingSettings       -- the settings table missingOptions belongs to

local warnedDuplicates = {}

local keyOptions = {}       -- [option name] = true for options whose value is a key (br.ui.dropOptions.Toggle)

local warnedKeyClashes = {}

-- missing (optional): what to return for an option not found (0, or false for a checkbox)
local function findOption(Value, Page, Type, missing)
	if Type == nil then Type = " Check" end
	local notFound = 0
	if Type == " Check" then notFound = false end
	if missing ~= nil then notFound = missing end
	-- A nil or secret option name can't be a real option
	if Value == nil or misc:isFlagged(Value) then return notFound end
	local specSettings = br.data and br.data.settings and br.data.settings[br.loader.selectedSpec]
	local settings = specSettings and specSettings[br.loader.selectedProfile]
	if settings == nil then return notFound end
	local option = Value .. Type
	-- An explicit page that holds the option
	if Page ~= nil and settings[Page] ~= nil and settings[Page][option] ~= nil then
		return settings[Page][option]
	end
	-- The page the option was created on (or found on earlier)
	local page = optionIndex[option] or fallbackPages[option]
	if page ~= nil then
		local pageSettings = settings[page]
		if pageSettings ~= nil and pageSettings[option] ~= nil then return pageSettings[option] end
		if optionIndex[option] ~= nil then return notFound end
	end
	-- Not registered yet (UI not built, or Power off): find it once and remember the page.
	-- An option no page has is remembered as missing for a second, so asking for an option the
	-- profile never created doesn't search every page on every call.
	if missingSettings ~= settings then
		missingOptions = {}
		missingSettings = settings
	end
	local now = br._G.GetTime()
	local missedAt = missingOptions[option]
	if missedAt ~= nil and now - missedAt < 1 then return notFound end
	for pageName, pageSettings in pairs(settings) do
		if type(pageSettings) == "table" and pageName ~= "PageList" and pageSettings[option] ~= nil then
			fallbackPages[option] = pageName
			return pageSettings[option]
		end
	end
	missingOptions[option] = now
	return notFound
end

--- Warns (once per combination) when two key options use the same key: keys are read while held, so
-- holding it would do both (cycle a toggle and pause, say).
function misc:checkKeyClashes()
	local keys = br.ui.dropOptions and br.ui.dropOptions.Toggle
	if keys == nil then return end
	local byKey = {}
	for name in pairs(keyOptions) do
		local key = keys[misc:getOptionValue(name)]
		if key ~= nil and key ~= "None" then
			byKey[key] = byKey[key] or {}
			byKey[key][#byKey[key] + 1] = name
		end
	end
	for key, names in pairs(byKey) do
		if #names > 1 then
			table.sort(names)
			local text = key .. ": " .. table.concat(names, ", ")
			if not warnedKeyClashes[text] then
				warnedKeyClashes[text] = true
				br.log:warning("Key " .. br.log.highlight(key) .. " is set for " .. table.concat(names, " and ")
					.. ". Holding it does all of them; give one a different key.")
			end
		end
	end
end

-- Reads a module option: from "Rotation Options" when the profile defines that page, otherwise
-- from "Base Options" (option lookups search the other pages when not found on the first).
-- if br.functions.misc:getModuleOption("Use Racial", "Check") then
function misc:getModuleOption(option, optionType)
	local settings = br.data.settings[br.loader.selectedSpec][br.loader.selectedProfile]
	local page = (settings ~= nil and settings["Rotation Options"] ~= nil) and "Rotation Options" or "Base Options"
	if optionType == "Check" then return misc:isChecked(option, page) end
	if optionType == "Value" then return misc:getOptionValue(option, page) end
end

-- used to gather informations from the bot options frame
function misc:getOptionCheck(Value)
	return br.functions.misc:isChecked(Value)
end

--- Page -> { option key -> default } for every registered option (used by the save guard).
function misc:getOptionDefaults()
	return optionDefaults
end

function misc:getOptionValue(Value)
	return br.functions.misc:getValue(Value)
end

-- if br.functions.misc:getValue("player") <= br.functions.misc:getValue("Eternal Flame") then
-- function misc:getValue(Value)
-- 	if br.data~=nil then
-- 		if br.data.settings[br.loader.selectedSpec][br.loader.selectedProfile]~=nil then
-- 	        if br.data.settings[br.loader.selectedSpec][br.loader.selectedProfile][Value.."Status"] ~= nil then
-- 	            return br.data.settings[br.loader.selectedSpec][br.loader.selectedProfile][Value.."Status"]
-- 	        elseif br.data.settings[br.loader.selectedSpec][br.loader.selectedProfile][Value.."Drop"] ~= nil then
-- 	            return br.data.settings[br.loader.selectedSpec][br.loader.selectedProfile][Value.."Drop"]
-- 	        else
-- 	            return 0
-- 	        end
-- 		end
-- 	else
-- 		return 0
-- 	end
-- end
function misc:getValue(Value, Page)
	local statusValue = findOption(Value, Page, " Status")
	if statusValue and statusValue > 0 then
		return statusValue
	end
	local dropValue = findOption(Value, Page, " Drop")
	if dropValue and dropValue > 0 then
		return dropValue
	end
	local editBoxValue = findOption(Value, Page, " EditBox")
	if editBoxValue then
		return editBoxValue
	end
	-- if br.data ~= nil and br.data.settings ~= nil then
	-- 	local selectedProfile = br.data.settings[br.loader.selectedSpec][br.loader.selectedProfile]
	-- 	if selectedProfile ~= nil then
	-- 		if selectedProfile[Value .. "EditBox"] ~= nil then
	-- 			return selectedProfile[Value .. "EditBox"]
	-- 		end
	-- 	end
	-- end
	return 0
	-- if br.data ~= nil and br.data.settings ~= nil then
	-- 	local selectedProfile = br.data.settings[br.loader.selectedSpec][br.loader.selectedProfile]
	-- 	if selectedProfile ~= nil then
	-- 		if selectedProfile[Value .. "Status"] ~= nil then
	-- 			return selectedProfile[Value .. "Status"]
	-- 		elseif selectedProfile[Value .. "Drop"] ~= nil then
	-- 			return selectedProfile[Value .. "Drop"]
	-- 		elseif selectedProfile[Value .. "EditBox"] ~= nil then
	-- 			return selectedProfile[Value .. "EditBox"]
	-- 		else
	-- 			return 0
	-- 		end
	-- 	end
	-- else
	-- 	return 0
	-- end
end

-- if br.functions.misc:isChecked("Debug") then
function misc:isChecked(Value, Page)
	if Value == nil then return false end
	return findOption(Value, Page, " Check")
end

--- Whether an option's checkbox was unticked: false for an option not made or loaded yet, so an
-- option that starts ticked counts as ticked until the player's settings say otherwise.
function misc:isUnchecked(Value, Page)
	if Value == nil then return false end
	local value = findOption(Value, Page, " Check", "missing")
	return value == false or value == 0
end

function misc:isKeyOption(name)
	return keyOptions[name] == true
end

--- Records an option whose value is a key from br.ui.dropOptions.Toggle (toggle keys, Pause Mode,
-- keys a profile reads with ui.toggle), so checkKeyClashes can find two options on one key.
function misc:registerKeyOption(name)
	if name ~= nil then keyOptions[name] = true end
end

--- Records an option's page and default (called by the UI elements).
-- The first page an option is created on wins; another page with the same option is reported once.
function misc:registerOption(page, key, default)
	if page == nil or key == nil then return end
	optionDefaults[page] = optionDefaults[page] or {}
	optionDefaults[page][key] = default
	missingOptions[key] = nil
	local known = optionIndex[key]
	if known == nil then
		optionIndex[key] = page
	elseif known ~= page and not warnedDuplicates[key] then
		warnedDuplicates[key] = true
		br.log:warning("Option \"" .. key .. "\" exists on pages \"" .. known .. "\" and \"" .. page
			.. "\"; using \"" .. known .. "\". Rename one of them.")
	end
end

--- Clears the option index (a new profile's pages are about to be built).
function misc:resetOptionIndex()
	optionIndex = {}
	optionDefaults = {}
	fallbackPages = {}
	missingOptions = {}
	keyOptions = {}
end
