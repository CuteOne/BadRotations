-- $Id: ComboBoxItem.lua 60 2016-11-04 01:34:23Z diesal2010 $

local DiesalGUI = LibStub('DiesalGUI-1.0')
-- ~~| Libraries |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local DiesalTools = LibStub('DiesalTools-1.0')
local DiesalStyle = LibStub("DiesalStyle-1.0")
-- ~~| Diesal Upvalues |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local Colors = DiesalStyle.Colors
local HSL, ShadeColor, TintColor = DiesalTools.HSL, DiesalTools.ShadeColor, DiesalTools.TintColor
-- ~~| Lua Upvalues |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-- ~~| WoW Upvalues |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-- ~~| ComboBoxItem |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local Type 		= 'ComboBoxItem'
local Version 	= 2
-- ~~| ComboBoxItem Stylesheets |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local Stylesheet = {
	['frame-hover'] = {
		type			= 'texture',
		layer			= 'HIGHLIGHT',
		color			= 'b3d9ff',
		alpha			= .05,
	},
}
-- ~~| ComboBoxItem Locals |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-- ~~| ComboBoxItem Methods |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local methods = {
	['OnAcquire'] = function(self)
		self:ApplySettings()
		self:SetStylesheet(Stylesheet)
		-- self:SetStylesheet(wireFrameSheet)
		self:Show()
	end,
	['OnRelease'] = function(self)
		self.check:Hide()
	end,
	['ApplySettings'] = function(self)
		if not self.settings.key then return end

		local settings 			= self.settings
		local comboBoxSettings	= settings.parentObject.settings
		local text 					= self.text

		if settings.position == 1 then
			self:SetPoint('TOPLEFT')
			self:SetPoint('RIGHT')
		else
			self:SetPoint('TOPLEFT',settings.parentObject.children[settings.position-1].frame,'BOTTOMLEFT',0,0)
			self:SetPoint('RIGHT')
		end

		self:SetHeight(comboBoxSettings.dropdownButtonWidth)

		self:SetText(settings.value)
	end,
	['SetText'] = function(self,text)
		self.text:SetText(text)
	end,
	['OnClick'] = function(self)
		local settings 			= self.settings
		local comboBox 			= settings.parentObject
		local comboBoxSettings	= comboBox.settings
		local comboBoxItems		= comboBox.children

		for i=1,#comboBoxItems do
			comboBoxItems[i]:SetSelected(false)
		end

		self:SetSelected(true)

		comboBox.dropdown:Hide()
		comboBox:SetText(settings.value)
		comboBox:FireEvent("OnValueSelected",settings.key,settings.value)
	end,
	['SetSelected'] = function(self,selected)
		if selected then
			self.settings.parentObject.settings.selectedKey = self.settings.key
			self.settings.selected = true
			self.check:Show()
		else
			self.settings.selected = false
			self.check:Hide()
		end
	end,
}
-- ~~| ComboBoxItem Constructor |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local function Constructor()
	local self 		= DiesalGUI:CreateObjectBase(Type)
	local frame		= CreateFrame('Button',nil,UIParent)
	self.frame		= frame
	-- ~~ Default Settings ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	self.defaults = {	}
	-- ~~ Registered Events ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

	-- ~~ Construct ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	frame:SetScript("OnClick", function(this,button) self:OnClick() end)
	frame:SetScript('OnEnter', function(this) end)
	frame:SetScript('OnLeave', function(this) end)

	local text = self:CreateRegion("FontString", 'text', frame)
	text:SetPoint("TOPLEFT",12,-2)
	text:SetPoint("BOTTOMRIGHT",0,0)
	text:SetJustifyH("TOP")
	text:SetJustifyH("LEFT")
	text:SetWordWrap(false)

	local check = self:CreateRegion("Texture", 'check', frame)
	DiesalStyle:StyleTexture(check,{
		position 	= {2,nil,0,nil},
		height	= 16,
		width		= 16,
    image    = {'DiesalGUIcons', {10,5,16,256,128},'FFFF00'},
	})
	check:Hide()
	-- ~~ Methods ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	for method, func in pairs(methods) do	self[method] = func	end
	-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	return self
end
DiesalGUI:RegisterObjectConstructor(Type,Constructor,Version)
