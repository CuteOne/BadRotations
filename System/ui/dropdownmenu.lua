-- i will need to make tables of values.
function createDropDownMenu(parent,option,x,y,textString)
    local value,tip,dropdown,dropOptions = option.name,option.dropTip,option.dropdown,option.dropOptions
    local currentValue = 1
    if BadBoy_data.options[GetSpecialization()] then
        currentValue = BadBoy_data.options[GetSpecialization()][value.."Drop"]
    end
    local textString = option.name
    if tip == "Toggle2" then
        tip = "|cffFFFFFFSet which button you want as toggle for \n"..textString.."."
        dropOptions = {"|cffFFBB00LeftCtrl","|cffFFBB00LeftShift","|cffFFBB00LeftAlt","|cffFFBB00RightCtrl","|cffFFBB00RightShift","|cffFFBB00RightAlt","|cffFFBB00MMouse","|cffFFBB00Mouse4","|cffFFBB00Mouse5","|cffFFBB00None"}
    end
    if tip == "Toggle" then
        tip = "|cffFFFFFFSet which button you want as toggle for \n"..textString.."."
        dropOptions = {"|cffFFBB00LeftCtrl","|cffFFBB00LeftShift","|cffFFBB00RightCtrl","|cffFFBB00RightShift","|cffFFBB00RightAlt","|cffFFBB00None"}
    end
    if tip == "CD" then
        tip = "|cffFFFFFFSets how you want this Cooldown to react. \n|cffD60000Never = Never use this CD. \n|cffFFBB00CDs = Use this CD when ActiveCooldowns Enabled. \n|cff15FF00Always = Always use this CD."
        dropOptions = {"|cffFF0000Never","|cffFFDD11CDs","|cff00FF00Always"}
    end
    if tip == "Auto" then
        tip = "|cffFFFFFFSets how you want this Ability to react."
        dropOptions = {"|cffD60000Off","|cffFFBB00Auto","|cff15FF00On"}
    end
    -- when a new dropbox is created
    -- create the main button that will trigger the frame that will hold values
    local scale = BadBoy_data.BadBoyUI.optionsFrame.scale or 1
    _G[parent..value.."Drop"] = CreateFrame("Button", _G[parent..value.."Drop"], _G[parent.."Frame"])
    _G[parent..value.."Drop"]:SetWidth(75*scale)
    _G[parent..value.."Drop"]:SetHeight(22*scale)
    _G[parent..value.."Drop"]:SetPoint("TOPLEFT",x*scale,y*scale)
    _G[parent..value.."Drop"]:SetAlpha(BadBoy_data.BadBoyUI.alpha)
    -- texture part
    _G[parent..value.."Drop"].texture = _G[parent..value.."Drop"]:CreateTexture(_G[parent..value.."Drop"],"ARTWORK",_G[parent..value.."Frame"])
    _G[parent..value.."Drop"].texture:SetAllPoints()
    _G[parent..value.."Drop"].texture:SetTexture((BadBoy_data.BadBoyUI.optionsFrame.color.r + 25)/255,(BadBoy_data.BadBoyUI.optionsFrame.color.g + 25)/255,(BadBoy_data.BadBoyUI.optionsFrame.color.b + 25)/255,BadBoy_data.BadBoyUI.optionsFrame.color.a)
    _G[parent..value.."Drop"].texture:SetBlendMode("BLEND")
    _G[parent..value.."Drop"].texture:SetWidth(75*scale)
    _G[parent..value.."Drop"].texture:SetHeight(22*scale)
    -- click event
    _G[parent..value.."Drop"]:SetScript("OnClick", function(self)
        if openedDropDown ~= nil and openedDropDown.value ~= value then
            clearDropsDowns()
        end
        -- on click show childs and set button white
        for i = 1, #dropOptions do
            if _G[value..dropOptions[i].."DropChild"] ~= nil and _G[value..dropOptions[i].."DropChild"]:IsShown() then
                _G[value..dropOptions[i].."DropChild"]:Hide()
            elseif _G[value..dropOptions[i].."DropChild"] ~= nil then
                _G[value..dropOptions[i].."DropChild"]:Show()
            end
        end
        openedDropDown = { parent = parent, value = value, options = dropOptions }
    end)
    -- hover event
    _G[parent..value.."Drop"]:SetScript("OnEnter", function(self)
        -- set button gray
        GameTooltip:SetOwner(self,"BOTTOMRIGHT",225,5)
        if tip ~= nil then
            GameTooltip:SetText(tip, nil, nil, nil, nil, true)
        else
            GameTooltip:SetText("|cffFFFFFFSelect option for \n|cffFFFFFF"..value.."|cffFFBB00.", nil, nil, nil, nil, true)
        end
        GameTooltip:Show()
        _G[parent..value.."Drop"].texture:SetTexture((BadBoy_data.BadBoyUI.optionsFrame.color.r + 75)/255,(BadBoy_data.BadBoyUI.optionsFrame.color.g + 75)/255,(BadBoy_data.BadBoyUI.optionsFrame.color.b + 75)/255,BadBoy_data.BadBoyUI.optionsFrame.color.a)
    end)
    -- leave event
    _G[parent..value.."Drop"]:SetScript("OnLeave", function(self)
        -- reset button to addon color
        _G[parent..value.."Drop"].texture:SetTexture((BadBoy_data.BadBoyUI.optionsFrame.color.r + 25)/255,(BadBoy_data.BadBoyUI.optionsFrame.color.g + 25)/255,(BadBoy_data.BadBoyUI.optionsFrame.color.b + 25)/255,BadBoy_data.BadBoyUI.optionsFrame.color.a)
        --GameTooltip:Hide()
        -- we need to start a timer and if next second cursor isnt on a child, we clear it
    end)
    -- text
    _G[parent..value.."DropText"] = _G[parent..value.."Drop"]:CreateFontString(_G[parent..value.."Text"],"ARTWORK")
    _G[parent..value.."DropText"]:SetWidth(75*scale)
    _G[parent..value.."DropText"]:SetHeight(22*scale)
    _G[parent..value.."DropText"]:SetPoint("TOPLEFT",0,-2)
    _G[parent..value.."DropText"]:SetAlpha(BadBoy_data.BadBoyUI.alpha)
    _G[parent..value.."DropText"]:SetJustifyH("CENTER")
    _G[parent..value.."DropText"]:SetFont(BadBoy_data.BadBoyUI.font,BadBoy_data.BadBoyUI.fontsize*scale,"THICKOUTLINE")
    -- assign the actually selected value to the option
    local textDisplay
    if BadBoy_data.options[GetSpecialization()] then
        if dropOptions[BadBoy_data.options[GetSpecialization()][value.."Drop"]] ~= nil then
            textDisplay = dropOptions[BadBoy_data.options[GetSpecialization()][value.."Drop"]]
        end
    end
    _G[parent..value.."DropText"]:SetText(textDisplay,nil,nil,nil,nil,false)
    -- create all options in the frame as layered buttons
    -- build common options frame that will "hold" childs
    _G[parent..value.."DropFrame"] = CreateFrame("Frame","Options",_G[parent..value.."Drop"])
    _G[parent..value.."DropFrame"]:SetPoint("TOPLEFT",0,-24)
    _G[parent..value.."DropFrame"]:SetWidth(75*scale)
    _G[parent..value.."DropFrame"]:SetHeight(22*scale)
    _G[parent..value.."DropFrame"]:SetClampedToScreen(true)
    _G[parent..value.."DropFrame"]:SetScript("OnUpdate",configFrame_OnUpdate)
    _G[parent..value.."DropFrame"]:EnableMouse(true)
    _G[parent..value.."DropFrame"]:SetMovable(true)
    _G[parent..value.."DropFrame"]:RegisterForDrag("LeftButton")
    _G[parent..value.."DropFrame"]:SetScript("OnDragStart",_G[parent.."Frame"].StartMoving)
    _G[parent..value.."DropFrame"]:SetScript("OnDragStop",_G[parent.."Frame"].StopMovingOrSizing)
    -- generate the childs
    for i = 1, #dropOptions do
        createDropDownChild(parent,value,dropOptions[i],0,-24*i,i,dropOptions,tip)
    end
    -- hide childs
    for i = 1, #dropOptions do
        if _G[value..dropOptions[i].."DropChild"] ~= nil and _G[value..dropOptions[i].."DropChild"]:IsShown() then
            _G[value..dropOptions[i].."DropChild"]:Hide()
        end
    end
    -- hide childs frame
    _G[parent..value.."DropFrame"]:Hide()
end

function createDropDownChild(grandParent,parent,value,x,y,tag,dropOptions,tip)
    local scale = BadBoy_data.BadBoyUI.optionsFrame.scale or 1
    _G[parent..value.."DropChild"] = CreateFrame("Button", _G[parent..value.."DropChild"], _G[grandParent..parent.."Drop"])
    _G[parent..value.."DropChild"]:SetWidth(75*scale)
    _G[parent..value.."DropChild"]:SetHeight(22*scale)
    _G[parent..value.."DropChild"]:SetPoint("TOPLEFT",x*scale,y*scale)
    _G[parent..value.."DropChild"]:SetAlpha(BadBoy_data.BadBoyUI.alpha)
    -- texture part
    _G[parent..value.."DropChild"].texture = _G[parent..value.."DropChild"]:CreateTexture(_G[parent..value.."Texture"],"ARTWORK",_G[parent..value.."Frame"])
    _G[parent..value.."DropChild"].texture:SetAllPoints()
    _G[parent..value.."DropChild"].texture:SetTexture((BadBoy_data.BadBoyUI.optionsFrame.color.r - 25)/255,(BadBoy_data.BadBoyUI.optionsFrame.color.g - 25)/255,(BadBoy_data.BadBoyUI.optionsFrame.color.b - 25)/255,BadBoy_data.BadBoyUI.optionsFrame.color.a)
    _G[parent..value.."DropChild"].texture:SetBlendMode("BLEND")
    _G[parent..value.."DropChild"].texture:SetWidth(75*scale)
    _G[parent..value.."DropChild"].texture:SetHeight(22*scale)
    -- click event
    _G[parent..value.."DropChild"]:SetScript("OnClick", function(self)
        -- on click child frame select value
        if BadBoy_data.options[GetSpecialization()][parent.."Drop"] ~= tag then
            BadBoy_data.options[GetSpecialization()][parent.."Drop"] = tag
        end
        -- we need to hide childs
        for i = 1, #dropOptions do
            if _G[parent..dropOptions[i].."DropChild"] ~= nil and _G[parent..dropOptions[i].."DropChild"]:IsShown() then
                _G[parent..dropOptions[i].."DropChild"]:Hide()
            end
        end
        -- refresh button tag
        local textDisplay = dropOptions[tag]
        _G[grandParent..parent.."DropText"]:SetText(textDisplay,nil,nil,nil,nil,false)
    end)
    -- hover event
    _G[parent..value.."DropChild"]:SetScript("OnEnter",function(self)
        -- set button gray
        _G[parent..value.."DropChild"].texture:SetTexture(175/255,175/255,175/255,BadBoy_data.BadBoyUI.optionsFrame.color.a)
        GameTooltip:SetOwner(self,"BOTTOMRIGHT",225,5)
        if tip ~= nil then
            GameTooltip:SetText(tip, nil, nil, nil, nil, true)
        else
            GameTooltip:SetText("|cffFFFFFFSelect option for \n|cffFFFFFF"..parent.."|cffFFBB00.", nil, nil, nil, nil, true)
        end
        GameTooltip:Show()

    end)
    -- leave event
    _G[parent..value.."DropChild"]:SetScript("OnLeave",function(self)
        -- reset button to addon color
        _G[parent..value.."DropChild"].texture:SetTexture((BadBoy_data.BadBoyUI.optionsFrame.color.r - 25)/255,(BadBoy_data.BadBoyUI.optionsFrame.color.g - 25)/255,(BadBoy_data.BadBoyUI.optionsFrame.color.b - 25)/255,BadBoy_data.BadBoyUI.optionsFrame.color.a)
        --GameTooltip:Hide()
    end)
    -- text
    _G[parent..value.."TextChild"] = _G[parent..value.."DropChild"]:CreateFontString(_G[parent..value.."TextChild"],"ARTWORK")
    _G[parent..value.."TextChild"]:SetWidth(75*scale)
    _G[parent..value.."TextChild"]:SetHeight(24*scale)
    _G[parent..value.."TextChild"]:SetPoint("TOPLEFT",0,0)
    _G[parent..value.."TextChild"]:SetAlpha(BadBoy_data.BadBoyUI.alpha)
    _G[parent..value.."TextChild"]:SetJustifyH("CENTER")
    _G[parent..value.."TextChild"]:SetFont(BadBoy_data.BadBoyUI.font,BadBoy_data.BadBoyUI.fontsize*scale,"THICKOUTLINE")
    _G[parent..value.."TextChild"]:SetText(value, nil, nil, nil, nil, false)
end


function clearDropsDowns()
    if openedDropDown ~= nil then
        local dropOptions = openedDropDown.options
        local value = openedDropDown.value
        local parent = openedDropDown.parent
        -- cycle saved drop info
        for i = 1, #dropOptions do
            if _G[value..dropOptions[i].."DropChild"] ~= nil and _G[value..dropOptions[i].."DropChild"]:IsShown() then
                _G[value..dropOptions[i].."DropChild"]:Hide()
            end
        end
        -- clear temp
        openedDropDown = nil
        GameTooltip:Hide()
    end
end