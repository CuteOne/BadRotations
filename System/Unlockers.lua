if FH and not EWT then
	IsHackEnabled = HackEnabled
	SetHackEnabled = HackEnabled
	ObjectTypes = ObjectType
	ObjectExists = ObjectIsVisible
elseif EWT then
	IsHackEnabled = IsHackEnabled
	SetHackEnabled = SetHackEnabled
	ObjectTypes = ObjectTypes
	ObjectExists = ObjectExists
end
