if select(3, UnitClass("player")) == 11 then
    function MoonkinFunctions()

        -- we want to build core only only
        if core == nil then

            -- build core
            local moonCore = {
                -- player stats
                buff = { },
                castingStarsurge = 0,
                cd = { },
                eclipseEnergy = 0,
                glyph = { },
                health = 100,
                inCombat = false,
                lastStarsurge = 0,
                mana = 0,
                mode = { },
                recharge = { },
                talent = { },
                units = { },
                shape = 0,
                spell = {
                    celestialAlignment = 112071,
                    incarnation = 102560,
                    moonfire = 8921,
                    moonkinForm = 24858,
                    starfall = 48505,
                    starfire = 2912,
                    starsurge = 78674,
                    sunfire = 93402,
                    wrath = 5176,
                 }
            }



            -- Global
            core = moonCore

            -- localise commonly used functions
            local getHP,hasGlyph,UnitPower,getBuffRemain,getBuffStacks = getHP,hasGlyph,UnitPower,getBuffRemain,getBuffStacks
            local UnitBuffID,IsSpellOverlayed,getSpellCD,getEnemies = UnitBuffID,IsSpellOverlayed,getSpellCD,getEnemies
            local player,BadBoy_data,GetShapeshiftForm,dynamicTarget = "player",BadBoy_data,GetShapeshiftForm,dynamicTarget
            local GetSpellCooldown,select,getValue,isChecked,castInterrupt = GetSpellCooldown,select,getValue,isChecked,castInterrupt
            local isSelected,UnitExists,isDummy,isMoving,castSpell,castGround = isSelected,UnitExists,isDummy,isMoving,castSpell,castGround
            local canCast,isKnown,enemiesTable,GetSpellCharges = canCast,isKnown,enemiesTable,GetSpellCharges
            local UnitHealth,castDotCycle,print,UnitHealthMax = UnitHealth,castDotCycle,print,UnitHealthMax
            local GetEclipseDirection,getDebuffRemain,SPELL_POWER_ECLIPSE = GetEclipseDirection,getDebuffRemain,SPELL_POWER_ECLIPSE
            local GetSpellInfo,UnitCastingInfo,GetTime,floor = GetSpellInfo,UnitCastingInfo,GetTime,math.floor

            -- no external access after here
            setfenv(1,moonCore)

            function moonCore:ooc()
                -- Talents (refresh ooc)
                talent.incarnation = isKnown(spell.incarnation)
                -- Glyph (refresh ooc)
                glyph.guidedStars = hasGlyph(175)
                inCombat = false
            end

            -- this will be used to make the core refresh itself
            function moonCore:update()
                -- player stats
                if UnitCastingInfo(player) == GetSpellInfo(spell.starsurge) then
                    castingStarsurge = GetTime()
                end
                activeEnemies = getMoonfireEnemies()
                eclipseDirection = GetEclipseDirection()
                eclipseEnergy = UnitPower(player,8)
                inCombat = true
                combatTime = BadBoy_data["Combat Started"]
                health = getHP(player)
                mana = UnitPower(player,0)
                moonfireIcon = select(3,GetSpellInfo(8921)) == [["Interface\\Icons\\Spell_Nature_StarFall"]]
                surgeStacks,_,surgeTime = GetSpellCharges(spell.starsurge)
                starfireOverlayed = IsSpellOverlayed(2912)
                wrathOverlayed = IsSpellOverlayed(5176)
                forceOfNatureStacks,_,forceOfNatureTime = GetSpellCharges(spell.forceOfNature)
                -- Buffs
                buff.celestialAlignment = getBuffRemain(player,spell.celestialAlignment)
                buff.incarnation = getBuffRemain(player,spell.incarnation)
                buff.lunarEmpowerment = getBuffRemain(player,164547)
                buff.lunarPeak = getBuffRemain(player,171743)
                buff.solarEmpowerment = getBuffRemain(player,164545)
                buff.solarPeak = getBuffRemain(player,171744)
                buff.starfall = getBuffRemain(player,spell.starfall)
                -- Cooldowns
                cd.incarnation = getSpellCD(spell.incarnation)
                -- Modes
                mode.aoe = BadBoy_data["MoonAoE"]
                mode.cooldowns = BadBoy_data["MoonCooldowns"]
                mode.defensive = BadBoy_data["MoonDefensive"]
                mode.healing = BadBoy_data["MoonInterrupts"]
                -- truth = true, right = false
                shape = GetShapeshiftForm()

                -- dynamic units
                units.dyn40 = dynamicTarget(40,true)
            end

            function moonCore:debug()
                if debugEnabled == true then
                    local time = (floor((GetTime() - combatTime)*1000))/1000
                    print("Debug: "..time.." "..self)
                end
            end

            -- Celestial Alignment
            function moonCore:castCelestialAlignment()
                return (castSpell(player,spell.celestialAlignment,true,false) == true and debug("Celestial Alignment")) or false
            end

            -- Incarnation
            function moonCore:castIncarnation()
                if isSelected("Incarnation") then
                    if (isDummy(units.dyn40) or (UnitHealth(units.dyn40) >= 400*UnitHealthMax(player)/100)) then
                        return (castSpell(player,spell.incarnation,true,false) == true and debug("Incarnation")) or false
                    end
                end
            end

            -- Multi Moonfire
            function moonCore:castMultiMoonfire()
                if not SunfireCheck() then
                    if isChecked("Multi-Moonfire") then
                        return (castDotCycle("All",8921,40,false,false,12) == true and debug("Multi-Moonfire"))  or false
                    else
                        return (getDebuffRemain(units.dyn40,spell.moonfire,"player") < 12 and castSpell(units.dyn40,spell.moonfire,false,false) == true and debug("Direct-Moonfire")) or false
                    end
                end
                return false
            end

            -- Moonfire
            function moonCore:castMoonfire()
                if not SunfireCheck() then
                    return (castSpell(units.dyn40,spell.moonfire,false,false) == true and debug("Moonfire")) or false
                end
            end

            -- Starfall
            function moonCore:castStarfall()
                return (castSpell(player,spell.starfall,true,false) == true and debug("Starfall")) or false
            end

            -- Starfire
            function moonCore:castStarfire()
                if eclipseDirection == "moon" then
                    return (castSpell(units.dyn40,spell.starfire,false,true) == true and debug("Starfire")) or false
                end
            end

            -- Starsurge
            function moonCore:castStarsurge()
                return (castSpell(units.dyn40,spell.starsurge,false,true) == true and debug("Starsurge")) or false
            end

            -- Sunfire check
            function moonCore:SunfireCheck()
                return select(3,GetSpellInfo(spell.moonfire)) == select(3,GetSpellInfo(spell.sunfire)) == true or nil
            end
            -- Sunfire
            function moonCore:castSunfire()
                if SunfireCheck() then
                    return (castSpell(units.dyn40,spell.moonfire,false,false) == true and debug("Sunfire")) or false
                end
            end

            -- Wrath
            function moonCore:castFiller()
                if (eclipseDirection == "sun" and eclipseEnergy >= -20)
                  or (eclipseDirection == "moon" and eclipseEnergy >= 20)
                  or (wrathOverlayed)
                  and not starfireOverlayed then
                    return (castSpell(units.dyn40,spell.wrath,false,true) == true and debug("Wrath")) or false
                else
                    return (castSpell(units.dyn40,spell.starfire,false,true) == true and debug("Starfire")) or false
                end
            end
             -- activeEnemes
            function moonCore:getMoonfireEnemies()
                local moonfireCandidates = 0
                for i = 1, #enemiesTable do
                    local enemy = enemiesTable[i]
                    if enemy.facing == true and enemy.distance <= 40 then
                        moonfireCandidates = moonfireCandidates + 1
                    end
                end
                return moonfireCandidates
            end
        end
    end

end