-- $Id: Menu.lua 60 2016-11-04 01:34:23Z diesal2010 $
local DiesalMenu 	= LibStub('DiesalMenu-1.0')
-- ~~| Libraries |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local DiesalGUI = LibStub('DiesalGUI-1.0')
local DiesalTools = LibStub('DiesalTools-1.0')
local DiesalStyle = LibStub("DiesalStyle-1.0")
-- ~~| Diesal Upvalues |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local Colors = DiesalStyle.Colors
local HSL, ShadeColor, TintColor = DiesalTools.HSL, DiesalTools.ShadeColor, DiesalTools.TintColor
-- | Lua Upvalues |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local ipairs, pairs, table_sort = ipairs, pairs, table.sort
-- | WoW Upvalues |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- | Menu |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local Type 		= 'Menu'
local Version = 2
-- | Stylesheets |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local Stylesheet = {
	['frame-background'] = {
    type	    = 'texture',
		layer	    = 'BACKGROUND',
		color   	= Colors.UI_100,
    alpha     = .95,
	},
	['frame-inline'] = {
    type			= 'outline',
		layer			= 'BORDER',
		color			= 'ffffff',
		alpha 		= .02,
		position	= -1,
	},
	['frame-shadow'] = {
		type			= 'shadow',
	},
}
local wireFrame = {
	['frame-white'] = {
		type			= 'outline',
		layer			= 'OVERLAY',
		color			= 'ffffff',
	},
	['content-yellow'] = {
		type			= 'outline',
		layer			= 'OVERLAY',
		color			= 'fffc00',
	},
}
-- | Locals |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local function compare(a,b)
  return a[1] < b[1]
end
local function sortTable(t)
  local st = {}
  for key, val in pairs(t) do
    st[#st + 1] = {val.order, key}
  end
  table_sort(st,compare)
  return st
end
-- | Methods |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local methods = {
	['OnAcquire'] = function(self)
		self.frame:SetFrameStrata("FULLSCREEN_DIALOG")
		self:ApplySettings()
		self:SetStylesheet(Stylesheet)
		-- self:SetStylesheet(wireFrame)
	end,
	['OnRelease'] = function(self)

	end,
	['ApplySettings'] = function(self)
		self:UpdatePosition()
	end,
	['UpdatePosition'] = function(self)
		self.content:SetPoint("TOPLEFT",self.settings.padding[1],-self.settings.padding[3])
		self.content:SetPoint("BOTTOMRIGHT",-self.settings.padding[2],self.settings.padding[4])
	end,
	['UpdateSize'] = function(self)
		local menuHeight = 0
		for i=1, #self.children do
			menuHeight = menuHeight + self.children[i].frame:GetHeight()
		end
		self.frame:SetHeight(self.settings.padding[3] + menuHeight + self.settings.padding[4])
		self.frame:SetWidth(self.settings.padding[1] + self.settings.itemWidth + self.settings.padding[2])
	end,
	['BuildMenu'] = function(self, menuData)
		if menuData	then self.settings.menuData = menuData else menuData = self.settings.menuData end
		if not menuData then return end
		-- reset menu
		self:ReleaseChildren()
		self:SetWidth(1)
		-- set menu properties
		for key in pairs(menuData) do
			if menuData[key].check then self.settings.check = true end
			if menuData[key].menuData then self.settings.arrow = true end
		end
		-- create menuItems
		local sortedTable = sortTable(menuData)
		for i = 1, #sortedTable do
			local menuItem = DiesalGUI:Create('MenuItem')
			self:AddChild(menuItem)
			menuItem:SetParentObject(self)
			menuItem:SetSettings({
				itemData = menuData[sortedTable[i][2]],
				position = i,
			},true)
		end

		self:UpdateSize()
		return true
	end,
}
-- | Constructor |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local function Constructor()
	local self 		= DiesalGUI:CreateObjectBase(Type)
	local frame		= CreateFrame('Frame',nil,UIParent)
	self.frame		= frame
	self.defaults = {
		itemWidth	= 0,
		padding		= {4,4,8,8},
	}
	-- ~~ Construct ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	frame:SetClampedToScreen( true )
	frame:SetScript('OnEnter', function(this) DiesalMenu:StopCloseTimer() end)
	frame:SetScript('OnLeave', function(this) DiesalMenu:StartCloseTimer() end)

	self:CreateRegion("Frame", 'content', 	frame)
	-- ~~ Methods ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	for method, func in pairs(methods) do	self[method] = func	end
	-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	return self
end
DiesalGUI:RegisterObjectConstructor(Type,Constructor,Version)
