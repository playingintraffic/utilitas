--[[ 
    This file is part of utilitas and is licensed under the MIT License.
    See the LICENSE file in the root directory for full terms.

    © 2025 Case @ Playing In Traffic

    Support honest development. 
    Retain this credit. Don't be that guy...
]]

--- @module timestamps.convert
--- @description Small set of useful timestamp functions

--[[
API:

- convert_timestamp   -- Converts UNIX timestamp to { date, time, both }
]]

local m = {}

--- @section Functions

--- Converts a UNIX timestamp (seconds) to date/time components.
--- @param ts number: UNIX timestamp in seconds.
--- @return table
function m.convert_timestamp(ts)
    return {
        date = os.date("%Y-%m-%d", ts),
        time = os.date("%H:%M:%S", ts),
        both = os.date("%Y-%m-%d %H:%M:%S", ts)
    }
end

return m