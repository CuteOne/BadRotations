-- this function will create a child button at x,y position from the topleft corner.
function createStatusBar(parent,option,x,y)
	local value,status,statusMin,statusMax = option.name,option.status,option.statusMin,option.statusMax
	local statusStep,statusBase = option.statusStep,option.statusBase
	if statusStep == nil then
		statusStep = 5
	end
	local enabled = enabled or true
	local width = width or 75
	local heigth = heigth or 22
	local currentValue
	if  BadBoy_data.options[GetSpecialization()] then
		currentValue = BadBoy_data.options[GetSpecialization()][value.."Status"]
	end
	if currentValue == nil then
		currentValue = statusBase or 0
	end
	if _G[parent..value.."Status"] == nil then
		local scale = BadBoy_data.BadBoyUI.optionsFrame.scale or 1
		_G[parent..value.."Status"] = CreateFrame("StatusBar", _G[parent..value.."Status"], _G[parent.."Frame"])
		_G[parent..value.."Status"]:SetWidth(width*scale)
		_G[parent..value.."Status"]:SetHeight(heigth*scale)
		_G[parent..value.."Status"]:SetPoint("TOPLEFT",x*scale,(y-2)*scale)
		_G[parent..value.."Status"]:SetAlpha(BadBoy_data.BadBoyUI.alpha)
		-- status part
		_G[parent..value.."Status"]:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
		_G[parent..value.."Status"]:GetStatusBarTexture():SetHorizTile(false)
		_G[parent..value.."Status"]:SetMinMaxValues(statusMin,statusMax)
		_G[parent..value.."Status"]:SetValue(currentValue or 50)
		if enabled then
			_G[parent..value.."Status"]:EnableMouseWheel(true)
			-- hover event
			_G[parent..value.."Status"]:SetScript("OnEnter", function(self)
				GameTooltip:SetOwner(self, "BOTTOMLEFT", 225, 5)
				GameTooltip:SetText(status, nil, nil, nil, nil, true)
				GameTooltip:Show()
			end)
			-- leave event
			_G[parent..value.."Status"]:SetScript("OnLeave", function(self)
				GameTooltip:Hide()
			end)
			-- here i need to track the current values from bb.options.1.
			_G[parent..value.."Status"]:SetScript("OnMouseWheel", function(self, delta)
				if currentValue then
					currentValue = (currentValue + (delta*statusStep))
				end
				if currentValue and currentValue < statusMin then
					currentValue = statusMin
				end
				if currentValue and currentValue > statusMax then
					currentValue = statusMax
				end
				BadBoy_data.options[GetSpecialization()][value.."Status"] = currentValue or 0
				_G[parent..value.."Status"]:SetValue(currentValue)
				_G[parent..value.."StatusText"]:SetText(currentValue)
			end)
		end
		-- text
		_G[parent..value.."StatusText"] = _G[parent..value.."Status"]:CreateFontString(_G[parent..value.."StatusText"],"ARTWORK")
		_G[parent..value.."StatusText"]:SetWidth(width*scale)
		_G[parent..value.."StatusText"]:SetHeight(heigth*scale)
		_G[parent..value.."StatusText"]:SetPoint("CENTER",0,-2)
		_G[parent..value.."StatusText"]:SetAlpha(BadBoy_data.BadBoyUI.alpha)
		_G[parent..value.."StatusText"]:SetJustifyH("CENTER")
		_G[parent..value.."StatusText"]:SetFont(BadBoy_data.BadBoyUI.font,BadBoy_data.BadBoyUI.fontsize,"THICKOUTLINE")
		_G[parent..value.."StatusText"]:SetText(currentValue, nil, nil, nil, nil, false)
	end
end
-- this function will create a child button at x,y position from the topleft corner.
function createNovaStatusBar(parent,option,x,y,width,heigth)
	local value,status,statusMin,statusMax = option.name,option.status,option.statusMin,option.statusMax
	local width = width or 180
	local heigth = heigth or 22
	if _G[parent..value.."Nova"] == nil then
		local scale = BadBoy_data.BadBoyUI.optionsFrame.scale or 1
		_G[parent..value.."Nova"] = CreateFrame("StatusBar", _G[parent..value.."Nova"], _G[parent.."Frame"])
		_G[parent..value.."Nova"]:SetWidth(width*scale)
		_G[parent..value.."Nova"]:SetHeight(heigth*scale)
		_G[parent..value.."Nova"]:SetPoint("TOPLEFT",x*scale,(y-2)*scale)
		_G[parent..value.."Nova"]:SetAlpha(BadBoy_data.BadBoyUI.alpha)
		-- status part
		_G[parent..value.."Nova"]:SetStatusBarTexture(1,1,1)
		_G[parent..value.."Nova"]:SetMinMaxValues(statusMin,statusMax)
		_G[parent..value.."Nova"]:SetValue(currentValue or 50)
		-- hover event
		_G[parent..value.."Nova"]:SetBackdropColor(1,1,1)
		_G[parent..value.."Nova"]:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "BOTTOMLEFT", 225, 5)
			local thisUnit = nNova[value]
			local color = "|cffFFFFFF"
			if classColors[thisUnit.class] ~= nil then
				color = classColors[thisUnit.class].hex
			end
			GameTooltip:SetText(color.."Name: "..thisUnit.name..
				"\n|cffFF1100Health: "..math.floor(thisUnit.hp)..
				"\n|cff11A7DFRole: "..thisUnit.role, nil, nil, nil, nil, true)
			GameTooltip:Show()
		end)
		-- leave event
		_G[parent..value.."Nova"]:SetScript("OnLeave", function(self)
			GameTooltip:Hide()
		end)
		-- leave event
		_G[parent..value.."Nova"]:SetScript("OnMouseDown", function(self, button)
			if button == "RightButton" then
				FocusUnit(nNova[value].unit)
			else
				RunMacroText("/target "..UnitName(nNova[value].unit))
			end
		end)
		-- text
		_G[parent..value.."NovaText"] = _G[parent..value.."Nova"]:CreateFontString(_G[parent..value.."NovaText"],"ARTWORK")
		_G[parent..value.."NovaText"]:SetWidth(width*scale)
		_G[parent..value.."NovaText"]:SetHeight(heigth*scale)
		_G[parent..value.."NovaText"]:SetPoint("CENTER",0,-2)
		_G[parent..value.."NovaText"]:SetAlpha(BadBoy_data.BadBoyUI.alpha)
		_G[parent..value.."NovaText"]:SetJustifyH("CENTER")
		_G[parent..value.."NovaText"]:SetFont(BadBoy_data.BadBoyUI.font,BadBoy_data.BadBoyUI.fontsize,"THICKOUTLINE")
		_G[parent..value.."NovaText"]:SetText(currentValue, nil, nil, nil, nil, false)
		if nNovaDebug == nil then
			nNovaDebug = {}
		end
		nNovaDebug[#nNovaDebug+1] = parent..value.."Nova"
	end
end
