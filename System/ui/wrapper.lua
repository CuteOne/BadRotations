-- i will look into my existing profile table that was made of the profile options sheet
-- return position of current clicked wrapper
-- return position of the next visible wrapper
-- hide/show all options between these
-- set wrapper on
-- set the options under wrappers to hidden
-- remove number of hidden rows from currentShown
-- refresh display to current shown
-- this function will create a child button at x,y position from the topleft corner.
function createWrapper(parent,value,x,y,wrapperRank)
	if _G[parent..value.."Wrapper"] == nil then
		local scale = BadBoy_data.BadBoyUI.optionsFrame.scale or 1
		_G[parent..value.."Wrapper"] = CreateFrame("Button", _G[parent..value.."Wrapper"], _G[parent.."Frame"])
		_G[parent..value.."Wrapper"]:SetWidth(257*scale)
		_G[parent..value.."Wrapper"]:SetHeight(22*scale)
		_G[parent..value.."Wrapper"]:SetPoint("TOPLEFT",x,y)
		_G[parent..value.."Wrapper"]:SetAlpha(BadBoy_data.BadBoyUI.alpha)
		-- texture part
		_G[parent..value.."Wrapper"].texture = _G[parent..value.."Wrapper"]:CreateTexture(_G[parent..value.."Texture"],"ARTWORK",_G[parent..value.."Frame"])
		_G[parent..value.."Wrapper"].texture:SetAllPoints()
		if BadBoy_data.options[bb.selectedSpec][value.."Wrapper"] == true then
			_G[parent..value.."Wrapper"].texture:SetTexture(100/255,100/255,100/255,BadBoy_data.BadBoyUI.optionsFrame.color.a)
		else
			_G[parent..value.."Wrapper"].texture:SetTexture(60/255,60/255,60/255,BadBoy_data.BadBoyUI.optionsFrame.color.a)
		end
		_G[parent..value.."Wrapper"].texture:SetBlendMode("BLEND")
		_G[parent..value.."Wrapper"].texture:SetWidth(257*scale)
		_G[parent..value.."Wrapper"].texture:SetHeight(22*scale)
		-- click event
		_G[parent..value.."Wrapper"]:SetScript("OnClick",function(self)
			-- if wrapper shown we need to know it
			if BadBoy_data.options[bb.selectedSpec][value.."Wrapper"] ~= true then
				BadBoy_data.options[bb.selectedSpec][value.."Wrapper"] = true
				replaceWraps(parent,value)
			else
				BadBoy_data.options[bb.selectedSpec][value.."Wrapper"] = false
				replaceWraps(parent,value)
			end
		end)
		-- hover event
		_G[parent..value.."Wrapper"]:SetScript("OnEnter",function(self)
			_G[parent..value.."Wrapper"].texture:SetTexture(200/255,200/255,200/255,BadBoy_data.BadBoyUI.optionsFrame.color.a)
		end)
		-- leave event
		_G[parent..value.."Wrapper"]:SetScript("OnLeave",function(self)
			if BadBoy_data.options[bb.selectedSpec][value.."Wrapper"] == true then
				_G[parent..value.."Wrapper"].texture:SetTexture(100/255,100/255,100/255,BadBoy_data.BadBoyUI.optionsFrame.color.a)
			else
				_G[parent..value.."Wrapper"].texture:SetTexture(60/255,60/255,60/255,BadBoy_data.BadBoyUI.optionsFrame.color.a)
			end
		end)
		-- text frame
		_G[parent..value.."Text"] = _G[parent..value.."Wrapper"]:CreateFontString(_G[parent..value.."Text"],"ARTWORK")
		_G[parent..value.."Text"]:SetWidth(257*scale)
		_G[parent..value.."Text"]:SetHeight(22*scale)
		_G[parent..value.."Text"]:SetPoint("TOPLEFT",0,0)
		_G[parent..value.."Text"]:SetAlpha(BadBoy_data.BadBoyUI.alpha)
		_G[parent..value.."Text"]:SetJustifyH("CENTER")
		_G[parent..value.."Text"]:SetFont(BadBoy_data.BadBoyUI.font,BadBoy_data.BadBoyUI.fontsize,"THICKOUTLINE")
		_G[parent..value.."Text"]:SetText(value, nil, nil, nil, nil, false)
	end
end
function hideRow(parent,i)
	local value = BadBoy_data.options[bb.selectedSpec].profile[i].name
	_G[parent..value.."Text"]:Hide()
	if _G[parent..value.."Check"] then
		_G[parent..value.."Check"]:Hide()
	end
	if _G[parent..value.."Status"] then
		_G[parent..value.."Status"]:Hide()
	end
	if _G[parent..value.."Drop"] then
		_G[parent..value.."Drop"]:Hide()
	end
end
function showRow(parent,i)
	local value = BadBoy_data.options[bb.selectedSpec].profile[i].name
	_G[parent..value.."Text"]:Show()
	if _G[parent..value.."Check"] then
		_G[parent..value.."Check"]:Show()
	end
	if _G[parent..value.."Status"] then
		_G[parent..value.."Status"]:Show()
	end
	if _G[parent..value.."Drop"] then
		_G[parent..value.."Drop"]:Show()
	end
end
function replaceRow(parent,ypos,i)
	local scale = BadBoy_data.BadBoyUI.optionsFrame.scale or 1
	local value = BadBoy_data.options[bb.selectedSpec].profile[i].name
	if _G[parent..value.."Wrapper"] then
		_G[parent..value.."Wrapper"]:SetPoint("TOPLEFT",7*scale,((ypos*-(27*scale))+27)*scale)
	end
	if _G[parent..value.."TextFrame"] then
		_G[parent..value.."TextFrame"]:SetPoint("TOPLEFT",35*scale,((ypos*-(27*scale))+27)*scale)
	end
	if _G[parent..value.."Check"] then
		_G[parent..value.."Check"]:SetPoint("TOPLEFT",7*scale,((ypos*-(27*scale))+27)*scale)
	end
	if _G[parent..value.."Status"] then
		_G[parent..value.."Status"]:SetPoint("TOPLEFT",189*scale,((ypos*-(27*scale))+27)*scale)
	end
	if _G[parent..value.."Drop"] then
		_G[parent..value.."Drop"]:SetPoint("TOPLEFT",189*scale,((ypos*-(27*scale))+27)*scale)
	end
end
function replaceWraps(parent)
	currentProfile = BadBoy_data.options[bb.selectedSpec].profile
	local currentProfileName = currentProfile[1].name
	local isShown = true
	local shownRows = 0
	for i = 1, #currentProfile do
		item = currentProfile[i]
		name = currentProfile[i].name
		-- if its a wrapper, never hide it
		-- if its a wrapper when we reach it,
		if isShown == true or currentProfile[i].wrap ~= nil then
			showRow(parent,i)
			shownRows = shownRows + 1
		else
			hideRow(parent,i)
		end
		-- replace all rows
		replaceRow(parent,shownRows,i)
		-- set hidden for next wraps
		if BadBoy_data.options[bb.selectedSpec][name.."Wrapper"] == true then
			isShown = true
		elseif BadBoy_data.options[bb.selectedSpec][name.."Wrapper"] == false then
			isShown = false
		end
	end
	local scale = BadBoy_data.BadBoyUI.optionsFrame.scale or 1
	_G[currentProfileName.."Frame"]:SetHeight(shownRows*(24*scale)+shownRows*0.3)
end
