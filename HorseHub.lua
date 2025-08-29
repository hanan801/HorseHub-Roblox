-- Horse Hub Roblox Script (GUI + Fly + Walk Speed + Jump Boost)

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local root = character:WaitForChild("HumanoidRootPart")

-- Variables
local FlyEnabled = false
local FlySpeed = 50
local FlyHeight = 10
local ExtraSpeed = 0
local WalkSpeedValue = 16
local JumpPowerValue = 50

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "HorseHubGUI"
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 300)
frame.Position = UDim2.new(0.5, -150, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.BorderSizePixel = 0
frame.Parent = screenGui

-- Fly Button
local flyButton = Instance.new("TextButton")
flyButton.Size = UDim2.new(0, 280, 0, 40)
flyButton.Position = UDim2.new(0, 10, 0, 10)
flyButton.Text = "Toggle Fly (F)"
flyButton.Parent = frame

-- Fly Speed
local speedBox = Instance.new("TextBox")
speedBox.Size = UDim2.new(0,280,0,30)
speedBox.Position = UDim2.new(0,10,0,60)
speedBox.PlaceholderText = "Fly Speed: 50"
speedBox.Text = ""
speedBox.Parent = frame

-- Fly Height
local heightBox = Instance.new("TextBox")
heightBox.Size = UDim2.new(0,280,0,30)
heightBox.Position = UDim2.new(0,10,0,100)
heightBox.PlaceholderText = "Fly Height: 10"
heightBox.Text = ""
heightBox.Parent = frame

-- Extra Speed
local extraBox = Instance.new("TextBox")
extraBox.Size = UDim2.new(0,280,0,30)
extraBox.Position = UDim2.new(0,10,0,140)
extraBox.PlaceholderText = "Extra Speed: 0"
extraBox.Text = ""
extraBox.Parent = frame

-- Walk Speed
local walkBox = Instance.new("TextBox")
walkBox.Size = UDim2.new(0,280,0,30)
walkBox.Position = UDim2.new(0,10,0,180)
walkBox.PlaceholderText = "Walk Speed: 16"
walkBox.Text = ""
walkBox.Parent = frame

-- Jump Boost
local jumpBox = Instance.new("TextBox")
jumpBox.Size = UDim2.new(0,280,0,30)
jumpBox.Position = UDim2.new(0,10,0,220)
jumpBox.PlaceholderText = "Jump Power: 50"
jumpBox.Text = ""
jumpBox.Parent = frame

-- Fly Function
local function Fly()
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(1e5,1e5,1e5)
    bodyVelocity.Velocity = Vector3.new(0,0,0)
    bodyVelocity.Parent = root
    
    while FlyEnabled do
        local moveDir = Vector3.new()
        local UserInputService = game:GetService("UserInputService")
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + root.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - root.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - root.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + root.CFrame.RightVector end
        
        if moveDir.Magnitude > 0 then
            bodyVelocity.Velocity = moveDir.Unit * FlySpeed + Vector3.new(0, FlyHeight, 0) + Vector3.new(0,0,0)*ExtraSpeed
        else
            bodyVelocity.Velocity = Vector3.new(0, FlyHeight, 0)
        end
        game:GetService("RunService").RenderStepped:Wait()
    end
    bodyVelocity:Destroy()
end

-- GUI Input Handling
flyButton.MouseButton1Click:Connect(function()
    FlyEnabled = not FlyEnabled
    if FlyEnabled then spawn(Fly) end
end)

speedBox.FocusLost:Connect(function()
    local v = tonumber(speedBox.Text)
    if v then FlySpeed = v end
    speedBox.PlaceholderText = "Fly Speed: "..FlySpeed
    speedBox.Text = ""
end)

heightBox.FocusLost:Connect(function()
    local v = tonumber(heightBox.Text)
    if v then FlyHeight = v end
    heightBox.PlaceholderText = "Fly Height: "..FlyHeight
    heightBox.Text = ""
end)

extraBox.FocusLost:Connect(function()
    local v = tonumber(extraBox.Text)
    if v then ExtraSpeed = v end
    extraBox.PlaceholderText = "Extra Speed: "..ExtraSpeed
    extraBox.Text = ""
end)

walkBox.FocusLost:Connect(function()
    local v = tonumber(walkBox.Text)
    if v then WalkSpeedValue = v humanoid.WalkSpeed = WalkSpeedValue end
    walkBox.PlaceholderText = "Walk Speed: "..WalkSpeedValue
    walkBox.Text = ""
end)

jumpBox.FocusLost:Connect(function()
    local v = tonumber(jumpBox.Text)
    if v then JumpPowerValue = v humanoid.JumpPower = JumpPowerValue end
    jumpBox.PlaceholderText = "Jump Power: "..JumpPowerValue
    jumpBox.Text = ""
end)

-- Keyboard F Toggle Fly
game:GetService("UserInputService").InputBegan:Connect(function(input, processed)
    if input.KeyCode == Enum.KeyCode.F and not processed then
        FlyEnabled = not FlyEnabled
        if FlyEnabled then spawn(Fly) end
    end
end)

-- Set default WalkSpeed & JumpPower
humanoid.WalkSpeed = WalkSpeedValue
humanoid.JumpPower = JumpPowerValue
