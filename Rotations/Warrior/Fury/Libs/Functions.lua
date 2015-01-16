if select(3, UnitClass("player")) == 1 then

	function HasLust()
		if UnitBuffID("player",2825) or UnitBuffID("player",80353) or UnitBuffID("player",32182) or UnitBuffID("player",90355) then
			return true
		else
			return false
		end
	end

	function CanCast(SpellID)
		if IsPlayerSpell(SpellID) then
			if select(2,GetSpellCooldown(SpellID)) == 0 or select(2,GetSpellCooldown(SpellID)) < 0.1 then
				return true
			end
		end
		return false
	end

	function InRange(SpellID)
		if IsSpellInRange(tostring(GetSpellInfo(SpellID)), "target") == 1 then
			return true
		end
	end

	function CanAttack(Unit)
		if UnitExists(Unit) then
			if not UnitIsDeadOrGhost(Unit) then
				if UnitCanAttack("player",Unit) then
					return true
				end
			end
		end
		return false
	end

	function SpellCharges(SpellID)
		if select(1, GetSpellCharges(SpellID)) == nil then
			return 0
		else
			return select(1, GetSpellCharges(SpellID))
		end
	end

	function SpellCD(SpellID)
		if GetSpellCooldown(SpellID) == 0 then
			return 0
		else
			local SPELL_START, SPELL_DURATION = GetSpellCooldown(SpellID)
			local SPELL_COOLDOWN = (SPELL_START + SPELL_DURATION - GetTime())

			return SPELL_COOLDOWN
		end
	end

end