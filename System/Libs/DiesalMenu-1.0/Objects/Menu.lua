-- $Id: Menu.lua 52 2014-04-08 11:52:40Z diesal@reece-tech.com $
local DiesalMenu 	= LibStub('DiesalMenu-1.0')
-- ~~| Libraries |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local DiesalGUI = LibStub('DiesalGUI-1.0')
local DiesalTools = LibStub('DiesalTools-1.0')
-- | Lua Upvalues |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local ipairs, pairs, table_sort = ipairs, pairs, table.sort 
-- | WoW Upvalues |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- | Menu |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local Type 		= 'Menu'
local Version = 2
-- | StyleSheets |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local styleSheet = {
	['frame-background'] = {
		type			= 'texture',
		layer			= 'BACKGROUND',
		color			= '000000',
	},
	['frame-inline'] = {
		type			= 'outline',
		layer			= 'BORDER',
		color			= 'ffffff',
		gradient		= 'VERTICAL',
		alpha 		= .1,
		alphaEnd 	= .1,
		offset		= -1,
	},
	['frame-highlight'] = {
		type			= 'texture',
		layer			= 'BORDER',
		color			= 'ffffff',
		gradient		= 'VERTICAL',
		alpha 		= .02,
		alphaEnd		= .07,
		offset		= -1,
		height		= 10,
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
		self:AddStyleSheet(styleSheet)
		-- self:AddStyleSheet(wireFrame)
	end,
	['OnRelease'] = function(self)

	end,
	['ApplySettings'] = function(self)
		local settings 	= self.settings
		local content		= self.content

		content:SetPoint("TOPLEFT",settings.padding[1],-settings.padding[3])
		content:SetPoint("BOTTOMRIGHT",-settings.padding[2],settings.padding[4])

		if settings.menuData then
			self:BuildMenu()
			local children 	= self.children
			local menuHeight	= 0
			for i=1 , #children do
				menuHeight = menuHeight + children[i].frame:GetHeight()
			end
			self.frame:SetHeight(settings.padding[3] + menuHeight + settings.padding[4])
			self.frame:SetWidth(settings.padding[1] + settings.itemWidth + settings.padding[2])
		end
	end,
	['BuildMenu'] = function(self)
		self:ReleaseChildren()
		self:SetWidth(1)
		local menuData = self.settings.menuData
		local settings	= self.settings
		-- set settings
		for key in pairs(menuData) do
			if menuData[key].check then settings.check = true end
			if menuData[key].menuData then settings.arrow = true end
		end
		-- create menuItems
		local sortedTable = sortTable(menuData)
		for i = 1, #sortedTable do
			local menuItem = DiesalGUI:Create('MenuItem')
			self:AddChild(menuItem)
			menuItem:SetParentObject(self)
			menuItem:SetSettings({
				itemData			= menuData[sortedTable[i][2]],
				position			= i,
			},true)			
		end		
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
	-- ~~ Registered Events ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

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