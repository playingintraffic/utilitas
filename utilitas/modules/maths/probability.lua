--- @module m.probabilty
--- @description Handles all probability based maths functions.

local m = {}

--- Returns a random float between min and max.
--- @param min number: Min value.
--- @param max number: Max value
--- @return number
function m.random_between(min, max)
    return min + math.random() * (max - min)
end

--- Selects a random choice from a mapping of options with weights.
--- @param map table: Table of weighted options.
--- @return The chosen option
function m.weighted_choice(map)
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

return m