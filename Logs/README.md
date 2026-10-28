# BadRotations logs

BadRotations writes what it does and sees to the files in this folder while you play. If you need
help with a problem, zip this folder and send it along with a short note of what went wrong and
roughly when. The logs often show the cause without you having to reproduce it.

## Your logs stay with you

- **Nothing is sent anywhere.** BadRotations only writes these files to your computer. It never
  uploads them, shares them or sends them to anyone. They leave your computer only if you send
  them yourself.
- **No one is named in them.** Your character is written as `Me`. Other players get a stand-in that
  stays the same for the session, such as `Party2[PRIEST]` or `Player5[ROGUE]`. Realm names, player
  IDs, and your user name in folder paths are left out. Creatures and NPCs keep their names, since
  what you were fighting matters. Chat in the game still shows real names as usual; only the files
  are changed.
- **What they do contain:** your character's race, class and level, the game version, the unlocker,
  the names of your other addons, your BadRotations settings, and what happened in your fights.
- **Check them if you like.** They are plain text files you can open in any text editor. Names are
  replaced for every player BadRotations knew about (your group, and anyone it targeted or looked
  at). If you want to be sure, look the files over before you send them.
- **You can switch them off.** Untick **Write Log Files** in the BadRotations settings (Bot Options >
  Debug Options) and no log files are written at all. Nothing is written before your settings
  load, so with the option off nothing is written from startup either. You can delete the files in
  this folder at any time, even while the game is running.

Each file trims itself when a session starts, so the folder stays small without you having to
clean it.

## The files

| File | What it holds |
| --- | --- |
| Session.log | Read this first: BadRotations' version, the game client, the unlocker, your character's class and level, the other addons, every setting of the loaded profile, and each setting or toggle you changed while playing |
| Errors.log | BadRotations' Lua errors with where they happened (a repeated one is counted) |
| Chat.log | Every line BadRotations printed in chat |
| Rotation.log | Every spell BadRotations sent, where in the profile it came from, and the game's answer; refused casts and why; a summary per fight |
| Fights.log | A scorecard per fight, in a fixed layout for scripts: damage and healing done, damage taken, deaths, time busy or idle, time at full energy or rage, mana spent, casts and mana per spell, cooldowns left ready, and the rest before each fight (time since the last, drinking and eating, mana gained, spells cast in between) |
| Idle.log | A snapshot whenever you stood idle in combat with an enemy close by: what was refused and why |
| Target.log | Why BadRotations picked the enemy it picked, when that changes in combat |
| Cast.log | Spells sent while another cast was still going, and casts the game refused |
| Gate.log | At Debug Level Trace (Bot Options > Debug Options): every routine cast refusal: the gates' "not yet" answers (GCD, cooldown, not enough power, ...), the ones the cast system made itself (out of range, no target, not enough targets, out of sight), and the game's refusals BR couldn't foresee (the target died) |
| Loot.log | What the loot engine did, corpse by corpse, and the tracker's auto-interacts with their answers ("Tracker: ...") |
| Melee.log | Melee range episodes, client facts, the swing around a cast, and when the game answers BR's auto attack starts |
| Range.log | Results of the /br range command |

## Reading the files

- Each session starts with `=== session <date time>, loaded at game time N ===`. Every line after
  it starts with the clock time and the game time in seconds (`21:42:50 12183.1 ...`): the clock
  time matches what you remember, the game time matches timings inside the lines.
- A value the game hides from addons (a "secret" value) is written as `<SECRET>` or left out with
  a note, never guessed.
