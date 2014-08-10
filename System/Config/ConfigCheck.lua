function CreateNewCheck(value, textString, tip1)

	if BadBoy_data["Check "..textString] == nil then BadBoy_data["Check "..textString] = 1; end

	_G["option"..value.."Check"] = CreateFrame("CheckButton", "MyButton", configFrame, "UIPanelButtonTemplate");
	_G["option"..value.."Check"]:SetAlpha(0.80);
	_G["option"..value.."Check"]:SetWidth(19);
	_G["option"..value.."Check"]:SetHeight(19);
	_G["option"..value.."Check"]:SetPoint("TOPLEFT", 5 , -((value*22)));
	_G["option"..value.."Check"]:SetNormalTexture([[Interface\BUTTONS\ButtonHilight-SquareQuickslot]]);
	_G["option"..value.."Check"]:RegisterForClicks("AnyUp");


	_G["option"..value.."Check"]:SetScript("OnClick", function()
		if BadBoy_data["Check "..textString] == 1 then
            BadBoy_data["Check "..textString] = 0;
            _G["option"..value.."Check"]:SetText(" ");
            ChatOverlay("|cFFED0000"..textString.." Disabled");
        else
            BadBoy_data["Check "..textString] = 1;
            _G["option"..value.."Check"]:SetText("X");
            ChatOverlay("|cff15FF00"..textString.." Enabled");
        end
	end )

	_G["option"..value.."Check"]:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "BOTTOMLEFT", 225, 5);
		if tip1 ~= nil then GameTooltip:SetText(tip1, nil, nil, nil, nil, true); else GameTooltip:SetText("|cff15FF00Enables|cffFFFFFF/|cffD60000Disable \n|cffFFFFFF"..textString.."|cffFFBB00.", nil, nil, nil, nil, true); end
		GameTooltip:Show();
	end)
	_G["option"..value.."Check"]:SetScript("OnLeave", function(self)
		GameTooltip:Hide();
	end)


	if BadBoy_data["Check "..textString] ~= 1 then 
		_G["option"..value.."Check"]:SetText(" "); 
	else 
		_G["option"..value.."Check"]:SetText("X"); 
	end
end