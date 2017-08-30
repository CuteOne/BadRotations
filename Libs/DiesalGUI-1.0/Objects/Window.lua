-- $Id: Window.lua 60 2016-11-04 01:34:23Z diesal2010 $

local DiesalGUI = LibStub("DiesalGUI-1.0")
-- | Libraries |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local DiesalTools = LibStub("DiesalTools-1.0")
local DiesalStyle = LibStub("DiesalStyle-1.0")
local Colors = DiesalStyle.Colors
-- | Lua Upvalues |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local type, select, pairs, tonumber			= type, select, pairs, tonumber
local floor, ceil = math.floor, math.ceil
-- | WoW Upvalues |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- | Window |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local Type 		= "Window"
local Version 	= 14
-- ~~| Stylesheets |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local Stylesheet = {
	['frame-outline'] = {
		type			= 'outline',
		layer			= 'BACKGROUND',
		color			= '000000',
	},
	['frame-shadow'] = {
		type			= 'shadow',
	},
	['titleBar-color'] = {
		type			= 'texture',
		layer			= 'BACKGROUND',
		color			= '000000',
		alpha			= .95,
	},
	['titletext-Font'] = {
		type			= 'font',
		color			= 'd8d8d8',
	},
	['closeButton-icon'] = {
		type			= 'texture',
		layer			= 'ARTWORK',
    image     = {'DiesalGUIcons', {9,5,16,256,128}},
		alpha 		= .3,
		position	= {-2,nil,-1,nil},
		width			= 16,
		height		= 16,
	},
	['closeButton-iconHover'] = {
		type			= 'texture',
		layer			= 'HIGHLIGHT',
    image     = {'DiesalGUIcons', {9,5,16,256,128}, 'b30000'},
		alpha			= 1,
		position	= {-2,nil,-1,nil},
		width			= 16,
		height		= 16,
	},
	['header-background'] = {
		type			= 'texture',
		layer			= 'BACKGROUND',
    gradient	= {'VERTICAL',Colors.UI_400_GR[1],Colors.UI_400_GR[2]},
    alpha     = .95,
		position 	= {0,0,0,-1},
	},
	['header-inline'] = {
		type			= 'outline',
		layer			= 'BORDER',
    gradient	= {'VERTICAL','ffffff','ffffff'},
    alpha     = {.05,.02},
		position	= {0,0,0,-1},
	},
	['header-divider'] = {
		type			= 'texture',
		layer			= 'BORDER',
		color			= '000000',
		alpha 		= 1,
		position	= {0,0,nil,0},
		height		= 1,
	},
	['content-background'] = {
		type			= 'texture',
		layer			= 'BACKGROUND',
		color			= Colors.UI_100,
		alpha			= .95,
	},
	['content-outline'] = {
		type			= 'outline',
		layer			= 'BORDER',
		color			= 'FFFFFF',
		alpha			= .01
	},
	['footer-background'] = {
		type			= 'texture',
		layer			= 'BACKGROUND',
    gradient	= {'VERTICAL',Colors.UI_400_GR[1],Colors.UI_400_GR[2]},
    alpha     = .95,
		position 	= {0,0,-1,0},
	},
	['footer-divider'] = {
		type			= 'texture',
		layer			= 'BACKGROUND',
		color			= '000000',
		position	= {0,0,0,nil},
		height		= 1,
	},
	['footer-inline'] = {
		type			= 'outline',
		layer			= 'BORDER',
    gradient	= {'VERTICAL','ffffff','ffffff'},
    alpha     = {.05,.02},
		position	= {0,0,-1,0},
    debug = true,
	},
}
local wireFrame = {
	['frame-white'] = {
		type			= 'outline',
		layer			= 'OVERLAY',
		color			= 'ffffff',
	},
	['titleBar-yellow'] = {
		type			= 'outline',
		layer			= 'OVERLAY',
		color			= 'fffc00',
	},
	['closeButton-orange'] = {
		type			= 'outline',
		layer			= 'OVERLAY',
		color			= 'ffd400',
	},
	['header-blue'] = {
		type			= 'outline',
		layer			= 'OVERLAY',
		color			= '00aaff',
	},
	['footer-green'] = {
		type			= 'outline',
		layer			= 'OVERLAY',
		color			= '55ff00',
	},

}
local sizerWireFrame = {
	['sizerR-yellow'] = {
		type			= 'outline',
		layer			= 'OVERLAY',
		color			= 'fffc00',
	},
	['sizerB-green'] = {
		type			= 'outline',
		layer			= 'OVERLAY',
		color			= '55ff00',
	},
	['sizerBR-blue'] = {
		type			= 'outline',
		layer			= 'OVERLAY',
		color			= '00aaff',
	},
}
-- | Window Locals |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local function round(num)
  if num >= 0 then return floor(num+.5)
  else return ceil(num-.5) end
end

-- | Methods |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local methods = {
	['OnAcquire'] = function(self)
		self:ApplySettings()
		self:SetStylesheet(Stylesheet)
		-- self:SetStylesheet(sizerWireFrame)
		self:Show()
	end,
	['OnRelease'] = function(self)	end,
	['SetTopLevel'] = function(self)
		DiesalGUI:SetTopLevel(self.frame)
	end,
  ['SetContentHeight'] = function(self, height)
    local contentHeight = round(self.content:GetHeight())
		self.frame:SetHeight( (self.settings.height - contentHeight) + height )
	end,
	['ApplySettings'] = function(self)
		local settings			= self.settings
		local frame 				= self.frame
		local titleBar			= self.titleBar
		local closeButton		= self.closeButton
		local header				= self.header
		local content				= self.content
		local footer				= self.footer

		local headerHeight 	= settings.header and settings.headerHeight or 0
		local footerHeight 	= settings.footer and settings.footerHeight or 0

		frame:SetMinResize(settings.minWidth,settings.minHeight)
		frame:SetMaxResize(settings.maxWidth,settings.maxHeight)

		self:UpdatePosition()
		self:UpdateSizers()

		titleBar:SetHeight(settings.titleBarHeight)
		closeButton:SetHeight(settings.titleBarHeight)
		closeButton:SetWidth(settings.titleBarHeight)

		content:SetPoint("TOPLEFT",settings.padding[1],-(settings.titleBarHeight + headerHeight))
		content:SetPoint("BOTTOMRIGHT",-settings.padding[2],footerHeight + settings.padding[4])
		header:SetHeight(headerHeight)
		footer:SetHeight(footerHeight)
		header[settings.header and "Show" or "Hide"](header)
		footer[settings.footer and "Show" or "Hide"](footer)

		header:SetPoint("TOPLEFT",self.titleBar,"BOTTOMLEFT",settings.padding[1],0)
		header:SetPoint("TOPRIGHT",self.titleBar,"BOTTOMRIGHT",-settings.padding[2],0)

		footer:SetPoint("BOTTOMLEFT",settings.padding[1],settings.padding[4])
		footer:SetPoint("BOTTOMRIGHT",-settings.padding[2],settings.padding[4])

	end,
	['UpdatePosition'] = function(self)
		self.frame:ClearAllPoints()
		if self.settings.top and self.settings.left then
			self.frame:SetPoint("TOP",UIParent,"BOTTOM",0,self.settings.top)
			self.frame:SetPoint("LEFT",UIParent,"LEFT",self.settings.left,0)
		else
			self.frame:SetPoint("CENTER",UIParent,"CENTER")
		end

		self.frame:SetWidth(self.settings.width)
		self.frame:SetHeight(self.settings.height)
	end,
	['UpdateSizers'] = function(self)
		local settings = self.settings

		local frame		= self.frame
		local sizerB	= self.sizerB
		local sizerR	= self.sizerR
		local sizerBR	= self.sizerBR

		sizerBR[settings.sizerBR and "Show" or "Hide"](sizerBR)
		sizerBR:SetSize(settings.sizerBRWidth,settings.sizerBRHeight)
		sizerB[settings.sizerB and "Show" or "Hide"](sizerB)
		sizerB:SetHeight(settings.sizerHeight)
		sizerB:SetPoint("BOTTOMRIGHT",frame,"BOTTOMRIGHT",-settings.sizerBRWidth,0)
		sizerR[settings.sizerR and "Show" or "Hide"](sizerR)
		sizerR:SetWidth(settings.sizerWidth)
		sizerR:SetPoint("TOPRIGHT",frame,"TOPRIGHT",0,-settings.titleBarHeight)
		sizerR:SetPoint("BOTTOMRIGHT",frame,"BOTTOMRIGHT",0,settings.sizerBRHeight)
	end,
	['SetTitle'] = function(self,title,subtitle)
		local settings = self.settings
		settings.title		= title 		or settings.title
		settings.subTitle	= subtitle 	or settings.subTitle
		self.titletext:SetText(('%s |cff7f7f7f%s'):format(settings.title,settings.subTitle))
	end,
}
-- | Constructor |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local function Constructor()
	local self 		= DiesalGUI:CreateObjectBase(Type)
	local frame		= CreateFrame('Frame',nil,UIParent)
	self.frame		= frame
	self.defaults = {
		height 				= 300,
		width 				= 500,
		minHeight 		= 200,
		minWidth 			= 200,
		maxHeight 		= 9999,
		maxWidth 			= 9999,
		left					= nil,
		top						= nil,
		titleBarHeight= 18,
		title					= '',
		subTitle			= '',
		padding				= {1,1,0,1},
		header				= false,
		headerHeight	= 21,
		footer				= false,
		footerHeight	= 21,
		sizerR				= true,
		sizerB				= true,
		sizerBR				= true,
		sizerWidth		= 6,
		sizerHeight		= 6,
		sizerBRHeight	= 6,
		sizerBRWidth	= 6,
	}
	-- ~~ Events ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	-- OnAcquire, OnRelease, OnHeightSet, OnWidthSet
	-- OnSizeChanged, OnDragStop, OnHide, OnShow, OnClose
	-- ~~ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	frame:EnableMouse()
	frame:SetMovable(true)
	frame:SetResizable(true)
	frame:SetScript("OnMouseDown", function(this,button)
		DiesalGUI:OnMouse(this,button)
	end)
	frame:SetScript("OnSizeChanged", function(this,width,height)
		self.settings.width 	= DiesalTools.Round(width)
		self.settings.height	= DiesalTools.Round(height)

		self:FireEvent( "OnSizeChanged", self.settings.width, self.settings.height )
	end)
	frame:SetScript("OnHide",function(this)
		self:FireEvent("OnHide")
	end)
	frame:SetScript("OnShow",function(this)
		self:FireEvent("OnShow")
	end)
	frame:SetToplevel(true)
	frame.obj = self
	local titleBar = self:CreateRegion("Button", 'titleBar', frame)
	titleBar:SetPoint("TOPLEFT")
	titleBar:SetPoint("TOPRIGHT")
	titleBar:EnableMouse()
	titleBar:SetScript("OnMouseDown",function(this,button)
		DiesalGUI:OnMouse(this,button)
		frame:StartMoving()
	end)
	titleBar:SetScript("OnMouseUp", function(this)
		frame:StopMovingOrSizing()

		self.settings.top 		= DiesalTools.Round(frame:GetTop())
		self.settings.left	 	= DiesalTools.Round(frame:GetLeft())

		self:UpdatePosition()
		self:FireEvent( "OnDragStop", self.settings.left, self.settings.top )
	end)
	local closeButton = self:CreateRegion("Button", 'closeButton', titleBar)
	closeButton:SetPoint("TOPRIGHT", -1, 1)
	closeButton:SetScript("OnClick", function(this,button)
		DiesalGUI:OnMouse(this,button)
		PlaySound(799)
		self:FireEvent("OnClose")
		self:Hide()
	end)
	local titletext = self:CreateRegion("FontString", 'titletext', titleBar)
	titletext:SetWordWrap(false)
	titletext:SetPoint("TOPLEFT", 4, -5)
	titletext:SetPoint("TOPRIGHT", -20, -5)
	titletext:SetJustifyH("TOP")
	titletext:SetJustifyH("LEFT")

	self:CreateRegion("Frame", 'header', 	frame)
	self:CreateRegion("Frame", 'content', 	frame)
	self:CreateRegion("Frame", 'footer', 	frame)

	local sizerBR = self:CreateRegion("Frame", 'sizerBR', frame)
	sizerBR:SetPoint("BOTTOMRIGHT",frame,"BOTTOMRIGHT",0,0)
	sizerBR:EnableMouse()
	sizerBR:SetScript("OnMouseDown",function(this,button)
		DiesalGUI:OnMouse(this,button)
		frame:StartSizing("BOTTOMRIGHT")
	end)
	sizerBR:SetScript("OnMouseUp", function(this)
		frame:StopMovingOrSizing()
		self:UpdatePosition()
		self:FireEvent( "OnSizeStop", self.settings.width, self.settings.height )
	end)
	local sizerB = self:CreateRegion("Frame", 'sizerB', frame)
	sizerB:SetPoint("BOTTOMLEFT",frame,"BOTTOMLEFT",0,0)
	sizerB:EnableMouse()
	sizerB:SetScript("OnMouseDown",function(this,button)
		DiesalGUI:OnMouse(this,button)
		frame:StartSizing("BOTTOM")
	end)
	sizerB:SetScript("OnMouseUp", function(this)
		frame:StopMovingOrSizing()
		self:UpdatePosition()
		self:FireEvent( "OnSizeStop", self.settings.width, self.settings.height )
	end)
	local sizerR = self:CreateRegion("Frame", 'sizerR', frame)
	sizerR:EnableMouse()
	sizerR:SetScript("OnMouseDown",function(this,button)
		DiesalGUI:OnMouse(this,button)
		frame:StartSizing("RIGHT")
	end)
	sizerR:SetScript("OnMouseUp", function(this)
		frame:StopMovingOrSizing()
		self:UpdatePosition()
		self:FireEvent( "OnSizeStop", self.settings.width, self.settings.height )
	end)
	-- ~~ Methods ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	for method, func in pairs(methods) do	self[method] = func	end
	-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	return self
end
DiesalGUI:RegisterObjectConstructor(Type,Constructor,Version)
