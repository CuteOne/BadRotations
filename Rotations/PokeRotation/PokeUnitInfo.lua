

function pokeTimer()
	-- In Battle timer
	if inBattle then
		if inBattleTimer == 0 then 
			inBattleTimer = GetTime()
		end
	elseif inBattleTimer ~= 0 then
		ChatOverlay("\124cFF9999FFBattle Ended "..GetBattleTime().." Min. "..select(2,GetBattleTime()).." Secs.")
		inBattleTimer = 0
	end
	-- Out of Battle timer
	if not inBattle then
		if outOfBattleTimer == 0 then 
			outOfBattleTimer = GetTime()
		end
	elseif outOfBattleTimer ~= 0 then
		outOfBattleTimer = 0
	end
end