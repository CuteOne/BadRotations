-- $Id: Branch.lua 60 2016-11-04 01:34:23Z diesal2010 $
-- ~~| Libraries |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local DiesalTools = LibStub('DiesalTools-1.0')
local DiesalStyle = LibStub('DiesalStyle-1.0')
local DiesalGUI 	= LibStub('DiesalGUI-1.0')
-- ~~| Lua Upvalues |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local sub, format, match, lower			= string.sub, string.format, string.match, string.lower
local tsort													= table.sort
local tostring											= tostring
-- ~~| WoW Upvalues |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-- ~~| TableExplorerBranch |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local Type 		= 'Branch'
local Version 	= 1
-- ~~| Stylesheets |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local Stylesheet = {
	['button-highlight'] = {
		type			= 'texture',
		layer			= 'HIGHLIGHT',
		color			= 'ffffff',
		alpha			= .1,
	},
	['button-selected'] = {
		type			= 'texture',
		layer			= 'BORDER',
		color			= '0059b3',
		alpha			= 0,
	},
}
local wireFrameSheet = {
	['frame-white'] = {
		type			= 'outline',
		layer			= 'OVERLAY',
		color			= 'ffffff',
	},
	['button-purple'] = {
		type			= 'outline',
		layer			= 'OVERLAY',
		color			= 'aa00ff',
	},
	['content-yellow'] = {
		type			= 'outline',
		layer			= 'OVERLAY',
		color			= 'fffc00',
	},
}
-- ~~| Methods |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local methods = {
	['OnAcquire'] = function(self)
		self:ApplySettings()
		self:SetStylesheet(Stylesheet)
		self:Show()
	end,
	['OnRelease'] = function(self)

	end,
	['ApplySettings'] = function(self)
		if not self.settings.position then return false end

		local button			= self.button
		local content			= self.content

		button:SetHeight(self.settings.buttonHeight)

		if not self.settings.leaf then
			self[self.settings.expanded and "Expand" or "Collapse"](self)
		else
			self:UpdateLines()
			self:UpdateHeight()
		end

		self:ClearAllPoints()
		if self.settings.position == 1 then
			self:SetPoint('TOPLEFT',self.settings.indent,0)
			self:SetPoint('RIGHT')
		else
			local anchor = self.settings.parentObject.children[self.settings.position-1].frame
			self:SetPoint('TOPLEFT',anchor,'BOTTOMLEFT',0,0)
			self:SetPoint('RIGHT')
		end
	end,
	['Collapse'] = function(self)
		if self.settings.leaf then return end
		self:FireEvent("OnStateChange",false)
		self.settings.expanded = false
		self:SetIconCollapsed()
		self:UpdateLines()
		self.content:Hide()
		self:UpdateHeight()
	end,
	['Expand'] = function(self)
		if self.settings.leaf then return end
		self:FireEvent("OnStateChange",true)
		self.settings.expanded = true
		self:SetIconExpanded()
		self:UpdateLines()
		self.content:Show()
		self:UpdateHeight()
	end,
	['UpdateHeight'] = function(self)
		local contentHeight = 0
		local settings = self.settings
		local children = self.children

		if settings.expanded then
			for i=1 , #children do
				contentHeight = contentHeight + children[i].frame:GetHeight()
			end
		end
		self.content:SetHeight(contentHeight)
		self:SetHeight(settings.buttonHeight + contentHeight)
		settings.parentObject:UpdateHeight()
	end,
	['SetLabel'] = function(self,text)
		self.text:SetText(text)
	end,
	['SetIconTexture'] = function(self,texture)
		self.icon:SetTexture(texture)
	end,
	['SetIconCoords'] = function(self,left,right,top,bottom)
		self.icon:SetTexCoord(left,right,top,bottom)
	end,
	['SetIconExpanded']	= function(self)
		self.icon:SetTexCoord(DiesalTools.GetIconCoords(2,8,16,256,128))
	end,
	['SetIconCollapsed'] = function(self)
		self.icon:SetTexCoord(DiesalTools.GetIconCoords(1,8,16,256,128))
	end,
	['SetSelected'] = function(self,state)
		self:UpdateStyle('button-selected',{
			type			= 'texture',
			alpha			= state and 1 or 0,
		})
	end,
	['UpdateLines'] = function(self)
		if not self.settings.branches then return end
		local foldColor	= '353535'
		local expandColor	= '5a5a5a'
		-- Frame Fold Line
		if not self.settings.last and not self.settings.leaf then
			self:UpdateStyle('frame-foldLine',{
				type			= 'texture',
				layer			= 'OVERLAY',
				color			= foldColor,
				position		= {6,nil,-11,2},
				width			= 1,
			})
		end
		-- expandable Fold Lines
		if not self.settings.leaf then
			self:UpdateStyle('button-square',{
				type			= 'outline',
				layer			= 'BORDER',
				color			= foldColor,
				position	= {10,nil,-2,nil},
				width			= 9,
				height		= 9,
			})
			self:UpdateStyle('button-expandH',{
				type			= 'texture',
				layer			= 'BORDER',
				color			= expandColor,
				position		= {8,nil,-6,nil},
				width			= 5,
				height		= 1,
			})
			self:UpdateStyle('button-expandV',{
					type			= 'texture',
					layer			= 'BORDER',
					color			= expandColor,
					position		= {6,nil,-4,nil},
					width			= 1,
					height		= 5,
					alpha			= 1,
			})
			if self.settings.expanded then
				self:UpdateStyle('button-expandV',{
					type			= 'texture',
					alpha			= 0,
				})
			end
		else -- Leaf nodes
			self:UpdateStyle('button-lineV',{
				type			= 'texture',
				layer			= 'BORDER',
				color			= foldColor,
				position		= {6,nil,-6,nil},
				height		= 1,
				width			= 6,
			})
			self:UpdateStyle('button-lineH',{
				type			= 'texture',
				layer			= 'BORDER',
				color			= foldColor,
				position		= {6,nil,0,0},
				width			= 1,
			})
			if self.settings.last then
				self:UpdateStyle('button-lineH',{
					type			= 'texture',
					position		= {6,nil,0,-7},
				})
			end
		end
	end,
}
-- ~~| TableExplorerBranch Constructor |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local function Constructor()
	local self 		= DiesalGUI:CreateObjectBase(Type)
	local frame		= CreateFrame('Frame',nil,UIParent)
	self.frame		= frame
	-- ~~ Default Settings ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	self.defaults = {
		fontObject		= DiesalFontNormal,
		branches			= true,
		expanded			= true,
		buttonHeight 	= 14,
		indent				= 13,
		expIconTex		= 'DiesalGUIcons',
		colIconTex		= 'DiesalGUIcons',
		expIconCoords = {DiesalTools.GetIconCoords(2,8,16,256,128)},
		colIconCoords = {DiesalTools.GetIconCoords(1,8,16,256,128)},
	}
	-- ~~ Events ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	-- OnAcquire, OnRelease, OnHeightSet, OnWidthSet
	-- ~~ Construct ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	local button = self:CreateRegion("Button", 'button', frame)
	button:SetPoint('TOPRIGHT')
	button:SetPoint('TOPLEFT')
	button:RegisterForClicks('RightButtonUp','LeftButtonUp')
	button:RegisterForDrag( "LeftButton" )
	button:SetScript("OnClick", function(this,button)
		DiesalGUI:OnMouse(this,button)
		if button == 'LeftButton' then self[not self.settings.expanded and "Expand" or "Collapse"](self) end
		self:FireEvent("OnClick",button)
	end)
	button:SetScript( "OnDoubleClick", function(this,...)
		self:FireEvent("OnDoubleClick",...)
	end)
	button:SetScript( "OnDragStart", function(this,...)
		self:FireEvent("OnDragStart",...)
	end)
	button:SetScript( "OnDragStop", function(this,...)
		self:FireEvent("OnDragStop",...)
	end)
	button:SetScript("OnEnter",function(this,...)
		self:FireEvent("OnEnter",...)
	end)
	button:SetScript("OnLeave", function(this,...)
		self:FireEvent("OnLeave",...)
	end)


	local icon = self:CreateRegion("Texture", 'icon', button)
	DiesalStyle:StyleTexture(icon,{
		position 	= {0,nil,2,nil},
		height	= 16,
		width		= 16,
		image	  = {'DiesalGUIcons'},
	})

	local text = self:CreateRegion("FontString", 'text', button)
	text:SetPoint("TOPLEFT",14,-1)
	text:SetPoint("BOTTOMRIGHT",-4,0)
	text:SetHeight(0)
	text:SetJustifyH("TOP")
	text:SetJustifyH("LEFT")
	text:SetWordWrap(false)

	local content = self:CreateRegion("Frame", 'content', button)
	content:SetPoint('TOPLEFT',button,'BOTTOMLEFT',0,0)
	content:SetPoint('TOPRIGHT')
	content:SetHeight(0)
	-- ~~ Methods ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	for method, func in pairs(methods) do	self[method] = func	end
	-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	return self
end
DiesalGUI:RegisterObjectConstructor(Type,Constructor,Version)
