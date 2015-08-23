-- define bb global that will hold the bot global background features
bb = { }
-- developers debug, use /run BadBoy_data["Development Debug"] = true
function bb:debug(message)
	if BadBoy_data["Development Debug"] == true then
		print(message)
	end
end
function bb:Run()
	rc = LibStub("LibRangeCheck-2.0")
	minRange, maxRange = rc:GetRange('target')
	-- lets wipe and start up fresh.
	if BadBoy_data == nil or BadBoy_data and BadBoy_data.wiped ~= true then
		BadBoy_data = {
			buttonSize = 32,
			wiped = true
		}
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
		[5]				= {class = "Priest",	B=1,		G=1,	R=1,	hex="|cffffffff"},
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
	if BadBoy_data.options == nil then
		BadBoy_data.options = {}
		BadBoy_data.options[1] = {}
		BadBoy_data.options[2] = {}
		BadBoy_data.options[3] = {}
		BadBoy_data.options[4] = {}
	end
	-- uncomment that when all ready
	if BadBoy_data.BadBoyUI == nil then
		BadBoy_data.BadBoyUI = {
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
		mainButton:Click()
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
		if BadBoy_data.blackList == nil then BadBoy_data.blackList = { } end
		if msg == "dump" then
			print("|cffFF0000BadBoy Blacklist:")
			if #BadBoy_data.blackList == (0 or nil) then print("|cffFFDD11Empty") end
			if BadBoy_data.blackList then
				for i = 1, #BadBoy_data.blackList do
					print("|cffFFDD11- "..BadBoy_data.blackList[i].name)
				end
			end
		elseif msg == "clear" then
			BadBoy_data.blackList = { }
			print("|cffFF0000BadBoy Blacklist Cleared")
		else
			if UnitExists("mouseover") then
				local mouseoverName = UnitName("mouseover")
				local mouseoverGUID = UnitGUID("mouseover")
				-- Now we're trying to find that unit in the blackList table to remove
				local found
				for k,v in pairs(BadBoy_data.blackList) do
					-- Now we're trying to find that unit in the Cache table to remove
					if UnitGUID("mouseover") == v.guid then
						tremove(BadBoy_data.blackList, k)
						print("|cffFFDD11"..mouseoverName.."|cffFF0000 Removed from Blacklist")
						found = true
						--blackList[k] = nil
					end
				end
				if not found then
					print("|cffFFDD11"..mouseoverName.."|cffFF0000 Added to Blacklist")
					tinsert(BadBoy_data.blackList, { guid = mouseoverGUID, name = mouseoverName})
				end
			end
		end
	end
	SLASH_Pause1 = "/Pause"
	function SlashCmdList.Pause(msg, editbox)
		if BadBoy_data['Pause'] == 0 then
			ChatOverlay("\124cFFED0000 -- Paused -- ")
			BadBoy_data['Pause'] = 1
		else
			ChatOverlay("\124cFF3BB0FF -- Pause Removed -- ")
			BadBoy_data['Pause'] = 0
		end
	end
	SLASH_Power1 = "/Power"
	function SlashCmdList.Power(msg, editbox)
		if BadBoy_data['Power'] == 0 then
			ChatOverlay("\124cFF3BB0FF -- BadBoy Enabled -- ")
			BadBoy_data['Power'] = 1
		else
			ChatOverlay("\124cFFED0000 -- BadBoy Disabled -- ")
			BadBoy_data['Power'] = 0
		end
	end
	-- Build up pulse frame (hearth)
	bb:Engine()
	-- add minimap fire icon
	bb:MinimapButton()
	-- build up UI
	bb:StartUI()
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
	_G["options"..BadBoy_data.options.selected.."Button"]:Click()
	-- Build up buttons frame (toggles)
	BadBoyFrame()
end
--[[Updating UI]]
function bb:PulseUI()
	-- distance on main icon
	targetDistance = getDistance("target") or 0

	-- Check if FH got injected correctly
	-- has a bug, if bug happen shouldBePlayer = nil
	-- turns distance color to red
	local shouldBePlayer,_ = UnitName(ObjectPointer("Player"))
	if shouldBePlayer == GetUnitName("player") then
		displayDistance = math.ceil(targetDistance)
	else
		displayDistance = "|cffFF0011"..math.ceil(targetDistance)
	end
	-- End Bug Check

	mainText:SetText(displayDistance)
	-- enemies
	makeEnemiesTable(maxDistance)
	-- allies
    if isChecked("HE Active") then
	    nNova:Update()
    end
	-- Pulse other features
	-- PokeEngine()
	ProfessionHelper()
	SalvageHelper()
end
