local input = require("utilitas.modules.input")
local log = require("utilitas.modules.debugging")

-- Bind test keys
input.bind("jump", "space")
input.bind("shoot", "mouse1")

log.info("=== Frame 1: pressing space ===")
input.set_state("space", true)
input.update(0.016)
log.info("jump is_down", input.is_down("jump"))
log.info("jump was_pressed", input.was_pressed("jump"))

log.info("=== Frame 2: holding space ===")
input.update(0.016)
log.info("jump is_down", input.is_down("jump"))
log.info("jump was_pressed", input.was_pressed("jump"))

log.info("=== Frame 3: releasing space ===")
input.set_state("space", false)
input.update(0.016)
log.info("jump is_down", input.is_down("jump"))
log.info("jump was_released", input.was_released("jump"))

log.info("=== Frame 4: triggering shoot manually ===")
input.trigger("shoot")
input.update(0.016)
log.info("shoot was_pressed", input.was_pressed("shoot"))

log.success("test_input complete.")
