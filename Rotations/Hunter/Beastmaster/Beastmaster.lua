if select(3, UnitClass("player")) == 3 then
	function  HunterBeastmaster()

		if not UnitIsDeadOrGhost("player") then
			
			--Auto Target
			if UnitIsDeadOrGhost("target") and UnitAffectingCombat("player") then ClearTarget() end
			if not UnitExists("target") or (UnitExists("target") and (getDistance("player","target") > 40 or getLineOfSight("player","target") == false or getFacing("player","target") == false)) then
				for i = 1, #bb.friend do		
					if (bb.friend[i].role == "TANK" or UnitGroupRolesAssigned(bb.friend[i].unit) == "TANK") and UnitAffectingCombat(bb.friend[i].unit) then	
						AssistUnit(bb.friend[i].unit)
						if UnitExists("target") and getDistance("player","target") <= 40 and getLineOfSight("player","target") == true and getFacing("player","target") == true and not UnitIsDeadOrGhost("target") and UnitAffectingCombat("target") then
							StartAttack()			
							PetAttack()
						end
					end
				end
				for i = 1, #getEnemies("player",40) do
					local thisUnit = getEnemies("player",40)[i]
					local distance = getDistance("player",thisUnit)
					if UnitExists(thisUnit) and distance <= 40 and getLineOfSight("player",thisUnit) == true and getFacing("player",thisUnit) == true and not UnitIsDeadOrGhost(thisUnit) and UnitAffectingCombat(thisUnit) then
						StartAttack(thisUnit)			
						PetAttack(thisUnit)
					end
				end	
			end
			
			--Exhilaration
			if getHP("player") <= 25 or (UnitExists("pet") and not UnitIsDeadOrGhost("pet") and getHP("pet") <= 15) then
				CastSpellByName(GetSpellInfo(109304))
			end
			
			--Mend Pet
			if UnitExists("pet") and getDistance("player","pet") <= 45 and not UnitIsDeadOrGhost("pet") then
				if UnitBuffID("pet",136) == nil and getHP("pet") <= 75 then
					CastSpellByName(GetSpellInfo(136))
				end
			end
			
			--Multi Shot
			if UnitExists("pet") and getDistance("player","pet") <= 40 and not UnitIsDeadOrGhost("pet") then
				if UnitBuffID("pet",118455) == nil or getBuffRemain("pet",118455) < 1.5 then
					if #getEnemies("pet", 8) >= 2 then
						for i = 1, #getEnemies("pet",8) do
							local thisUnit = getEnemies("pet",8)[i]
							local distance = getDistance("player",thisUnit)
							if UnitExists(thisUnit) and distance <= 40 and getLineOfSight("player",thisUnit) == true and getFacing("player",thisUnit) == true and not UnitIsDeadOrGhost(thisUnit) then
								CastSpellByName(GetSpellInfo(2643),thisUnit)
							end
						end
					end
				end
			end
			
			--Dire Beast
			if UnitExists("target") and not UnitIsDeadOrGhost("target") and getLineOfSight("player","target") == true and getFacing("player","target") == true then
				if getDistance("player","target") <= 40 then
					CastSpellByName(GetSpellInfo(120679),"target")
				end
			end
			
			--Kill Command
			if UnitExists("pet") and getDistance("player","pet") <= 40 and not UnitIsDeadOrGhost("pet") then
				if UnitExists("petTarget") and not UnitIsDeadOrGhost("petTarget") and getDistance("pet","petTarget") <= 25 and getLineOfSight("pet","petTarget") == true then
					if UnitPower("player") >= 30 then
						CastSpellByName(GetSpellInfo(34026),"petTarget")
					end
				end
			end
			
			--Cobra Shot
			if UnitExists("target") and not UnitIsDeadOrGhost("target") then
				if not UnitExists("pet") or (UnitExists("pet") and (#getEnemies("pet", 8) == 1 or (#getEnemies("pet", 8) >= 2 and getBuffRemain("pet",118455) > 1.5) or getDistance("player","pet") > 40 or UnitIsDeadOrGhost("pet"))) then
					if getDistance("player","target") <= 40 and getLineOfSight("player","target") == true and getFacing("player","target") == true then
						if UnitPower("player") >= 90 or (UnitBuffID("player",193539) ~= nil and UnitPower("player") >= 85) then
							CastSpellByName(GetSpellInfo(193455),"target")
						end
					end
				end
			end

		end
		
	end
end
