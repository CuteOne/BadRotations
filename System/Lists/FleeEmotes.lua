local _, br = ...
if br.lists == nil then br.lists = {} end
-- The game's flee emote (BroadcastText 1150, TrinityCore BROADCAST_TEXT_FLEE_FOR_ASSIST): a mob at
-- low health "attempts to run away in fear!". CHAT_MSG_MONSTER_EMOTE carries this template (with %s
-- for the name) and the mob's GUID, so unit:isFleeing can tell a real flee from a mob moving away.
-- Male and female forms; texts from AzerothCore's broadcast_text(_locale) data (the 3.3.5 client's).
-- itIT and ptBR aren't known yet: BRMelee.log records the emote texts seen in fights.
br.lists.fleeEmotes = {
	["%s attempts to run away in fear!"] = true,                                   -- enUS / enGB
	["%s versucht zu flüchten!"] = true,                                           -- deDE
	["¡%s intenta huir despavorido!"] = true,                                      -- esES / esMX
	["¡%s intenta huir despavorida!"] = true,
	["%s essaie de s'enfuir dans un moment de panique !"] = true,                  -- frFR
	["%s|1이;가; 겁을 먹고 도망치려고 합니다!"] = true,                               -- koKR
	["%s в панике пытается бежать!"] = true,                                        -- ruRU
	["%s充满恐惧地想要转身逃跑！"] = true,                                             -- zhCN
	["%s充滿恐懼地想要轉身逃跑!"] = true,                                              -- zhTW
}
