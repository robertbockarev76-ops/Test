-- ========================================================
-- Full Chams Body Highlight + Name ESP for Roblox
-- Author: robertbockarev76-ops
-- Target Platform: Mobile (Delta Executor)
-- ========================================================

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

-- Очистка старых объектов при перезапуске
if CoreGui:FindFirstChild("RobloxFullESP") then
    CoreGui.RobloxFullESP:Destroy()
end

local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "RobloxFullESP"
ESPFolder.Parent = CoreGui

local function createESP(player)
    if player == LocalPlayer then return end
    
    local function applyESP(character)
        local head = character:WaitForChild("Head", 5)
        if not head then return end
        
        -- 1. Подсветка всего тела (Highlight)
        local highlight = character:FindFirstChild("ESPHighlight")
        if not highlight then
            highlight = Instance.new("Highlight")
            highlight.Name = "ESPHighlight"
            highlight.Adornee = character
            highlight.FillColor = Color3.fromRGB(0, 255, 127) -- Цвет заливки тела (зеленый)
            highlight.FillTransparency = 0.5 -- Прозрачность заливки
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255) -- Белый контур
            highlight.OutlineTransparency = 0
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop -- Видно сквозь стены
            highlight.Parent = character
        end
        
        -- 2. Табличка с никнеймом над головой
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
        label.TextColor3 = Color3.fromRGB(0, 255, 127)
        label.TextSize = 14
        label.Font = Enum.Font.SourceSansBold
        label.TextStrokeTransparency = 0
        label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        
        -- Дистанция в реальном времени
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

-- Инициализация
for _, player in ipairs(Players:GetPlayers()) do
    createESP(player)
end

Players.PlayerAdded:Connect(createESP)
