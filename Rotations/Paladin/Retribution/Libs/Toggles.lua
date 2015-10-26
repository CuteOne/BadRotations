if select(3,UnitClass("player")) == 2 then
  function PaladinRetToggles()
    GarbageButtons()

      AoEModes = {
        [1] = {
          mode = "1-2",
          value = 1,
          overlay = "|cffFFFFFFSingle Target Enabled",
          tip = "|cffFF0000Used for \n|cffFFDD11Single Target(1-2).",
          highlight = 0,
          icon = 35395
        },
        [2] = {
          mode = ">2",
          value = 2,
          overlay = "|cffFFBC0BCleave AoE Enabled",
          tip = "|cffFF0000Used for \n|cffFFDD11AoE(>2).",
          highlight = 0,
          icon = 53385
        },
        [3] = {
          mode = "Auto",
          value = 3,
          overlay = "|cff00F900Auto-AoE Enabled",
          tip = "|cffFFDD11Automatic calculations of ennemies.",
          highlight = 1,
          icon = 114158
        }
      }
      CreateButton("AoE",0,1)
    -- Interrupts Button
      InterruptsModes = {
        [1] = {
          mode = "None",
          value = 1 ,
          overlay = "Interrupts Disabled",
          tip = "No Interrupts will be used.",
          highlight = 0,
          icon = [[INTERFACE\ICONS\ability_hibernation]]
        },
        [2] = {
          mode = "Raid",
          value = 2 ,
          overlay = "Interrupts Specific Abilities",
          tip = "Interrupts preset abilities only.",
          highlight = 1,
          icon = [[INTERFACE\ICONS\INV_Misc_Head_Dragon_01.png]]
        },
        [3] = {
          mode = "All",
          value = 3 ,
          overlay = "Interrupt All Abilities",
          tip = "Interrupts everything.",
          highlight = 1,
          icon = 147362
        }
      }
      CreateButton("Interrupts",1,0)
    -- Defensive Button
      DefensiveModes = {
        [1] = {
          mode = "None",
          value = 1 ,
          overlay = "Defensive Disabled",
          tip =  "|cffFF0000Defensive Cooldowns Included: \n|cffFFDD11None.",
          highlight = 0,
          icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]]
        },
        [2] = {
          mode = "User",
          value = 1 ,
          overlay = "Selective Defense Enabled",
          tip = "|cffFF0000Defensive Cooldowns Included: \n|cffFFDD11Config's selected spells.",
          highlight = 0,
          icon = 498
        },
        [3] = {
          mode = "All",
          value = 2 ,
          overlay = "Defensive Enabled",
          tip = "|cffFF0000Defensive Cooldowns Included: |cffFFDD11\nDivine Protection, \nDivine Shield.",
          highlight = 1,
          icon = 642
        }
      }
      CreateButton("Defensive",1,1)
    -- Cooldowns Button
      CooldownsModes = {
        [1] = {
          mode = "None",
          value = 1 ,
          overlay = "Cooldowns Disabled",
          tip = "|cffFF0000Cooldowns Included: \n|cffFFDD11None.",
          highlight = 0,
          icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]]
        },
        [2] = {
          mode = "User",
          value = 2 ,
          overlay = "User Cooldowns Enabled",
          tip = "|cffFF0000Cooldowns Included: \n|cffFFDD11Config's selected spells.",
          highlight = 1,
          icon = 105809
        },
        [3] = {
          mode = "All",
          value = 3 ,
          overlay = "Cooldowns Enabled",
          tip = "|cffFF0000Cooldowns Included: \n|cffFFDD11Avenging Wrath, \nHoly Avenger, \nLight's Hammer, \nExecution Sentence.",
          highlight = 1,
          icon = 31884
        }
      }
      CreateButton("Cooldowns",2,0)
    -- Healing Button
      HealingModes = {
        [1] = {
          mode = "Self",
          value = 1 ,
          overlay = "Heal only Self.",
          tip = "|cffFF0000Healing: |cffFFDD11On self only.",
          highlight = 0,
          icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]]
        },
        [2] = {
          mode = "All",
          value = 2 ,
          overlay = "Heal Everyone.",
          tip = "|cffFF0000Healing: |cffFFDD11Everyone.",
          highlight = 1,
          icon = 19750
        }
      }
      CreateButton("Healing",2,1)
  end
end
