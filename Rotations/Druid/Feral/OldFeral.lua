if select(3, UnitClass("player")) == 11 and GetSpecialization() == 2 then
	function cFeral:OLDFeral()
   	-- Global Functions
    	--GroupInfo() -- Determings Player with Lowest HP
    	KeyToggles() -- Keyboard Toggles
--------------
--- Locals ---
--------------
		if leftCombat == nil then leftCombat = GetTime() end
		if profileStop == nil then profileStop = false end
		if lastSpellCast == nil then lastSpellCast = cf end
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
		local gcd = ((1.5/GetHaste("player"))+1)
		local p2t17 = TierScan("T17")>=2
		local t18_2pc = TierScan("T18")>=2
		local t18_4pc = TierScan("T18")>=4
		-- Specific Player Variables
		local combo = getCombo()
		local clearcast = UnitBuffID("player",cc)~=nil
		local travel, flight, cat, stag = UnitBuffID("player", trf), UnitBuffID("player", flf), UnitBuffID("player",cf) or UnitBuffID("player",cosf), hasGlyph(114338)
		local stealth = UnitBuffID("player",prl) or UnitBuffID("player",sm)
		local rejRemain = getBuffRemain("player", rej)
		local psRemain = getBuffRemain("player", ps)
		local siBuff, siCharge = UnitBuffID("player",si), getCharges(si)
		local rbCooldown = GetSpellCooldown(rb)
		local sbCooldown = GetSpellCooldown(sb)
		local mbCooldown = GetSpellCooldown(mb)
	    local srRemain = getBuffRemain("player",svr)
	    local tfRemain, tfCooldown = getBuffRemain("player",tf), GetSpellCooldown(tf)
	    local fonCooldown, fonCharge, fonRecharge = GetSpellCooldown(fon), getCharges(fon), getRecharge(fon)
	    local berserk, berRemain, berCooldown = UnitBuffID("player",ber)~=nil, getBuffRemain("player",ber), GetSpellCooldown(ber)
	    local incarnation, incBuff, incCooldown, incRemain = getTalent(4,2), UnitBuffID("player",inc)~=nil, GetSpellCooldown(inc), getBuffRemain("player",inc)
	    local vicious = getBuffRemain("player",148903)
	    local restlessagi = getBuffRemain("player",146310)
	    local bloodtalons, btRemain,btStacks = getTalent(7,2), getBuffRemain("player",bt), getBuffStacks("player",bt,"player")
	    local newSr = 18 + (6*(combo-1))
	    local tt5 = 40*getRegen("player")*(5-floor(UnitPower("player")/40))
		-- Target Variables
		local dynTar5 = dynamicTarget(5,true) --Melee
		local dynTar8 = dynamicTarget(8,true) --Swipe
		local dynTar8AoE = dynamicTarget(8,false) --Thrash
		local dynTar13 = dynamicTarget(13,true) --Skull Bash
		local dynTar20AoE = dynamicTarget(20,false) --Prowl
		local dynTar40AoE = dynamicTarget(40,false) --Cat Form/Moonfire	
		local dynTable5 = (useCleave() and enemiesTable) or { [1] = {["unit"]=dynTar5, ["distance"] = tarDist(dynTar5)}}
		local dynTable8 = (useCleave() and enemiesTable) or { [1] = {["unit"]=dynTar8, ["distance"] = tarDist(dynTar8)}}
		local dynTable8AoE = (useCleave() and enemiesTable) or { [1] = {["unit"]=dynTar8AoE, ["distance"] = tarDist(dynTar8AoE)}}
		local dynTable13 = (useCleave() and enemiesTable) or { [1] = {["unit"]=dynTar13, ["distance"] = tarDist(dynTar13)}}
		local dynTable20AoE = (useCleave() and enemiesTable) or { [1] = {["unit"]=dynTar20AoE, ["distance"] = tarDist(dynTar20AoE)}}
		local dynTable40AoE = (useCleave() and enemiesTable) or { [1] = {["unit"]=dynTar40AoE, ["distance"] = tarDist(dynTar40AoE)}}
		local deadtar, attacktar, hastar, playertar = deadtar or UnitIsDeadOrGhost("target"), attacktar or UnitCanAttack("target", "player"), hastar or ObjectExists("target"), UnitIsPlayer("target")
		local friendly = friendly or UnitIsFriend("target", "player")
	    local stunRemain = getDebuffRemain(dynTar5,rks,"player")
	    local mfTick = 20.0/(1+UnitSpellHaste("player")/100)/10

	    --ChatOverlay(getDistance2("player","target").." | "..tarDist("target"))

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
		    if ((not dead and hastar and not friendly and attacktar and tarDist(dynTar20AoE)<=40)
		    		or (isMoving("player") and not travel and not IsFalling()))
		        and (not IsFlying() or (IsFlying() and tarDist(dynTar20AoE)<10))
		        and not cat 
		        and (falling==0 or tarDist(dynTar20AoE)<10)
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
	-- Perma Fire Cat
		-- check if its check and player out of combat an not stealthed
		if isChecked("Perma Fire Cat") and not isInCombat("player") and not stealth and cat then
			-- check if Burning Essence buff has less than 60secs remaining
			if getBuffRemain("player",138927)==0 then
				-- check if player has the Fandral's Seed Pouch
				if PlayerHasToy(122304) then
					-- check if item is off cooldown
					if GetItemCooldown(122304)==0 then
						-- Let's only use it once and not spam it
						if not spamToyDelay or GetTime() > spamToyDelay then
							UseItemByName(select(1,UseItemByName(122304)))
							spamToyDelay = GetTime() + 1
						end
					end
				-- check if Burning Seeds exist and are useable if Fandral's Seed Pouch doesn't exist
				elseif canUse(94604) then
					useItem(94604)
				end
			end
		end
	-- Death Cat mode
		if isChecked("Death Cat Mode") and cat then
	        if hastar and tarDist(dynTar8AoE) > 8 then
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
	                if castSpell(dynTar5,shr,false,false,false) then swipeSoon = nil; return end
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
	                if not isBuffed(members[i].Unit,{1126,115921,116781,20217,160206,69378,159988,160017,90363,160077}) 
	                	and (--#nNova==select(5,GetInstanceInfo()) 
	                		--[[or]] select(2,IsInInstance())=="none" 
	                		or (select(2,IsInInstance())=="party" and not UnitInParty("player"))
                      or (select(2,IsInInstance())=="raid"))
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
			if not isInCombat("player") and cat 
				and ((not (IsMounted() or IsFlying() or friendly)) or isDummy()) 
			then
		-- Prowl
				for i=1, #dynTable20AoE do
					local thisUnit = dynTable20AoE[i].unit
			        if useProwl() and not stealth and (ObjectExists(thisUnit) or isKnown(eprl)) and GetTime()-leftCombat > lootDelay then
						if castSpell("player",prl,false,false,false) then return end
			        end
			    end
		-- Rake/Shred
		        if hastar and attacktar and power>40 and tarDist(dynTar5)<5 then
		        	if isKnown(irk) then
		        		if castSpell(dynTar5,rk,false,false,false) then return end
		        	else
		            	if castSpell(dynTar5,shr,false,false,false) then return end
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
		          	for i=1, #enemiesTable do
			            thisUnit = enemiesTable[i].unit
			            if canInterrupt(thisUnit,getOptionValue("Interrupt At")) then
				-- Skull Bash
			    			if isChecked("Skull Bash") and enemiesTable[i].distance<13 then
			    			    --if castInterrupt(sb,getOptionValue("Interrupt At")) then return end
			                	if castSpell(thisUnit,sb,false,false,false) then return end
			    			end
				-- Mighty Bash
			    			if isChecked("Mighty Bash") then
			    			    --if castInterrupt(mb,getOptionValue("Interrupt At")) then return end
			                	if castSpell(thisUnit,mb,false,false,false) then return end
			    			end
				-- Maim (PvP)
			    			if isChecked("Maim") and combo > 0 and power >= 35 and isInPvP() then
			    			    --if castInterrupt(ma,getOptionValue("Interrupt At")) then return end
			                	if castSpell(thisUnit,ma,false,false,false) then return end
			    			end
		            	end
		          	end
			 	end
	-----------------------------
	--- In Combat - Cooldowns ---
	-----------------------------
				if not stealth and ObjectExists(dynTar5) then
		-- Tier 4 Talent: Force of Nature
			        if useCDs() and fonCooldown == 0 then
			            if fonCharge == 3 or (fonCharge == 2 and (fonRecharge - GetTime()) > 19) then
			                if castSpell(dynTar5,fon,true,false,false) then return end
			            elseif (vicious>0 and vicious<1) or restlessagi==20 or ttd(dynTar5)<20 then
			                if castSpell(dynTar5,fon,true,false,true) then return end
			            end
		            end
		-- Berserk
					--if=buff.tigers_fury.up&(buff.incarnation.up|!talent.incarnation_king_of_the_jungle.enabled)
		            if useCDs() and tfRemain>0 and ttd(dynTar5) >= 18 and (incBuff or not incarnation) then
		                if castSpell("player",ber,true,false,false) then return end
		            end
		-- Trinkets
					-- if=(prev.tigers_fury&(target.time_to_die>trinket.stat.any.cooldown|target.time_to_die<45))|prev.berserk|(buff.king_of_the_jungle.up&time<10)
					-- if useCDs() and ((lastSpellCast==tf and (ttd>120 or ttd<45)) or lastSpellCast==ber or (incBuff and getCombatTime()<10)) then
					-- 	if canTrinket(13) then
					-- 		RunMacroText("/use 13")
					-- 		if IsAoEPending() then
					-- 			local X,Y,Z = ObjectPosition(Unit)
					-- 			ClickPosition(X,Y,Z,true)
					-- 		end
					-- 	end
					-- 	if canTrinket(14) then
					-- 		RunMacroText("/use 14")
					-- 		if IsAoEPending() then
					-- 			local X,Y,Z = ObjectPosition(Unit)
					-- 			ClickPosition(X,Y,Z,true)
					-- 		end
					-- 	end
					-- end
		-- Agi-Pot
					-- if=(buff.berserk.remains>10&(target.time_to_die<180|(trinket.proc.all.react&target.health.pct<25)))|target.time_to_die<=40
		            if useCDs() and canUse(109217) and select(2,IsInInstance())=="raid" and isChecked("Agi-Pot") and ((berRemain>10 and (ttd(dynTar5)<180 or (thp(dynTar5)<25))) or ttd(dynTar5)<=40) then
		                UseItemByName(tostring(select(1,GetItemInfo(109217))))
		            end
		-- Racial: Orc Blood Fury
					if useCDs() and select(2, UnitRace("player")) == "Orc" and power >= 60 and tfRemain>0 then
		                if castSpell("player",obf,true,false,false) then return end
		            end            
		-- Racial: Troll Berserking
		            if useCDs() and select(2, UnitRace("player")) == "Troll" and power >= 60 and tfRemain>0 then
		                if castSpell("player",rber,true,false,false) then return end
		            end
		-- Racial: Blood Elf Arcane Torrent
					if useCDs() and select(2, UnitRace("player")) == "Troll" and power >= 60 and tfRemain>0 then
		                if castSpell("player",beat,true,false,false) then return end
		            end
		-- Tiger's Fury
					-- if=(!buff.omen_of_clarity.react&energy.deficit>=60)|energy.deficit>=80|(t18_class_trinket&buff.berserk.up&buff.tigers_fury.down)
					if ((not clearcast and powmax-power>=60) or powmax-power>=80 or (hasEquiped(124514) and berRemain>0 and tfRemain==0)) and ObjectExists(dynTar5) then
						if castSpell("player",tf,true,false,false) then return end
					end
		-- Tier 4 Talent: Incarnation - King of the Jungle
					-- if=cooldown.berserk.remains<10&energy.time_to_max>1
		            if useCDs() and berCooldown<10 and ttm>1 and tarDist(dynTar5)<5 then
		                if castSpell("player",inc,true,false,false) then return end
		            end
		-- Racial: Night Elf Shadowmeld
					-- dot.rake.remains<4.5&energy>=35&dot.rake.pmultiplier<2&(buff.bloodtalons.up|!talent.bloodtalons.enabled)&(!talent.incarnation.enabled|cooldown.incarnation.remains>15)&!buff.king_of_the_jungle.up
					if useCDs() and (rakeRemain(dynTar5)<4.5 and power>=35 and rakeAppliedDotDmg(dynTar5)<2 
						and (btRemain>0 or not bloodtalons) and (not incarnation or incCooldown>15) and not incBuff)
						and select(2,IsInInstance())~="none"
					then
						if castSpell("player",sm,false,false) then return end
					end
		        end
	------------------------------------------
	--- In Combat Rotation ---
	------------------------------------------
		-- Rake/Shred from Stealth
				if hastar and attacktar and stealth and power>40 and stunRemain==0 then
					if isKnown(irk) then
		        		if castSpell(dynTar5,rk,false,false,false) then return end
		        	else
		            	if castSpell(dynTar5,shr,false,false,false) then return end
		            end
				end
				if stealth then
					StopAttack()
				end
				if not stealth and isInCombat("player") and BadBoy_data['AoE'] ~= 4 then
		-- Ferocious Bite
					-- cycle_targets=1,if=dot.rip.ticking&dot.rip.remains<3&target.health.pct<25
					for i=1, #dynTable5 do
						local thisUnit = dynTable5[i].unit
						if dynTable5[i].distance<5 and combo>0 and power>25 then
							if ripRemain(thisUnit)>0 and ripRemain(thisUnit)<3 and thp(thisUnit)<25 then
								if castSpell(thisUnit,fb,false,false,false) then return end
							end
						end
					end
		-- Healing Touch
					-- if=talent.bloodtalons.enabled&buff.predatory_swiftness.up&((combo_points>=4&!set_bonus.tier18_4pc)|combo_points=5|buff.predatory_swiftness.remains<1.5)
					if bloodtalons and psRemain > 0 and ((combo >= 4 and not t18_4pc) or combo == 5 or psRemain < 1.5) then
						if getOptionValue("Auto Heal")==1 then
		                    if castSpell(nNova[1].unit,ht,true,false,false) then return end
		                end
		                if getOptionValue("Auto Heal")==2 then
		                    if castSpell("player",ht,true,false,false) then return end
		                end
					end
		-- Savage Roar
					-- if=buff.savage_roar.down
					if srRemains==0 and combo>0 and power>25 and ObjectExists(dynTar5) then
					--if (srRemain<1 or (srRemain<rpRemain and newSr-rpRemain>1)) and combo>0 and power>25 and ObjectExists(dynTar5) then 
						if castSpell("player",svr,true,false,false) then return end
		            end
		-- Rake
					--if rake will expire before energy maxes out for FB then reapply rake. 
					for i=1, #dynTable5 do
						local thisUnit = dynTable5[i].unit
						if dynTable5[i].distance<5 then
							if ttm>rakeRemain(thisUnit) and stunRemain==0 and power>35 and combo>3 then
								if castSpell(thisUnit,rk,false,false,false) then return end
		    				end
					 	end
					 end
		-- Thrash with T18 4pc
					-- if=set_bonus.tier18_4pc&buff.omen_of_clarity.react&remains<4.5&combo_points+buff.bloodtalons.stack!=6
					if t18_4pc and clearcast and thrashRemain(dynTar8AoE)<4.5 and (combo + btStacks) ~= 6 then
						if castSpell(dynTar8AoE,thr,true,false,false) then return end
					end
		-- Pool Energy then Thrash
					-- cycle_targets=1,if=remains<4.5&(active_enemies>=2&set_bonus.tier17_2pc|active_enemies>=4)
					for i=1, #dynTable8AoE do
						local thisUnit = dynTable8AoE[i].unit
						if dynTable8AoE[i].distance<8 then
							if thrashRemain(thisUnit)<4.5 and ((enemies>=2 and p2t17) or enemies>=4) then
								if power <= 50 then
				-- Pool Energy
									return true
								else
				-- Thrash
									if castSpell(thisUnit,thr,true,false,false) then return end
								end
							end
						end
					end
		-- Finishers
					-- if=combo_points=5
					if combo==5 then
      			-- Finisher: Rip
      					-- cycle_targets=1,if=remains<2&target.time_to_die-remains>18&(target.health.pct>25|!dot.rip.ticking)
			            for i=1, #dynTable5 do
							local thisUnit = dynTable5[i].unit
							if dynTable5[i].distance<5 then
								if (ripRemain(thisUnit)<2 and ttd(thisUnit)-ripRemain(thisUnit)>18 and (thp(thisUnit)>25 or ripRemain(thisUnit)<2)) and power>30 then
									if castSpell(thisUnit,rp,false,false,false) then return end
								end
							end
						end
				-- Finisher: Ferocious Bite
						-- cycle_targets=1,max_energy=1,if=target.health.pct<25&dot.rip.ticking
						for i=1, #dynTable5 do
							local thisUnit = dynTable5[i].unit
							if dynTable5[i].distance<5 then
								if power>50 and thp(thisUnit)<25 and ripRemain(thisUnit)>0 then
									if castSpell(thisUnit,fb,false,false,false) then return end
								end
							end
						end
				-- Finisher: Rip
						-- cycle_targets=1,if=remains<7.2&persistent_multiplier>dot.rip.pmultiplier&target.time_to_die-remains>18
						for i=1, #dynTable5 do
							local thisUnit = dynTable5[i].unit
							if dynTable5[i].distance<5 and power>30 then
								if ripRemain(thisUnit)<7.2 and ripCalcDotDmg()>ripAppliedDotDmg(thisUnit) and ttd(thisUnit)-ripRemain(thisUnit)>18 then
									if castSpell(thisUnit,rp,false,false,false) then return end
								end
							end
						end
						-- if=remains<7.2&persistent_multiplier=dot.rip.pmultiplier&(energy.time_to_max<=1|!talent.bloodtalons.enabled|(set_bonus.tier18_4pc&energy>50))&target.time_to_die-remains>18
						for i=1, #dynTable5 do
							local thisUnit = dynTable5[i].unit
							if dynTable5[i].distance<5 and power>30 then
								if ripRemain(thisUnit)<7.2 and ripCalcDotDmg()==ripAppliedDotDmg(thisUnit) and (ttm<=1 or not bloodtalons or (t18_4pc and power > 50)) and ttd(thisUnit)-ripRemain(thisUnit)>18 then
									if castSpell(thisUnit,rp,false,false,false) then return end
								end
							end
						end
				-- Finisher: Savage Roar
						-- if=((set_bonus.tier18_4pc&energy>50)|(set_bonus.tier18_2pc&buff.omen_of_clarity.react)|energy.time_to_max<=1|buff.berserk.up|cooldown.tigers_fury.remains<3)&buff.savage_roar.remains<12.6
						if ((t18_4pc and power > 50) or (t18_2pc and clearcast) or ttm<=1 or berserk or tfCooldown<3) and srRemain<12.6 and power>25 then
							if castSpell("player",svr,true,false,false) then return end
			      		end
				-- Finisher: Ferocious Bite
						-- max_energy=1,if=(set_bonus.tier18_4pc&energy>50)|(set_bonus.tier18_2pc&buff.omen_of_clarity.react)|energy.time_to_max<=1|buff.berserk.up|cooldown.tigers_fury.remains<3
		    			if ((t18_4pc and power > 50) or (t18_2pc and clearcast) or ttm<=1 or berserk or tfCooldown<3) and power>50 then
			    			if castSpell(dynTar5,fb,false,false,false) then return end
			       		end
					end --End Finishers
		-- Savage Roar
					-- if=buff.savage_roar.remains<gcd
					if srRemain<gcd and power>25 and combo>0 then
						if castSpell("player",svr,true,false,false) then return end
					end
		-- Maintain
					-- if=combo_points<5
					if combo<5 then
		    	-- Maintain: Rake
		    			-- cycle_targets=1,if=remains<3&((target.time_to_die-remains>3&spell_targets.swipe<3)|target.time_to_die-remains>6)
		    			for i=1, #dynTable5 do
							local thisUnit = dynTable5[i].unit
							if dynTable5[i].distance<5 and stunRemain==0 and power>35 then 
			    				if rakeRemain(thisUnit)<3 and ((ttd(thisUnit)-rakeRemain(thisUnit)>3 and enemies<3) or ttd(thisUnit)-rakeRemain(thisUnit)>6) then
			    					if castSpell(thisUnit,rk,false,false,false) then return end
			    				end
						 	end
					 	end
					 	-- cycle_targets=1,if=remains<4.5&(persistent_multiplier>=dot.rake.pmultiplier|(talent.bloodtalons.enabled&(buff.bloodtalons.up|!buff.predatory_swiftness.up)))&((target.time_to_die-remains>3&spell_targets.swipe<3)|target.time_to_die-remains>6)
						for i=1, #dynTable5 do
							local thisUnit = dynTable5[i].unit
							if dynTable5[i].distance<5 and stunRemain==0 and power>35 then
								if rakeRemain(thisUnit)<4.5 and (rakeCalcDotDmg()>=rakeAppliedDotDmg(thisUnit) or (bloodtalons and (btRemain>0 or psRemain==0))) and ((ttd(thisUnit)-rakeRemain(thisUnit)>3 and enemies<3) or ttd(thisUnit)-rakeRemain(thisUnit)>6) then
									if castSpell(thisUnit,rk,false,false,false) then return end
			    				end
						 	end
					 	end 
				-- Maintain: Moonfire
						-- cycle_targets=1,if=remains<4.2&spell_targets.swipe<=5&target.time_to_die-remains>tick_time*5
						if getTalent(7,1) and power>30 then
							for i=1, #dynTable40AoE do
								local thisUnit = dynTable40AoE[i].unit
								if dynTable40AoE[i].distance<40 then
									if moonfireRemain(thisUnit)<4.2 and enemies<=5 and ttd(thisUnit)-moonfireRemain(thisUnit)>mfTick*5 then
						    			if castSpell(thisUnit,mf,true,false,false) then return end
						    		end
						    	end
						    end
					   	end 	        
    			-- Maintain: Rake
    					-- cycle_targets=1,if=persistent_multiplier>dot.rake.pmultiplier&spell_targets.swipe=1&((target.time_to_die-remains>3&spell_targets.swipe<3)|target.time_to_die-remains>6)
    					for i=1, #dynTable5 do
							local thisUnit = dynTable5[i].unit
							if dynTable5[i].distance<5 and stunRemain==0 and power>35 then
								if rakeCalcDotDmg()>rakeAppliedDotDmg(thisUnit) and enemies==1 and ((ttd(thisUnit)-rakeRemain(thisUnit)>3 and enemies<3) or ttd(thisUnit)-rakeRemain(thisUnit)>6) then
									if castSpell(thisUnit,rk,false,false,false) then return end
			    				end
			    			end
			    		end	
					end --End Maintain
			-- Pool Energy then Thrash
					--if useCleave() or (BadBoy_data['AoE'] == 2 and not useCleave()) then
					for i=1, #dynTable8AoE do
						local thisUnit = dynTable8AoE[i].unit
						if dynTable8AoE[i].distance<8 then
							-- cycle_targets=1,if=remains<4.5&spell_targets.thrash_cat>=2
							if thrashRemain(thisUnit)<4.5 and enemies>=2 then
								if power<=50 then
				-- Pool Energy 
									return true
								else
				-- Thrash			
									if castSpell(thisUnit,thr,true,false,false) then return end	
								end
							end
						end
					end
			-- Generator
					-- if=combo_points<5
					if combo<5 then
		    	-- Generator: Swipe
				   		-- if=spell_targets.swipe>=4|(spell_targets.swipe>=3&buff.incarnation.down)
				   		if (enemies>=4 or (enemies>=3 and incRemain==0)) and power>45 then
				   			if castSpell(dynTar8,sw,false,false,false) then return end
				      	end
		    	-- Generator: Shred
				   		-- if=spell_targets.swipe<3|(spell_targets.swipe=3&buff.incarnation.up)
				   		if (enemies<3 or (enemies==3 and incRemain>0)) and rakeRemain(dynTar5)>=3 and power>40 then
				   			if castSpell(dynTar5,shr,false,false,false) then return end
				      	end
			    	end --End Generator
				end --End No Stealth
			end --In Combat End
	-- Start Attack
			if ObjectExists(dynTar5) and not stealth and isInCombat("player") and cat and profileStop==false then
				StartAttack()
			end
		end
	end --Druid Function End
end --Class Check End