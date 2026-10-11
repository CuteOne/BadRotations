local _, br = ...
---@class br.functions.action
br.functions.action = br.functions.action or {}
local action = br.functions.action

function action:canFly()
	return br._G.IsOutdoors() and br._G.IsFlyableArea()
end
