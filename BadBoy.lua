-- define bb global that will hold the bot global background features
bb = {}
bbdata = {}
bb.selectedSpec = 1
bb.selectedProfile = 1
bb.dropOptions = {}
bb.dropOptions.Toggle = {"LeftCtrl","LeftShift","RightCtrl","RightShift","RightAlt","None"}
bb.dropOptions.Toggle2 ={"LeftCtrl","LeftShift","LeftAlt","RightCtrl","RightShift","RightAlt","MMouse","Mouse4","Mouse5","None" }
bb.dropOptions.CD = {"Never","CDs","Always" }
-- developers debug, use /run bb.data["isDebugging"] = true
bb.debug = {}
function bb.debug:print(message)
	if bb.data["isDebugging"] == true then
		print(message)
	end
end
function bb:Run()
	rc = LibStub("LibRangeCheck-2.0")
	minRange, maxRange = rc:GetRange('target')
	-- lets wipe and start up fresh.
	bb.data = bbdata
	if bb.data == nil or bb.data and bb.data.wiped ~= true then
		bb.data = {
			buttonSize = 32,
			wiped = true
		}
		bbdata = bb.data
	end
	--[[Init the readers codes (System/Reader.lua)]]
	-- combat log
	bb.read.combatLog()
	-- other readers
	bb.read.commonReaders()
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
	if bb.data.options == nil then
		bb.data.options = {}
		bb.data.options[1] = {}
		bb.data.options[2] = {}
		bb.data.options[3] = {}
		bb.data.options[4] = {}
		bb.data.options[5] = {}
    end
    if bb.data.options[5] == nil then
        bb.data.options[5] = {}
    end
    if GetSpecialization() == nil then
    	bb.selectedSpec = 5
    	bb.selectedProfile = 1
    else
    	bb.selectedSpec = GetSpecialization()
    end
    if bb.data.options[bb.selectedSpec]["Rotation".."Drop"] == nil then
        bb.selectedProfile = 1
    else
        bb.selectedProfile = bb.data.options[bb.selectedSpec]["Rotation".."Drop"]
    end
    --bb.selectedProfile = bb.data.options[bb.selectedSpec]["Rotation".."Drop"] or 1
    if bb.data.options[bb.selectedSpec][bb.selectedProfile]  == nil then
        bb.data.options[bb.selectedSpec][bb.selectedProfile] = {}
    end
	-- uncomment that when all ready
	if bb.data.BadBoyUI == nil then
		bb.data.BadBoyUI = {
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
	-- Macro Toggle ON/OFF
	SLASH_BadBoy1 = "/BadBoy"
	function SlashCmdList.BadBoy(msg, editbox, ...)
		print(...)
        if msg == "" then
		    mainButton:Click()
        elseif msg == "hide" then
            BadBoyButton:Hide()
        elseif msg == "show" then
            BadBoyButton:Show()
        end

	end
	SLASH_AoE1 = "/aoe"
	function SlashCmdList.AoE(msg, editbox)
		ToggleValue("AoE")
	end
	SLASH_FHStop1 = "/fhstop"
	function SlashCmdList.FHStop(msg, editbox)
		StopFalling()
		StopMoving()
	end
	SLASH_Cooldowns1 = "/Cooldowns"
	function SlashCmdList.Cooldowns(msg, editbox)
		ToggleValue("Cooldowns")
	end
	SLASH_DPS1 = "/DPS"
	function SlashCmdList.DPS(msg, editbox)
		ToggleValue("DPS")
	end
	SLASH_BlackList1, SLASH_BlackList2 = "/blacklist", "/bbb"
	function SlashCmdList.BlackList(msg, editbox)
		if bb.data.blackList == nil then bb.data.blackList = { } end
		if msg == "dump" then
			print("|cffFF0000BadBoy Blacklist:")
			if #bb.data.blackList == (0 or nil) then print("|cffFFDD11Empty") end
			if bb.data.blackList then
				for i = 1, #bb.data.blackList do
					print("|cffFFDD11- "..bb.data.blackList[i].name)
				end
			end
		elseif msg == "clear" then
			bb.data.blackList = { }
			print("|cffFF0000BadBoy Blacklist Cleared")
		else
			if UnitExists("mouseover") then
				local mouseoverName = UnitName("mouseover")
				local mouseoverGUID = UnitGUID("mouseover")
				-- Now we're trying to find that unit in the blackList table to remove
				local found
				for k,v in pairs(bb.data.blackList) do
					-- Now we're trying to find that unit in the Cache table to remove
					if UnitGUID("mouseover") == v.guid then
						tremove(bb.data.blackList, k)
						print("|cffFFDD11"..mouseoverName.."|cffFF0000 Removed from Blacklist")
						found = true
						--blackList[k] = nil
					end
				end
				if not found then
					print("|cffFFDD11"..mouseoverName.."|cffFF0000 Added to Blacklist")
					tinsert(bb.data.blackList, { guid = mouseoverGUID, name = mouseoverName})
				end
			end
		end
	end
	SLASH_Pause1 = "/Pause"
	function SlashCmdList.Pause(msg, editbox)
		if bb.data['Pause'] == 0 then
			ChatOverlay("\124cFFED0000 -- Paused -- ")
			bb.data['Pause'] = 1
		else
			ChatOverlay("\124cFF3BB0FF -- Pause Removed -- ")
			bb.data['Pause'] = 0
		end
	end
	SLASH_Power1 = "/Power"
	function SlashCmdList.Power(msg, editbox)
		if bb.data['Power'] == 0 then
			ChatOverlay("\124cFF3BB0FF -- BadBoy Enabled -- ")
			bb.data['Power'] = 1
		else
			ChatOverlay("\124cFFED0000 -- BadBoy Disabled -- ")
			bb.data['Power'] = 0
		end
	end
	-- Build up pulse frame (hearth)
	bb:Engine()
	-- add minimap fire icon
	bb:MinimapButton()
	-- build up UI
	bb:StartUI()

    if bb.data.options[bb.selectedSpec] == nil then bb.data.options[bb.selectedSpec] = {} end
    if bb.data.options[bb.selectedSpec][bb.selectedProfile] == nil then bb.data.options[bb.selectedSpec][bb.selectedProfile] = {} end
    --bb.selectedProfile = bb.data.options[bb.selectedSpec]["Rotation".."Drop"] or 1
    bb.ui:createConfigWindow()

	-- start up enemies Engine
	enemiesEngineRange = 55
	EnemiesEngine()
	ChatOverlay("-= BadBoy Loaded =-")
end
--[[Startup UI]]
function bb:StartUI()
	-- trigger frame creation in ui.lua
	ConstructUI()
	-- select the active option(refresh)
	_G["options"..bb.data.options.selected.."Button"]:Click()
	-- Build up buttons frame (toggles)
	BadBoyFrame()
end

bb.pulse = {}
bb.pulse.makeTable = true
bb.pulse.gathering = true
-- debug
function bb.pulse:getDist()
    targetDistance = getDistance("target") or 0
end
function bb.pulse:dispDist()
    displayDistance = math.ceil(targetDistance)
end
function bb.pulse:makeEnTable()
    if bb.pulse.makeTable then
        makeEnemiesTable(maxDistance)
    end
end
function bb.pulse:ttd()
    TTDRefresh()
end
--[[Updating UI]]
function bb:PulseUI()
	-- distance on main icon
    bb.pulse:getDist()
    bb.pulse:dispDist()

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
    bb.pulse:makeEnTable()
	-- ttd
    bb.pulse:ttd()
	-- allies
    if isChecked("HE Active") then
	    bb.friend:Update()
    end
	-- Pulse other features
	-- PokeEngine()
	ProfessionHelper()
	SalvageHelper()
end

