local Luna = loadstring(game:HttpGet("https://raw.githubusercontent.com/Nebula-Softworks/Luna-Interface-Suite/refs/heads/master/source.lua", true))()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

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
    AutoBuy = Window:CreateTab({
        Name = "Auto Buy",
        Icon = "settings_remote",
        ImageSource = "Material",
        ShowTitle = true,
    }),
}

-- === Anti Kick ===
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

-- === Steal (Teleport to center) ===
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

-- === WalkSpeed Bypass ===
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

-- === Enhanced Steal & Position Saving ===
local savedPosition = nil
local enhancedStealRunning = false

local function savePosition()
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp then savedPosition = hrp.Position end
end

local function enhancedSteal()
    if not savedPosition or enhancedStealRunning then return end
    enhancedStealRunning = true
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then enhancedStealRunning = false return end

    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then part.CanCollide = false end
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
                if part:IsA("BasePart") then part.CanCollide = true end
            end
            enhancedStealRunning = false
        else
            hrp.CFrame = hrp.CFrame:Lerp(CFrame.new(savedPosition), 0.02)
        end
    end)
end

-- === Speed Boost Toggle ===
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

-- === ESP (Billboard + Highlight) ===
local espEnabled = false
local espInstances = {}

local function createESP(plr)
    if not espEnabled or plr == player then return end
    local character = plr.Character
    if not character then return end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    -- Billboard
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

    -- Highlight
    local highlight = character:FindFirstChild("ESP_HL")
    if not highlight then
        highlight = Instance.new("Highlight", character)
        highlight.Name = "ESP_HL"
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
        highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
        highlight.FillTransparency = 0.4
    end

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
    local character = plr.Character
    if character then
        local hl = character:FindFirstChild("ESP_HL")
        if hl then hl:Destroy() end
    end
end

local function toggleESP(enabled)
    espEnabled = enabled
    if enabled then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= player then createESP(plr) end
        end
    else
        for plr, _ in pairs(espInstances) do
            removeESP(plr)
        end
        espInstances = {}
    end
end

-- === GUI Elements ===
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

-- === Settings Tab Keybinds ===
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

-- === Speed Variable and Speed Boost (from extra snippet) ===
local speed = 2
local speedOn = false

Tabs.Main:CreateInput({
    Name = "Speed Value",
    PlaceholderText = "2",
    RemoveTextAfterFocusLost = false,
    Callback = function(txt)
        local val = tonumber(txt)
        if val then speed = math.clamp(val, 1, 100) end
    end
})

Tabs.Main:CreateToggle({
    Name = "Speed Boost (Velocity)",
    CurrentValue = false,
    Callback = function(state)
        speedOn = state
    end
})

RunService.Heartbeat:Connect(function()
    if speedOn then
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local root = char.HumanoidRootPart
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                local dir = hum.MoveDirection
                root.Velocity = dir * speed
            end
        end
    end
end)

-- === Multi Jump ===
_G.MultiJump = false
Tabs.Main:CreateToggle({
    Name = "Multi Jump",
    CurrentValue = false,
    Callback = function(state)
        _G.MultiJump = state
    end
})

UserInputService.JumpRequest:Connect(function()
    if _G.MultiJump then
        local h = player.Character and player.Character:FindFirstChildWhichIsA("Humanoid")
        if h then h:ChangeState("Jumping") end
    end
end)

-- === Godmode ===
_G.God = false
Tabs.Main:CreateToggle({
    Name = "Godmode",
    CurrentValue = false,
    Callback = function(state)
        _G.God = state
        local h = player.Character and player.Character:FindFirstChildWhichIsA("Humanoid")
        if h then
            h:GetPropertyChangedSignal("Health"):Connect(function()
                if _G.God then h.Health = h.MaxHealth end
            end)
        end
    end
})

-- === Anti Ragdoll ===
RunService.Stepped:Connect(function()
    local c = player.Character
    if _G.God and c then
        local humanoid = c:FindFirstChildWhichIsA("Humanoid")
        if humanoid then
            if humanoid.PlatformStand then
                humanoid.PlatformStand = false
            end
        end
    end
end)

-- === Auto Buy Tab ===
local AutoBuyEnabled = false
local AutoBuyItems = {
    "Fridge", "Newspaper", "Microphone", "BigSpeaker", "Chicken"
}

Tabs.AutoBuy:CreateToggle({
    Name = "Auto Buy",
    CurrentValue = false,
    Callback = function(state)
        AutoBuyEnabled = state
        if state then
            spawn(function()
                while AutoBuyEnabled do
                    for _, itemName in pairs(AutoBuyItems) do
                        local args = {
                            [1] = itemName
                        }
                        local success, err = pcall(function()
                            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("PurchaseEvent"):FireServer(unpack(args))
                        end)
                        task.wait(0.2)
                    end
                    task.wait(1)
                end
            end)
        end
    end
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
