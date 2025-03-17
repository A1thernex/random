local esp = loadstring(game:HttpGet("https://raw.githubusercontent.com/A1thernex/modified-esp/main/main.lua"))()
local sa = loadstring(game:HttpGet("https://raw.githubusercontent.com/A1thernex/random/refs/heads/main/universal%20silent%20aim.lua"))()

local repo = 'https://raw.githubusercontent.com/mstudio45/LinoriaLib/main/'

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()
local Options = Library.Options
local Toggles = Library.Toggles

Library.ShowToggleFrameInKeybinds = true
Library.ShowCustomCursor = true
Library.NotifySide = "Left"

local plrs = gs("Players")
local rs = gs("RunService")
local lighting = gs("Lighting")
local uis = gs("UserInputService")

local lplr = plrs.LocalPlayer
local cam = workspace.CurrentCamera

local vec3, vec2, cframe, angles = Vector3.new, Vector2.new, CFrame.new, CFrame.Angles
local atan2, rad, floor, clamp, round, huge, abs, rand = math.atan2, math.rad, math.floor, math.clamp, math.round, math.huge, math.abs, math.random 
local col3rgb, col3hsv, col3tohsv = Color3.fromRGB, Color3.fromHSV, Color3.toHSV
local ray = Ray.new
local tick = tick

local ffc, ffcoc, fporwil, fporwwl = game.FindFirstChild, game.FindFirstChildOfClass, workspace.FindPartOnRayWithIgnoreList, workspace.FindPartOnRayWithWhitelist
local isa, isdof = game.IsA, game.IsDescendantOf
local wtvp, vptr = cam.WorldToViewportPoint, cam.ViewportPointToRay
local keydown, mouseloc = uis.IsKeyDown, uis.GetMouseLocation

local aimcircle, deadcircle = Drawing.new("Circle"), Drawing.new("Circle")
local hrpcf = nil
local spin = 0

local Atlanta = {
    Locals = {
        AimAssistFOV = 100,
        DeadzoneFOV = 90,
        Humaniser = {
            Tick = tick(),
            Sample = nil,
            Index = 1
        },
        LastTick = tick(),
        LastStutter = tick(),
        TriggerTick = tick()
    }
}

local defaultskybox = {
    ["SkyboxBk"] = lighting.Sky.SkyboxBk,
    ["SkyboxDn"] = lighting.Sky.SkyboxDn,
    ["SkyboxFt"] = lighting.Sky.SkyboxFt,
    ["SkyboxLf"] = lighting.Sky.SkyboxLf,
    ["SkyboxRt"] = lighting.Sky.SkyboxRt,
    ["SkyboxUp"] = lighting.Sky.SkyboxUp,
}

local skyboxes = { 
    ["Nebula"] = {      
		["SkyboxLf"] = "rbxassetid://159454286",      
		["SkyboxBk"] = "rbxassetid://159454299",      
		["SkyboxDn"] = "rbxassetid://159454296",      
		["SkyboxFt"] = "rbxassetid://159454293",      
		["SkyboxLf"] = "rbxassetid://159454286",      
		["SkyboxRt"] = "rbxassetid://159454300",      
		["SkyboxUp"] = "rbxassetid://159454288",      
	},      
	["Vaporwave"] = {      
		["SkyboxLf"] = "rbxassetid://1417494402",      
		["SkyboxBk"] = "rbxassetid://1417494030",      
		["SkyboxDn"] = "rbxassetid://1417494146",      
		["SkyboxFt"] = "rbxassetid://1417494253",      
		["SkyboxLf"] = "rbxassetid://1417494402",      
		["SkyboxRt"] = "rbxassetid://1417494499",      
		["SkyboxUp"] = "rbxassetid://1417494643",      
	},      
	["Clouds"] = {      
		["SkyboxLf"] = "rbxassetid://570557620",      
		["SkyboxBk"] = "rbxassetid://570557514",      
		["SkyboxDn"] = "rbxassetid://570557775",      
		["SkyboxFt"] = "rbxassetid://570557559",      
		["SkyboxLf"] = "rbxassetid://570557620",      
		["SkyboxRt"] = "rbxassetid://570557672",      
		["SkyboxUp"] = "rbxassetid://570557727",      
	},      
	["Twilight"] = {      
		["SkyboxLf"] = "rbxassetid://264909758",      
		["SkyboxBk"] = "rbxassetid://264908339",      
		["SkyboxDn"] = "rbxassetid://264907909",      
		["SkyboxFt"] = "rbxassetid://264909420",      
		["SkyboxLf"] = "rbxassetid://264909758",      
		["SkyboxRt"] = "rbxassetid://264908886",      
		["SkyboxUp"] = "rbxassetid://264907379",      
	},      
	["Pink Vision"] = {
		["SkyboxBk"] = "http://www.roblox.com/asset/?id=6593929026",
		["SkyboxDn"] = "http://www.roblox.com/asset/?id=6593930140",
		["SkyboxFt"] = "http://www.roblox.com/asset/?id=6593931249",
		["SkyboxLf"] = "http://www.roblox.com/asset/?id=6593932587",
		["SkyboxRt"] = "http://www.roblox.com/asset/?id=6593933789",
		["SkyboxUp"] = "http://www.roblox.com/asset/?id=6593935319",
	},
	["Blue Sky"] = {
		["SkyboxBk"] = "http://www.roblox.com/asset/?id=226060119",
		["SkyboxDn"] = "http://www.roblox.com/asset/?id=226060115",
		["SkyboxFt"] = "http://www.roblox.com/asset/?id=226060143",
		["SkyboxLf"] = "http://www.roblox.com/asset/?id=226060136",
		["SkyboxRt"] = "http://www.roblox.com/asset/?id=226060155",
		["SkyboxUp"] = "http://www.roblox.com/asset/?id=226060167",
	},
	["Green Sky"] = {
		["SkyboxBk"] = "http://www.roblox.com/asset/?id=157711514",
		["SkyboxDn"] = "http://www.roblox.com/asset/?id=157711501",
		["SkyboxFt"] = "http://www.roblox.com/asset/?id=157711522",
		["SkyboxLf"] = "http://www.roblox.com/asset/?id=157711494",
		["SkyboxRt"] = "http://www.roblox.com/asset/?id=157711509",
		["SkyboxUp"] = "http://www.roblox.com/asset/?id=157711528",
	},
    ["Night Sky"] = {
        ["SkyboxBk"] = "rbxassetid://12064107",
        ["SkyboxDn"] = "rbxassetid://12064152",
        ["SkyboxFt"] = "rbxassetid://12064121",
        ["SkyboxLf"] = "rbxassetid://12063984",
        ["SkyboxRt"] = "rbxassetid://12064115",
        ["SkyboxUp"] = "rbxassetid://12064131",
    },
    ["Pink Daylight"] = {
        ["SkyboxBk"] = "rbxassetid://271042516",
        ["SkyboxDn"] = "rbxassetid://271077243",
        ["SkyboxFt"] = "rbxassetid://271042556",
        ["SkyboxLf"] = "rbxassetid://271042310",
        ["SkyboxRt"] = "rbxassetid://271042467",
        ["SkyboxUp"] = "rbxassetid://271077958",
    },
    ["Morning Glow"] = {
        ["SkyboxBk"] = "rbxassetid://1417494030",
        ["SkyboxDn"] = "rbxassetid://1417494146",
        ["SkyboxFt"] = "rbxassetid://1417494253",
        ["SkyboxLf"] = "rbxassetid://1417494402",
        ["SkyboxRt"] = "rbxassetid://1417494499",
        ["SkyboxUp"] = "rbxassetid://1417494643",
    },
    ["Fade Blue"] = {
        ["SkyboxBk"] = "rbxassetid://153695414",
        ["SkyboxDn"] = "rbxassetid://153695352",
        ["SkyboxFt"] = "rbxassetid://153695452",
        ["SkyboxLf"] = "rbxassetid://153695320",
        ["SkyboxRt"] = "rbxassetid://153695383",
        ["SkyboxUp"] = "rbxassetid://153695471",
    },
    ["Neptune"] = {
        ["SkyboxBk"] = "rbxassetid://218955819",
        ["SkyboxDn"] = "rbxassetid://218953419",
        ["SkyboxFt"] = "rbxassetid://218954524",
        ["SkyboxLf"] = "rbxassetid://218958493",
        ["SkyboxRt"] = "rbxassetid://218957134",
        ["SkyboxUp"] = "rbxassetid://218950090",
    },
    ["Redshift"] = {
        ["SkyboxBk"] = "rbxassetid://401664839",
        ["SkyboxDn"] = "rbxassetid://401664862",
        ["SkyboxFt"] = "rbxassetid://401664960",
        ["SkyboxLf"] = "rbxassetid://401664881",
        ["SkyboxRt"] = "rbxassetid://401664901",
        ["SkyboxUp"] = "rbxassetid://401664936",
    }
}

local chams = {
    oldvalues = {}
}

local noclipparts = {}

local desync = {
    frames = {}
}

local default = {
    Lighting = {
        ClockTime = lighting.ClockTime,
        Brightness = lighting.Brightness,
        ExposureCompensation = lighting.ExposureCompensation,

        Ambient = lighting.Ambient,
        OutdoorAmbient = lighting.OutdoorAmbient,
        ColorShift_Bottom = lighting.ColorShift_Bottom,
        ColorShift_Top = lighting.ColorShift_Top,

        Technology = lighting.Technology,

        Sky = {
            SkyboxBk = lighting.Sky.SkyboxBk,
            SkyboxDn = lighting.Sky.SkyboxDn,
            SkyboxFt = lighting.Sky.SkyboxFt,
            SkyboxLf = lighting.Sky.SkyboxLf,
            SkyboxRt = lighting.Sky.SkyboxRt,
            SkyboxUp = lighting.Sky.SkyboxUp,
        },

        Atmosphere = {
            Color = lighting.Atmosphere.Color,
            Decay = lighting.Atmosphere.Decay
        },
    },

    Camera = {
        FieldOfView = cam.FieldOfView
    }
}

local function rotatey(cfr)
    local _, y, _ = cfr:ToOrientation()

    return cframe(cfr.Position) * angles(0, y, 0)
end

local function getrainbow(speed: number, color: Color3)
    local hue, sat, val = col3tohsv(color)
    local tick = tick()
    
    return (col3hsv((tick * (Options.chamrainsp.Value / 100) - floor(tick * (Options.chamrainsp.Value / 100))), sat, val))
end

function chams.apply(color: Color3, trans: number, rainbow: boolean)
    local alive, char = alive()

    if alive then
        for _, part in char:GetChildren() do
            if isa(part, "MeshPart") then
                if not chams.oldvalues[part.Name] then
                    chams.oldvalues[part.Name] = {}
                    chams.oldvalues[part.Name]["Color"] = part.Color
                    chams.oldvalues[part.Name]["Hat"] = false
                end

                part.Color = rainbow and getrainbow(Options.chamrainsp.Value, color) or color
                part.Material = "ForceField"
                part.Transparency = trans
            elseif isa(part, "Accessory") then
                if not chams.oldvalues[part.Name] then
                    chams.oldvalues[part.Name] = {}
                    chams.oldvalues[part.Name]["Color"] = part.Handle.Color
                    chams.oldvalues[part.Name]["Hat"] = true
                end

                part.Handle.Color = rainbow and getrainbow(Options.chamrainsp.Value, color) or color
                part.Handle.Material = "ForceField"
                part.Handle.Transparency = trans
            end
        end
    end
end

function chams.default()
    local alive, char = alive()

    if alive then
        for i,v in char:GetChildren() do
            if chams.oldvalues[v.Name] then
                if not chams.oldvalues[v.Name]["Hat"] then
                    v.Color = chams.oldvalues[v.Name]["Color"]
                    v.Material = "Plastic"
                    v.Transparency = 0
                else
                    v.Handle.Color = chams.oldvalues[v.Name]["Color"]
                    v.Handle.Material = "Plastic"
                    v.Handle.Transparency = 0
                end
            end
        end
    end
end

local function applyskybox(skybox: string)
    if skybox == "Default" then
        for skyb, val in default.Lighting.Sky do
            lighting.Sky[skyb] = val
        end
    else
        for skyb, val in skyboxes[skybox] do
            lighting.Sky[skyb] = val
        end
    end
end

function desync:getfakepos()
	return desync["origin"] or cframe()
end
	   
function desync:setfakepos(new)
	desync["origin"] = new
end 
			   
function desync.run(a, origin)
	frames = desync.frames
	if isAlive() then
	    frames[#frames + 1] = origin
		if frames[#frames - a] ~= nil then
			desync:setfakepos(frames[#frames - a])
		else
			desync:getfakepos(frames[#frames])
		end
	end
end

local Window = Library:CreateWindow({
	Title = 'euphoria [universal] | v1',
	Center = true,
	AutoShow = true,
	Resizable = true,
	ShowCustomCursor = true,
	NotifySide = "Left",
	TabPadding = 8,
	MenuFadeTime = 0.2
})

local Tabs = {
	Combat = Window:AddTab('Combat'),
    Visuals = Window:AddTab('Visuals'),
    Misc = Window:AddTab('Miscellaneous'),
	['UI Settings'] = Window:AddTab('UI Settings'),
}

local comAim = Tabs.Combat:AddLeftGroupbox('Aim Assist')

comAim:AddToggle("aimas", {
    Text = "Enabled",
    Default = false,
    Risky = false,
    Callback = function() end
}):AddKeyPicker("aimaskey", {
    Default = "E",
    Mode = "Toggle",
    Text = "Aim Assist",
    SyncToggleState = true,
    Callback = function() end
})

comAim:AddSlider("aimfov", {
    Text = "Field Of View",
    Default = 12.5,
    Min = 0.5,
    Max = 100,
    Rounding = 2,
    Callback = function() end
})

comAim:AddDropdown("fovtype", {
    Values = {"Static", "Dynamic"},
    Text = "FOV Type",
    Default = 1,
    Callback = function() end
})

comAim:AddSlider("dyn", {
    Text = "Dynamic Amount",
    Default = 25,
    Min = 1,
    Max = 100,
    Rounding = 2,
    Callback = function() end
})

comAim:AddDropdown("hitb", {
    Values = {"Head", "Torso", "Arms", "Legs"},
    Text = "Hitboxes",
    Multi = true,
    Default = 1,
    Callback = function() end
})

comAim:AddToggle("randhb", {
    Text = "Randomize Hitbox Position",
    Default = false,
    Risky = false,
    Callback = function() end
})

comAim:AddDropdown("aimchecks", {
    Values = {"Team Check", "Wall Check", "Visible Check", "ForceField Check", "Alive Check"},
    Text = "Aim Assist Checks",
    Multi = true,
    Default = 1,
    Callback = function() end
})

comAim:AddDropdown("wallcheckor", {
    Values = {"Camera", "Head", "Torso"},
    Text = "Wall Check Origin",
    Default = 1,
    Callback = function() end
})

comAim:AddSlider("horsm", {
    Text = "Horizontal Smoothing (%)",
    Default = 12.5,
    Min = 1,
    Max = 100,
    Rounding = 2,
    Callback = function() end
})

comAim:AddSlider("versm", {
    Text = "Vertical Smoothing (%)",
    Default = 5,
    Min = 1,
    Max = 100,
    Rounding = 2,
    Callback = function() end
})

comAim:AddSlider("dynsm", {
    Text = "Dynamic Smoothing (%)",
    Default = 100,
    Min = 0.01,
    Max = 100,
    Rounding = 2,
    Callback = function() end
})

comAim:AddToggle("readj", {
    Text = "Readjustment",
    Default = false,
    Risky = false,
    Callback = function() end
}):AddKeyPicker("readjkey", {
    Default = "MB2",
    Mode = "Hold",
    Text = "AA Readjustment",
    SyncToggleState = true,
    Callback = function() end
})

comAim:AddSlider("deadzone", {
    Text = "Deadzone (%)",
    Default = 100,
    Min = 0.5,
    Max = 100,
    Rounding = 2,
    Callback = function() end
})

comAim:AddSlider("stutter", {
    Text = "Stutter (t)",
    Default = 25,
    Min = 0.1,
    Max = 100,
    Rounding = 2,
    Callback = function() end
})

comAim:AddToggle("humanizer", {
    Text = "Humanizer",
    Default = false,
    Risky = false,
    Callback = function() end
})

local comTrig = Tabs.Combat:AddRightGroupbox("Triggerbot")

comTrig:AddToggle("trig", {
    Text = "Enabled",
    Default = false,
    Risky = false,
    Callback = function() end
}):AddKeyPicker("trigkey", {
    Default = "H",
    Mode = "Always",
    Text = "Triggerbot",
    SyncToggleState = true,
    Callback = function() end
})

comTrig:AddSlider("trigdelay", {
    Text = "Delay (ms)",
    Default = 12.5,
    Min = 0.5,
    Max = 500,
    Rounding = 2,
    Callback = function() end
})

comTrig:AddSlider("trigint", {
    Text = "Interval (ms)",
    Default = 75,
    Min = 0.5,
    Max = 1000,
    Rounding = 1,
    Callback = function() end
})

comTrig:AddDropdown("trigcheck", {
    Values = {"Team Check", "Wall Check", "Visible Check", "ForceField Check", "Alive Check"},
    Text = "Triggerbot Checks",
    Multi = true,
    Default = 1,
    Callback = function() end
})

comTrig:AddDropdown("hitb1", {
    Values = {"Head", "Torso", "Arms", "Legs"},
    Text = "Hitboxes",
    Multi = true,
    Default = 1,
    Callback = function() end
})

comTrig:AddDropdown("wallcheckor1", {
    Values = {"Camera", "Head", "Torso"},
    Text = "Wall Check Origin",
    Default = 1,
    Callback = function() end
})

local comSil = Tabs.Combat:AddRightGroupbox("Bullet Redirection")

comSil:AddToggle("silent", {
    Text = "Enabled",
    Default = false,
    Risky = true,
    Callback = function(val) 
        sa.Enabled = val

        if val then
            sa.FOVVisible = Toggles.sacirc.Value
        else
            sa.FOVVisible = false
        end
    end
})

comSil:AddSlider("silfov", {
    Text = "Field Of View",
    Default = 130,
    Min = 1,
    Max = 250,
    Rounding = 0,
    Callback = function(val) 
        sa.FOVRadius = val
    end
})

comSil:AddDropdown("silmet", {
    Values = {"Raycast", "FindPartOnRay", "FindPartOnRayWithWhitelist", "FindPartOnRayWithIgnoreList", "Mouse.Hit/Target"},
    Text = "Method",
    Default = 1,
    Callback = function(val) 
        sa.SilentAimMethod = val
    end
})

comSil:AddDropdown("silhitb", {
    Values = {"Head", "HumanoidRootPart"},
    Text = "Hitbox",
    Default = 1,
    Callback = function(val)
        sa.TargetPart = val 
    end
})

comSil:AddDropdown("sachecks", {
    Values = {"Team Check", "Visible Check"},
    Text = "Bullet Redirection Checks",
    Multi = true,
    Default = 1,
    Callback = function(val)
        sa.TeamCheck = val["Team Check"]
        sa.VisibleCheck = val["Visible Check"]
    end
})

comSil:AddSlider("hitc", {
    Text = "Hit Chance",
    Default = 100,
    Min = 1,
    Max = 100,
    Rounding = 0,
    Callback = function(val) 
        sa.HitChance = val
    end
})

comSil:AddToggle("predictog", {
    Text = "Mouse.Hit/Target Prediction",
    Default = false,
    Risky = false,
    Callback = function(val) 
        sa.MouseHitPrediction = val
    end
})

comSil:AddSlider("predic", {
    Text = "Prediction Amount",
    Default = 0.165,
    Min = 0.001,
    Max = 1,
    Rounding = 3,
    Callback = function(val) 
        sa.MouseHitPredictionAmount = val
    end
})

local visEspBox = Tabs.Visuals:AddLeftTabbox()
local visEsp = visEspBox:AddTab("ESP")
local visEspSet = visEspBox:AddTab("Settings")

visEsp:AddToggle("esptog", {
    Text = "Enabled",
    Default = false,
    Risky = false,
    Callback = function(val)
        esp.Enabled = val
    end
})

visEsp:AddDropdown("espelem", {
    Values = {"Text", "Box", "Health Bar", "Chams", "Skeleton"},
    Default = 1,
    Text = "Element To Change",
    Callback = function() end
})

visEspSet:AddToggle("teamcheck", {
    Text = "Team Check",
    Default = false,
    Risky = false,
    Callback = function(val)
        esp.TeamCheck = val
    end
})

visEspSet:AddToggle("fadeout", {
    Text = "Fade Out On Distance",
    Default = false,
    Risky = false,
    Callback = function(val)
        esp.FadeOut.OnDistance = val
    end
})

visEspSet:AddDivider()

visEspSet:AddDropdown("font", {
    Values = {"ProggyClean", "SmallestPixel", "Minecraftia", "Verdana", "VerdanaBold", "Tahoma", "TahomaBold"},
    Text = "Font",
    Default = 1,
    Callback = function(val)
        esp.Names.Font = val
        esp.Distances.Font = val
        esp.Weapons.Font = val
        esp.HealthBar.Font = val
    end
})

visEspSet:AddSlider("fontsize", {
    Text = "Font Size",
    Default = 11,
    Min = 1,
    Max = 25,
    Rounding = 0,
    Callback = function(val)
        esp.Names.FontSize = val
        esp.Distances.FontSize = val
        esp.Weapons.FontSize = val
        esp.HealthBar.FontSize = val
    end
})

visEspSet:AddSlider("maxdist", {
    Text = "Max Distance",
    Default = 200,
    Min = 1,
    Max = 5000,
    Rounding = 0,
    Callback = function(val)
        esp.MaxDistance = val
    end
})

visEspSet:AddSlider("rainsp", {
    Text = "Rainbow Speed",
    Default = 2,
    Min = 1,
    Max = 10,
    Rounding = 0,
    Callback = function(val)
        esp.RainbowSpeed = val
    end
})

local visElem = Tabs.Visuals:AddRightGroupbox("ESP Element Settings")

local visText = visElem:AddDependencyBox()

visText:AddDropdown("texttog", {
    Values = {"Name", "Distance", "Weapon"},
    Text = "Text Elements To Show",
    Default = 1,
    Multi = true,
    Callback = function() 
        esp.Names.Enabled = Options.texttog.Value["Name"]
        esp.Distances.Enabled = Options.texttog.Value["Distance"]
        esp.Weapons.Enabled = Options.texttog.Value["Weapons"]
    end
})

visText:AddLabel("Name Color"):AddColorPicker("namecol", {
    Default = esp.Names.RGB,
    Title = "Name Color",
    Callback = function()
        -- checking toggle so the lib can access the values
        -- and not give me an error
        if Toggles.esptog.Value then
            esp.Names.RGB = Options.namecol.Value
        end
    end
})

visText:AddLabel("Distance Color"):AddColorPicker("distcol", {
    Default = esp.Distances.RGB,
    Title = "Distance Color",
    Callback = function()
        if Toggles.esptog.Value then
            esp.Distances.RGB = Options.distcol.Value
        end
    end
})

visText:AddLabel("Weapon Color"):AddColorPicker("weapcol", {
    Default = esp.Weapons.RGB,
    Title = "Weapon Color",
    Callback = function()
        if Toggles.esptog.Value then
            esp.Weapons.RGB = Options.weapcol.Value
        end
    end
})

visText:AddToggle("rainbowtext", {
    Text = "Rainbow Text Color",
    Default = false,
    Risky = false,
    Callback = function(val)
        esp.Names.Rainbow = val
        esp.Distances.Rainbow = val
        esp.Weapons.Rainbow = val
    end
})

visText:AddDivider()

visText:AddToggle("nametype", {
    Text = "Show Display Name Instead",
    Default = false,
    Risky = false,
    Callback = function(val)
        esp.Names.NameType = val and "Display Name" or "Regular"
    end
})

visText:AddDropdown("distpos", {
    Values = {"Text", "Bottom"},
    Default = 1,
    Text = "Distance Position",
    Callback = function(val)
        esp.Distances.Position = val
    end
})

visText:AddInput("distsuf", {
    Text = "Distance Suffix",
    Numeric = false,
    Finished = true,
    Default = "m",
    ClearTextOnFocus = false,
    Placeholder = "meters",
    Callback = function(val)
        esp.Distances.Suffix = val
    end
})

visText:SetupDependencies({
    {Options.espelem, "Text"}
})

local visBox = visElem:AddDependencyBox()

visBox:AddToggle("boxtog", {
    Text = "Enabled",
    Default = false,
    Risky = false,
    Callback = function(val)
        esp.Boxes.Enabled = val
    end
}):AddColorPicker("boxcol", {
    Default = col3rgb(255, 255, 255),
    Title = "Box Color",
    Callback = function()
        if Toggles.esptog.Value then
            esp.Boxes.RGB = Options.boxcol.Value
        end
    end
})

visBox:AddDropdown("boxtype", {
    Values = {"Full", "Corner"},
    Text = "Box Type",
    Default = 1,
    Callback = function(val)
        esp.Boxes.BoxType = val
    end
})

visBox:AddToggle("boxfill", {
    Text = "Filled",
    Default = false,
    Risky = false,
    Callback = function(val)
        esp.Boxes.Filled.Enabled = val
    end
}):AddColorPicker("boxfillcol", {
    Default = col3rgb(0, 0, 0),
    Transparency = 0.75,
    Title = "Fill Color",
    Callback = function()
        if Toggles.esptog.Value then
            esp.Boxes.Filled.RGB = Options.boxfillcol.Value
            esp.Boxes.Filled.Transparency = Options.boxfillcol.Transparency
        end
    end
})

visBox:AddToggle("boxgrad", {
    Text = "Gradient",
    Default = false,
    Risky = false,
    Callback = function(val)
        esp.Boxes.Gradient = val
    end
}):AddColorPicker("boxgradcol1", {
    Default = col3rgb(119, 120, 255),
    Title = "Gradient Color 1",
    Callback = function()
        if Toggles.esptog.Value then
            esp.Boxes.GradientRGB1 = Options.boxgradcol1.Value
        end
    end
}):AddColorPicker("boxgradcol2", {
    Default = col3rgb(0, 0, 0),
    Title = "Gradient Color 2",
    Callback = function()
        if Toggles.esptog.Value then
            esp.Boxes.GradientRGB2 = Options.boxgradcol2.Value
        end
    end
})

visBox:AddToggle("boxanim", {
    Text = "Animate",
    Default = false,
    Risky = false,
    Callback = function(val)
        esp.Boxes.Animate = val
    end
})

visBox:AddSlider("boxanimspeed", {
    Text = "Animation Speed",
    Default = 300,
    Min = 1,
    Max = 2500,
    Rounding = 0,
    Callback = function(val)
        esp.Boxes.RotationSpeed = val
    end
})

visBox:SetupDependencies({
    {Options.espelem, "Box"}
})

local visHp = visElem:AddDependencyBox()

visHp:AddToggle("hptog", {
    Text = "Enabled",
    Default = false,
    Risky = false,
    Callback = function(val)
        esp.HealthBar.Enabled = val
    end
}):AddColorPicker("hpcol", {
    Default = col3rgb(0, 255, 0),
    Title = "Health Bar Color",
    Callback = function()
        if Toggles.esptog.Value then
            esp.HealthBar.RGB = Options.hpcol.Value
        end
    end
})

visHp:AddToggle("hprainbow", {
    Text = "Rainbow Health Bar Color",
    Default = false,
    Risky = false,
    Callback = function(val)
        esp.HealthBar.Rainbow = val
    end
})

visHp:AddDivider()

visHp:AddToggle("hptext", {
    Text = "Show Health Text",
    Default = false,
    Risky = false,
    Callback = function(val)
        esp.HealthBar.HealthText = val
    end
}):AddColorPicker("hptextcol", {
    Default = col3rgb(255, 255, 255),
    Title = "Health Text Color",
    Callback = function()
        if Toggles.esptog.Value then
            esp.HealthBar.HealthTextRGB = Options.hptextcol.Value
        end
    end
})

visHp:AddDropdown("hptextpos", {
    Values = {"Left", "Follow Bar"},
    Text = "Health Text Position",
    Default = 1,
    Callback = function(val)
        esp.HealthBar.HealthTextPosition = val
    end
})

visHp:AddToggle("hplerp", {
    Text = "Lerp",
    Default = false,
    Tooltip = "Changes health bar color based on the enemy\'s current health.",
    Risky = false,
    Callback = function(val)
        esp.HealthBar.Lerp = val
    end
})

visHp:AddToggle("hpgrad", {
    Text = "Gradient",
    Default = false,
    Risky = false,
    Callback = function(val)
        esp.HealthBar.Gradient = val
    end
}):AddColorPicker("hpgradcol1", {
    Default = col3rgb(200, 0, 0),
    Title = "Gradient Color 1",
    Callback = function()
        if Toggles.esptog.Value then
            esp.HealthBar.GradientRGB1 = Options.hpgradcol1.Value
        end
    end
}):AddColorPicker("hpgradcol2", {
    Default = col3rgb(60, 60, 125),
    Title = "Gradient Color 2",
    Callback = function()
        if Toggles.esptog.Value then
            esp.HealthBar.GradientRGB2 = Options.hpgradcol2.Value
        end
    end
}):AddColorPicker("hpgradcol3", {
    Default = col3rgb(119, 129, 255),
    Title = "Gradient Color 3",
    Callback = function()
        if Toggles.esptog.Value then
            esp.HealthBar.GradientRGB3 = Options.hpgradcol3.Value
        end
    end
})

visHp:AddToggle("hpgradrain", {
    Text = "Rainbow Gradient",
    Default = false,
    Risky = false,
    Callback = function(val)
        esp.HealthBar.RainbowGradient = val
    end
})

visHp:AddSlider("hpwidth", {
    Text = "Width",
    Default = 2.5,
    Min = 0.1,
    Max = 5,
    Rounding = 1,
    Callback = function(val)
        esp.HealthBar.Width = val
    end
})

visHp:SetupDependencies({
    {Options.espelem, "Health Bar"}
})

local visChams = visElem:AddDependencyBox()

visChams:AddToggle("chamtog", {
    Text = "Enabled",
    Default = false,
    Risky = false,
    Callback = function(val)
        esp.Chams.Enabled = val
    end
}):AddColorPicker("chamfillcol", {
    Default = col3rgb(119, 129, 255),
    Title = "Fill Color",
    Transparency = 0,
    Callback = function()
        if Toggles.esptog.Value then
            esp.Chams.FillRGB = Options.chamfillcol.Value
            esp.Chams.FillTransparency = 100 - Options.chamfillcol.Transparency * 100
        end
    end
}):AddColorPicker("chamoutcol", {
    Default = col3rgb(119, 129, 255),
    Title = "Outline Color",
    Transparency = 0,
    Callback = function()
        if Toggles.esptog.Value then
            esp.Chams.OutlineRGB = Options.chamoutcol.Value
            esp.Chams.OutlineTransparency = 100 - Options.chamoutcol.Transparency * 100
        end
    end
})

visChams:AddToggle("chamfillrain", {
    Text = "Rainbow Fill Color",
    Default = false,
    Risky = false,
    Callback = function(val)
        esp.Chams.RainbowFill = val
    end
})

visChams:AddToggle("chamoutrain", {
    Text = "Rainbow Outline Color",
    Default = false,
    Risky = false,
    Callback = function(val)
        esp.Chams.RainbowOutline = val
    end
})

visChams:AddToggle("chamvis", {
    Text = "Visible Check",
    Default = false,
    Risky = false,
    Callback = function(val)
        esp.Chams.VisibleCheck = val
    end
})

visChams:AddToggle("chamanim", {
    Text = "Animate",
    Default = false,
    Risky = false,
    Callback = function(val)
        esp.Chams.Thermal = val
    end
})

visChams:SetupDependencies({
    {Options.espelem, "Chams"}
})

local visSkel = visElem:AddDependencyBox()

visSkel:AddToggle("skeltog", {
    Text = "Enabled",
    Default = false,
    Risky = false,
    Callback = function(val)
        esp.Skeleton.Enabled = val
    end
}):AddColorPicker("skelcol", {
    Default = col3rgb(255, 255, 255),
    Title = "Skeleton Color",
    Transparency = 0,
    Callback = function()
        if Toggles.esptog.Value then
            esp.Skeleton.RGB = Options.skelcol.Value
            esp.Skeleton.Transparency = Options.skelcol.Transparency
        end
    end
})

visSkel:AddToggle("skelrain", {
    Text = "Rainbow Skeleton Color",
    Default = false,
    Risky = false,
    Callback = function(val)
        esp.Skeleton.Rainbow = val
    end
})

visSkel:AddSlider("skelthick", {
    Text = "Thickness",
    Default = 1,
    Min = 0.1,
    Max = 5,
    Rounding = 1,
    Callback = function(val)
        esp.Skeleton.Thickness = val
    end
})

visSkel:SetupDependencies({
    {Options.espelem, "Skeleton"}
})

local visTabbox = Tabs.Visuals:AddLeftTabbox()
local visWorld = visTabbox:AddTab("World")
local visChar = visTabbox:AddTab("Self")
local visFov = visTabbox:AddTab("FOVs")

visWorld:AddToggle("shadows", {
    Text = "Show Shadows",
    Default = true,
    Risky = false,
    Callback = function(val)
        lighting.GlobalShadows = val
    end
})

visWorld:AddToggle("ambience", {
    Text = "Change Ambience",
    Default = false,
    Risky = false,
    Callback = function(val)
        if val then
            lighting.Ambient = Options.ambient.Value
            lighting.OutdoorAmbient = Options.outambient.Value
        else
            lighting.Ambient = default.Lighting.Ambient
            lighting.OutdoorAmbient = default.Lighting.OutdoorAmbient
        end
    end
}):AddColorPicker("ambient", {
    Default = default.Lighting.Ambient,
    Title = "Ambient Color",
    Callback = function()
        if Toggles.ambience.Value then
            lighting.Ambient = Options.ambient.Value
        end
    end
}):AddColorPicker("outambient", {
    Default = default.Lighting.OutdoorAmbient,
    Title = "Outdoor Ambient Color",
    Callback = function()
        if Toggles.ambience.Value then
            lighting.OutdoorAmbient = Options.outambient.Value
        end
    end
})

visWorld:AddToggle("colshift", {
    Text = "Change Color Shift",
    Default = false,
    Risky = false,
    Callback = function(val)
        if val then
            lighting.ColorShift_Bottom = Options.bottomcs.Value
            lighting.ColorShift_Top = Options.topcs.Value
        else
            lighting.ColorShift_Bottom = default.Lighting.ColorShift_Bottom
            lighting.ColorShift_Top = default.Lighting.ColorShift_Top
        end
    end
}):AddColorPicker("bottomcs", {
    Default = default.Lighting.ColorShift_Bottom,
    Title = "Bottom Color Shift Color",
    Callback = function()
        if Toggles.colshift.Value then
            lighting.ColorShift_Bottom = Options.bottomcs.Value
        end
    end
}):AddColorPicker("topcs", {
    Default = default.Lighting.ColorShift_Top,
    Title = "Top Color Shift Color",
    Callback = function()
        if Toggles.colshift.Value then
            lighting.ColorShift_Top = Options.topcs.Value
        end
    end
})

visWorld:AddToggle("atmos", {
    Text = "Change Atmosphere",
    Default = false,
    Risky = false,
    Callback = function(val)
        if val then
            lighting.Atmosphere.Color = Options.atmoscol.Value
            lighting.Atmosphere.Decay = Options.decaycol.Value
        else
            lighting.Atmosphere.Color = default.Lighting.Atmosphere.Color
            lighting.Atmosphere.Decay = default.Lighting.Atmosphere.Decay
        end
    end
}):AddColorPicker("atmoscol", {
    Default = default.Lighting.Atmosphere.Color,
    Title = "Atmosphere Color",
    Callback = function()
        if Toggles.atmos.Value then
            lighting.Atmosphere.Color = Options.atmoscol.Value
        end
    end
}):AddColorPicker("decaycol", {
    Default = default.Lighting.Atmosphere.Decay,
    Title = "Decay Color",
    Callback = function()
        if Toggles.atmos.Value then
            lighting.Atmosphere.Decay = Options.decaycol.Value
        end
    end
})

visWorld:AddDivider()

visWorld:AddSlider("clocktime", {
    Text = "Clock Time",
    Default = default.Lighting.ClockTime,
    Min = 0,
    Max = 23,
    Rounding = 0,
    Callback = function(val)
        lighting.ClockTime = val 
    end
})

visWorld:AddSlider("bright", {
    Text = "Brightness",
    Default = default.Lighting.Brightness,
    Min = 0,
    Max = 10,
    Rounding = 1,
    Callback = function(val)
        lighting.Brightness = val 
    end
})

visWorld:AddSlider("glare", {
    Text = "Glare", 
    Default = 0,
    Min = 0,
    Max = 10,
    Rounding = 1,
    Callback = function(val)
        lighting.Atmosphere.Glare = val
    end
})

visWorld:AddSlider("haze", {
    Text = "Haze", 
    Default = 0,
    Min = 0,
    Max = 10,
    Rounding = 2,
    Callback = function(val)
        lighting.Atmosphere.Haze = val
    end
})

visWorld:AddDropdown("tech", {
    Values = {"Compatibility", "Future", "Legacy", "ShadowMap", "Unified", "Voxel"},
    Default = 6,
    Text = "Technology",
    Callback = function(val)
        lighting.Technology = val
    end
})

visWorld:AddDropdown("skybox", {
    Values = {"Default", "Nebula", "Vaporwave", "Clouds", "Twilight", "Pink Vision", "Blue Sky", "Green Sky", "Night Sky", "Pink Daylight", "Morning Glow", "Fade Blue", "Neptune", "Redshift"},
    Default = 1,
    Text = "Skybox",
    Callback = function(val)
        applyskybox(val)
    end
})

visChar:AddToggle("charchams", {
    Text = "Self Chams",
    Default = false,
    Risky = false,
    Tooltip = "Modifies your character's appearance.\nChange rainbow saturation through the colorpicker.",
    Callback = function() end
}):AddColorPicker("chamcol", {
    Title = "Cham Color",
    Default = col3rgb(130, 168, 255),
    Transparency = 0,
    Callback = function() end
})

visChar:AddToggle("chamrain", {
    Text = "Rainbow Chams",
    Default = false,
    Risky = false,
    Callback = function() end
})

visChar:AddSlider("chamrainsp", {
    Text = "Rainbow Speed",
    Default = 75,
    Min = 1,
    Max = 500,
    Rounding = 0,
    Callback = function() end
})

visChar:AddToggle("thirdp", {
    Text = "Third Person",
    Default = false,
    Tooltip = "Third person for games that don't let you play in third person mode.\nDo not enable otherwise.",
    Callback = function(val)
        lplr.CameraMode = val and Enum.CameraMode.Classic or Enum.CameraMode.LockFirstPerson
        lplr.CameraMaxZoomDistance = Options.tpdist.Value
        lplr.CameraMinZoomDistance = Options.tpdist.Value
    end
}):AddKeyPicker("tpkey", {
    Default = "X",
    Mode = "Toggle",
    Text = "Third Person",
    SyncToggleState = true,
    Callback = function(val)
        lplr.CameraMode = val and Enum.CameraMode.Classic or Enum.CameraMode.LockFirstPerson
    end
})

visChar:AddSlider("tpdist", {
    Text = "Third Person Distance",
    Default = 10,
    Min = 0.1,
    Max = 30,
    Rounding = 1,
    Callback = function(val)
        lplr.CameraMaxZoomDistance = val
        lplr.CameraMinZoomDistance = val
    end
})

visChar:AddSlider("fieldofview", {
    Text = "Field Of View",
    Default = default.Camera.FieldOfView,
    Min = 1,
    Max = 120,
    Rounding = 0,
    Callback = function(val)
        cam.FieldOfView = val
    end 
})

visFov:AddToggle("aimcirc", {
    Text = "AA FOV Circle",
    Default = false,
    Risky = false,
    Callback = function() end
}):AddColorPicker("aimcirccol", {
    Title = "Circle Color",
    Default = col3rgb(93, 62, 152),
    Transparency = 0,
    Callback = function() end
})

visFov:AddToggle("deadcirc", {
    Text = "Deadzone FOV Circle",
    Default = false,
    Risky = false,
    Callback = function(val) 
        setrenderproperty(deadcircle, "Visible", val)
    end
}):AddColorPicker("deadcirccol", {
    Title = "Circle Color",
    Default = col3rgb(255, 0, 0),
    Transparency = 0,
    Callback = function() end
})

visFov:AddToggle("sacirc", {
    Text = "BR FOV Circle",
    Default = false,
    Risky = false,
    Callback = function(val) 
        if sa.Enabled then
            sa.FOVVisible = val
        else
            sa.FOVVisible = false
        end
    end
}):AddColorPicker("sacirccol", {
    Title = "Circle Color",
    Default = col3rgb(103, 232, 255),
    Callback = function(val) 
        if Toggles.sacirc.Value then
            sa.FOVColor = val
        end
    end
})

local miscMove = Tabs.Misc:AddLeftGroupbox('Movement')

miscMove:AddToggle("autojump", {
    Text = "Automatic Jump",
    Default = false,
    Risky = false,
    Tooltip = "Makes your character automatically jump when holding spacebar.\nUseful for games that have a jumping cooldown.",
    Callback = function() end
})

miscMove:AddToggle("modws", {
    Text = "Modify Walkspeed",
    Default = false,
    Risky = false,
    Tooltip = "Modifies your walking speed.\nCFrame walkspeed will break with desync on.",
    Callback = function(val)
        local plralive, char = alive()

        if plralive and not val and char.Humanoid.WalkSpeed ~= 16 then
            char.Humanoid.WalkSpeed = 16
        end
    end
}):AddKeyPicker("wskey", {
    Text = "Modify Walkspeed",
    Default = "C",
    SyncToggleState = true,
    Mode = "Toggle",
    Callback = function() end
})

miscMove:AddDropdown("wstype", {
    Text = "Walkspeed Type",
    Values = {"Normal", "CFrame"},
    Default = 1,
    Callback = function() end
})

miscMove:AddSlider("wsamount", {
    Text = "Walkspeed Amount",
    Default = 16,
    Min = 1,
    Max = 200,
    Rounding = 0,
    Callback = function() end
})

miscMove:AddSlider("cfwsamount", {
    Text = "CFrame Walkspeed Amount",
    Default = 5,
    Min = 1,
    Max = 200,
    Rounding = 0,
    Callback = function() end
})

miscMove:AddToggle("fly", {
    Text = "Fly",
    Default = false,
    Risky = true,
    Callback = function() end
}):AddKeyPicker("flykey", {
    Text = "Fly",
    Default = "L",
    SyncToggleState = true,
    Mode = "Toggle",
    Callback = function() end
})

miscMove:AddSlider("flyspeed", {
    Text = "Fly Speed",
    Default = 50,
    Min = 1,
    Max = 300,
    Rounding = 0,
    Callback = function() end
})

local miscExp = Tabs.Misc:AddRightGroupbox("Exploits")

miscExp:AddToggle("desync", {
    Text = "Enable Desync",
    Default = false,
    Risky = true,
    Tooltip = "Manipulates your server position, while making you able to play normally.",
    Callback = function() end
}):AddKeyPicker("desynckey", {
    Text = "Desync",
    Default = "V",
    SyncToggleState = true,
    Mode = "Toggle",
    Callback = function() end
})

miscExp:AddDropdown("desynctype", {
    Text = "Desync Type",
    Values = {"None", "Invisible", "Underground", "Zero", "Sky"},
    Default = 1,
    Callback = function() end
})

miscExp:AddToggle("delay", {
    Text = "Delay Position",
    Default = false,
    Risky = false,
    Callback = function() end
})

miscExp:AddSlider("delayoff", {
    Text = "Delay Offset (frames)",
    Default = 1,
    Min = 1,
    Max = 250,
    Rounding = 0,
    Callback = function() end
})

--[[miscExp:AddToggle("blockpos", {
    Text = "Block Position Update",
    Default = false,
    Risky = false,
    Tooltip = "Blocks any updates for your server position.",
    Callback = function() end
}):AddKeyPicker("blockposkey", {
    Text = "Block Position Update",
    Default = "Z",
    Mode = "Toggle",
    SyncToggleState = true,
    Callback = function() end
})]]

local miscOther = Tabs.Misc:AddLeftGroupbox("Other")

miscOther:AddToggle("noclip", {
    Text = "Noclip",
    Default = false,
    Risky = true,
    Callback = function(val) 
        for _, ncpart in noclipparts do
            if not val then
                ncpart.CanCollide = true
            end
        end
    end
}):AddKeyPicker("noclipkey", {
    Text = "Noclip",
    Default = "J",
    SyncToggleState = true,
    Mode = "Toggle",
    Callback = function() end
})

miscOther:AddToggle("spin", {
    Text = "Spin",
    Default = false,
    Risky = false,
    Callback = function() end
})

miscOther:AddSlider("spinspeed", {
    Text = "Spin Speed",
    Default = 10,
    Min = 1,
    Max = 200,
    Rounding = 0,
    Callback = function() end
})

------- code below is taken from atlanta (gamesneeze), thx matas 

local function ThreadFunction(Func, Name, ...)
        local Func = Name and function()
            local Passed, Statement = pcall(Func)
            --
            if not Passed and Statement ~= nil then
                warn("Error! Info:\n", "              " .. Name .. ":", Statement)
            end
        end or Func
        local Thread = coroutine.create(Func)
        --
        coroutine.resume(Thread, ...)
        return Thread
    end

function Atlanta:GetCharacter(Player)
        return Player.Character
    end
    --
    function Atlanta:GetHumanoid(Player, Character)
        return ffcoc(Character, "Humanoid")
    end
    --
    function Atlanta:GetHealth(Player, Character, Humanoid)
        if Humanoid then
            return clamp(Humanoid.Health, 0, Humanoid.MaxHealth), Humanoid.MaxHealth
        end
    end
    --
    function Atlanta:GetRootPart(Player, Character, Humanoid)
        return Humanoid.RootPart
    end

function Atlanta:CheckTeam(Player1, Player2)
    return Player1.Team ~= Player2.Team
end
--
function Atlanta:GetIgnore(Unpacked)
    return
end

function Atlanta:ClientAlive(Player, Character, Humanoid)
        local Health, MaxHealth = Atlanta:GetHealth(Player, Character, Humanoid)
        --
        return (Health > 0)
    end
    --
    function Atlanta:ValidateClient(Player)
        local Object = Atlanta:GetCharacter(Player)
        local Humanoid = (Object and Atlanta:GetHumanoid(Player, Object))
        local RootPart = (Humanoid and Atlanta:GetRootPart(Player, Object, Humanoid))
        --
        return Object, Humanoid, RootPart
    end

function Atlanta:GetOrigin(Origin)
        if Origin == "Head" then
            local Object, Humanoid, RootPart = Atlanta:ValidateClient(lplr)
            local Head = ffc(Object, "Head")
            --
            if Head and isa(Head, "RootPart") then
                return Head.CFrame.Position
            end
        elseif Origin == "Torso" then
            local Object, Humanoid, RootPart = Atlanta:ValidateClient(lplr)
            --
            if RootPart then
                return RootPart.CFrame.Position
            end
        end
        --
        return cam.CFrame.Position
    end

function Atlanta:GetBodyParts(Character, RootPart, Indexes, Hitboxes)
        local Parts = {}
        local Hitboxes = Hitboxes or {"Head", "Torso", "Arms", "Legs"}
        --
        for Index, Part in pairs(Character:GetChildren()) do
            if isa(Part, "BasePart") and Part ~= RootPart then
                if Hitboxes["Head"] and Part.Name:lower():find("head") then
                    Parts[Indexes and Part.Name or #Parts + 1] = Part
                elseif Hitboxes["Torso"] and Part.Name:lower():find("torso") then
                    Parts[Indexes and Part.Name or #Parts + 1] = Part
                elseif Hitboxes["Arms"] and Part.Name:lower():find("arm") then
                    Parts[Indexes and Part.Name or #Parts + 1] = Part
                elseif Hitboxes["Legs"] and Part.Name:lower():find("leg") then
                    Parts[Indexes and Part.Name or #Parts + 1] = Part
                elseif (Hitboxes["Arms"] and Part.Name:lower():find("hand")) or (Hitboxes["Legs"] and Part.Name:lower():find("foot")) then
                    Parts[Indexes and Part.Name or #Parts + 1] = Part
                end
            end
        end
        --
        return Parts
    end

function Atlanta:RayCast(Part, Origin, Ignore, Distance)
        local Ignore = Ignore or {}
        local Distance = Distance or 2000
        --
        local Cast = ray(Origin, (Part.Position - Origin).Unit * Distance)
        local Hit = fporwil(workspace, Cast, Ignore)
        --
        return (Hit and isdof(Hit, Part.Parent)) == true, Hit
    end

function Atlanta:GetAimAssistTarget()
        local Target = {
            Player = nil,
            Object = nil,
            Part = nil,
            Vector = nil,
            Magnitude = huge
        }
        --
        local MouseLocation = mouseloc(uis)
        --
        local Randomise = Toggles.randhb.Value
        local Origin = Options.wallcheckor.Value
        local FOVType = Options.fovtype.Value
        local FieldOfView = Options.aimfov.Value
        local Deadzone = Options.deadzone.Value
        local Hitboxes = Options.hitb.Value
        local Checks = Options.aimchecks.Value
        local Dynamic = Options.dyn.Value * 25
        --
        local Disabled = FieldOfView == 100
        local FieldOfView = Atlanta.Locals.AimAssistFOV / 2
        local Disabled2 = Deadzone == 100
        local Deadzone = Atlanta.Locals.DeadzoneFOV / 2
        --
        local DynamicHigh = Dynamic * 2
        local DynamicLow = Dynamic / 8.5
        --
        local PossibleTarget = {
            Player = nil,
            Object = nil,
            Magnitude = huge
        }
        --
        for Index, Player in pairs(plrs:GetPlayers()) do
            if Player ~= lplr then
                if (Checks["Team Check"] and not Atlanta:CheckTeam(lplr, Player)) then continue end
                --
                local Object, Humanoid, RootPart = Atlanta:ValidateClient(Player)
                --
                if (Object and Humanoid and RootPart) then
                    if (Checks["Forcefield Check"] and ffcoc(Object, "ForceField")) then continue end
                    if (Checks["Alive Check"] and not Atlanta:ClientAlive(Player, Character, Humanoid)) then continue end
                    --
                    local Position, Visible = wtvp(cam, RootPart.CFrame.Position)
                    local Position2 = vec2(Position.X, Position.Y)
                    local Magnitude = (MouseLocation - Position2).Magnitude
                    local Distance = (cam.CFrame.Position - RootPart.CFrame.Position).Magnitude
                    local SelfAimAssistFOV = FieldOfView
                    local SelfDeadzoneFOV = Deadzone
                    local SelfMultiplier = 1
                    --
                    if FOVType == "Dynamic" then
                        SelfMultiplier = (Distance - DynamicLow) > 0 and (1 - ((Distance - DynamicLow) / Dynamic)) or (1 + (clamp(abs((Distance - DynamicLow) * 1.75), 0, DynamicHigh) / 100)) * 1.25
                    end
                    --
                    if Visible and Magnitude <= PossibleTarget.Magnitude then
                        PossibleTarget = {
                            Player = Player,
                            Object = Object,
                            Distance = Distance,
                            Multiplier = SelfMultiplier,
                            Magnitude = Magnitude
                        }
                    end
                    --
                    SelfAimAssistFOV = (SelfAimAssistFOV * SelfMultiplier)
                    SelfDeadzoneFOV = (SelfDeadzoneFOV * SelfMultiplier)
                    --
                    if ((not Disabled) and not (Magnitude <= SelfAimAssistFOV)) then continue end
                    --
                    if Visible and Magnitude <= Target.Magnitude then
                        local ClosestPart, ClosestVector, ClosestMagnitude = nil, nil, huge
                        --
                        for Index2, Part in pairs(Atlanta:GetBodyParts(Object, RootPart, false, Hitboxes)) do
                            if (Checks["Visible Check"] and not (Part.Transparency ~= 1)) then continue end
                            --
                            local HitboxPosition
                            --
                            if Randomise then
                                local HitboxSize = Part.Size / 2
                                --
                                HitboxPosition = Part.CFrame.Position + vec3(rand(1, HitboxSize.X), rand(1, HitboxSize.Y), rand(1, HitboxSize.Z))
                            else
                               HitboxPosition = Part.CFrame.Position
                            end
                            --
                            local Position3, Visible2 = wtvp(cam, HitboxPosition)
                            local Position4 = vec2(Position3.X, Position3.Y)
                            local Magnitude2 = (MouseLocation - Position4).Magnitude
                            --
                            if Position4 and Visible2 then
                                if ((not Disabled) and not (Magnitude2 <= SelfAimAssistFOV)) then continue end
                                if (Checks["Wall Check"] and not Atlanta:RayCast(Part, Atlanta:GetOrigin(Origin), {Atlanta:GetCharacter(lplr), Atlanta:GetIgnore(true)})) then continue end
                                --
                                if Magnitude2 <= ClosestMagnitude then
                                    ClosestPart = Part
                                    ClosestVector = Position4
                                    ClosestMagnitude = Magnitude2
                                end
                            end
                        end
                        --
                        if ClosestPart and ClosestVector and ClosestMagnitude then
                            Target = {
                                Player = Player,
                                Object = Object,
                                Part = ClosestPart,
                                Vector = ClosestVector,
                                Distance = Distance,
                                Multiplier = SelfMultiplier,
                                Magnitude = ClosestMagnitude
                            }
                        end
                    end
                end
            end
        end
        --
        if Target.Player and Target.Object and Target.Part and Target.Vector and Target.Magnitude then
            PossibleTarget = {
                Player = Target.Player,
                Object = Target.Object,
                Distance = Target.Distance,
                Multiplier = Target.Multiplier,
                Magnitude = Target.Magnitude
            }
            --
            Atlanta.Locals.Target = Target
        else
            Atlanta.Locals.Target = nil
        end
        --
        if PossibleTarget and PossibleTarget.Distance and PossibleTarget.Multiplier then
            Atlanta.Locals.PossibleTarget = PossibleTarget
        else
            Atlanta.Locals.PossibleTarget = nil
        end
    end
    --
    function Atlanta:GetTriggerBotTarget()
        local Targets = {}
        --
        local MouseLocation = mouseloc(uis)
        --
        local Hitboxes = Options.hitb1.Value
        local Checks = Options.trigcheck.Value
        local Origin = Options.wallcheckor1.Value
        --
        for Index, Player in pairs(plrs:GetPlayers()) do
            if Player ~= lplr then
                if (Checks["Team Check"] and not Atlanta:CheckTeam(lplr, Player)) then continue end
                --
                local Object, Humanoid, RootPart = Atlanta:ValidateClient(Player)
                --
                if (Object and Humanoid and RootPart) then
                    if (Checks["Forcefield Check"] and ffcoc(Object, "ForceField")) then continue end
                    if (Checks["Alive Check"] and not Atlanta:ClientAlive(Player, Character, Humanoid)) then continue end
                    --
                    for Index2, Part in pairs(Atlanta:GetBodyParts(Object, RootPart, false, Hitboxes)) do
                        if (Checks["Visible Check"] and not (Part.Transparency ~= 1)) then continue end
                        if (Checks["Wall Check"] and not Atlanta:RayCast(Part, Atlanta:GetOrigin(Origin), {Atlanta:GetCharacter(lplr), Atlanta:GetIgnore(true)})) then continue end
                        --
                        Targets[#Targets + 1] = Part
                    end
                end
            end
        end
        --
        local PointRay = vptr(cam, MouseLocation.X, MouseLocation.Y, 0)
        local Hit, Position, Normal, Material = fporwwl(workspace, ray(PointRay.Origin, PointRay.Direction * 1000), Targets, false, false)
        --
        if Hit then
            Atlanta.Locals.TriggerTarget = {
                Part = Hit,
                Position = Position,
                Material = Material
            }
        else
            Atlanta.Locals.TriggerTarget = nil
        end
    end
    --
    function Atlanta:AimAssist()
        if Atlanta.Locals.Target and Atlanta.Locals.Target.Part and Atlanta.Locals.Target.Vector then
            local Stutter = Options.stutter.Value
            local Deadzone = Options.deadzone.Value == 100
            local Humaniser = Toggles.humanizer.Value
            local DynamicSmoothing = Options.dynsm.Value
            local Multiplier = Atlanta.Locals.Target.Multiplier
            --
            if not ((not Stutter == 100) and not ((tick() - Atlanta.Locals.LastStutter) >= (Stutter / 1000))) and not ((not Deadzone) and not (Atlanta.Locals.Target.Magnitude >= ((Atlanta.Locals.DeadzoneFOV * Multiplier) / 2))) then
                Atlanta.Locals.LastStutter = tick()
                --
                local MouseLocation = mouseloc(uis)
                local MoveVector =  (Atlanta.Locals.Target.Vector - MouseLocation)
                local Smoothness = vec2((Options.horsm.Value / 2), (Options.versm.Value / 2))
                --
                if not DynamicSmoothing == 100 then
                    local SmoothingMultiplier = DynamicSmoothing
                    local SmoothnessMultplier = 1
                    --
                    if Multiplier <= 1 then
                        SmoothnessMultplier = 1 + ((1 - Multiplier) * SmoothingMultiplier)
                        --(Distance - DynamicLow) > 0 and (1 - ((Distance - DynamicLow) / Dynamic)) or (1 + (Clamp(Abs((Distance - DynamicLow) * 1.75), 0, DynamicHigh) / 100)) * 1.25
                    end
                end
                --
                local FinalVector = vec2(round(MoveVector.X / Smoothness.X), round(MoveVector.Y / Smoothness.Y))
                --
                if Humaniser and Atlanta.Locals.Humaniser.Sample then
                    local Delta = 25 / Atlanta.Locals.Target.Magnitude
                    --
                    if Delta <= 0.8 then
                        local Tick = tick()
                        local HumaniserSample = Atlanta.Locals.Humaniser.Sample[Atlanta.Locals.Humaniser.Index]
                        --
                        FinalVector = FinalVector + (vec2(HumaniserSample[1], HumaniserSample[2]) * Delta)
                        --
                        if (Tick - Atlanta.Locals.Humaniser.Tick) > 0.1 then
                            Atlanta.Locals.Humaniser.Tick = Tick
                            --
                            if (Atlanta.Locals.Humaniser.Index + 1) > #Atlanta.Locals.Humaniser.Sample then
                                Atlanta.Locals.Humaniser.Index = 1
                            else
                                Atlanta.Locals.Humaniser.Index = Atlanta.Locals.Humaniser.Index + 1
                            end
                        end
                    end
                end
                --
                mousemoverel(FinalVector.X, FinalVector.Y)
            end
        end
    end
    --
    function Atlanta:TriggerBot()
        if Atlanta.Locals.TriggerTarget then
            local Tick = tick()
            --
            local TriggerDelay = Options.trigdelay.Value
            local Interval = Options.trigint.Value
            --
            if not ((not Interval == 1000) and not ((Tick - Atlanta.Locals.TriggerTick) >= (Interval / 1000))) then
                Atlanta.Locals.TriggerTick = Tick
                --
                if not TriggerDelay == 500 then
                    task.delay(TriggerDelay / 1000, function()
                        mouse1press()
                        task.wait(0.05)
                        mouse1release()
                    end)
                else
                    mouse1press()
                    task.wait(0.05)
                    mouse1release()
                end
            end
        end
    end
    --
    function Atlanta:UpdateFieldOfView()
        local ScreenSize = cam.ViewportSize
        --
        local FieldOfView = Options.aimfov.Value
        local Deadzone = Options.deadzone.Value
        local Multiplier = (Atlanta.Locals.PossibleTarget and Atlanta.Locals.PossibleTarget.Multiplier or 1)
        --
        Atlanta.Locals.AimAssistFOV = ((FieldOfView / 100) * ScreenSize.Y)
        Atlanta.Locals.DeadzoneFOV = (Atlanta.Locals.AimAssistFOV * 0.9) * (Deadzone / 100)
        --
        Atlanta.Locals.VisualAimAssistFOV = (Atlanta.Locals.AimAssistFOV * Multiplier)
        Atlanta.Locals.VisualDeadzoneFOV = (Atlanta.Locals.DeadzoneFOV * Multiplier)
    end

local loop = rs.Heartbeat:Connect(function(dt)
    local lplralive, char = alive()
    local mousepos = mouseloc(uis)
    local desynctype = Options.desynctype.Value
    local fakecf = nil

    if Toggles.aimas.Value then
        ThreadFunction(Atlanta.UpdateFieldOfView, "2x01")
    end

    if Options.aimaskey:GetState() and not Options.readjkey:GetState() then
        ThreadFunction(Atlanta.GetAimAssistTarget, "2x02")
        ThreadFunction(Atlanta.AimAssist, "2x03")

        if Toggles.aimcirc.Value then
            setrenderproperty(aimcircle, "Visible", true)
            setrenderproperty(aimcircle, "Position", mousepos)
            setrenderproperty(aimcircle, "Radius", Atlanta.Locals.VisualAimAssistFOV / 2)
            setrenderproperty(aimcircle, "Color", Options.aimcirccol.Value)
            setrenderproperty(aimcircle, "Transparency", 1 - Options.aimcirccol.Transparency)
        end
    else
        setrenderproperty(aimcircle, "Visible", false)
        Atlanta.Locals.PossibleTarget = nil
        Atlanta.Locals.Target = nil
    end
    --
    if Options.trigkey:GetState() and not Options.readjkey:GetState() then
        ThreadFunction(Atlanta.GetTriggerBotTarget, "2x04")
        ThreadFunction(Atlanta.TriggerBot, "2x05")

        if Toggles.deadcirc.Value then
            setrenderproperty(deadcircle, "Position", mousepos)
            setrenderproperty(deadcircle, "Radius", Atlanta.Locals.VisualDeadzoneFOV / 2)
            setrenderproperty(deadcircle, "Color", Options.deadcirccol.Value)
            setrenderproperty(deadcircle, "Transparency", 1 - Options.deadcirccol.Transparency)
        end
    else
        Atlanta.Locals.TriggerTarget = nil
    end

    if lplralive then
        hrpcf = char.HumanoidRootPart.CFrame

        if Toggles.autojump.Value and keydown(uis, Enum.KeyCode.Space) and alive() then
            char.Humanoid.Jump = true
        end
    
        if Toggles.modws.Value then
            if Options.wstype.Value == "CFrame" then
                char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame + (char.Humanoid.MoveDirection * (Options.cfwsamount.Value / 100))
            else
                char.Humanoid.WalkSpeed = Options.wsamount.Value
            end
        end

        if Toggles.charchams.Value then
            chams.apply(Options.chamcol.Value, Options.chamcol.Transparency, Toggles.chamrain.Value)
        else
            chams.default()
        end

        if Toggles.desync.Value then
            if Toggles.delay.Value then
                fakecf = desync:getfakepos()
                desync.run(Options.delayoff.Value, hrpcf)
            else
                if desynctype == "Invisible" then
                    fakecf = cframe(9e9, 0/0, huge)
                elseif desynctype == "Underground" then
                    fakecf = hrpcf * cframe(0, -20, 0)
                elseif desynctype == "Zero" then
                    fakecf = cframe(0, 0, 0)
                elseif desynctype == "Sky" then
                    fakecf = hrpcf * cframe(0, 50, 0)
                else
                    fakecf = hrpcf
                end
            end

            char.HumanoidRootPart.CFrame = fakecf or hrpcf

            rs.RenderStepped:Wait()

            char.HumanoidRootPart.CFrame = hrpcf
        end

        if Toggles.fly.Value then
            local new = vec3(0, 0, 0)
            local lookvec = cam.CFrame.LookVector

            if keydown(uis, Enum.KeyCode.W) then
                new += lookvec
            end
            if keydown(uis, Enum.KeyCode.S) then
                new -= lookvec
            end
            if keydown(uis, Enum.KeyCode.D) then
                new += vec3(-lookvec.Z, 0, lookvec.X)
            end
            if keydown(uis, Enum.KeyCode.A) then
                new += vec3(lookvec.Z, 0, -lookvec.X)
            end
            if keydown(uis, Enum.KeyCode.Space) then
                new += vec3(0, 1, 0)
            end

            if new.Unit.X == new.Unit.X then
                char.HumanoidRootPart.Anchored = false
                char.HumanoidRootPart.Velocity = new.Unit * Options.flyspeed.Value
            else
                char.HumanoidRootPart.Anchored = true
                char.HumanoidRootPart.Velocity = vec3()
            end
        else
            if char.HumanoidRootPart.Anchored then
                char.HumanoidRootPart.Anchored = false
            end
        end

        if Toggles.noclip.Value then
            for _, part in char:GetChildren() do
                if (isa(part, "MeshPart") or part.Name == "HumanoidRootPart") and part.CanCollide == true then
                    if not table.find(noclipparts, part) then
                        table.insert(noclipparts, part)
                    end

                    part.CanCollide = false
                end
            end
        end

        if Toggles.spin.Value then
            spin = clamp(spin + round(Options.spinspeed.Value / 2), 0, 360)
            
            if spin == 360 then
                spin = 0
            end

            local camlook = cam.CFrame.LookVector
            local angle = -atan2(camlook.Z, camlook.X) + rad(spin)
            local endpos = cframe(char.HumanoidRootPart.Position) * angles(0, angle, 0)

            char.HumanoidRootPart.CFrame = rotatey(endpos)
        end
    end
end)

-- camera fix for desync
rs:BindToRenderStep("desync", 1, function()
    local plralive, char = alive()

    if alive() and Toggles.desync.Value then
        char.HumanoidRootPart.CFrame = hrpcf
    end
end)

--[[rs.PostSimulation:Connect(function()
    local plralive, char = alive()

    if Toggles.blockpos.Value and plralive then
        sethiddenproperty(char.HumanoidRootPart, "NetworkIsSleeping", true)
    end
end)]]

Library:SetWatermarkVisibility(false)

local FrameTimer = tick()
local FrameCounter = 0;
local FPS = 60;

local WatermarkConnection = game:GetService('RunService').RenderStepped:Connect(function()
	FrameCounter += 1;

	if (tick() - FrameTimer) >= 1 then
		FPS = FrameCounter;
		FrameTimer = tick();
		FrameCounter = 0;
	end;

    if Toggles.ShowWatermark.Value then
	    Library:SetWatermark(('euphoria | %s fps | %s ms | %s'):format(
		    floor(FPS),
		    floor(game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue()),
            os.date("%H:%M:%S")
        ));
    end
end);

Library:OnUnload(function()
	WatermarkConnection:Disconnect()
    loop:Disconnect()
	Library.Unloaded = true
end)

local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')

MenuGroup:AddToggle("KeybindMenuOpen", { Default = Library.KeybindFrame.Visible, Text = "Show Keybinds", Callback = function(value) Library.KeybindFrame.Visible = value end})
MenuGroup:AddToggle("ShowWatermark", { Default = false, Text = "Show Watermark", Callback = function(value) Library:SetWatermarkVisibility(value) end})
MenuGroup:AddToggle("ShowCustomCursor", {Text = "Custom Cursor", Default = true, Callback = function(Value) Library.ShowCustomCursor = Value end})
MenuGroup:AddToggle("RainbowTheme", {Text = "Rainbow Theme", Default = false})
MenuGroup:AddDivider()
MenuGroup:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", { Default = "RightShift", NoUI = true, Text = "Menu keybind" })
MenuGroup:AddButton("Unload", function() Library:Unload() end)

Library.ToggleKeybind = Options.MenuKeybind

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

SaveManager:IgnoreThemeSettings()

SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })

ThemeManager:SetFolder('MyScriptHub')
SaveManager:SetFolder('MyScriptHub/specific-game')
SaveManager:SetSubFolder('specific-place')

SaveManager:BuildConfigSection(Tabs['UI Settings'])
ThemeManager:ApplyToTab(Tabs['UI Settings'])

SaveManager:LoadAutoloadConfig()

rs.RenderStepped:Connect(function()
    local Registry = Window.Holder.Visible and Library.Registry or Library.HudRegistry
    for Idx, Object in next, Registry do
        for Property, ColorIdx in next, Object.Properties do
            if ColorIdx == "AccentColor" or ColorIdx == "AccentColorDark" then
                local Instance = Object.Instance
                local yPos = Instance.AbsolutePosition.Y

                local Mapped = Library:MapValue(yPos, 0, 1080, 0, 0.3) / 0.45
                local Color = col3hsv((Library.CurrentRainbowHue - Mapped) % 1, 0.59, 1)

                if ColorIdx == "AccentColorDark" then
                    Color = Library:GetDarkerColor(Color)
                end

                Instance[Property] = Toggles.RainbowTheme.Value and Color or Library.AccentColor
            end
        end
    end
end)
