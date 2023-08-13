-- $Id: ComboBox.lua 60 2016-11-04 01:34:23Z diesal2010 $

local DiesalGUI = LibStub('DiesalGUI-1.0')
-- ~~| Libraries |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local DiesalTools = LibStub('DiesalTools-1.0')
local DiesalStyle = LibStub("DiesalStyle-1.0")
-- ~~| Diesal Upvalues |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local Colors = DiesalStyle.Colors
local HSL, ShadeColor, TintColor = DiesalTools.HSL, DiesalTools.ShadeColor, DiesalTools.TintColor
-- ~~| Lua Upvalues |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local sub, format, lower, upper,gsub				= string.sub, string.format, string.lower, string.upper, string.gsub
local tsort																	= table.sort

-- ~~| WoW Upvalues |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-- ~~| ComboBox |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local Type 		= 'ComboBox'
local Version 	= 1
-- ~~| ComboBox Stylesheets |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local Stylesheet = {
  ['frame-background'] = {
    type  = 'texture',
    layer = 'BACKGROUND',
    color = '000000',
    alpha = .7,
  },
	['frame-inline'] = {
		type	= 'outline',
		layer	= 'BORDER',
		color	= '000000',
    alpha = .7,
	},
  ['frame-outline'] = {
    type  = 'outline',
    layer = 'BORDER',
    color = 'FFFFFF',
    alpha = .02,
    position = 1,
	},
	['button-background'] = {
		type		 = 'texture',
		layer		 = 'BACKGROUND',
    gradient = {'VERTICAL',Colors.UI_500_GR[1],Colors.UI_500_GR[2]},
	},
	['button-outline'] = {
    type  = 'outline',
    layer = 'ARTWORK',
    color = '000000',
    alpha = .9,
	},
	['button-inline'] = {
    type = 'outline',
    layer = 'BORDER',
    gradient = {'VERTICAL','FFFFFF','FFFFFF'},
    alpha = {.07,.02},
		position	= -1,
	},
	['button-hover'] = {
		type			= 'texture',
		layer			= 'HIGHLIGHT',
		color			= 'ffffff',
		alpha			= .05,
	},
	['button-arrow'] = {
		type			= 'texture',
		layer			= 'BORDER',
    image     = {'DiesalGUIcons',{2,1,16,256,128}},
		alpha 		= .5,
		position	= {nil,-4,-5,nil},
		height		= 4,
		width			= 5,
	},
	['editBox-hover'] = {
		type			= 'texture',
		layer			= 'HIGHLIGHT',
		color			= 'ffffff',
		alpha 		= .1,
		position		= {-1,0,-1,-1},
	},
	['editBox-font'] = {
		type			= 'Font',
		color			= Colors.UI_TEXT,
	},

	['dropdown-background'] = {
		type	= 'texture',
		layer	= 'BACKGROUND',
		color	= Colors.UI_100,
    alpha = .95,
	},
	['dropdown-inline'] = {
		type			= 'outline',
		layer			= 'BORDER',
		color			= 'ffffff',
		alpha 		= .02,
		position		= -1,
	},
	['dropdown-shadow'] = {
		type			= 'shadow',
	},
}
-- ~~| ComboBox Locals |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local function compare(a,b)
	return  a.value < b.value
end
local function sortList(list,orderedKeys)
	if orderedKeys then return orderedKeys end
	local sortedList 	= {}
	local orderedKeys = {}
	for key,value in pairs(list) do
		sortedList[#sortedList + 1] = {key=key,value=value}
	end
	tsort(sortedList,compare)
	for i,value in ipairs(sortedList) do
		orderedKeys[#orderedKeys + 1] = value.key
	end

	return orderedKeys
end
-- ~~| ComboBox Methods |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local methods = {
	['OnAcquire'] = function(self)
		self:ApplySettings()
		self:SetStylesheet(Stylesheet)
		-- self:SetStylesheet(wireFrameSheet)
		self:Show()
	end,
	['OnRelease'] = function(self)	end,
	['ApplySettings'] = function(self)
		local settings 	= self.settings
		local content		= self.content
		local frame			= self.frame
		local children 	= self.children
		local dropdown		= self.dropdown

		frame:SetWidth(settings.width)
		frame:SetHeight(settings.height)

		self.editBox:SetPoint('RIGHT',-settings.buttonWidth,0)
		self.button:SetWidth(settings.buttonWidth)

		-- dropdown
		content:SetPoint("TOPLEFT",settings.dropdownPadding[1],-settings.dropdownPadding[3])
		content:SetPoint("BOTTOMRIGHT",-settings.dropdownPadding[2],settings.dropdownPadding[4])

		local menuHeight	= 0
		for i=1 , #children do
			menuHeight = menuHeight + children[i].frame:GetHeight()
		end
		dropdown:SetHeight(settings.dropdownPadding[3] + menuHeight + settings.dropdownPadding[4])

	end,
	['SetList'] = function(self,list,orderedKeys)
		self:ReleaseChildren()
		self:SetText('')
		local settings		= self.settings
		local orderedKeys = sortList(list,orderedKeys)
		settings.list 		= list

		for position, key in ipairs(orderedKeys) do
			local comboBoxItem = DiesalGUI:Create('ComboBoxItem')
			self:AddChild(comboBoxItem)
			comboBoxItem:SetParentObject(self)
			comboBoxItem:SetSettings({
				key		= key,
				value		= list[key],
				position	= position,
			},true)
		end
		self:ApplySettings()
	end,
	['SetValue'] = function(self,key)
		for i=1,#self.children do
			self.children[i]:SetSelected(false)
		end

		for i=1,#self.children do
			if self.children[i].settings.key == key then
				self.children[i]:SetSelected(true)
				self:SetText(self.children[i].settings.value)
				self.editBox:SetCursorPosition(0)
			break end
		end
	end,
	['SetText'] = function(self,text)
		self.editBox:SetText(text)
	end,
	['SetJustify'] = function(self,j)
		self.editBox:SetJustifyH(j)
	end,
	['SetFocus'] = function(self)
		DiesalGUI:SetFocus(self)
	end,
	['ClearFocus'] = function(self)
		self.dropdown:Hide()
	end,
	['ClearSelection'] = function(self)
		for i=1,#self.children do
			self.children[i]:SetSelected(false)
		end
		self:SetText('')
	end,
}
-- ~~| ComboBox Constructor |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local function Constructor()
	local self 		= DiesalGUI:CreateObjectBase(Type)
	local frame		= CreateFrame('Frame',nil,UIParent)
	self.frame		= frame
	-- ~~ Default Settings ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	self.defaults = {
		width							  = 100,
		height						  = 16,
		buttonWidth				  = 16,

    dropdownPadding     = {4,4,4,4},
    dropdownButtonWidth = 16,
	}
	-- ~~ Registered Events ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	-- OnValueSelected, OnRenameValue
	-- OnEnter, OnLeave
	-- OnButtonClick, OnButtonEnter, OnButtonLeave
	-- ~~ Construct ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	local editBox = self:CreateRegion("EditBox", 'editBox', frame)
	editBox:SetPoint("TOPLEFT")
	editBox:SetPoint("BOTTOMLEFT")
	editBox:SetAutoFocus(false)
	editBox:SetJustifyH("RIGHT")
	editBox:SetJustifyV("CENTER")
	editBox:SetTextInsets(1,2,2,0)
	editBox:SetScript('OnEnterPressed',  function(this)
		local text = this:GetText()
		DiesalGUI:ClearFocus()
		if text ~= self.settings.oldValue then self:FireEvent("OnRenameValue",self.settings.selectedKey,text) end
	end)
	editBox:HookScript('OnEscapePressed', function(this,...)
		this:SetText(self.settings.oldValue)
	end)
	editBox:HookScript('OnEditFocusGained', function(this)
		self.settings.oldValue = this:GetText()
	end)
	editBox:HookScript('OnEditFocusLost', function(this,...)
		self:SetText(self.settings.oldValue)
	end)
	editBox:SetScript("OnEnter",function(this)
		self:FireEvent("OnEnter")
	end)
	editBox:SetScript("OnLeave", function(this)
		self:FireEvent("OnLeave")
	end)

	local button = self:CreateRegion("Button", 'button', frame)
	button:SetPoint('TOPRIGHT')
	button:SetPoint('BOTTOMRIGHT')
	button:SetScript("OnEnter",function(this)
		self:FireEvent("OnButtonEnter")
	end)
	button:SetScript("OnLeave", function(this)
		self:FireEvent("OnButtonLeave")
	end)
	button:SetScript("OnClick", function(this, button)
		self:FireEvent("OnButtonClick")

		local dropdown = self.dropdown
		local visible = dropdown:IsVisible()
		DiesalGUI:OnMouse(this,button)
		dropdown[visible and "Hide" or 'Show'](dropdown)
	end)

	local dropdown = self:CreateRegion("Frame", 'dropdown', frame)
	dropdown:SetFrameStrata("FULLSCREEN_DIALOG")
	dropdown:SetPoint('TOPRIGHT',frame,'BOTTOMRIGHT',0,-2)
	dropdown:SetPoint('TOPLEFT',frame,'BOTTOMLEFT',0,-2)
	dropdown:SetScript("OnShow", function(this) self:SetFocus() end)
	dropdown:Hide()

	self:CreateRegion("Frame", 'content', 	dropdown)
	-- ~~ Methods ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	for method, func in pairs(methods) do	self[method] = func	end
	-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	return self
end
DiesalGUI:RegisterObjectConstructor(Type,Constructor,Version)
