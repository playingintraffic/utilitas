--[[ 
    This file is part of utilitas and is licensed under the MIT License.
    See the LICENSE file in the root directory for full terms.

    © 2025 Case @ Playing In Traffic

    Support honest development. 
    Retain this credit. Don't be that guy...
]]

--- @module maths
--- @description Extension module for functions not covered by lua `math.` functions

--[[
API:
- maths.round                 -- Round a number to a set number of decimal places
- maths.calculate_distance    -- Get distance between two 3D points
- maths.clamp                 -- Clamp a number between two bounds
- maths.lerp                  -- Linearly interpolate between two values
- maths.factorial             -- Calculate factorial of a non-negative integer
- maths.deg_to_rad            -- Convert degrees to radians
- maths.rad_to_deg            -- Convert radians to degrees
- maths.circle_circumference  -- Get circumference of a circle by radius
- maths.circle_area           -- Get area of a circle by radius
- maths.triangle_area         -- Get area of a triangle from 2D vertices
- maths.mean                  -- Get average (mean) of a list of numbers
- maths.median                -- Get median value from a list of numbers
- maths.mode                  -- Get mode (most frequent value) from a list
- maths.standard_deviation    -- Calculate standard deviation from a list
- maths.linear_regression     -- Perform linear regression on a set of {x,y} points
- maths.weighted_choice       -- Pick a random key from a table of weighted options
- maths.random_between        -- Get a random float between two values
]]

local maths = {}

--- @section Functions

--- Rounds a number to the specified number of decimal places.
--- @param number number: The number to round.
--- @param decimals number: The number of decimal places.
--- @return number: The rounded number.
function maths.round(number, decimals)
    local mult = 10 ^ decimals
    return math.floor(number * mult + 0.5) / mult
end

--- Calculates the distance between two 3D points.
--- @param start_coords table: {x:number,y:number,z:number} The starting coordinates.
--- @param end_coords table: {x:number,y:number,z:number} The ending coordinates.
--- @return number: The Euclidean distance between the two points.
function maths.calculate_distance(start_coords, end_coords)
    local dx = end_coords.x - start_coords.x
    local dy = end_coords.y - start_coords.y
    local dz = end_coords.z - start_coords.z
    return math.sqrt(dx * dx + dy * dy + dz * dz)
end

--- Clamps a value within a specified range.
--- @param val number: The value to clamp.
--- @param lower number: The lower bound.
--- @param upper number: The upper bound.
--- @return number: The clamped value.
function maths.clamp(val, lower, upper)
    if lower > upper then lower, upper = upper, lower end
    return math.max(lower, math.min(upper, val))
end

--- Linearly interpolates between two values.
--- @param a number: The start value.
--- @param b number: The end value.
--- @param t number: Interpolation factor between 0 and 1.
--- @return number: The interpolated value.
function maths.lerp(a, b, t)
    return a + (b - a) * t
end

--- Calculates the factorial of a non-negative integer.
--- @param n number: The integer to compute factorial for.
--- @return number: The factorial of n.
function maths.factorial(n)
    if n == 0 then
        return 1
    else
        return n * maths.factorial(n - 1)
    end
end

--- Converts degrees to radians.
--- @param deg number: Angle in degrees.
--- @return number: Angle in radians.
function maths.deg_to_rad(deg)
    return deg * (math.pi / 180)
end

--- Converts radians to degrees.
--- @param rad number: Angle in radians.
--- @return number: Angle in degrees.
function maths.rad_to_deg(rad)
    return rad * (180 / math.pi)
end

--- Calculates the circumference of a circle.
--- @param radius number: The circle radius.
--- @return number: The circumference.
function maths.circle_circumference(radius)
    return 2 * math.pi * radius
end

--- Calculates the area of a circle.
--- @param radius number: The circle radius.
--- @return number: The area.
function maths.circle_area(radius)
    return math.pi * radius ^ 2
end

--- Calculates the area of a triangle using its 2D vertices.
--- @param p1 table: {x:number,y:number} First vertex.
--- @param p2 table: {x:number,y:number} Second vertex.
--- @param p3 table: {x:number,y:number} Third vertex.
--- @return number: The triangle area.
function maths.triangle_area(p1, p2, p3)
    return math.abs((p1.x * (p2.y - p3.y) + p2.x * (p3.y - p1.y) + p3.x * (p1.y - p2.y)) / 2)
end

--- Calculates the mean of a list of numbers.
--- @param numbers table: The list of numbers.
--- @return number: The mean value.
function maths.mean(numbers)
    local sum = 0
    for _, v in ipairs(numbers) do sum = sum + v end
    return sum / #numbers
end

--- Calculates the median of a list of numbers.
--- @param numbers table: The list of numbers.
--- @return number: The median value.
function maths.median(numbers)
    table.sort(numbers)
    local n = #numbers
    if n % 2 == 0 then
        return (numbers[n/2] + numbers[n/2 + 1]) / 2
    else
        return numbers[math.ceil(n/2)]
    end
end

--- Calculates the mode of a list of numbers.
--- @param numbers table: The list of numbers.
--- @return number|nil: The mode value or nil if no single mode.
function maths.mode(numbers)
    local counts = {}
    for _, v in ipairs(numbers) do counts[v] = (counts[v] or 0) + 1 end
    local max_count, mode_val = 0, nil
    for v, count in pairs(counts) do
        if count > max_count then max_count, mode_val = count, v
        elseif count == max_count then mode_val = nil end
    end
    return mode_val
end

--- Calculates the standard deviation of a list of numbers.
--- @param numbers table: The list of numbers.
--- @return number: The standard deviation.
function maths.standard_deviation(numbers)
    local m = maths.mean(numbers)
    local sum = 0
    for _, v in ipairs(numbers) do sum = sum + (v - m) ^ 2 end
    return math.sqrt(sum / #numbers)
end

--- Performs linear regression on a list of points.
--- @param points table: The list of points with {x:number,y:number}.
--- @return table: {slope:number,intercept:number} Regression coefficients.
function maths.linear_regression(points)
    local n, sum_x, sum_y, sum_xx, sum_xy = #points, 0, 0, 0, 0
    for _, p in ipairs(points) do
        sum_x = sum_x + p.x
        sum_y = sum_y + p.y
        sum_xx = sum_xx + p.x * p.x
        sum_xy = sum_xy + p.x * p.y
    end
    local slope = (n * sum_xy - sum_x * sum_y) / (n * sum_xx - sum_x * sum_x)
    local intercept = (sum_y - slope * sum_x) / n
    return { slope = slope, intercept = intercept }
end

--- Selects a random choice from a mapping of options with weights.
--- @param map table: Table of weighted options.
--- @return The chosen option
function maths.weighted_choice(map)
    local total = 0
    for _, w in pairs(map) do
        if w > 0 then total = total + w end
    end
    if total == 0 then return nil end
    local thresh = math.random(total)
    local cumulative = 0
    for key, w in pairs(map) do
        if w > 0 then
            cumulative = cumulative + w
            if thresh <= cumulative then
                return key
            end
        end
    end
end

--- Returns a random float between min and max.
--- @param min number: Min value.
--- @param max number: Max value
--- @return number
function maths.random_between(min, max)
    return min + math.random() * (max - min)
end

return maths