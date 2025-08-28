--[[ 
    This file is part of utilitas and is licensed under the MIT License.
    See the LICENSE file in the root directory for full terms.

    © 2025 Case @ Playing In Traffic

    Support honest development. 
    Retain this credit. Don't be that guy...
]]

--- @module timestamps
--- @description Small set of useful timestamp functions

--[[
API:
- timestamps.convert_timestamp   -- Converts UNIX timestamp to { date, time, both }
- timestamps.add_days_to_date    -- Adds (or subtracts) days to a date string (YYYY-MM-DD)
- timestamps.date_difference     -- Gets absolute day difference between two date strings
]]

local timestamps = {}

--- @section Functions

--- Converts a UNIX timestamp (seconds) to date/time components.
--- @param ts number: UNIX timestamp in seconds.
--- @return table
function timestamps.convert_timestamp(ts)
    return {
        date = os.date("%Y-%m-%d", ts),
        time = os.date("%H:%M:%S", ts),
        both = os.date("%Y-%m-%d %H:%M:%S", ts)
    }
end

--- Adds a number of days to a date string.
--- @param date_str string: Date in "YYYY-MM-DD" format.
--- @param days number: Number of days to add (can be negative).
--- @return string: New date in "YYYY-MM-DD" format.
function timestamps.add_days_to_date(date_str, days)
    local y, m, d = date_str:match("(%d+)%-(%d+)%-(%d+)")
    local time = os.time{ year = tonumber(y), month = tonumber(m), day = tonumber(d) }
    local new_time = time + (days * 24 * 60 * 60)
    return os.date("%Y-%m-%d", new_time)
end

--- Calculates the difference in days between two dates.
--- @param start_date string: Start date in "YYYY-MM-DD" format.
--- @param end_date string: End date in "YYYY-MM-DD" format.
--- @return number: The absolute number of days between the two dates.
function timestamps.date_difference(start_date, end_date)
    local sy, sm, sd = start_date:match("(%d+)%-(%d+)%-(%d+)")
    local ey, em, ed = end_date:match("(%d+)%-(%d+)%-(%d+)")
    local t1 = os.time{ year = tonumber(sy), month = tonumber(sm), day = tonumber(sd) }
    local t2 = os.time{ year = tonumber(ey), month = tonumber(em), day = tonumber(ed) }
    local diff = math.abs(os.difftime(t2, t1))
    return math.floor(diff / (24 * 60 * 60))
end


return timestamps