-- test_timestamps.lua
local timestamps = require("utilitas.modules.timestamps")
local log = require("utilitas.modules.debugging")

log.info("[Testing] Timestamp utilities...")

-- Convert current timestamp
local now = os.time()
local converted = timestamps.convert_timestamp(now)

log.info("Current timestamp", now)
log.info("Date", converted.date)
log.info("Time", converted.time)
log.info("Both", converted.both)

-- Add / subtract days
local base_date = "2025-09-28"
log.info("Base date", base_date)

local plus_5 = timestamps.add_days_to_date(base_date, 5)
local minus_10 = timestamps.add_days_to_date(base_date, -10)

log.info("Add 5 days", plus_5)
log.info("Subtract 10 days", minus_10)

-- Date difference
local d1 = "2025-09-01"
local d2 = "2025-09-28"
local diff = timestamps.date_difference(d1, d2)

log.info("Date 1", d1)
log.info("Date 2", d2)
log.info("Day difference", diff)

log.success("[Test] Timestamp tests complete.\n")