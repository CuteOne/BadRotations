local _, br = ...
---@class br.functions.action
br.functions.action = br.functions.action or {}
local action = br.functions.action

function action:canFly()
	return br.game.IsOutdoors() and br.game.IsFlyableArea()
end
