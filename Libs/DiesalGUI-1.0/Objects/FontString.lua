local DiesalGUI = LibStub("DiesalGUI-1.0")

local Type = "FontString"
local Version = 1

local function Constructor()
	local self = DiesalGUI:CreateObjectBase(Type)

	-- Create the actual FontString region
	local UIParent = _G.UIParent
	self.frame = CreateFrame("Frame", nil, UIParent)
	self:CreateRegion("FontString", "fontString", self.frame)

	-- CRITICAL: Ensure font is set on the fontString widget
	if self.fontString then
		local testFont = self.fontString:GetFont()
		if not testFont then
			-- Font wasn't set in CreateRegion, set it now
			self.fontString:SetFontObject(_G.GameFontNormal)
		end
	end

	function self:SetParent(parent)
		self.frame:SetParent(parent)
	end

	return self
end

DiesalGUI:RegisterObjectConstructor(Type, Constructor, Version)
