-- Vicious widget library
vicious = require("vicious")
-- Application menu
require("freedesktop.utils")
require("freedesktop.menu")
-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
-- Scratchpad
local scratch = require("scratch")
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
                         text = err })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
beautiful.init("/usr/share/awesome/themes/siidney/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "urxvt"
editor = os.getenv("EDITOR") or "gedit"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts =
{
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    --awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    --awful.layout.suit.tile.top,
    --awful.layout.suit.fair,
   -- awful.layout.suit.fair.horizontal,
   --awful.layout.suit.spiral,
    --awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    --awful.layout.suit.max.fullscreen,
    --awful.layout.suit.magnifier
}
-- }}}

-- {{{ Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {
	names =  {" Main ", " WWW ", " Email ", " Work ", " Office ", " Torrent ", " Files ", " Multimedia "},
	layout = {layouts[2], layouts[1], layouts[2], layouts[2], layouts[2], layouts[2], layouts[2], layouts[2]}
}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag(tags.names, s, tags.layout)
end
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
menu_items = freedesktop.menu.new()

myawesomemenu = {
	{ "&Manual", terminal .. " -e man awesome" },
	{ "&Edit Config", "gedit /home/siid/.config/awesome/rc.lua"},
	{ "&Restart", awesome.restart },
	{ "&Quit", awesome.quit }
}

-- Freedesktop menu
table.insert(menu_items, { "awesome", myawesomemenu, beautiful.awesome_icon })

mymainmenu = awful.menu.new({ items = menu_items })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })
-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Wibox
-- Seperator-widget
seperator = wibox.widget.textbox()
seperator:set_markup(" <b>|</b> ")
-- Spacer-widget
spacer = wibox.widget.textbox()
spacer:set_markup(" ")
-- Vol_widget

-- CPU-widget
cpu_widget = wibox.widget.textbox()
vicious.register(cpu_widget, vicious.widgets.cpu,
	function (cpu_widget, args)
		if args[1] < 25 then
			return ' <b>CPU</b> <span color="#7F9F7F">' .. args[1] .. '%</span> '
		elseif args[1] < 50 then
			return ' <b>CPU</b> <span color="#FCFD97">' .. args[1] .. '%</span> '
		elseif args[1] < 75 then
			return ' <b>CPU</b> <span color="#e99559">' .. args[1] .. '%</span> '
		else
			return ' <b>CPU</b> <span color="#CC9393">' .. args[1] .. '%</span> '
		end
	end)
-- Memory-widget
mem_widget = wibox.widget.textbox()
vicious.register(mem_widget, vicious.widgets.mem,
	function (mem_widget, args)
		if args[1] < 25 then
			return ' <b>MEM</b> <span color="#7F9F7F">' .. args[1] .. '%</span>(' .. args[2] .. 'MB/' .. args[3] .. 'MB) '
		elseif args[1] < 50 then
			return ' <b>MEM</b> <span color="#FCFD97">' .. args[1] .. '%</span>(' .. args[2] .. 'MB/' .. args[3] .. 'MB) '
		elseif args[1] < 75 then
			return ' <b>MEM</b> <span color="#e99559">' .. args[1] .. '%</span>(' .. args[2] .. 'MB/' .. args[3] .. 'MB) '
		else
			return ' <b>MEM</b> <span color="#CC9393">' .. args[1] .. '%</span>(' .. args[2] .. 'MB/' .. args[3] .. 'MB) '
		end
	end, 13)
-- Hard-disk-widget
disc_widget = wibox.widget.textbox()
vicious.register(disc_widget, vicious.widgets.fs, ' <b>HOME</b> <span color="#CC9393">${/home avail_p}% (${/home avail_gb}GB</span>/${/home size_gb}GB) ' )
-- Network usage widget
net_widget = wibox.widget.textbox()
vicious.register(net_widget, vicious.widgets.net, ' <b><span color="#CC9393">&#118; ${enp3s0 down_kb} </span><span color="#7F9F7F">&#94; ${enp3s0 up_kb}</span></b> ', 3)
-- Create a textclock widget
mytextclock = awful.widget.textclock()
-- Mpd Widget
mpd_widget = wibox.widget.textbox()
-- Open ncmpcpp on left click
mpd_widget:buttons(awful.util.table.join(
   					awful.button({ }, 1, function () scratch.drop(terminal .. " -e ncmpc" , "bottom" , "right" , 1000 , 1000) end)
				  ))

vicious.register(mpd_widget, vicious.widgets.mpd,
    function (mpd_widget, args)
        if args["{state}"] == "Play" then
			return '<span color="#7F9F7F" font="15">▶</span>  ' .. args["{Artist}"] ..' - '.. args["{Title}"] .. ' <span color="#7F9F7F" font="15">♫</span>'
		elseif args["{state}"] == "Pause" then
			return '<span color="#FCFD97" font="15">‖</span>  ' .. args["{Artist}"] ..' - '.. args["{Title}"] .. ' <span color="#FCFD97" font="15">♫</span>'
		elseif args["{state}"] == "Stop" then
			return '<span color="#CC9393" font="15">■</span>  ' .. args["{Artist}"] ..' - '.. args["{Title}"] .. ' <span color="#CC9393" font="15">♫</span>'
        else
            return " No Media "
        end
    end, 10)
-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
					 awful.button({ }, 2, function (c)
                                              	 c:kill()
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s, height = 30 })

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mylauncher)
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    if s == 1 then right_layout:add(wibox.widget.systray()) end
    right_layout:add(spacer)
	right_layout:add(mpd_widget)
	right_layout:add(seperator)
	right_layout:add(net_widget)
	right_layout:add(seperator)
	right_layout:add(disc_widget)
	right_layout:add(seperator)
	right_layout:add(mem_widget)
	right_layout:add(seperator)
	right_layout:add(cpu_widget)
	right_layout:add(seperator)
    right_layout:add(mytextclock)
	right_layout:add(seperator)
    right_layout:add(mylayoutbox[s])

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
	-- Print Screen
	awful.key({ modkey,			  }, "Print" , function () awful.util.spawn("scrot -e 'mv $f ~/screenshots/ 2>/dev/null'") end),
	-- Calculator
	awful.key({ modkey,			  }, "c" , function () scratch.drop("qalculate" , "right" , "center" , 250 , 300) end),
	-- Vim
	awful.key({ modkey,			  }, "v" , function () awful.util.spawn("urxvt -e vim") end),
	-- Ncmpc
	awful.key({ modkey, "Control" }, "c" , function () scratch.drop(terminal .. " -e ncmpc" , "bottom" , "right" , 1000 , 1000) end),

	awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1 )
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
	-- Scratchpad terminal
	awful.key({ modkey,           }, "Return", function () scratch.drop(terminal, "bottom", "right", 700, 500) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),

    -- Prompt
    awful.key({ modkey 			  }, "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end),
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end),

	-- Multimedia Keys
	awful.key({ }, "XF86AudioRaiseVolume", function () awful.util.spawn("amixer -c 0 set Master 1dB+", false) end),
	awful.key({ }, "XF86AudioLowerVolume", function () awful.util.spawn("amixer -c 0 set Master 1dB-", false) end),
	awful.key({ }, "XF86AudioMute", function () awful.util.spawn("amixer set Master toggle", false) end),
	-- mpc Keybinding
	awful.key({ }, "XF86AudioNext",function () awful.util.spawn( "mpc next" ) end),
	awful.key({ }, "XF86AudioPrev",function () awful.util.spawn( "mpc prev" ) end),
	awful.key({ }, "XF86AudioPlay",function () awful.util.spawn( "mpc toggle" ) end),
	awful.key({ }, "XF86AudioStop",function () awful.util.spawn( "mpc stop" ) end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        local tag = awful.tag.gettags(screen)[i]
                        if tag then
                           awful.tag.viewonly(tag)
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      local tag = awful.tag.gettags(screen)[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.movetotag(tag)
                          end
                     end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.toggletag(tag)
                          end
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "Gimp" },
      properties = { floating = true, tag = tags[1][8] }},
    { rule = { instance = "plugin-container" },
      properties = { floating = true, focus = yes }},
    { rule = { instance = "gpicview" },
      properties = { floating = true, focus = yes }},
    -- Set program mapping
	{ rule = { class = "Gedit" },
	  properties = { tag = tags[1][1] } },
	{ rule = { class = "Firefox" },
      properties = { tag = tags[1][2] } },
	{ rule = { class = "Chromium" },
	  properties = { tag = tags[1][2] } },
	{ rule = { class = "Thunderbird" },
	  properties = { tag = tags[1][3] } },
	{ rule = { class = "Qbittorrent" },
	  properties = { tag = tags[1][6] } },
 	{ rule = { class = "Spacefm" },
	  properties = { tag = tags[1][7] } },
	{ rule = { class = "Vlc" },
	  properties = { tag = tags[1][8] } },
	{ rule = { class = "Steam" },
	  properties = { tag = tags[1][8] } }
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end

    local titlebars_enabled = false
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- buttons for the titlebar
        local buttons = awful.util.table.join(
                awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end),
                awful.button({ }, 3, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end)
                )

        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))
        left_layout:buttons(buttons)

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local middle_layout = wibox.layout.flex.horizontal()
        local title = awful.titlebar.widget.titlewidget(c)
        title:set_align("center")
        middle_layout:add(title)
        middle_layout:buttons(buttons)

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(middle_layout)

        awful.titlebar(c):set_widget(layout)
    end
end)


client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- Autostart Apps

function run_once(cmd)
  findme = cmd
  firstspace = cmd:find(" ")
  if firstspace then
    findme = cmd:sub(0, firstspace-1)
  end
  awful.util.spawn_with_shell("pgrep -u $USER -x " .. findme .. " > /dev/null || (" .. cmd .. ")")
end

-- run_once("gedit")
run_once("firefox")
run_once("thunderbird")
-- run_once("qbittorrent")
-- run_once("spacefm")
run_once("dropboxd")
run_once("conky")
run_once("mpd")
-- }}}