if select(3, UnitClass("player")) == 11 then
	function Druid()
	    if Currentconfig ~= "Feral CuteOne" then
	        FeralCatConfig();
	        Currentconfig = "Feral CuteOne";
	    end
	    KeyToggles()
	    GroupInfo()
	    if not canRun() then
	    	return true
	    end

---------------------------------------
--- Ressurection/Dispelling/Healing ---
---------------------------------------
		if isValidTarget("mouseover")
			and UnitIsDeadOrGhost("mouseover") 
			and UnitIsPlayer("mouseover") 
			and not UnitBuffID("player", prl)
			and not UnitBuffID("player", 80169) -- Food
	  		and not UnitBuffID("player", 87959) -- Drink
	 	 	and UnitCastingInfo("player") == nil
	 	 	and UnitChannelInfo("player") == nil 
		  	and not UnitIsDeadOrGhost("player")
		  	and not IsMounted()
		  	and not IsFlying()
		  	and targetDistance <= 40
		then
	-- Rebirth
			if isInCombat("player")	and UnitBuffID("player",ps) then
				if castSpell("mouseover",rb,true) then return; end
			end

			if not isInCombat("player") then
	-- Revive
				if castSpell("mouseover",rv,true) then return; end
	-- Remove Corruption			
				if canDispel("player", rc) then
					if castSpell("player",rc,true) then return; end
				end
				if canDispel("mouseover", rc) then
					if castSpell("mouseover",rc,true) then return; end
				end
				if canDispel("target", rc) then
					if castSpell("target",rc,true) then return; end
				end
	-- Rejuvenation
				if not UnitBuffID("player", prl)
					and not UnitBuffID("player", rej)
					and getHP("player") <= 70
				then
					if castSpell("player",rej) then return; end
				end
			end
		end

-------------
--- Buffs ---
-------------	    	
	-- precombat=flask,type=spring_blossoms
	-- precombat+=/food,type=sea_mist_rice_noodles
		if not UnitBuffID("player", prl)
			and not UnitBuffID("player", 80169) -- Food
		  	and not UnitBuffID("player", 87959) -- Drink
		  	and UnitCastingInfo("player") == nil
		  	and UnitChannelInfo("player") == nil 
		  	and not UnitIsDeadOrGhost("player")
		  	and not IsMounted()
		  	and not IsFlying()
		  	and not isInCombat("player")
		 then
	-- Mark of the Wild
		   	if isChecked("Mark of the Wild") and not UnitExists("mouseover") then
			  	for i = 1, #members do
		  			if not isBuffed(members[i].Unit,{115921,20217,1126,90363}) and (#members==select(5,GetInstanceInfo()) or select(2,IsInInstance())=="none") then
		  				if UnitPower("player") ~= UnitPower("player",0) then
		  					CancelShapeshiftForm()
		  				else
		  					if castSpell("player",mow,true) then return; end
		  				end
			  		end
				end 
			end

	-- Flask / Crystal
			if isChecked("Flask / Crystal") then
				if (select(2,IsInInstance())=="raid" or select(2,IsInInstance())=="none") and not UnitBuffID("player",105689) then
					if not UnitBuffID("player",127230) and canUse(86569) then
						UseItemByName(tostring(select(1,GetItemInfo(86569))))
					end
				end
			end
		end

----------------------
--- Pre-Pot Assist ---
----------------------
	-- Cast Form
		if UnitBuffID("player",105697)
			and not UnitBuffID("player",cf)
			and not IsFlying()
		then
			if castSpell("player",cf) then return; end
		end

	-- Prowl
		if not UnitBuffID("player", tf)
			and UnitBuffID("player", cf)
			and not isInCombat("player")
			and UnitBuffID("player",105697)
		then
			if castSpell("player",prl) then return; end
		end

	-- Stampeding Roar
		if UnitBuffID("player", tf)
			and UnitBuffID("player", cf)
			and isMoving("player")
			and UnitBuffID("player",105697)
		then
			if castSpell("player",sro) then return; end
		end


-------------
--- Forms ---
------------- 		
	-- Flying Form
		if (getFallTime() > 1 or outOfWater()) and not isInCombat("player") and IsFlyableArea() then
			if not (UnitBuffID("player", sff) or UnitBuffID("player", flf)) then
				if castSpell("player", sff) then return; elseif castSpell("player", flf) then return; end
			end
		end
	-- Aquatic Form
   		if IsSwimming() and not UnitBuffID("player",af) and not UnitExists("target") then
			if castSpell("player",af) then return; end
   		end
	-- Cat Form   		
   		if isValidTarget("target") and IsFlying()==nil and targetDistance<=40 and not UnitBuffID("player",cf) and canAttack("player", "target") then
			if castSpell("player",cf) then return; end
   		end
   	-- PowerShift
   		if hasNoControl() then
   			for i=1, 6 do
				if i == GetShapeshiftForm() then
					CastShapeshiftForm(i)
				end
			end
		end

------------------
--- Defensives ---
------------------
		if isChecked("Defensive Mode") then
			if not UnitBuffID("player", prl)
				and not UnitBuffID("player", 80169) -- Food
			  	and not UnitBuffID("player", 87959) -- Drink
			  	and not UnitCastingInfo("player")
				and not UnitChannelInfo("player")
				and not UnitIsDeadOrGhost("player")
				and isInCombat("player")
			then
	-- Pot/Stoned
				if isChecked("Pot/Stoned") and getHP("player") <= getValue("Pot/Stoned") then
					if isInCombat("player") then
						if canUse(5512) then
							--useItem(5512)
							UseItemByName(tostring(select(1,GetItemInfo(5512))))
						elseif canUse(76097) then
							--useItem(76097)
							UseItemByName(tostring(select(1,GetItemInfo(76097))))
						end
					end
				end
	-- Barkskin
				if isChecked("Barkskin") and getHP("player") <= getValue("Barkskin") then
					if castSpell("player",bar,true) then return; end
				end
	-- Survival Instincts
				if isChecked("Survival Instincts") and getHP("player") <= getValue("Survival Instincts") then
					if castSpell("player",si,true) then return; end
				end
	-- Might of Ursoc / Frenzied Regeneration / Cat Form
				if isChecked("Frenzied Regen") and (UnitBuffID("player",mu) or getHP("player") <= getValue("Frenzied Regen")) then
					if debugTable[1].spellid == nil then lastSpell = 0; else lastSpell = debugTable[1].spellid; end
					if castSpell("player",mu,true) then return; end	
					if UnitBuffID("player",bf) and getSpellCD(fr)==0 and lastSpell ~= fr then
						if castSpell("player",fr,true) then return; end
					end
					if UnitBuffID("player",bf) then
						CancelShapeshiftForm();--if castSpell("player",cf) then return; end
					end
				end
			end
		end

-------------------
--- Death Cat ---
-------------------
	-- Target Free Carnage
		if isChecked("Death Cat Mode") and not (IsMounted() or IsFlying() or isCasting("player")) then
			if not UnitBuffID("player",cf) then
				if castSpell("player",cf,true) then return; end
			end
			if UnitBuffID("player",cf) and getPower("player") >= 25 then
				if UnitExists("target") ~= nil and isEnnemy("target") and targetDistance > 8 then
		  			ClearTarget();
		 		end
		 		local enemiesInRange = getNumEnnemies("player",8)
		 		if enemiesInRange > 0 then
		 			if getPower("player") <= 35 and getSpellCD(tf) == 0 then
						if castSpell("player",tf) then return; end
					end
					if getPower("player") >= 25 and getSRR() < 1 and (hasGlyph(gsr) or getCombo() > 0) then
						if castSpell("player",svr) then return; end
					end
		 			if getPower("player") >= 35 and enemiesInRange == 1 then
            			for i = 1, GetTotalObjects(TYPE_UNIT) do
            				local Guid = IGetObjectListEntry(i);
         					ISetAsUnitID(Guid,"thisUnit");
                			if UnitCanAttack("player","thisUnit") == 1 and getCreatureType("thisUnit") == true then
               			 		if getDistance("thisUnit") <= 4 and getFacing("thisUnit") == true then
                					if castSpell("thisUnit",mgl,false) then swipeSoon = nil; return; end
                				end
                			end
                		end
                	end
               		if getPower("player") >= 45 and enemiesInRange > 1 then
	            	   	if swipeSoon == nil then
		        	   		swipeSoon = GetTime();
		        	   	end
		        	   	if swipeSoon ~= nil and swipeSoon < GetTime() - 1 then
		        	   		if castSpell("player",sw,true) then swipeSoon = nil; return; end
		        	   	end
		        	end
		    	end
		    end
	    elseif not isChecked("Death Cat Mode") then

---------------------
--- Out of Combat ---
---------------------
		    if not isInCombat("player") then

	   		 	if UnitIsDeadOrGhost("target") ~= 1 and UnitExists("target") and canAttack("player", "target") and UnitBuffID("player",cf) and targetDistance<=20 then	

	--------------------------------------
	--- Out of Combat - Symbiosis Apply---
	--------------------------------------
		-- Symbiosis
					--[[if plvl >= 87 and outcom and SymMode==0 and select(2,IsInInstance())~="none" then
					    if not ubid(p,sym) and getSpellCD(sym)==0 then
					        if PQR_CustomTarget ~= symmem[1].Unit then
					            PQR_CustomTarget = symmem[1].Unit
					            if PQR_CustomTarget == "" or PQR_CustomTarget == "player" then
					                return false
					            end
					        end
					    	if sir(gsi(inn),PQR_CustomTarget)==1 then
					        	TargetUnit(PQR_CustomTarget)
					        end
					        if UnitExists(t) and UnitCanCooperate(p,t) and (UnitInParty(t) or UnitInRaid(t)) and not pcasting then
					            symcast = 1
					            cast(gsi(sym),PQR_CustomTarget)
					        end                
						end
					    if symcast==1 and not pcasting and HaveBuff("target",{110478, 110479, 110482, 110483, 110484, 110485, 110486, 110488, 110490, 110491}) then
					        symcast = 0
					        ClearTarget()
					    end        
					end]]

	-----------------------------
	--- Out of Combat - Opener ---
	-----------------------------
		-- Savage Roar
					if getSRR() <= 1 then
						if hasGlyph(gsr) or getCombo() > 0 then
							if castSpell("player",svr) then return; end
						end
					end
		-- Prowl
					if not UnitBuffID("player",prl) then
						if castSpell("player",prl) then return; end
					end
		--Opening Attack Move				
					if isInMelee() then
						if UnitBuffID("player",prl) and getFacing("target","player") ~= true then
							 if isInPvP() then
							 	if castSpell("target",pnc,false) then return; end 	--Pounce
							 else
								if castSpell("target",rvg,false) then return; end 	--Ravage
							end
						elseif canShred() then
							if hasGlyph(gsh) then
								if castSpell("target",shg) then return; end --Glyphed Shred
							else
								if castSpell("target",shr) then return; end --Shred
							end
						else
							if castSpell("target",mgl) then return; end --Mangle
						end
					end
				end --Target Alive Check End
			end --Out Of Combat Check End

-----------------
--- In Combat ---
-----------------
			if isInCombat("player") then			
	
	----------------------
	--- Rotation Pause ---
	----------------------
				if pause() then
					return true
				end

	--------------------------------------------------
	--- In Combat - Dummy Test / Cat Form Maintain ---
	--------------------------------------------------
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

		-- Cat Form Check
				if UnitBuffID("player",cf) and targetDistance<=20 then 

	------------------------------
	--- In Combat - Interrupts ---
	------------------------------
					if isChecked("Interrupt Mode") and UnitBuffID("player",cf) and not UnitBuffID("player",prl) then
		-- Skull Bash
						if canInterrupt(sb, tonumber(getValue("Interrupts"))) 
							and isChecked("Skull Bash") 
							and targetDistance<=13
						then
							if castSpell("target",sb,false) then return; end
						end
		-- Mighty Bash
						if canInterrupt(mb, tonumber(getValue("Interrupts"))) 
							and isChecked("Mighty Bash")
							and (getSpellCD(sb) < 14 or not isChecked("Skull Bash")) 
							and targetDistance<=5
						then
							if castSpell("target",mb,false) then return; end
						end
		-- Maim (PvP)
						if canInterrupt(ma, tonumber(getValue("Interrupts"))) 
						 	and (getSpellCD(sb) < 14 or not isChecked("Skull Bash"))
						 	and (getSpellCD(mb) < 49 or not isChecked("Mighty Bash")) 
						 	and getCombo() > 0 
						 	and UnitPower("player") >= 35 
						 	and isInPvP() 
						 	and targetDistance<=5
						then 
						 	if castSpell("target",ma,false) then return; end
						end
					end
					
	-----------------------------
	--- In Combat - Cooldowns ---
	-----------------------------
					if useCDs() and UnitBuffID("player",cf) and not UnitBuffID("player",prl) and targetDistance<=5 then
						if getSRR() > 0 and getBuffRemain("player",tf) > 0 then
		-- Agi-Pot			
							if canUse(76089) and getCombo() >= 4 and getHP("target") <= 25 and UnitInRaid("player") and isChecked("Agi-Pot") then
								--useItem(76089)
								UseItemByName(tostring(select(1,GetItemInfo(76089))))
							end
		-- Racial: Troll Berserking
							if select(2, UnitRace("player")) == "Troll" and getPower("player") >= 75 then
								if castSpell("player",rber) then return; end
							end
		-- Profession: Engineering Hands
							if getPower("player") >= 75 and GetInventoryItemCooldown("player",10) == 0 and not UnitBuffID("player",ber) then
								UseInventoryItem(10)
							end
		-- Berserk
							if getPower("player") >= 75 and getSpellCD(tf) > 6 and getTimeToDie("target") >= 18 then
								if castSpell("player",ber) then return; end
							end
		-- Tier 4 Talent: Incarnation - King of the Jungle
							if getTimeToDie("target") >= 15 and UnitBuffID("player",ber) then
								if castSpell("player",inb) then return; end
							end
		-- Tier 6 Talent: Nature's Vigil
							if getTimeToDie("target") >= 15 and getPower("player") >= 75 then
								if castSpell("player",nv) then return; end
							end
						end
		-- Tier 4 Talent: Force of Nature
						if getSpellCD(fon) == 0 then
							if select(1, GetSpellCharges(fon)) == 3 or (select(1, GetSpellCharges(fon)) == 2 and (select(3, GetSpellCharges(fon)) - GetTime()) > 19) then
								if castSpell("target",fon,true,false,false) then return; end
							elseif (getBuffRemain("player",148903)>0 and getBuffRemain("player",148903)<1 ) 
								or (getBuffStacks("player",146310)==20) 
								or (getRoRoRemain()>0 and getRoRoRemain()<1) or getTimeToDie("target")<20 
								or (getBuffRemain("player",61336)>0 and getBuffRemain("player",61336)<1 ) then
								if castSpell("target",fon,true,false,true) then return; end
							end
						end 
					end
					
	-----------------------------------
	--- In Combat - Symbiosis Usage ---
	-----------------------------------
		-- Symbiosis				
					if getBuffRemain("player",sym)>0 then
					    -- if isKnown(symwar) and getSpellCD(symwar)==0 and useCDs() then
					    --     if castSpell("target",symwar,false) then return; end
					    -- end
					    -- if isKnown(symsha) and getSpellCD(symsha)==0 and useCDs() then
					    --     if castSpell("target",symsha,false) then return; end
					    -- end
				     --    if isKnown(sympri) and getSpellCD(sympri)==0 and getHP("player")<=25 then
				     --        if castSpell("player",sympri,true) then return; end
				     --    end
				     --    if isKnown(sympal) and getSpellCD(sympal)==0 and getHP("player")<=25 then
				     --        if castSpell("player",sympal,true) then return; end
				     --    end
				     --    if isKnown(symdk) and sir(gsi(rk),t)~=1 and sir(gsi(rc),t)==1 and pow>=40 then
				     --       	if castSpell("target",symdk,false) then return; end
				     --    end
				     --    if isKnown(symhun) and getSpellCD(symhun)==0 then
				     --        local threat={UnitDetailedThreatSituation("player","target")}
				     --        if (threat[1]==1 or (threat[5] ~=nil and threat[5]>25000 and threat[3]>90)) then
				     --        	if castSpell("player",symhun,true) then return; end
				     --        end
				     --    end
				     --    if isKnown(symloc) then
				     --     	return false
				     --    end
				     --    if isKnown(symrog) then
				     --        return false
				     --    end
				     --    if isKnown(symmag) and getSpellCD(symmag)==0 and getHP("player")<=25 then
				     --        if castSpell("player",symmag,true) then return; end
				     --    end
				     --    if isKnown(symmon) then
				     --        return false   
				     --    end
					end		
	-----------------------------------------
	--- In Combat - Multi-Target Rotation ---
	-----------------------------------------
					if UnitExists("target") and not UnitIsDeadOrGhost("target") and canAttack("player", "target") then
						if useAoE() then
		-- Faerie Fire (AoE) 
							local ennemiesList = getEnnemies("player",10)
							for i = 1, #ennemiesList do
			  					ISetAsUnitID(IGetObjectListEntry(i),"thisUnit");
								if getDistance("player", "thisUnit") < 10 and getFacing("player","thisUnit")==true then
									if not UnitDebuffID("thisUnit",wa) or select(4,UnitDebuffID("thisUnit",wa)) < 3 then
										if castSpell("thisUnit",ff,true) then return; end
									end
								end
							end

		-- Savage Roar - No Savage Roar Present (AoE)
							if getPower("player") >= 25 and getSRR()  < 3 then
								if castSpell("player",svr) then return; end
							end

		-- Tiger's Fury (AoE)
							if getPower("player") <= 35 and not UnitBuffID("player",cc) then
								if castSpell("player",tf) then return; end
							end

		-- Thrash (AoE)
							if getPower("player") >= 50 
								and (getDebuffRemain("target",thr) < 3 or (UnitBuffID("player",tf) 
								and getDebuffRemain("target",thr) < 9)) 
								and targetDistance <= 8
								and ThrashMode == 1
								and not isGarrMCd() 
							then
								if castSpell("player",thr,true) then return; end
							end

		-- Savage Roar - Refresh if < 9 and 5cp (AoE)
							if getPower("player") >= 25 and getSRR() < 9 and getCombo() >= 5 then
								if castSpell("player",svr) then return; end
							end	
						
		-- Rip (AoE)
							if getPower("player") >= 30 and getCombo() >= 5 and targetDistance < 5 and not isGarrMCd() then
								if castSpell("target",rp,false) then return; end
							end

		-- Rake - Multi-Dot (AoE)
							if getPower("player") >= 35 and not isGarrMCd() then
								if isChecked("Multi-Rake") then
									for i = 1, GetTotalObjects(TYPE_UNIT) do
										local Guid = IGetObjectListEntry(i)
										ISetAsUnitID(Guid,"thisUnit");
										if getFacing("player","thisUnit") == true
											and getDebuffRemain("thisUnit",rk) < 3
											and getTimeToDie("thisUnit") > 5
											and getDistance("thisUnit") < 5
										then
											if castSpell("thisUnit",rk,false) then return; end								
										end
									end
								elseif getDebuffRemain("target",rk) < 3 and targetDistance < 5 then
									if castSpell("target",rk,false) then return; end								
								end
							end
		-- Swipe 
							if getPower("player") >= 45 and targetDistance <= 8 then
								if getSRR() <= 5 
									or (UnitBuffID("player",tf) or UnitBuffID("player",ber))
									or getSpellCD(tf) < 3
									or UnitBuffID("player",cc) 
									or getTimeToMax("player") <= 1
								then
									if castSpell("player",sw,true) then return; end
								end
							end			
						end --Multi-Target Rotation End
						
	------------------------------------------
	--- In Combat - Single-Target Rotation ---
	------------------------------------------
					
	 					if not useAoE() and targetDistance < 5 then 

		-- Ferocious Bite (Kill)
							if getFerociousBiteDamage() >= UnitHealth("target") and getCombo()>0 and not isDummy() then
								if castSpell("target",fb,false) then return; end
							end

		-- Thrash - Clearcasting Proc
							if UnitBuffID("player",cc)
								and getDebuffRemain("target",thr) <= 3
								and getDebuffRemain("target",rp) > 3
								and getDebuffRemain("target",rk) > 3
								and getTimeToDie("target") >= 6
								and ThrashMode == 1
								and not isGarrMCd() 
							then
								if castSpell("player",thr,true) then return; end
							end

		-- Faerie Fire
							if getHP("target") > 25
								and getSpellCD(ff) == 0
								and not UnitDebuffID("target",wa,"player") 
								and not UnitBuffID("player",prl)
							then
								if castSpell("target",ff,true) then return; end
							end

		-- Savage Roar
							if not UnitBuffID("player",how) and getPower("player") >= 25 then
								if getBuffRemain("player",svr) <= 1 or (getSrRpDiff() <= 4 and getSRT() and getDebuffRemain("target",rp) < 10 and getDebuffRemain("target",rp) > 0) then
									if castSpell("player",svr) then return; end
								end
							end

		-- Tiger's Fury
							if getPower("player") <= 35 and getSpellCD(tf) and not UnitBuffID("player",ber) and not UnitBuffID("player",cc) then
								if castSpell("player",tf) then return; end
							end

		--Thrash
							if getPower("player") >= 50 and not UnitBuffID("player",cc) and getTimeToDie("target") >= 6 and ThrashMode == 1 and not isGarrMCd() then
								if (getDebuffRemain("target",thr) < 9 and getRoRoRemain() > 0 and getRoRoRemain() <= 1.5 and getDebuffRemain("target",rp)) 
									or (getDebuffRemain("target",thr) <= 3 and getDebuffRemain("target",rp) > 3 and getDebuffRemain("target",rk) > 3)
								then
									if castSpell("player",thr,true) then return; end
								end
							end

		-- Ferocious Bite
							if getPower("player") >= 25 and getRoRoRemain() == 0 and getSRR() > 0 and getCombo()>=5 then
								if (getTimeToDie("target") <= 4 and getCombo() >= 5)
									or (getDebuffRemain("target",rp) <= 4 and getDebuffRemain("target",rp)>0 and getHP("target") <=25)
									or (RPP() < 108 and getDebuffRemain("target",rp) > 6 and getDebuffRemain("target",thr) > 3 and getCombo() >= 5 and getPower("player") >= 50) 
								then
									if castSpell("target",fb,false) then return; end
								end
							end

		-- Healing Touch
							if getBuffRemain("player", ps) > 0 and getBuffRemain("player", dcd) == 0 and (getBuffRemain("player", ps) <= 1.5 or getCombo() >= 4) then
					  			if castSpell(nNova[1].unit,ht) then return; end
					  		end

		-- Rip
							if getSRR() > 1 and getTimeToDie("target") > 4 and getPower("player") >= 30 and not isGarrMCd() then
								if RPP() >= 95 and getTimeToDie("target") > 30 and getRoRoRemain() > 0.5 then
									if (getCombo() >= 4 and getRoRoRemain() < 5) or (getCombo() == 5 and getRoRoRemain() < 11) then
										if castSpell("target",rp,false) then return; end
									end
								end
								if getCombo() >= 5 then
									if getDebuffRemain("target",rp) == 0 then
										if castSpell("target",rp,false) then return; end
									end
									if getTimeToDie("target") >= 15 then
										if (getDebuffRemain("target",rp) < 6 and getHP("target") > 25)
											or (RPP() > 108 and (getBuffRemain("player",138756) == 0 or getBuffRemain("player",138756) >= 7))
										then
											if castSpell("target",rp,false) then return; end
										end
									end
								end
							end

		-- Rake
							if getSRR() > 1 and not UnitBuffID("player", prl) and getPower("player") >= 35 and not isGarrMCd() then
								if (getRoRoRemain() > 0.5 and getDebuffRemain("target",rk) < 9 and getRoRoRemain() <= 1.5)
									or getDebuffRemain("target",rk) < 3
									or (getRkOver() and (getBuffRemain("player",138756) == 0 or getBuffRemain("player",138756) >= 9))	
								then
									if castSpell("target",rk,false) then return; end
								end
							end

		-- Combo Generator
							if getBuffRemain("player",cc)>0 
								or getBuffRemain("player",frf)>0 
								or ((getCombo()<5 and getDebuffRemain("target",rp)<3) or (getCombo()==0 and getSRR()<2))
								or getTimeToDie("target")<=8.5
								or (getBuffRemain("player",tf)>0 or getBuffRemain("player",ber)>0)
								or getTimeToMax("player")<=1
							then
			-- Ravage Opener
								if getFacing("target","player")==false and UnitBuffID("player",prl) and getSRR() > 1 and not UnitIsPlayer("target") and not isInPvP() and getPower("player") >= 45 then  
									if castSpell("target",rvg,false) then return; end
								end

			-- Pounce Opener
								if UnitBuffID("player",prl) and UnitIsPlayer("target") and getFacing("target","player")==true and getPower("player") >= 50 and isInPvP() then
									if castSpell("target",pnc,false) then return; end
								end

			-- Ravage - King of the Jungle
								if UnitBuffID("player",inb) then
									if castSpell("target",rvf,false) then return; end
								end

			-- Ravage - Stampede
								if UnitBuffID("player", spd) then
									if castSpell("target",rvf,false) then return; end
								end

			-- Rake - Filler
								if not UnitBuffID("player",cc) and getRkFill() and getPower("player") >= 35 and not isGarrMCd() then
									if castSpell("target",rk,false) then return; end
								end

			-- Shred
								if canShred() and not UnitBuffID("player",inb) and getPower("player") >= 40 then
									if UnitBuff("player",ber) or getRegen("player") >= 15 then
										if hasGlyph(gsr) then
											if castSpell("target",shg,false) then return; end
										else
											if castSpell("target",shr,false) then return; end
										end
									end
								end

			-- Mangle
								if not UnitBuffID("player",inb) and getPower("player") >= 35 then
									if castSpell("target",mgl,false) then return; end
								end
							end   
		 				end --Single Rotation End
			-- Start Attack
						if not UnitBuffID("player",prl) then
							StartAttack()
						end
					end	--Target Exists/Target Alive/Target Enemy Check End
				end --Cat Form/Melee Range Check End
			end --In Combat Check End
		end --Death Cat Mode End
	end --Druid Function End
end --Class Check End