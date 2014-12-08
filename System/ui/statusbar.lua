-- this function will create a child button at x,y position from the topleft corner.
function createStatusBar(parent,option,x,y)
    local value,status,statusMin,statusMax = option.name,option.status,option.statusMin,option.statusMax
    local statusStep,statusBase = option.statusStep,option.statusBase
    if statusStep == nil then
        statusStep = 5
    end
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
        _G[parent..value.."Status"]:SetWidth(75*scale)
        _G[parent..value.."Status"]:SetHeight(22*scale)
        _G[parent..value.."Status"]:SetPoint("TOPLEFT",x*scale,(y-2)*scale)
        _G[parent..value.."Status"]:SetAlpha(BadBoy_data.BadBoyUI.alpha)
        -- status part
        _G[parent..value.."Status"]:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
        _G[parent..value.."Status"]:GetStatusBarTexture():SetHorizTile(false)
        _G[parent..value.."Status"]:SetMinMaxValues(statusMin,statusMax)
        _G[parent..value.."Status"]:SetValue(currentValue or 50)
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
        -- text
        _G[parent..value.."StatusText"] = _G[parent..value.."Status"]:CreateFontString(_G[parent..value.."StatusText"],"ARTWORK")
        _G[parent..value.."StatusText"]:SetWidth(150*scale)
        _G[parent..value.."StatusText"]:SetHeight(22*scale)
        _G[parent..value.."StatusText"]:SetPoint("CENTER",0,-2)
        _G[parent..value.."StatusText"]:SetAlpha(BadBoy_data.BadBoyUI.alpha)
        _G[parent..value.."StatusText"]:SetJustifyH("CENTER")
        _G[parent..value.."StatusText"]:SetFont(BadBoy_data.BadBoyUI.font,BadBoy_data.BadBoyUI.fontsize,"THICKOUTLINE")
        _G[parent..value.."StatusText"]:SetText(currentValue, nil, nil, nil, nil, false)

    end

end



