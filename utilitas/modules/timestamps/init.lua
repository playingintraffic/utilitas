--[[ 
    This file is part of utilitas and is licensed under the MIT License.
    See the LICENSE file in the root directory for full terms.

    © 2025 Case @ Playing In Traffic

    Support honest development. 
    Retain this credit. Don't be that guy...
]]

--- @module timestamps.init
--- @description Single access loader for all timestamps modules.

local m = {}

m.convert = require(... .. ".convert")
m.difference = require(... .. ".difference")
m.modify = require(... .. ".modify")

--- Safely promote selected functions into the maths root table
--- Delayed promotion ensures all modules are fully loaded before merging
local promotions = {}
for _, submod in pairs(m) do
    if type(submod) == "table" then
        for k, v in pairs(submod) do
            promotions[k] = v
        end
    end
end

for k, v in pairs(promotions) do
    m[k] = v
end

return m