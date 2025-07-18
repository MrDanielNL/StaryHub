-- ✅ Built-in Anti-Kick (Safe & Compatible)
local Players = game:GetService("Players")
local player = Players.LocalPlayer

while not player do
    task.wait()
    player = Players.LocalPlayer
end

-- Metamethod hooks to block Kick/Destroy
local mt = getrawmetatable(game)
setreadonly(mt, false)

local oldNamecall = mt.__namecall
local oldIndex = mt.__index

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if (self == player and (method == "Kick" or method == "Destroy")) then
        warn("[AntiKick] Blocked:", method)
        return nil
    end
    return oldNamecall(self, ...)
end)

mt.__index = newcclosure(function(self, key)
    if self == player and key == "Kick" then
        warn("[AntiKick] Blocked access to .Kick")
        return function() end
    end
    return oldIndex(self, key)
end)

setreadonly(mt, true)
task.wait(3) -- Wait before loading rest of the UI

-- ✅ Luna GUI Setup
local Luna = loadstring(game:HttpGet("https://raw.githubusercontent.com/Nebula-Softworks/Luna-Interface-Suite/refs/heads/master/source.lua", true))()

local Window = Luna:CreateWindow({
    Name = "Rotware Hub 〢 Brainrot Steal",
    Subtitle = "Glitchy Red Edition",
    Size = Vector2.new(550, 400),
    Theme = {
        MainColor = Color3.fromRGB(255, 0, 0),
        AccentColor = Color3.fromRGB(255, 50, 50),
        BackgroundColor = Color3.fromRGB(30, 0, 0),
        TextColor = Color3.fromRGB(255, 150, 150),
    }
})

local Tabs = {
    Home = Window:CreateHomeTab({
        SupportedExecutors = {"Swift", "Delta", "Wave"},
        DiscordInvite = "yourdiscordcode",
        Icon = 1,
    }),
    Main = Window:CreateTab({
        Name = "Main",
        Icon = "home",
        ImageSource = "Material",
        ShowTitle = true,
    }),
    ESP = Window:CreateTab({
        Name = "ESP",
        Icon = "panorama_fish_eye",
        ImageSource = "Material",
        ShowTitle = true,
    }),
    Settings = Window:CreateTab({
        Name = "Settings",
        Icon = "settings_remote",
        ImageSource = "Material",
        ShowTitle = true,
    }),
}

-- 🔁 Player services
local RunService = game:GetService("RunService")

-- ✅ Teleport Steal
local function steal()
    local pos = CFrame.new(0, -500, 0)
    local startT = os.clock()
    while os.clock() - startT < 1 do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = pos
        end
        task.wait()
    end
end

-- ✅ WalkSpeed Bypass
local currentSpeed = 0
local function speedHack(character)
    local humanoid = character:WaitForChild("Humanoid")
    task.spawn(function()
        while character and humanoid and humanoid.Parent do
            if currentSpeed > 0 and humanoid.MoveDirection.Magnitude > 0 then
                character:TranslateBy(humanoid.MoveDirection * currentSpeed * RunService.Heartbeat:Wait() * 10)
            end
            task.wait()
        end
    end)
end

player.CharacterAdded:Connect(speedHack)
if player.Character then speedHack(player.Character) end

-- ✅ Enhanced Steal
local savedPosition = nil
local enhancedStealRunning = false

local function savePosition()
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp then
        savedPosition = hrp.Position
    end
end

local function enhancedSteal()
    if not savedPosition or enhancedStealRunning then return end
    enhancedStealRunning = true

    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then enhancedStealRunning = false return end

    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end

    hrp.Anchored = true
    hrp.CFrame = CFrame.new(hrp.Position + Vector3.new(0, 15, 0))
    task.wait(0.6)

    local connection
    connection = RunService.RenderStepped:Connect(function()
        local dir = (savedPosition - hrp.Position)
        if dir.Magnitude < 2 then
            connection:Disconnect()
            task.wait(0.2)
            hrp.Anchored = false
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
            enhancedStealRunning = false
        else
            hrp.CFrame = hrp.CFrame:Lerp(CFrame.new(savedPosition), 0.02)
        end
    end)
end

-- ✅ Speed Toggle
local speedBoostEnabled = false
local function toggleSpeedBoost(enabled)
    speedBoostEnabled = enabled
    local char = player.Character or player.CharacterAdded:Wait()
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = enabled and 38 or 18
    end
end

player.CharacterAdded:Connect(function(char)
    local hum = char:WaitForChild("Humanoid")
    hum.WalkSpeed = speedBoostEnabled and 38 or 18
end)

-- ✅ ESP
local espEnabled = false
local espInstances = {}

local function createESP(plr)
    if not espEnabled or plr == player then return end
    local character = plr.Character
    if not character then return end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "RotwareESP_" .. plr.Name
    billboard.Adornee = hrp
    billboard.AlwaysOnTop = true
    billboard.Size = UDim2.new(0, 200, 0, 40)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.Parent = hrp

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = plr.Name
    label.TextColor3 = Color3.fromRGB(255, 0, 0)
    label.TextStrokeColor3 = Color3.new(0, 0, 0)
    label.TextStrokeTransparency = 0
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.Parent = billboard

    espInstances[plr] = billboard

    plr.CharacterAdded:Connect(function()
        removeESP(plr)
        task.wait(1)
        if espEnabled then createESP(plr) end
    end)
end

local function removeESP(plr)
    if espInstances[plr] then
        espInstances[plr]:Destroy()
        espInstances[plr] = nil
    end
end

local function toggleESP(enabled)
    espEnabled = enabled
    if enabled then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= player then createESP(plr) end
        end
    else
        for _, esp in pairs(espInstances) do
            esp:Destroy()
        end
        espInstances = {}
    end
end

-- ✅ GUI Buttons
Tabs.Main:CreateButton({ Name = "Steal (Teleport Center)", Callback = steal })
Tabs.Main:CreateSlider({
    Name = "Walkspeed Bypass",
    Range = {0, 10},
    Increment = 1,
    CurrentValue = 0,
    Callback = function(val) currentSpeed = val end,
})
Tabs.Main:CreateButton({ Name = "Save Position", Callback = savePosition })
Tabs.Main:CreateButton({ Name = "Enhanced Steal (Float + Fly)", Callback = enhancedSteal })
Tabs.Main:CreateToggle({ Name = "Speed Boost (38 WS)", CurrentValue = false, Callback = toggleSpeedBoost })

Tabs.ESP:CreateToggle({ Name = "Enable ESP", CurrentValue = false, Callback = toggleESP })

Tabs.Settings:CreateBind({
    Name = "Steal Keybind",
    CurrentBind = Enum.KeyCode.G,
    HoldToInteract = false,
    Callback = steal,
})
Tabs.Settings:CreateBind({
    Name = "Toggle UI",
    CurrentBind = Enum.KeyCode.RightControl,
    HoldToInteract = false,
    Callback = function() Window:Toggle() end,
})

Luna:LoadAutoloadConfig()
Window:Show()

Luna:Notification({
    Title = "Rotware Hub",
    Icon = "circle_notifications",
    ImageSource = "Material",
    Content = "Loaded successfully! Press Right Ctrl to toggle UI.",
    Duration = 5,
})
