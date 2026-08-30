-- ========================================================
-- Premium Clean Chams + Name ESP for Roblox Mobile (Delta)
-- Author: robertbockarev76-ops
-- ========================================================

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

-- Очистка старых объектов
if CoreGui:FindFirstChild("RobloxBodyESP_Clean") then
    CoreGui.RobloxBodyESP_Clean:Destroy()
end

local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "RobloxBodyESP_Clean"
ESPFolder.Parent = CoreGui

local function createESP(player)
    if player == LocalPlayer then return end
    
    local function applyESP(character)
        local head = character:WaitForChild("Head", 5)
        if not head then return end
        
        -- 1. Красивая подсветка частей тела (Smooth Cyan Chams)
        for _, part in ipairs(character:GetChildren()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                local sphere = part:FindFirstChild("BodyChamsSmooth")
                if not sphere then
                    sphere = Instance.new("CylinderHandleAdornment")
                    if part.Name == "Head" then
                        sphere = Instance.new("SphereHandleAdornment")
                        sphere.Radius = part.Size.Y / 1.8
                    else
                        sphere = Instance.new("BoxHandleAdornment")
                        sphere.Size = part.Size + Vector3.new(0.08, 0.08, 0.08)
                    end
                    
                    sphere.Name = "BodyChamsSmooth"
                    sphere.Adornee = part
                    sphere.Color3 = Color3.fromRGB(0, 220, 255) -- Красивый голубой неон
                    sphere.Transparency = 0.35 -- Легкая полупрозрачность
                    sphere.AlwaysOnTop = true -- Светится сквозь стены
                    sphere.ZIndex = 5
                    sphere.Parent = part
                end
            end
        end
        
        -- 2. Аккуратный Никнейм над головой
        if head:FindFirstChild("PlayerESP_Tag") then
            head.PlayerESP_Tag:Destroy()
        end
        
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "PlayerESP_Tag"
        billboard.Adornee = head
        billboard.Size = UDim2.new(0, 160, 0, 30)
        billboard.StudsOffset = Vector3.new(0, 2.8, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = head
        
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 1, 0)
        frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
        frame.BackgroundTransparency = 0.4
        frame.Parent = billboard
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = frame
        
        local label = Instance.new("TextLabel")
        label.Parent = frame
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextSize = 13
        label.Font = Enum.Font.GothamBold
        
        -- Вывод чёткого имени и дистанции
        local connection
        connection = RunService.RenderStepped:Connect(function()
            if not character or not character:Parent() or not head:Parent() then
                connection:Disconnect()
                return
            end
            
            local myChar = LocalPlayer.Character
            local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
            local targetRoot = character:FindFirstChild("HumanoidRootPart")
            
            local playerName = player.DisplayName or player.Name
            
            if myRoot and targetRoot then
                local distance = math.floor((myRoot.Position - targetRoot.Position).Magnitude)
                label.Text = playerName .. " [" .. distance .. "m]"
            else
                label.Text = playerName
            end
        end)
    end
    
    if player.Character then
        task.spawn(function()
            applyESP(player.Character)
        end)
    end
    
    player.CharacterAdded:Connect(applyESP)
end

-- Подключение игроков
for _, player in ipairs(Players:GetPlayers()) do
    createESP(player)
end

Players.PlayerAdded:Connect(createESP)
