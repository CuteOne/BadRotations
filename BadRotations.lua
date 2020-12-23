-- define br global that will hold the bot global background features
br = {}
br.addonName = "BadRotations"
br.commandHelp = {}
br.data = {}
br.data.ui = {}
br.deadPet = false
-- developers debug, use /run br.data.settings[br.selectedSpec].toggles["isDebugging"] = true
br.debug = {}
br.dropOptions = {}
--br.dropOptions.Toggle = {"LeftCtrl","LeftShift","RightCtrl","RightShift","RightAlt","None"}
br.dropOptions.Toggle ={"LeftCtrl","LeftShift","RightCtrl","RightShift","RightAlt","None","MMouse","Mouse4","Mouse5" }
br.dropOptions.CD = {"Never","CDs","Always" }
br.engines = {}
br.loadedIn = false
br.loadFile = false
br.pauseCast = GetTime()
br.prevQueueWindow = GetCVar("SpellQueueWindow")
br.profile = {}
br.rotations = {}
br.selectedSpec = "None"
br.selectedProfile = 1
br.selectedProfileName = "None"
br.settingsDir = "\\"
br.settingsFile = "None.lua"

-- The colors Duke, the colors!
br.classColors = {
	[1]				= {class = "Warrior", 		B=0.43,	G=0.61,	R=0.78,	hex="c79c6e"},
	[2]				= {class = "Paladin", 		B=0.73,	G=0.55,	R=0.96,	hex="f58cba"},
	[3]				= {class = "Hunter",		B=0.45,	G=0.83,	R=0.67,	hex="abd473"},
	[4]				= {class = "Rogue",			B=0.41,	G=0.96,	R=1,	hex="fff569"},
	[5]				= {class = "Priest",		B=1,	G=1,	R=1,	hex="ffffff"},
	[6]				= {class = "Deathknight",	B=0.23,	G=0.12,	R=0.77,	hex="c41f3b"},
	[7]				= {class = "Shaman",		B=0.87,	G=0.44,	R=0,	hex="0070de"},
	[8]				= {class = "Mage",			B=0.94,	G=0.8,	R=0.41,	hex="69ccf0"},
	[9]				= {class = "Warlock", 		B=0.79,	G=0.51,	R=0.58,	hex="9482c9"},
	[10]			= {class = "Monk",			B=0.59,	G=1,	R=0,	hex="00ff96"},
	[11]			= {class = "Druid", 		B=0.04,	G=0.49,	R=1,	hex="ff7d0a"},
	[12] 			= {class = "Demonhunter", 	B=0.79, G=0.19, R=0.64, hex="a330c9"},
}
br.classColor = tostring("|cff"..br.classColors[select(3,UnitClass("player"))].hex)
br.qualityColors = {
	blue = "0070dd",
	green = "1eff00",
	white = "ffffff",
	grey = "9d9d9d"
}

local nameSet = false
function br:setAddonName()
	if not nameSet then
		for i = 1, GetNumAddOns() do
			local name, title = GetAddOnInfo(i)
			if title == "|cffa330c9BadRotations" then
				br.addonName = name
				if br.addonName ~= "BadRotations" then
					Print("Currently known as "..tostring(br.addonName))
				end
				nameSet = true
				break
			end
		end
	end
end

-- Cache all non-nil return values from GetSpellInfo in a table to improve performance
local spellcache = setmetatable({}, {__index=function(t,v) local a = {GetSpellInfo(v)} if GetSpellInfo(v) then t[v] = a end return a end})
local function GetSpellInfo(a)
    return unpack(spellcache[a])
end
-- Custom Print
function br.debug:Print(message)
	if br.data.settings[br.selectedSpec].toggles["isDebugging"] == true then
		Print(message)
	end
end
-- Run
function br:Run()		
	if br.selectedSpec == nil then 
		br.selectedSpec =  select(2, GetSpecializationInfo(GetSpecialization()))
    	if br.selectedSpec == "" then br.selectedSpec = "Initial" end
	end
	-- rc = LibStub("LibRangeCheck-2.0")
	-- minRange, maxRange = rc:GetRange('target')
	--[[Init the readers codes (System/Reader.lua)]]
	-- -- combat log
	-- br.read.combatLog()
	-- -- other readers
	-- br.read.commonReaders()
	-- load common used stuff on first load
	if not br.initalizeSettings then
		br:defaultSettings()
	end
	-- add minimap fire icon
	br:MinimapButton()
	-- Build up pulse frame (hearth)
	if not br.loadedIn then
		-- Start Logs
		-- combat log
		br.read.combatLog()
		-- other readers
		br.read.commonReaders()
		-- Start Engines
		br:Engine()
		br:ObjectManager()
		-- Complete Loadin
		ChatOverlay("-= BadRotations Loaded =-")
		Print("Loaded")
		br.loadedIn = true
	end
end
-- Default Settings
function br:defaultSettings()
	if br.data == nil then br.data = {} end	
	if br.data.tracker == nil then br.data.tracker = {} end
	if br.data.settings == nil then br.data.settings = {} end
	C_Timer.After(2, function()
		if br.ui.window.config == nil then br.ui.window.config = {} end
		if br.ui.window.config.frame == nil then
			br.ui:createConfigWindow()
		end
		br.ui:toggleWindow("config")
	end)
	-- Settings Per Spec
	if br.data.settings[br.selectedSpec] == nil then br.data.settings[br.selectedSpec] = {}	end
	if br.data.settings[br.selectedSpec].toggles == nil then br.data.settings[br.selectedSpec].toggles = {} end
	if br.data.settings[br.selectedSpec]["RotationDrop"] == nil then
		br.selectedProfile = 1
	else
		br.selectedProfile = br.data.settings[br.selectedSpec]["RotationDrop"]
	end
	if br.data.settings[br.selectedSpec][br.selectedProfile] == nil then br.data.settings[br.selectedSpec][br.selectedProfile] = {} end
end
-- Load Saved Settings
function br:loadSavedSettings()
	if br.initalizeSettings then
		br:defaultSettings()
		br.loader.loadProfiles()
		br:loadLastProfileTracker()
		br:loadSettings(nil,nil,nil, br.data.settings[br.selectedSpec]['RotationDropValue'])			
		-- Define Main Button if no settings exist
		if (br.data.settings and br.data.settings.mainButton == nil) then
            br.data.settings.mainButton = {
                pos = {
                    anchor = "CENTER",
                    x = -75,
                    y = -200
                }
            }
            br.data.settings.buttonSize = 32
            br.data.settings.font = "Fonts/arialn.ttf"
            br.data.settings.fontsize = 16
            br.data.settings.wiped = true
        end
		-- Build the Toggles
		TogglesFrame()
		br.initalizeSettings = false
	end
end
local frame = CreateFrame("FRAME")
frame:RegisterEvent("ADDON_LOADED");
frame:RegisterEvent("PLAYER_LOGOUT")
frame:RegisterUnitEvent("PLAYER_ENTERING_WORLD")
frame:RegisterUnitEvent("PLAYER_LEAVING_WORLD")
frame:RegisterEvent("LOADING_SCREEN_ENABLED")
frame:RegisterEvent("LOADING_SCREEN_DISABLED")
function frame:OnEvent(event, arg1, arg2, arg3, arg4, arg5)
	if event == "LOADING_SCREEN_ENABLED" then
		br.disablePulse = true
	end
	if event == "LOADING_SCREEN_DISABLED" then
		br.disablePulse = false
	end
	if event == "PLAYER_LOGOUT" then
		if br.unlocked then
			-- Return queue window to previous setting
			if GetCVar("SpellQueueWindow") =="0" then 
				RunMacroText("/console SpellQueueWindow "..br.prevQueueWindow)
			end 
			br.ui:saveWindowPosition()
			if getOptionCheck("Reset Options") then
				-- Reset Settings
				br:saveSettings(nil,nil,br.selectedSpec,br.selectedProfileName, true)
			else	
			-- Save Settings
				br:saveSettings(nil,nil,br.selectedSpec,br.selectedProfileName)
			end
			br.saveLastProfileTracker()		
			
		end
	end
	if event == "PLAYER_ENTERING_WORLD" then
		if not br.unlocked then
			br.initalizeSettings = true
			print(br.classColor .. "[BadRotations] |cffFFFFFFPlease wait for settings to load!")
		end
		-- Update Selected Spec
		br.selectedSpec = select(2, GetSpecializationInfo(GetSpecialization()))
    	if br.selectedSpec == "" then br.selectedSpec = "Initial" end
		br.activeSpecGroup = GetActiveSpecGroup()
		br.equipHasChanged = true
		if not br.loadedIn then
			if br.damaged == nil then br.damaged = {} end
			br.bagsUpdated = true
			br:Run()
		end
	end
end
frame:SetScript("OnEvent", frame.OnEvent)
