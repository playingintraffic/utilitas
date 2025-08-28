--[[ 
    This file is part of utilitas and is licensed under the MIT License.
    See the LICENSE file in the root directory for full terms.

    © 2025 Case @ Playing In Traffic

    Support honest development. 
    Retain this credit. Don't be that guy...
]]

--- @module utilitas
--- @description Root namespace loader for the utilitas toolkit

local utilitas = {} -- Public interface

--- @section Tables

--- List of known sub‑modules (no path or extension).
local _modules = {
    "callbacks",
    "debugging",
    "geometry",
    "maths",
    "methods",
    "strings",
    "tables",
    "timestamps"
}

--- Cache of already‑required modules.
local _cache = {} -- name -> module

--- @section Internal Functions

--- Require a module (or return cached version).
--- Also makes it available as `require("utilitas.<name>")`.
--- @param name string: Module name without path.
--- @return table: The loaded module.
local function _load(name)
    local mod = _cache[name]
    if not mod then
        mod = require("utilitas.modules." .. name)
        _cache[name] = mod
        package.loaded["utilitas." .. name] = mod
    end
    return mod
end

--- @section API

--- Lists all available utilitas modules.
--- @return string[]: List of module names.
function utilitas.list()
    return _modules
end

--- @section Loader Metatable

setmetatable(utilitas, {
    -- Lazy-load submodules (e.g. utilitas.geometry)
    __index = function(_, key)
        if not _cache[key] and not table.find(_modules, key) then
            error(("utilitas: No module named '%s'"):format(key), 2)
        end
        return _load(key)
    end,

    -- Prevent assignment to the namespace
    __newindex = function(_, key, value)
        error(("Attempted to assign to utilitas.%s after initialization"):format(key), 2)
    end,
})

--- @section Eager preload

-- Load all modules now (helps with autocompletion or preload optimizations).
for _, name in ipairs(_modules) do
    _load(name)
end

--- @type table<string, table>
return utilitas