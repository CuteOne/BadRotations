if select(3,UnitClass("player")) == 1 then

function ProtectionWarrior()
if Currentconfig ~= "Protection Chumii" then
 WarriorProtConfig();
 WarriorProtToggles()
 Currentconfig = "Protection Chumii";
end

--[[Queues]]
if _Queues == nil then
 _Queues = {
    [Shockwave] = false, -- Shockwave
    [Bladestorm] = false,
    [DragonRoar] = false,
 }
end


if isChecked("Rotation Up") then
		if SpecificToggle("Rotation Up") == 1 and GetCurrentKeyBoardFocus() == nil then
	 	if myTimer == nil or myTimer <= GetTime() -0.7 then
	  		myTimer = GetTime()
	  		ToggleValue("AoE");
	 	end
	end
end
if isChecked("Rotation Down") then
    if SpecificToggle("Rotation Down") == 1 and GetCurrentKeyBoardFocus() == nil then
	 	if myTimer == nil or myTimer <= GetTime() -0.7 then
	  		myTimer = GetTime()
	  		ToggleMinus("AoE");
	 	end
	end
end
-- Locals
	local rage = UnitPower("player");
	local myHP = getHP("player");
	local ennemyUnits = getNumEnnemies("player", 5)
-- Food/Invis Check
	if canRun() ~= true or UnitInVehicle("Player") then return false; end
	if IsMounted("player") then return false; end

-- Pause 
	if isChecked("Pause Toggle") and SpecificToggle("Pause Toggle") == 1 then ChatOverlay("|cffFF0000BadBoy Paused", 0); return; end

-- HeroicLeapKey 
	 if isChecked("HeroicLeapKey") and SpecificToggle("HeroicLeapKey") == 1 then 
 		if not GetCurrentKeyBoardFocus() and not IsMouselooking() then
   			CastSpellByName(GetSpellInfo(6544))
   		if SpellIsTargeting() then 
   			CameraOrSelectOrMoveStart() CameraOrSelectOrMoveStop() 
   			return true;
  		end
  	end
 	end

 -- DemoBannerKey 
	 if isChecked("DemoBannerKey") and SpecificToggle("DemoBannerKey") == 1 then 
 		if not GetCurrentKeyBoardFocus() and not IsMouselooking() then
   			CastSpellByName(GetSpellInfo(114203))
   		if SpellIsTargeting() then 
   			CameraOrSelectOrMoveStart() CameraOrSelectOrMoveStop() 
   			return true;
  		end
  	end
 	end

 -- MockingBannerKey 
	 if isChecked("MockingBannerKey") and SpecificToggle("MockingBannerKey") == 1 then 
 		if not GetCurrentKeyBoardFocus() and not IsMouselooking() then
   			CastSpellByName(GetSpellInfo(114192))
   		if SpellIsTargeting() then 
   			CameraOrSelectOrMoveStart() CameraOrSelectOrMoveStop() 
   			return true;
  		end
  	end
 	end

	if not isInCombat("player") then
---------------------
--- Out of Combat ---
---------------------
		-- Shout
		if isChecked("ShoutOOC") == true then
			if isChecked("Shout") == true then
				--Commanding
				if getValue("Shout") == 1 and not UnitBuffID("player",CommandingShout) then
					if castSpell("player",CommandingShout,true) then
						return;
					end
				end
				-- Battle
				if getValue("Shout") == 2 and not UnitBuffID("player",BattleShout) then
					if castSpell("player",BattleShout,true) then
						return;
					end
				end
			end
		end
		
		--[[Charge if getDistance > 10]]
		if isChecked("Charge") == true and canAttack("target","player") and not UnitIsDeadOrGhost("target") and getDistance("player","target") > 10 then
			if targetDistance <= 40 and getGround("target") == true and UnitExists("target") then
				if castSpell("target",100,false,false) then return; end
			end
		end

	end
	if pause() ~= true and isInCombat("player") and canAttack("target","player") and not UnitIsDeadOrGhost("target") then			
-----------------
--- In Combat ---
-----------------

--------------------
--- Queue Spells ---
--------------------

if _Queues[Shockwave] == true then
 if castSpell("target",Shockwave,false,false) then return; end
end
if _Queues[Bladestorm] == true then
 if castSpell("target",Bladestorm,false,false) then return; end
end
if _Queues[DragonRoar] == true then
 if castSpell("target",DragonRoar,false,false) then return; end
end

------------------
--- Offensives ---
------------------

		-- Recklessness
		if isChecked("Recklessness") == true then
        	if getValue("Recklessness") == 2 and isBoss("target") or isDummy("target") then
        		if castSpell("player",Recklessness,true) then
		        	return;
		        end
		    elseif getValue("Recklessness") == 1 then
        		if castSpell("player",Recklessness,true) then
		        	return;
		        end
        	end
        end

        -- SkullBanner
        if isChecked("SkullBanner") == true then
        	if getValue("SkullBanner") == 2 and isBoss("target") or isDummy("target") then
        		if not UnitBuffID("player",SkullBanner)
        		and UnitBuffID("player",Recklessness) then
	        		if castSpell("player",SkullBanner,true) then
	        			return;
	        		end
	        	end
        	elseif getValue("SkullBanner") == 1 then
        		if not UnitBuffID("player",SkullBanner)
        		and UnitBuffID("player",Recklessness) then
	        		if castSpell("player",SkullBanner,true) then
	        			return;
	        		end
	        	end
        	end
        end

        -- Avatar        
        if isChecked("Avatar") == true then
        	if getValue("Avatar") == 2 and isBoss("target") or isDummy("target") then
        		if UnitBuffID("player",Recklessness) or getTimeToDie("target") <= 25 then
	        		if castSpell("player",Avatar,true) then
	        			return;
	        		end
	        	end
        	elseif getValue("Avatar") == 1 then
        		if UnitBuffID("player",Recklessness) or getTimeToDie("target") <= 25 then
	        		if castSpell("player",Avatar,true) then
	        			return;
	        		end
	        	end
        	end
        end

        -- Racial
		if isChecked("Racial") == true then
        	if getValue("Racial") == 2 and isBoss("target") or isDummy("target") then
        		if UnitBuffID("player",Recklessness) or getTimeToDie("target") <= 25 then
	        		if select(2, UnitRace("player")) == "Troll" then
		        		if castSpell("player",26297,true) then
		        			return;
		        		end
		        	elseif select(2, UnitRace("player")) == "Orc" then
		        		if castSpell("player",20572,true) then
		        			return;
		        		end
		        	end
		        end
        	elseif getValue("Racial") == 1 then
        		if UnitBuffID("player",Recklessness) or getTimeToDie("target") <= 25 then
	        		if select(2, UnitRace("player")) == "Troll" then
		        		if castSpell("player",26297,true) then
		        			return;
		        		end
		        	elseif select(2, UnitRace("player")) == "Orc" then
		        		if castSpell("player",20572,true) then
		        			return;
		        		end
		        	end
		        end
        	end
        end

        --actions+=/mogu_power_potion,if=(target.health.pct<20&buff.recklessness.up)|buff.bloodlust.react|target.time_to_die<=25
        if (getHP("target") <= 20 and UnitBuffID("player",Recklessness)) or hasLust() or getTimeToDie("target") <= 25 then        	
	        	if canUse(76095) then
					UseItemByName(tostring(select(1,GetItemInfo(76095))))
				end			
		end

------------------
--- Defensives ---
------------------

		-- Demo Shout
		if not UnitDebuffID("Target",DemoralizingShout) then
			if castSpell("player",DemoralizingShout,true) then
				return;
			end
		end
		
		-- Last Stand
		if isChecked("LastStand") == true then
			if getHP("player") <= getValue("LastStand") then
				if castSpell("player",LastStand,true) then
					return;
				end
			end
		end

		-- Rallying Cry
		if isChecked("RallyingCry") == true then
			if getHP("player") <= getValue("RallyingCry") then
				if castSpell("player",RallyingCry,true) then
					return;
				end
			end
		end

		-- ShieldWall
		if isChecked("ShieldWall") == true then
			if getHP("player") <= getValue("ShieldWall") then
				if castSpell("player",ShieldWall,true) then
					return;
				end
			end
		end

		-- Enraged Regeneration
		if isChecked("EnragedRegeneration") == true then
			if isKnown(EnragedRegeneration) and getHP("player") <= getValue("EnragedRegeneration") then
				if castSpell("player",EnragedRegeneration,true) then
					return;
				end
			end
		end

		-- Healthstone
        if isChecked("Healthstone") == true then
			if getHP("player") <= getValue("Healthstone") then
				if canUse(5512) then
					UseItemByName(tostring(select(1,GetItemInfo(5512))))
				end	
			end
		end

		-- Safeguard Focus
		if isChecked("SafeguardFocus") == true then
			if getHP("focus") <= getValue("SafeguardFocus") then
				if castSpell("focus",Safeguard,false,false) then
					return;
				end
			end
		end

		-- Vigilance Focus
		if isChecked("VigilanceFocus") == true then
			if getHP("focus") <= getValue("VigilanceFocus") then
				if castSpell("focus",Vigilance,false,false) then
					return;
				end
			end
		end


		

		if isCasting() then return false; end
		if targetDistance > 5 and targetDistance <= 40 then
--------------------
--- Out of Range ---
--------------------

			--[[Charge]]
			if isChecked("Charge") == true and canAttack("target","player") and not UnitIsDeadOrGhost("target") and getDistance("player","target") > 10 then
				if targetDistance <= 40 and getGround("target") == true and UnitExists("target") then
					if castSpell("target",100,false,false) then return; end
				end
			end

		elseif UnitExists("target") and not UnitIsDeadOrGhost("target") and isEnnemy("target") == true and getCreatureType("target") == true then


--------------------
--- Do everytime ---
--------------------

			-- actions+=/bloodbath,if=enabled&(debuff.colossus_smash.remains>0.1|cooldown.colossus_smash.remains<5|target.time_to_die<=20)
			if getDebuffRemain("target",ColossusSmash) > 0.1 or getSpellCD(ColossusSmash) < 5 or getTimeToDie("target") <= 20 then
				if castSpell("player",Bloodbath,true) then
					return;
				end
			end
			-- actions+=/berserker_rage,if=buff.enrage.remains<0.5
			if getBuffRemain("player",Enrage) < 0.5 then
				if castSpell("player",BerserkerRage,true) then
					return;
				end
			end
----------------
--- In Range ---
----------------
		
		-- shout once to get starting rage
			if getCombatTime() < 5 then
				if isChecked("Shout") == true then
					--Commanding
					if getValue("Shout") == 1 then
						if castSpell("player",CommandingShout,true) then
							return;
						end
					end
					-- Battle
					if getValue("Shout") == 2 then
						if castSpell("player",BattleShout,true) then
							return;
						end
					end
				end
			end


		-- Shield Block / Barrier
		if getValue("BlockBarrier") == 1 and not UnitBuffID("player",ShieldBlockBuff) then
			if castSpell("player",ShieldBlock,true) then
				return;
			end
		elseif getValue("BlockBarrier") == 2 and not UnitBuffID("player",ShieldBarrierBuff) and rage >= 50 then
			if castSpell("player",ShieldBarrier,true) then
				return
			end
		end

---------------------
--- Single Target ---
---------------------
		if not useAoE() and targetDistance < 5 then
			-- ImpendingVictory / Victory Rush
			if isChecked("ImpendingVictory") then
				if isKnown(ImpendingVictory) and getHP("player") <= getValue("ImpendingVictory") then
					if castSpell("target",ImpendingVictory,false,false) then
						return;
					end
				elseif not isKnown(ImpendingVictory) and getHP("player") <= getValue("ImpendingVictory") then
					if castSpell("target",VictoryRush,false,false) then
						return;
					end
				end
			end
			-- shield slam on cd / sword and board proc
			if castSpell("target",ShieldSlam,false,false) then
				return;
			end		
			-- revenge on cd
			if castSpell("target",Revenge,false,false) then
				return;
			end			
			-- shout if need rage
			if rage < 40 then
				if castSpell("target",CommandingShout,false,false) then
					return;
				end	
			end
			-- thunderclap if weakened blows missing
			if not UnitDebuffID("target",WeakenedBlows) then
				if castSpell("target",ThunderClap,true) then
					return;
				end
			end			
			-- heroic strike on ultimatum proc
			if rage > 100 or UnitBuffID("player",Ultimatum) then
				if castSpell("target",HeroicStrike,false,false) then
					return;
				end
			end
			-- devastate filler
			if castSpell("target",Devastate,false,false,false,true) then
				return;
			end	
		end
--------------------
--- Multi Target ---
--------------------
		if useAoE() then
			-- ImpendingVictory / Victory Rush
			if isChecked("ImpendingVictory") then
				if isKnown(ImpendingVictory) and getHP("player") <= getValue("ImpendingVictory") then
					if castSpell("target",ImpendingVictory,false,false) then
						return;
					end
				elseif not isKnown(ImpendingVictory) and getHP("player") <= getValue("ImpendingVictory") then
					if castSpell("target",VictoryRush,false,false) then
						return;
					end
				end
			end
			-- thunderclap on cd		
			if castSpell("target",ThunderClap,true) then
				return;
			end
			-- t4 talent (shockwave/bladestorm/dragonroar)
			if isChecked("StormRoar") == true and isKnown(DragonRoar) then
				if getDistance("player","target") <= 8 then
					if castSpell("target",DragonRoar,false,false) then
						return;
					end
				end
			end
			if isChecked("StormRoar") == true and isKnown(Bladestorm) then
				if getDistance("player","target") <= 8 then
					if castSpell("target",Bladestorm,false,false) then
						return;
					end
				end
			end
			-- shield slam on cd / sword and board proc
			if castSpell("target",ShieldSlam,false,false) then
				return;
			end	
			-- revenge on cd
			if castSpell("target",Revenge,false,false) then
				return;
			end	
			-- cleave on ultimatum
			if rage > 100 or UnitBuffID("player",Ultimatum) then
				if castSpell("target",Cleave,false,false) then
					return;
				end
			end
			-- devastate filler
			if castSpell("target",Devastate,false,false,false,true) then
				return;
			end	

		end

		end
	end
end
end
