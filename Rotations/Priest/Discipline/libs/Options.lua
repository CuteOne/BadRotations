if select(3, UnitClass("player")) == 5 then

	function DisciplineConfig()
		if currentConfig ~= "Discipline ragnar" then
			ClearConfig()
			thisConfig = 0
			-- Title
			CreateNewTitle(thisConfig,"semi auto disc |cffBA55D3by ragnar")

			-- Wrapper -----------------------------------------
			CreateNewWrap(thisConfig,"|cffBA55D3Offensive")

			-- PWS
			CreateNewCheck(thisConfig,"PW:Shield","max PWS count in raid")
			CreateNewBox(thisConfig,"PW:Shield", 1, 40, 1, 5, "Set to max count for PWS in raid")
			CreateNewText(thisConfig,"PW:Shield")

			-- heal
			CreateNewCheck(thisConfig,"Heal","use heal")
			CreateNewBox(thisConfig,"Heal", 1, 40, 1, 4, "Heal under %HP")
			CreateNewText(thisConfig,"Heal")

			-- flash heal
			CreateNewCheck(thisConfig,"Flash Heal","use Flash Heal")
			CreateNewBox(thisConfig,"Flash Heal", 1, 100, 2, 30, "Flash Heal under %HP")
			CreateNewText(thisConfig,"Flash Heal")

			-- penance
			--CreateNewCheck(thisConfig,"Penance","use Penance")
			--CreateNewBox(thisConfig,"Penance", 1, 40, 1, 4, "")
			--CreateNewText(thisConfig,"Penance")

			-- Wrapper -----------------------------------------
			CreateNewWrap(thisConfig,"|cffBA55D3Utilities")

			-- Pause Toggle
			CreateNewCheck(thisConfig,"Pause Toggle")
			CreateNewDrop(thisConfig,"Pause Toggle", 10, "Toggle2")
			CreateNewText(thisConfig,"Pause Toggle")

			--Power Word: Fortitude
			CreateNewCheck(thisConfig,"PW:Fortitude")
			CreateNewText(thisConfig,"PW:Fortitude")



			-- General Configs ---------------------------------
			CreateGeneralsConfig()
			WrapsManager()
		end
	end
end