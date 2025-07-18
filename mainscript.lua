-- Rotware Hub v1 | Glitchy Red Theme with Anti-Kick, Walkspeed Bypass, Steal, ESP

local Luna = loadstring(game:HttpGet("https://raw.githubusercontent.com/Nebula-Softworks/Luna-Interface-Suite/refs/heads/master/source.lua"))()

-- Create Window with glitchy red theme
local Window = Luna:CreateWindow({
    Title = "Rotware Hub 〢 Brainrot Steal",
    SubTitle = "Glitchy Red Edition",
    Size = Vector2.new(550, 400),
    Theme = {
        MainColor = Color3.fromRGB(255, 0, 0),
        AccentColor = Color3.fromRGB(255, 50, 50),
        BackgroundColor = Color3.fromRGB(30, 0, 0),
        TextColor = Color3.fromRGB(255, 150, 150)
    }
})

local Tabs = {
    Home = Window:AddTab("Home"),
    Main = Window:AddTab("Main"),
    ESP = Window:AddTab("ESP"),
    Settings = Window:AddTab("Settings")
}

-- Anti-Kick protection
local function antiKick()
    local mt = getrawmetatable(game)
    local oldNamecall = mt.__namecall
    setreadonly(mt, false)
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if method == "Kick" or method == "kick" then
            return wait(9e9)
        end
        return oldNamecall(self, ...)
    end)
    setreadonly(mt, true)
end
antiKick()

-- Steal (teleport to center)
local function steal()
    local player = game.Players.LocalPlayer
    local pos = CFrame.new(0, -500, 0)
    local startT = os.clock()
    while os.clock() - startT < 1 do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = pos
        end
        task.wait()
    end
end

-- Walkspeed Bypass
local currentSpeed = 0
local player = game.Players.LocalPlayer

local function speedHack(character)
    local humanoid = character:WaitForChild("Humanoid")
    local RunService = game:GetService("RunService")
    task.spawn(function()
        while character and humanoid and humanoid.Parent do
            if currentSpeed > 0 and humanoid.MoveDirection.Magnitude > 0 then
                character:TranslateBy(humanoid.MoveDirection * currentSpeed * RunService.Heartbeat:Wait() * 10)
            end
            task.wait()
        end
    end)
end

local function onCharacterAdded(character)
    speedHack(character)
end

player.CharacterAdded:Connect(onCharacterAdded)
if player.Character then
    onCharacterAdded(player.Character)
end

-- Home Tab
Tabs.Home:AddLabel("Welcome to Rotware Hub!")
Tabs.Home:AddLabel("Glitchy Red Theme")
Tabs.Home:AddLabel("Use carefully!")

-- Main Tab
Tabs.Main:AddButton("Steal (Teleport Center)", function()
    steal()
end)

local speedSlider = Tabs.Main:AddSlider("Walkspeed Bypass", {
    Default = 0,
    Min = 0,
    Max = 10,
    Rounding = 1,
})
speedSlider:OnChanged(function(value)
    currentSpeed = value
end)

-- ESP
local espEnabled = false
local espInstances = {}

local function createESP(target)
    if not espEnabled or target == player then return end
    local character = target.Character
    if not character then return end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "RotwareESP_" .. target.Name
    billboard.Adornee = hrp
    billboard.AlwaysOnTop = true
    billboard.Size = UDim2.new(0, 200, 0, 40)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.Parent = hrp

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = target.Name
    label.TextColor3 = Color3.fromRGB(255, 0, 0)
    label.TextStrokeColor3 = Color3.new(0, 0, 0)
    label.TextStrokeTransparency = 0
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.Parent = billboard

    espInstances[target] = billboard

    target.CharacterAdded:Connect(function()
        if espInstances[target] then espInstances[target]:Destroy() end
        task.wait(1)
        if espEnabled then
            createESP(target)
        end
    end)
end

local function toggleESP(enabled)
    espEnabled = enabled
    if enabled then
        for _, plr in pairs(game.Players:GetPlayers()) do
            if plr ~= player then
                createESP(plr)
            end
        end
    else
        for _, esp in pairs(espInstances) do
            if esp then esp:Destroy() end
        end
        espInstances = {}
    end
end

Tabs.ESP:AddToggle("Enable ESP", false, function(value)
    toggleESP(value)
end)

-- Settings Tab
Tabs.Settings:AddKeybind("Steal Keybind", Enum.KeyCode.G, function()
    steal()
end)

Tabs.Settings:AddKeybind("Toggle UI", Enum.KeyCode.RightControl, function()
    Window:Toggle()
end)

-- Show
Window:Show()

-- Notify ready
Luna:Notify({
    Title = "Rotware",
    Content = "Loaded successfully! Press Right Ctrl to toggle UI.",
    Duration = 5,
})
