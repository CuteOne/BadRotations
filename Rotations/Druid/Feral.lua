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
	    WA_calcStats_feral()
	    --makeEnemiesTable(8)

--------------
--- Locals ---
--------------
		if leftCombat == nil then leftCombat = GetTime() end
		local enemies = #getEnemies("player",8)
		local enemyList = getEnemies("player",8)
		local hasMouse = UnitExists("mouseover")
		local level = UnitLevel("player")
		local php = getHP("player")
		local combo = getCombo()
		local power = getPower("player")
		local powmax = UnitPowerMax("player")
		local powgen = getRegen("player")
		local clearcast = getBuffRemain("player",cc)
		local ttm = getTimeToMax("player")
		local deadtar = UnitIsDeadOrGhost("target")
		local attacktar = canAttack("player", "target")
		local falling = getFallTime()
		local swimming = IsSwimming()
		local travel = UnitBuffID("player", trf)
		local flight = UnitBuffID("player", flf)
		local cat = UnitBuffID("player",cf) or UnitBuffID("player",cosf)
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
	    local mfTick = 20.0/(1+UnitSpellHaste("player")/100)/10
	    local rkCalc = CRKD()
	    local rpCalc = CRPD()
	    local lootDelay = getValue("LootDelay")
		local thisUnit = thisUnit
		local tarDist = tarDist
		local hasTarget = hasTarget
		local friendly = friendly
		local thp = thp
		local ttd = ttd
	    local rkRemain = rkRemain
	    local rkDuration = rkDuration
	    local stunRemain = stunRemain
	    local rpRemain = rpRemain
	    local rpDuration = rpDuration
	    local thrRemain = thrRemain
	    local thrDuration = thrDuration
	    local mfRemain = mfRemain
	    local rkDmg = rkDmg
	    local rpDmg = rpDmg
	    if useCleave() and enemies>1 then
	    	for i=1, enemies do
	    		thisUnit = enemyList[i]
			   	tarDist = getDistance(thisUnit)
				hasTarget = UnitExists(thisUnit)
				friendly = UnitIsFriend(thisUnit,"player")
				thp = getHP(thisUnit)
				ttd = getTimeToDie(thisUnit)
			    rkRemain = getDebuffRemain(thisUnit,rk,"player")
			    rkDuration = getDebuffDuration(thisUnit,rk,"player")
			    stunRemain = getDebuffRemain(thisUnit,rks,"player")
			    rpRemain = getDebuffRemain(thisUnit,rp,"player")
			    rpDuration = getDebuffDuration(thisUnit,rp,"player")
			    thrRemain = getDebuffRemain(thisUnit,thr,"player")
			    thrDuration = getDebuffDuration(thisUnit,thr,"player")
			    mfRemain = getDebuffRemain(thisUnit,mf,"player")
		    	rkDmg = RKD(thisUnit)
		    	rpDmg = RPD(thisUnit)
		    end
		else
			thisUnit = "target"
			tarDist = getDistance("target")
			hasTarget = UnitExists("target")
			friendly = UnitIsFriend("target","player")
			thp = getHP("target")
			ttd = getTimeToDie("target")
		    rkRemain = getDebuffRemain("target",rk,"player")
		    rkDuration = getDebuffDuration("target",rk,"player")
		    stunRemain = getDebuffRemain("target",rks,"player")
		    rpRemain = getDebuffRemain("target",rp,"player")
		    rpDuration = getDebuffDuration("target",rp,"player")
		    thrRemain = getDebuffRemain("target",thr,"player")
		    thrDuration = getDebuffDuration("target",thr,"player")
		    mfRemain = getDebuffRemain("target",mf,"player")
	    	rkDmg = RKD("target")
	    	rpDmg = RPD("target")
	    end
--------------------------------------------------
--- Ressurection/Dispelling/Healing/Pause/Misc ---
--------------------------------------------------
	-- Flying Form
		if isChecked("Auto Shapeshifts") then
		    if (falling > 1 or (not swimming and travel)) and not isInCombat("player") and IsFlyableArea() then
		        if ((not travel and not flight) or (not swimming and travel)) and level>=58 and not isInDraenor() then
		            if stag then
		                if castSpell("player",flf,true,false,false) then return end
		            elseif not stag then
		                if castSpell("player",trf,true,false,false) then return end
		            end
		        elseif not cat then
		            if castSpell("player",cf,true,false,false) then return end
		        end
		    end
	-- Aquatic Form
		    if swimming and not travel and not hasTarget and not isInCombat("player") then
		        if castSpell("player",trf,true,false,false) then return end
		    end
	-- Cat Form
	
		    if ((not dead and hastar and not friendly and attacktar and tarDist<=40)
		    		or (isMoving("player") and not travel and not IsFalling()))
		        and (not IsFlying() or (IsFlying() and targetDistance<10))
		        and not cat 
		        and (falling==0 or tarDist<10)
		    then
				
		        if castSpell("player",cf,true,false,false) then return end
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
                    if castSpell("player",tf,false,false,false) then return end
                end
                if combo >= 5 and power>25 then
                    if castSpell("player",svr,true,false,false) then return end
                end
                if power > 40 and enemies == 1 then
			    	for i = 1, #enemiesTable do
			    		if enemiesTable[i].distance<8 then
							thisUnit = enemiesTable[i].unit
							unitHP = enemiesTable[i].hp
							unitDist = enemiesTable[i].distance
							urkRemain = getDebuffRemain(thisUnit,rk,"player")
							urpRemain = getDebuffRemain(thisUnit,rp,"player")
							uthrRemain = getDebuffRemain(thisUnit,thr,"player")
							umfRemain = getDebuffRemain(thisUnit,mf,"player")
							uttd = getTimeToDie(thisUnit)
                            if getDistance(thisUnit) < 5 and getFacing(thisUnit) == true then
                                if castSpell(thisUnit,shr,false,false,false) then swipeSoon = nil; return end
                            end
                        end
                    end
                end
                if power > 45 and enemies > 1 then
                    if swipeSoon == nil then
                        swipeSoon = GetTime();
                    end
                    if swipeSoon ~= nil and swipeSoon < GetTime() - 1 then
                        if castSpell("player",sw,false,false) then swipeSoon = nil; return end
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
	                        if castSpell("player",mow,true,false,false) then return end
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
	                    if castSpell("player",rej,true,false,false) then return end
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
	                if castSpell("player",nv,true,false,false) then return end
	            end
-- Healing Touch
	            if isChecked("Healing Touch") and ((psRemain>0 and php <= getValue("Healing Touch")) or (not isInCombat("player") and rejRemain>0 and php<=getValue("Rejuvenation"))) then
	                if castSpell("player",ht,true,false,false) then return end
	            end
-- Survival Instincts
	            if isChecked("Survival Instincts") and php <= getValue("Survival Instincts") and isInCombat("player") and not siBuff and siCharge>0 then
	                if castSpell("player",si,true,false,false) then return end
	            end
    		end
---------------------
--- Out of Combat ---
---------------------
			if not isInCombat("player") and cat and ((not (IsMounted() or IsFlying() or friendly)) or isDummy()) then
		-- Prowl
		        if useProwl() and not stealth and (tarDist<20 or isKnown(eprl)) and GetTime()-leftCombat > lootDelay then
					if castSpell("player",prl,false,false,false) then return end
		        end
		-- Rake/Shred
		        if isInMelee() and power>40 and tarDist<5 then
		        	if isKnown(irk) then
		        		if castSpell("target",rk,false,false,false) then return end
		        	else
		            	if castSpell("target",shr,false,false,false) then return end
		            end
		        end
			end
-----------------
--- In Combat ---
-----------------
			if isInCombat("player") and not cat then
				if castSpell("player",cf,true,false,false) then return end
			end
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
			            if castSpell("target",sb,false,false,false) then return end
			        end
		-- Mighty Bash
			        if isChecked("Mighty Bash")
			            and (sbCooldown < 14 or not isChecked("Skull Bash"))
			            and tarDist<=5
			        then
			            if castSpell("target",mb,false,false,false) then return end
			        end
		-- Maim (PvP)
			        if (sbCooldown < 14 or not isChecked("Skull Bash"))
			            and (mbCooldown < 49 or not isChecked("Mighty Bash"))
			            and combo > 0
			            and power >= 35
			            and isInPvP()
			            and tarDist<=5
			        then
			            if castSpell("target",ma,false,false,false) then return end
			        end
			    end
	-----------------------------
	--- In Combat - Cooldowns ---
	-----------------------------
				if useCDs() and not stealth and tarDist<5 then
		-- Tier 4 Talent: Force of Nature
			        if fonCooldown == 0 then
			            if fonCharge == 3 or (fonCharge == 2 and (fonRecharge - GetTime()) > 19) then
			                if castSpell("target",fon,true,false,false) then return end
			            elseif (vicious>0 and vicious<1)
			                or restlessagi==20
			                or ttd<20
			            then
			                if castSpell("target",fon,true,false,true) then return end
			            end
		            end
		-- Agi-Pot
		            if canUse(76089) and ttd<=40 and select(2,IsInInstance())=="raid" and isChecked("Agi-Pot") then
		                UseItemByName(tostring(select(1,GetItemInfo(76089))))
		            end
		-- Racial: Troll Berserking
		            if select(2, UnitRace("player")) == "Troll" and power >= 75 and tfRemain>0 then
		                if castSpell("player",rber,true,false,false) then return end
		            end
		-- Tier 4 Talent: Incarnation - King of the Jungle
		            if berCooldown<10 and ttm>1 then
		                if castSpell("player",inc,true,false,false) then return end
		            end
		-- Berserk
		            if tfRemain>0 and ttd >= 18 then
		    -- Agi-Pot
		            	if canUse(76089) and thp <= 25 and select(2,IsInInstance())=="raid" and isChecked("Agi-Pot") then
		                	UseItemByName(tostring(select(1,GetItemInfo(76089))))
		            	end
		                if castSpell("player",ber,true,false,false) then return end
		            end
		-- Racial: Night Elf Shadowmeld
					if rkRemain<4.5 and power>=35 and rkDmg<2 and (btRemain>0 or not getTalent(7,2)) and (not getTalent(4,2) or incCooldown>15) and not incarnation then
						if castSpell("player",sm,false,false) then return end
					end
		        end
	------------------------------------------
	--- In Combat Rotation ---
	------------------------------------------
		-- Rake/Shred from Stealth
				if stealth and power>40 and tarDist<5 then
					if isKnown(irk) then
		        		if castSpell("target",rk,false,false,false) then return end
		        	else
		            	if castSpell("target",shr,false,false,false) then return end
		            end
				end
				if not stealth then
		-- Tiger's Fury
					if (not clearcast and powmax-power>=60) or powmax-power>=80 and tarDist<5 then
						if canTrinket(13) and useCDs() then
							RunMacroText("/use 13")
						end
						if canTrinket(14) and useCDs() then
							RunMacroText("/use 14")
						end
						if castSpell("player",tf,true,false,false) then return end
					end
		-- Ferocious Bite
					--if=dot.rip.ticking&dot.rip.remains<3&target.health.pct<25
					if rpRemain>0 and rpRemain<3 and power>25 and thp<25 and tarDist<5 then
						if castSpell(thisUnit,fb,false,false,false) then return end
					end
		-- Healing Touch
					if psRemain>0 and ((combo>=4 and getTalent(7,2)) or psRemain<1.5) then
						if getValue("Auto Heal")==1 then
		                    if castSpell(nNova[1].unit,ht,true,false,false) then return end
		                end
		                if getValue("Auto Heal")==2 then
		                    if castSpell("player",ht,true,false,false) then return end
		                end
					end
		-- Savage Roar
					if srRemain<3 and combo>0 and power>25 and tarDist<5 then
						if castSpell("player",svr,true,false,false) then return end
		            end
		-- Thrash
					--if=buff.omen_of_clarity.react&remains<4.5&active_enemies>1
					if clearcast and thrRemain<4.5 and enemies>1 and tarDist<8 and useCleave() then
						if castSpell(thisUnit,thr,true,false,false) then return end
					end
					--if=!talent.bloodtalons.enabled&combo_points=5&remains<4.5&buff.omen_of_clarity.react
					if not getTalent(7,2) and combo==5 and thrRemain<4.5 and clearcast and tarDist<8 and useCleave() then
						if castSpell(thisUnit,thr,true,false,false) then return end
					end
					--pool_resource,for_next=1
					if thrRemain<4.5 and enemies>1 and power<=50 and useCleave() then
						return true
					end
					--if=remains<4.5&active_enemies>1
					if thrRemain<4.5 and enemies>1 and power>50 and useCleave() then
						if castSpell(thisUnit,thr,true,false,false) then return end
					end
		-- Ferocious Bite
					--max_energy=1,if=target.health.pct<25&dot.rip.ticking
					if combo==5 and power>50 and thp<25 and rpRemain>0 and tarDist<5 then
						if castSpell(thisUnit,fb,false,false,false) then return end
					end
		-- Rip
					--if=remains<3&target.time_to_die-remains>18
					if combo==5 and rpRemain<3 and ttd-rpRemain>18 and power>30 and tarDist<5 then
						if castSpell(thisUnit,rp,false,false,false) then return end
					end
					--if=remains<7.2&persistent_multiplier>dot.rip.pmultiplier&target.time_to_die-remains>18
					if combo==5 and rpRemain<7.2 and rpCalc>rpDmg and ttd-rpRemain>18 and power>30 and tarDist<5 then
						if castSpell(thisUnit,rp,false,false,false) then return end
					end
		-- Savage Roar
					--if=(energy.time_to_max<=1|buff.berserk.up|cooldown.tigers_fury.remains<3)&buff.savage_roar.remains<12.6
					if combo==5 and (ttm<=1 or berserking or tfCooldown<3) and srRemain<12.6 and power>25 and tarDist<5 then
						if castSpell("player",svr,true,false,false) then return end
		            end
		-- Ferocious Bite
					--if=(energy.time_to_max<=1|buff.berserk.up|cooldown.tigers_fury.remains<3)
	    			if combo==5 and (ttm<=1 or berserking or tfRemain<3) and power>50 and tarDist<5 then
		    			if castSpell("target",fb,false,false,false) then return end
		            end
	    -- Rake 
	    			--if=!talent.bloodtalons.enabled&remains<3&combo_points<5&((target.time_to_die-remains>3&active_enemies<3)|target.time_to_die-remains>6)
	    			if not getTalent(7,2) and rkRemain<3 and combo<5 and ((ttd-rkRemain>3 and enemies<3) or ttd-rkRemain>6) and power>35 and tarDist<5 then
	    				if castSpell(thisUnit,rk,false,false,false) then return end
	    			end
	    			--if=!talent.bloodtalons.enabled&remains<4.5&combo_points<5&persistent_multiplier>dot.rake.pmultiplier&((target.time_to_die-remains>3&active_enemies<3)|target.time_to_die-remains>6)
	    			if not getTalent(7,2) and rkRemain<4.5 and combo<5 and rkCalc>rkDmg and ((ttd-rkRemain>3 and enemies<3) or ttd-rkRemain>6) and power>35 and tarDist<5 then
	    				if castSpell(thisUnit,rk,false,false,false) then return end
	    			end
	    			--if=talent.bloodtalons.enabled&remains<4.5&combo_points<5&(!buff.predatory_swiftness.up|buff.bloodtalons.up|persistent_multiplier>dot.rake.pmultiplier)&((target.time_to_die-remains>3&active_enemies<3)|target.time_to_die-remains>6)
	    			if getTalent(7,2) and rkRemain<4.5 and combo<5 and (psRemain==0 or btRemain>0 or rkCalc>rkDmg) and ((ttd-rkRemain>3 and enemies<3) or ttd-rkRemain>6) and power>35 and tarDist<5 then
						if castSpell(thisUnit,rk,false,false,false) then return end
	    			end
		-- Thrash
					--if=talent.bloodtalons.enabled&combo_points=5&remains<4.5&buff.omen_of_clarity.react		
		    		if getTalent(7,2) and combo==5 and thrRemain<4.5 and clearcast and tarDist<8 then
		    			if castSpell(thisUnit,thr,true,false,false) then return end
		    		end
		-- Moonfire
					--if=combo_points<5&remains<4.2&active_enemies<6&target.time_to_die-remains>tick_time*5
		    		if getTalent(7,1) and mfRemain<4.2 and enemies<6 and ttd-mfRemain>mfTick*5 then
		    			if castSpell(thisUnit,mf,true,false,false) then return end
		    		end 	        
	    -- Rake
	    			--persistent_multiplier>dot.rake.pmultiplier&combo_points<5&active_enemies=1
		    		if rkCalc>rkDmg and combo<5 and enemies==1 and power>35 and tarDist<5 then
		    			if castSpell(thisUnit,rk,false,false,false) then return end
		            end
	    -- Swipe
		    		if useAoE() and power>45 and combo<5 then
		    			if castSpell("player",sw,false,false,false) then return end
		            end
	    -- Shred
		    		if not useAoE() and power>40 and combo<5 and tarDist<5 then
		    			if castSpell("target",shr,false,false,false) then return end
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