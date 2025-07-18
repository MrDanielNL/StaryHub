-- Load Starlight UI library
local Starlight = loadstring(game:HttpGet("https://raw.githubusercontent.com/Nebula-Softworks/Starlight-Interface-Suite/master/Source.lua"))()

-- Create main window with full config
local window = Starlight:CreateWindow({
    Name = "Steal a Brainrot",
    Subtitle = "v1.0",
    Icon = 6023426915,  -- Replace with your own RBX asset icon if you want

    LoadingSettings = {
        Title = "Steal a Brainrot Hub",
        Subtitle = "by You",
    },

    ConfigurationSettings = {
        FolderName = "StealABrainrotConfig"
    },

    LoadingEnabled = true,
    BuildWarnings = true,
    InterfaceAdvertisingPrompts = false,
    NotifyOnCallbackError = true,
})

-- Create main page
local mainPage = window:Page("Main Features")

-- Enable ESP button
mainPage:Button("Enable ESP", function()
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer then
            local character = player.Character
            if character and not character:FindFirstChild("ESP") then
                local esp = Instance.new("BillboardGui", character)
                esp.Name = "ESP"
                esp.Adornee = character:FindFirstChild("Head")
                esp.Size = UDim2.new(0, 100, 0, 40)
                esp.AlwaysOnTop = true

                local label = Instance.new("TextLabel", esp)
                label.Text = player.Name
                label.Size = UDim2.new(1, 0, 1, 0)
                label.BackgroundTransparency = 1
                label.TextColor3 = Color3.fromRGB(255, 0, 0)
                label.TextStrokeTransparency = 0.5
                label.TextScaled = true
            end
        end
    end
end)

-- Auto Collect Coins button
mainPage:Button("Auto Collect Coins", function()
    local coins = workspace:FindFirstChild("Coins") -- Change "Coins" to your actual coin folder name
    if coins then
        for _, coin in pairs(coins:GetChildren()) do
            if coin:IsA("BasePart") then
                firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, coin, 0)
                task.wait(0.1)
                firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, coin, 1)
            end
        end
    end
end)

-- Speed Boost button
mainPage:Button("Speed Boost", function()
    local humanoid = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = 100
    end
end)

-- Godmode button
mainPage:Button("Godmode", function()
    local char = game.Players.LocalPlayer.Character
    if char then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.MaxHealth = math.huge
            humanoid.Health = math.huge
        end
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
                part.Anchored = false
            end
        end
    end
end)

-- Teleport to NPC button
mainPage:Button("Teleport to NPC", function()
    local npc = workspace:FindFirstChild("Bob") -- Change "Bob" to your NPC's name
    if npc then
        local rootPart = npc:FindFirstChild("HumanoidRootPart") or npc.PrimaryPart
        if rootPart then
            game.Players.LocalPlayer.Character:MoveTo(rootPart.Position + Vector3.new(0, 5, 0))
        end
    end
end)

-- Load autoload configs (planned feature)
Starlight:LoadAutoloadConfig()
