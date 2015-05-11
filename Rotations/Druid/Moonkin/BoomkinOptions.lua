if select(3, UnitClass("player")) == 11 then
	function MoonkinConfig()
			
		-- color and wrapper code
		local myColor = "|cffC0C0C0"
		local redColor = "|cffFF0011"
		local whiteColor = "|cffFFFFFF"
		local myClassColor = classColors[select(3,UnitClass("player"))].hex
		local function generateWrapper(wrapName)
			CreateNewWrap(thisConfig,whiteColor.."- "..redColor..wrapName..whiteColor.." -")
		end

		ClearConfig()
		thisConfig = 0
		-- Title
		CreateNewTitle(thisConfig,"boomkin |cffBA55D3by ragnar")

		generateWrapper("General")
			-- Pause Toggle
			CreateNewCheck(thisConfig,"Pause Toggle")
			CreateNewDrop(thisConfig,"Pause Toggle", 3, "Toggle2")
			CreateNewText(thisConfig,"Pause Toggle")

			-- Dummy DPS Test
			CreateNewCheck(thisConfig,"DPS Testing");
			CreateNewBox(thisConfig,"DPS Testing", 1, 15, 1, 5, "Set to desired time for test in minutes. Min: 1 / Max: 15 / Interval: 1");
			CreateNewText(thisConfig,"DPS Testing");





		generateWrapper("Utilities")
		-- General Configs
		CreateGeneralsConfig()
		WrapsManager()

	end
end