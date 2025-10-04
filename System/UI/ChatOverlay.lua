local _, br = ...
br.ui.chatOverlay = br.ui.chatOverlay or {}
local chatOverlay = br.ui.chatOverlay

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

-- Chat Overlay Frame
chatOverlay.frame = br._G.CreateFrame("Frame", nil, br._G.ChatFrame1)
chatOverlay.frame:SetSize(br._G.ChatFrame1:GetWidth(), 50)
chatOverlay.frame:Hide()
chatOverlay.frame:SetScript("OnUpdate", onUpdate)
chatOverlay.frame:SetPoint("TOP", 0, 0)
chatOverlay.frame.text = chatOverlay.frame:CreateFontString(nil, "OVERLAY", "MovieSubtitleFont")
chatOverlay.frame.text:SetAllPoints()
chatOverlay.frame.texture = chatOverlay.frame:CreateTexture()
chatOverlay.frame.texture:SetAllPoints()
chatOverlay.frame.texture:SetTexture(0, 0, 0, .50)
chatOverlay.frame.time = 0

-- Function to show messages in chat overlay
function chatOverlay:Show(Message, FadingTime)
	if br.functions.misc:getOptionCheck("Overlay Messages") then
		chatOverlay.frame:SetSize(br._G.ChatFrame1:GetWidth(), 50)
		chatOverlay.frame.text:SetText(Message)
		chatOverlay.frame:SetAlpha(1)
		if FadingTime == nil or type(FadingTime) ~= "number" then
			chatOverlay.frame.time = br._G.GetTime()
		else
			chatOverlay.frame.time = br._G.GetTime() - 2 + FadingTime
		end
		chatOverlay.frame:Show()
	end
end
