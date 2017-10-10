-- getLatency()
function getLatency()
	-- local lag = ((select(3,GetNetStats()) + select(4,GetNetStats())) / 1000)
	local lag = select(4,GetNetStats()) / 1000
	if lag < .05 then
		lag = .05
	elseif lag > .4 then
		lag = .4
	end
	return lag
end

--Calculate Agility
function getAgility()
	local AgiBase,AgiStat,AgiPos,AgiNeg = UnitStat("player",2)
	local Agi = AgiBase + AgiPos + AgiNeg
	return Agi
end

--if getFallTime() > 2 then
function getFallTime()
	if fallStarted==nil then fallStarted = 0 end
	if fallTime==nil then fallTime = 0 end
	if IsFalling() then
		if fallStarted == 0 then
			fallStarted = GetTime()
		end
		if fallStarted ~= 0 then
			fallTime = (math.floor((GetTime() - fallStarted)*1000)/1000)
		end
	end
	if not IsFalling() then
		fallStarted = 0
		fallTime = 0
	end
	return fallTime
end



-- if getLineOfSight("target"[,"target"]) then
function getLineOfSight(Unit1,Unit2)
	if Unit2 == nil then
		if Unit1 == "player" then
			Unit2 = "target"
		else
			Unit2 = "player"
		end
	end
	local skipLoSTable = {
		56754, -- Azure Serpent (Shado'pan Monestary)
		56895, -- Weak Spot - Raigon (Gate of the Setting Sun)
		76585, 	-- Ragewing
		77692, 	-- Kromog
		77182, 	-- Oregorger
		96759, 	-- Helya
		100360,	-- Grasping Tentacle (Helya fight)
		100354,	-- Grasping Tentacle (Helya fight)
		100362,	-- Grasping Tentacle (Helya fight)
		98363,	-- Grasping Tentacle (Helya fight)
		99803, -- Destructor Tentacle (Helya fight)
		99801, -- Destructor Tentacle (Helya fight)
		98696, 	-- Illysanna Ravencrest (Black Rook Hold)
		114900, -- Grasping Tentacle (Trials of Valor)
		114901, -- Gripping Tentacle (Trials of Valor)
		116195, -- Bilewater Slime (Trials of Valor)
		120436, -- Fallen Avatar (Tomb of Sargeras)
		116939, -- Fallen Avatar (Tomb of Sargeras)
		118462, -- Soul Queen Dejahna
		119072, -- Desolate Host
		118460, -- Engine of Souls
		--86644, -- Ore Crate from Oregorger boss

	}
	for i = 1,#skipLoSTable do
		if GetObjectID(Unit1) == skipLoSTable[i] or GetObjectID(Unit2) == skipLoSTable[i] then
			return true
		end
	end
	if GetObjectExists(Unit1) and GetUnitIsVisible(Unit1) and GetObjectExists(Unit2) and GetUnitIsVisible(Unit2) then
		local X1,Y1,Z1 = GetObjectPosition(Unit1)
		local X2,Y2,Z2 = GetObjectPosition(Unit2)
		if TraceLine(X1,Y1,Z1 + 2,X2,Y2,Z2 + 2, 0x10) == nil then
			return true
		else
			return false
		end
	else
		return true
	end
end
-- if getGround("target"[,"target"]) then
function getGround(Unit)
	if GetObjectExists(Unit) and GetUnitIsVisible(Unit) then
		local X1,Y1,Z1 = GetObjectPosition(Unit)
		if TraceLine(X1,Y1,Z1,X1,Y1,Z1-2, 0x10) == nil and TraceLine(X1,Y1,Z1,X1,Y1,Z1-2, 0x100) == nil then
			return false
		else
			return true
		end
	end
end
function getGroundDistance(Unit)
	if GetObjectExists(Unit) and GetUnitIsVisible(Unit) then
		local X1,Y1,Z1 = GetObjectPosition(Unit)
		for i = 1,100 do
			if TraceLine(X1,Y1,Z1,X1,Y1,Z1-i/10, 0x10) ~= nil or TraceLine(X1,Y1,Z1,X1,Y1,Z1-i/10, 0x100) ~= nil then
				return i/10
			end
		end
	else
		return 0
	end
end
-- if getPetLineOfSight("target"[,"target"]) then
function getPetLineOfSight(Unit)
	if GetObjectExists(Unit) and GetUnitIsVisible("pet") and GetUnitIsVisible(Unit) then
		local X1,Y1,Z1 = GetObjectPosition("pet")
		local X2,Y2,Z2 = GetObjectPosition(Unit)
		if TraceLine(X1,Y1,Z1 + 2,X2,Y2,Z2 + 2, 0x10) == nil then
			return true
		else
			return false
		end
	else
		return true
	end
end

--- Round
function round2(num,idp)
	mult = 10^(idp or 0)
	return math.floor(num * mult + 0.5) / mult
end
-- if getTalent(8) == true then
function getTalent(Row,Column,specGroup)
	if specGroup == nil then specGroup = GetActiveSpecGroup() end
	local _,_,_,selected = GetTalentInfo(Row,Column,specGroup)
	return selected or false
end

-- if hasEmptySlots() then
function hasEmptySlots()
	local openSlots = 0
	for i = 0, 4 do --Let's look at each bag
		local numBagSlots = GetContainerNumSlots(i)
		if numBagSlots>0 then -- Only look for slots if bag present
			openSlots = openSlots + select(1,GetContainerNumFreeSlots(i))
		end
	end
	if openSlots>0 then
		return true
	else
		return false
	end
end
-- if hasGlyph(1234) == true then
function hasGlyph(glyphid)
	for i=1,6 do
		if select(4,GetGlyphSocketInfo(i)) == glyphid or select(6,GetGlyphSocketInfo(i)) == glyphid then
			return true
		end
	end
	return false
end




-- UnitGUID("target"):sub(-15,-10)

--if isGarrMCd() then
function isGarrMCd(Unit)
	if Unit == nil then
		Unit = "target"
	end
	if GetUnitExists(Unit)
		and (UnitDebuffID(Unit,145832)
		or UnitDebuffID(Unit,145171)
		or UnitDebuffID(Unit,145065)
		or UnitDebuffID(Unit,145071)) then
		return true
	else
		return false
	end
end
-- if isInCombat("target") then
function isInCombat(Unit)
	if UnitAffectingCombat(Unit) then
		return true
	else
		return false
	end
end
-- if isInDraenor() then
function isInDraenor()
	local tContains = tContains
	local currentMapID = GetCurrentMapAreaID()
	local draenorMapIDs =
		{
			962,-- Draenor
			978,-- Ashran
			941,-- Frostfire Ridge
			976,-- Frostwall
			949,-- Gorgrond
			971,-- Lunarfall
			950,-- Nagrand
			947,-- Shadowmoon Valley
			948,-- Spires of Arak
			1009,-- Stormshield
			946,-- Talador
			945,-- Tanaan Jungle
			970,-- Tanaan Jungle - Assault on the Dark Portal
			1011,-- Warspear
		}
	if (tContains(draenorMapIDs,currentMapID)) then
		return true
	else
		return false
	end
end
function isInLegion()
	local tContains = tContains
	local currentMapID = GetCurrentMapAreaID()
	local legionMapIDs =
		{
			1007, -- Broken Isles
			1015, -- Aszuna
			1021, -- Broken Shore
			1014, -- Dalaran
			1098, -- Eye of Azshara
			1024, -- Highmountain
			1017, -- Stormheim
			1033, -- Suramar
			1018, -- Val'sharah
		}
	if (tContains(legionMapIDs,currentMapID)) then
		return true
	else
		return false
	end
end

-- if IsInPvP() then
function isInPvP()
	local inpvp = GetPVPTimer()
	if (inpvp ~= 301000 and inpvp ~= -1) or (UnitIsPVP("player") and UnitIsPVP("target")) then
		return true
	else
		return false
	end
end

--if isLongTimeCCed("target") then
-- CCs with >=20 seconds
function isLongTimeCCed(Unit)
	if Unit == nil then
		return false
	end
	local longTimeCC = {84868, 3355, 19386, 118, 28272, 28271, 61305, 61721, 161372, 61780, 161355, 126819, 161354, 115078, 20066, 9484, 6770, 1776, 51514, 107079, 10326, 8122, 154359, 2094, 5246, 5782, 5484, 6358, 115268, 339};

	-- {
	-- 	339,	-- Druid - Entangling Roots
	-- 	102359,	-- Druid - Mass Entanglement
	-- 	1499,	-- Hunter - Freezing Trap
	-- 	19386,	-- Hunter - Wyvern Sting
	-- 	118,	-- Mage - Polymorph
	-- 	115078,	-- Monk - Paralysis
	-- 	20066,	-- Paladin - Repentance
	-- 	10326,	-- Paladin - Turn Evil
	-- 	9484,	-- Priest - Shackle Undead
	-- 	605,	-- Priest - Dominate Mind
	-- 	6770,	-- Rogue - Sap
	-- 	2094,	-- Rogue - Blind
	-- 	51514,	-- Shaman - Hex
	-- 	710,	-- Warlock - Banish
	-- 	5782,	-- Warlock - Fear
	-- 	5484,	-- Warlock - Howl of Terror
	-- 	115268,	-- Warlock - Mesmerize
	-- 	6358,	-- Warlock - Seduction
	-- }
	for i=1,#longTimeCC do
		--local checkCC=longTimeCC[i]
		if UnitDebuffID(Unit,longTimeCC[i])~=nil then
			return true
		end
	end
	return false
end
-- if isLooting() then
function isLooting()
	if GetNumLootItems() > 0 then
		return true
	else
		return false
	end
end
-- if not isMoving("target") then
function isMoving(Unit)
	if GetUnitSpeed(Unit) > 0 then
		return true
	else
		return false
	end
end
-- if IsMovingTime(5) then
function IsMovingTime(time)
	if time == nil then time = 1 end
	if GetUnitSpeed("player") > 0 then
		if IsRunning == nil then
			IsRunning = GetTime()
			IsStanding = nil
		end
		if GetTime() - IsRunning > time then
			return true
		end
	else
		if IsStanding == nil then
			IsStanding = GetTime()
			IsRunning = nil
		end
		if GetTime() - IsStanding > time then
			return false
		end
	end
end
function isPlayer(Unit)
	if GetUnitExists(Unit) ~= true then
		return false
	end
	if UnitIsPlayer(Unit) == true then
		return true
	elseif UnitIsPlayer(Unit) ~= true then
		local playerNPC = {
			[72218] = "Oto the Protector",
			[72219] = "Ki the Asssassin",
			[72220] = "Sooli the Survivalist",
			[72221] = "Kavan the Arcanist"
		}
		if playerNPC[tonumber(string.match(UnitGUID(Unit),"-(%d+)-%x+$"))] ~= nil then
			return true
		end
	else
		return false
	end
end
function getStandingTime()
	return DontMoveStartTime and GetTime() - DontMoveStartTime or nil
end
--
function isStanding(Seconds)
	return IsFalling() == false and DontMoveStartTime and getStandingTime() >= Seconds or false
end
-- if IsStandingTime(5) then
function IsStandingTime(time, unit)
	if time == nil then time = 1 end
	if unit == nil then unit = "player" end
	if not IsFalling() and GetUnitSpeed(unit) == 0 then
		if IsStanding == nil then
			IsStanding = GetTime()
			IsRunning = nil
		end
		if GetTime() - IsStanding > time then
			return true
		end
	else
		if IsRunning == nil then
			IsRunning = GetTime()
			IsStanding = nil
		end
		if GetTime() - IsRunning > time then
			return false
		end
	end
end

-- if isValidTarget("target") then
function isValidTarget(Unit)
	if UnitIsEnemy("player",Unit) or isDummy(Unit) then
		if GetUnitExists(Unit) and not UnitIsDeadOrGhost(Unit) then
			return true
		else
			return false
		end
	else
		if GetUnitExists(Unit) then
			return true
		else
			return false
		end
	end
end
function isTargeting(Unit,MatchUnit)
	if MatchUnit == nil then MatchUnit = "player" end
	if GetUnit(Unit) == nil then 
		unitTarget = nil 
	elseif UnitTarget(GetUnit(Unit)) ~= nil then
		unitTarget = UnitTarget(GetUnit(Unit))
	end
	if unitTarget ~= nil then
		return unitTarget == GetUnit(MatchUnit)
	end
	return false
end
function enemyListCheck(Unit)
	local hostileOnly = isChecked("Hostiles Only")
	local distance = getDistance(Unit,"player","noMod")
	return GetObjectExists(Unit) and not UnitIsDeadOrGhost(Unit) and UnitInPhase(Unit) and distance < 50
		and (not UnitIsFriend(Unit, "player") and (not hostileOnly or (hostileOnly and (UnitIsEnemy(Unit, "player") or isTargeting(Unit) or isDummy(Unit) or UnitIsUnit(Unit,"target"))))) 
		and UnitCanAttack("player",Unit) and isSafeToAttack(Unit) and not isCritter(Unit) and getLineOfSight("player", Unit)
	-- then
	-- 	local inCombat = UnitAffectingCombat("player") or (GetObjectExists("pet") and UnitAffectingCombat("pet"))
	-- 	local hasThreat = hasThreat(Unit) or isTargeting(Unit) or (GetObjectExists("pet") and (hasThreat(Unit,"pet") or isTargeting(Unit,"pet"))) or isBurnTarget(Unit) > 0
	-- 	local playerTarget = UnitIsUnit(Unit,"target")
 --        if inCombat then
 --        	-- Only consider Units that I have threat with or have targeted or are dummies within 8yrds when in Combat.
	-- 		if (playerTarget and (#br.friend == 1 or distance < 20)) or hasThreat or (isDummy(Unit) and (distance <= 8 or playerTarget)) then return true end
	-- 	elseif not inCombat and IsInInstance() then
	-- 		-- Only consider Units that I have threat with or I am alone and have targeted when not in Combat and in an Instance.
	-- 		if (#br.friend == 1 and playerTarget) or hasThreat then return true end
	-- 	elseif not inCombat and not IsInInstance() then
	-- 		-- Only consider Units that are in 20yrs or I have targeted when not in Combat and not in an Instance.
	-- 		if (playerTarget or (not GetObjectExists("target") and distance < 20 and not next(br.enemy))) then return true end
	-- 	end
	-- end
	-- return false
end
function isValidUnit(Unit)
	if not pause(true) and Unit ~= nil and (br.enemy[Unit] ~= nil or enemyListCheck(Unit)) then 
		local distance = getDistance(Unit,"player","noMod")
		local inCombat = UnitAffectingCombat("player") or (GetObjectExists("pet") and UnitAffectingCombat("pet"))
		local hasThreat = hasThreat(Unit) or isTargeting(Unit) or (GetObjectExists("pet") and (hasThreat(Unit,"pet") or isTargeting(Unit,"pet"))) or isBurnTarget(Unit) > 0
		local playerTarget = UnitIsUnit(Unit,"target")
		if inCombat then
	    	-- Only consider Units that I have threat with or have targeted or are dummies within 8yrds when in Combat.
			if (playerTarget and (#br.friend == 1 or distance < 20)) or hasThreat or (isDummy(Unit) and (getDistance(Unit,"target","noMod") <= 8 or playerTarget)) then return true end
		elseif not inCombat and IsInInstance() then
			-- Only consider Units that I have threat with or I am alone and have targeted when not in Combat and in an Instance.
			if (#br.friend == 1 and playerTarget) or hasThreat then return true end
		elseif not inCombat and not IsInInstance() then
			-- Only consider Units that are in 20yrs or I have targeted when not in Combat and not in an Instance.
			if (playerTarget or (not GetObjectExists("target") and distance < 20 and not next(br.enemy))) then return true end
		end
	end
	return false
end
function SpecificToggle(toggle)
	if customToggle then
		return false
	elseif getOptionValue(toggle) == 1 then
        return IsLeftControlKeyDown();
    elseif getOptionValue(toggle) == 2 then
        return IsLeftShiftKeyDown();
    elseif getOptionValue(toggle) == 3 then
        return IsRightControlKeyDown();
    elseif getOptionValue(toggle) == 4 then
        return IsRightShiftKeyDown();
    elseif getOptionValue(toggle) == 5 then
        return IsRightAltKeyDown();
    elseif getOptionValue(toggle) == 6 then
       	return false
    end
end

function UpdateToggle(toggle,delay)
	--if toggle == nil then toggle = "toggle" end
	if customToggle then toggle = toggleKey end
	if _G[toggle.."Timer"] == nil then _G[toggle.."Timer"] = 0; end
    if (SpecificToggle(toggle.." Mode") or customToggle) and not GetCurrentKeyBoardFocus() and GetTime() - _G[toggle.."Timer"] > delay then
        _G[toggle.."Timer"] = GetTime()
        UpdateButton(tostring(toggle))
    end
end
function BurstToggle(toggle,delay)
	if burstKey == nil then burstKey = false end
	if _G[toggle.."Timer"] == nil then _G[toggle.."Timer"] = 0; end
    if burst and not GetCurrentKeyBoardFocus() and GetTime() - _G[toggle.."Timer"] > delay then
    	if not burstKey then
	        _G[toggle.."Timer"] = GetTime()
	        burstKey = true
    	else
    		_G[toggle.."Timer"] = GetTime()
    		burstKey = false
    	end
    end
end
function SlashCommandHelp(cmd,msg)
	if cmd == nil then cmd = "" end
	if msg == nil then msg = "" end
	if cmd == "Print Help" then Print(tostring(commandHelp)); return end
	if commandHelp == nil then
		commandHelp = "BadRotations Slash Commands\n        /"..cmd.." - "..msg
	else
		commandHelp = commandHelp.."\n        /"..cmd.." - "..msg
	end
 end
-- if pause() then
-- set skipCastingCheck to true, to not check if player is casting
-- (useful if you want to use off-cd stuff, or spells which can be cast while other is casting)
function pause(skipCastingCheck)
	-- local button = CreateFrame("Button", "DismountButton")
	-- if button == "RightButton" then
	-- 	Print("Right Clicked")
	-- end
	if SpecificToggle("Pause Mode") == nil or getValue("Pause Mode") == 6 then
		pausekey = IsLeftAltKeyDown()
	else
		pausekey = SpecificToggle("Pause Mode")
	end
	-- DPS Testing
	if isChecked("DPS Testing") then
		if GetObjectExists("target") and isInCombat("player") then
			if getCombatTime() >= (tonumber(getOptionValue("DPS Testing"))*60) and isDummy() then
				StopAttack()
				ClearTarget()
				Print(tonumber(getOptionValue("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
				profileStop = true
			else
				profileStop = false
			end
		elseif not isInCombat("player") and profileStop==true then
			if GetObjectExists("target") then
				StopAttack()
				ClearTarget()
				profileStop=false
			end
		end
	end
	-- Pause Toggle
	if br.data.settings[br.selectedSpec].toggles['Pause'] == 1 then
		ChatOverlay("\124cFFED0000 -- Paused -- ")
		return true
	end
	-- Pause Hold/Auto
	if (pausekey and GetCurrentKeyBoardFocus() == nil and isChecked("Pause Mode"))
		or profileStop
		or ((IsMounted() or IsFlying()) --and (GetObjectExists("target") and GetObjectID("target") ~= 56877)
			and not (UnitBuffID("player",190784) or UnitBuffID("player",164222)
			or UnitBuffID("player",165803) or UnitBuffID("player",157059)
			or UnitBuffID("player",157060)))
		or SpellIsTargeting()
		-- or (not UnitCanAttack("player","target") and not UnitIsPlayer("target") and GetUnitExists("target"))
		or (UnitCastingInfo("player") and not skipCastingCheck)
		or (UnitChannelInfo("player") and not skipCastingCheck)
		or UnitIsDeadOrGhost("player")
		-- or (UnitIsDeadOrGhost("target") and not UnitIsPlayer("target"))
		or UnitBuffID("player",80169) -- Eating
		or UnitBuffID("player",87959) -- Drinking
		-- or UnitBuffID("target",117961) --Impervious Shield - Qiang the Merciless
		-- or UnitDebuffID("player",135147) --Dead Zone - Iron Qon: Dam'ren
		-- or (((UnitHealth("target")/UnitHealthMax("target"))*100) > 10 and UnitBuffID("target",143593)) --Defensive Stance - General Nagrazim
		-- or UnitBuffID("target",140296) --Conductive Shield - Thunder Lord / Lightning Guardian
	then
		if (UnitCastingInfo("player") and not skipCastingCheck) or (UnitChannelInfo("player") and not skipCastingCheck) then
			return true
		else
			ChatOverlay("Profile Paused")
			if GetUnitExists("pet") and UnitAffectingCombat("pet") then PetFollow() end
			return true
		end
	else
		return false
	end
end
-- feed a var
function toggleTrueNil(var)
	if _G[var] ~= true then
		_G[var] = true
	else
		_G[var] = nil
	end
end

function spellDebug(Message)
	if imDebugging == true and getOptionCheck("Debugging Mode") then
		ChatOverlay(Message)
	end
end
-- if isChecked("Debug") then
function isChecked(Value)
	if br.data ~= nil and br.data.settings ~= nil then
		--Print(br.data.settings[br.selectedSpec]["profile"..Value.."Check"])
	    if br.data.settings[br.selectedSpec] == nil or br.data.settings[br.selectedSpec][br.selectedProfile] == nil then return false end

	    if br.data.settings[br.selectedSpec]
	        and (br.data.settings[br.selectedSpec][br.selectedProfile][Value.. "Check"]==1 or br.data.settings[br.selectedSpec][br.selectedProfile][Value.. "Check"] == true)
	    then
	        return true
	    end
	end
    return false
end
-- if isSelected("Stormlash Totem") then
function isSelected(Value)
	if br.data.settings ~= nil and (br.data.settings[br.selectedSpec].toggles["Cooldowns"] == 3 
		or (isChecked(Value) and (getValue(Value) == 3 or (getValue(Value) == 2 and br.data.settings[br.selectedSpec].toggles["Cooldowns"] == 2)))) 
	then
		return true
	end
	return false
end
-- if getValue("player") <= getValue("Eternal Flame") then
-- function getValue(Value)
-- 	if br.data~=nil then
-- 		if br.data.settings[br.selectedSpec][br.selectedProfile]~=nil then
-- 	        if br.data.settings[br.selectedSpec][br.selectedProfile][Value.."Status"] ~= nil then
-- 	            return br.data.settings[br.selectedSpec][br.selectedProfile][Value.."Status"]
-- 	        elseif br.data.settings[br.selectedSpec][br.selectedProfile][Value.."Drop"] ~= nil then
-- 	            return br.data.settings[br.selectedSpec][br.selectedProfile][Value.."Drop"]
-- 	        else
-- 	            return 0
-- 	        end
-- 		end
-- 	else
-- 		return 0
-- 	end
-- end
function getValue(Value)
    if br.data ~=nil and br.data.settings ~= nil then
    	local selectedProfile = br.data.settings[br.selectedSpec][br.selectedProfile]
        if selectedProfile ~=nil then
            if selectedProfile[Value.."Status"] ~= nil then
                return selectedProfile[Value.."Status"]
            elseif selectedProfile[Value.."Drop"] ~= nil then
                return selectedProfile[Value.."Drop"]
            else
                return 0
            end
        end
    else
        return 0
    end
end
-- used to gather informations from the bot options frame
function getOptionCheck(Value)
    return isChecked(Value)
end
function getOptionValue(Value)
    return getValue(Value)
end
function getOptionText(Value)
	if br.data ~=nil and br.data.settings ~= nil then
    	local selectedProfile = br.data.settings[br.selectedSpec][br.selectedProfile]
        if selectedProfile ~= nil then
        	if selectedProfile[Value.."Data"] ~= nil then
        		if selectedProfile[Value.."Drop"] ~= nil then
        			if selectedProfile[Value.."Data"][selectedProfile[Value.."Drop"]] ~= nil then 
            			return selectedProfile[Value.."Data"][selectedProfile[Value.."Drop"]]
					end
            	end
            end
        end
    end
    return ""
end 




function convertName(name)
    local function titleCase( first, rest )
       return first:upper()..rest:lower()
    end
    if name ~= nil then
	    -- Cap All First Letters of Words
	    name = name:gsub( "(%a)([%w_']*)", titleCase )
	    -- Lower first character of name
	    name = name:gsub("%a", string.lower, 1)
	    -- Remove all non alphanumeric in string
	    name = name:gsub('%W','')
	    return name
	end
	return "None"
end

function bossHPLimit(unit,hp)
    -- Boss Active/Health Max
    local bossHPMax = bossHPMax or 0
    local inBossFight = inBossFight or false
    local enemyList = br.player.enemies(40)
    for i = 1, #enemyList do
        local thisUnit = enemyList[i]
        if isBoss(thisUnit) then
            bossHPMax = UnitHealthMax(thisUnit)
            inBossFight = true
            break
        end
    end
    return (not inBossFight or (inBossFight and UnitHealthMax(unit) > bossHPMax * (hp / 100)))
end

function talentAnywhere()
    local removeTalent = RemoveTalent
    local learnTalent = LearnTalent
    -- Load Talent UI if not opened before
    if not IsAddOnLoaded("Blizzard_TalentUI") and not UnitAffectingCombat("player") then
       LoadAddOn("Blizzard_TalentUI")
    end

    local function talentSelection(row)
    	selectedTalent = nil
    	for column = 1, 3 do
    		if IsMouseButtonDown(1) and newTalent == nil and MouseIsOver(_G["PlayerTalentFrameTalentsTalentRow"..row.."Talent"..column]) 
    			and not select(4, GetTalentInfoByID(GetTalentInfo(row, column, 1), 1)) 
    		then
    			selectedTalent = nil
    			newTalent = select(1,GetTalentInfo(row, column, 1))
    			newTalentRow = row
    		end
    		if newTalentRow ~= nil then
	    		if select(4, GetTalentInfoByID(GetTalentInfo(newTalentRow, column, 1), 1)) then
	    			selectedTalent = select(1,GetTalentInfo(newTalentRow, column, 1))
	    		end
	    	end
    	end
    	return selectedTalent, newTalent -- selectedNew
    end

	if PlayerTalentFrame and PlayerTalentFrame:IsVisible() and not IsResting() then
        for row = 1, 7 do
        	selectedTalent, newTalent, selectedNew  = talentSelection(row)
        end
        --ChatOverlay(tostring(selectedTalent).." | "..tostring(newTalent).." | "..tostring(selectedNew))
        if newTalent ~= nil then
	        if selectedTalent ~= nil and selectedTalent ~= newTalent and not selectedNew and br.timer:useTimer("RemoveTalent", 0.1) then
	        	removeTalent(selectedTalent)
	        end
	        if selectedTalent == nil and selectedTalent ~= newTalent and not selectedNew then
	        	learnTalent(newTalent)
	        	selectedNew = true
	        end
	        if selectedTalent == newTalent then
	        	selectedNew = false
	        	newTalent = nil
	        end
	    end
    end
end