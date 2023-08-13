 -- $Id: Spinner.lua 60 2016-11-04 01:34:23Z diesal2010 $
local DiesalGUI = LibStub("DiesalGUI-1.0")
-- | Libraries |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local DiesalTools = LibStub("DiesalTools-1.0")
local DiesalStyle = LibStub("DiesalStyle-1.0")
-- ~~| Diesal Upvalues |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local Colors = DiesalStyle.Colors
local HSL, ShadeColor, TintColor = DiesalTools.HSL, DiesalTools.ShadeColor, DiesalTools.TintColor
local round = DiesalTools.Round
-- | Lua Upvalues |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local type, tonumber, select 		= type, tonumber, select
local pairs, ipairs, next				= pairs, ipairs, next
local min, max					 				= math.min, math.max
-- | WoW Upvalues |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- | Spinner |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local Type = "Spinner"
local Version = 3
-- | Stylesheets |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local Stylesheet = {
  ['frame-background'] = {
    type = 'texture',
    layer = 'BACKGROUND',
    color = '000000',
    alpha = .6,
  },
  ['frame-inline'] = {
    type = 'outline',
    layer = 'BORDER',
    color = '000000',
    alpha = .6,
  },
  ['frame-outline'] = {
    type = 'outline',
    layer = 'BORDER',
    color = 'FFFFFF',
    alpha = .02,
    position = 1,
  },
  ['frame-hover'] = {
    type = 'outline',
    layer = 'HIGHLIGHT',
    color = 'FFFFFF',
    alpha = .25,
    position = -1,
  },
  ['editBox-font'] = {
    type = 'Font',
    color = Colors.UI_TEXT,
  },
  ['bar-background'] = {
    type = 'texture',
    layer = 'BACKGROUND',
    gradient = {'VERTICAL',Colors.UI_A100,ShadeColor(Colors.UI_A100,.1)},
  },
  ['bar-inline'] = {
    type = 'outline',
    layer = 'BORDER',
    gradient = {'VERTICAL','FFFFFF','FFFFFF'},
    alpha = {.07,.02},
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
	['editBox-purple'] = {
		type			= 'outline',
		layer			= 'OVERLAY',
		color			= 'aa00ff',
	},
	['buttonUp-yellow'] = {
		type			= 'outline',
		layer			= 'OVERLAY',
		color			= 'fffc00',
	},
	['buttonDown-orange'] = {
		type			= 'outline',
		layer			= 'OVERLAY',
		color			= 'ffd400',
	},
	['bar-green'] = {
		type			= 'outline',
		layer			= 'OVERLAY',
		color			= '55ff00',
	},
}
-- | Internal Methods |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local function processNumber(self, number)
  local settings 	= self.settings
  local number, oldNumber	= tonumber(number), self:GetNumber()

  if not number then
    number = oldNumber or settings.min
  else
    number = max(min(number,settings.max),settings.min)
  end

  settings.number = number

  self.editBox:SetText( (settings.prefix or '')..number..(settings.suffix or '') )
  self.editBox:HighlightText(0,0) -- clear any selcted text
  self.editBox:SetCursorPosition(0)

  self:UpdateBar()

  if number ~= oldNumber then return number end
end
-- | Methods |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local methods = {
	['OnAcquire'] = function(self)
		self:SetStylesheet(Stylesheet)
    -- self:SetStylesheet(wireFrame)
		self:ApplySettings()
		self:Show()
	end,
	['OnRelease'] = function(self) end,
	['ApplySettings'] = function(self)
		local settings 			= self.settings
		local frame					= self.frame
		local buttonUp			= self.buttonUp
		local buttonDown		= self.buttonDown
		local editBox				= self.editBox
		local buttonsWidth 	= settings.buttons and settings.buttonsWidth or 0
		local buttonHeight	= round(settings.height / 2)
		-- Apply Settings
		self:SetWidth(settings.width)
		self:SetHeight(settings.height)

		editBox:EnableMouse(settings.mouse)
		editBox:EnableMouseWheel(settings.mouseWheel)
		editBox:SetPoint('BOTTOMRIGHT',-buttonsWidth,0)

		buttonUp[settings.buttons and "Show" or "Hide"](buttonUp)
		buttonUp:EnableMouse(settings.mouse)
		buttonUp:SetHeight(buttonHeight)
		buttonUp:SetWidth(buttonsWidth)
		buttonDown[settings.buttons and "Show" or "Hide"](buttonDown)
		buttonDown:EnableMouse(settings.mouse)
		buttonDown:SetHeight(buttonHeight)
		buttonDown:SetWidth(buttonsWidth)

		self:UpdateBar()
	end,
	['EnableMouse'] = function(self,enable)
		self.settings.mouse = enable
		self.buttonUp:EnableMouse(enable)
		self.buttonDown:EnableMouse(enable)
		self.editBox:EnableMouse(enable)
		self.editBox:EnableMouseWheel(enable)
	end,
	['GetNumber'] = function(self)
		return self.settings.number
	end,
	['SetNumber'] = function(self,number)
		local newNumber = processNumber(self, number)
		if newNumber then	self:FireEvent("OnValueChanged",false,newNumber) end
	end,
  ['SetPrefix'] = function(self,prefix)
    self.settings.prefix = prefix
    processNumber(self, self.settings.number)
	end,
  ['SetSuffix'] = function(self,suffix)
    self.settings.suffix = suffix
    processNumber(self, self.settings.number)
	end,
	['OnSpin'] = function(self,delta)
		local step = IsShiftKeyDown() and self.settings.shiftStep or self.settings.step
    local oldNumber	= self.settings.number
		local newNumber

		if delta > 0 then
			newNumber = processNumber(self, round(oldNumber,step)+step)
		else
			newNumber = processNumber(self, round(oldNumber,step)-step)
		end

		if newNumber then	self:FireEvent("OnValueChanged",true,newNumber) end
	end,
	['UpdateBar'] = function(self)
		if not self.settings.bar then return end
    local settings = self.settings
    local barWidth = self:GetWidth() - (settings.buttons and settings.buttonsWidth or 0) - 2 -- bar padding
		local number = settings.number or settings.min
		local width = round(((number - settings.min) / (settings.max - settings.min) * barWidth ))
		if width == 0 then
			self.bar:Hide()
		else
			self.bar:Show()
			self.bar:SetWidth(width)
		end
		self.value = settings.number
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
	-- ~~ Default Settings ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	self.defaults = {
		height 			= 16,
		width 			= 29,
		mouse				= true,
		mouseWheel	= true,
		buttons			= false,
		buttonsWidth= 8,
		bar					= true,
		min					= 0,
		max					= 100,
		step				= 5,
		shiftStep		= 1,
	}
	-- ~~ Construct ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	frame:SetScript("OnHide",function(this)
		self:FireEvent("OnHide")
	end)
  frame:SetScript('OnSizeChanged', function() self:UpdateBar() end )

	local editBox = self:CreateRegion("EditBox", 'editBox', frame)
	editBox:SetPoint("TOPLEFT")
	editBox:SetAutoFocus(false)
	editBox:SetJustifyH("CENTER")
	editBox:SetJustifyV("CENTER")
	editBox:SetTextInsets(1,0,2,0)
	editBox:SetText(self.defaults.min)
	editBox:SetScript('OnEnterPressed',  function(this,...)
    local number = this:GetNumber() or self.settings.number -- if entered text or nothing revert to old value
    local newNumber = processNumber(self, number)

    if newNumber then self:FireEvent("OnValueChanged",true,newNumber)end
		self:FireEvent("OnEnterPressed",...)

		DiesalGUI:ClearFocus()
	end)
	editBox:HookScript('OnEditFocusLost', function(this,...)
    processNumber(self, self.settings.number)
	end)
	editBox:HookScript('OnEditFocusGained', function(this)
    this:SetText( self.settings.number )
    this:HighlightText()
	end)
	editBox:SetScript("OnMouseWheel", function(this,delta)
		DiesalGUI:OnMouse(this,'MouseWheel')
		self:OnSpin(delta)
	end)
	editBox:SetScript("OnEnter",function(this,...)
		self:FireEvent("OnEnter",...)
	end)
	editBox:SetScript("OnLeave", function(this,...)
		self:FireEvent("OnLeave",...)
	end)

	local bar = self:CreateRegion("Frame", 'bar', frame)
	bar:SetPoint('TOPLEFT',1,-1)
	bar:SetPoint('BOTTOMLEFT',-1,1)

	local buttonUp = self:CreateRegion("Button", 'buttonUp', frame)
	buttonUp:SetPoint('TOP',0,0)
	buttonUp:SetPoint('RIGHT')
	buttonUp:SetScript("OnClick", function(this)
		DiesalGUI:OnMouse(this,button)
		PlaySound(799)
		self:OnSpin(1)
	end)
	local buttonDown = self:CreateRegion("Button", 'buttonDown', frame)
	buttonDown:SetPoint('BOTTOM',0,0)
	buttonDown:SetPoint('RIGHT')
	buttonDown:SetScript("OnClick", function(this)
		DiesalGUI:OnMouse(this,button)
		PlaySound(799)
		self:OnSpin(-1)
	end)

	-- ~~ Methods ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	for method, func in pairs(methods) do	self[method] = func	end
	-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	return self
end
DiesalGUI:RegisterObjectConstructor(Type,Constructor,Version)
