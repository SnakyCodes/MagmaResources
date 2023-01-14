local shot_data = {}
local switch = 1

function on_paint()
    
    for i = 1, #shot_data do
    
        local shot = shot_data[i]
        
        if shot.draw then

            if shot.alpha <= 0 then
                shot.alpha = 0
                shot.draw = false
            else
                if shot.z >= shot.target then shot.alpha = shot.alpha - 1 end
                
                local s = render.world_to_screen(vector.new(shot.x,shot.y,shot.z))
                
                if shot.dmg <= 15 then
    
                --ebannirot
                   		render.rect_filled(s.x + 2, s.y + 14, 2, 2, color.new(0,0,0,shot.alpha))
    					render.rect_filled(s.x , s.y + 12, 2, 2, color.new(0,0,0,shot.alpha))
    					render.rect_filled(s.x - 2, s.y + 10, 2, 2, color.new(0,0,0,shot.alpha))
       				render.rect_filled(s.x - 4, s.y + 4, 2, 6, color.new(0,0,0,shot.alpha))
   					render.rect_filled(s.x - 2, s.y + 2, 2, 2, color.new(0,0,0,shot.alpha))
   					render.rect_filled(s.x , s.y , 2, 2, color.new(0,0,0,shot.alpha))
    					render.rect_filled(s.x + 2, s.y , 2, 2, color.new(0,0,0, shot.alpha))
    					render.rect_filled(s.x + 4, s.y + 2, 2, 2, color.new(0,0,0, shot.alpha))
    					render.rect_filled(s.x + 6, s.y , 2, 2, color.new(0,0,0, shot.alpha))
    					render.rect_filled(s.x + 8, s.y , 2, 2, color.new(0,0,0, shot.alpha))
    					render.rect_filled(s.x + 10, s.y + 2, 2, 2, color.new(0,0,0, shot.alpha))
    					render.rect_filled(s.x + 12, s.y + 4, 2, 6, color.new(0,0,0, shot.alpha))
    					render.rect_filled(s.x + 10, s.y + 10, 2, 2, color.new(0,0,0, shot.alpha))
    					render.rect_filled(s.x + 8, s.y + 12, 2, 2, color.new(0,0,0, shot.alpha))
    					render.rect_filled(s.x + 6, s.y + 14, 2, 2, color.new(0,0,0, shot.alpha))
    					render.rect_filled(s.x + 4, s.y + 16, 2, 2, color.new(0,0,0, shot.alpha))
    					render.rect_filled(s.x - 2, s.y + 4, 2, 6, color.new( 60, 255, 0, shot.alpha))
    					render.rect_filled(s.x , s.y + 2, 4, 2, color.new( 60, 255, 0, shot.alpha))
    					render.rect_filled(s.x , s.y + 6, 4, 6, color.new( 60, 255, 0, shot.alpha))
    					render.rect_filled(s.x + 2, s.y + 4, 2, 2, color.new(255, 255, 255, shot.alpha))
    					render.rect_filled(s.x + 2, s.y + 12, 2, 2, color.new( 60, 255, 0, shot.alpha))
    					render.rect_filled(s.x + 4, s.y + 4, 2, 12, color.new( 60, 255, 0, shot.alpha))
    					render.rect_filled(s.x + 6, s.y + 2, 4, 10, color.new( 60, 255, 0, shot.alpha))
    					render.rect_filled(s.x + 6, s.y + 12, 2, 2, color.new(60, 255, 0, shot.alpha))
    					render.rect_filled(s.x + 10, s.y + 4, 2, 6, color.new(60, 255, 0, shot.alpha))
    					render.rect_filled(s.x , s.y + 4, 2, 2, color.new( 60, 255, 0, shot.alpha))

                --ebannirot
                elseif shot.dmg <= 30 then
                               --ebannirot
                   		render.rect_filled(s.x + 2, s.y + 14, 2, 2, color.new(0,0,0,shot.alpha))
    					render.rect_filled(s.x , s.y + 12, 2, 2, color.new(0,0,0,shot.alpha))
    					render.rect_filled(s.x - 2, s.y + 10, 2, 2, color.new(0,0,0,shot.alpha))
       				render.rect_filled(s.x - 4, s.y + 4, 2, 6, color.new(0,0,0,shot.alpha))
   					render.rect_filled(s.x - 2, s.y + 2, 2, 2, color.new(0,0,0,shot.alpha))
   					render.rect_filled(s.x , s.y , 2, 2, color.new(0,0,0,shot.alpha))
    					render.rect_filled(s.x + 2, s.y , 2, 2, color.new(0,0,0, shot.alpha))
    					render.rect_filled(s.x + 4, s.y + 2, 2, 2, color.new(0,0,0, shot.alpha))
    					render.rect_filled(s.x + 6, s.y , 2, 2, color.new(0,0,0, shot.alpha))
    					render.rect_filled(s.x + 8, s.y , 2, 2, color.new(0,0,0, shot.alpha))
    					render.rect_filled(s.x + 10, s.y + 2, 2, 2, color.new(0,0,0, shot.alpha))
    					render.rect_filled(s.x + 12, s.y + 4, 2, 6, color.new(0,0,0, shot.alpha))
    					render.rect_filled(s.x + 10, s.y + 10, 2, 2, color.new(0,0,0, shot.alpha))
    					render.rect_filled(s.x + 8, s.y + 12, 2, 2, color.new(0,0,0, shot.alpha))
    					render.rect_filled(s.x + 6, s.y + 14, 2, 2, color.new(0,0,0, shot.alpha))
    					render.rect_filled(s.x + 4, s.y + 16, 2, 2, color.new(0,0,0, shot.alpha))
    					render.rect_filled(s.x - 2, s.y + 4, 2, 6, color.new(255, 251, 0, shot.alpha))
    					render.rect_filled(s.x , s.y + 2, 4, 2, color.new(255, 251, 0, shot.alpha))
    					render.rect_filled(s.x , s.y + 6, 4, 6, color.new(255, 251, 0, shot.alpha))
    					render.rect_filled(s.x + 2, s.y + 4, 2, 2, color.new(255, 255, 255, shot.alpha))
    					render.rect_filled(s.x + 2, s.y + 12, 2, 2, color.new(255, 251, 0, shot.alpha))
    					render.rect_filled(s.x + 4, s.y + 4, 2, 12, color.new(255, 251, 0, shot.alpha))
    					render.rect_filled(s.x + 6, s.y + 2, 4, 10, color.new(255, 251, 0, shot.alpha))
    					render.rect_filled(s.x + 6, s.y + 12, 2, 2, color.new(255, 251, 0, shot.alpha))
    					render.rect_filled(s.x + 10, s.y + 4, 2, 6, color.new(255, 251, 0, shot.alpha))
    					render.rect_filled(s.x , s.y + 4, 2, 2, color.new(255, 251, 0, shot.alpha))
    			elseif shot.dmg <= 60 then
                   		render.rect_filled(s.x + 2, s.y + 14, 2, 2, color.new(0,0,0,shot.alpha))
    					render.rect_filled(s.x , s.y + 12, 2, 2, color.new(0,0,0,shot.alpha))
    					render.rect_filled(s.x - 2, s.y + 10, 2, 2, color.new(0,0,0,shot.alpha))
       				render.rect_filled(s.x - 4, s.y + 4, 2, 6, color.new(0,0,0,shot.alpha))
   					render.rect_filled(s.x - 2, s.y + 2, 2, 2, color.new(0,0,0,shot.alpha))
   					render.rect_filled(s.x , s.y , 2, 2, color.new(0,0,0,shot.alpha))
    					render.rect_filled(s.x + 2, s.y , 2, 2, color.new(0,0,0, shot.alpha))
    					render.rect_filled(s.x + 4, s.y + 2, 2, 2, color.new(0,0,0, shot.alpha))
    					render.rect_filled(s.x + 6, s.y , 2, 2, color.new(0,0,0, shot.alpha))
    					render.rect_filled(s.x + 8, s.y , 2, 2, color.new(0,0,0, shot.alpha))
    					render.rect_filled(s.x + 10, s.y + 2, 2, 2, color.new(0,0,0, shot.alpha))
    					render.rect_filled(s.x + 12, s.y + 4, 2, 6, color.new(0,0,0, shot.alpha))
    					render.rect_filled(s.x + 10, s.y + 10, 2, 2, color.new(0,0,0, shot.alpha))
    					render.rect_filled(s.x + 8, s.y + 12, 2, 2, color.new(0,0,0, shot.alpha))
    					render.rect_filled(s.x + 6, s.y + 14, 2, 2, color.new(0,0,0, shot.alpha))
    					render.rect_filled(s.x + 4, s.y + 16, 2, 2, color.new(0,0,0, shot.alpha))
    					render.rect_filled(s.x - 2, s.y + 4, 2, 6, color.new(255, 140, 0, shot.alpha))
    					render.rect_filled(s.x , s.y + 2, 4, 2, color.new(255, 140, 0, shot.alpha))
    					render.rect_filled(s.x , s.y + 6, 4, 6, color.new(255, 140, 0, shot.alpha))
    					render.rect_filled(s.x + 2, s.y + 4, 2, 2, color.new(255, 255, 255, shot.alpha))
    					render.rect_filled(s.x + 2, s.y + 12, 2, 2, color.new(255, 140, 0, shot.alpha))
    					render.rect_filled(s.x + 4, s.y + 4, 2, 12, color.new(255, 140, 0, shot.alpha))
    					render.rect_filled(s.x + 6, s.y + 2, 4, 10, color.new(255, 140, 0, shot.alpha))
    					render.rect_filled(s.x + 6, s.y + 12, 2, 2, color.new(255, 140, 0, shot.alpha))
    					render.rect_filled(s.x + 10, s.y + 4, 2, 6, color.new(255, 140, 0, shot.alpha))
    					render.rect_filled(s.x , s.y + 4, 2, 2, color.new(255, 140, 0, shot.alpha))
                else
                   		render.rect_filled(s.x + 2, s.y + 14, 2, 2, color.new(0,0,0,shot.alpha))
    					render.rect_filled(s.x , s.y + 12, 2, 2, color.new(0,0,0,shot.alpha))
    					render.rect_filled(s.x - 2, s.y + 10, 2, 2, color.new(0,0,0,shot.alpha))
       				render.rect_filled(s.x - 4, s.y + 4, 2, 6, color.new(0,0,0,shot.alpha))
   					render.rect_filled(s.x - 2, s.y + 2, 2, 2, color.new(0,0,0,shot.alpha))
   					render.rect_filled(s.x , s.y , 2, 2, color.new(0,0,0,shot.alpha))
    					render.rect_filled(s.x + 2, s.y , 2, 2, color.new(0,0,0, shot.alpha))
    					render.rect_filled(s.x + 4, s.y + 2, 2, 2, color.new(0,0,0, shot.alpha))
    					render.rect_filled(s.x + 6, s.y , 2, 2, color.new(0,0,0, shot.alpha))
    					render.rect_filled(s.x + 8, s.y , 2, 2, color.new(0,0,0, shot.alpha))
    					render.rect_filled(s.x + 10, s.y + 2, 2, 2, color.new(0,0,0, shot.alpha))
    					render.rect_filled(s.x + 12, s.y + 4, 2, 6, color.new(0,0,0, shot.alpha))
    					render.rect_filled(s.x + 10, s.y + 10, 2, 2, color.new(0,0,0, shot.alpha))
    					render.rect_filled(s.x + 8, s.y + 12, 2, 2, color.new(0,0,0, shot.alpha))
    					render.rect_filled(s.x + 6, s.y + 14, 2, 2, color.new(0,0,0, shot.alpha))
    					render.rect_filled(s.x + 4, s.y + 16, 2, 2, color.new(0,0,0, shot.alpha))
    					render.rect_filled(s.x - 2, s.y + 4, 2, 6, color.new(254, 19, 19, shot.alpha))
    					render.rect_filled(s.x , s.y + 2, 4, 2, color.new(254, 19, 19, shot.alpha))
    					render.rect_filled(s.x , s.y + 6, 4, 6, color.new(254, 19, 19, shot.alpha))
    					render.rect_filled(s.x + 2, s.y + 4, 2, 2, color.new(255, 255, 255, shot.alpha))
    					render.rect_filled(s.x + 2, s.y + 12, 2, 2, color.new(254, 19, 19, shot.alpha))
    					render.rect_filled(s.x + 4, s.y + 4, 2, 12, color.new(254, 19, 19, shot.alpha))
    					render.rect_filled(s.x + 6, s.y + 2, 4, 10, color.new(254, 19, 19, shot.alpha))
    					render.rect_filled(s.x + 6, s.y + 12, 2, 2, color.new(254, 19, 19, shot.alpha))
    					render.rect_filled(s.x + 10, s.y + 4, 2, 6, color.new(254, 19, 19, shot.alpha))
    					render.rect_filled(s.x , s.y + 4, 2, 2, color.new(254, 19, 19, shot.alpha))
                end
                shot.z = shot.z + 0.5
                
            end
        end
    end
end

function player_hurt(e)

    local attacker = e:get_int("attacker")
    local attacker_idx = engine.get_player_for_user_id(attacker)
    
    local victim = e:get_int("userid")
    local victim_idx = engine.get_player_for_user_id(victim)
    
    if attacker_idx ~= engine.get_local_player_index() then
        return
    end
    
    local pos = entitylist.get_player_by_index(victim_idx):get_absorigin()
    local duck = entitylist.get_player_by_index(victim_idx):get_prop_float("CBasePlayer", "m_flDuckAmount")
    
    pos.z = pos.z + (46 + (1 - duck) * 18)
    
    switch = switch*-1
    
    shot_data[#shot_data+1] = { x = pos.x, y = pos.y+switch*35, z = pos.z, target = pos.z + 25, dmg = e:get_int("dmg_health"), alpha = 255, draw = true,}
end

function round_start()
    shot_data = {}
end
events.register_event("player_hurt", player_hurt)
events.register_event("round_prestart", round_start)
cheat.RegisterCallback("on_paint", on_paint)






