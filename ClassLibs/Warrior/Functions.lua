if select(3, UnitClass("player")) == 1 then
	
	  --[[]]		--[[           ]]	--[[]]     --[[]] 	--[[           ]]
     --[[  ]]		--[[           ]]	--[[ ]]   --[[ ]]	--[[           ]]
    --[[    ]] 		--[[]]	   --[[]]	--[[           ]]	--[[]]
   --[[      ]] 	--[[         ]]		--[[           ]] 	--[[           ]]
  --[[        ]]	--[[        ]]		--[[]] 	   --[[]]			   --[[]]
 --[[]]    --[[]]	--[[]]	  --[[]]	--[[]] 	   --[[]]	--[[           ]]	
--[[]]      --[[]]	--[[]]	   --[[]]	--[[]] 	   --[[]]	--[[           ]]

-------------------------------------
--- Evil Eye CD Reduction Trinket ---
-------------------------------------
function EvilEye()
  if CD_Trinket == nil then
  
    if (GetInventoryItemID("player", 13) == 105491
      or GetInventoryItemID("player", 14) == 105491) then -- heroic warforged 47%
        CD_Reduction_Value = (1 / 1.47)
        CD_Trinket = true
        
    elseif (GetInventoryItemID("player", 13) == 104495 -- heroic 44%
      or GetInventoryItemID("player", 14) == 104495) then
        CD_Reduction_Value = (1 / 1.44)
        CD_Trinket = true
      
    elseif (GetInventoryItemID("player", 13) == 105242 -- warforged 41%
      or GetInventoryItemID("player", 14) == 105242) then
        CD_Reduction_Value = (1 / 1.41)
        CD_Trinket = true
    
    elseif (GetInventoryItemID("player", 13) == 102298  -- normal 39%
      or GetInventoryItemID("player", 14) == 102298) then
        CD_Reduction_Value = (1 / 1.39)
        CD_Trinket = true
    
    elseif (GetInventoryItemID("player", 13) == 104744 -- flex 34%
      or GetInventoryItemID("player", 14) == 104744) then
        CD_Reduction_Value = (1 / 1.34)
        CD_Trinket = true
    
    elseif (GetInventoryItemID("player", 13) == 104993  -- lfr 31%
      or GetInventoryItemID("player", 14) == 104993) then
        CD_Reduction_Value = (1 / 1.31)
        CD_Trinket = true
    end
  
    if CD_Trinket ~= true then
      CD_Trinket = false
      CD_Reduction_Value = 1
    end
  end
end

--[[           ]]	--[[]]	   --[[]]	--[[           ]]	--[[]]	  --[[]]
--[[           ]]	--[[]]	   --[[]]	--[[           ]]	--[[]]	  --[[]]
--[[]] 				--[[]]	   --[[]]	--[[]]	   --[[]]	   --[[    ]]	
--[[           ]]	--[[]]	   --[[]]	--[[         ]]		   --[[    ]]	
--[[           ]]	--[[]]	   --[[]]	--[[        ]]			 --[[]]
--[[]] 				--[[           ]]	--[[]]	  --[[]]		 --[[]]	
--[[]]      		--[[           ]]	--[[]]		--[[]]		 --[[]]

--[[           ]]	--[[           ]]	--[[           ]] 	--[[           ]]
--[[           ]]	--[[           ]]	--[[           ]] 	--[[           ]]
--[[]]	   --[[]]	--[[]]	   --[[]]	--[[]]	   --[[]]		 --[[ ]]
--[[         ]]		--[[         ]]	    --[[]]	   --[[]]		 --[[ ]]
--[[       ]]		--[[        ]]		--[[]]	   --[[]]		 --[[ ]]
--[[]]				--[[]]	  --[[]]	--[[           ]]	 	 --[[ ]]		
--[[]] 				--[[]]	   --[[]]	--[[           ]]		 --[[ ]]	

--[[           ]]	--[[]]	   --[[]]	--[[]]	   --[[]]	--[[   		   ]]	--[[   		   ]]	--[[   		   ]]	--[[           ]]	--[[]]	   --[[]]
--[[           ]]	--[[]]	   --[[]]	--[[  ]]   --[[]]	--[[   		   ]]	--[[   		   ]]	--[[   		   ]]	--[[           ]]	--[[  ]]   --[[]]
--[[]]				--[[]]	   --[[]]	--[[    ]] --[[]]   --[[]]					 --[[ ]]			 --[[ ]]		--[[]]	   --[[]]	--[[    ]] --[[]]
--[[           ]]	--[[]]	   --[[]]	--[[           ]]	--[[]]					 --[[ ]]			 --[[ ]]		--[[]]	   --[[]]	--[[           ]]
--[[           ]]	--[[]]	   --[[]]	--[[   		   ]]	--[[]]					 --[[ ]]			 --[[ ]]		--[[]]	   --[[]]	--[[   		   ]]
--[[]]	   			--[[           ]]	--[[]]	 --[[  ]]	--[[   		   ]]		 --[[ ]]		--[[   		   ]]	--[[           ]]	--[[]]	 --[[  ]]
--[[]]	   			--[[           ]]	--[[]]	   --[[]]	--[[   		   ]]		 --[[ ]]		--[[   		   ]]	--[[           ]]	--[[]]	   --[[]]

end
