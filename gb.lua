-- [[ SOUTH BRONX : TARGET ENHANCER ]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Configuração da UI
local ScreenGui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
ScreenGui.Name = "SB_Internal"

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 180, 0, 120)
Main.Position = UDim2.new(0.1, 0, 0.5, 0)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.BorderSizePixel = 0

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 25)
Title.Text = "SB HITBOX"
Title.TextColor3 = Color3.new(1, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

local Input = Instance.new("TextBox", Main)
Input.Size = UDim2.new(0.8, 0, 0, 25)
Input.Position = UDim2.new(0.1, 0, 0.3, 0)
Input.Text = "3" -- Tamanho padrão
Input.PlaceholderText = "Tamanho..."

local Toggle = Instance.new("TextButton", Main)
Toggle.Size = UDim2.new(0.8, 0, 0, 30)
Toggle.Position = UDim2.new(0.1, 0, 0.6, 0)
Toggle.Text = "OFF"
Toggle.BackgroundColor3 = Color3.fromRGB(150, 0, 0)

-- Variáveis de Controle
local _active = false
local _size = 3

Toggle.MouseButton1Click:Connect(function()
    _active = not _active
    _size = tonumber(Input.Text) or 3
    Toggle.Text = _active and "ON" or "OFF"
    Toggle.BackgroundColor3 = _active and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
end)

-- Loop de Execução
RunService.RenderStepped:Connect(function()
    if active then
        for , plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                local chest = plr.Character:FindFirstChild("UpperTorso")
                local belly = plr.Character:FindFirstChild("LowerTorso")

                -- Altera o Peito
                if chest and chest:IsA("BasePart") then
                    chest.Size = Vector3.new(_size, _size, _size)
                    chest.Transparency = 0.7 -- Visualizar a área de acerto
                    chest.CanCollide = false
                end

                -- Altera a Barriga (opcional, para garantir o hit)
                if belly and belly:IsA("BasePart") then
                    belly.Size = Vector3.new(_size, _size, _size)
                    belly.Transparency = 0.7
                    belly.CanCollide = false
                end
            end
        end
    end
end)
