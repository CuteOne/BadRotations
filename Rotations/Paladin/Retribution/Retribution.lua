if select(3, UnitClass("player")) == 2 then
	function PaladinRetribution()
	if retPaladin == nil then --Where is currentConfig set? Is this only used for init?
        retPaladin = cRetribution:new()
        setmetatable(retPaladin, {__index = cRetribution})

		retPaladin:update()
	end

	-- ToDo add pause toggle
	-- Manual Input
	if IsLeftShiftKeyDown() then -- Pause the script, keybind in wow shift+1 etc for manual cast
		return true
	end
	if IsLeftControlKeyDown() then -- Pause the script, keybind in wow ctrl+1 etc for manual cast
		return true
	end
	if IsLeftAltKeyDown() then
		return true
	end

	retPaladin:update()

	end
end
