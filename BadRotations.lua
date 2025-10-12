-- [[ Global Variables and Tables Initialization ]] --
-- define br global that will hold the bot global background features
local _, br = ...
local loadedIn = false
br._G = setmetatable({}, { __index = _G })
br._G.GetSpellInfo = function(spellIdentifier)
	local spellInfo = _G["GetSpellInfo"](spellIdentifier)
	if spellInfo and type(spellInfo) == "table" then
		---@diagnostic disable-next-line: redundant-return-value
		return spellInfo.name, _, spellInfo.iconID, spellInfo.castTime, spellInfo.minRange,
			---@diagnostic disable-next-line: redundant-return-value
			spellInfo.maxRange, spellInfo.spellID, spellInfo.originalIconID
	else
		return _G["GetSpellInfo"](spellIdentifier)
	end
end
-- System Table Initialization
br.api = {}
br.engines = {}
br.functions = {}
br.lists = {}
br.loader = {}
br.misc = {}
br.readers = {}
br.ui = {}
br.debug = {}
br.slashCommands = {}
br.unlockers = {}

-- Other Initialization
br.data = {}
br.data.settings = {}
br.loader.addonName = "BadRotations"
br.loader.rotations = {}
br.loader.selectedSpec = "None"
br.loader.selectedSpecID = 0
br.loader.selectedProfile = 1
br.loader.selectedProfileName = "None"
br.loader.settingsFile = "None.lua"
-- developers debug, use /run br.data.settings[br.loader.selectedSpec].toggles["isDebugging"] = true

-- Run
function br.Run()
	if br.loader.selectedSpec == nil then
		br.loader.selectedSpecID, br.loader.selectedSpec = br._G.C_SpecializationInfo.GetSpecializationInfo(br._G.C_SpecializationInfo.GetSpecialization())
		if br.loader.selectedSpec == "" then
			br.loader.selectedSpec = "Initial"
		end
	end
	-- add minimap fire icon
	br.ui:MinimapButton()
	-- Build up pulse frame (hearth)
	if not loadedIn then
		-- Start Logs
		-- combat log
		br.readers.combatLog:combatLog()
		-- other readers
		br.readers.common:commonReaders()
		-- Start Engines
		br.engines:Main()
		br.engines:ObjectManager()
		br.engines:ObjectTracker()
		-- Complete Loadin
		br.ui.chatOverlay:Show("-= BadRotations Loaded =-")
		br._G.print("Initialization Complete.")
		loadedIn = true
	end
end

function br.load()
	-- Update Selected Spec
	br.loader.selectedSpecID, br.loader.selectedSpec = br._G.C_SpecializationInfo.GetSpecializationInfo(br._G.C_SpecializationInfo.GetSpecialization())
	if br.loader.selectedSpec == "" then
		br.loader.selectedSpec = "Initial"
	end
	if br.data == nil then
		br.data = {}
	end
	if br.data.tracker == nil then
		br.data.tracker = {}
	end
	if br.data.settings == nil then
		br.data.settings = {}
	end
	if br.data.ui == nil then
		br.data.ui = {}
	end
	if br.data.settings[br.loader.selectedSpec] == nil then
		br.data.settings[br.loader.selectedSpec] = {}
	end
	if not br.unlocked then
		br.ui.settingsManagement.initializeSettings = true
		print(br.ui.colors.class .. "[BadRotations] |cffFFFFFFInitializing Please Wait...")
	end
	if not loadedIn then
		if br.engines.enemiesEngine.damaged == nil then
			br.engines.enemiesEngine.damaged = {}
		end
		-- br.bagsUpdated = true
		br:Run()
	end
end

-- [[ Event Listeners ]] --
local frame = br._G.CreateFrame("FRAME")

-- Registering events
frame:RegisterEvent("PLAYER_LOGOUT")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("LOADING_SCREEN_ENABLED")
frame:RegisterEvent("LOADING_SCREEN_DISABLED")

-- Separate OnEvent function
local function OnEvent(self, event)
	if event == "LOADING_SCREEN_ENABLED" then
		br.disablePulse = true
	end
	if event == "LOADING_SCREEN_DISABLED" then
		br.disablePulse = false
	end
	if event == "PLAYER_LOGOUT" then
		if br.unlocked then
			-- Return queue window to previous setting
			if br._G.C_CVar.GetCVar("SpellQueueWindow") == "0" then
				br._G.RunMacroText("/console SpellQueueWindow " .. br._G.GetCVar("SpellQueueWindow"))
			end
			br.ui:saveWindowPosition()
			br.ui.settingsManagement:cleanSettings()
			table.wipe(br.data.settings[br.loader.selectedSpec][br.loader.selectedProfile]["PageList"])
			if br.functions.misc:getOptionCheck("Reset Options") then
				-- Reset Settings
				br.ui.settingsManagement:saveSettings(nil, nil, br.loader.selectedSpec, br.loader.selectedProfileName, true)
			else
				-- Save Settings
				br.ui.settingsManagement:saveSettings(nil, nil, br.loader.selectedSpec, br.loader.selectedProfileName)
			end
			br.ui.settingsManagement:saveLastProfileTracker()
			table.wipe(br.ui)
		end
	end
	if event == "PLAYER_ENTERING_WORLD" then
		br.load()
	end
end

-- Setting the OnEvent script handler
frame:SetScript("OnEvent", OnEvent)
