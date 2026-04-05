local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local players = game:GetService("Players")
local player = players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local mouse = player:GetMouse()

-- Variáveis de Estado
local noclipAtivo = false
local noclipConnection = nil
local flying = false
local speedFly = 50
local flyLoop = nil
local infJumpAtivo = false
local esperandoTecla = false
local uiAberta = true
local toggleKey = Enum.KeyCode.E

-- --- CRIAÇÃO DA UI PRINCIPAL ---
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SexyUi_Fixed"
screenGui.ResetOnSpawn = false -- ISSO IMPEDE A UI DE SUMIR AO MORRER
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.new(0, 300, 0, 450)
frame.Position = UDim2.new(0.5, -150, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
frame.Active = true
frame.BorderSizePixel = 2
frame.Parent = screenGui

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 40, 0, 40)
closeButton.Position = UDim2.new(1, -45, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.Text = "🥵"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextSize = 20
closeButton.Parent = frame

-- --- FUNÇÃO DA FERRAMENTA DE DELETAR ---
local function darFerramentaDeletar()
    local tool = Instance.new("Tool")
    tool.Name = "Deletar Click"
    tool.RequiresHandle = true
    
    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(1, 1, 1)
    handle.Transparency = 0.5
    handle.BrickColor = BrickColor.new("Bright red")
    handle.Parent = tool
    
    tool.Activated:Connect(function()
        local alvo = mouse.Target
        if alvo and alvo.Name ~= "Baseplate" and alvo.Name ~= "Terrain" then
            alvo:Destroy()
        end
    end)
    tool.Parent = player.Backpack
end

-- --- BOTÕES E INPUTS ---

-- WalkSpeed
local speedBox = Instance.new("TextBox", frame)
speedBox.Size = UDim2.new(0, 140, 0, 50)
speedBox.Position = UDim2.new(0, 10, 0, 60)
speedBox.BackgroundColor3 = Color3.fromRGB(255, 0, 255)
speedBox.Text = "Speed: 16"
speedBox.TextColor3 = Color3.new(1,1,1)
speedBox.Font = Enum.Font.SourceSansBold
speedBox.FocusLost:Connect(function(enter)
    if enter then
        local num = tonumber(speedBox.Text:match("%d+"))
        if num and player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = math.clamp(num, 0, 250)
        end
    end
end)

-- Infinite Jump
local infJumpButton = Instance.new("TextButton", frame)
infJumpButton.Size = UDim2.new(0, 140, 0, 50)
infJumpButton.Position = UDim2.new(0, 10, 0, 120)
infJumpButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
infJumpButton.Text = "InfJump: OFF"
infJumpButton.TextColor3 = Color3.new(1,1,1)
infJumpButton.Font = Enum.Font.SourceSansBold
infJumpButton.MouseButton1Click:Connect(function()
    infJumpAtivo = not infJumpAtivo
    infJumpButton.Text = infJumpAtivo and "InfJump: ON" or "InfJump: OFF"
end)

-- Keybind Button
local keyBindButton = Instance.new("TextButton", frame)
keyBindButton.Size = UDim2.new(0, 140, 0, 40)
keyBindButton.Position = UDim2.new(0, 10, 0, 180)
keyBindButton.BackgroundColor3 = Color3.fromRGB(80, 0, 80)
keyBindButton.Text = "Key: E"
keyBindButton.TextColor3 = Color3.new(1,1,1)
keyBindButton.Font = Enum.Font.SourceSansBold
keyBindButton.MouseButton1Click:Connect(function()
    esperandoTecla = true
    keyBindButton.Text = "..."
end)

-- Noclip Button
local noclipButton = Instance.new("TextButton", frame)
noclipButton.Size = UDim2.new(0, 130, 0, 50)
noclipButton.Position = UDim2.new(0.5, 5, 0, 120)
noclipButton.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
noclipButton.Text = "Noclip: OFF"
noclipButton.TextColor3 = Color3.new(1,1,1)
noclipButton.Font = Enum.Font.SourceSansBold
noclipButton.MouseButton1Click:Connect(function()
    noclipAtivo = not noclipAtivo
    noclipButton.Text = noclipAtivo and "Noclip: ON" or "Noclip: OFF"
    if noclipAtivo then
        noclipConnection = RunService.Stepped:Connect(function()
            if player.Character then
                for _, v in pairs(player.Character:GetDescendants()) do
                    if v:IsA("BasePart") then v.CanCollide = false end
                end
            end
        end)
    else
        if noclipConnection then noclipConnection:Disconnect() end
    end
end)

-- Fly Button
local flyButton = Instance.new("TextButton", frame)
flyButton.Size = UDim2.new(0, 130, 0, 40)
flyButton.Position = UDim2.new(0.5, 5, 0, 230)
flyButton.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
flyButton.Text = "Fly: OFF"
flyButton.TextColor3 = Color3.new(1,1,1)
flyButton.Font = Enum.Font.SourceSansBold
flyButton.MouseButton1Click:Connect(function()
    flying = not flying
    flyButton.Text = flying and "Fly: ON" or "Fly: OFF"
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local root = char.HumanoidRootPart
    if flying then
        local bv = Instance.new("BodyVelocity", root)
        bv.Name = "FlyVel"
        bv.MaxForce = Vector3.new(1e8, 1e8, 1e8)
        local bg = Instance.new("BodyGyro", root)
        bg.Name = "FlyGyro"
        bg.MaxTorque = Vector3.new(1e8, 1e8, 1e8)
        flyLoop = RunService.RenderStepped:Connect(function()
            local cam = workspace.CurrentCamera
            local dir = Vector3.new(0,0,0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.CFrame.RightVector end
            bv.Velocity = dir * speedFly
            bg.CFrame = cam.CFrame
        end)
    else
        if flyLoop then flyLoop:Disconnect() end
        if root:FindFirstChild("FlyVel") then root.FlyVel:Destroy() end
        if root:FindFirstChild("FlyGyro") then root.FlyGyro:Destroy() end
    end
end)

-- DELETE TOOL BUTTON
local delBtn = Instance.new("TextButton", frame)
delBtn.Size = UDim2.new(0, 275, 0, 45)
delBtn.Position = UDim2.new(0, 10, 0, 285)
delBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
delBtn.Text = "OBTER DELETADOR (CLICK)"
delBtn.TextColor3 = Color3.new(1,1,1)
delBtn.Font = Enum.Font.SourceSansBold
delBtn.MouseButton1Click:Connect(darFerramentaDeletar)

-- --- TOGGLE E FECHAR ---
local toggleGui = Instance.new("ScreenGui", playerGui)
toggleGui.Name = "ToggleSystem"
toggleGui.ResetOnSpawn = false

local toggleBtn = Instance.new("TextButton", toggleGui)
toggleBtn.Size = UDim2.new(0, 120, 0, 40)
toggleBtn.Position = UDim2.new(0, 10, 0, 230)
toggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
toggleBtn.Text = "Fechar Menu"
toggleBtn.TextColor3 = Color3.fromRGB(255, 0, 255)
toggleBtn.Font = Enum.Font.SourceSansBold

toggleBtn.MouseButton1Click:Connect(function()
    uiAberta = not uiAberta
    frame.Visible = uiAberta
    toggleBtn.Text = uiAberta and "Fechar Menu" or "Abrir Menu"
end)

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
    toggleGui:Destroy()
end)

-- --- LÓGICA DE ARRASTAR E ATALHOS ---
local dragging, dragInput, dragStart, startPos
frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true dragStart = input.Position startPos = frame.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.JumpRequest:Connect(function()
    if infJumpAtivo and player.Character then
        local h = player.Character:FindFirstChildOfClass("Humanoid")
        if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if esperandoTecla then
        toggleKey = input.KeyCode
        keyBindButton.Text = "Key: " .. input.KeyCode.Name
        esperandoTecla = false
    elseif input.KeyCode == toggleKey then
        uiAberta = not uiAberta
        frame.Visible = uiAberta
    end
end)
