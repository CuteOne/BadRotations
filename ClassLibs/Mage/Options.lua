if select(3, UnitClass("player")) == 8 then



	function FrostMageConfig()
		if currentConfig ~= "Frost ragnar" then
			ClearConfig();
			thisConfig = 0;
			--[[Title]]
			CreateNewTitle(thisConfig,"Frost |cffFF0000ragnar");

			-- Wrapper -----------------------------------------
			CreateNewWrap(thisConfig,"== Buffs");

			--[[Arcane Brilliance]]
			CreateNewCheck(thisConfig,"Arcane Brilliance");
			CreateNewText(thisConfig,"Arcane Brilliance");

			-- Wrapper -----------------------------------------
			CreateNewWrap(thisConfig,"== Cooldowns");

			if isKnown(MirrorImage) then
				CreateNewCheck(thisConfig,"Mirror Image");
				CreateNewText(thisConfig,"Mirror Image");
			end

			CreateNewCheck(thisConfig,"Icy Veins");
			CreateNewText(thisConfig,"Icy Veins");

			CreateNewCheck(thisConfig,"Racial");
			CreateNewText(thisConfig,"Racial");



			--[[General Configs]]
			CreateGeneralsConfig();


			WrapsManager();
		end
	end
end