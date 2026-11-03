# Rinse Combat Opacity

Gives [Rinse](https://github.com/Otari98/Rinse) a separate opacity for combat. For WoW 1.12.

## Usage

Rinse's options window gets a new **Combat Opacity** slider, right under Rinse's own Opacity
slider. That one is renamed **OOC Opacity**, because it now only applies out of combat.

| When | Opacity |
|---|---|
| In combat | Combat Opacity (default 1.00) |
| Out of combat | OOC Opacity, Rinse's original slider |
| Mouse over the frame's title strip | Fully opaque, as in plain Rinse |

The debuff buttons sit in their own frame and stay fully visible, same as in plain Rinse.

To make room for the slider, the checkboxes below it move down a row and the window gets a
little taller. Combat Opacity is account-wide, like Rinse's own setting. Rinse's own files
aren't modified.

## Install

Add `https://github.com/daev-code/RinseCombatOpacity` to your launcher, or `git clone` it into
`Interface\AddOns`. Leave the `.git` folder in place: launchers that install from git need
it to pull updates.

You can also copy the folder to `Interface\AddOns\RinseCombatOpacity` yourself, but then
you'll need to update it yourself too.
