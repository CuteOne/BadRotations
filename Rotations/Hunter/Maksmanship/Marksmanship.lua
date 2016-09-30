if select(3, UnitClass("player")) == 3 then
	function HunterMarksmanship()
		
		local function UnitChecks(Unit)
			if UnitExists(Unit) == true and getDistance("player",Unit) <= 40 and getLineOfSight("player",Unit) == true 
			and getFacing("player",Unit) == true and UnitIsDeadOrGhost(Unit) == false then
				return true
			end
			return false
		end
		
		local current_focus = UnitPower("player")
		local max_focus = UnitPowerMax("player")
		local focus_defecit = (max_focus - current_focus)
		local focus_regen = round2(select(2,GetPowerRegen("player")),2)
		local aimed_shot_cast_time = select(4,GetSpellInfo(19434)) / 1000
		local aimed_shot_regen = (aimed_shot_cast_time * focus_regen)
		--185365 hunters mark
		--187131 vuln
		--194594 lnl
		--223138 buff marking targets applies 185365 
		
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
			
			--Exhilaration
			if getSpellCD(109304) <= 0.1 then
				if getHP("player") <= 25 then
					CastSpellByName(GetSpellInfo(109304))
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
				if UnitAffectingCombat("player") and UnitChecks("target") then
					CastSpellByName(GetSpellInfo(26297),"player")
				end
			end
			
			--Trueshot
			if getSpellCD(193526) <= 0.1 then
				if UnitAffectingCombat("player") and UnitChecks("target") then
					CastSpellByName(GetSpellInfo(193526),"player")
				end
			end
		
			--Marked Shot Vuln
			if UnitPower("player") >= 30 then
				for i = 1, #getEnemies("player",40) do
					local thisUnit = getEnemies("player",40)[i]
					if UnitChecks(thisUnit) then
						--Hunters Mark
						if UnitDebuffID(thisUnit,185365,"player") ~= nil and UnitPower("player") >= 30 then
							if ((getDebuffRemain(thisUnit,187131,"player") < aimed_shot_cast_time) and getDebuffRemain(thisUnit,187131,"player") >= 1) 
							or UnitDebuffID(thisUnit,187131,"player") == nil then
								CastSpellByName(GetSpellInfo(185901),thisUnit)
							end
						end
					end
				end
			end
						
			--actions+=/aimed_shot,if=buff.lock_and_load.up&debuff.vulnerability.remains>gcd.max
			if not isMoving("player") then
				if UnitBuffID("player",194594) ~= nil then
					for i = 1, #getEnemies("player",40) do
						local thisUnit = getEnemies("player",40)[i]
						if UnitChecks(thisUnit) then
							if getDebuffRemain(thisUnit,187131,"player") > 1.5 then
								CastSpellByName(GetSpellInfo(19434),thisUnit)
							end
						end
					end
			--actions+=/aimed_shot,if=cast_time<debuff.vulnerability.remains&(focus+cast_regen>80|debuff.hunters_mark.down)
				elseif UnitPower("player") >= 50 then
					for i = 1, #getEnemies("player",40) do
						local thisUnit = getEnemies("player",40)[i]
						if UnitChecks(thisUnit) then
							if (aimed_shot_cast_time < getDebuffRemain(thisUnit,187131,"player")) 
							and ((UnitPower("player") + aimed_shot_regen > 80) or UnitDebuffID(thisUnit,185365,"player") == nil) then
								CastSpellByName(GetSpellInfo(19434),thisUnit)
							end
						end
					end
				end
			end
						
			--actions+=/marked_shot
			if UnitPower("player") >= 30 then
				for i = 1, #getEnemies("player",40) do
					local thisUnit = getEnemies("player",40)[i]
					if UnitChecks(thisUnit) then
						if UnitDebuffID(thisUnit,185365,"player") ~= nil then
							CastSpellByName(GetSpellInfo(185901),thisUnit)		
						end			
					end
				end
			end
						
			--actions+=/multishot,if=spell_targets.barrage>1&(debuff.hunters_mark.down&buff.marking_targets.react|focus.time_to_max>=2)
			if UnitBuffID("player",223138) ~= nil then
				for i = 1, #getEnemies("player",40) do
					local thisUnit = getEnemies("player",40)[i]
					if UnitChecks(thisUnit) then
						if UnitDebuffID(thisUnit,185365,"player") == nil or getTimeToMax("player") >= 2 then
							if #getEnemies(thisUnit,7) >= 6 then
								CastSpellByName(GetSpellInfo(2643),thisUnit)
							elseif #getEnemies(thisUnit,7) == 5 then
								CastSpellByName(GetSpellInfo(2643),thisUnit)
							elseif #getEnemies(thisUnit,7) == 4 then
								CastSpellByName(GetSpellInfo(2643),thisUnit)
							elseif #getEnemies(thisUnit,7) == 3 then
								CastSpellByName(GetSpellInfo(2643),thisUnit)
							elseif #getEnemies(thisUnit,7) == 2 then
								CastSpellByName(GetSpellInfo(2643),thisUnit)
							end
						end
					end
				end
			end

			--actions+=/arcane_shot,if=spell_targets.barrage=1&(debuff.hunters_mark.down&buff.marking_targets.react|focus.time_to_max>=2)
			if UnitBuffID("player",223138) ~= nil then
				if #getEnemies("target",7) == 1 then
					if UnitChecks("target") then
						if UnitDebuffID("target",185365,"player") == nil or getTimeToMax("player") >= 2 then
							CastSpellByName(GetSpellInfo(185358),"target")
						end
					end
				end
			end

			--actions+=/multi_shot,if=focus.deficit<10
			for i = 1, #getEnemies("player",40) do
				local thisUnit = getEnemies("player",40)[i]
				if UnitChecks(thisUnit) then
					if #getEnemies(thisUnit,7) >= 6 then
						CastSpellByName(GetSpellInfo(2643),thisUnit)
					elseif #getEnemies(thisUnit,7) == 5 then
						CastSpellByName(GetSpellInfo(2643),thisUnit)
					elseif #getEnemies(thisUnit,7) == 4 then
						CastSpellByName(GetSpellInfo(2643),thisUnit)
					elseif #getEnemies(thisUnit,7) == 3 then
						CastSpellByName(GetSpellInfo(2643),thisUnit)
					elseif #getEnemies(thisUnit,7) == 2 then
						CastSpellByName(GetSpellInfo(2643),thisUnit)
					end		
				end
			end

			--actions+=/arcane_shot,if=focus.deficit<10
			if #getEnemies("target",7) == 1 then
				if UnitChecks("target") then
					CastSpellByName(GetSpellInfo(185358),"target")
				end
			end
			
		end
	
	end
end
