local cache = ui.get_int('Antiaim.fake_lag_limit', '0Antiaim.range', '1Antiaim.range', '2Antiaim.range', '3Antiaim.range', "Antiaim.freestand")
function Jitter()
        if swtich then
             swtich = false
        else
             swtich = true
        end

     if swtich then
         ui.set_int("Antiaim.fake_lag_limit", 12, false)
     else
         ui.set_int("Antiaim.fake_lag_limit", 16, true)
     end


    if swtich then
        ui.set_int("0Antiaim.range", 60, false)
    else
        ui.set_int("0Antiaim.range", 12, true)
    end

    if swtich then
        ui.set_int("1Antiaim.range", 60, false)
    else
        ui.set_int("1Antiaim.range", 12, true)
    end

    if swtich then
        ui.set_int("2Antiaim.range", 12, false)
    else
        ui.set_int("2Antiaim.range", 52, true)
    end

    if swtich then
        ui.set_int("3Antiaim.range", 60, false)
    else
        ui.set_int("3Antiaim.range", 12, true)
    end
         if swtich then
        swtich = true
         else
        swtich = false
         end
    if ui.get_keybind_state(keybinds.automatic_peek) then
          ui.set_bool("Antiaim.freestand", true)
     else
          ui.set_bool("Antiaim.freestand", false)
     end
end
cheat.RegisterCallback("on_paint", Jitter)

cheat.notify("Made By @Soniso#4344 changed by Nexus#2624") 