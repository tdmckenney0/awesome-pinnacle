-- Standard awesome library
local gears = require("gears")
local awful = require("awful")

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

-- Freedesktop menu
local freedesktop = require("freedesktop")

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
	
-- This is used later as the default terminal and editor to run.
browser = "exo-open --launch WebBrowser" or "firefox"
filemanager = "exo-open --launch FileManager" or "thunar"
gui_editor = "code"
terminal = "alacritty"

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

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
    awful.layout.suit.corner.nw,
    awful.layout.suit.corner.ne,
    awful.layout.suit.corner.sw,
    awful.layout.suit.corner.se,
    awful.layout.suit.floating
}
-- }}}

-- F1 -> F12 Launchers. 
launchers = {
    ["F1"] = {
        name = "Launch Terminal",
        command = terminal
    },
    ["F2"] = {
        name = "Launch File Manager",
        command = filemanager
    },
    ["F3"] = {
        name = "Launch Browser (" .. browser .. ")",
        command = browser
    },
    ["F4"] = {
        name = "Launch GUI Editor (" .. gui_editor .. ")",
        command = gui_editor
    },
    ["F5"] = {
        name = "Show All Applications",
        command = filemanager .. " /usr/share/applications"
    },
    ["F6"] = {
        name = "Launch Task Manager (htop)",
        command = terminal .. " -e htop"
    },
    ["F7"] = {
        name = "Launch Sound Control (alsamixer)",
        command = terminal .. " --hold -e alsamixer"
    },
    ["F8"] = {
        name = "Window Inspector (xprop)",
        command = terminal .. " --hold -e xprop"
    },
    ["F9"] = {
        name = "Kill Window (xkill)",
        command = "xkill"
    },
    ["F10"] = {
        name = "Launch Neofetch",
        command = terminal .. " --hold -e neofetch"
    },
    ["F11"] = {
        name = "Launch Ranger",
        command = terminal .. " --hold -e ranger"
    }
}

--- Tag Layouts
tags = {
    {
        name = "Alpha",
        config = {
            layout = awful.layout.suit.fair.horizontal,
            selected = true
        }
    },
    {
        name = "Beta",
        config = {}
    },
    {
        name = "Gamma",
        config = {}
    },
    {
        name = "Delta",
        config = {}
    },
    {
        name = "Epsilon",
        config = {}
    },
    {
        name = "Zeta",
        config = {}
    },
    {
        name = "Kappa",
        config = {}
    }
}

-- {{{ Helper functions
local function client_menu_toggle_fn()
    local instance = nil
    return function ()
        if instance and instance.wibox.visible then
            instance:hide()
            instance = nil
        else
            instance = awful.menu.clients({ theme = { width = 250 } })
        end
    end
end
-- }}}


-- {{{ Layout Menu
layoutmenuitems = {}

for id, layout in pairs(awful.layout.layouts) do 
    table.insert(layoutmenuitems, {
        layout.name:gsub("^%l", string.upper), -- UC first. 
        function () 
            awful.layout.set(layout)
        end,
        ""
    })
end

layoutmenu = awful.menu(layoutmenuitems)
-- }}}


-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
    { "hotkeys", function() return false, hotkeys_popup.show_help end, menubar.utils.lookup_icon("preferences-desktop-keyboard-shortcuts") },
    { "manual", terminal .. " -e man awesome", menubar.utils.lookup_icon("system-help") },
    { "edit config", gui_editor .. " " .. awesome.conffile,  menubar.utils.lookup_icon("accessories-text-editor") },
    { "restart", awesome.restart, menubar.utils.lookup_icon("system-restart") }
}
myexitmenu = {
    { "lock", "light-locker-command -l", menubar.utils.lookup_icon("system-switch-user") },
    { "log out", function() awesome.quit() end, menubar.utils.lookup_icon("system-log-out") },
    { "suspend", "systemctl suspend", menubar.utils.lookup_icon("system-suspend") },
    { "hibernate", "systemctl hibernate", menubar.utils.lookup_icon("system-suspend-hibernate") },
    { "reboot", "systemctl reboot", menubar.utils.lookup_icon("system-reboot") },
    { "shutdown", "poweroff", menubar.utils.lookup_icon("system-shutdown") }
}
mymainmenu = freedesktop.menu.build({
    icon_size = 32,
    before = {
        { "Terminal", terminal, menubar.utils.lookup_icon("utilities-terminal") },
        { "Browser", browser, menubar.utils.lookup_icon("internet-web-browser") },
        { "Files", filemanager, menubar.utils.lookup_icon("system-file-manager") },
        -- other triads can be put here
    },
    after = {
        { "Awesome", myawesomemenu, "/usr/share/awesome/icons/awesome32.png" },
        { "Exit", myexitmenu, menubar.utils.lookup_icon("system-shutdown") },
        -- other triads can be put here
    }
})
mylauncher = awful.widget.launcher({ text = "Menu",
                                     -- image = beautiful.awesome_icon,
                                     menu = mymainmenu })
-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock("%a %B %d %Y %I:%M %p %Z")
-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

darkblue    = beautiful.bg_focus
blue        = "#9EBABA"
red         = "#EB8F8F"

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ modkey }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                          end),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
                )

local tasklist_buttons = gears.table.join(
                     awful.button({ modkey }, 1, function (c)
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
                     awful.button({ modkey }, 3, client_menu_toggle_fn()),
                     awful.button({ modkey }, 4, function ()
                                              awful.client.focus.byidx(1)
                                          end),
                     awful.button({ modkey  }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                          end))

awful.screen.connect_for_each_screen(function(s)
    -- Setup tags. 
    for id, config in pairs(tags) do 
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

    s.mytaskmanager = awful.popup {
        widget = awful.widget.tasklist {
            screen   = s,
            filter   = awful.widget.tasklist.filter.alltags,
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
        visible      = false
    }
    
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

awful.keygrabber {
    keybindings = {
        {
            {modkey}, 'Tab', 
            function () 
                awful.screen.focused().mytaskmanager.visible = true
                awful.client.focus.byidx( 1) 
            end,
            {description = "Next Window", group = "Desktop"}
        },
        {
            {modkey, 'Shift'}, 'Tab', 
            function () 
                awful.screen.focused().mytaskmanager.visible = true
                awful.client.focus.byidx( -1) 
            end,
            {description = "Previous Window", group = "Desktop"}
        }
    },
    -- Note that it is using the key name and not the modifier name.
    stop_key           = modkey,
    stop_event         = 'release',
    start_callback     = function () end,
    stop_callback      = function () awful.screen.focused().mytaskmanager.visible = false end,
    export_keybindings = true
}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
	awful.button({ }, 1, function () mymainmenu:hide() end),
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(

    -- Awesome WM Functions
    awful.key({ modkey, "Control" }, "r", awesome.restart, 
              {description = "Reload Awesome", group = "Awesome"}),

    awful.key({ modkey, "Control" }, "q", awesome.quit,
              {description = "Quit Awesome", group = "Awesome"}),

    awful.key({ modkey, "Control" }, "l", function () awful.spawn.with_shell("light-locker-command -l") end,
              {description = "Lock Awesome", group = "Awesome"}),

    awful.key({ modkey,           }, "h", hotkeys_popup.show_help,
              {description="Show Help", group="Awesome"}),

    -- Launcher
    awful.key({ "Control" }, "space", function() menubar.show() end,
              {description = "Toggle the menubar", group = "Launcher"}),

    -- Desktop Stuff
    awful.key({ modkey, "Control" }, "b", function () awful.spawn.with_shell("~/.fehbg") end,
              {description = "Change Desktop Wallpaper", group = "Desktop"}),

    awful.key({ modkey,           }, "Left", awful.tag.viewprev,
              {description = "Previous Desktop", group = "Desktop"}),
    
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "Next Desktop", group = "Desktop"}),

    awful.key({ modkey,           }, "Up",  function () awful.layout.inc( 1) end,
              {description = "Next Layout", group = "Desktop"}),

    awful.key({ modkey,           }, "Down",  function () awful.layout.inc( -1) end,
              {description = "Previous Layout", group = "Desktop"}),

    awful.key({ modkey,           }, "Return", awful.client.urgent.jumpto,
              {description = "Focus on Urgent Window", group = "Desktop"}),
            
              

    awful.key({ modkey,           }, "Insert", function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "Add Main Window", group = "Desktop"}),

    awful.key({ modkey,           }, "Delete", function () awful.tag.incnmaster( -1, nil, true) end,
              {description = "Remove Main Window", group = "Desktop"}),

    awful.key({ modkey, "Shift"   }, "Insert", function () awful.tag.incncol( 1, nil, true) end,
              {description = "Add Column", group = "Desktop"}),

    awful.key({ modkey, "Shift"   }, "Delete", function () awful.tag.incncol( -1, nil, true) end,
              {description = "Remove Column", group = "Desktop"}),

    awful.key({ modkey, "Control" }, "m",
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
    --[[ awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "Window"}),

    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),

    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}), 
    
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05) end,
              {description = "increase master width factor", group = "layout"}),

    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05) end,
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
for key, launcher in pairs(launchers) do 
    globalkeys = gears.table.join(
        globalkeys,
        awful.key(
            { modkey },
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
    awful.key({ modkey }, "space",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "Toggle Fullscreen", group = "Window"}),

    awful.key({ modkey,           }, "x",      function (c) c:kill() end,
              {description = "Close", group = "Window"}),

    awful.key({ modkey            }, "f",  awful.client.floating.toggle,
              {description = "Toggle Floating", group = "Window"}),

    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop end,
              {description = "Toggle Keep on Top", group = "Window"}),
    
    awful.key({ modkey,           }, "p",      function (c) c.sticky = not c.sticky end,
              {description = "Toggle Show on all Desktops", group = "Window"}),

    awful.key({ modkey,           }, "m",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end,
        {description = "Minimize", group = "Window"}) --[[,

     awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
        {description = "move to master", group = "Window"}),
    
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "Window"}) ]]
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
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
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
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
                 mymainmenu:hide() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize),
    awful.button({ modkey }, 4, function (c) c.opacity = math.min(c.opacity + 0.1, 1.0) end),
    awful.button({ modkey }, 5, function (c) c.opacity = math.max(c.opacity - 0.1, 0.1) end))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
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

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
        },
        class = {
          "Arandr",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Wpa_gui",
          "pinentry",
          "veromix",
          "xtightvncviewer"},

        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},
	
    -- Open these Windows on Tag "Alpha"
    { 
        rule_any = { 
            class = { 
                "discord",
                "Signal"
            }
        },
      properties = { screen = 1, tag = "Alpha" } 
    },

    -- Open these Windows on Tag "Beta"
    { rule = { class = "Firefox" },
      properties = { screen = 1, tag = "Beta" } 
    },

    -- Open these Windows on Tag "Gamma"
    { rule = { class = "Steam" },
      properties = { screen = 1, tag = "Gamma" } 
    },
}
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
    else
      local tiled = awful.client.tiled(c.screen)
      if #tiled == 1 then -- and c == tiled[1] then
        tiled[1].border_width = beautiful.border_width
        tiled[1].border_color  = beautiful.border_normal
      else
        c.border_width = beautiful.border_width
      end
    end
  end
end)
end

-- }}}

awful.spawn.with_shell("~/.config/autorun.sh")