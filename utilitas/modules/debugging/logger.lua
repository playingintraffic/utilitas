--[[ 
    This file is part of utilitas and is licensed under the MIT License.
    See the LICENSE file in the root directory for full terms.

    © 2025 Case @ Playing In Traffic

    Support honest development. 
    Retain this credit. Don't be that guy...
]]

--- @module m
--- @description Simple colour-coded logger

local m = {}

--- @section Tables

local _levels = { "debug", "info", "success", "warn", "error", "fatal" }
local _level_index = {}

--- @section Vars

local _force_colour -- Runtime flag to force colours on/off (nil = auto-detect)
local _palette -- Active palette
local _min_level_index = _level_index.debug -- Minimum level to show (default: "debug")
local _history = {} -- History buffer
local _history_max = 100 -- Max line to store in buffer

--- Map level to index
for i, lvl in ipairs(_levels) do _level_index[lvl] = i end

--- Detect if ANSI colours are supported in terminal.
local function ansi_supported()
    if _force_colour ~= nil then return _force_colour end
    
    -- Common envs that indicate ANSI support on Windows
    if jit and jit.os == "Windows" then
        if os.getenv("WT_SESSION") or os.getenv("ANSICON") or os.getenv("ConEmuANSI") == "ON" or os.getenv("TERM_PROGRAM")  or os.getenv("TERM") then
            return true
        end
        return true
    end
    -- Non-Windows: assume supported
    return true
end

--- Retrieves or builds the ANSI color palette for log levels.
--- @return table palette: A table mapping log level names to ANSI color codes.
local function get_palette()
    if _palette then return _palette end
    if ansi_supported() then
        _palette = {
            debug = "\27[35m",
            info = "\27[36m",
            success = "\27[32m",
            warn = "\27[33m",
            error = "\27[31m",
            reset = "\27[0m",
        }
    else
        _palette = setmetatable({}, { __index = function() return "" end })
        _palette.reset = ""
    end
    return _palette
end

--- Serializes a Lua table into a string representation (shallow).
--- @param t table: The table to serialize.
--- @param depth? integer: Current recursion depth (internal use).
--- @param seen? table: Set of already visited tables (internal use).
--- @return string: A string representation of the table.
local function table_to_string(t, depth, seen)
    depth = depth or 0
    if depth > 3 then return "{…}" end
    seen = seen or {}
    if seen[t] then return "{cycle}" end
    seen[t] = true
    local parts = {}
    for k, v in pairs(t) do
        local key = tostring(k)
        local val
        if type(v) == "table" then
            val = table_to_string(v, depth + 1, seen)
        else
            val = type(v) == "string" and ("\"" .. v .. "\"") or tostring(v)
        end
        parts[#parts + 1] = key .. "=" .. val
    end
    return "{" .. table.concat(parts, ", ") .. "}"
end

--- Converts a value to string, handling tables with shallow serialization.
--- @param v any: The value to serialize.
--- @return string: String representation of the value.
local function serialize(v)
    return type(v) == "table" and table_to_string(v) or tostring(v)
end

--- Set minimum level that will be printed.
--- @param level string: Level to set
function m.set_level(level)
    assert(_level_index[level], "m.set_level: invalid level '" .. tostring(level) .. "'")
    _min_level_index = _level_index[level]
end

--- Force colour on/off (overrides auto-detection). Call with nil to restore auto.
--- @param on boolean|nil: If colour is used or not
function m.use_colour(on)
    _force_colour = on
    _palette = nil
end

--- Get the full log history.
--- @return table
function m.get_history()
    return _history
end

--- Print a stlised log with optional serialized data tables.
--- @param level string: Log level to use
--- @param msg any: Message to send
--- @param data any|nil: Optional data table
function m.print(level, msg, data)
    local idx = _level_index[level]
    if not idx then 
        idx = _min_level_index
    end

    local colours = get_palette()
    local ts = os.date("%Y-%m-%d %H:%M:%S")
    local line = ("%s [%s] [%s]: %s"):format(colours[level], ts, level:upper(), tostring(msg))

    if data ~= nil then
        line = line .. " " .. serialize(data)
    end

    line = line .. (colours.reset or "")

    print(line)

    _history[#_history + 1] = line
    if #_history > _history_max then
        table.remove(_history, 1)
    end

    if level == "fatal" then
        if not os.exit then
            print("[FATAL] os.exit not available — sandbox mode?")
        end
        os.exit(1)
    end

    return true
end

--- Sugar helpers: m.debug/info/success/warn/error
for _, lvl in ipairs(_levels) do
    m[lvl] = function(msg, data)
        return m.print(lvl, msg, data)
    end
end

return m