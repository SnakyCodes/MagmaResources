local labels = {
	"⏳",
	"⏳ n",
	"⏳ n1g",
	"⏳ n!GG(:",
	"⏳ n6gg3(:",
	"⏳ n!gg3r",
	"⏳ n1gger$",
	"⏳ nlggers.l/u",
	"⏳ n!GG3rs.lua(:",
	"⏳ niggers.lu/",
	"⏳ n!gg3r$",
	"⏳ big black monkey boy",
	"⏳ n!gg",
	"⏳ n1ig",
	"⏳ monkey a$$",
	"⏳ pornhub",
	"⏳ n!",
	"⏳ N",
	"⏳ Slapping a$$",
	"⏳",
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

        time.first = globalvars.get_tickcount() + 16
    end
end)





