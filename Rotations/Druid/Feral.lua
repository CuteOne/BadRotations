if select(3, UnitClass("player")) == 11 then
	function DruidFeral()
	    if Currentconfig ~= "Feral CuteOne" then
	        FeralCatConfig();
	        Currentconfig = "Feral CuteOne";
	    end
	    if not canRun() then
	    	return true
	    end
	    KeyToggles()
	    GroupInfo()
	    makeEnemiesTable(8)
--------------
--- Locals ---
--------------
		if leftCombat == nil then leftCombat = GetTime() end
		local enemies = #enemiesTable
		local thisUnit = thisUnit
		local unitHP = unitHP
		local unitDist = unitDist
		local urkRemain = urkRemain
		local urpRemain = urpRemain
		local uthrRemain = uthrRemain
   		--local target = dynamicTarget(5,true)
		local tarDist = getDistance2("target")
		local hasTarget = UnitExists("target")
		local friendly = UnitIsFriend("target","player")
		local hasMouse = UnitExists("mouseover")
		local level = UnitLevel("player")
		local php = getHP("player")
		local thp = getHP("target")
		local combo = getCombo()
		local power = getPower("player")
		local powmax = UnitPowerMax("player")
		local powgen = getRegen("player")
		local clearcast = getBuffRemain("player",cc)
		local ttd = getTimeToDie("target")
		local ttm = getTimeToMax("player")
		local deadtar = UnitIsDeadOrGhost("target")
		local attacktar = canAttack("player", "target")
		local falling = getFallTime()
		local swimming = IsSwimming()
		local travel = UnitBuffID("player", trf)
		local flight = UnitBuffID("player", flf)
		local cat = UnitBuffID("player",cf)
		local stag = hasGlyph(114338)
		local stealth = UnitBuffID("player",prl) or UnitBuffID("player",sm)
		local rejRemain = getBuffRemain("player", rej)
		local psRemain = getBuffRemain("player", ps)
		local siBuff = UnitBuffID("player",si)
		local siCharge = getCharges(si)
		local sbCooldown = getSpellCD(sb)
		local mbCooldown = getSpellCD(mb)
	    local srRemain = getBuffRemain("player",svr)
	    local tfRemain = getBuffRemain("player",tf)
	    local tfCooldown = getSpellCD(tf)
	    local fonCooldown = getSpellCD(fon)
	    local fonCharge = getCharges(fon)
	    local fonRecharge = getRecharge(fon)
	    local berserk = UnitBuffID("player",ber)
	    local berCooldown = getSpellCD(ber)
	    local incarnation = UnitBuffID("player",inc) 
	    local incCooldown = getSpellCD(inc)
	    local vicious = getBuffRemain("player",148903)
	    local restlessagi = getBuffRemain("player",146310)
	    local btRemain = getBuffRemain("player",bt)
	    local rkRemain = getDebuffRemain("target",rk,"player")
	    local rkDuration = getDebuffDuration("target",rk,"player")
	    local rpRemain = getDebuffRemain("target",rp,"player")
	    local rpDuration = getDebuffDuration("target",rp,"player")
	    local thrRemain = getDebuffRemain("target",thr,"player")
	    local thrDuration = getDebuffDuration("target",thr,"player")
	    local mfRemain = getDebuffRemain("target",mf,"player")
	    local mfTick = 20.0/(1+UnitSpellHaste("player")/100)/10
	    local rkCalc = CRKD()
    	local rkDmg = RKD("target")
    	local rpCalc = CRPD()
    	local rpDmg = RPD("target")
    	local lootDelay = getValue("LootDelay")
    	if useCleave() or isChecked("Death Cat Mode") then
    		if enemies > 0 and hasTarget then
		    	for i = 1, enemies do
					thisUnit = enemiesTable[i].unit
					unitHP = enemiesTable[i].hp
					unitDist = enemiesTable[i].distance
					urkRemain = getDebuffRemain(thisUnit,rk,"player")
					urpRemain = getDebuffRemain(thisUnit,rp,"player")
					uthrRemain = getDebuffRemain(thisUnit,thr,"player")
					umfRemain = getDebuffRemain(thisUnit,mf,"player")
					uttd = getTimeToDie(thisUnit)
					urkCalc = CRKD()
					urkDmg = RKD(thisUnit)
					urpClac = CRPD()
					urpDmg = RPD(thisUnit)
				end
			else
				thisUnit = "target"
				unitHP = 0
				unitDist = 0
				urkRemain = getDebuffRemain(thisUnit,rk,"player")
				urpRemain = getDebuffRemain(thisUnit,rp,"player")
				uthrRemain = getDebuffRemain(thisUnit,thr,"player")
				umfRemain = getDebuffRemain(thisUnit,mf,"player")
				uttd = getTimeToDie(thisUnit)
				urkCalc = CRKD()
				urkDmg = RKD(thisUnit)
				urpClac = CRPD()
				urpDmg = RPD(thisUnit)
			end
		end
--------------------------------------------------
--- Ressurection/Dispelling/Healing/Pause/Misc ---
--------------------------------------------------
	-- Flying Form
		if isChecked("Auto Shapeshifts") then
		    if (falling > 1 or (not swimming and travel)) and not isInCombat("player") and IsFlyableArea() then
		        if ((not travel and not flight) or (not swimming and travel)) and level>=58 and not isInDraenor() then
		            if stag then
		                if castSpell("player",flf,true,false,false) then return; end
		            elseif not stag then
		                if castSpell("player",trf,true,false,false) then return; end
		            end
		        elseif not cat then
		            if castSpell("player",cf,true,false,false) then return; end
		        end
		    end
	-- Aquatic Form
		    if swimming and not travel and not hasTarget and not isInCombat("player") then
		        if castSpell("player",trf,true,false,false) then return; end
		    end
	-- Cat Form
		    if ((not dead and hastar and not friendly and attacktar and tarDist<=40)
		    		or (isMoving("player") and not travel and not IsFalling()))
		        and (not IsFlying() or (IsFlying() and targetDistance<10))
		        and not cat
		        and (falling==0 or tarDist<10)
		    then
		        if castSpell("player",cf,true,false,false) then return; end
		    end
		end
	-- PowerShift
	    if hasNoControl() then
	        for i=1, 6 do
	            if i == GetShapeshiftForm() then
	                CastShapeshiftForm(i)
	                return true
	            end
	        end
	    end
	-- Death Cat mode
		if isChecked("Death Cat Mode") and cat then
	        if hastar and tarDist > 8 then
	            ClearTarget()
	        end
            if enemies > 0 then
                if power < 35 and tfCooldown == 0 then
                    if castSpell("player",tf,false,false,false) then return; end
                end
                if combo >= 5 and power>25 then
                    if castSpell("player",svr,true,false,false) then return; end
                end
                if power > 40 and enemies == 1 then
                    if myEnemies == nil or myMultiTimer == nil or myMultiTimer <= GetTime() - 1 then
                        myEnemies, myMultiTimer = getEnemies("player",5), GetTime()
                    end
                    for i = 1, enemies do
                        if getCreatureType(enemies[i].unit) == true then
                            local thisUnit = enemies[i].unit
                            if UnitCanAttack("player",thisUnit) and getDistance2(thisUnit) <= 4 and getFacing(thisUnit) == true then
                                if castSpell(thisUnit,shr,false,false,false) then swipeSoon = nil; return; end
                            end
                        end
                    end
                end
                if power > 45 and enemies > 1 then
                    if swipeSoon == nil then
                        swipeSoon = GetTime();
                    end
                    if swipeSoon ~= nil and swipeSoon < GetTime() - 1 then
                        if castSpell("player",sw,false,false) then swipeSoon = nil; return; end
                    end
                end
            end
		end
	-- Pause
		if pause() then
			return true
		elseif not isChecked("Death Cat Mode") then
-------------
--- Buffs ---
-------------
	 -- Mark of the Wild
	        if isChecked("Mark of the Wild") and not hasmouse and not (IsFlying() or IsMounted()) then
	            for i = 1, #members do --members
	                if not isBuffed(members[i].Unit,{115921,20217,1126,90363,159988,160017,160077}) and (#nNova==select(5,GetInstanceInfo()) or select(2,IsInInstance())=="none") then
	                    --if power ~= UnitPower("player",0) then
	                    --    CancelShapeshiftForm()
	                    --else
	                        if castSpell("player",mow,true,false,false) then return; end
	                    --end
	                end
	            end
	        end
        -- Flask / Crystal
	        if isChecked("Flask / Crystal") and not (IsFlying() or IsMounted()) then
	            if (select(2,IsInInstance())=="raid" or select(2,IsInInstance())=="none") and not UnitBuffID("player",105689) then
	                if not UnitBuffID("player",127230) and canUse(86569) then
	                    UseItemByName(tostring(select(1,GetItemInfo(86569))))
	                end
	            end
	        end
------------------
--- Defensives ---
------------------
			if useDefensive() and not stealth then
-- Rejuvenation
	            if isChecked("Rejuvenation") and php <= getValue("Rejuvenation") then
	                if not stealth and rejRemain==0 and ((not isInCombat("player")) or isKnown(erej)) then
	                    if castSpell("player",rej,true,false,false) then return; end
	                end
	            end
-- Pot/Stoned
	            if isChecked("Pot/Stoned") and getHP("player") <= getValue("Pot/Stoned") and isInCombat("player") and usePot then
                    if canUse(5512) then
                        UseItemByName(tostring(select(1,GetItemInfo(5512))))
                    elseif canUse(76097) then
                        UseItemByName(tostring(select(1,GetItemInfo(76097))))
                    end
	            end
-- Tier 6 Talent: Nature's Vigil
	            if isChecked("Nature's Vigil") and php <= getValue("Nature's Vigil") then
	                if castSpell("player",nv,true,false,false) then return; end
	            end
-- Healing Touch
	            if isChecked("Healing Touch") and ((psRemain>0 and php <= getValue("Healing Touch")) or (not isInCombat("player") and rejRemain>0 and php<=getValue("Rejuvenation"))) then
	                if castSpell("player",ht,true,false,false) then return; end
	            end
-- Survival Instincts
	            if isChecked("Survival Instincts") and php <= getValue("Survival Instincts") and isInCombat("player") and not siBuff and siCharge>0 then
	                if castSpell("player",si,true,false,false) then return; end
	            end
    		end
---------------------
--- Out of Combat ---
---------------------
			if not isInCombat("player") and cat and ((not (IsMounted() or IsFlying() or friendly)) or isDummy()) then
		-- Prowl
		        if useProwl() and not stealth and (tarDist<20 or isKnown(eprl)) and GetTime()-leftCombat > lootDelay then
					if castSpell("player",prl,false,false,false) then return; end
		        end
		-- Rake/Shred
		        if isInMelee() and power>40 and tarDist<5 then
		        	if isKnown(irk) then
		        		if castSpell("target",rk,false,false,false) then return; end
		        	else
		            	if castSpell("target",shr,false,false,false) then return; end
		            end
		        end
			end
-----------------
--- In Combat ---
-----------------
			if isInCombat("player") and cat then
	------------------------------
	--- In Combat - Dummy Test ---
	------------------------------
		-- Dummy Test
				if isChecked("DPS Testing") then
					if UnitExists("target") then
						if getCombatTime() >= (tonumber(getValue("DPS Testing"))*60) and isDummy() then
							StopAttack()
							ClearTarget()
							print(tonumber(getValue("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
						end
					end
				end
	------------------------------
	--- In Combat - Interrupts ---
	------------------------------
				if useInterrupts() and not stealth and canInterrupt("target", tonumber(getValue("Interrupts"))) then
		-- Skull Bash
				    if isChecked("Skull Bash")
			            and tarDist<=13
			        then
			            if castSpell("target",sb,false,false,false) then return; end
			        end
		-- Mighty Bash
			        if isChecked("Mighty Bash")
			            and (sbCooldown < 14 or not isChecked("Skull Bash"))
			            and tarDist<=5
			        then
			            if castSpell("target",mb,false,false,false) then return; end
			        end
		-- Maim (PvP)
			        if (sbCooldown < 14 or not isChecked("Skull Bash"))
			            and (mbCooldown < 49 or not isChecked("Mighty Bash"))
			            and combo > 0
			            and power >= 35
			            and isInPvP()
			            and tarDist<=5
			        then
			            if castSpell("target",ma,false,false,false) then return; end
			        end
			    end
	-----------------------------
	--- In Combat - Cooldowns ---
	-----------------------------
				if useCDs() and not stealth then
		-- Tier 4 Talent: Force of Nature
			        if fonCooldown == 0 then
			            if fonCharge == 3 or (fonCharge == 2 and (fonRecharge - GetTime()) > 19) then
			                if castSpell("target",fon,true,false,false) then return; end
			            elseif (vicious>0 and vicious<1)
			                or restlessagi==20
			                or ttd<20
			            then
			                if castSpell("target",fon,true,false,true) then return; end
			            end
		            end
		-- Agi-Pot
		            if canUse(76089) and ttd<=40 and select(2,IsInInstance())=="raid" and isChecked("Agi-Pot") then
		                UseItemByName(tostring(select(1,GetItemInfo(76089))))
		            end
		-- Racial: Troll Berserking
		            if select(2, UnitRace("player")) == "Troll" and power >= 75 and tfRemain>0 then
		                if castSpell("player",rber,true,false,false) then return; end
		            end
		-- Tier 4 Talent: Incarnation - King of the Jungle
		            if berCooldown<10 and ttm>1 then
		                if castSpell("player",inc,true,false,false) then return; end
		            end
		-- Berserk
		            if tfRemain>0 and ttd >= 18 then
		    -- Agi-Pot
		            	if canUse(76089) and thp <= 25 and select(2,IsInInstance())=="raid" and isChecked("Agi-Pot") then
		                	UseItemByName(tostring(select(1,GetItemInfo(76089))))
		            	end
		                if castSpell("player",ber,true,false,false) then return; end
		            end
		-- Racial: Night Elf Shadowmeld
					if rkRemain<4.5 and power>=35 and rkDmg<2 and (btRemain>0 or not getTalent(7,2)) and (not getTalent(4,2) or incCooldown>15) and not incarnation then
						if castSpell("player",sm,false,false) then return; end
					end
		        end
	------------------------------------------
	--- In Combat Rotation ---
	------------------------------------------
		-- Rake/Shred from Stealth
				if stealth and power>40 and tarDist<5 then
					if isKnown(irk) then
		        		if castSpell("target",rk,false,false,false) then return; end
		        	else
		            	if castSpell("target",shr,false,false,false) then return; end
		            end
				end
				if not stealth then
		-- Tiger's Fury
					if (not clearcast and powmax-power>=60) or powmax-power>=80 then
						if castSpell("player",tf,true,false,false) then return; end
					end
		-- Ferocious Bite
					if power>25 then
						if rpRemain>0 and rpRemain<3 and thp<25 and tarDist<5 then
							if castSpell("target",fb,false,false,false) then return; end
						end
						if useCleave() then
							if urpRemain>0 and urpRemain<3 and unitHP<25 and unitDist<5 then
								if castSpell(thisUnit,fb,false,false,false) then return; end
							end
						end
					end
		-- Healing Touch
					if psRemain>0 and ((combo>=4 and getTalent(7,2)) or psRemain<1.5) then
						if getValue("Auto Heal")==1 then
		                    if castSpell(nNova[1].unit,ht,true,false,false) then return; end
		                end
		                if getValue("Auto Heal")==2 then
		                    if castSpell("player",ht,true,false,false) then return; end
		                end
					end
		-- Savage Roar
					if srRemain<3 and power>25 and tarDist<5 then
						if castSpell("player",svr,true,false,false) then return; end
		            end
	    -- Thrash
		    		if clearcast and power>50 and (enemies>1 or (not getTalent(7,2) and combo==5)) and useCleave() then
		    			if thrRemain<4.5 then
		    				if castSpell("target",thr,true,false,false) then return; end
						end
	   					if uthrRemain<4.5 then 
	   						if castSpell(thisUnit,thr,true,false,false) then return; end
	   					end
					end
		-- Thrash
					if enemies>1 and power>50 and useCleave() then
						if thrRemain<4.5 then
		    				if castSpell("target",thr,true,false,false) then return; end
						end
	   					if uthrRemain<4.5 then 
	   						if castSpell(thisUnit,thr,true,false,false) then return; end
		    			end
					end
					if combo==5 then
		-- Ferocious Bite
						if power>50 then
							if thp<25 and rpRemain>0 and tarDist<5 then
								if castSpell("target",fb,false,false,false) then return; end
							end
							if useCleave() then
								if unitHP<25 and urpRemain>0 and unitDist<5 then
									if castSpell(thisUnit,fb,false,false,false) then return; end
								end
							end
						end
		-- Rip
						if power>30 then
							if ((rpRemain<=3 and ttd-rpRemain>18) or (rpRemain<7.2 and rpCalc>rpDmg and ttd-rpRemain>18)) and tarDist<5 then
								if castSpell("target",rp,false,false,false) then return; end
							end
							if useCleave() then
								if ((urpRemain<=3 and uttd-urpRemain>18) or (urpRemain<7.2 and urpCalc>urpDmg and uttd-urpRemain>18)) and unitDist<5 then
									if castSpell(thisUnit,rp,false,false,false) then return; end
								end
							end
						end
		-- Savage Roar
						if (ttm<=1 or berserking or tfCooldown<3) and srRemain<12.6 and power>25 and tarDist<5 then
							if castSpell("player",svr,true,false,false) then return; end
			            end
	    -- Ferocious Bite
		    			if (ttm<=1 or berserking or tfRemain<3) and power>50 and tarDist<5 then
			    			if castSpell("target",fb,false,false,false) then return; end
			            end
			        end
	    -- Rake 
		    		if not getTalent(7,2) and combo<5 and power>35 then
		    			if rkRemain<3 and ((ttd-rkRemain>3 and enemies<3) or ttd-rkRemain>6) and tarDist<5 then
			    			if castSpell("target",rk,false,false,false) then return; end
			            end
		    			if useCleave() then
		    				if urkRemain<3 and ((uttd-urkRemain>3 and enemies<3) or uttd-urkRemain>6) and unitDist<5 then
		    					if castSpell(thisUnit,rk,false,false,false) then return; end
		    				end
			    		end
			        end
	    -- Rake
		    		if not getTalent(7,2) and combo<5 and power>35 then
		    			if rkRemain<4.5 and rkCalc>rkDmg and ((ttd-rkRemain>3 and enemies<3) or ttd-rkRemain>6) and tarDist<5 then
			    			if castSpell("target",rk,false,false,false) then return; end
			            end
		    			if useCleave() then
		    				if urkRemain<4.5 and urkCalc>urkDmg and ((uttd-urkRemain>3 and enemies<3) or ttd-urkRemain>6) and unitDist<5 then
		    					if castSpell(thisUnit,rk,false,false,false) then return; end
		    				end
			    		end
			        end
	    -- Rake
		    		if getTalent(7,2) and combo<5 and power>35 then
		    			if rkRemain<4.5 and (psRemain==0 or btRemain>0 or rkCalc>rkDmg) and ((ttd-rkRemain>3 and enemies<3) or ttd-rkRemain>6) and tarDist<5 then
		    				if castSpell("target",rk,false,false,false) then return; end
		            	end
		    			if useCleave() then
		    				if urkRemain<4.5 and (psRemain==0 or btRemain>0 or urkCalc>urkDmg) and ((uttd-urkRemain>3 and enemies<3) or uttd-urkRemain>6) and unitDist<5 then
		    					if castSpell(thisUnit,rk,false,false,false) then return; end
		    				end
		    			end
		            end
	    -- Thrash
		    		if getTalent(7,2) and combo==5 and clearcast and power>50 and useCleave() then
		    			if thrRemain<4.5 then
		    				if castSpell("target",thr,true,false,false) then return; end
		            	end
		    			if uthrRemain<4.5 then
		    				if castSpell(thisUnit,thr,true,false,false) then return; end
		    			end
		            end
	    -- Moonfire
		    		if getTalent(7,1) and combo<5 and enemies<6 then
		    			if mfRemain<4.2 and ttd-mfRemain>mfTick*5 and tarDist<40 then
			    			if castSpell("target",mf,true,false,false) then return; end
			    		end
		    			if useCleave() then
		    				if umfRemain<4.2 and uttd-umfRemain>mfTick*5 and unitDist<5 then
		    					if castSpell(thisUnit,mf,true,false,false) then return; end
		    				end
		    			end
			    	end 
	    -- Rake
		    		if rkCalc>rkDmg and combo<5 and enemies==1 and power>35 and tarDist<5 then
		    			if castSpell("target",rk,false,false,false) then return; end
		            end
		    		if combo<5 then
	    -- Swipe
			    		if useAoE() and power>45 then
			    			if castSpell("player",sw,false,false,false) then return; end
			            end
	    -- Shred
			    		if not useAoE() and power>40 and tarDist<5 then
			    			if castSpell("target",shr,false,false,false) then return; end
			            end
			        end
			    end --not stealth end
			end --In Combat End
	-- Start Attack
			if tarDist<5 and not stealth and isInCombat("player") and cat then
				StartAttack()
			end
		end
	end --Druid Function End
end --Class Check End