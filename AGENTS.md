# AGENTS.md - RinseCombatOpacity

Companion addon for [Rinse](https://github.com/Otari98/Rinse). What it does for players (settings, behaviour) is in `README.md`; this file covers internals and how to work on it.

Files: `RinseCombatOpacity.toc`, `RinseCombatOpacity.lua`, `README.md` (user docs), this file.

## How it hooks into Rinse

- Rinse's frame is `RinseFrame`. Its mouseover (`RinseFrameHitRect` OnEnter/OnLeave)
  sets alpha 1 and restores `RinseFrame.alpha`, which this addon keeps in step.
- The slider uses `RinseOptionsSliderTemplate`; `RinseOptionsFrameWyvernSting` is
  re-anchored under it and `RinseOptionsFrame` grows by 32 px.
- Rinse's own slider `OnValueChanged` is wrapped (via `GetScript`) to re-apply the alpha.
- Opacity switches on `PLAYER_REGEN_DISABLED` / `PLAYER_REGEN_ENABLED`; a 5x-a-second check
  re-applies it if anything else resets it.
- The value is `RINSE_CONFIG.COMBAT_OPACITY` (account-wide, next to `OPACITY`). The relabel
  is done through `Rinse.L.FMT_OPACITY`.

## Environment

- Client: WoW 1.12.1, so **Lua 5.0**: `table.getn` (no `#`),
  `string.find` / `string.gsub` (no `string.match` / `gmatch`), `math.mod`, varargs via `arg`.
- Scripts use the 1.12 globals `this`, `event`, `arg1`..`argN`. There is no `HookScript`:
  wrap with `GetScript` / `SetScript`, or replace global functions.
- SavedVariables are loaded after the addon's files: read settings in `ADDON_LOADED` /
  `PLAYER_LOGIN`, not at file load.
- No `_G` in plain Lua 5.0: use `getfenv(0)` or `getglobal()`.

## Working copy vs repo

Edit the files in this repo, not the game's copy. To test, copy the changed files into the
game's `Interface\AddOns\RinseCombatOpacity` folder and `/reload` in game. Before copying, check
that the game's copy still matches the last commit (for example by comparing hashes), so you
don't overwrite changes made there; if it doesn't, ask first.

The game folder's location is in your local, private instructions. If it isn't there, ask
for it. Never write it into this repo (it's public).

## Rules

- Never edit the addon this extends (`Rinse`). Its folder must stay a clean git clone
  of https://github.com/Otari98/Rinse. Everything goes in this companion addon.
- UI conventions: prefer buttons and settings over slash commands (slash commands only as
  show/hide/toggle shortcuts); muted, darkened status colours.
- Nothing here needs network access; go easy on external APIs.

## Pre-commit checklist

1. Update `README.md` for any user-visible change (settings, clicks, behaviour) and this file
   for internals (hooks, stored values, timing). Don't repeat one in the other.
2. Keep the header comment in the `.lua` in sync with what the code does.
3. There are no automated tests: verify in game (`/reload`, and a full relog when
   SavedVariables or the `.toc` changed). Say in the report what wasn't tested.
4. Copy the changed files into the game folder and test there, then commit code and docs
   together.
5. Don't commit scratch notes, logs or downloaded third-party files. The repo is public:
   keep personal details (names, local paths, account or character names) out of files and
   commit messages, and don't name the specific client, launcher, server or realm this is
   played on. Say "WoW 1.12" and link the repo of the addon being extended instead.
6. Use [Conventional Commits](https://www.conventionalcommits.org/) for commit messages
   and PR titles (`feat:`, `fix:`, `docs:`, `refactor:`, `chore:`). See `CONTRIBUTING.md`.
7. Before pushing a change players will notice, bump `## Version:` in the `.toc` once
   per push: minor (1.1.0 -> 1.2.0) when there's a `feat:`, patch (1.1.0 -> 1.1.1) for fixes
   only. Docs-only and other changes players don't notice don't need a bump.
