local function drawpeek(vec, col)
    for i = 1, 1 do
        render.circle_3d(vec, 0 + i*18, color(col:r(), col:g(), col:b(), math.floor(col:a() / math.max(1, i))))
        render.circle_filled_3d(vec, 0 + i*18, color(col:r(), col:g(), col:b(), math.floor(col:a() / math.max(6, i))))
    end
end

local m_pCache = {
    startPosition = vector(0, 0, 0)
}

local peekcolor = ui.add_colorpicker("color")

cheat.push_callback("on_paint", function()
local m_pPeek = ui.get_keybind_state(keybinds.automatic_peek)
local m_pLocal = entity.get_local()
    if not m_pLocal then
        return 
    end

    if not m_pLocal:is_alive() then
        return
    end
    local Origin = vector(m_pLocal:get_absorigin().x, m_pLocal:get_absorigin().y, m_pLocal:get_absorigin().z)
    local Color = peekcolor:get()
    
    ui.find_menu_color("Misc.autopeek_color"):set(color(0, 0, 0, 0))

    if not m_pPeek then 
        m_pCache.startPosition = vector(0, 0, 0)
        return 1
    end
    if m_pCache.startPosition:is_zero() then
       m_pCache.startPosition = Origin

       if bit.band(m_pLocal:get_prop_int("CBasePlayer", "m_fFlags"), 1) ~= 1 then
        local trfloor = trace.ray(m_pCache.startPosition, vector(m_pCache.startPosition.x,m_pCache.startPosition.y,m_pCache.startPosition.z - 1000), entity.get_local(), 0xFFFFFFFF)
        
        if trfloor.fraction < 1.0 then
            local endpos = trfloor.endpos
            m_pCache.startPosition = vector(endpos.x, endpos.y, endpos.z + 2)
        end
       end
    else
        drawpeek(m_pCache.startPosition, color(Color:r(),Color:g(),Color:b(), 255))
    end
end)





