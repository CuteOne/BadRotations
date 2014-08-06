
--[[-------------------------------------------------------------------------------------------------------------------------------------------------------]]
--[[---------          ---           --------       -------           --------------------------------------------------------------------------------------------------------------------]]
--[[---------  -----  ----   ---------------  ----  -------  --------  ---------------------------------------------------------------------------------------------------]]
--[[---------  ----  -----           ------  ------  ------  ---------  ----------------------------------------------------------------------------------------------------------]]
--[[---------       ------  --------------             ----  ---------  -------------------------------------------------------------------------------------------------------------]]
--[[---------  ----  -----  -------------  ----------  ----  --------  -------------------------------------------------------------------------------------------------]]
--[[---------  -----  ----           ---  ------------  ---            -------------------------------------------------------------------------------------------------------------------]]
--[[-------------------------------------------------------------------------------------------------------------------------------------------------------]]

-- Chat Overlay: Originally written by Sheuron.
local function onUpdate(self,elapsed) 
  	if self.time < GetTime() - 2.0 then if self:GetAlpha() == 0 then self:Hide(); else self:SetAlpha(self:GetAlpha() - 0.02); end end 
end
chatOverlay = CreateFrame("Frame",nil,ChatFrame1); 
chatOverlay:SetSize(ChatFrame1:GetWidth(),50);
chatOverlay:Hide();
chatOverlay:SetScript("OnUpdate",onUpdate);
chatOverlay:SetPoint("TOP",0,0);
chatOverlay.text = chatOverlay:CreateFontString(nil,"OVERLAY","MovieSubtitleFont");
chatOverlay.text:SetAllPoints();
chatOverlay.texture = chatOverlay:CreateTexture();
chatOverlay.texture:SetAllPoints();
chatOverlay.texture:SetTexture(0,0,0,.50);
chatOverlay.time = 0;
function ChatOverlay(message) 
	chatOverlay:SetSize(ChatFrame1:GetWidth(),50);
  	chatOverlay.text:SetText(message);
  	chatOverlay:SetAlpha(1);
  	chatOverlay.time = GetTime(); 
  	chatOverlay:Show(); 
end	


local frame = CreateFrame("FRAME");
frame:RegisterEvent("ADDON_LOADED");
frame:RegisterEvent("PLAYER_LOGOUT");

function frame:OnEvent(event, arg1)
 	if event == "ADDON_LOADED" and arg1 == "BadBoy" then
 		ChatOverlay("Addons Loaded. Starting BadBoy.");
 		BadBoy_data = BadBoy_data;
 		BadBoyRun();
	end
end
frame:SetScript("OnEvent", frame.OnEvent);



-- Sell Greys Macros
SLASH_Greys1 = "/grey"
SLASH_Greys2 = "/greys"
function SlashCmdList.Greys(msg, editbox)
	SellGreys();
end

function SellGreys()
  	for bag = 0,4 do
    	for slot = 1,GetContainerNumSlots(bag) do
      		local item = GetContainerItemLink(bag,slot)
      		if item then
				-- Is it grey quality item?
        		if string.find(item, qualityColors.grey) ~= nil then
          			greyPrice = select(11, GetItemInfo(item)) * select(2, GetContainerItemInfo(bag, slot))
          			if greyPrice > 0 then
            			PickupContainerItem(bag, slot)
            			PickupMerchantItem()
            		end
            	end
            end
        end
    end
    ChatOverlay("Sold Greys")
end

