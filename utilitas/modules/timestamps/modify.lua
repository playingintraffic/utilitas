--[[ 
    This file is part of utilitas and is licensed under the MIT License.
    See the LICENSE file in the root directory for full terms.

    © 2025 Case @ Playing In Traffic

    Support honest development. 
    Retain this credit. Don't be that guy...
]]

--- @module timestamps.modify
--- @description Small set of useful timestamp functions

--[[
API:

- add_days_to_date    -- Adds (or subtracts) days to a date string (YYYY-MM-DD)
]]

local m = {}

--- Adds a number of days to a date string.
--- @param date_str string: Date in "YYYY-MM-DD" format.
--- @param days number: Number of days to add (can be negative).
--- @return string: New date in "YYYY-MM-DD" format.
function m.add_days_to_date(date_str, days)
    local y, m, d = date_str:match("(%d+)%-(%d+)%-(%d+)")
    local time = os.time{ year = tonumber(y), month = tonumber(m), day = tonumber(d) }
    local new_time = time + (days * 24 * 60 * 60)
    return os.date("%Y-%m-%d", new_time)
end

return m