cheat.push_callback("on_event", function(event)
    if (event:get_name() == "bullet_impact") then
        local attacker = event:get_int("userid")
        local attacker_idx = engine.get_player_for_user_id(attacker)
        local lp_idx = engine.get_local_player_index()


        local x, y, z = event:get_float("x"), event:get_float("y"), event:get_float("z")


        if attacker_idx == lp_idx then
            interfaces.ieffects.sparks(vector(x, y, z), 5, 5, vector(0, 0, 0))
        end
    end
end)