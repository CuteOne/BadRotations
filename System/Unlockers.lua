if FH and not EWT then
	IsHackEnabled = HackEnabled
	SetHackEnabled = HackEnabled
	ObjectTypes = ObjectType
	ObjectExists = ObjectIsVisible
elseif EWT and EasyWoWToolbox ~= nil then
	IsHackEnabled = IsHackEnabled
	SetHackEnabled = SetHackEnabled
	ObjectTypes = ObjectTypes
	ObjectExists = ObjectExists
elseif EWT and EasyWoWToolbox == nil then
	IsHackEnabled = IsHackEnabled
	SetHackEnabled = SetHackEnabled
	ObjectTypes = ObjectTypes
	ObjectExists = ObjectExists
	ObjectIsUnit = UnitIsUnit
	ObjectIsVisible = UnitIsVisible
end
