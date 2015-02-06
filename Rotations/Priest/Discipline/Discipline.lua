if select(3, UnitClass("player")) == 5 then
  function PriestDiscipline()

    if currentConfig ~= "Discipline ragnar" then
      DisciplineConfig();
      DisciplineToggles();
      currentConfig = "Discipline ragnar";
    end
    -- Head End


    -- Locals / Globals--
    --GCD = 1.5/(1+UnitSpellHaste("player")/100)
    --hasTarget = UnitExists("target")
    --hasMouse = UnitExists("mouseover")
    --php = getHP("player")
    -- thp = getHP("target")


    --MBCD = getSpellCD(MB)
    --SWDCD = getSpellCD(SWD)

    if lastDP==nil then	lastDP=99 end
    if lastVT==nil then lastVT=99 end

    --DPTICK = DPTIME/6
    -- SWP (18sec)
    --SWPTICK = 18.0/(1+UnitSpellHaste("player")/100)/6
    -- VT (15sec)
    --VTTICK = 16.0/(1+UnitSpellHaste("player")/100)/5
    --VTCASTTIME = 1.5/(1+UnitSpellHaste("player")/100)



    -- Set Enemies Table
    makeEnemiesTable(40)



    local options = {
      -- Player values
      player = {
        GCD = 		1.5/(1+UnitSpellHaste("player")/100),
        php =		getHP("player"),
        PWSolCD =	getSpellCD(PWSol),
        PENCD =		getSpellCD(Penance),
        AASTACKS =	getBuffStacks("player",AA),
      },
      -- Buttons
      buttons = {
        Feather =	BadBoy_data['Feather'],
      },
      isChecked = {
        Feather =			isChecked("Angelic Feather"),
        BodyAndSoul = 		isChecked("Body And Soul"),
      },
      healing = {
        PenanceTankCheck 	= isChecked("Penance Tank"),
        PenanceTankValue 	= getValue("Penance Tank"),
        PenanceCheck 		= isChecked("Penance"),
        PenanceValue 		= getValue("Penance"),
      },
    }

    -------------
    -- TOGGLES --
    -------------

    -- Pause toggle
    if isChecked("Pause Toggle") and SpecificToggle("Pause Toggle") == true then
      ChatOverlay("|cffFF0000BadBoy Paused", 0); return;
    end

    -- Focus Toggle
    if isChecked("Focus Toggle") and SpecificToggle("Focus Toggle") == 1 then
      RunMacroText("/focus mouseover");
    end

    -- -- Auto Resurrection
    -- if isChecked("Auto Rez") then
    -- 	if not isInCombat("player") and UnitIsDeadOrGhost("mouseover") and UnitIsFriend("player","mouseover") then
    -- 		if castSpell("mouseover",Rez,true,true) then return; end
    -- 	end
    -- end

    ------------
    -- CHECKS --
    ------------

    -- Food/Invis Check
    if canRun() ~= true then return false;
    end

    -- Mounted Check (except nagrand outpost mounts)
    if IsMounted("player") and not (UnitBuffID("player",164222) or UnitBuffID("player",165803)) then
      return false;
    end

    -- Do not Interrupt "player" while GCD (61304)
    -- if getSpellCD(61304) > 0 then return false;
    -- end
    if castingUnit() then
      return false
    end

    -------------------
    -- OUT OF COMBAT --
    -------------------

    -- Power Word: Fortitude
    if not isInCombat("player") then
      if options.isChecked.PWF and (lastPWF == nil or lastPWF <= GetTime() - 5) then
        for i = 1, #nNova do
          if isPlayer(nNova[i].unit) == true and not isBuffed(nNova[i].unit,{21562,109773,469,90364}) and (UnitInRange(nNova[i].unit) or UnitIsUnit(nNova[i].unit,"player")) then
            if castSpell("player",PWF,true) then lastPWF = GetTime(); return; end
          end
        end
      end
    end

    ------------------------
    -- AutoSpeed Selfbuff --
    ------------------------

    -- Angelic Feather
    if isKnown(AngelicFeather) and options.buttons.Feather==2 then
      if getGround("player") and IsMovingTime(0.2) and not UnitBuffID("player",AngelicFeatherBuff) then
        --if options.isChecked.Feather and getGround("player") and IsMovingTime(0.2) and not UnitBuffID("player",AngelicFeatherBuff) then
        --if useFeather==true and IsMovingTime(0.2) and not UnitBuffID("player",AngelicFeatherBuff) then
        if castGround("player",AngelicFeather,30) then
          SpellStopTargeting();
          return;
        end
      end
    end

    -- Body and Soul
    if isKnown(BodyAndSoul) then
      if options.isChecked.BodyAndSoul then
        if getGround("player") and IsMovingTime(0.75) and not UnitBuffID("player",PWS) and not UnitDebuffID("player",PWSDebuff) then
          if castSpell("player",PWS,true,false) then return; end
        end
      end
    end

    ---------------
    -- IN COMBAT --
    ---------------
    -- AffectingCombat, Pause, Target, Dead/Ghost Check
    if UnitAffectingCombat("player") or UnitAffectingCombat("target") then

      makeEnemiesTable(40)
      -------------------
      -- Dummy Testing --
      -------------------
      if isChecked("DPS Testing") then
        if UnitExists("target") then
          if getCombatTime() >= (tonumber(getValue("DPS Testing"))*60) and isDummy() then
            StopAttack()
            ClearTarget()
            print("____ " .. tonumber(getValue("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped ____")
          end
        end
      end


      --[[-----------------------------------------------------------------------------------------------------------------------------------------------]]
      ----------------
      -- Defensives --
      ----------------
      --ShadowDefensive(options)


      ----------------
      -- Offensives --
      ----------------
      --ShadowCooldowns(options)

      -------------
      -- Healing --
      -------------
      if BadBoy_data["Power"] == 2 then

        -- Penance on Tank
        if options.healing.PenanceTankCheck then
          for i=1, #nNova do
            if (nNova[i].role == "TANK" or UnitGroupRolesAssigned(nNova[i].unit) == "TANK")
              and nNova[i].hp <= options.healing.PenanceTankValue then
              if castSpell(nNova[i].unit,Penance,false,false) then return; end
            end
          end
        end

        -- Penance on Low HP player
        --if options.healing.PenanceCheck then
        for i=1, #nNova do
          if nNova[i].hp <= options.healing.PenanceValue then
            if castSpell(nNova[i].unit,Penance,false,false) then return; end
          end
        end
        --end

        -- Holy Fire / Power Word: Solace
        if (getTalent(3,3) and getSpellCD(PWSol)==0) or (not getTalent(3,3) and getSpellCD(HF)==0) then
          if enemiesTable and enemiesTable[1] ~= nil then
            myTarget = enemiesTable[1].unit
            myDistance = enemiesTable[1].distance

            if UnitExists(myTarget) and UnitCanAttack(myTarget,"player") == true then
              if isKnown(PWSol) then
                if castSpell(mytarget,PWSol,false,false) then return; end
              else
                if castSpell(mytarget,HF,false,false) then return; end
              end
            end
          end
        end

        -- Smite
        if getBuffStacks(Evangelism)<5 or (getBuffStacks(Evangelism)==5 and getBuffRemain("player",Evangelism)<=2*options.player.GCD) then
          if enemiesTable and enemiesTable[1] ~= nil then
            myTarget = enemiesTable[1].unit
            myDistance = enemiesTable[1].distance

            if UnitExists(myTarget) and UnitCanAttack(myTarget,"player") == true then
              if isKnown(PWSol) then
                if castSpell(mytarget,Smite,false,true) then return; end
              end
            end
          end
        end

        -- Clarity of Will (if specced)

        -- Prayer of Mending

      end -- POWER BUTTON ON


      --[[-----------------------------------------------------------------------------------------------------------------------------------------------]]

    end -- AffectingCombat, Pause, Target, Dead/Ghost Check
  end
end
