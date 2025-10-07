local _, br = ...
br.functions.spell = br.functions.spell or {}
local spell = br.functions.spell

function spell:castInterrupt(SpellID, Percent, Unit)
	Percent = br._G.Math.min(Percent + math.random(-6, 6), 99)
	if Unit == nil then Unit = "target" end
	if br.functions.unit:GetObjectExists(Unit) then
		local _, _, _, castStartTime, castEndTime, _, _, castInterruptable = br._G.UnitCastingInfo(Unit)
		local channelName, _, _, channelStartTime, channelEndTime, _, channelInterruptable = br._G.UnitChannelInfo(Unit)
		-- first make sure we will be able to cast the spellID
		if br.functions.cast:canCast(SpellID, false, false, Unit) == true then
			-- make sure we cover melee range
			local allowedDistance = select(6, br._G.GetSpellInfo(SpellID))
			if allowedDistance < 5 then
				allowedDistance = 5
			end
			--check for cast
			if channelName ~= nil then
				--target is channeling a spell that is interruptable
				--load the channel variables into the cast variables to make logic a little easier.
				_ = channelName
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
			if br._G.UnitCanAttack("player", Unit) == nil then
				return false
			end
			if castInterruptable then
				--target is casting something that is interruptable.
				--the following 2 variables are named logically... value is in seconds.
				local timeSinceStart = (br._G.GetTime() * 1000 - castStartTime) / 1000
				-- local timeLeft = ((br._G.GetTime() * 1000 - castEndTime) * -1) / 1000
				local castTime = castEndTime - castStartTime
				local currentPercent = timeSinceStart / castTime * 100000
				--interrupt percentage check
				if currentPercent >= Percent then
					return false
				end
				--cast the spell
				if br.functions.range:getDistance("player", Unit) < allowedDistance then
					if br.functions.cast:castSpell(Unit, SpellID, false, false) then
						return true
					end
				end
			end
		end
	end
	return false
end

-- br.functions.spell:canInterrupt("target",20)
function spell:canInterrupt(unit, percentint)
	unit = unit or "target"
	-- M+ Affix: Beguiling (Prevents Interrupt) - Queen's Decree: Unstoppable buff
	if br.functions.aura:UnitBuffID(unit, 302417) ~= nil then return false end
	local interruptTarget = br.functions.misc:getOptionValue("Interrupt Target")
	if interruptTarget == 2 and not br.functions.unit:GetUnitIsUnit(unit, "target") then
		return false
	elseif interruptTarget == 3 and not br.functions.unit:GetUnitIsUnit(unit, "focus") then
		return false
	elseif interruptTarget == 4 and br.functions.misc:getOptionValue("Interrupt Mark") ~= br._G.GetRaidTargetIndex(unit) then
		return false
	end
	local castStartTime, castEndTime, interruptID, interruptable = 0, 0, 0, false
	local castDuration, castTimeRemain, castPercent = 0, 0, 0
	local channelDelay = 1    -- Delay to mimick human reaction time for channeled spells
	local castType = "spellcast" -- Handle difference in logic if the spell is cast or being channeles
	local onWhitelist = false
	local whitelistOnly = br.functions.misc:isChecked("Interrupt Only Whitelist")
	if br.functions.unit:GetUnitExists(unit)
		and br._G.UnitCanAttack("player", unit)
		and not br._G.UnitIsDeadOrGhost(unit)
	then
		-- Get Cast/Channel Info
		if select(5, br._G.UnitCastingInfo(unit)) and not select(8, br._G.UnitCastingInfo(unit)) then --Get spell cast time
			_, _, _, castStartTime, castEndTime, _, _, _, interruptID = br._G.UnitCastingInfo(unit)
			-- castStartTime = select(4, br._G.UnitCastingInfo(unit))
			-- castEndTime = select(5, br._G.UnitCastingInfo(unit))
			-- interruptID = select(9, br._G.UnitCastingInfo(unit))
			interruptable = true
			castType = "spellcast"
		elseif select(5, br._G.UnitChannelInfo(unit)) and not select(7, br._G.UnitChannelInfo(unit)) then -- Get spell channel time
			_, _, _, castStartTime, castEndTime, _, _, interruptID = br._G.UnitChannelInfo(unit)
			-- castStartTime = select(4, br._G.UnitChannelInfo(unit))
			-- castEndTime = select(5, br._G.UnitChannelInfo(unit))
			-- interruptID = select(8, br._G.UnitChannelInfo(unit))
			interruptable = true
			castType = "spellchannel"
		end
		-- Assign interrupt time
		if castEndTime > 0 and castStartTime > 0 then
			castDuration = (castEndTime - castStartTime) / 1000
			castTimeRemain = ((castEndTime / 1000) - br._G.GetTime())
			if percentint == nil and castPercent == 0 then
				if castType == "spellcast" then
					castPercent = math.random(25, 75) --  I am not sure that this is working,we are doing this check every pulse so its different randoms each time
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
					castPercent = math.random(25, 75)
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
					castPercent = math.random((percentint - 5), (5 + percentint))
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
		if whitelistOnly and br.lists.interruptWhitelist[interruptID] then
			onWhitelist = true
		end
		-- Return when interrupt time is met
		if ((whitelistOnly and onWhitelist) or not whitelistOnly)
			or not (br.player.instance == "party" or br.player.instance == "raid" or br.player.instance == "scenario")
		then
			local ttd = br.engines.ttdTable:getTTD(unit) or 0
			local withinsCastPercent = math.ceil((castTimeRemain / castDuration) * 100) <= castPercent
			local willFinishCast = ttd > castTimeRemain --or ttd < 0
			if castType == "spellcast" then
				if withinsCastPercent and interruptable == true and willFinishCast then
					return true
				end
			end
			if castType == "spellchannel" then
				--if (GetTime() - castStartTime/1000) > channelDelay and interruptable == true then
				if (br._G.GetTime() - castStartTime / 1000) > (channelDelay - 0.2 + math.random() * 0.4)
					and (withinsCastPercent or castPercent == 100) and interruptable == true
					and (willFinishCast or castPercent == 100)
				then
					return true
				end
			end
		end
		return false
	end
end

function spell:canStun(unit)
	return br.engines.enemiesEngineFunctions:isCrowdControlCandidates(unit)
end

-- if br.functions.spell:getCharges(115399) > 0 then
function spell:getCharges(spellID)
	local chargeInfo = br._G.C_Spell.GetSpellCharges(spellID)
	return chargeInfo and chargeInfo.currentCharges or 0
end

function spell:getChargesFrac(spellID, chargeMax)
	local chargeInfo = br._G.C_Spell.GetSpellCharges(spellID)
	local charges, maxCharges, start, duration = chargeInfo.currentCharges, chargeInfo.maxCharges,
		chargeInfo.cooldownStartTime, chargeInfo.cooldownDuration
	if chargeMax == nil then chargeMax = false end
	if maxCharges ~= nil then
		if chargeMax then
			return maxCharges
		else
			if start <= br._G.GetTime() then
				local endTime = start + duration
				local percentRemaining = 1 - (endTime - br._G.GetTime()) / duration
				return charges + percentRemaining
			else
				return charges
			end
		end
	end
	return 0
end

function spell:getRecharge(spellID, chargeMax)
	local chargeInfo = br._G.C_Spell.GetSpellCharges(spellID)
	local charges, maxCharges, chargeStart, chargeDuration = chargeInfo.currentCharges, chargeInfo.maxCharges,
		chargeInfo.cooldownStartTime, chargeInfo.cooldownDuration
	if chargeMax then return chargeDuration end
	if charges then
		if charges < maxCharges then
			local chargeEnd = chargeStart + chargeDuration
			return chargeEnd - br._G.GetTime()
		end
		return 0
	end
end

-- Full RechargeTime of a Spell/dump getFullRechargeTime(214579)
function spell:getFullRechargeTime(spellID)
	local chargeInfo = br._G.C_Spell.GetSpellCharges(spellID)
	local charges, maxCharges, chargeStart, chargeDuration = chargeInfo.currentCharges, chargeInfo.maxCharges,
		chargeInfo.cooldownStartTime, chargeInfo.cooldownDuration
	if charges then
		local currentChargeTime = (charges or 0) < (maxCharges or 0) and
			chargeDuration - (br._G.GetTime() - (chargeStart or 0)) or 0
		local leftChargesTotalTime = (maxCharges - charges - 1) * chargeDuration
		if charges ~= maxCharges then
			return currentChargeTime + leftChargesTotalTime
		end
	end
	return 0
end

local maxStage = 0
function spell:getEmpoweredRank(spellID)
	local stage = 0
	if br.empowerID and spellID == br.empowerID then
		local _, _, _, startTime, _, _, _, _, _, totalStages = br._G.UnitChannelInfo("player")
		if totalStages and totalStages > 0 then
			maxStage = totalStages
			startTime = startTime / 1000 -- Doing this here so we don't divide by 1000 every loop index
			local currentTime = br._G.GetTime() -- If you really want to get time each loop, go for it. But the time difference will be miniscule for a single frame loop
			local stageDuration = 0
			for i = 1, totalStages do
				stageDuration = stageDuration + br._G.GetUnitEmpowerStageDuration("player", i - 1) / 1000
				if startTime + stageDuration > currentTime then
					break -- Break early so we don't keep checking, we haven't hit this stage yet
				end
				stage = i
			end
		end
		if totalStages == nil then
			stage = maxStage
		end
	end
	return stage
end

-- if br.functions.spell:getSpellCD(12345) <= 0.4 then
function spell:getSpellCD(SpellID)
	if SpellID == nil then return false end
	local spellCD = br._G.C_Spell.GetSpellCooldown(SpellID)
	if spellCD == nil or spellCD.startTime == 0 then
		return 0
	else
		local MyCD = spellCD.startTime + spellCD.duration - br._G.GetTime()
		MyCD = MyCD or 0 -- br.functions.misc:getLatency()
		if MyCD < 0 then MyCD = 0 end
		return MyCD
	end
end

function spell:getGlobalCD(max)
	local currentSpecName = select(2, br._G.C_SpecializationInfo.GetSpecializationInfo(br._G.C_SpecializationInfo.GetSpecialization()))
	if currentSpecName == "" then currentSpecName = "Initial" end
	if max == true then
		if currentSpecName == "Feral" or currentSpecName == "Brewmaster" or currentSpecName == "Windwalker" or br._G.UnitClass("player") == "Rogue" then
			return 1
		else
			return math.max(math.max(1, 1.5 / (1 + br._G.UnitSpellHaste("player") / 100)), 0.75)
		end
	end
	return br.functions.spell:getSpellCD(61304)
end

function spell:getSpellType(spellName)
	if spellName == nil then return "Invalid" end
	local helpful = br._G.C_Spell.IsSpellHelpful(spellName) or false
	local harmful = br._G.C_Spell.IsSpellHarmful(spellName) or false
	if helpful and not harmful then return "Helpful" end
	if harmful and not helpful then return "Harmful" end
	if helpful and harmful then return "Both" end
	if not helpful and not harmful then return "Unknown" end
end

function spell:getCastingRegen(spellID)
	local regenRate = br.functions.power:getRegen("player")
	local power = 0
	local desc = br._G.C_Spell.GetSpellDescription(spellID)
	local generates = desc:gsub("%D+", "")
	local tooltip = tonumber(generates:sub(-2)) or 0
	-- Get the "execute time" of the spell (larger of GCD or the cast time).
	local castTime = br.functions.cast:getCastTime(spellID) or 0
	local gcd = br.player.gcdMax
	local castSeconds = (castTime > gcd) and castTime or gcd
	power = power + regenRate * castSeconds + tooltip

	-- Get the amount of time remaining on the Steady Focus buff.
	if br.functions.aura:UnitBuffID("player", 193534) ~= nil then
		local seconds = br.functions.aura:getBuffRemain("player", 193534)
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

function spell:getSpellRange(spellID, option)
	local _, _, _, _, _, maxRange = br._G.GetSpellInfo(spellID)
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

function spell:isSpellInSpellbook(spellID, spellType)
	local spellSlot = br._G.FindSpellBookSlotBySpellID(spellID, spellType == "pet" and true or false)
	if spellSlot then
		local spellName = br._G.C_SpellBook.GetSpellBookItemName(spellSlot, spellType)
		local link = br._G.C_Spell.GetSpellLink(spellName)
		local currentSpellId = tonumber(link and link:gsub("|", "||"):match("spell:(%d+)"))
		return currentSpellId == spellID
	end
	return false
end

function spell:getSpellInSpellBook(spellID, spellType)
	for i = 1, br._G.GetNumSpellTabs() do
		local name, texture, offset, numSlots, isGuild, offspecID = br._G.GetSpellTabInfo(i)
		-- local offset, numSlots = skillLineInfo.itemIndexOffset, skillLineInfo.numSpellBookItems
		for j = offset + 1, offset + numSlots do
			local spellType, id = br._G.GetSpellBookItemInfo(j,
				(spellType == "pet" and Enum.SpellBookSpellBank.Pet or Enum.SpellBookSpellBank.Player))
			-- local spellType, id = spellBookItemInfo.itemType, spellBookItemInfo.actionID
			local spellName
			if spellType == Enum.SpellBookItemType.Spell then
				spellName = br._G.C_Spell.GetSpellName(id)
				spellType = "Spell"
			elseif spellType == Enum.SpellBookItemType.FutureSpell then
				spellName = br._G.C_Spell.GetSpellName(id)
				spellType = "Future Spell"
			elseif spellType == Enum.SpellBookItemType.Flyout then
				spellName = GetFlyoutInfo(id)
				spellType = "Flyout"
			end
			if id == spellID then
				return i, j, spellType, id, spellName
			end
		end
	end
	return nil
end

-- if br.functions.spell:isKnown(106832) then
-- function spell:isKnown(spellID)
-- 	local baseSpellID = br._G.FindBaseSpellByID(spellID)
-- 	local _, _, spellInBookType = br.functions.spell:getSpellInSpellBook(spellID)
-- 	return spellID ~= nil and spellInBookType ~= "Future Spell" and
-- 		( --[[spellInBookType ~= nil or]] br._G.IsPlayerSpell(tonumber(spellID))
-- 			or br._G.IsSpellKnown(spellID) or br._G.IsPlayerSpell(tonumber(baseSpellID) or br._G.IsSpellKnown(baseSpellID))) -- or spellInBookType == "Spell")
-- end

function spell:isKnown(spellID)
	local spellName = br._G.GetSpellInfo(spellID)
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
	return spellID ~= nil and (br._G.GetSpellBookItemInfo(tostring(spellName)) ~= nil or br._G.IsPlayerSpell(tonumber(spellID)) or br._G.IsSpellKnown(spellID) or br.functions.spell:isSpellInSpellbook(spellID,"spell"))
end

function spell:isActiveEssence(spellID)
	local _, _, heartIcon = br._G.GetSpellInfo(296208)
	local _, _, essenceIcon = br._G.GetSpellInfo(spellID)
	return heartIcon == essenceIcon
end

local function flipRace()
    local race = select(2, br._G.UnitRace("player"))
    local class = select(3, br._G.UnitClass("player"))
    if br.functions.aura:UnitBuffID("player", 193863) then
        if race == "Orc" then
            return "Dwarf"
        elseif race == "Undead" then
            return "Human"
        elseif race == "Troll" then
            if class == 7 then
                return "Draenei"
            elseif class == 9 then
                return "Human"
            else
                return "NightElf"
            end
        elseif race == "Tauren" then
            if class == 11 then
                return "NightElf"
            else
                return "Draenei"
            end
        elseif race == "BloodElf" then
            if class == 12 then
                return "NightElf"
            else
                return "Human"
            end
        elseif race == "Goblin" then
            if class == 3 or class == 7 then
                return "Dwarf"
            else
                return "Gnome"
            end
        elseif race == "Pandaren" then
            return "Pandaren"
        elseif race == "HighmountainTauren" then
            if class == 11 then
                return "NightElf"
            else
                return "Draenei"
            end
        elseif race == "Nightborne" then
            if class == 9 then
                return "Human"
            else
                return "NightElf"
            end
        elseif race == "MagharOrc" then
            return "DarkIronDwarf"
        end
    elseif br.functions.aura:UnitBuffID("player", 193864) then
        if race == "Worgen" then
            return "Troll"
        elseif race == "DarkIronDwarf" then
            return "MagharOrc"
        elseif race == "Human" then
            if class == 2 then
                return "BloodElf"
            else
                return "Undead"
            end
        elseif race == "NightElf" then
            if class == 12 then
                return "BloodElf"
            else
                return "Troll"
            end
        elseif race == "Dwarf" then
            if class == 2 then
                return "Tauren"
            elseif class == 5 then
                return "Undead"
            else
                return "Orc"
            end
        elseif race == "Draenei" then
            if class == 8 then
                return "Orc"
            else
                return "Tauren"
            end
        elseif race == "Pandaren" then
            return "Pandaren"
        elseif race == "Gnome" then
            if class == 10 then
                return "BloodElf"
            else
                return "Goblin"
            end
        elseif race == "VoidElf" then
            if class == 3 or class == 5 or class == 1 then
                return "BloodElf"
            else
                return "Troll"
            end
        elseif race == "LightforgedDraenei" then
            if class == 8 then
                return "Orc"
            else
                return "Tauren"
            end
        end
    end
end

function spell:getRacial(thisRace)
    local forTheAlliance = br.functions.aura:UnitBuffID("player", 193863) or false
    local forTheHorde = br.functions.aura:UnitBuffID("player", 193864) or false
    local race = select(2, br._G.UnitRace("player"))
    if forTheAlliance or forTheHorde then
        race = flipRace()
    end
    local BloodElfRacial
    local DraeneiRacial
    local OrcRacial

    if race == "BloodElf" or race == thisRace then
        BloodElfRacial = select(7, br._G.GetSpellInfo(br._G.GetSpellInfo(69179)))
    end
    if race == "Draenei" or race == thisRace then
        DraeneiRacial = select(7, br._G.GetSpellInfo(br._G.GetSpellInfo(28880)))
    end
    if race == "Orc" or race == thisRace then
        OrcRacial = select(7, br._G.GetSpellInfo(br._G.GetSpellInfo(33702)))
    end
    local racialSpells = {
        -- Alliance
        Dwarf              = 20594,          -- Stoneform
        Gnome              = 20589,          -- Escape Artist
        Draenei            = DraeneiRacial,  -- Gift of the Naaru
        Human              = 59752,          -- Every Man for Himself
        NightElf           = 58984,          -- Shadowmeld
        Worgen             = 68992,          -- Darkflight
        -- Horde
        BloodElf           = BloodElfRacial, -- Arcane Torrent
        Goblin             = 69041,          -- Rocket Barrage
        Orc                = OrcRacial,      -- Blood Fury
        Tauren             = 20549,          -- War Stomp
        Troll              = 26297,          -- Berserking
        Scourge            = 7744,           -- Will of the Forsaken
        -- Both
        Pandaren           = 107079,         -- Quaking Palm
        -- Allied Races
        HighmountainTauren = 255654,         -- Bull Rush
        LightforgedDraenei = 255647,         -- Light's Judgment
        Nightborne         = 260364,         -- Arcane Pulse
        VoidElf            = 256948,         -- Spatial Rift
        DarkIronDwarf      = 265221,         -- Fireblood
        MagharOrc          = 274738,         -- Ancestral Call
        ZandalariTroll     = 291944,         -- Regeneratin'
        KulTiran           = 287712,         -- Haymaker
        Vulpera            = 312411,         -- Bag of Tricks
        Mechagnome         = 312924,         -- Hyper Organic Light Originator
    }
    if thisRace ~= nil and racialSpells[thisRace] ~= nil then return racialSpells[thisRace] end
    return racialSpells[race]
    -- return racialSpells[race]
end