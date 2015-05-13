


-- Functions from coders for public use

--[[                                                                                                ]]
--[[ ragnar                                                                                         ]]
--[[                                                                                                ]]

function RaidBuff(BuffSlot,myBuffSpellID)
	-- description: 
		-- check for raidbuff
		-- cast raidbuff if missing

	-- how to use:
		-- Buffslots:
			-- 1 Stats
			-- 2 Stamina
			-- 3 Attack Power
			-- 4 Haste
			-- 5 Spell Power
			-- 6 Critical Strike
			-- 7 Mastery
			-- 8 Multistrike
			-- 9 Versatility

		-- RaidBuff(1)
			-- check if all members in the raid are buffed in slot 1

		-- RaidBuff(1,myBuffSpellID)
			-- use the spellID (spellID and not the spellname)
			-- check if all memebers in the raid are buffed in slot 1
			-- if one member is not buffed in slot 1 and is in range then cast your buff

	if BuffSlot==nil then return false end
	
	local class
	local spec
	local id = BuffSlot
	local SpellID = myBuffSpellID
	local bufftable = {
		stats = {1126,115921,116781,20217,160206,159988,160017,90363,160077},
		stamina = {21562,166298,469,160199,50256,160003,90364},
		attackPower = {57330,19506,6673},
		spellPower = {1459,61316,109773,160205,128433,90364,126309},
		mastery = {155522,24907,19740,116956,160198,93435,160039,128997,160073},
		haste = {55610,49868,113742,116956,160203,128432,160003,135670,160074},
		crit = {17007,1459,61316,116781,160200,90309,126373,160052,90363,126309,24604},
		multistrike = {166916,49868,113742,109773,172968,50519,57386,58604,54889,24844},
		versatility = {55610,1126,167187,167188,172967,159735,35290,57386,160045,50518,173035,160007}
	}

	local chosenTable
	if id == 1 then
		chosenTable = bufftable.stats
	elseif id == 2 then
		chosenTable = bufftable.stamina
	elseif id == 3 then
		chosenTable = bufftable.attackPower
	elseif id == 4 then
		chosenTable = bufftable.spellPower
	elseif id == 5 then
		chosenTable = bufftable.mastery
	elseif id == 6 then
		chosenTable = bufftable.haste
	elseif id == 7 then
		chosenTable = bufftable.crit
	elseif id == 8 then
		chosenTable = bufftable.multistrike
	elseif id == 9 then
		chosenTable = bufftable.versatility
	end
		
	if GetNumGroupMembers()==0 then
		if not UnitIsDeadOrGhost("player") then
			if GetRaidBuffTrayAuraInfo(id) then
				return true
			elseif not GetRaidBuffTrayAuraInfo(id) then
				if castSpell("player",SpellID) then return true end
			else 
				return false
			end
		else
			return false
		end
	else 
		if UnitIsDeadOrGhost("player") then
			return false
		else 
			for index=1,GetNumGroupMembers() do
				local name, _, subgroup, _, _, _, zone, online, isDead, _, _ = GetRaidRosterInfo(index)
				if online and not isDead and 1==IsSpellInRange(select(1,GetSpellInfo(SpellID)), "raid"..index) then
					local playerBuffed = false
					for auraIndex=1, #StaminaTable do
						local buffActive = UnitAura("raid"..index, select(1,GetSpellInfo(chosenTable[auraindex])))
						playerBuffed = playerBuffed or buffActive ~= nil
					end
					if not playerBuffed then
						if castSpell("player",SpellID) then return true end
					end
				end
			end
		end
	end
end


--[[                                                                                                ]]
--[[ Defmaster                                                                                      ]]
--[[                                                                                                ]]