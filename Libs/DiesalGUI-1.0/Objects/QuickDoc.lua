-- $Id: QuickDoc.lua 60 2016-11-04 01:34:23Z diesal2010 $

-- | Libraries |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local DiesalTools 	= LibStub("DiesalTools-1.0")
local DiesalStyle 	= LibStub("DiesalStyle-1.0")
local DiesalGUI 		= LibStub("DiesalGUI-1.0")
local DiesalMenu 		= LibStub('DiesalMenu-1.0')
-- | Lua Upvalues |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local print, type, select, tostring, tonumber	= print, type, select, tostring, tonumber
local sub, format, match, lower								= string.sub, string.format, string.match, string.lower
local table_sort															= table.sort
local abs																			= math.abs
-- | WoW Upvalues |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


-- | TableExplorer |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local QuickDoc
local Type = "QuickDoc"
local Version = 1
-- | Stylesheets |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local windowStylesheet = {
	['content-background'] = {
		type			= 'texture',
		color			= '131517',
	},
}

-- | Local |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

local doc = {
	{ type = 'section',
		margin = {0,0,0,0},
		padding = {0,0,0,0},
		style = {},
		{ type = 'single-line',	text = 'Editor',
			font = nil,
			fontSize = 14,
			text = 'Editor',
		},
		{ type = 'columns',	text = 'Editor',
			font = nil,
			fontSize = 14,
			text = 'Editor',
		},
	}	
}

-- |  Methods |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local methods = {
	['OnAcquire'] = function(self)
		self.settings = DiesalTools.TableCopy( self.defaults )
		self:ApplySettings()
		self:Show()
	end,
	['OnRelease'] = function(self)
		self.tree:ReleaseChildren()
	end,
	['ApplySettings'] = function(self)

	end,
	['BuildDoc'] = function(self,doc)
-- 		if #doc == 0 then error('BuildDoc(doc) doc requires atleast one section')
-- 		local settings = self.settings
-- 		-- reset
-- 		self:ReleaseChildren()
-- 		-- setup
-- 		settings.doc = doc
--
-- 		if #doc == 0 then
-- 			tree:UpdateHeight()
-- 			self.statusText:SetText('|cffff0000Table is empty.')
-- 		return end
-- 		-- sort tree table
-- 		local sortedTable = sortTable(settings.exploredTable)
-- 		-- build Tree Branches
-- 		for position, key in ipairs(sortedTable) do
-- 			if self.settings.endtime <= time() then	self:Timeout() return end
-- 			self:BuildBranch(self.tree,key[2],settings.exploredTable[key[2]],position,1,position == #sortedTable)
-- 		end
	end,
	['BuildSection'] = function(self,parent,key,value,position,depth,last)
-- 		local tree = self.tree
-- 		local leaf = type(value) ~= 'table' or next(value) == nil or depth >= self.settings.maxDepth
-- 		local branch = DiesalGUI:Create('Branch')
-- 		-- | Reset Branch	|~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- 		branch:ReleaseChildren()
-- 		-- | setup Branch |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- 		branch:SetParentObject(parent)
-- 		parent:AddChild(branch)
-- 		branch:SetSettings({
-- 			key				= key,
-- 			value			= value,
-- 			position 	= position,
-- 			depth			= depth,
-- 			last			= last,
-- 			leaf 			= leaf,
-- 		})
-- 		branch:SetEventListener('OnClick',function(this,event,button)
-- 			if button =='RightButton' then
-- 				if not next(this.settings.menuData) then return end
-- 				DiesalMenu:Menu(this.settings.menuData,this.frame,10,-10)
-- 			end
-- 		end)
--
-- 		self:SetBranchLabel(branch,key,value,leaf)
-- 		self:SetBranchMenu(branch,key,value)
-- 		self:SetBranchIcon(branch,type(value))
--
-- 		if value == tree or leaf then branch:ApplySettings() return end
-- 		-- | sort Branch Table |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- 		local sortedTable = sortTable(value)
-- 		-- | build Branch Branches |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- 		for position, key in ipairs(sortedTable) do
-- 			if self.settings.endtime <= time() then	self:Timeout() return end
-- 			self:BuildBranch(branch,key[2],value[key[2]],position,depth+1,position == #sortedTable)
-- 		end
-- 		-- | Update Branch | ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- 		branch:ApplySettings()
	end,
	['Show'] = function(self)
		self.window:Show()
	end,
}
-- ~~| TableExplorer Constructor |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local function Constructor()
	QuickDoc = DiesalGUI:CreateObjectBase(Type)
	-- ~~ Default Settings ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	QuickDoc.defaults = {

	}
	-- ~~ Construct ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	local window = DiesalGUI:Create('Window')
	window:SetSettings({
		header				= false,
		footer				= false,
		top						= UIParent:GetHeight() - 100,
		left 					= 100,
		height 				= 300,
		width 				= 400,
		minWidth 			= 200,
		minHeight			= 200,
	},true)
	window:SetStylesheet(windowStylesheet)








	-- ~~ Frames ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	QuickDoc.window 				= window
	QuickDoc.content 				= window.content
	QuickDoc.frame					= window.frame


	-- ~~ Methods ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	for method, func in pairs(methods) do	QuickDoc[method] = func	end
	-- ~~ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	return QuickDoc
end
DiesalGUI:RegisterObjectConstructor(Type,Constructor,Version)
