-- SwebScript Compact - A streamlined cheat menu for Rivals
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Configuration with default values
local config = {
    aimbot = {
        enabled = false,
        targetPart = "Head",
        fov = 250,
        teamCheck = true,
        visibilityCheck = true,
        drawFOV = true,
        fovColor = Color3.fromRGB(255, 255, 255)
    },
    esp = {
        enabled = false,
        boxEsp = true,
        tracerEsp = true,
        nameEsp = true,
        teamCheck = true,
        boxColor = Color3.fromRGB(255, 0, 0)
    },
    character = {
        speedHack = false,
        speedMultiplier = 2,
        jumpHack = false,
        jumpMultiplier = 2,
        infiniteJump = false,
        noClip = false
    },
    gunMods = {
        noRecoil = false,
        noSpread = false,
        rapidFire = false,
        infiniteAmmo = false
    },
    ui = {
        accentColor = Color3.fromRGB(255, 0, 0),
        toggleKey = Enum.KeyCode.RightShift
    }
}

-- Create UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SwebScriptCompact"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = game:GetService("CoreGui")

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
MainFrame.Size = UDim2.new(0, 400, 0, 300)
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
Title.Text = "SwebScript Compact"
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

-- Tabs
local TabButtons = Instance.new("Frame")
TabButtons.Name = "TabButtons"
TabButtons.Parent = MainFrame
TabButtons.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TabButtons.BorderSizePixel = 0
TabButtons.Position = UDim2.new(0, 0, 0, 30)
TabButtons.Size = UDim2.new(0, 100, 1, -30)

local UICorner3 = Instance.new("UICorner")
UICorner3.CornerRadius = UDim.new(0, 6)
UICorner3.Parent = TabButtons

local TabContent = Instance.new("Frame")
TabContent.Name = "TabContent"
TabContent.Parent = MainFrame
TabContent.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
TabContent.BorderSizePixel = 0
TabContent.Position = UDim2.new(0, 100, 0, 30)
TabContent.Size = UDim2.new(1, -100, 1, -30)

local UICorner4 = Instance.new("UICorner")
UICorner4.CornerRadius = UDim.new(0, 6)
UICorner4.Parent = TabContent

-- Create tabs
local tabs = {}
local tabContents = {}

local function createTab(name, index)
    local tabButton = Instance.new("TextButton")
    tabButton.Name = name.."Tab"
    tabButton.Parent = TabButtons
    tabButton.BackgroundTransparency = 1
    tabButton.Position = UDim2.new(0, 0, 0, 40 * (index - 1))
    tabButton.Size = UDim2.new(1, 0, 0, 40)
    tabButton.Font = Enum.Font.GothamSemibold
    tabButton.Text = name
    tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    tabButton.TextSize = 14
    
    local tabIndicator = Instance.new("Frame")
    tabIndicator.Name = "Indicator"
    tabIndicator.Parent = tabButton
    tabIndicator.BackgroundColor3 = config.ui.accentColor
    tabIndicator.BorderSizePixel = 0
    tabIndicator.Position = UDim2.new(0, 0, 0, 0)
    tabIndicator.Size = UDim2.new(0, 3, 1, 0)
    tabIndicator.Visible = false
    
    local tabContent = Instance.new("ScrollingFrame")
    tabContent.Name = name.."Content"
    tabContent.Parent = TabContent
    tabContent.Active = true
    tabContent.BackgroundTransparency = 1
    tabContent.BorderSizePixel = 0
    tabContent.Position = UDim2.new(0, 0, 0, 0)
    tabContent.Size = UDim2.new(1, 0, 1, 0)
    tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabContent.ScrollBarThickness = 4
    tabContent.Visible = false
    tabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
    
    tabButton.MouseButton1Click:Connect(function()
        for _, tab in pairs(tabs) do
            tab.Indicator.Visible = false
        end
        
        for _, content in pairs(tabContents) do
            content.Visible = false
        end
        
        tabIndicator.Visible = true
        tabContent.Visible = true
    end)
    
    table.insert(tabs, tabButton)
    table.insert(tabContents, tabContent)
    
    return tabContent
end

-- Create toggle function
local function createToggle(parent, name, default, callback, yPos)
    local toggleContainer = Instance.new("Frame")
    toggleContainer.Name = name.."Toggle"
    toggleContainer.Parent = parent
    toggleContainer.BackgroundTransparency = 1
    toggleContainer.Size = UDim2.new(1, -20, 0, 30)
    toggleContainer.Position = UDim2.new(0, 10, 0, yPos)
    
    local toggleLabel = Instance.new("TextLabel")
    toggleLabel.Name = "Label"
    toggleLabel.Parent = toggleContainer
    toggleLabel.BackgroundTransparency = 1
    toggleLabel.Position = UDim2.new(0, 0, 0, 0)
    toggleLabel.Size = UDim2.new(1, -50, 1, 0)
    toggleLabel.Font = Enum.Font.Gotham
    toggleLabel.Text = name
    toggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleLabel.TextSize = 14
    toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local toggleButton = Instance.new("Frame")
    toggleButton.Name = "Button"
    toggleButton.Parent = toggleContainer
    toggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    toggleButton.BorderSizePixel = 0
    toggleButton.Position = UDim2.new(1, -40, 0.5, -10)
    toggleButton.Size = UDim2.new(0, 40, 0, 20)
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = toggleButton
    
    local toggleCircle = Instance.new("Frame")
    toggleCircle.Name = "Circle"
    toggleCircle.Parent = toggleButton
    toggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    toggleCircle.Position = UDim2.new(0, 2, 0.5, -8)
    toggleCircle.Size = UDim2.new(0, 16, 0, 16)
    
    local UICorner2 = Instance.new("UICorner")
    UICorner2.CornerRadius = UDim.new(1, 0)
    UICorner2.Parent = toggleCircle
    
    local toggle = {
        Value = default,
        Button = toggleButton,
        Circle = toggleCircle
    }
    
    -- Update visual state
    local function updateToggle()
        if toggle.Value then
            toggleButton.BackgroundColor3 = config.ui.accentColor
            toggleCircle:TweenPosition(UDim2.new(1, -18, 0.5, -8), Enum.EasingDirection.InOut, Enum.EasingStyle.Quad, 0.2, true)
        else
            toggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            toggleCircle:TweenPosition(UDim2.new(0, 2, 0.5, -8), Enum.EasingDirection.InOut, Enum.EasingStyle.Quad, 0.2, true)
        end
    end
    
    -- Set initial state
    toggle.Value = default
    updateToggle()
    
    -- Click event
    toggleButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            toggle.Value = not toggle.Value
            updateToggle()
            callback(toggle.Value)
        end
    end)
    
    toggleCircle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            toggle.Value = not toggle.Value
            updateToggle()
            callback(toggle.Value)
        end
    end)
    
    return toggle
end

-- Create slider function
local function createSlider(parent, name, min, max, default, callback, yPos)
    local sliderContainer = Instance.new("Frame")
    sliderContainer.Name = name.."Slider"
    sliderContainer.Parent = parent
    sliderContainer.BackgroundTransparency = 1
    sliderContainer.Size = UDim2.new(1, -20, 0, 50)
    sliderContainer.Position = UDim2.new(0, 10, 0, yPos)
    
    local sliderLabel = Instance.new("TextLabel")
    sliderLabel.Name = "Label"
    sliderLabel.Parent = sliderContainer
    sliderLabel.BackgroundTransparency = 1
    sliderLabel.Position = UDim2.new(0, 0, 0, 0)
    sliderLabel.Size = UDim2.new(1, -50, 0, 20)
    sliderLabel.Font = Enum.Font.Gotham
    sliderLabel.Text = name
    sliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    sliderLabel.TextSize = 14
    sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Name = "Value"
    valueLabel.Parent = sliderContainer
    valueLabel.BackgroundTransparency = 1
    valueLabel.Position = UDim2.new(1, -45, 0, 0)
    valueLabel.Size = UDim2.new(0, 40, 0, 20)
    valueLabel.Font = Enum.Font.Gotham
    valueLabel.Text = tostring(default)
    valueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    valueLabel.TextSize = 14
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    
    local sliderBack = Instance.new("Frame")
    sliderBack.Name = "Background"
    sliderBack.Parent = sliderContainer
    sliderBack.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    sliderBack.BorderSizePixel = 0
    sliderBack.Position = UDim2.new(0, 0, 0, 25)
    sliderBack.Size = UDim2.new(1, -5, 0, 10)
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 5)
    UICorner.Parent = sliderBack
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Name = "Fill"
    sliderFill.Parent = sliderBack
    sliderFill.BackgroundColor3 = config.ui.accentColor
    sliderFill.BorderSizePixel = 0
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    
    local UICorner2 = Instance.new("UICorner")
    UICorner2.CornerRadius = UDim.new(0, 5)
    UICorner2.Parent = sliderFill
    
    local sliderCircle = Instance.new("Frame")
    sliderCircle = Instance.new("Frame")
    sliderCircle.Name = "Circle"
    sliderCircle.Parent = sliderFill
    sliderCircle.AnchorPoint = Vector2.new(0.5, 0.5)
    sliderCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sliderCircle.Position = UDim2.new(1, 0, 0.5, 0)
    sliderCircle.Size = UDim2.new(0, 16, 0, 16)
    
    local UICorner3 = Instance.new("UICorner")
    UICorner3.CornerRadius = UDim.new(1, 0)
    UICorner3.Parent = sliderCircle
    
    local slider = {
        Value = default,
        Min = min,
        Max = max
    }
    
    local function updateSlider(value)
        value = math.clamp(value, min, max)
        slider.Value = value
        valueLabel.Text = tostring(math.floor(value * 10) / 10)
        sliderFill:TweenSize(UDim2.new((value - min) / (max - min), 0, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
        callback(value)
    end
    
    local dragging = false
    
    sliderBack.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            local relativePos = input.Position.X - sliderBack.AbsolutePosition.X
            local percentage = math.clamp(relativePos / sliderBack.AbsoluteSize.X, 0, 1)
            updateSlider(min + (max - min) * percentage)
        end
    end)
    
    sliderBack.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local relativePos = input.Position.X - sliderBack.AbsolutePosition.X
            local percentage = math.clamp(relativePos / sliderBack.AbsoluteSize.X, 0, 1)
            updateSlider(min + (max - min) * percentage)
        end
    end)
    
    return slider
end

-- Create dropdown function
local function createDropdown(parent, name, options, default, callback, yPos)
    local dropdownContainer = Instance.new("Frame")
    dropdownContainer.Name = name.."Dropdown"
    dropdownContainer.Parent = parent
    dropdownContainer.BackgroundTransparency = 1
    dropdownContainer.Size = UDim2.new(1, -20, 0, 60)
    dropdownContainer.Position = UDim2.new(0, 10, 0, yPos)
    
    local dropdownLabel = Instance.new("TextLabel")
    dropdownLabel.Name = "Label"
    dropdownLabel.Parent = dropdownContainer
    dropdownLabel.BackgroundTransparency = 1
    dropdownLabel.Position = UDim2.new(0, 0, 0, 0)
    dropdownLabel.Size = UDim2.new(1, 0, 0, 20)
    dropdownLabel.Font = Enum.Font.Gotham
    dropdownLabel.Text = name
    dropdownLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    dropdownLabel.TextSize = 14
    dropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local dropdownButton = Instance.new("TextButton")
    dropdownButton.Name = "Button"
    dropdownButton.Parent = dropdownContainer
    dropdownButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    dropdownButton.BorderSizePixel = 0
    dropdownButton.Position = UDim2.new(0, 0, 0, 25)
    dropdownButton.Size = UDim2.new(1, 0, 0, 30)
    dropdownButton.Font = Enum.Font.Gotham
    dropdownButton.Text = default
    dropdownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    dropdownButton.TextSize = 14
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 5)
    UICorner.Parent = dropdownButton
    
    local dropdownMenu = Instance.new("Frame")
    dropdownMenu.Name = "Menu"
    dropdownMenu.Parent = dropdownContainer
    dropdownMenu.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    dropdownMenu.BorderSizePixel = 0
    dropdownMenu.Position = UDim2.new(0, 0, 0, 60)
    dropdownMenu.Size = UDim2.new(1, 0, 0, #options * 25)
    dropdownMenu.Visible = false
    dropdownMenu.ZIndex = 10
    
    local UICorner2 = Instance.new("UICorner")
    UICorner2.CornerRadius = UDim.new(0, 5)
    UICorner2.Parent = dropdownMenu
    
    local dropdown = {
        Value = default,
        Open = false
    }
    
    for i, option in ipairs(options) do
        local optionButton = Instance.new("TextButton")
        optionButton.Name = option
        optionButton.Parent = dropdownMenu
        optionButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        optionButton.BorderSizePixel = 0
        optionButton.Position = UDim2.new(0, 0, 0, (i-1) * 25)
        optionButton.Size = UDim2.new(1, 0, 0, 25)
        optionButton.Font = Enum.Font.Gotham
        optionButton.Text = option
        optionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        optionButton.TextSize = 14
        optionButton.ZIndex = 11
        
        optionButton.MouseButton1Click:Connect(function()
            dropdown.Value = option
            dropdownButton.Text = option
            dropdownMenu.Visible = false
            dropdown.Open = false
            callback(option)
        end)
    end
    
    dropdownButton.MouseButton1Click:Connect(function()
        dropdown.Open = not dropdown.Open
        dropdownMenu.Visible = dropdown.Open
    end)
    
    return dropdown
end

-- Create tabs
local aimbotTab = createTab("Aimbot", 1)
local espTab = createTab("ESP", 2)
local characterTab = createTab("Character", 3)
local gunModsTab = createTab("Gun Mods", 4)
local settingsTab = createTab("Settings", 5)

-- Select first tab by default
tabs[1].Indicator.Visible = true
tabContents[1].Visible = true

-- Aimbot Tab
local aimbotToggle = createToggle(aimbotTab, "Enable Aimbot", config.aimbot.enabled, function(value)
    config.aimbot.enabled = value
end, 10)

local aimbotFOVSlider = createSlider(aimbotTab, "FOV Size", 50, 500, config.aimbot.fov, function(value)
    config.aimbot.fov = value
end, 50)

local aimbotPartDropdown = createDropdown(aimbotTab, "Target Part", {"Head", "Torso", "HumanoidRootPart"}, config.aimbot.targetPart, function(value)
    config.aimbot.targetPart = value
end, 110)

local aimbotTeamToggle = createToggle(aimbotTab, "Team Check", config.aimbot.teamCheck, function(value)
    config.aimbot.teamCheck = value
end, 180)

local aimbotVisibilityToggle = createToggle(aimbotTab, "Visibility Check", config.aimbot.visibilityCheck, function(value)
    config.aimbot.visibilityCheck = value
end, 220)

local aimbotDrawFOVToggle = createToggle(aimbotTab, "Draw FOV", config.aimbot.drawFOV, function(value)
    config.aimbot.drawFOV = value
end, 260)

-- ESP Tab
local espToggle = createToggle(espTab, "Enable ESP", config.esp.enabled, function(value)
    config.esp.enabled = value
end, 10)

local boxEspToggle = createToggle(espTab, "Box ESP", config.esp.boxEsp, function(value)
    config.esp.boxEsp = value
end, 50)

local tracerEspToggle = createToggle(espTab, "Tracer ESP", config.esp.tracerEsp, function(value)
    config.esp.tracerEsp = value
end, 90)

local nameEspToggle = createToggle(espTab, "Name ESP", config.esp.nameEsp, function(value)
    config.esp.nameEsp = value
end, 130)

local espTeamToggle = createToggle(espTab, "Team Check", config.esp.teamCheck, function(value)
    config.esp.teamCheck = value
end, 170)

-- Character Tab
local speedHackToggle = createToggle(characterTab, "Speed Hack", config.character.speedHack, function(value)
    config.character.speedHack = value
end, 10)

local speedMultiplierSlider = createSlider(characterTab, "Speed Multiplier", 1, 10, config.character.speedMultiplier, function(value)
    config.character.speedMultiplier = value
end, 50)

local jumpHackToggle = createToggle(characterTab, "Jump Hack", config.character.jumpHack, function(value)
    config.character.jumpHack = value
end, 110)

local jumpMultiplierSlider = createSlider(characterTab, "Jump Multiplier", 1, 10, config.character.jumpMultiplier, function(value)
    config.character.jumpMultiplier = value
end, 150)

local infiniteJumpToggle = createToggle(characterTab, "Infinite Jump", config.character.infiniteJump, function(value)
    config.character.infiniteJump = value
end, 210)

local noClipToggle = createToggle(characterTab, "No Clip", config.character.noClip, function(value)
    config.character.noClip = value
end, 250)

-- Gun Mods Tab
local noRecoilToggle = createToggle(gunModsTab, "No Recoil", config.gunMods.noRecoil, function(value)
    config.gunMods.noRecoil = value
end, 10)

local noSpreadToggle = createToggle(gunModsTab, "No Spread", config.gunMods.noSpread, function(value)
    config.gunMods.noSpread = value
end, 50)

local rapidFireToggle = createToggle(gunModsTab, "Rapid Fire", config.gunMods.rapidFire, function(value)
    config.gunMods.rapidFire = value
end, 90)

local infiniteAmmoToggle = createToggle(gunModsTab, "Infinite Ammo", config.gunMods.infiniteAmmo, function(value)
    config.gunMods.infiniteAmmo = value
end, 130)

-- Settings Tab
local creditsLabel = Instance.new("TextLabel")
creditsLabel.Name = "CreditsLabel"
creditsLabel.Parent = settingsTab
creditsLabel.BackgroundTransparency = 1
creditsLabel.Position = UDim2.new(0, 10, 0, 10)
creditsLabel.Size = UDim2.new(1, -20, 0, 60)
creditsLabel.Font = Enum.Font.Gotham
creditsLabel.Text = "SwebScript Compact v1.0\nDeveloped by SwebTeam\nThanks for using our script!"
creditsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
creditsLabel.TextSize = 14
creditsLabel.TextWrapped = true
creditsLabel.TextXAlignment = Enum.TextXAlignment.Left
creditsLabel.TextYAlignment = Enum.TextYAlignment.Top

-- Close button functionality
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Toggle menu with keybind
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == config.ui.toggleKey then
        ScreenGui.Enabled = not ScreenGui.Enabled
    end
end)

-- Implement functionality
-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if config.character.infiniteJump then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- Speed and Jump hacks
RunService.RenderStepped:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        
        if config.character.speedHack then
            humanoid.WalkSpeed = 16 * config.character.speedMultiplier
        else
            humanoid.WalkSpeed = 16
        end
        
        if config.character.jumpHack then
            humanoid.JumpPower = 50 * config.character.jumpMultiplier
        else
            humanoid.JumpPower = 50
        end
    end
end)

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

noClipToggle.Button.MouseButton1Click:Connect(updateNoClip)

-- Draw FOV Circle
local fovCircle = Drawing.new("Circle")
fovCircle.Visible = false
fovCircle.Thickness = 1
fovCircle.NumSides = 100
fovCircle.Radius = config.aimbot.fov
fovCircle.Filled = false
fovCircle.Transparency = 1
fovCircle.Color = config.aimbot.fovColor

RunService.RenderStepped:Connect(function()
    fovCircle.Visible = config.aimbot.enabled and config.aimbot.drawFOV
    fovCircle.Radius = config.aimbot.fov
    fovCircle.Position = Vector2.new(game.Workspace.CurrentCamera.ViewportSize.X / 2, game.Workspace.CurrentCamera.ViewportSize.Y / 2)
end)

-- ESP Implementation
local espObjects = {}

local function createESPObject(player)
    if player == LocalPlayer then return end
    
    local espObject = {
        box = Drawing.new("Square"),
        tracer = Drawing.new("Line"),
        name = Drawing.new("Text"),
        player = player
    }
    
    espObject.box.Thickness = 1
    espObject.box.Filled = false
    espObject.box.Transparency = 1
    espObject.box.Color = config.esp.boxColor
    espObject.box.Visible = false
    
    espObject.tracer.Thickness = 1
    espObject.tracer.Transparency = 1
    espObject.tracer.Color = config.esp.boxColor
    espObject.tracer.Visible = false
    
    espObject.name.Size = 14
    espObject.name.Center = true
    espObject.name.Outline = true
    espObject.name.Color = Color3.fromRGB(255, 255, 255)
    espObject.name.Visible = false
    
    espObjects[player] = espObject
    return espObject
end

local function removeESPObject(player)
    local espObject = espObjects[player]
    if espObject then
        espObject.box:Remove()
        espObject.tracer:Remove()
        espObject.name:Remove()
        espObjects[player] = nil
    end
end

local function isTeammate(player)
    if not config.esp.teamCheck then return false end
    return player.Team == LocalPlayer.Team
end

local function updateESP()
    for player, espObject in pairs(espObjects) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            local humanoidRootPart = player.Character.HumanoidRootPart
            local head = player.Character:FindFirstChild("Head")
            local isVisible = true
            
            if isTeammate(player) then
                isVisible = false
            end
            
            if isVisible and config.esp.enabled then
                local rootPos, onScreen = game.Workspace.CurrentCamera:WorldToViewportPoint(humanoidRootPart.Position)
                
                if onScreen then
                    -- Update Box ESP
                    if config.esp.boxEsp then
                        local size = Vector3.new(4, 5, 0) * (1 / (rootPos.Z * 0.2)) * 2
                        local boxPosition = Vector2.new(rootPos.X - size.X / 2, rootPos.Y - size.Y / 2)
                        
                        espObject.box.Size = Vector2.new(size.X, size.Y)
                        espObject.box.Position = boxPosition
                        espObject.box.Visible = true
                    else
                        espObject.box.Visible = false
                    end
                    
                    -- Update Tracer ESP
                    if config.esp.tracerEsp then
                        espObject.tracer.From = Vector2.new(game.Workspace.CurrentCamera.ViewportSize.X / 2, game.Workspace.CurrentCamera.ViewportSize.Y)
                        espObject.tracer.To = Vector2.new(rootPos.X, rootPos.Y)
                        espObject.tracer.Visible = true
                    else
                        espObject.tracer.Visible = false
                    end
                    
                    -- Update Name ESP
                    if config.esp.nameEsp and head then
                        local headPos = game.Workspace.CurrentCamera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                        espObject.name.Position = Vector2.new(headPos.X, headPos.Y - 40)
                        espObject.name.Text = player.Name
                        espObject.name.Visible = true
                    else
                        espObject.name.Visible = false
                    end
                else
                    espObject.box.Visible = false
                    espObject.tracer.Visible = false
                    espObject.name.Visible = false
                end
            else
                espObject.box.Visible = false
                espObject.tracer.Visible = false
                espObject.name.Visible = false
            end
        else
            espObject.box.Visible = false
            espObject.tracer.Visible = false
            espObject.name.Visible = false
        end
    end
end

-- Aimbot Implementation
local function getClosestPlayerToCursor()
    local closestPlayer = nil
    local shortestDistance = math.huge
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 and player.Character:FindFirstChild(config.aimbot.targetPart) then
            if config.aimbot.teamCheck and player.Team == LocalPlayer.Team then
                continue
            end
            
            local targetPart = player.Character[config.aimbot.targetPart]
            local pos, onScreen = game.Workspace.CurrentCamera:WorldToViewportPoint(targetPart.Position)
            
            if onScreen then
                local screenPos = Vector2.new(pos.X, pos.Y)
                local mousePos = Vector2.new(game.Workspace.CurrentCamera.ViewportSize.X / 2, game.Workspace.CurrentCamera.ViewportSize.Y / 2)
                local distance = (screenPos - mousePos).Magnitude
                
                if distance < shortestDistance and distance <= config.aimbot.fov then
                    if config.aimbot.visibilityCheck then
                        local ray = Ray.new(game.Workspace.CurrentCamera.CFrame.Position, (targetPart.Position - game.Workspace.CurrentCamera.CFrame.Position).Unit * 1000)
                        local hit, _ = game.Workspace:FindPartOnRayWithIgnoreList(ray, {LocalPlayer.Character})
                        
                        if hit and hit:IsDescendantOf(player.Character) then
                            closestPlayer = player
                            shortestDistance = distance
                        end
                    else
                        closestPlayer = player
                        shortestDistance = distance
                    end
                end
            end
        end
    end
    
    return closestPlayer
end

-- Gun Mods Implementation
local function applyGunMods()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool") then
        local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
        
        if tool:FindFirstChild("RecoilMax") and config.gunMods.noRecoil then
            tool.RecoilMax.Value = 0
            tool.RecoilMin.Value = 0
        end
        
        if tool:FindFirstChild("Spread") and config.gunMods.noSpread then
            tool.Spread.Value = 0
            tool.MaxSpread.Value = 0
        end
        
        if tool:FindFirstChild("FireRate") and config.gunMods.rapidFire then
            tool.FireRate.Value = tool.FireRate.Value * 2
        end
        
        if tool:FindFirstChild("Ammo") and config.gunMods.infiniteAmmo then
            tool.Ammo.Value = tool.MaxAmmo.Value
        end
    end
end

-- Main Loop
RunService.RenderStepped:Connect(function()
    updateESP()
    
    if config.aimbot.enabled then
        local target = getClosestPlayerToCursor()
        if target and target.Character and target.Character:FindFirstChild(config.aimbot.targetPart) then
            local pos = game.Workspace.CurrentCamera:WorldToViewportPoint(target.Character[config.aimbot.targetPart].Position)
            mousemoveabs(pos.X, pos.Y)
        end
    end
    
    if config.gunMods.noRecoil or config.gunMods.noSpread or config.gunMods.rapidFire or config.gunMods.infiniteAmmo then
        applyGunMods()
    end
end)

-- Player Added/Removed Events
Players.PlayerAdded:Connect(function(player)
    createESPObject(player)
end)

Players.PlayerRemoving:Connect(function(player)
    removeESPObject(player)
end)

-- Initialize ESP for existing players
for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        createESPObject(player)
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
notificationText.Text = "SwebScript Compact loaded! Press Right Shift to toggle."
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

return ScreenGui
