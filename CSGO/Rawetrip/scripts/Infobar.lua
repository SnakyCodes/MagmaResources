local screen = {
  x = engine.get_screen_width(),
  y = engine.get_screen_height(),
}

local font = {
  SmallFonts = render.setup_font('Small Fonts', 10.0, 0.0, true, false, true),
}

local info = {
  fps = 1 /globalvars.get_frametime(),
}

render.text_centered = function(font, x, y, color, text)
  render.text(font, x - render.get_text_width(font, text) /2, y, color, text)
end

render.multitext = function(font, x, y, _table)
  for _, key in pairs(_table) do
    render.text(font, x, y, key.color, key.text)
    x = x + render.get_text_width(font, key.text)
  end
end

render.multitext_centered = function(font, x, y, _table)
  for _, key in pairs(_table) do
    x = x - render.get_text_width(font, key.text) /2
  end

  render.multitext(font, x, y, _table)
end

cheat.RegisterCallback('on_paint', function()
  if not engine.is_in_game() or not engine.is_connected() then return end

  local player = entitylist.get_local_player()
  if not player then return end

  local speed = 0
  local velocity = player:get_velocity()
  if velocity then
    speed = velocity:length_2d()
  end

  local pos = {
    x = screen.x /2,
    y = screen.y,
    w = 750.0,
    h = 20.0,
  }

  pos.y = pos.y - pos.h

  if math.floor(globalvars.get_realtime() * 100 % 100) == 0 then
    info.fps = 1 /globalvars.get_frametime()
  end

  render.triplegradient(pos.x - pos.w /2, pos.y, pos.w, pos.h, color.new(0.0, 0.0, 0.0, 0.0), color.new(0.0, 0.0, 0.0, 200.0), color.new(0.0, 0.0, 0.0, 0.0))
  render.multitext_centered(font.SmallFonts, pos.x, pos.y + pos.h /2 - 4.0, {
    {color = color.new(255.0, 255.0, 0.0, 255.0), text = string.format('%.f', info.fps)},
    {color = color.new(255.0, 255.0, 255.0, 255.0), text = ' FPS'},
  })

  local gap = pos.w * 0.15

  render.multitext_centered(font.SmallFonts, pos.x - gap, pos.y + pos.h /2 - 4.0, {
    {color = color.new(255.0, 255.0, 0.0, 255.0), text = globalvars.get_ping()},
    {color = color.new(255.0, 255.0, 255.0, 255.0), text = ' PING'},
  })

  render.multitext_centered(font.SmallFonts, pos.x + gap, pos.y + pos.h /2 - 4.0, {
    {color = color.new(255.0, 255.0, 0.0, 255.0), text = string.format('%.f', speed)},
    {color = color.new(255.0, 255.0, 255.0, 255.0), text = ' SPEED'},
  })
end)