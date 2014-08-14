if select(3,UnitClass("player")) == 10 then

function BrewmasterMonk()
	--ChatOverlay(getNumEnnemies("player",10))
	if AoEModesLoaded ~= "Brew Monk AoE Modes" then
		MonkBrewConfig();
		MonkBrewToggles();
	end

	-- Locals
	local chi = UnitPower("player", SPELL_POWER_CHI);
	local energy = getPower("player");
	local myHP = getHP("player");

	-- Food/Invis Check
	if canRun() ~= true or UnitInVehicle("Player") then return false; end
	if IsMounted("player") then return false; end

	if UnitAffectingCombat("player") then

		-- Mind Freeze
		--if isChecked("Mind Freeze") == true then
			--if canInterrupt(_MindFreeze, getValue("Mind Freeze")) and getDistance("player","target") <= 4 then
				--castSpell("target",_MindFreeze,false);
			--end
		--end

    	-- Fortifying Brew
    	if isChecked("Fortifying Brew") == true and myHP <= getValue("Fortifying Brew") then
    		if castSpell("player",115203,true) then return; end
    	end

    end

	if isCasting() then return false; end

--[[Buffs:
Maintain these buffs at all times.

Stance: Stance of the Sturdy Ox
Statue: Summon Black Ox Statue

Chi Builders:
Follow this priority to generate Chi.

Keg Smash on cooldown when at < 3 Chi. Applies Weakened Blows.
Expel Harm when you are not at full health.
Jab use to build Chi and prevent Energy capping.
Chi Finishers:
Follow this priority to spend Chi.

Purifying Brew to remove your Stagger DoT when Yellow or Red.
Elusive Brew if > 10 stacks. Delay up to 10-15 sec for anticipated damage.
Guard on cooldown. Delay up to 10-15 sec for anticipated damage.
Blackout Kick as often as possible. Aim for ~80% uptime on Shuffle.
Tiger Palm does not cost Chi, but is used like a finisher (see explanation).
The Brewmaster Monk single target tanking priority involves building and then spending Chi on abilities that improve your damage and survivability. For building Chi, you want to cast Keg Smash on cooldown as long as you have < 3 Chi or if Weakened Blows might drop. Cast Expel Harm if you are below 100% health and remember that you can spam cast Expel Harm if you are 35% health thanks to Desperate Measures. Otherwise, use Jab as your go-to Chi builder.

Spending Chi is a bit more complicated than building Chi. Your first priority is to use Purifying Brew when your Stagger DoT is in its Yellow (moderate damage) or Red (high damage) stages. After this, use Elusive Brew when you have > 10 stacks of Brewing: Elusive Brew to prevent the stacks from capping. This ability may be delayed by 10-15 sec if you are expecting a spike in physical damage. Next, use Guard on cooldown, except when you might need to delay by 10-15 sec to mitigate any spike damage. Cast Blackout Kick as often as possible to activate Shuffle. Generally, you want to obtain an ~80% uptime on Shuffle as any higher uptime reduces how often you can use Guard.

Tiger Palm is a unique ability thanks to Brewmaster Training. For Brewmasters, Tiger Palm has no Chi cost and provides both the Tiger Power and Power Guard buffs. Tiger Power is easy to maintain as you will almost always cast Tiger Palm once every 20 sec, but Power Guard requires some planning. It is ideal to have Power Guard for each Guard. In most situations, you will have a Power Guard in time for each Guard, but if you need to use Guard for a large hit you should make sure to use Tiger Palm just before Guard is required.

Finally, one last ability needs to considered for effective Brewmaster Tanking: Gift of the Ox. This ability places Healing Spheres on the ground that you can move over for a decently sized heal. You should save ~3 spheres at all times and consume other spheres as they appear. Only consume the 3 reserved Spheres when you need a large heal to help recover from a major attack.

AoE Rotation

Dizzying Haze
Breath of Fire
Spinning Crane Kick
AoE tanking is pretty straight forward for Brewmasters. At 2 targets, continue with the single target rotation and switch between the targets as needed to maintain threat. With 3+ targets, maintain the Dizzying Haze debuff that is applied by Keg Smash and the DoT from Breath of Fire. At 10+ targets, spam Spinning Crane Kick to generate Chi and spend the Chi as you normally would. Also, remember to maintain Shuffle with Blackout Kick at all times.

Effective Cooldowns

These effective cooldowns are available if you chose them in your talent build.

Chi Wave Use for self-healing or to help with AoE threat.
Dampen Harm Use often to reduce damage. Line up with spike damage when possible.
These are effective cooldowns to try and incorporate into most all encounters.

Avert Harm Use as needed to reduce raid damage. Stack with other survival cooldowns.
Fortifying Brew Use as needed to mitigate damage or to stay alive during an emergency.
Nimble Brew Use to remove and/or prevent crowd control effects.
Provoke Use on an enemy for a single taunt or on Summon Black Ox Statue for an AoE taunt.
Touch of Death Be a ninja and try to time this when boss health < your health.
Zen Meditation Use proactively to reduce the damage of one large magic attack by 90%.


]]
    -- Stance
	local myStance = GetShapeshiftForm()
    if isChecked("Stance") then
    	if getValue("Stance") == 1 and myStance ~= 1 then
    		if castSpell("player",115069,true) then return; end
    	elseif getValue("Stance") == 2 and myStance ~= 2 then
    		if castSpell("player",103985,true) then return; end
    	end
    end

    -- Legacy of the Emperor
	local lastLegacy;
	if isChecked("Legacy of the Emperor") == true and (lastLegacy == nil or lastLegacy <= GetTime() - 5) then
		for i = 1, #nNova do
	  		if isPlayer(nNova[i].unit) == true and not isBuffed(nNova[i].unit,{115921,20217,1126,90363}) then
	  			if castSpell("player",115921,true) then lastLegacy = GetTime(); return; end
			end 
		end
	end


	if isInCombat("player") and isAlive() and (isEnnemy() or isDummy("target")) then


	    -- Jab
	    if energy >= 40 then
	    	if castSpell("target",115698,false) then return; end
	    end

	    -- Jab
	    if energy >= 40 then
	    	if castSpell("target",115698,false) then return; end
	    end	    

		--ChatOverlay("A L'ATTAQUE");

	end







end

end