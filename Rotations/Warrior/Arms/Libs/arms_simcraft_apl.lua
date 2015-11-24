29.10.2015

warrior="Warrior_Arms_T18M"
level=100
race=blood_elf
role=attack
position=back
talents=0011022
talent_override=bladestorm,if=raid_event.adds.count>=1|enemies>1
talent_override=dragon_roar,if=raid_event.adds.count>=1|enemies>1
talent_override=taste_for_blood,if=raid_event.adds.count>=1|enemies>1
talent_override=ravager,if=raid_event.adds.cooldown>=60&raid_event.adds.exists
glyphs=unending_rage/bull_rush/sweeping_strikes
spec=arms

# Executed before combat begins. Accepts non-harmful actions only.

actions.precombat=flask,type=greater_draenic_strength_flask
actions.precombat+=/food,type=sleeper_sushi
actions.precombat+=/stance,choose=battle
actions.precombat+=/snapshot_stats
actions.precombat+=/potion,name=draenic_strength

# Executed every time the actor is available.

actions=charge,if=debuff.charge.down
actions+=/auto_attack
actions+=/run_action_list,name=movement,if=movement.distance>5
actions+=/use_item,name=thorasus_the_stone_heart_of_draenor,if=(buff.bloodbath.up|(!talent.bloodbath.enabled&debuff.colossus_smash.up))
actions+=/potion,name=draenic_strength,if=(target.health.pct<20&buff.recklessness.up)|target.time_to_die<25
actions+=/recklessness,if=(((target.time_to_die>190|target.health.pct<20)&(buff.bloodbath.up|!talent.bloodbath.enabled))|target.time_to_die<=12|talent.anger_management.enabled)&((desired_targets=1&!raid_event.adds.exists)|!talent.bladestorm.enabled)
actions+=/bloodbath,if=(dot.rend.ticking&cooldown.colossus_smash.remains<5&((talent.ravager.enabled&prev_gcd.ravager)|!talent.ravager.enabled))|target.time_to_die<20
actions+=/avatar,if=buff.recklessness.up|target.time_to_die<25
actions+=/blood_fury,if=buff.bloodbath.up|(!talent.bloodbath.enabled&debuff.colossus_smash.up)|buff.recklessness.up
actions+=/berserking,if=buff.bloodbath.up|(!talent.bloodbath.enabled&debuff.colossus_smash.up)|buff.recklessness.up
actions+=/arcane_torrent,if=rage<rage.max-40
actions+=/heroic_leap,if=(raid_event.movement.distance>25&raid_event.movement.in>45)|!raid_event.movement.exists
actions+=/call_action_list,name=aoe,if=spell_targets.whirlwind>1
actions+=/call_action_list,name=single

actions.aoe=sweeping_strikes
actions.aoe+=/rend,if=dot.rend.remains<5.4&target.time_to_die>4
actions.aoe+=/rend,cycle_targets=1,max_cycle_targets=2,if=dot.rend.remains<5.4&target.time_to_die>8&!buff.colossus_smash_up.up&talent.taste_for_blood.enabled
actions.aoe+=/rend,cycle_targets=1,if=dot.rend.remains<5.4&target.time_to_die-remains>18&!buff.colossus_smash_up.up&spell_targets.whirlwind<=8
actions.aoe+=/ravager,if=buff.bloodbath.up|cooldown.colossus_smash.remains<4
actions.aoe+=/bladestorm,if=((debuff.colossus_smash.up|cooldown.colossus_smash.remains>3)&target.health.pct>20)|(target.health.pct<20&rage<30&cooldown.colossus_smash.remains>4)
actions.aoe+=/colossus_smash,if=dot.rend.ticking
actions.aoe+=/execute,cycle_targets=1,if=!buff.sudden_death.react&spell_targets.whirlwind<=8&((rage.deficit<48&cooldown.colossus_smash.remains>gcd)|rage>80|target.time_to_die<5|debuff.colossus_smash.up)
actions.aoe+=/heroic_charge,cycle_targets=1,if=target.health.pct<20&rage<70&swing.mh.remains>2&debuff.charge.down
actions.aoe+=/mortal_strike,if=target.health.pct>20&(rage>60|debuff.colossus_smash.up)&spell_targets.whirlwind<=5
actions.aoe+=/dragon_roar,if=!debuff.colossus_smash.up
actions.aoe+=/thunder_clap,if=(target.health.pct>20|spell_targets.whirlwind>=9)&glyph.resonating_power.enabled
actions.aoe+=/rend,cycle_targets=1,if=dot.rend.remains<5.4&target.time_to_die>8&!buff.colossus_smash_up.up&spell_targets.whirlwind>=9&rage<50&!talent.taste_for_blood.enabled
actions.aoe+=/whirlwind,if=target.health.pct>20|spell_targets.whirlwind>=9
actions.aoe+=/siegebreaker
actions.aoe+=/storm_bolt,if=cooldown.colossus_smash.remains>4|debuff.colossus_smash.up
actions.aoe+=/shockwave
actions.aoe+=/execute,if=buff.sudden_death.react

actions.single=rend,if=target.time_to_die>4&(remains<gcd|(debuff.colossus_smash.down&remains<5.4))
actions.single+=/ravager,if=cooldown.colossus_smash.remains<4&(!raid_event.adds.exists|raid_event.adds.in>55)
actions.single+=/colossus_smash,if=debuff.colossus_smash.down
actions.single+=/mortal_strike,if=target.health.pct>20
actions.single+=/colossus_smash
actions.single+=/bladestorm,if=(((debuff.colossus_smash.up|cooldown.colossus_smash.remains>3)&target.health.pct>20)|(target.health.pct<20&rage<30&cooldown.colossus_smash.remains>4))&(!raid_event.adds.exists|raid_event.adds.in>55|(talent.anger_management.enabled&raid_event.adds.in>40))
actions.single+=/storm_bolt,if=debuff.colossus_smash.down
actions.single+=/siegebreaker
actions.single+=/dragon_roar,if=!debuff.colossus_smash.up&(!raid_event.adds.exists|raid_event.adds.in>55|(talent.anger_management.enabled&raid_event.adds.in>40))
actions.single+=/execute,if=buff.sudden_death.react
actions.single+=/execute,if=!buff.sudden_death.react&(rage.deficit<48&cooldown.colossus_smash.remains>gcd)|debuff.colossus_smash.up|target.time_to_die<5
actions.single+=/rend,if=target.time_to_die>4&remains<5.4
actions.single+=/wait,sec=cooldown.colossus_smash.remains,if=cooldown.colossus_smash.remains<gcd
actions.single+=/shockwave,if=target.health.pct<=20
actions.single+=/wait,sec=0.1,if=target.health.pct<=20
actions.single+=/impending_victory,if=rage<40&!set_bonus.tier18_4pc
actions.single+=/slam,if=rage>20&!set_bonus.tier18_4pc
actions.single+=/thunder_clap,if=((!set_bonus.tier18_2pc&!t18_class_trinket)|(!set_bonus.tier18_4pc&rage.deficit<45)|rage.deficit<30)&(!talent.slam.enabled|set_bonus.tier18_4pc)&(rage>=40|debuff.colossus_smash.up)&glyph.resonating_power.enabled
actions.single+=/whirlwind,if=((!set_bonus.tier18_2pc&!t18_class_trinket)|(!set_bonus.tier18_4pc&rage.deficit<45)|rage.deficit<30)&(!talent.slam.enabled|set_bonus.tier18_4pc)&(rage>=40|debuff.colossus_smash.up)
actions.single+=/shockwave

actions.movement=heroic_leap
actions.movement+=/charge,cycle_targets=1,if=debuff.charge.down
actions.movement+=/charge
actions.movement+=/storm_bolt
actions.movement+=/heroic_throw

head=faceguard_of_iron_wrath,id=124334,bonus_id=567
neck=choker_of_sneering_superiority,id=124219,bonus_id=567,enchant=gift_of_mastery
shoulders=doomcriers_shoulderplates,id=124343,bonus_id=567
back=cloak_of_incendiary_wrath,id=124144,bonus_id=567,enchant=gift_of_mastery
chest=breastplate_of_iron_wrath,id=124319,bonus_id=567
wrists=breachscarred_wristplates,id=124353,bonus_id=567
hands=gauntlets_of_iron_wrath,id=124329,bonus_id=567
waist=annihilans_waistplate,id=124349,bonus_id=567
legs=legplates_of_iron_wrath,id=124340,bonus_id=567
feet=treads_of_the_defiler,id=124322,bonus_id=567
finger1=thorasus_the_stone_heart_of_draenor,id=124634,enchant=gift_of_mastery
finger2=loop_of_beckoned_shadows,id=124199,bonus_id=567,enchant=gift_of_mastery
trinket1=empty_drinking_horn,id=124238,bonus_id=567
trinket2=worldbreakers_resolve,id=124523,bonus_id=567
main_hand=calamitys_edge,id=124389,bonus_id=567,enchant=mark_of_bleeding_hollow

# Gear Summary
# gear_ilvl=730.67
# gear_strength=4686
# gear_stamina=6242
# gear_crit_rating=2231
# gear_haste_rating=1006
# gear_mastery_rating=1888
# gear_multistrike_rating=684
# gear_armor=2512
# set_bonus=tier18_2pc=1
# set_bonus=tier18_4pc=1