local _, br = ...
br.queueSpell = false
local queueSpellTime
local queueSpellPos = {x = 0, y = 0, z = 0}
local queueSpellTarget
local smartQueueFrame
local ignoreKeys = {["LALT"] = true, ["LSHIFT"] = true, ["LCTRL"] = true}

local function checkKeys(self, key)
	if br.player ~= nil and br.player.spell ~= nil and br.player.spell.bindings ~= nil and ignoreKeys[key] == nil and br.isChecked("Smart Queue") and br._G.UnitAffectingCombat("player") then
		local pressedKey = ""
		if _G.IsLeftShiftKeyDown() then
			pressedKey = "SHIFT-"
		elseif _G.IsLeftAltKeyDown() then
			pressedKey = "ALT-"
		elseif _G.IsLeftControlKeyDown() then
			pressedKey = "CTRL-"
		end
		pressedKey = pressedKey .. key
		local spell = br.player.spell.bindings[pressedKey]
		if spell ~= nil then
			if _G.GetSpecializationInfo(_G.GetSpecialization()) == 258 and spell == 2061 then spell = 186263 end
			local cd = br.getSpellCD(spell)
			if _G.GetSpellInfo(spell) and cd <= br.getOptionValue("Smart Queue") and br.isChecked(_G.GetSpellInfo(spell) .. " (Queue)") and (cd > 0 or _G.IsUsableSpell(spell) == false or br._G.UnitCastingInfo("player")) then
				br.queueSpell = spell
				queueSpellTime = _G.GetTime()
				if br.getOptionValue(_G.GetSpellInfo(br.queueSpell) .. " (Queue)") == 2 then
					local x, y = br._G.GetMousePosition()
					queueSpellPos.x, queueSpellPos.y, queueSpellPos.z = br._G.ScreenToWorld(x, y)
				elseif br.getOptionValue(_G.GetSpellInfo(br.queueSpell) .. " (Queue)") == 4 and br.GetUnitIsVisible("mouseover") then
					queueSpellTarget = br._G.ObjectPointer("mouseover")
				else
					queueSpellTarget = "target"
				end
				br.ChatOverlay("Queued: " .. _G.GetSpellInfo(br.queueSpell))
			end
		end
	end
end

local function GetKeyBindings()
	local function GetActionbarSlot(slot)
		local name
		if _G.Bartender4 then
			name = "CLICK BT4Button" .. slot .. ":LeftButton"
			if _G.GetBindingKey(name) ~= nil then
				return name
			end
		end
		if _G.Dominos then
			for i = 1, 60 do
				if _G["DominosActionButton" .. i] and _G["DominosActionButton" .. i]["action"] == slot then
					name = "CLICK DominosActionButton" .. i .. ":LeftButton"
					if _G.GetBindingKey(name) ~= nil then
						return name
					end
				end
			end
		end
		local bonusBar = _G.GetBonusBarOffset()
		local slotID = (1 + (_G.NUM_ACTIONBAR_PAGES + bonusBar - 1) * _G.NUM_ACTIONBAR_BUTTONS)
		if (bonusBar == 0 and slot <= 12) or (bonusBar > 0 and slot >= slotID and slot < (slotID + 12)) then
			name = "ACTIONBUTTON" .. (((slot - 1)%12) + 1)
		elseif slot <= 36 then
			name = "MULTIACTIONBAR3BUTTON" .. (slot - 24)
		elseif slot <= 48 then
			name = "MULTIACTIONBAR4BUTTON" .. (slot - 36)
		elseif slot <= 60 then
			name = "MULTIACTIONBAR2BUTTON" .. (slot - 48)
		else
			name = "MULTIACTIONBAR1BUTTON" .. (slot - 60)
		end
		return name
	end
	if br.player ~= nil and br.player.spell ~= nil then
		br.player.spell.bindings = {}
		for _, v in pairs(br.player.spell.abilities) do
			local slot = _G.C_ActionBar.FindSpellActionButtons(v)
			if slot ~= nil then
				for _, y in pairs(slot) do
					local key, key2 = _G.GetBindingKey(GetActionbarSlot(y))
					if key ~= nil then
						br.player.spell.bindings[key] = v
					end
					if key2 ~= nil then
						br.player.spell.bindings[key2] = v
					end
				end
			end
		end
	end
end
local function spellSuccess(self, event, ...)
	if event == "UNIT_SPELLCAST_SUCCEEDED" then
		local sourceUnit = select(1, ...)
		local spellID = select(3, ...)
		if sourceUnit == "player" then
			if spellID == br.queueSpell then
				br.ChatOverlay("Casted Queued Spell: " .. _G.GetSpellInfo(spellID))
				br.queueSpell = false
			end
		end
	end
end

function br.smartQueue()
    if smartQueueFrame == nil then
        smartQueueFrame = _G.CreateFrame("Frame")
		smartQueueFrame:SetPropagateKeyboardInput(true)
		smartQueueFrame:SetScript("OnKeyDown", checkKeys)
		smartQueueFrame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
		smartQueueFrame:SetScript("OnEvent", spellSuccess)
    end
    GetKeyBindings()

    -- Fix capturing mousebuttons
    if br.isChecked("Smart Queue") then
        if br._G.GetKeyState(0x05) then
            checkKeys(nil, "BUTTON4")
        elseif br._G.GetKeyState(0x06) then
            checkKeys(nil, "BUTTON5")
        end
    end
    
    if br.queueSpell and (_G.GetTime() - queueSpellTime) > br.getOptionValue("Smart Queue") then
        br.queueSpell = false
    end

    if ((br.queueSpell and br.isChecked("Smart Queue") and (_G.GetTime() - queueSpellTime) <= br.getOptionValue("Smart Queue") and not br._G.UnitChannelInfo("player") and (br.GetUnitIsVisible(queueSpellTarget) or br.getOptionValue(_G.GetSpellInfo(br.queueSpell) .. " (Queue)") == 2) and br._G.UnitAffectingCombat("player")) or
    (br._G.IsAoEPending() and br.isChecked("Smart Queue") and br.isChecked(_G.GetSpellInfo(br._G.GetTargetingSpell()) .. " (Queue)") and br._G.UnitAffectingCombat("player"))) and (br.queueSpell ~= 1776 or br.getFacing("target", "player")) then
		if br._G.IsAoEPending() and br.getOptionValue(_G.GetSpellInfo(br._G.GetTargetingSpell()) .. " (Queue)") ~= 3 then
            local pendingSpell = br._G.GetTargetingSpell()
            br._G.CancelPendingSpell()
            br._G.CastSpellByName(_G.GetSpellInfo(pendingSpell), "cursor")
            return true
        end
        if br.queueSpell and not br._G.UnitCastingInfo("player") then
            if br.getOptionValue(_G.GetSpellInfo(br.queueSpell) .. " (Queue)") == 2 then
                if br.createCastFunction("player","debug",nil,nil,br.queueSpell) then
					if br.castAtPosition(queueSpellPos.x, queueSpellPos.y, queueSpellPos.z, br.queueSpell) then
						br.ChatOverlay("Casted Queued Spell: " .. _G.GetSpellInfo(br.queueSpell))
						return true
					end
                end
            elseif br.getOptionValue(_G.GetSpellInfo(br.queueSpell) .. " (Queue)") == 3 then
                if br.createCastFunction("player","debug",nil,nil,br.queueSpell) then
					br._G.CastSpellByName(_G.GetSpellInfo(br.queueSpell))
					br.ChatOverlay("Casted Queued Spell: " .. _G.GetSpellInfo(br.queueSpell))
                    return true
                end
            else
                if _G.IsSpellInRange(_G.GetSpellInfo(br.queueSpell), queueSpellTarget) ~= nil then
					if br.createCastFunction(queueSpellTarget,nil,nil,nil,br.queueSpell) then
                        return true
                    end
                else
					if br.createCastFunction("player",nil,nil,nil,br.queueSpell) then
                        return true
                    end
                end
            end
        end
    end
end