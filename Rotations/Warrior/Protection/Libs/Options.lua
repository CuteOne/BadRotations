if select(3, UnitClass("player")) == 1 
and GetSpecialization() == 3 then



function WarriorProtConfig()
if currentConfig ~= "Protection Chumii" then
ClearConfig();
thisConfig = 0;
-- Title
CreateNewTitle(thisConfig,"Protection |cffFF0000Chumii");

--Wrapper
CreateNewWrap(thisConfig,"---------- Mode ---------")
-- Rotation
CreateNewDrop(thisConfig, "Gladiator / Protection", 1, "Choose Rotation to use.", "|cffFFBB00Gladiator", "|cff0077FFProtection");
CreateNewText(thisConfig, "Gladiator / Protection");
-- Wrapper
CreateNewWrap(thisConfig,"---------- Keys ----------");

-- Pause Toggle
CreateNewCheck(thisConfig,"Pause Key");
CreateNewDrop(thisConfig,"Pause Key", 4, "Toggle")
CreateNewText(thisConfig,"Pause Key");

-- Heroic Leap
CreateNewCheck(thisConfig,"Heroic Leap Key");
CreateNewDrop(thisConfig,"Heroic Leap Key", 2, "Toggle2")
CreateNewText(thisConfig,"Heroic Leap Key");

-- Mocking Banner
CreateNewCheck(thisConfig,"Mocking Banner Key");
CreateNewDrop(thisConfig,"Mocking Banner Key", 7, "Toggle2")
CreateNewText(thisConfig,"Mocking Banner Key");

-- Wrapper
CreateNewWrap(thisConfig,"---------- Buffs ---------");

-- Shout
CreateNewCheck(thisConfig,"Shout");
CreateNewDrop(thisConfig, "Shout", 1, "Choose Shout to use.", "|cffFFBB00Command", "|cff0077FFBattle")
CreateNewText(thisConfig,"Shout");

-- Wrapper
CreateNewWrap(thisConfig,"------ Cooldowns ------");

-- Avatar
CreateNewCheck(thisConfig,"Avatar");
CreateNewText(thisConfig,"Avatar");

-- Racial
CreateNewCheck(thisConfig,"Racial (Orc / Troll)");
CreateNewText(thisConfig,"Racial (Orc / Troll)");

-- Wrapper
CreateNewWrap(thisConfig,"------- Defensive ------");

-- Shield Block / Barrier
CreateNewDrop(thisConfig, "Block or Barrier", 1, "Use Shield Block or Shield Barrier", "|cffFFBB00Block", "|cff0077FFBarrier")
CreateNewText(thisConfig,"Block or Barrier");

-- Last Stand
CreateNewCheck(thisConfig,"Last Stand");
CreateNewBox(thisConfig, "Last Stand", 0, 100  , 5, 40, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFLast Stand");
CreateNewText(thisConfig,"Last Stand");

-- Shield Wall
CreateNewCheck(thisConfig,"Shield Wall");
CreateNewBox(thisConfig, "Shield Wall", 0, 100  , 5, 25, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFShield Wall");
CreateNewText(thisConfig,"Shield Wall");

-- Enraged Regeneration
CreateNewCheck(thisConfig,"Enraged Regeneration");
CreateNewBox(thisConfig, "Enraged Regeneration", 0, 100  , 5, 25, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFEnraged Regeneration");
CreateNewText(thisConfig,"Enraged Regeneration");

-- ImpendingVictory/Victory Rush
CreateNewCheck(thisConfig,"Impending Victory");
CreateNewBox(thisConfig, "Impending Victory", 0, 100  , 5, 40, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFImpending Victory (Victory Rush)");
CreateNewText(thisConfig,"Impending Victory");

-- Healthstone
CreateNewCheck(thisConfig,"Healthstone");
CreateNewBox(thisConfig, "Healthstone", 0, 100  , 5, 25, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFHealthstone");
CreateNewText(thisConfig,"Healthstone");

-- Safeguard Focus
CreateNewCheck(thisConfig,"Safeguard at Focus");
CreateNewBox(thisConfig, "Safeguard at Focus", 0, 100  , 5, 25, "% HP of Focustarget to Safeguard at Focustarget");
CreateNewText(thisConfig,"Safeguard at Focus");

-- Vigilance Focus
CreateNewCheck(thisConfig,"Vigilance on Focus");
CreateNewBox(thisConfig, "Vigilance on Focus", 0, 100  , 5, 25, "% HP of Focustarget to use Vigilance on Focustarget");
CreateNewText(thisConfig,"Vigilance on Focus");

-- -- Wrapper
-- CreateNewWrap(thisConfig,"-------- Interrupts --------");

-- -- Pummel
-- CreateNewCheck(thisConfig,"Pummel");
-- CreateNewBox(thisConfig, "Pummel", 0, 100  , 5, 60 , "|cffFFBB00Over what % of cast we want to \n|cffFFFFFFPummel.");
-- CreateNewText(thisConfig,"Pummel");

-- -- Disrupting Shout
-- CreateNewCheck(thisConfig,"Disrupting Shout");
-- CreateNewBox(thisConfig, "Disrupting Shout", 0, 100  , 5, 60 , "|cffFFBB00Over what % of cast we want to \n|cffFFFFFFDisrupting Shout.");
-- CreateNewText(thisConfig,"Disrupting Shout");

-- if isKnown(QuakingPalm) then
-- -- Quaking Palm
-- CreateNewCheck(thisConfig,"Quaking Palm");
-- CreateNewBox(thisConfig, "Quaking Palm", 0, 100  , 5, 30 , "|cffFFBB00Over what % of cast we want to \n|cffFFFFFFQuaking Palm.");
-- CreateNewText(thisConfig,"Quaking Palm");
-- end

-- Wrapper
CreateNewWrap(thisConfig,"---------- AoE Talents  ---------");

-- Auto Bladestorm / DragonRoar / Ravager
CreateNewCheck(thisConfig,"Auto Bladestorm","Use Bladestorm automatically");
CreateNewText(thisConfig,"Auto Bladestorm");

CreateNewCheck(thisConfig,"Auto Dragon Roar","Use Dragon Roar automatically");
CreateNewText(thisConfig,"Auto Dragon Roar");

CreateNewCheck(thisConfig,"Auto Ravager","Use Ravager automatically");
CreateNewText(thisConfig,"Auto Ravager");

-- Dummy DPS Test
CreateNewCheck(thisConfig,"DPS Testing");
CreateNewBox(thisConfig,"DPS Testing", 1, 15, 1, 5, "Set to desired time for test in minutes. Min: 1 / Max: 15 / Interval: 1");
CreateNewText(thisConfig,"DPS Testing");

CreateGeneralsConfig();
WrapsManager();
end
end
end
