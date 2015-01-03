-- this function is suited to load informations from a table
-- parent: name of parent frame
-- value: name of the frame
-- textString: text to show on the frame
-- width: inherit from the parent frame
-- height: inherit from the parent frame
function createRow(parent,value,textString)
    local scale = BadBoy_data.BadBoyUI[parent.."Frame"].scale or 1
    _G[parent..value.."Frame"] = CreateFrame("Frame", "DebugRow", _G[parent.."Frame"])
    _G[parent..value.."Frame"]:SetWidth(290*scale)
    _G[parent..value.."Frame"]:SetHeight(24*scale)
    _G[parent..value.."Frame"]:SetPoint("TOPLEFT",5*scale,-(value*24)*scale)
    _G[parent..value.."Frame"]:SetAlpha(BadBoy_data.BadBoyUI.alpha)
    _G[parent..value.."Frame"]:SetScript("OnEnter", function(self)
        local MyValue = value
        if _G[parent.."Table"] ~= nil and _G[parent.."Table"][value] ~= nil then
            GameTooltip:SetOwner(self, "BOTTOMLEFT", 250, 5)
            GameTooltip:SetText(_G[parent.."Table"][value].toolTip, nil, nil, nil, nil, false)
            GameTooltip:Show()
        end
    end)
    _G[parent..value.."Text"] = _G[parent..value.."Frame"]:CreateFontString(_G[parent..value.."Frame"],"ARTWORK")
    _G[parent..value.."Text"]:SetWidth(290*scale)
    _G[parent..value.."Text"]:SetHeight(24*scale)
    _G[parent..value.."Text"]:SetPoint("TOPLEFT",0,0)
    _G[parent..value.."Text"]:SetAlpha(BadBoy_data.BadBoyUI.alpha)
    _G[parent..value.."Text"]:SetJustifyH("LEFT")
    _G[parent..value.."Text"]:SetFont(BadBoy_data.BadBoyUI.font,BadBoy_data.BadBoyUI.fontsize+1*scale,"THICKOUTLINE")
end

-- /run badboyFrameRefresh("debug")
function badboyFrameRefresh(name)
    for i = 1, 5 do
        local debugItem
        if _G[name.."Table"][i] ~= nil then
            debugItem = _G[name.."Table"][i].textString or ""
        end
        _G[name..i.."Text"]:SetText(debugItem, 1, 1, 1, 0.7)
    end
end

function badboyDebugShown()
    if BadBoy_data.options[GetSpecialization()]["Debug Frame"] == 1 then
        _G["debugFrame"]:Show()
    else
        _G["debugFrame"]:Hide()
    end
end
