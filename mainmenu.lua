-- Freedesktop menu
local freedesktop = require("freedesktop")

-- Awful
local awful = require("awful")

-- Load Configuration
local settings = require('settings');

-- Menubar
local menubar = require("menubar");

local myawesomemenu = {
    { "hotkeys", function() return false, hotkeys_popup.show_help end, menubar.utils.lookup_icon("preferences-desktop-keyboard-shortcuts") },
    { "manual", settings.terminal .. " -e man awesome", menubar.utils.lookup_icon("system-help") },
    { "edit config", settings.gui_editor .. " " .. awesome.conffile,  menubar.utils.lookup_icon("accessories-text-editor") },
    { "restart", awesome.restart, menubar.utils.lookup_icon("system-restart") }
}

local myexitmenu = {
    { "lock", settings.lock, menubar.utils.lookup_icon("system-switch-user") },
    { "log out", function() awesome.quit() end, menubar.utils.lookup_icon("system-log-out") },
    { "suspend", settings.suspend, menubar.utils.lookup_icon("system-suspend") },
    { "hibernate", settings.hibernate, menubar.utils.lookup_icon("system-suspend-hibernate") },
    { "reboot", settings.reboot, menubar.utils.lookup_icon("system-reboot") },
    { "shutdown", settings.shutdown, menubar.utils.lookup_icon("system-shutdown") }
}

return freedesktop.menu.build({
    icon_size = 32,
    before = {
        { "Terminal", settings.terminal, menubar.utils.lookup_icon("utilities-terminal") },
        { "Browser", settings.browser, menubar.utils.lookup_icon("internet-web-browser") },
        { "Files", settings.filemanager, menubar.utils.lookup_icon("system-file-manager") },
        -- other triads can be put here
    },
    after = {
        { "Change Wallpaper", function () awful.spawn.with_shell(settings.wallpaper) end, "" },
        { "Awesome", myawesomemenu, "/usr/share/awesome/icons/awesome32.png" },
        { "Exit", myexitmenu, menubar.utils.lookup_icon("system-shutdown") },
        -- other triads can be put here
    }
});
