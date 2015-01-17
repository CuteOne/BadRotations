if select(3, UnitClass("player")) == 8 then

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
		if currentConfig ~= "Frost Ragnar&Gabbz" then
			ClearConfig()
			thisConfig = 0
			--[[Title]]
			 titleOp("Frost |cffFF0000Ragnar & Gabbz")

			-- Wrapper -----------------------------------------
			textOp(" ")
            wrapOp("--- Buffs ---")

				--[[Arcane Brilliance]]
				checkOp("Arcane Brilliance")
				textOp("Arcane Brilliance")

			-- Wrapper -----------------------------------------
			textOp(" ")
            wrapOp("--- Cooldowns ---")

				if isKnown(MirrorImage) then
					checkOp("Mirror Image")
					textOp("Mirror Image")
				end

				checkOp("Icy Veins")
				textOp("Icy Veins")

				checkOp("Racial")
				textOp("Racial")

			-- Wrapper -----------------------------------------
			textOp(" ")
            wrapOp("--- Pet ---")
            	checkOp("Auto Summon Pet")
				textOp("Auto Summon Pet")

			-- Wrapper -----------------------------------------
			textOp(" ")
            wrapOp("--- Defensives ---")



			-- Wrapper -----------------------------------------
			textOp(" ")
            wrapOp("--- Toggles")

			
			-- Wrapper -----------------------------------------
			textOp(" ")
            wrapOp("--- Rotation ---")

				-- Rotation
				dropOp("RotationSelect", 1, "Choose Rotation to use.", "|cffFFBB00IcyVeins", "|cff0077FFSimCraft")
				textOp("Rotation Priority")

			--[[General Configs]]
			CreateGeneralsConfig()

			WrapsManager()
		end
	end
end