--[[]]     --[[]]   --[[           ]]   --[[           ]]   --[[]]     --[[]]   
--[[ ]]   --[[ ]]   --[[           ]]   --[[           ]]   --[[  ]]   --[[]]   
--[[           ]]   --[[]]     --[[]]   --[[]]     --[[]]   --[[    ]] --[[]]       
--[[           ]]   --[[]]     --[[]]   --[[]]     --[[]]   --[[           ]]   
--[[]]     --[[]]   --[[]]     --[[]]   --[[]]     --[[]]   --[[           ]]   
--[[]]     --[[]]   --[[           ]]   --[[           ]]   --[[]]   --[[  ]]   
--[[]]     --[[]]   --[[           ]]   --[[           ]]   --[[]]     --[[]]   
 
--[[           ]]         --[[]]        --[[           ]]
--[[           ]]        --[[  ]]       --[[           ]]
--[[]]                  --[[    ]]           --[[ ]]    
--[[]]                 --[[      ]]          --[[ ]]    
--[[]]                --[[        ]]         --[[ ]]    
--[[           ]]    --[[]]    --[[]]        --[[ ]]        
--[[           ]]   --[[]]      --[[]]       --[[ ]]    

--[[This function will create a Value Box.]]
-- function CreateNewBox(value,textString,minValue,maxValue,step,base,tip1)

--[[This function will create a Check Box.]]
-- function CreateNewCheck(value, textString, tip1)

--[[This function will create a Menu, up to 10 values can be passed.]]
-- function CreateNewDrop(value, textString, base, tip1, value1, value2, value3, value4, value5, value6, value7, value8, value9, value10)

--[[This function will create the TextString.
This function must always be last, it will increase table row.]]
-- function CreateNewText(value, textString)

--[[This function will create the Title String.
This function will use table row #1.]]
-- function CreateNewTitle(value, textString)

function titleOp(string)
    return CreateNewTitle(thisConfig,string);
end
function checkOp(string,tip)
    if tip == nil then
        return CreateNewCheck(thisConfig,string);
    else
        return CreateNewCheck(thisConfig,string,tip);
    end
end
function textOp(string)
    return CreateNewText(thisConfig,string);
end
function boxOp(string, minnum, maxnum, stepnum, defaultnum, tip)
    if tip == nil then
        return CreateNewBox(thisConfig,string, minnum, maxnum, stepnum, defaultnum);
    else
        return CreateNewBox(thisConfig,string, minnum, maxnum, stepnum, defaultnum, tip);
    end
end
function dropOp(string, base, tip1, value1, value2, value3, value4, value5, value6, value7, value8, value9, value10)
    return CreateNewDrop(thisConfig,string, base, tip1, value1, value2, value3, value4, value5, value6, value7, value8, value9, value10);
end

-- Config Panel
function FeralCatConfig()
    --if not doneConfig then
        thisConfig = 0
        -- Title
        titleOp("CuteOne Feral Cat");
                -- Spacer
        textOp(" ");
        CreateNewWrap(thisConfig,"--- General ---");

            -- Death Cat
            checkOp("Death Cat Mode","|cffFF0000I like kitties");
            textOp("Death Cat Mode");

            -- Mark Of The Wild
            checkOp("Mark of the Wild");
            textOp(tostring(select(1,GetSpellInfo(mow))));

            -- Dummy DPS Test
            checkOp("DPS Testing");
            boxOp("DPS Testing", 5, 60, 5, 5, "|cffFFFFFFSet to desired time for test in minuts.")
            textOp("DPS Testing");

        -- Spacer
        textOp(" ");
        textOp("--- Cooldowns ---");

            -- Agi Pot
            checkOp("Agi-Pot");
            textOp("Agi-Pot");

            -- Flask / Crystal
            checkOp("Flask / Crystal");
            textOp("Flask / Crystal");
        
        -- Spacer
        textOp(" ");
        textOp("--- Defensive ---");

            -- Healthstone
            checkOp("Pot/Stoned");
            boxOp("Pot/Stoned", 0, 100, 5, 60);
            textOp("Pot/Stoned");

            -- Barkskin
            checkOp("Barkskin");
            boxOp("Barkskin", 0, 100, 5, 50);
            textOp(tostring(select(1,GetSpellInfo(bar))));

            -- Survival Instincts
            checkOp("Survival Instincts");
            boxOp("Survival Instincts", 0, 100, 5, 40);
            textOp(tostring(select(1,GetSpellInfo(si))));

            -- Frenzied Regeneration
            checkOp("Frenzied Regen");
             boxOp("Frenzied Regen", 0, 100, 5, 30);
            textOp(tostring(select(1,GetSpellInfo(fr))));

        -- Spacer --
        textOp(" ");
        textOp("--- Interrupts ---");

            -- Skull Bash
            checkOp("Skull Bash")
            textOp(tostring(select(1,GetSpellInfo(sb))))

            -- Mighty Bash
            checkOp("Mighty Bash")
            textOp(tostring(select(1,GetSpellInfo(mb))))

            -- Maim
            checkOp("Maim")
            textOp(tostring(select(1,GetSpellInfo(ma))))


            -- Standard Interrupt
            checkOp("Interrupts");
            boxOp("Interrupts", 5, 95, 5, 0);
            textOp("Interrupt At");

        -- Spacer
        textOp(" ");
        textOp("--- Utilities ---");

            -- PokeRotation
            checkOp("PokeRotation");
            textOp("PokeRotation");

            -- Debug
            checkOp("Debug");
            textOp("Debug");

            -- AoE Toggle
            checkOp("AoE Toggle");
            dropOp("AoE Toggle", 1, "Toggle")
            textOp("AoE Toggle");

       -- Bound
        CreateNewBound(thisConfig,"End"); 

        doneConfig = true;
        WrapsManager();
    --end
end


--[[           ]]   --[[           ]]   --[[           ]]   --[[           ]]   --[[           ]]
--[[           ]]   --[[           ]]   --[[           ]]   --[[           ]]   --[[           ]]
--[[]]     --[[]]   --[[]]              --[[]]                   --[[ ]]        --[[]]     --[[]]
--[[           ]]   --[[           ]]   --[[           ]]        --[[ ]]        --[[]]     --[[]]
--[[        ]]      --[[]]                         --[[]]        --[[ ]]        --[[]]     --[[]]
--[[]]    --[[]]    --[[           ]]   --[[           ]]        --[[ ]]        --[[           ]]
--[[]]     --[[]]   --[[           ]]   --[[           ]]        --[[ ]]        --[[           ]]
