br.queueSpell = false
local queueSpellTime
local queueSpellPos = {x = 0, y = 0, z = 0}
local queueSpellTarget
local smartQueueFrame
local ignoreKeys = {["LALT"] = true, ["LSHIFT"] = true, ["LCTRL"] = true}

local function checkKeys(self, key)
	if br.player ~= nil and br.player.spell ~= nil and br.player.spell.bindings ~= nil and ignoreKeys[key] == nil and isChecked("Smart Queue") and UnitAffectingCombat("player") then
		local pressedKey = ""
		if IsLeftShiftKeyDown() then
			pressedKey = "SHIFT-"
		elseif IsLeftAltKeyDown() then
			pressedKey = "ALT-"
		elseif IsLeftControlKeyDown() then
			pressedKey = "CTRL-"
		end
		pressedKey = pressedKey .. key
		local spell = br.player.spell.bindings[pressedKey]
		if spell ~= nil then
			if GetSpecializationInfo(GetSpecialization()) == 258 and spell == 2061 then spell = 186263 end
			local cd = getSpellCD(spell)
			if GetSpellInfo(GetSpellInfo(spell)) and cd <= getOptionValue("Smart Queue") and isChecked(GetSpellInfo(spell) .. " (Queue)") and (cd > 0 or IsUsableSpell(spell) == false or UnitCastingInfo("player")) then
				br.queueSpell = spell
				queueSpellTime = GetTime()
				if getOptionValue(GetSpellInfo(br.queueSpell) .. " (Queue)") == 2 then
					local x, y = GetMousePosition() 
					queueSpellPos.x, queueSpellPos.y, queueSpellPos.z = ScreenToWorld(x, y)
				elseif getOptionValue(GetSpellInfo(br.queueSpell) .. " (Queue)") == 4 and UnitIsVisible("mouseover") then
					queueSpellTarget = ObjectPointer("mouseover")
				else
					queueSpellTarget = "target"
				end
				ChatOverlay("Queued: " .. GetSpellInfo(br.queueSpell))
			end
		end
	end
end

local function GetKeyBindings()
	local function GetActionbarSlot(slot)
		local name
		if Bartender4 then
			name = "CLICK BT4Button" .. slot .. ":LeftButton"
			if GetBindingKey(name) ~= nil then
				return name
			end
		end
		if Dominos then
			for i = 1, 60 do
				if _G["DominosActionButton" .. i] and _G["DominosActionButton" .. i]["action"] == slot then
					name = "CLICK DominosActionButton" .. i .. ":LeftButton"
					if GetBindingKey(name) ~= nil then
						return name
					end
				end
			end
		end
		local bonusBar = GetBonusBarOffset()
		local slotID = (1 + (NUM_ACTIONBAR_PAGES + bonusBar - 1) * NUM_ACTIONBAR_BUTTONS)
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
		for k, v in pairs(br.player.spell.abilities) do
			local slot = C_ActionBar.FindSpellActionButtons(v)
			if slot ~= nil then
				for _, y in pairs(slot) do
					local key, key2 = GetBindingKey(GetActionbarSlot(y))
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
				ChatOverlay("Casted Queued Spell: " .. GetSpellInfo(spellID))
				br.queueSpell = false
			end
		end
	end
end

function br.smartQueue()
    if smartQueueFrame == nil then
        smartQueueFrame = CreateFrame("Frame")
		smartQueueFrame:SetPropagateKeyboardInput(true)
		smartQueueFrame:SetScript("OnKeyDown", checkKeys)
		smartQueueFrame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
		smartQueueFrame:SetScript("OnEvent", spellSuccess)
    end
    GetKeyBindings()

    -- Fix capturing mousebuttons
    if isChecked("Smart Queue") then
        if GetKeyState(0x05) then
            checkKeys(nil, "BUTTON4")
        elseif GetKeyState(0x06) then
            checkKeys(nil, "BUTTON5")
        end
    end
    
    if br.queueSpell and (GetTime() - queueSpellTime) > getOptionValue("Smart Queue") then
        br.queueSpell = false
    end

    if ((br.queueSpell and isChecked("Smart Queue") and (GetTime() - queueSpellTime) <= getOptionValue("Smart Queue") and not UnitChannelInfo("player") and (UnitIsVisible(queueSpellTarget) or getOptionValue(GetSpellInfo(br.queueSpell) .. " (Queue)") == 2) and UnitAffectingCombat("player")) or
    (IsAoEPending() and isChecked("Smart Queue") and isChecked(GetSpellInfo(GetTargetingSpell()) .. " (Queue)") and UnitAffectingCombat("player"))) and (br.queueSpell ~= 1776 or getFacing("target", "player")) then
		if IsAoEPending() and getOptionValue(GetSpellInfo(GetTargetingSpell()) .. " (Queue)") ~= 3 then
            local pendingSpell = GetTargetingSpell()
            CancelPendingSpell()
            CastSpellByName(GetSpellInfo(pendingSpell), "cursor")
            return true
        end
        if br.queueSpell and not UnitCastingInfo("player") then
            if getOptionValue(GetSpellInfo(br.queueSpell) .. " (Queue)") == 2 then
                if createCastFunction("player","debug",nil,nil,br.queueSpell) then
					if castAtPosition(queueSpellPos.x, queueSpellPos.y, queueSpellPos.z, br.queueSpell) then
						ChatOverlay("Casted Queued Spell: " .. GetSpellInfo(br.queueSpell))
						return true
					end
                end
            elseif getOptionValue(GetSpellInfo(br.queueSpell) .. " (Queue)") == 3 then
                if createCastFunction("player","debug",nil,nil,br.queueSpell) then
					CastSpellByName(GetSpellInfo(br.queueSpell))
					ChatOverlay("Casted Queued Spell: " .. GetSpellInfo(br.queueSpell))
                    return true
                end
            else
                if IsSpellInRange(GetSpellInfo(br.queueSpell), queueSpellTarget) ~= nil then
					if createCastFunction(queueSpellTarget,nil,nil,nil,br.queueSpell) then
                        return true 
                    end
                else
					if createCastFunction("player",nil,nil,nil,br.queueSpell) then
                        return true 
                    end
                end
            end
        end
    end
end