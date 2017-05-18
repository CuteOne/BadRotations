-- $Id: ScrollFrame.lua 60 2016-11-04 01:34:23Z diesal2010 $

local DiesalGUI = LibStub("DiesalGUI-1.0")
-- ~~| Libraries |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local DiesalTools = LibStub("DiesalTools-1.0")
local DiesalStyle = LibStub("DiesalStyle-1.0")
-- ~~| Diesal Upvalues |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local Colors = DiesalStyle.Colors
local HSL, ShadeColor, TintColor = DiesalTools.HSL, DiesalTools.ShadeColor, DiesalTools.TintColor
-- ~~| Lua Upvalues |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local type, select, pairs, tonumber									= type, select, pairs, tonumber
local setmetatable, getmetatable, next								= setmetatable, getmetatable, next
local sub, format, lower, upper 										= string.sub, string.format, string.lower, string.upper
local floor, ceil, min, max, abs, modf								= math.floor, math.ceil, math.min, math.max, math.abs, math.modf
-- ~~| WoW Upvalues |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local GetCursorPosition 												= GetCursorPosition
-- ~~| ScrollFrame |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local Type 		= 'ScrollFrame'
local Version 	= 3
-- ~~| ScrollFrame Stylesheets |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local Stylesheet = {
	['track-background'] = {
		type		= 'texture',
		layer		= 'BACKGROUND',
		color		= '000000',
    alpha   = .3,
	},
	['grip-background'] = {
		type			= 'texture',
		layer			= 'BACKGROUND',
    color			= Colors.UI_400,
	},
  ['grip-inline'] = {
    type = 'outline',
    layer = 'BORDER',
    color = 'FFFFFF',
    alpha = .02,
  },
}
local wireFrame = {
	['frame-white'] = {
		type			= 'outline',
		layer			= 'OVERLAY',
		color			= 'ffffff',
	},
	['scrollFrameContainer-yellow'] = {
		type			= 'outline',
		layer			= 'OVERLAY',
		color			= 'ffff00',
	},
	['scrollFrame-orange'] = {
		type			= 'outline',
		layer			= 'OVERLAY',
		color			= 'ff7f00',
	},
	['scrollBar-blue'] = {
		type			= 'outline',
		layer			= 'OVERLAY',
		color			= '0080ff',
	},
	['track-green'] = {
		type			= 'outline',
		layer			= 'OVERLAY',
		color			= '00ff00',
	},
  ['grip-purple'] = {
		type			= 'outline',
		layer			= 'OVERLAY',
		color			= 'a800ff',
	},
}
-- ~~| ScrollFrame Locals |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local internal
-- ~~| ScrollFrame Methods |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local methods = {
	['OnAcquire'] = function(self)
		self:ApplySettings()
		self:SetStylesheet(Stylesheet)
    --self:SetStylesheet(wireFrame)
		self:Show()
	end,
	['OnRelease'] = function(self)
	end,
	['ApplySettings'] = function(self)
		local settings		= self.settings
		local scrollFrame	= self.scrollFrame

		scrollFrame:SetPoint('TOPLEFT',settings.contentPadding[1],-settings.contentPadding[3])
		scrollFrame:SetPoint('BOTTOMRIGHT',-settings.contentPadding[2],settings.contentPadding[4])

		self.scrollBar:SetWidth(settings.scrollBarWidth)
    self.scrollBar:SetPoint('TOPRIGHT',-settings.scrollBarPadding[2],-settings.scrollBarPadding[3])
  	self.scrollBar:SetPoint('BOTTOMRIGHT',-settings.scrollBarPadding[2],settings.scrollBarPadding[4])

    if settings.scrollBarButtons then
      self.track:SetPoint('TOP',0,-settings.scrollBarButtonHeight)
    	self.track:SetPoint('BOTTOM',0,settings.scrollBarButtonHeight)

      self.buttonDown:SetHeight(settings.scrollBarButtonHeight)
  		self.buttonUp:SetHeight(settings.scrollBarButtonHeight)
      self.buttonUp:Show()
      self.buttonDown:Show()
    else
      self.track:SetPoint('TOP',0,0)
    	self.track:SetPoint('BOTTOM',0,0)

      self.buttonUp:Hide()
      self.buttonDown:Hide()
    end
		self.content:SetHeight(settings.contentHeight)
	end,
	['SetContentHeight'] = function(self,height)
		height = height < 1 and 1 or height -- height of 0 wont hide scrollbar
		self.settings.contentHeight = height
		self.content:SetHeight(height)
	end,
	['SetGripSize'] = function(self)
		local contentSize 			= self.scrollFrame:GetVerticalScrollRange() + self.scrollFrame:GetHeight()
		local windowSize 				= self.scrollFrame:GetHeight()
		local trackSize 				= self.track:GetHeight()
		local windowContentRatio 	= windowSize / contentSize
		local gripSize 				= DiesalTools.Round(trackSize * windowContentRatio)

		gripSize = max(gripSize, 10) -- might give this a setting?
		gripSize = min(gripSize, trackSize)

		self.grip:SetHeight(gripSize)
	end,
	['SetScrollThumbPosition'] = function(self)
		local verticalScrollRange 	= self.scrollFrame:GetVerticalScrollRange() -- windowScrollAreaSize (rounded no need to round)
		if verticalScrollRange < 1 then	self.grip:SetPoint('TOP',0,0) return end
		local verticalScroll 		= self.scrollFrame:GetVerticalScroll() -- windowPosition
		local trackSize 				= self.track:GetHeight()
		local gripSize 				= self.grip:GetHeight()

		local windowPositionRatio 	= verticalScroll / verticalScrollRange
		local trackScrollAreaSize 	= trackSize - gripSize
		local gripPositionOnTrack 	= DiesalTools.Round(trackScrollAreaSize * windowPositionRatio)

		self.grip:SetPoint('TOP',0,-gripPositionOnTrack)
	end,
	['ShowScrollBar'] = function(self,show)
		if show then
			self.scrollFrameContainer:SetPoint('BOTTOMRIGHT',-(self.settings.scrollBarWidth + self.settings.scrollBarPadding[1] + self.settings.scrollBarPadding[2]),0)
			self.scrollBar:Show()
		else
			self.scrollBar:Hide()
			self.scrollFrameContainer:SetPoint('BOTTOMRIGHT',0,0)
		end
	end,
	['ScrollToBottom'] = function(self)
		local scrollRange = self.scrollFrame:GetVerticalScrollRange()
		if scrollRange > 0 and scrollRange ~= self.scrollFrame:GetVerticalScroll() then
			self.scrollFrame:SetVerticalScroll(scrollRange)
		end
	end,
	['SetVerticalScroll'] = function(self,num)
		self.scrollFrame:SetVerticalScroll(num)
	end,
	['GetVerticalScroll'] = function(self)
		return self.scrollFrame:GetVerticalScroll()
	end,
	['GetVerticalScrollRange'] = function(self)
		return self.scrollFrame:GetVerticalScrollRange()
	end,
	['VerticallyScroll'] = function(self,num)
		if num < 0 then
			self.scrollFrame:SetVerticalScroll(max( self.scrollFrame:GetVerticalScroll() + num, 0))
		else
			self.scrollFrame:SetVerticalScroll(min( self.scrollFrame:GetVerticalScroll() + num, self.scrollFrame:GetVerticalScrollRange()))
		end
	end,
}
-- ~~| ScrollFrame Constructor |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local function Constructor()
	local self 		= DiesalGUI:CreateObjectBase(Type)
	local frame		= CreateFrame('Frame',nil,UIParent)
	self.frame		= frame
	-- ~~ Default Settings ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	self.defaults = {
		height 						    = 300,
		width 						    = 500,
		scrollBarButtonHeight	= 4,
		scrollBarWidth				= 4,
    scrollBarButtons      = false,
    scrollBarPadding      = {0,0,0,0},
    contentPadding        = {0,0,0,0},
		contentHeight				  = 1,
	}
	-- ~~ Events ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	-- OnAcquire, OnRelease, OnHeightSet, OnWidthSet
	-- OnHide
	-- ~~ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	frame:SetScript("OnHide",function(this)
		self:FireEvent("OnHide")
	end)

	local scrollFrameContainer = self:CreateRegion("Frame", 'scrollFrameContainer', frame)
	scrollFrameContainer:SetAllPoints()
	local scrollFrame = self:CreateRegion("ScrollFrame", 'scrollFrame', scrollFrameContainer)
	scrollFrame:EnableMouseWheel(true)
	scrollFrame:SetScript("OnMouseWheel", function(this,delta)
		DiesalGUI:OnMouse(this,'MouseWheel')
		if delta > 0 then
			self:VerticallyScroll(-25)
		else
			self:VerticallyScroll(25)
		end
	end)
	scrollFrame:SetScript("OnVerticalScroll", function(this,offset)
		-- self.scrollFrame:GetVerticalScrollRange() windowScrollAreaSize
		if this:GetVerticalScrollRange() < 1 then	-- nothing to scroll
			self:ShowScrollBar(false)
		else
			self:ShowScrollBar(true)
		end
		self:SetScrollThumbPosition()
	end)
	scrollFrame:SetScript("OnScrollRangeChanged", function(this,horizontalScrollRange, verticalScrollRange)
		if verticalScrollRange < 1 then -- nothing to scroll
			this:SetVerticalScroll(0)
			self:ShowScrollBar(false)
		return end
		this:SetVerticalScroll(min(this:GetVerticalScroll(),verticalScrollRange))
		self:ShowScrollBar(true)
		self:SetGripSize()
		self:SetScrollThumbPosition()
	end)
	scrollFrame:SetScript("OnSizeChanged", function(this,width,height)
		self.content:SetWidth(width)
	end)
	scrollFrame:SetScrollChild(self:CreateRegion("Frame", 'content', scrollFrame))
	scrollFrame:RegisterForDrag("LeftButton")
	scrollFrame:SetScript( "OnDragStart", function(this,...)
		self:FireEvent("OnDragStart",...)
	end)

	local scrollBar = self:CreateRegion("Frame", 'scrollBar', frame)
	scrollBar:Hide()
	local buttonUp = self:CreateRegion("Frame", 'buttonUp', scrollBar)
	buttonUp:SetPoint('TOPLEFT')
	buttonUp:SetPoint('TOPRIGHT')
	local buttonDown = self:CreateRegion("Frame", 'buttonDown', scrollBar)
	buttonDown:SetPoint('BOTTOMLEFT')
	buttonDown:SetPoint('BOTTOMRIGHT')
	local track = self:CreateRegion("Frame", 'track', scrollBar)
	track:SetPoint('LEFT')
	track:SetPoint('RIGHT')
	local grip = self:CreateRegion("Frame", 'grip', track)
	grip:SetPoint('LEFT')
	grip:SetPoint('RIGHT')
	grip:SetPoint('TOP')
	grip:EnableMouse(true)
	grip:SetScript("OnMouseDown", function(this,button)
		DiesalGUI:OnMouse(this,button)
		if button ~= 'LeftButton' then return end
		local MouseY = select(2, GetCursorPosition()) / this:GetEffectiveScale()
		local effectiveScale = this:GetEffectiveScale()
		local trackScrollAreaSize = track:GetHeight() - this:GetHeight()
		local gripPositionOnTrack = abs(select(5,this:GetPoint(1)))

		this:SetScript("OnUpdate", function(this)
			local newGripPosition = gripPositionOnTrack + (MouseY - (select(2, GetCursorPosition()) / effectiveScale ))
			newGripPosition = min(max(newGripPosition,0),trackScrollAreaSize)
			-- local newGripPositionRatio = newGripPosition / trackScrollAreaSize
			-- local windowPosition = newGripPositionRatio * scrollArea:GetVerticalScrollRange()
			scrollFrame:SetVerticalScroll((newGripPosition / trackScrollAreaSize) * scrollFrame:GetVerticalScrollRange())
		end)
	end)
	grip:SetScript("OnMouseUp", function(this,button)
		this:SetScript("OnUpdate", function(this)	end)
	end)
	-- ~~ Methods ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	for method, func in pairs(methods) do	self[method] = func	end
	-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	return self
end

DiesalGUI:RegisterObjectConstructor(Type,Constructor,Version)
