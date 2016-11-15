-- i want a reusable method to generate common style frames by throwing args.
-- args: name,width,heigth
function frameCreation(name,width,heigth,title)
	if _G[name.."Frame"] == nil then
		-- build frame properties
		if br.data.BadRotationsUI[name.."Frame"] == nil then
			br.data.BadRotationsUI[name.."Frame"] = {
				color = {
					r = 16,
					g = 16,
					b = 16,
					a = 1,
				},
				heigth = 300,
				pos = {
					anchor = "CENTER",
					x = 0,
					y = 0
				},
				width = 200,
				shown = 1,
				scale = 1,
			}
		end
		local anchor,x,y
		local scale = br.data.BadRotationsUI.optionsFrame.scale or 1
		-- build common options frame
		_G[name.."Frame"] = CreateFrame("Frame",name.."Frame",UIParent)
		if br.data.BadRotationsUI[name.."Frame"] ~= nil and br.data.BadRotationsUI[name.."Frame"].pos ~= nil then
			anchor = br.data.BadRotationsUI[name.."Frame"].pos.anchor or "CENTER"
			x = br.data.BadRotationsUI[name.."Frame"].pos.x or -75
			y = br.data.BadRotationsUI[name.."Frame"].pos.y or -200
		else
			anchor = "CENTER"
			x = 75
			y = 200
		end
		x=1
		_G[name.."Frame"]:SetPoint(anchor,x*scale,y*scale)
		_G[name.."Frame"]:SetWidth(width*scale)
		_G[name.."Frame"]:SetHeight(heigth*scale)
		_G[name.."Frame"]:SetClampedToScreen(true)
		_G[name.."Frame"]:SetScript("OnUpdate", configFrame_OnUpdate)
		_G[name.."Frame"]:EnableMouse(true)
		_G[name.."Frame"]:SetMovable(true)
		_G[name.."Frame"]:RegisterForDrag("LeftButton")
		_G[name.."Frame"]:SetScript("OnDragStart",_G[name.."Frame"].StartMoving)
		_G[name.."Frame"]:SetScript("OnDragStop",_G[name.."Frame"].StopMovingOrSizing)
		-- frame texture
		_G[name.."Frame"].texture = _G[name.."Frame"]:CreateTexture(_G[name.."Frame"],"ARTWORK")
		_G[name.."Frame"].texture:SetAllPoints()
		_G[name.."Frame"].texture:SetTexture(br.data.BadRotationsUI[name.."Frame"].color.r/255,br.data.BadRotationsUI[name.."Frame"].color.g/255,br.data.BadRotationsUI[name.."Frame"].color.b/255,br.data.BadRotationsUI[name.."Frame"].color.a)
		_G[name.."Frame"].texture:SetBlendMode("BLEND")
		_G[name.."Frame"].texture:SetWidth(width*scale)
		_G[name.."Frame"].texture:SetHeight(heigth*scale)
		-- frame title
		_G[name.."FrameTitle"] = _G[name.."Frame"]:CreateFontString(debugFrame, "ARTWORK")
		_G[name.."FrameTitle"]:SetFont(br.data.BadRotationsUI.font,br.data.BadRotationsUI.fontsize+1,"THICKOUTLINE")
		_G[name.."FrameTitle"]:SetPoint("TOP",0,-5)
		_G[name.."FrameTitle"]:SetJustifyH("CENTER")
		_G[name.."FrameTitle"]:SetTextColor(225/255, 225/255, 225/255,1)
		_G[name.."FrameTitle"]:SetText(title)
		if br.data.options[br.selectedSpec] and br.data.options[br.selectedSpec][name.."Frame"] == false then
			_G[name.."Frame"]:Hide()
		end
		-- when we roll mouse (delta +1,-1)
		_G[name.."Frame"]:SetScript("OnMouseWheel", function(self, delta)
			--ResizeUI(delta)
			end)
		-- tooltip when we mouseover the frame itself
		_G[name.."Frame"]:SetScript("OnEnter", function(self)
			--GameTooltip:SetOwner(self,"BOTTOMRIGHT",0,5)
			--GameTooltip:SetText("|cffD60000Tests",nil,nil,nil,nil,true)
			--GameTooltip:Show()
			end)
		_G[name.."Frame"]:SetScript("OnLeave", function(self)
			GameTooltip:Hide()
		end)
		_G[name.."Frame"]:SetScript("OnReceiveDrag", function(self)
			local _, _, anchor, x, y = _G[name.."Frame"]:GetPoint(1)
			br.data.BadRotationsUI[name.."Frame"].pos.x = x
			br.data.BadRotationsUI[name.."Frame"].pos.y = y
			br.data.BadRotationsUI[name.."Frame"].pos.anchor = anchor
		end)
		if getOptionCheck("UI Borders") then
			CreateBorder(_G[name.."Frame"],8,0.6,0.6,0.6)
		end
	end
end
