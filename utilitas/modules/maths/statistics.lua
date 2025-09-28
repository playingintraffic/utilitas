--- @module m.statistics
--- @description 

local m = {}

--- Calculates the mean of a list of numbers.
--- @param numbers table: The list of numbers.
--- @return number: The mean value.
function m.mean(numbers)
    local sum = 0
    for _, v in ipairs(numbers) do sum = sum + v end
    return sum / #numbers
end

--- Calculates the median of a list of numbers.
--- @param numbers table: The list of numbers.
--- @return number: The median value.
function m.median(numbers)
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
function m.mode(numbers)
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
function m.standard_deviation(numbers)
    local m = m.mean(numbers)
    local sum = 0
    for _, v in ipairs(numbers) do sum = sum + (v - m) ^ 2 end
    return math.sqrt(sum / #numbers)
end

--- Performs linear regression on a list of points.
--- @param points table: The list of points with {x:number,y:number}.
--- @return table: {slope:number,intercept:number} Regression coefficients.
function m.linear_regression(points)
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

return m