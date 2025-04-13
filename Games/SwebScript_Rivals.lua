-- SwebScript Focused - Compact but powerful cheat for Rivals
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Configuration
local config = {
    aimbot = {
        enabled = false,
        key = Enum.UserInputType.MouseButton2, -- Right mouse button
        targetPart = "Head",
        fov = 250,
        smoothness = 0.5, -- Lower = faster
        teamCheck = true,
        visibilityCheck = true,
        drawFov = true
    },
    esp = {
        enabled = false,
        boxes = true,
        tracers = true,
        names = true,
        distance = true,
        skeletons = true,
        teamCheck = true,
        teamColor = false,
        boxColor = Color3.fromRGB(255, 0, 0),
        tracerColor = Color3.fromRGB(255, 0, 0),
        textColor = Color3.fromRGB(255, 255, 255)
    },
    character = {
        speedEnabled = false,
        speedValue = 50,
        flyEnabled = false,
        flySpeed = 50,
        godMode = false,
        noClip = false
    },
    toggleKey = Enum.KeyCode.RightShift
}

-- Create UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SwebScriptFocused"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -150)
MainFrame.Size = UDim2.new(0, 300, 0, 300)
MainFrame.Active = true
MainFrame.Draggable = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 6)
UICorner.Parent = MainFrame

local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
TopBar.BorderSizePixel = 0
TopBar.Size = UDim2.new(1, 0, 0, 30)

local UICorner2 = Instance.new("UICorner")
UICorner2.CornerRadius = UDim.new(0, 6)
UICorner2.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Size = UDim2.new(1, -50, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "SwebScript Focused"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left

local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Parent = TopBar
CloseButton.BackgroundTransparency = 1
CloseButton.Position = UDim2.new(1, -25, 0, 0)
CloseButton.Size = UDim2.new(0, 25, 1, 0)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 14

local Content = Instance.new("ScrollingFrame")
Content.Name = "Content"
Content.Parent = MainFrame
Content.Active = true
Content.BackgroundTransparency = 1
Content.Position = UDim2.new(0, 0, 0, 30)
Content.Size = UDim2.new(1, 0, 1, -30)
Content.CanvasSize = UDim2.new(0, 0, 0, 500)
Content.ScrollBarThickness = 4

-- Helper function to create toggles
local function createToggle(parent, name, default, yPos, callback)
    local toggle = Instance.new("Frame")
    toggle.Name = name.."Toggle"
    toggle.Parent = parent
    toggle.BackgroundTransparency = 1
    toggle.Position = UDim2.new(0, 10, 0, yPos)
    toggle.Size = UDim2.new(1, -20, 0, 30)
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Parent = toggle
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 0, 0, 0)
    label.Size = UDim2.new(1, -50, 1, 0)
    label.Font = Enum.Font.Gotham
    label.Text = name
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local button = Instance.new("Frame")
    button.Name = "Button"
    button.Parent = toggle
    button.BackgroundColor3 = default and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(60, 60, 60)
    button.BorderSizePixel = 0
    button.Position = UDim2.new(1, -40, 0.5, -10)
    button.Size = UDim2.new(0, 40, 0, 20)
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = button
    
    local circle = Instance.new("Frame")
    circle.Name = "Circle"
    circle.Parent = button
    circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    circle.Position = default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    circle.Size = UDim2.new(0, 16, 0, 16)
    
    local UICorner2 = Instance.new("UICorner")
    UICorner2.CornerRadius = UDim.new(1, 0)
    UICorner2.Parent = circle
    
    local value = default
    
    button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            value = not value
            
            if value then
                button.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
                circle:TweenPosition(UDim2.new(1, -18, 0.5, -8), Enum.EasingDirection.InOut, Enum.EasingStyle.Quad, 0.2, true)
            else
                button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                circle:TweenPosition(UDim2.new(0, 2, 0.5, -8), Enum.EasingDirection.InOut, Enum.EasingStyle.Quad, 0.2, true)
            end
            
            callback(value)
        end
    end)
    
    circle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            value = not value
            
            if value then
                button.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
                circle:TweenPosition(UDim2.new(1, -18, 0.5, -8), Enum.EasingDirection.InOut, Enum.EasingStyle.Quad, 0.2, true)
            else
                button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                circle:TweenPosition(UDim2.new(0, 2, 0.5, -8), Enum.EasingDirection.InOut, Enum.EasingStyle.Quad, 0.2, true)
            end
            
            callback(value)
        end
    end)
    
    return {
        Instance = toggle,
        Value = value,
        Set = function(newValue)
            value = newValue
            
            if value then
                button.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
                circle.Position = UDim2.new(1, -18, 0.5, -8)
            else
                button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                circle.Position = UDim2.new(0, 2, 0.5, -8)
            end
            
            callback(value)
        end
    }
end

-- Helper function to create sliders
local function createSlider(parent, name, min, max, default, yPos, callback)
    local slider = Instance.new("Frame")
    slider.Name = name.."Slider"
    slider.Parent = parent
    slider.BackgroundTransparency = 1
    slider.Position = UDim2.new(0, 10, 0, yPos)
    slider.Size = UDim2.new(1, -20, 0, 50)
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Parent = slider
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 0, 0, 0)
    label.Size = UDim2.new(1, -50, 0, 20)
    label.Font = Enum.Font.Gotham
    label.Text = name
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Name = "Value"
    valueLabel.Parent = slider
    valueLabel.BackgroundTransparency = 1
    valueLabel.Position = UDim2.new(1, -45, 0, 0)
    valueLabel.Size = UDim2.new(0, 40, 0, 20)
    valueLabel.Font = Enum.Font.Gotham
    valueLabel.Text = tostring(default)
    valueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    valueLabel.TextSize = 14
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Name = "Background"
    sliderBg.Parent = slider
    sliderBg.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    sliderBg.BorderSizePixel = 0
    sliderBg.Position = UDim2.new(0, 0, 0, 25)
    sliderBg.Size = UDim2.new(1, 0, 0, 10)
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 5)
    UICorner.Parent = sliderBg
    
    local fill = Instance.new("Frame")
    fill.Name = "Fill"
    fill.Parent = sliderBg
    fill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    fill.BorderSizePixel = 0
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    
    local UICorner2 = Instance.new("UICorner")
    UICorner2.CornerRadius = UDim.new(0, 5)
    UICorner2.Parent = fill
    
    local value = default
    
    local function update(newValue)
        value = math.clamp(newValue, min, max)
        valueLabel.Text = tostring(math.floor(value * 10) / 10)
        fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
        callback(value)
    end
    
    local dragging = false
    
    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            local relativePos = input.Position.X - sliderBg.AbsolutePosition.X
            local percentage = math.clamp(relativePos / sliderBg.AbsoluteSize.X, 0, 1)
            update(min + (max - min) * percentage)
        end
    end)
    
    sliderBg.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local relativePos = input.Position.X - sliderBg.AbsolutePosition.X
            local percentage = math.clamp(relativePos / sliderBg.AbsoluteSize.X, 0, 1)
            update(min + (max - min) * percentage)
        end
    end)
    
    return {
        Instance = slider,
        Value = value,
        Set = function(newValue)
            update(newValue)
        end
    }
end

-- Create section headers
local function createHeader(parent, text, yPos)
    local header = Instance.new("Frame")
    header.Name = text.."Header"
    header.Parent = parent
    header.BackgroundTransparency = 1
    header.Position = UDim2.new(0, 10, 0, yPos)
    header.Size = UDim2.new(1, -20, 0, 30)
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Parent = header
    label.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    label.BorderSizePixel = 0
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Font = Enum.Font.GothamBold
    label.Text = "  "..text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 4)
    UICorner.Parent = label
    
    return header
end

-- Create UI elements
local aimbotHeader = createHeader(Content, "Aimbot", 10)
local aimbotToggle = createToggle(Content, "Enable Aimbot", config.aimbot.enabled, 50, function(value)
    config.aimbot.enabled = value
end)

local aimbotFovSlider = createSlider(Content, "Aimbot FOV", 50, 500, config.aimbot.fov, 90, function(value)
    config.aimbot.fov = value
end)

local aimbotSmoothSlider = createSlider(Content, "Aimbot Smoothness", 0.1, 1, config.aimbot.smoothness, 150, function(value)
    config.aimbot.smoothness = value
end)

local aimbotTeamToggle = createToggle(Content, "Team Check", config.aimbot.teamCheck, 210, function(value)
    config.aimbot.teamCheck = value
end)

local aimbotVisToggle = createToggle(Content, "Visibility Check", config.aimbot.visibilityCheck, 250, function(value)
    config.aimbot.visibilityCheck = value
end)

local aimbotFovToggle = createToggle(Content, "Draw FOV", config.aimbot.drawFov, 290, function(value)
    config.aimbot.drawFov = value
end)

local espHeader = createHeader(Content, "ESP", 330)
local espToggle = createToggle(Content, "Enable ESP", config.esp.enabled, 370, function(value)
    config.esp.enabled = value
end)

local boxEspToggle = createToggle(Content, "Box ESP", config.esp.boxes, 410, function(value)
    config.esp.boxes = value
end)

local tracerEspToggle = createToggle(Content, "Tracer ESP", config.esp.tracers, 450, function(value)
    config.esp.tracers = value
end)

local nameEspToggle = createToggle(Content, "Name ESP", config.esp.names, 490, function(value)
    config.esp.names = value
end)

local skeletonEspToggle = createToggle(Content, "Skeleton ESP", config.esp.skeletons, 530, function(value)
    config.esp.skeletons = value
end)

local espTeamToggle = createToggle(Content, "Team Check", config.esp.teamCheck, 570, function(value)
    config.esp.teamCheck = value
end)

local characterHeader = createHeader(Content, "Character", 610)
local speedToggle = createToggle(Content, "Speed Hack", config.character.speedEnabled, 650, function(value)
    config.character.speedEnabled = value
end)

local speedSlider = createSlider(Content, "Speed Value", 16, 150, config.character.speedValue, 690, function(value)
    config.character.speedValue = value
end)

local flyToggle = createToggle(Content, "Fly Hack", config.character.flyEnabled, 750, function(value)
    config.character.flyEnabled = value
    if value then
        activateFly()
    else
        deactivateFly()
    end
end)

local flySpeedSlider = createSlider(Content, "Fly Speed", 1, 150, config.character.flySpeed, 790, function(value)
    config.character.flySpeed = value
end)

local godModeToggle = createToggle(Content, "God Mode", config.character.godMode, 850, function(value)
    config.character.godMode = value
    if value then
        activateGodMode()
    end
end)

local noClipToggle = createToggle(Content, "No Clip", config.character.noClip, 890, function(value)
    config.character.noClip = value
end)

-- Close button functionality
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Toggle menu with keybind
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == config.toggleKey then
        ScreenGui.Enabled = not ScreenGui.Enabled
    end
end)

-- FOV Circle
local fovCircle = Drawing.new("Circle")
fovCircle.Visible = false
fovCircle.Thickness = 1
fovCircle.NumSides = 100
fovCircle.Radius = config.aimbot.fov
fovCircle.Filled = false
fovCircle.Transparency = 1
fovCircle.Color = Color3.fromRGB(255, 255, 255)

-- ESP Objects
local espObjects = {}

-- Function to get character parts
local function getCharacterParts(character)
    local parts = {}
    
    if character and character:FindFirstChild("Head") then
        parts.Head = character.Head
        parts.Torso = character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")
        parts.LowerTorso = character:FindFirstChild("LowerTorso")
        parts.LeftUpperArm = character:FindFirstChild("LeftUpperArm") or character:FindFirstChild("Left Arm")
        parts.RightUpperArm = character:FindFirstChild("RightUpperArm") or character:FindFirstChild("Right Arm")
        parts.LeftLowerArm = character:FindFirstChild("LeftLowerArm")
        parts.RightLowerArm = character:FindFirstChild("RightLowerArm")
        parts.LeftHand = character:FindFirstChild("LeftHand")
        parts.RightHand = character:FindFirstChild("RightHand")
        parts.LeftUpperLeg = character:FindFirstChild("LeftUpperLeg") or character:FindFirstChild("Left Leg")
        parts.RightUpperLeg = character:FindFirstChild("RightUpperLeg") or character:FindFirstChild("Right Leg")
        parts.LeftLowerLeg = character:FindFirstChild("LeftLowerLeg")
        parts.RightLowerLeg = character:FindFirstChild("RightLowerLeg")
        parts.LeftFoot = character:FindFirstChild("LeftFoot")
        parts.RightFoot = character:FindFirstChild("RightFoot")
        parts.HumanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    end
    
    return parts
end

-- Create ESP for a player
local function createEsp(player)
    if player == LocalPlayer then return end
    
    local esp = {
        box = Drawing.new("Square"),
        tracer = Drawing.new("Line"),
        name = Drawing.new("Text"),
        distance = Drawing.new("Text"),
        bones = {},
        player = player
    }
    
    -- Box ESP
    esp.box.Visible = false
    esp.box.Thickness = 1
    esp.box.Filled = false
    esp.box.Color = config.esp.boxColor
    
    -- Tracer ESP
    esp.tracer.Visible = false
    esp.tracer.Thickness = 1
    esp.tracer.Color = config.esp.tracerColor
    
    -- Name ESP
    esp.name.Visible = false
    esp.name.Size = 14
    esp.name.Center = true
    esp.name.Outline = true
    esp.name.Color = config.esp.textColor
    
    -- Distance ESP
    esp.distance.Visible = false
    esp.distance.Size = 14
    esp.distance.Center = true
    esp.distance.Outline = true
    esp.distance.Color = config.esp.textColor
    
    -- Skeleton ESP
    local skeletonConnections = {
        {"Head", "Torso"},
        {"Torso", "LowerTorso"},
        {"Torso", "LeftUpperArm"},
        {"LeftUpperArm", "LeftLowerArm"},
        {"LeftLowerArm", "LeftHand"},
        {"Torso", "RightUpperArm"},
        {"RightUpperArm", "RightLowerArm"},
        {"RightLowerArm", "RightHand"},
        {"LowerTorso", "LeftUpperLeg"},
        {"LeftUpperLeg", "LeftLowerLeg"},
        {"LeftLowerLeg", "LeftFoot"},
        {"LowerTorso", "RightUpperLeg"},
        {"RightUpperLeg", "RightLowerLeg"},
        {"RightLowerLeg", "RightFoot"}
    }
    
    for _, connection in ipairs(skeletonConnections) do
        local bone = Drawing.new("Line")
        bone.Visible = false
        bone.Thickness = 1
        bone.Color = Color3.fromRGB(255, 255, 255)
        
        esp.bones[connection[1].."-"..connection[2]] = {
            line = bone,
            from = connection[1],
            to = connection[2]
        }
    end
    
    espObjects[player] = esp
    return esp
end

-- Remove ESP for a player
local function removeEsp(player)
    local esp = espObjects[player]
    if esp then
        esp.box:Remove()
        esp.tracer:Remove()
        esp.name:Remove()
        esp.distance:Remove()
        
        for _, bone in pairs(esp.bones) do
            bone.line:Remove()
        end
        
        espObjects[player] = nil
    end
end

-- Check if a player is an enemy
local function isEnemy(player)
    if not config.esp.teamCheck and not config.aimbot.teamCheck then
        return true
    end
    return player.Team ~= LocalPlayer.Team
end

-- Update ESP
local function updateEsp()
    for player, esp in pairs(espObjects) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            local character = player.Character
            local humanoidRootPart = character.HumanoidRootPart
            local head = character:FindFirstChild("Head")
            
            if not head then continue end
            
            local isPlayerEnemy = isEnemy(player)
            local shouldRender = config.esp.enabled and isPlayerEnemy
            
            if shouldRender then
                local rootPos, rootOnScreen = Camera:WorldToViewportPoint(humanoidRootPart.Position)
                local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                local legPos = Camera:WorldToViewportPoint(humanoidRootPart.Position - Vector3.new(0, 3, 0))
                
                if rootOnScreen then
                    -- Calculate box dimensions
                    local boxSize = Vector2.new(1000 / rootPos.Z, (headPos.Y - legPos.Y))
                    local boxPosition = Vector2.new(rootPos.X - boxSize.X / 2, rootPos.Y - boxSize.Y / 2)
                    
                    -- Update box ESP
                    esp.box.Size = boxSize
                    esp.box.Position = boxPosition
                    esp.box.Visible = config.esp.boxes
                    
                    -- Update tracer ESP
                    esp.tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                    esp.tracer.To = Vector2.new(rootPos.X, rootPos.Y)
                    esp.tracer.Visible = config.esp.tracers
                    
                    -- Update name ESP
                    esp.name.Position = Vector2.new(rootPos.X, headPos.Y - 20)
                    esp.name.Text = player.Name
                    esp.name.Visible = config.esp.names
                    
                    -- Update distance ESP
                    local distance = math.floor((Camera.CFrame.Position - humanoidRootPart.Position).Magnitude)
                    esp.distance.Position = Vector2.new(rootPos.X, headPos.Y - 35)
                    esp.distance.Text = tostring(distance).."m"
                    esp.distance.Visible = config.esp.distance
                    
                    -- Update skeleton ESP
                    if config.esp.skeletons then
                        local parts = getCharacterParts(character)
                        
                        for name, bone in pairs(esp.bones) do
                            if parts[bone.from] and parts[bone.to] then
                                local from = Camera:WorldToViewportPoint(parts[bone.from].Position)
                                local to = Camera:WorldToViewportPoint(parts[bone.to].Position)
                                
                                bone.line.From = Vector2.new(from.X, from.Y)
                                bone.line.To = Vector2.new(to.X, to.Y)
                                bone.line.Visible = true
                            else
                                bone.line.Visible = false
                            end
                        end
                    else
                        for _, bone in pairs(esp.bones) do
                            bone.line.Visible = false
                        end
                    end
                else
                    esp.box.Visible = false
                    esp.tracer.Visible = false
                    esp.name.Visible = false
                    esp.distance.Visible = false
                    
                    for _, bone in pairs(esp.bones) do
                        bone.line.Visible = false
                    end
                end
            else
                esp.box.Visible = false
                esp.tracer.Visible = false
                esp.name.Visible = false
                esp.distance.Visible = false
                
                for _, bone in pairs(esp.bones) do
                    bone.line.Visible = false
                end
            end
        else
            esp.box.Visible = false
            esp.tracer.Visible = false
            esp.name.Visible = false
            esp.distance.Visible = false
            
            for _, bone in pairs(esp.bones) do
                bone.line.Visible = false
            end
        end
    end
end

-- Aimbot
local isAiming = false
local function aimbot()
    if not config.aimbot.enabled then return end
    
    local closestPlayer = nil
    local closestDistance = config.aimbot.fov
    local mousePos = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    
    for _, player in pairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        
        if config.aimbot.teamCheck and player.Team == LocalPlayer.Team then
            continue
        end
        
        if player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 and player.Character:FindFirstChild(config.aimbot.targetPart) then
            local targetPart = player.Character[config.aimbot.targetPart]
            local pos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
            
            if onScreen then
                local distance = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
                
                if distance < closestDistance then
                    if config.aimbot.visibilityCheck then
                        local ray = Ray.new(Camera.CFrame.Position, (targetPart.Position - Camera.CFrame.Position).Unit * 1000)
                        local hit, _ = workspace:FindPartOnRayWithIgnoreList(ray, {LocalPlayer.Character})
                        
                        if hit and hit:IsDescendantOf(player.Character) then
                            closestPlayer = player
                            closestDistance = distance
                        end
                    else
                        closestPlayer = player
                        closestDistance = distance
                    end
                end
            end
        end
    end
    
    if closestPlayer and isAiming then
        local targetPart = closestPlayer.Character[config.aimbot.targetPart]
        local pos = Camera:WorldToViewportPoint(targetPart.Position)
        local smoothness = config.aimbot.smoothness
        
        local targetX = pos.X
        local targetY = pos.Y
        
        local currentX = Camera.ViewportSize.X / 2
        local currentY = Camera.ViewportSize.Y / 2
        
        mousemoverel(
            (targetX - currentX) * smoothness,
            (targetY - currentY) * smoothness
        )
    end
end

-- Flying functionality
local flyPart
local flyConnection

function activateFly()
    if flyPart then return end
    
    flyPart = Instance.new("Part")
    flyPart.Name = "FlyPart"
    flyPart.Size = Vector3.new(1, 1, 1)
    flyPart.Transparency = 1
    flyPart.CanCollide = false
    flyPart.Anchored = true
    flyPart.Parent = workspace
    
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        flyPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
    end
    
    flyConnection = RunService.RenderStepped:Connect(function()
        if not config.character.flyEnabled then
            deactivateFly()
            return
        end
        
        if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            return
        end
        
        local humanoidRootPart = LocalPlayer.Character.HumanoidRootPart
        local flySpeed = config.character.flySpeed
        
        -- Update fly part position
        local cameraLook = Camera.CFrame.LookVector
        local cameraSide = Camera.CFrame.RightVector
        local cameraUp = Camera.CFrame.UpVector
        local moveDirection = Vector3.new(0, 0, 0)
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDirection = moveDirection + cameraLook
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDirection = moveDirection - cameraLook
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDirection = moveDirection - cameraSide
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDirection = moveDirection + cameraSide
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveDirection = moveDirection + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            moveDirection = moveDirection - Vector3.new(0, 1, 0)
        end
        
        if moveDirection.Magnitude > 0 then
            moveDirection = moveDirection.Unit
        end
        
        flyPart.CFrame = flyPart.CFrame + moveDirection * flySpeed * 0.1
        humanoidRootPart.CFrame = CFrame.new(flyPart.Position, flyPart.Position + Camera.CFrame.LookVector)
        humanoidRootPart.Velocity = Vector3.new(0, 0, 0)
    end)
end

function deactivateFly()
    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end
    
    if flyPart then
        flyPart:Destroy()
        flyPart = nil
    end
end

-- God Mode
function activateGodMode()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local humanoid = LocalPlayer.Character.Humanoid
        
        -- Method 1: Set health to a very high value
        humanoid.MaxHealth = math.huge
        humanoid.Health = math.huge
        
        -- Method 2: Connect to health changed event
        humanoid.HealthChanged:Connect(function(health)
            if health < humanoid.MaxHealth and config.character.godMode then
                humanoid.Health = humanoid.MaxHealth
            end
        end)
    end
end

-- No Clip
local noclipConnection
local function updateNoClip()
    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end
    
    if config.character.noClip then
        noclipConnection = RunService.Stepped:Connect(function()
            if LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
            end
        end)
    end
end

-- Speed Hack
local function updateSpeed()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local humanoid = LocalPlayer.Character.Humanoid
        
        if config.character.speedEnabled then
            humanoid.WalkSpeed = config.character.speedValue
        else
            humanoid.WalkSpeed = 16 -- Default walk speed
        end
    end
end

-- Main loop
RunService.RenderStepped:Connect(function()
    -- Update FOV circle
    fovCircle.Visible = config.aimbot.enabled and config.aimbot.drawFov
    fovCircle.Radius = config.aimbot.fov
    fovCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    
    -- Update ESP
    updateEsp()
    
    -- Update Aimbot
    aimbot()
    
    -- Update Speed
    updateSpeed()
    
    -- Update NoClip
    updateNoClip()
end)

-- Input handling
UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == config.aimbot.key then
        isAiming = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == config.aimbot.key then
        isAiming = false
    end
end)

-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if LocalPlayer.Character and config.character.infiniteJump then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- Player events
Players.PlayerAdded:Connect(function(player)
    createEsp(player)
end)

Players.PlayerRemoving:Connect(function(player)
    removeEsp(player)
end)

-- Initialize ESP for existing players
for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        createEsp(player)
    end
end

-- Notification
local notification = Instance.new("Frame")
notification.Name = "Notification"
notification.Parent = ScreenGui
notification.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
notification.BorderSizePixel = 0
notification.Position = UDim2.new(0.5, -150, 0, -50)
notification.Size = UDim2.new(0, 300, 0, 40)
notification.ZIndex = 100

local UICorner5 = Instance.new("UICorner")
UICorner5.CornerRadius = UDim.new(0, 5)
UICorner5.Parent = notification

local notificationText = Instance.new("TextLabel")
notificationText.Name = "Text"
notificationText.Parent = notification
notificationText.BackgroundTransparency = 1
notificationText.Position = UDim2.new(0, 10, 0, 0)
notificationText.Size = UDim2.new(1, -20, 1, 0)
notificationText.Font = Enum.Font.GothamSemibold
notificationText.Text = "SwebScript Focused loaded! Press Right Shift to toggle."
notificationText.TextColor3 = Color3.fromRGB(255, 255, 255)
notificationText.TextSize = 14
notificationText.ZIndex = 101

notification:TweenPosition(UDim2.new(0.5, -150, 0, 20), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.5, true)

task.delay(3, function()
    notification:TweenPosition(UDim2.new(0.5, -150, 0, -50), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.5, true)
    task.delay(0.5, function()
        notification:Destroy()
    end)
end)
