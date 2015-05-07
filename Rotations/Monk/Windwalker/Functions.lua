if select(3,UnitClass("player")) == 10 then
	function MonkWwFunctions()
		-- we want to build core only once
		if core == nil then
			
			-- Build core
			local wwCore = {
				profile = "Windwalker",
				-- player stats
				buff = { },
				cd = { },
				charges = { },
				channel = { },
				glyph = { },
				health = 100,
				chi = 0,
				chiMax = 0,
				energyTimeToMax = 0,
				inCombat = false,
				melee5Yards = 0,
				melee8Yards = 0,
				melee10Yards = 0,
				melee12Yards = 0,
				mode = { },
				recharge = { },
				stacks = { },
				talent = { },
				units = { },
				spell = {
					blackoutKick               =   100784,  --Blackout Kick
					chiBrew                    =   115399,  --Chi Brew
					chiBurst					=	123986,	--Chi Burst
					chiExplosion 				=	152174,	--Chi Explosion
					chiWave                    =   115098,  --Chi Wave
					cracklingJadeLightning     =   117952,  --Crackling Jade Lightning
					dampenHarm                 =   122278,  --Dampen Harm
					diffuseMagic				=	122783,	--Diffuse Magic
					disable                    =   116095,  --Disable
					detox                      =   115450,  --Detox
					energizingBrew             =   115288,  --Energizing Brew
					expelHarm                  =   115072,  --Expel Harm
					fistsOfFury                =   113656,  --Fists of Fury
					flyingSerpentKick          =   101545,  --Flying Serpent Kick
					flyingSerpentKickEnd       =   115057,  --Flying Serpent Kick End
					fortifyingBrew             =   115203,  --Fortifying Brew
					hurricaneStrike			=	152175,	--Hurricane Strike
					invokeXuen                 =   123904,  --Invoke Xuen
					jab                        =   108557,  --Jab
					legSweep                   =   119381,  --Leg Sweep
					legacyOfTheWhiteTiger      =   116781,  --Legacy of the White Tiger
					nimbleBrew                 =   137562,  --Nimble Brew
					paralysis                  =   115078,  --Paralysis
					provoke                    =   115546,  --Provoke
					quakingPalm                =   107079,  --Quaking Palm
					risingSunKick             =   107428,  --Raising Sun Kick
					resuscitate                =   115178,  --Resuscitate
					rushingJadeWind			=	116847,	--Rushing Jade Wind
					serenity 					=	152173,	--Serenity
					spinningCraneKick          =   101546,  --Spinning Crane Kick
					stanceOfTheFierceTiger     =   103985,  --Stance of the Fierce Tiger
					stormEarthFire				=	137639,	--Storm, Earth, and Fire
					stormEarthFireDebuff       =   138130,  --Storm, Earth, and Fire
					spearHandStrike            =   116705,  --Spear Hand Strike
					surgingMist				=	116694,	--Surging Mist
					tigereyeBrew				=	116740,	--Tigereye Brew Damage
					tigereyeBrewStacks	        =   125195,  --Tigereye Brew Stacks
					tigersLust					=	116841,	--Tiger's Lust
					tigerPalm                  =   100787,  --Tiger Palm
					touchOfDeath               =   115080,  --Touch of Death
					touchOfKarma               =   122470,  --Touch of Karma
					zenMeditation				=	115176,	--Zen Meditation
					zenPilgramage              =   126892,  --Zen Pilgramage
					zenSphere                  =   124081,  --Zen Sphere
					deathNote                  =   121125, --Tracking Touch of Death Availability
					tigerPower                 =   125359, --Tiger Power
					comboBreakerTigerPalm      =   118864, --Combo Breaker: Tiger Palm
					comboBreakerBlackoutKick   =   116768, --Combo Breaker: Blackout Kick
					comboBreakerChiExplosion	=	159407, --Combo Breaker: Chi Explosion
					zenSphereBuff              =   124081, --Zen Sphere Buff
					disableDebuff              =   116706, --Disable (root)
				}
			}
		

			-- Global
			core = wwCore

			-- localise commonly used functions
			local getHP,getChi,getChiMax,hasGlyph,UnitPower,UnitPowerMax,getBuffRemain,getBuffStacks = getHP,getChi,getChiMax,hasGlyph,UnitPower,UnitPowerMax,getBuffRemain,getBuffStacks
			local UnitBuffID,IsSpellOverlayed,getSpellCD,getEnemies = UnitBuffID,IsSpellOverlayed,getSpellCD,getEnemies
			local player,BadBoy_data,GetShapeshiftForm,dynamicTarget = "player",BadBoy_data,GetShapeshiftForm,dynamicTarget
			local GetSpellCooldown,select,getValue,isChecked,castInterrupt = GetSpellCooldown,select,getValue,isChecked,castInterrupt
			local isSelected,UnitExists,isDummy,isMoving,castSpell,castGround = isSelected,UnitExists,isDummy,isMoving,castSpell,castGround
			local getGround,canCast,isKnown,enemiesTable,sp = getGround,canCast,isKnown,enemiesTable,core.spells
			local UnitHealth,print,UnitHealthMax,getCharges = UnitHealth,print,UnitHealthMax,getCharges
			local canTrinket,useItem,GetInventoryItemID,UnitSpellHaste = canTrinket,useItem,GetInventoryItemID,UnitSpellHaste
			local getPower,getRegen,getRecharge,GetInventorySlotInfo,GetItemInfo = getPower,getRegen,getRecharge,GetInventorySlotInfo,GetItemInfo

			-- no external access after here
			setfenv(1,wwCore)

			-- Refresh out of combat
			function wwCore:ooc()
				-- Talents (refresh ooc)
				self.talent.chiWave = isKnown(self.spell.chiWave)
				self.talent.zenSphere = isKnown(self.spell.zenSphere)
				self.talent.chiBurst = isKnown(self.spell.chiBurst)
				self.talent.serenity = isKnown(self.spell.serenity)
				self.talent.chiBrew = isKnown(self.spell.chiBrew)
				self.talent.chiExplosion = isKnown(self.spell.chiExplosion)
				self.talent.hurricaneStrike = isKnown(self.spell.hurricaneStrike)
				self.talent.rushingJadeWind = isKnown(self.spell.rushingJadeWind)
				self.talent.powerStrikes = isKnown(121817)

				--if getTalent(1,1) then
				--	self.spell.roll = 121827 --Roll w/ Celerity Talent
				--else
				--	self.spell.roll = 109132  --Roll
				--end


				-- GET Jab SpellID
				local itemId = GetInventoryItemID(player,select(1,GetInventorySlotInfo("MainHandSlot")))
				local _, _, _, _, _, _, SubType, _ = GetItemInfo(itemId)

				-- Jab IDS: Staff 	- 108557,
				--			Axe 	- 115687,
				--			Mace 	- 115693,
				--			Sword 	- 115695,
				--			Polearm	- 115698
				if SubType == "Staves" then
					self.spell.jab = 108557
				elseif SubType == "One-Handed Axes" or sSubType == "Two-Handed Axes" then
					self.spell.jab = 115687
				elseif SubType == "One-Handed Maces" or sSubType == "Two-Handed Maces" then
					self.spell.jab = 115693
				elseif SubType == "One-Handed Swords" or sSubType == "Two-Handed Swords" then
					self.spell.jab = 115695
				elseif SubType == "Polearms" then
					self.spell.jab = 115698
				end

				-- Glyph (refresh ooc)
				self.glyph.touchOfDeath = hasGlyph(1014)

				self.inCombat = false
			end

			-- this will be used to make the core refresh itself
			function wwCore:update()
				-- player stats
				self.health = getHP(player)
				self.chi = getChi(player)
				self.chiMax = getChiMax(player)

				-- Buffs
				--self.buff. = getBuffRemain(player,self.spell.)
				self.buff.comboBreakerBlackoutKick = getBuffRemain(player,self.spell.comboBreakerBlackoutKick)
				self.buff.comboBreakerChiExplosion = getBuffRemain(player,self.spell.comboBreakerChiExplosion)
				self.buff.comboBreakerTigerPalm = getBuffRemain(player,self.spell.comboBreakerTigerPalm)
				self.buff.energizingBrew = getBuffRemain(player,self.spell.energizingBrew)
				self.buff.serenity = getBuffRemain(player,self.spell.serenity)
				self.buff.tigereyeBrew = getBuffRemain(player,self.spell.tigereyeBrew)
				self.buff.tigereyeBrewStacks = getBuffRemain(player,self.spell.tigereyeBrewStacks)
				self.buff.tigerPower = getBuffRemain(player,self.spell.tigerPower)
				self.buff.zenSphere = getBuffRemain(player,self.spell.zenSphere)

				-- Buff Stacks
				self.stacks.tigereyeBrewStacks = getBuffStacks(player,self.spell.tigereyeBrewStacks)
				self.stacks.stormEarthFire = getBuffStacks(player,self.spell.stormEarthFire)

				-- Buff Charges
				self.charges.chiBrew = getCharges(self.spell.chiBrew)

				-- Buff Recharge
				self.recharge.chiBrew = getRecharge(self.spell.chiBrew)


				-- Cooldowns
				-- self.cd. = getSpellCD(self.spell.)
				self.cd.fistsOfFury = getSpellCD(self.spell.fistsOfFury)
				self.cd.hurricaneStrike = getSpellCD(self.spell.hurricaneStrike)
				self.cd.touchOfDeath = getSpellCD(self.spell.touchOfDeath)
				self.cd.serenity = getSpellCD(self.spell.serenity)
				self.cd.risingSunKick = getSpellCD(self.spell.risingSunKick)
				self.cd.invokeXuen = getSpellCD(self.spell.invokeXuen)

				-- Channel Time
				self.channel.fistsOfFury = 4-(4*UnitSpellHaste(player)/100)
				self.channel.hurricaneStrike = 2-(2*UnitSpellHaste(player)/100)

				self.energyTimeToMax = (UnitPowerMax(player)-UnitPower(player)) / (10*(1+(UnitSpellHaste(player)/100)))
				

				-- Global Cooldown = 1.5 / ((Spell Haste Percentage / 100) + 1)
				--local gcd = (1.5 / ((UnitSpellHaste(player)/100)+1))
				--if gcd < 1 then
				--	self.cd.globalCooldown = 1
				--else
				--	self.cd.globalCooldown = gcd
				--end
				
				self.inCombat = true

				-- Units
				self.melee5Yards = #getEnemies(player,5)
				self.melee8Yards = #getEnemies(player,8)
				self.melee10Yards = #getEnemies(player,10)
				self.melee12Yards = #getEnemies(player,12) 

				-- Modes
				self.mode.aoe = BadBoy_data["AoE"]
				self.mode.cooldowns = BadBoy_data["Cooldowns"]
				self.mode.defensive = BadBoy_data["Defensive"]
				self.mode.healing = BadBoy_data["Healing"]

				-- dynamic units
				self.units.dyn5 = dynamicTarget(5,true)

				self.units.dyn8AoE = dynamicTarget(8,false)
				self.units.dyn8 = dynamicTarget(8,true)

				self.units.dyn10 = dynamicTarget(10,true)

				self.units.dyn12 = dynamicTarget(12,true)
				self.units.dyn12AoE = dynamicTarget(12,false)

				self.units.dyn25 = dynamicTarget(25,true)
				self.units.dyn25AoE = dynamicTarget(25,false)

				self.units.dyn30 = dynamicTarget(30,true)
				self.units.dyn40 = dynamicTarget(40,true)
				self.units.dyn40AoE = dynamicTarget(40,false)
				-- 

			end

			function wwCore:castBlackoutKick()
				return castSpell(self.units.dyn5,self.spell.blackoutKick,false,false) == true or false
			end

			function wwCore:castChiBrew()
				return castSpell(player,self.spell.chiBrew,true,false) == true or false
			end

			function wwCore:castChiBurst()
				return castSpell(self.units.dyn40,self.spell.chiBurst,false,false) == true or false
			end

			function wwCore:castChiExplosion()
				return castSpell(self.units.dyn30,self.spell.chiExplosion,false,false) == true or false
			end

			function wwCore:castChiWave()
				return castSpell(self.units.dyn25AoE,self.spell.chiWave,true,false) == true or false
			end

			function wwCore:castCracklingJadeLightning()
				return castSpell(self.units.dyn40,self.spell.cracklingJadeLightning,false,false) == true or false
			end

			function wwCore:castEnergizingBrew()
				return castSpell(player,self.spell.energizingBrew,true,false) == true or false
			end

			function wwCore:castExpelHarm()
				return castSpell(player,self.spell.expelHarm,true,false) == true or false
			end

			-- TODO: Glyph range extend
			function wwCore:castFistsOfFury()
				return castSpell(self.units.dyn5,self.spell.fistsOfFury,false,false) == true or false
			end

			-- Flying Serpent Kick

			-- Fortifying Brew
			function wwCore:castFortifyingBrew()
				return castSpell(player,self.spell.fortifyingBrew,true,false) == true or false
			end

			function wwCore:castHurricaneStrike()
				return castSpell(self.units.dyn12AoE,self.spell.hurricaneStrike,true,false) == true or false
			end

			function wwCore:castInvokeXuen()
				-- TODO: Cooldown Toggle
				return castSpell(self.units.dyn40,self.spell.invokeXuen,true,false) == true or false
			end

			function wwCore:castJab()
				return castSpell(self.units.dyn5,self.spell.jab,false,false) == true or false
			end

			-- Nimble Brew

			-- Paralysis

			-- Resuscitate

			function wwCore:castRisingSunKick()
				return castSpell(self.units.dyn5,self.spell.risingSunKick,false,false) == true or false
			end

			-- Roll

			function wwCore:castRushingJadeWind() -- 8y
				return castSpell(player,self.spell.rushingJadeWind,true,false) == true or false
			end

			function wwCore:castSerenity()
				return castSpell(player,self.spell.serenity,true,false) == true or false
			end

			-- Spear Hand Strike

			function wwCore:castSpinningCraneKick() -- 8y
				return castSpell(player,self.spell.spinningCraneKick,true,false) == true or false
			end

			function wwCore:castStormEarthFire()
				return castSpell(self.units.dyn40AoE,self.spell.stormEarthFire,true,false) == true or false
			end

			function wwCore:castSurgingMist()
				return castSpell(player,self.spell.surgingMist,true,false) == true or false
			end

			function wwCore:castTigerPalm()
				return castSpell(self.units.dyn5,self.spell.tigerPalm,false,false) == true or false
			end

			function wwCore:castTigereyeBrew()
				return castSpell(player,self.spell.tigereyeBrew,true,false) == true or false
			end

			function wwCore:castTouchOfDeath()
				return castSpell(self.units.dyn5,self.spell.touchOfDeath,true,false) == true or false
			end

			function wwCore:castTouchOfKarma() -- TODO: range glyph, 25y
				return castSpell(self.units.dyn5,self.spell.touchOfKarma,true,false) == true or false
			end

			function wwCore:castZenSphere()
				return castSpell(player,self.spell.zenSphere,true,false) == true or false
			end

			--function wwCore:castSPELL()
			--	return castSpell(self.units.dyn5,self.spell.,true,false) == true or false
			--end

		end
	end
end
