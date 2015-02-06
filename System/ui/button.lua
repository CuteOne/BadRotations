-- this function will create a child button at x,y position from the topleft corner.
function createButton(parent,value,x,y,textString)
  if _G[parent..value.."Button"] == nil then
    local scale = BadBoy_data.BadBoyUI[parent.."Frame"].scale or 1
    _G[parent..value.."Button"] = CreateFrame("Button", _G[parent..value.."Button"], _G[parent.."Frame"])
    _G[parent..value.."Button"]:SetWidth(189*scale)
    _G[parent..value.."Button"]:SetHeight(24*scale)
    _G[parent..value.."Button"]:SetPoint("TOPLEFT",x*scale,y*scale)
    _G[parent..value.."Button"]:SetAlpha(BadBoy_data.BadBoyUI.alpha)
    -- texture part
    _G[parent..value.."Button"].texture = _G[parent..value.."Button"]:CreateTexture(_G[parent..value.."Texture"],"ARTWORK",_G[parent..value.."Frame"])
    _G[parent..value.."Button"].texture:SetAllPoints()
    _G[parent..value.."Button"].texture:SetTexture(BadBoy_data.BadBoyUI[parent.."Frame"].color.r/255,BadBoy_data.BadBoyUI[parent.."Frame"].color.g/255,BadBoy_data.BadBoyUI[parent.."Frame"].color.b/255,BadBoy_data.BadBoyUI[parent.."Frame"].color.a)
    _G[parent..value.."Button"].texture:SetBlendMode("BLEND")
    _G[parent..value.."Button"].texture:SetWidth(150*scale)
    _G[parent..value.."Button"].texture:SetHeight(24*scale)
    -- click event
    _G[parent..value.."Button"]:SetScript("OnClick",function(self)
      BadBoy_data.options.selected = value
      radioGeneral("options",value)
      optionsShow(value)
    end)
    -- hover event
    _G[parent..value.."Button"]:SetScript("OnEnter",function(self)
      if value ~= BadBoy_data.options.selected then
        _G[parent..value.."Button"].texture:SetTexture(100/255,100/255,100/255,BadBoy_data.BadBoyUI.optionsFrame.color.a)
        GameTooltip:Show()
      end
    end)
    -- leave event
    _G[parent..value.."Button"]:SetScript("OnLeave",function(self)
      radioGeneral(parent,BadBoy_data.options.selected)
      GameTooltip:Hide()
    end)
    -- text frame
    _G[parent..value.."Text"] = _G[parent..value.."Button"]:CreateFontString(_G[parent..value.."Text"],"ARTWORK")
    _G[parent..value.."Text"]:SetWidth(189*scale)
    _G[parent..value.."Text"]:SetHeight(24*scale)
    _G[parent..value.."Text"]:SetPoint("TOPLEFT",0,0)
    _G[parent..value.."Text"]:SetAlpha(BadBoy_data.BadBoyUI.alpha)
    _G[parent..value.."Text"]:SetJustifyH("CENTER")
    _G[parent..value.."Text"]:SetFont(BadBoy_data.BadBoyUI.font,BadBoy_data.BadBoyUI.fontsize*scale,"THICKOUTLINE")
    _G[parent..value.."Text"]:SetJustifyH("CENTER")
    _G[parent..value.."Text"]:SetText(textString, nil, nil, nil, nil, false)
  end
end
