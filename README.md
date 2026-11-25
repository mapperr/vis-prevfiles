# vis-prevfile

A plugin for **vis 0.9 with Lua support**. Switch between the last two active files or browse the files you've visited in the current session.

## Installation

1. Copy `vis-prevfile.lua` to `~/.config/vis/`, or to `$XDG_CONFIG_HOME/vis/` if `XDG_CONFIG_HOME` is set.
2. Add `require('vis-prevfile')` to your `visrc.lua` after `require('vis')`.
3. Restart vis.

## Keybindings

Use these keys in Normal mode.

| Keys | Action |
| --- | --- |
| `Ctrl+6` | Toggle between the last two active files |
| `g[` | Go back one entry, toward older files |
| `g]` | Go forward one entry, toward newer files |
| `2` then `Ctrl+6` | Go back two entries |

You can also prefix `g[` and `g]` with a count. For example, `2g[` goes back two entries. The plugin handles `Ctrl+6` whether vis reads it as `<C-6>` or `<C-^>`.

## History

The plugin keeps up to **five distinct named files** in memory, including the active file if it has a name. Change `history_limit` at the top of `vis-prevfile.lua` to set a different limit.

When you switch files with vis commands, the file you visit moves to the front of the history. `g[` and `g]` follow the recorded order.

Open `a.lua`, `b.lua`, and `c.lua` in that order. From `c.lua`, press `g[` to go back to `b.lua`, then press `g[` again to reach `a.lua`. Press `g]` to return to `b.lua`.

If the target file is already open in a split, the plugin focuses that split. Otherwise, it reopens the file with `:e`, which uses the usual vis checks for unsaved changes.
