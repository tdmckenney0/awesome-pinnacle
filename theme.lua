local dpi   = require("beautiful.xresources").apply_dpi

theme = {}

theme.font              = "Cantarell 14"
theme.notification_font = "Cantarell 14"

theme.useless_gap 	    =  dpi(12)

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

-- No Icons on the tab strip. 
theme.tasklist_disable_icon = false
theme.tasklist_disable_task_name = true

-- System Tray
theme.systray_icon_spacing = 24;

theme.menu_height = dpi(32)
theme.menu_width  = dpi(200)

theme.icon_theme = "Pop"

-- Dock
theme.dock = {
    height = theme.menu_height * 2,
    height_hidden = dpi(6),
    icon_spacing = dpi(12),
    icon_padding = dpi(8)
}

return theme
