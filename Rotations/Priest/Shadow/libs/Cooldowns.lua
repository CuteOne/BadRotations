if select(3, UnitClass("player")) == 5 and GetSpecialization()==3 then

	--[[ Shadow Cooldowns ]]
	function ShadowCooldowns(options)
		-- MB on CD
		if options.buttons.Cooldowns == 2 and getTalent(7,1) then
			if castSpell("target",MB,false,false) then return; end
		end

		--if getBuffRemain("player",InsanityBuff)<=0 then

			-- Trinket 1
			if options.isChecked.Trinket1 and options.buttons.Cooldowns == 2 and canTrinket(13) then
				RunMacroText("/use 13")
			end

			-- Trinket 2
			if options.isChecked.Trinket2 and options.buttons.Cooldowns == 2 and canTrinket(14) then
				RunMacroText("/use 14")
			end

			-- -- Halo
			-- if isKnown(Halo) and options.buttons.Halo == 2 then
			-- 	if getDistance("player","target")<=30 and getDistance("player","target")>=17 then
			-- 		if castSpell("player",Halo,true,false) then return; end
			-- 	end
			-- end

			-- -- Mindbender
			-- if isKnown(Mindbender) and options.buttons.Cooldowns == 2 and options.isChecked.Mindbender then
			-- 	if castSpell("target",Mindbender) then return; end
			-- end

			-- -- Shadowfiend
			-- if isKnown(SF) and options.buttons.Cooldowns == 2 and options.isChecked.Shadowfiend then
			-- 	if castSpell("target",SF,true,false) then return; end
			-- end

			-- -- Power Infusion
			-- if isKnown(PI) and options.buttons.Cooldowns == 2 and isChecked("Power Infusion") then
			-- 	if castSpell("player",PI) then return; end
			-- end

			-- Berserking (Troll Racial)
			--if not UnitBuffID("player",176875) then
			if isKnown(Berserking) and options.buttons.Cooldowns == 2 and options.isChecked.Berserking then
				if castSpell("player",Berserking,true,false) then return end
			end
			--end
		--end
	end -- Shadow Cooldowns

	--[[ Shadow Cooldowns Small ]]
	function ShadowCooldownsSmall(options)
		-- Halo
		if isKnown(Halo) and options.buttons.Halo == 2 then
			if getDistance("player","target")<=30 and getDistance("player","target")>=17 then
				if castSpell("player",Halo,true,false) then return end
			end
		end

		-- Cascade
		if isKnown(Cascade) and options.buttons.Halo == 2 then
			if getDistance("player","target")>=28 and getDistance("player","target")<=40 then
				if castSpell("target",Cascade,true,false) then return end
			end
		end

		if isBoss() and options.isChecked.isBoss
		or not options.isChecked.isBoss then
			-- Mindbender
			if isKnown(Mindbender) and options.buttons.Cooldowns == 2 and options.isChecked.Mindbender then
				if castSpell("target",Mindbender) then return end
			end

			-- Shadowfiend
			if isKnown(SF) and options.buttons.Cooldowns == 2 and options.isChecked.Shadowfiend then
				if castSpell("target",SF) then return end
			end
		end
	end -- Cooldowns Small end

end