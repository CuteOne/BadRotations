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
		local tooltip = _G[parent..value.."Text"]:GetText()
		if tooltip then
			GameTooltip:SetOwner(self, "BOTTOMLEFT", 250, 5)
			GameTooltip:SetText(tooltip, nil, nil, nil, nil, false)
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
function bb.read:display(...)
	if getOptionCheck("Debug Frame") then
		_G["debug10Text"]:SetText(_G["debug9Text"]:GetText(), 1, 1, 1, 0.7)
		_G["debug9Text"]:SetText(_G["debug8Text"]:GetText(), 1, 1, 1, 0.7)
		_G["debug8Text"]:SetText(_G["debug7Text"]:GetText(), 1, 1, 1, 0.7)
		_G["debug7Text"]:SetText(_G["debug6Text"]:GetText(), 1, 1, 1, 0.7)
		_G["debug6Text"]:SetText(_G["debug5Text"]:GetText(), 1, 1, 1, 0.7)
		_G["debug5Text"]:SetText(_G["debug4Text"]:GetText(), 1, 1, 1, 0.7)
		_G["debug4Text"]:SetText(_G["debug3Text"]:GetText(), 1, 1, 1, 0.7)
		_G["debug3Text"]:SetText(_G["debug2Text"]:GetText(), 1, 1, 1, 0.7)
		_G["debug2Text"]:SetText(_G["debug1Text"]:GetText(), 1, 1, 1, 0.7)
		_G["debug1Text"]:SetText(..., 1, 1, 1, 0.7)
	end
end
