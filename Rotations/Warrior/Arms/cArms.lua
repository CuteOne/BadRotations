--- Arms Class
-- Inherit from ../cCharacter.lua and cWarrior.lua
-- All Warrior specs inherit from cWarrior.lua
-- credits also go out to chumii the warrior master
if select(3, UnitClass("player")) == 1 and GetSpecialization() == 1 then
cArms = {}

-- Create Arms Warrior
function cArms:new()
	local self = cWarrior:new("Arms")

	local player = "player"
	
	-- __      __                              _   _______    _     _           
	-- \ \    / /                             | | |__   __|  | |   | |          
	--  \ \  / /_ _ _ __ ___    __ _ _ __   __| |    | | __ _| |__ | | ___  ___ 
	--   \ \/ / _` | '__/ __|  / _` | '_ \ / _` |    | |/ _` | '_ \| |/ _ \/ __|
	--    \  / (_| | |  \__ \ | (_| | | | | (_| |    | | (_| | |_) | |  __/\__ \
	--     \/ \__,_|_|  |___/  \__,_|_| |_|\__,_|    |_|\__,_|_.__/|_|\___||___/
	self.enemies = {
		active_enemies_30,
		active_enemies_40,
	}
	--   _____            _ _     
	--  / ____|          | | |    
	-- | (___  _ __   ___| | |___ 
	--  \___ \| '_ \ / _ \ | / __|
	--  ____) | |_) |  __/ | \__ \
	-- |_____/| .__/ \___|_|_|___/
	--        | |                 
	--        |_|                 
	self.armsSpell = {
		anger_management = 152278,
		avatar = 107574,
		battle_shout = 6673,
		battle_stance = 2457,
		berserker_rage = 18499,
		bladestorm = 46924,
		bloodbath = 12292,
		charge = 100,
		colossus_smash = 167105,
		commanding_shout = 469,
		defensive_stance = 71,
		die_by_the_sword = 118038,
		double_time = 103827,
		dragon_roar = 118000,
		enraged_regeneration = 55694,
		execute = 163201,
		hamstring = 1715,
		heroic_leap = 6544,
		heroic_throw = 57755,
		impending_victory = 103840,
		intervene = 3411,
		intimidating_shout = 0,
		juggernaut = 103826,
		mass_spell_reflection = 114028,
		mortal_strike = 12294,
		pummel = 6552,
		rallying_cry = 97462,
		ravager = 152277,
		recklessness = 1719,
		rend = 772,
		safeguard = 114029,
		second_wind = 29838,
		shield_barrier = 174926,
		shockwave = 46968,
		siegebreaker = 176289,
		slam = 1464,
		spell_reflection = 23920,
		storm_bolt = 107570,
		sudden_death = 29725,
		sudden_death_proc = 52437,
		sweeping_strikes = 12328,
		taste_for_blood = 56636,
		taunt = 355,
		thunder_clap = 6343,
		victory_rush = 34428,
		vigilance = 114030,
		warbringer = 103828,
		whirlwind = 1680,
	}
	-- Merge all spell tables into self.spell
	self.spell = {}
	self.spell = mergeSpellTables(self.spell, self.characterSpell, self.warriorSpell, self.armsSpell)

	--  _    _           _       _       
	-- | |  | |         | |     | |      
	-- | |  | |_ __   __| | __ _| |_ ___ 
	-- | |  | | '_ \ / _` |/ _` | __/ _ \
	-- | |__| | |_) | (_| | (_| | ||  __/
	--  \____/| .__/ \__,_|\__,_|\__\___|
	--        | |                        
	--        |_|                        
	function self.update()
		self.classUpdate()
		self.getBuffs()
		self.getDebuffs()
		self.getCooldowns()
		self.getDynamicUnits()
		self.getEnemies()
		self.getOptions()
		self.getRotation()

		-- stance
		self.battlestance 	= GetShapeshiftForm() == 1
		self.defstance 		= GetShapeshiftForm() == 2

		-- rage
		self.rage = UnitPower("player",1)
		self.rageMax = UnitPowerMax("player",1)
		self.rageDeficit = self.rageMax - self.rage

		self.BossDetection()
		
		-- Casting and GCD check
		if select(2,GetSpellCooldown(61304))>0 then
			return false
		end
		
		
		-- Start selected rotation
		self:startRotation()
	end

	--   ____   ____   _____   _    _           _       _       
	--  / __ \ / __ \ / ____| | |  | |         | |     | |      
	-- | |  | | |  | | |      | |  | |_ __   __| | __ _| |_ ___ 
	-- | |  | | |  | | |      | |  | | '_ \ / _` |/ _` | __/ _ \
	-- | |__| | |__| | |____  | |__| | |_) | (_| | (_| | ||  __/
	--  \____/ \____/ \_____|  \____/| .__/ \__,_|\__,_|\__\___|
	--                               | |                        
	--                               |_|                        
	function self.updateOOC()
		-- Call classUpdateOOC()
		self.classUpdateOOC()

		self.getGlyphs()
		self.getTalents()

		self.BossDetection()

		-- Setup Queues
		if _Queues == nil or #_Queues <= 0 then
			_Queues = {
				[self.spell.bladestorm] 	= false,
				[self.spell.shockwave]		= false,
				[self.spell.dragon_roar]	= false,
			}
		end
	end

	--  ____                      _      _            _   _             
	-- |  _ \                    | |    | |          | | (_)            
	-- | |_) | ___  ___ ___    __| | ___| |_ ___  ___| |_ _  ___  _ __  
	-- |  _ < / _ \/ __/ __|  / _` |/ _ \ __/ _ \/ __| __| |/ _ \| '_ \ 
	-- | |_) | (_) \__ \__ \ | (_| |  __/ ||  __/ (__| |_| | (_) | | | |
	-- |____/ \___/|___/___/  \__,_|\___|\__\___|\___|\__|_|\___/|_| |_|
	function self.BossDetection()
		-- not infight: reset current boss
		if UnitAffectingCombat("player")==false then
			currentBoss = "noBoss"
		end
		-- infight: detect boss
		if UnitAffectingCombat("player") then
			if currentBoss=="noBoss" or currentBoss==nil then
				if UnitName("boss1")==nil then 
					currentBoss="noBoss"
				else currentBoss=UnitName("boss1") 
				end
			end
		end
	end

	--   ____        _   _                   _        _     _      
	--  / __ \      | | (_)                 | |      | |   | |     
	-- | |  | |_ __ | |_ _  ___  _ __  ___  | |_ __ _| |__ | | ___ 
	-- | |  | | '_ \| __| |/ _ \| '_ \/ __| | __/ _` | '_ \| |/ _ \
	-- | |__| | |_) | |_| | (_) | | | \__ \ | || (_| | |_) | |  __/
	--  \____/| .__/ \__|_|\___/|_| |_|___/  \__\__,_|_.__/|_|\___|
	--        | |                                                  
	--        |_|                                                  
	function self.getOptions()
		local getValue,isChecked = getValue,isChecked

		self.options.rotation 							= {}
		self.options.rotation.HeroicLeap				= isChecked("Heroic Leap")
		self.options.rotation.Ravager 					= isChecked("Ravager")
		self.options.rotation.maxRend 					= getValue("")
		
		self.options.cooldowns 							= {}
		self.options.cooldowns.Recklessness 			= isChecked("Recklessness")
		self.options.cooldowns.Avatar 					= isChecked("Avatar")
		self.options.cooldowns.Racial 					= isChecked("")
		self.options.cooldowns.Stormbolt 				= isChecked("Storm Bolt")
		self.options.cooldowns.Trinket 					= isChecked("Use Trinket")
		
		self.options.defensive 								= {}
		self.options.defensive.Dbts 						= isChecked("Die by the Sword")
		self.options.defensive.DbtsValue					= getValue("Die by the Sword")
		self.options.defensive.RallyingCry 					= isChecked("Rallying Cry")
		self.options.defensive.RallyingCryValue				= getValue("Rallying Cry")
		self.options.defensive.EnragedRegeneration 			= isChecked("Enraged Regeneration")
		self.options.defensive.EnragedRegenerationValue		= getValue("Enraged Regeneration")
		self.options.defensive.ImpendingVictory 			= isChecked("Impending Victory")
		self.options.defensive.ImpendingVictoryValue		= getValue("Impending Victory")
		self.options.defensive.Vigilance 					= isChecked("Vigilance on Focus")
		self.options.defensive.VigilanceValue				= getValue("Vigilance on Focus")
		self.options.defensive.DefStance 					= isChecked("")
		self.options.defensive.DefStanceValue				= getValue("")
		self.options.defensive.HealingTonic 				= isChecked("Healing Tonic")
		self.options.defensive.HealingTonicValue			= getValue("Healing Tonic")

		self.options.bosshelper 						= {}
		-- self.options.bosshelper.Guise					= isChecked("")
		-- self.options.bosshelper.Mass_Dispel				= isChecked("")
		-- self.options.bosshelper.Dispel					= isChecked("")
		-- self.options.bosshelper.Silence 				= isChecked("")
		-- self.options.bosshelper.Target 					= isChecked("")
		-- self.options.bosshelper.Gorefiend				= isChecked("")

		self.options.utilities 							= {}
		--self.options.utilities.pause 					= isChecked("Pause Toggle")
    end

	function self.createOptions()
		if self.rotation == 1 then
			WarriorArmsConfig()
		end
	end

	--  ____         __  __     
	-- |  _ \       / _|/ _|    
	-- | |_) |_   _| |_| |_ ___ 
	-- |  _ <| | | |  _|  _/ __|
	-- | |_) | |_| | | | | \__ \
	-- |____/ \__,_|_| |_| |___/
	function self.getBuffs()
		local UnitBuffID = UnitBuffID
		
		self.buff.avatar 			= UnitBuffID("player",self.spell.avatar) ~=nil or false
		self.buff.bladestorm 		= UnitBuffID("player",self.spell.bladestorm) ~=nil or false
		self.buff.bloodbath 		= UnitBuffID("player",self.spell.bloodbath) ~=nil or false
		self.buff.recklessness 		= UnitBuffID("player",self.spell.recklessness) ~=nil or false
		self.buff.sudden_death 		= UnitBuffID("player",self.spell.sudden_death_proc) ~=nil or false
		self.buff.sweeping_strikes 	= UnitBuffID("player",self.spell.sweeping_strikes) ~= nil or false

		self.getBuffsRemain()
	end

	function self.getBuffsRemain()
		local getBuffRemain = getBuffRemain
		self.buff.remain 		= {}
		-- self.buff.remain.a 		= getBuffRemain("player",1) or 0
		-- self.buff.remain.b 		= getBuffRemain("player",1) or 0
		-- self.buff.remain.c 		= getBuffRemain("player",1) or 0
		-- self.buff.remain.d 		= getBuffRemain("player",1) or 0
		-- self.buff.remain.e 		= getBuffRemain("player",1) or 0
	end

	--  _____       _            __  __     
	-- |  __ \     | |          / _|/ _|    
	-- | |  | | ___| |__  _   _| |_| |_ ___ 
	-- | |  | |/ _ \ '_ \| | | |  _|  _/ __|
	-- | |__| |  __/ |_) | |_| | | | | \__ \
	-- |_____/ \___|_.__/ \__,_|_| |_| |___/
	function self.getDebuffs()
		local UnitDebuffID = UnitDebuffID

		self.debuff.colossus_smash 	= UnitDebuffID(self.units.dyn5,self.spell.colossus_smash,"player")~=nil or false
		self.debuff.rend 			= UnitDebuffID(self.units.dyn5,self.spell.rend,"player")~=nil or false

		self.getDebuffsRemain()
	end
	function self.getDebuffsRemain()
		local getDebuffRemain = getDebuffRemain

		self.debuff.remain 					= {}
		self.debuff.remain.colossus_smash 	= getDebuffRemain(self.units.dyn5,self.spell.colossus_smash,"player") or 0
		self.debuff.remain.rend 			= getDebuffRemain(self.units.dyn5,self.spell.rend,"player") or 0
	end

	--   _____            _     _                         
	--  / ____|          | |   | |                        
	-- | |     ___   ___ | | __| | _____      ___ __  ___ 
	-- | |    / _ \ / _ \| |/ _` |/ _ \ \ /\ / / '_ \/ __|
	-- | |___| (_) | (_) | | (_| | (_) \ V  V /| | | \__ \
	--  \_____\___/ \___/|_|\__,_|\___/ \_/\_/ |_| |_|___/
	function self.getCooldowns()
		local getSpellCD = getSpellCD
		self.cd.colossus_smash  		= getSpellCD(self.spell.colossus_smash)
		self.cd.mortal_strike 			= getSpellCD(self.spell.mortal_strike)
		self.cd.storm_bolt 				= getSpellCD(self.spell.storm_bolt)
		self.cd.sweeping_strikes 		= getSpellCD(self.spell.sweeping_strikes)
		self.cd.execute 				= getSpellCD(self.spell.execute)
	end

	--   _____ _             _         
	--  / ____| |           | |        
	-- | |  __| |_   _ _ __ | |__  ___ 
	-- | | |_ | | | | | '_ \| '_ \/ __|
	-- | |__| | | |_| | |_) | | | \__ \
	--  \_____|_|\__, | .__/|_| |_|___/
	--            __/ | |              
	--           |___/|_|              
	function self.getGlyphs()
		local hasGlyph = hasGlyph
		self.glyph.resonating_power		= hasGlyph(507)
	end

	--  _______    _            _       
	-- |__   __|  | |          | |      
	--    | | __ _| | ___ _ __ | |_ ___ 
	--    | |/ _` | |/ _ \ '_ \| __/ __|
	--    | | (_| | |  __/ | | | |_\__ \
	--    |_|\__,_|_|\___|_| |_|\__|___/
	function self.getTalents()
		local isKnown = isKnown
		self.talent.juggernaut 				= getTalent(1,1)
		self.talent.double_time 			= getTalent(1,2)
		self.talent.warbringer 				= getTalent(1,3)
		self.talent.enraged_regeneration 	= getTalent(2,1)
		self.talent.second_wind 			= getTalent(2,2)
		self.talent.impending_victory 		= getTalent(2,3)
		self.talent.taste_for_blood 		= getTalent(3,1)
		self.talent.sudden_death 			= getTalent(3,2)
		self.talent.slam 					= getTalent(3,3)
		self.talent.storm_bolt 				= getTalent(4,1)
		self.talent.shockwave 				= getTalent(4,2)
		self.talent.dragon_roar 			= getTalent(4,3)
		self.talent.mass_spell_reflection 	= getTalent(5,1)
		self.talent.safeguard 				= getTalent(5,2)
		self.talent.vigilance 				= getTalent(5,3)
		self.talent.avatar 					= getTalent(6,1)
		self.talent.bloodbath 				= getTalent(6,2)
		self.talent.bladestorm 				= getTalent(6,3)
		self.talent.anger_management 		= getTalent(7,1)
		self.talent.ravager 				= getTalent(7,2)
		self.talent.siegebreaker 			= getTalent(7,3)
	end

	--   _____      _      _____      _           _           _    _____ _____  
	--  / ____|    | |    / ____|    | |         | |         | |  / ____|  __ \ 
	-- | |  __  ___| |_  | (___   ___| | ___  ___| |_ ___  __| | | |    | |__) |
	-- | | |_ |/ _ \ __|  \___ \ / _ \ |/ _ \/ __| __/ _ \/ _` | | |    |  _  / 
	-- | |__| |  __/ |_   ____) |  __/ |  __/ (__| ||  __/ (_| | | |____| | \ \ 
	--  \_____|\___|\__| |_____/ \___|_|\___|\___|\__\___|\__,_|  \_____|_|  \_\
	function self.getRotation()
		self.rotation = bb.selectedProfile
		
		if bb.rotation_changed then
			--self.createToggles()
			self.createOptions()
			
			bb.rotation_changed = false
		end
	end

	--  _____                              _        _    _       _ _       
	-- |  __ \                            (_)      | |  | |     (_) |      
	-- | |  | |_   _ _ __   __ _ _ __ ___  _  ___  | |  | |_ __  _| |_ ___ 
	-- | |  | | | | | '_ \ / _` | '_ ` _ \| |/ __| | |  | | '_ \| | __/ __|
	-- | |__| | |_| | | | | (_| | | | | | | | (__  | |__| | | | | | |_\__ \
	-- |_____/ \__, |_| |_|\__,_|_| |_| |_|_|\___|  \____/|_| |_|_|\__|___/
	--          __/ |                                                      
	--         |___/                                                       
	function self.getDynamicUnits()
	end

	--  ______                      _           
	-- |  ____|                    (_)          
	-- | |__   _ __   ___ _ __ ___  _  ___  ___ 
	-- |  __| | '_ \ / _ \ '_ ` _ \| |/ _ \/ __|
	-- | |____| | | |  __/ | | | | | |  __/\__ \
	-- |______|_| |_|\___|_| |_| |_|_|\___||___/
	function self.getEnemies()
		local getEnemies = getEnemies

		self.enemies.yards5  = #getEnemies("player",5) -- meleeEnemies
		self.enemies.yards8  = #getEnemies("player",8) -- whirlwind
		self.enemies.yards10 = #getEnemies("player",10) -- ()
		self.enemies.yards15 = #getEnemies("player",15) -- Holy Prism on friendly AoE

		self.aroundTarget7Yards = #getEnemies(self.units.dyn5,7) -- (Hammer of the Righteous)

		self.unitInFront = getFacing("player",self.units.dyn5) == true or false
	end

	--  _    _ _   _ _ _ _   _           
	-- | |  | | | (_) (_) | (_)          
	-- | |  | | |_ _| |_| |_ _  ___  ___ 
	-- | |  | | __| | | | __| |/ _ \/ __|
	-- | |__| | |_| | | | |_| |  __/\__ \
	--  \____/ \__|_|_|_|\__|_|\___||___/
	-- single/AoE mode
	function self.useAoE()
		if self.mode.aoe==2
		or self.mode.aoe==1 and self.enemies.yards8>1 then
			return true
		end
		return false
	end
	function self.useCD()
		-- auto
		if self.mode.cooldowns==1 and (isBoss("boss1") or isBoss("target"))
		or self.mode.cooldowns==2 then
			return true
		end
		return false
	end

	--  _____     _______  
	-- |  __ \   |__   __| 
	-- | |  | | ___ | |___ 
	-- | |  | |/ _ \| / __|
	-- | |__| | (_) | \__ \
	-- |_____/ \___/|_|___/ 
	-- rend
	function self.getRendRunning()
		local counter = 0
		-- iterate units for rend
		for i=1,#enemiesTable do
			local thisUnit = enemiesTable[i].unit
			-- increase counter for each SWP
			if (UnitAffectingCombat(thisUnit) or isDummy(thisUnit)) and UnitDebuffID(thisUnit,self.spell.rend,"player") then
				counter=counter+1
			end
		end
		-- return counter
		return counter
	end
	-- SWP
	function self.Rend_allowed(targetUnit)
		if targetUnit == nil or not UnitExists(targetUnit) then 
			return true 
		end
		
		local thisUnit = targetUnit
		local thisUnitID = getUnitID(thisUnit)
		local Blacklist_UnitID = {
		-- HM: Highmaul
			79956,		-- Ko'ragh: Volatile Anomaly
			78077,		-- Mar'gok: Volatile Anomaly
		-- BRF: Blackrock Foundry
			77128,		-- Darmac: Pack Beast
			77394,		-- Thogar: Iron Raider (Train Ads)
			77893,		-- Kromog: Grasping Earth (Hands)
			77665,		-- Blackhand: Iron Soldier
		-- HFC: Hellfire Citadel
			90114,		-- Hellfire Assault: damn small ads
			--94326,		-- Iron Reaver: Reactive Bomb
			90513,		-- Kilrogg: Fel Blood Globule
			96077,		-- Kilrogg: Fel Blood Globule
			90477,		-- Kilrogg: Blood Globule
			93288,		-- Gorefiend: Corrupted Players
			95101,		-- Socrethar: Phase1 Voracious Soulstalker
			92919,		-- Zakuun: Mythic dat orb
			--92208,		-- Archimonde: Doomfire Spirit
		}
		local Blacklist_BuffID = {
		-- blackrock foundry
			155176, 	-- Blast Furnace: Primal Elementalist: http://www.wowhead.com/spell=155176/damage-shield
			176141, 	-- Blast Furnace: Slag Elemental: http://www.wowhead.com/spell=176141/hardened-slag
		}

		-- check for buffs
		for i = 1, #Blacklist_BuffID do
			if getBuffRemain(thisUnit,Blacklist_BuffID[i]) > 0 or getDebuffRemain(thisUnit,Blacklist_BuffID[i]) > 0 then return false end
		end
		-- check for unit id
		for i = 1, #Blacklist_UnitID do
			if thisUnitID == Blacklist_UnitID[i] then return false end
		end
		return true
	end

	--  _____       _        _   _                _____ _             _   
	-- |  __ \     | |      | | (_)              / ____| |           | |  
	-- | |__) |___ | |_ __ _| |_ _  ___  _ __   | (___ | |_ __ _ _ __| |_ 
	-- |  _  // _ \| __/ _` | __| |/ _ \| '_ \   \___ \| __/ _` | '__| __|
	-- | | \ \ (_) | || (_| | |_| | (_) | | | |  ____) | || (_| | |  | |_ 
	-- |_|  \_\___/ \__\__,_|\__|_|\___/|_| |_| |_____/ \__\__,_|_|   \__|
	function self.startRotation()
		if self.inCombat then
			if self.rotation == 1 then
				self:Simcraft()
			-- put different rotations below; dont forget to setup your rota in options
			else
				ChatOverlay("ERROR: NO ROTATION", 2000)
			end
		end
	end

	--   _____            _ _     
	--  / ____|          | | |    
	-- | (___  _ __   ___| | |___ 
	--  \___ \| '_ \ / _ \ | / __|
	--  ____) | |_) |  __/ | \__ \
	-- |_____/| .__/ \___|_|_|___/
	--        | |                 
	--        |_|                 
	-- avatar
	function self.castAvatar()
		return castSpell("player",self.spell.avatar,true,false) == true or false
	end
	-- battle_shout
	function self.castBattleShout()
		return castSpell("player",self.spell.battle_shout,true,false) == true or false
	end
	-- battle_stance
	function self.castBattleStance()
		return castSpell("player",self.spell.battle_stance,true,false) == true or false
	end
	-- berserker_rage
	function self.castBerserkerRage()
		return castSpell("player",self.spell.berserker_rage,true,false) == true or false
	end
	-- bladestorm
	function self.castBladestorm()
		return castSpell("player",self.spell.bladestorm,true,false) == true or false
	end
	-- bloodbath
	function self.castBloodbath()
		return castSpell("player",self.spell.bloodbath,true,false) == true or false
	end
	-- charge
	function self.castCharge()
		return castSpell(self.units.dyn5,self.spell.charge,false,false) == true or false
	end
	-- colossus_smash
	function self.castColossusSmash()
		return castSpell(self.units.dyn5,self.spell.colossus_smash,false,false) == true or false
	end
	-- commanding_shout
	function self.castCommandingShout()
		return castSpell("player",self.spell.commanding_shout,true,false) == true or false
	end
	-- defensive_stance
	function self.castDefensiveStance()
		return castSpell("player",self.spell.defensive_stance,true,false) == true or false
	end
	-- die_by_the_sword
	function self.castDieByTheSword()
		return castSpell("player",self.spell.die_by_the_sword,true,false) == true or false
	end
	-- dragon_roar
	function self.castDragonRoar()
		return castSpell("player",self.spell.dragon_roar,true,false) == true or false
	end
	-- enraged_regeneration
	function self.castEnragedRegeneration()
		return castSpell("player",self.spell.enraged_regeneration,true,false) == true or false
	end
	-- execute
	function self.castExecute()
		if self.buff.sudden_death then
			return castSpell(self.units.dyn5,self.spell.execute,false,false) == true or false
		end
		if GetObjectExists(self.units.dyn5) then
			local thisUnit = thisTarget
			local range = getDistance("player",thisUnit)
			local hp = getHP(thisUnit)
			if hp<20 and range<5 then
				return castSpell(thisUnit,self.spell.execute,false,false) == true or false
			end
		end
		for i=1,#enemiesTable do
			local thisUnit = enemiesTable[i].unit
			local range = getDistance("player",thisUnit)
			local hp = enemiesTable[i].hp
			if hp<20 and range<5 then
				return castSpell(thisUnit,self.spell.execute,false,false,false,false,false,false,true) == true or false
			end
		end
		return false
	end
	-- hamstring
	function self.castHamstring()
		return castSpell(self.units.dyn5,self.spell.hamstring,false,false) == true or false
	end
	-- heroic_leap

	-- heroic_throw
	function self.castHeroicThrow()
		return castSpell(self.units.dyn5,self.spell.heroic_throw,false,false) == true or false
	end
	-- impending_victory
	function self.castImpendingVictory()
		return castSpell(self.units.dyn5,self.spell.impending_victory,false,false) == true or false
	end
	-- intervene

	-- intimidating_shout

	-- mortal_strike
	function self.castMortalStrike()
		return castSpell(self.units.dyn5,self.spell.mortal_strike,false,false) == true or false
	end
	-- pummel
	function self.castPummel()
		return castSpell(self.units.dyn5,self.spell.pummel,false,false) == true or false
	end
	-- rallying_cry
	function self.castRallyingCry()
		return castSpell("player",self.spell.rallying_cry,true,false) == true or false
	end
	-- ravager

	-- recklessness
	function self.castRecklessness()
		return castSpell("player",self.spell.recklessness,true,false) == true or false
	end
	-- rend
	-- function self.castRendCycle(mode)
	-- 	local thisTarget = self.units.dyn5
	-- 	local rend_remains = self.debuff.remain.rend
	-- 	local colossus_smash_up = self.debuff.colossus_smash
	-- 	local rend_running = 
	-- 	if mode==1 then
	-- 		--target.time_to_die>4&(remains<gcd|(debuff.colossus_smash.down&remains<5.4))
	-- 		if getTTD(thisTarget)>4 or isDummy(thisTarget) then
	-- 			if rend_remains<self.gcd or (not colossus_smash_up and rend_remains<5.4) then
	-- 				return castSpell(thisTarget,self.spell.rend,false,false) == true or false
	-- 			end
	-- 		end
	-- 	elseif mode==2 then
	-- 		-- 	actions.aoe+=/rend,cycle_targets=1,max_cycle_targets=2,if=dot.rend.remains<5.4&target.time_to_die>8&!buff.colossus_smash_up.up&talent.taste_for_blood.enabled

	-- 	elseif mode==3 then
	-- 		-- 	actions.aoe+=/rend,cycle_targets=1,if=dot.rend.remains<5.4&target.time_to_die-remains>18&!buff.colossus_smash_up.up&spell_targets.whirlwind<=8
	-- 	elseif mode==4 then
	-- 		-- 	actions.aoe+=/rend,cycle_targets=1,if=dot.rend.remains<5.4&target.time_to_die>8&!buff.colossus_smash_up.up&spell_targets.whirlwind>=9&rage<50&!talent.taste_for_blood.enabled
	-- 	end
	-- 	return false
	-- end
	function self.castRendOnUnit()
		local thisUnit = self.units.dyn5
		if not isCCed(thisUnit) and self.Rend_allowed(thisUnit) then
			return castSpell(thisUnit,self.spell.rend,false,false) == true or false
		end
		return false
	end
	-- shield_barrier

	-- shieldbreaker
	function self.castSiegebreaker()
		return castSpell(self.units.dyn5,self.spell.siegebreaker,false,false) == true or false
	end
	-- shockwave
	function self.castShockwave()
		return castSpell(self.units.dyn5,self.spell.shockwave,false,false) == true or false
	end
	-- slam
	function self.castSlam()
		return castSpell(self.units.dyn5,self.spell.slam,false,false) == true or false
	end
	-- spell_reflection

	-- storm_bolt
	function self.castStormBolt()
		return castSpell(self.units.dyn5,self.spell.storm_bolt,false,false) == true or false
	end
	-- sweeping_strikes
	function self.castSweepingStrike()
		return castSpell("player",self.spell.sweeping_strikes,true,false) == true or false
	end
	-- taunt

	-- thunder_clap
	function self.castThunderClap()
		return castSpell("player",self.spell.thunder_clap,true,false) == true or false
	end
	-- victory_rush
	function self.castVictoryRush()
		return castSpell("player",self.spell.victory_rush,true,false) == true or false
	end
	-- vigilance
	function self.castVigilanceOn(thisTarget)
		return castSpell(thisTarget,self.spell.vigilance,false,false)== true or false
	end
	-- whirlwind
	function self.castWhirlwind()
		return castSpell("player",self.spell.whirlwind,true,false) == true or false
	end


	-- Create Options
	self.createOptions()
	--self.createToggles()

	-- Return
	return self

	end
end