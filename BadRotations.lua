-- define br global that will hold the bot global background features
br = {}
br.data = {}
br.dungeon = {}
br.mdungeon = {}
br.raid = {}
br.mraid = {}
br.selectedSpec = "None"
br.selectedProfile = 1
br.dropOptions = {}
--br.dropOptions.Toggle = {"LeftCtrl","LeftShift","RightCtrl","RightShift","RightAlt","None"}
br.dropOptions.Toggle ={"LeftCtrl","LeftShift","RightCtrl","RightShift","RightAlt","None","MMouse","Mouse4","Mouse5" }
br.dropOptions.CD = {"Never","CDs","Always" }
br.loadedIn = false
br.rotations = {}
-- developers debug, use /run br.data.settings[br.selectedSpec].toggles["isDebugging"] = true
br.debug = {}
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
	if br.selectedSpec == nil then br.selectedSpec = select(2,GetSpecializationInfo(GetSpecialization())) end
	-- rc = LibStub("LibRangeCheck-2.0")
	-- minRange, maxRange = rc:GetRange('target')
	--[[Init the readers codes (System/Reader.lua)]]
	-- combat log
	br.read.combatLog()
	-- other readers
	br.read.commonReaders()
	-- Globals
	classColors = {
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
	br.classColor = tostring("|cff"..classColors[select(3,UnitClass("player"))].hex)
	-- Class Specific Color for UI Elements
    classColor = {
        color = classColors[select(3,UnitClass("player"))].hex,
    }
	qualityColors = {
		blue = "0070dd",
		green = "1eff00",
		white = "ffffff",
		grey = "9d9d9d"
	}
	-- load common used stuff on first load
 	br:loadSettings()
	-- add minimap fire icon
	br:MinimapButton()
	-- build up UI
	TogglesFrame()
	-- Build up pulse frame (hearth)
	if not br.loadedIn then
		br:Engine()
        br:ObjectManager()
		ChatOverlay("-= BadRotations Loaded =-")
		Print("Loaded")
		br.loadedIn = true
	end
end

-- Load Settings
function br:loadSettings()
	-- Base Settings
	if br.data == nil then br.data = {} end
	if br.data.settings == nil then
		br.data.settings = {
			mainButton = {
				pos = {
					anchor = "CENTER",
					x = -75,
					y = -200
				}
			},
			buttonSize = 32,
			font = "Fonts/arialn.ttf",
			fontsize = 16,
			wiped = true,
		}
	end
	-- Settings Per Spec
    if br.data.settings[br.selectedSpec] == nil then br.data.settings[br.selectedSpec] = {} end
	if br.data.settings[br.selectedSpec].toggles == nil then br.data.settings[br.selectedSpec].toggles = {} end
    if br.data.settings[br.selectedSpec]["RotationDrop"] == nil then
        br.selectedProfile = 1
    else
        br.selectedProfile = br.data.settings[br.selectedSpec]["RotationDrop"]
    end
    if br.data.settings[br.selectedSpec][br.selectedProfile] == nil then br.data.settings[br.selectedSpec][br.selectedProfile] = {} end
end
local frame = CreateFrame("FRAME")
frame:RegisterEvent("ADDON_LOADED");
frame:RegisterEvent("PLAYER_LOGOUT")
frame:RegisterUnitEvent("PLAYER_ENTERING_WORLD")
function frame:OnEvent(event, arg1, arg2, arg3, arg4, arg5)
	if event == "ADDON_LOADED" and arg1 == "BadRotations" then
		-- Load Settings
		br.data = deepcopy(brdata)
		br.dungeon = deepcopy(dungeondata)
		br.mdungeon = deepcopy(mdungeondata)
		br.raid = deepcopy(raiddata)
		br.mraid = deepcopy(mraiddata)
	end
    if event == "PLAYER_LOGOUT" then
        br.ui:saveWindowPosition()
        if getOptionCheck("Reset Options") then
        	-- Reset Settings
			brdata = {}
		elseif getOptionCheck("Reset Saved Profiles") then
			dungeondata = {}
        	raiddata = {}
        	mdungeondata = {}
        	mraiddata = {}
        	br.dungeon = {}
			br.mdungeon = {}
			br.raid = {}
			br.mraid = {}
        else
        	-- Save Settings
        	brdata = deepcopy(br.data)
        	dungeondata = deepcopy(br.dungeon)
        	mdungeondata = deepcopy(br.mdungeon)
        	raiddata = deepcopy(br.raid)
        	mraiddata = deepcopy(br.mraid)
        end
    end
    if event == "PLAYER_ENTERING_WORLD" then
    	-- Update Selected Spec
        br.selectedSpec = select(2,GetSpecializationInfo(GetSpecialization()))
        br.activeSpecGroup = GetActiveSpecGroup()
		br.equipHasChanged = true
    	if not br.loadedIn then
    		bagsUpdated = true
        	br:Run()
        end
    end
end
frame:SetScript("OnEvent", frame.OnEvent)
