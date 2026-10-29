# Writing a profile

A **profile** tells BadRotations (BR) what your character should do in a fight: which spells to cast, in
which order, and when. This guide walks you through writing one, starting from
[`sample rotation.lua`](sample%20rotation.lua) in this folder. You don't need to have written code
before.

BR handles the hard parts itself:
- whether a spell is ready, affordable and in range;
- which rank to use;
- facing, line of sight and the global cooldown;
- not interrupting your own casts.

Your profile only has to say what you want, in order of priority.

## Contents

1. [Before you start](#before-you-start)
2. [Lua in five minutes](#lua-in-five-minutes)
3. [Your first profile](#your-first-profile)
4. [Finding spell names](#finding-spell-names)
5. [Toggles](#toggles)
6. [Options](#options)
7. [Action lists](#action-lists)
8. [The rotation](#the-rotation)
9. [Trying it in game](#trying-it-in-game)
10. [Playing well at every level](#playing-well-at-every-level)
11. [Going further](#going-further)
12. [Getting help from an AI](#getting-help-from-an-ai)

## Before you start

- **An editor.** Any text editor works, but [Visual Studio Code](https://code.visualstudio.com/) with the
  **Lua** extension (by sumneko) makes it much easier. Open the whole `BadRotations` folder in it: the
  extension then reads BR's `Types/` folder. As you type `cast.`, it lists every spell you can cast and
  every BR function, with a short description of each.
- **A character to test with.** Any level will do; see
  [Playing well at every level](#playing-well-at-every-level).
- **`/reload`.** BR reads your profile when the game loads its interface. After every change, save the
  file and type `/reload` in game.

## Lua in five minutes

Profiles are written in Lua, the language World of Warcraft addons use. A profile only needs a small part
of it.

**Notes.** A line starting with `--` is a note for people; the game skips it. You can also switch a line
of code off by putting `--` in front of it.

```lua
-- This is a note
-- if cast.charge() then return true end   (switched off)
```

**Values with a name.** `local` gives a value a name you can use later. Use `local` the first time you
name something; after that, just the name.

```lua
local healthToHeal = 40     -- a number
local enemy                 -- a name with no value yet (nil, meaning "nothing")
enemy = units.get(40)       -- given a value later
```

**Asking questions.** `if ... then ... end` runs the lines inside only when the question is true. Join
questions with `and` / `or`, and turn one around with `not`.

```lua
if unit.hp() < 40 and not buff.lightningShield.exists() then
    -- runs only when your health is under 40% and Lightning Shield is not on you
end
```

Comparisons: `<` less than, `>` more than, `<=` / `>=` or equal, `==` equal (two `=`), `~=` not equal.

**Calling BR.** Everything BR offers is reached with dots, and called with brackets `()`. Inside the
brackets go the details, such as which unit:

```lua
unit.hp()                -- your health, in percent
unit.hp(enemy)           -- the enemy's health
cast.lightningBolt(enemy)
```

**Functions and `return`.** A *function* is a named list of steps. `return` leaves it straight away,
optionally handing back an answer. In a profile, `return true` means "I did something, stop here".

```lua
local function myList()
    if cast.lightningShield() then return true end
    if cast.lightningBolt(enemy) then return true end
end
```

That's all the Lua the sample uses. Watch the small things: every `if` needs its `then` and its `end`,
and names are case-sensitive (`lightningBolt`, not `LightningBolt`).

## Your first profile

1. **Copy** `sample rotation.lua` into your class and spec's folder: `Rotations/<Class>/<Spec>/`, such
   as `Rotations/Druid/Feral/`. On game versions without specializations (Classic Era, Burning Crusade
   Classic, WoW Forever), the folder is the class name twice, such as `Rotations/Shaman/Shaman/`. Use the
   folder if it exists; if it doesn't, create it with the spec name as BR spells it in
   `System/Lists/Specs.lua`.
2. **Rename** your copy, for example `Feral-MyName.lua`.
3. **Fill in** the three lines at the bottom:
   - `name`: what the profile is called in the rotation list. It must be different from the other
     profiles for that spec.
   - `specID`: your spec's number, from
     [warcraft.wiki.gg/wiki/SpecializationID](https://warcraft.wiki.gg/wiki/SpecializationID). On game
     versions without specializations, the number isn't on that page. Copy it from another profile in
     the same folder. If there is none, leave `000`, `/reload`, and BR says in chat
     "no rotation for spec <number>": that's your number.
   - `expansion`: which game version it is for: `"Retail"`, `"MOP"`, `"TBC"`, `"Classic"` or
     `"Forever"`. A profile is for one version only. For another version, make another file.
4. **`/reload`** in game. **Right-click** BR's minimap button to open the profile window, and choose your
   profile in the rotation list at the top.

It does very little yet: it attacks and nothing more. The rest of this guide fills it in.

If BR prints a warning about your file in chat instead, the message says what's wrong, such as a missing
`specID` or a misspelled field name.

## Finding spell names

You cast a spell by its name in BR's **spell list**, written like `lightningBolt`: no spaces, every word
after the first starting with a capital letter.

The lists live in `Expansions/<Version>/<CLASS>/`:
- `Class.lua` has the whole class.
- On Retail and MoP there is also a file per spec, such as `Fury.lua`.
- `Expansions/<Version>/Global.lua` has what every class shares, such as `autoAttack` and the racials.

Inside, spells are grouped into `abilities` (what you cast), `buffs` (what's on you or a friend) and
`debuffs` (what's on an enemy). One spell can be in more than one group. Battle Shout is an ability you
cast and a buff you then have.

With the editor set up as in [Before you start](#before-you-start), typing `cast.` lists the spell names
for you.

**Ranks.** On game versions with spell ranks, a list entry holds every rank. BR casts the highest rank
you know, so you never pick a rank yourself.

## Toggles

The toggles are the buttons on BR's toggle bar. A player switches them while playing: AoE or single
target, cooldowns on or off, and so on.

The sample has four. **Keep these four as they are**: BR's own helpers read them by name and by the order
of their modes. You can add your own after them:

```lua
ui.toggle("Taunt", { modes = {
    { name = "On",  icon = 355, tip = "Taunt enemies that attack others." },
    { name = "Off", icon = 355, tip = "Never taunt." },
} })
```

- Each click moves the button to its next mode. The first mode is where it starts.
- `icon` is any spell's ID number (from a site like Wowhead) or a spell name from your class's list.
- `key = "RightAlt"` (optional) also lets a key cycle it. The choices are listed in BR's Bot Options.

In the rotation, `ui.mode.taunt` is the mode it's on: `1` for "On", `2` for "Off". The toggle's name is
written with a small first letter here.

For the four standard toggles, BR has helpers that read them for you: `ui.useAOE()`, `ui.useCDs()`,
`ui.useDefensive()` and `ui.useInterrupt()`.

## Options

Options are the settings on the profile window's Rotation Options page, kept for each player.

```lua
local function options()
    local section = ui.section("Defensive")
    ui.checkbox(section, "Use Healing Wave", { checked = true, tip = "Heal yourself when low." })
    ui.spinner(section, "Healing Wave At", { value = 40, min = 5, max = 95, checkbox = false })
    ui.dropdown(section, "Bloodlust", { choices = "AlwaysCdNever", value = "Cooldowns" })
end
```

- `ui.section("Name")` starts a group. Each option after it names that group, then its own name.
- `ui.checkbox`: a tick box. `checked = true` starts it ticked.
- `ui.spinner`: a number with up/down arrows (`value`, `min`, `max`, `step`). It also has a tick box in
  front, unless `checkbox = false`.
- `ui.dropdown`: a list of choices, with a tick box in front like the spinner. `choices` is a list of
  your own (`{ "Never", "Sometimes", "Always" }`) or one of BR's ready-made ones, such as
  `"AlwaysCdNever"` (always / when the Cooldown toggle allows / never).
- `ui.text(section, "Some words")` adds a line of text.

In the rotation:

```lua
if ui.checked("Use Healing Wave") and unit.hp() <= ui.value("Healing Wave At") then
    if cast.healingWave("player") then return true end
end
```

- `ui.checked("Name")`: is its tick box ticked?
- `ui.value("Name")`: its number, or the number of the dropdown choice (1 for the first).
- For a `"AlwaysCdNever"` dropdown, `ui.alwaysCdNever("Name")` answers the whole question for you.

The names must match exactly, capitals included.

## Action lists

An **action list** is your priority list: the spells you want, best first. BR goes down it every time it
checks, and casts the first one that is possible right now.

```lua
actionList.Combat = function()
    if cast.victoryRush(enemy) then return true end
    if unit.hp(enemy) < 20 then
        if cast.execute(enemy) then return true end
    end
    if cast.heroicStrike(enemy) then return true end
end
```

`if cast.execute(enemy) then return true end` means: try to cast Execute at the enemy. If it went out,
stop here. If it couldn't (not enough rage, on cooldown, out of range, not learned yet), go on to the next
line.

You don't check whether a spell is ready, affordable or in range: `cast.<spell>()` does that itself.
You only add the conditions that are *your* choice, such as "only under 20% health".

**Things you can ask about.** Each is a question you can put in an `if`:

| You want to know | Write | Answer |
|---|---|---|
| your health | `unit.hp()` | percent |
| the enemy's health | `unit.hp(enemy)` | percent |
| how far away it is | `unit.distance(enemy)` | yards |
| a buff on you | `buff.lightningShield.exists()` | true / false |
| how long it lasts | `buff.lightningShield.remain()` | seconds |
| a debuff on the enemy | `debuff.flameShock.exists(enemy)` | true / false |
| ...how long it lasts | `debuff.flameShock.remain(enemy)` | seconds |
| a cooldown | `cd.earthShock.ready()` | true / false |
| ...time left on it | `cd.earthShock.remain()` | seconds |
| your power | `power.mana.percent()`, `power.rage()` | percent / amount |
| whether you know a spell | `spell.stormstrike.known()` | true / false |
| enemies around you | `#enemies.yards8` (after `enemies.get(8)`) | how many |
| in combat | `unit.inCombat()` | true / false |
| moving | `unit.moving()` | true / false |

The full list of what BR offers is at
[cuteone.github.io/BadRotations](https://cuteone.github.io/BadRotations/).

**From a plain rule to code.** Write each rule as a sentence first, then turn it into code:

> Keep Lightning Shield up.

```lua
if not buff.lightningShield.exists() then
    if cast.lightningShield() then return true end
end
```

> Flame Shock the enemy if it isn't on it yet, and the enemy will live long enough for it to matter.

```lua
if not debuff.flameShock.exists(enemy) and unit.ttd(enemy) > 6 then
    if cast.flameShock(enemy) then return true end
end
```

(`unit.ttd` is BR's estimate of how many seconds the enemy has left to live.)

## The rotation

`runRotation` is the main part. BR runs it many times a second. It picks the enemy, then tries the action
lists in order:

```lua
local function runRotation()
    enemy = units.get(40)
    if ui.mode.rotation == 4 then return end
    if actionList.Defensive() then return true end
    if unit.inCombat() and enemy then
        if actionList.Combat() then return true end
    end
end
```

- `units.get(40)` gives the best enemy within 40 yards, as BR picks it under **Targeting** in Bot
  Options. It gives nothing when there is none, which is why the code asks `and enemy`.
- Each list that did something returns `true`, so the rotation stops there until next time.
- The order of the lists is a priority too. Defensives come before damage, so a low-health player heals
  first.

You don't need to check for these yourself:
- BR skips the rotation while you are paused, mounted, on a taxi or dead.
- While you are casting, BR keeps your new casts back until the cast is nearly done.

## Trying it in game

1. Save, then `/reload`.
2. Choose your profile (right-click the minimap button, the rotation list at the top), turn BR on with
   `/br`, and fight something: a training dummy is ideal.

**When something goes wrong:**
- **A Lua error** (a typo, a missing `end`, a misspelled spell name) is written to
  `BadRotations/Logs/Errors.log` with your file's name and the line number, such as
  `[string "Feral-MyName.lua"]:42: ...`. A mistake BR finds while loading the file is also shown in chat.
  To see errors during play as they happen, install the BugSack addon, or turn on the game's
  "Display Lua Errors" setting. Fix that line and `/reload`.
- **A spell is never cast:** type `/br why <spell>`, such as `/br why flame shock`. BR says why it last
  refused that spell: not learned, on cooldown, out of range, not enough mana, and so on.
- **To see everything BR cast,** and what the game answered: open Bot Options (left-click the minimap
  button), **Debug Options**, and tick **Rotation Log**. The same goes to
  `BadRotations/Logs/Rotation.log`.
- **More detail in chat:** in Debug Options, tick **Addon Debug Messages** and set **Debug Level** to
  *Developer*. BR then also reports idle moments in a fight and spells you have but never cast.

**Optional:** to add your own note when a spell goes out, write `ui.debug("text")`:

```lua
if cast.heroicStrike(enemy) then ui.debug("Heroic Strike [rage dump]") return true end
```

## Playing well at every level

A good profile works for a level 10 character as well as a max-level one.
- **Spells not learned yet are skipped.** `cast.<spell>()` simply answers "no" for a spell you don't know
  yet, so your list moves on.
- **Ranks are automatic.** On game versions with ranks, BR uses the best one you know.
- **Plan for the gaps.** When a spell you'd normally rely on isn't known yet, ask
  `spell.<name>.known()` and do something else. For example: a low-level Shaman who doesn't have
  Stormstrike yet should cast Lightning Bolt instead of only meleeing.
- **Don't count on talents.** Players choose them differently. Ask `spell.<name>.known()` (or on Retail,
  `talent.<name>`) before relying on one.
- **Mana and rage are tighter at low level.** Thresholds like "keep 30% mana for healing" matter more
  there.

## Going further

These are for when the basics work.

- **Area spells.** `cast.consecration.aoe(8, 3)` casts only when 3 or more enemies are within 8 yards.
  `cast.blizzard.ground(8, 3)` places a ground spell where it hits the most enemies. There are also
  `.cone(...)` and `.rect(...)` for cones and lines.
- **A specific rank.** `cast.healingWave.rank(3)("player")`, or the lowest rank that heals enough:
  `cast.healingWave.forAmount(missingHealth)("player")`.
- **During your own cast.** BR holds new casts while you cast. For a spell the game allows during a cast,
  write `cast.<spell>.whileCasting()`. For an item, `use.<item>.whileCasting()`.
- **Stopping your own cast.** `cast.cancel.<spell>()` stops it early, for example to cut a channel short
  when something better comes up. `cast.current.<spell>()` tells you whether you're casting it.
- **Items.** `use.healthstone()`, `use.slot(13)` (the first trinket slot). `use.able.<item>()` asks
  whether it's ready.
- **Racials and trinkets.** BR's Base Options use them for you. If your profile uses one itself
  (`cast.racial()`, `use.slot(13)`, ...), BR notices and leaves that to your profile.
- **Remembering things between checks.** `var` keeps values from one check to the next, such as
  `var.lastPull = unit.combatTime()`.
- **More option pages.** Make `options` a list of pages:
  `{ { "General", generalOptions }, { "Healing", healingOptions } }`.
- **Choosing targets.** `units.setTargetWeight(function(thisUnit) ... end)` lets you raise or lower how
  much BR wants to attack each enemy, such as ones that already have your debuff.
- **Everything else:** the API reference at
  [cuteone.github.io/BadRotations](https://cuteone.github.io/BadRotations/), the existing profiles in
  `Rotations/`, and [AGENTS.md](../AGENTS.md) for how BR is built.

## Getting help from an AI

An AI assistant can write a good first draft of a profile, if you give it the right material and keep it
to what a profile writer does. Attach or paste these three:
- this guide;
- [`sample rotation.lua`](sample%20rotation.lua);
- your class's spell list file(s) from `Expansions/<Version>/<CLASS>/`.

Keep the AI to your own profile, as you would yourself:
- It writes or changes **your profile file only**, plus a support file of your own in
  `Rotations/<Class>/Support/` if you need one.
- It doesn't change BR's own files: `System/`, `Expansions/` (the spell lists included), `Libs/`,
  `Settings/`, or other people's profiles. When something seems missing from BR, or a spell isn't in
  the list, it tells you instead. You can then ask on BR's Discord or open an issue.
- An AI that works inside your BadRotations folder (such as Claude Code, Copilot or Codex) may read BR's
  files to understand them, but give it this rule too. BR's own developer notes (`AGENTS.md`) are for
  people working on BR itself, not on a profile.

Then copy the prompt below, fill in the parts in `<angle brackets>`, and send it with the files.

```text
I want a BadRotations (BR) profile for World of Warcraft. I've attached BR's guide
"Writing a profile.md", its "sample rotation.lua" and my class's spell list file(s).

My character:
- Game version: <Retail / MOP / TBC / Classic / Forever>
- Class and spec: <for example "Shaman, Enhancement", or just the class on versions without specs>
- Level: <for example "levelling, now 34" or "max level">
- What I do most: <for example "solo questing", "dungeons as a healer", "raids">
- How I want it to play: <your rules in plain words, best first, for example
  "keep Lightning Shield up; Flame Shock if it isn't on the target; Stormstrike on cooldown;
  Earth Shock when Stormstrike is on cooldown; heal myself under 40% health">

Please write the profile as one Lua file, following these rules:
1. Only write my profile file. Don't create or change any other file: not BR's System/, Expansions/
   (spell lists), Libs/ or Settings/ folders, and not other profiles. If BR seems to lack something I
   need, or a spell is missing from the list, tell me what and why instead.
2. Start from sample rotation.lua and keep its layout and its four toggles (Rotation, Cooldown,
   Defensive, Interrupt).
3. Use only BR functions that appear in the guide or the sample, or in BR's API reference
   (https://cuteone.github.io/BadRotations/). A profile can't use WoW's own API or "br."; don't
   invent functions.
4. Use only spell names that are in the spell list files I attached, spelled exactly as there.
5. Write each action as `if cast.<spell>(...) then return true end`. Don't check whether a spell is
   ready, affordable or in range: BR does that. Only add conditions that are my choices.
6. It must play well at my level: ask spell.<name>.known() before relying on a spell I might not
   have yet, and have a fallback.
7. Put a short plain-English note above each rule saying what it does and why.
8. Fill in name, specID and expansion at the bottom, and tell me which folder to put the file in.

If anything about how I want it to play is unclear, ask me before writing the code.
```

Then try it in game as in [Trying it in game](#trying-it-in-game). The AI can't see your game, so paste
back to it:
- any error from `Errors.log`;
- what `/br why <spell>` says about a spell it never casts;
- anything it does that you didn't want, in plain words.
