-- Rotware Hub - Glitchy Red Brainrot Features
local Luna = loadstring(game:HttpGet("https://raw.githubusercontent.com/Nebula-Softworks/Luna-Interface-Suite/refs/heads/master/source.lua", true))()

local Window = Luna:CreateWindow({
	Name = "Rotware ▸ Brainrot Scripthub",
	LogoID = nil,
	LoadingEnabled = true,
	LoadingTitle = "Loading Rotware...",
	LoadingSubtitle = "Brainrot Goes Red",
	ConfigSettings = {
		ConfigFolder = "RotwareHub"
	},
	KeySystem = false
})

-- Main Tab
local MainTab = Window:CreateTab({
	Name = "Main Features",
	Icon = "rocket_launch",
	ImageSource = "Material",
	ShowTitle = true
})

-- Section
MainTab:CreateSection("Brainrot Utilities")

-- 🌐 Anti-Kick
do
    local mt = getrawmetatable(game)
    local old = mt.__namecall
    setreadonly(mt, false)
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if method == "Kick" then return end
        return old(self, ...)
    end)
    setreadonly(mt, true)
end

-- 🚀 Walkspeed Bypass
local speedValue = 0
local RunService = game:GetService("RunService")
local plr = game:GetService("Players").LocalPlayer

local function applySpeed()
	if not plr.Character then return end
	local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
	if not humanoid then return end

	RunService:BindToRenderStep("RotwareSpeed", Enum.RenderPriority.Character.Value + 1, function()
		if speedValue > 0 and humanoid.MoveDirection.Magnitude > 0 then
			plr.Character:TranslateBy(humanoid.MoveDirection * speedValue * 0.2)
		end
	end)
end

plr.CharacterAdded:Connect(function()
	task.wait(1)
	applySpeed()
end)
if plr.Character then applySpeed() end

MainTab:CreateSlider({
	Name = "Walkspeed Bypass",
	Range = {0, 5},
	Increment = 0.1,
	CurrentValue = 0,
	Callback = function(val)
		speedValue = val
	end
}, "SpeedBypass")

-- 🕳️ Cloak (Invisible Cloak)
MainTab:CreateButton({
	Name = "Use Invisible Cloak",
	Description = "Forces cloak use if equipped",
	Callback = function()
		local cloak = plr.Character and plr.Character:FindFirstChild("Invisibility Cloak")
		if cloak and cloak:GetAttribute("SpeedModifier") == 2 then
			cloak.Parent = workspace
			Luna:Notification({
				Title = "Cloak Used",
				Content = "You are now invisible",
				Icon = "visibility_off",
				ImageSource = "Material"
			})
		else
			Luna:Notification({
				Title = "No Cloak Found",
				Content = "Equip the cloak manually first",
				Icon = "warning",
				ImageSource = "Material"
			})
		end
	end
})

-- 🧲 Steal Position (Teleport)
MainTab:CreateButton({
	Name = "Steal Position",
	Description = "TPs you to an underground point (can be used to steal)",
	Callback = function()
		local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
		if not hrp then return end
		local t = tick()
		while tick() - t < 1.2 do
			hrp.CFrame = CFrame.new(0, -500, 0)
			task.wait()
		end
	end
})

-- 🔴 ESP
local espActive = false
local espCache = {}

local function createESP(target)
	local char = target.Character
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	local gui = Instance.new("BillboardGui")
	gui.Name = "RotwareESP"
	gui.Adornee = hrp
	gui.Size = UDim2.new(0, 200, 0, 30)
	gui.StudsOffset = Vector3.new(0, 3, 0)
	gui.AlwaysOnTop = true

	local label = Instance.new("TextLabel")
	label.Text = target.DisplayName
	label.Size = UDim2.new(1, 0, 1, 0)
	label.TextColor3 = Color3.fromRGB(255, 50, 50)
	label.TextStrokeTransparency = 0
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.GothamBold
	label.TextScaled = true
	label.Parent = gui

	gui.Parent = hrp
	espCache[target] = gui
end

local function toggleESP(state)
	espActive = state
	for _, p in pairs(game:GetService("Players"):GetPlayers()) do
		if p ~= plr then
			if state then
				createESP(p)
			else
				if espCache[p] then
					espCache[p]:Destroy()
					espCache[p] = nil
				end
			end
		end
	end
end

MainTab:CreateToggle({
	Name = "Enable ESP (Glitch Red)",
	CurrentValue = false,
	Callback = toggleESP
}, "ESP")

-- 🐾 Pet Finder (simple log)
MainTab:CreateButton({
	Name = "Log All Pets",
	Description = "Prints pets found in ReplicatedStorage",
	Callback = function()
		local pets = {}
		for _, v in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
			if v:IsA("Model") and v.Name:lower():find("pet") then
				table.insert(pets, v.Name)
			end
		end
		warn("[Rotware] Pets found:\n", table.concat(pets, ", "))
	end
})

-- 🔁 Server Hop / Rejoin
local TeleportService = game:GetService("TeleportService")
local placeId = game.PlaceId

local ServerTab = Window:CreateTab({
	Name = "Server Tools",
	Icon = "dns",
	ImageSource = "Material",
	ShowTitle = true
})

ServerTab:CreateButton({
	Name = "Rejoin Server",
	Description = "Reconnects to current server",
	Callback = function()
		TeleportService:Teleport(placeId, plr)
	end
})

ServerTab:CreateButton({
	Name = "Server Hop",
	Description = "Joins a new server",
	Callback = function()
		local servers = {}
		local req = game:HttpGet("https://games.roblox.com/v1/games/"..placeId.."/servers/Public?sortOrder=Asc&limit=100")
		local decoded = game:GetService("HttpService"):JSONDecode(req)
		for _, v in pairs(decoded.data) do
			if v.playing < v.maxPlayers then
				table.insert(servers, v.id)
			end
		end
		if #servers > 0 then
			TeleportService:TeleportToPlaceInstance(placeId, servers[math.random(1, #servers)], plr)
		end
	end
})

-- Load Saved Config
Luna:LoadAutoloadConfig()
