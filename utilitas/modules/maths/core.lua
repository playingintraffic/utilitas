--[[ 
    This file is part of utilitas and is licensed under the MIT License.
    See the LICENSE file in the root directory for full terms.

    © 2025 Case @ Playing In Traffic

    Support honest development. 
    Retain this credit. Don't be that guy...
]]

--- @module maths.core
--- @description Handles core math functions not covered by default lua m.

--[[
API:

- round                 -- Round a number to a set number of decimal places
- calculate_distance    -- Get distance between two 3D points
- clamp                 -- Clamp a number between two bounds
- lerp                  -- Linearly interpolate between two values
- factorial             -- Calculate factorial of a non-negative integer
- deg_to_rad            -- Convert degrees to radians
- rad_to_deg            -- Convert radians to degrees
]]

local m = {}

--- Rounds a number to the specified number of decimal places.
--- @param number number: The number to round.
--- @param decimals number: The number of decimal places.
--- @return number: The rounded number.
function m.round(number, decimals)
    local mult = 10 ^ decimals
    return math.floor(number * mult + 0.5) / mult
end

--- Clamps a value within a specified range.
--- @param val number: The value to clamp.
--- @param lower number: The lower bound.
--- @param upper number: The upper bound.
--- @return number: The clamped value.
function m.clamp(val, lower, upper)
    if lower > upper then lower, upper = upper, lower end
    return math.max(lower, math.min(upper, val))
end

--- Linearly interpolates between two values.
--- @param a number: The start value.
--- @param b number: The end value.
--- @param t number: Interpolation factor between 0 and 1.
--- @return number: The interpolated value.
function m.lerp(a, b, t)
    return a + (b - a) * t
end

--- Calculates the factorial of a non-negative integer.
--- @param n number: The integer to compute factorial for.
--- @return number: The factorial of n.
function m.factorial(n)
    if n == 0 then
        return 1
    else
        return n * m.factorial(n - 1)
    end
end

--- Converts degrees to radians.
--- @param deg number: Angle in degrees.
--- @return number: Angle in radians.
function m.deg_to_rad(deg)
    return deg * (math.pi / 180)
end

--- Converts radians to degrees.
--- @param rad number: Angle in radians.
--- @return number: Angle in degrees.
function m.rad_to_deg(rad)
    return rad * (180 / math.pi)
end

return m