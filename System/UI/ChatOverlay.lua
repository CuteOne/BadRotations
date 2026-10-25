local _, br = ...
br.ui.chatOverlay = br.ui.chatOverlay or {}
local chatOverlay = br.ui.chatOverlay

-- Chat Overlay: Originally written by Sheuron.
-- Fade speed after the 2 s hold: about 0.8 s, what the old 0.02-per-frame fade took at 60 FPS
local FADE_PER_SECOND = 1.2
local function onUpdate(self, elapsed)
	if br.game.GetTime() - self.time < 2.0 then return end
	local alpha = self:GetAlpha() - FADE_PER_SECOND * elapsed
	if alpha <= 0 then
		self:Hide()
	else
		self:SetAlpha(alpha)
	end
end

-- Chat Overlay Frame
chatOverlay.frame = br.game.CreateFrame("Frame", nil, br.game.ChatFrame1)
chatOverlay.frame:SetSize(br.game.ChatFrame1:GetWidth(), 50)
chatOverlay.frame:Hide()
chatOverlay.frame:SetScript("OnUpdate", onUpdate)
chatOverlay.frame:SetPoint("TOP", 0, 0)
chatOverlay.frame.text = chatOverlay.frame:CreateFontString(nil, "OVERLAY", "MovieSubtitleFont")
chatOverlay.frame.text:SetAllPoints()
chatOverlay.frame.texture = chatOverlay.frame:CreateTexture()
chatOverlay.frame.texture:SetAllPoints()
chatOverlay.frame.texture:SetColorTexture(0, 0, 0, .50)
chatOverlay.frame.time = 0

-- Function to show messages in chat overlay
function chatOverlay:Show(Message, FadingTime)
	if br.functions.misc:getOptionCheck("Overlay Messages") then
		chatOverlay.frame:SetSize(br.game.ChatFrame1:GetWidth(), 50)
		chatOverlay.frame.text:SetText(Message)
		chatOverlay.frame:SetAlpha(1)
		if FadingTime == nil or type(FadingTime) ~= "number" then
			chatOverlay.frame.time = br.game.GetTime()
		else
			chatOverlay.frame.time = br.game.GetTime() - 2 + FadingTime
		end
		chatOverlay.frame:Show()
	end
end
