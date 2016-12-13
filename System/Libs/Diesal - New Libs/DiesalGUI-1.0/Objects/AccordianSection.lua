local DiesalGUI = LibStub("DiesalGUI-1.0")
-- ~~| Libraries |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local DiesalTools = LibStub("DiesalTools-1.0")
local DiesalStyle = LibStub("DiesalStyle-1.0")
-- | Lua Upvalues |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- | WoW Upvalues |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- | AccordianSection |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local Type = 'AccordianSection'
local Version = 2
-- | StyleSheets |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local styleSheet = {	
	['button-background'] = {			
		type			= 'texture',
		layer			= 'BACKGROUND',							
		color			= '232f38',
		colorEnd	= '2d3c47',
		gradient	= 'VERTICAL',		
		alpha			= .95,		
		offset 		= {0,0,-1,0},		
	},
	
		
	['button-outline'] = {			
		type			= 'outline',
		layer			= 'BACKGROUND',							
		color			= '000000',		
		offset 		= {1,1,0,1},		
	},
			
	['button-inline'] = {			
		type			= 'outline',
		layer			= 'ARTWORK',					
		color			= 'FFFFFF',		
		gradient	= 'VERTICAL',		
		alpha			= .02,
		alphaEnd	= .07,				
		offset		= {0,0,-1,0},		
	},	
	['button-hover'] = {
		type			= 'texture',
		layer			= 'HIGHLIGHT',
		color			= 'ffffff',
		alpha			= .1,
	},
	['content-background'] = {
		type			= 'texture',
		layer			= 'BACKGROUND',				
		color			= '182228',		
		alpha			= .95,	
		offset		= {0,0,-1,0},			
	},		
	['content-top'] = {
		type			= 'texture',
		layer			= 'ARTWORK',		
		color			= '000000',
		gradient	= 'VERTICAL',		
		alpha			= 0,
		alphaEnd	= .3,
		offset		= {0,0,-1,nil},	
		height		= 4,
	},
	['content-bottom'] = {
		type			= 'texture',
		layer			= 'ARTWORK',		
		color			= '000000',
		gradient	= 'VERTICAL',		
		alpha			= .3,
		alphaEnd	= 0,			
		offset		= {0,0,nil,0},	
		height		= 4,
	},
	['content-inline'] = {
		type			= 'outline',
		layer			= 'ARTWORK',				
		color			= 'ffffff',		
		alpha			= .02,	
		offset		= {0,0,-1,0},			
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
		self:AddStyleSheet(styleSheet)
		self:Show()
	end,
	['OnRelease'] = function(self)

	end,
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
		self:SetButtonVisbility(self.settings.buttonVisbility)
	end,	
	['Collapse'] = function(self)	
		if not self.settings.collapsable then	self:UpdateHeight()	return end 	
		self.settings.expanded = false
		self:FireEvent("OnStateChange", self.settings.position, 'Collapse') 		
		self.arrow:SetTexCoord(DiesalTools:GetIconCoords(7,5,16,256,128))
		self.content:Hide()
		self:UpdateHeight()
	end,
	['Expand'] = function(self)		
		self.settings.expanded = true
		self:FireEvent("OnStateChange", self.settings.position, 'Expand') 		
		self.arrow:SetTexCoord(DiesalTools:GetIconCoords(5,5,16,256,128))
		self.content:Show()
		self:UpdateHeight()
	end,	
	['SetButtonVisbility'] = function(self,state)			
		self.settings.buttonVisbility = state
		self.button[state and 'Show' or 'Hide'](self.button)
		self:UpdateHeight()
	end,	
	['UpdateHeight'] = function(self)
		local settings, children = self.settings, self.children
		local contentHeight = 0
		self.content:SetPoint('TOPLEFT',self.frame,0,settings.buttonVisbility and settings.buttonHeight *-1 or 0)
		
		if settings.expanded then
			contentHeight = settings.contentPad[3] + settings.contentPad[4]		
			for i=1 , #children do contentHeight = contentHeight + children[i].frame:GetHeight() end			
		end
		self.content:SetHeight(contentHeight)
		self:SetHeight((settings.buttonVisbility and settings.buttonHeight or 0) + contentHeight)		
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
		collapsable		 	=	true,
		buttonVisbility	=	true,
		contentPad			= {0,0,3,2},				
		expanded				= true,
		buttonHeight		= 17,
	}
	-- ~~ Events ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	-- OnAcquire, OnRelease, OnHeightSet, OnWidthSet
	-- ~~ Construct ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

	local button = self:CreateRegion("Button", 'button', frame)
	button:SetPoint('TOPRIGHT')
	button:SetPoint('TOPLEFT')	
	button:SetScript("OnClick", function(this,button)
		DiesalGUI:OnMouse(this,button)
		self[self.settings.expanded and "Collapse" or "Expand"](self)			
	end)
	local arrow = self:CreateRegion("Texture", 'arrow', button)
	DiesalStyle:StyleTexture(arrow,{
		offset 	= {1,nil,-1,nil},
		height	= 16,
		width		= 16,
		texFile	= 'DiesalGUIcons',
		alpha		= .7,
	})
	local text = self:CreateRegion("FontString", 'text', button)
	text:SetPoint("TOPLEFT",13,-5)
	text:SetPoint("RIGHT",-4,0)
	text:SetHeight(0)
	text:SetJustifyH("TOP")
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
