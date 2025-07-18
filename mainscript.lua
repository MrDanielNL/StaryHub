local Luna = loadstring(game:HttpGet("https://raw.githubusercontent.com/Nebula-Softworks/Luna-Interface-Suite/refs/heads/master/source.lua", true))()

local Window = Luna:CreateWindow({
	Name = "Rotware Hub v1",
	Subtitle = "Glitchy Red Edition",
	LogoID = nil,
	LoadingEnabled = true,
	LoadingTitle = "Rotware Hub",
	LoadingSubtitle = "Steal a Brainrot Script",
	ConfigSettings = {
		ConfigFolder = "RotwareConfig"
	},
	KeySystem = false
})

local Tab = Window:CreateTab({
	Name = "Main",
	Icon = "bolt",
	ImageSource = "Lucide",
	ShowTitle = true
})

local ESPTab = Window:CreateTab({
	Name = "ESP",
	Icon = "eye",
	ImageSource = "Lucide",
	ShowTitle = true
})

local Settings = Window:CreateTab({
	Name = "Settings",
	Icon = "settings",
	ImageSource = "Lucide",
	ShowTitle = true
})

-- Anti Kick
do
    local mt = getrawmetatable(game)
    local old = mt.__namecall
    setreadonly(mt, false)
    mt.__namecall = newcclosure(function(self, ...)
        if getnamecallmethod() == "Kick" then
            return nil
        end
        return old(self, ...)
    end)
    setreadonly(mt, true)
end

-- Steal Function
local function steal()
	local lp = game.Players.LocalPlayer
	if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
		lp.Character.HumanoidRootPart.CFrame = CFrame.new(0, -500, 0)
	end
end

-- Walkspeed Bypass
local currentSpeed = 0
local player = game.Players.LocalPlayer

local function speedHack(char)
    local hum = char:WaitForChild("Humanoid")
    local RunService = game:GetService("RunService")
    task.spawn(function()
        while char and hum and hum.Parent do
            if currentSpeed > 0 and hum.MoveDirection.Magnitude > 0 then
                char:TranslateBy(hum.MoveDirection * currentSpeed * RunService.Heartbeat:Wait() * 10)
            end
            task.wait()
        end
    end)
end

player.CharacterAdded:Connect(speedHack)
if player.Character then
    speedHack(player.Character)
end

-- ESP
local espEnabled = false
local espTable = {}

local function addESP(plr)
    if plr == player then return end
    local char = plr.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local bb = Instance.new("BillboardGui", hrp)
    bb.Name = "RotwareESP"
    bb.Size = UDim2.new(0, 200, 0, 40)
    bb.Adornee = hrp
    bb.AlwaysOnTop = true

    local label = Instance.new("TextLabel", bb)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Text = plr.Name
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 0, 0)
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold

    espTable[plr] = bb

    plr.CharacterAdded:Connect(function()
        if espTable[plr] then espTable[plr]:Destroy() end
        task.wait(1)
        if espEnabled then
            addESP(plr)
        end
    end)
end

local function toggleESP(val)
    espEnabled = val
    if val then
        for _, p in ipairs(game.Players:GetPlayers()) do
            if p ~= player then
                addESP(p)
            end
        end
    else
        for _, bb in pairs(espTable) do
            if bb then bb:Destroy() end
        end
        espTable = {}
    end
end

-- Buttons
Tab:CreateButton({
	Name = "Steal (Teleport Center)",
	Callback = steal
})

Tab:CreateSlider({
	Name = "Walkspeed Bypass",
	Range = {0, 10},
	Increment = 1,
	CurrentValue = 0,
	Callback = function(val)
		currentSpeed = val
	end
}, "WalkspeedFlag")

-- ESP Toggle
ESPTab:CreateToggle({
	Name = "Enable ESP",
	CurrentValue = false,
	Callback = toggleESP
}, "ESPToggle")

-- Keybinds
Settings:CreateBind({
	Name = "Steal Keybind",
	CurrentBind = "G",
	HoldToInteract = false,
	Callback = function()
		steal()
	end
}, "StealKey")

Settings:CreateBind({
	Name = "Toggle UI",
	CurrentBind = "RightControl",
	HoldToInteract = false,
	Callback = function()
		Window:Toggle()
	end
}, "ToggleUI")

-- Done
Luna:Notification({
	Title = "Rotware",
	Content = "Loaded successfully! Press Right Ctrl to toggle UI.",
	Icon = "check_circle",
	ImageSource = "Material"
})

Luna:LoadAutoloadConfig()
