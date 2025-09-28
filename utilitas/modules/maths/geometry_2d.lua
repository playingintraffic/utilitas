--[[ 
    This file is part of utilitas and is licensed under the MIT License.
    See the LICENSE file in the root directory for full terms.

    © 2025 Case @ Playing In Traffic

    Support honest development. 
    Retain this credit. Don't be that guy...
]]

--- @module maths.geometry_2d
--- @description Handles all 2D geometry functions, is short hand to geo2d for imports.

--[[
API:

- circle_circumference              -- Get circumference of a circle by radius
- circle_area                       -- Get area of a circle by radius
- triangle_area                     -- Get area of a triangle from 2D vertices
- distance_2d                       -- Get Euclidean distance between two 2D points
- is_point_in_rect                  -- Check if a 2D point is inside a rectangle
- is_point_on_line_segment          -- Check if a point lies exactly on a 2D line segment
- project_point_on_line             -- Project a point onto a 2D line segment
- calculate_slope                   -- Calculate slope between two 2D points
- angle_between_points              -- Get angle in degrees between two 2D points
- do_circles_intersect              -- Check if two circles intersect
- is_point_in_circle                -- Check if a point is inside a circle
- do_lines_intersect                -- Check if two 2D line segments intersect
- line_intersects_circle            -- Check if a line intersects a circle
- does_rect_intersect_line          -- Check if a rectangle intersects a line segment
- closest_point_on_line_segment     -- Get nearest point on a line segment to another point
- is_point_in_convex_polygon        -- Determine if a point is inside a convex polygon
- rotate_point_around_point_2d      -- Rotate a 2D point around a pivot
- distance_point_to_plane           -- Get perpendicular distance from a point to a 3D plane
]]

local m = {}

--- Calculates the circumference of a circle.
--- @param radius number: The circle radius.
--- @return number: The circumference.
function m.circle_circumference(radius)
    return 2 * math.pi * radius
end

--- Calculates the area of a circle.
--- @param radius number: The circle radius.
--- @return number: The area.
function m.circle_area(radius)
    return math.pi * radius ^ 2
end

--- Calculates the area of a triangle using its 2D vertices.
--- @param p1 table: {x:number,y:number} First vertex.
--- @param p2 table: {x:number,y:number} Second vertex.
--- @param p3 table: {x:number,y:number} Third vertex.
--- @return number: The triangle area.
function m.triangle_area(p1, p2, p3)
    return math.abs((p1.x * (p2.y - p3.y) + p2.x * (p3.y - p1.y) + p3.x * (p1.y - p2.y)) / 2)
end

--- Calculates the distance between two 2D points.
--- @param p1 table: The first point (x, y).
--- @param p2 table: The second point (x, y).
--- @return number: The Euclidean distance between the two points.
function m.distance_2d(p1, p2)
    return math.sqrt((p2.x - p1.x)^2 + (p2.y - p1.y)^2)
end

--- Determines if a point is inside a given 2D rectangle boundary.
--- @param point table: The point to check (x, y).
--- @param rect table: The rectangle (x, y, width, height).
--- @return boolean: True if the point is inside the rectangle, false otherwise.
function m.is_point_in_rect(point, rect)
    return point.x >= rect.x and point.x <= (rect.x + rect.width) and point.y >= rect.y and point.y <= (rect.y + rect.height)
end

--- Determines if a point is on a line segment defined by two 2D points.
--- @param point table: The point to check (x, y).
--- @param line_start table: The starting point of the line segment (x, y).
--- @param line_end table: The ending point of the line segment (x, y).
--- @return boolean: True if the point is on the line segment, false otherwise.
function m.is_point_on_line_segment(point, line_start, line_end)
    return m.distance_2d(point, line_start) + m.distance_2d(point, line_end) == m.distance_2d(line_start, line_end)
end

--- Projects a point onto a line segment defined by two 2D points.
--- @param p table: The point to project (x, y).
--- @param p1 table: The starting point of the line segment (x, y).
--- @param p2 table: The ending point of the line segment (x, y).
--- @return table: The projected point (x, y).
function m.project_point_on_line(p, p1, p2)
    local l2 = (p2.x-p1.x)^2 + (p2.y-p1.y)^2
    local t = ((p.x-p1.x)*(p2.x-p1.x) + (p.y-p1.y)*(p2.y-p1.y)) / l2

    return {x = p1.x + t * (p2.x - p1.x), y = p1.y + t * (p2.y - p1.y)}
end

--- Calculates the slope of a line given two 2D points.
--- @param p1 table: The first point (x, y).
--- @param p2 table: The second point (x, y).
--- @return number: The slope of the line. Returns nil if the slope is undefined (vertical line).
function m.calculate_slope(p1, p2)
    if p2.x - p1.x == 0 then
        return nil
    end

    return (p2.y - p1.y) / (p2.x - p1.x)
end

--- Returns the angle between two 2D points in degrees.
--- @param p1 table: The first point (x, y).
--- @param p2 table: The second point (x, y).
--- @return number: The angle in degrees.
function m.angle_between_points(p1, p2)
    return math.atan2(p2.y - p1.y, p2.x - p1.x) * (180 / math.pi)
end

--- Determines if two circles defined by center and radius intersect.
--- @param c1_center table: The center of the first circle (x, y).
--- @param c1_radius number: The radius of the first circle.
--- @param c2_center table: The center of the second circle (x, y).
--- @param c2_radius number: The radius of the second circle.
--- @return boolean: True if the circles intersect, false otherwise.
function m.do_circles_intersect(c1_center, c1_radius, c2_center, c2_radius)
    return m.distance_2d(c1_center, c2_center) <= (c1_radius + c2_radius)
end

--- Determines if a point is inside a circle defined by center and radius.
--- @param point table: The point to check (x, y).
--- @param circle_center table: The center of the circle (x, y).
--- @param circle_radius number: The radius of the circle.
--- @return boolean: True if the point is inside the circle, false otherwise.
function m.is_point_in_circle(point, circle_center, circle_radius)
    return m.distance_2d(point, circle_center) <= circle_radius
end

--- Determines if two 2D line segments intersect.
--- @param l1_start table: The starting point of the first line segment (x, y).
--- @param l1_end table: The ending point of the first line segment (x, y).
--- @param l2_start table: The starting point of the second line segment (x, y).
--- @param l2_end table: The ending point of the second line segment (x, y).
--- @return boolean: True if the line segments intersect, false otherwise.
function m.do_lines_intersect(l1_start, l1_end, l2_start, l2_end)
    local function ccw(a, b, c)
        return (c.y-a.y) * (b.x-a.x) > (b.y-a.y) * (c.x-a.x)
    end

    return ccw(l1_start, l2_start, l2_end) ~= ccw(l1_end, l2_start, l2_end) and ccw(l1_start, l1_end, l2_start) ~= ccw(l1_start, l1_end, l2_end)
end

--- Determines if a line segment intersects a circle.
--- @param line_start table: Starting point of the line (x, y).
--- @param line_end table: Ending point of the line (x, y).
--- @param circle_center table: Center of the circle (x, y).
--- @param circle_radius number: Radius of the circle.
--- @return boolean: True if the line intersects the circle, false otherwise.
function m.line_intersects_circle(line_start, line_end, circle_center, circle_radius)
    local d = {x = line_end.x - line_start.x, y = line_end.y - line_start.y}
    local f = {x = line_start.x - circle_center.x, y = line_start.y - circle_center.y}
    local a = d.x^2 + d.y^2
    local b = 2 * (f.x * d.x + f.y * d.y)
    local c = (f.x^2 + f.y^2) - circle_radius^2
    local discriminant = b^2 - 4 * a * c

    if discriminant >= 0 then
        discriminant = math.sqrt(discriminant)
        local t1 = (-b - discriminant) / (2 * a)
        local t2 = (-b + discriminant) / (2 * a)
        if t1 >= 0 and t1 <= 1 or t2 >= 0 and t2 <= 1 then
            return true
        end
    end

    return false
end

--- Determines if a rectangle intersects with a 2D line segment.
--- @param rect table: The rectangle (x, y, width, height).
--- @param line_start table: The starting point of the line segment (x, y).
--- @param line_end table: The ending point of the line segment (x, y).
--- @return boolean: True if the rectangle intersects with the line segment, false otherwise.
function m.does_rect_intersect_line(rect, line_start, line_end)
    return m.do_lines_intersect({x = rect.x, y = rect.y}, {x = rect.x + rect.width, y = rect.y}, line_start, line_end) or m.do_lines_intersect({x = rect.x + rect.width, y = rect.y}, {x = rect.x + rect.width, y = rect.y + rect.height}, line_start, line_end) or m.do_lines_intersect({x = rect.x + rect.width, y = rect.y + rect.height}, {x = rect.x, y = rect.y + rect.height}, line_start, line_end) or m.do_lines_intersect({x = rect.x, y = rect.y + rect.height}, {x = rect.x, y = rect.y}, line_start, line_end)
end

--- Determines the closest point on a 2D line segment to a given point.
--- @param point table: The point to find the closest point for (x, y).
--- @param line_start table: The starting point of the line segment (x, y).
--- @param line_end table: The ending point of the line segment (x, y).
--- @return table: The closest point on the line segment (x, y).
function m.closest_point_on_line_segment(point, line_start, line_end)
    local l2 = m.distance_2d(line_start, line_end)^2
    if l2 == 0 then return line_start end
    local t = ((point.x - line_start.x) * (line_end.x - line_start.x) + (point.y - line_start.y) * (line_end.y - line_start.y)) / l2
    if t < 0 then return line_start end
    if t > 1 then return line_end end
    return {x = line_start.x + t * (line_end.x - line_start.x), y = line_start.y + t * (line_end.y - line_start.y)}
end

--- Determines if a point is inside a 2D convex polygon.
--- @param point table: The point to check (x, y).
--- @param polygon table: The polygon defined as a sequence of points [{x, y}, {x, y}, ...].
--- @return boolean: True if the point is inside the polygon, false otherwise.
function m.is_point_in_convex_polygon(point, polygon)
    local sign = nil

    for i = 1, #polygon do
        local dx1 = polygon[i].x - point.x
        local dy1 = polygon[i].y - point.y
        local dx2 = polygon[(i % #polygon) + 1].x - point.x
        local dy2 = polygon[(i % #polygon) + 1].y - point.y
        local cross = dx1 * dy2 - dx2 * dy1
        if i == 1 then
            sign = cross > 0
        else
            if sign ~= (cross > 0) then
                return false
            end
        end
    end

    return true
end

--- Rotates a point around another point in 2D by a given angle in degrees.
--- @param point table: The point to rotate (x, y).
--- @param pivot table: The pivot point to rotate around (x, y).
--- @param angle_degrees number: The angle in degrees to rotate the point.
--- @return table: The rotated point (x, y).
function m.rotate_point_around_point_2d(point, pivot, angle_degrees)
    local angle_rad = math.rad(angle_degrees)
    local sin_angle = math.sin(angle_rad)
    local cos_angle = math.cos(angle_rad)
    local dx = point.x - pivot.x
    local dy = point.y - pivot.y

    return {x = cos_angle * dx - sin_angle * dy + pivot.x, y = sin_angle * dx + cos_angle * dy + pivot.y}
end

--- Calculates the distance from a point to a plane.
--- @param point table: The point to check (x, y, z).
--- @param plane_point table: A point on the plane (x, y, z).
--- @param plane_normal table: The normal of the plane (x, y, z).
--- @return number: The distance from the point to the plane.
function m.distance_point_to_plane(point, plane_point, plane_normal)
    local v = { x = point.x - plane_point.x, y = point.y - plane_point.y, z = point.z - plane_point.z }
    local dist = v.x * plane_normal.x + v.y * plane_normal.y + v.z * plane_normal.z

    return math.abs(dist)
end

return m