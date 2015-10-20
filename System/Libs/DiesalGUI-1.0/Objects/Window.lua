-- $Id: Window.lua 52 2014-04-08 11:52:40Z diesal@reece-tech.com $

local DiesalGUI = LibStub("DiesalGUI-1.0")
-- | Libraries |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local DiesalTools = LibStub("DiesalTools-1.0")
local DiesalStyle = LibStub("DiesalStyle-1.0")
-- | Lua Upvalues |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local type, select, pairs, tonumber			= type, select, pairs, tonumber
-- | WoW Upvalues |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- | Window |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local Type 		= "Window"
local Version 	= 14
-- ~~| StyleSheets |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local styleSheet = {
	['frame-outline'] = {
		type			= 'outline',
		layer			= 'BACKGROUND',
		color			= '000000',
		offset		= 0,
	},
	['frame-shadow'] = {
		type			= 'shadow',
	},
	['titleBar-color'] = {
		type			= 'texture',
		layer			= 'ARTWORK',		
		color			= '000000',		
		alpha			= .95,
		offset		= 0,
	},
	['titleBar-outline'] = {
		type			= 'outline',
		layer			= 'ARTWORK',
		gradient	= 'VERTICAL',
		color			= 'FFFFFF',
		alpha			= .0,
		alphaEnd	= .05,
		offset		= -1,
	},
	['titletext-Font'] = {
		type			= 'font',
		color			= 'd8d8d8',
	},
	['closeButton-icon'] = {
		type			= 'texture',
		layer			= 'ARTWORK',
		texFile		= 'DiesalGUIcons',
		texCoord		= {9,5,16,256,128},
		alpha 		= .7,
		offset		= {-2,nil,-2,nil},
		width			= 16,
		height		= 16,
	},
	['closeButton-iconHover'] = {
		type			= 'texture',
		layer			= 'HIGHLIGHT',
		texFile		= 'DiesalGUIcons',
		texCoord		= {9,5,16,256,128},
		texColor		= 'b30000',
		alpha			= 1,
		offset		= {-2,nil,-2,nil},
		width			= 16,
		height		= 16,
	},
	
	['header-background'] = {
		type			= 'texture',
		layer			= 'BACKGROUND',
		color			= '333740',
		alpha			= .95,
		offset 		= {0,0,0,-1},
	},
	['header-gloss'] = {
		type			= 'texture',
		layer			= 'ARTWORK',
		gradient	= 'VERTICAL',
		color			= 'FFFFFF',
		alpha			= 0,
		alphaEnd	= .05,
		offset		= {0,0,0,-1},
	},
	['header-inline'] = {
		type			= 'outline',
		layer			= 'ARTWORK',
		color			= 'FFFFFF',
		alpha			= .04,
		offset		= {0,0,0,-1},
	},
	['header-divider'] = {
		type			= 'texture',
		layer			= 'BACKGROUND',
		color			= '000000',
		alpha 		= 1,
		offset		= {0,0,nil,0},
		height		= 1,
	},	
	['content-background'] = {
		type			= 'texture',
		layer			= 'BACKGROUND',
		color			= '1b1e21',
		alpha			= .95,
		offset		= 0,

	},
	['content-outline'] = {
		type			= 'outline',
		layer			= 'BORDER',
		color			= 'FFFFFF',
		alpha			= .04,
		offset		= 0,
	},
	['footer-background'] = {			
		type			= 'texture',
		layer			= 'BACKGROUND',							
		color			= '2f353b',
		alpha			= .95,		
		offset 		= {0,0,-1,0},
	},
	['footer-divider'] = {
		type			= 'texture',
		layer			= 'BACKGROUND',
		color			= '000000',
		offset		= {0,0,0,nil},
		height		= 1,
	},	
	['footer-gloss'] = {			
		type			= 'texture',
		layer			= 'ARTWORK',		
		gradient	= 'VERTICAL',				
		color			= 'FFFFFF',		
		alpha			= 0,
		alphaEnd	= .05,		
		offset		= {0,0,-1,0}	
	},			
	['footer-inline'] = {			
		type			= 'outline',
		layer			= 'BORDER',
		gradient	= 'VERTICAL',	
		color			= 'ffffff',
		alpha 		= .03,
		alphaEnd	= .05,			
		offset		= {0,0,-1,0}	
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
-- ~~| Window Locals |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- | Methods |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local methods = {
	['OnAcquire'] = function(self)
		self:ApplySettings()
		self:AddStyleSheet(styleSheet)
		-- self:AddStyleSheet(sizerWireFrame)
		self:Show()
	end,
	['OnRelease'] = function(self)

	end,
	['SetTopLevel'] = function(self)
		DiesalGUI:SetTopLevel(self.frame)
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
		self.settings.width 	= DiesalTools:Round(width)
		self.settings.height	= DiesalTools:Round(height)

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

		self.settings.top 		= DiesalTools:Round(frame:GetTop())
		self.settings.left	 	= DiesalTools:Round(frame:GetLeft())

		self:UpdatePosition()
		self:FireEvent( "OnDragStop", self.settings.left, self.settings.top )
	end)
	local closeButton = self:CreateRegion("Button", 'closeButton', titleBar)
	closeButton:SetPoint("TOPRIGHT", 0, 0)
	closeButton:SetScript("OnClick", function(this,button)
		DiesalGUI:OnMouse(this,button)
		PlaySound("gsTitleOptionExit")
		self:FireEvent("OnClose")
		self:Hide()
	end)
	local titletext = self:CreateRegion("FontString", 'titletext', titleBar)
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
