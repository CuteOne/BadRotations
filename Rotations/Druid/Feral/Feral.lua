function DruidFeral()
	if select(3, UnitClass("player")) == 11 and GetSpecialization() == 2 then
	    if Currentconfig ~= "Feral CuteOne" then
	        FeralCatConfig();
	        Currentconfig = "Feral CuteOne";
	    end
	    if not canRun() then
	    	return true
	    end
	    KeyToggles()
	    GroupInfo()
	    makeEnemiesTable(40)
--------------
--- Locals ---
--------------
		if leftCombat == nil then leftCombat = GetTime() end
		if profileStop == nil then profileStop = false end
		-- General Player Variables
		local lootDelay = getOptionValue("LootDelay")
		local hasMouse = ObjectExists("mouseover")
		local deadMouse = UnitIsDeadOrGhost("mouseover")
		local playerMouse = UnitIsPlayer("mouseover")
		local level = UnitLevel("player")
		local php = getHP("player")
		local power, powmax, powgen = getPower("player"), UnitPowerMax("player"), getRegen("player")
		local ttm = getTimeToMax("player")
		local enemies, enemiesList = #getEnemies("player",8), getEnemies("player",8)
		local falling, swimming = getFallTime(), IsSwimming()
		--General Target Variables
		local dynamicUnit = {
			["dyn5"] = dynamicTarget(5,true), --Melee
			["dyn8"] = dynamicTarget(8,true), --Swipe
			["dyn8AoE"] = dynamicTarget(8,false), --Thrash
			["dyn20AoE"] = dynamicTarget(20,false), --Prowl
			["dyn13"] = dynamicTarget(13,true), --Skull Bash
			["dyn40AoE"] = dynamicTarget(40,false), --Cat Form/Moonfire
		}
		local deadtar, attacktar, hastar, playertar = deadtar, attacktar, hastar, UnitIsPlayer("target")
			if deadtar == nil then deadtar = UnitIsDeadOrGhost("target") end
			if attacktar == nil then attacktar = UnitCanAttack("target", "player") end
			if hastar == nil then hastar = ObjectExists("target") end
		local thisUnit = thisUnit
			if thisUnit == nil then thisUnit = "target" end
		local tarDist = tarDist
			if tarDist == nil then tarDist = getDistance("player","target") end
		local friendly = friendly
			if friendly == nil then friendly = UnitIsFriend("target", "player") end
		local thp = thp
			if thp == nil then thp = getHP("target") end
		local ttd = ttd
			if ttd == nil then ttd = getTimeToDie("target") end
		-- Specific Player Variables
		local combo = getCombo()
		local clearcast = UnitBuffID("player",cc)
		local travel, flight, cat, stag = UnitBuffID("player", trf), UnitBuffID("player", flf), UnitBuffID("player",cf) or UnitBuffID("player",cosf), hasGlyph(114338)
		local stealth = UnitBuffID("player",prl) or UnitBuffID("player",sm)
		local rejRemain = getBuffRemain("player", rej)
		local psRemain = getBuffRemain("player", ps)
		local siBuff, siCharge = UnitBuffID("player",si), getCharges(si)
		local rbCooldown = getSpellCD(rb)
		local sbCooldown = getSpellCD(sb)
		local mbCooldown = getSpellCD(mb)
	    local srRemain = getBuffRemain("player",svr)
	    local tfRemain, tfCooldown = getBuffRemain("player",tf), getSpellCD(tf)
	    local fonCooldown, fonCharge, fonRecharge = getSpellCD(fon), getCharges(fon), getRecharge(fon)
	    local berserk, berCooldown = UnitBuffID("player",ber), getSpellCD(ber)
	    local incarnation, incBuff, incCooldown = getTalent(4,2), UnitBuffID("player",inc), getSpellCD(inc)
	    local vicious = getBuffRemain("player",148903)
	    local restlessagi = getBuffRemain("player",146310)
	    local bloodtalons, btRemain = getTalent(7,2), getBuffRemain("player",bt)
	    newSr = 18 + (6*(combo-1))
	    tt5 = 40*getRegen("player")*(5-floor(UnitPower("player")/40))
		--Specific Target Variables
	    local rkCalc, rpCalc, rkDmg, rpDmg = CRKD(), CRPD(), RKD(dynamicUnit.dyn5), RPD(dynamicUnit.dyn5)
	    local rkRemain, rkDuration, stunRemain = getDebuffRemain(dynamicUnit.dyn5,rk,"player"), getDebuffDuration(dynamicUnit.dyn5,rk,"player"), 0
	    local rpRemain, rpDuration = getDebuffRemain(dynamicUnit.dyn5,rp,"player"), getDebuffDuration(dynamicUnit.dyn5,rp,"player")
	    local thrRemain, thrDuration = getDebuffRemain(dynamicUnit.dyn8AoE,thr,"player"), getDebuffDuration(dynamicUnit.dyn8AoE,thr,"player")
	    local mfRemain, mfTick = getDebuffRemain(dynamicUnit.dyn40AoE,mf,"player"), 20.0/(1+UnitSpellHaste("player")/100)/10
	    if srRemain - rpRemain >= 0 then
	    	srrpDiff = srRemain - rpRemain
	    end
	    if rpRemain - srRemain > 0 then
	    	srrpDiff = rpRemain - srRemain
	    end
--------------------------------------------------
--- Ressurection/Dispelling/Healing/Pause/Misc ---
--------------------------------------------------
	-- Profile Stop
		if isInCombat("player") and profileStop==true then
			return true
		else
			profileStop=false
		end
	--Revive/Rebirth
		if isChecked("Mouseover Targeting") and hasMouse and deadMouse and playerMouse then
			if isInCombat("player") and rbCooldown==0 and psRemain>0 then
				if castSpell("mouseover",rb,true,true,false,false,true) then return end
			elseif not isInCombat("player") then
				if castSpell("mouseover",rv,true,true,false,false,true) then return end
			end
		elseif hastar and deadtar and playertar then
			if isInCombat("player") and rbCooldown==0 and psRemain>0 then
				if castSpell("target",rb,true,false,false,false,true) then return end
			elseif not isInCombat("player") then
				if castSpell("target",rv,true,false,false,false,true) then return end
			end
		end
	-- Remove Corruption
		if isChecked("Mouseover Targeting") and hasMouse and playerMouse and canDispel("mouseover",rc) then
			if castSpell("mouseover",rc,true,false,false) then return end
		elseif hastar and playertar and canDispel("target",rc) then
			if castSpell("target",rc,true,false,false) then return end
		end
		if canDispel("player",rc) then
			if castSpell("player",rc,true,false,false) then return end
		end
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
		        and (not IsFlying() or (IsFlying() and tarDist<10))
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
	                if castSpell(dynamicUnit.dyn5,shr,false,false,false) then swipeSoon = nil; return end
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
	        if isChecked("Mark of the Wild") and not hasmouse and not (IsFlying() or IsMounted()) and not stealth and not isInCombat("player") then
	            for i = 1, #members do --members
	                if not isBuffed(members[i].Unit,{115921,20217,1126,90363,159988,160017,160077}) 
	                	and (#nNova==select(5,GetInstanceInfo()) 
	                		or select(2,IsInInstance())=="none" 
	                		or (select(2,IsInInstance())=="party" and not UnitInParty("player")))
	                then
	                    if castSpell("player",mow,true,false,false) then return end
	                end
	            end
	        end
        -- Flask / Crystal
	        if isChecked("Flask / Crystal") and not (IsFlying() or IsMounted()) then
	            if (select(2,IsInInstance())=="raid" or select(2,IsInInstance())=="none") 
	            	and not (UnitBuffID("player",156073) or UnitBuffID("player",156064)) --Draenor Agi Flasks
	            then
	                if not UnitBuffID("player",176151) and canUse(118922) then --Draenor Insanity Crystal
	                    UseItemByName(tostring(select(1,GetItemInfo(118922))))
	                end
	            end
	        end
------------------
--- Defensives ---
------------------
			if useDefensive() and not stealth and not flight then
-- Rejuvenation
	            if isChecked("Rejuvenation") and php <= getOptionValue("Rejuvenation") then
	                if not stealth and rejRemain==0 and ((not isInCombat("player")) or isKnown(erej)) then
	                    if castSpell("player",rej,true,false,false) then return end
	                end
	            end
-- Auto Rejuvenation
				if isChecked("Auto Rejuvenation") and isKnown(erej) then
					if getOptionValue("Auto Heal")==1 and getBuffRemain(nNova[1].unit,rej)==0 and nNova[1].hp<=getOptionValue("Auto Rejuvenation") and nNova[1].unit~="player" then
	                    if castSpell(nNova[1].unit,rej,true,false,false) then return end
	                end
				end
-- Pot/Stoned
	            if isChecked("Pot/Stoned") and php <= getOptionValue("Pot/Stoned") 
	            	and isInCombat("player") and hasHealthPot() 
	            then
                    if canUse(5512) then
                        UseItemByName(tostring(select(1,GetItemInfo(5512))))
                    elseif canUse(healPot) then
                        UseItemByName(tostring(select(1,GetItemInfo(healPot))))
                    end
	            end
-- Engineering: Shield-o-tronic
				if isChecked("Shield-o-tronic") and php <= getOptionValue("Shield-o-tronic") and isInCombat("player") and canUse(118006) then
					UseItemByName(tostring(select(1,GetItemInfo(118006))))
				end
-- Tier 6 Talent: Nature's Vigil
	            if isChecked("Nature's Vigil") and php <= getOptionValue("Nature's Vigil") then
	                if castSpell("player",nv,true,false,false) then return end
	            end
-- Healing Touch
	            if isChecked("Healing Touch") 
	            	and ((psRemain>0 and php <= getOptionValue("Healing Touch")) 
	            		or (not isInCombat("player") and rejRemain>0 and php<=getOptionValue("Rejuvenation"))) 
	            then
	                if castSpell("player",ht,true,false,false) then return end
	            end
-- Survival Instincts
	            if isChecked("Survival Instincts") and php <= getOptionValue("Survival Instincts") 
	            	and isInCombat("player") and not siBuff and siCharge>0 
	            then
	                if castSpell("player",si,true,false,false) then return end
	            end
    		end
---------------------
--- Out of Combat ---
---------------------
			if hastar and attacktar and not isInCombat("player") and cat 
				and ((not (IsMounted() or IsFlying() or friendly)) or isDummy()) 
			then
		-- Prowl
		        if useProwl() and not stealth 
		        	and (ObjectExists(dynamicUnit.dyn20) or isKnown(eprl)) and GetTime()-leftCombat > lootDelay 
		        then
					if castSpell("player",prl,false,false,false) then return end
		        end
		-- Rake/Shred
		        if power>40 and getDistance(dynamicUnit.dyn5)<5 then
		        	if isKnown(irk) then
		        		if castSpell(dynamicUnit.dyn5,rk,false,false,false) then return end
		        	else
		            	if castSpell(dynamicUnit.dyn5,shr,false,false,false) then return end
		            end
		        end
		        if stealth then
		        	StopAttack()
		        end
			end
-----------------
--- In Combat ---
-----------------
			if isInCombat("player") and not cat then
				if castSpell("player",cf,true,false,false) then return end
			end
			if hastar and attacktar and isInCombat("player") and cat and profileStop==false then
	------------------------------
	--- In Combat - Dummy Test ---
	------------------------------
		-- Dummy Test
				if isChecked("DPS Testing") then
					if ObjectExists("target") then
						if getCombatTime() >= (tonumber(getOptionValue("DPS Testing"))*60) and isDummy() then
							StopAttack()
							ClearTarget()
							print(tonumber(getOptionValue("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
							profileStop = true
						end
					end
				end
	------------------------------
	--- In Combat - Interrupts ---
	------------------------------
				if useInterrupts() and not stealth then
		-- Skull Bash
			        if isChecked("Skull Bash") then
					    if castInterrupt(sb,getOptionValue("Interrupt At")) then return end
					end
		-- Mighty Bash
			        if isChecked("Mighty Bash") then
			        	if castInterrupt(mb,getOptionValue("Interrupt At")) then return end
			        end
		-- Maim (PvP)
			        if isChecked("Maim") and combo > 0 and power >= 35 and isInPvP() then
			        	if castInterrupt(ma,getOptionValue("Interrupt At")) then return end
			        end
			    end
	-----------------------------
	--- In Combat - Cooldowns ---
	-----------------------------
				if useCDs() and not stealth and ObjectExists(dynamicUnit.dyn5) then
					thisUnit = dynamicUnit.dyn5
					ttd = getTimeToDie(dynamicUnit.dyn5)
					thp = getHP(dynamicUnit.dyn5)
		-- Tier 4 Talent: Force of Nature
			        if fonCooldown == 0 then
			            if fonCharge == 3 or (fonCharge == 2 and (fonRecharge - GetTime()) > 19) then
			                if castSpell(dynamicUnit.dyn5,fon,true,false,false) then return end
			            elseif (vicious>0 and vicious<1) or restlessagi==20 or ttd<20 then
			                if castSpell(dynamicUnit.dyn5,fon,true,false,true) then return end
			            end
		            end
		-- Agi-Pot
		            if canUse(109217) and ttd<=40 and select(2,IsInInstance())=="raid" and isChecked("Agi-Pot") then
		                UseItemByName(tostring(select(1,GetItemInfo(109217))))
		            end
		-- Racial: Troll Berserking
		            if select(2, UnitRace("player")) == "Troll" and power >= 75 and tfRemain>0 then
		                if castSpell("player",rber,true,false,false) then return end
		            end
		-- Tier 4 Talent: Incarnation - King of the Jungle
		            if berCooldown<10 and ttm>1 and tarDist<5 then
		                if castSpell("player",inc,true,false,false) then return end
		            end
		-- Berserk
		            if tfRemain>0 and ttd >= 18 then
		    -- Agi-Pot
		            	if canUse(109217) and thp <= 25 and select(2,IsInInstance())=="raid" and isChecked("Agi-Pot") then
		                	UseItemByName(tostring(select(1,GetItemInfo(109217))))
		            	end
		                if castSpell("player",ber,true,false,false) then return end
		            end
		-- Racial: Night Elf Shadowmeld
					if rkRemain<4.5 and power>=35 and rkDmg<2 
						and (btRemain>0 or not bloodtalons) and (not incarnation or incCooldown>15) and not incBuff 
					then
						if castSpell("player",sm,false,false) then return end
					end
		        end
	------------------------------------------
	--- In Combat Rotation ---
	------------------------------------------
		-- Rake/Shred from Stealth
				if stealth and power>40 then
					if isKnown(irk) then
		        		if castSpell(dynamicUnit.dyn5,rk,false,false,false) then return end
		        	else
		            	if castSpell(dynamicUnit.dyn5,shr,false,false,false) then return end
		            end
				end
				if stealth then
					StopAttack()
				end
				if not stealth and isInCombat("player") and BadBoy_data['AoE'] ~= 4 then
		-- Tiger's Fury
					if ((not clearcast and powmax-power>=60) or powmax-power>=80) and ObjectExists(dynamicUnit.dyn5) then
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
					if useCleave() then
						for i=1, #enemiesTable do
							if enemiesTable[i].distance<5 then
								thisUnit = enemiesTable[i].unit
								rpRemain = getDebuffRemain(thisUnit,rp,"player")
								if power>25 and ((rpRemain>0 and rpRemain < 3 and combo>0 and enemiesTable[i].hp<25)
									or (((3.4*UnitAttackPower("player"))*combo/5)>UnitHealth(thisUnit))) 
								then
									if castSpell(thisUnit,fb,false,false,false) then return end
								end
							end
						end
					else
						thisUnit = dynamicUnit.dyn5
						if power>25 and ((rpRemain>0 and rpRemain < 3 and getHP(thisUnit)<25 and combo>0) or (((3.4*UnitAttackPower("player"))*combo/5)>UnitHealth(thisUnit))) then
							if castSpell(thisUnit,fb,false,false,false) then return end
						end
					end
		-- Healing Touch
					if psRemain>0 and ((combo>=4 and bloodtalons) or psRemain<1.5) then
						if getOptionValue("Auto Heal")==1 then
		                    if castSpell(nNova[1].unit,ht,true,false,false) then return end
		                end
		                if getOptionValue("Auto Heal")==2 then
		                    if castSpell("player",ht,true,false,false) then return end
		                end
					end
		-- Savage Roar
					if (srRemain<1 or (srRemain<rpRemain and newSr-rpRemain>1)) and combo>0 and power>25 and ObjectExists(dynamicUnit.dyn5) then --(srRemain<1 or (srRemain<rpRemain and newSr-rpRemain>1))
						if castSpell("player",svr,true,false,false) then return end
		            end
		-- Thrash
					if useCleave() or (BadBoy_data['AoE'] == 2 and not useCleave()) then
						for i=1, #enemiesTable do
							if enemiesTable[i].distance<8 then
								thisUnit = enemiesTable[i].unit
								thrRemain = getDebuffRemain(thisUnit,thr,"player")
								if thrRemain<4.5 then
									if clearcast then
										--if=buff.omen_of_clarity.react&remains<4.5&active_enemies>1
										--if=!talent.bloodtalons.enabled&combo_points=5&remains<4.5&buff.omen_of_clarity.react
										if enemies>1 or (not bloodtalons and combo==5) then
											if castSpell(thisUnit,thr,true,false,false) then return end
										end
									end
									if enemies>1 and power>50 then
										if castSpell(thisUnit,thr,true,false,false) then return end
									end
								end
							end
						end
					end
		-- Ferocious Bite
					if useCleave() then
						for i=1, #enemiesTable do
							if enemiesTable[i].distance<5 then
								thisUnit = enemiesTable[i].unit
								rpRemain = getDebuffRemain(thisUnit,rp,"player")
								ttd = getTimeToDie(thisUnit)
								--max_energy=1,if=target.health.pct<25&dot.rip.ticking
								if combo==5 and power>50 and enemiesTable[i].hp<25 and (rpRemain>0 or ttd-rpRemain<=18) then
									if castSpell(thisUnit,fb,false,false,false) then return end
								end
							end
						end
					else
						thisUnit = dynamicUnit.dyn5
						ttd = getTimeToDie(thisUnit)
						--max_energy=1,if=target.health.pct<25&dot.rip.ticking
						if combo==5 and power>50 and getHP(thisUnit)<25 and (rpRemain>0 or ttd-rpRemain<=18) then
							if castSpell(thisUnit,fb,false,false,false) then return end
						end
					end
		-- Rip
					if useCleave() then
						for i=1, #enemiesTable do
							if enemiesTable[i].distance<5 then
								thisUnit = enemiesTable[i].unit
								rpRemain = getDebuffRemain(thisUnit,rp,"player")
								ttd = getTimeToDie(thisUnit)
								if ttd-rpRemain>18 and combo==5 and power>30 then
									--if=remains<3&target.time_to_die-remains>18
									--if=remains<7.2&persistent_multiplier>dot.rip.pmultiplier&target.time_to_die-remains>18
									if rpRemain<3 or (rpRemain<7.2 and rpCalc>rpDmg) then
										if castSpell(thisUnit,rp,false,false,false) then return end
									end
								end
							end
						end
					else
						thisUnit = dynamicUnit.dyn5
						ttd = getTimeToDie(thisUnit)
						if ttd-rpRemain>18 and combo==5 and power>30 then
							--if=remains<3&target.time_to_die-remains>18
							--if=remains<7.2&persistent_multiplier>dot.rip.pmultiplier&target.time_to_die-remains>18
							if rpRemain<3 or (rpRemain<7.2 and rpCalc>rpDmg) then
								if castSpell(thisUnit,rp,false,false,false) then return end
							end
						end
					end
		-- Savage Roar
					--if=(energy.time_to_max<=1|buff.berserk.up|cooldown.tigers_fury.remains<3)&buff.savage_roar.remains<12.6
					-- if combo==5 and (ttm<=1 or berserk or tfCooldown<3) and srRemain<12.6 and power>25 and tarDist<5 then
					-- 	if castSpell("player",svr,true,false,false) then return end
		   --          end
		-- Ferocious Bite
					--if=(energy.time_to_max<=1|buff.berserk.up|cooldown.tigers_fury.remains<3)
	    			if combo==5 and (ttm<=1 or berserk or tfCooldown<3 or rpRemain>10) and power>50 then
		    			if castSpell(dynamicUnit.dyn5,fb,false,false,false) then return end
		            end
	    -- Rake 
	    			if useCleave() then
						for i=1, #enemiesTable do
							if enemiesTable[i].distance<5 then
								thisUnit = enemiesTable[i].unit
								rkRemain = getDebuffRemain(thisUnit,rk,"player")
								ttd = getTimeToDie(thisUnit)
								if ((ttd-rkRemain>3 and enemies<3) or ttd-rkRemain>6) 
									and stunRemain==0 and combo<5 and power>35
								then
									if not bloodtalons then
						    			--if=!talent.bloodtalons.enabled&remains<3&combo_points<5&((target.time_to_die-remains>3&active_enemies<3)|target.time_to_die-remains>6)
						    			--if=!talent.bloodtalons.enabled&remains<4.5&combo_points<5&persistent_multiplier>dot.rake.pmultiplier&((target.time_to_die-remains>3&active_enemies<3)|target.time_to_die-remains>6)
						    			if rkRemain<3 or (rkRemain<4.5 and rkCalc>rkDmg) then
						    				if castSpell(thisUnit,rk,false,false,false) then return end
						    			end
						    		elseif bloodtalons then
						    			--if=talent.bloodtalons.enabled&remains<4.5&combo_points<5&(!buff.predatory_swiftness.up|buff.bloodtalons.up|persistent_multiplier>dot.rake.pmultiplier)&((target.time_to_die-remains>3&active_enemies<3)|target.time_to_die-remains>6)
						    			if rkRemain<4.5 and (psRemain==0 or btRemain>0 or rkCalc>rkDmg) then
											if castSpell(thisUnit,rk,false,false,false) then return end
						    			end
						    		end
						    	end
						    end
					    end
					else
						thisUnit = dynamicUnit.dyn5
						ttd = getTimeToDie(dynamicUnit.dyn5)
						if ((ttd-rkRemain>3 and enemies<3) or ttd-rkRemain>6) and stunRemain==0 and combo<5 and power>35 then
							if not bloodtalons then
				    			--if=!talent.bloodtalons.enabled&remains<3&combo_points<5&((target.time_to_die-remains>3&active_enemies<3)|target.time_to_die-remains>6)
				    			--if=!talent.bloodtalons.enabled&remains<4.5&combo_points<5&persistent_multiplier>dot.rake.pmultiplier&((target.time_to_die-remains>3&active_enemies<3)|target.time_to_die-remains>6)
				    			if rkRemain<3 or (rkRemain<4.5 and rkCalc>rkDmg) then
				    				if castSpell(thisUnit,rk,false,false,false) then return end
				    			end
				    		elseif bloodtalons then
				    			--if=talent.bloodtalons.enabled&remains<4.5&combo_points<5&(!buff.predatory_swiftness.up|buff.bloodtalons.up|persistent_multiplier>dot.rake.pmultiplier)&((target.time_to_die-remains>3&active_enemies<3)|target.time_to_die-remains>6)
				    			if rkRemain<4.5 and (psRemain==0 or btRemain>0 or rkCalc>rkDmg) then
									if castSpell(thisUnit,rk,false,false,false) then return end
				    			end
				    		end
				    	end
				    end
		-- Thrash
					if useCleave() or (BadBoy_data['AoE'] == 2 and not useCleave()) then
						for i=1, #enemiesTable do
							if enemiesTable[i].distance<8 then
								thisUnit = enemiesTable[i].unit
								thrRemain = getDebuffRemain(enemiesTable[i].unit,thr,"player")
								--if=talent.bloodtalons.enabled&combo_points=5&remains<4.5&buff.omen_of_clarity.react		
					    		if bloodtalons and combo==5 and thrRemain<4.5 and clearcast then
					    			if castSpell(thisUnit,thr,true,false,false) then return end
					    		end
					    	end
				    	end
			    	end
		-- Moonfire
					if getTalent(7,1) then
						if useCleave() then
							for i=1, #enemiesTable do
								if enemiesTable[i].distance<40 then
									thisUnit = enemiesTable[i].unit
									mfRemain = getDebuffRemain(thisUnit,mf,"player")
									ttd = getTimeToDie(thisUnit)
									--if=combo_points<5&remains<4.2&active_enemies<6&target.time_to_die-remains>tick_time*5
						    		if mfRemain<4.2 and enemies<6 and ttd-mfRemain>mfTick*5 then
						    			if castSpell(thisUnit,mf,true,false,false) then return end
						    		end
						    	end
					    	end
					    else
					    	thisUnit = dynamicUnit.dyn40AoE
							ttd = getTimeToDie(thisUnit)
							--if=combo_points<5&remains<4.2&active_enemies<6&target.time_to_die-remains>tick_time*5
				    		if mfRemain<4.2 and enemies<6 and ttd-mfRemain>mfTick*5 then
				    			if castSpell(thisUnit,mf,true,false,false) then return end
				    		end
					    end
				   	end 	        
	    -- Rake
	    			if useCleave() then
						for i=1, #enemiesTable do
							if enemiesTable[i].distance<5 then
								thisUnit = enemiesTable[i].unit
								rkRemain = getDebuffRemain(thisUnit,rk,"player")
								ttd = getTimeToDie(thisUnit)
				    			--persistent_multiplier>dot.rake.pmultiplier&combo_points<5&active_enemies=1
					    		if rkCalc>rkDmg and stunRemain==0 and combo<5 and enemies==1 and power>35 then
					    			if castSpell(thisUnit,rk,false,false,false) then return end
					            end
					        end
				        end
				    else
				    	thisUnit = dynamicUnit.dyn5
						ttd = getTimeToDie(thisUnit)
		    			--persistent_multiplier>dot.rake.pmultiplier&combo_points<5&active_enemies=1
			    		if rkCalc>rkDmg and stunRemain==0 and combo<5 and enemies==1 and power>35 then
			    			if castSpell(thisUnit,rk,false,false,false) then return end
			            end
				    end
	    -- Swipe
		    		if useAoE() and power>45 and combo<5 then
		    			if castSpell(dynamicUnit.dyn8,sw,false,false,false) then return end
		            end
	    -- Shred
		    		if not useAoE() and power>40 and combo<5 then
		    			if castSpell(dynamicUnit.dyn5,shr,false,false,false) then return end
		            end
			    end --not stealth end
			end --In Combat End
	-- Start Attack
			if ObjectExists(dynamicUnit.dyn5) and not stealth and isInCombat("player") and cat and profileStop==false then
				StartAttack()
			end
		end
	end --Druid Function End
end --Class Check End