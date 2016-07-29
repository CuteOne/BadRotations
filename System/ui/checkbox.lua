-- creates a checkbox with current UI settings at location within parent
-- createCheckBox("options",thisOption,(xpos+7),(ypos*-27)-10)
function createCheckBox(parent,value,x,y,checkState)
	local name = value.name
	if _G[parent..name.."Check"] == nil then
		if bb.data.options[bb.selectedSpec] then
			if bb.data.options[bb.selectedSpec][name.."Check"] == nil then
				if value.base == 1 then
					bb.data.options[bb.selectedSpec][name.."Check"] = 1
				end
			end
		end
		local scale = bb.data.BadBoyUI.optionsFrame.scale or 1
		local tip = value.tip
		_G[parent..name.."Check"] = CreateFrame("Button", _G[parent..name.."Check"], _G[parent.."Frame"])
		_G[parent..name.."Check"]:SetAlpha(bb.data.BadBoyUI.alpha)
		_G[parent..name.."Check"]:SetWidth(22*scale)
		_G[parent..name.."Check"]:SetHeight(22*scale)
		_G[parent..name.."Check"]:SetPoint("TOPLEFT",x*scale,y*scale)
		_G[parent..name.."Check"]:RegisterForClicks("AnyUp")
		_G[parent..name.."Check"].texture = _G[parent..name.."Check"]:CreateTexture(_G[parent..name.."Texture"],"ARTWORK",_G[parent..name.."Frame"])
		_G[parent..name.."Check"].texture:SetAllPoints()
		_G[parent..name.."Check"].texture:SetBlendMode("BLEND")
		if bb.data.options[bb.selectedSpec] and bb.data.options[bb.selectedSpec][name.."Check"] == 1 then
			_G[parent..name.."Check"].texture:SetTexture(125/255,125/255,125/255,1)
		else
			if state == 1 then
				_G[parent..name.."Check"].texture:SetTexture(125/255,125/255,125/255,1)
			else
				_G[parent..name.."Check"].texture:SetTexture(45/255,45/255,45/255,1)
			end
		end
		_G[parent..name.."Check"].texture:SetWidth(22*scale)
		_G[parent..name.."Check"].texture:SetHeight(22*scale)
		-- varDir = bb.data.BadBoyUI.optionsFrames.options.enemiesEngine
		_G[parent..name.."Check"]:SetScript("OnClick", function()
			if bb.data.options[bb.selectedSpec][name.."Check"] == 1 then
				bb.data.options[bb.selectedSpec][name.."Check"] = 0
				ChatOverlay("|cFFED0000"..name.." Disabled")
				_G[parent..name.."Check"].texture:SetTexture(45/255,45/255,45/255,1)
			else
				bb.data.options[bb.selectedSpec][name.."Check"] = 1
				ChatOverlay("|cff15FF00"..name.." Enabled")
				_G[parent..name.."Check"].texture:SetTexture(200/255,200/255,200/255,1)
			end
			frameCheck(name)
		end )
		_G[parent..name.."Check"]:SetScript("OnEnter", function(self)
			_G[parent..name.."Check"].texture:SetTexture(200/255,200/255,200/255,1)
			GameTooltip:SetOwner(self, "BOTTOMLEFT", 225, 5)
			if tip ~= nil then
				GameTooltip:SetText(tip, nil, nil, nil, nil, true)
			else
				GameTooltip:SetText("|cff15FF00Enables|cffFFFFFF/|cffD60000Disable \n|cffFFFFFF"..name.."|cffFFBB00.", nil, nil, nil, nil, true)
			end
			GameTooltip:Show()
		end)
		_G[parent..name.."Check"]:SetScript("OnLeave", function(self)
			if bb.data.options[bb.selectedSpec] and bb.data.options[bb.selectedSpec][name.."Check"] == 1 then
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
		if bb.data.options[bb.selectedSpec] and bb.data.options[bb.selectedSpec][name.."Check"] == 1 then
			_G["debugFrame"]:Show()
		else
			_G["debugFrame"]:Hide()
		end
	end
end
