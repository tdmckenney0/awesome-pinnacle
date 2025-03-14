--[[
	Client (window) key configuration
]]
return function(settings, awful, gears)
    clientkeys = gears.table.join(
        awful.key({ settings.modkey }, "space",
            function(c)
                c.fullscreen = not c.fullscreen
                c:raise()
            end,
            { description = "Toggle Fullscreen", group = "Window" }),
        awful.key({ settings.modkey, }, "x", function(c) c:kill() end,
            { description = "Close", group = "Window" }),

        awful.key({ settings.modkey }, "f",
            function(c)
                if (c.first_tag.layout.name ~= "floating") then
                    c.floating = not c.floating
                end
            end,
            { description = "Toggle Floating", group = "Window" }),
        awful.key({ settings.modkey, }, "t", function(c) c.ontop = not c.ontop end,
            { description = "Toggle Keep on Top", group = "Window" }),
        awful.key({ settings.modkey, }, "p", function(c) c.sticky = not c.sticky end,
            { description = "Toggle Show on all Desktops", group = "Window" }),
        awful.key({ settings.modkey, }, "m",
            function(c)
                -- The client currently has the input focus, so it cannot be
                -- minimized, since minimized clients can't have the focus.
                c.minimized = true
            end,
            { description = "Minimize", group = "Window" }) --[[,

        awful.key({ settings.modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
            {description = "move to master", group = "Window"}),

        awful.key({ settings.modkey,           }, "o",      function (c) c:move_to_screen()               end,
                {description = "move to screen", group = "Window"}) ]]
    )

    return clientkeys;
end
