-- Load Starlight Interface Suite
local Starlight = loadstring(game:HttpGet("https://raw.githubusercontent.com/Nebula-Softworks/Starlight-Interface-Suite/main/main.lua"))()
local Window = Starlight:CreateWindow("Steal a Brainrot", "v1.0")

-- Create Pages
local MainPage = Window:Page("Main Features")

-- ESP Toggle
MainPage:Button("Enable ESP", function()
    -- Simple ESP using BillboardGui
    for _, player in pairs(game:GetService("Players"):GetPlayers()) do
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

-- Auto Collect Coins
MainPage:Button("Auto Collect Coins", function()
    local coins = workspace:FindFirstChild("Coins") -- Rename this to your coin folder
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

-- Speed Boost
MainPage:Button("Speed Boost", function()
    local humanoid = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = 100 -- Change speed as needed
    end
end)

-- Godmode
MainPage:Button("Godmode", function()
    local char = game.Players.LocalPlayer.Character
    if char then
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
                v.Anchored = false
            end
        end
        char:FindFirstChildOfClass("Humanoid").Health = math.huge
        char:FindFirstChildOfClass("Humanoid").MaxHealth = math.huge
    end
end)

-- Teleport to NPC
MainPage:Button("Teleport to NPC", function()
    local npc = workspace:FindFirstChild("Bob") -- Replace 'Bob' with your actual NPC name
    if npc and npc:IsA("Model") then
        local root = npc:FindFirstChild("HumanoidRootPart") or npc.PrimaryPart
        if root then
            game.Players.LocalPlayer.Character:MoveTo(root.Position + Vector3.new(0, 5, 0))
        end
    end
end)
