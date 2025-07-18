local Luna = loadstring(game:HttpGet("https://raw.githubusercontent.com/Nebula-Softworks/Luna/main/source.lua", true))()

-- Create Window
local Window = Luna:CreateWindow({
	Name = "Rotware Hub 〢 Brainrot Steal",
	Subtitle = "Glitchy Red Edition",
	LogoID = "", -- empty string disables logo
	LoadingEnabled = true,
	LoadingTitle = "Rotware Hub",
	LoadingSubtitle = "Initializing...",
	ConfigSettings = {
		ConfigFolder = "RotwareConfigs"
	},
	KeySystem = false
})

-- Create Tabs
local HomeTab = Window:CreateTab({
	Name = "Home",
	Icon = "None",
	ImageSource = "Material"
})

local MainTab = Window:CreateTab({
	Name = "Main",
	Icon = "None",
	ImageSource = "Material"
})

local ESPTab = Window:CreateTab({
	Name = "ESP",
	Icon = "None",
	ImageSource = "Material"
})

local SettingsTab = Window:CreateTab({
	Name = "Settings",
	Icon = "None",
	ImageSource = "Material"
})

-- === Anti-Kick ===
local function antiKick()
	local mt = getrawmetatable(game)
	local old = mt.__namecall
	setreadonly(mt, false)
	mt.__namecall = newcclosure(function(self, ...)
		if getnamecallmethod() == "Kick" then return wait(9e9) end
		return old(self, ...)
	end)
	setreadonly(mt, true)
end
antiKick()

-- === Steal (Teleport) ===
local function steal()
	local p = game.Players.LocalPlayer
	if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
		p.Character.HumanoidRootPart.CFrame = CFrame.new(0, -500, 0)
	end
end

-- === Walkspeed Bypass ===
local currentSpeed = 0
local player = game.Players.LocalPlayer

local function speedHack(char)
	local humanoid = char:WaitForChild("Humanoid", 3)
	if not humanoid then return end
	task.spawn(function()
		while humanoid and humanoid.Parent do
			if currentSpeed > 0 and humanoid.MoveDirection.Magnitude > 0 then
				char:TranslateBy(humanoid.MoveDirection * currentSpeed * game:GetService("RunService").Heartbeat:Wait() * 10)
			end
			task.wait()
		end
	end)
end

player.CharacterAdded:Connect(speedHack)
if player.Character then speedHack(player.Character) end

-- === ESP ===
local espEnabled = false
local espObjects = {}

local function addESP(plr)
	if plr == player then return end
	local char = plr.Character
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	local bb = Instance.new("BillboardGui", hrp)
	bb.Name = "RotwareESP"
	bb.Size = UDim2.new(0, 100, 0, 30)
	bb.AlwaysOnTop = true
	bb.StudsOffset = Vector3.new(0, 3, 0)

	local label = Instance.new("TextLabel", bb)
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = plr.Name
	label.TextColor3 = Color3.fromRGB(255, 0, 0)
	label.TextStrokeTransparency = 0
	label.Font = Enum.Font.GothamBold
	label.TextScaled = true

	espObjects[plr] = bb
end

local function removeESP(plr)
	if espObjects[plr] then
		espObjects[plr]:Destroy()
		espObjects[plr] = nil
	end
end

local function toggleESP(state)
	espEnabled = state
	if state then
		for _, p in ipairs(game.Players:GetPlayers()) do
			if p ~= player then addESP(p) end
		end
	else
		for _, v in pairs(espObjects) do
			v:Destroy()
		end
		table.clear(espObjects)
	end
end

-- === UI Elements ===
HomeTab:CreateLabel({ Text = "Welcome to Rotware Hub!" })
HomeTab:CreateLabel({ Text = "Brainrot Stealer Edition" })
HomeTab:CreateLabel({ Text = "Theme: Glitchy Red" })

MainTab:CreateButton({
	Name = "Steal (Teleport Center)",
	Callback = steal
})

MainTab:CreateSlider({
	Name = "Walkspeed Bypass",
	Range = {0, 10},
	Increment = 1,
	CurrentValue = 0,
	Callback = function(v)
		currentSpeed = v
	end
})

ESPTab:CreateToggle({
	Name = "Enable ESP",
	CurrentValue = false,
	Callback = toggleESP
})

SettingsTab:CreateBind({
	Name = "Steal Keybind",
	CurrentBind = "G",
	HoldToInteract = false,
	Callback = steal
})

SettingsTab:CreateBind({
	Name = "Toggle UI",
	CurrentBind = "RightControl",
	HoldToInteract = false,
	Callback = function()
		Window:Toggle()
	end
})

-- Theme & Config Support
SettingsTab:BuildThemeSection()
SettingsTab:BuildConfigSection()

Luna:LoadAutoloadConfig()

-- Notification
Luna:Notification({
	Title = "Rotware Loaded",
	Content = "Press Right Ctrl to toggle the UI.",
	Icon = "None",
	ImageSource = "Material"
})
