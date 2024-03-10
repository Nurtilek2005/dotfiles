pcall(require, "luarocks.loader")

local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local naughty = require("naughty")
local menubar = require("menubar")
local beautiful = require("beautiful")
local hotkeys_popup = require("awful.hotkeys_popup")
local volume_widget = require('awesome-wm-widgets.volume-widget.volume')
local battery_widget = require("awesome-wm-widgets.battery-widget.battery")
local calendar_widget = require("awesome-wm-widgets.calendar-widget.calendar")
local brightness_widget = require("awesome-wm-widgets.brightness-widget.brightness")
local logout_menu_widget = require("awesome-wm-widgets.logout-menu-widget.logout-menu")
require("awful.hotkeys_popup.keys")
require("awful.autofocus")

--[ CATHING ERRORS ]---------------------
if awesome.startup_errors then
    naughty.notify({
        preset = naughty.config.presets.critical,
        title = "Oops, there were errors during startup!",
        text = awesome.startup_errors
    })
end

do
    local in_error = false
    awesome.connect_signal("debug::error", function(err)
        if in_error then return end
        in_error = true
        naughty.notify({
            preset = naughty.config.presets.critical,
            title = "Oops, an error happened!",
            text = tostring(err)
        })
        in_error = false
    end)
end
-----------------------------------------

--[ VARIABLES ]--------------------------
modkey = "Mod4"
altkey = "Mod1"
terminal = "kitty"
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor

local theme = "nordic_dark"
local home_dir = os.getenv("HOME")
local awesome_dir = gears.filesystem.get_configuration_dir()
local launcher = home_dir .. "/.config/rofi/scripts/launcher_t1"
local theme_dir = awesome_dir .. "themes/" .. theme .. "/"
-----------------------------------------

--[ AUTOSTART ]--------------------------
awful.spawn.with_shell(awesome_dir .. "autostart.sh")
-----------------------------------------

--[ BEAUTIFUL ]--------------------------
beautiful.init(theme_dir .. "theme.lua")

local function set_wallpaper(s)
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

screen.connect_signal("property::geometry", set_wallpaper)
-----------------------------------------

--[ LAYOUTS ]----------------------------
awful.layout.layouts = {
    -- awful.layout.suit.floating,
    awful.layout.suit.tile,
    -- awful.layout.suit.tile.left,
    -- awful.layout.suit.tile.bottom,
    -- awful.layout.suit.tile.top,
    -- awful.layout.suit.fair,
    -- awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
    -- awful.layout.suit.max,
    -- awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.magnifier,
    -- awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}
-----------------------------------------

--[ AWESOME MENU ]-----------------------
myawesomemenu = {
    { "hotkeys",     function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
    { "manual",      terminal .. " -e man awesome" },
    { "edit config", editor_cmd .. " " .. awesome.conffile },
    { "restart",     awesome.restart },
    { "quit",        function() awesome.quit() end },
}

mymainmenu = awful.menu({
    items = {
        { "awesome",       myawesomemenu, beautiful.awesome_icon },
        { "open terminal", terminal }
    }
})

mylauncher = awful.widget.launcher({
    image = beautiful.awesome_icon,
    menu = mymainmenu
})

menubar.utils.terminal = terminal
-----------------------------------------

--[ WIBAR ]------------------------------
mytextclock = wibox.widget.textclock()
mykeyboardlayout = awful.widget.keyboardlayout()

local cw = calendar_widget({
    theme = 'nord',
    next_month_button = 3,
    previous_month_button = 1,
    placement = 'bottom_right',
    radius = 4,
})

local taglist_buttons = gears.table.join(
    awful.button({}, 1, function(t) t:view_only() end),
    awful.button({ modkey }, 1, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),
    awful.button({}, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
        if client.focus then
            client.focus:toggle_tag(t)
        end
    end),
    awful.button({}, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({}, 5, function(t) awful.tag.viewprev(t.screen) end)
)

local tasklist_buttons = gears.table.join(
    awful.button({}, 1, function(c)
        if c == client.focus then
            c.minimized = true
        else
            c:emit_signal(
                "request::activate",
                "tasklist",
                { raise = true }
            )
        end
    end),
    awful.button({}, 3, function()
        awful.menu.client_list(
            {
                theme = { width = 400 }
            }
        )
    end),
    awful.button({}, 4, function() awful.client.focus.byidx(1) end),
    awful.button({}, 5, function() awful.client.focus.byidx(-1) end)
)

awful.screen.connect_for_each_screen(function(s)
    set_wallpaper(s)

    awful.tag({ " 1 ", " 2 ", " 3 ", " 4 ", " 5 ", " 6 ", " 7 ", " 8 ", " 9 " }, s, awful.layout.layouts[1])

    s.mypromptbox = awful.widget.prompt()
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
        awful.button({}, 1, function() awful.layout.inc(1) end),
        awful.button({}, 3, function() awful.layout.inc(-1) end),
        awful.button({}, 4, function() awful.layout.inc(1) end),
        awful.button({}, 5, function() awful.layout.inc(-1) end)
    ))
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons
    }
    s.mytasklist = awful.widget.tasklist {
        screen          = s,
        filter          = awful.widget.tasklist.filter.currenttags,
        buttons         = tasklist_buttons,
        style           = {
            border_width = 1,
            border_color = beautiful.bg_occupied,
            --shape        = gears.shape.rounded_bar,
        },
        layout          = {
            spacing        = 10,
            spacing_widget = {
                {
                    forced_width = 5,
                    shape        = gears.shape.circle,
                    widget       = wibox.widget.separator
                },
                valign = "center",
                halign = "center",
                widget = wibox.container.place,
            },
            layout         = wibox.layout.flex.horizontal
        },
        -- Notice that there is *NO* wibox.wibox prefix, it is a template,
        -- not a widget instance.
        widget_template = {
            {
                {
                    {
                        {
                            id     = "icon_role",
                            widget = wibox.widget.imagebox,
                        },
                        margins = 4,
                        widget  = wibox.container.margin,
                    },
                    {
                        id     = "text_role",
                        widget = wibox.widget.textbox,
                    },
                    layout = wibox.layout.fixed.horizontal,
                },
                left   = 4,
                right  = 4,
                widget = wibox.container.margin
            },
            id     = "background_role",
            widget = wibox.container.background,
        },
    }
    s.mywibox = awful.wibar({ position = "bottom", screen = s, height = 30, })
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        {
            layout = wibox.layout.fixed.horizontal,
            mylauncher,
            s.mytaglist,
            s.mypromptbox,
        },
        s.mytasklist,
        {
            spacing_widget = {
                {
                    forced_width  = 5,
                    forced_height = 24,
                    thickness     = 2,
                    color         = beautiful.bg_occupied,
                    widget        = wibox.widget.separator,
                },
                valign = 'center',
                halign = 'center',
                widget = wibox.container.place,
            },
            spacing        = 24,
            layout         = wibox.layout.fixed.horizontal,
            wibox.widget.textbox(),
            wibox.widget.systray(),
            mykeyboardlayout,
            volume_widget {
                step = 2,
                device = "pipewire",
                widget_type = "icon_and_text",
            },
            brightness_widget {
                type = 'icon_and_text',
                program = 'light',
                step = 5,
            },
            battery_widget {
                font = beautiful.font,
                show_current_level = true,
            },
            mytextclock,
            logout_menu_widget {
                font = beautiful.font,
                onlock = function() awful.spawn.with_shell('dm-tool lock') end
            },
            s.mylayoutbox,
        },
    }
end)
-----------------------------------------

--[ MOUSE BINDIGS ]----------------------
root.buttons(gears.table.join(
    awful.button({}, 3, function() mymainmenu:toggle() end),
    awful.button({}, 4, awful.tag.viewnext),
    awful.button({}, 5, awful.tag.viewprev)
))
-----------------------------------------

--[ KEYBINDIGS ]-------------------------
globalkeys = gears.table.join(
    awful.key({ modkey, }, "/", hotkeys_popup.show_help,
        { description = "show help", group = "awesome" }
    ),
    awful.key({ modkey, }, "Left", awful.tag.viewprev,
        { description = "view previous", group = "tag" }
    ),
    awful.key({ modkey, }, "Right", awful.tag.viewnext,
        { description = "view next", group = "tag" }
    ),
    awful.key({ modkey, }, "Escape", awful.tag.history.restore,
        { description = "go back", group = "tag" }
    ),
    awful.key({ modkey, }, "j", function() awful.client.focus.byidx(1) end,
        { description = "focus next by index", group = "client" }
    ),
    awful.key({ modkey, }, "k", function() awful.client.focus.byidx(-1) end,
        { description = "focus previous by index", group = "client" }
    ),
    awful.key({ modkey, }, "w", function() mymainmenu:show() end,
        { description = "show main menu", group = "awesome" }
    ),
    awful.key({ modkey, "Shift" }, "j", function() awful.client.swap.byidx(1) end,
        { description = "swap with next client by index", group = "client" }
    ),
    awful.key({ modkey, "Shift" }, "k", function() awful.client.swap.byidx(-1) end,
        { description = "swap with previous client by index", group = "client" }
    ),
    awful.key({ modkey, "Control" }, "j", function() awful.screen.focus_relative(1) end,
        { description = "focus the next screen", group = "screen" }
    ),
    awful.key({ modkey, "Control" }, "k", function() awful.screen.focus_relative(-1) end,
        { description = "focus the previous screen", group = "screen" }
    ),
    awful.key({ modkey, }, "u", awful.client.urgent.jumpto,
        { description = "jump to urgent client", group = "client" }
    ),
    awful.key({ modkey, }, "Tab",
        function()
            awful.client.focus.history.previous()
            if client.focus then client.focus:raise() end
        end,
        { description = "go back", group = "client" }
    ),
    awful.key({ modkey, }, "Return", function() awful.spawn(terminal) end,
        { description = "open a terminal", group = "launcher" }
    ),
    awful.key({ modkey, altkey }, "r", awesome.restart,
        { description = "reload awesome", group = "awesome" }
    ),
    awful.key({ modkey, altkey }, "q", awesome.quit,
        { description = "quit awesome", group = "awesome" }
    ),
    awful.key({ modkey, }, "l", function() awful.tag.incmwfact(0.05) end,
        { description = "increase master width factor", group = "layout" }
    ),
    awful.key({ modkey, }, "h", function() awful.tag.incmwfact(-0.05) end,
        { description = "decrease master width factor", group = "layout" }
    ),
    awful.key({ modkey, "Shift" }, "h", function() awful.tag.incnmaster(1, nil, true) end,
        { description = "increase the number of master clients", group = "layout" }
    ),
    awful.key({ modkey, "Shift" }, "l", function() awful.tag.incnmaster(-1, nil, true) end,
        { description = "decrease the number of master clients", group = "layout" }
    ),
    awful.key({ modkey, "Control" }, "h", function() awful.tag.incncol(1, nil, true) end,
        { description = "increase the number of columns", group = "layout" }
    ),
    awful.key({ modkey, "Control" }, "l", function() awful.tag.incncol(-1, nil, true) end,
        { description = "decrease the number of columns", group = "layout" }
    ),
    awful.key({ modkey, }, "v", function() awful.layout.inc(1) end,
        { description = "select next", group = "layout" }),
    awful.key({ modkey, "Shift" }, "v", function() awful.layout.inc(-1) end,
        { description = "select previous", group = "layout" }),
    awful.key({ modkey, "Control" }, "n",
        function()
            local c = awful.client.restore()
            if c then c:emit_signal("request::activate", "key.unminimize", { raise = true }) end
        end,
        { description = "restore minimized", group = "client" }
    ),
    awful.key({ modkey }, "r", function()
            awful.screen.focused().mypromptbox:run()
        end,
        { description = "run prompt", group = "launcher" }
    ),
    awful.key({ modkey }, "x",
        function()
            awful.prompt.run {
                prompt       = "Run Lua code: ",
                textbox      = awful.screen.focused().mypromptbox.widget,
                exe_callback = awful.util.eval,
                history_path = awful.util.get_cache_dir() .. "/history_eval"
            }
        end,
        { description = "lua execute prompt", group = "awesome" }
    ),
    awful.key({ modkey }, "p", function() awful.spawn.with_shell(launcher) end,
        { description = "show the menubar", group = "launcher" }
    ),
    awful.key({}, "XF86AudioRaiseVolume", function() volume_widget:inc() end,
        { description = "volume up", group = "custom" }
    ),
    awful.key({}, "XF86AudioLowerVolume", function() volume_widget:dec() end,
        { description = "volume down", group = "custom" }
    ),
    awful.key({}, "XF86AudioMute", function() volume_widget:toggle() end,
        { description = "volume mute", group = "custom" }
    ),
    awful.key({}, "XF86MonBrightnessUp", function() brightness_widget:inc() end,
        { description = "increase brightness", group = "custom" }
    ),
    awful.key({}, "XF86MonBrightnessDown", function() brightness_widget:dec() end,
        { description = "decrease brightness", group = "custom" }
    ),
    -- Media Keys
    awful.key({}, "XF86AudioPlay",
        function()
            awful.util.spawn("playerctl play-pause", false)
        end,
        { description = "audio play toggle", group = "custom" }
    ),
    awful.key({}, "XF86AudioNext",
        function()
            awful.util.spawn("playerctl next", false)
        end,
        { description = "play audio next", group = "custom" }
    ),
    awful.key({}, "XF86AudioPrev",
        function()
            awful.util.spawn("playerctl previous", false)
        end,
        { description = "play previous audio", group = "custom" }
    )
)

clientkeys = gears.table.join(
    awful.key({ modkey, }, "f",
        function(c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        { description = "toggle fullscreen", group = "client" }
    ),
    awful.key({ modkey, }, "q", function(c) c:kill() end,
        { description = "close", group = "client" }
    ),
    awful.key({ modkey, "Shift" }, "q",
        function(c)
            if c.pid then
                awful.spawn("kill -9 " .. c.pid)
            end
        end
    ),
    awful.key({ modkey, }, "s", awful.client.floating.toggle,
        { description = "toggle floating", group = "client" }
    ),
    awful.key({ modkey, "Control" }, "Return", function(c) c:swap(awful.client.getmaster()) end,
        { description = "move to master", group = "client" }
    ),
    awful.key({ modkey, }, "o", function(c) c:move_to_screen() end,
        { description = "move to screen", group = "client" }
    ),
    awful.key({ modkey, }, "t", function(c) c.ontop = not c.ontop end,
        { description = "toggle keep on top", group = "client" }
    ),
    awful.key({ modkey, }, "n",
        function(c)
            c.minimized = true
        end,
        { description = "minimize", group = "client" }
    ),
    awful.key({ modkey, }, "m",
        function(c)
            c.maximized = not c.maximized
            c:raise()
        end,
        { description = "(un)maximize", group = "client" }
    ),
    awful.key({ modkey, "Control" }, "m",
        function(c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end,
        { description = "(un)maximize vertically", group = "client" }
    ),
    awful.key({ modkey, "Shift" }, "m",
        function(c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end,
        { description = "(un)maximize horizontally", group = "client" }
    )
)

for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    tag:view_only()
                end
            end,
            { description = "view tag #" .. i, group = "tag" }
        ),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    awful.tag.viewtoggle(tag)
                end
            end,
            { description = "toggle tag #" .. i, group = "tag" }
        ),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:move_to_tag(tag)
                    end
                end
            end,
            { description = "move focused client to tag #" .. i, group = "tag" }
        ),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:toggle_tag(tag)
                    end
                end
            end,
            { description = "toggle focused client on tag #" .. i, group = "tag" }
        )
    )
end

clientbuttons = gears.table.join(
    awful.button({}, 1, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
    end),
    awful.button({ modkey }, 1, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
        awful.mouse.client.resize(c)
    end)
)

root.keys(globalkeys)
-----------------------------------------

--[ RULES ]------------------------------
awful.rules.rules = {
    {
        rule = {},
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap + awful.placement.no_offscreen
        }
    },
    {
        rule_any = {
            instance = {
                "DTA",
                "copyq",
                "pinentry",
            },
            class = {
                "Arandr",
                "Blueman-manager",
                "Gpick",
                "Kruler",
                "MessageWin",
                "Sxiv",
                "Tor Browser",
                "Wpa_gui",
                "veromix",
                "xtightvncviewer"
            },
            name = {
                "Event Tester",
            },
            role = {
                "AlarmWindow",
                "ConfigManager",
                "pop-up",
            }
        },
        properties = { floating = true }
    },
    {
        rule_any = {
            type = { "normal", "dialog" }
        },
        properties = {
            titlebars_enabled = false,
            placement = awful.placement.centered + awful.placement.no_overlap + awful.placement.no_offscreen
        }
    },
}
-----------------------------------------

--[ SIGNALS ]----------------------------
client.connect_signal("manage", function(c)
    if awesome.startup
        and not c.size_hints.user_position
        and not c.size_hints.program_position then
        awful.placement.no_offscreen(c)
    end
end)

client.connect_signal("request::titlebars", function(c)
    local buttons = gears.table.join(
        awful.button({}, 1, function()
            c:emit_signal("request::activate", "titlebar", { raise = true })
            awful.mouse.client.move(c)
        end),
        awful.button({}, 3, function()
            c:emit_signal("request::activate", "titlebar", { raise = true })
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c, { position = "right" }):setup {
        {
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.vertical
        },
        {
            {
                {
                    align  = "center",
                    widget = awful.titlebar.widget.titlewidget(c)
                },
                buttons = buttons,
                layout  = wibox.layout.flex.vertical
            },
            widget = wibox.container.rotate,
            direction = "west",
        },
        {
            awful.titlebar.widget.floatingbutton(c),
            awful.titlebar.widget.stickybutton(c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.ontopbutton(c),
            awful.titlebar.widget.closebutton(c),
            layout = wibox.layout.fixed.vertical()
        },
        layout = wibox.layout.align.vertical
    }
end)

client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", { raise = false })
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

mytextclock:connect_signal("button::press",
    function(_, _, _, button)
        if button == 1 then cw.toggle() end
    end
)
-----------------------------------------
