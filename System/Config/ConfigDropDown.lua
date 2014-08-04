function CreateNewDrop(value, textString, base, tip1, value1, value2, value3, value4, value5, value6, value7, value8, value9, value10)

	local vvalues = { value1, value2, value3, value4, value5, value6, value7, value8, value9, value10 }
	local vValue = tonumber(BadBoy_data["Drop "..textString])
	local tip = tip1
	if tip == "Toggle" then 
		tip = "|cffFFFFFFSet wich button you want as toggle for \n"..textString.."."; 
		vvalues = {"|cffFFBB00LeftCtrl", "|cffFFBB00LeftShift", "|cffFFBB00RightCtrl", "|cffFFBB00RightShift", "|cffFFBB00RightAlt"}
	end	
	if tip == "CD" then 
		tip = "|cffFFFFFFSets how you want this Cooldown to react. \n|cffD60000Never = Never use this CD. \n|cffFFBB00CDs = Use this CD when ActiveCooldowns Enabled. \n|cff15FF00Always = Always use this CD."; 
		vvalues = {"|cffD60000Never", "|cffFFBB00CDs", "|cff15FF00Always"}
	end
	if tip == "Auto" then 
		tip = "|cffFFFFFFSets how you want this Ability to react."; 
		vvalues = {"|cffD60000Off", "|cffFFBB00Auto", "|cff15FF00On"}
	end

	if base == nil then base = 1 end
	if vValue == nil then vValue = base; end
	_G["option"..value.."Drop"] = CreateFrame("Frame", nil, configFrame);
	_G["option"..value.."Drop"]:SetBackdropColor(1,1,1,1);
	_G["option"..value.."Drop"]:SetAlpha(0.80);
	_G["option"..value.."Drop"]:SetWidth(80);
	_G["option"..value.."Drop"]:SetHeight(19);
	_G["option"..value.."Drop"]:SetPoint("TOPRIGHT", -5 , -((value*22)));
	_G["option"..value.."Drop"]:EnableMouseWheel(true)
	_G["option"..value.."Drop"].texture = _G["option"..value.."Drop"]:CreateTexture();
	_G["option"..value.."Drop"].texture:SetAllPoints();
	_G["option"..value.."Drop"].texture:SetTexture([[Interface\DialogFrame\UI-DialogBox-Background-Dark]],0.5);

	_G["option"..value.."Drop"]:SetScript("OnMouseWheel", function(self, delta)
		if vvalues[tonumber(vValue)+delta]  ~= nil then
		    vValue = (tonumber(vValue) + (delta))
		    BadBoy_data["Drop "..textString] = vValue
			_G["option"..value.."DropText"]:SetText(vvalues[vValue]);
		end
	end)

	_G["option"..value.."Drop"]:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "BOTTOMRIGHT", 80, 5);
		if tip1 ~= nil then GameTooltip:SetText(tip, nil, nil, nil, nil, true); end
		GameTooltip:Show();
	end)
	_G["option"..value.."Drop"]:SetScript("OnLeave", function(self)
		GameTooltip:Hide();
	end)

	_G["option"..value.."DropText"] = _G["option"..value.."Drop"]:CreateFontString(nil, "OVERLAY");
	_G["option"..value.."DropText"]:SetFontObject("QuestTitleFontBlackShadow", 17,"THICKOUTLINE");
	_G["option"..value.."DropText"]:SetTextHeight(17);
	_G["option"..value.."DropText"]:SetPoint("CENTER", 0 , 0);
	_G["option"..value.."DropText"]:SetTextColor(225/255, 225/255, 225/255,1);
	_G["option"..value.."DropText"]:SetText(vvalues[vValue]);
	if BadBoy_data["Drop "..textString] == nil then BadBoy_data["Drop "..textString] = base; print("yo"..textString ) end
end