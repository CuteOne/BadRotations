local _, br = ...
-- Chat Overlay: Originally written by Sheuron.
local function onUpdate(self)
	if self.time < br._G.GetTime() - 2.0 then
		if self:GetAlpha() == 0 then
			self:Hide()
		else
			self:SetAlpha(math.max(0.02, self:GetAlpha()) - 0.02)
		end
	end
end
br.chatOverlayText = br._G.CreateFrame("Frame", nil, br._G.ChatFrame1)
br.chatOverlayText:SetSize(br._G.ChatFrame1:GetWidth(), 50)
br.chatOverlayText:Hide()
br.chatOverlayText:SetScript("OnUpdate", onUpdate)
br.chatOverlayText:SetPoint("TOP", 0, 0)
br.chatOverlayText.text = br.chatOverlayText:CreateFontString(nil, "OVERLAY", "MovieSubtitleFont")
br.chatOverlayText.text:SetAllPoints()
br.chatOverlayText.texture = br.chatOverlayText:CreateTexture()
br.chatOverlayText.texture:SetAllPoints()
br.chatOverlayText.texture:SetTexture(0, 0, 0, .50)
br.chatOverlayText.time = 0
function br.ChatOverlay(Message, FadingTime)
	if br.getOptionCheck("Overlay Messages") then
		br.chatOverlayText:SetSize(br._G.ChatFrame1:GetWidth(), 50)
		br.chatOverlayText.text:SetText(Message)
		br.chatOverlayText:SetAlpha(1)
		if FadingTime == nil or type(FadingTime) ~= "number" then
			br.chatOverlayText.time = br._G.GetTime()
		else
			br.chatOverlayText.time = br._G.GetTime() - 2 + FadingTime
		end
		br.chatOverlayText:Show()
	end
end
