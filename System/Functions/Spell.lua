function castInterrupt(SpellID,Percent,Unit)
	Percent = Math.min(Percent + math.random(-6.5, 6.5), 99)
	if Unit == nil then Unit = "target" end
	if GetObjectExists(Unit) then
		local castName, _, _, castStartTime, castEndTime, _, _, castInterruptable = UnitCastingInfo(Unit)
		local channelName, _, _, channelStartTime, channelEndTime, _, channelInterruptable = UnitChannelInfo(Unit)
		-- first make sure we will be able to cast the spellID
		if canCast(SpellID,false,false) == true then
			-- make sure we cover melee range
			local allowedDistance = select(6,GetSpellInfo(SpellID))
			if allowedDistance < 5 then
				allowedDistance = 5
			end
			--check for cast
			if channelName ~= nil then
				--target is channeling a spell that is interruptable
				--load the channel variables into the cast variables to make logic a little easier.
				castName = channelName
				castStartTime = channelStartTime
				castEndTime = channelEndTime
				castInterruptable = channelInterruptable
			end
			--This is actually Not Interruptable... so lets swap it around to use in the positive.
			if castInterruptable == false then
				castInterruptable = true
			else
				castInterruptable = false
			end
			--we can't attack the target.
			if UnitCanAttack("player",Unit) == nil then
				return false
			end
			if castInterruptable then
				--target is casting something that is interruptable.
				--the following 2 variables are named logically... value is in seconds.
				local timeSinceStart = (GetTime() * 1000 - castStartTime) / 1000
				local timeLeft = ((GetTime() * 1000 - castEndTime) * -1) / 1000
				local castTime = castEndTime - castStartTime
				local currentPercent = timeSinceStart / castTime * 100000
				--interrupt percentage check
				if currentPercent >= Percent then
					return false
				end
				--cast the spell
				if getDistance("player",Unit) < allowedDistance then
					if castSpell(Unit,SpellID,false,false) then
						return true
					end
				end
			end
		end
	end
	return false
end
-- canInterrupt("target",20)
function canInterrupt(unit,percentint)
	unit = unit or "target"
	-- M+ Affix: Beguiling (Prevents Interrupt) - Queen's Decree: Unstoppable buff
	if UnitBuffID(unit,302417) ~= nil then return false end
	local interruptTarget = getOptionValue("Interrupt Target")
	if interruptTarget == 2 and not GetUnitIsUnit(unit, "target") then
		return false
	elseif interruptTarget == 3 and not GetUnitIsUnit(unit, "focus") then
		return false
	elseif interruptTarget == 4 and getOptionValue("Interrupt Mark") ~= GetRaidTargetIndex(unit) then
		return false
	end
	local castStartTime, castEndTime, interruptID, interruptable = 0, 0, 0, false
	local castDuration, castTimeRemain, castPercent = 0, 0, 0
	local channelDelay = 1 -- Delay to mimick human reaction time for channeled spells
	local castType = "spellcast" -- Handle difference in logic if the spell is cast or being channeles
	local onWhitelist = false
	if GetUnitExists(unit)
		and UnitCanAttack("player",unit)
		and not UnitIsDeadOrGhost(unit)
	then
		-- Get Cast/Channel Info
		if select(5,UnitCastingInfo(unit)) and not select(8,UnitCastingInfo(unit)) then --Get spell cast time
			castStartTime = select(4,UnitCastingInfo(unit))
			castEndTime = select(5,UnitCastingInfo(unit))
			interruptID = select(9,UnitCastingInfo(unit))
			interruptable = true
			castType = "spellcast"
		elseif select(5,UnitChannelInfo(unit)) and not select(7,UnitChannelInfo(unit)) then -- Get spell channel time
			castStartTime = select(4,UnitChannelInfo(unit))
			castEndTime = select(5,UnitChannelInfo(unit))
			interruptID = select(8,UnitChannelInfo(unit))
			interruptable = true
			castType = "spellchannel"
		end
		-- Assign interrupt time
		if castEndTime > 0 and castStartTime > 0 then
			castDuration = (castEndTime - castStartTime)/1000
			castTimeRemain = ((castEndTime/1000) - GetTime())
			if percentint == nil and castPercent == 0 then
				if castType == "spellcast" then
					castPercent = math.random(25,75) --  I am not sure that this is working,we are doing this check every pulse so its different randoms each time
				end
				if castType == "spellchannel" then
					if castDuration > 60 then
						castPercent = 100
					else
						castPercent = math.random(95, 99)
					end
				end
			elseif percentint == 0 and castPercent == 0 then
				if castType == "spellcast" then
					castPercent = math.random(25,75)
				end
				if castType == "spellchannel" then
					if castDuration > 60 then
						castPercent = 100
					else
						castPercent = math.random(95, 99)
					end
				end
			elseif percentint > 0 then
				if castType == "spellcast" then
					castPercent = percentint
				end
				if castType == "spellchannel" then
					if castDuration > 60 then
						castPercent = 100
					else
						castPercent = math.random(95, 99)
					end
				end
			end
		end
		-- Check if on whitelist (if selected)
		if isChecked("Interrupt Only Whitelist") and br.lists.interruptWhitelist[interruptID] then
			 onWhitelist = true
		end
		-- Return when interrupt time is met
		if ((isChecked("Interrupt Only Whitelist") and (onWhitelist or not (br.player.instance=="party" or br.player.instance=="raid"))) or not isChecked("Interrupt Only Whitelist")) then
			if castType == "spellcast" then
				if math.ceil((castTimeRemain/castDuration)*100) <= castPercent and interruptable == true and getTTD(unit)>castTimeRemain then
					return true
				end
			end
			if castType == "spellchannel" then
				--if (GetTime() - castStartTime/1000) > channelDelay and interruptable == true then
				if (GetTime() - castStartTime/1000) > (channelDelay-0.2 + math.random() * 0.4) and (math.ceil((castTimeRemain/castDuration)*100) <= castPercent or castPercent == 100) and interruptable == true and (getTTD(unit)>castTimeRemain or castPercent == 100) then
					return true
				end
			end
		end
		return false
	end
end
function canStun(unit)
	return isCrowdControlCandidates(unit)
end
-- if getCharges(115399) > 0 then
function getCharges(spellID)
	return select(1,GetSpellCharges(spellID))
end
function getChargesFrac(spellID,chargeMax)
	local charges,maxCharges,start,duration = GetSpellCharges(spellID)
	if chargeMax == nil then chargeMax = false end
	if maxCharges ~= nil then
		if chargeMax then
			return maxCharges
		else
			if start <= GetTime() then
				local endTime = start + duration
				local percentRemaining = 1 - (endTime - GetTime()) / duration
				return charges + percentRemaining
			else
				return charges
			end
		end
	end
	return 0
end
function getRecharge(spellID,chargeMax)
	local charges,maxCharges,chargeStart,chargeDuration = GetSpellCharges(spellID)
	if chargeMax then return chargeDuration end
	if charges then
		if charges < maxCharges then
			local chargeEnd = chargeStart + chargeDuration
			return chargeEnd - GetTime()
		end
		return 0
	end
end
-- Full RechargeTime of a Spell/dump getFullRechargeTime(214579)
function getFullRechargeTime(spellID)
    local charges,maxCharges,chargeStart,chargeDuration = GetSpellCharges(spellID)
    if charges then
        local currentChargeTime = (charges or 0) < (maxCharges or 0) and chargeDuration - (GetTime() - (chargeStart or 0)) or 0
        local leftChargesTotalTime = (maxCharges - charges - 1) * chargeDuration
        if charges ~= maxCharges then
            return currentChargeTime + leftChargesTotalTime
        end
    end
    return 0
end
-- if getSpellCD(12345) <= 0.4 then
function getSpellCD(SpellID)
	if SpellID == nil then return false end
	if GetSpellCooldown(SpellID) == 0 then
		return 0
	else
		local Start, CD = GetSpellCooldown(SpellID)
		local MyCD = Start + CD - GetTime()
		MyCD = MyCD -- getLatency()
		if MyCD < 0 then MyCD = 0 end
		return MyCD
	end
end
function getGlobalCD(max)
	local currentSpecName = select(2,GetSpecializationInfo(GetSpecialization()))
	if currentSpecName == "" then currentSpecName = "Initial" end
	if max == true then
		if currentSpecName=="Feral" or currentSpecName=="Brewmaster" or currentSpecName=="Windwalker" or UnitClass("player") == "Rogue" then
			return 1
		else
			return math.max(math.max(1, 1.5 / (1 + UnitSpellHaste("player") / 100)), 0.75)
		end
	end
	return getSpellCD(61304)
end
function getSpellType(spellName)
	if spellName == nil then return "Invalid" end
	local helpful = IsHelpfulSpell(spellName) or false
	local harmful = IsHarmfulSpell(spellName) or false
	if helpful and not harmful then return "Helpful" end
    if harmful and not helpful then return "Harmful" end
    if helpful and harmful then return "Both" end
    if not helpful and not harmful then return "Unknown" end
end
function getCastingRegen(spellID)
	local regenRate = getRegen("player")
	local power = 0
	local desc = GetSpellDescription(spellID)
	local generates = desc:gsub("%D+", "")
	local tooltip = tonumber(generates:sub(-2))
	-- Get the "execute time" of the spell (larger of GCD or the cast time).
	local castTime = getCastTime(spellID) or 0
	local gcd = br.player.gcdMax
	local castSeconds = (castTime > gcd) and castTime or gcd
	power = power + regenRate * castSeconds + tooltip

	-- Get the amount of time remaining on the Steady Focus buff.
	if UnitBuffID("player", 193534) ~= nil then
		local seconds = getBuffRemain("player", 193534)
		if seconds <= 0 then
			seconds = 0
		elseif seconds > castSeconds then
			seconds = castSeconds
		end
		-- Steady Focus increases the focus regeneration rate by 50% for its duration.
		power = power + regenRate * 1.5 * seconds + tooltip
	end
	return power
end
function getSpellRange(spellID)
	local _,_,_,_,_,maxRange = GetSpellInfo(spellID)
	if maxRange == nil or maxRange == 0 then maxRange = 5 else maxRange = tonumber(maxRange) end
	-- Modifiers
	local rangeMod = 0
	-- Balance Affinity range change (Druid - Not Balance)
	if br.player ~= nil then
		if br.player.talent.balanceAffinity ~= nil then
			if br.player.talent.balanceAffinity and option ~= "noMod" then
				rangeMod = 5
			end
		end
	end
	return maxRange + rangeMod
end
function isSpellInSpellbook(spellID,spellType)
    local spellSlot = FindSpellBookSlotBySpellID(spellID, spellType == "pet" and true or false)
    if spellSlot then
       local spellName = GetSpellBookItemName(spellSlot, spellType)
       local link = GetSpellLink(spellName)
       local currentSpellId = tonumber(link and link:gsub("|", "||"):match("spell:(%d+)"))
       return currentSpellId == spellID
    end
	return false
end
-- if isKnown(106832) then
function isKnown(spellID)
	local spellName = GetSpellInfo(spellID)
	-- if GetSpellBookItemInfo(tostring(spellName)) ~= nil then
	-- 	return true
	-- elseif IsPlayerSpell(tonumber(spellID)) == true then
	-- 	return true
	-- elseif IsSpellKnown(spellID) == true then
	-- 	return true
	-- elseif hasPerk(spellID) == true then
 --        return true
 --    end
	-- return false
	return spellID ~= nil and (GetSpellBookItemInfo(tostring(spellName)) ~= nil or IsPlayerSpell(tonumber(spellID)) or IsSpellKnown(spellID) or hasPerk(spellID) or isSpellInSpellbook(spellID,"spell"))
end

function isActiveEssence(spellID)
	local _, _, heartIcon = GetSpellInfo(296208) 
	local _, _, essenceIcon = GetSpellInfo(spellID)
	return heartIcon == essenceIcon
end
