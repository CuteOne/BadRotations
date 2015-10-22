if select(2, UnitClass("player")) == "SHAMAN" then
    function cEnhancement:EnhancementCuteOne()
    	-- GroupInfo()
    	KeyToggles()
    --------------
    --- Locals ---
    --------------
        local buff              = self.buff
        local dyn5 				= self.units.dyn5
        local canFlask          = canUse(self.flask.wod.agilityBig)
        local cd                = self.cd
        local charges           = self.charges
        local combatTime        = getCombatTime()
        local debuff            = self.debuff
        local enemies           = self.enemies
        local flaskBuff         = getBuffRemain("player",self.flask.wod.buff.agilityBig) or 0
        local frac 				= self.frac
        local glyph             = self.glyph
        local healthPot         = getHealthPot() or 0
        local inCombat          = self.inCombat
        local inRaid            = select(2,IsInInstance())=="raid"
        local level             = self.level
        local needsHealing 		= needsHealing or 0
        local php               = self.health
        local power             = self.power
        local race              = self.race
        local racial 			= self.getRacial()
        local recharge          = self.recharge
        local regen             = self.powerRegen
        local solo              = select(2,IsInInstance())=="none"
        local t17_2pc           = self.eq.t17_2pc
        local t18_2pc           = self.eq.t18_2pc 
        local t18_4pc           = self.eq.t18_4pc
        local talent            = self.talent
        local thp               = getHP(self.units.dyn5)
        local totem 			= self.totem
        local ttd               = getTimeToDie(self.units.dyn5)
        local ttm               = self.timeToMax
        if t18_4pc then t18_4pcBonus = 1 else t18_4pcBonus = 0 end
    --------------------
    --- Action Lists ---
    --------------------
    -- Action list - Extras
    	function actionList_Extra()
    	-- Earthbind Totem
    		if isChecked("Earthbind Totem") and not talent.earthgrabTotem and not isBoss() and cd.EarthbindTotem==0 then
                for i=1, #getEnemies("player",10) do
                    thisUnit = getEnemies("player",10)[i]
                    if not ObjectIsFacing(thisUnit,"player") and isMoving(thisUnit) then
                    	if self.castEarthbindTotem() then return end
                    end
               	end
            end
        -- Earthgrab Totem
        	if isChecked("Earthgrab Totem") and talent.earthgrabTotem and not isBoss() and cd.EarthgrabTotem==0 then
        		for i=1, #getEnemies("player",10) do
                    thisUnit = getEnemies("player",10)[i]
                    if not ObjectIsFacing(thisUnit,"player") and isMoving(thisUnit) then
                    	if self.castEarthgrabTotem() then return end
                    end
               	end
        	end
        -- Ghost Wolf
        	if isChecked("Ghost Wolf") and isMoving("player") and ((not inCombat) or (inCombat and getDistance("target")>10)) then
        		if self.castGhostWolf() then return end
        	end
        -- Purge
        	if isChecked("Purge") and canDispel("target",self.spell.purge) and not isBoss and ObjectExists("target") then
        		if self.castPurge() then return end
        	end
        -- Spirit Walk
        	if isChecked("Spirit Walk") and hasNoControl(self.spell.spiritWalk) then
        		if self.castSpiritWalk() then return end
        	end
        -- Totemic Recall
        	if not inCombat and totem.exist and not (totem.healingStreamTotem or totem.fireElementalTotem or totem.earthElementalTotem or totem.stormElementalTotem) then
        		if self.castTotemicRecall() then return end
        	end
        -- Tremor Totem
        	if isChecked("Tremor Totem") and cd.tremorTotem==0 then
        		for i=1,#nNova do
        			local thisUnit=nNova[i].unit
        			local thisUnitDist=getDistance(thisUnit)
        			if thisUnitDist<30 and hasNoControl(self.spell.tremorTotem,thisUnit) then
        				if self.castTremorTotem() then return end
        			end
        		end
        	end
        -- Water Walking
        	if isChecked("Water Walking") and not inCombat and IsSwimming() then
        		if self.castWaterWalking() then return end
        	end
    	end -- End Action List - Extra
    -- Action List - Defensive
    	function actionList_Defensive()
    		if useDefensive() then 
		-- Ancestral Guidance
				if isChecked("Ancestral Guidance") then
					if not inCombat and needsHealing>0 then needsHealing=0 end
					for i=1,#nNova do
						local thisUnit = nNova[i].unit
						local thisUnitHP = getHP(thisUnit)
						if thisUnitHP < getOptionValue("Ancestral Guidance") then
							needsHealing = needsHealing+1
						end
					end
					if inCombat and (needsHealing >= 3 or needsHealing==#nNova) then
						if self.castAncestralGuidance() then return end
					end
				end
		-- Ancestral Spirit
				if isChecked("Ancestral Spirit") then
					if getOptionValue("Ancestral Spirit")==1 then
						if self.castAncestralSpirit("target") then return end
					end
					if getOptionValue("Ancestral Spirit")==2 then
						if self.castAncestralSpirit("mouseover") then return end
					end
				end
        -- Astral Shift
		        if isChecked("Astral Shift") and inCombat and not castingUnit("player") and php<=getOptionValue("Astral Shift") then
		          	if self.castAstralShift() then return end
		        end
		-- Capacitor Totem
				if isChecked("Capacitor Totem - Defensive") and inCombat and php<=getOptionValue("Capacitor Totem") and ttd>5 then
					if self.castCapacitorTotem() then return end
				end
		-- Cleanse Spirit
        		if isChecked("Cleanse Spirit") then
			        if getOptionValue("Cleanse Spirit")==1 and canDispel("player",self.spell.cleanseSpirit) then
			          	if self.castCleanseSpirit("player") then return; end
			        end
			        if getOptionValue("Cleanse Spirit")==2 and canDispel("target",self.spell.cleanseSpirit) then
			        	if self.castCleanseSpirit("target") then return end
			        end
			        if getOptionValue("Cleanse Spirit")==3 and canDispel("mouseover",self.spell.cleanseSpirit) then
			          	if self.castCleanseSpirit("mouseover") then return end
			        end
			    end
		-- Earth Elemental Totem
				if isChecked("Earth Elemental Totem") and inCombat and php <= getOptionValue("Earth Elemental Totem") then
					if self.castEarthElementalTotem() then return end
				end
		-- Gift of the Naaru
		        if isChecked("Gift of the Naaru") and php <= getOptionValue("Gift of the Naaru") and self.race=="Draenei" then
		          	if castSpell("player",racial,false,false,false) then return end
		        end
		-- Healing Rain
				if isChecked("Healing Rain") then
					if self.castHealingRain() then return end
				end
		-- Healing Stream Totem
			    if isChecked("Healing Stream Totem") and php < getOptionValue("Healing Stream Totem") and not totem.healingStreamTotem then
			      	if self.castHealingStreamTotem() then return end
			    end
		-- Healing Surge
				if isChecked("Healing Surge") then
					if ((getOptionValue("Healing Surge - Target")==1 and charges.maelstromWeapon>3) or not inCombat) and php < getOptionValue("Healing Surge - Level") then
						if self.castHealingSurge("player") then return end
					end
					if getOptionValue("Healing Surge - Target")==3 and charges.maelstromWeapon>3 and ObjectExists("mouseover") and getHP("mouseover") < getOptionValue("Healing Surge - Level") then
						if self.castHealingSurge("mouseover") then return end
					end
					if getOptionValue("Healing Surge - Target")==2 and charges.maelstromWeapon>3 then
						for i=1,#nNova do
							local thisUnit = nNova[i].unit
							local thisUnitHP = getHP(thisUnit)
							local thisUnitDist = getDistance(thisUnit)
							if thisUnitDist<40 and thisUnitHP < getOptionValue("Healing Surge - Level") then
								if self.castHealingSurge(thisUnit) then return end
							end
						end
					end
				end
		-- lightning Shield
				if not buff.lightningShield then
					if self.castLightningShield() then return end
				end
		-- Shamanistic Rage
		        if isChecked("Shamanistic Rage") and inCombat and php <= getOptionValue("Shamanistic Rage") then
		          	if self.castShamanisticRage() then return end
		        end
    		end -- End Defensive Check
    	end -- End Action List - Defensive
    -- Action List - Interrupts
    	function actionList_Interrupts()
		    if useInterrupts() then
        -- Wind Shear
        		-- wind_shear
	            if isChecked("Wind Shear") then
	                for i=1, #getEnemies("player",25) do
	                    thisUnit = getEnemies("player",25)[i]
	                    if canInterrupt(thisUnit,getOptionValue("InterruptAt")) then
	                        if self.castWindShear(thisUnit) then return end
	                    end
	                end
	            end
	    -- Grounding Totem
	    		-- Grounding Totem
	    		if isChecked("Gounding Totem") then
	    			for i=1, #getEnemies("player",25) do
	    				thisUnit = getEnemies("player",25)[i]
	                    if canInterrupt(thisUnit,getOptionValue("InterruptAt")) then
	                        if self.castGroundingTotem() then return end
	                    end
	                end
	            end
	    -- Capacitor Totem
				if isChecked("Capacitor Totem - Interrupt") and ttd>5 then
					for i=1, #getEnemies("player",8) do
	    				thisUnit = getEnemies("player",8)[i]
	                    if canInterrupt(thisUnit,getOptionValue("InterruptAt")) then
							if self.castCapacitorTotem() then return end
						end
					end
				end
    		end
    	end -- End Action List - Interrupts
    -- Action List - Cooldowns
    	function actionList_Cooldowns()
    		if getDistance(dyn5)<5 then
    	-- Heroism/Bloodlust
	    		-- bloodlust,if=target.health.pct<25|time>0.500
	    		if useCDs() and isChecked("HeroLust") and not raid and (thp<25 or combatTime>0.500) then
	    			if self.castHeroLust() then return end
	    		end
	    -- Legendary Ring
	    		-- use_item,name=maalus_the_blood_drinker
	    		-- TODO
	    -- Potion
	    		-- potion,name=draenic_agility,if=(talent.storm_elemental_totem.enabled&(pet.storm_elemental_totem.remains>=25|(cooldown.storm_elemental_totem.remains>target.time_to_die&pet.fire_elemental_totem.remains>=25)))|(!talent.storm_elemental_totem.enabled&pet.fire_elemental_totem.remains>=25)|target.time_to_die<=30
	    		if useCDs() and canUse(109217) and inRaid and isChecked("Agi-Pot") then
	    			if (talent.stormElementalTotem and (totem.remain.stormElementalTotem>=25 or (cd.stormElementalTotem>ttd and totem.remaim.fireElementalTotem>=25))) or (not talent.stormElementalTotem and totem.remain.fireElementalTotem>=25) or ttd<=30 then
	    				useItem(109217)
	    			end
	    		end
	    -- Racials
	    		-- blood_fury
	    		-- arcane_torrent
	    		-- berserking
	    		if useCDs() and (self.race == "Orc" or self.race == "Troll" or self.race == "Blood Elf") then
	    			if self.castRacial() then return end
	    		end
	    -- Elemental Mastery
	    		-- elemental_mastery
	    		if useCDs() and isChecked("Elemental Mastery") then
	    			if self.castElementalMastery() then return end
	    		end
	    -- Storm Elemental Totem
	    		-- storm_elemental_totem
	    		if useCDs() and isChecked("Storm Elemental Totem") then
	    			if self.castStormElementalTotem() then return end
	    		end
	    -- Fire Elemental Totem
	    		-- fire_elemental_totem
	    		if useCDs() and isChecked("Fire Elemental Totem") then
	    			if self.castFireElementalTotem() then return end
	    			if self.castEarthElementalTotem() then return end
	    		end
	    -- Feral Spirit
	    		-- feral_spirit
	    		if useCDs() and isChecked("Feral Spirit") then
	    			if self.castFeralSpirit() then return end
	    		end
	    -- Liquid Magma
	    		-- liquid_magma,if=pet.searing_totem.remains>10|pet.magma_totem.remains>10|pet.fire_elemental_totem.remains>10
	    		if isChecked("Liquid Magma") and totem.remain.searingTotem>10 or totem.remain.magmaTotem>10 or totem.remain.fireElementalTotem>10 then
	    			if self.castLiquidMagma() then return end
	    		end
	    -- Ancestral Swiftness
	    		-- ancestral_swiftness
	    		if useCDs() and isChecked("Ancestral Swiftness") then
	    			if self.castAncestralSwiftness() then return end
	    		end
	    -- Ascendance
	    		-- ascendance
	    		if useCDs() and isChecked("Ascendance") then
	    			if self.castAscendance() then return end
	    		end
	    -- Touch of the Void
	            if useCDs() and isChecked("Touch of the Void") and getDistance(self.units.dyn5)<5 then
	                if hasEquiped(128318) then
	                    if GetItemCooldown(128318)==0 then
	                        useItem(128318)
	                    end
	                end
	            end
	    -- Trinkets
				if useCDs() and isChecked("Trinkets") then
					if canUse(13) then
						useItem(13)
					end
					if canUse(14) then
						useItem(14)
					end
				end		
	    	end
    	end -- End Action List - Cooldowns
    -- Action List - Pre-Combat
	    function actionList_PreCombat()
	   	-- Flask
	   		-- flask,type=greater_draenic_agility_flask
	   		if isChecked("Agi-Pot") then
                if inRaid and canFlask and flaskBuff==0 and not UnitBuffID("player",176151) then
                    useItem(self.flask.wod.agilityBig)
                    return true
                end
                if flaskBuff==0 then
                    if self.useCrystal() then return end
                end
            end
        -- Food
        	-- food,type=buttered_sturgeon
        -- Lightning Shield
        	-- lightning_shield,if=!buff.lightning_shield.up
        	if not buff.lightningShield then
        		if self.castLightningShield() then return end
		    end
		-- Snapshot Stats
			-- snapshot_stats
		-- Potion
			-- potion,name=draenic_agility
	    end  -- End Action List - Pre-Combat
	-- Action List - Single
		function actionList_Single()
		-- Searing Totem
			-- searing_totem,if=!totem.fire.active
			if (not totem.searingTotem and not totem.fireElementalTotem) or totem.magmaTotem then
				if self.castSearingTotem() then return end
			end
		-- Unleash Elements
			-- unleash_elements,if=talent.unleashed_fury.enabled
			if talent.unleashedFury then
				if self.castUnleashElements() then return end
			end
		-- Elemental Blast
			-- elemental_blast,if=buff.maelstrom_weapon.react>=5+3*set_bonus.tier18_4pc
			if charges.maelstromWeapon>=5+3*t18_4pcBonus then
				if self.castElementalBlast() then return end
			end
		-- Windstrike
			-- windstrike,if=!talent.echo_of_the_elements.enabled|(talent.echo_of_the_elements.enabled&(charges=2|(action.windstrike.charges_fractional>1.75)|(charges=1&buff.ascendance.remains<1.5)))
			if not talent.echoOfTheElements or (talent.echoOfTheElements and (charges.windstrike==2 or (frac.windstrike>1.75) or (charges.windstrike==1 and buff.remain.ascendance<1.5))) then
				if self.castWindstrike() then return end
			end
		-- Lightning Bolt
			-- lightning_bolt,if=buff.maelstrom_weapon.react>=5+3*set_bonus.tier18_4pc
			if charges.maelstromWeapon>=5+3*t18_4pcBonus then
				if self.castLightningBolt() then return end
			end
		-- Stormstrike
			-- stormstrike,if=!talent.echo_of_the_elements.enabled|(talent.echo_of_the_elements.enabled&(charges=2|(action.stormstrike.charges_fractional>1.75)|target.time_to_die<6))
			if not talent.echoOfTheElements or (talent.echoOfTheElements and (charges.stormstrike==2 or (frac.stormstrike>1.75) or ttd<6)) then
				if self.castStormstrike() then return end
			end
		-- Lava Lash
			-- lava_lash,if=!talent.echo_of_the_elements.enabled|(talent.echo_of_the_elements.enabled&(charges=2|(action.lava_lash.charges_fractional>1.8)|target.time_to_die<8))
			if not talent.echoOfTheElements or (talent.echoOfTheElements and (charges.lavaLash==2 or (frac.lavaLash>1.8) or ttd<8)) then
				if self.castLavaLash() then return end
			end
		-- Flame Shock
			-- flame_shock,if=(talent.elemental_fusion.enabled&buff.elemental_fusion.stack=2&buff.unleash_flame.up&dot.flame_shock.remains<16)|(!talent.elemental_fusion.enabled&buff.unleash_flame.up&dot.flame_shock.remains<=9)|!ticking
			if (talent.elementalFusion and charges.elementalFusion==2 and buff.unleashFlame and debuff.remain.flameShock<16) or (not talent.elementalFusion and buff.unleashFlame and debuff.remain.flameShock<=9) or not debuff.flameShock then
				if self.castFlameShock() then return end
			end
		-- Unleash Elements
			-- unleash_elements
			if self.castUnleashElements() then return end
		-- Windstrike
			-- windstrike,if=talent.echo_of_the_elements.enabled
			if talent.echoOfTheElements then
				if self.castWindstrike() then return end
			end
		-- Elemental Blast
			-- elemental_blast,if=(!set_bonus.tier18_4pc&buff.maelstrom_weapon.react>=3)|buff.ancestral_swiftness.up
			if (not t18_4pc and charges.maelstromWeapon>=3) or buff.ancestralSwiftness then
				if self.castElementalBlast() then return end
			end
		-- Lightning Bolt
			-- lightning_bolt,if=(!set_bonus.tier18_4pc&(buff.maelstrom_weapon.react>=3&!buff.ascendance.up))|buff.ancestral_swiftness.up
			if (not t18_4pc and (charges.maelstromWeapon>=3 and not buff.ascendance)) or buff.ancestralSwiftness then
				if self.castLightningBolt() then return end
			end
		-- Lava Lash
			-- lava_lash,if=talent.echo_of_the_elements.enabled
			if talent.echoOfTheElements then
				if self.castLavaLash() then return end
			end
		-- Frost Shock
			-- frost_shock,if=(talent.elemental_fusion.enabled&dot.flame_shock.remains>=16)|!talent.elemental_fusion.enabled
			if (talent.elementalFusion and debuff.remain.flameShock>=16) or not talent.elementalFusion then
				if self.castFrostShock() then return end
			end
		-- Elemental Blast
			-- elemental_blast,if=buff.maelstrom_weapon.react>=1+2*set_bonus.tier18_4pc
			if charges.maelstromWeapon>=1+2*t18_4pcBonus then
				if self.castElementalBlast() then return end
			end
		-- Lightning Bolt
			-- lightning_bolt,if=talent.echo_of_the_elements.enabled&((!set_bonus.tier18_4pc&(buff.maelstrom_weapon.react>=2&!buff.ascendance.up))|buff.ancestral_swiftness.up)
			if talent.echoOfTheElements and ((not t18_4pc and (charges.maelstromWeapon>=2 and not buff.ascendance)) or buff.ancestralSwiftness) then
				if self.castLightningBolt() then return end
			end
		-- Stormstrike
			-- stormstrike,if=talent.echo_of_the_elements.enabled
			if talent.echoOfTheElements then
				if self.castStormstrike() then return end
			end
		-- Lightning Bolt
			-- lightning_bolt,if=(!set_bonus.tier18_4pc&(buff.maelstrom_weapon.react>=1&!buff.ascendance.up))|(set_bonus.tier18_4pc&((talent.unleashed_fury.enabled&buff.unleashed_fury.up)|!talent.unleashed_fury.enabled)&(buff.maelstrom_weapon.react>=5|(buff.maelstrom_weapon.react>=3&!buff.ascendance.up)))|buff.ancestral_swiftness.up
			if (not t18_4pc and (charges.maelstromWeapon>=1 and not buff.ascendance)) or (t18_4pc and ((talent.unleashedFury and buff.unleashedFury) or not talent.unleashedFury) and (charges.maelstromWeapon>=5 or (charges.maelstromWeapon>=3 and not buff.ascendance))) or buff.ancestralSwiftness then
				if self.castLightningBolt() then return end
			end
		-- Searing Totem
			-- searing_totem,if=pet.searing_totem.remains<=20&!pet.fire_elemental_totem.active&!buff.liquid_magma.up
			if totem.remain.searingTotem<=20 and not totem.fireElementalTotem and not buff.liquidMagma then
				if self.castSearingTotem() then return end
			end
		end -- End Action List - Single
	-- Action List - MultiTarget
		function actionList_MultiTarget()
		-- Touch of the Void
            if isChecked("Touch of the Void") and getDistance(self.units.dyn5)<5 then
                if hasEquiped(128318) then
                    if GetItemCooldown(128318)==0 then
                        useItem(128318)
                    end
                end
            end	
		-- Unleash Elements
			-- unleash_elements,if=spell_targets.fire_nova_explosion>=4&dot.flame_shock.ticking&(cooldown.shock.remains>cooldown.fire_nova.remains|cooldown.fire_nova.remains=0)
			if enemies.yards10>=4 and debuff.flameShock and (cd.flameShock>cd.fireNova or cd.fireNova==0) then
				if self.castUnleashElements() then return end
			end
		-- Fire Nova
			-- fire_nova,if=active_dot.flame_shock>=3&spell_targets.fire_nova_explosion>=3
			if debuff.count.flameShock>=3 and enemies.yards10>=3 then
				if self.castFireNova() then return end
			end
			-- wait,sec=cooldown.fire_nova.remains,if=!talent.echo_of_the_elements.enabled&active_dot.flame_shock>=4&cooldown.fire_nova.remains<=action.fire_nova.gcd%2
			if not talent.echoOfTheElements and debuff.count.flameShock>=4 and cd.fireNova<=self.gcd/2 then
				pause()
			end
		-- Magma Totem
			-- magma_totem,if=!totem.fire.active
			if (not totem.magmaTotem and not totem.fireElementalTotem) or totem.searingTotem then
				if self.castMagmaTotem() then return end
			end
		-- Lava Lash
			-- lava_lash,if=dot.flame_shock.ticking&active_dot.flame_shock<spell_targets.fire_nova_explosion
			if debuff.flameShock and debuff.count.flameShock<enemies.yards10 then
				if self.castLavaLash() then return end
			end
		-- Elemental Blast
			-- elemental_blast,if=!buff.unleash_flame.up&(buff.maelstrom_weapon.react>=4|buff.ancestral_swiftness.up)
			if not buff.unleashFlame and (charges.maelstromWeapon>=4 or buff.ancestralSwiftness) then
				if self.castElementalBlast() then return end
			end
		-- Chain Lightning
			-- chain_lightning,if=buff.maelstrom_weapon.react=5&((glyph.chain_lightning.enabled&spell_targets.chain_lightning>=3)|(!glyph.chain_lightning.enabled&spell_targets.chain_lightning>=2))
			if charges.maelstromWeapon==5 and ((glyph.chainLightning and #getEnemies(self.units.dyn10AoE,10)>=3) or (not glyph.chainLightning and #getEnemies(self.units.dyn10AoE,10)>=2)) then
				if self.castChainLightning() then return end
			end
		-- Unleash Elements
			-- unleash_elements,if=spell_targets.fire_nova_explosion<4
			if enemies.yards10 < 4 then
				if self.castUnleashElements() then return end
			end
		-- Flame Shock
			-- flame_shock,if=dot.flame_shock.remains<=9|!ticking
			if debuff.remain.flameShock<=9 or not debuff.flameShock then
				if self.castFlameShock() then return end
			end
		-- Windstrike
			-- windstrike,target=1,if=!debuff.stormstrike.up
			-- windstrike,target=2,if=!debuff.stormstrike.up
			-- windstrike,target=2,if=!debuff.stormstrike.up
			if debuff.count.windstrike<3 then
				for i=1, #getEnemies("player",5) do
					thisUnit = getEnemies("player",5)[i]
					if getDebuffRemain(thisUnit,self.spell.windstrike,"player")==0 then
						if self.castWindstrike(thisUnit) then return end
					end
				end
			end
		-- Windstrike
			-- windstrike
			if self.castWindstrike() then return end
		-- Elemental Blast
			-- elemental_blast,if=!buff.unleash_flame.up&buff.maelstrom_weapon.react>=3
			if not buff.unleashFlame and charges.maelstromWeapon>=3 then
				if self.castElementalBlast() then return end
			end
		-- Chain Lightning
			-- chain_lightning,if=(buff.maelstrom_weapon.react>=3|buff.ancestral_swiftness.up)&((glyph.chain_lightning.enabled&spell_targets.chain_lightning>=4)|(!glyph.chain_lightning.enabled&spell_targets.chain_lightning>=3))
			if (charges.maelstromWeapon>=3 or buff.ancestralSwiftness) and ((glyph.chainLightning and #getEnemies(self.units.dyn10AoE,10)>=4) or (not glyph.chainLightning and #getEnemies(self.units.dyn10AoE,10)>=3)) then
				if self.castChainLightning() then return end
			end
		-- Magma Totem
			-- magma_totem,if=pet.magma_totem.remains<=20&!pet.fire_elemental_totem.active&!buff.liquid_magma.up
			if totem.remain.magmaTotem<=20 and not totem.fireElementalTotem and not buff.liquidMagma then
				if self.castMagmaTotem() then return end
			end
		-- Lightning Bolt
			-- lightning_bolt,if=buff.maelstrom_weapon.react=5&glyph.chain_lightning.enabled&spell_targets.chain_lightning<3
			if charges.maelstromWeapon==5 and glyph.chainLightning and #getEnemies(self.units.dyn10AoE,10)<3 then
				if self.castLightningBolt() then return end
			end
		-- Stormstrike
			-- stormstrike,target=1,if=!debuff.stormstrike.up
			-- stormstrike,target=2,if=!debuff.stormstrike.up
			-- stormstrike,target=3,if=!debuff.stormstrike.up
			if debuff.count.stormstrike<3 then
				for i=1, #getEnemies("player",5) do
					thisUnit = getEnemies("player",5)[i]
					if getDebuffRemain(thisUnit,self.spell.stormstrike,"player")==0 then
						if self.castStormstrike(thisUnit) then return end
					end
				end
			end
		-- Stormstrike
			-- stormstrike
			if self.castStormstrike() then return end
		-- Lava Lash
			-- lava_lash
			if self.castLavaLash() then return end
		-- Fire Nova
			-- fire_nova,if=active_dot.flame_shock>=2&spell_targets.fire_nova_explosion>=2
			if debuff.count.flameShock>=2 and enemies.yards10>=2 then
				if self.castFireNova() then return end
			end
		-- Elemental Blast
			-- elemental_blast,if=!buff.unleash_flame.up&buff.maelstrom_weapon.react>=1
			if not buff.unleashFlame and charges.maelstromWeapon>=1 then
				if self.castElementalBlast() then return end
			end
		-- Chain Lightning
			-- chain_lightning,if=(buff.maelstrom_weapon.react>=1|buff.ancestral_swiftness.up)&((glyph.chain_lightning.enabled&spell_targets.chain_lightning>=3)|(!glyph.chain_lightning.enabled&spell_targets.chain_lightning>=2))
			if (charges.maelstromWeapon>=1 or buff.ancestralSwiftness) and ((glyph.chainLightning and #getEnemies(self.units.dyn10AoE,10)>=3) or (not glyph.chainLightning and #getEnemies(self.units.dyn10AoE,10)>=2)) then
				if self.castChainLightning() then return end
			end
		-- Lightning Bolt
			-- lightning_bolt,if=(buff.maelstrom_weapon.react>=1|buff.ancestral_swiftness.up)&glyph.chain_lightning.enabled&spell_targets.chain_lightning<3
			if (charges.maelstromWeapon>=1 or buff.ancestralSwiftness) and glyph.chainLightning and #getEnemies(self.units.dyn10AoE,10)<3 then
				if self.castLightningBolt() then return end
			end
		-- Fire Nova
			-- fire_nova,if=active_dot.flame_shock>=1&spell_targets.fire_nova_explosion>=1
			if debuff.count.flameShock>=1 and enemies.yards10>=1 then
				if self.castFireNova() then return end
			end
		end -- End Action List - MultiTarget
	-----------------
	--- Rotations ---
	-----------------
		if actionList_Extra() then return end
		if actionList_Defensive() then return end
	---------------------------------
	--- Out Of Combat - Rotations ---
	---------------------------------
		if not inCombat and ObjectExists("target") and not UnitIsDeadOrGhost("target") and UnitCanAttack("target", "player") then
			if actionList_PreCombat() then return end
			if getDistance("target")<5 then
				StartAttack()
			end
		end
	-----------------------------
	--- In Combat - Rotations --- 
	-----------------------------
		if inCombat then
			if actionList_Interrupts() then return end
			if actionList_Cooldowns() then return end
	-- Run Action List - MultiTarget
			-- call_action_list,name=aoe,if=spell_targets.chain_lightning>1
			if (enemies.yards10>1 and useAoE()) or BadBoy_data['AoE'] == 2 then
				if actionList_MultiTarget() then return end
			end
	-- Run Action List - Single Target
			-- call_action_list,name=single
			if (enemies.yards10==1 and useSingle()) or BadBoy_data['AoE'] == 3 then
				if actionList_Single() then return end
			end
		end -- End Combat Rotation
    end -- End cEnhancement:EnhanementCuteOne()
end -- End Select Shaman