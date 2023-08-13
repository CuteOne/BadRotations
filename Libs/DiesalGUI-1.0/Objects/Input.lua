-- $Id: Input.lua 60 2016-11-04 01:34:23Z diesal2010 $

local DiesalGUI = LibStub("DiesalGUI-1.0")
-- ~~| Libraries |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local DiesalTools = LibStub("DiesalTools-1.0")
local DiesalStyle = LibStub("DiesalStyle-1.0")
-- ~~| Diesal Upvalues |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local Colors = DiesalStyle.Colors
local HSL, ShadeColor, TintColor = DiesalTools.HSL, DiesalTools.ShadeColor, DiesalTools.TintColor
-- ~~| Lua Upvalues |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- | Input |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local Type = "Input"
local Version = 1
-- | Stylesheets |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local Stylesheet = {
	['frame-background'] = {
		type			= 'texture',
		layer			= 'BACKGROUND',
		color			= '000000',
    alpha     = .6,
	},
	['editBox-outline'] = {
    type  = 'outline',
    layer = 'BORDER',
    color = 'FFFFFF',
    alpha = .02,
    position = 1,
	},
	['editBox-inline'] = {
    type	= 'outline',
		layer	= 'BORDER',
		color	= '000000',
    alpha = .7,
	},
	['editBox-hover'] = {
		type			= 'texture',
		layer			= 'HIGHLIGHT',
		color			= 'ffffff',
		alpha 		= .05,
		position		= -1,
	},
	['editBox-font'] = {
		type			= 'Font',
    color			= Colors.UI_TEXT,
	},
}

-- ~~| Spinner Methods |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local methods = {
	['OnAcquire'] = function(self)
		self:SetStylesheet(Stylesheet)
		self:ApplySettings()
		self:Show()
	end,
	['OnRelease'] = function(self)

	end,
	['ApplySettings'] = function(self)
		self:SetWidth( self.settings.width)
		self:SetHeight( self.settings.height)
	end,
	['GetText'] = function(self)
		return self.editBox:GetText()
	end,
	['SetText'] = function(self,txt)
		self.editBox:SetText(txt)
	end,
	['SetTextColor'] = function(self,color,alpha)
		alpha = alpha or 1
		color = {DiesalTools.GetColor(color)}
		self.editBox:SetTextColor(color[1],color[2],color[3],alpha)
	end,
}
-- | Constructor |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local function Constructor()
	local self 		= DiesalGUI:CreateObjectBase(Type)
	local frame		= CreateFrame('Frame',nil,UIParent)
	self.frame		= frame
	self.defaults = {
		height 			= 16,
		width 			= 50,
		mouse				= true,
	}
	-- ~~ Events ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	-- OnAcquire, OnRelease, OnHeightSet, OnWidthSet
	-- OnEnter, OnLeave, OnEnterPressed, OnValueChanged
	-- ~~ Construct ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	frame:SetScript("OnHide",function(this)
		self:FireEvent("OnHide")
	end)

	local editBox = self:CreateRegion("EditBox", 'editBox', frame)
	editBox:SetAllPoints()
	editBox:SetAutoFocus(false)
	editBox:SetJustifyH("LEFT")
	editBox:SetJustifyV("CENTER")
	editBox:SetTextInsets(3,0,2,0)
	editBox:SetScript('OnEnterPressed',  function(this,...)
		self:FireEvent("OnEnterPressed",...)
		DiesalGUI:ClearFocus()
	end)
	editBox:HookScript('OnEscapePressed', function(this,...)
		self:FireEvent("OnEscapePressed",...)
	end)
	editBox:HookScript('OnEditFocusLost', function(this,...)
		self:FireEvent("OnEditFocusLost",...)
	end)
	editBox:HookScript('OnEditFocusGained', function(this,...)
		self:FireEvent("OnEditFocusGained",...)
	end)
	editBox:SetScript("OnEnter",function(this,...)
		self:FireEvent("OnEnter",...)
	end)
	editBox:SetScript("OnLeave", function(this,...)
		self:FireEvent("OnLeave",...)
	end)

	-- ~~ Methods ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	for method, func in pairs(methods) do	self[method] = func	end
	-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	return self
end

DiesalGUI:RegisterObjectConstructor(Type,Constructor,Version)
