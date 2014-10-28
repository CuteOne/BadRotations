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
			CreateNewWrap(thisConfig,"--- Toggles");

			--[[Pause Toggle]]
			CreateNewCheck(thisConfig,"Pause Toggle");
			CreateNewDrop(thisConfig,"Pause Toggle", 3, "Toggle2")
			CreateNewText(thisConfig,"Pause Toggle");

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

	function ArcaneMageConfig()
		if currentConfig ~= "Arcane ragnar" then
			ClearConfig();
			thisConfig = 0;
			--[[Title]]
			CreateNewTitle(thisConfig,"Arcane |cffFF0000ragnar");

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

			CreateNewCheck(thisConfig,"Arcane Power");
			CreateNewText(thisConfig,"Arcane Power");

			CreateNewCheck(thisConfig,"Racial");
			CreateNewText(thisConfig,"Racial");

			if isKnown(ColdSnap) then
				CreateNewCheck(thisConfig,"Cold Snap");
				CreateNewText(thisConfig,"Cold Snap");
			end

			-- Wrapper -----------------------------------------
			CreateNewWrap(thisConfig,"--- Defensives ---");

			if isKnown(Evanesce) then
				CreateNewCheck(thisConfig,"Evanesce");
				CreateNewBox(thisConfig, "Evanesce", 0, 100  , 5, 30, "|cffFFBB00Under what |cff69ccf0%HP|cffFFBB00 cast |cff69ccf0Evanesce.");
				CreateNewText(thisConfig,"Evanesce");
			end

			-- Wrapper -----------------------------------------
			CreateNewWrap(thisConfig,"--- Rotation ---");

			CreateNewBox(thisConfig, "ArcaneBlast (x4)", 80, 100  , 1, 93, "|cffFFBB00Under what |cff69ccf0%Mana|cffFFBB00 dont cast |cff69ccf0Arcane Blast at 4 stacks.");
			CreateNewText(thisConfig,"ArcaneBlast (x4)");

			CreateNewCheck(thisConfig,"Burn Mana", "Do not enable on Dummy. Not yet tested in raid (LVL90)");
			CreateNewText(thisConfig,"Burn Mana");



			--[[General Configs]]
			CreateGeneralsConfig();


			WrapsManager();
		end
	end
end