repeat task.wait() until game:IsLoaded()

local githublink = "https://raw.githubusercontent.com/A1thernex/random/refs/heads/main/bloxsense/"

local games = {
    ["18976527873"] = githublink .. "cbe.lua",
    ["17586052747"] = githublink .. "cbrv2.lua"
}

local link = games[tostring(game.PlaceId)]

if link then
    loadstring(game:HttpGet(link))()
end
