if select(3, UnitClass("player")) == 3 then
	function  HunterBeastMastery()
		
		local function UnitChecks(Unit)
			if UnitExists(Unit) == true and getDistance("player",Unit) <= 40 and getLineOfSight("player",Unit) == true 
			and getFacing("player",Unit) == true and UnitIsDeadOrGhost(Unit) == false then
				return true
			end
			return false
		end
		
		local petAlive = UnitExists("pet") and not UnitIsDeadOrGhost("pet") and getDistance("player","pet") <= 40
		local inKCRange = UnitExists("petTarget") and not UnitIsDeadOrGhost("petTarget") and getDistance("pet","petTarget") <= 25 and getLineOfSight("pet","petTarget") == true 
		
		--if IsMouseButtonDown(3) then end
		--Stop Rotation
		if not UnitIsDeadOrGhost("player") and not IsMounted() and UnitBuffID("player",5384) == nil then
			
			--Clear Target
			if UnitIsDeadOrGhost("target") and UnitAffectingCombat("player") then ClearTarget() end
			
			--Auto Target
			if UnitExists("target") == false or (UnitExists("target") and (getDistance("player","target") > 40 or getLineOfSight("player","target") == false or getFacing("player","target") == false)) then
				if select(2,IsInInstance()) == "party" or select(2,IsInInstance()) == "raid" then
					for i = 1, #bb.friend do		
						if (bb.friend[i].role == "TANK" or UnitGroupRolesAssigned(bb.friend[i].unit) == "TANK") and UnitAffectingCombat(bb.friend[i].unit) and not UnitIsDeadOrGhost(bb.friend[i].unit) then	
							AssistUnit(bb.friend[i].unit)
							if UnitChecks("target") and UnitAffectingCombat("target") then
								StartAttack()			
							end
						end
					end
				else
					for i = 1, #getEnemies("player",40) do
						local thisUnit = getEnemies("player",40)[i]
						if UnitChecks(thisUnit) and UnitAffectingCombat(thisUnit) then
							StartAttack(thisUnit)			
						end
					end	
				end
			end
			
			--Change Pet Target for aoe
			if petAlive and UnitAffectingCombat("player") then
				for i = 1, #getEnemies("player",40) do
					local thisUnit = getEnemies("player",40)[i]
					if UnitChecks(thisUnit) and UnitAffectingCombat(thisUnit) then		
						if #getEnemies(thisUnit,7) >= 6 and #getEnemies("pet",7) < 6 then
							PetAttack(thisUnit)					
						elseif #getEnemies(thisUnit,7) == 5 and #getEnemies("pet",7) < 5 then
							PetAttack(thisUnit)
						elseif #getEnemies(thisUnit,7) == 4 and #getEnemies("pet",7) < 4 then
							PetAttack(thisUnit)
						elseif #getEnemies(thisUnit,7) == 3 and #getEnemies("pet",7) < 3 then
							PetAttack(thisUnit)
						elseif #getEnemies(thisUnit,7) == 2 and #getEnemies("pet",7) < 2 then
							PetAttack(thisUnit)
						end
					end
				end	
			end
			
			--Revive Pet
			if UnitExists("pet") and UnitIsDeadOrGhost("pet") then
				if not isMoving("player") then
					CastSpellByName(GetSpellInfo(982))
				end
			end
			
			--Exhilaration
			if getSpellCD(109304) <= 0.1 then
				if getHP("player") <= 25 or (petAlive and getHP("pet") <= 15) then
					CastSpellByName(GetSpellInfo(109304))
				end
			end
			
			--Mend Pet
			if getSpellCD(136) <= 0.1 then
				if petAlive then
					if UnitBuffID("pet",136) == nil and getHP("pet") <= 75 then
						CastSpellByName(GetSpellInfo(136))
					end
				end
			end
			
			--Misdirection
			if getSpellCD(34477) <= 0.1 then
				if UnitThreatSituation("player", "target") ~= nil and UnitAffectingCombat("player") then
					for i = 1, #bb.friend do		
						if (bb.friend[i].role == "TANK" or UnitGroupRolesAssigned(bb.friend[i].unit) == "TANK") and UnitAffectingCombat(bb.friend[i].unit) then	
							if UnitChecks(bb.friend[i].unit) then
								CastSpellByName(GetSpellInfo(34477),bb.friend[i].unit)
							end
						end
					end
				end
			end
			
			--Berserking
			if getSpellCD(26297) <= 0.1 then
				if UnitBuffID("player",19574) ~= nil then
					if UnitAffectingCombat("player") and UnitChecks("target") then
						CastSpellByName(GetSpellInfo(26297),"player")
					end
				end
			end
			
			--Dire Beast
			if getSpellCD(120679) <= 0.1 then
				if getSpellCD(19574) > 2 then
					for i = 1, #getEnemies("player",40) do
						local thisUnit = getEnemies("player",40)[i]
						if UnitChecks(thisUnit) then				
							if #getEnemies(thisUnit,5) >= 6 then
								CastSpellByName(GetSpellInfo(120679),thisUnit)
							elseif #getEnemies(thisUnit,5) == 5 then
								CastSpellByName(GetSpellInfo(120679),thisUnit)
							elseif #getEnemies(thisUnit,5) == 4 then
								CastSpellByName(GetSpellInfo(120679),thisUnit)
							elseif #getEnemies(thisUnit,5) == 3 then
								CastSpellByName(GetSpellInfo(120679),thisUnit)
							elseif #getEnemies(thisUnit,5) == 2 then
								CastSpellByName(GetSpellInfo(120679),thisUnit)
							end
						end
					end
				end
			end
			
			--Dire Beast
			if getSpellCD(120679) <= 0.1 then
				if getSpellCD(19574) > 2 then
					if UnitChecks("target") then
						CastSpellByName(GetSpellInfo(120679),"target")
					end
				end
			end
			
			--Aspect of the wild
			if getSpellCD(193530) <= 0.1 then
				if UnitBuffID("player",19574) ~= nil and UnitPower("player") <= 90 then
					if (petAlive and inKCRange) or UnitExists("pet") == nil then
						if UnitAffectingCombat("player") and UnitChecks("target") then					
							CastSpellByName(GetSpellInfo(193530))
						end
					end
				end
			end
			
			--Beastial Wrath
			if getSpellCD(19574) <= 0.1 then
				if (petAlive and inKCRange) or UnitExists("pet") == nil then
					if UnitAffectingCombat("player") and UnitChecks("target") then		
						CastSpellByName(GetSpellInfo(19574))
					end
				end
			end
			
			--Multi Shot
			if petAlive then
				if UnitBuffID("pet",118455) == nil or getBuffRemain("pet",118455) < 1.5 then
					if #getEnemies("pet", 7) >= 5 then
						for i = 1, #getEnemies("pet",7) do
							local thisUnit = getEnemies("pet",7)[i]
							if UnitChecks(thisUnit) then
								CastSpellByName(GetSpellInfo(2643),thisUnit)
							end
						end
					end
				end
			end
			
			--Kill Command
			if petAlive then
				if UnitPower("player") >= 30 then
					if inKCRange then
						CastSpellByName(GetSpellInfo(34026),"petTarget")
					end
				end
			end
		
			--Multi Shot
			if petAlive then
				if UnitBuffID("pet",118455) == nil or getBuffRemain("pet",118455) < 3 then
					if #getEnemies("pet", 7) >= 2 then
						for i = 1, #getEnemies("pet",7) do
							local thisUnit = getEnemies("pet",7)[i]
							if UnitChecks(thisUnit) then
								CastSpellByName(GetSpellInfo(2643),thisUnit)
							end
						end
					end
				end
			end
			
			--Cobra Shot
			if UnitPower("player") >= 90 then
				if UnitChecks("target") then
					if not UnitExists("pet") or (petAlive and (#getEnemies("pet", 7) == 1 or (#getEnemies("pet", 7) >= 2 and getBuffRemain("pet",118455) > 1.5))) or UnitIsDeadOrGhost("pet") then								
						CastSpellByName(GetSpellInfo(193455),"target")			
					end
				end
			end

		end
		
	end
end
