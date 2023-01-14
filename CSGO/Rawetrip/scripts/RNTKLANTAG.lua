local labels = {
    "                  ",
"",
    "P",
    "R",
    "R4",
    "Ra",
    "Ra1",
     "Rai",
      "RaiN",
       "RaiH",
        "Rain",
         "RainH",
          "RainN",
           "RainN4",
            "RainNa",
             "RainNa|",
              "RainNaI",
               "RainNai|",
                "RainNil7",
                 "RainNailT",
                  "RainNailT",
                 "RainNailTг",
                "RainNailTr",
               "RainNailTr4",
              "RainNailTrA",
             "RainNailTra",
            "RainNailTraI",
           "RainNailTrai",
          "RainNailTrail",
         "Ra1nNa1lTra1l",
        "R41nN41lTr41l",
       "RnNlTl",
      "RNT",
     "RHT",
    "RH7",
   "ЯH7",
  "ЯH",
 "R",
"R",
"R",
"R",
"R",
	
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
