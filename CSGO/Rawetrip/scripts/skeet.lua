local labels = {
    "                  ",
	"                  ",
	"                 g",
	"                 g",
	"                ga",
	"                ga",
	"               gam",
	"               gam",
	"              game",
	"              game",
	"             games",
	"             games",
	"            gamese",
	"            gamese",
	"           gamesen",
	"           gamesen",
	"          gamesens",
	"          gamesens",
	"         gamesense",
	"         gamesense",
	"        gamesense ",
	"        gamesense ",
	"       gamesense  ",
	"       gamesense  ",
	"      gamesense   ",
	"      gamesense   ",
	"     gamesense    ",
	"     gamesense    ",
	"    gamesense     ",
	"    gamesense     ",
	"   gamesense      ",
	"   gamesense      ",
	"  gamesense       ",
	"  gamesense       ",
	" gamesense        ",
	" gamesense        ",
	"gamesense         ",
	"gamesense         ",
	"amesense          ",
	"amesense          ",
	"mesense           ",
	"mesense           ",
	"esense            ",
	"esense            ",
	"sense             ",
	"sense             ",
	"sens              ",
	"sens              ",
	"sen               ",
	"sen               ",
	"se                ",
	"se                ",
	"s                 ",
	"s                 ",
	
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