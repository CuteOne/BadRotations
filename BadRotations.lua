-- define br global that will hold the bot global background features
br = {}
brdata = {}
br.selectedSpec = "None"
br.selectedProfile = 1
br.dropOptions = {}
br.dropOptions.Toggle = {"LeftCtrl","LeftShift","RightCtrl","RightShift","RightAlt","None"}
br.dropOptions.Toggle2 ={"LeftCtrl","LeftShift","LeftAlt","RightCtrl","RightShift","RightAlt","MMouse","Mouse4","Mouse5","None" }
br.dropOptions.CD = {"Never","CDs","Always" }
br.loadedIn = false
-- developers debug, use /run br.data["isDebugging"] = true
br.debug = {}
function br.debug:print(message)
	if br.data["isDebugging"] == true then
		print(message)
	end
end
function br:Run()
	if br.selectedSpec == nil then br.selectedSpec = select(2,GetSpecializationInfo(GetSpecialization())) end
	rc = LibStub("LibRangeCheck-2.0")
	minRange, maxRange = rc:GetRange('target')
	-- lets wipe and start up fresh.
	br.data = brdata
	if br.data == nil or brdata == nil or (br.data and br.data.wiped ~= true) then
		br.data = {
			buttonSize = 32,
			wiped = true
		}
		brdata = br.data
	end
	--[[Init the readers codes (System/Reader.lua)]]
	-- combat log
	br.read.combatLog()
	-- other readers
	br.read.commonReaders()
	-- Globals
	classColors = {
		[1]				= {class = "Warrior", 	B=0.43,	G=0.61,	R=0.78,	hex="|cffc79c6e"},
		[2]				= {class = "Paladin", 	B=0.73,	G=0.55,	R=0.96,	hex="|cfff58cba"},
		[3]				= {class = "Hunter",	B=0.45,	G=0.83,	R=0.67,	hex="|cffabd473"},
		[4]				= {class = "Rogue",		B=0.41,	G=0.96,	R=1,	hex="|cfffff569"},
		[5]				= {class = "Priest",	B=1,	G=1,	R=1,	hex="|cffffffff"},
		[6]				= {class = "Deathknight",B=0.23,	G=0.12,	R=0.77,	hex="|cffc41f3b"},
		[7]				= {class = "Shaman",	B=0.87,	G=0.44,	R=0,	hex="|cff0070de"},
		[8]				= {class = "Mage",		B=0.94,	G=0.8,	R=0.41,	hex="|cff69ccf0"},
		[9]				= {class = "Warlock", 	B=0.79,	G=0.51,	R=0.58,	hex="|cff9482c9"},
		[10]			= {class = "Monk",		B=0.59,	G=1,	R=0,	hex="|cff00ff96"},
		[11]			= {class = "Druid", 	B=0.04,	G=0.49,	R=1,	hex="|cffff7d0a"},
		["Training Dummy"] = {B=0.76,  G=0.76,  R=0.76, hex="|cffC0C0C0"},
		["Black"]		= {B=0.1, 	G=0.1,	R=0.12,	hex="|cff191919"},
		["Hunter"]		= {B=0.45,	G=0.83,	R=0.67,	hex="|cffabd473"},
		["Gray"]		= {B=0.2,	G=0.2,	R=0.2,	hex="|cff333333"},
		["Warrior"]		= {B=0.43,	G=0.61,	R=0.78,	hex="|cffc79c6e"},
		["Paladin"] 	= {B=0.73,	G=0.55,	R=0.96,	hex="|cfff58cba"},
		["Mage"]		= {B=0.94,	G=0.8,	R=0.41,	hex="|cff69ccf0"},
		["Priest"]		= {B=1,		G=1,	R=1,	hex="|cffffffff"},
		["Warlock"]		= {B=0.79,	G=0.51,	R=0.58,	hex="|cff9482c9"},
		["Shaman"]		= {B=0.87,	G=0.44,	R=0,	hex="|cff0070de"},
		["DeathKnight"]	= {B=0.23,	G=0.12,	R=0.77,	hex="|cffc41f3b"},
		["Druid"]		= {B=0.04,	G=0.49,	R=1,	hex="|cffff7d0a"},
		["Monk"]		= {B=0.59,	G=1,	R=0,	hex="|cff00ff96"},
		["Rogue"]		= {B=0.41,	G=0.96,	R=1,	hex="|cfffff569"}
	}
	qualityColors = {
		blue = "0070dd",
		green = "1eff00",
		white = "ffffff",
		grey = "9d9d9d"
	}
	-- load common used stuff on first load
	-- options table that will hold specs subtable
	if br.data.options == nil then
		br.data.options = {}
		br.data.options[br.selectedSpec] = {}
		-- br.data.options[1] = {}
		-- br.data.options[2] = {}
		-- br.data.options[3] = {}
		-- br.data.options[4] = {}
		-- br.data.options[5] = {}
    end
    if br.data.options[br.selectedSpec] == nil then
        br.data.options[br.selectedSpec] = {}
    end
    -- if GetSpecialization() == nil then
    -- 	br.selectedSpec = 5
    -- 	br.selectedProfile = 1
    -- else
    	-- br.selectedSpec = select(2,GetSpecializationInfo(GetSpecialization()))
    -- end
    if br.data.options[br.selectedSpec]["Rotation".."Drop"] == nil then
        br.selectedProfile = 1
    else
        br.selectedProfile = br.data.options[br.selectedSpec]["Rotation".."Drop"]
    end
    --br.selectedProfile = br.data.options[br.selectedSpec]["Rotation".."Drop"] or 1
    if br.data.options[br.selectedSpec][br.selectedProfile]  == nil then
        br.data.options[br.selectedSpec][br.selectedProfile] = {}
    end
	-- uncomment that when all ready
	if br.data.BadRotationsUI == nil then
		br.data.BadRotationsUI = {
			mainButton = {
				pos = {
					anchor = "CENTER",
					x = -75,
					y = -200
				}
			},
			alpha = 1,
			buttonSize = 1,
			configshown = true,
			debugFrame = {
				color = {
					r = 16,
					g = 16,
					b = 16,
					a = 1,
				},
				heigth = 150,
				pos = {
					anchor = "LEFT",
					x = 1 ,
					y = 1
				},
				scale = 0.9,
				width = 200,
			},
			font = "Fonts/arialn.ttf",
			fonts = {
				"Fonts/skurri.ttf",
				"Fonts/morpheus.ttf",
				"Fonts/arialn.ttf",
				"Fonts/skurri.ttf"
			},
			fontsize = 16,
			iconSize = 1,
			icons = {
				emptyIcon = [[Interface\FrameGeneral\UI-Background-Marble]],
				backIconOn = [[Interface\ICONS\Spell_Holy_PowerWordShield]],
				backIconOff = [[Interface\ICONS\SPELL_HOLY_DEVOTIONAURA]],
				genericIconOff = [[Interface\GLUES\CREDITS\Arakkoa1]],
				genericIconOn = [[Interface/BUTTONS/CheckButtonGlow]]
			},
			optionsFrame = {
				generalButton = {
					tip = "General Options",
				},
				enemiesEngineButton = {
					tip = "Enemies Engine Options",
				},
				healingEngineButton = {
					tip = "Healing Engine Options",
				},
				interruptEngineButton = {
					tip = "Interrupts Engine Options",
				},
				color = {
					r = 16,
					g = 16,
					b = 16,
					a = 1,
				},
				heigth = 300,
				pos = {
					anchor = "RIGHT",
					x = 1 ,
					y = 1
				},
				selected = "options",
				scale = 0.9,
				width = 200,
			},
			profileFrame = {
				color = {
					r = 16,
					g = 16,
					b = 16,
					a = 1,
				},
				heigth = 400,
				pos = {
					anchor = "CENTER",
					x = 1 ,
					y = 1 },
				scale = 0.9,
				width = 270,
			},
			uiScale = 1,
		}
	end
	---------------------------------
	commandHelp = "|cffFF0000BadRotations Slash Commands"
	function SlashCommandHelp(cmd,msg)
		if cmd == nil then cmd = "" end
		if msg == nil then msg = "" end
		if cmd == "Print Help" then print(tostring(commandHelp)); return end
		commandHelp = commandHelp.."|cffFFFFFF\n        /"..cmd.."|cffFFDD11 - "..msg
	 end
	-- Macro Toggle ON/OFF
	SLASH_BadRotations1 = "/BadRotations"
	SlashCommandHelp("BadRotations","Toggles BadRotations On/Off")
	function SlashCmdList.BadRotations(msg, editbox, ...)
		print(...)
        if msg == "" then
		    mainButton:Click()
        elseif msg == "hide" then
            BadRotationsButton:Hide()
        elseif msg == "show" then
            BadRotationsButton:Show()
        end

	end
	SLASH_BRHelp1 = "/brHelp"
	function SlashCmdList.brHelp(msg, editbox)
		-- print(tostring(commandHelp))
		SlashCommandHelp("Print Help")
	end
	SLASH_FHStop1 = "/fhstop"
	function SlashCmdList.FHStop(msg, editbox)
		StopFalling()
		StopMoving()
	end
	SLASH_BlackList1, SLASH_BlackList2 = "/blacklist", "/brb"
	SlashCommandHelp("blacklist or /brb","Adds/Removes mouseover unit to healing blacklist.")
	SlashCommandHelp("blacklist dump or /brb dump","Prints all units currently on blacklist.")
	SlashCommandHelp("blacklist clear or /brb clear","Clears the blacklist.")
	function SlashCmdList.BlackList(msg, editbox)
		if br.data.blackList == nil then br.data.blackList = { } end
		if msg == "dump" then
			print("|cffFF0000BadRotations Blacklist:")
			if #br.data.blackList == (0 or nil) then print("|cffFFDD11Empty") end
			if br.data.blackList then
				for i = 1, #br.data.blackList do
					print("|cffFFDD11- "..br.data.blackList[i].name)
				end
			end
		elseif msg == "clear" then
			br.data.blackList = { }
			print("|cffFF0000BadRotations Blacklist Cleared")
		else
			if UnitExists("mouseover") then
				local mouseoverName = UnitName("mouseover")
				local mouseoverGUID = UnitGUID("mouseover")
				-- Now we're trying to find that unit in the blackList table to remove
				local found
				for k,v in pairs(br.data.blackList) do
					-- Now we're trying to find that unit in the Cache table to remove
					if UnitGUID("mouseover") == v.guid then
						tremove(br.data.blackList, k)
						print("|cffFFDD11"..mouseoverName.. "|cffFF0000 Removed from Blacklist")
						found = true
						--blackList[k] = nil
					end
				end
				if not found then
					print("|cffFFDD11"..mouseoverName.. "|cffFF0000 Added to Blacklist")
					tinsert(br.data.blackList, { guid = mouseoverGUID, name = mouseoverName})
				end
			end
		end
	end
	SLASH_Pause1 = "/Pause"
	SlashCommandHelp("Pause","Toggles Pause On/Off")
	function SlashCmdList.Pause(msg, editbox)
		if br.data['Pause'] == 0 then
			ChatOverlay("\124cFFED0000 -- Paused -- ")
			br.data['Pause'] = 1
		else
			ChatOverlay("\124cFF3BB0FF -- Pause Removed -- ")
			br.data['Pause'] = 0
		end
	end
	SLASH_Power1 = "/Power"
	SlashCommandHelp("Power","Toggles BadRotations On/Off")
	function SlashCmdList.Power(msg, editbox)
		if br.data['Power'] == 0 then
			ChatOverlay("\124cFF3BB0FF -- BadRotations Enabled -- ")
			br.data['Power'] = 1
		else
			ChatOverlay("\124cFFED0000 -- BadRotations Disabled -- ")
			br.data['Power'] = 0
		end
	end
	-- Build up pulse frame (hearth)
	br:Engine()
	-- add minimap fire icon
	br:MinimapButton()
	-- build up UI
	br:StartUI()

    if br.data.options[br.selectedSpec] == nil then br.data.options[br.selectedSpec] = {} end
    if br.data.options[br.selectedSpec][br.selectedProfile] == nil then br.data.options[br.selectedSpec][br.selectedProfile] = {} end
    --br.selectedProfile = br.data.options[br.selectedSpec]["Rotation".."Drop"] or 1
    br.ui:createConfigWindow()

	-- start up enemies Engine
	enemiesEngineRange = 55
	EnemiesEngine()
	ChatOverlay("-= BadRotations Loaded =-")
	br.loadedIn = true
end
--[[Startup UI]]
function br:StartUI()
	-- trigger frame creation in ui.lua
	ConstructUI()
	-- select the active option(refresh)
	_G["options"..br.data.options.selected.."Button"]:Click()
	-- Build up buttons frame (toggles)
	BadRotationsFrame()
end

br.pulse = {}
br.pulse.makeTable = true
br.pulse.gathering = true
-- debug
function br.pulse:getDist()
    targetDistance = getDistance("target") or 0
end
function br.pulse:dispDist()
    displayDistance = math.ceil(targetDistance)
end
function br.pulse:makeEnTable()
    if br.pulse.makeTable then
        makeEnemiesTable(maxDistance)
    end
end
function br.pulse:ttd()
    TTDRefresh()
end
--[[Updating UI]]
function br:PulseUI()
	-- distance on main icon
    br.pulse:getDist()
    br.pulse:dispDist()

	-- Check if FH got injected correctly
	-- has a bug, if bug happen shouldBePlayer = nil
	-- turns distance color to red
	--local shouldBePlayer,_ = UnitName(ObjectPointer("Player"))
	--if shouldBePlayer == GetUnitName("player") then
	--	displayDistance = math.ceil(targetDistance)
	--else
	--	displayDistance = "|cffFF0011"..math.ceil(targetDistance)
	--end
	-- End Bug Check
    -- Disabled as of october 2015, bug seems to be fixed for awhile

	mainText:SetText(displayDistance)
	-- enemies
    br.pulse:makeEnTable()
	-- ttd
    br.pulse:ttd()
	-- allies
    if isChecked("HE Active") then
	    br.friend:Update()
    end
	-- Pulse other features
	-- PokeEngine()
	ProfessionHelper()
	SalvageHelper()
end

