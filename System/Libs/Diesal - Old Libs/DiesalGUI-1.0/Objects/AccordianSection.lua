local DiesalGUI = LibStub("DiesalGUI-1.0")
-- ~~| Libraries |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local DiesalTools = LibStub("DiesalTools-1.0")
local DiesalStyle = LibStub("DiesalStyle-1.0")
-- | Lua Upvalues |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- | WoW Upvalues |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- | AccordianSection |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local Type = 'AccordianSectionBR'
local Version = 2
-- | StyleSheets |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local styleSheet = {	
	['button-background'] = {			
		type			= 'texture',
		layer			= 'BACKGROUND',							
		color			= '333740',
		alpha			= .95,		
		offset 		= {0,0,-1,0},		
	},	
	['button-outline'] = {			
		type			= 'outline',
		layer			= 'BACKGROUND',							
		color			= '000000',		
		offset 		= {1,1,0,1},		
	},
	['button-gloss'] = {			
		type			= 'texture',
		layer			= 'ARTWORK',		
		gradient	= 'VERTICAL',				
		color			= 'FFFFFF',		
		alpha			= 0,
		alphaEnd	= .05,		
		offset		= {0,0,-1,0},	
	},			
	['button-inline'] = {			
		type			= 'outline',
		layer			= 'ARTWORK',					
		color			= 'FFFFFF',		
		gradient	= 'VERTICAL',		
		alpha			= 0,
		alphaEnd	= .09,				
		offset		= {0,0,-1,-8},		
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
		color			= '1b1e21',		
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
		alpha			= .03,	
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
	end,	
	['Collapse'] = function(self)		
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
	['UpdateHeight'] = function(self)
		local settings, children = self.settings, self.children
		local contentHeight = 0

		if settings.expanded and #children > 0 then
			contentHeight = settings.contentPad[3] + settings.contentPad[4]		
			--for i=1 , #children do contentHeight = contentHeight + children[i].frame:GetHeight() end
            if #children ~= 1 then
                local addBecauseOfToggle = 0
                if children[#children].type == "Toggle" then
                    addBecauseOfToggle = 15
                end
                contentHeight = contentHeight + (select(5,children[#children-1].frame:GetPoint())*-1) + 10 + addBecauseOfToggle
            elseif #children == 1 then
             contentHeight = contentHeight + (select(5,children[#children].frame:GetPoint())*-1) + 10
            end

		end
		self.content:SetHeight(contentHeight)
		self:SetHeight(settings.buttonHeight + contentHeight)		
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
		contentPad	= {0,0,3,2},				
		expanded		= true,
		buttonHeight= 17,
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
    button:SetScript('OnEnter', function(this)
        self:FireEvent("OnEnter")
    end)
    button:SetScript('OnLeave', function(this)
        self:FireEvent("OnLeave")
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

	local content = self:CreateRegion("Frame", 'content', button)
	content:SetPoint('TOPLEFT',button,'BOTTOMLEFT',0,0)
	content:SetPoint('TOPRIGHT',button,'BOTTOMRIGHT',0,0)
	content:SetHeight(10)
	-- ~~ Methods ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	for method, func in pairs(methods) do	self[method] = func	end
	-- ~~ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	return self
end
DiesalGUI:RegisterObjectConstructor(Type,Constructor,Version)
