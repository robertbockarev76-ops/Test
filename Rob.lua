-- ========================================================
-- Advanced Name ESP for Roblox (Delta Executor Mobile)
-- Author: robertbockarev76-ops
-- Platform: Mobile (Android / iOS)
-- ========================================================

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

-- Удаление старого интерфейса при перезапуске
if CoreGui:FindFirstChild("RobloxNameESP") then
    CoreGui.RobloxNameESP:Destroy()
end

local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "RobloxNameESP"
ESPFolder.Parent = CoreGui

local function createESP(player)
    if player == LocalPlayer then return end
    
    local function applyTag(character)
        local head = character:WaitForChild("Head", 5)
        if not head then return end
        
        if head:FindFirstChild("PlayerESP_Tag") then
            head.PlayerESP_Tag:Destroy()
        end
        
        -- Создание плавающей плашки сквозь стены
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
        label.TextColor3 = Color3.fromRGB(0, 255, 127) -- Неоново-зеленый
        label.TextSize = 14
        label.Font = Enum.Font.SourceSansBold
        label.TextStrokeTransparency = 0 -- Черная обводка
        label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        
        -- Обновление расстояния в реальном времени
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
            applyTag(player.Character)
        end)
    end
    
    player.CharacterAdded:Connect(applyTag)
end

-- Подключение игроков
for _, player in ipairs(Players:GetPlayers()) do
    createESP(player)
end

Players.PlayerAdded:Connect(createESP)
