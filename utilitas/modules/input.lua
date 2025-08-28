--[[ 
    This file is part of utilitas and is licensed under the MIT License.
    See the LICENSE file in the root directory for full terms.

    © 2025 Case @ Playing In Traffic

    Support honest development. 
    Retain this credit. Don't be that guy...
]]

--- @module input
--- @description Engine-agnostic input system

--[[
API:
- input.bind(action, key)            -- Bind a key or button to an action
- input.unbind(action, key?)         -- Unbind a key from an action, or remove all keys
- input.set_state(key, is_down)      -- Update key/button state from your engine
- input.trigger(action)              -- Manually trigger an action (e.g. mouse wheel)
- input.update(dt)                   -- Advance state each frame (call from update loop)
- input.is_down(action)              -- Check if action is currently held
- input.was_pressed(action)          -- Check if action was just pressed this frame
- input.was_released(action)         -- Check if action was just released this frame
]]

local input = {}

--- @section Tables

local bindings = {} -- action -> { key1, key2, ... }
local triggers = {} -- actions triggered manually this frame
local prev_state = {} -- action -> boolean (last frame)
local curr_state = {} -- action -> boolean (this frame)
local pressed = {} -- action -> boolean (pressed this frame)
local released = {} -- action -> boolean (released this frame)
local key_state = {} -- key -> boolean (raw key/button state, set externally)

--- @section Public Functions

--- Binds a key or button to a logical action name.
--- @param action string: Name of the action to bind (e.g. "jump", "shoot").
--- @param key string: Engine key identifier (e.g. "w", "space", "mouse1").
function input.bind(action, key)
    assert(type(action) == "string", "input.bind: action must be a string")
    assert(type(key) == "string", "input.bind: key must be a string")
    bindings[action] = bindings[action] or {}
    for _, k in ipairs(bindings[action]) do
        if k == key then return end
    end
    table.insert(bindings[action], key)
end

--- Unbinds a key from an action, or removes all keys if `key` is nil.
--- @param action string: The action to unbind from.
--- @param key? string: The specific key to unbind (optional).
function input.unbind(action, key)
    local b = bindings[action]
    if not b then return end
    if not key then
        bindings[action] = nil
        return
    end
    for i, k in ipairs(b) do
        if k == key then
            table.remove(b, i)
            break
        end
    end
    if #b == 0 then bindings[action] = nil end
end

--- Sets the state of a key or button (must be called externally from your engine).
--- @param key string: Engine key name (e.g. "space", "mouse1", "gamepad_x").
--- @param is_down boolean: Whether the key is currently pressed.
function input.set_state(key, is_down)
    key_state[key] = is_down
end

--- Triggers an action manually (bypassing bindings) — useful for wheel, gestures, etc.
--- @param action string: Action name to trigger this frame.
function input.trigger(action)
    triggers[action] = true
end

--- Updates all input states. Call this once per frame, typically from your engine's update loop.
--- @param dt number: Delta time in seconds (not used directly).
function input.update(dt)
    for a in pairs(curr_state) do
        prev_state[a] = curr_state[a]
    end

    for a in pairs(pressed) do pressed[a] = nil end
    for a in pairs(released) do released[a] = nil end

    for a in pairs(triggers) do
        curr_state[a] = true
        pressed[a] = true
    end
    triggers = {}

    for action, keys in pairs(bindings) do
        local was = curr_state[action] or false
        local now = false

        for _, key in ipairs(keys) do
            if key_state[key] then
                now = true
                break
            end
        end

        curr_state[action] = now
        if was and not now then
            released[action] = true
        elseif not was and now then
            pressed[action] = true
        end
    end
end

--- Returns true if the given action is currently held.
--- @param action string: The action name.
--- @return boolean: True if held.
function input.is_down(action)
    return curr_state[action] or false
end

--- Returns true if the action was pressed (went from up to down) this frame.
--- @param action string: The action name.
--- @return boolean: True if newly pressed.
function input.was_pressed(action)
    return pressed[action] or false
end

--- Returns true if the action was released (went from down to up) this frame.
--- @param action string: The action name.
--- @return boolean: True if newly released.
function input.was_released(action)
    return released[action] or false
end

return input