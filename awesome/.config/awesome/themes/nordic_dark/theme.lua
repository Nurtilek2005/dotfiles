local theme_assets                              = require("beautiful.theme_assets")
local xresources                                = require("beautiful.xresources")
local gfs                                       = require("gears.filesystem")
local gears                                     = require("gears")
local dpi                                       = xresources.apply_dpi

local theme_name                                = "nordic_dark"
local theme_path                                = gfs.get_configuration_dir() .. "/themes/" .. theme_name

local theme                                     = {}

-- Font
theme.font                                      = "Exo 2 10"

-- Colors (Darker colors following the Nordic theme)
theme.bg_normal                                 = "#3A4152"
theme.fg_normal                                 = "#D0D7DE"
theme.bg_focus                                  = "#4D556B"
theme.fg_focus                                  = "#E2EAF1"
theme.bg_urgent                                 = "#BF616A"
theme.fg_urgent                                 = "#404759"
theme.bg_minimize                               = "#2D323F"
theme.fg_minimize                               = "#A7ADB3"

-- Systray and Widget
theme.systray_icon_spacing                      = dpi(6)
theme.bg_systray                                = theme.bg_normal
theme.bg_widget                                 = theme.bg_normal

-- Gaps and Borders
theme.gap_single_client                         = true
theme.useless_gap                               = dpi(4)
theme.border_width                              = dpi(2)
theme.border_normal                             = "#242833"
theme.border_focus                              = "#313745"
theme.border_marked                             = "#404759"

-- Taglist
theme.taglist_square_size                       = dpi(5)
theme.taglist_bg_focus                          = theme.bg_focus
theme.taglist_fg_focus                          = theme.fg_focus
theme.taglist_bg_urgent                         = theme.bg_urgent
theme.taglist_fg_urgent                         = theme.fg_urgent

theme.taglist_bg_occupied                       = theme.bg_normal
theme.taglist_fg_occupied                       = theme.fg_normal
theme.taglist_bg_empty                          = theme.bg_minimize
theme.taglist_fg_empty                          = theme.fg_minimize
theme.taglist_bg_volatile                       = "#2E3442"
theme.taglist_fg_volatile                       = "#E2EAF1"

-- Taglist Numbers
theme.taglist_squares_sel                       = theme_assets.taglist_squares_sel(
    theme.taglist_square_size, theme.fg_focus
)
theme.taglist_squares_unsel                     = theme_assets.taglist_squares_unsel(
    theme.taglist_square_size, theme.fg_normal
)

-- Tasklist
theme.tasklist_bg_focus                         = theme.bg_focus
theme.tasklist_fg_focus                         = theme.fg_focus
theme.tasklist_bg_urgent                        = theme.bg_urgent
theme.tasklist_fg_urgent                        = theme.fg_urgent

-- Titlebar
theme.titlebar_bg_normal                        = theme.bg_normal
theme.titlebar_fg_normal                        = theme.fg_normal
theme.titlebar_bg_focus                         = theme.bg_focus
theme.titlebar_fg_focus                         = theme.fg_focus

-- Tooltip
theme.tooltip_font                              = theme.font
theme.tooltip_opacity                           = 0.9
theme.tooltip_bg_color                          = theme.bg_normal
theme.tooltip_fg_color                          = theme.fg_normal
theme.tooltip_border_width                      = theme.border_width
theme.tooltip_border_color                      = theme.border_normal

-- Mouse Finder
theme.mouse_finder_color                        = theme.bg_urgent
theme.mouse_finder_timeout                      = 2
theme.mouse_finder_animate_timeout              = 0.2
theme.mouse_finder_radius                       = 20
theme.mouse_finder_factor                       = 2

-- Prompt
theme.prompt_font                               = theme.font
theme.prompt_bg                                 = theme.bg_normal
theme.prompt_fg                                 = theme.fg_normal
theme.prompt_bg_cursor                          = theme.bg_focus
theme.prompt_fg_cursor                          = theme.fg_focus

-- Hotkeys
theme.hotkeys_font                              = theme.font
theme.hotkeys_bg                                = theme.bg_normal
theme.hotkeys_fg                                = theme.fg_normal
theme.hotkeys_border_width                      = theme.border_width
theme.hotkeys_border_color                      = theme.border_normal
theme.hotkeys_shape                             = function(cr, width, height)
    gears.shape.rectangle(cr, width, height)
end
theme.hotkeys_opacity                           = 0.8
theme.hotkeys_group_margin                      = dpi(20)
theme.hotkeys_description_font                  = theme.font
theme.hotkeys_modifiers_fg                      = theme.fg_focus
theme.hotkeys_label_bg                          = theme.bg_normal
theme.hotkeys_label_fg                          = theme.fg_normal

-- Notifications
theme.notification_font                         = theme.font
theme.notification_bg                           = theme.bg_normal
theme.notification_fg                           = theme.fg_normal
theme.notification_width                        = dpi(300)
theme.notification_height                       = dpi(80)
theme.notification_margin                       = dpi(10)
theme.notification_border_color                 = theme.border_normal
theme.notification_border_width                 = theme.border_width
theme.notification_shape                        = gears.shape.rectangle
theme.notification_opacity                      = 0.9

-- Menu
theme.menu_bg_normal                            = theme.bg_normal
theme.menu_fg_normal                            = theme.fg_normal
theme.menu_bg_focus                             = theme.bg_focus
theme.menu_fg_focus                             = theme.fg_focus
theme.menu_border_color                         = theme.border_normal
theme.menu_border_width                         = theme.border_width
theme.menu_submenu_icon                         = theme_path .. "/submenu.png"
theme.menu_height                               = dpi(25)
theme.menu_width                                = dpi(175)

-- Titlebar Buttons
theme.titlebar_close_button_normal              = theme_path .. "/titlebar/close_normal.png"
theme.titlebar_close_button_focus               = theme_path .. "/titlebar/close_focus.png"
theme.titlebar_minimize_button_normal           = theme_path .. "/titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus            = theme_path .. "/titlebar/minimize_focus.png"

-- Titlebar Buttons (OnTop)
theme.titlebar_ontop_button_normal_inactive     = theme_path .. "/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive      = theme_path .. "/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active       = theme_path .. "/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active        = theme_path .. "/titlebar/ontop_focus_active.png"

-- Titlebar Buttons (Sticky)
theme.titlebar_sticky_button_normal_inactive    = theme_path .. "/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive     = theme_path .. "/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active      = theme_path .. "/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active       = theme_path .. "/titlebar/sticky_focus_active.png"

-- Titlebar Buttons (Floating)
theme.titlebar_floating_button_normal_inactive  = theme_path .. "/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive   = theme_path .. "/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active    = theme_path .. "/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active     = theme_path .. "/titlebar/floating_focus_active.png"

-- Titlebar Buttons (Maximized)
theme.titlebar_maximized_button_normal_inactive = theme_path .. "/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = theme_path .. "/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active   = theme_path .. "/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active    = theme_path .. "/titlebar/maximized_focus_active.png"

-- Wallpaper and Layouts
theme.wallpaper                                 = theme_path .. "/background.png"
theme.layout_fairh                              = theme_path .. "/layouts/fairhw.png"
theme.layout_fairv                              = theme_path .. "/layouts/fairvw.png"
theme.layout_floating                           = theme_path .. "/layouts/floatingw.png"
theme.layout_magnifier                          = theme_path .. "/layouts/magnifierw.png"
theme.layout_max                                = theme_path .. "/layouts/maxw.png"
theme.layout_fullscreen                         = theme_path .. "/layouts/fullscreenw.png"
theme.layout_tilebottom                         = theme_path .. "/layouts/tilebottomw.png"
theme.layout_tileleft                           = theme_path .. "/layouts/tileleftw.png"
theme.layout_tile                               = theme_path .. "/layouts/tilew.png"
theme.layout_tiletop                            = theme_path .. "/layouts/tiletopw.png"
theme.layout_spiral                             = theme_path .. "/layouts/spiralw.png"
theme.layout_dwindle                            = theme_path .. "/layouts/dwindlew.png"
theme.layout_cornernw                           = theme_path .. "/layouts/cornernww.png"
theme.layout_cornerne                           = theme_path .. "/layouts/cornernew.png"
theme.layout_cornersw                           = theme_path .. "/layouts/cornersww.png"
theme.layout_cornerse                           = theme_path .. "/layouts/cornersew.png"

-- AwesomeWM Icon
theme.awesome_icon                              = theme_assets.awesome_icon(
    theme.menu_height, theme.bg_focus, theme.fg_focus
)

-- Icon Theme
theme.icon_theme                                = "Papirus-Dark"

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
