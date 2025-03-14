-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
local dpi   = require("beautiful.xresources").apply_dpi

-- Auto Focus. 
require("awful.autofocus")

-- Widget and layout library
local wibox = require("wibox")

-- Theme handling library
local beautiful = require("beautiful")

-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup").widget

-- Enable VIM help for hotkeys widget when client with matching name is opened:
require("awful.hotkeys_popup.keys.vim")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                                  title = "Oops, there were errors during startup!",
                                  text = awesome.startup_errors })
end
-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true
        naughty.notify({ preset = naughty.config.presets.critical,
                                      title = "Oops, an error happened!",
                                      text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- Debugger
local function debug(v) 
    naughty.notify({preset=naughty.config.presets.normal, title="debug", text = gears.debug.dump_return(v, "Debugged") })
end

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
-- Chosen colors and buttons look alike adapta maia theme
-- beautiful.init("/usr/share/awesome/themes/cesious/theme.lua")
beautiful.init(string.format("%s/.config/awesome/theme.lua", os.getenv("HOME")))

-- Load Configuration
local settings = require('settings');
local mainmenu = require("mainmenu");

-- Load Widgets
local TaskManager = require('widgets/TaskManager');

function double_click_event_handler(double_click_event)
    if double_click_timer then
        double_click_timer:stop()
        double_click_timer = nil

        double_click_event()
        
        return
    end
  
    double_click_timer = gears.timer.start_new(0.20, function()
        double_click_timer = nil
        return false
    end)
end

layoutmenu = require('layoutmenu');

-- Menubar configuration
menubar.utils.terminal = settings.terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock("%a %B %d %Y %I:%M %p %Z")

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ settings.modkey }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ settings.modkey }, 3, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                          end),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
                )


awful.screen.connect_for_each_screen(function(s)
    -- Setup tags. 
    for id, config in pairs(settings.tags) do 
        local merged = gears.table.join({
            screen = s,
            layout = awful.layout.suit.tile
        }, config.config)

        awful.tag.add(config.name, merged)
    end

    -- Custom Layout Box.
    s.mylayoutbox = wibox.widget.textbox(awful.layout.getname(awful.layout.get(s)):gsub("^%l", string.upper))

    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () layoutmenu:show() end),
                           awful.button({ }, 3, function () layoutmenu:show() end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))

    s:connect_signal("arrange", function ()
        local layout = awful.layout.getname(awful.layout.get(s)):gsub("^%l", string.upper);
        s.mylayoutbox.text = layout;
    end)

    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons)

    -- Create the Task Switcher
    s.mytaskmanager = TaskManager(s, settings, awful, gears, wibox, theme, debug);
    
    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s, height = theme.menu_height })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        expand = "none",
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            s.mytaglist
        },
        {
            layout = wibox.layout.fixed.horizontal,
            mytextclock
        }, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            wibox.layout.margin(wibox.widget.systray(), 6, theme.systray_icon_spacing, 6, 6),
            wibox.layout.margin(s.mylayoutbox, 0, 6, 0, 0),
        },
    }

end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
	awful.button({ }, 1, function () mainmenu:hide() end),
    awful.button({ }, 3, function () mainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(

    -- Awesome WM Functions
    awful.key({ settings.modkey, "Control" }, "r", awesome.restart, 
              {description = "Reload Awesome", group = "Awesome"}),

    awful.key({ settings.modkey, "Control" }, "q", awesome.quit,
              {description = "Quit Awesome", group = "Awesome"}),

    awful.key({ settings.modkey,           }, "h", hotkeys_popup.show_help,
              {description="Show Help", group="Awesome"}),

    -- Launcher
    awful.key({ "Control" }, "space", function() menubar.show() end,
              {description = "Toggle the menubar", group = "Launcher"}),

    -- Desktop Stuff
    awful.key({ settings.modkey,           }, "b", function () awful.spawn.with_shell(settings.wallpaper) end,
              {description = "Change Desktop Wallpaper", group = "Desktop"}),
    
    awful.key({ settings.modkey,           }, "l", function () awful.spawn.with_shell(settings.lock) end,
              {description = "Lock the Destkop", group = "Desktop"}),

    awful.key({ settings.modkey,           }, "Left", awful.tag.viewprev,
              {description = "Previous Desktop", group = "Desktop"}),
    
    awful.key({ settings.modkey,           }, "Right",  awful.tag.viewnext,
              {description = "Next Desktop", group = "Desktop"}),

    awful.key({ settings.modkey,           }, "Up",  function () awful.layout.inc( 1) end,
              {description = "Next Layout", group = "Desktop"}),

    awful.key({ settings.modkey,           }, "Down",  function () awful.layout.inc( -1) end,
              {description = "Previous Layout", group = "Desktop"}),

    awful.key({ settings.modkey,           }, "Return", awful.client.urgent.jumpto,
              {description = "Focus on Urgent Window", group = "Desktop"}),
            
              

    awful.key({ settings.modkey,           }, "Insert", function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "Add Main Window", group = "Desktop"}),

    awful.key({ settings.modkey,           }, "Delete", function () awful.tag.incnmaster( -1, nil, true) end,
              {description = "Remove Main Window", group = "Desktop"}),

    awful.key({ settings.modkey, "Shift"   }, "Insert", function () awful.tag.incncol( 1, nil, true) end,
              {description = "Add Column", group = "Desktop"}),

    awful.key({ settings.modkey, "Shift"   }, "Delete", function () awful.tag.incncol( -1, nil, true) end,
              {description = "Remove Column", group = "Desktop"}),

    awful.key({ settings.modkey, "Control" }, "m",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                      client.focus = c
                      c:raise()
                  end
              end,
              {description = "Restore Minimized", group = "Desktop"})

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
            function () awful.spawn(launcher.command) end,
            {
                description = launcher.name,
                group = "Launcher"
            }
        )
    )
end

clientkeys = gears.table.join(
    awful.key({ settings.modkey }, "space",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "Toggle Fullscreen", group = "Window"}),

    awful.key({ settings.modkey,           }, "x",      function (c) c:kill() end,
              {description = "Close", group = "Window"}),

    awful.key({ settings.modkey            }, "f", 
            function (c) 
                if (c.first_tag.layout.name ~= "floating") then
                    c.floating = not c.floating 
                end
            end,
            {description = "Toggle Floating", group = "Window"}),
    
    awful.key({ settings.modkey,           }, "t",      function (c) c.ontop = not c.ontop end,
              {description = "Toggle Keep on Top", group = "Window"}),
    
    awful.key({ settings.modkey,           }, "p",      function (c) c.sticky = not c.sticky end,
              {description = "Toggle Show on all Desktops", group = "Window"}),

    awful.key({ settings.modkey,           }, "m",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end,
        {description = "Minimize", group = "Window"}) --[[,

     awful.key({ settings.modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
        {description = "move to master", group = "Window"}),
    
    awful.key({ settings.modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "Window"}) ]]
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ settings.modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ settings.modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ settings.modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ settings.modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise()
                 mainmenu:hide() end),
    awful.button({ settings.modkey }, 1, awful.mouse.client.move),
    awful.button({ settings.modkey }, 3, awful.mouse.client.resize),
    awful.button({ settings.modkey }, 4, function (c) c.opacity = math.min(c.opacity + 0.1, 1.0) end),
    awful.button({ settings.modkey }, 5, function (c) c.opacity = math.max(c.opacity - 0.1, 0.1) end))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules

-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = gears.table.join(settings.rules, {
    {
        -- All clients will match this rule.
        rule = {},
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            size_hints_honor = false, -- Remove gaps between terminals
            screen = awful.screen.preferred,
            callback = awful.client.setslave,
            placement = awful.placement.no_overlap+awful.placement.no_offscreen
        }
    },

    -- Add titlebars to normal clients and dialogs
    { 
        rule_any = { 
            type = { "dialog" } 
        },
        properties = { 
            titlebars_enabled = true 
        }
    }
})
-- }}}

-- {{{ Signals

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup and
      not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Turn on Titlebars and OnTop when Window is set to float. 
client.connect_signal("property::floating", function (c)
    if c.floating then
        awful.titlebar.show(c)
        c.ontop = true;
    else
        awful.titlebar.hide(c)
        c.ontop = false;
    end
end)

-- turn tilebars on when layout is floating
awful.tag.attached_connect_signal(nil, "property::layout", function (t)
    local float = t.layout.name == "floating"

    for _,c in pairs(t:clients()) do
      c.floating = float
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            client.focus = c
            c:raise()
            awful.mouse.client.move(c)

            -- WILL EXECUTE THIS ON DOUBLE CLICK
            double_click_event_handler(function() 
                if c.first_tag.layout ~= awful.layout.suit.floating then
                    c.floating = false
                end
            end)
        end),
        awful.button({ }, 3, function()
            client.focus = c
            c:raise()
            awful.mouse.client.resize(c)
        end)
    )
    awful.titlebar(c):setup {
        { -- Left
            awful.titlebar.widget.closebutton(c),
            -- awful.titlebar.widget.iconwidget(c),
            layout = wibox.layout.fixed.horizontal()
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.stickybutton (c),
            awful.titlebar.widget.minimizebutton (c),
            layout = wibox.layout.fixed.horizontal(),
            spacing = dpi(24)
        },
        layout = wibox.layout.align.horizontal
    }
        -- Hide the menubar if we are not floating
   -- local l = awful.layout.get(c.screen)
   -- if not (l.name == "floating" or c.floating) then
   --     awful.titlebar.hide(c)
   -- end
end)

-- No Maximized Windows!
client.connect_signal("property::maximized", function(c)
    c.maximized = false;
end);

client.connect_signal("property::maximized_vertical", function(c)
    c.maximized_vertical = false;
end);

client.connect_signal("property::maximized_horizontal", function(c)
    c.maximized_horizontal = false;
end);

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
        and awful.client.focus.filter(c) then
        client.focus = c
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- Disable borders on lone windows
-- Handle border sizes of clients.
for s = 1, screen.count() do screen[s]:connect_signal("arrange", function ()
  local clients = awful.client.visible(s)
  local layout = awful.layout.getname(awful.layout.get(s))

  for _, c in pairs(clients) do
    -- No borders with only one humanly visible client
    if c.floating or layout == "floating" then
        c.border_width = beautiful.border_width
    elseif layout == "max" or layout == "fullscreen" then
        c.border_width = 0
        c.first_tag.gap = 0
    else
      local tiled = awful.client.tiled(c.screen)
      if #tiled == 1 then -- and c == tiled[1] then
        tiled[1].border_width = 0
        c.first_tag.gap = 0
      else
        c.border_width = beautiful.border_width
        c.first_tag.gap = theme.useless_gap
      end
    end
  end
end)
end

-- }}}

-- Wallpaper
awful.spawn.with_shell(settings.wallpaper)

-- Picom
if settings.compositor then 
    awful.spawn.with_shell(string.format("picom -b --vsync --experimental-backends --config %s/.config/awesome/picom.conf", os.getenv("HOME")))
end

-- Autorun
awful.spawn.with_shell(settings.autorun)
