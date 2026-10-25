local DiesalGUI = _G.LibStub("DiesalGUI-1.0")
local _, br = ...
function br.ui:createSection(parent, sectionName, tooltip)
    local newSection = DiesalGUI:Create("AccordianSection")

    newSection:SetParentObject(parent)
    newSection:ClearAllPoints()
    -- Calculate Position
    if #parent.children == nil then
        newSection.settings.position = 1
    else
        newSection.settings.position = #parent.children + 1
    end
    newSection.settings.sectionName = sectionName
    -- Storage key for this section's options. Bot Options and Base Options sections are prefixed
    -- so their pages can't collide with a rotation's own pages (and are saved to their own files).
    local prefix = ""
    if parent == br.ui.window.config then
        prefix = "Bot Options/"
    elseif br.ui.sectionStoragePrefix then
        prefix = br.ui.sectionStoragePrefix
    end
    local storageName = prefix .. sectionName
    newSection.settings.storageName = storageName
    if br.data.settings[br.loader.selectedSpec][br.loader.selectedProfile] == nil then
        br.data.settings[br.loader.selectedSpec][br.loader.selectedProfile] = {}
    end
    newSection.settings.expanded =
        br.data.settings[br.loader.selectedSpec][br.loader.selectedProfile][storageName .. " Section"] or true
    br.data.ui[storageName .. " Section"] = newSection.settings.expanded
    -- Recording (elementOptions.withoutFrames): the settings above are all that's needed
    if br.ui.recording then return newSection end
    -- newSection.settings.contentPadding = {0,0,12,32}

    newSection:SetEventListener(
        "OnStateChange",
        function(this, event)
            br.data.settings[br.loader.selectedSpec][br.loader.selectedProfile][storageName .. " Section"] =
                newSection.settings.expanded
            br.data.ui[storageName .. " Section"] = newSection.settings.expanded
        end
    )
    if tooltip then br.ui.elementOptions.cursorTooltip(newSection, tooltip) end

    newSection:ApplySettings()

    newSection["UpdateHeight"] = function(self)
        local settings, children = self.settings, self.children
        local contentHeight = 0
        self.content:SetPoint("TOPLEFT", self.frame, 0, settings.button and -settings.buttonHeight or 0)

        if settings.expanded then
            contentHeight = settings.contentPadding[3] + settings.contentPadding[4]
            for _, child in ipairs(children) do
                if child.type ~= "Spinner" and child.type ~= "Dropdown" then
                    contentHeight = contentHeight + child.frame:GetHeight() * 1.2
                end
            end
        end
        self.content:SetHeight(contentHeight)
        self:SetHeight((settings.button and settings.buttonHeight or 0) + contentHeight)
        self:FireEvent("OnHeightChange", contentHeight)
    end

    newSection:UpdateHeight()

    parent:AddChild(newSection)

    return newSection
end

-- Restore last saved state of section (collapsed or expanded)
function br.ui:checkSectionState(section)
    local state = br.data.settings[br.loader.selectedSpec][br.loader.selectedProfile][(section.settings.storageName or section.settings.sectionName) .. " Section"]


    if state then
        section:Expand()
        section:UpdateHeight(section)
    else
        section:Collapse()
    end
end

-- The section br.ui:section made last; closed when the next one starts or its page is done
local openSection

---@class br.ui.SectionOptions
---@field tip? string Tooltip for the section's title
---@field window? table The window to add it to (br.ui.window.profile)

-- The type each field takes, for elementOptions.check
---@type table<string, string>
local SECTION_FIELDS = { tip = "string", window = "table" }

--- Adds a collapsible section and returns it, to pass to br.ui:checkbox, br.ui:spinner, ... and to
--- module calls. The previous section's collapsed/expanded state is restored when this one starts.
---@param name string The section's title
---@param options? br.ui.SectionOptions
---@return table? section Nil when the name or options are wrong
function br.ui:section(name, options)
    local elementOptions = br.ui.elementOptions
    if type(name) ~= "string" or name == "" then
        return elementOptions.problem("section() needs a name first, e.g. br.ui:section(\"Defensive\")")
    end
    options = elementOptions.check("section \"" .. name .. "\"", options, SECTION_FIELDS)
    if options == nil then return end
    br.ui:closeSection()
    openSection = br.ui:createSection(options.window or br.ui.window.profile, name, elementOptions.white(options.tip))
    return openSection
end

--- Restores the collapsed/expanded state of the section br.ui:section made last.
function br.ui:closeSection()
    if openSection then
        br.ui:checkSectionState(openSection)
        openSection = nil
    end
end
