local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local ScreenGui = Instance.new("ScreenGui")
local FreezeButton = Instance.new("TextButton")

ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.Name = "SimpleFreeze"

FreezeButton.Parent = ScreenGui
FreezeButton.Size = UDim2.new(0, 120, 0, 40)
FreezeButton.Position = UDim2.new(0, 10, 0, 10)
FreezeButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
FreezeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FreezeButton.Text = "FREEZE 5s"
FreezeButton.Font = Enum.Font.SourceSansBold
FreezeButton.TextSize = 14

local Freezing = false
local FrozenPlayers = {}

local function FreezeCharacter(player)
    if player == LocalPlayer then return end
    
    pcall(function()
        local character = player.Character
        if character then
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                local originalPosition = humanoidRootPart.Position
                local originalCFrame = humanoidRootPart.CFrame
                
                local connection
                connection = RunService.Heartbeat:Connect(function()
                    if character and humanoidRootPart then
                        -- C. Force position lock and remove velocity
                        humanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                        humanoidRootPart.RotVelocity = Vector3.new(0, 0, 0)
                        humanoidRootPart.CFrame = originalCFrame
                    else
                        connection:Disconnect()
                    end
                end)
                
                FrozenPlayers[player] = connection
            end
        end
    end)
end

local function UnfreezeCharacter(player)
    pcall(function()
        if FrozenPlayers[player] then
            FrozenPlayers[player]:Disconnect()
            FrozenPlayers[player] = nil
        end
    end)
end

local function onKeyPress(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.G and not Freezing then
        Freezing = true
        
        FreezeButton.BackgroundColor3 = Color3.fromRGB(60, 200, 60)
        FreezeButton.Text = "FREEZING..."
        
        for _, player in pairs(Players:GetPlayers()) do
            FreezeCharacter(player)
        end
        
        local newPlayerConnection
        newPlayerConnection = Players.PlayerAdded:Connect(function(newPlayer)
            FreezeCharacter(newPlayer)
        end)
        
        wait(5)
        
        newPlayerConnection:Disconnect()
        
        for _, player in pairs(Players:GetPlayers()) do
            UnfreezeCharacter(player)
        end
        
        FreezeButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
        FreezeButton.Text = "FREEZE 5s"
        Freezing = false
        FrozenPlayers = {}
    end
end

UIS.InputBegan:Connect(onKeyPress)

FreezeButton.MouseButton1Click:Connect(function()
    if Freezing then return end
    Freezing = true
    
    FreezeButton.BackgroundColor3 = Color3.fromRGB(60, 200, 60)
    FreezeButton.Text = "FREEZING..."
    
    for _, player in pairs(Players:GetPlayers()) do
        FreezeCharacter(player)
    end
    
    local newPlayerConnection
    newPlayerConnection = Players.PlayerAdded:Connect(function(newPlayer)
        FreezeCharacter(newPlayer)
    end)
    
    wait(5)
    
    newPlayerConnection:Disconnect()
    
    for _, player in pairs(Players:GetPlayers()) do
        UnfreezeCharacter(player)
    end
    
    FreezeButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
    FreezeButton.Text = "FREEZE 5s"
    Freezing = false
    FrozenPlayers = {}
end)
