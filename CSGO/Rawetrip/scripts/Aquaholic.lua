local labels = {
	 "",
	 ">A",
	 "Aq",
	 "Aqu",
	 "Aqua",
	 "Aquah",
	 "Aquaho",
	 "Aquahol",
	 "Aquaholi",
	 "Aquaholic",
	 "Aquaholic!?",
	 "Aquaholic.",
	 "Aquaholic.l",
	 "Aquaholic.lu",
	 "Aquaholic.lua",
	 "Aquaholic.lua<",
	 "Aquaholic.lu",
	 "Aquaholic.l",
	 "Aquaholic.",
	 "Aquaholic",
	 "Aquaholi",
	 "Aquahol",
	 "Aquah0",
	 "Aquaho",
	 "Aquah",
	 "Aqua",
	 "Aqu",
	 "Aq!",
	 "Aq",
	 "A<",
	 "<>",
	 " ",	
	 "",
}

local time = {
	first = 0, second = 0
}

cheat.push_callback("on_paint", function()
    if time.first < globalvars.get_tickcount() then   
		time.second = time.second + 1
        if time.second > #labels + 1 then
            time.second = 0
        end

        engine.set_clantag(labels[time.second])

        time.first = globalvars.get_tickcount() + 11
    end
end)



















