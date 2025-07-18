local Luna = loadstring(game:HttpGet("https://raw.githubusercontent.com/Nebula-Softworks/Luna-Interface-Suite/refs/heads/master/source.lua", true))()

local Window = Luna:CreateWindow({
	Name = "Rotware - Brainrot Tools",
	LogoID = nil,
	LoadingEnabled = true,
	LoadingTitle = "Rotware",
	LoadingSubtitle = "Injecting Brainrot...",
	ConfigSettings = {
		ConfigFolder = "Rotware"
	},
	KeySystem = false,
})

local Tab = Window:CreateTab({
	Name = "Main",
	Icon = "bug_report",
	ImageSource = "Material",
	ShowTitle = true
})

Tab:CreateSection("Core Tools")

-- 🧠 Anti-Kick
do
	local mt = getrawmetatable(game)
	local old = mt.__namecall
	setreadonly(mt, false)
	mt.__namecall = newcclosure(function(self, ...)
		if getnamecallmethod() == "Kick" then return end
		return old(self, ...)
	end)
	setreadonly(mt, true)
end

-- 🚀 Walkspeed Bypass
local speedValue = 0
local humanoid
local speedConn

local function updateSpeed()
	local char = game.Players.LocalPlayer.Character
	if char and char:FindFirstChild("Humanoid") then
		humanoid = char.Humanoid
		if speedConn then speedConn:Disconnect() end
		speedConn = game:GetService("RunService").Heartbeat:Connect(function(dt)
			if speedValue > 0 and humanoid.MoveDirection.Magnitude > 0 then
				char:TranslateBy(humanoid.MoveDirection * dt * speedValue * 5)
			end
		end)
	end
end

game.Players.LocalPlayer.CharacterAdded:Connect(updateSpeed)
if game.Players.LocalPlayer.Character then updateSpeed() end

Tab:CreateSlider({
	Name = "Walkspeed Bypass",
	Range = {0, 10},
	Increment = 1,
	CurrentValue = 0,
	Callback = function(value)
		speedValue = value
	end
}, "Walkspeed")

-- 🕵️‍♂️ Invisibility Cloak
Tab:CreateButton({
	Name = "Toggle Invisibility Cloak",
	Description = "Drops the cloak to become invisible (must be equipped).",
	Callback = function()
		local char = game.Players.LocalPlayer.Character
		if char then
			local cloak = char:FindFirstChild("Invisibility Cloak")
			if cloak and cloak:GetAttribute("SpeedModifier") == 2 then
				cloak.Parent = workspace
				Luna:Notification({Title = "Rotware", Content = "Cloak dropped. You're invisible!"})
			else
				Luna:Notification({Title = "Rotware", Content = "Equip the cloak first!"})
			end
		end
	end
})

-- 📡 ESP (Glitchy Red)
local espEnabled = false
local espTable = {}

local function createESP(plr)
	if plr == game.Players.LocalPlayer then return end
	local char = plr.Character
	if not char or not char:FindFirstChild("HumanoidRootPart") then return end

	local tag = Instance.new("BillboardGui")
	tag.Name = "RotwareESP"
	tag.AlwaysOnTop = true
	tag.Size = UDim2.new(0, 200, 0, 40)
	tag.StudsOffset = Vector3.new(0, 3, 0)
	tag.Adornee = char:FindFirstChild("HumanoidRootPart")
	tag.Parent = char:FindFirstChild("HumanoidRootPart")

	local text = Instance.new("TextLabel", tag)
	text.Size = UDim2.new(1, 0, 1, 0)
	text.BackgroundTransparency = 1
	text.Text = plr.DisplayName
	text.TextColor3 = Color3.fromRGB(255, 50, 50)
	text.TextStrokeTransparency = 0
	text.TextStrokeColor3 = Color3.new(0, 0, 0)
	text.TextScaled = true
	text.Font = Enum.Font.GothamBold

	espTable[plr] = tag
end

local function clearESP()
	for _, v in pairs(espTable) do
		if v then v:Destroy() end
	end
	table.clear(espTable)
end

Tab:CreateToggle({
	Name = "ESP (Players)",
	CurrentValue = false,
	Callback = function(state)
		espEnabled = state
		clearESP()
		if espEnabled then
			for _, plr in pairs(game.Players:GetPlayers()) do
				if plr ~= game.Players.LocalPlayer then
					createESP(plr)
					plr.CharacterAdded:Connect(function()
						task.wait(1)
						createESP(plr)
					end)
				end
			end
		end
	end
}, "ESP")

-- ⚡ Steal Teleport
Tab:CreateButton({
	Name = "Steal Teleport",
	Description = "Launch downward into brainrot void.",
	Callback = function()
		local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
		if hrp then
			local target = CFrame.new(0, -500, 0)
			for _ = 1, 50 do
				hrp.CFrame = target
				task.wait()
			end
		end
	end
})

-- 🔁 Rejoin
Tab:CreateButton({
	Name = "Rejoin Server",
	Description = "Quickly rejoin current server.",
	Callback = function()
		game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId)
	end
})

-- 🎲 Server Hop
Tab:CreateButton({
	Name = "Server Hop",
	Description = "Hop to a different public server.",
	Callback = function()
		local HttpService = game:GetService("HttpService")
		local TeleportService = game:GetService("TeleportService")
		local success, servers = pcall(function()
			return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?limit=100"))
		end)
		if success and servers and servers.data then
			for _, s in pairs(servers.data) do
				if s.id ~= game.JobId then
					TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id)
					break
				end
			end
		end
	end
})

-- Finalize
Luna:LoadAutoloadConfig()
