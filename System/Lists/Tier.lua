local _, br = ...
if br.lists == nil then
	br.lists = {}
end
br.lists.tier = {
	["T17"] = {
		["DRUID"] = {
			115540, -- chest
			115541, -- hands
			115542, -- head
			115543, -- legs
			115544 -- shoulder
		},
		["DEATHKNIGHT"] = {
			115535, -- legs
			115536, -- shoulder
			115537, -- chest
			115538, -- hands
			115539 -- head
		},
		["DEMONHUNTER"] = {},
		["EVOKER"] = {},
		["HUNTER"] = {
			115545, -- head
			115546, -- legs
			115547, -- shoulder
			115548, -- chest
			115549 -- hands
		},
		["MAGE"] = {
			115550, -- chest
			115551, -- shoulder
			155552, -- hands
			155553, -- head
			155554 -- legs
		},
		["MONK"] = {
			115555, -- hands
			115556, -- head
			115557, -- legs
			115558, -- chest
			115559 -- shoulder
		},
		["PALADIN"] = {
			115565, -- shoulder
			115566, -- chest
			115567, -- hands
			115568, -- head
			115569 -- legs
		},
		["PRIEST"] = {
			115560, -- chest
			115561, -- shoulder
			115562, -- hands
			115563, -- head
			115564 -- legs
		},
		["ROGUE"] = {
			115570, -- chest
			115571, -- hands
			115572, -- head
			115573, -- legs
			115574 -- shoulder
		},
		["SHAMAN"] = {
			115575, -- legs
			115576, -- shoulder
			115577, -- chest
			115578, -- hands
			115579 -- head
		},
		["WARLOCK"] = {
			115585, -- hands
			115586, -- head
			115587, -- legs
			115588, -- chest
			115589 -- shoulder
		},
		["WARRIOR"] = {
			115580, -- legs
			115581, -- shoulder
			115582, -- chest
			115583, -- hands
			115584 -- head
		}
	},
	["T18"] = {
		["DRUID"] = {
			124246, -- chest
			124255, -- hands
			124261, -- head
			124267, -- legs
			124272 -- shoulder
		},
		["DEATHKNIGHT"] = {
			124317, -- chest
			124327, -- hands
			124332, -- head
			124338, -- legs
			124344 -- shoulder
		},
		["DEMONHUNTER"] = {},
		["EVOKER"] = {},
		["HUNTER"] = {
			124284, -- chest
			124292, -- hands
			124296, -- head
			124301, -- legs
			124307 -- shoulder
		},
		["MAGE"] = {
			124171, -- chest
			124154, -- hands
			124160, -- head
			124165, -- legs
			124177 -- shoulder
		},
		["MONK"] = {
			124247, -- chest
			124256, -- hands
			124262, -- head
			124268, -- legs
			124273 -- shoulder
		},
		["PALADIN"] = {
			124318, -- chest
			124328, -- hands
			124333, -- head
			124339, -- legs
			124345 -- shoulder
		},
		["PRIEST"] = {
			124172, -- chest
			124155, -- hands
			124161, -- head
			124166, -- legs
			124178 -- shoulder
		},
		["ROGUE"] = {
			124248, -- chest
			124257, -- hands
			124263, -- head
			124269, -- legs
			124274 -- shoulder
		},
		["SHAMAN"] = {
			124303, -- chest
			124293, -- hands
			124297, -- head
			124302, -- legs
			124308 -- shoulder
		},
		["WARLOCK"] = {
			124173, -- chest
			124156, -- hands
			124162, -- head
			124167, -- legs
			124179 -- shoulder
		},
		["WARRIOR"] = {
			124319, -- chest
			124329, -- hands
			124334, -- head
			124340, -- legs
			124346 -- shoulder
		}
	},
	["T19"] = {
		["DEATHKNIGHT"] = {
			138355, -- head
			138349, -- chest
			138361, -- shoulder
			138352, -- hands
			138358, -- legs
			138364 -- back
		},
		["DEMONHUNTER"] = {
			138378, -- head
			138376, -- chest
			138380, -- shoulder
			138377, -- hands
			138379, -- legs
			138375 -- back
		},
		["DRUID"] = {
			138330, -- head
			138324, -- chest
			138336, -- shoulder
			138327, -- hands
			138333, -- legs
			138366 -- back
		},
		["EVOKER"] = {},
		["HUNTER"] = {
			138342, -- head
			138339, -- chest
			138347, -- shoulder
			138340, -- hands
			138344, -- legs
			138368 -- back
		},
		["MAGE"] = {
			138312, -- head
			138318, -- chest
			138321, -- shoulder
			138309, -- hands
			138315, -- legs
			138365 -- back
		},
		["MONK"] = {
			138331, -- head
			138325, -- chest
			138337, -- shoulder
			138328, -- hands
			138334, -- legs
			138367 -- back
		},
		["PALADIN"] = {
			138356, -- head
			138350, -- chest
			138362, -- shoulder
			138353, -- hands
			138359, -- legs
			138369 -- back
		},
		["PRIEST"] = {
			138313, -- head
			138319, -- chest
			138322, -- shoulder
			138310, -- hands
			138316, -- legs
			138370 -- back
		},
		["ROGUE"] = {
			138332, -- head
			138326, -- chest
			138338, -- shoulder
			138329, -- hands
			138335, -- legs
			138371 -- back
		},
		["SHAMAN"] = {
			138343, -- head
			138346, -- chest
			138348, -- shoulder
			138341, -- hands
			138345, -- legs
			138372 -- back
		},
		["WARLOCK"] = {
			138314, -- head
			138320, -- chest
			138323, -- shoulder
			138311, -- hands
			138317, -- legs
			138373 -- back
		},
		["WARRIOR"] = {
			138357, -- head
			138351, -- chest
			138363, -- shoulder
			138354, -- hands
			138360, -- legs
			138374 -- back
		}
	},
	["T20"] = {
		["DEATHKNIGHT"] = {
			147124, -- head
			147121, -- chest
			147126, -- shoulder
			147123, -- hands
			147125, -- legs
			147122 -- back
		},
		["DEMONHUNTER"] = {
			147130, -- head
			147127, -- chest
			147132, -- shoulder
			147129, -- hands
			147131, -- legs
			147128 -- back
		},
		["DRUID"] = {
			147136, -- head
			147133, -- chest
			147138, -- shoulder
			147135, -- hands
			147137, -- legs
			147134 -- back
		},
		["EVOKER"] = {},
		["HUNTER"] = {
			147142, -- head
			147139, -- chest
			147144, -- shoulder
			147141, -- hands
			147143, -- legs
			147140 -- back
		},
		["MAGE"] = {
			147147, -- head
			147149, -- chest
			147150, -- shoulder
			147146, -- hands
			147148, -- legs
			147145 -- back
		},
		["MONK"] = {
			147154, -- head
			147151, -- chest
			147156, -- shoulder
			147153, -- hands
			147155, -- legs
			147152 -- back
		},
		["PALADIN"] = {
			147160, -- head
			147157, -- chest
			147162, -- shoulder
			147159, -- hands
			147161, -- legs
			147158 -- back
		},
		["PRIEST"] = {
			147165, -- head
			147167, -- chest
			147168, -- shoulder
			147164, -- hands
			147166, -- legs
			147163 -- back
		},
		["ROGUE"] = {
			147172, -- head
			147169, -- chest
			147174, -- shoulder
			147171, -- hands
			147173, -- legs
			147170 -- back
		},
		["SHAMAN"] = {
			147178, -- head
			147175, -- chest
			147180, -- shoulder
			147177, -- hands
			147179, -- legs
			147176 -- back
		},
		["WARLOCK"] = {
			147183, -- head
			147185, -- chest
			147186, -- shoulder
			147182, -- hands
			147184, -- legs
			147181 -- back
		},
		["WARRIOR"] = {
			147190, -- head
			147187, -- chest
			147192, -- shoulder
			147189, -- hands
			147191, -- legs
			147188 -- back
		}
	},
	["T21"] = {
		["DEATHKNIGHT"] = {
			152115, -- head
			152112, -- chest
			152117, -- shoulder
			152114, -- hands
			152116, -- legs
			152113 -- back
		},
		["DEMONHUNTER"] = {
			152121, -- head
			152118, -- chest
			152123, -- shoulder
			152120, -- hands
			152122, -- legs
			152119 -- back
		},
		["DRUID"] = {
			152127, -- head
			152124, -- chest
			152129, -- shoulder
			152126, -- hands
			152128, -- legs
			152125 -- back
		},
		["EVOKER"] = {},
		["HUNTER"] = {
			152133, -- head
			152130, -- chest
			152135, -- shoulder
			152132, -- hands
			152134, -- legs
			152131 -- back
		},
		["MAGE"] = {
			152138, -- head
			152140, -- chest
			152141, -- shoulder
			152137, -- hands
			152139, -- legs
			152136 -- back
		},
		["MONK"] = {
			152145, -- head
			152142, -- chest
			152147, -- shoulder
			152144, -- hands
			152146, -- legs
			152143 -- back
		},
		["PALADIN"] = {
			152151, -- head
			152148, -- chest
			152153, -- shoulder
			152150, -- hands
			152152, -- legs
			152149 -- back
		},
		["PRIEST"] = {
			152156, -- head
			152158, -- chest
			152159, -- shoulder
			152155, -- hands
			152157, -- legs
			152154 -- back
		},
		["ROGUE"] = {
			152163, -- head
			152160, -- chest
			152165, -- shoulder
			152162, -- hands
			152164, -- legs
			152161 -- back
		},
		["SHAMAN"] = {
			152169, -- head
			152166, -- chest
			152171, -- shoulder
			152168, -- hands
			152170, -- legs
			152167 -- back
		},
		["WARLOCK"] = {
			152174, -- head
			152176, -- chest
			152177, -- shoulder
			152173, -- hands
			152175, -- legs
			152172 -- back
		},
		["WARRIOR"] = {
			152181, -- head
			152178, -- chest
			152183, -- shoulder
			152180, -- hands
			152182, -- legs
			152179 -- back
		}
	},
	["T28"] = {
		["DEATHKNIGHT"] = {
		188868, -- head
		188864, -- chest
		188867, -- shoulder
		188863, -- hands
		188866, -- legs
		},
		["DEMONHUNTER"] = {
		188892, -- head
		188894, -- chest
		188896, -- shoulder
		188898, -- hands
		188893, -- legs
		},
		["DRUID"] = {
		188847, -- head
		188849, -- chest
		188851, -- shoulder
		188853, -- hands
		188848, -- legs
		},
		["EVOKER"] = {},
		["HUNTER"] = {
		188859, -- head
		188858, -- chest
		188856, -- shoulder
		188861, -- hands
		188860, -- legs
		},
		["MAGE"] = {
		188844, -- head
		188839, -- chest
		188843, -- shoulder
		188845, -- hands
		188842, -- legs
		},
		["MONK"] = {
		188910, -- head
		188912, -- chest
		188914, -- shoulder
		188916, -- hands
		188911, -- legs
		},
		["PALADIN"] = {
		188933, -- head
		188929, -- chest
		188932, -- shoulder
		188928, -- hands
		188931, -- legs
		},
		["PRIEST"] = {
		188880, -- head
		188875, -- chest
		188879, -- shoulder
		188881, -- hands
		188878, -- legs
		},
		["ROGUE"] = {
		188901, -- head
		188903, -- chest
		188905, -- shoulder
		188907, -- hands
		188902, -- legs
		},
		["SHAMAN"] = {
		188923, -- head
		188922, -- chest
		188920, -- shoulder
		188925, -- hands
		188924, -- legs
		},
		["WARLOCK"] = {
		188889, -- head
		188884, -- chest
		188888, -- shoulder
		188890, -- hands
		188887, -- legs
		},
		["WARRIOR"] = {
		188942, -- head
		188938, -- chest
		188941, -- shoulder
		188937, -- hands
		188940, -- legs
		}
	},
	["T29"] = {
		["DEATHKNIGHT"] = {
			200408, -- head
			200405, -- chest
			200410, -- shoulder
			200407, -- hands
			200409, -- legs
		},
		["DEMONHUNTER"] = {
			200345, -- head
			200342, -- chest
			200347, -- shoulder
			200344, -- hands
			200346, -- legs
		},
		["DRUID"] = {
			200354, -- head
			200351, -- chest
			200356, -- shoulder
			200353, -- hands
			200355, -- legs
		},
		["EVOKER"] = {
			200381, -- head
			200378, -- chest
			200383, -- shoulder
			200380, -- hands
			200382, -- legs
		},
		["HUNTER"] = {
			200390, -- head
			200387, -- chest
			200392, -- shoulder
			200389, -- hands
			200391, -- legs
		},
		["MAGE"] = {
			200318, -- head
			200315, -- chest
			200320, -- shoulder
			200317, -- hands
			200319, -- legs
		},
		["MONK"] = {
			200363, -- head
			200360, -- chest
			200365, -- shoulder
			200362, -- hands
			200364, -- legs
		},
		["PALADIN"] = {
			200417, -- head
			200414, -- chest
			200419, -- shoulder
			200416, -- hands
			200418, -- legs
		},
		["PRIEST"] = {
			200327, -- head
			200324, -- chest
			200329, -- shoulder
			200326, -- hands
			200328, -- legs
		},
		["ROGUE"] = {
			200372, -- head
			200369, -- chest
			200374, -- shoulder
			200371, -- hands
			200373, -- legs
		},
		["SHAMAN"] = {
			200399, -- head
			200396, -- chest
			200401, -- shoulder
			200398, -- hands
			200400, -- legs
		},
		["WARLOCK"] = {
			200336, -- head
			200333, -- chest
			200338, -- shoulder
			200335, -- hands
			200337, -- legs
		},
		["WARRIOR"] = {
			200426, -- head
			200423, -- chest
			200428, -- shoulder
			200425, -- hands
			200427, -- legs
		}
	}
}
