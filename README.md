# Yazi-Drive-Picker

This lets you see what external drives there are. Press g then a to get a list of all external drives.

create AppData/Roaming/yazi/config/plugins/drive-picker.yazi
copy the main.lua there

then add: { on = [ "g", "a" ], run = "plugin drive-picker", desc = "Show all drives" },
to AppData/Roaming/yazi/config/keymap.toml

