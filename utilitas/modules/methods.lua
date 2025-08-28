--[[ 
    This file is part of utilitas and is licensed under the MIT License.
    See the LICENSE file in the root directory for full terms.

    © 2025 Case @ Playing In Traffic

    Support honest development. 
    Retain this credit. Don't be that guy...
]]

--- @module methods
--- @description Simple event/hook system for decoupling and UGC-friendly modding.

--[[
API:
- methods.add        -- Register a callback for a named event, returns a unique ID
- methods.remove     -- Remove a specific callback by event name and ID
- methods.trigger    -- Trigger all callbacks for an event, stops if any return false
]]

local methods = {}

--- Internal registry: event_name -> { id -> callback }
local _registry = {}
local _next_id = 0

--- @section Functions

--- Adds a callback for a named event.
--- @param event string: The event name.
--- @param cb function: Callback to invoke when the event triggers.
--- @return number id: Unique identifier for this registration (use remove to unregister).
function methods.add(event, cb)
    assert(type(event) == "string", "methods.add: event must be a string")
    assert(type(cb) == "function", "methods.add: callback must be a function")
    _registry[event] = _registry[event] or {}
    _next_id = _next_id + 1
    _registry[event][_next_id] = cb
    return _next_id
end

--- Removes a previously registered callback.
--- @param event string: The event name.
--- @param id number: The registration id returned by add.
function methods.remove(event, id)
    local ev = _registry[event]
    if ev then ev[id] = nil end
end

--- Triggers all callbacks for an event.
--- If any callback returns false, iteration stops and false is returned.
--- @param event string: The event name.
--- @param ... any: Arguments passed to each callback.
--- @return boolean: True if none blocked, false otherwise.
function methods.trigger(event, ...)
    local ev = _registry[event]
    if not ev then return true end
    for id, cb in pairs(ev) do
        if cb(...) == false then
            return false
        end
    end
    return true
end

return methods