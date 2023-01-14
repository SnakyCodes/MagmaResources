--- #region: Resolver fix
ResMode = {"PREVIOUS_GFY", "ZERO", "FIRST", "SECOND", "LOW_FIRST", "LOW_SECOND"}

local function shot(info)

    if info.result ~= "Hit" then

        local target = resolver_optional.get_last_target()
        local resolve_type = math.random(1,5)
        local players = entitylist.get_players()

        resolver_optional.override_solve(target, resolve_type)
        cheat.notify("Target: " .. players[target]:get_name() .. " | Type: " .. ResMode[resolver_optional.get_solve(target)+1]  .. " -> " .. ResMode[resolve_type+1])

    end
end

cheat.push_callback("on_shot", function(shot_info)
    cheat.notify(shot_info.target_name)
end)
--- #endregion