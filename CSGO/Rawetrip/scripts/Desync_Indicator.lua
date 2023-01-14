-- legendware syntax
local print = cheat.notify
local menu = ui

-- lua elements
menu.add_checkbox('Desync Indicator')
menu.add_colorpicker('Color')

-- code
local callbacks = {
    on_paint = {
        screen = { x = engine.get_screen_width(), y = engine.get_screen_height() }, -- get screen size
        desync_indicator = function(self)
            if not menu.get_bool('Desync Indicator') then return end -- checkbox check


            -- colors
            local col = menu.get_color('Color')
            local r, g, b = col:r(), col:g(), col:b()
            local manual_color_left = color.new(0, 0, 0, 80)
            local manual_color_right = color.new(0, 0, 0, 80)
            local def_r_col = color.new(0, 0, 0, 80)
            local def_l_col = color.new(0, 0, 0, 80)

            -- get values from menu
            local type = menu.get_int('0Antiaim.desync')

            -- get state
            local invert = menu.get_keybind_state(keybinds.flip_desync)
            local left_manual = menu.get_keybind_state(keybinds.manual_left)
            local right_manual = menu.get_keybind_state(keybinds.manual_right)

            -- set values
            if left_manual then manual_color_left = color.new(255, 255, 255, 100) end
            if right_manual then manual_color_right = color.new(255, 255, 255, 100) end
            if type == 1 then if invert then def_l_col = color.new(r,g,b) else def_r_col = color.new(r,g,b) end elseif type == 2 then if globalvars.get_tickcount() % 6 < 3 then def_l_col = color.new(r,g,b) else def_r_col = color.new(r,g,b) end end

            -- render
            render.triangle(self.screen.x/2 + 39 + 15, self.screen.y/2, self.screen.x/2 + 39, self.screen.y/2 + 9, self.screen.x/2 + 39, self.screen.y/2 - 9, manual_color_right)
            render.triangle(self.screen.x/2 - 39, self.screen.y/2 + 9, self.screen.x/2 - 39 - 15, self.screen.y/2, self.screen.x/2 - 39, self.screen.y/2 - 9, manual_color_left)

            render.rect_filled(self.screen.x/2 - 37, self.screen.y/2 - 9, 2, 18, def_r_col) -- desync deff right rect
            render.rect_filled(self.screen.x/2 + 35, self.screen.y/2 - 9, 2, 18, def_l_col) -- desync deff left rect
        end,
    },
}
cheat.RegisterCallback("on_paint", function()
    callbacks.on_paint:desync_indicator()
end)
