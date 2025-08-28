--[[ 
    This file is part of utilitas and is licensed under the MIT License.
    See the LICENSE file in the root directory for full terms.

    © 2025 Case @ Playing In Traffic

    Support honest development. 
    Retain this credit. Don't be that guy...
]]

--- @module tables
--- @description Extension module for functions not covered by lua `table.` functions

--[[
API:
- tables.print         -- Recursively prints a table's contents for debugging
- tables.contains      -- Checks if a table contains a specific value (including nested)
- tables.deep_copy     -- Returns a deep copy of a table (recursive, with metatables)
- tables.deep_compare  -- Compares two tables for deep structural equality
]]

local tables = {}

--- @section Functions

--- Recursively prints a table's contents for debugging.
--- @param t table: The table to print.
--- @param indent string?: Used internally for nested indentation.
function tables.print(t, indent)
    indent = indent or ""
    for k, v in pairs(t) do
        if type(v) == "table" then
            print(indent .. tostring(k) .. ":")
            tables.print(v, indent .. "  ")
        else
            print(indent .. tostring(k) .. ": " .. tostring(v))
        end
    end
end

--- Checks if a table contains a specific value, searching nested tables.
--- @param tbl table: The table to check.
--- @param val any: The value to search for.
--- @return boolean: True if the value is found.
function tables.contains(tbl, val)
    for _, v in pairs(tbl) do
        if v == val then
            return true
        elseif type(v) == "table" and tables.contains(v, val) then
            return true
        end
    end
    return false
end

--- Creates a deep copy of a table.
--- @param orig table: The value to copy tables are duplicated recursively.
--- @return table: A deep copy of the original value.
function tables.deep_copy(orig)
    if type(orig) ~= "table" then
        return orig
    end
    local copy = {}
    for k, v in pairs(orig) do
        copy[tables.deep_copy(k)] = tables.deep_copy(v)
    end
    return setmetatable(copy, tables.deep_copy(getmetatable(orig)))
end

--- Deeply compares two tables for equality.
--- @param t1 table: The first value to compare.
--- @param t2 table: The second value to compare.
--- @return boolean: True if both values (and sub‑tables) are equal.
function tables.deep_compare(t1, t2)
    if t1 == t2 then
        return true
    end
    if type(t1) ~= "table" or type(t2) ~= "table" then
        return false
    end
    for k, v in pairs(t1) do
        if not tables.deep_compare(v, t2[k]) then
            return false
        end
    end
    for k in pairs(t2) do
        if t1[k] == nil then
            return false
        end
    end
    return true
end

return tables