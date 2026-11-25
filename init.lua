-- Load after require('vis') in visrc.lua.
local alternate_keys = { '<C-6>', '<C-^>' }
local history_limit = 5
local history = {}
local current_path, previous_path
local jumping = false

local function active_path()
    local win = vis.win
    return win and win.file.path
end

local function history_index(path)
    for index, entry in ipairs(history) do
        if entry == path then
            return index
        end
    end
end

local function record_visit(path, keep_order)
    if not path or path == current_path then
        return
    end

    local index = history_index(path)
    if not keep_order or not index then
        if index then
            table.remove(history, index)
        end
        table.insert(history, 1, path)
        if #history > history_limit then
            table.remove(history)
        end
    end
    previous_path, current_path = current_path, path
end

local function remember_file()
    if not jumping then
        record_visit(active_path())
    end
end

local function reopen_file(path)
    if path:find("[*?%[{$`;&|<>()\n]") then
        -- Vis 0.9 sends patterns to vis-open using a shell command.
        if path:find('[%s*]$') then
            vis:info('Questo nome non può essere riaperto con :e')
            return
        end
        path = "'" .. path:gsub("'", [['\'']]) .. "'${0:+}"
    end

    local escaped = path:gsub('[\\"]', '\\%0')
    vis:command('e "' .. escaped .. '"')
end

local function focus_or_reopen(path)
    for win in vis:windows() do
        if win.file.path == path then
            vis.win = win
            return
        end
    end
    reopen_file(path)
end

local function jump_to(path)
    if not path then
        return
    end

    -- Reopening a file can emit WIN_OPEN before the command returns.
    jumping = true
    local ok, err = pcall(focus_or_reopen, path)
    jumping = false
    if not ok then
        error(err, 0)
    end

    local opened_path = active_path()
    record_visit(opened_path, opened_path == path)
end

local function jump_by(offset)
    local index = history_index(current_path)
    if index then
        jump_to(history[index + offset])
    end
end

local function take_count()
    local count = vis.count
    vis.count = nil
    return count
end

local function switch_file()
    remember_file()
    local count = take_count()
    if count then
        jump_by(count)
        return 0
    end

    local target = previous_path
    if not active_path() then
        target = current_path
    end
    if target then
        jump_to(target)
    else
        vis:info('Nessun file precedente')
    end
    return 0
end

local function move_history(direction)
    remember_file()
    jump_by(direction * (take_count() or 1))
    return 0
end

vis.events.subscribe(vis.events.WIN_OPEN, remember_file)
vis.events.subscribe(vis.events.UI_DRAW, remember_file)

local normal = vis.modes.NORMAL
for _, key in ipairs(alternate_keys) do
    vis:map(normal, key, switch_file, 'Alterna gli ultimi due file o torna indietro di N posizioni')
end

vis:map(normal, 'g[', function() return move_history(1) end, 'Indietro nella cronologia dei file')
vis:map(normal, 'g]', function() return move_history(-1) end, 'Avanti nella cronologia dei file')
