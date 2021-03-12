--[[
    A useful bottom-screen dock. 

    @param s screen
    @param awful
    @param gears
    @param wibox
]]
return function (s, settings, awful, gears, wibox, theme, debug)
    local dock = wibox({ 
        screen = s, 
        y = s.workarea.height - theme.dock.height / 2, 
        height = theme.dock.height, 
        fg = theme.fg_normal, 
        ontop = true, 
        visible = true, 
        type = "dock"
    });

    local focusClient = function (c) 
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

    local buttons = gears.table.join(
        awful.button({ }, 1, function (c)
            if c == client.focus then
                c.minimized = true
            else
                focusClient(c)
            end
        end),

        awful.button({ settings.modkey }, 3, function () end), -- right click

        awful.button({ }, 4, function ()
            awful.client.focus.byidx(1)
        end),

        awful.button({ }, 5, function ()
            awful.client.focus.byidx(-1)
        end),

        awful.button({ settings.modkey }, 4, function ()
            awful.client.cycle();
        end),

        awful.button({ settings.modkey }, 5, function ()
            awful.client.cycle(true);
        end)
    );

    local tasklist = awful.widget.tasklist {
        screen   = s,
        filter   = awful.widget.tasklist.filter.alltags,
        buttons  = buttons,
        style    = {
            shape = gears.shape.rectangle,
        },
        layout   = {
            spacing = theme.dock.icon_spacing,
            forced_num_rows = 1,
            layout = wibox.layout.grid.horizontal
        },
        widget_template = {
            {
                {
                    id     = 'clienticon',
                    widget = awful.widget.clienticon,
                },
                margins = theme.dock.icon_padding,
                widget  = wibox.container.margin,
            },
            id              = 'background_role',
            forced_width    = theme.dock.height,
            forced_height   = theme.dock.height,
            widget          = wibox.container.background,
            create_callback = function(self, c, index, objects) --luacheck: no unused
                self:get_children_by_id('clienticon')[1].client = c
            end,
            update_callback = function (self, c, index, objects)
                -- debug(objects);
                local count = 0

                for _ in pairs(objects) do count = count + 1 end

                dock.width = (theme.dock.height * count) + (theme.dock.icon_spacing * (count + 1));                
                dock.x = (s.workarea.width / 2) - (dock.width / 2);
            end
        }
    };

    local showDock = function()
        dock.height = theme.dock.height;
        dock.y = s.workarea.height - theme.dock.height / 2;

        tasklist.visible = true; 
    end

    local hideDock = function ()
        dock.height = theme.dock.height_hidden;
        dock.y = s.workarea.height + (theme.dock.height / 2) - theme.dock.height_hidden;

        tasklist.visible = false; 
    end

    -- Add toggling functionalities
    local docktimer = gears.timer{ timeout = settings.dock.timeout }

    docktimer:connect_signal("timeout", function()
        hideDock(); 

        if docktimer.started then
            docktimer:stop()
        end
    end)

    local triggerShow = function ()
        showDock();

        if docktimer.started then
            docktimer:stop()
        end
    end

    local timeoutHide = function ()
        if not docktimer.started then
            docktimer:start()
        end
    end

    --[[
    tag.connect_signal("property::selected", function(t)
        local s = t.screen or awful.screen.focused()
        s.myleftwibox.width = dpi(38)
        s.layoutb.visible = true
        mylauncher.visible = true
        gears.surface.apply_shape_bounding(s.myleftwibox, dockshape)
        if not s.docktimer.started then
            s.docktimer:start()
        end
    end)
    ]]

    awful.keygrabber {
        keybindings = {
            {
                {settings.modkey}, 'Tab', 
                function () 
                    awful.client.focus.byidx( 1) 
                end,
                {description = "Next Window", group = "Desktop"}
            },
            {
                {settings.modkey, 'Shift'}, 'Tab', 
                function () 
                    awful.client.focus.byidx( -1) 
                end,
                {description = "Previous Window", group = "Desktop"}
            }
        },
        -- Note that it is using the key name and not the modifier name.
        stop_key           = settings.modkey,
        stop_event         = 'release',
        start_callback     = triggerShow,
        stop_callback      = function ()
            local layout = awful.layout.getname(awful.layout.get(s));

            if not layout == "floating" then
                timeoutHide();
            end
        end,
        export_keybindings = true
    }

    -- Add the Task List.
    dock:setup {
        layout = wibox.layout.align.horizontal,
        expand = "none",
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal
        },
        {
            layout = wibox.layout.fixed.horizontal,
            tasklist
        }, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal
        },
        -- widget = tasklist
    }

    s:connect_signal("arrange", function () 
        local layout = awful.layout.getname(awful.layout.get(s))

        if layout == "floating" then
            dock:disconnect_signal("mouse::leave", timeoutHide);
            dock:disconnect_signal("mouse::enter", triggerShow);
            triggerShow();
        else
            dock:connect_signal("mouse::leave", timeoutHide);
            dock:connect_signal("mouse::enter", triggerShow);
            timeoutHide();
        end
    end)

    return dock;
end
