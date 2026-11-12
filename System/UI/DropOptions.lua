local _, br = ...
br.ui.dropOptions = br.ui.dropOptions or {}
local dropOptions = br.ui.dropOptions

dropOptions.Toggle = {
	"LeftCtrl",
	"LeftShift",
	"RightCtrl",
	"RightShift",
	"RightAlt",
	"None",
	"MMouse",
	"Mouse4",
	"Mouse5"
}
-- Who a helpful spell may go on (units.castOn): you always come first, then the unit the choice adds.
-- Same order as the old Player/Target/Mouseover/Focus/Group choices, so saved settings keep their meaning.
dropOptions.CastOn = { "You", "You + Target", "You + Mouseover", "You + Focus", "You + Group" }
dropOptions.AlwaysCdNever ={ "|cff00FF00Always", "|cffFFFF00Cooldowns", "|cffFF0000Never" }
dropOptions.AlwaysCdAoeNever = { "|cff00FF00Always", "|cff008000AOE", "|cffffff00AOE/CD", "|cff0000ffCD", "|cffff0000Never" }