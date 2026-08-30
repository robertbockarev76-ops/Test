-- Roblox Studio test utility
-- LocalScript -> StarterPlayerScripts
-- ESP + names + noclip + adjustable flight speed

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

local Settings = {
    ESP = true,
    Names = true,
    Noclip = true,
    Flight = true,
    FlightSpeed = 60,
    SpeedStep = 10,
    MinSpeed = 10,
    MaxSpeed = 300,
}

local espObjects = {}
local flightConnection
local noclipConnection

local function removeESP(player)
    local objects = espObjects[player]

    if objects then
        for _, object in ipairs(objects) do
            object:Destroy()
        end

        espObjects[player] = nil
    end
end

local function createESP(player)
    if player == LocalPlayer or not Settings.ESP then
        return
    end

    removeESP(player)

    local character = player.Character
    if not character then
        return
    end

    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then
        return
    end

    local highlight = Instance.new("Highlight")
    highlight.Name = "TestESP"
    highlight.Adornee = character
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.FillTransparency = 0.75
    highlight.OutlineTransparency = 0
    highlight.Parent = character

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "TestName"
    billboard.Adornee = root
    billboard.AlwaysOnTop = true
    billboard.Size = UDim2.fromOffset(200, 40)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.Parent = root

    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Size = UDim2.fromScale(1, 1)
    label.Text = player.DisplayName .. "  @" .. player.Name
    label.TextScaled = true
    label.TextStrokeTransparency = 0.4
    label.Parent = billboard

    espObjects[player] = {highlight, billboard}
end

local function refreshESP(player)
    if Settings.ESP then
        createESP(player)
    else
        removeESP(player)
    end
end

local function setupPlayer(player)
    if player == LocalPlayer then
        return
    end

    player.CharacterAdded:Connect(function()
        task.wait(0.5)
        refreshESP(player)
    end)

    if player.Character then
        refreshESP(player)
    end
end

for _, player in ipairs(Players:GetPlayers()) do
    setupPlayer(player)
end

Players.PlayerAdded:Connect(setupPlayer)
Players.PlayerRemoving:Connect(removeESP)

noclipConnection = RunService.Stepped:Connect(function()
    if not Settings.Noclip then
        return
    end

    local character = LocalPlayer.Character
    if not character then
        return
    end

    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
end)

local function startFlight()
    if flightConnection then
        return
    end

    flightConnection = RunService.RenderStepped:Connect(function()
        if not Settings.Flight then
            return
        end

        local character = LocalPlayer.Character
        if not character then
            return
        end

        local humanoid = character:FindFirstChildOfClass("Humanoid")
        local root = character:FindFirstChild("HumanoidRootPart")

        if not humanoid or not root then
            return
        end

        local camera = workspace.CurrentCamera
        if not camera then
            return
        end

        local direction = Vector3.zero

        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            direction += camera.CFrame.LookVector
        end

        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            direction -= camera.CFrame.LookVector
        end

        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            direction -= camera.CFrame.RightVector
        end

        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            direction += camera.CFrame.RightVector
        end

        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            direction += Vector3.yAxis
        end

        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            direction -= Vector3.yAxis
        end

        if direction.Magnitude > 0 then
            direction = direction.Unit
        end

        root.AssemblyLinearVelocity = direction * Settings.FlightSpeed
    end)
end

local function stopFlight()
    if flightConnection then
        flightConnection:Disconnect()
        flightConnection = nil
    end
end

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then
        return
    end

    if input.KeyCode == Enum.KeyCode.F6 then
        Settings.Flight = not Settings.Flight

        if Settings.Flight then
            startFlight()
        else
            stopFlight()
        end

    elseif input.KeyCode == Enum.KeyCode.Equals then
        Settings.FlightSpeed = math.min(
            Settings.MaxSpeed,
            Settings.FlightSpeed + Settings.SpeedStep
        )

        print("Flight speed:", Settings.FlightSpeed)

    elseif input.KeyCode == Enum.KeyCode.Minus then
        Settings.FlightSpeed = math.max(
            Settings.MinSpeed,
            Settings.FlightSpeed - Settings.SpeedStep
        )

        print("Flight speed:", Settings.FlightSpeed)

    elseif input.KeyCode == Enum.KeyCode.F7 then
        Settings.ESP = not Settings.ESP

        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                refreshESP(player)
            end
        end
    end
end)

startFlight()

print("Test utility loaded.")
print("F6 = flight on/off")
print("+/- = flight speed")
print("F7 = ESP on/off")
print("Space/Ctrl = vertical movement")
