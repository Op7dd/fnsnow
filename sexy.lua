local UserInputService = game:GetService("UserInputService")
local players = game:GetService("Players")
local player = players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "sexy Ui"
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Name = "quadrado sexy"
frame.Size = UDim2.new(0, 300, 0, 300)
frame.Position = UDim2.new(0.5, -150, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
frame.Active = true
frame.BorderSizePixel = 2
frame.Parent = screenGui

local closeButton = Instance.new("TextButton")
closeButton.Name = "FechadaSexy"
closeButton.Size = UDim2.new(0, 40, 0, 40)
closeButton.Position = UDim2.new(1, -45, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.Text = "🥵"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 20
closeButton.Font = Enum.Font.SourceSansBold
closeButton.Parent = frame

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
    print("UI Gozada com sucesso")
end)

local button = Instance.new("TextButton")
button.Name = "Butaum du emicoatro"
button.Size = UDim2.new(0, 150, 0, 50)
button.Position = UDim2.new(0.5, 10, 0, -60)
button.BackgroundColor3 = Color3.fromRGB(255, 0, 255)
button.Text = "Cor du leumeusobrinio"
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.TextSize = 17
button.Font = Enum.Font.SourceSansBold
button.Parent = frame
button.MouseButton1Click:Connect(function()
    print("Voze crico nu butau du leumeusobrinio")
    end)

local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleUI"
toggleButton.Size = UDim2.new(0, 120, 0, 40)
toggleButton.Position = UDim2.new(0, 10, 0.5, -20)
toggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
toggleButton.Text = "Abridu"
toggleButton.TextColor3 = Color3.fromRGB(255, 0, 255)
toggleButton.TextSize = 16
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.Parent = screenGui

local uiAberta = true

toggleButton.MouseButton1Click:Connect(function()
    uiAberta = not uiAberta

    screenGui.Enabled = uiAberta

    if uiAberta then
        toggleButton.Text = "desabridu"
    else
        toggleButton.Text = "Abrir rego do stebi"
        end
    end)

local toggleGui = Instance.new("ScreenGui")
toggleGui.Name = "ToggleGui"
toggleGui.Parent = playerGui

toggleButton.Parent = toggleGui

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
    toggleGui:Destroy()
end)


local dragging
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    
    frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true         
        dragStart = input.Position
        startPos = frame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)
