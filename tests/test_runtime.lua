local runtime = require("utilitas.modules.runtime")
local log = require("utilitas.modules.debugging")

log.info("Testing runtime callback registry...")

-- Register
runtime.register_callback("greet", function(name)
    return "Yo, " .. name
end)

-- Trigger
local result, err = runtime.trigger_callback("greet", "Case")
log.info("trigger_callback('greet', 'Case')", result) -- "Yo, Case"

-- Exists
log.info("callback_exists('greet')", runtime.callback_exists("greet")) -- true

-- Overwrite (fail)
local ok, msg = pcall(function()
    runtime.register_callback("greet", function() return "Nope" end)
end)
log.info("overwrite rejected", not ok) -- true

-- Overwrite (force)
runtime.register_callback("greet", function() return "Overwritten" end, true)
log.info("forced overwrite result", runtime.trigger_callback("greet")) -- "Overwritten"

-- Unregister + Check
runtime.unregister_callback("greet")
log.info("exists after unregister", runtime.callback_exists("greet")) -- false

--==[ Hook System ]==--

log.info("Testing runtime hook system...")

-- Register 2 hooks
local id1 = runtime.register_hook("on_hit", function(dmg)
    log.info("Hook 1 got damage", dmg)
end)

local id2 = runtime.register_hook("on_hit", function(dmg)
    log.info("Hook 2 got damage", dmg)
    return false -- stop propagation
end)

-- Trigger → should stop at hook 2
local allowed = runtime.trigger_hook("on_hit", 99)
log.info("trigger_hook blocked?", not allowed) -- true

-- Remove hook 2
runtime.unregister_hook("on_hit", id2)

-- Trigger again → should now pass
allowed = runtime.trigger_hook("on_hit", 42)
log.info("trigger_hook allowed?", allowed) -- true

log.success("[Test] Flattened namespaced runtime module test complete.\n")