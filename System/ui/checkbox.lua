-- creates a checkbox with current UI settings at location within parent
function createCheckBox(parent,name,x,y,state)
    if _G[parent..name.."Check"] == nil then
        local scale = BadBoy_data.BadBoyUI.optionsFrame.scale or 1
        local state
        if name ~= nil then
            if BadBoy_data.options[GetSpecialization()] then
                state = BadBoy_data.options[GetSpecialization()][name.."Check"] or 0
            end
        end

        _G[parent..name.."Check"] = CreateFrame("Button", _G[parent..name.."Check"], _G[parent.."Frame"])
        _G[parent..name.."Check"]:SetAlpha(BadBoy_data.BadBoyUI.alpha)
        _G[parent..name.."Check"]:SetWidth(22*scale)
        _G[parent..name.."Check"]:SetHeight(22*scale)
        _G[parent..name.."Check"]:SetPoint("TOPLEFT",x*scale,y*scale)
        _G[parent..name.."Check"]:RegisterForClicks("AnyUp")

        _G[parent..name.."Check"].texture = _G[parent..name.."Check"]:CreateTexture(_G[parent..name.."Texture"],"ARTWORK",_G[parent..name.."Frame"])
        _G[parent..name.."Check"].texture:SetAllPoints()
        _G[parent..name.."Check"].texture:SetBlendMode("BLEND")
        if BadBoy_data.options[GetSpecialization()] and BadBoy_data.options[GetSpecialization()][name.."Check"] == 1 then
            _G[parent..name.."Check"].texture:SetTexture(125/255,125/255,125/255,1)
        else
            _G[parent..name.."Check"].texture:SetTexture(45/255,45/255,45/255,1)
        end
        _G[parent..name.."Check"].texture:SetWidth(22*scale)
        _G[parent..name.."Check"].texture:SetHeight(22*scale)


               -- varDir = BadBoy_data.BadBoyUI.optionsFrames.options.enemiesEngine

        _G[parent..name.."Check"]:SetScript("OnClick", function()
            if BadBoy_data.options[GetSpecialization()][name.."Check"] == 1 then
                BadBoy_data.options[GetSpecialization()][name.."Check"] = 0
                ChatOverlay("|cFFED0000"..name.." Disabled")
                _G[parent..name.."Check"].texture:SetTexture(45/255,45/255,45/255,1)
            else
                BadBoy_data.options[GetSpecialization()][name.."Check"] = 1
                ChatOverlay("|cff15FF00"..name.." Enabled")
                _G[parent..name.."Check"].texture:SetTexture(125/255,125/255,125/255,1)
            end
            frameCheck(name)
        end )

        _G[parent..name.."Check"]:SetScript("OnEnter", function(self)
            _G[parent..name.."Check"].texture:SetTexture(200/255,200/255,200/255,1)
            GameTooltip:SetOwner(self, "BOTTOMLEFT", 225, 5)
            if tip1 ~= nil then
                if tip1 == "Normal" then
                    GameTooltip:SetText("|cff15FF00Enables|cffFFFFFF/|cffD60000Disable \n|cffFFFFFF"..name.."|cffFFBB00.", nil, nil, nil, nil, true)
                else
                    GameTooltip:SetText(tip1, nil, nil, nil, nil, true)
                end
            else
                GameTooltip:SetText("|cff15FF00Enables|cffFFFFFF/|cffD60000Disable \n|cffFFFFFF"..name.."|cffFFBB00.", nil, nil, nil, nil, true)
            end
            GameTooltip:Show()
        end)
        _G[parent..name.."Check"]:SetScript("OnLeave", function(self)
            if BadBoy_data.options[GetSpecialization()] and BadBoy_data.options[GetSpecialization()][name.."Check"] == 1 then
                _G[parent..name.."Check"].texture:SetTexture(150/255,150/255,150/255,1)
            else
                _G[parent..name.."Check"].texture:SetTexture(45/255,45/255,45/255,1)
            end

            GameTooltip:Hide()
        end)
    end
    -- if spring frame check to display if its one
    frameCheck(name)
end


function frameCheck(name)
    if _G["debugFrame"] ~= nil and name == "Debug Frame" then
        if BadBoy_data.options[GetSpecialization()] and BadBoy_data.options[GetSpecialization()][name.."Check"] == 1 then
            _G["debugFrame"]:Show()
        else
            _G["debugFrame"]:Hide()
        end
    end
end