if select(2, UnitClass("player")) == "DRUID" then
    function cFeral:FeralCuteOne()
   	-- Global Functions
    	GroupInfo() -- Determings Player with Lowest HP
    	KeyToggles() -- Keyboard Toggles
   	-- Locals
   		if leftCombat == nil then leftCombat = GetTime() end
		if profileStop == nil then profileStop = false end
		if lastSpellCast == nil then lastSpellCast = cf end
   		-- General Player Variables
		local lootDelay 									= getOptionValue("LootDelay")
		local hasMouse 										= ObjectExists("mouseover")
		local deadMouse 									= UnitIsDeadOrGhost("mouseover")
		local playerMouse 									= UnitIsPlayer("mouseover")
		local inCombat 										= self.inCombat
		local level 										= self.level
		local php	 										= self.health
		local power, powmax, powgen 						= self.power, self.powerMax, self.powerRegen
		local ttm 											= self.timeToMax
		local falling, swimming 							= getFallTime(), IsSwimming()
		local gcd 											= self.gcd
		local t17_2pc 										= self.eq.t17_2pc
		local t18_2pc 										= self.eq.t18_2pc 
		local t18_4pc 										= self.eq.t18_4pc 
		-- Specific Player Variables
		local combo 										= self.comboPoints
		local clearcast 									= self.buff.clearcast
		local travel, flight, cat, stag 					= self.buff.travelForm, self.buff.flightForm, self.buff.catForm or self.buff.clawsOfShirvallahForm, self.glyph.stag
		local stealth 										= self.stealth
		local rejRemain 									= self.buff.remain.rejuvenation
		local psRemain 										= self.buff.remain.predatorySwiftness
		local siBuff, siCharge 								= self.buff.survivalInstincts, self.charges.survivalInstincts
		local rbCooldown 									= self.cd.rebirth
		local sbCooldown 									= self.cd.skullBash
		local mbCooldown 									= self.cd.mightyBash
	    local srRemain 										= self.buff.remain.savageRoar
	    local tfRemain, tfCooldown 							= self.buff.remain.tigersFury, self.cd.tigersFury
	    local fonCooldown, fonCharge, fonRecharge 			= self.cd.forceOfNature, self.charges.forceOfNature, self.recharge.forceOfNature
	    local berserk, berRemain, berCooldown 				= self.buff.berserk, self.buff.remain.berserk, self.cd.berserk
	    local incarnation, incBuff, incCooldown, incRemain 	= self.talent.incarnationKingOfTheJungle, self.buff.incarnationKingOfTheJungle, self.cd.incarnationKingOfTheJungle, self.buff.remain.incarnationKingOfTheJungle
	    local bloodtalons, btRemain,btStacks 				= self.talent.bloodtalons, self.buff.remain.bloodtalons, self.charges.bloodtalons
	    local trinketProc									= self.hasTrinketProc()
	    local flaskBuff										= getBuffRemain("player",self.flask.wod.buff.agilityBig)
		local canFlask										= canUse(self.flask.wod.agilityBig)
		local inRaid 										= select(2,IsInInstance())=="raid"
		local inInstance 									= select(2,IsInInstance())=="party"
		local solo 											= select(2,IsInInstance())=="none"		
		-- Target Variables
		local dynTar5 										= self.units.dyn5 --Melee
		local dynTar8 										= self.units.dyn8 --Swipe
		local dynTar8AoE 									= self.units.dyn8AoE --Thrash
		local dynTar13 										= self.units.dyn13 --Skull Bash
		local dynTar20AoE 									= self.units.dyn20AoE --Prowl
		local dynTar40AoE 									= self.units.dyn40AoE --Cat Form/Moonfire	
		local dynTable5 									= (BadBoy_data['Cleave']==1 and enemiesTable) or { [1] = {["unit"]=dynTar5, ["distance"] = getDistance(dynTar5)}}
		local dynTable8 									= (BadBoy_data['Cleave']==1 and enemiesTable) or { [1] = {["unit"]=dynTar8, ["distance"] = getDistance(dynTar8)}}
		local dynTable8AoE 									= (BadBoy_data['Cleave']==1 and enemiesTable) or { [1] = {["unit"]=dynTar8AoE, ["distance"] = getDistance(dynTar8AoE)}}
		local dynTable13 									= (BadBoy_data['Cleave']==1 and enemiesTable) or { [1] = {["unit"]=dynTar13, ["distance"] = getDistance(dynTar13)}}
		local dynTable20AoE 								= (BadBoy_data['Cleave']==1 and enemiesTable) or { [1] = {["unit"]=dynTar20AoE, ["distance"] = getDistance(dynTar20AoE)}}
		local dynTable40AoE 								= (BadBoy_data['Cleave']==1 and enemiesTable) or { [1] = {["unit"]=dynTar40AoE, ["distance"] = getDistance(dynTar40AoE)}}
		local deadtar, attacktar, hastar, playertar 		= deadtar or UnitIsDeadOrGhost("target"), attacktar or UnitCanAttack("target", "player"), hastar or ObjectExists("target"), UnitIsPlayer("target")
		local friendly 										= friendly or UnitIsFriend("target", "player")
	    local mfTick 										= 20.0/(1+UnitSpellHaste("player")/100)/10  

--------------------
--- Action Lists ---
--------------------
	-- Action List - Extras
		local function actionList_Extras()
		-- Shapeshift Form Management
			if isChecked("Auto Shapeshifts") then
				if not inCombat then
			-- Flight Form
					if IsFlyableArea() and ((not isInDraenor()) or isKnown(191633)) and not swimming and falling > 1 and level>=58 then 
						if stag then
			            	if self.castFlightForm() then return end
			            elseif not stag then
			                if self.castTravelForm() then return end
			            end
			-- Aquatic Form
			        elseif swimming and not travel and not hasTarget then
				    	if self.castTravelForm() then return end
			-- Cat Form
				    elseif not cat and not (flight or swimming or travel) then
			        	if self.castCatForm() then return end
			        end
		      	end
			end -- End Shapeshift Form Management 
		-- Perma Fire Cat
			-- check if its check and player out of combat an not stealthed
			if isChecked("Perma Fire Cat") and not inCombat and not stealth and cat then
				-- check if Burning Essence buff expired
				if getBuffRemain("player",138927)==0 then
					-- check if player has the Fandral's Seed Pouch
					if PlayerHasToy(122304) then
						-- check if item is off cooldown
						if GetItemCooldown(122304)==0 then
							-- Let's only use it once and not spam it
							if not spamToyDelay or GetTime() > spamToyDelay then
								useItem(122304)
								--UseItemByName(select(1,UseItemByName(122304)))
								spamToyDelay = GetTime() + 1
							end
						end
					-- check if Burning Seeds exist and are useable if Fandral's Seed Pouch doesn't exist
					elseif GetItemCooldown(94604)==0 and GetItemCount(94604,false,false) > 0 then
						useItem(94604)
						--UseItemByName(select(1,UseItemByName(94604)))
					end
				end -- End Burning Essence Check
			end -- End Perma Fire Cat
		-- Death Cat mode
			if isChecked("Death Cat Mode") and cat then
		        if hastar and getDistance(dynTar8AoE) > 8 then
		            ClearTarget()
		        end
	            if self.enemies.yards20 > 0 then
	            -- Tiger's Fury - Low Energy
	                if power < 35 and tfCooldown == 0 then
	                	if self.castTigersFury() then return end
	                end
	            -- Savage Roar - Use Combo Points
	                if combo >= 5 and power>25 then
	                	if self.castSavageRoar() then return end
	                end
	            -- Shred - Single
	                if power > 40 and self.enemies.yards5 == 1 then
	                	if self.castShred() then swipeSoon = nil; return end
	                end
	            -- Swipe - AoE
	                if power > 45 and self.enemies.yards8 > 1 then
	                    if swipeSoon == nil then
	                        swipeSoon = GetTime();
	                    end
	                    if swipeSoon ~= nil and swipeSoon < GetTime() - 1 then
	                    	if self.castSwipe() then swipeSoon = nil; return end
	                    end
	                end
	            end -- End 20yrd Enemy Scan
			end -- End Death Cat Mode
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
			end -- End Dummy Test
		end -- End Action List - Extras
	-- Action List - Defensive
		local function actionList_Defensive()
			if useDefensive() and not stealth and not flight then
		--Revive/Rebirth
				if isChecked("Mouseover Targeting") and hasMouse and deadMouse and playerMouse then
					if inCombat and rbCooldown==0 and psRemain>0 then
						if self.castRebirth("mouseover") then return end
					elseif not inCombat then
						if self.castRevive("mouseover") then return end
					end
				elseif hastar and deadtar and playertar then
					if inCombat and rbCooldown==0 and psRemain>0 then
						if self.castRebirth("target") then return end
					elseif not inCombat then
						if self.castRevive("target") then return end
					end
				end
		-- Remove Corruption
				if isChecked("Mouseover Targeting") and hasMouse and playerMouse and canDispel("mouseover",rc) then
					if self.castRemoveCorruption("mouseover") then return end
				elseif hastar and playertar and canDispel("target",rc) then
					if self.castRemoveCorruption("target") then return end
				end
				if canDispel("player",rc) then
					if self.castRemoveCorruption("player") then return end
				end
		-- PowerShift - Breaks Crowd Control
			    if hasNoControl() then
			        for i=1, 6 do
			            if i == GetShapeshiftForm() then
			                CastShapeshiftForm(i)
			                return true
			            end
			        end
			    end
		-- Rejuvenation
	            if isChecked("Rejuvenation") and php <= getOptionValue("Rejuvenation") then
	                if not stealth and rejRemain==0 and ((not inCombat) or self.perk.enhancedRejuvenation) then
	                	if self.castRejuvenation("player") then return end
	                end
	            end
		-- Auto Rejuvenation
				if isChecked("Auto Rejuvenation") and self.perk.enhancedRejuvenation then
					if getOptionValue("Auto Heal")==1 and getBuffRemain(nNova[1].unit,self.spell.rejuvenationBuff)==0 and nNova[1].hp<=getOptionValue("Auto Rejuvenation") and nNova[1].unit~="player" then
	                    if self.castRejuvenation(nNova[1].unit) then return end
	                end
				end
		-- Pot/Stoned
	            if isChecked("Pot/Stoned") and php <= getOptionValue("Pot/Stoned") 
	            	and inCombat and hasHealthPot() 
	            then
                    if canUse(5512) then
                        useItem(5512)
                    elseif canUse(healPot) then
                        useItem(healPot)
                    end
	            end
	    -- Heirloom Neck
	    		if isChecked("Heirloom Neck") and php <= getOptionValue("Heirloom Neck") then
	    			if hasEquiped(122668) then
	    				if GetItemCooldown(122668)==0 then
	    					useItem(122668)
	    				end
	    			end
	    		end
		-- Engineering: Shield-o-tronic
				if isChecked("Shield-o-tronic") and php <= getOptionValue("Shield-o-tronic") and inCombat and canUse(118006) then
					useItem(118006)
				end
		-- Tier 6 Talent: Nature's Vigil
	            if isChecked("Nature's Vigil") and php <= getOptionValue("Nature's Vigil") then
	            	if self.castNaturesVigil() then return end
	            end
		-- Healing Touch
	            if isChecked("Healing Touch") 
	            	and ((psRemain>0 and php <= getOptionValue("Healing Touch")) 
	            		or (not inCombat and rejRemain>0 and php<=getOptionValue("Rejuvenation"))) 
	            then
	            	if self.castHealingTouch("player") then return end
	            end
		-- Survival Instincts
	            if isChecked("Survival Instincts") and php <= getOptionValue("Survival Instincts") 
	            	and inCombat and not siBuff and siCharge>0 
	            then
	            	if self.castSurvivalInstincts() then return end
	            end
    		end -- End Defensive Toggle
		end -- End Action List - Defensive
	-- Action List - Interrupts
		local function actionList_Interrupts()
			if useInterrupts() then
		-- Skull Bash
				if isChecked("Skull Bash") then
					for i=1, #dynTable13 do
						thisUnit = dynTable13[i].unit
						if canInterrupt(thisUnit,getOptionValue("InterruptAt")) then
							if self.castSkullBash(thisUnit) then return end
						end
					end
				end
		-- Mighty Bash
    			if isChecked("Mighty Bash") then
    				for i=1, #dynTable5 do
						thisUnit = dynTable5[i].unit
						if canInterrupt(thisUnit,getOptionValue("InterruptAt")) then
							if self.castMightyBash(thisUnit) then return end
						end
					end
				end
		-- Maim (PvP)
    			if isChecked("Maim") then 
    				for i=1, #dynTable5 do
						thisUnit = dynTable5[i].unit
    					if canInterrupt(thisUnit,getOptionValue("InterruptAt")) and isInPvP() then
    						if self.castMaim(thisUnit) then return end
		    			end
	            	end
	          	end
		 	end -- End useInterrupts check
		end -- End Action List - Interrupts
	-- Action List - Cooldowns
		local function actionList_Cooldowns()
			if ObjectExists(dynTar5) then
		-- Force of Nature
				-- if=charges=3|trinket.proc.all.react|target.time_to_die<20
				if useCDs() then
					if fonCharge==3 or trinketProc or ttd(dynTar5)<20 then
						if self.castForceOfNature() then return end
					end
				end
		-- Berserk
				--if=buff.tigers_fury.up&(buff.incarnation.up|!talent.incarnation_king_of_the_jungle.enabled)
	            if useCDs() and tfRemain>0 and (incBuff or not incarnation) and ttd(dynTar5) >= 18 then
	            	if self.castBerserk() then return end
	            end
		-- Legendary Ring
						-- use_item,slot=finger1
						-- TODO: Write Legendary Ring Usage
		-- Agi-Pot
				-- if=(buff.berserk.remains>10&(target.time_to_die<180|(trinket.proc.all.react&target.health.pct<25)))|target.time_to_die<=40
	            if useCDs() and canUse(109217) and inRaid and isChecked("Agi-Pot") then
	            	if (berRemain>10 and (ttd(dynTar5)<180 or (trinketProc and thp(dynTar5)<25))) or ttd(dynTar5)<=40 then
	                	useItem(109217)
	                end
	            end
		-- Racial: Orc Blood Fury | Troll Berserking | Blood Elf Arcane Torrent
				-- blood_fury,sync=tigers_fury | berserking,sync=tigers_fury | arcane_torrent,sync=tigers_fury
				if useCDs() and (self.race == "Orc" or self.race == "Troll" or self.race == "Blood Elf") then
					if (not clearcast and self.powerDeficit>=60) or self.powerDeficit>=80 or (hasEquiped(124514) and berRemain>0 and tfRemain==0) then
						if self.castRacial() then return end
					end
	            end            
		-- Tiger's Fury
				-- if=(!buff.omen_of_clarity.react&energy.deficit>=60)|energy.deficit>=80|(t18_class_trinket&buff.berserk.up&buff.tigers_fury.down)
				if (not clearcast and self.powerDeficit>=60) or self.powerDeficit>=80 or (hasEquiped(124514) and berRemain>0 and tfRemain==0) then
					if self.castTigersFury() then return end
				end
		-- Incarnation - King of the Jungle
				-- if=cooldown.berserk.remains<10&energy.time_to_max>1
	            if useCDs() and berCooldown<10 and ttm>1 then
	            	if self.castIncarnationKingOfTheJungle() then return end
	            end
		-- Racial: Night Elf Shadowmeld
				-- dot.rake.remains<4.5&energy>=35&dot.rake.pmultiplier<2&(buff.bloodtalons.up|!talent.bloodtalons.enabled)&(!talent.incarnation.enabled|cooldown.incarnation.remains>15)&!buff.king_of_the_jungle.up
				if useCDs() and self.race == "Night Elf" and (rakeRemain(dynTar5)<4.5 and power>=35 and rakeAppliedDotDmg(dynTar5)<2 
					and (btRemain>0 or not bloodtalons) and (not incarnation or incCooldown>15) and not incBuff) and not solo
				then
					if self.castRacial() then return end
				end
	        end -- End useCooldowns check
		end -- End Action List - Cooldowns
	-- Action List - PreCombat
		local function actionList_PreCombat()
			if not inCombat and not (IsFlying() or IsMounted()) then
				if not stealth then
		-- Flask / Crystal
					-- flask,type=greater_draenic_agility_flask
					if isChecked("Agi-Pot") and not stealth then
						if inRaid and canFlask and flaskBuff==0 and not UnitBuffID("player",176151) then
							useItem(self.flask.wod.agilityBig)
							return true
						end
			            if flaskBuff==0 then
			                -- if not UnitBuffID("player",176151) and canUse(118922) then --Draenor Insanity Crystal
			                --     useItem(118922))
			                -- end
			                if self.useCrystal() then return end
			            end
			        end
		-- TODO: food,type=pickled_eel
		-- Mark of the Wild
					-- mark_of_the_wild,if=!aura.str_agi_int.up
			        if isChecked("Mark of the Wild") and not stealth then
			            for i = 1, #members do --members
			                if not isBuffed(members[i].Unit,{1126,115921,116781,20217,160206,69378,159988,160017,90363,160077}) 
			                	--and (solo or (inInstance and not UnitInParty("player")) or inRaid)
			                then
			                	if self.castMarkOfTheWild() then return end
			                end
			            end
		        	end
		-- TODO: healing_touch,if=talent.bloodtalons.enabled
		-- TODO: Cat Form
		-- Prowl
		 			if cat then --and (not friendly or isDummy()) 
						for i=1, #dynTable20AoE do
							local thisUnit = dynTable20AoE[i].unit
							if dynTable20AoE[i].distance < 20 then
						        if useProwl() and not inInstance and not inRaid and ((ObjectExists(thisUnit) and UnitCanAttack(thisUnit,"player")) or self.perk.enhancedProwl) and GetTime()-leftCombat > lootDelay then
						        	if self.castProwl() then return end
						        end
						    end
					    end
					end
				end -- End No Stealth
				if stealth then
		-- TODO: snapshot_stats
		-- TODO: potion,name=draenic_agility
		-- TODO: incarnation
		-- Rake/Shred
			        if hastar and attacktar and getDistance(dynTar5)<5 then
			        	if self.perk.improvedRake then
			        		if self.castRake(dynTar5) then StopAttack(); return end
			        	else
			        		if self.castShred() then StopAttack(); return end
			            end
			        end
			    end -- End Stealth
			end -- End No Combat
		end -- End Action List - PreCombat 
	-- Action List - Finisher
		local function actionList_Finisher()
		-- Finisher: Rip
			-- cycle_targets=1,if=remains<2&target.time_to_die-remains>18&(target.health.pct>25|!dot.rip.ticking)
	        for i=1, #dynTable5 do
				local thisUnit = dynTable5[i].unit
				if dynTable5[i].distance < 5 then
					if ripRemain(thisUnit)<2 and ttd(thisUnit)-ripRemain(thisUnit)>18 and (thp(thisUnit)>25 or ripRemain(thisUnit)<2) then
						if self.castRip(thisUnit) then return end
					end
				end
			end
		-- Finisher: Ferocious Bite
			-- cycle_targets=1,max_energy=1,if=target.health.pct<25&dot.rip.ticking
			for i=1, #dynTable5 do
				local thisUnit = dynTable5[i].unit
				if dynTable5[i].distance < 5 then
					if power>50 and thp(thisUnit)<25 and ripRemain(thisUnit)>0 then
						if self.castFerociousBite(thisUnit) then return end
					end
				end
			end
		-- Finisher: Rip
			-- cycle_targets=1,if=remains<7.2&persistent_multiplier>dot.rip.pmultiplier&target.time_to_die-remains>18
			for i=1, #dynTable5 do
				local thisUnit = dynTable5[i].unit
				if dynTable5[i].distance < 5 then
					if ripRemain(thisUnit)<7.2 and ripCalcDotDmg()>ripAppliedDotDmg(thisUnit) and ttd(thisUnit)-ripRemain(thisUnit)>18 then
						if self.castRip(thisUnit) then return end
					end
				end
			end
			-- if=remains<7.2&persistent_multiplier=dot.rip.pmultiplier&(energy.time_to_max<=1|!talent.bloodtalons.enabled|(set_bonus.tier18_4pc&energy>50))&target.time_to_die-remains>18
			for i=1, #dynTable5 do
				local thisUnit = dynTable5[i].unit
				if dynTable5[i].distance < 5 then
					if ripRemain(thisUnit)<7.2 and ripCalcDotDmg()==ripAppliedDotDmg(thisUnit) and (ttm<=1 or not bloodtalons or (t18_4pc and power > 50)) and ttd(thisUnit)-ripRemain(thisUnit)>18 then
						if self.castRip(thisUnit) then return end
					end
				end
			end
		-- Finisher: Savage Roar
			-- if=((set_bonus.tier18_4pc&energy>50)|(set_bonus.tier18_2pc&buff.omen_of_clarity.react)|energy.time_to_max<=1|buff.berserk.up|cooldown.tigers_fury.remains<3)&buff.savage_roar.remains<12.6
			if ((t18_4pc and power > 50) or (t18_2pc and clearcast) or ttm<=1 or berserk or tfCooldown<3) and srRemain<12.6 and getDistance(dynTar5)<5 then
				if self.castSavageRoar() then return end
	  		end
		-- Finisher: Ferocious Bite
			-- max_energy=1,if=(set_bonus.tier18_4pc&energy>50)|(set_bonus.tier18_2pc&buff.omen_of_clarity.react)|energy.time_to_max<=1|buff.berserk.up|cooldown.tigers_fury.remains<3
			if (t18_4pc and power > 50) or (t18_2pc and clearcast) or ttm<=1 or berserk or tfCooldown<3 and getDistance(dynTar5)<5 then
				if self.castFerociousBite(dynTar5) then return end
	   		end
		end -- End Action List - Finisher
	-- Action List - Maintain
		local function actionList_Maintain()
		-- Maintain: Rake
			-- cycle_targets=1,if=remains<3&((target.time_to_die-remains>3&spell_targets.swipe<3)|target.time_to_die-remains>6)
			for i=1, #dynTable5 do
				local thisUnit = dynTable5[i].unit
				if dynTable5[i].distance < 5 then
					if rakeRemain(thisUnit)<3 and ((ttd(thisUnit)-rakeRemain(thisUnit)>3 and self.enemies.yards8<3) or ttd(thisUnit)-rakeRemain(thisUnit)>6) then
						if self.castRake(thisUnit) then return end
					end
				end
		 	end
		 	-- cycle_targets=1,if=remains<4.5&(persistent_multiplier>=dot.rake.pmultiplier|(talent.bloodtalons.enabled&(buff.bloodtalons.up|!buff.predatory_swiftness.up)))&((target.time_to_die-remains>3&spell_targets.swipe<3)|target.time_to_die-remains>6)
			for i=1, #dynTable5 do
				local thisUnit = dynTable5[i].unit
				if dynTable5[i].distance < 5 then
					if rakeRemain(thisUnit)<4.5 and (rakeCalcDotDmg()>=rakeAppliedDotDmg(thisUnit) or (bloodtalons and (btRemain>0 or psRemain==0))) and ((ttd(thisUnit)-rakeRemain(thisUnit)>3 and self.enemies.yards8<3) or ttd(thisUnit)-rakeRemain(thisUnit)>6) then
						if self.castRake(thisUnit) then return end
				 	end
				end
		 	end 
		-- Maintain: Moonfire
			-- cycle_targets=1,if=remains<4.2&spell_targets.swipe<=5&target.time_to_die-remains>tick_time*5
			if self.talent.lunarInspiration and power>30 then
				for i=1, #dynTable40AoE do
					local thisUnit = dynTable40AoE[i].unit
					if dynTable40AoE[i].distance<40 then
						if moonfireRemain(thisUnit)<4.2 and self.enemies.yards8<=5 and ttd(thisUnit)-moonfireRemain(thisUnit)>mfTick*5 then
							if self.castMoonfire(thisUnit) then return end
			    		end
			    	end
			    end
		   	end 	        
		-- Maintain: Rake
			-- cycle_targets=1,if=persistent_multiplier>dot.rake.pmultiplier&spell_targets.swipe=1&((target.time_to_die-remains>3&spell_targets.swipe<3)|target.time_to_die-remains>6)
			for i=1, #dynTable5 do
				local thisUnit = dynTable5[i].unit
				if dynTable5[i].distance < 5 then
					if rakeCalcDotDmg()>rakeAppliedDotDmg(thisUnit) and self.enemies.yards8>=1 and ((ttd(thisUnit)-rakeRemain(thisUnit)>3 and self.enemies.yards8<3) or ttd(thisUnit)-rakeRemain(thisUnit)>6) then
						if self.castRake(thisUnit) then return end
					end
				end
			end	
		end -- End Action List - Maintain
	-- Action List - Generator
		local function actionList_Generator()
		-- Generator: Swipe
	   		-- if=spell_targets.swipe>=4|(spell_targets.swipe>=3&buff.incarnation.down)
	   		if BadBoy_data['AoE']==2 or (BadBoy_data['AoE']==1 and (self.enemies.yards8>=4 or (self.enemies.yards8>=3 and incRemain==0))) and getDistance(dynTar8)<8 then
	   			if self.castSwipe() then return end
	      	end
		-- Generator: Shred
	   		-- if=spell_targets.swipe<3|(spell_targets.swipe=3&buff.incarnation.up)
	   		if (BadBoy_data['AoE']==3 or (BadBoy_data['AoE']==1 and (self.enemies.yards8<3 or (self.enemies.yards8==3 and incRemain>0)))) and rakeRemain(dynTar5)>=3 and getDistance(dynTar5)<5 then
	   			if self.castShred() then return end
	      	end
		end -- End Action List - Generator
---------------------
--- Begin Profile ---
---------------------
	-- Profile Stop | Pause
		if not inCombat and not hastar and profileStop==true then
			profileStop = false
		elseif (inCombat and profileStop==true) or pause() then
			return true
		else
-----------------------
--- Extras Rotation ---
-----------------------
			if actionList_Extras() then return end
--------------------------
--- Defensive Rotation ---
--------------------------
			if actionList_Defensive() then return end
------------------------------
--- Out of Combat Rotation ---
------------------------------
			if actionList_PreCombat() then return end
--------------------------
--- In Combat Rotation ---
--------------------------
		-- Cat is 4 fyte!
			if inCombat and not cat and not (flight or travel) then
				if self.castCatForm() then return end
			elseif inCombat and cat and profileStop==false and not isChecked("Death Cat Mode") and hastar and attacktar then
		-- TODO: Wild Charge
		-- TODO: Displacer Beast
		-- TODO: Dash/Worgen Racial
		-- Rake/Shred from Stealth
				-- rake,if=buff.prowl.up|buff.shadowmeld.up
				if stealth then
					if self.perk.improvedRake then
						if self.castRake(dynTar5) then StopAttack(); return end
		        	else
		        		if self.castShred() then StopAttack(); return end
		            end
				elseif not stealth and BadBoy_data['AoE'] ~= 4 then
					-- auto_attack
					StartAttack()
	------------------------------
	--- In Combat - Interrupts ---
	------------------------------
					if actionList_Interrupts() then return end
	-----------------------------
	--- In Combat - Cooldowns ---
	-----------------------------
					if actionList_Cooldowns() then return end
	---------------------------
	--- In Combat - Attacks ---
	---------------------------
		-- Ferocious Bite
					-- cycle_targets=1,if=dot.rip.ticking&dot.rip.remains<3&target.health.pct<25
					for i=1, #dynTable5 do
						local thisUnit = dynTable5[i].unit
						if dynTable5[i].distance < 5 then
							if ripRemain(thisUnit)>0 and ripRemain(thisUnit)<3 and thp(thisUnit)<25 then
								if self.castRip(thisUnit) then return end
							end
						end
					end
		-- Healing Touch
					-- if=talent.bloodtalons.enabled&buff.predatory_swiftness.up&((combo_points>=4&!set_bonus.tier18_4pc)|combo_points=5|buff.predatory_swiftness.remains<1.5)
					if bloodtalons and psRemain > 0 and ((combo >= 4 and not t18_4pc) or combo == 5 or psRemain < 1.5) then
						if getOptionValue("Auto Heal")==1 then
							if self.castHealingTouch(nNova[1].unit) then return end
		                end
		                if getOptionValue("Auto Heal")==2 then
		                	if self.castHealingTouch("player") then return end
		                end
					end
		-- Savage Roar
					-- if=buff.savage_roar.down
					if srRemains==0 then
						if self.castSavageRoar() then return end
		            end
		-- Rake
					--if rake will expire before energy maxes out for FB then reapply rake. 
					for i=1, #dynTable5 do
						local thisUnit = dynTable5[i].unit
						if dynTable5[i].distance<5 then
							if ttm>rakeRemain(thisUnit) then
								if self.castRake(thisUnit) then return end
		    				end
					 	end
					end
		-- Thrash with T18 4pc
					-- if=set_bonus.tier18_4pc&buff.omen_of_clarity.react&remains<4.5&combo_points+buff.bloodtalons.stack!=6
					if t18_4pc and clearcast and thrashRemain(dynTar8AoE)<4.5 and (combo + btStacks) ~= 6 and getDistance(dynTar8AoE)<8 then
						if self.castThrash(dynTar8AoE) then return end
					end
		-- Pool Energy then Thrash
					-- cycle_targets=1,if=remains<4.5&(active_enemies>=2&set_bonus.tier17_2pc|active_enemies>=4)
					for i=1, #dynTable8AoE do
						local thisUnit = dynTable8AoE[i].unit
						if dynTable8AoE[i].distance<8 then
							if thrashRemain(thisUnit)<4.5 and ((self.enemies.yards8>=2 and t17_2pc) or self.enemies.yards8>=4) then
								if power <= 50 then
					-- Pool Energy
									return true
								else
					-- Thrash
									if self.castThrash(thisUnit) then return end
								end
							end
						end
					end
		-- Finishers
					-- if=combo_points=5
					if combo==5 then
	  					if actionList_Finisher() then return end
					end --End Finishers
		-- Savage Roar
					-- if=buff.savage_roar.remains<gcd
					if self.buff.remain.savageRoar<gcd then
						if self.castSavageRoar() then return end
					end
		-- Maintain
					-- if=combo_points<5
					if combo<5 then
		    			if actionList_Maintain() then return end
					end --End Maintain
		-- Pool Energy then Thrash
					--if useCleave() or (BadBoy_data['AoE'] == 2 and not useCleave()) then
					for i=1, #dynTable8AoE do
						local thisUnit = dynTable8AoE[i].unit
						if dynTable8AoE[i].distance < 8 then
							-- cycle_targets=1,if=remains<4.5&spell_targets.thrash_cat>=2
							if thrashRemain(thisUnit)<4.5 and self.enemies.yards8>=2 then
								if power<=50 then
						-- Pool Energy 
									return true
								else
						-- Thrash			
									if self.castThrash(thisUnit) then return end	
								end
							end
						end
					end
		-- Generator
					-- if=combo_points<5
					if combo<5 then
		    			if actionList_Generator() then return end
			    	end --End Generator
			    end -- End No Stealth | Rotation Off Check
			end --End In Combat
		end --End Rotation Logic
	end --End Druid Function
end --End Class Check