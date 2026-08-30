-- ========================================================
-- Real Body Chams + Name ESP for Roblox Mobile (Delta)
-- Author: robertbockarev76-ops
-- ========================================================

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

-- Очистка старых объектов
if CoreGui:FindFirstChild("RobloxFullBodyESP") then
    CoreGui.RobloxFullBodyESP:Destroy()
end

local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "RobloxFullBodyESP"
ESPFolder.Parent = CoreGui

local function createESP(player)
    if player == LocalPlayer then return end
    
    local function applyESP(character)
        local head = character:WaitForChild("Head", 5)
        if not head then return end
        
        -- 1. Подсветка всех частей тела (Chams / BoxAdornment)
        for _, part in ipairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                local box = part:FindFirstChild("BodyChams")
                if not box then
                    box = Instance.new("BoxHandleAdornment")
                    box.Name = "BodyChams"
                    box.Size = part.Size + Vector3.new(0.05, 0.05, 0.05)
                    box.Adornee = part
                    box.Color3 = Color3.fromRGB(0, 255, 127) -- Неоново-зеленый цвет тела
                    box.Transparency = 0.4 -- Прозрачность
                    box.AlwaysOnTop = true -- Видно сквозь стены!
                    box.ZIndex = 10
                    box.Parent = part
                end
            end
        end
        
        -- 2. Никнеймы над головой
        if head:FindFirstChild("PlayerESP_Tag") then
            head.PlayerESP_Tag:Destroy()
        end
        
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "PlayerESP_Tag"
        billboard.Adornee = head
        billboard.Size = UDim2.new(0, 200, 0, 40)
        billboard.StudsOffset = Vector3.new(0, 2.5, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = head
        
        local label = Instance.new("TextLabel")
        label.Parent = billboard
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(255, 255, 255) -- Белый цвет для текста
        label.TextSize = 14
        label.Font = Enum.Font.SourceSansBold
        label.TextStrokeTransparency = 0 -- Черная обводка
        label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        
        -- Обновление имени и дистанции
        local connection
        connection = RunService.RenderStepped:Connect(function()
            if not character or not character:Parent() or not head:Parent() then
                connection:Disconnect()
                return
            end
            
            local myChar = LocalPlayer.Character
            local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
            local targetRoot = character:FindFirstChild("HumanoidRootPart")
            
            if myRoot and targetRoot then
                local distance = math.floor((myRoot.Position - targetRoot.Position).Magnitude)
                label.Text = player.DisplayName .. " (@" .. player.Name .. ") [" .. distance .. "m]"
            else
                label.Text = player.DisplayName .. " (@" .. player.Name .. ")"
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

-- Запуск для всех игроков
for _, player in ipairs(Players:GetPlayers()) do
    createESP(player)
end

Players.PlayerAdded:Connect(createESP)
