-- $Id: DropDown.lua 60 2016-11-04 01:34:23Z diesal2010 $

local DiesalGUI = LibStub('DiesalGUI-1.0')
-- ~~| Libraries |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local DiesalTools = LibStub('DiesalTools-1.0')
local DiesalStyle = LibStub("DiesalStyle-1.0")
-- ~~| Diesal Upvalues |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local Colors = DiesalStyle.Colors
local HSL, ShadeColor, TintColor = DiesalTools.HSL, DiesalTools.ShadeColor, DiesalTools.TintColor
-- ~~| Lua Upvalues |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local tsort																	= table.sort
local sub, format, lower, upper,gsub				= string.sub, string.format, string.lower, string.upper, string.gsub

-- ~~| WoW Upvalues |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-- ~~| Dropdown |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local Type 		= 'Dropdown'
local Version 	= 2
-- ~~| Dropdown Stylesheets |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local Stylesheet = {
  ['frame-background'] = {
    type = 'texture',
    layer = 'BACKGROUND',
    gradient = {'VERTICAL',Colors.UI_400_GR[1],Colors.UI_400_GR[2]},
  },
  ['frame-outline'] = {
		type			= 'outline',
		layer			= 'BORDER',
		color			= '000000',
	},
	['frame-inline'] = {
		type			= 'outline',
		layer			= 'BORDER',
    gradient  = {'VERTICAL','FFFFFF','FFFFFF'},
    alpha     = {.07,.02},
		position	= -1,
	},
	['frame-hover'] = {
    type			= 'texture',
		layer			= 'HIGHLIGHT',
		color			= 'ffffff',
		alpha			= .05,
	},
	['frame-arrow'] = {
    type			= 'texture',
		layer			= 'BORDER',
    image     = {'DiesalGUIcons',{2,1,16,256,128}},
		alpha 		= .5,
		position	= {nil,-5,-7,nil},
		height		= 3,
		width			= 5,
	},
	['text-color'] = {
		type			= 'Font',
    color			= Colors.UI_TEXT,
	},
  ['dropdown-background'] = {
		type	    = 'texture',
		layer	    = 'BACKGROUND',
		color   	= Colors.UI_100,
    alpha     = .95,
	},
	['dropdown-inline'] = {
		type			= 'outline',
		layer			= 'BORDER',
		color			= 'ffffff',
		alpha 		= .02,
		position	= -1,
	},
	['dropdown-shadow'] = {
		type			= 'shadow',
	},
}
-- ~~| Dropdown Locals |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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
-- ~~| Dropdown Methods |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local methods = {
	['OnAcquire'] = function(self)
		self:ApplySettings()
		self:SetStylesheet(Stylesheet)
		-- self:SetStylesheet(wireFrameSheet)
		self:Show()
	end,
	['OnRelease'] = function(self)

	end,
	['ApplySettings'] = function(self)
		local settings 	= self.settings
		local content		= self.content
		local frame			= self.frame
		local children 	= self.children
		local dropdown		= self.dropdown

		frame:SetWidth(settings.width)
		frame:SetHeight(settings.height)

		content:SetPoint("TOPLEFT",settings.dropdownPadLeft,-settings.dropdownPadTop)
		content:SetPoint("BOTTOMRIGHT",-settings.dropdownPadRight,settings.dropdownPadBottom)

		local menuHeight	= 0
		for i=1 , #children do
			menuHeight = menuHeight + children[i].frame:GetHeight()
		end
		dropdown:SetHeight(settings.dropdownPadTop + menuHeight + settings.dropdownPadBottom)

	end,
	['SetList'] = function(self,list,orderedKeys)
		self:ReleaseChildren()
		self:SetText('')
		local settings		= self.settings
		local orderedKeys = sortList(list,orderedKeys)
		settings.list 		= list

		for position, key in ipairs(orderedKeys) do
			local dropdownItem = DiesalGUI:Create('DropdownItem')
			self:AddChild(dropdownItem)
			dropdownItem:SetParentObject(self)
			dropdownItem:SetSettings({
				key	= key,
				value	= list[key],
				position = position,
			},true)
		end
		self:ApplySettings()
	end,
	['SetValue'] = function(self,key)
		local selectionTable = {}
		local selectedKey, dropdownText, selectedValue

		if key ~='CLEAR' then
			if self.settings.multiSelect then
				for i=1,#self.children do
					if self.children[i].settings.key == key then	selectedKey = key; self.children[i]:SetSelected(true) end
					if self.children[i].settings.selected then
						if dropdownText then
							dropdownText = format('%s, %s',dropdownText,self.children[i].settings.value)
						else
							dropdownText = self.children[i].settings.value
						end
						selectionTable[#selectionTable+1] = self.children[i].settings.key
					end
				end
			else
				for i=1,#self.children do
					self.children[i]:SetSelected(false)
					if self.children[i].settings.key == key then
						self.children[i]:SetSelected(true)
						dropdownText = self.children[i].settings.value
						selectionTable = {key}
						selectedKey	= key
						selectedValue	= value
					end
				end
			end
		else
			self:ClearSelection()
		end
		if selectedKey then
			self:SetText(dropdownText)
			self:FireEvent("OnValueChanged",selectedKey,selectedValue,selectionTable)
		else
			self:SetText('')
			self:FireEvent("OnValueChanged",selectedKey,selectedValue,selectionTable)
		end
	end,
	['ClearSelection'] = function(self)
		for i=1,#self.children do
			self.children[i]:SetSelected(false)
		end
		self:SetText('')
	end,
	['SetValueTable'] = function(self,keyTable)
		if not self.settings.multiSelect or type(keyTable) ~='table' then return end
		local dropdownItems = self.children
		local selectionTable = {}
		local selectedKey
		local dropdownText

		for i=1,#dropdownItems do
			local dropdownItem = dropdownItems[i]
			dropdownItem:SetSelected(false)
			for _,key in ipairs(keyTable) do

				if dropdownItem.settings.key == key then
					dropdownItem:SetSelected(true)
					if dropdownText then
						dropdownText = format('%s, %s',dropdownText,dropdownItem.settings.value)
					else
						dropdownText = dropdownItem.settings.value
					end
					selectionTable[#selectionTable+1] = dropdownItem.settings.key
				end
			end
		end
		self:FireEvent("OnValueChanged",nil,nil,selectionTable)
		self:SetText(dropdownText)
	end,
	['SetMultiSelect'] = function(self,state)
		self.settings.multiSelect = state
	end,
	['SetText'] = function(self,text)
		self.text:SetText(text)
		for i=1, #self.children do
			if self.children[i].settings.value==text then self.value = self.children[i].settings.key end
		end
	end,
	['SetFocus'] = function(self)
		DiesalGUI:SetFocus(self)
	end,
	['ClearFocus'] = function(self)
		self.dropdown:Hide()
	end,
	['EnableMouse'] = function(self,state)
		self.frame:EnableMouse(state)
	end,
	["RegisterForClicks"] = function(self,...)
		self.frame:RegisterForClicks(...)
	end,
	['SetJustifyV'] = function(self,justify)
		self.text:SetJustifyV(justify)
	end,
	['SetJustifyH'] = function(self,justify)
		self.text:SetJustifyH(justify)
	end,
}
-- ~~| Dropdown Constructor |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local function Constructor()
	local self 		= DiesalGUI:CreateObjectBase(Type)
	local frame		= CreateFrame('Button',nil,UIParent)
	self.frame		= frame
	self.defaults = {
		dropdownPadLeft		= 4,
		dropdownPadRight	= 4,
		dropdownPadTop		= 4,
		dropdownPadBottom	= 4,
		itemHeight				= 16,
		width							= 100,
		height						= 16,
	}
	-- ~~ Registered Events ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	-- OnValueChanged(event,selectedKey,selectedValue,selectionTable)
	-- OnValueSelected(event,selectedKey,selectedValue,selectionTable)
	-- OnEnter, OnLeave
	-- ~~ Construct ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	frame:SetScript("OnMouseUp", function(this, button)
		if button == 'LeftButton' then
			local dropdown = self.dropdown
			local visible = dropdown:IsVisible()
			DiesalGUI:OnMouse(this,button)
			dropdown[visible and "Hide" or 'Show'](dropdown)
		end
	end)
	frame:SetScript("OnClick", function(this, ...)
		self:FireEvent("OnClick", ...)
	end)
	frame:SetScript("OnEnter",function(this,...)
		self:FireEvent("OnEnter",...)
	end)
	frame:SetScript("OnLeave", function(this,...)
		self:FireEvent("OnLeave",...)
	end)

	local text = self:CreateRegion("FontString", 'text', frame)
	text:ClearAllPoints()
	text:SetPoint("TOPLEFT", 4, -1)
	text:SetPoint("BOTTOMRIGHT", -14, 1)
	text:SetJustifyV("MIDDLE")
	text:SetJustifyH("LEFT")

	local dropdown = self:CreateRegion("Frame", 'dropdown', frame)
	dropdown:SetFrameStrata("FULLSCREEN_DIALOG")
	dropdown:SetPoint('TOPRIGHT',frame,'BOTTOMRIGHT',0,-2)
	dropdown:SetPoint('TOPLEFT',frame,'BOTTOMLEFT',0,-2)
	dropdown:SetScript("OnShow", function(this) self:SetFocus() end)
	dropdown:Hide()

	self:CreateRegion("Frame", 'content',	dropdown)
	-- ~~ Methods ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	for method, func in pairs(methods) do	self[method] = func	end
	-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	return self
end
DiesalGUI:RegisterObjectConstructor(Type,Constructor,Version)
