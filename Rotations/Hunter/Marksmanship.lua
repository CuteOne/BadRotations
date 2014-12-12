if select(3, UnitClass("player")) == 3 then
	-- Rotation
	function MarkHunter()
		if Currentconfig ~= "Marksmanship" then
			MarkConfig();
			MarkToggles();
			Currentconfig = "Marksmanship";
		end

		--Variables
		local player_haste = round2(UnitSpellHaste("player"),2)
		local current_focus = UnitPower("player")
		local max_focus = UnitPowerMax("player")
		local focus_defecit = (max_focus - current_focus)
		local focus_regen = round2(select(2,GetPowerRegen("player")),2)
		local focusing_shot_cast_time = select(4,GetSpellInfo(163485)) / 1000
		local focusing_shot_regen = (focusing_shot_cast_time * focus_regen)
		local power_shot_cast_time = select(4,GetSpellInfo(109259)) / 1000
		local power_shot_regen = (power_shot_cast_time * focus_regen)
		local aimed_shot_cast_time = select(4,GetSpellInfo(19434)) / 1000
		local aimed_shot_regen = (aimed_shot_cast_time * focus_regen)
		local steady_shot_cast_time = select(4,GetSpellInfo(56641)) / 1000
		local steady_shot_regen = (steady_shot_cast_time * focus_regen)
		local PetDistance = getDistance("pet","target")

		-- myEnemies
		if myEnemiesTimer == nil or myEnemiesTimer <= GetTime() - 0.5 or myEnemies == nil then
			myEnemies, myEnemiesTimer = #getEnemies("target",10), GetTime();
		end

		--Middle Mouse Override
		if IsMouseButtonDown(3) then
			RunMacroText("/click"..GetMouseFocus():GetName())
		end

		--Don't use rotation checks
		if UnitInVehicle("Player") then return false; end --Dont want to cast if we are in a vehicle
		if UnitBuffID("player",5384) ~= nil then return false; end --Dont want to do anything if we feign death
		--add in some kind of spam stop here to do with target HP% and Target Casting

		-- Aspect of the Cheetah
		if not isInCombat("player") and isChecked("Auto-Cheetah") and getSpellCD(5118) == 0
		  and not UnitBuffID("player", 5118)
		  and not IsMounted()
		  and isCasting("player") == false
		  and IsMovingTime(1.5)
		  and not UnitIsDeadOrGhost("player")
		  and GetShapeshiftForm() ~= 2 then
			castSpell("player",5118,true,false);
		end

		if (isInCombat("player") or IsMounted("player")) and UnitBuffID("player",5118) ~= nil then
			RunMacroText("/cancelaura Aspect of the Cheetah")
		end

		-- Trap Launcher if not activated
		if isChecked("Trap Launcher") then 
			if not UnitBuffID("player",77769) then
				castSpell("player",77769,true,false);
			end
		end

		----------------------------------------------------------
		--Exotic Munitions   ADD WHEN 100--------------------
		--------------------------------------------------------
		if isKnown(162534) and isChecked("Exotic Munitions") and UnitCastingInfo("player") == nil then
			if getValue("Exotic Munitions") == 1 then
				if UnitBuffID("player",162536) == nil then
					castSpell("player",162536,true,true);
				end
			elseif getValue("Exotic Munitions") == 2 then
				if UnitBuffID("player",162537) == nil then
					castSpell("player",162537,true,true);
				end
			elseif getValue("Exotic Munitions") == 3 then
				if UnitBuffID("player",162539) == nil then
					castSpell("player",162539,true,true);
				end
			end
		end


		-------------------------
		-- Pet Management -- Mavmins Updated
		-------------------------
		if isChecked("Auto Summon")  and not UnitExists("pet") and (UnitIsDead("pet") ~= nil and UnitIsDead("pet") ~= false) then
			if waitForPetToAppear ~= nil and waitForPetToAppear < GetTime() - 2 then
				-- if lastFailedWhistle and lastFailedWhistle > GetTime() - 3 then
				-- 	if castSpell("player",RevivePet) then return; end
				-- else
				local Autocall = getValue("Auto Summon");

				if Autocall == 1 then
					if castSpell("player",CallPet1) then return; end
				elseif Autocall == 2 then
					if castSpell("player",CallPet2) then return; end
				elseif Autocall == 3 then
					if castSpell("player",CallPet3) then return; end
				elseif Autocall == 4 then
					if castSpell("player",CallPet4) then return; end
				elseif Autocall == 5 then
					if castSpell("player",CallPet5) then return; end
				else
					print("Auto Call Pet Error")
				end
			end
			if waitForPetToAppear == nil then
				waitForPetToAppear = GetTime()
			end
		end

		if UnitIsDeadOrGhost("pet") then
			if castSpell("player",RevivePet) then return; end
		end

		-- Mend Pet
		if isChecked("Mend Pet") and getHP("pet") < getValue("Mend Pet") and not UnitBuffID("pet",136) then
			if castSpell("pet",136) then return; end
		end



		--------------------
		--- Combat Check ---
		--------------------
		if UnitAffectingCombat("player") == true and UnitExists("target") == true and UnitIsVisible("target") == true
		  and UnitIsDeadOrGhost("target") == false and UnitCanAttack("target","player") == true then

			---------------------------
			--- Defensive Abilities --- Mavmins Updated
			---------------------------

			--HP Stone
	        if isChecked("Healthstone/Potion") == true then
	            if getHP("player") <= getValue("Healthstone/Potion") then
	                if canUse(5512) then
	                    UseItemByName(tostring(select(1,GetItemInfo(5512))))
	                elseif canUse(76067) then -- MoP Potion (Master Healing Potion)
	                	UseItemByName(tostring(select(1,GetItemInfo(76089))))
	                elseif canUse(109223) then -- WoD Potion (Healing Tonic)
	                	UseItemByName(tostring(select(1,GetItemInfo(109223))))
	                elseif canUse(109226) then -- WoD Potion (Draenic Rejuvenation Potion)
	                	UseItemByName(tostring(select(1,GetItemInfo(109226))))
	                end
	            end
        	end

			-- Misdirection
			if isChecked("Misdirection") and getSpellCD(34477) == 0 then
				if getValue("Misdirection") == 1 and UnitExists("pet") and UnitBuffID("pet",34477) == nil then
					if castSpell("pet",34477,true,false) then return; end
				elseif getValue("Misdirection") == 2 and UnitExists("focus") == true and UnitBuffID("focus",34477) == nil then
					if castSpell("focus",34477,true,false) then return; end
				end
			end

			--Intimidation on Aggro
			if isChecked("Intimidation") and (getValue("Intimidation") == 1 or getValue("Intimidation") == 3) and UnitExists("pet") then
				if UnitExists("target") and UnitThreatSituation("player", "target") == 3 then
					if isKnown(19577) and getSpellCD(19577) == 0 then
						if castSpell("target",19577,true,false) then return; end
					end 
				end
			end

			-- Deterrence
			if isChecked("Deterrence") and getSpellCD(148467) == 0 then
				if getHP("player") <= getValue("Deterrence") and UnitBuffID("player",148467) == nil then
					if castSpell("player",148467,true,false) then return; end
				end
			end

			--Feign Death
			if isChecked("Feign Death") and getSpellCD(5384) == 0 and UnitBuffID("player",5384) == nil then
				if getHP("player") <= getValue("Feign Death") then
					if castSpell("player",5384,true,false) then return; end
				end
			end

			--Disengage
			if isChecked("Disengage") and getSpellCD(781) == 0 then
				if getDistance("player","target") <= getValue("Disengage") then
					if castSpell("player",781,true,false) then return; end
				end
			end


			------------------
			--- Interrupts --- Mavmins Updated
			------------------
			if BadBoy_data["Interrupts"] == 3 then --all interrupt
				 if isChecked("Counter Shot") then
				 	if isKnown(147362) and getSpellCD(147362) == 0 then
						castInterrupt(147362,getValue("Counter Shot"))
				 	end
				
				end

				 if isChecked("Intimidation") and (getValue("Intimidation") == 2 or getValue("Intimidation") == 3)  and UnitExists("pet") then
				 	if isKnown(19577) and (getSpellCD(19577) == 0 and getSpellCD(147362) > 0) then
				 		castInterrupt(147362,getValue("Counter Shot"))
				 		--if canInterrupt("target", 1) then
							if castSpell("target",19577,false,false) then return; end
				 		--end
				 	end
				 end
			end

			-----------------
			--- Cooldowns --- Mavmins Updated
			-----------------
			-- Rapid Fire
			if BadBoy_data["Cooldowns"] == 3 or (isChecked("Rapid Fire") and (getValue("Rapid Fire") == 3 or getValue("Rapid Fire") == 2 and BadBoy_data["Cooldowns"] == 2)) then
				if castSpell("player",3045,false,false) then return; end
			end
			-- Stampede
			if BadBoy_data["Cooldowns"] == 3 or (isChecked("Check Stampede") and (getValue("Stampede") == 3 or getValue("Stampede") == 2 and BadBoy_data["Cooldowns"] == 2)) then
				if castSpell("target",121818,false,false) then return; end
			end

			----------------------------
			--- Damage Rotation ---
			---------------------------

			-- actions=auto_shot
			-- actions+=/use_item,name=beating_heart_of_the_mountain (TRINKETS)

			-- actions+=/arcane_torrent,if=focus.deficit>=30
	        if (BadBoy_data['Cooldowns'] == 2 and isChecked("Racials") == true) or BadBoy_data['Cooldowns'] == 3 then
	            if isKnown(80483) then
	                if focus_defecit >= 30 then
	                    if castSpell("player",80483,true,false) then
	                        return;
	                    end
	                end
	            end
	        end

			-- actions+=/blood_fury
	        if (BadBoy_data['Cooldowns'] == 2 and isChecked("Racials") == true) or BadBoy_data['Cooldowns'] == 3 then
	            if isKnown(20572) then
	                if castSpell("player",20572,true,false) then
	                    return;
	                end
	            end
	        end

			-- actions+=/berserking
	        if (BadBoy_data['Cooldowns'] == 2 and isChecked("Racials") == true) or BadBoy_data['Cooldowns'] == 3 then
	            if isKnown(26297) then
	                if castSpell("player",26297,true,false) then
	                    return;
	                end
	            end
	        end

			-- actions+=/potion,name=draenic_agility,if=((buff.rapid_fire.up|buff.bloodlust.up)&(cooldown.stampede.remains<1))|target.time_to_die<=25
	        if (BadBoy_data['Cooldowns'] == 2 and isChecked("Potions") == true) or BadBoy_data['Cooldowns'] == 3 then
	            if ((UnitBuffID("player",3045) ~= nil or hasBloodLust() == true) and ((isKnown(121818) and getSpellCD(121818) <1) or isKnown(121818) == false)) or getTimeToDie("target") <= 25 then
	                if canUse(76089) then -- MoP Potion (Virmens Bite)
	                    UseItemByName(tostring(select(1,GetItemInfo(76089))))
	                elseif canUse(109217) then -- WoD Potion (Draenic Agility)
	                    UseItemByName(tostring(select(1,GetItemInfo(109217))))
	                end
	            end
	        end

			-- actions+=/chimaera_shot
			if isKnown(53209) then
				if getSpellCD(53209) == 0 then
					if castSpell("target",53209,false,false) then return; end
				end
			end

			-- actions+=/kill_shot (with perk and without)
			if isKnown(157708) then
				if getSpellCD(157708) == 0 and getHP("target") <= 35 then
					if UnitCastingInfo("player") ~= nil then 
						RunMacroText("/stopcasting")
						RunMacroText("/stopcasting")
						if castSpell("target",157708,false,false) then return; end
					else
						if castSpell("target",157708,false,false) then return; end
					end
				end
			else 
				if isKnown(53351) and getSpellCD(53351) == 0 and getHP("target") <= 20 then
					if UnitCastingInfo("player") ~= nil then 
						RunMacroText("/stopcasting")
						RunMacroText("/stopcasting")
						if castSpell("target",53351,false,false) then return; end
					else
						if castSpell("target",53351,false,false) then return; end
					end
				end
			end

			-- actions+=/rapid_fire
	        if (BadBoy_data['Cooldowns'] == 2 and isChecked("Rapid Fire") == true) or BadBoy_data['Cooldowns'] == 3 then
	            if isKnown(3045) and getSpellCD(3045) == 0 then
	                if castSpell("player",3045,true,false) then
	                    return;
	                end
	            end
	        end

			-- actions+=/stampede,if=buff.rapid_fire.up|buff.bloodlust.up|target.time_to_die<=25
			if (BadBoy_data['Cooldowns'] == 2 and isChecked("Stampede") == true) or BadBoy_data['Cooldowns'] == 3 then
	            if isKnown(121818) and getSpellCD(121818) == 0 then
	                if castSpell("target",121818,false,false) then
	                    return;
	                end
	            end
	        end

			-- actions+=/call_action_list,name=careful_aim,if=buff.careful_aim.up
			if getHP("target") > 80 or UnitBuffID("player",3045) ~= nil then

				-- actions.careful_aim=glaive_toss,if=active_enemies>2
				if isKnown(117050) and getSpellCD(117050) == 0 then
					if BadBoy_data['AoE'] == 2 or (BadBoy_data['AoE'] == 3 and myEnemies > 2) then
						if castSpell("target",117050,false,false) then return; end
					end
				end
				
				-- actions.careful_aim+=/powershot,if=active_enemies>1&cast_regen<focus.deficit
				if isKnown(109259) then
					if BadBoy_data['AoE'] == 2 or (BadBoy_data['AoE'] == 3 and myEnemies > 1) and power_shot_regen < focus_defecit then
						if castSpell("target",109259,false,false) then return; end
					end
				end

				-- actions.careful_aim+=/barrage,if=active_enemies>1
				if isKnown(120360) then
					if BadBoy_data['AoE'] == 2 or (BadBoy_data['AoE'] == 3 and myEnemies > 1) then
						if castSpell("target",120360,false,false) then return; end
					end
				end

				-- actions.careful_aim+=/aimed_shot
				if isKnown(19434) then
					if castSpell("target",19434,false,false) then return; end
				end

				-- actions.careful_aim+=/focusing_shot,if=50+cast_regen<focus.deficit
				if isKnown(163485) then
					if 50 + focusing_shot_regen < focus_defecit then
						if castSpell("target",163485,false,true) then return; end
					end
				end

				-- actions.careful_aim+=/steady_shot
				if isKnown(56641) then
					if castSpell("target",56641,false,false) then return; end
				end

			end

			-- actions+=/explosive_trap,if=active_enemies>1
			if (isKnown(82939) and isChecked("Explosive Trap") and getSpellCD(82939) == 0) and UnitBuffID("player",77769) ~= nil then 
				if BadBoy_data['AoE'] == 2 or (BadBoy_data['AoE'] == 3 and myEnemies > 1) and getGround("target") == true and isMoving("target") ~= true then
					if castGround("target",82939,40) then return; end
				end
			end

			-- actions+=/a_murder_of_crows
	        if (BadBoy_data['Cooldowns'] == 2 and isChecked("A Murder of Crows") == true) or BadBoy_data['Cooldowns'] == 3 then
	            if isKnown(131894) and getSpellCD(131894) == 0 then
	                if castSpell("target",131894,true,false) then
	                    return;
	                end
	            end
	        end

			-- actions+=/dire_beast,if=cast_regen+action.aimed_shot.cast_regen<focus.deficit FINISH THIS ONE LATER
	        if (BadBoy_data['Cooldowns'] == 2 and isChecked("Dire Beast") == true) or BadBoy_data['Cooldowns'] == 3 then
	             if isKnown(120679) and getSpellCD(120679) == 0 then
	       			if aimed_shot_regen + 18 < focus_defecit then
		                if castSpell("target",120679,true,false) then
		                    return;
		            	end
		       		end
	             end
	         end

			-- actions+=/glaive_toss
			if isKnown(117050) and getSpellCD(117050) == 0 then
				if castSpell("target",117050,false,false) then return; end
			end

			-- actions+=/powershot,if=cast_regen<focus.deficit
			if isKnown(109259) then
				if power_shot_regen < focus_defecit then
					if castSpell("target",109259,false,false) then return; end
				end
			end

			-- actions+=/barrage
			if isKnown(120360) then
				if castSpell("target",120360,false,false) then return; end
			end

			-- actions+=/steady_shot,if=focus.deficit*cast_time%(14+cast_regen)>cooldown.rapid_fire.remains -added CD check because this is pooling focus for rapid fire use
			if (BadBoy_data['Cooldowns'] == 2 and isChecked("Rapid Fire") == true) or BadBoy_data['Cooldowns'] == 3 then
				if isKnown(56641) then
					if focus_defecit * steady_shot_cast_time / (14 + steady_shot_regen) > getSpellCD(3045) then
						if castSpell("target",56641,false,false) then return; end
					end
				end
			end

			-- actions+=/focusing_shot,if=focus.deficit*cast_time%(50+cast_regen)>cooldown.rapid_fire.remains&focus<100    -added CD check because this is pooling focus for rapid fire use
			if (BadBoy_data['Cooldowns'] == 2 and isChecked("Rapid Fire") == true) or BadBoy_data['Cooldowns'] == 3 then
				if isKnown(163485) then
					if focus_defecit * focusing_shot_cast_time / (50 + focusing_shot_regen) > getSpellCD(3045) and current_focus < 100 then
						if castSpell("target",163485,false,false) then return; end
					end
				end
			end

			-- actions+=/steady_shot,if=buff.pre_steady_focus.up&(14+cast_regen+action.aimed_shot.cast_regen)<=focus.deficit   
			if isKnown(56641) then
				if UnitBuffID("player",177668) ~= nil and (14 + steady_shot_regen + aimed_shot_regen) <= focus_defecit then
					if castSpell("target",56641,false,false) then return; end
				end
			end


			-- actions+=/multishot,if=active_enemies>6
			if isKnown(2643) and getSpellCD(2643) == 0 then 
				if BadBoy_data['AoE'] == 2 or (BadBoy_data['AoE'] == 3 and myEnemies >= 5) then
					if castSpell("target",2643,false,false) then return; end
				end
			end

			-- actions+=/aimed_shot,if=talent.focusing_shot.enabled
			if isKnown(19434) then 
				if isKnown(163485) then
					if castSpell("target",19434,false,false) then return; end
				end
			end

			-- actions+=/aimed_shot,if=focus+cast_regen>=85
			if isKnown(19434) then 
				if current_focus + aimed_shot_regen >= 85 then
					if castSpell("target",19434,false,false) then return; end
				end
			end

			-- actions+=/aimed_shot,if=buff.thrill_of_the_hunt.react&focus+cast_regen>=65
			if isKnown(19434) then 
				if UnitBuffID("player",34720) ~= nil and current_focus + aimed_shot_regen >= 65 then
					if castSpell("target",19434,false,false) then return; end
				end
			end

			-- actions+=/focusing_shot,if=50+cast_regen-10<focus.deficit
			if isKnown(163485) then
				if 50 + focusing_shot_regen - 10 < focus_defecit  then
					if castSpell("target",163485,false,true) then return; end
				end
			end

			-- actions+=/steady_shot
			if isKnown(56641) then
				if castSpell("target",56641,false,false) then return; end
			end

		end
	end
end