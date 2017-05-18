-- $Id: ScrollingEditBox.lua 60 2016-11-04 01:34:23Z diesal2010 $

local DiesalGUI = LibStub('DiesalGUI-1.0')
-- ~~| Libraries |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local DiesalTools = LibStub('DiesalTools-1.0')
local DiesalStyle = LibStub("DiesalStyle-1.0")
-- ~~| Diesal Upvalues |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local Colors = DiesalStyle.Colors
local HSL, ShadeColor, TintColor = DiesalTools.HSL, DiesalTools.ShadeColor, DiesalTools.TintColor
-- ~~| Lua Upvalues |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local type, select, pairs, tonumber									= type, select, pairs, tonumber
local setmetatable, getmetatable, next								= setmetatable, getmetatable, next
local sub, format, lower, upper 										= string.sub, string.format, string.lower, string.upper
local floor, ceil, min, max, abs, modf								= math.floor, math.ceil, math.min, math.max, math.abs, math.modf
-- ~~| WoW Upvalues |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local GetCursorPosition 												= GetCursorPosition
-- ~~| ScrollingEditBox |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local Type 		= 'ScrollingEditBox'
local Version 	= 3
-- ~~| ScrollingEditBox Stylesheets |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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
		layer			= 'BACKGROUND',
		color			= 'fffc00',
	},
	['scrollFrame-orange'] = {
		type			= 'outline',
		layer			= 'BORDER',
		color			= 'ffd400',
	},
	['editBox-red'] = {
		type			= 'outline',
		layer			= 'ARTWORK',
		color			= 'ff0000',
		aplha			= .5,
	},
	['scrollBar-blue'] = {
		type			= 'outline',
		layer			= 'OVERLAY',
		color			= '00aaff',
	},
	['track-green'] = {
		type			= 'outline',
		layer			= 'OVERLAY',
		color			= '55ff00',
	},
}
-- ~~| ScrollingEditBox Locals |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-- ~~| ScrollingEditBox Methods |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local methods = {
	['OnAcquire'] = function(self)
		self:ApplySettings()
		self:SetStylesheet(Stylesheet)
		-- self:SetStylesheet(wireFrame)
		self:Show()
	end,
	['OnRelease'] = function(self) end,
	['ApplySettings'] = function(self)
		local settings		= self.settings

		self.scrollFrame:SetPoint('TOPLEFT',settings.contentPadding[1],-settings.contentPadding[3])
		self.scrollFrame:SetPoint('BOTTOMRIGHT',-settings.contentPadding[2],settings.contentPadding[4])

    self.scrollBar:SetPoint('TOPRIGHT',0,-settings.contentPadding[3] + 1)
    self.scrollBar:SetPoint('BOTTOMRIGHT',0,settings.contentPadding[4] - 1)


		self.scrollBar:SetWidth(settings.scrollBarWidth)
		self.buttonDown:SetHeight(settings.scrollBarButtonHeight)
		self.buttonUp:SetHeight(settings.scrollBarButtonHeight)

	  self.editBox:SetJustifyH(settings.justifyH)
		self.editBox:SetJustifyV(settings.justifyV)
	end,
	['ShowScrollBar'] = function(self,show)
		if show then
			self.scrollFrameContainer:SetPoint('BOTTOMRIGHT',-(self.settings.scrollBarWidth + 1),0)
			self.scrollBar:Show()
		else
			self.scrollBar:Hide()
			self.scrollFrameContainer:SetPoint('BOTTOMRIGHT',0,0)
		end
	end,
	['SetContentHeight'] = function(self,height)
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
	['SetVerticalScroll'] = function(self,scroll) -- user scrolled only
		self.settings.forceScrollBottom = DiesalTools.Round(scroll) == DiesalTools.Round(self.scrollFrame:GetVerticalScrollRange())
		self.scrollFrame:SetVerticalScroll(scroll)
	end,
	['SetText'] = function(self,txt)
		self.settings.text = txt
		self.editBox:SetText(txt or '')
	end,
}
-- ~~| ScrollingEditBox Constructor |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local function Constructor()
	local self 		= DiesalGUI:CreateObjectBase(Type)
	local frame		= CreateFrame('Frame',nil,UIParent)
	self.frame		= frame
	-- ~~ Default Settings ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	self.defaults = {
		scrollBarButtonHeight	= 1,
		scrollBarWidth				= 4,
    contentPadding        = {0,0,0,0},
		justifyH					   	= "LEFT",
		justifyV						  = "TOP",
		forceScrollBottom			= true,
	}
	-- ~~ Events ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	-- OnAcquire, OnRelease, OnHeightSet, OnWidthSet
	-- OnHide
	-- ~~ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	frame:SetScript("OnHide",function(this) self:FireEvent("OnHide") end)

	local scrollFrameContainer = self:CreateRegion("Frame", 'scrollFrameContainer', frame)
	scrollFrameContainer:SetAllPoints()
	local scrollFrame = self:CreateRegion("ScrollFrame", 'scrollFrame', scrollFrameContainer)
	scrollFrame:EnableMouseWheel(true)
	scrollFrame:SetScript("OnMouseWheel", function(this,delta)
		DiesalGUI:OnMouse(this,'MouseWheel')
		if delta > 0 then
			self:SetVerticalScroll(max( this:GetVerticalScroll() - 50, 0))
		else
			self:SetVerticalScroll(min( this:GetVerticalScroll() + 50, this:GetVerticalScrollRange()))
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
	scrollFrame:SetScript("OnScrollRangeChanged", function(this,xOffset, verticalScrollRange)
		if verticalScrollRange < 1 then -- nothing to scroll
			this:SetVerticalScroll(0)
			self:ShowScrollBar(false)
		return end

		if self.settings.forceScrollBottom then
			this:SetVerticalScroll(verticalScrollRange)
		else
			this:SetVerticalScroll(min(this:GetVerticalScroll(),verticalScrollRange))
		end
		self:ShowScrollBar(true)
		self:SetGripSize()
		self:SetScrollThumbPosition()
	end)
	scrollFrame:SetScript("OnSizeChanged", function(this,width,height)
		 self.editBox:SetWidth(width)
	end)

	local editBox = self:CreateRegion("EditBox", 'editBox', scrollFrame)
	editBox:SetPoint("TOPLEFT")
	editBox:SetPoint("TOPRIGHT")
	editBox:SetAutoFocus(false)
	editBox:SetMultiLine(true)
	editBox:HookScript('OnEditFocusLost',function(this)
		this:HighlightText(0,0)
		this:SetText(self.settings.text)
	end)
	editBox:HookScript('OnEditFocusGained',function(this)
		self:FireEvent("OnEditFocusGained")
	end)
	editBox:HookScript('OnEscapePressed',function(this)
		self:FireEvent("OnEscapePressed")
	end)
	editBox:HookScript('OnTabPressed',function(this)
		self:FireEvent("OnTabPressed")
	end)
	editBox:HookScript('OnCursorChanged',function(this,...)
		self:FireEvent("OnCursorChanged",...)
	end)
	editBox:HookScript('OnTextChanged',function(this)
		self:FireEvent("OnTextChanged")
	end)



	scrollFrame:SetScrollChild(editBox)

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
	track:SetPoint('TOP',buttonUp,'BOTTOM',0,0)
	track:SetPoint('BOTTOM',buttonDown,'TOP',0,0)
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
			self:SetVerticalScroll((newGripPosition / trackScrollAreaSize) * scrollFrame:GetVerticalScrollRange())
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
