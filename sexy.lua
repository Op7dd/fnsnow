local RunService = game:GetService("RunService")
local noclipAtivo = false
local noclipConnection = noclipAtivo

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


local speedAtiva = false

local speedBox = Instance.new("TextBox")
speedBox.Name = "SpeedInput"
speedBox.Size = UDim2.new(0, 150, 0, 50)
speedBox.Position = UDim2.new(0, 10, 0, 60)
speedBox.BackgroundColor3 = Color3.fromRGB(255, 0, 255)
speedBox.Text = "choose 0-100"
speedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
speedBox.TextSize = 17
speedBox.Font = Enum.Font.SourceSansBold
speedBox.ClearTextOnFocus = true
speedBox.Parent = frame
speedBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:WaitForChild("Humanoid")

        local numero= tonumber(speedBox.Text)

        if numero then
            numero = math.clamp(numero, 0, 100)

            humanoid.WalkSpeed = numero
            speedBox.Text = tostring(numero)
            

            print("Ws setado para:", numero)
        else
            print("valor invalido")
        end
    end
end)

local infJumpButton = Instance.new("TextButton")
infJumpButton.Name = "InfJump"
infJumpButton.Size = UDim2.new(0, 150, 0, 50)
infJumpButton.Position = UDim2.new(0, 10, 0, 120)
infJumpButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
infJumpButton.Text = "Infinite Jump: OFF"
infJumpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
infJumpButton.TextSize = 16
infJumpButton.Font = Enum.Font.SourceSansBold
infJumpButton.Parent = frame

local infJumpAtivo = false

infJumpButton.MouseButton1Click:Connect(function()
    infJumpAtivo = not infJumpAtivo

    if infJumpAtivo then
        infJumpButton.Text = "Infinite jump: ON"
        print("Infinite jump ligado")
    else
        infJumpButton.Text = "Infinite Jump: OFF"
        print("Infinite Jump Desligado")
    end
end)

local toggleKey = Enum.KeyCode.E
local esperandoTecla = false

local uiAberta = true

local keyBindButton = Instance.new("TextButton")
keyBindButton.Size = UDim2.new(0, 150, 0, 40)
keyBindButton.Position = UDim2.new(0,10, 0, 180)
keyBindButton.BackgroundColor3 = Color3.fromRGB(80, 0, 80)
keyBindButton.Text = "Key: E"
keyBindButton.TextColor3 = Color3.fromRGB(255, 255, 255)
keyBindButton.Font = Enum.Font.SourceSansBold
keyBindButton.TextSize = 16
keyBindButton.Parent = frame

keyBindButton.MouseButton1Click:Connect(function()
    esperandoTecla = true
    keyBindButton.Text = "Pressione uma tecla"
end)

local noclipButton = Instance.new("TextButton")
noclipButton.Name = "noclipButton"
noclipButton.Size = UDim2.new(0, 120, 0, 50)
noclipButton.Position = UDim2.new(0.5, 5, 0, 120)
noclipButton.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
noclipButton.Text = "Nouclipi du meusobrinio off"
noclipButton.TextColor3 = Color3.fromRGB(255, 255 ,255)
noclipButton.TextSize = 16
noclipButton.Font = Enum.Font.SourceSansBold
noclipButton.Parent = frame

local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleUI"
toggleButton.Size = UDim2.new(0, 120, 0, 40)
toggleButton.Position = UDim2.new(0, 10, 0, 230)
toggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
toggleButton.Text = "Abridu"
toggleButton.TextColor3 = Color3.fromRGB(255, 0, 255)
toggleButton.TextSize = 16
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.Parent = screenGui



toggleButton.MouseButton1Click:Connect(function()
    uiAberta = not uiAberta

    frame.Visible = uiAberta

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
    infJumpAtivo = false
    uiAberta = false

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

UserInputService.JumpRequest:Connect(function()
    if infJumpAtivo then
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:FindFirstChildOfClass("Humanoid")

        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    if esperandoTecla then
        if input.UserInputType == Enum.UserInputType.Keyboard then
            toggleKey = input.KeyCode
            keyBindButton.Text = "Key: " .. input.KeyCode.Name
            esperandoTecla = false
        end
        return
    end

    if input.KeyCode == toggleKey and not UserInputService:GetFocusedTextBox() then
        uiAberta = not uiAberta
        frame.Visible = uiAberta

        if uiAberta then
            toggleButton.Text = "desabridu"
        else
            toggleButton.Text = "Abrir rego do stebi"
            end
        end
    end)


noclipButton.MouseButton1Click:Connect(function()
    noclipAtivo = not noclipAtivo

    if noclipAtivo then
        noclipButton.Text = "nocripi du leumeusobrinio ON"
        noclipButton.BackgroundColor3 = Color3.fromRGB(0,255,120)

        noclipConnection = RunService.Stepped:Connect(function()
            if player.Character then
                for _, part in pairs(player.Character:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide == true then
                        part.CanCollide = false
                    end
                end
            end
        end)
        print("NUcripi ativadu")
    else
        noclipButton.Text = "Noclip OFIUM"
        noclipButton.BackgroundColor3 = Color3.fromRGB(0, 200, 100)

        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
        print("nocripi disativado")
    end
end)
