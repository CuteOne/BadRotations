if br.lists == nil then
	br.lists = {}
end
-- Crowd Control Units = list of units to stun, either always or udner certain condition such as having a buff or wirldwinding etc
br.lists.dispell = {
	--[164257] = "Enrage", -- ogres gorgrond
	-- Auchindon
	[160312] = "Magic",-- Void Shell
	-- UBRS
	[153909] = "Enrage",-- Frenzy
	[161203] = "Magic",-- Rejuvenating Serum
	[81173] = "Enrage",-- Frenzy
	--61574,-- Banner of the horde (dummy buff just to test)
	-- lib dispel
	[8599] = "Enrage",[12880] = "Enrage",[15061] = "Enrage",[15716] = "Enrage",[18499] = "Enrage",
	[18501] = "Enrage",[19451] = "Enrage",[19812] = "Enrage",[22428] = "Enrage",[23128] = "Enrage",
	[23257] = "Enrage",[23342] = "Enrage",[24689] = "Enrage",[26041] = "Enrage",[26051] = "Enrage",
	[28371] = "Enrage",[30485] = "Enrage",[31540] = "Enrage",[31915] = "Enrage",[32714] = "Enrage",
	[33958] = "Enrage",[34670] = "Enrage",[37605] = "Enrage",[37648] = "Enrage",[37975] = "Enrage",
	[38046] = "Enrage",[38166] = "Enrage",[38664] = "Enrage",[39031] = "Enrage",[39575] = "Enrage",
	[40076] = "Enrage",[41254] = "Enrage",[41447] = "Enrage",[42705] = "Enrage",[42745] = "Enrage",
	[43139] = "Enrage",[47399] = "Enrage",[48138] = "Enrage",[48142] = "Enrage",[48193] = "Enrage",
	[50420] = "Enrage",[51513] = "Enrage",[52262] = "Enrage",[52470] = "Enrage",[54427] = "Enrage",
	[55285] = "Enrage",[56646] = "Enrage",[57733] = "Enrage",[58942] = "Enrage",[59465] = "Enrage",
	[59697] = "Enrage",[59707] = "Enrage",[59828] = "Enrage",[60075] = "Enrage",[61369] = "Enrage",
	[63227] = "Enrage",[66092] = "Enrage",[68541] = "Enrage",[70371] = "Enrage",[72143] = "Enrage",
	[75998] = "Enrage",[76100] = "Enrage",[76862] = "Enrage",[77238] = "Enrage",[78722] = "Enrage",
	[78943] = "Enrage",[80084] = "Enrage",[80467] = "Enrage",[86736] = "Enrage",[102134] = "Enrage",
	[102989] = "Enrage",[106925] = "Enrage",[108169] = "Enrage",[109889] = "Enrage",[111220] = "Enrage",
	[115430] = "Enrage",[117837] = "Enrage",[119629] = "Enrage",[123936] = "Enrage",[124019] = "Enrage",
	[124309] = "Enrage",[126370] = "Enrage",[127823] = "Enrage",[127955] = "Enrage",[128231] = "Enrage",
	[129016] = "Enrage",[129874] = "Enrage",[130196] = "Enrage",[130202] = "Enrage",[131150] = "Enrage",
	[135524] = "Enrage",[135548] = "Enrage",[142760] = "Enrage",[148295] = "Enrage",[151553] = "Enrage",
	[154017] = "Enrage",[155620] = "Enrage",[164324] = "Enrage",[164835] = "Enrage",[175743] = "Enrage",
	[144351] = "Magic",[333227] = "Undying Rage",[326450] = "Loyal Beasts",[320012] = "Unholy Frenzy",
	[333241] = "Raging Tantrum"
}