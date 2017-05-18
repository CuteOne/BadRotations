-- $Id: MenuItem.lua 60 2016-11-04 01:34:23Z diesal2010 $
local DiesalMenu 	= LibStub('DiesalMenu-1.0')
-- ~~| Libraries |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local DiesalTools = LibStub('DiesalTools-1.0')
local DiesalStyle = LibStub("DiesalStyle-1.0")
local DiesalGUI 	= LibStub('DiesalGUI-1.0')
local DiesalStyle = LibStub("DiesalStyle-1.0")
-- ~~| Diesal Upvalues |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local Colors = DiesalStyle.Colors
local HSL, ShadeColor, TintColor = DiesalTools.HSL, DiesalTools.ShadeColor, DiesalTools.TintColor
-- | Lua Upvalues |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- | WoW Upvalues |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- | MenuItem |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local Type 			= 'MenuItem'
local Version 	= 2
-- | Stylesheets |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local Stylesheet = {
	['frame-hover'] = {
		type			= 'texture',
		layer			= 'HIGHLIGHT',
		color			= Colors.UI_1000,
		alpha			= .1,
	},
	['text-color'] = {
		type			= 'Font',
		color			= 'cbcbcb',
	},
}
-- | Locals |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-- | Methods |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local methods = {
	['OnAcquire'] = function(self)
		self:ApplySettings()
		self:SetStylesheet(Stylesheet)
		-- self:SetStylesheet(wireFrame)
		self:Show()
	end,
	['OnRelease'] = function(self)

	end,
	['ApplySettings'] = function(self)
		if not self.settings.itemData then return false end

		local settings 		= self.settings
		local menuSettings= settings.parentObject.settings
		local itemData		= settings.itemData
		local text 				= self.text
		local check				= self.check
		local arrow				= self.arrow

		local checkWidth 		= menuSettings.check and settings.checkWidth or settings.textPadLeft
		local arrowWidth 		= menuSettings.arrow	and settings.arrowWidth or settings.textPadRight
		local textWidthMax 	= settings.widthMax - arrowWidth - checkWidth

		if settings.position == 1 then
			self:SetPoint('TOPLEFT')
			self:SetPoint('RIGHT')
		else
			self:SetPoint('TOPLEFT',settings.parentObject.children[settings.position-1].frame,'BOTTOMLEFT',0,0)
			self:SetPoint('RIGHT')
		end

		if itemData.type == 'spacer' then
			self.frame:EnableMouse(false)
			self:SetHeight(settings.spacerHeight)
		else
			self.frame:EnableMouse(true)
			self:SetHeight(settings.height)
		end

		self:SetText(itemData.name)
		text:SetPoint("LEFT",checkWidth, 0)
		text:SetPoint("RIGHT",-arrowWidth, 0)

		arrow[menuSettings.arrow and itemData.menuData and "Show" or "Hide"](arrow)
		check[menuSettings.check and itemData.check and itemData.check() and "Show" or "Hide"](check)

		local textWidth = DiesalTools.Round(text:GetStringWidth()) + 10
		local itemWidth = checkWidth + textWidth + arrowWidth

		menuSettings.itemWidth = min(max(menuSettings.itemWidth,itemWidth),settings.widthMax)
	end,
	['SetText'] = function(self,text)
		self.text:SetText(text or '')
	end,
	['OnClick'] = function(self)
		local onClick = self.settings.itemData.onClick
		if onClick then onClick() end
	end,
	['OnEnter'] = function(self)
		DiesalMenu:StopCloseTimer()
		local menuChildren = self.settings.parentObject.children
		local menuData = self.settings.itemData.menuData
		for i=1, #menuChildren do menuChildren[i]:ReleaseChildren()	end
		self:BuildSubMenu(menuData)
	end,
	['BuildSubMenu'] = function(self,menuData)
		if not menuData then return end
		local subMenu = DiesalGUI:Create('Menu')
		if not subMenu:BuildMenu(menuData) then DiesalGUI:Release(subMenu) return end
		self:AddChild(subMenu)
		subMenu:SetParent(self.frame)
		subMenu:ClearAllPoints()
		subMenu:SetPoint('TOPLEFT',self.frame,'TOPRIGHT',0,0)
		subMenu:Show()
	end,
}
-- | Constructor |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local function Constructor()
	local self 		= DiesalGUI:CreateObjectBase(Type)
	local frame		= CreateFrame('Button',nil,UIParent)
	self.frame		= frame
	-- ~~ Default Settings ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	self.defaults = {
		widthMax			= 250,
		height				= 16,
		spacerHeight	= 5,
		checkWidth 		= 14,
		arrowWidth 		= 14,
		textPadLeft		= 2,
		textPadRight	= 2,
	}
	-- ~~ Events ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	-- OnAcquire, OnRelease, OnHeightSet, OnWidthSet
	-- ~~ Construct ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	frame:SetScript("OnClick", function(this,button) DiesalGUI:OnMouse(this,button); self:OnClick() end)
	frame:SetScript('OnEnter', function(this) self:OnEnter() end)
	frame:SetScript('OnLeave', function(this) DiesalMenu:StartCloseTimer() end)

	local text = self:CreateRegion("FontString", 'text', frame)
	text:SetPoint("TOP",0,-2)
	text:SetPoint("BOTTOM",0,0)
	text:SetJustifyH("TOP")
	text:SetJustifyH("LEFT")
	text:SetWordWrap(false)

	local check = self:CreateRegion("Texture", 'check', frame)
	DiesalStyle:StyleTexture(check,{
		position 	= {1,nil,0,nil},
		height	= 16,
		width		= 16,
    image    = {'DiesalGUIcons', {10,5,16,256,128},'FFFF00'},
	})
	local arrow = self:CreateRegion("Texture", 'arrow', frame)
	DiesalStyle:StyleTexture(arrow,{
		position = {nil,2,-1,nil},
		height	 = 16,
		width		 = 16,
    image    = {'DiesalGUIcons', {7,5,16,256,128},'FFFF00'},
	})
	-- ~~ Methods ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	for method, func in pairs(methods) do	self[method] = func	end
	-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	return self
end
DiesalGUI:RegisterObjectConstructor(Type,Constructor,Version)
