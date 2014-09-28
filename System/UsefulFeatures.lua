function UsefulFeatures() 
    if isChecked("Fly Hack") and GetFlyHack() == false then SetFlyHack(true) end
    if not isChecked("Fly Hack") and GetFlyHack() == true then SetFlyHack(false) end
    if isChecked("Hover Hack") and GetHoverHack() == false then SetHoverHack(true) end
    if not isChecked("Hover Hack") and GetHoverHack() == true then SetHoverHack(false) end
    if isChecked("Water Walking") and GetWaterWalkHack() == false then SetWaterWalkHack(true) end
    if not isChecked("Water Walking") and GetWaterWalkHack() == true then SetWaterWalkHack(false) end
    if isChecked("Climb Hack") and GetWaterWalkHack() == false then SetWaterWalkHack(true) end
    if not isChecked("Climb Hack") and GetWaterWalkHack() == true then SetWaterWalkHack(false) end
    --[[Trackings]]
    -- Friends
    if isChecked("Friends") and GetTrackingState("Friends") == false then SetTrackingState("Friends",true) end 
    if not isChecked("Friends") and GetTrackingState("Friends") == true then SetTrackingState("Friends",false) end
    -- Neutral
    if isChecked("Neutral") and GetTrackingState("Neutral") == false then SetTrackingState("Neutral",true) end 
    if not isChecked("Neutral") and GetTrackingState("Neutral") == true then SetTrackingState("Neutral",false) end
    -- Enemies
    if isChecked("Enemies") and GetTrackingState("Enemies") == false then SetTrackingState("Enemies",true) end 
    if not isChecked("Enemies") and GetTrackingState("Enemies") == true then SetTrackingState("Enemies",false) end 
    -- Players 
    if isChecked("Players") and GetTrackingState("Players") == false then SetTrackingState("Players",true) end 
    if not isChecked("Players") and GetTrackingState("Players") == true then SetTrackingState("Players",false) end 
    -- FriendlyPlayers 
    if isChecked("FriendlyPlayers") and GetTrackingState("FriendlyPlayers") == false then SetTrackingState("FriendlyPlayers",true) end 
    if not isChecked("FriendlyPlayers") and GetTrackingState("FriendlyPlayers") == true then SetTrackingState("FriendlyPlayers",false) end 
    -- EnemyPlayers 
    if isChecked("EnemyPlayers") and GetTrackingState("EnemyPlayers") == false then SetTrackingState("EnemyPlayers",true) end 
    if not isChecked("EnemyPlayers") and GetTrackingState("EnemyPlayers") == true then SetTrackingState("EnemyPlayers",false) end 
    -- Rares 
    if isChecked("Rares") and GetTrackingState("Rares") == false then SetTrackingState("Rares",true) end 
    if not isChecked("Rares") and GetTrackingState("Rares") == true then SetTrackingState("Rares",false) end 
    -- Objects 
    if isChecked("Objects") and GetTrackingState("Objects") == false then SetTrackingState("Objects",true) end 
    if not isChecked("Objects") and GetTrackingState("Objects") == true then SetTrackingState("Objects",false) end 
    -- Moving
    if isChecked("Moving") and GetTrackingState("Moving") == false then SetTrackingState("Moving",true) end 
    if not isChecked("Moving") and GetTrackingState("Moving") == true then SetTrackingState("Moving",false) end 
    -- Attackable
    if isChecked("Attackable") and GetTrackingState("Attackable") == false then SetTrackingState("Attackable",true) end 
    if not isChecked("Attackable") and GetTrackingState("Attackable") == true then SetTrackingState("Attackable",false) end 
    -- Chests
    if isChecked("Chests") and GetTrackingState("Chests") == false then SetTrackingState("Chests",true) end 
    if not isChecked("Chests") and GetTrackingState("Chests") == true then SetTrackingState("Chests",false) end 
end