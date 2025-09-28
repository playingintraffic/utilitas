--[[ 
    This file is part of utilitas and is licensed under the MIT License.
    See the LICENSE file in the root directory for full terms.

    © 2025 Case @ Playing In Traffic

    Support honest development. 
    Retain this credit. Don't be that guy...
]]

--- @module maths.mat4
--- @description Matrix utility module for 3D transformations (4x4 matrices)

local mat4 = {}

local _identity = {
    1,0,0,0,
    0,1,0,0,
    0,0,1,0,
    0,0,0,1
}

--- Returns an identity matrix (does nothing when multiplied)
--- @return table: identity_matrix
function mat4.identity()
    local copy = {}
    for i = 1, 16 do copy[i] = _identity[i] end
    return copy
end

--- Builds a perspective projection matrix
--- This simulates a camera lens (farther objects look smaller)
--- @param fov number: Field of view in degrees
--- @param aspect number: Aspect ratio (width / height)
--- @param near number: Near clipping plane
--- @param far number: Far clipping plane
--- @return table: perspective_matrix
function mat4.perspective(fov, aspect, near, far)
    local f = 1 / math.tan(math.rad(fov) / 2)
    return {
        f / aspect, 0, 0, 0,
        0, f, 0, 0,
        0, 0, (far + near) / (near - far), -1,
        0, 0, (2 * far * near) / (near - far), 0
    }
end

--- Builds a camera 'look at' view matrix
--- This positions the camera and rotates it to face a point
--- @param eye table: {x, y, z} Camera position
--- @param target table: {x, y, z} Look-at position
--- @param up table: {x, y, z} Up vector
--- @return table view_matrix
function mat4.look_at(eye, target, up)
    local function safe_normalize(v)
        local len = math.sqrt(v[1]^2 + v[2]^2 + v[3]^2)
        return (len > 0) and { v[1]/len, v[2]/len, v[3]/len } or { 0, 0, 0 }
    end

    local function cross(a, b)
        return {
            a[2]*b[3] - a[3]*b[2],
            a[3]*b[1] - a[1]*b[3],
            a[1]*b[2] - a[2]*b[1]
        }
    end

    local function subtract(a, b)
        return { a[1] - b[1], a[2] - b[2], a[3] - b[3] }
    end

    local z = safe_normalize(subtract(eye, target))
    local x = safe_normalize(cross(up, z))
    local y = cross(z, x)

    return {
        x[1], y[1], z[1], 0,
        x[2], y[2], z[2], 0,
        x[3], y[3], z[3], 0,
        -x[1]*eye[1] - x[2]*eye[2] - x[3]*eye[3],
        -y[1]*eye[1] - y[2]*eye[2] - y[3]*eye[3],
        -z[1]*eye[1] - z[2]*eye[2] - z[3]*eye[3],
        1
    }
end

--- Multiplies two 4x4 matrices
--- @param a table: First matrix
--- @param b table: Second matrix
--- @return table: result_matrix
function mat4.multiply(a, b)
    local r = {}
    for row = 0, 3 do
        for col = 0, 3 do
            r[1 + row * 4 + col] =
                a[1 + row * 4 + 0] * b[1 + 0 * 4 + col] +
                a[1 + row * 4 + 1] * b[1 + 1 * 4 + col] +
                a[1 + row * 4 + 2] * b[1 + 2 * 4 + col] +
                a[1 + row * 4 + 3] * b[1 + 3 * 4 + col]
        end
    end
    return r
end

--- Inverts a 4x4 matrix using brute-force cofactor method
--- Returns nil if matrix is not invertible (det = 0)
--- @param m table: Matrix to invert
--- @return table|nil: inverted_matrix
function mat4.invert(m)
    local inv = {}
    local t = {}
    for i = 1, 16 do t[i] = m[i] end

    inv[1] = t[6]*t[11]*t[16] - t[6]*t[12]*t[15] - t[10]*t[7]*t[16] + t[10]*t[8]*t[15] + t[14]*t[7]*t[12] - t[14]*t[8]*t[11]
    inv[2] = -t[2]*t[11]*t[16] + t[2]*t[12]*t[15] + t[10]*t[3]*t[16] - t[10]*t[4]*t[15] - t[14]*t[3]*t[12] + t[14]*t[4]*t[11]
    inv[3] = t[2]*t[7]*t[16] - t[2]*t[8]*t[15] - t[6]*t[3]*t[16] + t[6]*t[4]*t[15] + t[14]*t[3]*t[8] - t[14]*t[4]*t[7]
    inv[4] = -t[2]*t[7]*t[12] + t[2]*t[8]*t[11] + t[6]*t[3]*t[12] - t[6]*t[4]*t[11] - t[10]*t[3]*t[8] + t[10]*t[4]*t[7]

    inv[5] = -t[5]*t[11]*t[16] + t[5]*t[12]*t[15] + t[9]*t[7]*t[16] - t[9]*t[8]*t[15] - t[13]*t[7]*t[12] + t[13]*t[8]*t[11]
    inv[6] = t[1]*t[11]*t[16] - t[1]*t[12]*t[15] - t[9]*t[3]*t[16] + t[9]*t[4]*t[15] + t[13]*t[3]*t[12] - t[13]*t[4]*t[11]
    inv[7] = -t[1]*t[7]*t[16] + t[1]*t[8]*t[15] + t[5]*t[3]*t[16] - t[5]*t[4]*t[15] - t[13]*t[3]*t[8] + t[13]*t[4]*t[7]
    inv[8] = t[1]*t[7]*t[12] - t[1]*t[8]*t[11] - t[5]*t[3]*t[12] + t[5]*t[4]*t[11] + t[9]*t[3]*t[8] - t[9]*t[4]*t[7]

    inv[9] = t[5]*t[10]*t[16] - t[5]*t[12]*t[14] - t[9]*t[6]*t[16] + t[9]*t[8]*t[14] + t[13]*t[6]*t[12] - t[13]*t[8]*t[10]
    inv[10] = -t[1]*t[10]*t[16] + t[1]*t[12]*t[14] + t[9]*t[2]*t[16] - t[9]*t[4]*t[14] - t[13]*t[2]*t[12] + t[13]*t[4]*t[10]
    inv[11] = t[1]*t[6]*t[16] - t[1]*t[8]*t[14] - t[5]*t[2]*t[16] + t[5]*t[4]*t[14] + t[13]*t[2]*t[8] - t[13]*t[4]*t[6]
    inv[12] = -t[1]*t[6]*t[12] + t[1]*t[8]*t[10] + t[5]*t[2]*t[12] - t[5]*t[4]*t[10] - t[9]*t[2]*t[8] + t[9]*t[4]*t[6]

    inv[13] = -t[5]*t[10]*t[15] + t[5]*t[11]*t[14] + t[9]*t[6]*t[15] - t[9]*t[7]*t[14] - t[13]*t[6]*t[11] + t[13]*t[7]*t[10]
    inv[14] = t[1]*t[10]*t[15] - t[1]*t[11]*t[14] - t[9]*t[2]*t[15] + t[9]*t[3]*t[14] + t[13]*t[2]*t[11] - t[13]*t[3]*t[10]
    inv[15] = -t[1]*t[6]*t[15] + t[1]*t[7]*t[14] + t[5]*t[2]*t[15] - t[5]*t[3]*t[14] - t[13]*t[2]*t[7] + t[13]*t[3]*t[6]
    inv[16] = t[1]*t[6]*t[11] - t[1]*t[7]*t[10] - t[5]*t[2]*t[11] + t[5]*t[3]*t[10] + t[9]*t[2]*t[7] - t[9]*t[3]*t[6]

    local det = t[1]*inv[1] + t[2]*inv[5] + t[3]*inv[9] + t[4]*inv[13]
    if det == 0 then return nil end

    for i = 1, 16 do inv[i] = inv[i] / det end
    return inv
end

--- Transposes a 4x4 matrix
--- @param m table: The matrix to transpose
--- @return table: Transposed matrix
function mat4.transpose(m)
    return {
        m[1],  m[5],  m[9],  m[13],
        m[2],  m[6],  m[10], m[14],
        m[3],  m[7],  m[11], m[15],
        m[4],  m[8],  m[12], m[16],
    }
end

return mat4