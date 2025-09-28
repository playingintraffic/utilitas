--[[
    Test suite for utilitas.maths.maths module.

    Verifies: round, clamp, lerp, factorial, deg_to_rad, rad_to_deg.
]]

local log = require("utilitas.modules.debugging")
local maths = require("utilitas.modules.maths")

--- @section Core

log.set_level("debug")
log.info("[Test] Starting maths.core tests...")

-- Round
log.info("round(3.14159, 2)", maths.round(3.14159, 2)) -- 3.14
log.info("round(2.71828, 3)", maths.round(2.71828, 3)) -- 2.718
log.info("round(1.9999, 0)", maths.round(1.9999, 0)) -- 2

-- Clamp
log.info("clamp(5, 0, 10)", maths.clamp(5, 0, 10)) -- 5
log.info("clamp(-2, 0, 10)", maths.clamp(-2, 0, 10)) -- 0
log.info("clamp(20, 0, 10)", maths.clamp(20, 0, 10)) -- 10
log.info("clamp(5, 10, 0)", maths.clamp(5, 10, 0)) -- 5 (unordered inputs)

-- Lerp
log.info("lerp(0, 10, 0)", maths.lerp(0, 10, 0)) -- 0
log.info("lerp(0, 10, 0.5)", maths.lerp(0, 10, 0.5)) -- 5
log.info("lerp(0, 10, 1)", maths.lerp(0, 10, 1)) -- 10

-- Factorial
log.info("factorial(0)", maths.factorial(0)) -- 1
log.info("factorial(1)", maths.factorial(1)) -- 1
log.info("factorial(5)", maths.factorial(5)) -- 120
log.info("factorial(7)", maths.factorial(7)) -- 5040

-- Degrees/Radians
log.info("deg_to_rad(180)", maths.deg_to_rad(180)) -- ~π
log.info("rad_to_deg(math.pi)", maths.rad_to_deg(math.pi)) -- ~180

log.success("[Test] maths.core tests complete.\n")

--- @section Geometry 2D

log.info("[Test] Starting maths.geo2d tests...")

-- Triangle
local t_area = maths.triangle_area(
    { x = 0, y = 0 },
    { x = 5, y = 0 },
    { x = 0, y = 5 }
)
log.info("triangle_area", t_area) -- 12.5

-- Distance
local d = maths.distance_2d(
    { x = 0, y = 0 },
    { x = 3, y = 4 }
)
log.info("distance_2d (3-4-5)", d) -- 5

-- Point in Rect
local rect = { x = 0, y = 0, width = 10, height = 10 }
log.info("is_point_in_rect({5,5})",  maths.is_point_in_rect({ x = 5, y = 5 }, rect))  -- true
log.info("is_point_in_rect({15,5})", maths.is_point_in_rect({ x = 15, y = 5 }, rect)) -- false

-- Point on Line Segment
local ls1 = { x = 0, y = 0 }
local ls2 = { x = 10, y = 0 }
log.info("is_point_on_line_segment", maths.is_point_on_line_segment({ x = 5, y = 0 }, ls1, ls2)) -- true

-- Project Point on Line
local proj = maths.project_point_on_line(
    { x = 5, y = 5 },
    { x = 0, y = 0 },
    { x = 10, y = 0 }
)
log.info("project_point_on_line({5,5} onto 0-10)", proj)

-- Slope
log.info("calculate_slope(0,0 to 10,10)", maths.calculate_slope({ x = 0, y = 0 }, { x = 10, y = 10 })) -- 1

-- Angle
log.info("angle_between_points(0,0 to 1,0)", maths.angle_between_points({ x = 0, y = 0 }, { x = 1, y = 0 })) -- 0 degrees
log.info("angle_between_points(0,0 to 0,1)", maths.angle_between_points({ x = 0, y = 0 }, { x = 0, y = 1 })) -- 90 degrees

-- Circles intersect / point in circle
log.info("do_circles_intersect", maths.do_circles_intersect({ x = 0, y = 0 }, 5, { x = 6, y = 0 }, 5)) -- true
log.info("is_point_in_circle", maths.is_point_in_circle({ x = 2, y = 0 }, { x = 0, y = 0 }, 5))         -- true

-- Lines intersect
local a1 = { x = 0, y = 0 }
local a2 = { x = 10, y = 10 }
local b1 = { x = 0, y = 10 }
local b2 = { x = 10, y = 0 }
log.info("do_lines_intersect", maths.do_lines_intersect(a1, a2, b1, b2)) -- true

-- Line intersects circle
log.info("line_intersects_circle", maths.line_intersects_circle({ x = -5, y = 0 }, { x = 5, y = 0 }, { x = 0, y = 0 }, 3)) -- true

-- Rect intersects line
local rect2 = { x = 0, y = 0, width = 10, height = 10 }
log.info("does_rect_intersect_line", maths.does_rect_intersect_line(rect2, { x = -5, y = 5 }, { x = 15, y = 5 })) -- true

-- Closest point on line segment
local closest = maths.closest_point_on_line_segment(
    { x = 5, y = 5 },
    { x = 0, y = 0 },
    { x = 10, y = 0 }
)
log.info("closest_point_on_line_segment({5,5})", closest)

-- Point in convex polygon
local poly = {
    { x = 0, y = 0 },
    { x = 10, y = 0 },
    { x = 10, y = 10 },
    { x = 0, y = 10 }
}
log.info("is_point_in_convex_polygon (5,5)", maths.is_point_in_convex_polygon({ x = 5, y = 5 }, poly)) -- true

-- Rotate point
local rotated = maths.rotate_point_around_point_2d({ x = 1, y = 0 }, { x = 0, y = 0 }, 90)
log.info("rotate_point_around_point_2d 90 deg", rotated)

-- Distance point to plane
local dist_plane = maths.distance_point_to_plane(
    { x = 0, y = 0, z = 5 },
    { x = 0, y = 0, z = 0 },
    { x = 0, y = 0, z = 1 }
)
log.info("distance_point_to_plane", dist_plane) -- 5

log.success("[Test] maths.geo2d tests complete.\n")

--- @section Geometry 3D

log.info("[Test] Starting maths.geo3d tests...")

-- Distance (calculate_distance)
local d1 = maths.calculate_distance(
    { x = 0, y = 0, z = 0 },
    { x = 3, y = 4, z = 12 }
)
log.info("calculate_distance (3,4,12)", d1) -- 13

-- Distance (distance_3d)
local d2 = maths.distance_3d(
    { x = 1, y = 2, z = 3 },
    { x = 4, y = 6, z = 3 }
)
log.info("distance_3d (flat z)", d2) -- 5

-- Midpoint
local mid = maths.midpoint(
    { x = 0, y = 0, z = 0 },
    { x = 2, y = 4, z = 6 }
)
log.info("midpoint", mid) -- { x = 1, y = 2, z = 3 }

-- Point in Box
local box = { x = 0, y = 0, z = 0, width = 10, height = 10, depth = 10 }
log.info("is_point_in_box (5,5,5)",   maths.is_point_in_box({ x = 5, y = 5, z = 5 }, box))   -- true
log.info("is_point_in_box (15,5,5)",  maths.is_point_in_box({ x = 15, y = 5, z = 5 }, box))  -- false
log.info("is_point_in_box (5,15,5)",  maths.is_point_in_box({ x = 5, y = 15, z = 5 }, box))  -- false
log.info("is_point_in_box (5,5,15)",  maths.is_point_in_box({ x = 5, y = 5, z = 15 }, box))  -- false

-- Angle Between 3 Points
local angle = maths.angle_between_3_points(
    { x = 1, y = 0, z = 0 },
    { x = 0, y = 0, z = 0 },
    { x = 0, y = 1, z = 0 }
)
log.info("angle_between_3_points (right angle)", angle) -- ~90 degrees

-- Triangle Area 3D
local area = maths.triangle_area_3d(
    { x = 0, y = 0, z = 0 },
    { x = 1, y = 0, z = 0 },
    { x = 0, y = 1, z = 0 }
)
log.info("triangle_area_3d (flat XY)", area) -- 0.5

-- Point in Sphere
log.info("is_point_in_sphere (inside)", maths.is_point_in_sphere(
    { x = 1, y = 1, z = 1 },
    { x = 0, y = 0, z = 0 },
    2
)) -- true

log.info("is_point_in_sphere (outside)", maths.is_point_in_sphere(
    { x = 3, y = 3, z = 3 },
    { x = 0, y = 0, z = 0 },
    2
)) -- false

-- Spheres Intersect
log.info("do_spheres_intersect (yes)", maths.do_spheres_intersect(
    { x = 0, y = 0, z = 0 },
    5,
    { x = 4, y = 0, z = 0 },
    2
)) -- true

log.info("do_spheres_intersect (no)", maths.do_spheres_intersect(
    { x = 0, y = 0, z = 0 },
    1,
    { x = 5, y = 5, z = 5 },
    1
)) -- false

log.success("[Test] maths.geo3d tests complete.\n")

--- @section Matrix 4x4

log.info("[Test] Starting maths.mat4 tests...")

-- Identity
local id = maths.identity()
log.info("identity matrix", id)

-- Perspective matrix
local perspective = maths.perspective(90, 1.0, 0.1, 100)
log.info("perspective matrix (90 fov, 1:1)", perspective)

-- Look-at matrix
local eye    = { 0, 0, 5 }
local target = { 0, 0, 0 }
local up     = { 0, 1, 0 }
local view   = maths.look_at(eye, target, up)
log.info("look_at matrix (eye at 0,0,5)", view)

-- Multiply identity with perspective (should return perspective)
local mul = maths.multiply(id, perspective)
log.info("multiply identity * perspective", mul)

-- Invert a matrix (invert of identity is identity)
local inv = maths.invert(id)
if inv then
    log.info("invert identity", inv)
else
    log.error("invert identity failed")
end

-- Invert perspective (just test it's not nil, since result is complex)
local inv_perspective = maths.invert(perspective)
if inv_perspective then
    log.info("invert perspective succeeded")
else
    log.warn("invert perspective failed (likely non-invertible)")
end

-- Transpose
local t = maths.transpose(perspective)
log.info("transpose perspective", t)

log.success("[Test] maths.mat4 tests complete.\n")

--- @section Probability

log.info("[Test] Starting maths.probability tests...")

-- Random float between
local r = maths.random_between(5, 10)
log.info("random_between(5,10)", r)
assert(r >= 5 and r <= 10, "random_between out of bounds")

-- Weighted choice
local choices = { apple = 5, banana = 1, orange = 0 }
local result_counts = { apple = 0, banana = 0 }
for _ = 1, 1000 do
    local choice = maths.weighted_choice(choices)
    if choice then result_counts[choice] = result_counts[choice] + 1 end
end
log.info("weighted_choice sampling (1000 runs)", result_counts)

-- Zero weight edge case
local bad_choice = maths.weighted_choice({ a = 0, b = 0 })
log.info("weighted_choice all zero", bad_choice) -- Should be nil

log.success("[Test] maths.probability tests complete.\n")

--- @section Statistics

log.info("[Test] Starting maths.statistics tests...")

local _numbers = { 1, 2, 2, 3, 4, 5 }

-- Mean
local mean = maths.mean(_numbers)
log.info("mean", mean) -- 2.833...

-- Median
local median = maths.median({ 1, 2, 3, 4 }) -- Even count
log.info("median (even)", median) -- 2.5
log.info("median (odd)", maths.median({ 5, 2, 3 })) -- 3

-- Mode
log.info("mode", maths.mode(_numbers)) -- 2
log.info("mode (no single mode)", maths.mode({ 1, 2, 2, 3, 3 })) -- nil

-- Standard deviation
local stddev = maths.standard_deviation(_numbers)
log.info("standard_deviation", stddev)

-- Linear regression
local points = {
    { x = 1, y = 2 },
    { x = 2, y = 4 },
    { x = 3, y = 6 },
}
local lr = maths.linear_regression(points)
log.info("linear_regression slope", lr.slope)       -- ~2
log.info("linear_regression intercept", lr.intercept) -- ~0

log.success("[Test] maths.statistics tests complete.\n")
