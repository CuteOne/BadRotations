local DiesalGUI = LibStub("DiesalGUI-1.0")

-- Dropdown for pages
-- todo: save last active page and restore
function br.ui:createPagesDropdown(window, menuPages)
    window.pages = menuPages
    window.pageDD = DiesalGUI:Create('Dropdown')
    local newDropdown = window.pageDD
    newDropdown:SetParent(window.parent.header)
    newDropdown.settings.width = 150
    newDropdown:SetPoint('CENTER',0,0)

    -- Get pagename and set the list
    -- window.pages = { {[1] = PAGE_NAME, [2] = PAGE_FUNCTION}, { ....} }
    local pageNames = {}
    for i=1,#window.pages do
        tinsert(pageNames, window.pages[i][1])
    end
    newDropdown:SetList(pageNames)

    newDropdown:SetEventListener('OnValueChanged', function(this, event, key, value, selection)
        window:ReleaseChildren()
        window.currentPage = key
        window.currentPageName = value
        if key ~= nil then
            window.pages[key][2]()
        end
        --Print(key.." - "..tostring(value))
        br.data.settings[br.selectedSpec][br.selectedProfile]["currentPage"] = window.currentPage
    end)
    if br.data.settings[br.selectedSpec][br.selectedProfile] == nil or br.data.settings[br.selectedSpec][br.selectedProfile]["currentPage"] == nil then
        newDropdown:SetValue(1)
    else
        newDropdown:SetValue(br.data.settings[br.selectedSpec][br.selectedProfile]["currentPage"])
    end
    newDropdown:ApplySettings()
    window.parent:AddChild(newDropdown)
end