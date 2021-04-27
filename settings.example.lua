local awful = require("awful")

settings = {}

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
settings.modkey = "Mod4"

-- Applications
settings.browser = "exo-open --launch WebBrowser" or "firefox"
settings.filemanager = "exo-open --launch FileManager" or "nautilus"
settings.gui_editor = "code"
settings.terminal = "alacritty"
settings.wallpaper = '~/.fehbg';

-- System Control
settings.lock = "i3lock -c 000000 -b";
settings.suspend = "systemctl suspend";
settings.hibernate = "systemctl hibernate";
settings.reboot = "systemctl reboot"
settings.shutdown = "poweroff";

-- Dock
settings.dock = {
    timeout = 2
}

-- Launchers. 
settings.launchers = {
    ["F1"] = {
        name = "Launch Terminal",
        command = settings.terminal
    },
    ["F2"] = {
        name = "Launch File Manager",
        command = settings.filemanager
    },
    ["F3"] = {
        name = "Launch Browser (" .. settings.browser .. ")",
        command = settings.browser
    },
    ["F4"] = {
        name = "Launch GUI Editor (" .. settings.gui_editor .. ")",
        command = settings.gui_editor
    }
}

-- Tags
settings.tags = {
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

-- Rules to apply to new clients (through the "manage" signal).
settings.rules = {
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
    { 
        rule = { 
            class = "Firefox" 
        },
        properties = { screen = 1, tag = "Beta" } 
    },

    -- Open these Windows on Tag "Gamma"
    { 
        rule = { 
            class = "Steam" 
        },
        properties = { screen = 1, tag = "Gamma" } 
    },

    -- Always float these. 
    { 
        rule_any = {
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
                "xtightvncviewer"
            },
            name = {
                "Event Tester",  -- xev.
            },
            role = {
                "AlarmWindow",  -- Thunderbird's calendar.
                "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
            }
        }, 
        properties = { 
            floating = true 
        }
    }
}

return settings;