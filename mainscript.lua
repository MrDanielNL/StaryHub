-- Anti-Kick bypass for Brainrot (Hooks observeTag in getgc)
do
    local hk = false
    for _, v in pairs(getgc(true)) do
        if typeof(v) == "table" then
            local fn = rawget(v, "observeTag")
            if typeof(fn) == "function" and not hk then
                hk = true
                hookfunction(fn, newcclosure(function(_, _)
                    return {
                        Disconnect = function() end,
                        disconnect = function() end
                    }
                end))
            end
        end
    end
end

local Luna = loadstring(game:HttpGet("https://raw.githubusercontent.com/Nebula-Softworks/Luna-Interface-Suite/refs/heads/master/source.lua", true))()

-- Create Window with glitchy red theme
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

-- Create Tabs
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

-- Additional Anti-Kick (metatable hook, for safety)
do
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

-- Steal function: teleport player to center
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

player.CharacterAdded:Connect(speedHack)
if player.Character then speedHack(player.Character) end

-- Main Tab Elements
Tabs.Main:CreateButton({
    Name = "Steal (Teleport Center)",
    Callback = steal,
})

local speedSlider = Tabs.Main:CreateSlider({
    Name = "Walkspeed Bypass",
    Range = {0, 10},
    Increment = 1,
    CurrentValue = 0,
    Callback = function(value)
        currentSpeed = value
    end,
}, "WalkspeedBypass")

-- ESP Setup
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

    plr.CharacterAdded:Connect(function(newChar)
        if espInstances[plr] then
            espInstances[plr]:Destroy()
            espInstances[plr] = nil
        end
        wait(1)
        if espEnabled then
            createESP(plr)
        end
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
        for _, plr in pairs(game.Players:GetPlayers()) do
            if plr ~= player then
                createESP(plr)
            end
        end
    else
        for plr, esp in pairs(espInstances) do
            if esp then esp:Destroy() end
        end
        espInstances = {}
    end
end

Tabs.ESP:CreateToggle({
    Name = "Enable ESP",
    CurrentValue = false,
    Callback = toggleESP,
}, "ESPEnabled")

-- Settings Tab keybinds
Tabs.Settings:CreateBind({
    Name = "Steal Keybind",
    CurrentBind = Enum.KeyCode.G,
    HoldToInteract = false,
    Callback = steal,
}, "StealKeybind")

Tabs.Settings:CreateBind({
    Name = "Toggle UI",
    CurrentBind = Enum.KeyCode.RightControl,
    HoldToInteract = false,
    Callback = function()
        Window:Toggle()
    end,
}, "ToggleUIBind")

-- Load autoload config (important)
Luna:LoadAutoloadConfig()

-- Show UI
Window:Show()

-- Notification
Luna:Notification({
    Title = "Rotware Hub",
    Icon = "circle_notifications",
    ImageSource = "Material",
    Content = "Loaded successfully! Press Right Ctrl to toggle UI.",
    Duration = 5,
})
