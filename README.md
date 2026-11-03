# Rinse Combat Opacity

Companion addon for [Rinse](https://github.com/Otari98/Rinse) (WoW 1.12) that adds a
separate **in-combat opacity** for Rinse's frame.

## Usage

Rinse's options window gets a **Combat Opacity** slider right under Rinse's own Opacity
slider, which is relabelled **OOC Opacity**:

| State | Opacity |
|---|---|
| In combat | Combat Opacity (default 1.00) |
| Out of combat | Rinse's own (OOC) Opacity |
| Mouse over the frame's title strip | Fully opaque (Rinse's own behaviour) |

The debuff buttons are in their own frame and stay fully visible, as in Rinse itself.

The checkboxes under the new slider move down one slot and the options window grows to make
room. Combat Opacity is account-wide, like Rinse's own Opacity. Rinse's own files aren't
changed, so its folder stays a clean git clone.

## Install

- **With a launcher or git:** add `https://github.com/daev-code/RinseCombatOpacity` as an addon, or
  `git clone` it into `Interface\AddOns`. Keep the `.git` folder: launchers that install
  from git use it to fetch updates.
- **By hand:** copy this folder to `Interface\AddOns\RinseCombatOpacity`. Updates are then manual too.
