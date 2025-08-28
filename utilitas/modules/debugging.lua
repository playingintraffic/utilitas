--[[ 
    This file is part of utilitas and is licensed under the MIT License.
    See the LICENSE file in the root directory for full terms.

    © 2025 Case @ Playing In Traffic

    Support honest development. 
    Retain this credit. Don't be that guy...
]]

--- @module debugging
--- @description Simple colour-coded logger

local debugging = {}

--- Levels
local LEVELS = { "debug", "info", "success", "warn", "error" }

--- Map level to index
local LEVEL_INDEX = {}
for i, lvl in ipairs(LEVELS) do LEVEL_INDEX[lvl] = i end

--- Minimum level to show (default: "debug")
local min_level_index = LEVEL_INDEX.debug

-- Runtime flag to force colours on/off (nil = auto-detect)
local force_colour -- nil|boolean

--- Detect whether ANSI colours are supported in terminal.
local function ansi_supported()
    if force_colour ~= nil then return force_colour end
    
    -- Common envs that indicate ANSI support on Windows
    if jit and jit.os == "Windows" then
        if os.getenv("WT_SESSION")            -- Windows Terminal
        or os.getenv("ANSICON")               -- ANSICON shim
        or os.getenv("ConEmuANSI") == "ON"    -- ConEmu
        or os.getenv("TERM_PROGRAM")          -- VSCode integrated terminal / others
        or os.getenv("TERM")                  -- Some shells set this too
        then
            return true
        end
        -- Fall back
        return true
    end
    -- Non-Windows: assume supported
    return true
end

--- Active palette
local PALETTE

local function get_palette()
    if PALETTE then return PALETTE end
    if ansi_supported() then
        PALETTE = {
            debug = "\27[35m",
            info = "\27[36m",
            success = "\27[32m",
            warn = "\27[33m",
            error = "\27[31m",
            reset = "\27[0m",
        }
    else
        PALETTE = setmetatable({}, { __index = function() return "" end })
        PALETTE.reset = ""
    end
    return PALETTE
end

-- Shallow table serializer
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

local function serialize(v)
    return type(v) == "table" and table_to_string(v) or tostring(v)
end

--- Set minimum level that will be printed.
--- @param level string: Level to set
function debugging.set_level(level)
    assert(LEVEL_INDEX[level], "debugging.set_level: invalid level '" .. tostring(level) .. "'")
    min_level_index = LEVEL_INDEX[level]
end

--- Force colour on/off (overrides auto-detection). Call with nil to restore auto.
--- @param on boolean|nil: If colour is used or not
function debugging.use_colour(on)
    force_colour = on
    PALETTE = nil
end

--- Print a log line if `level` >= threshold.
--- @param level string: Log level to use
--- @param msg any: Message to send
--- @param data any|nil: Optional data table
function debugging.print(level, msg, data)
    local idx = LEVEL_INDEX[level]
    if not idx then error("debugging.print: unknown level '" .. tostring(level) .. "'", 2) end
    if idx < min_level_index then return false end

    local colours = get_palette()
    local line = ("%s[%s][%s]: %s"):format( colours[level] or "", os.date("%Y-%m-%d %H:%M:%S"), level:upper(), tostring(msg))

    if data ~= nil then
        line = line .. " " .. serialize(data)
    end

    print(line .. (colours.reset or ""))
    return true
end

-- Sugar helpers: debugging.debug/info/success/warn/error
for _, lvl in ipairs(LEVELS) do
    debugging[lvl] = function(msg, data)
        return debugging.print(lvl, msg, data)
    end
end

return debugging