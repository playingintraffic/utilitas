--[[ 
    This file is part of utilitas and is licensed under the MIT License.
    See the LICENSE file in the root directory for full terms.

    © 2025 Case @ Playing In Traffic

    Support honest development. 
    Retain this credit. Don't be that guy...
]]

--- @module strings
--- @description Extension module for functions not covered by lua `string.` functions

--[[
API:
- capitalize      -- Capitalizes the first letter of each word in a string
- split           -- Splits a string by a delimiter into a table
- trim            -- Removes leading and trailing whitespace
- random_string   -- Generates a random alphanumeric string
]]

local m = {}

--- @section Functions

--- Capitalizes the first letter of each word in a string.
--- @param str string: The string to capitalize.
--- @return string: The capitalized string.
function m.capitalize(str)
    return string.gsub(str, "(%a)([%w_']*)", function(first, rest)
        return first:upper() .. rest:lower()
    end)
end

--- Splits a string into a table based on a given delimiter.
--- @param str string: The string to split.
--- @param delimiter string: The delimiter to split by.
--- @return table: A list of substrings.
function m.split(str, delimiter)
    local result = {}
    for piece in (str .. delimiter):gmatch("(.-)" .. delimiter) do
        table.insert(result, piece)
    end
    return result
end

--- Trims whitespace from the beginning and end of a string.
--- @param str string: The string to trim.
--- @return string: The trimmed string.
function m.trim(str)
    return str:match("^%s*(.-)%s*$")
end

--- Generates a random alphanumeric string of a specified length.
--- @param length number: The length of the random string.
--- @return string: The generated string.
function m.random_string(length)
    local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local result = {}
    for i = 1, length do
        local idx = math.random(1, #chars)
        result[i] = chars:sub(idx, idx)
    end
    return table.concat(result)
end

return m