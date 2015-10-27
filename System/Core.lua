function bb:Engine()
	-- Hidden Frame
	if Pulse_Engine == nil then
		Pulse_Engine = CreateFrame("Frame", nil, UIParent)
		Pulse_Engine:SetScript("OnUpdate", BadBoyUpdate)
		Pulse_Engine:Show()
	end
end
-- Chat Overlay: Originally written by Sheuron.
local function onUpdate(self,elapsed)
	if self.time < GetTime() - 2.0 then if self:GetAlpha() == 0 then self:Hide(); else self:SetAlpha(self:GetAlpha() - 0.02); end end
end
chatOverlay = CreateFrame("Frame",nil,ChatFrame1)
chatOverlay:SetSize(ChatFrame1:GetWidth(),50)
chatOverlay:Hide()
chatOverlay:SetScript("OnUpdate",onUpdate)
chatOverlay:SetPoint("TOP",0,0)
chatOverlay.text = chatOverlay:CreateFontString(nil,"OVERLAY","MovieSubtitleFont")
chatOverlay.text:SetAllPoints()
chatOverlay.texture = chatOverlay:CreateTexture()
chatOverlay.texture:SetAllPoints()
chatOverlay.texture:SetTexture(0,0,0,.50)
chatOverlay.time = 0
function ChatOverlay(Message, FadingTime)
	if getOptionCheck("Overlay Messages") then
		chatOverlay:SetSize(ChatFrame1:GetWidth(),50)
		chatOverlay.text:SetText(Message)
		chatOverlay:SetAlpha(1)
		if FadingTime == nil then
			chatOverlay.time = GetTime()
		else
			chatOverlay.time = GetTime() - 2 + FadingTime
		end
		chatOverlay:Show()
	end
end
function bb:MinimapButton()
	local dragMode = nil --"free", nil
	local function moveButton(self)
		local centerX, centerY = Minimap:GetCenter()
		local x, y = GetCursorPosition()
		x, y = x / self:GetEffectiveScale() - centerX, y / self:GetEffectiveScale() - centerY
		centerX, centerY = math.abs(x), math.abs(y)
		centerX, centerY = (centerX / math.sqrt(centerX^2 + centerY^2)) * 76, (centerY / sqrt(centerX^2 + centerY^2)) * 76
		centerX = x < 0 and -centerX or centerX
		centerY = y < 0 and -centerY or centerY
		self:ClearAllPoints()
		self:SetPoint("CENTER", centerX, centerY)
	end
	local button = CreateFrame("Button", "BadBoyButton", Minimap)
	button:SetHeight(25)
	button:SetWidth(25)
	button:SetFrameStrata("MEDIUM")
	button:SetPoint("CENTER", 75.70,-6.63)
	button:SetMovable(true)
	button:SetUserPlaced(true)
	button:SetNormalTexture("Interface\\HelpFrame\\HotIssueIcon.blp")
	button:SetPushedTexture("Interface\\HelpFrame\\HotIssueIcon.blp")
	button:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-Background.blp")
	button:SetScript("OnMouseDown",function(self, button)
		if button == "RightButton" then
			if BadBoy_data.options[GetSpecialization()] then
				if not FireHack then
						print("|cffFF1100BadBoy |cffFFFFFFCannot Start... |cffFF1100Firehack |cffFFFFFFis not loaded. Please attach Firehack.")
				else
                    if bb:checkProfileWindowStatus() then
                        BadBoy_data.options[GetSpecialization()]["configFrame"] = true
                        bb:checkProfileWindowStatus()
                    else
                        BadBoy_data.options[GetSpecialization()]["configFrame"] = false
                        bb:checkProfileWindowStatus()
                    end
				end
			end
        end
        if button == "MiddleButton" then
            if bb.help_window then
                bb.help_window.parent:Show()
            end
        end
		if IsShiftKeyDown() and IsAltKeyDown() then
			self:SetScript("OnUpdate",moveButton)
		end
	end)
	button:SetScript("OnMouseUp",function(self)
		self:SetScript("OnUpdate",nil)
	end)
	button:SetScript("OnClick",function(self, button)
		if button == "LeftButton" then
			if IsShiftKeyDown() and not IsAltKeyDown() then
				if BadBoy_data["Main"] == 1 then
					BadBoy_data["Main"] = 0
					mainButton:Hide()
				else
					BadBoy_data["Main"] = 1
					mainButton:Show()
				end
			elseif not IsShiftKeyDown() and not IsAltKeyDown() then
                bb:checkConfigWindowStatus()
				--if BadBoy_data.options[GetSpecialization()] then
				--	if BadBoy_data.options[GetSpecialization()]["optionsFrame"] ~= true then
				--		optionsFrame:Show()
				--		BadBoy_data.options[GetSpecialization()]["optionsFrame"] = true
				--	else
				--		optionsFrame:Hide()
				--		BadBoy_data.options[GetSpecialization()]["optionsFrame"] = false
				--	end
				--end
            end
		end
	end)
	button:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(Minimap, "ANCHOR_CURSOR", 50 , 50)
		GameTooltip:SetText("BadBoy The Ultimate Raider", 214/255, 25/255, 25/255)
		GameTooltip:AddLine("CodeMyLife - CuteOne - Masoud")
		GameTooltip:AddLine("Gabbz - Chumii - AveryKey")
		GameTooltip:AddLine("Ragnar - Cpoworks - Tocsin")
		GameTooltip:AddLine("Mavmins - CukieMunster - Magnu")
		GameTooltip:AddLine("Left Click to toggle config frame.", 1, 1, 1, 1)
		GameTooltip:AddLine("Shift+Left Click to toggle toggles frame.", 1, 1, 1, 1)
		GameTooltip:AddLine("Alt+Shift+LeftButton to drag.", 1, 1, 1, 1)
		GameTooltip:AddLine("Right Click to open profile options.", 1, 1, 1, 1)
        GameTooltip:AddLine("Middle Click to open help frame.", 1, 1, 1, 1)
		GameTooltip:Show()
	end)
	button:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)
end
--[[-------------------------------------------------------------------------------------------------------------------------------------------------------]]
--[[---------          ---           --------       -------           --------------------------------------------------------------------------------------------------------------------]]
--[[---------  -----  ----   ---------------  ----  -------  --------  ---------------------------------------------------------------------------------------------------]]
--[[---------  ----  -----           ------  ------  ------  ---------  ----------------------------------------------------------------------------------------------------------]]
--[[---------       ------  --------------             ----  ---------  -------------------------------------------------------------------------------------------------------------]]
--[[---------  ----  -----  -------------  ----------  ----  --------  -------------------------------------------------------------------------------------------------]]
--[[---------  -----  ----           ---  ------------  ---            -------------------------------------------------------------------------------------------------------------------]]
--[[-------------------------------------------------------------------------------------------------------------------------------------------------------]]
local frame = CreateFrame("FRAME")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_LOGOUT")
frame:RegisterUnitEvent("ACTIVE_TALENT_GROUP_CHANGED")
frame:RegisterUnitEvent("CHARACTER_POINTS_CHANGED")
function reloadOnSpecChange()
    if BadBoy_data["Power"] == 1 then
        ReloadUI()
    end
end
-- Sets 'talentHasChanged' to true
function characterTalentChanged()
    if bb.talentHasChanged == nil then
        bb.talentHasChanged = true
    end
end

function frame:OnEvent(event, arg1)
	if event == "ADDON_LOADED" and arg1 == "BadBoy" then
		bb:Run()
	end
	if event == "ACTIVE_TALENT_GROUP_CHANGED" then
        reloadOnSpecChange() -- Reloads UI when spec changed, prevents some bugs
    end
    if event == "CHARACTER_POINTS_CHANGED" and arg1 == -1 then
        characterTalentChanged() -- Sets a global to indicate a talent was changed
    end
end
frame:SetScript("OnEvent", frame.OnEvent)
--[[-------------------------------------------------------------------------------------------------------------------------------------------------------]]
--[[-------------------------------------------------------------------------------------------------------------------------------------------------------]]
--[[-------------------------------------------------------------------------------------------------------------------------------------------------------]]
--[[-------------------------------------------------------------------------------------------------------------------------------------------------------]]
--[[This function is refired everytime wow ticks. This frame is located in Core.lua]]
function BadBoyUpdate(self)
	-- prevent ticking when firechack isnt loaded
	-- if user click power button, stop everything from pulsing.
	if not getOptionCheck("Start/Stop BadBoy") or BadBoy_data["Power"] ~= 1 then
		optionsFrame:Hide()
		_G["debugFrame"]:Hide()
		return false
	end
	if FireHack == nil then
		optionsFrame:Hide()
		_G["debugFrame"]:Hide()
		if getOptionCheck("Start/Stop BadBoy") then
			ChatOverlay("FireHack not Loaded.")
		end
		return
	end
	-- pulse enemiesEngine
	bb:PulseUI()

    -- Show Debug Frame TEMP
    if isChecked("Debug Frame") then
        _G["debugFrame"]:Show()
    else
        _G["debugFrame"]:Hide()
    end

	-- accept dungeon queues
	bb:AcceptQueues()
	--[[Class/Spec Selector]]
    bb.selectedProfile = BadBoy_data.options[GetSpecialization()]["Rotation".."Drop"] or 1
	local playerClass = select(3,UnitClass("player"))
	local playerSpec = GetSpecialization()
	if playerClass == 1 then -- Warrior
		if playerSpec == 2 then
			FuryWarrior()
		elseif playerSpec == 3 then
			ProtectionWarrior()
		else
			ArmsWarrior()
		end
	elseif playerClass == 2 then -- Paladin
		if playerSpec == 1 then
			PaladinHoly()
		elseif playerSpec == 2 then
			PaladinProtection()
		elseif playerSpec == 3 then
			PaladinRetribution()
		end
	elseif playerClass == 3 then -- Hunter
		if playerSpec == 1 then
			BeastHunter()
		elseif playerSpec == 2 then
			MarkHunter()
		else
			SurvHunter()
		end
	elseif playerClass == 4 then -- Rogue
		if playerSpec == nil then
			NewRogue()
		end
		if playerSpec == 1 then
			AssassinationRogue()
		elseif playerSpec == 2 then
			CombatRogue()
		elseif playerSpec == 3 then
			SubRogue()
		end
	elseif playerClass == 5 then -- Priest
		if playerSpec == 3 then
			PriestShadow()
		end
		if playerSpec == 1 then
			PriestDiscipline()
		end
	elseif playerClass == 6 then -- Deathknight
		if playerSpec == 1 then
			Blood()
		end
		if playerSpec == 2 then
			FrostDK()
		end
		if playerSpec == 3 then
			UnholyDK()
		end
	elseif playerClass == 7 then -- Shaman
		if playerSpec == 1 then
			ShamanElemental()
		end
		if playerSpec == 2 then
			ShamanEnhancement()
		end
		if playerSpec == 3 then
			ShamanRestoration()
		end
	elseif playerClass == 8 then -- Mage
		if playerSpec == 1 then
			ArcaneMage()
		end
		if playerSpec == 2 then
			FireMage()
		end
		if playerSpec == 3 then
			FrostMage()
		end
	elseif playerClass == 9 then -- Warlock
		if playerSpec == 2 then
			WarlockDemonology()
		elseif playerSpec == 3 then
			WarlockDestruction()
		end
	elseif playerClass == 10 then -- Monk
		if playerSpec == nil then
			NewMonk()
		end
		if playerSpec == 1 then
			BrewmasterMonk()
		elseif playerSpec == 2 then
			MistweaverMonk();
		elseif playerSpec == 3 then
			WindwalkerMonk()
		end
	elseif playerClass == 11 then -- Druid
		if playerSpec == 1 then
			DruidMoonkin()
		end
		if playerSpec == 2 then
			DruidFeral()
		end
		if playerSpec == 3 then
			DruidGuardian()
		end
		if playerSpec == 4 then
			DruidRestoration()
		end
	end
end

--[[-------------------------------------------------------------------------------------------------------------------------------------------------------]]

--[[-------------------------------------------------------------------------------------------------------------------------------------------------------]]

--[[-------------------------------------------------------------------------------------------------------------------------------------------------------]]

--[[-------------------------------------------------------------------------------------------------------------------------------------------------------]]
