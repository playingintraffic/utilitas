--[[ 
    This file is part of utilitas and is licensed under the MIT License.
    See the LICENSE file in the root directory for full terms.

    © 2025 Case @ Playing In Traffic

    Support honest development. 
    Retain this credit. Don't be that guy...
]]

--- @module runtime.callbacks
--- @description Lightweight callback _registry

--[[
API:
- register_callback         -- Add a callback by name (optionally overwrite)
- trigger_callback          -- Call a registered callback with arguments
- unregister_callback       -- Remove a callback by name
- callback_exists           -- Check if a callback is registered
- get_each_callback         -- Iterate all registered callbacks
]]

local m = {}

--- @section Tables

local _registry = {} -- internal name → function map

--- @section Module Functions

--- Register a callback.
--- @param name string: Unique key.
--- @param fn function: The function to store.
--- @param overwrite? boolean: Set true to replace an existing entry (default false).
function m.register_callback(name, fn, overwrite)
    assert(type(name) == "string",  "name must be string")
    assert(type(fn)  == "function", "fn must be function")
    if _registry[name] and not overwrite then
        error(("callback '%s' exists"):format(name), 2)
    end
    _registry[name] = fn
end

--- Trigger a callback.
--- @param name string: Key to look up.
--- @return ...: Whatever the stored function returns, or nil + error message.
function m.trigger_callback(name, ...)
    local cb = _registry[name]
    return cb and cb(...) or nil, ("callback '%s' not found"):format(name)
end

--- Remove a callback.
--- @param name string
function m.unregister_callback(name)
    _registry[name] = nil
end

--- Check whether a callback exists.
--- @param name string
--- @return boolean
function m.callback_exists(name)
    return _registry[name] ~= nil
end

--- Iterate over all m.
--- @return function iterator
function m.get_each_callback()
    return next, _registry
end

return m