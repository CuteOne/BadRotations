-- $Id: DiesalGUI-1.0.lua 61 2017-03-28 23:13:41Z diesal2010 $
local MAJOR, MINOR = "DiesalGUI-1.0", "$Rev: 61 $"
local DiesalGUI, oldminor = LibStub:NewLibrary(MAJOR, MINOR)
if not DiesalGUI then return end -- No Upgrade needed.
-- ~~| Libraries |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local CallbackHandler                  = LibStub("CallbackHandler-1.0")
local DiesalTools                      = LibStub("DiesalTools-1.0")
local DiesalStyle                      = LibStub("DiesalStyle-1.0")
-- ~~| Lua Upvalues |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local type, select, tonumber           = type, select, tonumber
local setmetatable, getmetatable, next = setmetatable, getmetatable, next
local pairs, ipairs                    = pairs, ipairs
local tinsert, tremove                 = table.insert, table.remove
-- ~~| WoW Upvalues |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local CreateFrame, UIParent            = CreateFrame, UIParent
-- ~~| DiesalGUI Values |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
DiesalGUI.callbacks                    = DiesalGUI.callbacks or CallbackHandler:New(DiesalGUI)
DiesalGUI.ObjectFactory                = DiesalGUI.ObjectFactory or {}
DiesalGUI.ObjectVersions               = DiesalGUI.ObjectVersions or {}
DiesalGUI.ObjectPool                   = DiesalGUI.ObjectPool or {}
DiesalGUI.ObjectBase                   = DiesalGUI.ObjectBase or {}
-- ~~| DiesalGUI Upvalues |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local ObjectFactory                    = DiesalGUI.ObjectFactory
local ObjectVersions                   = DiesalGUI.ObjectVersions
local ObjectPool                       = DiesalGUI.ObjectPool
local ObjectBase                       = DiesalGUI.ObjectBase
-- ~~| DiesalGUI Local Methods |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local function OnMouse(frame, button)
	DiesalGUI:ClearFocus()
end
-- capture mouse clicks on the WorldFrame
local function WorldFrameOnMouse(frame, button)
	OnMouse(frame, button)
end
_G.WorldFrame:HookScript("OnMouseDown", WorldFrameOnMouse)
-- Returns a new object
local function newObject(objectType)
	if not ObjectFactory[objectType] then error("Attempt to construct unknown Object type", 2) end

	ObjectPool[objectType] = ObjectPool[objectType] or {}

	local newObj = next(ObjectPool[objectType])
	if not newObj then
		newObj = ObjectFactory[objectType](object)
	else
		ObjectPool[objectType][newObj] = nil
	end

	return newObj
end
-- Releases an object into ReleasedObjects
local function releaseObject(obj, objectType)
	ObjectPool[objectType] = ObjectPool[objectType] or {}

	if ObjectPool[objectType][obj] then
		error("Attempt to Release Object that is already released", 2)
	end
	ObjectPool[objectType][obj] = true
end
-- ~~| Object Blizzard Base |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ObjectBase.Hide = function(self)
	self.frame:Hide()
end
ObjectBase.Show = function(self)
	self.frame:Show()
end
ObjectBase.SetParent = function(self, parent)
	local frame = self.frame
	frame:SetParent(nil)
	frame:SetParent(parent)
	self.settings.parent = parent
end
ObjectBase.SetWidth = function(self, width)
	self.settings.width = width
	self.frame:SetWidth(width)
	self:FireEvent("OnWidthSet", width)
end
ObjectBase.SetHeight = function(self, height)
	self.settings.height = height
	self.frame:SetHeight(height)
	self:FireEvent("OnHeightSet", height)
end
ObjectBase.SetSize = function(self, width, height)
	self.settings.width = width
	self.settings.height = height

	self.frame:SetHeight(height)
	self.frame:SetWidth(width)

	self:FireEvent("OnWidthSet", width)
	self:FireEvent("OnHeightSet", height)
end
ObjectBase.GetWidth = function(self)
	return self.frame:GetWidth()
end
ObjectBase.GetHeight = function(self)
	return self.frame:GetHeight()
end
ObjectBase.IsVisible = function(self)
	return self.frame:IsVisible()
end
ObjectBase.IsShown = function(self)
	return self.frame:IsShown()
end
ObjectBase.SetPoint = function(self, ...)
	return self.frame:SetPoint(...)
end
ObjectBase.SetAllPoints = function(self, ...)
	return self.frame:SetAllPoints(...)
end
ObjectBase.ClearAllPoints = function(self)
	return self.frame:ClearAllPoints()
end
ObjectBase.GetNumPoints = function(self)
	return self.frame:GetNumPoints()
end
ObjectBase.GetPoint = function(self, ...)
	return self.frame:GetPoint(...)
end
-- ~~| Object Diesal Base |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ObjectBase.CreateRegion = function(self, regionType, regionName, parentRegion, defaultFontObject)
	if regionType == 'FontString' then
		-- Try creating with explicit parameters
		local fontString = parentRegion:CreateFontString(nil, "OVERLAY")

		-- CRITICAL: Set font IMMEDIATELY and DON'T let anything override it if it fails
		-- Start with GameFontNormal which is guaranteed to work
		fontString:SetFontObject(_G.GameFontNormal)

		-- set Default font properties
		if defaultFontObject then
			fontString.defaultFontObject = defaultFontObject
		else
			fontString.defaultFontObject = _G.DiesalFontNormal or _G.GameFontNormal
		end

		-- ONLY try to apply custom font if we can verify it's valid first
		if fontString.defaultFontObject and fontString.defaultFontObject ~= _G.GameFontNormal and type(fontString.defaultFontObject.GetFont) == "function" then
			local success, fontPath, fontSize, fontFlags = pcall(fontString.defaultFontObject.GetFont, fontString.defaultFontObject)
			-- Only apply if we got a valid font path
			if success and fontPath and fontPath ~= "" then
				local fontSuccess = pcall(fontString.SetFont, fontString, fontPath, fontSize or 12, fontFlags or "")
				-- If custom font failed, font object fallback is still active from SetFontObject above
			end
		end

		-- Set colors and spacing safely
		if fontString.defaultFontObject and type(fontString.defaultFontObject.GetTextColor) == "function" then
			local success, r, g, b, a = pcall(fontString.defaultFontObject.GetTextColor, fontString.defaultFontObject)
			if success and r then
				pcall(fontString.SetTextColor, fontString, r, g, b, a or 1)
			end
		end
		if fontString.defaultFontObject and type(fontString.defaultFontObject.GetSpacing) == "function" then
			local success, spacing = pcall(fontString.defaultFontObject.GetSpacing, fontString.defaultFontObject)
			if success and spacing then
				pcall(fontString.SetSpacing, fontString, spacing)
			end
		end

		self[regionName] = fontString
		self.fontStrings[regionName] = fontString
		return fontString
	end
	if regionType == 'Texture' then
		self[regionName] = parentRegion:CreateTexture()
		return self[regionName]
	end
	if regionType == 'EditBox' then
		local editBox = CreateFrame(regionType, nil, parentRegion)

		-- CRITICAL: Set a font IMMEDIATELY with multiple fallbacks
		if _G.GameFontNormal then
			pcall(editBox.SetFontObject, editBox, _G.GameFontNormal)
		end
		pcall(editBox.SetFont, editBox, "Fonts\\FRIZQT__.TTF", 12, "")

		local testFont = editBox:GetFont()
		if not testFont and _G.ChatFontNormal then
			pcall(editBox.SetFontObject, editBox, _G.ChatFontNormal)
		end

		-- set Default font properties
		if defaultFontObject then
			editBox.defaultFontObject = defaultFontObject
		else
			editBox.defaultFontObject = _G.DiesalFontNormal or _G.GameFontNormal
		end

		-- Try to apply custom font if available
		if editBox.defaultFontObject and type(editBox.defaultFontObject.GetFont) == "function" then
			local success, fontPath, fontSize, fontFlags = pcall(editBox.defaultFontObject.GetFont, editBox.defaultFontObject)
			if success and fontPath then
				pcall(editBox.SetFont, editBox, fontPath, fontSize or 11, fontFlags or "")
			end
		end

		-- Set colors and spacing safely
		if editBox.defaultFontObject and type(editBox.defaultFontObject.GetTextColor) == "function" then
			local success, r, g, b, a = pcall(editBox.defaultFontObject.GetTextColor, editBox.defaultFontObject)
			if success and r then
				pcall(editBox.SetTextColor, editBox, r, g, b, a or 1)
			end
		end
		if editBox.defaultFontObject and type(editBox.defaultFontObject.GetSpacing) == "function" then
			local success, spacing = pcall(editBox.defaultFontObject.GetSpacing, editBox.defaultFontObject)
			if success and spacing then
				pcall(editBox.SetSpacing, editBox, spacing)
			end
		end

		editBox:HookScript('OnEscapePressed', function(this) DiesalGUI:ClearFocus(); end)
		editBox:HookScript('OnEditFocusGained', function(this)
			DiesalGUI:SetFocus(this); GameTooltip:Hide();
		end)

		self[regionName] = editBox
		return editBox
	end
	if regionType == 'ScrollingMessageFrame' then
		local srollingMessageFrame = CreateFrame(regionType, nil, parentRegion)

		-- CRITICAL: Set a font IMMEDIATELY with multiple fallbacks
		if _G.GameFontNormal then
			pcall(srollingMessageFrame.SetFontObject, srollingMessageFrame, _G.GameFontNormal)
		end
		pcall(srollingMessageFrame.SetFont, srollingMessageFrame, "Fonts\\FRIZQT__.TTF", 12, "")

		local testFont = srollingMessageFrame:GetFont()
		if not testFont and _G.ChatFontNormal then
			pcall(srollingMessageFrame.SetFontObject, srollingMessageFrame, _G.ChatFontNormal)
		end

		-- set Default font properties
		if defaultFontObject then
			srollingMessageFrame.defaultFontObject = defaultFontObject
		else
			srollingMessageFrame.defaultFontObject = _G.DiesalFontNormal or _G.GameFontNormal
		end

		-- Try to apply custom font if available
		if srollingMessageFrame.defaultFontObject and type(srollingMessageFrame.defaultFontObject.GetFont) == "function" then
			local success, fontPath, fontSize, fontFlags = pcall(srollingMessageFrame.defaultFontObject.GetFont, srollingMessageFrame.defaultFontObject)
			if success and fontPath then
				pcall(srollingMessageFrame.SetFont, srollingMessageFrame, fontPath, fontSize or 11, fontFlags or "")
			end
		end

		-- Set colors and spacing safely
		if srollingMessageFrame.defaultFontObject and type(srollingMessageFrame.defaultFontObject.GetTextColor) == "function" then
			local success, r, g, b, a = pcall(srollingMessageFrame.defaultFontObject.GetTextColor, srollingMessageFrame.defaultFontObject)
			if success and r then
				pcall(srollingMessageFrame.SetTextColor, srollingMessageFrame, r, g, b, a or 1)
			end
		end
		if srollingMessageFrame.defaultFontObject and type(srollingMessageFrame.defaultFontObject.GetSpacing) == "function" then
			local success, spacing = pcall(srollingMessageFrame.defaultFontObject.GetSpacing, srollingMessageFrame.defaultFontObject)
			if success and spacing then
				pcall(srollingMessageFrame.SetSpacing, srollingMessageFrame, spacing)
			end
		end

		self[regionName] = srollingMessageFrame
		return srollingMessageFrame
	end

	self[regionName] = CreateFrame(regionType, nil, parentRegion)
	return self[regionName]
end
ObjectBase.ResetFonts = function(self)
	for name, fontString in pairs(self.fontStrings) do
		-- Safe font initialization with fallback
		local fontPath, fontSize, fontFlags = fontString.defaultFontObject:GetFont()
		if not fontPath then
			-- Fallback to WoW default if GetFont returns nil
			fontPath, fontSize, fontFlags = "Fonts\\FRIZQT__.TTF", 11, ""
		end
		fontString:SetFont(fontPath, fontSize, fontFlags)
		fontString:SetTextColor(fontString.defaultFontObject:GetTextColor())
		fontString:SetSpacing(fontString.defaultFontObject:GetSpacing())
	end
end
ObjectBase.AddChild = function(self, object)
	tinsert(self.children, object)
end
ObjectBase.ReleaseChild = function(self, object)
	local children = self.children

	for i = 1, #children do
		if children[i] == object then
			children[i]:Release()
			tremove(children, i)
			break
		end
	end
end
ObjectBase.ReleaseChildren = function(self)
	local children = self.children
	for i = 1, #children do
		children[i]:Release()
		children[i] = nil
	end
end
ObjectBase.Release = function(self)
	DiesalGUI:Release(self)
end
ObjectBase.SetParentObject = function(self, parent)
	local frame = self.frame
	local settings = self.settings

	frame:SetParent(nil)
	frame:SetParent(parent.content)
	settings.parent       = parent.content
	settings.parentObject = parent
end
ObjectBase.SetSettings = function(self, settings, apply)
	for key, value in pairs(settings) do
		self.settings[key] = value
	end
	if apply then self:ApplySettings() end
end
ObjectBase.ResetSettings = function(self, apply)
	self.settings = DiesalTools.TableCopy(self.defaults)
	if apply then self:ApplySettings() end
end
ObjectBase.SetEventListener = function(self, event, listener)
	if type(listener) == "function" then
		self.eventListeners[event] = listener
	else
		error("listener is required to be a function", 2)
	end
end
ObjectBase.ResetEventListeners = function(self)
	for k in pairs(self.eventListeners) do
		self.eventListeners[k] = nil
	end
end
ObjectBase.FireEvent = function(self, event, ...)
	if self.eventListeners[event] then
		return self.eventListeners[event](self, event, ...)
	end
end
ObjectBase.SetStyle = function(self, name, style)
	DiesalStyle:SetObjectStyle(self, name, style)
end
ObjectBase.UpdateStyle = function(self, name, style)
	DiesalStyle:UpdateObjectStyle(self, name, style)
end
ObjectBase.UpdateStylesheet = function(self, Stylesheet)
	DiesalStyle:UpdateObjectStylesheet(self, Stylesheet)
end
ObjectBase.SetStylesheet = function(self, Stylesheet)
	DiesalStyle:SetObjectStylesheet(self, Stylesheet)
end
ObjectBase.ReleaseTexture = function(self, name)
	if not self.textures[name] then return end
	DiesalStyle:ReleaseTexture(self, name)
end
ObjectBase.ReleaseTextures = function(self)
	DiesalStyle:ReleaseTextures(self)
end
-- ~~| DiesalGUI API |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Returns an Object Base
function DiesalGUI:CreateObjectBase(Type)
	local object = {
		type           = Type,
		fontStrings    = {},
		textures       = {},
		children       = {},
		eventListeners = {},
	}
	setmetatable(object, { __index = ObjectBase })
	return object
end

-- Registers an Object constructor in the ObjectFactory
function DiesalGUI:RegisterObjectConstructor(Type, constructor, version)
	assert(type(constructor) == "function")
	assert(type(version) == "number")

	local oldVersion = ObjectVersions[Type]
	if oldVersion and oldVersion >= version then return end

	ObjectVersions[Type] = version
	ObjectFactory[Type] = constructor
end

-- Create a new Object
function DiesalGUI:Create(objectType, name)
	if ObjectFactory[objectType] then
		local object
		if name then -- needs a specific name, bypass the objectPool and create a new object
			object = ObjectFactory[objectType](name)
		else
			object = newObject(objectType)
		end
		object:ResetSettings()
		-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		if object.OnAcquire then object:OnAcquire() end
		return object
	end
end

function DiesalGUI:CreateThrottle(duration, callback)
	assert(callback and type(callback) == 'function', 'callback has to be a function ')
	assert(duration and type(duration) == 'number', 'duration has to be a number ')

	local throttle         = CreateFrame("Frame", nil, UIParent):CreateAnimationGroup()
	throttle.anim          = throttle:CreateAnimation("Animation")
	throttle.args          = {}
	local mt               = getmetatable(throttle)
	mt.__index.SetCallback = function(self, callback)
		assert(callback and type(callback) == 'function', 'callback required to be a function ')
		self:SetScript("OnFinished", function() callback(unpack(self.args)) end)
	end
	mt.__index.AddCallback = function(self, callback)
		assert(callback and type(callback) == 'function', 'callback required to be a function ')
		self:HookScript("OnFinished", function() callback(unpack(self.args)) end)
	end
	mt.__index.SetDuration = function(self, duration)
		assert(duration and type(duration) == 'number', 'duration has to be a number ')
		self.anim:SetDuration(duration)
	end
	mt.__call              = function(self, ...)
		self.args = { ... }
		self:Stop()
		self:Play()
	end
	setmetatable(throttle, mt)

	throttle:SetScript("OnFinished", function() callback(unpack(throttle.args)) end)
	throttle:SetDuration(duration)

	return throttle
end

-- Releases an object ready for reuse by Create
function DiesalGUI:Release(object)
	if object.OnRelease then object:OnRelease() end
	object:FireEvent("OnRelease")

	object:ReleaseChildren()
	object:ReleaseTextures()
	object:ResetFonts()
	object:ResetEventListeners()

	object.frame:ClearAllPoints()
	object.frame:Hide()
	object.frame:SetParent(UIParent)
	releaseObject(object, object.type)
end

-- Set FocusedObject: Menu, Dropdown, editBox etc....
function DiesalGUI:SetFocus(object)
	if self.FocusedObject and self.FocusedObject ~= object then DiesalGUI:ClearFocus() end
	self.FocusedObject = object
end

-- clear focus from the FocusedObject
function DiesalGUI:ClearFocus()
	local FocusedObject = self.FocusedObject
	if FocusedObject then
		if FocusedObject.ClearFocus then -- FocusedObject is Focusable Frame
			FocusedObject:ClearFocus()
		end
		self.FocusedObject = nil
	end
end

-- Mouse Input capture for any DiesalGUI interactive region
function DiesalGUI:OnMouse(frame, button)
	-- print(button)
	OnMouse(frame, button)
	DiesalGUI.callbacks:Fire("DiesalGUI_OnMouse", frame, button)
end

DiesalGUI.counts = DiesalGUI.counts or {}
--- A type-based counter to count the number of widgets created.
function DiesalGUI:GetNextObjectNum(type)
	if not self.counts[type] then
		self.counts[type] = 0
	end
	self.counts[type] = self.counts[type] + 1
	return self.counts[type]
end

--- Return the number of created widgets for this type.
function DiesalGUI:GetObjectCount(type)
	return self.counts[type] or 0
end
