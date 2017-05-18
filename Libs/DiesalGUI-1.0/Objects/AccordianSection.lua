local DiesalGUI = LibStub("DiesalGUI-1.0")
-- ~~| Libraries |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local DiesalTools = LibStub("DiesalTools-1.0")
local DiesalStyle = LibStub("DiesalStyle-1.0")
-- ~~| Diesal Upvalues |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local Colors = DiesalStyle.Colors
local HSL, ShadeColor, TintColor = DiesalTools.HSL, DiesalTools.ShadeColor, DiesalTools.TintColor
-- | Lua Upvalues |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- | WoW Upvalues |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- | AccordianSection |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local Type = 'AccordianSection'
local Version = 3
-- | Stylesheets |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local Stylesheet = {
	['button-background'] = {
		type			= 'texture',
		layer			= 'BACKGROUND',
    gradient	= {'VERTICAL',Colors.UI_400_GR[1],Colors.UI_400_GR[2]},
    alpha     = .95,
		position 		= {0,0,-1,0},
	},
	['button-outline'] = {
		type			= 'outline',
		layer			= 'BACKGROUND',
		color			= '000000',
		position 	= {1,1,0,1},
	},
	['button-inline'] = {
		type			= 'outline',
		layer			= 'ARTWORK',
    gradient	= {'VERTICAL','ffffff','ffffff'},
    alpha     = {.03,.02},
		position	= {0,0,-1,0},
	},
	['button-hover'] = {
		type			= 'texture',
		layer			= 'HIGHLIGHT',
		color			= 'ffffff',
		alpha			= .1,
	},
  ['button-leftExpandIcon'] = {
    type			= 'texture',
    position 	= {0,nil,-1,nil},
    height	  = 16,
    width	  	= 16,
    image     = {'DiesalGUIcons',{3,6,16,256,128},HSL(Colors.UI_Hue,Colors.UI_Saturation,.65)},
    alpha	  	= 1,
  },
  ['button-leftCollapseIcon'] = {
    type			= 'texture',
    position 	= {0,nil,-1,nil},
    height	  = 16,
    width	  	= 16,
    image     = {'DiesalGUIcons',{4,6,16,256,128},HSL(Colors.UI_Hue,Colors.UI_Saturation,.65)},
    alpha	  	= 1,
  },
	['content-background'] = {
		type			= 'texture',
		layer			= 'BACKGROUND',
		color			= Colors.UI_300,
		alpha			= .95,
		position	= {0,0,-1,0},
	},
	['content-topShadow'] = {
		type			= 'texture',
		layer			= 'ARTWORK',
    gradient	= {'VERTICAL','000000','000000'},
		alpha			= {.05,0},
		position	= {0,0,-1,nil},
		height		= 4,
	},
	['content-bottomShadow'] = {
		type			= 'texture',
		layer			= 'ARTWORK',
    gradient	= {'VERTICAL','000000','000000'},
		alpha			= {0,.05},
		position	= {0,0,nil,0},
		height		= 4,
	},
	['content-inline'] = {
		type			= 'outline',
		layer			= 'ARTWORK',
		color			= 'ffffff',
		alpha			= .02,
		position	= {0,0,-1,0},
	},
  ['text-Font'] = {
    type			= 'font',
    color     = Colors.UI_F450,
  },
}
local wireFrameSheet = {
	['frame-white'] = {
		type			= 'outline',
		layer			= 'OVERLAY',
		color			= 'ffffff',
		alpha			= 1,
	},
	['button-purple'] = {
		type			= 'outline',
		layer			= 'OVERLAY',
		color			= 'aa00ff',
		alpha			= .5,
	},
	['content-yellow'] = {
		type			= 'outline',
		layer			= 'OVERLAY',
		color			= 'fffc00',
		alpha			= .5,
	},
}
-- | Locals |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- | Methods |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local methods = {
	['OnAcquire'] = function(self)
		self:SetStylesheet(Stylesheet)
		self:Show()
	end,
	['OnRelease'] = function(self)	end,
	['ApplySettings'] = function(self)
		self.button:SetHeight(self.settings.buttonHeight)
		-- postion
		self:ClearAllPoints()
		if self.settings.position == 1 then
			self:SetPoint('TOPLEFT')
			self:SetPoint('RIGHT')
		else
			local anchor = self.settings.parentObject.children[self.settings.position-1].frame
			self:SetPoint('TOPLEFT',anchor,'BOTTOMLEFT',0,0)
			self:SetPoint('RIGHT')
		end
		-- set section name
		self.text:SetText(self.settings.sectionName)
		-- set section state
		self[self.settings.expanded and 'Expand' or 'Collapse'](self)
		-- set button visibility
		self:SetButton(self.settings.button)
	end,
	['Collapse'] = function(self)
		if not self.settings.button then self:UpdateHeight() return end
		self.settings.expanded = false
		self:FireEvent("OnStateChange", self.settings.position, 'Collapse')
    self.textures['button-leftCollapseIcon']:SetAlpha(self.textures['button-leftCollapseIcon'].style.alpha[1])
    self.textures['button-leftExpandIcon']:SetAlpha(0)
		self.content:Hide()
		self:UpdateHeight()
	end,
	['Expand'] = function(self)
		self.settings.expanded = true
		self:FireEvent("OnStateChange", self.settings.position, 'Expand')
    self.textures['button-leftExpandIcon']:SetAlpha(self.textures['button-leftExpandIcon'].style.alpha[1])
    self.textures['button-leftCollapseIcon']:SetAlpha(0)
		self.content:Show()
		self:UpdateHeight()
	end,
	['SetButton'] = function(self,state)
		self.settings.button = state
		self.button[state and 'Show' or 'Hide'](self.button)
    if not state then
      self:Expand()
    else
      self:UpdateHeight()
    end
	end,
	['UpdateHeight'] = function(self)
		local settings, children = self.settings, self.children
		local contentHeight = 0
		self.content:SetPoint('TOPLEFT',self.frame,0,settings.button and -settings.buttonHeight or 0)

		if settings.expanded then
			contentHeight = settings.contentPadding[3] + settings.contentPadding[4]
			for i=1 , #children do contentHeight = contentHeight + children[i].frame:GetHeight() end
		end
		self.content:SetHeight(contentHeight)
		self:SetHeight((settings.button and settings.buttonHeight or 0) + contentHeight)
		self:FireEvent("OnHeightChange",contentHeight)
	end,
}
-- | Constructor |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local function Constructor()
	local self 		= DiesalGUI:CreateObjectBase(Type)
	local frame		= CreateFrame('Frame',nil,UIParent)
	self.frame		= frame
	-- ~~ Default Settings ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	self.defaults = {
		button        	=	true,
		contentPadding	= {0,0,3,1 },
		expanded				= true,
		buttonHeight		= 16,
	}
	-- ~~ Construct ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	local button = self:CreateRegion("Button", 'button', frame)
	button:SetPoint('TOPRIGHT')
	button:SetPoint('TOPLEFT')
	button:SetScript("OnClick", function(this,button)
		DiesalGUI:OnMouse(this,button)
		self[self.settings.expanded and "Collapse" or "Expand"](self)
	end)

	local text = self:CreateRegion("FontString", 'text', button)
	text:SetPoint("TOPLEFT",15,-2)
	text:SetPoint("BOTTOMRIGHT",-15,0)
	text:SetHeight(0)
	text:SetJustifyH("MIDDLE")
	text:SetJustifyH("LEFT")
	text:SetWordWrap(false)

	local content = self:CreateRegion("Frame", 'content', frame)
	content:SetPoint('TOPLEFT',frame,0,0)
	content:SetPoint('TOPRIGHT',frame,0,0)
	content:SetHeight(10)
	-- ~~ Methods ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	for method, func in pairs(methods) do	self[method] = func	end
	-- ~~ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	return self
end
DiesalGUI:RegisterObjectConstructor(Type,Constructor,Version)
