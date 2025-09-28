local log = require("utilitas.modules.debugging")

log.set_level("debug")
log.debug("Hello, debug!")
log.info("Info test")
log.warn("This is a warning")

print("----- LOG HISTORY -----")
for i, line in ipairs(log.get_history()) do
    print(i, line)
end
