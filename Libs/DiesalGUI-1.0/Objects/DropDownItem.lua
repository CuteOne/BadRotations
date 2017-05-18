-- $Id: DropDownItem.lua 60 2016-11-04 01:34:23Z diesal2010 $

local DiesalGUI = LibStub('DiesalGUI-1.0')
-- ~~| Libraries |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local DiesalTools = LibStub('DiesalTools-1.0')
local DiesalStyle = LibStub("DiesalStyle-1.0")

-- ~~| Lua Upvalues |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local sub, format, lower, upper,gsub								= string.sub, string.format, string.lower, string.upper, string.gsub
-- ~~| WoW Upvalues |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-- ~~| DropdownItem |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local Type 		= 'DropdownItem'
local Version 	= 2
-- ~~| DropdownItem Stylesheets |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local Stylesheet = {
	['frame-hover'] = {
		type			= 'texture',
		layer			= 'HIGHLIGHT',
		color			= 'b3d9ff',
		alpha			= .1,
	},
}
-- ~~| DropdownItem Methods |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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
		local dropdownSettings	= settings.parentObject.settings
		local text 					= self.text

		if settings.position == 1 then
			self:SetPoint('TOPLEFT')
			self:SetPoint('RIGHT')
		else
			self:SetPoint('TOPLEFT',settings.parentObject.children[settings.position-1].frame,'BOTTOMLEFT',0,0)
			self:SetPoint('RIGHT')
		end

		self:SetHeight(dropdownSettings.itemHeight)

		self:SetText(settings.value)
	end,
	['SetText'] = function(self,text)
		self.text:SetText(text)
	end,
	['OnClick'] = function(self)
		local settings 				= self.settings
		local dropdown 				= settings.parentObject
		local dropdownSettings= dropdown.settings
		local dropdownItems		= dropdown.children

		local selectionTable 	= {}
		local dropdownText
		if settings.key ~= 'CLEAR' then
			if dropdownSettings.multiSelect then
				self:SetSelected(not settings.selected)
				for i=1,#dropdownItems do
					if dropdownItems[i].settings.selected then
						if dropdownText then
							dropdownText = format('%s, %s',dropdownText,dropdownItems[i].settings.value)
						else
							dropdownText = dropdownItems[i].settings.value
						end
						selectionTable[#selectionTable+1] = dropdownItems[i].settings.key
					end
				end
			else
				for i=1,#dropdownItems do
					dropdownItems[i]:SetSelected(false)
				end
				self:SetSelected(true)
				dropdownText 	= settings.value
				selectionTable = {settings.key}
				dropdown.dropdown:Hide()
			end
		else
			dropdown.dropdown:Hide()
			dropdown:ClearSelection()
		end

		dropdown:SetText(dropdownText)
		dropdown:FireEvent("OnValueChanged",settings.key,settings.value,selectionTable)
		dropdown:FireEvent("OnValueSelected",settings.key,settings.value,selectionTable)
	end,
	['SetSelected'] = function(self,selected)
		if selected then
			self.settings.selected = true
			self.check:Show()
		else
			self.settings.selected = false
			self.check:Hide()
		end
	end,
}
-- ~~| DropdownItem Constructor |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local function Constructor()
	local self 		= DiesalGUI:CreateObjectBase(Type)
	local frame		= CreateFrame('Button',nil,UIParent)
	self.frame		= frame
	self.defaults = {	}
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
