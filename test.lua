--- @script test.lua
--- @description Basic test harness for utilitas modules.
--- Doesn't cover everything.. couldn't be bothered they all work they have been battletested from `GRAFT`

local unpack = table.unpack or unpack
local _utils = require("utilitas")

local log = _utils.debugging
local ts = _utils.timestamps
local cb = _utils.callbacks
local geo = _utils.geometry
local maths = _utils.maths
local str = _utils.strings
local tbl = _utils.tables
local methods = _utils.methods

--- @section Functions

local function test_debug_module()
    log.set_level("debug")
    log.debug("[Debug] Engine booted")
    log.info ("[Debug] Running in pure Lua test mode")
    log.success("[Debug] Ready!")
end

local function test_timestamps_module()
    local now = os.time()
    local conv = ts.convert_timestamp(now)
    log.info ("[Timestamps] convert_timestamp", conv)
    local plus_seven = ts.add_days_to_date(conv.date, 7)
    log.info ("[Timestamps] add_days_to_date", plus_seven)
    local days_diff = ts.date_difference(conv.date, plus_seven)
    log.info ("[Timestamps] date_difference", days_diff)
end

local function test_callbacks_module()
    log.info ("[Callbacks] registering callback foo")
    cb.register("foo", function(x) return x * 2 end)
    local result, err = cb.trigger("foo", 5)
    log.info ("[Callbacks] trigger foo with 5", result, err)
    log.info ("[Callbacks] exists foo", cb.exists("foo"))
    cb.unregister("foo")
    local r2, e2 = cb.trigger("foo", 1)
    log.info ("[Callbacks] after unregister", r2, e2)
end

local function test_geometry_module()
    log.info ("[Geometry] distance_2d (0,0)-(3,4)", geo.distance_2d({ x = 0, y = 0 }, { x = 3, y = 4 }))
    log.info ("[Geometry] angle_between_points (0,0)-(0,1)", geo.angle_between_points({ x = 0, y = 0 }, { x = 0, y = 1 }))
end

local function test_maths_module()
    log.info ("[Maths] clamp(5,0,10)", maths.clamp(5, 0, 10))
    log.info ("[Maths] clamp(-1,0,10)", maths.clamp(-1, 0, 10))
    log.info ("[Maths] lerp(0,10,0.5)", maths.lerp(0, 10, 0.5))
    log.info ("[Maths] mean({1,2,3,4})", maths.mean({ 1, 2, 3, 4 }))
end

local function test_strings_module()
    log.info ("[Strings] capitalize hello WORLD -", str.capitalize("hello WORLD"))
    local parts = str.split("a,b,c", ",")
    log.info ("[Strings] split a,b,c -", unpack(parts))
    log.info ("[Strings] trim '   foo    ' - ", "'" .. str.trim("  foo  ") .. "'")
end

local function test_tables_module()
    local t    = { a = 1, b = { c = 2 } }
    local copy = tbl.deep_copy(t)
    log.info ("[Tables] deep_compare original vs copy", tbl.deep_compare(t, copy))
    log.info ("[Tables] contains 2", tbl.contains(t, 2))
end

local function test_methods_module()
    log.info ("[Methods] adding handler to evt_test")
    local id = methods.add("evt_test", function(a, b)
        log.info("[Methods] evt_test callback", a, b)
        return true
    end)
    local ok1 = methods.trigger("evt_test", "foo", "bar")
    log.info ("[Methods] trigger returned", ok1)
    methods.remove("evt_test", id)
    local ok2 = methods.trigger("evt_test", "x", "y")
    log.info ("[Methods] after remove returned", ok2)
end

--- @section Test Run

local function run_all()
    test_debug_module()
    test_timestamps_module()
    test_callbacks_module()
    test_geometry_module()
    test_maths_module()
    test_strings_module()
    test_tables_module()
    test_methods_module()
end

run_all()