# Utilitas

Because Lua gives you basically nothing but `math.random` and some string hacks, we made **Utilitas**:
A **grab-bag of actually useful functions** so you can stop copy-pasting that same "deep copy" code you stole from StackOverflow in 2017.

It's **engine-agnostic**, **framework-free**, and **unashamedly extra**. 
Drop it in **LÖVE**, **Defold**, your **home-brew engine**, or that one Lua script that runs your Discord bot. It doesn't care.

---

## Included Modules

* **callbacks** - register and trigger functions, then forget you ever wrote them.
* **debugging** - colour-coded logs that make you look more professional than you are.
* **geometry** - everything from "is this point in a circle?" to "why am I writing my own collision again?".
* **maths** - clamp, lerp, factorials, regression… it's like math class but without the trauma.
* **methods** - an event/hook system so you can pretend your project supports "UGC".
* **strings** - capitalize, split, trim, generate random garbage.
* **tables** - deep copy, deep compare, recursive print, existential dread.
* **timestamps** - add days, diff dates, convert UNIX time into something human.

---

## Adding to a Project

1. **Download / clone** the repo.
2. Drop the internal `utilitas/` folder into your project. Don't get clever, just dump it in.
3. Profit.

```lua
-- in your main.lua, init.lua, drugs.lua, whatever:
local utilitas = require("utilitas")

-- now you have:
utilitas.debugging
utilitas.maths
utilitas.geometry
-- etc...
```

Modules are **lazy-loaded** the first time you touch them (`utilitas.geometry`, `utilitas.maths`, etc.).
If you're the impatient type, they're also exposed directly as `require("utilitas.geometry")`.

---

### Why like this?

Because Lua doesn't ship with a package manager.  
Sure, there's **LuaRocks**, but let's be honest: half of you are just dragging folders into your project like a raccoon in a bin.  
Utilitas was built to **work anywhere you can `require()`** - no globals, no framework glue, no hidden crap.

Stick it in:

* **LÖVE**: drop it next to `main.lua`
* **Defold**: shove it in your scripts folder
* **Custom engine**: as long as you can `require("utilitas")`, it doesn't care

---

## Usage

```lua
local utilitas = require("utilitas")

-- Logging

local log = utilitas.debugging
log.set_level("debug")
log.debug("Boot sequence initiated...")
log.success("Utilitas online. Lua just became 43% less terrible.")

-- Maths + Geometry

local geo = utilitas.geometry
local maths = utilitas.maths

local a = { x = 0, y = 0 }
local b = { x = 3, y = 4 }

log.info("Distance check", geo.distance_2d(a, b))

local val = 42
log.info("Clamp", maths.clamp(val, 0, 10)) 
log.info("Lerp", maths.lerp(0, 100, 0.25))

-- Strings + Tables

local str = utilitas.strings
local tbl = utilitas.tables

local s = "   hello WORLD   "
log.info("Trimmed", str.trim(s))
log.info("Capitalized", str.capitalize(s))

local t = { foo = 1, bar = { baz = 2 } }
local copy = tbl.deep_copy(t)
log.info("Deep compare original vs copy", tbl.deep_compare(t, copy))

-- Methods (hook system)

local methods = utilitas.methods

methods.add("player_jump", function(height)
    log.debug("Player jumped", height .. "m")
end)
methods.trigger("player_jump", 2.5)

-- Timestamps

local ts = utilitas.timestamps
local now = os.time()
local plus7 = ts.add_days_to_date(ts.convert_timestamp(now).date, 7)
log.info("Seven days later will be", plus7)
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
   (Yes, you actually have to edit the array. No, there isn't a CLI tool. This isn't npm.)

3. Test it.  
   If `require("utilitas.coolmath")` doesn't explode, you're halfway there.  
   If it **does** explode, congrats you're now maintaining a fork.

4. PRs welcome but if your module is `tables.flatten_but_worse_than-the-existing-ones.lua`, we'll roast you.  
   (and probably accept it anyway, because who doesn't love bloat?)

---

### Guidelines

- Keep it **engine-agnostic**. If it smells like LÖVE, FiveM, or Defold glue, it doesn't belong here.  
- Tests? You're the test. Run it, see if it breaks. If it doesn't, ship it.  
- MIT only. If you try to GPL this, we'll replace your code with `os.exit(69)`.

---

## Support

Functions not behaving?
`deep_copy` giving you an existential crisis?
`maths.lerp` taking you places you didn't consent to?

**[Join the PIT Discord](https://discord.gg/MUckUyS5Kq)**

> Support Hours: **Mon–Fri, 10AM–10PM GMT**
> After hours you're on "community edition support", aka screaming into the void and hoping someone else is awake.

Bug reports, feature requests, or debates about whether a function should exist are all fair game.