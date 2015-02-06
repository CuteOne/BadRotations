if select(3,UnitClass("player")) == 2 then
  -- here we will store the functions that we want to have on multiple specs/profiles

  -- Common blessing selector(all specs)
  function castBlessing()
    -- if ability is selected
    if isChecked("Blessings") then
      -- if we just logged or reloaded, we dont want to spam cast it instantly so we define a timer
      if timerBlessing == nil then
        timerBlessing = GetTime()
      end
      if timerBlessing < GetTime() - 5 then
        doBlessings = true
      end
      if doBlessings ~= nil then
        -- after timer we find if we have other buffers in group via findBestBlessing
        local myBlessing = findBestBlessing()
        for i = 1,#nNova do
          local thisUnit = nNova[i]
          if thisUnit.hp < 250 and thisUnit.isPlayer and not UnitBuffID(thisUnit.unit,myBlessing) then
            if castSpell("player",myBlessing,true,false) then
              timerBlessing = GetTime() + random(10,20)
              doBlessings = nil
              return
            end
          end
        end
      end
    end
  end

  function findBestBlessing()
    local modeBlessing = getValue("Blessings")
    local myBlessing = _BlessingOfKings
    -- if 3 and king buffer found buff might
    if modeBlessing == 3 then
      -- if theres a druide or monk or paladin, we do might.
      for i = 1, #nNova do
        local thisUnit = nNova[i]
        -- i think only these 3 class buff kings
        local MemberClass = nNova[i].class
        if not UnitIsUnit("player",thisUnit.unit) and thisUnit.hp < 250 and thisUnit.isPlayer and
          (thisUnit.class == "DRUID" or thisUnit.class == "MONK" or thisUnit.class == "PALADIN") then
          myBlessing = _BlessingOfMight
          break
        end
      end
      -- if user selected a specific blessing we do it, if 2 selected, buff might, otherwise(1) buff kings
    elseif modeBlessing == 2 then
      myBlessing = _BlessingOfMight
    end
    return myBlessing
  end
end

