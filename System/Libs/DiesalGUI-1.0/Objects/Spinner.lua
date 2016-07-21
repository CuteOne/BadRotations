 -- $Id: Spinner.lua 52 2014-04-08 11:52:40Z diesal@reece-tech.com $
local DiesalGUI = LibStub("DiesalGUI-1.0")
-- | Libraries |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local DiesalTools = LibStub("DiesalTools-1.0")
local DiesalStyle = LibStub("DiesalStyle-1.0")
-- | Lua Upvalues |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local type, tonumber, select 		= type, tonumber, select 	
local pairs, ipairs, next				= pairs, ipairs, next
local min, max					 				= math.min, math.max	
-- | WoW Upvalues |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- | Spinner |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local Type = "Spinner"
local Version = 3
-- | StyleSheets |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local styleSheet = {                                                              
	['frame-background'] = {	
		type			= 'texture',
		layer			= 'BACKGROUND',
		color			= '000000',
		offset		= 0,		
	},
	['editBox-highlight'] = {
		type			= 'texture',
		layer			= 'BORDER',
		gradient	= 'VERTICAL',
		color			= 'ffffff',
		alpha 		= .06,
		alphaEnd	= .12,
		offset		= {-1,-1,-1,-8},
	},	
	['editBox-outline'] = {		
		type			= 'outline',
		layer			= 'BORDER',	
		color			= '000000',
		offset		= 0,		
	},	
	['editBox-inline'] = {		
		type			= 'outline',
		layer			= 'BORDER',
		gradient	= 'VERTICAL',	
		color			= 'ffffff',
		alpha 		= .03,
		alphaEnd	= .07,
		offset		= -1,	
	},	
	['editBox-hover'] = {		
		type			= 'outline',
		layer			= 'HIGHLIGHT',
		color			= 'ffffff',
		alpha 		= .1,	
		offset		= -1,	
	},	
	['editBox-font'] = {
		type			= 'Font',
		color			= 'cfdee5',
	},
	['bar-background'] = {			
		type			= 'texture',
		layer			= 'BORDER',								
		color			= '003366',			
	},
	['bar-highlight'] = {
		type			= 'texture',
		layer			= 'ARTWORK',
		gradient	= 'VERTICAL',
		color			= 'ffffff',
		alpha 		= .06,
		alphaEnd	= .12,
		offset		= {0,0,0,-7},
	},
	['bar-outline'] = {			
		type			= 'outline',
		layer			= 'ARTWORK',
		gradient	= 'VERTICAL',
		color			= 'ffffff',	
		alpha 		= .02,
		alphaEnd	= .07,			
	},	
}
local wireFrame = {
	['frame-white'] = {			
		type			= 'outline',
		layer			= 'OVERLAY',						
		color			= 'ffffff',			
	},
	['editBox-purple'] = {			
		type			= 'outline',
		layer			= 'OVERLAY',						
		color			= 'aa00ff',			
	},
	['buttonUp-yellow'] = {			
		type			= 'outline',
		layer			= 'OVERLAY',						
		color			= 'fffc00',			
	},
	['buttonDown-orange'] = {			
		type			= 'outline',
		layer			= 'OVERLAY',						
		color			= 'ffd400',			
	},
	['bar-green'] = {			
		type			= 'outline',
		layer			= 'OVERLAY',						
		color			= '55ff00',			
	},	
}
-- | Methods |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local methods = {		
	['OnAcquire'] = function(self)
		self:AddStyleSheet(styleSheet)			
		self:ApplySettings()
		
		-- self:AddStyleSheet(wireFrame)				
		self:Show()		
	end,
	['OnRelease'] = function(self)	
				
	end,	
	['ApplySettings'] = function(self)		
		local settings 			= self.settings
		local frame					= self.frame
		local buttonUp			= self.buttonUp		
		local buttonDown		= self.buttonDown
		local editBox				= self.editBox
		local buttonsWidth 	= settings.buttons and settings.buttonsWidth or 0 
		local buttonHeight	= DiesalTools:Round(settings.height / 2)
		-- Update Settings
		settings.barWidth		= settings.width - buttonsWidth - 2 -- bar Texture padding
		-- Apply Settings
		self:SetWidth(settings.width)
		self:SetHeight(settings.height)
		
		editBox:EnableMouse(settings.mouse)		
		editBox:EnableMouseWheel(settings.mouseWheel)	
		editBox:SetPoint('BOTTOMRIGHT',-buttonsWidth,0)	
		
		buttonUp[settings.buttons and "Show" or "Hide"](buttonUp)					
		buttonUp:EnableMouse(settings.mouse)
		buttonUp:SetHeight(buttonHeight)
		buttonUp:SetWidth(buttonsWidth)
		buttonDown[settings.buttons and "Show" or "Hide"](buttonDown)	
		buttonDown:EnableMouse(settings.mouse)
		buttonDown:SetHeight(buttonHeight)
		buttonDown:SetWidth(buttonsWidth)
		
		self:UpdateBar()
	end,	
	['EnableMouse'] = function(self,enable)
		self.settings.mouse = enable						
		self.buttonUp:EnableMouse(enable)
		self.buttonDown:EnableMouse(enable)		
		self.editBox:EnableMouse(enable)
		self.editBox:EnableMouseWheel(enable)
	end,
	['GetNumber'] = function(self)						
		return tonumber(self.editBox:GetNumber())		
	end,
	['SetNumber'] = function(self,num)
		local newNumber = self:ProcessValue(num)		
		if newNumber then	self:FireEvent("OnValueChanged",false,newNumber) end			
	end,
	['ProcessValue'] = function(self,value,oldValue)
		local settings 	= self.settings				
		local number 		= tonumber(value)
		local oldNumber	= oldValue or tonumber(self.editBox:GetNumber())
		
		if not number then
			number = oldNumber or settings.min
		else
			number = max(min(number,settings.max),settings.min)
		end
		
		if number ~= oldNumber then 
			self.editBox:SetText(number)
			self.editBox:SetCursorPosition(0)
			self:UpdateBar()
			return number			
		else
			return false
		end 		
	end,
	['OnSpin'] = function(self,delta)
		local settings 	= self.settings
		local oldNumber	= tonumber(self.editBox:GetNumber())
		local step = IsShiftKeyDown() and settings.shiftStep or settings.step
		local newNumber
			
		if delta > 0 then
			newNumber = self:ProcessValue(DiesalTools:Round(oldNumber,step)+step)												
		else
			newNumber = self:ProcessValue(DiesalTools:Round(oldNumber,step)-step)								
		end
		
		if newNumber then	self:FireEvent("OnValueChanged",true,newNumber) end		
	end,
	['OnUserSet'] = function(self,num)
		if self.settings.oldNumber == tonumber(num) then return end
		local newNumber = self:ProcessValue(num,self.settings.oldNumber)
		
		if newNumber then
			self.settings.oldNumber = newNumber
			self:FireEvent("OnValueChanged",true,newNumber)
		end				
	end,		
	['UpdateBar'] = function(self)
		if not self.settings.bar then return end
		local settings = self.settings	
		local number = self:GetNumber() or settings.min				
		local width = DiesalTools:Round(((number - settings.min) / (settings.max - settings.min)* settings.barWidth ))	
		if width == 0 then 
			self.bar:Hide()
		else
			self.bar:Show()
			self.bar:SetWidth(width)
		end	
	end,
	['SetTextColor'] = function(self,color,alpha)
		alpha = alpha or 1
		color = {DiesalTools:GetColor(color)}
		self.editBox:SetTextColor(color[1],color[2],color[3],alpha)	
	end,			
}
-- | Constructor |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local function Constructor()
	local self 		= DiesalGUI:CreateObjectBase(Type)
	local frame		= CreateFrame('Frame',nil,UIParent)		
	self.frame		= frame	
	-- ~~ Default Settings ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	self.defaults = {
		height 			= 16,
		width 			= 29,
		mouse				= true,
		mouseWheel	= true,	
		buttons			= false,
		buttonsWidth= 8,
		bar					= true,	
		min					= 0,
		max					= 100,
		step				= 5,
		shiftStep		= 1,
	}
	-- ~~ Events ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	-- OnAcquire, OnRelease, OnHeightSet, OnWidthSet	
	-- OnEnter, OnLeave, OnEnterPressed, OnValueChanged 		
	-- ~~ Construct ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	frame:SetScript("OnHide",function(this)
		self:FireEvent("OnHide")
	end)	
	
	local editBox = self:CreateRegion("EditBox", 'editBox', frame)	
	editBox:SetPoint("TOPLEFT")		
	editBox:SetAutoFocus(false)			
	editBox:SetJustifyH("CENTER")
	editBox:SetJustifyV("CENTER")	
	editBox:SetTextInsets(1,0,2,0)
	editBox:SetText(self.defaults.min)
	editBox:SetScript('OnEnterPressed',  function(this,...)					
		self:OnUserSet(self:GetNumber())
		self:FireEvent("OnEnterPressed",...)	
		DiesalGUI:ClearFocus()		
	end)				
	editBox:HookScript('OnEscapePressed', function(this,...)				
		self:SetNumber(self.settings.oldNumber)		
	end)
	editBox:HookScript('OnEditFocusLost', function(this,...)	
		self:SetNumber(self.settings.oldNumber)				
	end)	
	editBox:HookScript('OnEditFocusGained', function(this)				
		self.settings.oldNumber = self:GetNumber()			
	end)
	editBox:SetScript("OnMouseWheel", function(this,delta)		
		DiesalGUI:OnMouse(this,'MouseWheel')	
		self:OnSpin(delta)		
	end)
	editBox:SetScript("OnEnter",function(this,...)		
		self:FireEvent("OnEnter",...)				
	end)
	editBox:SetScript("OnLeave", function(this,...)		
		self:FireEvent("OnLeave",...)					
	end)	
	
	local bar = self:CreateRegion("Frame", 'bar', frame)	
	bar:SetPoint('TOPLEFT',1,-1)	
	bar:SetPoint('BOTTOMLEFT',-1,1)
	local buttonUp = self:CreateRegion("Button", 'buttonUp', frame)	
	buttonUp:SetPoint('TOP',0,0)
	buttonUp:SetPoint('RIGHT')	
	buttonUp:SetScript("OnClick", function(this)
		DiesalGUI:OnMouse(this,button)
		PlaySound("gsTitleOptionExit")
		self:OnSpin(1)
	end)
	local buttonDown = self:CreateRegion("Button", 'buttonDown', frame)		
	buttonDown:SetPoint('BOTTOM',0,0)
	buttonDown:SetPoint('RIGHT')		
	buttonDown:SetScript("OnClick", function(this)
		DiesalGUI:OnMouse(this,button)
		PlaySound("gsTitleOptionExit")
		self:OnSpin(-1)
	end)	
	-- ~~ Methods ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	for method, func in pairs(methods) do	self[method] = func	end
	-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	return self
end	
DiesalGUI:RegisterObjectConstructor(Type,Constructor,Version)