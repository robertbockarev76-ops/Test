-- ========================================================
-- Advanced Touch Fling (Zero Self-Knockback Version)
-- Author: robertbockarev76-ops
-- Platform: Mobile (Delta Executor)
-- ========================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local FlingEnabled = false

-- Защита от дублирования интерфейса
if CoreGui:FindFirstChild("DeltaTouchFling_Mobile") then
    CoreGui.DeltaTouchFling_Mobile:Destroy()
end

-- --------------------------------------------------------
-- GUI Setup
-- --------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
local ToggleButton = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")

ScreenGui.Name = "DeltaTouchFling_Mobile"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

ToggleButton.Name = "FlingToggle"
ToggleButton.Parent = ScreenGui
ToggleButton.Size = UDim2.new(0, 100, 0, 45)
ToggleButton.Position = UDim2.new(0.15, 0, 0.15, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(230, 50, 50)
ToggleButton.Text = "FLING: OFF"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 13
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.Active = true
ToggleButton.Draggable = true

UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = ToggleButton

-- Переключение состояния
ToggleButton.MouseButton1Click:Connect(function()
    FlingEnabled = not FlingEnabled
    if FlingEnabled then
        ToggleButton.Text = "FLING: ON"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 210, 50)
    else
        ToggleButton.Text = "FLING: OFF"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(230, 50, 50)
    end
end)

-- --------------------------------------------------------
-- Physics Core (Anti-Self-Fling + Desync)
-- --------------------------------------------------------
RunService.Stepped:Connect(function()
    if not FlingEnabled then return end
    
    local character = LocalPlayer.Character
    if character then
        -- Полный Noclip своего персонажа, чтобы не получать отдачу
        for _, part in ipairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

RunService.Heartbeat:Connect(function()
    if not FlingEnabled then return end
    
    local character = LocalPlayer.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    
    if root and humanoid and humanoid.Health > 0 then
        local originalVelocity = root.AssemblyLinearVelocity
        
        -- Безумное вращение для выталкивания чужих персонажей
        root.AssemblyAngularVelocity = Vector3.new(0, 10000000, 0)
        
        -- Подмена вектора скорости для десинка
        root.AssemblyLinearVelocity = Vector3.new(0, 10000000, 0)
        
        RunService.RenderStepped:Wait()
        -- Возвращаем исходную скорость игрока для плавной ходьбы
        root.AssemblyLinearVelocity = originalVelocity
    end
end)
