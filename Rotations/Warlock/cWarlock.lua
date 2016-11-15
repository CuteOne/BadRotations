-- Inherit from: ../cCharacter.lua
-- All Warlock specs inherit from this file
if select(2, UnitClass("player")) == "WARLOCK" then
    cWarlock = {}

    -- Creates Warlock with given specialisation
    function cWarlock:new(spec)
    	local self = cCharacter:new("Warlock")

    	local player = "player" -- if someone forgets ""

	-----------------
    --- VARIABLES ---
    -----------------
    
        self.profile                        = spec
        self.spell.class                	= {}        -- Abilities Available To All Specs in Class
        self.spell.class.abilities      	= {
            darkPact                        = 108416,
            demonicCircle                   = 48018,
            drainLife                       = 689,
            fear                            = 5782,
            grimoireFelhunter               = 111897,
            grimoireImp                     = 111859,
            grimoireSuccubus                = 111896,
            grimoireVoidwalker              = 111895,
            healthFunnel                    = 755,
            lifeTap                         = 1454,
            mortalCoil                      = 6789,
            soulHarvest                     = 196098,
            summonDoomguard                 = 18540,
            summonFelhunter                 = 691,
            summonImp                       = 688,
            summonInfernal                  = 1122,
            summonSuccubus                  = 712,
            summonVoidwalker                = 697,
            unendingResolve                 = 104773,
        }
        self.spell.class.artifacts      	= {        -- Artifact Traits Available To All Specs in Class
            
        }
        self.spell.class.buffs          	= {        -- Buffs Available To All Specs in Class
            demonicSynergy                  = 171982,
            soulHarvest                     = 196098,
        }
        self.spell.class.debuffs        	= {        -- Debuffs Available To All Specs in Class

        }
        self.spell.class.glyphs         	= {        -- Glyphs Available To All Specs in Class

        }
        self.spell.class.talents        	= {        -- Talents Available To All Specs in Class
            burningRush                     = 111400,
            darkPact                        = 108416,
            demonicCircle                   = 48018,
            demonSkin                       = 219272,
            grimoireOfService               = 108501,
            grimoireOfSupremacy             = 152107,
            mortalCoil                      = 6789,
            soulHarvest                     = 196098,
        }

    ------------------
    --- OOC UPDATE ---
    ------------------

		function self.classUpdateOOC()
			-- Call baseUpdateOOC()
			self.baseUpdateOOC()
		end

    --------------
    --- UPDATE ---
    --------------

		function self.classUpdate()
			-- Call baseUpdate()
			self.baseUpdate()
            cFileBuild("class",self)

	        -- Update Energy Regeneration
	        -- self.powerRegen  = getRegen("player")
         --    self.shards = getPowerAlt("player")
		end

	---------------
	--- OPTIONS ---
	---------------

		-- Class options
		-- Options which every Druid should have
		function self.createClassOptions()
            -- Class Wrap
            local section = br.ui:createSection(br.ui.window.profile,  "Class Options", "Nothing")
            br.ui:checkSectionState(section)
		end
       
    ------------------------
    --- CUSTOM FUNCTIONS ---
    ------------------------

        function useAoE()
            local rotation = self.mode.rotation
            if (rotation == 1 and #enemies.yards8 > 1) or rotation == 2 then
                return true
            else
                return false
            end
        end

        function useCDs()
            local cooldown = self.mode.cooldown
            if (cooldown == 1 and isBoss()) or cooldown == 2 then
                return true
            else
                return false
            end
        end

        function useDefensive()
            if self.mode.defensive == 1 then
                return true
            else
                return false
            end
        end

        function useInterrupts()
            if self.mode.interrupt == 1 then
                return true
            else
                return false
            end
        end

    -----------------------------
    --- CALL CREATE FUNCTIONS ---
    -----------------------------
		-- Return
		return self
	end --End function cWarlock:new(spec)
end -- End Select 