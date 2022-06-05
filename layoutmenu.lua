local awful = require("awful")

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,    
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.magnifier,
    awful.layout.suit.max, 
    awful.layout.suit.corner.nw,
    awful.layout.suit.corner.ne,
    awful.layout.suit.corner.sw,
    awful.layout.suit.corner.se,
    awful.layout.suit.floating
}
-- }}}

local layoutmenuitems = {}

for id, layout in pairs(awful.layout.layouts) do 
    table.insert(layoutmenuitems, {
        layout.name:gsub("^%l", string.upper), -- UC first. 
        function () 
            awful.layout.set(layout)
        end,
        ""
    })
end

return awful.menu(layoutmenuitems)
