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
		local p2t17 = false
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
	    local berserk, berCooldown = UnitBuffID("player",ber)~=nil, GetSpellCooldown(ber)
	    local incarnation, incBuff, incCooldown, incRemain = getTalent(4,2), UnitBuffID("player",inc)~=nil, GetSpellCooldown(inc), getBuffRemain("player",inc)
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
	    ChatOverlay(swapper)
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
				-- if isChecked("DPS Testing") then
				-- 	if ObjectExists("target") then
				-- 		if getCombatTime() >= (tonumber(getOptionValue("DPS Testing"))*60) and isDummy() then
				-- 			StopAttack()
				-- 			ClearTarget()
				-- 			print(tonumber(getOptionValue("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
				-- 			profileStop = true
				-- 		end
				-- 	end
				-- end
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
				if not stealth and ObjectExists(dynamicUnit.dyn5) then
					thisUnit = dynamicUnit.dyn5
					ttd = getTimeToDie(dynamicUnit.dyn5)
					thp = getHP(dynamicUnit.dyn5)
		-- Tier 4 Talent: Force of Nature
			        if useCDs() and fonCooldown == 0 then
			            if fonCharge == 3 or (fonCharge == 2 and (fonRecharge - GetTime()) > 19) then
			                if castSpell(dynamicUnit.dyn5,fon,true,false,false) then return end
			            elseif (vicious>0 and vicious<1) or restlessagi==20 or ttd<20 then
			                if castSpell(dynamicUnit.dyn5,fon,true,false,true) then return end
			            end
		            end
		-- Berserk
					--if=buff.king_of_the_jungle.up|!talent.incarnation.enabled
		            if useCDs() and tfRemain>0 and power>60 and ttd >= 18 and (incBuff or not incarnation) then
		                if castSpell("player",ber,true,false,false) then return end
		            end
		-- Trinkets
					-- if=(prev.tigers_fury&(target.time_to_die>trinket.stat.any.cooldown|target.time_to_die<45))|prev.berserk|(buff.king_of_the_jungle.up&time<10)
					-- if useCDs() and ((lastSpellCast==tf and (ttd>120 or ttd<45)) or lastSpellCast==ber or (incBuff and getCombatTime()<10)) then
					-- 	if canTrinket(13) then
					-- 		RunMacroText("/use 13")
					-- 		if IsAoEPending() then
					-- 			local X,Y,Z = ObjectPosition(Unit)
					-- 			CastAtPosition(X,Y,Z)
					-- 		end
					-- 	end
					-- 	if canTrinket(14) then
					-- 		RunMacroText("/use 14")
					-- 		if IsAoEPending() then
					-- 			local X,Y,Z = ObjectPosition(Unit)
					-- 			CastAtPosition(X,Y,Z)
					-- 		end
					-- 	end
					-- end
		-- Agi-Pot
					-- if=(buff.berserk.remains>10&(target.time_to_die<180|(trinket.proc.all.react&target.health.pct<25)))|target.time_to_die<=40
		            if useCDs() and canUse(109217) and select(2,IsInInstance())=="raid" and isChecked("Agi-Pot") and ((berRemain>10 and (ttd(dynamicUnit.dyn5)<180 or (thp<25))) or ttd(dynamicUnit.dyn5)<=40) then
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
					-- if=(!buff.omen_of_clarity.react&energy.max-energy>=60)|energy.max-energy>=80
					if ((not clearcast and powmax-power>=60) or powmax-power>=80) and ObjectExists(dynamicUnit.dyn5) then
						if castSpell("player",tf,true,false,false) then return end
					end
		-- Tier 4 Talent: Incarnation - King of the Jungle
					-- if=cooldown.berserk.remains<10&energy.time_to_max>1
		            if useCDs() and berCooldown<10 and ttm>1 and tarDist<5 then
		                if castSpell("player",inc,true,false,false) then return end
		            end
		-- Racial: Night Elf Shadowmeld
					-- dot.rake.remains<4.5&energy>=35&dot.rake.pmultiplier<2&(buff.bloodtalons.up|!talent.bloodtalons.enabled)&(!talent.incarnation.enabled|cooldown.incarnation.remains>15)&!buff.king_of_the_jungle.up
					if useCDs() and (rkRemain<4.5 and power>=35 and rkDmg<2 
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
				if stealth and power>40 and stunRemain==0 then
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
					-- if=buff.savage_roar.down
					if srRemains==0 and combo>0 and power>25 and ObjectExists(dynamicUnit.dyn5) then
					--if (srRemain<1 or (srRemain<rpRemain and newSr-rpRemain>1)) and combo>0 and power>25 and ObjectExists(dynamicUnit.dyn5) then 
						if castSpell("player",svr,true,false,false) then return end
		            end
		-- Pool Energy then Thrash
					if useCleave() or (BadBoy_data['AoE'] == 2 and not useCleave()) then
						for i=1, #enemiesTable do
							if enemiesTable[i].distance<8 then
								thisUnit = enemiesTable[i].unit
								thrRemain = getDebuffRemain(thisUnit,thr,"player")
				-- Pool Energy
								if power<50 and thrRemain<4.5 and ((enemies>=2 and p2t17) or enemies>=4) and power>50 then
									return true
								end
				-- Thrash
								-- if=remains<4.5&(active_enemies>=2&set_bonus.tier17_2pc|active_enemies>=4)
								if thrRemain<4.5 and ((enemies>=2 and p2t17) or enemies>=4) and power>50 then
									if castSpell(dynamicUnit.dyn8AoE,thr,true,false,false) then return end
								end
							end
						end
					end
		-- Finishers
					-- if=combo_points=5
					if combo==5 then 
			-- Finisher: Ferocious Bite
						if useCleave() then
							for i=1, #enemiesTable do
								if enemiesTable[i].distance<5 then
									thisUnit = enemiesTable[i].unit
									rpRemain = getDebuffRemain(thisUnit,rp,"player")
									ttd = getTimeToDie(thisUnit)
									--if=target.health.pct<25&dot.rip.ticking
									if power>50 and enemiesTable[i].hp<25 and rpRemain>0 then
										if castSpell(thisUnit,fb,false,false,false) then return end
									end
								end
							end
						else
							thisUnit = dynamicUnit.dyn5
							ttd = getTimeToDie(thisUnit)
							--if=target.health.pct<25&dot.rip.ticking
							if power>50 and getHP(thisUnit)<25 and rpRemain>0 then
								if castSpell(thisUnit,fb,false,false,false) then return end
							end
						end
			-- Finisher: Rip
						if useCleave() then
							for i=1, #enemiesTable do
								if enemiesTable[i].distance<5 then
									thisUnit = enemiesTable[i].unit
									rpRemain = getDebuffRemain(thisUnit,rp,"player")
									rpDmg = RPD(thisUnit)
									ttd = getTimeToDie(thisUnit)
									if power>30 then
										-- if=remains<7.2&persistent_multiplier>dot.rip.pmultiplier&target.time_to_die-remains>18
										if rpRemain<7.2 and rpCalc>rpDmg and ttd-rpRemain>18 then
											if castSpell(thisUnit,rp,false,false,false) then return end
										end
										-- if=remains<7.2&persistent_multiplier=dot.rip.pmultiplier&(energy.time_to_max<=1|!talent.bloodtalons.enabled)&target.time_to_die-remains>18
										if rpRemain<7.2 and rpCalc==rpDmg and (ttm<=1 or not bloodtalons) and ttd-rpRemain>18 then
											if castSpell(thisUnit,rp,false,false,false) then return end
										end
										-- if=remains<2&target.time_to_die-remains>18
										if rpRemain<2 and ttd-rpRemain>18 then
											if castSpell(thisUnit,rp,false,false,false) then return end
										end
									end
								end
							end
						else
							thisUnit = dynamicUnit.dyn5
							rpRemain = getDebuffRemain(thisUnit,rp,"player")
							rpDmg = RPD(thisUnit)
							ttd = getTimeToDie(thisUnit)
							tarDist = getDistance("player",dynamicUnit.dyn5)
							if power>30 and tarDist<5 then
								-- if=remains<7.2&persistent_multiplier>dot.rip.pmultiplier&target.time_to_die-remains>18
								if rpRemain<7.2 and rpCalc>rpDmg and ttd-rpRemain>18 then
									if castSpell(thisUnit,rp,false,false,false) then return end
								end
								-- if=remains<7.2&persistent_multiplier=dot.rip.pmultiplier&(energy.time_to_max<=1|!talent.bloodtalons.enabled)&target.time_to_die-remains>18
								if rpRemain<7.2 and rpCalc==rpDmg and (ttm<=1 or not bloodtalons) and ttd-rpRemain>18 then
									if castSpell(thisUnit,rp,false,false,false) then return end
								end
								-- if=remains<2&target.time_to_die-remains>18
								if rpRemain<2 and ttd-rpRemain>18 then
									if castSpell(thisUnit,rp,false,false,false) then return end
								end
							end
						end
			-- Finisher: Savage Roar
						--if=(energy.time_to_max<=1|buff.berserk.up|cooldown.tigers_fury.remains<3)&buff.savage_roar.remains<12.6
						if combo==5 and (ttm<=1 or berserk or tfCooldown<3) and srRemain<12.6 and power>25 and tarDist<5 then
							if castSpell("player",svr,true,false,false) then return end
			            end
			-- Finisher: Ferocious Bite
						if useCleave() then
							for i=1, #enemiesTable do
								if enemiesTable[i].distance<5 then
									thisUnit = enemiesTable[i].unit
									--if=(energy.time_to_max<=1|buff.berserk.up|cooldown.tigers_fury.remains<3)
					    			if (ttm<=1 or berserk or tfCooldown<3) and power>50 then
						    			if castSpell(thisUnit,fb,false,false,false) then return end
						            end
						        end
						    end
						else
							--if=(energy.time_to_max<=1|buff.berserk.up|cooldown.tigers_fury.remains<3)
			    			if (ttm<=1 or berserk or tfCooldown<3) and power>50 then
				    			if castSpell(dynamicUnit.dyn5,fb,false,false,false) then return end
				            end
				        end
				    end --End Finishers
		-- Savage Roar
					-- if=buff.savage_roar.remains<gcd
					if srRemain<gcd and power>25 and combo>0 then
						if castSpell("player",svr,true,false,false) then return end
					end
		-- Rake
					if useCleave() then
	    				for i=1, #enemiesTable do
	    					if enemiesTable[i].distance<5 then
	    						thisUnit = enemiesTable[i].unit
	    						rkRemain = getDebuffRemain(thisUnit,rk,"player")
								ttd = getTimeToDie(thisUnit)
								-- if=combo_points<5&remains<3&buff.king_of_the_jungle.up&active_enemies<=15&((target.time_to_die-remains>3&active_enemies<=5)|target.time_to_die-remains>3*(active_enemies%2-2))
								if combo<5 and rkRemain<3 and incBuff and enemies<=15 and ((ttd-rkRemain>3 and enemies <=5) or ttd-rkRemain>3*(enemies/2-2)) and power>35 and stunRemain==0 then
									if castSpell(thisUnit,rk,false,false,false) then return end
								end
							end
						end
					else
						thisUnit = dynamicUnit.dyn5
						rkRemain = getDebuffRemain(thisUnit,rk,"player")
						ttd = getTimeToDie(thisUnit)
						-- if=combo_points<5&remains<3&buff.king_of_the_jungle.up&active_enemies<=15&((target.time_to_die-remains>3&active_enemies<=5)|target.time_to_die-remains>3*(active_enemies%2-2))
						if combo<5 and rkRemain<3 and incBuff and enemies<=15 and ((ttd-rkRemain>3 and enemies <=5) or ttd-rkRemain>3*(enemies/2-2)) and power>35 and stunRemain==0 then
							if castSpell(thisUnit,rk,false,false,false) then return end
						end
					end

		-- Maintain
					-- if=combo_points<5&active_enemies<=7
					if combo<5 and enemies<=7 then
		    -- Maintina: Rake 
		    			if useCleave() then
		    				for i=1, #enemiesTable do
		    					if enemiesTable[i].distance<5 then
		    						thisUnit = enemiesTable[i].unit
		    						rkRemain = getDebuffRemain(thisUnit,rk,"player")
		    						ttd = getTimeToDie(thisUnit)
		    						rkDmg = RKD(thisUnit)
		    						if power>35 then
			    						-- if=remains<3&((target.time_to_die-remains>3&active_enemies<=2)|target.time_to_die-remains>3*(active_enemies-2))
			    						if rkRemain<3 and ((ttd-rkRemain>3 and enemies<=2) or ttd-rkRemain>3*(enemies-2)) and stunRemain==0 then
			    							if castSpell(thisUnit,rk,false,false,false) then return end
			    						end
			    						-- if=remains<4.5&(persistent_multiplier>=dot.rake.pmultiplier|(talent.bloodtalons.enabled&(buff.bloodtalons.up|!buff.predatory_swiftness.up)))&((target.time_to_die-remains>3&active_enemies<=2)|target.time_to_die-remains>3*(active_enemies-2))
							 	    	if rkRemain<4.5 and (rkCalc>=rkDmg or (bloodtalons and (btRemain>0 or psRemain==0))) and ((ttd-rkRemain>3 and enemies<=2) or ttd-rkRemain>3*(enemies-2)) and stunRemain==0 then
							 	    		if castSpell(thisUnit,rk,false,false,false) then return end
			    						end
			    					end
						 	    end
						 	end
						else
							thisUnit = dynamicUnit.dyn5
	    					rkRemain = getDebuffRemain(thisUnit,rk,"player")
    						ttd = getTimeToDie(thisUnit)
    						rkDmg = RKD(thisUnit)
    						if power>35 then
	    						-- if=remains<3&((target.time_to_die-remains>3&active_enemies<=2)|target.time_to_die-remains>3*(active_enemies-2))
	    						if rkRemain<3 and ((ttd-rkRemain>3 and enemies<=2) or ttd-rkRemain>3*(enemies-2)) and stunRemain==0 then
	    							if castSpell(thisUnit,rk,false,false,false) then return end
	    						end
	    						-- if=remains<4.5&(persistent_multiplier>=dot.rake.pmultiplier|(talent.bloodtalons.enabled&(buff.bloodtalons.up|!buff.predatory_swiftness.up)))&((target.time_to_die-remains>3&active_enemies<=2)|target.time_to_die-remains>3*(active_enemies-2))
					 	    	if rkRemain<4.5 and (rkCalc>=rkDmg or (bloodtalons and (btRemain>0 or psRemain==0))) and ((ttd-rkRemain>3 and enemies<=2) or ttd-rkRemain>3*(enemies-2)) and stunRemain==0 then
					 	    		if castSpell(thisUnit,rk,false,false,false) then return end
	    						end
	    					end
					 	end
			-- Maintain: Moonfire
						if getTalent(7,1) and power>30 then
							if useCleave() then
								for i=1, #enemiesTable do
									if enemiesTable[i].distance<40 then
										thisUnit = enemiesTable[i].unit
										mfRemain = getDebuffRemain(thisUnit,mf,"player")
										ttd = getTimeToDie(thisUnit)
										--if=remains<4.2&active_enemies<=5&((target.time_to_die-remains>tick_time*5&active_enemies<=2)|target.time_to_die-remains>tick_time*(active_enemies+2))
							    		if mfRemain<4.2 and enemies<=5 and ((ttd-mfRemain>mfTick*5 and enemies<=2) or ttd-mfRemain>mfTick*(enemies+2)) then
							    			if castSpell(thisUnit,mf,true,false,false) then return end
							    		end
							    	end
						    	end
						    else
						    	thisUnit = dynamicUnit.dyn40AoE
						    	mfRemain = getDebuffRemain(thisUnit,mf,"player")
								ttd = getTimeToDie(thisUnit)
								--if=remains<4.2&active_enemies<=5&((target.time_to_die-remains>tick_time*5&active_enemies<=2)|target.time_to_die-remains>tick_time*(active_enemies+2))
					    		if mfRemain<4.2 and enemies<=5 and ((ttd-mfRemain>mfTick*5 and enemies<=2) or ttd-mfRemain>mfTick*(enemies+2)) then
					    			if castSpell(thisUnit,mf,true,false,false) then return end
					    		end
						    end
					   	end 	        
    		-- Maintain: Rake
    					if useCleave() then
		    				for i=1, #enemiesTable do
		    					if enemiesTable[i].distance<5 then
		    						thisUnit = enemiesTable[i].unit
		    						rkRemain = getDebuffRemain(thisUnit,rk,"player")
		    						ttd = getTimeToDie(thisUnit)
		    						rkDmg = RKD(thisUnit)
									-- if=persistent_multiplier>dot.rake.pmultiplier&active_enemies=1&((target.time_to_die-remains>3&active_enemies<=2)|target.time_to_die-remains>3*(active_enemies-2))
									if power>35 and rkCalc>rkDmg and enemies==1 and ((ttd-rkRemain>3 and enemies<=2) or ttd-rkRemain>3*(enemies-2)) and stunRemain==0 then
						        		if castSpell(thisUnit,rk,false,false,false) then return end
									end
								end
							end
						else
							thisUnit = dynamicUnit.dyn5
    						rkRemain = getDebuffRemain(thisUnit,rk,"player")
    						ttd = getTimeToDie(thisUnit)
    						rkDmg = RKD(thisUnit)
    						-- if=persistent_multiplier>dot.rake.pmultiplier&active_enemies=1&((target.time_to_die-remains>3&active_enemies<=2)|target.time_to_die-remains>3*(active_enemies-2))
							if power>35 and rkCalc>rkDmg and enemies==1 and ((ttd-rkRemain>3 and enemies<=2) or ttd-rkRemain>3*(enemies-2)) and stunRemain==0 then
				        		if castSpell(thisUnit,rk,false,false,false) then return end
							end
						end
					end --End Maintain
		-- Pool Energy then Thrash
					if useCleave() or (BadBoy_data['AoE'] == 2 and not useCleave()) then
						for i=1, #enemiesTable do
							if enemiesTable[i].distance<8 then
								thisUnit = enemiesTable[i].unit
								thrRemain = getDebuffRemain(thisUnit,thr,"player")
				-- Pool Energy
								if power<50 and thrRemain<4.5 and enemies>=2 then
									return true
								end
				-- Thrash
								-- if=remains<4.5&active_enemies>=2
								if thrRemain<4.5 and enemies>=2 and power>50 then
									if castSpell(dynamicUnit.dyn8AoE,thr,true,false,false) then return end
								end
							end
						end
					end
		-- Rake
					-- if=buff.king_of_the_jungle.up&buff.king_of_the_jungle.remains<=3&dot.rake.remains<15&target.time_to_die-remains>15
					if incBuff and incRemain<=3 and rkRemain<15 and ttd-rkRemain>15 and power>35 and stunRemain==0 then
						if castSpell(dynamicUnit.dyn5,rk,false,false,false) then return end
					end
		-- Generator
					-- if=combo_points<5
					-- if=combo_points<5&(energy.time_to_max<=1|buff.berserk.up|cooldown.tigers_fury.remains<3|buff.tigers_fury.up|(buff.king_of_the_jungle.up&buff.king_of_the_jungle.remains<3)|dot.rip.remains<8-combo_points|buff.omen_of_clarity.react|(talent.bloodtalons.enabled&buff.predatory_swiftness.up&buff.predatory_swiftness.remains<6.5-combo_points))
					--if combo<5 then
					if combo<5 and (ttm<=1 or berserk or tfCooldown<3 or tfRemain>0 or (incBuff and incRemain<3) or rpRemain<8-combo or clearcast or (bloodtalons and psRemain>0 and psRemain<6.5-combo)) then
		    -- Swipe
			    		--if=(buff.king_of_the_jungle.up&active_enemies>=3)|active_enemies>=4
			    		if power>45 and ((incBuff and enemies>=3) or enemies>=4) then
			    			if castSpell(dynamicUnit.dyn8,sw,false,false,false) then return end
			            end
		    -- Shred
			    		--if=active_enemies<3
			    		if power>40 and ((incBuff and enemies<3) or enemies<4) then
			    			if castSpell(dynamicUnit.dyn5,shr,false,false,false) then return end
			            end
			        end --End Generator
			    end --End No Stealth
			end --In Combat End
	-- Start Attack
			if ObjectExists(dynamicUnit.dyn5) and not stealth and isInCombat("player") and cat and profileStop==false then
				StartAttack()
			end
		end
	end --Druid Function End
end --Class Check End