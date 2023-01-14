-- legendware syntax
local print = cheat.notify
local menu = ui
local client = cheat

menu.add_sliderint('JumpScout Hitchance', 10, 100)

local callbacks = {
    create_move = {
        cache = {
            override = false,
        },
        jump_scout = function(self)
            local local_player = entitylist.get_local_player()
            if not local_player then return end

            local check_air = local_player:get_prop_bool('CBasePlayer', 'm_hGroundEntity') -- deff false

            if check_air then
                if not self.cache.override then
                    self.cache.value = {
                        default_hitchance = menu.get_int('5Ragebot.hitchance_amount')
                    }
                    menu.set_int('5Ragebot.hitchance_amount', menu.get_int('JumpScout Hitchance'))
                    self.cache.override = true
                end
            else
                if self.cache.override then
                    menu.set_int('5Ragebot.hitchance_amount', self.cache.value.default_hitchance)
                    self.cache.override = false
                end
            end
        end,
    },
}

client.RegisterCallback("on_createmove", function()
    callbacks.create_move:jump_scout()
end)