 -- $Id: Bar.lua 60 2016-11-04 01:34:23Z diesal2010 $
local DiesalGUI = LibStub("DiesalGUI-1.0")
-- | Libraries |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local DiesalTools = LibStub("DiesalTools-1.0")
local DiesalStyle = LibStub("DiesalStyle-1.0")
-- ~~| Diesal Upvalues |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local Colors = DiesalStyle.Colors
local HSL, ShadeColor, TintColor = DiesalTools.HSL, DiesalTools.ShadeColor, DiesalTools.TintColor
-- | Lua Upvalues |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local type, tonumber, select 		= type, tonumber, select
local pairs, ipairs, next				= pairs, ipairs, next
local min, max					 				= math.min, math.max
-- | WoW Upvalues |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- | Spinner |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local Type = "Bar"
local Version = 1
-- | Stylesheets |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local Stylesheet = {
	['frame-background'] = {
		type			= 'texture',
		layer			= 'BACKGROUND',
		color			= '000000',
		alpha			= .60,
	},
	['frame-outline'] = {
		type			= 'outline',
		layer			= 'BORDER',
		color			= 'FFFFFF',
		alpha 		= .02,
		position		= 1,
	},
	['frame-inline'] = {
		type			= 'outline',
		layer			= 'BORDER',
		color			= '000000',
		alpha 		= .60,
	},
  ['bar-background'] = {
    type = 'texture',
    layer = 'BACKGROUND',
    gradient = {'VERTICAL',Colors.UI_A100,ShadeColor(Colors.UI_A100,.1)},
    position = 0,
  },
  ['bar-inline'] = {
    type = 'outline',
    layer = 'BORDER',
    gradient = {'VERTICAL','FFFFFF','FFFFFF'},
    alpha = {.07,.02},
    position = 0,
  },
  ['bar-outline'] = {
    type = 'texture',
    layer = 'ARTWORK',
    color = '000000',
    alpha = .7,
    width = 1,
    position = {nil,1,0,0},
  },
}
local wireFrame = {
	['frame-white'] = {
		type			= 'outline',
		layer			= 'OVERLAY',
		color			= 'ffffff',
	},
	['bar-green'] = {
		type			= 'outline',
		layer			= 'OVERLAY',
		color			= '55ff00',
	},
}
-- | Locals |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local function round(num)
	return floor((num + 1/2)/1) * 1
end
-- | Methods |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local methods = {
	['OnAcquire'] = function(self)
		self:SetStylesheet(Stylesheet)
		self:ApplySettings()

		-- self:SetStylesheet(wireFrame)
		self:Show()
	end,
	['OnRelease'] = function(self)

	end,
	['ApplySettings'] = function(self)
		self:UpdateSize()
	end,
	['UpdateSize'] = function(self)
		self:SetWidth(self.settings.width)
		self:SetHeight(self.settings.height)

		self.bar:SetPoint('TOPLEFT',self.settings.padding[1],-self.settings.padding[3])
		self.bar:SetPoint('BOTTOMLEFT',self.settings.padding[1],self.settings.padding[4])

		self.settings.barWidth = self.settings.width - self.settings.padding[1] - self.settings.padding[2]

		self:UpdateBar()
	end,
	['SetColor'] = function(self, color, colorTop, gradientDirection)

	end,
	['SetSize'] = function(self, width, height)
		width, height = tonumber(width), tonumber(height)
		if not width then error('Bar:SetSize(width, height) width to be a number.',0) end
		if not height then error('Bar:SetSize(width, height) height to be a number.',0) end

		self.settings.width, self.settings.height = width, height

		self:UpdateSize()
	end,
	['SetValue'] = function(self, number, min, max)
		number, min, max = tonumber(number), tonumber(min), tonumber(max)
		if not number then error('Bar:SetValue(number) number needs to be a number.',0) end

		self.settings.min = min or self.settings.min
		self.settings.max = max or self.settings.max
		self.settings.value = number
		self:UpdateBar()
	end,
	['SetMin'] = function(self, number)
		number = tonumber(number)
		if not number then error('Bar:SetMin(number) needs to be a number.',0) end

		self.settings.min = number
		self:UpdateBar()
	end,
	['SetMax'] = function(self, number)
		number = tonumber(number)
		if not number then error('Bar:SetMax(number) needs to be a number.',0) end

		self.settings.max = number
		self:UpdateBar()
	end,
	['UpdateBar'] = function(self)
		local min, max, value, barWidth = self.settings.min, self.settings.max, self.settings.value, self.settings.barWidth
		local width = round( (value - min) / (max - min) * barWidth )
		if width == 0 then
			self.bar:Hide()
		else
			self.bar:Show()
			self.bar:SetWidth(width)
		end
	end,
	['IsVisible'] = function(self)
		return self.frame:IsVisible()
	end,
}
-- | Constructor |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local function Constructor()
	local self 		= DiesalGUI:CreateObjectBase(Type)
	local frame		= CreateFrame('Frame',nil,UIParent)
	self.frame		= frame
	-- ~~ Default Settings ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	self.defaults = {
		height 			= 14, -- frame height (not bar)
		width 			= 96,	-- frame width (not bar)
		padding			= {1,1,1,1}, -- left, right, top, bottom		(bar padding from frame)
		value				= 0,
		min					= 0,
		max					= 100,
	}
	-- ~~ Construct ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	frame:SetScript("OnHide",function(this)
		self:FireEvent("OnHide")
	end)

	local bar = self:CreateRegion("Frame", 'bar', frame)

	-- ~~ Methods ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	for method, func in pairs(methods) do	self[method] = func	end
	-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	return self
end
DiesalGUI:RegisterObjectConstructor(Type,Constructor,Version)
