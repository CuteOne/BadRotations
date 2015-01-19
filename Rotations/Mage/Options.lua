if select(3, UnitClass("player")) == 8 then

--- Mage ClassColor = |cff69ccf0
	 function titleOp(string)
        return CreateNewTitle(thisConfig,string)
    end
    function checkOp(string,tip)
        if tip == nil then
            return CreateNewCheck(thisConfig,string)
        else
            return CreateNewCheck(thisConfig,string,tip)
        end
    end
    function textOp(string)
        return CreateNewText(thisConfig,string)
    end
    function wrapOp(string)
        return CreateNewWrap(thisConfig,string)
    end
    function boxOp(string, minnum, maxnum, stepnum, defaultnum, tip)
        if tip == nil then
            return CreateNewBox(thisConfig,string, minnum, maxnum, stepnum, defaultnum)
        else
            return CreateNewBox(thisConfig,string, minnum, maxnum, stepnum, defaultnum, tip)
        end
    end
    function dropOp(string, base, tip1, value1, value2, value3, value4, value5, value6, value7, value8, value9, value10)
        return CreateNewDrop(thisConfig, string, base, tip1, value1, value2, value3, value4, value5, value6, value7, value8, value9, value10)
    end

	function FrostMageConfig()
		if currentConfig ~= "Frost ragnar" then
			ClearConfig()
			thisConfig = 0
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
		if currentConfig ~= "Arcane Ragnar & Gabbz" then
			ClearConfig()
			thisConfig = 0
			--[[Title]]
			 titleOp("Arcane |cffFF0000Ragnar & Gabbz")

			-- Wrapper -----------------------------------------
			wrapOp("--- Buffs ---")

			--[[Arcane Brilliance]]
			checkOp("Arcane Brilliance")
			textOp("Arcane Brilliance")

			-- Wrapper -----------------------------------------
			wrapOp("--- Cooldowns ---")

			if isKnown(MirrorImage) then
				checkOp("Mirror Image")
				textOp("Mirror Image")
			end

			checkOp("Arcane Power")
			textOp("Arcane Power")

			checkOp("Racial")
			textOp("Racial")

			if isKnown(ColdSnap) then
				checkOp("Cold Snap")
				textOp("Cold Snap")
			end

			-- Wrapper -----------------------------------------
			wrapOp("--- Defensives ---")

			if isKnown(Evanesce) then
				CreateNewCheck(thisConfig,"Evanesce");
				boxOp("Evanesce", 0, 100  , 5, 30, "|cffFFBB00Under what |cff69ccf0%HP|cffFFBB00 cast |cff69ccf0Evanesce.")
				textOp("Evanesce")
			end

			-- Healthstone
			checkOp("Healthstone")
			boxOp("Healthstone", 0, 100  , 5, 25, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFHealthstone")
			textOp("Healthstone")

			-- Wrapper -----------------------------------------
			wrapOp("--- Rotation ---")
			checkOp("Arcane Blast")
			boxOp("ArcaneBlast (x4)", 80, 100  , 1, 93, "|cffFFBB00Under what |cff69ccf0%Mana|cffFFBB00 dont cast |cff69ccf0Arcane Blast at 4 stacks.")
			textOp("ArcaneBlast (x4)")

			checkOp("Burn Phase", "Do not enable on Dummy.")
			textOp("Burn Phase")

			--[[General Configs]]
			CreateGeneralsConfig()
			WrapsManager()
		end
	end
end