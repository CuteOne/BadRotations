-- $Id: DiesalMenu-1.0.lua 53 2016-07-12 21:56:30Z diesal2010 $
local MAJOR, MINOR = "DiesalMenu-1.0", "$Rev: 53 $"
local DiesalMenu, oldminor = LibStub:NewLibrary(MAJOR, MINOR)
if not DiesalMenu then return end -- No Upgrade needed.
-- ~~| Libraries |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local DiesalTools = LibStub("DiesalTools-1.0")
local DiesalStyle = LibStub("DiesalStyle-1.0")
local DiesalGUI 	= LibStub("DiesalGUI-1.0")
-- ~~| Lua Upvalues |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local type, select,  tonumber											= type, select, tonumber
local setmetatable, getmetatable, next								= setmetatable, getmetatable, next
local sub, format, lower, upper, match 							= string.sub, string.format, string.lower, string.upper, string.match
local pairs, ipairs														= pairs,ipairs
local tinsert, tremove, tconcat, tsort								= table.insert, table.remove, table.concat, table.sort
local floor, ceil, abs, modf											= math.floor, math.ceil, math.abs, math.modf
-- ~~| WoW Upvalues |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local CreateFrame, UIParent  											= CreateFrame, UIParent
-- ~~| DiesalMenu Values |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	
-- ~~| DiesalMenu Upvalues |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- ~~| DiesalStyle Locals |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local MENU
local CLOSEDELAY = 2

local closeTimer = CreateFrame('Frame')
closeTimer:Hide()
closeTimer:SetScript('OnUpdate', function(this,elapsed)
	if this.count < 0 then 
		DiesalMenu:Close()
		this:Hide()		
	else		
		this.count = this.count - elapsed			
	end	
end)
-- ~~| DiesalMenu Local Methods |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

 -- ~~| DiesalMenu API |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function DiesalMenu:Menu(menuData,anchor,x,y,closeDelay)
	MENU = MENU or DiesalGUI:Create('Menu')		
	MENU:ResetSettings()
	if not MENU:BuildMenu(menuData) then MENU:Hide() return end
	MENU:Show()		
	MENU:ClearAllPoints()
	MENU:SetPoint('TOPLEFT',anchor,'TOPLEFT',x,y)
	closeTimer.closeDelay = closeDelay or CLOSEDELAY
	DiesalMenu:StartCloseTimer()
	DiesalMenu:SetFocus()			
end
function DiesalMenu:Close()
	DiesalMenu:StopCloseTimer()
	if not MENU or not MENU:IsVisible() then return end
	MENU:ResetSettings()
	MENU:ReleaseChildren()	
	MENU:Hide()
	MENU:ClearAllPoints()			
end
function DiesalMenu:StartCloseTimer()
	closeTimer.count = closeTimer.closeDelay
	closeTimer:Show()		
end
function DiesalMenu:StopCloseTimer()
	closeTimer:Hide()
end
function DiesalMenu:ClearFocus()
	DiesalMenu:Close()	
end
function DiesalMenu:SetFocus()
	DiesalGUI:SetFocus(DiesalMenu)
end
