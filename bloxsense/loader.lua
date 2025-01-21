local githublink = "https://raw.githubusercontent.com/A1thernex/random/refs/heads/main/bloxsense/"

local games = {
    ["18976527873"] = "cbe.lua",
    ["12501200809"] = "csgo%20modded.lua" 
}

local link = games[tostring(game.PlaceId)]

if link then
    loadstring(game:HttpGet(githublink .. link))()
else
    warn("[bloxsense] game not supported")
end
