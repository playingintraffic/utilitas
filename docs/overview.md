# Utilitas

Because Lua gives you basically nothing but `math.random` and some string hacks, we made **Utilitas**:  
A **grab-bag of actually useful functions** so you can stop copy-pasting that same "deep copy" code you stole from StackOverflow in 2017.

It's **engine-agnostic**, **framework-free**, and **unashamedly extra**.  
Drop it in **LÖVE**, **Defold**, your **home-brew engine**, or that one Lua script that runs your Discord bot. It doesn't care.

---

## Included Modules

* **callbacks** – register and trigger functions, then forget you ever wrote them.
* **debugging** – colour-coded logs that make you look more professional than you are.
* **geometry** – everything from "is this point in a circle?" to "why am I writing my own collision again?".
* **maths** – clamp, lerp, factorials, regression… it's like math class but without the trauma.
* **methods** – an event/hook system so you can pretend your project supports "UGC".
* **strings** – capitalize, split, trim, generate random garbage.
* **tables** – deep copy, deep compare, recursive print, existential dread.
* **timestamps** – add days, diff dates, convert UNIX time into something human.

---

## Adding to a Project

1. **Download / clone** the repo.
2. Drop the internal `utilitas/` folder into your project. Don't get clever, just dump it in.
3. Use one of the options below:

---

## Importing

### Import Everything (Lazy Loaded)
```lua
local utilitas = require("utilitas")

utilitas.maths.core.clamp(42, 0, 10)
utilitas.strings.trim("  hello world  ")
utilitas.geometry.distance_2d({ x = 0, y = 0 }, { x = 3, y = 4 })
````

### Import a Module Category (By Group)

```lua
local maths = require("utilitas.modules.maths")
local core = maths.core

local rounded = core.round(3.14159, 2)
local interpolated = core.lerp(0, 100, 0.25)
```

### Import a Specific File (Direct Access)

```lua
local round = require("utilitas.modules.maths.core").round

print(round(2.718, 1)) --> 2.7
```

Use whichever makes sense for your setup. They all point to the same functions under the hood.

---

## Example Usage

```lua
local utilitas = require("utilitas")
local log = utilitas.debugging
log.set_level("debug")

log.debug("Boot sequence initiated...")
log.success("Utilitas required.")

-- Maths
local clamp = utilitas.maths.core.clamp
log.info("Clamp 42 to [0, 10]", clamp(42, 0, 10))

-- Geometry
local a = { x = 0, y = 0 }
local b = { x = 3, y = 4 }
log.info("Distance", utilitas.geometry.distance_2d(a, b))

-- Strings
local str = utilitas.strings
log.info("Capitalize", str.capitalize("hello world"))
log.info("Trim", str.trim("   extra space   "))

-- Tables
local tbl = utilitas.tables
local t1 = { foo = 1, bar = { baz = 2 } }
local t2 = tbl.deep_copy(t1)
log.info("Tables equal?", tbl.deep_compare(t1, t2))

-- Timestamps
local now = os.time()
local date_info = utilitas.timestamps.convert_timestamp(now)
log.info("Today is", date_info.date)

-- Callbacks + Hooks
local runtime = utilitas.runtime
runtime.register_callback("shout", function(msg) return "YO " .. msg end)
log.info("Callback:", runtime.trigger_callback("shout", "CASE!"))

local id = runtime.register_hook("on_event", function(x) log.info("Hook triggered:", x) end)
runtime.trigger_hook("on_event", 99)
```

---

## Why Use This?

Because Lua's standard library is like a survival kit that comes with a **stick** and says "good luck".
Utilitas adds the missing duct tape, Swiss army knife, and lighter fluid so you can actually get things done.

MIT-licensed. Free to use.
Break it. Change it. Extend it.
Just don't pretend you wrote it.

---

## Contributing

Want to add your own "totally essential" function that definitely isn't just a wrapper around `math.random`?
Cool... just don't trash the loader while you're at it.

1. Put your shiny new file in `utilitas/modules/`.
   Example: `utilitas/modules/coolmath.lua`

2. Add its name to the `_modules` list in `utilitas/init.lua`.

3. Test it.
   If `require("utilitas.coolmath")` doesn't explode, you're halfway there.
   If it **does** explode, congrats you're now maintaining a fork.

4. PRs welcome — but if your module is `tables.flatten_but_worse_than_existing.lua`, expect shade.

---

### Guidelines

* Tests? You’re the test. Run it. If it breaks, fix it. If it doesn’t, ship it.
* MIT only. Don't be a dick.

---

## Support

Functions not behaving?
`deep_copy` giving you an existential crisis?
`maths.lerp` taking you places you didn’t consent to?

**[Join the PIT Discord](https://discord.gg/MUckUyS5Kq)**

> Support Hours: **Mon–Fri, 10AM–10PM GMT**
> After hours you're on "community edition support", aka screaming into the void and hoping someone else is awake.