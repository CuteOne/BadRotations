local _, br = ...
br.functions.SmartQueue = br.functions.SmartQueue or {}
local SmartQueue = br.functions.SmartQueue
SmartQueue.queueSpell = false
local queueSpellTime
local queueSpellPos = { x = 0, y = 0, z = 0 }
local queueSpellTarget
local smartQueueFrame
local ignoreKeys = { ["LALT"] = true, ["LSHIFT"] = true, ["LCTRL"] = true }

local function checkKeys(self, key)
	if br.player ~= nil and br.player.spells ~= nil and br.player.spells.bindings ~= nil and ignoreKeys[key] == nil and br.functions.misc:isChecked("Smart Queue") and br._G.UnitAffectingCombat("player") then
		local pressedKey = ""
		if br._G.IsLeftShiftKeyDown() then
			pressedKey = "SHIFT-"
		elseif br._G.IsLeftAltKeyDown() then
			pressedKey = "ALT-"
		elseif br._G.IsLeftControlKeyDown() then
			pressedKey = "CTRL-"
		end
		pressedKey = pressedKey .. key
		local spell = br.player.spells.bindings[pressedKey]
		if spell ~= nil then
			local cd = br.functions.spell:getSpellCD(spell)
			if br._G.GetSpellInfo(br._G.GetSpellInfo(spell)) and cd <= br.functions.misc:getOptionValue("Smart Queue") and br.functions.misc:isChecked(br._G.GetSpellInfo(spell) .. " (Queue)") and (cd > 0 or br._G.C_Spell.IsSpellUsable(spell) == false or br._G.UnitCastingInfo("player")) then
				SmartQueue.queueSpell = spell
				queueSpellTime = br._G.GetTime()
				if br.functions.misc:getOptionValue(br._G.GetSpellInfo(SmartQueue.queueSpell) .. " (Queue)") == 2 then
					local x, y = br._G.GetMousePosition()
					queueSpellPos.x, queueSpellPos.y, queueSpellPos.z = br._G.ScreenToWorld(x, y)
				elseif br.functions.misc:getOptionValue(br._G.GetSpellInfo(SmartQueue.queueSpell) .. " (Queue)") == 4 and br._G.UnitIsVisible("mouseover") then
					queueSpellTarget = br._G.ObjectPointer("mouseover")
				else
					queueSpellTarget = "target"
				end
				br.ui.chatOverlay:Show("Queued: " .. br._G.GetSpellInfo(SmartQueue.queueSpell))
			end
		end
	end
end

local function GetKeyBindings()
	local function GetActionbarSlot(slot)
		local name
		if br._G["Bartender4"] then
			name = "CLICK BT4Button" .. slot .. ":LeftButton"
			if br._G.GetBindingKey(name) ~= nil then
				return name
			end
		end
		if br._G["Dominos"] then
			for i = 1, 60 do
				if br._G["DominosActionButton" .. i] and br._G["DominosActionButton" .. i]["action"] == slot then
					name = "CLICK DominosActionButton" .. i .. ":LeftButton"
					if br._G.GetBindingKey(name) ~= nil then
						return name
					end
				end
			end
		end
		local bonusBar = br._G.GetBonusBarOffset()
		local slotID = (1 + (br._G["NUM_ACTIONBAR_PAGES"] + bonusBar - 1) * br._G["NUM_ACTIONBAR_BUTTONS"])
		if (bonusBar == 0 and slot <= 12) or (bonusBar > 0 and slot >= slotID and slot < (slotID + 12)) then
			name = "ACTIONBUTTON" .. (((slot - 1) % 12) + 1)
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
	if br.player ~= nil and br.player.spells ~= nil then
		br.player.spells.bindings = {}
		for _, v in pairs(br.player.spells.abilities) do
			local slot = br._G.C_ActionBar.FindSpellActionButtons(v)
			if slot ~= nil then
				local _, id, _ = br._G.GetActionInfo(slot[1])
				if v == id then
					for _, y in pairs(slot) do
						local key, key2 = br._G.GetBindingKey(GetActionbarSlot(y))
						if key ~= nil then
							br.player.spells.bindings[key] = v
						end
						if key2 ~= nil then
							br.player.spells.bindings[key2] = v
						end
					end
				end
			end
		end
		--for i,v in pairs(br.player.spells.bindings) do print(i,v) end
	end
end
local function spellSuccess(self, event, ...)
	if event == "UNIT_SPELLCAST_SUCCEEDED" then
		local sourceUnit = select(1, ...)
		local spellID = select(3, ...)
		if sourceUnit == "player" then
			if spellID == SmartQueue.queueSpell then
				br.ui.chatOverlay:Show("Casted Queued Spell: " .. br._G.GetSpellInfo(spellID))
				SmartQueue.queueSpell = false
			end
		end
	end
end

function SmartQueue:smartQueue()
	if smartQueueFrame == nil then
		smartQueueFrame = br._G.CreateFrame("Frame")
		smartQueueFrame:SetPropagateKeyboardInput(true)
		smartQueueFrame:SetScript("OnKeyDown", checkKeys)
		smartQueueFrame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
		smartQueueFrame:SetScript("OnEvent", spellSuccess)
	end
	GetKeyBindings()

	-- Fix capturing mousebuttons
	if br.functions.misc:isChecked("Smart Queue") then
		if br._G.GetKeyState(0x05) then
			checkKeys(nil, "BUTTON4")
		elseif br._G.GetKeyState(0x06) then
			checkKeys(nil, "BUTTON5")
		end
	end

	if SmartQueue.queueSpell and (br._G.GetTime() - queueSpellTime) > br.functions.misc:getOptionValue("Smart Queue") then
		SmartQueue.queueSpell = false
	end

	if SmartQueue.queueSpell and br.functions.misc:isChecked("Smart Queue") and (((br._G.GetTime() - queueSpellTime) <= br.functions.misc:getOptionValue("Smart Queue") and not br._G.UnitChannelInfo("player")
				and (br._G.UnitIsVisible(queueSpellTarget) or br.functions.misc:getOptionValue(br._G.GetSpellInfo(SmartQueue.queueSpell) .. " (Queue)") == 2) and br._G.UnitAffectingCombat("player"))
			or (br._G.IsAoEPending() and br.functions.misc:isChecked("Smart Queue") and br.functions.misc:isChecked(br._G.GetSpellInfo(SmartQueue.queueSpell) .. " (Queue)") and br._G.UnitAffectingCombat("player")))
		and (SmartQueue.queueSpell ~= 1776 or br.functions.unit:getFacing("target", "player"))
	then
		if br._G.IsAoEPending() and br.functions.misc:getOptionValue(br._G.GetSpellInfo(SmartQueue.queueSpell) .. " (Queue)") ~= 3 then
			local pendingSpell = SmartQueue.queueSpell
			br._G.CancelPendingSpell()
			br._G.CastSpellByName(br._G.GetSpellInfo(pendingSpell), "cursor")
			return true
		end
		if SmartQueue.queueSpell and not br._G.UnitCastingInfo("player") then
			if br.functions.misc:getOptionValue(br._G.GetSpellInfo(SmartQueue.queueSpell) .. " (Queue)") == 2 then
				if br.functions.cast:createCastFunction("player", nil, nil, nil, SmartQueue.queueSpell, nil, nil, nil, nil, true) then
					if br.functions.cast:castAtPosition(queueSpellPos.x, queueSpellPos.y, queueSpellPos.z, SmartQueue.queueSpell) then
						br.ui.chatOverlay:Show("Casted Queued Spell: " .. br._G.GetSpellInfo(SmartQueue.queueSpell))
						return true
					end
				end
			elseif br.functions.misc:getOptionValue(br._G.GetSpellInfo(SmartQueue.queueSpell) .. " (Queue)") == 3 then
				if br.functions.cast:createCastFunction("player", nil, nil, nil, SmartQueue.queueSpell, nil, nil, nil, nil, true) then
					br._G.CastSpellByName(br._G.GetSpellInfo(SmartQueue.queueSpell))
					br.ui.chatOverlay:Show("Casted Queued Spell: " .. br._G.GetSpellInfo(SmartQueue.queueSpell))
					return true
				end
			else
				if br._G.C_Spell.IsSpellInRange(br._G.GetSpellInfo(SmartQueue.queueSpell), queueSpellTarget) ~= nil then
					if br.functions.cast:createCastFunction(queueSpellTarget, nil, nil, nil, SmartQueue.queueSpell) then
						return true
					end
				else
					if br.functions.cast:createCastFunction("player", nil, nil, nil, SmartQueue.queueSpell) then
						return true
					end
				end
			end
		end
	end
end
