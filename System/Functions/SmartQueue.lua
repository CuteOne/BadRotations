local _, br = ...
---@class br.functions.SmartQueue
br.functions.SmartQueue = br.functions.SmartQueue or {}
local SmartQueue = br.functions.SmartQueue
SmartQueue.queueSpell = false

local queueSpellTime

local queueSpellPos = { x = 0, y = 0, z = 0 }

local queueSpellTarget

local smartQueueFrame

local ignoreKeys = { ["LALT"] = true, ["LSHIFT"] = true, ["LCTRL"] = true }

local function checkKeys(self, key)
	if br.player ~= nil and br.player.spells ~= nil and br.player.spells.bindings ~= nil and ignoreKeys[key] == nil and br.functions.misc:isChecked("Smart Queue") and br.game.UnitAffectingCombat("player") then
		local pressedKey = ""
		if br.game.IsLeftShiftKeyDown() then
			pressedKey = "SHIFT-"
		elseif br.game.IsLeftAltKeyDown() then
			pressedKey = "ALT-"
		elseif br.game.IsLeftControlKeyDown() then
			pressedKey = "CTRL-"
		end
		pressedKey = pressedKey .. key
		local spell = br.player.spells.bindings[pressedKey]
		if spell ~= nil then
			local cd = br.functions.spell:getSpellCD(spell)
			if br.functions.spell:getName(br.functions.spell:getName(spell)) and cd <= br.functions.misc:getOptionValue("Smart Queue") and br.functions.misc:isChecked(br.functions.spell:getName(spell) .. " (Queue)") and (cd > 0 or br.game.C_Spell.IsSpellUsable(spell) == false or br.game.UnitCastingInfo("player")) then
				SmartQueue.queueSpell = spell
				queueSpellTime = br.game.GetTime()
				if br.functions.misc:getOptionValue(br.functions.spell:getName(SmartQueue.queueSpell) .. " (Queue)") == 2 then
					local x, y = br.game.GetMousePosition()
					queueSpellPos.x, queueSpellPos.y, queueSpellPos.z = br.game.ScreenToWorld(x, y)
				elseif br.functions.misc:getOptionValue(br.functions.spell:getName(SmartQueue.queueSpell) .. " (Queue)") == 4 and br.game.UnitIsVisible("mouseover") then
					queueSpellTarget = br.game.ObjectPointer("mouseover")
				else
					queueSpellTarget = "target"
				end
				br.ui.chatOverlay:Show("Queued: " .. br.functions.spell:getName(SmartQueue.queueSpell))
			end
		end
	end
end

local function GetKeyBindings()
	local function GetActionbarSlot(slot)
		local name
		if br.game["Bartender4"] then
			name = "CLICK BT4Button" .. slot .. ":LeftButton"
			if br.game.GetBindingKey(name) ~= nil then
				return name
			end
		end
		if br.game["Dominos"] then
			for i = 1, 60 do
				if br.game["DominosActionButton" .. i] and br.game["DominosActionButton" .. i]["action"] == slot then
					name = "CLICK DominosActionButton" .. i .. ":LeftButton"
					if br.game.GetBindingKey(name) ~= nil then
						return name
					end
				end
			end
		end
		local bonusBar = br.game.GetBonusBarOffset()
		local slotID = (1 + (br.game["NUM_ACTIONBAR_PAGES"] + bonusBar - 1) * br.game["NUM_ACTIONBAR_BUTTONS"])
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
			local slot = br.game.C_ActionBar.FindSpellActionButtons(v)
			if slot ~= nil then
				local _, id, _ = br.game.GetActionInfo(slot[1])
				if v == id then
					for _, y in pairs(slot) do
						local key, key2 = br.game.GetBindingKey(GetActionbarSlot(y))
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
				br.ui.chatOverlay:Show("Casted Queued Spell: " .. br.functions.spell:getName(spellID))
				SmartQueue.queueSpell = false
			end
		end
	end
end

function SmartQueue:smartQueue()
	if smartQueueFrame == nil then
		smartQueueFrame = br.game.CreateFrame("Frame")
		-- EnableKeyboard + Show are required for OnKeyDown to fire.
		-- Without them the frame exists but never receives key events.
		smartQueueFrame:EnableKeyboard(true)
		smartQueueFrame:Show()
		smartQueueFrame:SetPropagateKeyboardInput(true)
		smartQueueFrame:SetScript("OnKeyDown", checkKeys)
		smartQueueFrame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
		smartQueueFrame:SetScript("OnEvent", spellSuccess)
	end
	GetKeyBindings()

	-- Fix capturing mousebuttons (GetKeyState is unlocker-provided; guard for platforms that omit it)
	if br.functions.misc:isChecked("Smart Queue") and br.game.GetKeyState then
		if br.game.GetKeyState(0x05) then
			checkKeys(nil, "BUTTON4")
		elseif br.game.GetKeyState(0x06) then
			checkKeys(nil, "BUTTON5")
		end
	end

	if SmartQueue.queueSpell and (br.game.GetTime() - queueSpellTime) > br.functions.misc:getOptionValue("Smart Queue") then
		SmartQueue.queueSpell = false
	end

	if SmartQueue.queueSpell and br.functions.misc:isChecked("Smart Queue") and (((br.game.GetTime() - queueSpellTime) <= br.functions.misc:getOptionValue("Smart Queue") and not br.game.UnitChannelInfo("player")
				and (br.game.UnitIsVisible(queueSpellTarget) or br.functions.misc:getOptionValue(br.functions.spell:getName(SmartQueue.queueSpell) .. " (Queue)") == 2) and br.game.UnitAffectingCombat("player"))
			or (br.game.IsAoEPending() and br.functions.misc:isChecked("Smart Queue") and br.functions.misc:isChecked(br.functions.spell:getName(SmartQueue.queueSpell) .. " (Queue)") and br.game.UnitAffectingCombat("player")))
		-- Gouge only lands from in front of the target
		and (SmartQueue.queueSpell ~= br.functions.spell:getHighestSpellID("gouge") or br.functions.unit:getFacing("target", "player"))
	then
		if br.game.IsAoEPending() and br.functions.misc:getOptionValue(br.functions.spell:getName(SmartQueue.queueSpell) .. " (Queue)") ~= 3 then
			local pendingSpell = SmartQueue.queueSpell
			br.game.CancelPendingSpell()
			br.functions.cast:castByName(br.functions.spell:getName(pendingSpell), "cursor")
			return true
		end
		if SmartQueue.queueSpell and not br.game.UnitCastingInfo("player") then
			if br.functions.misc:getOptionValue(br.functions.spell:getName(SmartQueue.queueSpell) .. " (Queue)") == 2 then
				if br.functions.cast:createCastFunction("player", nil, nil, nil, SmartQueue.queueSpell, nil, nil, nil, nil, true) then
					if br.functions.cast:castAtPosition(queueSpellPos.x, queueSpellPos.y, queueSpellPos.z, SmartQueue.queueSpell) then
						br.ui.chatOverlay:Show("Casted Queued Spell: " .. br.functions.spell:getName(SmartQueue.queueSpell))
						return true
					end
				end
			elseif br.functions.misc:getOptionValue(br.functions.spell:getName(SmartQueue.queueSpell) .. " (Queue)") == 3 then
				if br.functions.cast:createCastFunction("player", nil, nil, nil, SmartQueue.queueSpell, nil, nil, nil, nil, true) then
					br.functions.cast:castByName(br.functions.spell:getName(SmartQueue.queueSpell))
					br.ui.chatOverlay:Show("Casted Queued Spell: " .. br.functions.spell:getName(SmartQueue.queueSpell))
					return true
				end
			else
				if br.game.C_Spell.IsSpellInRange(br.functions.spell:getName(SmartQueue.queueSpell), queueSpellTarget) ~= nil then
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

br.lifecycle:onTick(15, "smart queue", function()
	if br.functions.misc:isChecked("Smart Queue") then SmartQueue:smartQueue() end
end)
