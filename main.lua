--- Drive Picker Plugin for Yazi
--- Shows all available Windows drives and lets you select one to navigate to

local function get_available_drives()
    local drives = {}
    local drive_letters = {
        "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M",
        "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"
    }
    
    -- Check each drive by trying to list its contents
    for _, letter in ipairs(drive_letters) do
        local drive_path = letter .. ":\\"
        
        -- Try to read the directory - if it fails, drive doesn't exist
        local handle = io.popen('dir "' .. drive_path .. '" 2>nul')
        if handle then
            local result = handle:read("*a")
            handle:close()
            
            -- If we got any output (not empty), the drive exists
            if result and #result > 0 then
                table.insert(drives, letter)
            end
        end
    end
    
    return drives
end

local function show_drive_picker()
    local drives = get_available_drives()
    
    if #drives == 0 then
        ya.notify {
            title = "Drive Picker",
            content = "No drives found",
            timeout = 3,
            level = "warn",
        }
        return
    end
    
    -- Build candidates for the picker
    local cands = {}
    for _, letter in ipairs(drives) do
        table.insert(cands, {
            on = letter:lower(),
            desc = letter .. ":\\ drive"
        })
    end
    
    -- Add escape option
    table.insert(cands, { on = "<Esc>", desc = "Cancel" })
    
    -- Show the picker and get selection
    local choice = ya.which { cands = cands, silent = false }
    
    if choice == nil or choice > #drives then
        return -- User cancelled or pressed Esc
    end
    
    local selected_drive = drives[choice]
    local drive_path = selected_drive .. ":\\"
    
    -- Navigate to the selected drive using the correct Yazi API
    ya.mgr_emit("cd", { drive_path })
end

return {
    entry = function()
        show_drive_picker()
    end,
}
