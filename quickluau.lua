--[[
	QuickLuau - Developer Utility
	Making developing quicker by creating useful and easy-to-write functions.
	
	Version 1.2 - Updated 29.12.24

	Inspiration from "Utility" by liablelua
]]

env = getgenv and getgenv() or getfenv(0)
cloneref = cloneref or function(instance) return instance end

local getServ = game.FindService

local function makeFunction(aliases: table, callback)
	assert(callback ~= nil, "[QuickLuau] Missing callback for new functions!")
	for _, alias in pairs(aliases) do
		env[alias] = callback
	end
end

makeFunction({"gs", "getService", "GetService", "getservice"}, function(service: Instance)
	return cloneref(getServ(game, service))
end)

local players, stats, tpService, uis = gs("Players"), gs("Stats"), gs("TeleportService"), gs("UserInputService")
local camera = workspace.CurrentCamera
local instNew, drawNew, color3Hsv, vec2new, rand, huge, floor, clock, date = Instance.new, Drawing and Drawing.new or nil, Color3.fromHSV, Vector2.new, math.random, math.huge, math.floor, os.clock, os.date
local lplr = players.LocalPlayer
local worldToViewport, getParts = camera.WorldToViewportPoint, camera.GetPartsObscuringTarget
local plrTbl, plrStr = {}, ""
local charSet, ranstr = "", ""
local lastTime, start, frameTbl = nil, nil, {}

local scripts = {
	["unc"] = "https://raw.githubusercontent.com/unified-naming-convention/NamingStandard/main/UNCCheckEnv.lua",
	["iy"] = "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source",
	["dex"] = "https://raw.githubusercontent.com/infyiff/backup/main/dex.lua",
	["esp"] = "https://raw.githubusercontent.com/ic3w0lf22/Unnamed-ESP/master/UnnamedESP.lua",
	["nameless"] = "https://raw.githubusercontent.com/ltseverydayyou/Nameless-Admin/main/Source.lua"
}

makeFunction({"isalive", "alive", "isAlive", "IsAlive", "Alive"}, function(plr: Player)
	plr = plr or lplr
	plrchar = plr:IsA("Model") and plr or plr.Character

	if plrchar then
		if plrchar:FindFirstChild("Humanoid") and plrchar:FindFirstChild("HumanoidRootPart") then
			return true, plrchar
		end
	end
	
	return false
end)

makeFunction({"gethrp", "getHrp", "GetHrp", "GetHRP"}, function(plr: Player)
	plr = plr or lplr
	
	plrAlive, char = alive(plr)

	if plrAlive then
		return char:FindFirstChild("HumanoidRootPart") and char.HumanoidRootPart
	end
end)

makeFunction({"gethum", "gethumanoid", "getHum", "getHumanoid", "GetHum", "GetHumanoid"}, function(plr: Player)
	plr = plr or lplr

	plrAlive, char = alive(plr)

	if plrAlive then
		return char:FindFirstChild("Humanoid") and char.Humanoid
	end
end)

makeFunction({"gettool", "getTool", "GetTool"}, function(plr: Player)
	plr = plr or lplr
	
	plrAlive, char = alive(plr)
	tool = nil
	
	if plrAlive then
		tool = char:FindFirstChildOfClass("Tool") or nil
	end
	
	return tool, tool.Name
end)

makeFunction({"getplrs", "getPlrs", "GetPlrs", "getplayers", "getPlayers", "GetPlayers"}, function()
	for _, plr in pairs(players:GetPlayers()) do
		if plr == lplr then
			plrTbl["LocalPlayer"] = plr
		else
			plrTbl[plr.Name] = plr
		end
		plrStr = plrStr .. plr.Name .. ", "
	end
	
	return plrTbl, plrStr
end)

makeFunction({"checkteam", "checkTeam", "CheckTeam"}, function(plr: Player)
	return plr.Team == lplr.Team
end)

makeFunction({"join", "Join", "joingame", "joinGame", "JoinGame", "joininstance", "joinInstance", "JoinInstance"}, function(gameId: number, jobId: string)
	tpService:TeleportToPlaceInstance(gameId, jobId, lplr)
end)

makeFunction({"newinstance", "newinst", "newInstance", "newInst", "makeinst", "makeinstance", "makeInst", "makeInstance", "NewInst", "NewInstance", "MakeInst", "MakeInstance"}, function(instanceType: string, properties: table)
	local instance = instNew(instanceType)
	for property, value in pairs(properties) do
		instance[property] = value
	end
	
	return instance
end)

makeFunction({"draw", "newdrawing", "makedrawing", "Draw", "newDrawing", "makeDrawing", "NewDrawing", "MakeDrawing"}, function(drawingType: string, properties: table)
	assert(drawnew ~= nil, "Failed to create a new Drawing object! Reason: Drawing.new is not supported by your exploit.")
	
	local newdraw = drawNew(drawingType)
	for property, value in pairs(properties) do
		newdraw[property] = value
	end
	
	return newdraw
end)

makeFunction({"randstr", "randomstr", "randomstring", "randStr", "randomStr", "randomString", "RandStr", "RandomStr", "RandomString"}, function(length: number, settings: table)
	settings = settings or {}
	letters = settings.letters == nil and true or settings.letters
	ranstr = ""

	if letters then
		charSet = charSet .. "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
	end
	if settings.numbers then
		charSet = charSet .. "1234567890"
	end
	if settings.punctuation then
		charSet = charSet .. "!./:;(),?"
	end
	
	for i = 0, length do
		local index = rand(#charSet)
		
		local letter = string.sub(charSet, index, index)
		ranstr = ranstr .. letter
	end
	
	return ranstr
end)

makeFunction({"getrnbw", "getRnbw", "GetRnbw", "getrainbow", "getRainbow", "GetRainbow", "getrainbowcolor", "getRainbowColor", "GetRainbowColor", ""}, function()
	return color3Hsv(tick() % 1 / 1, 1, 1)
end)

makeFunction({"closest", "Closest", "getclosest", "getClosest", "GetClosest", "getclosestplr", "getClosestPlr", "GetClosestPlr", "getclosestplayer", "getClosestPlayer", "GetClosestPlayer"}, function(mode: string, instance: Instance)
	local mouseDistance = 2000
	local closest = nil
    local distance = huge

	local lplrAlive, lplrChar = alive()

	if mode == "distance" then
		if not instance then
			for _, plr in pairs(getplrs()) do
                if plr == lplr then continue end

				local plrAlive, plrChar = alive(plr)

				if plrAlive and lplrAlive then
					local magnitude = (lplrChar.HumanoidRootPart.Position - plrChar.HumanoidRootPart.Position).magnitude

					if magnitude < distance then
						closest = plr 
                        distance = magnitude
					end
				end
			end
		else
			for _, child in pairs(instance:GetChildren()) do
				if lplrAlive and child.HumanoidRootPart then
					local magnitude = (child.HumanoidRootPart.Position - lplrChar.HumanoidRootPart.Position).magnitude
					
					if magnitude < distance then
						closest = child
					end
				end
			end
		end
	elseif mode == "mouse" then
		if not instance then
			for _, plr in pairs(getplrs()) do
				local plrAlive, plrChar = alive(plr)
				
				if plrAlive and lplrAlive then
					-- taken from exunys
					local onScreen, pos = visibletocam(plrChar)
					local distance = (vec2new(uis:GetMouseLocation().X, uis:GetMouseLocation().Y) - vec2new(pos.X, pos.Y)).magnitude

					if distance < mouseDistance and onScreen then
						closest = plr 
					end
				end
			end
		else
			for _, child in pairs(instance:GetChildren()) do
				if lplrAlive then
					local onScreen, pos = visibletocam(child)
					local distance = (vec2new(uis:GetMouseLocation().X, uis:GetMouseLocation().Y) - vec2new(pos.X, pos.Y)).magnitude
					if distance < mouseDistance and onScreen then
						closest = child
					end
				end
			end
		end
	end

	return closest
end)

makeFunction({"load", "Load", "loadscript", "loadScript", "LoadScript", "run", "Run", "runscript", "runScript", "RunScript"}, function(script: string)
	found = false

	for name, source in pairs(scripts) do
		if script == name then
			loadstring(game:HttpGet(source))()
			found = true
		end
	end

	if not found then
		loadstring(game:HttpGet(script))()
	end
end)

makeFunction({"isvisible", "isVisible", "IsVisible", "isonscreen", "isOnScreen", "IsOnScreen"}, function(plr)
	if plr == lplr then return end
	
	local plrAlive, plrChar = alive(plr)
	local lplrAlive, lplrChar = alive()

	if plrAlive and lplrAlive then
		local castPoints = {plrChar.HumanoidRootPart.Position}
		local ignoreList = {lplrChar, plrChar}

		return not (#getParts(camera, castPoints, ignoreList) > 0)
	end
end)

makeFunction({"isoncam", "isOnCam", "IsOnCam", "visibletocam", "visibleToCam", "VisibleToCam", "visibletocamera", "visibleToCamera", "VisibleToCamera", "visibleoncamera", "visibleOnCamera", "VisibleOnCamera", "isoncamera", "isOnCamera", "IsOnCamera"}, function(plr)
	if plr == lplr then return end
	local plrAlive, plrChar = alive(plr)

	if plrAlive then
		local position, onScreen = worldToViewport(camera, plrChar.HumanoidRootPart.Position)

		return onScreen, position
	end
end)

makeFunction({"getfps", "getFps", "GetFps"}, function()
	return floor(stats.Workspace.Heartbeat:GetValueString())
end)

makeFunction({"getms", "getMs", "GetMs", "getping", "getPing", "GetPing"}, function()
	return floor(stats.Network.ServerStatsItem["Data Ping"]:GetValueString())
end)

makeFunction({"gettime", "getTime", "GetTime"}, function()
	return date("%H:%M:%S")
end)

makeFunction({"getdate", "getDate", "GetDate"}, function()
	return date("%d.%m.20%y")
end)
