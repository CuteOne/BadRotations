-- if shouldStopCasting(12345) then
function shouldStopCasting(Spell)
	-- if we are on a boss fight
	if GetUnitExists("boss1") then
		-- Locally  casting informations
		local Boss1Cast,Boss1CastEnd,PlayerCastEnd,StopCasting = Boss1Cast,Boss1CastEnd,PlayerCastEnd,false
		local MySpellCastTime
		-- Set Spell Cast Time
		if GetSpellInfo(Spell) ~= nil then
			MySpellCastTime = (GetTime()*1000) + select(4,GetSpellInfo(Spell))
		else
			return false
		end
		-- Spells which make us immune (buff)
		local ShouldContinue = {
			1022,-- Hand of Protection
			31821,-- Devotion
			104773,-- Unending Resolve
		}
		-- Spells that are dangerous (boss cast)
		local ShouldStop = {
			137457,-- Piercing Roar(Oondasta)
			138763,-- Interrupting Jolt(Dark Animus)
			143343,-- Deafening Screech(Thok)
			158093,-- Interrupting Shout (Twin Ogrons:Pol)
			160838,-- Disrupting Roar (Hans'gar and Franzok)
		}
		-- find casting informations
		if UnitCastingInfo("boss1") then
			Boss1Cast,_,_,_,Boss1CastEnd = UnitCastingInfo("boss1")
		elseif UnitChannelInfo("boss1") then
			Boss1Cast,_,_,_,Boss1CastEnd = UnitChannelInfo("boss1")
		else
			return false
		end
		if UnitCastingInfo("player") then
			PlayerCastEnd = select(5,UnitCastingInfo("player"))
		elseif UnitChannelInfo("player") then
			PlayerCastEnd = select(5,UnitChannelInfo("player"))
		else
			PlayerCastEnd = MySpellCastTime
		end
		for i = 1,#ShouldContinue do
			if UnitBuffID("player",ShouldContinue[i])
				and (select(6,UnitBuffID("player",ShouldContinue[i]))*1000)+50 > Boss1CastEnd then
				ChatOverlay("\124cFFFFFFFFStopper Safety Found")
				return false
			end
		end
		if not UnitCastingInfo("player") and not UnitChannelInfo("player") and MySpellCastTime and SetStopTime
			and MySpellCastTime > Boss1CastEnd then
			ChatOverlay("\124cFFD93B3BStop for "..Boss1Cast)
			return true
		end
		for j = 1,#ShouldStop do
			if Boss1Cast == select(1,GetSpellInfo(ShouldStop[j])) then
				SetStopTime = Boss1CastEnd
				if PlayerCastEnd ~= nil then
					if Boss1CastEnd < PlayerCastEnd then
						StopCasting = true
					end
				end
			end
		end
		return StopCasting
	end
end
function betterStopCasting(Spell)
	local spellCastLengt = select(4,GetSpellInfo(Spell)) or 0
	local MySpellCastTime = (GetTime()*1000) + spellCastLengt
	if shouldStopTime and shouldStopTime <= MySpellCastTime and not canContinue() then
		return true
	end
end
stopCasting = {
	shouldContinue = {
		[1022] = "Melee" , -- Hand of Protection
		[31821] = "All",-- Devotion
		[104773] = "All",-- Unending Resolve
	},
	shouldStop = {
		[137457] = "Melee",-- Piercing Roar(Oondasta)
		[138763] = "Spell",-- Interrupting Jolt(Dark Animus)
		[160838] = "Spell",-- Disrupting Roar (Hans'gar and Franzok)
		[143343] = "Melee",-- Deafening Screech(Thok)
		[19750] = "Spell" -- Flash heal(Test)
	}
}
function canContinue()
	for i = 1, #stopCasting.shouldContinue do
		if UnitBuffID("player", stopCasting.shouldContinue[i]) then
			return true
		end
	end
end
