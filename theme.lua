local dpi   = require("beautiful.xresources").apply_dpi
local gfs = require("gears.filesystem")

local themes_path = gfs.get_themes_dir()

theme = {}

theme.font              = "Cantarell 14"
theme.notification_font = "Cantarell 14"

theme.useless_gap 	    =  dpi(8)

theme.bg_normal   = "#000000"
theme.bg_focus    = "#222222"
theme.bg_urgent   = theme.bg_normal
theme.bg_minimize = theme.bg_normal
theme.bg_systray  = theme.bg_normal

theme.fg_normal   = "#ffffff"
theme.fg_focus    = "#ffffff"
theme.fg_urgent   = "#ff0000"
theme.fg_minimize = "#ffffff"

theme.border_width  = dpi(1)
theme.border_normal = "#222222"
theme.border_focus  = "#161616"
theme.border_marked = "#6510CC"

theme.hotkeys_modifiers_fg = "#2EB398"

-- System Tray
theme.systray_icon_spacing = 24;

theme.menu_height = dpi(32)
theme.menu_width  = dpi(200)

-- Define the image to load
theme.titlebar_close_button_normal = themes_path.."default/titlebar/close_normal.png"
theme.titlebar_close_button_focus  = themes_path.."default/titlebar/close_focus.png"

theme.titlebar_minimize_button_normal = themes_path.."default/titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus  = themes_path.."default/titlebar/minimize_focus.png"

theme.titlebar_sticky_button_normal_inactive = themes_path.."default/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive  = themes_path.."default/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = themes_path.."default/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active  = themes_path.."default/titlebar/sticky_focus_active.png"

-- Dock
theme.dock = {
    height = theme.menu_height * 2,
    height_hidden = dpi(6),
    icon_spacing = dpi(12),
    icon_padding = dpi(8)
}

return theme
