-- ========================================================
-- Touch Fling Script for Roblox (Delta Executor Mobile)
-- Author: Root_Coders / Delta Community
-- Target Platform: Mobile (Android / iOS)
-- ========================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local FlingEnabled = false

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
    local root = character and character:FindFirstChild("HumanoidRootPart")
    
    if root then
        local currentVelocity = root.Velocity
        
        -- Вызов вращательного импульса для отбрасывания других игроков
        root.RotVelocity = Vector3.new(0, 999999, 0)
        root.Velocity = Vector3.new(currentVelocity.X, 9999, currentVelocity.Z)
        
        -- Сброс вектора в следующем кадре для стабильности персонажа
        RunService.RenderStepped:Wait()
        root.Velocity = currentVelocity
    end
end)
