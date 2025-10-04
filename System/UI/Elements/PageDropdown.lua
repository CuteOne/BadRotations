local DiesalGUI = _G.LibStub("DiesalGUI-1.0")
local _, br = ...
-- Dropdown for pages
-- todo: save last active page and restore
function br.ui:createPagesDropdown(window, menuPages)
    local data = br.data.settings[br.loader.selectedSpec][br.loader.selectedProfile]
    data["PageList"] = br.data.settings[br.loader.selectedSpec][br.loader.selectedProfile]["PageList"] or {}
    if br.data.ui == nil then br.data.ui = {} end
    br.data.ui["PageList"] = br.data.ui["PageList"] or {}
    window.pages = menuPages
    window.pageDD = DiesalGUI:Create("Dropdown")
    local newDropdown = window.pageDD
    newDropdown:SetParent(window.parent.header)
    newDropdown.settings.width = 150
    newDropdown:SetPoint("CENTER", 0, 0)

    -- Get pagename and set the list
    -- window.pages = { {[1] = PAGE_NAME, [2] = PAGE_FUNCTION}, { ....} }
    local pageNames = {}
    for i = 1, #window.pages do
        local page = window.pages[i]
        local pageName = page[1]
        br._G.tinsert(pageNames, page[1])
        local foundPage = false
        for i = 1, #data["PageList"] do
            local thisPage = data["PageList"][i]
            if thisPage == pageName then
                foundPage = true
                return
            end
        end
        if not foundPage then
            br._G.tinsert(data["PageList"], pageName)
            br._G.tinsert(br.data.ui["PageList"], pageName)
        end
        -- window.pageDD:SetValue(page - 1)
    end
    newDropdown:SetList(pageNames)


    newDropdown:SetEventListener(
        "OnValueChanged",
        function(this, event, key, value, selection)
            window:ReleaseChildren()
            window.currentPage = key
            window.currentPageName = value
            if key ~= nil then
                window.pages[key][2]()
            end
            --Print(key.." - "..tostring(value))
            br.data.settings[br.loader.selectedSpec][br.loader.selectedProfile]["currentPage"] = window.currentPage
            br.data.settings[br.loader.selectedSpec][br.loader.selectedProfile]["totalPages"] = #window.pages
            br.data.ui["currentPage"] = window.currentPage
            br.data.ui["totalPages"] = #window.pages
        end
    )
    if br.data.settings[br.loader.selectedSpec][br.loader.selectedProfile] == nil or
        br.data.settings[br.loader.selectedSpec][br.loader.selectedProfile]["currentPage"] == nil
    then
        newDropdown:SetValue(1)
    else
        for i = 1, #data["PageList"] do
            newDropdown:SetValue(i)
        end
        newDropdown:SetValue(br.data.settings[br.loader.selectedSpec][br.loader.selectedProfile]["currentPage"])
    end
    newDropdown:ApplySettings()
    window.parent:AddChild(newDropdown)
end
