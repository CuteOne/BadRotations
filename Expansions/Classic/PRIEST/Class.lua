local _, br = ...
br.lists.spells.PRIEST = br.lists.spells.PRIEST or {}
br.lists.spells.PRIEST.Shared = {
            abilities = {
                desperatePrayer    = {13908, 19236, 19238, 19240, 19241, 19242, 19243}, -- Ranks 1-7
                cureDisease        = 528,
                dispelMagic        = {527, 988}, -- Ranks 1-2
                fade               = {586, 9578, 9579, 9592, 10941, 10942}, -- Ranks 1-6
                flashHeal          = {2061, 9472, 9473, 9474, 10915, 10916, 10917}, -- Ranks 1-7
                levitate           = 1706,
                mindBlast          = {8092, 8102, 8103, 8104, 8105, 8106, 10945, 10946, 10947}, -- Ranks 1-9
                mindControl        = {605, 10911, 10912}, -- Ranks 1-3
                mindSoothe         = {453, 8192, 10953}, -- Ranks 1-3
                mindVision         = {2096, 10909}, -- Ranks 1-2
                powerInfusion      = 10060,
                powerWordFortitude = {1243, 1244, 1245, 2791, 10937, 10938}, -- Ranks 1-6
                prayerOfFortitude  = {21562, 21564}, -- Ranks 1-2
                powerWordShield    = {17, 592, 600, 3747, 6065, 6066, 10898, 10899, 10900, 10901}, -- Ranks 1-10
                psychicScream      = {8122, 8124, 10888, 10890}, -- Ranks 1-4
                resurrection       = {2006, 2010, 10880, 10881, 20770}, -- Ranks 1-5
                shackleUndead      = {9484, 9485, 10955}, -- Ranks 1-3
                shadowWordPain     = {589, 594, 970, 992, 2767, 10892, 10893, 10894}, -- Ranks 1-8
                smite              = {585, 591, 598, 984, 1004, 6060, 10933, 10934}, -- Ranks 1-8
            },
            buffs     = {
                levitate           = 1706,
                powerWordFortitude = {1243, 1244, 1245, 2791, 10937, 10938}, -- Ranks 1-6
                powerWordShield    = {17, 592, 600, 3747, 6065, 6066, 10898, 10899, 10900, 10901}, -- Ranks 1-10
                prayerOfFortitude  = {21562, 21564}, -- Ranks 1-2
            },
            debuffs   = {
                shadowWordPain = {589, 594, 970, 992, 2767, 10892, 10893, 10894}, -- Ranks 1-8
                weakenedSoul   = 6788,
            },
            glyphs    = {

            },
            talents   = {

            },
        }
