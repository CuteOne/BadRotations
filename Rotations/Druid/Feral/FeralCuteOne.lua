if select(2, UnitClass("player")) == "DRUID" then
    function cFeral:FeralCuteOne()
   	-- Global Functions
    	-- GroupInfo() -- Determings Player with Lowest HP
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
		local falling, swimming, flying, moving				= getFallTime(), IsSwimming(), IsFlying(), GetUnitSpeed("player")>0
		local gcd 											= self.gcd
		local t17_2pc 										= self.eq.t17_2pc
		local t18_2pc 										= self.eq.t18_2pc 
		local t18_4pc 										= self.eq.t18_4pc 
		local racial 										= self.getRacial()
		local healPot 										= getHealthPot()
		local lowestHP 										= nNova[1].unit
		local pullTimer 									= bb.DBM:getPulltimer()
		-- Specific Player Variables
		local combo 										= self.comboPoints
		local clearcast 									= self.buff.clearcast
		local travel, flight, cat, noform, stag				= self.buff.travelForm, self.buff.flightForm, self.buff.catForm or self.buff.clawsOfShirvallahForm, GetShapeshiftForm()==0, self.glyph.stag
		local stealth 										= self.stealth
		local buff 											= self.buff
		local cd 											= self.cd
		local charges 										= self.charges
		local debuff 										= self.debuff
		local recharge 										= self.recharge
		local talent 										= self.talent
		local trinketProc									= self.hasTrinketProc()
	    local flaskBuff										= getBuffRemain("player",self.flask.wod.buff.agilityBig)
		local canFlask										= canUse(self.flask.wod.agilityBig)
		local inRaid 										= self.instance=="raid"
		local inInstance 									= self.instance=="party"
		local solo 											= self.instance=="none"
		local perk 											= self.perk		
		-- -- Target Variables
		local bleed 										= self.bleed
		local enemies 										= self.enemies
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
	    local multidot 										= (useCleave() or BadBoy_data['AoE'] ~= 3)
	    local fbDamage 										= getFbDamage()
--------------------
--- Action Lists ---
--------------------
	-- Action List - Extras
		local function actionList_Extras()
		-- Shapeshift Form Management
			if isChecked("Auto Shapeshifts") then
			-- Flight Form
				if IsFlyableArea() and ((not isInDraenor()) or isKnown(191633)) and not swimming and falling > 1 and level>=58 then 
					if stag then
		            	if self.castFlightForm() then return end
		            elseif not stag then
		                if self.castTravelForm() then return end
		            end
		        end
			-- Aquatic Form
			    if swimming and not travel and not hastar and not deadtar then
				  	if self.castTravelForm() then return end
				end
			-- Cat Form
				if not cat then
			    	-- Cat Form when not swimming or flying and not in combat
			    	if not inCombat and moving and not swimming and not flying then
		        		if self.castCatForm() then return end
		        	end
		        	-- Cat Form when not in combat and target selected and within 20yrds
		        	if not inCombat and hastar and attacktar and not deadtar and getDistance("target")<20 then
		        		if self.castCatForm() then return end
		        	end
		        	--Cat Form when in combat and not flying
		        	if inCombat and not flying then
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
								spamToyDelay = GetTime() + 1
							end
						end
					-- check if Burning Seeds exist and are useable if Fandral's Seed Pouch doesn't exist
					elseif GetItemCooldown(94604)==0 and GetItemCount(94604,false,false) > 0 then
						useItem(94604)
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
                	if self.castTigersFury() then return end
	            -- Savage Roar - Use Combo Points
	                if combo >= 5 then
	                	if self.castSavageRoar() then return end
	                end
	            -- Shred - Single
	                if self.enemies.yards5 == 1 then
	                	if self.castShred() then swipeSoon = nil; return end
	                end
	            -- Swipe - AoE
	                if self.enemies.yards8 > 1 then
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
				if isChecked("Rebirth") then
					if buff.remain.predatorySwiftness>0 then
						if getOptionValue("Rebirth - Target")==1 then
							if self.castRebirth("target") then return end
						end
						if getOptionValue("Rebirth - Target")==2 then
							if self.castRebirth("mouseover") then return end
						end
					end
				end
				if isChecked("Revive") then
					if getOptionValue("Revive - Target")==1 then
						if self.castRevive("target") then return end
					end
					if getOptionValue("Revive - Target")==2 then
						if self.castRevive("mouseover") then return end
					end
				end
		-- Remove Corruption
				if isChecked("Remove Corruption") then
					if getOptionValue("Remove Corruption - Target")==1 then
						if self.castRemoveCorruption("player") then return end
					end
					if getOptionValue("Remove Corruption - Target")==2 then
						if self.castRemoveCorruption("target") then return end
					end
					if getOptionValue("Remove Corruption - Target")==3 then
						if self.castRemoveCorruption("mouseover") then return end
					end
				end
		-- PowerShift - Breaks Crowd Control
			    if isChecked("Break Crowd Control") and hasNoControl() then
			        for i=1, 6 do
			            if i == GetShapeshiftForm() then
			                CastShapeshiftForm(i)
			                return true
			            end
			        end
			    end
		-- Rejuvenation
	            if isChecked("Rejuvenation") and php <= getOptionValue("Rejuvenation") then
	                if not stealth and buff.remain.rejuvenation==0 and ((not inCombat) or perk.enhancedRejuvenation) then
	                	if self.castRejuvenation("player") then return end
	                end
	            end
		-- Auto Rejuvenation
				if isChecked("Auto Rejuvenation") and perk.enhancedRejuvenation then
					if getOptionValue("Auto Heal")==1 
						and getBuffRemain(lowestHP,self.spell.rejuvenationBuff)==0 
						and getHP(lowestHP)<=getOptionValue("Auto Rejuvenation") 
						and lowestHP~="player" 
					then
	                    if self.castRejuvenation(lowestHP) then return end
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
				if isChecked("Shield-o-tronic") and php <= getOptionValue("Shield-o-tronic") 
					and inCombat and canUse(118006) 
				then
					useItem(118006)
				end
		-- Tier 6 Talent: Nature's Vigil
	            if isChecked("Nature's Vigil") and php <= getOptionValue("Nature's Vigil") then
	            	if self.castNaturesVigil() then return end
	            end
		-- Healing Touch
	            if isChecked("Healing Touch") 
	            	and ((buff.remain.predatorySwiftness>0 and php <= getOptionValue("Healing Touch")) 
	            		or (not inCombat and buff.remain.rejuvenation>0 and php<=getOptionValue("Rejuvenation"))) 
	            then
	            	if self.castHealingTouch("player") then return end
	            end
		-- Survival Instincts
	            if isChecked("Survival Instincts") and php <= getOptionValue("Survival Instincts") 
	            	and inCombat and not buff.survivalInstrincts and charges.survivalInstincts>0 
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
			if getDistance(dynTar5)<5 then
		-- Force of Nature
				-- if=charges=3|trinket.proc.all.react|target.time_to_die<20
				if useCDs() and isChecked("Force of Nature") then
					if charges.forceOfNature==3 or trinketProc or ttd(dynTar5)<20 then
						if self.castForceOfNature(dynTar5) then return end
					end
				end
		-- Berserk
				--if=buff.tigers_fury.up&(buff.incarnation.up|!talent.incarnation_king_of_the_jungle.enabled)
	            if useCDs() and isChecked("Berserk") then
	            	if buff.tigersFury and (buff.incarnationKingOfTheJungle or not talent.incarnationKingOfTheJungle) and ttd(dynTar5) >= 18 then
	            		if self.castBerserk() then return end
	            	end
	            end
		-- Legendary Ring
				-- use_item,slot=finger1
				if useCDs() and isChecked("Legendary Ring") then
					if hasEquiped(124636) and canUse(124636) then
						useItem(124636)
						return true
					end
				end
		-- Agi-Pot
				-- if=(buff.berserk.remains>10&(target.time_to_die<180|(trinket.proc.all.react&target.health.pct<25)))|target.time_to_die<=40
	            if useCDs() and isChecked("Agi-Pot") and canUse(109217) and inRaid then
	            	if (buff.remain.berserk>10 and (ttd(dynTar5)<180 or (trinketProc and thp(dynTar5)<25))) or ttd(dynTar5)<=40 then
	                	useItem(109217)
	                	return true
	                end
	            end
		-- Racial: Orc Blood Fury | Troll Berserking | Blood Elf Arcane Torrent
				-- blood_fury,sync=tigers_fury | berserking,sync=tigers_fury | arcane_torrent,sync=tigers_fury
				if useCDs() and isChecked("Racial") and (self.race == "Orc" or self.race == "Troll" or self.race == "Blood Elf") then
					if (not clearcast and self.powerDeficit>=60) or self.powerDeficit>=80 or (hasEquiped(124514) and buff.berserk and not buff.tigersFury) then
						if castSpell("player",racial,false,false,false) then return end
					end
	            end            
		-- Tiger's Fury
				-- if=(!buff.omen_of_clarity.react&energy.deficit>=60)|energy.deficit>=80|(t18_class_trinket&buff.berserk.up&buff.tigers_fury.down)
				if isChecked("Tiger's Fury") then
					if (not clearcast and self.powerDeficit>=60) or self.powerDeficit>=80 or (hasEquiped(124514) and buff.berserk and not buff.tigersFury) then
						if self.castTigersFury() then return end
					end
				end
		-- Incarnation - King of the Jungle
				-- if=cooldown.berserk.remains<10&energy.time_to_max>1
	            if useCDs() and isChecked("Incarnation") then
	            	if buff.remain.berserk<10 and ttm>1 then
	            		if self.castIncarnationKingOfTheJungle() then return end
	            	end
	            end
		-- Racial: Night Elf Shadowmeld
				-- if=energy>=35&dot.rake.pmultiplier<2&(buff.bloodtalons.up|!talent.bloodtalons.enabled)&(!talent.incarnation.enabled|cooldown.incarnation.remains>15)&!buff.incarnation.up
				if useCDs() and isChecked("Racial") and self.race == "Night Elf" and (power>=35 and rakeAppliedDotDmg(dynTar5)<2 
					and (buff.bloodtalons or not talent.bloodtalons) and (not talent.incarnationKingOfTheJungle or cd.incarnationKingOfTheJungle>15) and not buff.incarnationKingOfTheJungle) and not solo
				then
					if self.castRacial() then return end
				end
		-- Trinkets
				if useCDs() and isChecked("Trinkets") then
					if canUse(13) then
						useItem(13)
					end
					if canUse(14) then
						useItem(14)
					end
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
			                if not UnitBuffID("player",176151) and canUse(118922) then --Draenor Insanity Crystal
			                    useItem(118922)
			                    return true
			                end
			            end
			        end
		-- TODO: food,type=pickled_eel
		-- Mark of the Wild
					-- mark_of_the_wild,if=!aura.str_agi_int.up
			        if isChecked("Mark of the Wild") and not stealth then
	                	if self.castMarkOfTheWild() then return end
		        	end
		-- Prowl - Non-PrePull
					if cat then --and (not friendly or isDummy()) 
						for i=1, #dynTable20AoE do
							local thisUnit = dynTable20AoE[i].unit
							if dynTable20AoE[i].distance < 20 then
						        if useProwl() and not inInstance and not inRaid and ((ObjectExists(thisUnit) and UnitCanAttack(thisUnit,"player")) or perk.enhancedProwl) and GetTime()-leftCombat > lootDelay then
						        	if self.castProwl() then return end
						        end
						    end
					    end
					end
				end -- End No Stealth
	        	if isChecked("Pre-Pull Timer") and pullTimer <= getOptionValue("Pre-Pull Timer") then
		-- Healing Touch
					-- healing_touch,if=talent.bloodtalons.enabled
					if talent.bloodtalons and not buff.bloodtalons and (htTimer == nil or htTimer < GetTime() - 1) then
						if self.castHealingTouch("player") then htTimer = GetTime(); return end
					end
		-- Prowl 
				    if buff.bloodtalons then
				    	if self.castProwl() then return end
				    end
					if buff.prowl then
		-- Pre-Pot
						-- potion,name=draenic_agility
			            if useCDs() and isChecked("Agi-Pot") and canUse(109217) then
			            	useItem(109217)
			                return true
			            end
		-- Incarnation
						-- incarnation
						if useCDs() and isChecked("Incarnation") then
		            		if self.castIncarnationKingOfTheJungle() then return end
		            	end
					end -- End Prowl
				end -- End Pre-Pull
		-- Rake/Shred
		        if hastar and attacktar then
		        	if perk.improvedRake and debuff.remain.rake==0 then
		        		if self.castRake(dynTar5) then return end
		        	else
		        		if self.castShred(dynTar5) then return end
		            end
		        end
			end -- End No Combat
		end -- End Action List - PreCombat 
	-- Action List - Finisher
		local function actionList_Finisher()
		-- Finisher: Rip
			-- cycle_targets=1,if=remains<2&target.time_to_die-remains>18&(target.health.pct>25|!dot.rip.ticking)
			for i=1, #bleed.rip do
				local rip = bleed.rip[i]
				local thisUnit = rip.unit
				if (multidot or (UnitIsUnit(thisUnit,dynTar5) and not multidot)) and rip.remain<2 and ttd(thisUnit)-rip.remain>18 and (thp(thisUnit)>25 or rip.remain<2) then
					if self.castRip(thisUnit) then return end
				end
			end
		-- Finisher: Ferocious Bite
			-- cycle_targets=1,max_energy=1,if=target.health.pct<25&dot.rip.ticking
			for i=1, #bleed.rip do
				local rip = bleed.rip[i]
				local thisUnit = rip.unit
				if (multidot or (UnitIsUnit(thisUnit,dynTar5) and not multidot)) and power>50 and thp(thisUnit)<=25 and rip.remain>0 then
					if self.castFerociousBite(thisUnit) then return end
				end
			end
		-- Finisher: Rip
			-- cycle_targets=1,if=remains<7.2&persistent_multiplier>dot.rip.pmultiplier&target.time_to_die-remains>18
			for i=1, #bleed.rip do
				local rip = bleed.rip[i]
				local thisUnit = rip.unit
				if (multidot or (UnitIsUnit(thisUnit,dynTar5) and not multidot)) and rip.remain<7.2 and rip.calc>rip.applied and ttd(thisUnit)-rip.remain>18 then
					if self.castRip(thisUnit) then return end
				end
			end
			-- if=remains<7.2&persistent_multiplier=dot.rip.pmultiplier&(energy.time_to_max<=1|(set_bonus.tier18_4pc&energy>50)|(set_bonus.tier18_2pc&buff.omen_of_clarity.react)|!talent.bloodtalons.enabled)&target.time_to_die-remains>18
			for i=1, #bleed.rip do
				local rip = bleed.rip[i]
				local thisUnit = rip.unit
				if (multidot or (UnitIsUnit(thisUnit,dynTar5) and not multidot)) and rip.remain<7.2 and rip.calc==rip.applied and (ttm<=1 or (t18_4pc and power>50) or (t18_4pc and clearcast) or (not talent.bloodtalons)) and ttd(thisUnit)-rip.remain>18 then
					if self.castRip(thisUnit) then return end
				end
			end
		-- Finisher: Savage Roar
			-- if=((set_bonus.tier18_4pc&energy>50)|(set_bonus.tier18_2pc&buff.omen_of_clarity.react)|energy.time_to_max<=1|buff.berserk.up|cooldown.tigers_fury.remains<3)&buff.savage_roar.remains<12.6
			if ((t18_4pc and power > 50) or (t18_2pc and clearcast) or ttm<=1 or buff.berserk or cd.tigersFury<3) and buff.remain.savageRoar<12.6 and getDistance(dynTar5)<5 then
				if self.castSavageRoar() then return end
	  		end
		-- Finisher: Ferocious Bite
			-- max_energy=1,if=(set_bonus.tier18_4pc&energy>50)|(set_bonus.tier18_2pc&buff.omen_of_clarity.react)|energy.time_to_max<=1|buff.berserk.up|cooldown.tigers_fury.remains<3
			if (t18_4pc and power > 50) or (t18_2pc and clearcast) or ttm<=1 or buff.berserk or cd.tigersFury<3 and getDistance(dynTar5)<5 then
				if self.castFerociousBite(dynTar5) then return end
	   		end
		end -- End Action List - Finisher
	-- Action List - Maintain
		local function actionList_Maintain()
		-- Maintain: Rake
			-- cycle_targets=1,if=remains<3&((target.time_to_die-remains>3&spell_targets.swipe<3)|target.time_to_die-remains>6)
		 	for i=1, #bleed.rake do
				local rake = bleed.rake[i]
				local thisUnit = rake.unit
				if (multidot or (UnitIsUnit(thisUnit,dynTar5) and not multidot)) and rake.remain<3 and ((ttd(thisUnit)-rake.remain>3 and enemies.yards8<3) or ttd(thisUnit)-rake.remain>6) then
					if self.castRake(thisUnit) then return end
				end
			end
		 	-- cycle_targets=1,if=remains<4.5&(persistent_multiplier>=dot.rake.pmultiplier|(talent.bloodtalons.enabled&(buff.bloodtalons.up|!buff.predatory_swiftness.up)))&((target.time_to_die-remains>3&spell_targets.swipe<3)|target.time_to_die-remains>6)
			for i=1, #bleed.rake do
				local rake = bleed.rake[i]
				local thisUnit = rake.unit
				if (multidot or (UnitIsUnit(thisUnit,dynTar5) and not multidot)) and rake.remain<4.5 and (rake.calc>=rake.applied or (talent.bloodtalons and (buff.bloodtalons or not buff.predatorySwiftness))) and ((ttd(thisUnit)-rake.remain>3 and enemies.yards8<3) or ttd(thisUnit)-rake.remain>6) then
					if self.castRake(thisUnit) then return end
				end
			end 
		-- Maintain: Moonfire
			-- cycle_targets=1,if=remains<4.2&spell_targets.swipe<=5&target.time_to_die-remains>tick_time*5
			if self.talent.lunarInspiration and power>30 then
				for i=1, #bleed.moonfire do
					local moonfire = bleed.moonfire[i]
					local thisUnit = moonfire.unit
					if (multidot or (UnitIsUnit(thisUnit,dynTar40AoE) and not multidot)) and moonfire.remain<4.2 and enemies.yards8<=5 and ttd(thisUnit)-moonfire.remain>mfTick*5 then
						if self.castMoonfire(thisUnit) then return end
			    	end
			    end
			end      
		-- Maintain: Rake
			-- cycle_targets=1,if=persistent_multiplier>dot.rake.pmultiplier&spell_targets.swipe=1&((target.time_to_die-remains>3&spell_targets.swipe<3)|target.time_to_die-remains>6)
			for i=1, #bleed.rake do
				local rake = bleed.rake[i]
				local thisUnit = rake.unit
				if (multidot or (UnitIsUnit(thisUnit,dynTar5) and not multidot)) and rake.calc>rake.applied and enemies.yards8==1 and ((ttd(thisUnit)-rake.remain>3 and enemies.yards8<3) or ttd(thisUnit)-rake.remain>6) then
					if self.castRake(thisUnit) then return end
				end
			end	
		end -- End Action List - Maintain
	-- Action List - Generator
		local function actionList_Generator()
		-- Generator: Swipe
	   		-- if=spell_targets.swipe>=4|(spell_targets.swipe>=3&buff.incarnation.down)
	   		if BadBoy_data['AoE']==2 or (BadBoy_data['AoE']==1 and (enemies.yards8>=3 or (enemies.yards8>=3 and not buff.incarnationKingOfTheJungle))) and getDistance(dynTar8)<8 then
	   			if self.castSwipe(dynTar8) then return end
	      	end
		-- Generator: Shred
	   		-- if=spell_targets.swipe<3|(spell_targets.swipe=3&buff.incarnation.up)
	   		if (BadBoy_data['AoE']==3 or (BadBoy_data['AoE']==1 and (enemies.yards8<3 or (enemies.yards8==3 and buff.incarnationKingOfTheJungle)))) and getDistance(dynTar5)<5 then
	   			if self.castShred(dynTar5) then return end
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
			elseif inCombat and cat and profileStop==false and not isChecked("Death Cat Mode") then
		-- TODO: Wild Charge
		-- TODO: Displacer Beast
		-- TODO: Dash/Worgen Racial
		-- Rake/Shred from Stealth
				-- rake,if=buff.prowl.up|buff.shadowmeld.up
				if buff.prowl or buff.shadowmeld then
					if perk.improvedRake and debuff.remain.rake==0 then
						if self.castRake(dynTar5) then return end
		        	else
		        		if self.castShred(dynTar5) then return end
		            end
				elseif not stealth and BadBoy_data['AoE'] ~= 4 then
					-- auto_attack
					if getDistance(dynTar5)<5 then
						StartAttack()
					end
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
					for i=1, #getEnemies("player",5) do
						local thisUnit = getEnemies("player",5)[i]
						if fbDamage > UnitHealth(thisUnit) then
							if self.castFerociousBite(thisUnit) then return end
						end
					end
		-- Ferocious Bite
					-- cycle_targets=1,if=dot.rip.ticking&dot.rip.remains<3&target.health.pct<25
					for i=1, #bleed.rip do
						local rip = bleed.rip[i]
						local thisUnit = rip.unit
						if (multidot or (UnitIsUnit(thisUnit,dynTar5) and not multidot)) and rip.remain>0 and rip.remain<3 and thp(thisUnit)<25 then
							if self.castFerociousBite(thisUnit) then return end
						end
					end
		-- Healing Touch
					-- if=talent.bloodtalons.enabled&buff.predatory_swiftness.up&((combo_points>=4&!set_bonus.tier18_4pc)|combo_points=5|buff.predatory_swiftness.remains<1.5)
					if talent.bloodtalons and buff.predatorySwiftness and ((combo >= 4 and not t18_4pc) or combo == 5 or buff.remain.predatorySwiftness < 1.5) then
						if getOptionValue("Auto Heal")==1 then
							if self.castHealingTouch(nNova[1].unit) then return end
		                end
		                if getOptionValue("Auto Heal")==2 then
		                	if self.castHealingTouch("player") then return end
		                end
					end
		-- Savage Roar
					-- if=buff.savage_roar.down
					if not buff.savageRoar then
						if self.castSavageRoar() then return end
		            end
		-- Thrash with T18 4pc
					-- if=set_bonus.tier18_4pc&buff.omen_of_clarity.react&remains<4.5&combo_points+buff.bloodtalons.stack!=6
					if t18_4pc and clearcast and thrashRemain(dynTar8AoE)<4.5 and (combo + charges.bloodtalons) ~= 6 and getDistance(dynTar8AoE)<8 then
						if self.castThrash(dynTar8AoE) then return end
					end
		-- Thrash with T17 2pc
					-- cycle_targets=1,if=remains<4.5&(active_enemies>=2&set_bonus.tier17_2pc|active_enemies>=4)
					for i=1, #bleed.thrash do
						local thrash = bleed.thrash[i]
						local thisUnit = thrash.unit
						if (multidot or (UnitIsUnit(thisUnit,dynTar8AoE) and not multidot)) and thrash.remain<4.5 and ((enemies.yards8>=2 and t17_2pc) or enemies.yards8>=4) then
							if self.castThrash(thisUnit) then return end
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
		-- Thrash
					-- cycle_targets=1,if=remains<4.5&spell_targets.thrash_cat>=2
					for i=1, #bleed.thrash do
						local thrash = bleed.thrash[i]
						local thisUnit = thrash.unit
						if (multidot or (UnitIsUnit(thisUnit,dynTar8AoE) and not multidot)) and thrash.remain<4.5 and enemies.yards8>=2 then
							if self.castThrash(thisUnit) then return end
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