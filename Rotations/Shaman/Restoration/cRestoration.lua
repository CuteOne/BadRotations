if select(2, UnitClass("player")) == "SHAMAN" then

  cRestoration = {}

  -- Creates Mistweaver Monk
    function cRestoration:new()
        local self = cShaman:new("Restoration")

        local player = "player" -- if someone forgets ""

        -----------------
        --- VARIABLES ---
        -----------------

        self.enemies = {
            yards5,
            yards8,
            yards12,
            yards40,
        }
        self.restorationSpell = {
            
                -- Ability - Healing
	        chainHeal					= 1064,
	        earthShield					= 974,
	        healingWave					= 77472,
	        riptide						= 61295,
	        unleashLife					= 73685,
	        waterShield					= 52127,

	        -- Ability - Offensive
	        lavaBurst					= 51505,

	        -- Ability - Totems
	        healingTideTotem			= 108280,
	        spiritLinkTotem				= 98008,

	        -- Ability - Utility
	        purifySpirit				= 77130,

	        -- Buff - Healing
	        earthShieldBuff				= 974,
	        riptideBuff					= 61295,
	        tidalWavesBuff				= 53390,
	        waterShieldBuff				= 52127,

	        -- Buff - Forms

	        -- Buff - Offensive

	        -- Buff - Presense

	        -- Buff - Stacks
            earthShieldStacks           = 974,

	        -- Buff - Utility

	        -- Debuff - Offensive

	        -- Debuff - Defensive

	        -- Glyphs
	        chainLightningGlyph 		= 55449,

	        -- Perks

	        -- Talents

            
        }
        -- Merge all spell tables into self.spell
        self.spell = {}
        self.spell = mergeSpellTables(self.spell, self.characterSpell, self.shamanSpell, self.restorationSpell)

	-- OOC Update
		function self.updateOOC()
            -- Call classUpdateOOC()
            self.classUpdateOOC()

            self.getGlyphs()
            self.getTalents()
        end

	-- Update 
		function self.update()
			-- Call baseUpdate()
			self.classUpdate()
			self.getBuffs()
			self.getBuffsDuration()
			self.getBuffsRemain()
			self.getCharges()
			self.getClassCooldowns()
			self.getDebuffs()
			self.getDebuffsDuration()
			self.getDebuffsRemain()
			self.getDebuffsCount()
			self.getTotems()
			self.getTotemsDuration()
			self.getTotemsRemain()
			self.getRecharge()

			self:startRotation()
		end

	-- Buff updates
		function self.getBuffs()
			local UnitBuffID = UnitBuffID

			self.buff.tidalWaves     = UnitBuffID("player",self.spell.tidalWavesBuff)~=nil or false
			self.buff.waterShield 	 = UnitBuffID("player",self.spell.waterShieldBuff)~=nil or false

		end	

		function self.getBuffsDuration()
			local getBuffDuration = getBuffDuration

		end

		function self.getBuffsRemain()
			local getBuffRemain = getBuffRemain

		end

		function self.getCharges()
			local getBuffStacks = getBuffStacks

			self.charges.earthShield 	= getBuffStacks("player",self.spell.earthShieldStacks,"player") or 0
		end

	-- Cooldown updates
		function self.getClassCooldowns()
			local getSpellCD = getSpellCD

			self.cd.earthShield 		= getSpellCD(self.spell.earthShield)
			self.cd.healingTideTotem   	= getSpellCD(self.spell.healingTideTotem)
			self.cd.lavaBurst   		= getSpellCD(self.spell.lavaBurst)
			self.cd.purifySpirit 		= getSpellCD(self.spell.purifySpirit)
			self.cd.riptide 	 		= getSpellCD(self.spell.riptide)
			self.cd.spiritLinkTotem   	= getSpellCD(self.spell.spiritLinkTotem)
			self.cd.unleashLife 		= getSpellCD(self.spell.unleashLife)
		end

	-- Debuff updates
		function self.getDebuffs()
			local UnitDebuffID = UnitDebuffID

		end

		function self.getDebuffsDuration()
			local getDebuffDuration = getDebuffDuration

		end

		function self.getDebuffsRemain()
			local getDebuffRemain = getDebuffRemain

		end

		function self.getDebuffsCount()
			local UnitDebuffID = UnitDebuffID

		end

	-- Recharge updates
		function self.getRecharge()
			local getRecharge = getRecharge

			-- self.recharge.chiBrew 	 = getRecharge(self.spell.chiBrew)
		end

	-- Totem Updates
		function self.getTotems()
			local fire, earth, water, air = 1, 2, 3, 4
			local GetTotemInfo = GetTotemInfo
			local GetSpellInfo = GetSpellInfo

			self.totem.healingTideTotem 		= (select(2, GetTotemInfo(water)) == GetSpellInfo(self.spell.healingTideTotem))
			self.totem.spiritLinkTotem 			= (select(2, GetTotemInfo(air)) == GetSpellInfo(self.spell.spiritLinkTotem))

		end

		function self.getTotemsDuration()

			self.totem.duration.healingTideTotem  	= 10
			self.totem.duration.spiritLinkTotem  	= 6

		end

		function self.getTotemsRemain()
			local fire, earth, water, air = 1, 2, 3, 4
			local GetTotemTimeLeft = GetTotemTimeLeft

			if (select(2, GetTotemInfo(water)) == GetSpellInfo(self.spell.healingTideTotem)) then
				self.totem.remain.healingTideTotem 		= GetTotemTimeLeft(water) or 0
			else
				self.totem.remain.healingTideTotem 		= 0
			end
			if (select(2, GetTotemInfo(air)) == GetSpellInfo(self.spell.spiritLinkTotem)) then
				self.totem.remain.spiritLinkTotem 		= GetTotemTimeLeft(air) or 0
			else
				self.totem.remain.spiritLinkTotem 		= 0
			end
		end

	-- Glyph updates
		function self.getClassGlyphs()
			local hasGlyph = hasGlyph

			self.glyph.chainLightning 	= hasGlyph(self.spell.chainLightningGlyph)
		end

	-- Talent updates
		function self.getClassTalents()
			local getTalent = getTalent
		end

		 ----------------------
        --- START ROTATION ---
        ----------------------

        function self.startRotation()
            if self.rotation == 1 then
                self:RestorationKuu()
            else
                ChatOverlay("No ROTATION ?!", 2000)
            end
        end

	--------------------------
	--- SPELLS - HEALING   ---
	--------------------------
		-- Chain Heal
		function self.castChainHeal(thisUnit)
			if getDistance(thisUnit) < 40 then
				if castSpell(thisUnit,self.spell.chainHeal,false,false,false) then return end
			end
		end
		-- Earth Shield
		function self.castEarthShield(thisUnit)
			if getDistance(thisUnit) < 40 then
				if castSpell(thisUnit,self.spell.earthShield,false,false,false) then return end
			end
		end
		-- Healing Wave
		function self.castHealingWave(thisUnit)
			if getDistance(thisUnit) < 40 then
				if castSpell(thisUnit,self.spell.healingWave,false,false,false) then return end
			end
		end
		-- Riptide
		function self.castRiptide(thisUnit)
			if getDistance(thisUnit) < 40 and self.cd.riptide == 0 then
				if castSpell(thisUnit,self.spell.riptide,false,false,false) then return end
			end
		end
		-- Unleash Life
		function self.castUnleashLife()
			if self.cd.unleashLife == 0 then
				if castSpell("player",self.spell.unleashLife,false,false,false) then return end
			end
		end
		-- Water Shield
		function self.castWaterShield()
				if castSpell("player",self.spell.waterShield,false,false,false) then return end
		end
	--------------------------
	--- SPELLS - OFFENSIVE ---
	--------------------------
		-- Lava Burst
		function self.castLavaBurst(thisUnit)
			if self.cd.lavaBurst==0 and getDistance(thisUnit) < 30 then
				if castSpell(thisUnit,self.spell.lavaBurst,true,true,false) then return end
			end
		end
		function self.castLightningBoltResto(thisUnit)
			if getDistance(thisUnit) < 30 then
				if castSpell(thisUnit,self.spell.lightningBolt,true,true,false) then return end
			end
		end
	-----------------------
	--- SPELLS - TOTEMS ---
	-----------------------
		-- Healing Tide Totem
		function self.castHealingTideTotem()
			if self.cd.healingTideTotem==0 and self.powerPercent>5 then
				if castSpell("player",self.spell.healingTideTotem,false,false,false) then return end
			end
		end
		-- Spirit Link Totem
		function self.castSpiritLinkTotem()
			if self.cd.spiritLinkTotem==0 and self.powerPercent>5.9 then
				if castSpell("player",self.spell.spiritLinkTotem,false,false,false) then return end
			end
		end
	------------------------
	--- SPELLS - UTILITY ---
	------------------------
		-- Cleanse Spirit
		function self.castPurifySpirit(thisUnit)
			local thisUnit = thisUnit
			if getSpellCD(self.spell.purifySpirit)==0 and UnitIsPlayer(thisUnit) and UnitIsFriend(thisUnit,"player") then
				if castSpell(thisUnit,self.spell.purifySpirit,false,false,false) then return end
			end
		end
	
	-- Return
		return self
	end

end -- End Select 
