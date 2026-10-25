local DiesalGUI = _G.LibStub("DiesalGUI-1.0")
local DiesalTools = _G.LibStub("DiesalTools-1.0")
local _, br = ...

-- Puts an arrow icon on a page arrow button. Tries, in order, cell (column, 5) of the DiesalGUIcons
-- sheet (only loads where BR's Media is installed, see README), then the game's own page
-- arrows; the client reports a file that didn't load as GetTexture() == nil. A plain texture on the
-- button frame: buttons are pooled, so it is kept and reused, and br.ui:createButton hides it.
local function setArrowIcon(button, column, gameIcons)
    local icon = button.arrowIcon or button.frame:CreateTexture(nil, "OVERLAY")
    icon:SetSize(16, 16)
    icon:ClearAllPoints()
    icon:SetPoint("CENTER", 0, 0)
    -- DiesalStyle's current paths for the sheet (LibSharedMedia keeps the first path it was given,
    -- from before BR sets the media path)
    local sheets = br.game.LibStub("DiesalStyle-1.0"):GetMedia("texture", "DiesalGUIcons")
    if type(sheets) ~= "table" then sheets = { sheets } end
    local loaded = false
    for _, sheet in ipairs(sheets) do
        icon:SetTexture(sheet)
        if icon:GetTexture() ~= nil then
            icon:SetTexCoord(DiesalTools.GetIconCoords(column, 5, 16, 256, 128))
            loaded = true
            break
        end
    end
    if not loaded then
        icon:SetTexCoord(0, 1, 0, 1)
        for _, file in ipairs(gameIcons) do
            icon:SetTexture(file)
            if icon:GetTexture() ~= nil then break end
        end
    end
    icon:SetAlpha(.7)
    icon:Show()
    button.arrowIcon = icon
end

-- Right Arrow
function br.ui:createRightArrow(window)
    local rArr = DiesalGUI:Create("Button")
    rArr:SetParent(window.parent.header)
    setArrowIcon(rArr, 7, { "Interface\\Buttons\\UI-SpellbookIcon-NextPage-Up", "Interface\\Buttons\\Arrow-Right-Up" })
    rArr.settings.width = 20
    rArr.settings.height = 20
    rArr.settings.disabled = false
    rArr:SetPoint("TOPRIGHT", 0, 0)
    -- rArr:SetSettings({
    --     width           = 20,
    --     height          = 20,
    --     disabled        = false,
    -- },true)
    rArr:SetEventListener(
        "OnEnter",
        function()
            br.game.GameTooltip:SetOwner(rArr.frame, "ANCHOR_TOPLEFT", 0, 2)
            br.game.GameTooltip:AddLine("Next")
            br.game.GameTooltip:Show()
        end
    )
    rArr:SetEventListener(
        "OnLeave",
        function()
            br.game.GameTooltip:Hide()
        end
    )
    rArr:SetEventListener(
        "OnClick",
        function()
            local page = window.currentPage
            if page then
                -- br.data.settings[br.loader.selectedSpec][window] = page
                if page + 1 > #window.pages then
                    window.pageDD:SetValue(1)
                else
                    window.pageDD:SetValue(page + 1)
                end
            end
        end
    )
    rArr:ApplySettings()
    window.parent:AddChild(rArr)
end

-- Left Arrow
function br.ui:createLeftArrow(window)
    local lArr = DiesalGUI:Create("Button")
    lArr:SetParent(window.parent.header)
    lArr:SetPoint("TOPLEFT", 0, 0)
    lArr:SetSettings(
        {
            width = 20,
            height = 20,
            disabled = false
        },
        true
    )
    setArrowIcon(lArr, 8, { "Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Up", "Interface\\Buttons\\Arrow-Left-Up" })
    lArr:SetEventListener(
        "OnEnter",
        function()
            br.game.GameTooltip:SetOwner(lArr.frame, "ANCHOR_TOPLEFT", 0, 2)
            br.game.GameTooltip:AddLine("Previous")
            br.game.GameTooltip:Show()
        end
    )
    lArr:SetEventListener(
        "OnLeave",
        function()
            br.game.GameTooltip:Hide()
        end
    )
    lArr:SetEventListener(
        "OnClick",
        function()
            local page = window.currentPage
            if page then
                -- br.data.settings[br.loader.selectedSpec][window] = page
                if page - 1 == 0 then
                    window.pageDD:SetValue(#window.pages)
                else
                    window.pageDD:SetValue(page - 1)
                end
            end
        end
    )
    window.parent:AddChild(lArr)
end
