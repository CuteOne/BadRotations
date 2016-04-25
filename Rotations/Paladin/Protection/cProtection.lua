--- Protection Class
-- Inherit from: ../cCharacter.lua and ../cPaladin.lua
-- All Paladin specs inherit from cPaladin.lua
if select(3, UnitClass("player")) == 2 then

cProtection = {}

-- Creates Protection Paladin
function cProtection:new()
	local self = cPaladin:new("Protection")

	local player = "player" -- if someone forgets ""

    self.rotations = {
        "Defmaster",
        "Cute",
    }
    self.rotation = BadBoy_data.options[bb.selectedSpec]["Rotation".."Drop"]
    self.cast = {}
	self.enemies = {
		yards5,
		yards8,
		yards12,
	}
	self.previousJudgmentTarget = previousJudgmentTarget
	self.protectionSpell = {
        ardentDefender         = 31850,
        avengersShield         = 31935,
        bastionOfGlory         = 114637,
        consecration           = 26573,
        divineCrusader         = 144595,
        divinePurpose          = 86172,
        divinePurposeBuff      = 90174,
        grandCrusader          = 85416,
        guardianOfAncientKings = 86659,
        empoweredSeals         = 152263,
        hammerOfTheRighteous   = 53595,
        holyWrath              = 119072,
        righteousFury          = 25780,
        sanctifiedWrath        = 171648,
        sealOfInsight          = 20165,
        sealOfRighteousness    = 20154,
        seraphim               = 152262,
        shieldOfTheRighteous   = 53600,
        shieldOfTheRighteousBuff = 132403,
        turnEvil               = 10326,
		-- Empowered Seals
		liadrinsRighteousness = 156989,
        uthersInsight         = 156988,
	}

	-- Merge all spell tables into self.spell
	self.spell = {}
	self.spell = mergeSpellTables(self.spell, self.characterSpell, self.paladinSpell, self.protectionSpell)

	self.defaultSeal = self.spell.sealOfInsight

    -- Update OOC
    function self.updateOOC()
        -- Call classUpdateOOC()
        self.classUpdateOOC()

        self.getGlyphs()
        self.getTalents()
    end

    -- Update
	function self.update()
		self.classUpdate()
        -- Updates OOC things
        if not UnitAffectingCombat("player") then self.updateOOC() end
		self.getBuffs()
		self.getCooldowns()
		self.getJudgmentRecharge()
		self.getDynamicUnits()
		self.getEnemies()
        self.getOptions()

        -- Right = 1, Insight = 2
		self.seal = GetShapeshiftForm() == 1

		-- Casting and GCD check
		-- TODO: -> does not use off-GCD stuff like pots, dp etc
		if UnitCastingInfo("player") ~= nil or UnitChannelInfo("player") ~= nil or pause() then
			return
		end


		-- Start selected rotation
		self:startRotation()
	end



    -- Buff updates
	function self.getBuffs()
		local getBuffRemain,UnitBuffID = getBuffRemain,UnitBuffID

        self.buff.ardentDefender         = getBuffRemain(player,self.spell.ardentDefender)
        self.buff.bastionOfGlory         = getBuffRemain(player,self.spell.bastionOfGlory)
        self.buff.holyAvenger            = getBuffRemain(player,self.spell.holyAvenger)
        self.buff.divineProtection       = getBuffRemain(player,self.spell.divineProtection)
        self.buff.divinePurpose          = getBuffRemain(player,self.spell.divinePurposeBuff)
        self.buff.grandCrusader          = getBuffRemain(player,self.spell.grandCrusader)
        self.buff.guardianOfAncientKings = getBuffRemain(player,self.spell.guardianOfAncientKings)
        self.buff.righteousFury          = UnitBuffID(player,self.spell.righteousFury)
        self.buff.sacredShield           = getBuffRemain(player,self.spell.sacredShield)
        self.buff.shieldOfTheRighteous   = getBuffRemain(player,self.spell.shieldOfTheRighteousBuff)
        self.buff.seraphim               = getBuffRemain(player,self.spell.seraphim)

		-- Empowered Seals
		self.buff.liadrinsRighteousness = getBuffRemain(player,self.spell.liadrinsRighteousness)
        self.buff.uthersInsight         = getBuffRemain(player,self.spell.uthersInsight)

	end

    -- Cooldown updates
	function self.getCooldowns()
		local getSpellCD = getSpellCD

		self.cd.judgment         = getSpellCD(self.spell.judgment)
		self.cd.crusaderStrike   = getSpellCD(self.spell.crusaderStrike)
        self.cd.divineProtection = getSpellCD(self.spell.divineProtection)
		self.cd.seraphim         = getSpellCD(self.spell.seraphim)
	end

    -- Glyph updates
	function self.getGlyphs()
		local hasGlyph = hasGlyph

        self.glyph.doubleJeopardy = hasGlyph(183)
        self.glyph.consecration   = hasGlyph(189)
        self.glyph.focusedShield  = hasGlyph(191)
        self.glyph.finalWrath     = hasGlyph(194)
	end

    -- Talent updates
	function self.getTalents()
		local isKnown = isKnown

		self.talent.empoweredSeals  = isKnown(self.spell.empoweredSeals)
        self.talent.sanctifiedWrath = isKnown(self.spell.sanctifiedWrath)
		self.talent.seraphim        = isKnown(self.spell.seraphim)
	end

    -- Update Dynamic units
	function self.getDynamicUnits()
		local dynamicTarget = dynamicTarget

        -- Throttle dynamic target updating
        if bb.timer:useTimer("dynTarUpdate", self.dynTargetTimer) then
            -- Normal
            self.units.dyn8 = dynamicTarget(8,true) --

            -- AoE
            self.units.dyn8AoE  = dynamicTarget(8,false) --
        end
	end

    -- Update Number of Enemies around player
	function self.getEnemies()
		local getEnemies = getEnemies

        -- TODO: use a general method for this?
        self.enemies.yards15 = 0
        self.enemies.yards10 = 0
        self.enemies.yards9  = 0
        self.enemies.yards5  = 0

        self.enemies.yards15 = #getEnemies("player",15) -- Holy Prism on friendly AoE
        if self.enemies.yards15 > 0 then
            self.enemies.yards10 = #getEnemies("player",10) -- (Holy Wrath)
        end
        if self.enemies.yards10 > 0 then
            self.enemies.yards9  = #getEnemies("player",9) -- (Consecration)
        end
        if self.enemies.yards9 > 0 then
		    self.enemies.yards5  = #getEnemies("player",5) -- (meleeEnemies)
        end

        self.aroundTarget7Yards = #getEnemies(self.units.dyn5,7) -- (Hammer of the Righteous)

        self.unitInFront = getFacing("player",self.units.dyn5) == true or false
    end

    -- Updates toggle data
    function self.getToggleModes()
        local BadBoy_data   = BadBoy_data

        self.mode.aoe       = BadBoy_data["AoE"]
        self.mode.cooldowns = BadBoy_data["Cooldowns"]
        self.mode.defensive = BadBoy_data["Defensive"]
        self.mode.healing   = BadBoy_data["Healing"]
        self.mode.empS      = BadBoy_data["EmpS"]
        self.mode.classTrinket = BadBoy_data["classTrinket"]
    end

    -- Updates Judgment recharge time (cooldown)
	function self.getJudgmentRecharge()
		local GetSpellCooldown = GetSpellCooldown

		local cdCheckJudgment = select(2,GetSpellCooldown(self.spell.judgment))
		if cdCheckJudgment ~= nil and cdCheckJudgment > 2 then
			self.recharge.judgment = select(2,GetSpellCooldown(self.spell.judgment))
		else
			self.recharge.judgment = 4.5
		end
    end

    -- Starts rotation, uses default if no other specified; starts if inCombat == true
	function self.startRotation()
        self:protectionSimC()
	end

---------------------------------------------------------------
-------------------- OPTIONS ----------------------------------
---------------------------------------------------------------

    function self.createToggles()
        GarbageButtons()

        self.protectionSimC_createToggles()
    end

    function self.createOptions()
        bb.ui.window.profile = bb.ui:createProfileWindow("Protection")

        --self.createClassOptions()

        local section
        local function pageBuffs()
            -- Buffs
            section = bb.ui:createSection(bb.ui.window.profile, "Buffs")
            bb.ui:createCheckbox(section, "Righteous Fury")
            bb.ui:checkSectionState(section)
        end
        local function pageCooldowns()
            -- Rota
            section = bb.ui:createSection(bb.ui.window.profile, "Rotation Managment")
            bb.ui:createDropdown(section, "Light's Hammer", bb.dropOptions.CD)
            bb.ui:createDropdown(section, "Execution Sentence", bb.dropOptions.CD)
            bb.ui:createDropdown(section, "Holy Avenger", bb.dropOptions.CD)
            bb.ui:createDropdown(section, "Seraphim", bb.dropOptions.CD)
            bb.ui:checkSectionState(section)
        end
        local function pageT18Trinket()
            -- T18 Class Trinket DMG pushing
            section = bb.ui:createSection(bb.ui.window.profile, "T18 Class Trinket", "Choose which absorb buffs should be canceled to make trinket proc.")
            bb.ui:createSpinner(section, "Trinket % Trigger", 59, 59, 100, 1, "Enter your Trinket % when it will trigger.")
            bb.ui:createCheckbox(section, "Cancel Power Word: Shield")
            bb.ui:createCheckbox(section, "Cancel Clarity of Will")
            bb.ui:createCheckbox(section, "Cancel Sacred Shield", "Only cancels the short duration absorb buff.")
            bb.ui:createCheckbox(section, "Cancel Avenger's Reprieve", "2 T18 Buff")
            bb.ui:checkSectionState(section)
        end
        local function pageHealing()
            -- Healing
            section = bb.ui:createSection(bb.ui.window.profile, "Healing")
            bb.ui:createSpinner(section, "Word Of Glory On Self", 60)
            bb.ui:createSpinner(section, "Lay On Hands", 12)
            bb.ui:checkSectionState(section)
        end
        local function pageDefensive()
            -- Defensive
            section = bb.ui:createSection(bb.ui.window.profile, "Defensive")

            bb.ui:createSpinner(section, "Divine Protection", 65)
            bb.ui:createSpinner(section, "Ardent Defender", 20)
            bb.ui:createSpinner(section, "Guardian of Anchient Kings", 40)
            bb.ui:checkSectionState(section)
        end
        local function pageInterrupt()
            -- Interrupt
            section = bb.ui:createSection(bb.ui.window.profile, "Interrupts")

            bb.ui:createSpinner(section, "Rebuke", 35)
            bb.ui:createSpinner(section, "Avengers Shield Interrupt", 35)
            bb.ui:checkSectionState(section)
        end

        bb.ui:createPagesDropdown(bb.ui.window.profile, {
            {
                [1] = "Base Options",
                [2] = self.createBaseOptions,
            },
            {
                [1] = "Class Options",
                [2] = self.createClassOptions,
            },
            {
                [1] = "Buffs",
                [2] = pageBuffs,
            },
            {
                [1] = "Cooldowns",
                [2] = pageCooldowns,
            },
            {
                [1] = "T18 Trinket",
                [2] = pageT18Trinket,
            },
            {
                [1] = "Healing",
                [2] = pageHealing,
            },
            {
                [1] = "Defensive",
                [2] = pageDefensive,
            },
            {
                [1] = "Interrupt",
                [2] = pageInterrupt,
            },
        })
        --[[ Rotation Dropdown ]]--
        --bb.ui:createRotationDropdown(bb.ui.window.profile.parent, self.rotations, "Defmaster - real rotation\nCute - just here for some testing")

        bb:checkProfileWindowStatus()
    end

    function self.getOptions()
        local options = self.options

        options.ardentDefender = {
            isChecked = isChecked("Ardent Defender", true),
            value = getValue("Ardent Defender", true)
        }

        options.divineProtection = {
            isChecked = isChecked("Divine Protection", true),
            value = getValue("Divine Protection", true)
        }

        options.divineShield = {
            isChecked = isChecked("Divine Shield", true),
            value = getValue("Divine Shield", true)
        }

        --options.executionSentence = {
        --    isChecked = isChecked("Divine Shield", true),
        --    value = getValue("Divine Shield", true)
        --}
--
        --options.guardianOfAncientKings = {
        --    isChecked = isChecked("Divine Shield", true),
        --    value = getValue("Divine Shield", true)
        --}
        --
        --options.holyAvenger = {
        --    isChecked = isChecked("Divine Shield", true),
        --    value = getValue("Divine Shield", true)
        --}
--
        --options.lightsHammer = {
        --    isChecked = isChecked("Divine Shield", true),
        --    value = getValue("Divine Shield", true)
        --}
--
        --options.righteousFury = {
        --    isChecked = isChecked("Divine Shield", true),
        --    value = getValue("Divine Shield", true)
        --}
    end

---------------------------------------------------------------
-------------------- Spell functions --------------------------
---------------------------------------------------------------

    -- Ardent Defender
    function self.cast.ArdentDefender()
        return self.options.ardentDefender.isChecked and self.health <= self.options.ardentDefender.value and castSpell(player,self.spell.ardentDefender,true,false)
    end

    -- Avenger's Shield
    function self.cast.AvengersShield()
        -- Todo: we need to check if AS will hit 3 targets, so what is the range of AS jump? We are usimg same logic as Hammer of Righ at the moment, 8 yard.
        -- Todo: We could add functionality that cycle all unit to find one that is casting since the Avenger Shield is silencing as well.
        return castSpell(self.units.dyn30,self.spell.avengersShield,false,false) == true or false
    end

    function self.cast.Buffs()
        -- Make sure that we are buffed
        -- Righteous Fury
        if self.cast.RighteousFury() then
            return true
        end
    end

    -- Todo: populate list, link to profile, add option for it
    -- Cleanse
    --function protCore:castCleanse()
    --    if isChecked("Cleanse") then
    --        for i = 1, #shouldCleanseDebuff do
    --            if UnitDebuffID("player",shouldCleanseDebuff[i].debuff) then
    --                return castSpell("player",cleanse,true,false) == true or false
    --            end
    --        end
    --    end
    --end

    -- Consecration glyphed or not
    function self.cast.Consecration()
        if self.glyph.consecration then
            local thisUnit = self.units.dyn25AoE
            if UnitExists(thisUnit) and (isDummy(thisUnit) or not isMoving(thisUnit)) then
                if getGround(thisUnit) then
                    return castGround(thisUnit,116467,30) == true or false
                end
            end
        else
            local consecrationDebuff = 81298
            if isInMelee(self.units.dyn5AoE) and getDebuffRemain(self.units.dyn5AoE,consecrationDebuff,"player") < 2 then
                return castSpell(player,self.spell.consecration,true,false) == true or false
            end
        end
    end

    -- Crusader Strike
    function self.cast.CrusaderStrike()
        return castSpell(self.units.dyn5,self.spell.crusaderStrike,false,false) == true or false
    end

    -- Divine Protection
    function self.cast.DivineProtection()
        return self.options.divineProtection.isChecked and self.health <= self.options.divineProtection.value and castSpell(player,self.spell.divineProtection,true,false)
    end

    -- Divine Shield
    function self.cast.DivineShield()
        if (self.options.divineShield.isChecked and mode.defense == 2) or mode.defense == 3 then
            return self.health < self.options.divineShield.value and castSpell(player,self.spell.divineShield,true,false) == true or false
        end
    end

    -- Execution sentence
    -- Todo: make sure we cast on a unit with as much HP as possible
    function self.cast.ExecutionSentence()
        if isSelected("Execution Sentence",true) then
            local noSeraCheck = true
            if not self.talent.seraphim or not isSelected("Seraphim",true) or self.buff.seraphim > 5 or noSeraCheck then
                if (isDummy(self.units.dyn40) or (UnitHealth(self.units.dyn40) >= 4*UnitHealthMax("player"))) then
                    return castSpell(self.units.dyn30,self.spell.executionSentence,false,false) == true or false
                end
            end
        end
        return false
    end

    -- Guardian Of Ancient Kings
    function self.cast.GuardianOfAncientKings()
        return isChecked("Guardian Of Ancient Kings",true) and self.health <= getValue("Guardian Of Ancient Kings",true) and castSpell(player,self.spell.guardianOfAncientKings,true,false)
    end

    -- Hammer of the Righteous
    -- Todo: Find best cluster of mobs to cast on
    function self.cast.HammerOfTheRighteous()
        return castSpell(self.units.dyn5,self.spell.hammerOfTheRighteous,false,false) == true or false
    end

    -- Hammer of Wrath
    function self.cast.HammerOfWrath()
        if canCast(self.spell.hammerOfWrath) then
            for i = 1,#enemiesTable do
                if enemiesTable[i].hp < 20 then
                    return castSpell(enemiesTable[i].unit,self.spell.hammerOfWrath,false,false) == true or false
                end
            end
        end
    end


    --function self.cast.HandOfFreedom()
    --    -- Todo: see against list of debuff we should remove.
    --    -- This is returning false since its not proper designed yet.
    --    return false
    --end

    --function self.cast.HandOfSacrifice()
    --    -- Todo: We should add glyph check or health check, at the moment we assume the glyph
    --    -- Todo:  We should be able to config who to use as candidate, other tank, healer, based on debuffs etc.
    --    -- Todo: add check if target already have sacrifice buff
    --    -- Todo Is the talent handle correctly? 2 charges? CD starts but u have 2 charges
    --    -- We need to have a list of scenarios when we should cast sacrifice, off tanking, dangerous debuffs/dots or high spike damage on someone.
    --    -- This is returning false since its not proper designed yet.
    --    return false
    --end


    --function self.cast.HandOfSalvation()
    --    -- Todo: find the lowest units, see if they have hight treath and salv them
    --    -- This is returning false since its not proper designed yet.
    --    return false
    --end

    -- Holy Avenger
    function self.cast.HolyAvenger()
        if isSelected("Holy Avenger",true) then
            if isDummy(self.units.dyn5) or (UnitHealth(self.units.dyn5) >= 4*UnitHealthMax(player)) then
                if self.talent.seraphim and self.buff.seraphim or (not self.talent.seraphim and self.holyPower <= 2) then
                    return castSpell(player,self.spell.holyAvenger,true,false) == true or false
                end
            end
        end
    end

    -- Holy Prism
    -- Todo: find cluster of units to heal(single) or aoe around self
    -- Todo: Similiar to Lights Hammer, this can be improved, number of heals and enemies will give this a higher prio
    function self.cast.HolyPrism()
        if self.enemies.yards15 >= 2 then
            return castSpell(player,self.spell.holyPrism,true,false) == true or false
        else
            return castSpell(self.units.dyn30,self.spell.holyPrism,false,false) == true or false
        end
    end

    -- Holy Wrath
    -- Todo: better stun logic
    function self.cast.HolyWrath()
        return (getDistance(player,self.units.dyn8AoE) < 8 and castSpell(player,self.spell.holyWrath,true,false) == true) or false
    end

    -- Functionality regarding interrupting target(s) spellcasting
    -- ToDos: Add multiple interrupts such as binding light(if within 10 yards), Fist of Justice(stuns)
    -- Holy wrath on demons/undead
    --function self.cast.Interrupts()
    --    -- we return as soon as we cast any interupt to avoid interupting more than once on same unit
    --    -- we return true only for gcd spells, returning true will stop rotation, without true will continue
    --    if #spellCastersTable > 1 then
    --        local numberofcastersinrangeofarcanetorrent = 0
    --        for i = 1, #spellCastersTable do
    --            if spellCastersTable[i].distance < 8 then
    --                numberofcastersinrangeofarcanetorrent = numberofcastersinrangeofarcanetorrent + 1
    --            end
    --        end
    --        if numberofcastersinrangeofarcanetorrent > 1 and self:castArcaneTorrent() then
    --            return
    --        end
    --    end
    --    if getOptionCheck("Avengers Shield Interrupt") then
    --        if castInterrupt(self.spell.avengersShield,getValue("Avengers Shield Interrupt")) then
    --            return true
    --        end
    --    end
    --    if getOptionCheck("Rebuke") then
    --        if castInterrupt(self.spell.rebuke,getValue("Rebuke")) then
    --            return
    --        end
    --    end
    --    if getOptionCheck("Arcane Torrent Interrupt") then
    --        if castInterrupt(self.spell.arcaneTorrent,getValue("Arcane Torrent Interrupt")) then
    --            return
    --        end
    --    end
    --end

    -- Jeopardy
    -- Uses Jeopardy if glyph is found, uses normal judgment if not
    function self.cast.Jeopardy()
        -- Check if glyph is present
        if self.glyph.doubleJeopardy then
            -- scan enemies for a different unit
            local enemiesTable = enemiesTable
            if #enemiesTable > 1 then
                for i = 1, #enemiesTable do
                    local thisEnemy = enemiesTable[i]
                    -- if its in range
                    if thisEnemy.distance < 30 then
                        -- here i will need to compare my previous judgment target with the previous one
                        -- we declare a var in core updated by reader with last judged unit
                        if self.previousJudgmentTarget ~= thisEnemy.guid then
                            return castSpell(thisEnemy.unit,self.spell.judgment,true,false) == true or false
                        end
                    end
                end
            end
        else -- if no jeopardy glyph is found use normal judgment
            -- if no unit found for jeo, cast on actual target
            return castSpell(self.units.dyn30AoE,self.spell.judgment,true,false) == true or false
        end
    end

    -- Judgment
    function self.cast.Judgment()
        return castSpell(self.units.dyn30AoE,self.spell.judgment,true,false) == true or false
    end

    -- Light's Hammer
    -- Todo: find best cluster of mobs/allies
    function self.cast.LightsHammer()
        -- Todo: Could use enhanced logic here, cluster of mobs, cluster of damaged friendlies etc
        if isSelected("Light's Hammer",true) then
            local thisUnit = self.units.dyn30AoE
            if UnitExists(thisUnit) and (isDummy(thisUnit) or not isMoving(thisUnit)) then
                if getGround(thisUnit) then
                    return castGround(thisUnit,self.spell.lightsHammer,30) == true or false
                end
            end
        end
    end

    -- Righteous fury
    function self.cast.RighteousFury()
        if isChecked("Righteous Fury",true) then
            if not self.buff.righteousFury then
                return castSpell(player,self.spell.righteousFury,true,false) == true or false
            end
        end
        return false
    end

    -- Sacred shield
    function self.cast.SacredShield()
        return castSpell(player,self.spell.sacredShield,true,false) == true or false
    end

    -- Seals
    function self.cast.Seal(seal)
        return castSpell("player",seal,true,false) == true or false
    end

    -- Selfless Healer
    -- Todo: We should find friendly candidate to cast on
    function self.cast.SelfLessHealer()
        if getBuffStacks(player,self.spell.selflessHealerBuff) == 3 then
            if self.health <= getValue("Selfless Healer",true) then
                return castSpell(player,self.spell.flashOfLight,true,false) == true or false
            end
        end
    end

    -- Seraphim
    -- Todo: need to handle holy power during holy avenger
    function self.cast.Seraphim()
        if isSelected("Seraphim",true) then
            if self.talent.seraphim and self.holyPower == 5 then
                --if isDummy(self.units.dyn5) or (UnitHealth(self.units.dyn5) >= 4*UnitHealthMax(player)) then
                return castSpell(player,self.spell.seraphim,true,false) == true or false
                --end
            end
        end
    end

    -- Shield of the Righteous
    -- Todo: We need to see what damage since SoR is physical only.
    -- Should add logic, ie abilities we need to cast SoR for, Piercong armor in Skyreach for example
    -- Todo: Add a event that read combatlog and populate incoming damage where we can track the last 10 damage
    -- to see if they are physical or magic in order to determine if we should use SoR
    function self.cast.ShieldOfTheRighteous()
        return castSpell(self.units.dyn5,self.spell.shieldOfTheRighteous,false,false) == true or false
    end

    -- Word of glory
    -- Todo: add better logic for group support
    -- TODO: Calculate WoD heal, #ofHolyPower * 330% Spellpower * resolve * bastion of glory
    -- Only cast WoG if we are buffed with bastion of glory, base heal of 3 stacks is 11K(5% of hp)
    function self.cast.WordOfGlory(unit)
        if self.holyPower >= 3 or self.buff.divinePurpose then
            return castSpell(unit,self.spell.wordOfGlory,true,false) == true or false
        end
    end
    -- Handle the use of HolyPower
    function self.cast.holyPowerConsumers()
        -- If we have bastion of Glory stacks >= 4
        if getBuffStacks("player",self.spell.bastionOfGlory) >= 4 then
            if self.health < getValue("Word Of Glory On Self",true) then
                if self.cast.WordOfGlory(player) then
                    return true
                end
            end
        end
        -- If we are not low health then we should use it on SoR
        if self.cast.ShieldOfTheRighteous() then
            return true
        end
    end

    -- This module will hold hands and
    -- Todo Blinding Light,Turn Evil,HoP,HoF,Redemption,Mass Resurrection,Reckoning
    --function protCore:paladinUtility()
    --    -- We need to create options for these
    --    if getOptionCheck("Hand Of Freedom") then
    --        if self:checkForDebuffThatIShouldRemovewithHoF("player") then -- Only doing it for me at the moment, todo: add party/friendly units
    --        if self:castHandOfFreedom("player") then
    --            return true
    --        end
    --        end
    --    end
    --    -- Hand of Sacrifice
    --    if self:castHandOfSacrifice() then
    --        return true
    --    end
    --    -- Hand of Savlation
    --    if self:castHandOfSalvation() then
    --        return true
    --    end
    --end

    -- Survival
    function self.cast.survival() -- Check if we are close to dying and act accoridingly
        if isChecked("Lay On Hands") then
            if getHP("player") <= getValue("Lay On Hands") then
              if castLayOnHands("player") then
                return true
              end
            end
        end
        if self.health < 40 then
            if useItem(5512) then -- Healthstone
                return true
            end
        end
        return false
    end

    -----------------------------
    --- CALL CREATE FUNCTIONS ---
    -----------------------------

    self.createOptions()
    --self.createToggles()

-- Return
	return self
end
end
