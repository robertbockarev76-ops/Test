-- ========================================================
-- Ultra Touch Fling (Zero Self-Knockback & CFrame Lock)
-- Author: robertbockarev76-ops
-- Platform: Mobile (Delta Executor)
-- ========================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local FlingEnabled = false

-- Очистка старого интерфейса
if CoreGui:FindFirstChild("DeltaTouchFling_Mobile") then
    CoreGui.DeltaTouchFling_Mobile:Destroy()
end

-- GUI Setup
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

-- Toggle Logic
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

-- Noclip Anti-Collision
RunService.Stepped:Connect(function()
    if not FlingEnabled then return end
    local char = LocalPlayer.Character
    if char then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- Physics & Position Locking Engine
RunService.Heartbeat:Connect(function()
    if not FlingEnabled then return end
    
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    
    if root and humanoid and humanoid.Health > 0 then
        local lastCFrame = root.CFrame
        local lastVel = root.AssemblyLinearVelocity
        
        -- Мощнейший импульс вращения
        root.AssemblyAngularVelocity = Vector3.new(0, 9999999, 0)
        root.AssemblyLinearVelocity = Vector3.new(9999999, 9999999, 9999999)
        
        RunService.RenderStepped:Wait()
        -- Зажимаем координаты, чтобы тебя не смещало от отдачи
        root.CFrame = lastCFrame
        root.AssemblyLinearVelocity = lastVel
    end
end)
