local _, br = ...
-- if shouldStopCasting(12345) then
function br.shouldStopCasting(Spell)
	-- if we are on a boss fight
	if br.GetUnitExists("boss1") then
		-- Locally  casting informations
		local Boss1Cast,Boss1CastEnd,PlayerCastEnd,StopCasting
		local MySpellCastTime
		-- Set Spell Cast Time
		if br._G.GetSpellInfo(Spell) ~= nil then
			MySpellCastTime = (br._G.GetTime()*1000) + select(4,br._G.GetSpellInfo(Spell))
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
		if br._G.UnitCastingInfo("boss1") then
			Boss1Cast,_,_,_,Boss1CastEnd = br._G.UnitCastingInfo("boss1")
		elseif br._G.UnitChannelInfo("boss1") then
			Boss1Cast,_,_,_,Boss1CastEnd = br._G.UnitChannelInfo("boss1")
		else
			return false
		end
		if br._G.UnitCastingInfo("player") then
			PlayerCastEnd = select(5,br._G.UnitCastingInfo("player"))
		elseif br._G.UnitChannelInfo("player") then
			PlayerCastEnd = select(5,br._G.UnitChannelInfo("player"))
		else
			PlayerCastEnd = MySpellCastTime
		end
		for i = 1,#ShouldContinue do
			if br.UnitBuffID("player",ShouldContinue[i])
				and (select(6,br.UnitBuffID("player",ShouldContinue[i]))*1000)+50 > Boss1CastEnd then
				br.ChatOverlay("\124cFFFFFFFFStopper Safety Found")
				return false
			end
		end
		if not br._G.UnitCastingInfo("player") and not br._G.UnitChannelInfo("player") and MySpellCastTime and br.SetStopTime
			and MySpellCastTime > Boss1CastEnd then
			br.ChatOverlay("\124cFFD93B3BStop for "..Boss1Cast)
			return true
		end
		for j = 1,#ShouldStop do
			if Boss1Cast == select(1,br._G.GetSpellInfo(ShouldStop[j])) then
				br.SetStopTime = Boss1CastEnd
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
function br.betterStopCasting(Spell)
	local spellCastLengt = select(4,br._G.GetSpellInfo(Spell)) or 0
	local MySpellCastTime = (br._G.GetTime()*1000) + spellCastLengt
	if br.shouldStopTime and br.shouldStopTime <= MySpellCastTime and not br.canContinue() then
		return true
	end
end
br.stopCasting = {
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
function br.canContinue()
	for i = 1, #br.stopCasting.shouldContinue do
		if br.UnitBuffID("player", br.stopCasting.shouldContinue[i]) then
			return true
		end
	end
end
