# BadRotations logs

BadRotations writes what it does and sees to the files in this folder while you play. If you need
help with a problem, zip this folder and send it along with a short note of what went wrong and
roughly when. The logs often show the cause without you having to reproduce it.

No one is named in these files: your character is "Me", other players get a stand-in such as
`Party2[PRIEST]` or `Player5[ROGUE]`, and realms, player IDs and the user name in folder paths are
left out. Creatures and NPCs keep their names. (Chat in the game shows the real names as usual.)

Each file trims itself when a session starts, so the folder stays small without you having to
clean it. Deleting the files is safe at any time, even while the game is running.

| File | What it holds |
| --- | --- |
| Chat.log | Every line BadRotations printed in chat |
| Rotation.log | Every spell BadRotations sent, where in the profile it came from, and the game's answer; refused casts (with Cast Debug on); a summary per fight |
| Idle.log | A snapshot whenever you stood idle in combat with an enemy close by: what was refused and why |
| Target.log | Why BadRotations picked the enemy it picked, when that changes in combat |
| Cast.log | Spells sent while another cast was still going, and casts the game refused |
| Loot.log | What the loot engine did, corpse by corpse |
| Melee.log | Melee range episodes and client facts |
| Range.log | Results of the /br range command |

## Reading the files

- Each session starts with `=== session <date time>, loaded at game time N ===`. Every line after
  it starts with the game time in seconds, so the clock time is the session's time plus
  (line time - N).
- A value the game hides from addons (a "secret" value) is written as `<SECRET>` or left out with
  a note, never guessed.
