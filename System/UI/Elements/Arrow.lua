local DiesalGUI = LibStub("DiesalGUI-1.0")

-- Right Arrow
function br.ui:createRightArrow(window)
    local rArr = DiesalGUI:Create('Button')
    rArr:SetParent(window.parent.header)
    rArr:SetStyle('frame',br.ui.arrowRight)
    rArr.settings.width = 20
    rArr.settings.height = 20
    rArr.settings.disabled = false
    rArr:SetPoint('TOPRIGHT',0,0)
    -- rArr:SetSettings({
    --     width           = 20,
    --     height          = 20,
    --     disabled        = false,
    -- },true)
    rArr:SetEventListener('OnEnter',     function()
        GameTooltip:SetOwner(rArr.frame, "ANCHOR_TOPLEFT",0,2)
        GameTooltip:AddLine('Next')
        GameTooltip:Show()
    end)
    rArr:SetEventListener('OnLeave', function()
        GameTooltip:Hide()
    end)
    rArr:SetEventListener('OnClick', function()
        local page = window.currentPage
        if page then
            if page+1 > #window.pages  then
                window.pageDD:SetValue(1)
            else
                window.pageDD:SetValue(page+1)
            end
        end
    end)
    rArr:ApplySettings()
    window.parent:AddChild(rArr)
end
-- Left Arrow
function br.ui:createLeftArrow(window)
    local lArr = DiesalGUI:Create('Button')
    lArr:SetParent(window.parent.header)
    lArr:SetPoint('TOPLEFT',0,0)
    lArr:SetSettings({
        width           = 20,
        height          = 20,
        disabled        = false,
    },true)
    lArr:SetStyle('frame',br.ui.arrowLeft)
    lArr:SetEventListener('OnEnter',     function()
        GameTooltip:SetOwner(lArr.frame, "ANCHOR_TOPLEFT",0,2)
        GameTooltip:AddLine('Previous')
        GameTooltip:Show()
    end)
    lArr:SetEventListener('OnLeave', function()
        GameTooltip:Hide()
    end)
    lArr:SetEventListener('OnClick', function()
        local page = window.currentPage
        if page then
            if page-1 == 0  then
                window.pageDD:SetValue(#window.pages)
            else
                window.pageDD:SetValue(page-1)
            end
        end
    end)
    window.parent:AddChild(lArr)
end