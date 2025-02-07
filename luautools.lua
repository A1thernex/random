--[[
	LuauTools - Developer Utility
	Making developing quicker and easier by creating useful and easy-to-write functions.
	
	Version 1.61 - Updated 07.02.2025

	Inspiration from "Utility" by liablelua
]]

env = getgenv and getgenv() or getfenv(0)
cloneref = cloneref or function(instance) return instance end

local game = game

local getServ = game.GetService

local function makeFunction(aliases: table, callback)
	for _, alias in pairs(aliases) do
		env[alias] = callback
	end
end

local function gs(service: Instance)
	return cloneref(getServ(game, service))
end

local players, stats, tpService, uis, httpServ, tween, rs = gs("Players"), gs("Stats"), gs("TeleportService"), gs("UserInputService"), gs("HttpService"), gs("TweenService"), gs("RunService")
local camera = workspace.CurrentCamera
local instNew, drawNew, color3Hsv, vec2New, vec3New, rand, huge, floor, clock, date, tweenInfo, strFind, strSub, tblInsert, cframeNew, ceil, tick = Instance.new, Drawing and Drawing.new or nil, Color3.fromHSV, Vector2.new, Vector3.new, math.random, math.huge, math.floor, os.clock, os.date, TweenInfo.new, string.find, string.sub, table.insert, math.ceil, tick
local lplr = players.LocalPlayer
local worldToViewport, getParts = camera.WorldToViewportPoint, camera.GetPartsObscuringTarget
local getMouseLocation = uis.GetMouseLocation
local getChildren, getDescendants, findFirstChild, findFirstChildOfClass, getFullName = game.GetChildren, game.GetDescendants, game.FindFirstChild, game.FindFirstChildOfClass, game.GetFullName
local isA = game.IsA
local loops = {}

local scripts = {
	["unc"] = "https://raw.githubusercontent.com/unified-naming-convention/NamingStandard/main/UNCCheckEnv.lua",
	["sunc"] = "https://gitlab.com/sens3/nebunu/-/raw/main/HummingBird8's_sUNC_yes_i_moved_to_gitlab_because_my_github_acc_got_brickedd/sUNCm0m3n7.lua",
	["iy"] = "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source",
	["dex"] = "https://raw.githubusercontent.com/infyiff/backup/main/dex.lua",
	["esp"] = "https://raw.githubusercontent.com/ic3w0lf22/Unnamed-ESP/master/UnnamedESP.lua",
	["nameless"] = "https://raw.githubusercontent.com/ltseverydayyou/Nameless-Admin/main/Source.lua",
	["ss"] = "https://raw.githubusercontent.com/78n/SimpleSpy/refs/heads/main/SimpleSpySource.lua"
}

makeFunction({"cframetovec3", "cframetoVec3", "cframeToVec3", "CFrameToVec3"}, function(position: CFrame))
    return vec3New(position.Position.X, position.Position.Y, position.Position.Z)
end

makeFunction({"vec3tocframe", "vec3toCframe", "vec3ToCFrame", "Vec3ToCFrame"}, function(position: Vector3))
    return cframeNew(position.X, position.Y, position.Z)
end

makeFunction({"gs", "getService", "GetService", "getservice"}, function(service: Instance)
	return gs(service)
end)

makeFunction({"isalive", "alive", "isAlive", "IsAlive", "Alive"}, function(plr: Player)
	local plr = plr or lplr
	local plrChar = isA(plr, "Model") and plr or plr.Character

	if plrChar then
		if findFirstChild(plrChar, "Humanoid") and findFirstChild(plrChar, "HumanoidRootPart") then
			return true, plrChar
		end
	end
	
	return false
end)

makeFunction({"gethrp", "getHrp", "GetHrp", "GetHRP"}, function(plr: Player)
	local plr = plr or lplr
	local plrAlive, char = alive(plr)

	if plrAlive then
		return findFirstChild(char, "HumanoidRootPart") and char.HumanoidRootPart
	end
end)

makeFunction({"gethum", "gethumanoid", "getHum", "getHumanoid", "GetHum", "GetHumanoid"}, function(plr: Player)
	local plr = plr or lplr
	local plrAlive, char = alive(plr)

	if plrAlive then
		return findFirstChild(char, "Humanoid") and char.Humanoid
	end
end)

makeFunction({"gettool", "getTool", "GetTool"}, function(plr: Player)
	local plr = plr or lplr
	local plrAlive, char = alive(plr)
	local tool = nil
	
	if plrAlive then
		tool = findFirstChildOfClass(char, "Tool") or nil
	end
	
	return tool, tool.Name
end)

makeFunction({"getplrs", "getPlrs", "GetPlrs", "getplayers", "getPlayers", "GetPlayers"}, function()
	local plrTbl, plrStr = {}, ""
		
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
	assert(drawNew ~= nil, "Failed to create a new Drawing object! Reason: Drawing.new is not supported by your exploit.")
	
	local newDraw = drawNew(drawingType)
	
	for property, value in pairs(properties) do
		newDraw[property] = value
	end
	
	return newDraw
end)

makeFunction({"randstr", "randomstr", "randomstring", "randStr", "randomStr", "randomString", "RandStr", "RandomStr", "RandomString"}, function(length: number, settings: table)
	local settings = settings or {}
	local charSet, ranStr, index, letter = "", "", 0, ""
	local letters = settings.letters == nil and true or settings.letters

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
		index = rand(#charSet)
		letter = strSub(charSet, index, index)
			
		ranStr = ranStr .. letter
	end
	
	return ranStr
end)

makeFunction({"getrnbw", "getRnbw", "GetRnbw", "getrainbow", "getRainbow", "GetRainbow", "getrainbowcolor", "getRainbowColor", "GetRainbowColor"}, function()
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
			for _, child in pairs(getChildren(instance)) do
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
					local distance = (vec2New(getMouseLocation(uis).X, getMouseLocation(uis).Y) - vec2New(pos.X, pos.Y)).magnitude

					if distance < mouseDistance and onScreen then
						closest = plr 
					end
				end
			end
		else
			for _, child in pairs(getChildren(instance)) do
				if lplrAlive then
					local onScreen, pos = visibletocam(child)
					local distance = (vec2New(uis:GetMouseLocation().X, uis:GetMouseLocation().Y) - vec2New(pos.X, pos.Y)).magnitude
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

makeFunction({"isoncam", "isOnCam", "IsOnCam", "visibletocam", "visibleToCam", "VisibleToCam", "visibletocamera", "visibleToCamera", "VisibleToCamera", "visibleoncamera", "visibleOnCamera", "VisibleOnCamera", "isoncamera", "isOnCamera", "IsOnCamera"}, function(plr: Player)
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

makeFunction({"makecfg", "makeCfg", "MakeCfg", "makeconfig", "makeConfig", "MakeConfig"}, function(name: string, folderName: string)
    assert(name, "missing argument #1 (string expected")
    assert(type(name) == "string", "invalid argument #1 (string expected, got " .. type(name) .. " instead)")
    
    if not strFind(name, ".") then
        name ..= ".json"
    end
    
    if not strFind(name, ".json") then
        error("Only the .json extension is supported for configuration making.")
    end
    
    if folderName then
        if not isfolder(folderName) then
            makefolder(folderName)
        end
        
        name = folderName .. "/" .. name
    end
    
    if not isfile(name) then
        writefile(name, "{}")
    end
end)

makeFunction({"getcfg", "getCfg", "GetCfg", "getconfig", "getConfig", "GetConfig"}, function(path: string)
    assert(path, "missing argument #1 (string expected")
    assert(type(path) == "string", "invalid argument #1 (string expected, got " .. type(path) .. " instead)")
    assert(isfile(path), "invalid argument #1 (file specified was not found)")
    
    local configinst = {}
    
    function configinst:saveData(data: table) 
        data = httpServ:JSONEncode(data)
        writefile(path, data)
    end
    
    function configinst:readData()
        local parsed = httpServ:JSONDecode(readfile(path))
        return parsed
    end
    
    function configinst:getValue(value: string)
        local parsed = httpServ:JSONDecode(readfile(path))
        
        if parsed[value] then
            return parsed[value]
        end
    end
    
    function configinst:editValue(value: string, newValue: any)
        local parsed = httpServ:JSONDecode(readfile(path))
        
        if parsed[value] then
            parsed[value] = newValue
        end
        
        parsed = httpServ:JSONEncode(parsed)
        writefile(path, parsed)
    end
    
    function configinst.delete()
        delfile(path)
    end
    
    return configinst
end)

makeFunction({"tptoposition", "tptoPosition", "tpToPosition", "TpToPosition", "teleporttoposition", "teleportToPosition", "TeleportToPosition"}, function(position: Vector3 | CFrame | Tween, tpType: string)
    assert(position, "missing argument #1 (Vector3 or CFrame expected")
    assert(typeof(position) == "Vector3" or typeof(position) == "CFrame", "invalid argument #1 (Vector3 or CFrame expected, got " .. typeof(position) .. " instead)")
    
    if not tpType then
        tpType = "Normal"
    end
    
    local plrAlive, char = alive()
    
    if plrAlive then
        local hrp = getHrp()
        
        if tpType == "Normal" then
            if typeof(position) == "Vector3" then
                position = cframeNew(position.X, position.Y, position.Z)
            end
            
            hrp.CFrame = position
            
        elseif tpType == "Tween" then
            if typeof(position) == "Vector3" then
                position = cframeNew(position.X, position.Y, position.Z)
            end
            
            -- taken from some script, credits go to it
            local time = math.ceil((char.Head.Position - cframeToVec3(position)).Magnitude / 3 + 0.5) / 50
            local info = tweenInfo(time, Enum.EasingStyle.Linear)
            
            tween:Create(hrp, info, {CFrame = position}):Play()
        end
    end
end)

makeFunction({"tptoplayer", "tptoPlayer", "tpToPlayer", "TpToPlayer", "teleporttoplayer", "teleportToPlayer", "TeleportToPlayer", "tptoplr", "tptoPlr", "tpToPlr", "TpToPlr", "teleporttoplr", "teleportToPlr", "TeleportToPlr"}, function(player: Player, method: string)
    assert(player, "missing argument #1 (Player expected)")
    assert(typeof(player) == "Player", "invalid argument #1 (Player expected, got " .. typeof(player) .. " instead)")
    
    if not method then
        method = "Normal"
    end
    
    local plrChar, plrAlive = alive()
    
    if plrAlive then
        if method == "Normal" then
            getHrp().CFrame = getHrp(player).CFrame
        elseif method == "Tween" then
            local time = ceil((plrChar.Head.Position - cframeToVec3(position)).Magnitude / 3 + 0.5) / 50
            local info = tweenInfo(time, Enum.EasingStyle.Linear)
            
            tween:Create(getHrp(), info, {CFrame = getHrp(player).CFrame})
        end
    end
end)

makeFunction({"tptopart", "tptoPart", "tpToPart", "TpToPart", "teleporttopart", "teleportToPart", "TeleportToPart"}, function(part: BasePart?, method: string)
    assert(part, "missing argument #1 (Instance expected")
    assert(type(part) == "Instance", "invalid argument #1 (Instance expected, got " .. type(part) .. " instead)")
    
    if not method then
        method = "Normal"
    end
    
    local plrAlive, plrChar = alive()
    
    if plrAlive then
        if method == "Normal" then
            getHrp().CFrame = part.CFrame
        elseif method == "Tween" then
            local time = ceil((plrChar.Head.Position - cframeToVec3(part.CFrame)).Magnitude / 3 + 0.5) / 25
            local info = tweenInfo(time, Enum.EasingStyle.Linear)
            
            tween:Create(getHrp(), info, {CFrame = part.CFrame}):Play()
        end
    end
end)

makeFunction({"checkprop", "checkProp", "CheckProp", "checkproperty", "checkProperty", "CheckProperty"}, function(obj: Instance, property: string)
	assert(obj, "missing argument #1 (Instance expected")
	assert(type(obj) == "Instance", "invalid argument #1 (Instance expected, got " .. type(obj) .. " instead)")
	assert(property, "missing argument #2 (string expected")
	assert(type(property) == "string", "invalid argument #2 (string expected, got " .. type(property) .. " instead)")
	
	-- // i suppose this is the only way of checking

	local success, _ = pcall(function()
		local property = obj[prop]
	end)

	return success
end)

makeFunction({"searchobj", "searchObj", "SearchObj", "searchobject", "searchObject", "SearchObject", "findobj", "findObj", "FindObj", "findobject", "findObject", "FindObject"}, function(args: table)
    	local data = {
		origin = args.origin or args.Origin or nil, -- where to search from
		searchMode = args.searchmode or args.searchMode or args.SearchMode or "Children", -- basically :GetChildren() or :GetDescendants()
		object = args.object or args.Object, -- the object to search for
		-- extrafilters can apparently crash lol
		extraFilters = args.extrafilters or args.extraFilters or args.ExtraFilters, -- find by property values, e.g. filterValues = {["Name"] = "ObjectName", ["Color3"] = Color3.new()}
		output = args.output or args.Output or false -- whether to output the objects found or not
	}
	local objTbl = {}
	local index = 1

	if not data.origin then
		for _, obj in getDescendants(game) do
			if data.extraFilters or #data.extraFilters > 0 then
				for prop, val in data.extraFilters do
					if checkProperty(obj, prop) and obj[prop] == val then
						tblInsert(objTbl, obj)

						if data.output then
							print("[" .. index .. "] Found matching object: " .. obj.Name .. ", Path: " .. getFullName(obj))
							index += 1
						end
					end
				end
			end
		end

		if #objTbl > 0 then
			if data.output then
				if index - 1 == 1 then
					print(index - 1 .. " object found in total.")
				else
					print(index - 1 .. " objects found in total.")
				end
			end

			return objTbl
		end

		for _, obj in getDescendants(game) do
			if obj.Name == data.object or isA(obj, data.object) or strFind(obj.Name, data.object) then
				tblInsert(objTbl, obj)

				if data.output then
					print("[" .. index .. "] Found matching object: " .. obj.Name .. ", Path: " .. getFullName(obj))
					index += 1
				end
			end
		end
	else
		for _, obj in (data.searchMode == "Descendants" and getDescendants(data.origin) or getChildren(data.origin)) do
			if data.extraFilters or #data.extraFilters > 0 then
				for prop, val in data.extraFilters do
					if checkProperty(obj, prop) and obj[prop] == val then
						tblInsert(objTbl, obj)

						if data.output then
							print("[" .. index .. "] Found matching object: " .. obj.Name .. ", Path: " .. getFullName(obj))
							index += 1
						end
					end
				end
			end
		end

		if #objTbl > 0 then
			if data.output then
				if index - 1 == 1 then
					print(index - 1 .. " object found in total.")
				else
					print(index - 1 .. " objects found in total.")
				end
			end

			return objTbl
		end

		for _, obj in (data.searchMode == "Descendants" and getDescendants(data.origin) or getChildren(data.origin)) do
			if obj.Name == data.object or isA(obj, data.object) or strFind(obj.Name, data.object) then
				tblInsert(objTbl, obj)

				if data.output then
					print("[" .. index .. "] Found matching object: " .. obj.Name .. ", Path: " .. getFullName(obj))
					index += 1
				end
			end
		end
	end

	if data.output then
		if index - 1 == 1 then
			print(index - 1 .. " object found in total.")
		else
			print(index - 1 .. " objects found in total.")
		end
	end

	return objTbl
end)

makeFunction({"rsloop", "rsLoop", "RsLoop", "runserviceloop", "runserviceLoop", "runServiceLoop", "RunServiceLoop"}, function(method: string, id: string, loopFunction)
    assert(method, "missing argument #1 (string expected")
    assert(type(method) == "string", "invalid argument #1 (string expected, got " .. type(method) .. " instead)")
    assert(id, "missing argument #2 (string expected)")
    assert(type(id) == "string", "invalid argument #2 (string expected, got " .. type(id) .. " instead)")
    assert(loopFunction, "missing argument #3 (function expected)")
    assert(type(loopFunction) == "function", "invalid argument #3 (function expected, got " .. type(loopFunction) .. " instead)")
    
    if rs[method] and typeof(rs[method]) == "RBXScriptSignal" then
        loops[id] = rs[method]:Connect(loopFunction)
    end
end)

makeFunction({"disconnectrsloop, disconnectrsLoop", "disconnectRsLoop", "DisconnectRsLoop"}, function(id: string)
    assert(id, "missing argument #1 (string expected)")
    assert(type(id) == "string", "invalid argument #1 (string expected, got " .. type(id) .. " instead)")
    
    if loops[id] then
        loops[id]:Disconnect()
        loops[id] = nil
    end
end)

makeFunction({"listrsloops", "listrsLoops", "listRsLoops", "ListRsLoops"}, function()
    local string = ""
    
    for id, _ in loops do
        string ..= id .. ", "
    end
    
    return string
end)
