--[[
    A useful ModKey + Tab Task Switcher. 

    @param s screen
    @param awful
    @param gears
    @param wibox
]]
return function (s, settings, awful, gears, wibox, theme, debug)
    local tasklist_buttons = gears.table.join(
        awful.button({ settings.modkey }, 1, function (c)
            if c == client.focus then
                c.minimized = true
            else
                -- Without this, the following
                -- :isvisible() makes no sense
                c.minimized = false
                if not c:isvisible() and c.first_tag then
                    c.first_tag:view_only()
                end
                -- This will also un-minimize
                -- the client, if needed
                client.focus = c
                c:raise()
            end
        end),
    --- awful.button({ settings.modkey }, 3, client_menu_toggle_fn()),
        awful.button({ settings.modkey }, 4, function ()
            awful.client.focus.byidx(1)
        end),
        awful.button({ settings.modkey  }, 5, function ()
            awful.client.focus.byidx(-1)
        end)
    );

    local TaskManager = awful.popup {
        widget = awful.widget.tasklist {
            screen   = s,
            filter   = awful.widget.tasklist.filter.currenttags,
            buttons  = tasklist_buttons,
            style    = {
                shape = gears.shape.rectangle,
            },
            layout   = {
                spacing = 5,
                forced_num_rows = 1,
                layout = wibox.layout.grid.horizontal
            },
            widget_template = {
                {
                    {
                        id     = 'clienticon',
                        widget = awful.widget.clienticon,
                    },
                    margins = 4,
                    widget  = wibox.container.margin,
                },
                id              = 'background_role',
                forced_width    = 48,
                forced_height   = 48,
                widget          = wibox.container.background,
                create_callback = function(self, c, index, objects) --luacheck: no unused
                    self:get_children_by_id('clienticon')[1].client = c
                end,
            },
        },
        --border_color = '#777777',
        -- border_width = 2,
        ontop        = true,
        placement    = awful.placement.centered,
        shape        = gears.shape.rectangle,
        visible      = false,
        screen   = s
    }

    awful.keygrabber {
        keybindings = {
            {
                {settings.modkey}, 'Tab', 
                function () 
                    awful.screen.focused().mytaskmanager.visible = true
                    awful.client.focus.byidx( 1) 
                end,
                {description = "Next Window", group = "Desktop"}
            },
            {
                {settings.modkey, 'Shift'}, 'Tab', 
                function () 
                    awful.screen.focused().mytaskmanager.visible = true
                    awful.client.focus.byidx( -1) 
                end,
                {description = "Previous Window", group = "Desktop"}
            }
        },
        -- Note that it is using the key name and not the modifier name.
        stop_key           = settings.modkey,
        stop_event         = 'release',
        start_callback     = function () end,
        stop_callback      = function () awful.screen.focused().mytaskmanager.visible = false end,
        export_keybindings = true
    }

    return TaskManager;
end
