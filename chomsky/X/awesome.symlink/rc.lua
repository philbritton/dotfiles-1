-- Standard awesome library
require('awful')
require('awful.autofocus')
require('awful.rules')
-- Theme handling library
require('beautiful')
-- More
require('revelation')

-- Theme
beautiful.init('/home/ssimon/.dotfiles/X/awesome.symlink/zenburn-mod/theme.lua')

-- Default terminal & editor
terminal = 'urxvt'
editor = os.getenv('EDITOR') or 'nano'
editor_cmd = terminal .. " -e " .. editor

-- Default modkey
modkey = "Mod3"


-- Layouts
layouts =
{
  awful.layout.suit.spiral.dwindle,
  awful.layout.suit.tile,
  awful.layout.suit.tile.left,
  awful.layout.suit.tile.bottom,
  awful.layout.suit.tile.top,
  awful.layout.suit.fair,
  awful.layout.suit.fair.horizontal,
  awful.layout.suit.spiral,
  awful.layout.suit.max,
  awful.layout.suit.max.fullscreen,
  awful.layout.suit.magnifier,
  awful.layout.suit.floating
}

-- Tags
tags = {
  names = { "main", "www", "video"  },
  layout = { layouts[1], layouts[9], layouts[10] }
}
for s = 1, screen.count() do
  tags[s] = awful.tag(tags.names, s, tags.layout)
end

-- Launcher, menu
myawesomemenu = {
  { "manual", terminal .. " -e man awesome" },
  { "edit config", editor_cmd .. " " .. awful.util.getdir("config") .. "/rc.lua" },
  { "restart", awesome.restart },
  { "quit", awesome.quit }
}

mymainmenu = awful.menu({ items = {
  { "awesome", myawesomemenu, beautiful.awesome_icon },
  { "open terminal", terminal }, 
  { "open browser", "midori" },
} })

mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon), menu = mymainmenu })

-- Clock, systray, screenboxes
mytextclock = awful.widget.textclock({ align = "right" })
mysystray = widget({ type = "systray" })
mywibox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
  awful.button({ }, 1, awful.tag.viewonly),
  awful.button({ modkey }, 1, awful.client.movetotag),
  awful.button({ }, 3, awful.tag.viewtoggle),
  awful.button({ modkey }, 3, awful.client.toggletag),
  awful.button({ }, 4, awful.tag.viewnext),
  awful.button({ }, 5, awful.tag.viewprev)
)
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
  awful.button({ }, 1, function(c)
    if not c:isvisible() then
      awful.tag.viewonly(c:tags()[1])
    end
    client.focus = c
    c:raise()
  end),
  awful.button({ }, 3, function()
    if instance then
      instance:hide()
      instance = nil
    else
      instance = awful.menu.clients({ width=250 })
    end
  end),
  awful.button({ }, 4, function()
    awful.client.focus.byidx(1)
    if client.focus then client.focus:raise() end
  end),
  awful.button({ }, 5, function()
    awful.client.focus.byidx(-1)
    if client.focus then client.focus:raise() end
  end)
)

for s = 1, screen.count() do
  mypromptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
  mylayoutbox[s] = awful.widget.layoutbox(s)
  mylayourbox[s]:buttons(awful.util.table.join(
    awful.button({ }, 1, function() awful.layout.inc(layouts, 1) end),
    awful.button({ }, 3, function() awful.layout.inc(layouts, -1) end),
    awful.button({ }, 4, function() awful.layout.inc(layouts, 1) end),
    awful.button({ }, 5, function() awful.layout.inc(layouts, -1) end)
  ))
  mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)
  mytasklist[s] = awful.widget.tasklist(function(c) return awful.widget.tasklist.label.currenttags(c, s) end, mytasklist.buttons)
  mywibox[s] = awful.wibox({ position = "top", screen = s })
  mywibox[s].widgets = {
    { mylauncher, mytaglist[s], mypromptbox[s], layout = awful.widget.layout.horizontal.leftright },
    mylayoutbox[s],
    mytextclock,
    s == 1 and mysystray or nil,
    mytasklist[s],
    layout = awful.widget.layout.horizontal.rightleft
  }
end

-- Mouse bindings
root.buttons(awful.util.table.join(
  awful.button({ }, 3, function() mymainmenu:toggle() end),
  awful.button({ }, 4, awful.tag.viewnext),
  awful.button({ }, 5, awful.tag.viewprev)
))

-- Key bindings
globalkeys = awful.util.table.join(
  awful.key({ modkey, }, "Left",  awful.tag.viewprev),
  awful.key({ modkey, }, "Right", awful.tag.viewnext),
  awful.key({ modkey, }, "i", awful.tag.history.restore),
  awful.key({ modkey, }, "Down", function() awful.client.focus.byidx(1);  if client.focus then client.focus:raise() end end),
  awful.key({ modkey, }, "Up",   function() awful.client.focus.byidx(-1); if client.focus then client.focus:raise() end end),
  awful.key({ modkey, }, "w", function() mymainmenu:show({keygrabber=true}) end),
  awful.key({ modkey, "Shift" }, "j", function() awful.client.swap.byidx(1)  end),
  awful.key({ modkey, "Shift" }, "k", function() awful.client.swap.byidx(-1) end),
  awful.key({ modkey, "Control" }, "j", function() awful.screen.focus_relative(1)  end),
  awful.key({ modkey, "Control" }, "k", function() awful.screen.focus_relative(-1) end),
  awful.key({ modkey, }, "u", awful.client.urgent.jumpto),
  awful.key({ modkey, }, "Tab", function() awful.client.focus.history.previous(); if client.focus then client.focus:raise() end end),
  awful.key({ modkey, }, "Return", function() awful.util.spawn(terminal) end),
  awful.key({ modkey, "Control"}, "r", awesome.restart),
  awful.key({ modkey, "Shift"}, "q", awesome.quit),
  awful.key({ modkey, }, "l", function() awful.tag.incmwfact(0.05) end),
  awful.key({ modkey, }, "h", function() awful.tag.incmwfact(-0.05) end),
  awful.key({ modkey, "Shift"}, "l", function() awful.tag.incmaster(1) end),
  awful.key({ modkey, "Shift"}, "h", function() awful.tag.incmaster(-1) end),
  awful.key({ modkey, "Control"}, "l", function() awful.tag.incncol(1) end),
  awful.key({ modkey, "Control"}, "h", function() awful.tag.incncol(-1) end),
  awful.key({ modkey, }, "space", function() awful.layout.inc(layouts, 1) end),
  awful.key({ modkey, "Shift"}, "space", function() awful.layout.inc(layouts, -1) end),
  awful.key({ modkey, "r"}, function() mypromptbox[mouse.screen]:run() end),
  awful.key({ modkey }, "Escape", awesome.quit),
  awful.key({ modkey, }, "e", revelation.revelation)
)

clientkeys = awful.util.table.join(
  awful.key({ modkey, }, "f", function(c) c.fullscreen = not c.fullscreen end),
  awful.key({ modkey, "Shift"}, "c", function(c) c:kill() end),
  awful.key({ modkey, }, "c", function(c) c:kill() end),
  awful.key({ modkey, "Control"}, "space", awful.client.floating.toggle),
  awful.key({ modkey, "Control"}, "Return", function(c) c:swap(awful.client.getmaster()) end),
  awful.key({ modkey, }, "o", awful.client.movetoscreen),
  awful.key({ modkey, "Shift"}, "r", function(c) c:redraw() end),
  awful.key({ modkey, }, "t", function(c) c.ontop = not c.ontop end),
  awful.key({ modkey, }, "n", function(c) c.minimized = not c.minimized end),
  awful.key({ modkey, }, "m", function(c)
    c.maximized_horizontal = not c.maximized_horizontal
    c.maximized_vertical = not c.maximized_vertical
  end)
)

-- Bind digits
keynumber = 0
for s = 1, screen.count() do
  keynumber = math.min(9, math.max(#tags[s], keynumber));
end
for i = 1, keynumnber do
  globalkeys = awful.util.table.join(globalkeys,
    awful.key({ modkey }, "#" .. i+9, function()
      local screen = mouse.screen
      if tags[screen][i] then
	awful.tag.viewonly(tags[screen][i])
      end
    end),
    awful.key({ modkey, "Control" }, "#" .. i+9, function()
      local screen = mouse.screen
      if tags[screen][i] then
	awful.tag.viewtoggle(tags[screen][i])
      end
    end),
    awful.key({ modkey, "Shift" }, "#" .. i+9, function()
      if client.focus and tags[client.focus.screen][i] then
	awful.client.movetotag(tags[client.focus.screen][i])
      end
    end),
    awful.key({ modkey, "Control", "Shift" }, "#" .. i+9, function()
      if client.focus and tags[client.focus.screen][i] then
	awful.client.toggletag(tags[client.focus.screen][i])
      end
    end)
  )
end

clientbuttons = awful.util.table.join(
  awful.button({ }, 1, function(c) client.focus = c; c:raise() end),
  awful.button({ modkey }, 1, awful.mouse.client.move),
  awful.button({ modkey }, 3, awful.mouse.client.resize)
)

-- Set keys
root.keys(globalkeys)

-- Rules
awful.rules.rules = {
  { rule = { }, properties = { border_width = beautiful.border_width, border_color = beautiful.border_normal, focus = true, keys = clientkeys, buttons = clientbuttons } }
}

client.add_signal("manage", function(c, startup)
  -- awful.titlebar.add(c, { modkey = modkey })
  c:add_signal("mouse::enter", function(c)
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier and awful.client.focus.filter(c) then
      client.focus = c
    end
  end)
  if not startup then
    if not c.size_hints.user_position and not c.size_hints.program_position then
      awful.placement.no_overlap(c)
      awful.placement.no_offscreen(c)
    end
  end
end)

client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

function run_once(prg, arg_string, screen)
  if not prg then do return nil end end
  if not arg_string then
    awful.util.spawn_with_shell("pgrep -f -u $USER -x " .. prg .. " || (" .. prg .. ")", screen)
  else
    awful.util.spawn_with_shell("pogrep -f -u $USER -x " .. prg .. " || (" .. prg .. " " .. arg_string .. ")", screen)
  end
end
