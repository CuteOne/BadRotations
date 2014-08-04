function CreateNewTitle(value,textString)



	
	_G["option"..value.."Text"] = configFrame:CreateFontString(nil, "ARTWORK");
	_G["option"..value.."Text"]:SetFontObject("QuestTitleFontBlackShadow",17,"THICKOUTLINE");
	_G["option"..value.."Text"]:SetAlpha(0.80);
	_G["option"..value.."Text"]:SetTextHeight(18);
	_G["option"..value.."Text"]:SetPoint("TOPLEFT", 3, -((value*22)));
	_G["option"..value.."Text"]:SetTextColor(214/255, 0/255, 0/255,1);
	_G["option"..value.."Text"]:SetText(textString);
	if (value*22)+26 > configHeight then
		configHeight = (value*22)+26
		configFrame:SetHeight(configHeight);
		configFrame.Border:SetHeight(configHeight+10);
	end
	thisConfig = thisConfig + 1
end