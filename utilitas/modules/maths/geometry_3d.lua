--[[ 
    This file is part of utilitas and is licensed under the MIT License.
    See the LICENSE file in the root directory for full terms.

    © 2025 Case @ Playing In Traffic

    Support honest development. 
    Retain this credit. Don't be that guy...
]]

--- @module maths.geometry_3d
--- @description Handles all 3D geometry functions, is short hand to geo3d for imports.

--[[
API:

- calculate_distance           -- Get distance between two 3D points
- distance_3d                  -- Get Euclidean distance between two 3D points
- midpoint                     -- Get midpoint between two 3D points
- is_point_in_box              -- Check if a point is inside a 3D bounding box
- angle_between_3_points       -- Get angle at central point between three 3D points
- triangle_area_3d             -- Compute surface area of a 3D triangle
- is_point_in_sphere           -- Check if a point is inside a 3D sphere
- do_spheres_intersect         -- Check if two 3D spheres intersect
]]

local m = {}

--- Calculates the distance between two 3D points.
--- @param start_coords table: {x:number,y:number,z:number} The starting coordinates.
--- @param end_coords table: {x:number,y:number,z:number} The ending coordinates.
--- @return number: The Euclidean distance between the two points.
function m.calculate_distance(start_coords, end_coords)
    local dx = end_coords.x - start_coords.x
    local dy = end_coords.y - start_coords.y
    local dz = end_coords.z - start_coords.z
    return math.sqrt(dx * dx + dy * dy + dz * dz)
end

--- Calculates the distance between two 3D points.
--- @param p1 table: The first point (x, y, z).
--- @param p2 table: The second point (x, y, z).
--- @return number: The Euclidean distance between the two points.
function m.distance_3d(p1, p2)
    return math.sqrt((p2.x - p1.x)^2 + (p2.y - p1.y)^2 + (p2.z - p1.z)^2)
end

--- Returns the midpoint between two 3D points.
--- @param p1 table: The first point (x, y, z).
--- @param p2 table: The second point (x, y, z).
--- @return table: The midpoint (x, y, z).
function m.midpoint(p1, p2)
    return {x = (p1.x + p2.x) / 2, y = (p1.y + p2.y) / 2, z = (p1.z + p2.z) / 2}
end

--- Determines if a point is inside a given 3D box boundary.
--- @param point table: The point to check (x, y, z).
--- @param box table: The box (x, y, z, width, height, depth).
--- @return boolean: True if the point is inside the box, false otherwise.
function m.is_point_in_box(point, box)
    return point.x >= box.x and point.x <= (box.x + box.width) and point.y >= box.y and point.y <= (box.y + box.height) and point.z >= box.z and point.z <= (box.z + box.depth)
end

--- Calculates the angle between three 3D points (p1, p2 as center, p3).
--- @param p1 table: The first point (x, y, z).
--- @param p2 table: The center point (x, y, z).
--- @param p3 table: The third point (x, y, z).
--- @return number: The angle in degrees.
function m.angle_between_3_points(p1, p2, p3)
    local a = m.distance_3d(p2, p3)
    local b = m.distance_3d(p1, p3)
    local c = m.distance_3d(p1, p2)

    return math.acos((a*a + c*c - b*b) / (2*a*c)) * (180 / math.pi)
end

--- Calculates the area of a 3D triangle given three points.
--- @param p1 table: The first point of the triangle (x, y, z).
--- @param p2 table: The second point of the triangle (x, y, z).
--- @param p3 table: The third point of the triangle (x, y, z).
--- @return number: The area of the triangle.
function m.triangle_area_3d(p1, p2, p3)
    local u = {x = p2.x - p1.x, y = p2.y - p1.y, z = p2.z - p1.z}
    local v = {x = p3.x - p1.x, y = p3.y - p1.y, z = p3.z - p1.z}
    local cross_product = {x = u.y * v.z - u.z * v.y, y = u.z * v.x - u.x * v.z, z = u.x * v.y - u.y * v.x}
    return 0.5 * math.sqrt(cross_product.x^2 + cross_product.y^2 + cross_product.z^2)
end

--- Determines if a point is inside a 3D sphere defined by center and radius.
--- @param point table: The point to check (x, y, z).
--- @param sphere_center table: The center of the sphere (x, y, z).
--- @param sphere_radius number: The radius of the sphere.
--- @return boolean: True if the point is inside the sphere, false otherwise.
function m.is_point_in_sphere(point, sphere_center, sphere_radius)
    return m.distance_3d(point, sphere_center) <= sphere_radius
end

--- Determines if two spheres intersect.
--- @param s1_center table: The center of the first sphere (x, y, z).
--- @param s1_radius number: The radius of the first sphere.
--- @param s2_center table: The center of the second sphere (x, y, z).
--- @param s2_radius number: The radius of the second sphere.
--- @return boolean: True if the spheres intersect, false otherwise.
function m.do_spheres_intersect(s1_center, s1_radius, s2_center, s2_radius)
    return m.distance_3d(s1_center, s2_center) <= (s1_radius + s2_radius)
end

return m