if select(3, UnitClass("player")) == 5 and GetSpecialization()==3 then

	--[[ Defensives ]]
	function ShadowDefensive(options)
		-- Dispersion
		if isChecked("Dispersion") and (BadBoy_data['Defensive'] == 2) and getHP("player") <= getValue("Dispersion") then
			if castSpell("player",Disp,true,false) then return end
		end

		-- Desperate Prayer
		if isKnown(DesperatePrayer) then
			if isChecked("Desperate Prayer") and (BadBoy_data['Defensive'] == 2) and getHP("player") <= getValue("Desperate Prayer") then
				if castSpell("player",DesperatePrayer,true,false) then return end
			end
		end

		-- Healing Tonic
		if isChecked("Healing Tonic") and getHP("player") <= getValue("Healing Tonic") then
			if canUse(109223) then
				UseItemByName(109223)
			end
		end

		-- Shield
		if isChecked("PW: Shield") and (BadBoy_data['Defensive'] == 2) and getHP("player") <= getValue("PW: Shield") then
			if castSpell("player",PWS,true,false) then return end
		end

		-- Fade (Glyphed)
		if hasGlyph(GlyphOfFade) then
			if isChecked("Fade Glyph") and (BadBoy_data['Defensive'] == 2) and getHP("player") <= getValue("Fade Glyph") then
				if castSpell("player",Fade,true,false) then return end
			end
		end

		-- Fade (Aggro)
		if IsInRaid() ~= false then
			if isChecked("Fade Aggro") and BadBoy_data['Defensive']==2 and getThreat()>=3 then
				--if isChecked("Fade Aggro") and BadBoy_data['Defensive'] == 2 then
				if castSpell("player",Fade,true,false) then return end
			end
		end
	end -- Defensives end
end