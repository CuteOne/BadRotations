function CreateNewBox(value,textString,minValue,maxValue,step,base,tip1,tip2,tip3,tip4,tip5)


	local vValue = BadBoy_data["Box "..textString]
	if BadBoy_data["Box "..textString] == nil then BadBoy_data["Box "..textString] = base; end

	if base == nil then base = 5 end
	if vValue == nil then vValue = base end
	_G["option"..value.."Box"] = CreateFrame("StatusBar", nil, configFrame);
	_G["option"..value.."Box"]:SetBackdrop({ bgFile = [[Interface\DialogFrame\UI-DialogBox-Background-Dark]], tile = true, tileSize = 16 });
	_G["option"..value.."Box"]:SetStatusBarTexture([[Interface\\AddOns\\DBM-DefaultSkins\\textures\\default.tga]],"OVERLAY");
	_G["option"..value.."Box"]:SetOrientation("HORIZONTAL");
	_G["option"..value.."Box"]:SetStatusBarColor(1,1,1,1);
	_G["option"..value.."Box"]:SetBackdropColor(1,1,1,1);
	_G["option"..value.."Box"]:GetStatusBarTexture():SetTexture([[Interface\GLUES\MODELS\UI_Goblin\UI_Goblin_sky]],"OVERLAY");
	_G["option"..value.."Box"]:SetMinMaxValues(tonumber(minValue), tonumber(maxValue));
	_G["option"..value.."Box"]:SetAlpha(0.80);
	_G["option"..value.."Box"]:SetValue(vValue);
	_G["option"..value.."Box"]:SetWidth(42);
	_G["option"..value.."Box"]:SetHeight(19);
	_G["option"..value.."Box"].texture = _G["option"..value.."Box"]:CreateTexture();
	_G["option"..value.."Box"].texture:SetAllPoints();
	_G["option"..value.."Box"].texture:SetTexture([[Interface\DialogFrame\UI-DialogBox-Background-Dark]],0.5);
	_G["option"..value.."Box"]:SetPoint("TOPRIGHT", -5 , -((value*22)));
	_G["option"..value.."Box"]:EnableMouseWheel(true)

	_G["option"..value.."Box"]:SetScript("OnMouseWheel", function(self, delta)
	    vValue = (vValue + (delta*step))
	    if vValue < minValue then vValue = minValue; end
	    if vValue > maxValue then vValue = maxValue; end
	    BadBoy_data["Box "..textString] = vValue
	    _G["option"..value.."Box"]:SetValue(vValue);
		_G["option"..value.."BoxText"]:SetText(vValue);
	end)

	_G["option"..value.."Box"]:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "BOTTOMRIGHT", 42, 5);
		if tip1 ~= nil then GameTooltip:SetText(tip1, nil, nil, nil, nil, true); end
		GameTooltip:Show();
	end)
	_G["option"..value.."Box"]:SetScript("OnLeave", function(self)
		GameTooltip:Hide();
	end)

	_G["option"..value.."Box"]:SetValue(vValue);
	_G["option"..value.."BoxText"] = _G["option"..value.."Box"]:CreateFontString(nil, "OVERLAY");
	_G["option"..value.."BoxText"]:SetFont("Fonts/FRIZQT__.TTF",16,"THICKOUTLINE");
	_G["option"..value.."BoxText"]:SetPoint("CENTER", 0 , 0);
	_G["option"..value.."BoxText"]:SetTextColor(225/255, 225/255, 225/255,1);
	_G["option"..value.."BoxText"]:SetText(vValue);
end