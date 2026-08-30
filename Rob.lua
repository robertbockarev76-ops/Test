-- ========================================================
-- Touch Fling Script for Roblox (Delta Executor Mobile)
-- Author: robertbockarev76-ops
-- Repository: https://github.com/robertbockarev76-ops/Test
-- ========================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local FlingEnabled = false

-- Удаляем старое GUI, если скрипт перезапускают
if CoreGui:FindFirstChild("DeltaTouchFling_Mobile") then
    CoreGui.DeltaTouchFling_Mobile:Destroy()
end

-- --------------------------------------------------------
-- Mobile GUI Setup
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

-- --------------------------------------------------------
-- Toggle Event
-- --------------------------------------------------------
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
-- Fling Physics Loop
-- --------------------------------------------------------
RunService.Heartbeat:Connect(function()
    if not FlingEnabled then return end
    
    local character = LocalPlayer.Character
    if not character then return end
    
    local root = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    
    if root and humanoid and humanoid.Health > 0 then
        local oldVel = root.AssemblyLinearVelocity
        
        -- Максимальный разгон физики для отбрасывания игроков
        root.AssemblyAngularVelocity = Vector3.new(0, 999999, 0)
        root.AssemblyLinearVelocity = Vector3.new(oldVel.X, 9999, oldVel.Z)
        
        RunService.RenderStepped:Wait()
        root.AssemblyLinearVelocity = oldVel
    end
end)
