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
dropOptions.AlwaysCdNever = { "|cff00FF00Always", "|cffFFFF00Cooldowns", "|cffFF0000Never" }
dropOptions.AlwaysCdAoeNever = { "|cff00FF00Always", "|cff008000AOE", "|cffffff00AOE/CD", "|cff0000ffCD", "|cffff0000Never" }