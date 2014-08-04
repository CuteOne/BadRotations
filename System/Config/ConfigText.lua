function CreateNewText(value,textString)



	
	_G["option"..value.."Text"] = configFrame:CreateFontString(nil, "ARTWORK");
	_G["option"..value.."Text"]:SetFontObject("QuestTitleFontBlackShadow",17,"THICKOUTLINE");
	_G["option"..value.."Text"]:SetTextHeight(17);
	_G["option"..value.."Text"]:SetPoint("TOPLEFT",28,-((value*22)));
	_G["option"..value.."Text"]:SetTextColor(225/255, 225/255, 225/255,1);
	_G["option"..value.."Text"]:SetText(textString, 1, 1, 1, 0.7);
	if (value*22)+26 > configHeight then
		configHeight = (value*22)+26
		configFrame:SetHeight(configHeight+5);
	end
	thisConfig = thisConfig + 1
end