# BadRotations

BadRotations (BR) is a free, open-source combat rotation addon for World of Warcraft. It reads the fight
around you (enemies, your group's health, your cooldowns and resources) and casts your class's rotation for
you. Movement stays with you: BR never moves or turns your character on its own.

BR needs a **Lua unlocker** to run. The [Wiki](https://github.com/CuteOne/BadRotations/wiki) explains how to
set one up and load BR with it.

## Game versions

BR is not tied to one version of WoW. Each client gets a thin layer under `Expansions/` with its spell
lists and game rules. Adding a version means adding that layer, not changing BR itself. Profiles are
written for one game version, and BR offers only the profiles made for the client you are playing.

The [profile list](#profiles) below shows which game versions currently have profiles.

## Installing

1. Download BR, either the green **Code → Download ZIP** button above or `git clone`, and put the
   `BadRotations` folder where your unlocker loads it from. The [Wiki](https://github.com/CuteOne/BadRotations/wiki)
   has the details for each unlocker.
2. **Icons and fonts:** copy the `Media` folder from `3rd Party Files` into your game's `Interface\AddOns`
   folder, so you have `World of Warcraft\<game version>\Interface\AddOns\Media`. WoW only loads images and
   fonts from its own `Interface` folder. Without this step BR's windows have no icons and use the game's
   default font. BR itself still runs from wherever your unlocker loads it.
3. Log in and load BR through your unlocker. The BR button appears on your minimap.

## Using BR

- **Minimap button:** left-click opens the options window. Shift+left-click shows or hides the toggle bar.
  Alt+Shift drags the button.
- **Toggle bar:** buttons for the things you switch often in play: on/off, AoE, cooldowns, defensives,
  interrupts and whatever else the profile adds. Hover over a button to see what each state does.
- **Options window:** *Bot Options* (BR itself, per character), *Base Options* (shared features such as
  racials, trinkets and healthstones, per character and spec) and the profile's own *Rotation Options*.
  Settings are saved under `Settings/`, separately for each game version.
- **Chat commands:** `/br` turns BR on or off, and `/br help` lists the rest. Some useful ones:

  | Command | What it does |
  |---------|--------------|
  | `/br why <spell>` | Says why BR last refused to cast a spell |
  | `/br target` | Shows which enemy BR is focusing on and why |
  | `/br log` | Shows BR's recent chat lines in a window you can copy from |
  | `/br pause toggle` | Pauses or resumes BR |

## Reporting problems

Open an [issue](https://github.com/CuteOne/BadRotations/issues) or ask on
[Discord](https://discord.gg/VE7V7Mz). Say what went wrong and roughly when, and attach `Session.log` and
`Errors.log` from `BadRotations/Logs/` (or zip the whole folder). The logs usually show the cause without
you having to make it happen again.

BR writes what it does to these plain text files while you play. **Nothing is ever sent anywhere.** The
files stay on your computer until you choose to share them, and other players' names in them are
replaced. You can switch them off under *Bot Options → Debug Options → Write Log Files*.
[Logs/README.md](Logs/README.md) explains each file.

## Writing a profile

A profile is one Lua file in `Rotations/<Class>/<Spec>/`. It registers itself, so dropping a new file in is
enough for BR to find it.

- Start from [`Rotations/sample rotation.lua`](Rotations/sample%20rotation.lua).
- The profile API is documented at **<https://cuteone.github.io/BadRotations/>**, generated from the
  `System/API` source.
- `Types/` gives editors that use the Lua language server (such as VS Code with sumneko Lua) completion for
  the whole profile API.
- [AGENTS.md](AGENTS.md) describes how BR is put together and the conventions profiles follow.

Pull requests are welcome.

## Profiles

Generated from each profile's `registerRotation` table whenever a profile changes. Starter profiles cover
the levels before you pick a specialization.

<!-- rotations -->

### Retail

|   class    |         spec          |    rotation    |   author   |last updated|
|------------|-----------------------|----------------|------------|-----------:|
|Death Knight|Blood                  |CuteOne         |CuteOne     |  2026-10-25|
|Death Knight|Starter (before a spec)|Initial         |CuteOne     |  2026-10-25|
|Demon Hunter|Havoc                  |CuteOne         |CuteOne     |  2026-10-26|
|Demon Hunter|Starter (before a spec)|Initial         |CuteOne     |  2026-10-25|
|Demon Hunter|Vengeance              |CuteOne         |CuteOne     |  2026-10-26|
|Druid       |Feral                  |CuteOne         |CuteOne     |  2026-10-25|
|Druid       |Starter (before a spec)|Initial Druid   |CuteOne     |  2026-10-25|
|Evoker      |Devastation            |CuteOne         |CuteOne     |  2026-10-26|
|Evoker      |Starter (before a spec)|Initial         |Kuukuu      |  2026-10-26|
|Hunter      |BeastMastery           |BrewBeastMaster |BrewingCoder|  2026-10-25|
|Hunter      |Marksmanship           |CuteOne         |CuteOne     |  2026-10-25|
|Hunter      |Starter (before a spec)|Initial         |CuteOne     |  2026-10-25|
|Paladin     |Retribution            |CuteOne         |CuteOne     |  2026-10-26|
|Paladin     |Starter (before a spec)|Initial         |CuteOne     |  2026-10-25|
|Priest      |Starter (before a spec)|Initial         |CuteOne     |  2026-10-25|
|Rogue       |Starter (before a spec)|Initial         |Yamaraja666 |  2026-10-25|
|Warlock     |Affliction             |BrewAffliction  |BrewingCoder|  2026-10-25|
|Warlock     |Destruction            |BrewDestro      |BrewingCoder|  2026-10-25|
|Warlock     |Starter (before a spec)|Initial         |CuteOne     |  2026-10-25|
|Warrior     |Fury                   |CuteOne         |CuteOne     |  2026-10-25|
|Warrior     |Fury                   |BrewFuryLeveling|BrewingCoder|  2026-10-25|


### Mists of Pandaria Classic

|   class    |         spec          |  rotation   |  author   |last updated|
|------------|-----------------------|-------------|-----------|-----------:|
|Death Knight|Frost                  |CuteOne      |CuteOne    |  2026-10-25|
|Druid       |Feral                  |CuteOne      |CuteOne    |  2026-10-25|
|Druid       |Starter (before a spec)|Initial Druid|CuteOne    |  2026-10-25|
|Mage        |Starter (before a spec)|Initial      |CuteOne    |  2026-10-25|
|Monk        |Starter (before a spec)|Initial      |CuteOne    |  2026-10-25|
|Monk        |WindWalker             |CuteOne      |CuteOne    |  2026-10-26|
|Paladin     |Retribution            |CuteOne      |CuteOne    |  2026-10-25|
|Paladin     |Starter (before a spec)|Initial      |CuteOne    |  2026-10-25|
|Rogue       |Subtlety               |CuteOne      |CuteOne    |  2026-10-25|
|Shaman      |Enhancement            |CuteOne      |CuteOne    |  2026-10-25|
|Shaman      |Starter (before a spec)|Initial      |CuteOne    |  2026-10-25|
|Warrior     |Arms                   |CuteOne      |CuteOne    |  2026-10-26|
|Warrior     |Starter (before a spec)|Initial      |Yamaraja666|  2026-10-25|


### Burning Crusade Classic

|class |spec| rotation  |  author   |last updated|
|------|----|-----------|-----------|-----------:|
|Druid |All |CuteOne    |CuteOne    |  2026-10-28|
|Hunter|All |CuteOne    |CuteOne    |  2026-10-25|
|Shaman|All |Earthcaller|Earthcaller|  2026-10-28|
|Shaman|All |CuteOne    |CuteOne    |  2026-10-25|


### Classic Era

|class |spec|rotation|author |last updated|
|------|----|--------|-------|-----------:|
|Druid |All |CuteOne |CuteOne|  2026-10-25|
|Hunter|All |CuteOne |CuteOne|  2026-10-25|


### World of Warcraft Forever

|class|spec|rotation|author |last updated|
|-----|----|--------|-------|-----------:|
|Druid|All |CuteOne |CuteOne|  2026-10-25|


<!-- /rotations -->

## Credits

BadRotations is maintained by CuteOne. It started among developers of earlier rotation bots such as PQR and
ProbablyEngine, and many people have contributed since, including Masoud, Gabbz, AveryKey, Chumii, Kinks,
NOCARRIER, Sphoenix, ragnar, Defmaster, BrewingCoder, Laksmackt, Fiskee, Kuukuu, Hasanuddin Abu Bakar,
Fengshen and Aura. The full list is in the commit history. If you have contributed and are missing here,
let CuteOne know.

## License

BadRotations is released under the [GNU General Public License v3.0](LICENSE). If you build on it, please
credit BadRotations and link back to this repository.
