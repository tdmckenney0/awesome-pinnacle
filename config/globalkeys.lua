--[[
	Global key configuration
]]
return function(settings, awful, gears)
	local hotkeys_popup = require("awful.hotkeys_popup").widget

	-- Enable VIM help for hotkeys widget when client with matching name is opened:
	require("awful.hotkeys_popup.keys.vim")

	-- {{{ Key bindings
	globalkeys = gears.table.join(

	-- Awesome WM Functions
		awful.key({ settings.modkey, "Control" }, "r", awesome.restart,
			{ description = "Reload Awesome", group = "Awesome" }),
		awful.key({ settings.modkey, "Control" }, "q", awesome.quit,
			{ description = "Quit Awesome", group = "Awesome" }),
		awful.key({ settings.modkey, }, "h", hotkeys_popup.show_help,
			{ description = "Show Help", group = "Awesome" }),

		-- Launcher
		awful.key({ "Control" }, "space", function() menubar.show() end,
			{ description = "Toggle the menubar", group = "Launcher" }),

		-- Desktop Stuff
		awful.key({ settings.modkey, }, "b", function() awful.spawn.with_shell(settings.wallpaper) end,
			{ description = "Change Desktop Wallpaper", group = "Desktop" }),
		awful.key({ settings.modkey, }, "l", function() awful.spawn.with_shell(settings.lock) end,
			{ description = "Lock the Destkop", group = "Desktop" }),
		awful.key({ settings.modkey, }, "Left", awful.tag.viewprev,
			{ description = "Previous Desktop", group = "Desktop" }),
		awful.key({ settings.modkey, }, "Right", awful.tag.viewnext,
			{ description = "Next Desktop", group = "Desktop" }),
		awful.key({ settings.modkey, }, "Up", function() awful.layout.inc(1) end,
			{ description = "Next Layout", group = "Desktop" }),
		awful.key({ settings.modkey, }, "Down", function() awful.layout.inc(-1) end,
			{ description = "Previous Layout", group = "Desktop" }),
		awful.key({ settings.modkey, }, "Return", awful.client.urgent.jumpto,
			{ description = "Focus on Urgent Window", group = "Desktop" }),
		awful.key({ settings.modkey, }, "Insert", function() awful.tag.incnmaster(1, nil, true) end,
			{ description = "Add Main Window", group = "Desktop" }),
		awful.key({ settings.modkey, }, "Delete", function() awful.tag.incnmaster(-1, nil, true) end,
			{ description = "Remove Main Window", group = "Desktop" }),
		awful.key({ settings.modkey, "Shift" }, "Insert", function() awful.tag.incncol(1, nil, true) end,
			{ description = "Add Column", group = "Desktop" }),
		awful.key({ settings.modkey, "Shift" }, "Delete", function() awful.tag.incncol(-1, nil, true) end,
			{ description = "Remove Column", group = "Desktop" }),
		awful.key({ settings.modkey, "Control" }, "m",
			function()
				local c = awful.client.restore()
				-- Focus restored client
				if c then
					client.focus = c
					c:raise()
				end
			end,
			{ description = "Restore Minimized", group = "Desktop" })

	-- Window Magic
	--[[ awful.key({ settings.modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
		{description = "swap with next client by index", group = "Window"}),

	awful.key({ settings.modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
		{description = "swap with previous client by index", group = "client"}),

	awful.key({ settings.modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
		{description = "focus the next screen", group = "screen"}),

	awful.key({ settings.modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
		{description = "focus the previous screen", group = "screen"}),

	awful.key({ settings.modkey,           }, "l",     function () awful.tag.incmwfact( 0.05) end,
		{description = "increase master width factor", group = "layout"}),

	awful.key({ settings.modkey,           }, "h",     function () awful.tag.incmwfact(-0.05) end,
		{description = "decrease master width factor", group = "layout"}),

	awful.key({                   }, "Print", function () awful.spawn.with_shell("sleep 0.1 && /usr/bin/i3-scrot -d")   end,
		{description = "capture a screenshot", group = "screenshot"}),
	awful.key({"Control"          }, "Print", function () awful.spawn.with_shell("sleep 0.1 && /usr/bin/i3-scrot -w")   end,
		{description = "capture a screenshot of active window", group = "screenshot"}),
	awful.key({"Shift"            }, "Print", function () awful.spawn.with_shell("sleep 0.1 && /usr/bin/i3-scrot -s")   end,
		{description = "capture a screenshot of selection", group = "screenshot"}),
	]]
	)

	-- Build out the launcher keys.
	for key, launcher in pairs(settings.launchers) do
		globalkeys = gears.table.join(
			globalkeys,
			awful.key(
				{ settings.modkey },
				key,
				function() awful.spawn(launcher.command) end,
				{
					description = launcher.name,
					group = "Launcher"
				}
			)
		)
	end

	-- Bind all key numbers to tags.
	-- Be careful: we use keycodes to make it work on any keyboard layout.
	-- This should map on the top row of your keyboard, usually 1 to 9.
	for i = 1, 9 do
		globalkeys = gears.table.join(globalkeys,
			-- View tag only.
			awful.key({ settings.modkey }, "#" .. i + 9,
				function()
					local screen = awful.screen.focused()
					local tag = screen.tags[i]
					if tag then
						tag:view_only()
					end
				end,
				{ description = "view tag #" .. i, group = "tag" }),
			-- Toggle tag display.
			awful.key({ settings.modkey, "Control" }, "#" .. i + 9,
				function()
					local screen = awful.screen.focused()
					local tag = screen.tags[i]
					if tag then
						awful.tag.viewtoggle(tag)
					end
				end,
				{ description = "toggle tag #" .. i, group = "tag" }),
			-- Move client to tag.
			awful.key({ settings.modkey, "Shift" }, "#" .. i + 9,
				function()
					if client.focus then
						local tag = client.focus.screen.tags[i]
						if tag then
							client.focus:move_to_tag(tag)
						end
					end
				end,
				{ description = "move focused client to tag #" .. i, group = "tag" }),
			-- Toggle tag on focused client.
			awful.key({ settings.modkey, "Control", "Shift" }, "#" .. i + 9,
				function()
					if client.focus then
						local tag = client.focus.screen.tags[i]
						if tag then
							client.focus:toggle_tag(tag)
						end
					end
				end,
				{ description = "toggle focused client on tag #" .. i, group = "tag" })
		)
	end

	-- Bind all key numbers to tags.
	-- Be careful: we use keycodes to make it work on any keyboard layout.
	-- This should map on the top row of your keyboard, usually 1 to 9.
	for i = 1, 9 do
		globalkeys = gears.table.join(globalkeys,
			-- View tag only.
			awful.key({ settings.modkey }, "#" .. i + 9,
				function()
					local screen = awful.screen.focused()
					local tag = screen.tags[i]
					if tag then
						tag:view_only()
					end
				end,
				{ description = "view tag #" .. i, group = "tag" }),
			-- Toggle tag display.
			awful.key({ settings.modkey, "Control" }, "#" .. i + 9,
				function()
					local screen = awful.screen.focused()
					local tag = screen.tags[i]
					if tag then
						awful.tag.viewtoggle(tag)
					end
				end,
				{ description = "toggle tag #" .. i, group = "tag" }),
			-- Move client to tag.
			awful.key({ settings.modkey, "Shift" }, "#" .. i + 9,
				function()
					if client.focus then
						local tag = client.focus.screen.tags[i]
						if tag then
							client.focus:move_to_tag(tag)
						end
					end
				end,
				{ description = "move focused client to tag #" .. i, group = "tag" }),
			-- Toggle tag on focused client.
			awful.key({ settings.modkey, "Control", "Shift" }, "#" .. i + 9,
				function()
					if client.focus then
						local tag = client.focus.screen.tags[i]
						if tag then
							client.focus:toggle_tag(tag)
						end
					end
				end,
				{ description = "toggle focused client on tag #" .. i, group = "tag" })
		)
	end

	return globalkeys;
end
