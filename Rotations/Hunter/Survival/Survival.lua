if select(3, UnitClass("player")) == 3 then

	function SurvHunter()

		if Currentconfig ~= "Mavmins Survival" then
			SurvConfig()
			SurvToggles()
			Currentconfig = "Mavmins Survival"
		end

		--Variables----------------------------------------------
		local player_haste = round2(UnitSpellHaste("player"),2)
		local current_focus = UnitPower("player")
		local max_focus = UnitPowerMax("player")
		local focus_defecit = (max_focus - current_focus)
		local focus_regen = round2(select(2,GetPowerRegen("player")),2)
		local focusing_shot_cast_time = select(4,GetSpellInfo(163485)) / 1000
		local focusing_shot_regen = (focusing_shot_cast_time * focus_regen)
		local power_shot_cast_time = select(4,GetSpellInfo(109259)) / 1000
		local power_shot_regen = (power_shot_cast_time * focus_regen)
		local cobra_shot_cast_time = select(4,GetSpellInfo(77767)) / 1000
		local cobra_shot_regen = (cobra_shot_cast_time * focus_regen)
		local player_gcd_time = ((1.5/GetHaste("player"))+1)
		local player_gcd_regen = (player_gcd_time * focus_regen)
		local PetDistance = getDistance("pet","target")

		
		--myEnemies----------------------------------------------
		if myEnemiesTimer == nil or myEnemiesTimer <= GetTime() - 0.5 or myEnemies == nil then
			myEnemies, myEnemiesTimer = #getEnemies("target",10), GetTime()
		end

		--Middle Mouse Override-----------------------------------
		if IsMouseButtonDown(3) then
			RunMacroText("/click"..GetMouseFocus():GetName())
		end

		--Don't use rotation checks
		if UnitInVehicle("Player") then return false end --Dont want to cast if we are in a vehicle
		if UnitBuffID("player",5384) ~= nil then return false end --Dont want to do anything if we feign death

		-- OFF-GCD here we add the spells we want to be spamming all the time
		if UnitAffectingCombat("player") then
			---Interrupts---------------------------------------------
			if isChecked("Counter Shot") then
				castInterrupt(147362,getValue("Counter Shot"))
			end

			if isChecked("Intimidation") and (getValue("Intimidation") == 2 or getValue("Intimidation") == 3)  and UnitExists("pet") then
			 	if isKnown(19577) and (getSpellCD(19577) == 0 and getSpellCD(147362) > 0) then
					castInterrupt(147362,getValue("Counter Shot"))
				 end
			end
		end	
		
		--GCD check---------------------------------------------
		if castingUnit() then
			return
		end

		--Aspect of the Cheetah------------------------------------
		if (not isInCombat("player") or hasGlyph(692) == true) and isChecked("Auto-Cheetah") and getSpellCD(5118) == 0
			and not UnitBuffID("player", 5118)
			and not IsMounted()
			and isCasting("player") == false
			and IsMovingTime(1.5)
			and not UnitIsDeadOrGhost("player")
			and GetShapeshiftForm() ~= 2 then
				castSpell("player",5118,true,false)
		end

		if (isInCombat("player") or IsMounted("player")) and UnitBuffID("player",5118) ~= nil then
			if hasGlyph(692) == false then
				RunMacroText("/cancelaura Aspect of the Cheetah")
			end
		end

		-- Trap Launcher if not activated---------------------------
		if isChecked("Trap Launcher") then 
			if not UnitBuffID("player",77769) then
				castSpell("player",77769,true,false)
			end
		end

		--Exotic Munitions-------------------------------------------
		if isKnown(162534) and isChecked("Exotic Munitions") and UnitCastingInfo("player") == nil then
			if getValue("Exotic Munitions") == 1 then
				if UnitBuffID("player",162536) == nil then
					if castSpell("player",162536,true,true) then return end
				end
			elseif getValue("Exotic Munitions") == 2 then
				if UnitBuffID("player",162537) == nil then
					if castSpell("player",162537,true,true) then return end
				end
			elseif getValue("Exotic Munitions") == 3 then
				if UnitBuffID("player",162539) == nil then
					if castSpell("player",162539,true,true) then return end
				end
			end
		end

		-- Pet Management---------------------------------------------
		if isChecked("Auto Summon")  and not UnitExists("pet") and (UnitIsDead("pet") ~= nil or UnitIsDead("pet") == false) then
			if waitForPetToAppear ~= nil and waitForPetToAppear < GetTime() - 2 then
				if lastFailedWhistle and lastFailedWhistle > GetTime() - 3 then
				 	if castSpell("player",RevivePet) then return end
				else
					local Autocall = getValue("Auto Summon")

					if Autocall == 1 then
						if castSpell("player",883) then return end
					elseif Autocall == 2 then
						if castSpell("player",83242) then return end
					elseif Autocall == 3 then
						if castSpell("player",83243) then return end
					elseif Autocall == 4 then
						if castSpell("player",83244) then return end
					elseif Autocall == 5 then
						if castSpell("player",83245) then return end
					else
						print("Auto Call Pet Error")
					end
				end
			end
			if waitForPetToAppear == nil then
				waitForPetToAppear = GetTime()
			end
		end

		if isChecked("Auto Summon") and UnitIsDeadOrGhost("pet") then
			if castSpell("player",982) then return end
		end

		--Mend Pet----------------------------------------------------
		if isChecked("Mend Pet") and getHP("pet") < getValue("Mend Pet") and not UnitBuffID("pet",136) then
			if castSpell("pet",136) then return end
		end


		--Combat Check-------------------------------------------------
		if UnitAffectingCombat("player") == true and UnitExists("target") == true and UnitIsVisible("target") == true
			and UnitIsDeadOrGhost("target") == false and UnitCanAttack("target","player") == true then

			--Defensive Abilities--------------------------------------
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

			--Misdirection
			if isChecked("Misdirection") and getSpellCD(34477) == 0 then
				if getValue("Misdirection") == 1 and UnitExists("pet") and UnitBuffID("pet",34477) == nil then
					if castSpell("pet",34477,true,false) then return end
				elseif getValue("Misdirection") == 2 and UnitExists("focus") == true and UnitBuffID("focus",34477) == nil then
					if castSpell("focus",34477,true,false) then return end
				end
			end

			--Intimidation on Aggro
			if isChecked("Intimidation") and (getValue("Intimidation") == 1 or getValue("Intimidation") == 3) and UnitExists("pet") then
				if UnitExists("target") and UnitThreatSituation("player", "target") == 3 then
					if isKnown(19577) and getSpellCD(19577) == 0 then
						if castSpell("target",19577,true,false) then return end
					end 
				end
			end

			--Deterrence
			if isChecked("Deterrence") and getSpellCD(148467) == 0 then
				if getHP("player") <= getValue("Deterrence") and UnitBuffID("player",148467) == nil then
					if castSpell("player",148467,true,false) then return end
				end
			end

			--Feign Death
			if isChecked("Feign Death") and getSpellCD(5384) == 0 and UnitBuffID("player",5384) == nil then
				if getHP("player") <= getValue("Feign Death") then
					if castSpell("player",5384,true,false) then return end
				end
			end

			--Disengage
			if isChecked("Disengage") and getSpellCD(781) == 0 then
				if getDistance("player","target") <= getValue("Disengage") then
					if castSpell("player",781,true,false) then return end
				end
			end

			--Cooldowns--------------------------------------------------------
			--Stampede
			if BadBoy_data["Cooldowns"] == 3 or (isChecked("Check Stampede") and (getValue("Stampede") == 3 or getValue("Stampede") == 2 and BadBoy_data["Cooldowns"] == 2)) then
				if castSpell("target",121818,false,false) then return end
			end

			--Damage Rotation--------------------------------------------------
			--actions+=/use_item,name=gorashans_lodestone_spike
			if isChecked("Trinkets") then
				if GetInventoryItemCooldown(14)==0 then
					UseInventoryItem(14)
				end
				if GetInventoryItemCooldown(13)==0 then
					UseInventoryItem(13)
				end
			end

			-- actions+=/arcane_torrent,if=focus.deficit>=30
			if (BadBoy_data['Cooldowns'] == 2 and isChecked("Racials") == true) or BadBoy_data['Cooldowns'] == 3 then
	            if isKnown(80483) then
	                if focus_defecit >= 30 then
	                    if castSpell("player",80483,true,false) then return end
	                end
	            end
	        end

			-- actions+=/blood_fury
	        if (BadBoy_data['Cooldowns'] == 2 and isChecked("Racials") == true) or BadBoy_data['Cooldowns'] == 3 then
	            if isKnown(20572) and getSpellCD(20572) == 0 then
	                if castSpell("player",20572,true,false) then return end
	            end
	        end

			-- actions+=/berserking
	        if (BadBoy_data['Cooldowns'] == 2 and isChecked("Racials") == true) or BadBoy_data['Cooldowns'] == 3 then
	            if isKnown(26297) and getSpellCD(26297) == 0 then
	                if castSpell("player",26297,true,false) then return end
	            end
	        end

			-- actions+=/potion,name=draenic_agility,if=(((cooldown.stampede.remains<1)&(cooldown.a_murder_of_crows.remains<1))&(trinket.stat.any.up|buff.archmages_greater_incandescence_agi.up))|target.time_to_die<=25
			--TBC

			-- actions+=/call_action_list,name=aoe,if=active_enemies>1
			if BadBoy_data['AoE'] == 2 or (BadBoy_data['AoE'] == 3 and myEnemies > 1) then
				-- actions.aoe=stampede,if=buff.potion.up|(cooldown.potion.remains&(buff.archmages_greater_incandescence_agi.up|trinket.stat.any.up|buff.archmages_incandescence_agi.up))
				-- actions+=/stampede  -- TEMPORARY
				if BadBoy_data["Cooldowns"] == 3 or (isChecked("Stampede") and BadBoy_data["Cooldowns"] == 2) then
					if castSpell("target",121818,false,false) then return end
				end

				-- actions.aoe+=/explosive_shot,if=buff.lock_and_load.react&(!talent.barrage.enabled|cooldown.barrage.remains>0)
				if isKnown(53301) and getSpellCD(53301) == 0 then
					if UnitBuffID("player",168980) ~= nil and (isKnown(120360) == false or (isKnown(120360) == true and getSpellCD(120360) > 0)) then
						if castSpell("target",53301,false,false) then return end
					end
				end

				-- actions.aoe+=/barrage
				if isKnown(120360) and getSpellCD(120360) == 0 then
					if castSpell("target",120360,false,false) then return end
				end

				-- actions.aoe+=/black_arrow,if=!ticking
				if isKnown(3674) and getSpellCD(3674) == 0 then
					if UnitDebuffID("target",3674,"player") == nil then
						if castSpell("target",3674,false,false) then return end
					end
				end

				-- actions.aoe+=/explosive_shot,if=active_enemies<5
				if isKnown(53301) and getSpellCD(53301) == 0 then
					if myEnemies < 5 then
						if castSpell("target",53301,false,false) then return end
					end
				end

				-- actions.aoe+=/explosive_trap,if=dot.explosive_trap.remains<=5
				if (isKnown(82939) and isChecked("Explosive Trap") and getSpellCD(82939) == 0) and UnitBuffID("player",77769) ~= nil then 
					if getDebuffRemain("target",13812,"player") <= 5 then
						if castGround("target",82939,40) then return end
					end
				end

				-- actions.aoe+=/a_murder_of_crows
				if (BadBoy_data['Cooldowns'] == 2 and isChecked("A Murder of Crows") == true) or BadBoy_data['Cooldowns'] == 3 then
		            if isKnown(131894) and getSpellCD(131894) == 0 then
		                if castSpell("target",131894,true,false) then return end
		            end
	        	end

				-- actions.aoe+=/dire_beast
				if (BadBoy_data['Cooldowns'] == 2 and isChecked("Dire Beast") == true) or BadBoy_data['Cooldowns'] == 3 then
		            if isKnown(120679) and getSpellCD(120679) == 0 then
			        	if castSpell("target",120679,true,false) then return end
		            end
	        	end

				-- actions.aoe+=/multishot,if=buff.thrill_of_the_hunt.react&focus>50&cast_regen<=focus.deficit|dot.serpent_sting.remains<=5|target.time_to_die<4.5 
				if isKnown(2643) and getSpellCD(2643) == 0 then 
					if UnitBuffID("player",34720) ~= nil and current_focus > 50 and player_gcd_regen <= focus_defecit or getDebuffRemain("target",118253,"player") <= 5 or getTimeToDie("target") < 4.5 then
						if castSpell("target",2643,false,false) then return end
					end
				end

				-- actions.aoe+=/glaive_toss
				if isKnown(117050) and getSpellCD(117050) == 0 then
					if castSpell("target",117050,false,false) then return end
				end

				-- actions.aoe+=/powershot
				if isKnown(109259) and getSpellCD(109259) == 0 then
					if castSpell("target",109259,false,false) then return end
				end

				-- actions.aoe+=/cobra_shot,if=buff.pre_steady_focus.up&buff.steady_focus.remains<5&focus+14+cast_regen<80
				if isKnown(77767) and getSpellCD(77767) == 0 then
					if UnitBuffID("player",177668) ~= nil and getBuffRemain("player",177668) < 5 and (current_focus + 14 + cobra_shot_regen < 80) then
						if castSpell("target",77767,false,false) then return end
					end
				end
				
				-- actions.aoe+=/multishot,if=focus>=70|talent.focusing_shot.enabled
				if isKnown(2643) and getSpellCD(2643) == 0 then 
					if current_focus >= 70 or isKnown(163485) then
						if castSpell("target",2643,false,false) then return end
					end
				end

				-- actions.aoe+=/focusing_shot
				if isKnown(163485) and getSpellCD(163485) == 0 then
					if castSpell("target",163485,false,true) then return end
				end

				-- actions.aoe+=/cobra_shot
				if isKnown(77767) and getSpellCD(77767) == 0 then
					if castSpell("target",77767,false,false) then return end
				end
			end

			-- actions+=/stampede,if=buff.potion.up|(cooldown.potion.remains&(buff.archmages_greater_incandescence_agi.up|trinket.stat.any.up))|target.time_to_die<=25 (archmage buff 177172)
			--TBC

			-- actions+=/black_arrow,if=!ticking
			if isKnown(3674) and getSpellCD(3674) == 0 then
				if castSpell("target",3674,false,false) then return end
			end

			-- actions+=/explosive_shot
			if isKnown(53301) and getSpellCD(53301) == 0 then
				if castSpell("target",53301,false,false) then return end
			end

			-- actions+=/stampede  -- TEMPORARY
			if BadBoy_data["Cooldowns"] == 3 or (isChecked("Stampede") and BadBoy_data["Cooldowns"] == 2) then
				if castSpell("target",121818,false,false) then return end
			end

			-- actions+=/a_murder_of_crows
			if (BadBoy_data['Cooldowns'] == 2 and isChecked("A Murder of Crows") == true) or BadBoy_data['Cooldowns'] == 3 then
	            if isKnown(131894) and getSpellCD(131894) == 0 then
	                if castSpell("target",131894,true,false) then return end
	            end
	        end

			-- actions+=/dire_beast
	        if (BadBoy_data['Cooldowns'] == 2 and isChecked("Dire Beast") == true) or BadBoy_data['Cooldowns'] == 3 then
	            if isKnown(120679) and getSpellCD(120679) == 0 then
		        	if castSpell("target",120679,true,false) then return end
	            end
	        end

			-- actions+=/arcane_shot,if=buff.thrill_of_the_hunt.react&focus>35&cast_regen<=focus.deficit|dot.serpent_sting.remains<=3|target.time_to_die<4.5
			if isKnown(3044) and getSpellCD(3044) == 0 then
				if UnitBuffID("player",34720) ~= nil and current_focus > 35 and player_gcd_regen <= focus_defecit or getDebuffRemain("target",118253,"player") <= 3 or getTimeToDie("target") < 4.5 then
					if castSpell("target",3044,false,false) then return end
				end
			end

			-- actions+=/glaive_toss
			if isKnown(117050) and getSpellCD(117050) == 0 then
				if castSpell("target",117050,false,false) then return end
			end

			-- actions+=/powershot
			if isKnown(109259) and getSpellCD(109259) == 0 then
				if castSpell("target",109259,false,false) then return end
			end

			-- actions+=/barrage
			if isKnown(120360) and getSpellCD(120360) == 0 then
				if castSpell("target",120360,false,false) then return end
			end

			-- actions+=/cobra_shot,if=buff.pre_steady_focus.up&buff.steady_focus.remains<5&(14+cast_regen)<=focus.deficit<80
			if isKnown(77767) and getSpellCD(77767) == 0 then
				if UnitBuffID("player",177668) ~= nil and getBuffRemain("player",177668) < 5 and ((14 + cobra_shot_regen) <= focus_defecit) then 
					if castSpell("target",77767,false,false) then return end
				end
			end

			-- actions+=/arcane_shot,if=focus>=80|talent.focusing_shot.enabled
			if isKnown(3044) and getSpellCD(3044) == 0 then
				if current_focus >= 80 or isKnown(163485) then
					if castSpell("target",3044,false,false) then return end
				end
			end

			-- actions+=/focusing_shot
			if isKnown(163485) and getSpellCD(163485) == 0 then
				if castSpell("target",163485,false,true) then return end
			end

			-- actions+=/cobra_shot
			if isKnown(77767) and getSpellCD(77767) == 0 then
				if castSpell("target",77767,false,false) then return end
			end

		end -- combatcheck
	end -- function SurvHunter()
end --if select(3, UnitClass("player")) == 3 then
