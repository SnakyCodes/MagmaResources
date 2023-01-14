-- legendware syntax
local print = cheat.notify
local menu = ui

local font = render.setup_font("Calibri", 30, 0, true, false, false)

-- menu.add_checkbox('DT charge indicator')
-- code
local callbacks = {
    on_paint = {
        screen = { x = engine.get_screen_width(), y = engine.get_screen_height() }, -- get screen size
        dt_indicator = function(self)
            -- if not menu.get_bool('DT charge indicator') then return end
            local local_player = entitylist.get_local_player()
            if not local_player then return end

            if globalvars.get_dt_recharging() == false and menu.get_keybind_state(keybinds.double_tap) then charge = true else charge = false end

            if charge then color = color.new(255, 255, 255) else color = color.new(255,10,10) end

            render.gradient(self.screen.x - self.screen.x + 20, self.screen.y - 116, 20, 22, color.new(0,0,0, 200), color.new(0,0,0,0))
            render.gradient(self.screen.x - self.screen.x, self.screen.y - 116, 20, 22, color.new(0,0,0, 0), color.new(0,0,0, 200))
            render.text(font, self.screen.x - self.screen.x + 10, self.screen.y - 120, color, 'DT')

            -- render.circle_filled(100, 600, 60, 10, color)
            -- render.circle_filled(100, 600, 255, 8, color.new(50,50,50))
        end,
    },
}
cheat.RegisterCallback("on_paint", function()
    callbacks.on_paint:dt_indicator()
end)