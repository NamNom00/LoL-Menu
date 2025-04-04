-- LoL Menu Exploit Script
-- Compatible with both PC and Mobile

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- GUI Elements
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local LeftPanel = Instance.new("Frame")
local RightPanel = Instance.new("Frame")
local CategoryFrame = Instance.new("Frame")
local UIListLayout = Instance.new("UIListLayout")
local TitleBar = Instance.new("Frame")
local TitleText = Instance.new("TextLabel")
local MinimizeButton = Instance.new("TextButton")
local CloseButton = Instance.new("TextButton")
local ContentFrame = Instance.new("Frame")
local MenuContent = Instance.new("Frame")
local PlayerContent = Instance.new("Frame")
local MiscContent = Instance.new("Frame")
local AboutContent = Instance.new("Frame")
local MinimizedIcon = Instance.new("ImageButton")

-- Variables
local isDragging = false
local dragStart = nil
local startPos = nil
local isMinimized = false
local currentCategory = "Menu"
local ESPEnabled = false
local InfJumpEnabled = false
local NoclipEnabled = false
local ESPConnections = {}

-- Core UI Setup
ScreenGui.Name = "LoLMenu"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
MainFrame.Size = UDim2.new(0, 400, 0, 300)
MainFrame.ClipsDescendants = true
MainFrame.Active = true

TitleBar.Name = "TitleBar"
TitleBar.Parent = MainFrame
TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
TitleBar.BorderSizePixel = 0
TitleBar.Size = UDim2.new(1, 0, 0, 30)

TitleText.Name = "TitleText"
TitleText.Parent = TitleBar
TitleText.BackgroundTransparency = 1
TitleText.Position = UDim2.new(0, 10, 0, 0)
TitleText.Size = UDim2.new(1, -60, 1, 0)
TitleText.Font = Enum.Font.SourceSansBold
TitleText.Text = "LoL Menu"
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.TextSize = 18
TitleText.TextXAlignment = Enum.TextXAlignment.Left

MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Parent = TitleBar
MinimizeButton.BackgroundTransparency = 1
MinimizeButton.Position = UDim2.new(1, -50, 0, 0)
MinimizeButton.Size = UDim2.new(0, 30, 1, 0)
MinimizeButton.Font = Enum.Font.SourceSansBold
MinimizeButton.Text = "-"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.TextSize = 20

CloseButton.Name = "CloseButton"
CloseButton.Parent = TitleBar
CloseButton.BackgroundTransparency = 1
CloseButton.Position = UDim2.new(1, -30, 0, 0)
CloseButton.Size = UDim2.new(0, 30, 1, 0)
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 80, 80)
CloseButton.TextSize = 18

LeftPanel.Name = "LeftPanel"
LeftPanel.Parent = MainFrame
LeftPanel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
LeftPanel.BorderSizePixel = 0
LeftPanel.Position = UDim2.new(0, 0, 0, 30)
LeftPanel.Size = UDim2.new(0, 120, 1, -30)

CategoryFrame.Name = "CategoryFrame"
CategoryFrame.Parent = LeftPanel
CategoryFrame.BackgroundTransparency = 1
CategoryFrame.Position = UDim2.new(0, 0, 0, 10)
CategoryFrame.Size = UDim2.new(1, 0, 1, -10)

UIListLayout.Parent = CategoryFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)

RightPanel.Name = "RightPanel"
RightPanel.Parent = MainFrame
RightPanel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
RightPanel.BorderSizePixel = 0
RightPanel.Position = UDim2.new(0, 120, 0, 30)
RightPanel.Size = UDim2.new(1, -120, 1, -30)

ContentFrame.Name = "ContentFrame"
ContentFrame.Parent = RightPanel
ContentFrame.BackgroundTransparency = 1
ContentFrame.Size = UDim2.new(1, 0, 1, 0)

MenuContent.Name = "MenuContent"
MenuContent.Parent = ContentFrame
MenuContent.BackgroundTransparency = 1
MenuContent.Size = UDim2.new(1, 0, 1, 0)
MenuContent.Visible = true

PlayerContent.Name = "PlayerContent"
PlayerContent.Parent = ContentFrame
PlayerContent.BackgroundTransparency = 1
PlayerContent.Size = UDim2.new(1, 0, 1, 0)
PlayerContent.Visible = false

MiscContent.Name = "MiscContent"
MiscContent.Parent = ContentFrame
MiscContent.BackgroundTransparency = 1
MiscContent.Size = UDim2.new(1, 0, 1, 0)
MiscContent.Visible = false

AboutContent.Name = "AboutContent"
AboutContent.Parent = ContentFrame
AboutContent.BackgroundTransparency = 1
AboutContent.Size = UDim2.new(1, 0, 1, 0)
AboutContent.Visible = false

MinimizedIcon.Name = "MinimizedIcon"
MinimizedIcon.Parent = ScreenGui
MinimizedIcon.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MinimizedIcon.BorderSizePixel = 0
MinimizedIcon.Position = UDim2.new(0, 10, 0, 10)
MinimizedIcon.Size = UDim2.new(0, 40, 0, 40)
MinimizedIcon.Image = "rbxassetid://6026568198"  -- Menu icon
MinimizedIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
MinimizedIcon.Visible = false

-- Create Category Buttons
local function CreateCategoryButton(name, order)
    local button = Instance.new("TextButton")
    button.Name = name .. "Button"
    button.Parent = CategoryFrame
    button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    button.BorderSizePixel = 0
    button.Size = UDim2.new(1, -10, 0, 30)
    button.Position = UDim2.new(0, 5, 0, 0)
    button.Font = Enum.Font.SourceSansBold
    button.Text = name
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 14
    button.LayoutOrder = order
    
    button.MouseButton1Click:Connect(function()
        SwitchCategory(name)
    end)
    
    return button
end

-- Create Categories
local menuButton = CreateCategoryButton("Menu", 1)
local playerButton = CreateCategoryButton("Player", 2)
local miscButton = CreateCategoryButton("Misc", 3)
local aboutButton = CreateCategoryButton("About", 4)

-- Helper Functions
local function UpdateCategoryButtonColors()
    menuButton.BackgroundColor3 = currentCategory == "Menu" and Color3.fromRGB(45, 45, 45) or Color3.fromRGB(35, 35, 35)
    playerButton.BackgroundColor3 = currentCategory == "Player" and Color3.fromRGB(45, 45, 45) or Color3.fromRGB(35, 35, 35)
    miscButton.BackgroundColor3 = currentCategory == "Misc" and Color3.fromRGB(45, 45, 45) or Color3.fromRGB(35, 35, 35)
    aboutButton.BackgroundColor3 = currentCategory == "About" and Color3.fromRGB(45, 45, 45) or Color3.fromRGB(35, 35, 35)
end

function SwitchCategory(category)
    MenuContent.Visible = category == "Menu"
    PlayerContent.Visible = category == "Player"
    MiscContent.Visible = category == "Misc"
    AboutContent.Visible = category == "About"
    
    currentCategory = category
    UpdateCategoryButtonColors()
end

-- Create Label with Value
local function CreateLabelWithValue(parent, name, value, posY)
    local container = Instance.new("Frame")
    container.Name = name .. "Container"
    container.Parent = parent
    container.BackgroundTransparency = 1
    container.Position = UDim2.new(0, 10, 0, posY)
    container.Size = UDim2.new(1, -20, 0, 25)
    
    local label = Instance.new("TextLabel")
    label.Name = name .. "Label"
    label.Parent = container
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(0.5, 0, 1, 0)
    label.Font = Enum.Font.SourceSans
    label.Text = name .. ":"
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Name = name .. "Value"
    valueLabel.Parent = container
    valueLabel.BackgroundTransparency = 1
    valueLabel.Position = UDim2.new(0.5, 0, 0, 0)
    valueLabel.Size = UDim2.new(0.5, 0, 1, 0)
    valueLabel.Font = Enum.Font.SourceSans
    valueLabel.Text = value
    valueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    valueLabel.TextSize = 16
    valueLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    return valueLabel
end

-- Create Slider
local function CreateSlider(parent, name, min, max, default, posY, callback)
    local container = Instance.new("Frame")
    container.Name = name .. "Container"
    container.Parent = parent
    container.BackgroundTransparency = 1
    container.Position = UDim2.new(0, 10, 0, posY)
    container.Size = UDim2.new(1, -20, 0, 50)
    
    local label = Instance.new("TextLabel")
    label.Name = name .. "Label"
    label.Parent = container
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Font = Enum.Font.SourceSans
    label.Text = name .. ": " .. default
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local sliderBG = Instance.new("Frame")
    sliderBG.Name = "SliderBG"
    sliderBG.Parent = container
    sliderBG.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    sliderBG.BorderSizePixel = 0
    sliderBG.Position = UDim2.new(0, 0, 0, 25)
    sliderBG.Size = UDim2.new(1, 0, 0, 10)
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Name = "SliderFill"
    sliderFill.Parent = sliderBG
    sliderFill.BackgroundColor3 = Color3.fromRGB(80, 80, 255)
    sliderFill.BorderSizePixel = 0
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    
    local sliderButton = Instance.new("TextButton")
    sliderButton.Name = "SliderButton"
    sliderButton.Parent = sliderBG
    sliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sliderButton.BorderSizePixel = 0
    sliderButton.Position = UDim2.new((default - min) / (max - min), -5, 0, -5)
    sliderButton.Size = UDim2.new(0, 10, 0, 20)
    sliderButton.Text = ""
    sliderButton.AutoButtonColor = false
    
    local value = default
    local dragging = false
    
    local function update(input)
        local pos = UDim2.new(math.clamp((input.Position.X - sliderBG.AbsolutePosition.X) / sliderBG.AbsoluteSize.X, 0, 1), -5, 0, -5)
        sliderButton.Position = pos
        sliderFill.Size = UDim2.new(pos.X.Scale, 0, 1, 0)
        
        local calculatedValue = math.floor(min + ((max - min) * pos.X.Scale))
        value = calculatedValue
        label.Text = name .. ": " .. calculatedValue
        
        if callback then
            callback(calculatedValue)
        end
    end
    
    sliderButton.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            update(input)
        end
    end)
    
    sliderBG.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            update(input)
        end
    end)
    
    return container, function() return value end
end

-- Create Toggle Button
local function CreateToggle(parent, name, posY, callback)
    local container = Instance.new("Frame")
    container.Name = name .. "Container"
    container.Parent = parent
    container.BackgroundTransparency = 1
    container.Position = UDim2.new(0, 10, 0, posY)
    container.Size = UDim2.new(1, -20, 0, 30)
    
    local label = Instance.new("TextLabel")
    label.Name = name .. "Label"
    label.Parent = container
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Font = Enum.Font.SourceSans
    label.Text = name
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = name .. "Button"
    toggleButton.Parent = container
    toggleButton.Position = UDim2.new(0.7, 0, 0, 0)
    toggleButton.Size = UDim2.new(0.3, -5, 1, 0)
    toggleButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    toggleButton.BorderSizePixel = 0
    toggleButton.Font = Enum.Font.SourceSansBold
    toggleButton.Text = "OFF"
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.TextSize = 16
    
    local enabled = false
    
    toggleButton.MouseButton1Click:Connect(function()
        enabled = not enabled
        toggleButton.Text = enabled and "ON" or "OFF"
        toggleButton.BackgroundColor3 = enabled and Color3.fromRGB(80, 180, 80) or Color3.fromRGB(80, 80, 80)
        
        if callback then
            callback(enabled)
        end
    end)
    
    return container, function() return enabled end, function(value) 
        enabled = value
        toggleButton.Text = enabled and "ON" or "OFF"
        toggleButton.BackgroundColor3 = enabled and Color3.fromRGB(80, 180, 80) or Color3.fromRGB(80, 80, 80)
    end
end

-- Create Player Selection Dropdown
local function CreatePlayerDropdown(parent, posY)
    local container = Instance.new("Frame")
    container.Name = "PlayerSelectContainer"
    container.Parent = parent
    container.BackgroundTransparency = 1
    container.Position = UDim2.new(0, 10, 0, posY)
    container.Size = UDim2.new(1, -20, 0, 30)
    
    local label = Instance.new("TextLabel")
    label.Name = "PlayerSelectLabel"
    label.Parent = container
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(0.4, 0, 1, 0)
    label.Font = Enum.Font.SourceSans
    label.Text = "Select Player:"
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local dropdown = Instance.new("TextButton")
    dropdown.Name = "PlayerDropdown"
    dropdown.Parent = container
    dropdown.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    dropdown.BorderSizePixel = 0
    dropdown.Position = UDim2.new(0.4, 5, 0, 0)
    dropdown.Size = UDim2.new(0.6, -5, 1, 0)
    dropdown.Font = Enum.Font.SourceSans
    dropdown.Text = "Select..."
    dropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
    dropdown.TextSize = 14
    
    local dropdownList = Instance.new("ScrollingFrame")
    dropdownList.Name = "DropdownList"
    dropdownList.Parent = parent
    dropdownList.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    dropdownList.BorderSizePixel = 0
    dropdownList.Position = UDim2.new(0.4, 15, 0, posY + 30)
    dropdownList.Size = UDim2.new(0.6, -25, 0, 100)
    dropdownList.Visible = false
    dropdownList.ScrollBarThickness = 6
    dropdownList.CanvasSize = UDim2.new(0, 0, 0, 0)
    
    local UIListLayout2 = Instance.new("UIListLayout")
    UIListLayout2.Parent = dropdownList
    UIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout2.Padding = UDim.new(0, 2)
    
    local selectedPlayer = nil
    
    local function refreshPlayerList()
        for _, child in pairs(dropdownList:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end
        
        local order = 0
        for _, player in pairs(Players:GetPlayers()) do
            local button = Instance.new("TextButton")
            button.Name = player.Name .. "Button"
            button.Parent = dropdownList
            button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            button.BorderSizePixel = 0
            button.Size = UDim2.new(1, 0, 0, 24)
            button.Font = Enum.Font.SourceSans
            button.Text = player.Name
            button.TextColor3 = Color3.fromRGB(255, 255, 255)
            button.TextSize = 14
            button.LayoutOrder = order
            
            button.MouseButton1Click:Connect(function()
                dropdown.Text = player.Name
                selectedPlayer = player
                dropdownList.Visible = false
            end)
            
            order = order + 1
        end
        
        dropdownList.CanvasSize = UDim2.new(0, 0, 0, UIListLayout2.AbsoluteContentSize.Y)
    end
    
    dropdown.MouseButton1Click:Connect(function()
        refreshPlayerList()
        dropdownList.Visible = not dropdownList.Visible
    end)
    
    return container, dropdownList, function() return selectedPlayer end
end

-- Create Subplaces Dropdown
local function CreateSubplacesDropdown(parent, posY)
    local container = Instance.new("Frame")
    container.Name = "SubplacesSelectContainer"
    container.Parent = parent
    container.BackgroundTransparency = 1
    container.Position = UDim2.new(0, 10, 0, posY)
    container.Size = UDim2.new(1, -20, 0, 30)
    
    local label = Instance.new("TextLabel")
    label.Name = "SubplacesSelectLabel"
    label.Parent = container
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(0.4, 0, 1, 0)
    label.Font = Enum.Font.SourceSans
    label.Text = "Select Subplace:"
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local dropdown = Instance.new("TextButton")
    dropdown.Name = "SubplacesDropdown"
    dropdown.Parent = container
    dropdown.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    dropdown.BorderSizePixel = 0
    dropdown.Position = UDim2.new(0.4, 5, 0, 0)
    dropdown.Size = UDim2.new(0.6, -5, 1, 0)
    dropdown.Font = Enum.Font.SourceSans
    dropdown.Text = "Select..."
    dropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
    dropdown.TextSize = 14
    
    local dropdownList = Instance.new("ScrollingFrame")
    dropdownList.Name = "SubplacesDropdownList"
    dropdownList.Parent = parent
    dropdownList.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    dropdownList.BorderSizePixel = 0
    dropdownList.Position = UDim2.new(0.4, 15, 0, posY + 30)
    dropdownList.Size = UDim2.new(0.6, -25, 0, 100)
    dropdownList.Visible = false
    dropdownList.ScrollBarThickness = 6
    dropdownList.CanvasSize = UDim2.new(0, 0, 0, 0)
    
    local UIListLayout3 = Instance.new("UIListLayout")
    UIListLayout3.Parent = dropdownList
    UIListLayout3.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout3.Padding = UDim.new(0, 2)
    
    local selectedSubplace = nil
    local subplaces = {}
    
    -- Mock subplaces for demonstration (in a real scenario, you'd get these from the game)
    table.insert(subplaces, {name = "Main Lobby", id = 1234567})
    table.insert(subplaces, {name = "Game Arena", id = 1234568})
    table.insert(subplaces, {name = "Shop", id = 1234569})
    
    local function refreshSubplacesList()
        for _, child in pairs(dropdownList:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end
        
        local order = 0
        for _, subplace in pairs(subplaces) do
            local button = Instance.new("TextButton")
            button.Name = subplace.name .. "Button"
            button.Parent = dropdownList
            button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            button.BorderSizePixel = 0
            button.Size = UDim2.new(1, 0, 0, 24)
            button.Font = Enum.Font.SourceSans
            button.Text = subplace.name
            button.TextColor3 = Color3.fromRGB(255, 255, 255)
            button.TextSize = 14
            button.LayoutOrder = order
            
            button.MouseButton1Click:Connect(function()
                dropdown.Text = subplace.name
                selectedSubplace = subplace
                dropdownList.Visible = false
            end)
            
            order = order + 1
        end
        
        dropdownList.CanvasSize = UDim2.new(0, 0, 0, UIListLayout3.AbsoluteContentSize.Y)
    end
    
    dropdown.MouseButton1Click:Connect(function()
        refreshSubplacesList()
        dropdownList.Visible = not dropdownList.Visible
    end)
    
    return container, dropdownList, function() return selectedSubplace end
end

-- Create Teleport Button
local function CreateButton(parent, name, posY, callback)
    local button = Instance.new("TextButton")
    button.Name = name .. "Button"
    button.Parent = parent
    button.BackgroundColor3 = Color3.fromRGB(60, 100, 200)
    button.BorderSizePixel = 0
    button.Position = UDim2.new(0, 10, 0, posY)
    button.Size = UDim2.new(1, -20, 0, 30)
    button.Font = Enum.Font.SourceSansBold
    button.Text = name
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 16
    
    button.MouseButton1Click:Connect(callback)
    
    return button
end

-- Fill Menu Content
local playersCountValue = CreateLabelWithValue(MenuContent, "Players Count", "0", 20)
local gameNameValue = CreateLabelWithValue(MenuContent, "Game Name", game.Name, 50)
local playerPosValue = CreateLabelWithValue(MenuContent, "Player Position", "0, 0, 0", 80)

-- Update Menu Information
local function UpdateMenuInfo()
    playersCountValue.Text = #Players:GetPlayers()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local pos = char.HumanoidRootPart.Position
        playerPosValue.Text = math.floor(pos.X) .. ", " .. math.floor(pos.Y) .. ", " .. math.floor(pos.Z)
    else
        playerPosValue.Text = "0, 0, 0"
    end
end

-- Fill Player Content
local walkspeedSlider, getWalkspeed = CreateSlider(PlayerContent, "Walkspeed", 1, 100, 16, 20, function(value)
    local character = LocalPlayer.Character
    if character and character:FindFirstChild("Humanoid") then
        character.Humanoid.WalkSpeed = value
    end
end)

local jumpPowerSlider, getJumpPower = CreateSlider(PlayerContent, "Jump Power", 1, 100, 50, 80, function(value)
    local character = LocalPlayer.Character
    if character and character:FindFirstChild("Humanoid") then
        character.Humanoid.JumpPower = value
    end
end)

local infJumpToggle, getInfJump, setInfJump = CreateToggle(PlayerContent, "Infinite Jump", 140, function(enabled)
    InfJumpEnabled = enabled
end)

local noclipToggle, getNoclip, setNoclip = CreateToggle(PlayerContent, "Noclip", 180, function(enabled)
    NoclipEnabled = enabled
end)

-- Fill Misc Content
local espToggle, getESP, setESP = CreateToggle(MiscContent, "Player ESP", 20, function(enabled)
    ESPEnabled = enabled
    if enabled then
        EnableESP()
    else
        DisableESP()
    end
end)

local playerSelect, playerDropdown, getSelectedPlayer = CreatePlayerDropdown(MiscContent, 60)
local playerTeleportButton = CreateButton(MiscContent, "Teleport to Player", 170, function()
    local selectedPlayer = getSelectedPlayer()
    if selectedPlayer and selectedPlayer.Character and LocalPlayer.Character then
        local targetHRP = selectedPlayer.Character:FindFirstChild("HumanoidRootPart")
        local localHRP = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if targetHRP and localHRP then
            localHRP.CFrame = targetHRP.CFrame
        end
    end
end)

local subplaceSelect, subplaceDropdown, getSelectedSubplace = CreateSubplacesDropdown(MiscContent, 210)
local subplaceTeleportButton = CreateButton(MiscContent, "Teleport to Subplace", 320, function()
    local selectedSubplace = getSelectedSubplace()
    if selectedSubplace then
        -- In a real exploit, you would use TeleportService to teleport to the subplace
        print("Teleporting to: " .. selectedSubplace.name .. " (ID: " .. selectedSubplace.id .. ")")
        -- TeleportService:Teleport(selectedSubplace.id, LocalPlayer)
    end
end)

-- Fill About Content
local aboutContainer = Instance.new("Frame")
aboutContainer.Name = "AboutInfo"
aboutContainer.Parent = AboutContent
aboutContainer.BackgroundTransparency = 1
aboutContainer.Position = UDim2.new(0, 10, 0, 20)
aboutContainer.Size = UDim2.new(1, -20, 1, -30)

local discordLabel = Instance.new("TextLabel")
discordLabel.Name = "DiscordLabel"
discordLabel.Parent = aboutContainer
discordLabel.BackgroundTransparency = 1
discordLabel.Position = UDim2.new(0, 0, 0, 0)
discordLabel.Size = UDim2.new(1, 0, 0, 30)
discordLabel.Font = Enum.Font.SourceSansBold
discordLabel.Text = "Discord Server: Unavailable"
discordLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
discordLabel.TextSize = 16
discordLabel.TextXAlignment = Enum.TextXAlignment.Left

local ownerLabel = Instance.new("TextLabel")
ownerLabel.Name = "OwnerLabel"
ownerLabel.Parent = aboutContainer
ownerLabel.BackgroundTransparency = 1
ownerLabel.Position = UDim2.new(0, 0, 0, 40)
ownerLabel.Size = UDim2.new(1, 0, 0, 30)
ownerLabel.Font = Enum.Font.SourceSansBold
ownerLabel.Text = "Owner: Lol"
ownerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
ownerLabel.TextSize = 16
ownerLabel.TextXAlignment = Enum.TextXAlignment.Left

-- ESP Functions
function EnableESP()
    DisableESP() -- Clean up existing ESP
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local function createESP()
                if not player.Character or not player.Character:FindFirstChild("Head") then return end
                
                local billboardGui = Instance.new("BillboardGui")
                billboardGui.Name = "ESP_" .. player.Name
                billboardGui.Adornee = player.Character.Head
                billboardGui.AlwaysOnTop = true
                billboardGui.Size = UDim2.new(0, 100, 0, 40)
                billboardGui.StudsOffset = Vector3.new(0, 2, 0)
                billboardGui.Parent = player.Character.Head
                
                local nameLabel = Instance.new("TextLabel")
                nameLabel.Name = "NameLabel"
                nameLabel.BackgroundTransparency = 1
                nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
                nameLabel.Font = Enum.Font.SourceSansBold
                nameLabel.Text = player.Name
                nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                nameLabel.TextSize = 14
                nameLabel.TextStrokeTransparency = 0.5
                nameLabel.Parent = billboardGui
                
                local displayNameLabel = Instance.new("TextLabel")
                displayNameLabel.Name = "DisplayNameLabel"
                displayNameLabel.BackgroundTransparency = 1
                displayNameLabel.Position = UDim2.new(0, 0, 0.5, 0)
                displayNameLabel.Size = UDim2.new(1, 0, 0.5, 0)
                displayNameLabel.Font = Enum.Font.SourceSans
                displayNameLabel.Text = player.DisplayName
                displayNameLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
                displayNameLabel.TextSize = 12
                displayNameLabel.TextStrokeTransparency = 0.5
                displayNameLabel.Parent = billboardGui
                
                -- Add dot
                local dot = Instance.new("Frame")
                dot.Name = "Dot"
                dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                dot.BorderSizePixel = 0
                dot.Position = UDim2.new(0.5, -2, 1, 0)
                dot.Size = UDim2.new(0, 4, 0, 4)
                dot.Parent = billboardGui
                
                -- Add character added event to handle respawns
                local connection = player.CharacterAdded:Connect(function(char)
                    wait(1) -- Wait for character to load
                    if ESPEnabled then
                        createESP()
                    end
                end)
                
                table.insert(ESPConnections, connection)
            end
            
            createESP()
        end
    end
    
    -- Handle new players joining
    local playersConnection = Players.PlayerAdded:Connect(function(player)
        wait(2) -- Wait for character to load
        if ESPEnabled then
            createESP(player)
        end
    end)
    
    table.insert(ESPConnections, playersConnection)
end

function DisableESP()
    for _, connection in pairs(ESPConnections) do
        if connection.Connected then
            connection:Disconnect()
        end
    end
    ESPConnections = {}
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character then
            local esp = player.Character:FindFirstChild("Head"):FindFirstChild("ESP_" .. player.Name)
            if esp then
                esp:Destroy()
            end
        end
    end
end

-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if InfJumpEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- Noclip
RunService.Stepped:Connect(function()
    if NoclipEnabled and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end)

-- Dragging Functionality
TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

TitleBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = false
    end
end)

TitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and isDragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- Minimize and Close Functionality
MinimizeButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    MinimizedIcon.Visible = true
    isMinimized = true
end)

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

MinimizedIcon.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    MinimizedIcon.Visible = false
    isMinimized = false
end)

-- Update info periodically
RunService.Heartbeat:Connect(function()
    if not isMinimized then
        UpdateMenuInfo()
    end
end)

-- Initialize the UI
UpdateCategoryButtonColors()
SwitchCategory("Menu")

-- Function to make all dropdowns close when clicking elsewhere
UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        local position = UserInputService:GetMouseLocation()
        if not playerDropdown.Visible or not subplaceDropdown.Visible then return end
        
        local isInPlayerDropdown = position.X >= playerDropdown.AbsolutePosition.X and
                                  position.X <= playerDropdown.AbsolutePosition.X + playerDropdown.AbsoluteSize.X and
                                  position.Y >= playerDropdown.AbsolutePosition.Y and
                                  position.Y <= playerDropdown.AbsolutePosition.Y + playerDropdown.AbsoluteSize.Y
                                  
        local isInSubplaceDropdown = position.X >= subplaceDropdown.AbsolutePosition.X and
                                    position.X <= subplaceDropdown.AbsolutePosition.X + subplaceDropdown.AbsoluteSize.X and
                                    position.Y >= subplaceDropdown.AbsolutePosition.Y and
                                    position.Y <= subplaceDropdown.AbsolutePosition.Y + subplaceDropdown.AbsoluteSize.Y
        
        if not isInPlayerDropdown and playerDropdown.Visible then
            playerDropdown.Visible = false
        end
        
        if not isInSubplaceDropdown and subplaceDropdown.Visible then
            subplaceDropdown.Visible = false
        end
    end
end)

-- Return a cleanup function
local function cleanup()
    DisableESP()
    RunService:UnbindFromRenderStep("NoClip")
    ScreenGui:Destroy()
end

return cleanup
