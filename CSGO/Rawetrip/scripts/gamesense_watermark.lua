--[[
    -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

       + KoolAidBoy32#0001 сделал код ватермарки
       + HorribleBooba#6800 сделал больше функциональности:)

    -=-=-=-=-=-=-

       + KoolAidBoy32#0001 made watermark code
       + HorribleBooba#6800 made more functionality:)

    -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
--]]

cheat.notify("[!] Thanks for using - 'gamesense_watermark.lua'")
cheat.notify("[!] Creators - KoolAidBoy32#0001 & HorribleBooba#6800")
cheat.notify(" ")
cheat.notify("[!] Спасибо за использование - 'gamesense_watermark.lua'")
cheat.notify("[!] Создатели - KoolAidBoy32#0001 & HorribleBooba#6800'")
local x_posgs = ui.add_sliderint("X Position", 0, engine.get_screen_size().x)
local y_posgs = ui.add_sliderint("Y Position", 0, engine.get_screen_size().y)
local font = render.setup_font("Verdana", 15)
cheat.push_callback("on_paint", function()
    local ping = globalvars.get_ping()
    local time = os.date("%H:%M:%S")
    local GSPosition = { x_posgs:get(), y_posgs:get() }
    render.rect_filled(GSPosition[1] - 10, GSPosition[2] - 5, 217, 30, color(20,20,20,255))
    render.rect_filled(GSPosition[1] - 9, GSPosition[2] - 4, 215, 28, color(50,50,50,255))
    render.rect_filled(GSPosition[1] - 5, GSPosition[2], 206, 20, color(15,15,15,255))
    render.text(font, GSPosition[1]- 2, GSPosition[2] - 1, color(255,255,255, 255), "game", shadow, 1)
    render.text(font, GSPosition[1] + 31, GSPosition[2] - 1, color(120,183,53, 255), "sense", shadow, 1)
    render.text(font, GSPosition[1] + 65, GSPosition[2] - 1, color(255,255,255, 255), ".pub", shadow, 1)
    render.text_gradient(font, GSPosition[1] + 93, GSPosition[2], color(255,255,255, 255), color(120,183,53, 255), "| " .. ping .. "ms | " .. time .. "", 10, shadow, 1)
    render.gradient(GSPosition[1] - 4, GSPosition[2], 103, 1, color(30,86,153, 255), color(242,3,251, 255), 0)
    render.gradient(GSPosition[1] + 99, GSPosition[2], 101, 1, color(242,3,251, 255), color(224,255,0, 255), 0)
end)