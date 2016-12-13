-- $Id: CheckBox.lua 53 2016-07-12 21:56:30Z diesal2010 $

local DiesalGUI = LibStub("DiesalGUI-1.0")
-- ~~| Libraries |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local DiesalTools = LibStub("DiesalTools-1.0")
local DiesalStyle = LibStub("DiesalStyle-1.0")
-- ~~| Lua Upvalues |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local type, tonumber, select 											= type, tonumber, select
local pairs, ipairs, next												= pairs, ipairs, next
local min, max					 											= math.min, math.max
-- ~~| WoW Upvalues |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local CreateFrame, UIParent, GetCursorPosition 					= CreateFrame, UIParent, GetCursorPosition
local GetScreenWidth, GetScreenHeight								= GetScreenWidth, GetScreenHeight
local GetSpellInfo, GetBonusBarOffset, GetDodgeChance			= GetSpellInfo, GetBonusBarOffset, GetDodgeChance
local GetPrimaryTalentTree, GetCombatRatingBonus				= GetPrimaryTalentTree, GetCombatRatingBonus
-- ~~| Button |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local TYPE 		= "CheckBox"
local VERSION 	= 1
-- ~~| Button StyleSheets |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local styleSheet = {
	
	['frame-border'] = {
		type			= 'texture',
		layer			= 'BORDER',
		gradient	= 'VERTICAL',
		color			= '000000',		
		offset		= -2,
	},	
	['frame-innerColor'] = {
		type			= 'texture',
		layer			= 'BORDER',
		color			= '080a0d',
		offset		= -2,
	},
}
local checkStyle = {
		type			= 'texture',
		layer			= 'ARTWORK',
		color			= '4aa4ff',
		offset		= -3,
}
local checkDisabled = {
		type			= 'texture',
		texColor		= 'ffffff',
}
local checkEnabled = {
		type			= 'texture',
		aplha			= 1,
}
local wireFrame = {
	['frame-white'] = {
		type			= 'outline',
		layer			= 'OVERLAY',
		color			= 'ffffff',
	},
}
-- ~~| Button Methods |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local methods = {
	['OnAcquire'] = function(self)
		self:ApplySettings()
		self:AddStyleSheet(styleSheet)
		self:Enable()
		-- self:AddStyleSheet(wireFrameSheet)
		self:Show()
	end,
	['OnRelease'] = function(self)

	end,
	['ApplySettings'] = function(self)
		local settings 	= self.settings
		local frame 		= self.frame

		self:SetWidth(settings.width)
		self:SetHeight(settings.height)
	end,
	["SetChecked"] = function(self,value)
		self.settings.checked = value
		self.frame:SetChecked(value)

		self[self.settings.disabled and "Disable" or "Enable"](self)
	end,
	["GetChecked"] = function(self)
		return self.settings.checked
	end,
	["Disable"] = function(self)
		self.settings.disabled = true
		DiesalStyle:StyleTexture(self.check,checkDisabled)
		self.frame:Disable()
	end,
	["Enable"] = function(self)
		self.settings.disabled = false
		DiesalStyle:StyleTexture(self.check,checkEnabled)
		self.frame:Enable()
	end,
	["RegisterForClicks"] = function(self,...)
		self.frame:RegisterForClicks(...)
	end,
}
-- ~~| Button Constructor |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local function Constructor()
	local self 		= DiesalGUI:CreateObjectBase(TYPE)
	local frame		= CreateFrame('CheckButton', nil, UIParent)
	self.frame		= frame

	-- ~~ Default Settings ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	self.defaults = {
		height 		= 11,
		width 		= 11,
	}
	-- ~~ Events ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	-- OnAcquire, OnRelease, OnHeightSet, OnWidthSet
	-- OnValueChanged, OnEnter, OnLeave, OnDisable, OnEnable
	-- ~~ Construct ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

	local check = self:CreateRegion("Texture", 'check', frame)
	DiesalStyle:StyleTexture(check,checkStyle)
	frame:SetCheckedTexture(check)
	frame:SetScript('OnClick', function(this,button,...)
		DiesalGUI:OnMouse(this,button)

		if not self.settings.disabled then
			self:SetChecked(not self.settings.checked)

			if self.settings.checked then
				PlaySound("igMainMenuOptionCheckBoxOn")
			else
				PlaySound("igMainMenuOptionCheckBoxOff")
			end

			self:FireEvent("OnValueChanged", self.settings.checked)
		end
	end)
	frame:SetScript('OnEnter', function(this)
		self:FireEvent("OnEnter")
	end)
	frame:SetScript('OnLeave', function(this)
		self:FireEvent("OnLeave")
	end)
	frame:SetScript("OnDisable", function(this)
		self:FireEvent("OnDisable")
	end)
	frame:SetScript("OnEnable", function(this)
		self:FireEvent("OnEnable")
	end)

	-- ~~ Methods ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	for method, func in pairs(methods) do	self[method] = func	end
	-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	return self
end

DiesalGUI:RegisterObjectConstructor(TYPE,Constructor,VERSION)