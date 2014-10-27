if select(3, UnitClass("player")) == 8 then

--- Mage ClassColor = |cff69ccf0

	function FrostMageConfig()
		if currentConfig ~= "Frost ragnar" then
			ClearConfig();
			thisConfig = 0;
			--[[Title]]
			CreateNewTitle(thisConfig,"Frost |cffFF0000ragnar");

			-- Wrapper -----------------------------------------
			CreateNewWrap(thisConfig,"--- Buffs ---");

			--[[Arcane Brilliance]]
			CreateNewCheck(thisConfig,"Arcane Brilliance");
			CreateNewText(thisConfig,"Arcane Brilliance");

			-- Wrapper -----------------------------------------
			CreateNewWrap(thisConfig,"--- Cooldowns ---");

			if isKnown(MirrorImage) then
				CreateNewCheck(thisConfig,"Mirror Image");
				CreateNewText(thisConfig,"Mirror Image");
			end

			CreateNewCheck(thisConfig,"Icy Veins");
			CreateNewText(thisConfig,"Icy Veins");

			CreateNewCheck(thisConfig,"Racial");
			CreateNewText(thisConfig,"Racial");

			-- Wrapper -----------------------------------------
			CreateNewWrap(thisConfig,"--- Defensives ---");



			-- Wrapper -----------------------------------------
			-- CreateNewWrap(thisConfig,"--- Toggles");

			-- --[[Pause Toggle]]
			-- CreateNewCheck(thisConfig,"Pause Toggle");
			-- CreateNewDrop(thisConfig,"Pause Toggle", 3, "Toggle2")
			-- CreateNewText(thisConfig,"Pause Toggle");

			-- --[[Focus Toggle]]
			-- CreateNewCheck(thisConfig,"Focus Toggle");
			-- CreateNewDrop(thisConfig,"Focus Toggle", 2, "Toggle2")
			-- CreateNewText(thisConfig,"Focus Toggle");

						-- Wrapper -----------------------------------------
			CreateNewWrap(thisConfig,"--- Rotation ---");

			-- Rotation
			CreateNewDrop(thisConfig, "RotationSelect", 1, "Choose Rotation to use.", "|cffFFBB00IcyVeins", "|cff0077FFSimCraft");
			CreateNewText(thisConfig, "Rotation Priority");

			--[[General Configs]]
			CreateGeneralsConfig();


			WrapsManager();
		end
	end
end