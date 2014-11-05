function DruidGuardian()
  if currentConfig ~= "Guardian chumii" then
  	GuardianConfig()
		currentConfig = "Guardian chumii";
	end
	GuardianToggles();
	GroupInfo()
------------------------------------------------------------------------------------------------------
	-- Locals --------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------
	-- if not enemiesTimer or enemiesTimer <= GetTime() - 1 then
 --    	enemies, enemiesTimer = getNumEnemies("player",8), GetTime()
	-- end
	--local tarDist = getDistance2("target")
	local GCD = 1.5/(1+UnitSpellHaste("player")/100)
	local hasTarget = UnitExists("target")
	local hasMouse = UnitExists("mouseover")
	local php = getHP("player")
	local thp = getHP("target")
	local rage = getPower("player")
	local ttd = getTimeToDie("target")
	local deadtar = UnitIsDeadOrGhost("target")
	local attacktar = canAttack("player", "target")
	local falling = getFallTime()
	local swimming = IsSwimming()
	local travel = UnitBuffID("player", trf)
	local flight = UnitBuffID("player", flf)
	local stag = hasGlyph(114338)
	local rejRemain = getBuffRemain("player", rej)
	local siBuff = UnitBuffID("player",si)
	local tacBuff = UnitBuffID("player",tac)
	local siCharge = getCharges(si)
	local sbCooldown = getSpellCD(sb)
	local mbCooldown = getSpellCD(mb)
  local srRemain = getBuffRemain("player",svr)
  local fonCooldown = getSpellCD(fon)
  local fonCharge = getCharges(fon)
  local fonRecharge = getRecharge(fon)
  local berserk = UnitBuffID("player",berg)
  local vicious = getBuffRemain("player",148903)
  local restlessagi = getBuffRemain("player",146310)
  local thbRemain = getDebuffRemain("target",thb,"player")
  local thbDuration = getDebuffDuration("target",thb,"player")
  local docBuff = UnitBuffID("player",145162)
  local lacStacks = getDebuffStacks("target",lac)
  local lacTime = (3 - lacStacks) * GCD --(3-dot.lacerate.stack)*gcd
  function BossDummyG()
  	if isBoss("target") or isDummy("target") then
  		return true;
  	else
  		return false;
  	end
  end
	------------------------------------------------------------------------------------------------------
	-- Food/Invis Check ----------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------
	if canRun() ~= true or UnitInVehicle("Player") then
		return false;
	end
	if IsMounted("player") then
		return false;
	end
	------------------------------------------------------------------------------------------------------
	-- Pause ---------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------
	if isChecked("Pause Toggle") and SpecificToggle("Pause Toggle") == true then
		ChatOverlay("|cffFF0000BadBoy Paused", 0); return;
	end
	------------------------------------------------------------------------------------------------------
	-- Spell Queue ---------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------
	if _Queues == nil then
	 _Queues = {
			[ty]  = false,
			[mb] = false,
			[uv] = false,
	 }
	end
	------------------------------------------------------------------------------------------------------
	-- Input / Keys --------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------
 --  if isChecked("HeroicLeapKey") and SpecificToggle("HeroicLeapKey") == true then
 --    if not IsMouselooking() then
 --        CastSpellByName(GetSpellInfo(6544))
 --        if SpellIsTargeting() then
 --            CameraOrSelectOrMoveStart() CameraOrSelectOrMoveStop()
 --            return true;
 --        end
 --    end
	-- end
	-- if isChecked("MockingBannerKey") and SpecificToggle("MockingBannerKey") == true then
 --    if not IsMouselooking() then
 --        CastSpellByName(GetSpellInfo(114192))
 --        if SpellIsTargeting() then
 --            CameraOrSelectOrMoveStart() CameraOrSelectOrMoveStop()
 --            return true;
 --        end
 --    end
	-- end

	------------------------------------------------------------------------------------------------------
	-- Out of Combat -------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------
	if not isInCombat("player") then
		-- Mark of the Wild
		if isChecked("Mark Of The Wild") == true and canCast(1126,false,false) and (lastMotw == nil or lastMotw <= GetTime() - 5) then
			for i = 1, #nNova do
		  		if isPlayer(nNova[i].unit) == true and not isBuffed(nNova[i].unit,{115921,20217,1126,90363}) and UnitInRange(nNova[i].unit) then
		  			if castSpell("player",1126,true) then lastMotw = GetTime(); return; end
				end
			end
		end
	end -- Out of Combat end
	------------------------------------------------------------------------------------------------------
	-- In Combat -----------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------
	-- if pause() ~= true and isInCombat("player") and canAttack("target","player") and not UnitIsDeadOrGhost("target") then
	if isInCombat("player") then
	------------------------------------------------------------------------------------------------------
	-- Dummy Test ----------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------
		if isChecked("DPS Testing") then
			if UnitExists("target") then
				if getCombatTime() >= (tonumber(getValue("DPS Testing"))*60) and isDummy() then
					StopAttack()
					ClearTarget()
					print(tonumber(getValue("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
				end
			end
		end
	------------------------------------------------------------------------------------------------------
	-- Queued Spells -------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------
		if _Queues[ty] == true then
			if castSpell("target",ty,false,false) then
				return;
			end
		end
		if _Queues[mb] == true then
			if castSpell("target",mb,false,false) then
				return;
			end
		end
		if _Queues[uv] == true then
			if not IsMouselooking() then
          CastSpellByName(GetSpellInfo(102793))
          if SpellIsTargeting() then
              CameraOrSelectOrMoveStart() CameraOrSelectOrMoveStop()
              return true;
          end
      end
		end
	------------------------------------------------------------------------------------------------------
	-- Do everytime --------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------
	--SD / FR Mode
	if BadBoy_data['Defensive'] == 1 then
		if castSpell("player",sd) then
			return;
		end
	end
	if BadBoy_data['Defensive'] == 2 then
		if getPower("player") >= 60 then
			if getHP("player") < 75 then
				if castSpell("player",fr) then
					return;
				end
			end
		end
	end
	------------------------------------------------------------------------------------------------------
	-- Defensive Cooldowns -------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------
		-- Healthstone
		if isChecked("Healthstone") == true then
			if getHP("player") <= getValue("Healthstone") then
				if canUse(5512) then
					UseItemByName(tostring(select(1,GetItemInfo(5512))))
				end
			end
		end
		--Survival Instincts
		if isChecked("Survival Instincts") == true then
			if getHP("player") <= getValue("Survival Instincts") then
				if castSpell("player",si) then
					return;
				end
			end
		end
		-- actions+=/barkskin
			if isChecked("Barkskin") == true then
				if getHP("player") <= getValue("Barkskin") then
					if castSpell("player",bar) then
						return;
					end
				end
			end
		-- actions+=/cenarion_ward
		if getTalent(2,3) then
			if getValue("CenWard") == 2 then
	      if castSpell(nNova[1].unit,102351,true,false,false) then return; end
	    end
	    if getValue("CenWard") == 1 then
	        if castSpell("player",102351,true,false,false) then return; end
	    end
		end
		-- actions+=/renewal,if=health.pct<30
		if isChecked("Renewal") == true then
			if getTalent(2,2) then
				if getHP("player") <= getValue("Renewal") then
					if castSpell("player",_Renewal) then
						return;
					end
				end
			end
		end
		-- actions+=/heart_of_the_wild
		if getTalent(7,1) then
			if BossDummyG() == true then
				if isChecked("useHotW") then
					if getHP("player") < getValue("useHotW") then
						if castSpell("player",howg) then
							return;
						end
					end
				end
			end
		end
		-- actions+=/rejuvenation,if=!ticking&buff.heart_of_the_wild.up
		if getTalent(7,1) then
			if UnitBuffID("player",howg) then
				if not UnitBuffID("player",rej) then
					if castSpell("player",rej) then
						return;
					end
				end
			end
		end
		-- actions+=/natures_vigil
		if getTalent(6,3) then
			if BossDummyG() == true then
				if isChecked("useNVigil") then
					if castSpell("player",nv) then
						return;
					end
				end
			end
		end
	------------------------------------------------------------------------------------------------------
	-- Offensive Cooldowns -------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------
		-- actions+=/berserking
		if isChecked("useBerserk") then
			if BossDummyG() == true then
				if castSpell("player",berg) then
					return;
				end
			end
		end
		-- actions+=/incarnation
		if getTalent(4,2) then
			if BossDummyG() == true then
				if isChecked("useIncarnation") then
					if castSpell("player",incg) then
						return;
					end
				end
			end
		end
	------------------------------------------------------------------------------------------------------
	-- Single Target -------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------
		if chumiiuseAoE() == false then
			-- actions+=/maul,if=buff.tooth_and_claw.react&incoming_damage_1s&rage>=80
			if tacBuff then
				if getPower("player") > 80 then
					if castSpell("target",ml,false,false) then
						return;
					end
				end
			end
			-- actions+=/healing_touch,if=buff.dream_of_cenarius.react&health.pct<30
			if getTalent(6,2) and isChecked("DoCHT")then
				if docBuff then
					if getValue("DoCHT") == 2 then
			      if castSpell(nNova[1].unit,ht,true,false,false) then return; end
			    end
			    if getValue("DoCHT") == 1 then
			        if castSpell("player",ht,true,false,false) then return; end
			    end
			  end
			end
			-- actions+=/pulverize,if=buff.pulverize.remains<0.5
			if getTalent(8,2) then
				if getBuffRemain("player",pulv) < 0.5 then
					if castSpell("target",pulv,false,false) then
						return;
					end
				end
			end
			-- actions+=/lacerate,if=talent.pulverize.enabled&buff.pulverize.remains<=(3-dot.lacerate.stack)*gcd
			if getTalent(8,2) then
				if getDebuffRemain("player",pulv) <= lacTime then
					if castSpell("target",lac,false,false) then
						return;
					end
				end
			end
			--Lacerate 3 Stacks
			if getDebuffStacks("target",lac) <= 2 then
				if castSpell("target",lac,false,false) then
					return;
				end
			end
			-- actions+=/mangle,if=buff.son_of_ursoc.down
			if not UnitBuffID("player",incg) then
				if castSpell("target",mgl,false,false) then
					return;
				end
			end
			-- actions+=/thrash_bear,if=!ticking
			if getDebuffRemain("target",thb) < 4 then
				if castSpell("target",thb,true,false) then
					return;
				end
			end
			-- actions+=/mangle
			if castSpell("target",mgl,false,false) then
				return;
			end
			-- actions+=/Lacerate
			if castSpell("target",lac,false,false) then
				return;
			end
		end -- singletarget end
	------------------------------------------------------------------------------------------------------
	-- Multi Target --------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------
		if chumiiuseAoE() == true then
			--Mangle on CD
			if castSpell("target",mgl,false,false) then
				return;
			end
			--Maul with Tooth and Claw proc
			if tacBuff then
				if castSpell("target",ml,false,false) then
					return;
				end
			end
			--Trash
			if castSpell("target",thb,true) then
				return;
			end
		end
	------------------------------------------------------------------------------------------------------
	end -- In Combat end
end