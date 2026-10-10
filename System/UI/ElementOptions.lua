local _, br = ...
--- Element Options
-- Shared helpers for the short element methods rotations use (br.ui:section, br.ui:checkbox,
-- br.ui:spinner, br.ui:doubleSpinner, br.ui:dropdown, br.ui:text, br.ui:toggle). Each method lives
-- in its element's file with a ---@class block listing every field it takes.
br.ui = br.ui or {}
br.ui.elementOptions = br.ui.elementOptions or {}
local elementOptions = br.ui.elementOptions

--- Plain text shows white (option tooltips default to red); text with its own color is left as is.
function elementOptions.white(text)
    if type(text) ~= "string" or text:sub(1, 2) == "|c" then return text end
    return "|cffFFFFFF" .. text
end

local function stripColor(text)
    local stripped = tostring(text):gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
    return stripped
end

--- Position of text in a list, ignoring color codes (nil when it isn't there).
function elementOptions.indexOf(list, text)
    for i, entry in ipairs(list) do
        if stripColor(entry) == text then return i end
    end
end

-- The rotation file's line that called into BR ("Druid-Forever.lua:72: "): the first caller outside
-- BR's System folder, or "" when there is none
local function rotationLine()
    for level = 2, 16 do
        local _, location = pcall(error, "", level)
        location = tostring(location)
        if location == "" then break end
        if not location:find("[/\\]System[/\\]") then
            return (location:gsub('^%[string "(.-)"%]', "%1"))
        end
    end
    return ""
end

--- Prints a mistake in red at the rotation file's line ("Druid-Forever.lua:72: ...").
function elementOptions.problem(message)
    br._G.print("|cffFF0000" .. rotationLine() .. message .. "|r")
end

--- Reports something cosmetic (e.g. a toggle icon that isn't in the spell list) at the rotation
-- file's line, only when Addon Debug Messages shows profile messages.
function elementOptions.notice(message)
    br.functions.misc:addonDebug(rotationLine() .. message)
end

local function fieldList(fields)
    local names = {}
    for field in pairs(fields) do names[#names + 1] = field end
    table.sort(names)
    return table.concat(names, ", ")
end

--- Checks an element's fields against what it takes. fields: { field = "number" | "string" |
-- "boolean" | "table" | "function", or several joined with "/" }; required: list of fields that must
-- be given. Unknown or mistyped fields are reported and ignored. Returns the fields table, or nil
-- (reported) when a required field is missing.
-- @param what     how to name the element in messages, e.g. 'spinner "Healing Touch"'
function elementOptions.check(what, given, fields, required)
    if given == nil then given = {} end
    if type(given) ~= "table" then
        elementOptions.problem(what .. ": its settings must be a table, e.g. { tip = \"...\" }")
        return nil
    end
    local checked = {}
    for field, value in pairs(given) do
        local kinds = fields[field]
        if kinds == nil then
            elementOptions.problem(what .. " has no field \"" .. tostring(field) .. "\" (it takes " .. fieldList(fields) .. ")")
        elseif not ("/" .. kinds .. "/"):find("/" .. type(value) .. "/", 1, true) then
            elementOptions.problem(what .. ": " .. field .. " should be " .. kinds:gsub("/", " or ") .. ", not " .. type(value))
        else
            checked[field] = value
        end
    end
    for _, field in ipairs(required or {}) do
        if checked[field] == nil then
            elementOptions.problem(what .. " needs " .. field .. " = ...")
            return nil
        end
    end
    return checked
end

--- Checks an element's section and name before it is built. Returns true when both are usable.
function elementOptions.ready(element, section, name)
    if type(name) ~= "string" or name == "" then
        elementOptions.problem(element .. "() needs a name, e.g. br.ui:" .. element .. "(section, \"Name\", { ... })")
        return false
    end
    if type(section) ~= "table" then
        elementOptions.problem(element .. " \"" .. name .. "\" needs a section first, e.g. local section = br.ui:section(\"General\")")
        return false
    end
    return true
end

-- A stand-in for a widget while recording: GetParent is UIParent (the top of the frame tree), other
-- Get... methods return 0 (sizes the element code does arithmetic with), any other field reads as
-- another stand-in and calling one does nothing, so the element code runs without building frames
local function zero() return 0 end
local function topParent() return br._G.UIParent end
local inertMeta
inertMeta = {
    __index = function(t, k)
        local v
        if k == "GetParent" then
            v = topParent
        elseif type(k) == "string" and k:sub(1, 3) == "Get" then
            v = zero
        else
            v = setmetatable({}, inertMeta)
        end
        rawset(t, k, v)
        return v
    end,
    __call = function() return nil end,
}
local function inertWidget(kind)
    return setmetatable({ type = kind, settings = { contentPadding = { 0, 0, 0, 0 } }, children = {} }, inertMeta)
end

--- Runs fn with br.ui.recording set and the widget library handing out stand-ins instead of frames.
-- Options still register their page and default and fill in missing settings, exactly as when they
-- are shown; nothing is drawn. Returns ok, error like pcall.
function elementOptions.withoutFrames(fn)
    local DiesalGUI = br._G.LibStub("DiesalGUI-1.0")
    local DiesalStyle = br._G.LibStub("DiesalStyle-1.0")
    local create, styleTexture = DiesalGUI.Create, DiesalStyle.StyleTexture
    DiesalGUI.Create = function(_, kind) return inertWidget(kind) end
    -- Styling works on real textures; the stand-ins have none
    DiesalStyle.StyleTexture = function() end
    br.ui.recording = true
    local ok, err = pcall(fn)
    br.ui.recording = nil
    DiesalGUI.Create, DiesalStyle.StyleTexture = create, styleTexture
    return ok, err
end
