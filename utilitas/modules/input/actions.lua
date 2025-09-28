--[[ 
    This file is part of utilitas and is licensed under the MIT License.
    See the LICENSE file in the root directory for full terms.

    © 2025 Case @ Playing In Traffic

    Support honest development. 
    Retain this credit. Don't be that guy...
]]

--- @module input.actions
--- @description Agnostic system to handle input actions.

--[[
API:
- bind(action, key)            -- Bind a key or button to an action
- unbind(action, key?)         -- Unbind a key from an action, or remove all keys
- set_state(key, is_down)      -- Update key/button state from your engine
- trigger(action)              -- Manually trigger an action (e.g. mouse wheel)
- update(dt)                   -- Advance state each frame (call from update loop)
- is_down(action)              -- Check if action is currently held
- was_pressed(action)          -- Check if action was just pressed this frame
- was_released(action)         -- Check if action was just released this frame
]]

local m = {}

--- @section Tables

-- Internal state
local _bindings = {} -- action -> { key1, key2, ... }
local _triggers = {} -- actions triggered manually this frame
local _prev_state = {} -- action -> boolean (last frame)
local _curr_state = {} -- action -> boolean (this frame)
local _pressed = {} -- action -> boolean (_pressed this frame)
local _released = {} -- action -> boolean (_released this frame)
local _key_state = {} -- key -> boolean (raw key/button state, set externally)

--- @section API

--- Binds a key or button to a logical action name.
--- @param action string: Name of the action to bind (e.g. "jump", "shoot").
--- @param key string: Engine key identifier (e.g. "w", "space", "mouse1").
function m.bind(action, key)
    assert(type(action) == "string", "m.bind: action must be a string")
    assert(type(key) == "string", "m.bind: key must be a string")
    _bindings[action] = _bindings[action] or {}
    for _, k in ipairs(_bindings[action]) do
        if k == key then return end
    end
    table.insert(_bindings[action], key)
end

--- Unbinds a key from an action, or removes all keys if `key` is nil.
--- @param action string: The action to unbind from.
--- @param key? string: The specific key to unbind (optional).
function m.unbind(action, key)
    local b = _bindings[action]
    if not b then return end
    if not key then
        _bindings[action] = nil
        return
    end
    for i, k in ipairs(b) do
        if k == key then
            table.remove(b, i)
            break
        end
    end
    if #b == 0 then _bindings[action] = nil end
end

--- Sets the state of a key or button (must be called externally from your engine).
--- @param key string: Engine key name (e.g. "space", "mouse1", "gamepad_x").
--- @param is_down boolean: Whether the key is currently _pressed.
function m.set_state(key, is_down)
    _key_state[key] = is_down
end

--- _triggers an action manually (bypassing _bindings) — useful for wheel, gestures, etc.
--- @param action string: Action name to trigger this frame.
function m.trigger(action)
    _triggers[action] = true
end

--- Updates all m states. Call this once per frame, typically from your engine's update loop.
--- @param dt number: Delta time in seconds (not used directly).
function m.update(dt)
    for a in pairs(_curr_state) do
        _prev_state[a] = _curr_state[a]
    end

    for a in pairs(_pressed) do _pressed[a] = nil end
    for a in pairs(_released) do _released[a] = nil end

    for a in pairs(_triggers) do
        _curr_state[a] = true
        _pressed[a] = true
    end
    _triggers = {}

    for action, keys in pairs(_bindings) do
        local was = _curr_state[action] or false
        local now = false

        for _, key in ipairs(keys) do
            if _key_state[key] then
                now = true
                break
            end
        end

        _curr_state[action] = now
        if was and not now then
            _released[action] = true
        elseif not was and now then
            _pressed[action] = true
        end
    end
end

--- Returns true if the given action is currently held.
--- @param action string: The action name.
--- @return boolean: True if held.
function m.is_down(action)
    return _curr_state[action] or false
end

--- Returns true if the action was _pressed (went from up to down) this frame.
--- @param action string: The action name.
--- @return boolean: True if newly _pressed.
function m.was_pressed(action)
    return _pressed[action] or false
end

--- Returns true if the action was _released (went from down to up) this frame.
--- @param action string: The action name.
--- @return boolean: True if newly _released.
function m.was_released(action)
    return _released[action] or false
end

return m