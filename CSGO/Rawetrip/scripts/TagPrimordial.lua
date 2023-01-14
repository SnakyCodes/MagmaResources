cheat.notify("PrimordialTag.lua by astraxzy#3564")
local labels = {
	"⏳ p",
	"⏳ pri",
	"⏳ prim",
	"⏳ primo",
	"⏳ primor",
	"⏳ primord",
	"⏳ primordi",
	"⏳ primordia",
	"⏳ primordial",
	"⏳ primordia",
	"⏳ primordi",
	"⏳ primord",
	"⏳ primor",
	"⏳ primo",
	"⏳ prim",
	"⏳ pri",
	"⏳ pr",
	"⏳ p"
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

        time.first = globalvars.get_tickcount() + 17
    end
end)



