
function CreateNewBound(value,textString)
	tinsert(WrapTable, {Value = value, String = textString});
	theEnd = value;
end


function CreateNewWrap(value,textString)

	function WrapsManager()
		for i = 1 , #WrapTable-1 do
			if BadBoy_data["Check "..WrapTable[i].String] == 0 then
				HideWrap(WrapTable[i].Value);
			else
				DisplayWrap(WrapTable[i].Value);
			end
		end
	end

	function HideWrap(value)
       	local WrapBegins = 0;
        local WrapEnd = 0;
		for i = 1, #WrapTable do
			if WrapTable[i].Value == value then
				WrapBegins = WrapTable[i].Value;
				WrapEnd = WrapTable[i+1].Value;
			end
		end
		for i = WrapBegins+1, WrapEnd-1 do
			DeleteRow(i);
		end
		ReplaceWraps()
	end

	function DisplayWrap(value)
        local WrapBegins = 0;
        local WrapEnd = 0;
		for i = 1, #WrapTable do
			if WrapTable[i].String == textString then
				WrapBegins = WrapTable[i].Value;
				WrapEnd = WrapTable[i+1].Value;
			end
		end
		for i = WrapBegins+1, WrapEnd-1 do
			ReviveRow(i);
		end
		ReplaceWraps()
	end

	function DeleteRow(Row)
 		if _G["option"..Row.."Text"] ~= nil then _G["option"..Row.."Text"]:Hide(); end
 		if _G["option"..Row.."Drop"] ~= nil then _G["option"..Row.."Drop"]:Hide(); end
 		if _G["option"..Row.."Check"] ~= nil then _G["option"..Row.."Check"]:Hide(); end
 		if _G["option"..Row.."Box"] ~= nil then _G["option"..Row.."Box"]:Hide(); end
 	end

 	function ClearRow(Row)
 		if _G["option"..Row.."Text"] ~= nil then _G["option"..Row.."Text"]:Hide(); end
 		if _G["option"..Row.."Drop"] ~= nil then _G["option"..Row.."Drop"]:Hide(); end
 		if _G["option"..Row.."Check"] ~= nil then _G["option"..Row.."Check"]:Hide(); end
 		if _G["option"..Row.."Box"] ~= nil then _G["option"..Row.."Box"]:Hide(); end 		
 		if _G["option"..Row.."Text"] ~= nil then _G["option"..Row.."Text"] = nil ; end
 		if _G["option"..Row.."Drop"] ~= nil then _G["option"..Row.."Drop"] = nil ; end
 		if _G["option"..Row.."Check"] ~= nil then _G["option"..Row.."Check"] = nil ; end
 		if _G["option"..Row.."Box"] ~= nil then _G["option"..Row.."Box"] = nil ; end
 	end	

 	function ClearConfig()
 		for i = 0, thisConfig do
 			ClearRow(i);
 			configFrame:SetHeight(30)
 		end
 	end

 	function ReviveRow(Row)
 		if _G["option"..Row.."Text"] ~= nil then _G["option"..Row.."Text"]:Show(); end
 		if _G["option"..Row.."Drop"] ~= nil then _G["option"..Row.."Drop"]:Show(); end
 		if _G["option"..Row.."Check"] ~= nil then _G["option"..Row.."Check"]:Show(); end
 		if _G["option"..Row.."Box"] ~= nil then _G["option"..Row.."Box"]:Show(); end
 	end	

 	function ReplaceRow(Value,Row)
		if _G["option"..Value.."Text"] ~= nil then _G["option"..Value.."Text"]:SetPoint("TOPLEFT", 28,-(Row*22)); end
		if _G["option"..Value.."Drop"] ~= nil then _G["option"..Value.."Drop"]:SetPoint("TOPRIGHT", -5 , -(Row*22)); end
 		if _G["option"..Value.."Check"] ~= nil then _G["option"..Value.."Check"]:SetPoint("TOPLEFT", 5, -(Row*22)); end
 		if _G["option"..Value.."Box"] ~= nil then _G["option"..Value.."Box"]:SetPoint("TOPRIGHT", -5 , -(Row*22)); end
 	end

 	function ReplaceWraps()
 		local totalshown = 0;
 		for i = 1, thisConfig do
 			if _G["option"..i.."Text"] ~= nil then
 				if _G["option"..i.."Text"]:IsShown() == true then
 					totalshown = totalshown + 1;
 					ReplaceRow(i,totalshown)
					configFrame:SetHeight((totalshown*22)+25);
 				end
 			end
 		end
 	end

	if WrapTable == nil then
		WrapTable = { };
	end
	tinsert(WrapTable, {Value = value, String = textString})



	_G["option"..value.."Check"] = CreateFrame("CheckButton", "MyButton", configFrame, "UIPanelButtonTemplate");
	_G["option"..value.."Check"]:SetAlpha(0.80);
	_G["option"..value.."Check"]:SetWidth(21);
	_G["option"..value.."Check"]:SetHeight(21);
	_G["option"..value.."Check"]:SetPoint("TOPLEFT", 5 , -((value*22)));
	_G["option"..value.."Check"]:RegisterForClicks("AnyUp");



    if BadBoy_data["Check "..textString] == 1 then
        _G["option"..value.."Check"]:SetNormalTexture([[Interface\BUTTONS\UI-Panel-HideButton-Up]]);
    else
        _G["option"..value.."Check"]:SetNormalTexture([[Interface\BUTTONS\UI-Panel-ExpandButton-Up]]);
    end





	_G["option"..value.."Check"]:SetScript("OnClick", function()
		if BadBoy_data["Check "..textString] == 1 then
            BadBoy_data["Check "..textString] = 0;
            _G["option"..value.."Check"]:SetNormalTexture([[Interface\BUTTONS\UI-Panel-ExpandButton-Up]]);

            local WrapBegins = 0;
            local WrapEnd = 0;
 			for i = 1, #WrapTable do
 				if WrapTable[i].Value == value then
 					WrapBegins = WrapTable[i].Value;
 					WrapEnd = WrapTable[i+1].Value;
 				end
 			end
 			for i = WrapBegins+1, WrapEnd-1 do
				DeleteRow(i);
 			end
 			ReplaceWraps()

        else


            BadBoy_data["Check "..textString] = 1;
            _G["option"..value.."Check"]:SetNormalTexture([[Interface\BUTTONS\UI-Panel-HideButton-Up]]);
            local WrapBegins = 0;
            local WrapEnd = 0;
 			for i = 1, #WrapTable do
 				if WrapTable[i].String == textString then
 					WrapBegins = WrapTable[i].Value;
 					WrapEnd = WrapTable[i+1].Value;
 				end
 			end
 			for i = WrapBegins+1, WrapEnd-1 do
 				ReviveRow(i);
 			end
 			ReplaceWraps()

        end
	end )



	_G["option"..value.."Check"]:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "BOTTOMLEFT", 225, 5);
		if tip1 ~= nil then GameTooltip:SetText(tip1, nil, nil, nil, nil, true); else GameTooltip:SetText("|cff15FF00Shows|cffFFFFFF/|cffD60000Hide |cffFFFFFFThis Wrap|cffFFBB00.", nil, nil, nil, nil, true); end
		GameTooltip:Show();
	end)
	_G["option"..value.."Check"]:SetScript("OnLeave", function(self)
		GameTooltip:Hide();
	end)

	if BadBoy_data["Check "..textString] == nil then 
		BadBoy_data["Check "..textString] = 0; 
	end


	_G["option"..value.."Text"] = configFrame:CreateFontString(nil, "ARTWORK");
	_G["option"..value.."Text"]:SetFont("Fonts/FRIZQT__.TTF",17,"THICKOUTLINE");
	_G["option"..value.."Text"]:SetTextHeight(17);
	_G["option"..value.."Text"]:SetPoint("TOPLEFT",28,-((value*22)));
	_G["option"..value.."Text"]:SetTextColor(225/255, 225/255, 225/255,1);
	_G["option"..value.."Text"]:SetText(classColors[select(3,UnitClass("player"))].hex..textString, 1, 1, 1, 0.7);
	if (value*22)+26 > configHeight then
		configHeight = (value*22)+26
		configFrame:SetHeight(configHeight+5);
	end
	thisConfig = thisConfig + 1

end