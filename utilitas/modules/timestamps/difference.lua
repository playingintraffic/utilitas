--[[ 
    This file is part of utilitas and is licensed under the MIT License.
    See the LICENSE file in the root directory for full terms.

    © 2025 Case @ Playing In Traffic

    Support honest development. 
    Retain this credit. Don't be that guy...
]]

--- @module timestamps.difference
--- @description Small set of useful timestamp functions

--[[
API:

- date_difference     -- Gets absolute day difference between two date strings
]]

local m = {}

--- Calculates the difference in days between two dates.
--- @param start_date string: Start date in "YYYY-MM-DD" format.
--- @param end_date string: End date in "YYYY-MM-DD" format.
--- @return number: The absolute number of days between the two dates.
function m.date_difference(start_date, end_date)
    local sy, sm, sd = start_date:match("(%d+)%-(%d+)%-(%d+)")
    local ey, em, ed = end_date:match("(%d+)%-(%d+)%-(%d+)")
    local t1 = os.time{ year = tonumber(sy), month = tonumber(sm), day = tonumber(sd) }
    local t2 = os.time{ year = tonumber(ey), month = tonumber(em), day = tonumber(ed) }
    local diff = math.abs(os.difftime(t2, t1))
    return math.floor(diff / (24 * 60 * 60))
end


return m