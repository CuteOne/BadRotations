if select(3, UnitClass("player")) == 11 then
	function MoonkinConfig()
		if currentConfig ~= "boomkin ragnar" then
			ClearConfig()
			thisConfig = 0

			CreateNewTitle(thisConfig,"boomkin |cffBA55D3by ragnar");

			-- Wrapper -----------------------------------------
			--CreateNewWrap(thisConfig,"|cffBA55D3Offensive")

			-- General Configs ---------------------------------
			CreateGeneralsConfig()
			WrapsManager()
		end
	end
end