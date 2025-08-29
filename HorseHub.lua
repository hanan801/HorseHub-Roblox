-- Horse Hub GUI v2
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local root = character:WaitForChild("HumanoidRootPart")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Variables
local FlyEnabled = false
local FlySpeed = 50
local FlyHeight = 10
local ExtraSpeed = 0
local WalkSpeedValue = 16
local JumpPowerValue = 50

-- Main ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "HorseHubGUI"
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Text at top
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(0,200,0,30)
titleLabel.Position = UDim2.new(0.5,-100,0,10)
titleLabel.Text = "Horse Hub"
titleLabel.TextColor3 = Color3.new(1,0,0)
titleLabel.BackgroundTransparency = 1
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextScaled = true
titleLabel.Parent = screenGui

-- Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 350)
frame.Position = UDim2.new(0.5, -150, 0.5, -175)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.BorderColor3 = Color3.fromRGB(100,100,100)
frame.Parent = screenGui

-- Close button X
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0,30,0,30)
closeBtn.Position = UDim2.new(1,-35,0,5)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1,0,0)
closeBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
closeBtn.Parent = frame

-- Minimize button []
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0,30,0,30)
minBtn.Position = UDim2.new(1,-70,0,5)
minBtn.Text = "[]"
minBtn.TextColor3 = Color3.new(1,1,1)
minBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
minBtn.Parent = frame

-- Mini Box when minimized
local miniBox = Instance.new("TextButton")
miniBox.Size = UDim2.new(0,100,0,40)
miniBox.Position = UDim2.new(0,10,0,50)
miniBox.Text = "Horse Hub"
miniBox.TextColor3 = Color3.new(1,0,0)
miniBox.BorderColor3 = Color3.fromRGB(100,100,100)
miniBox.BackgroundColor3 = Color3.fromRGB(30,30,30)
miniBox.Parent = screenGui
miniBox.Visible = false

-- Confirmation label for close
local confirmClose = Instance.new("Frame")
confirmClose.Size = UDim2.new(0,200,0,100)
confirmClose.Position = UDim2.new(0.5,-100,0.5,-50)
confirmClose.BackgroundColor3 = Color3.fromRGB(40,40,40)
confirmClose.BorderColor3 = Color3.fromRGB(100,100,100)
confirmClose.Visible = false
confirmClose.Parent = screenGui

local confirmText = Instance.new("TextLabel")
confirmText.Size = UDim2.new(1,0,0.5,0)
confirmText.Position = UDim2.new(0,0,0,0)
confirmText.Text = "Close Script?"
confirmText.TextColor3 = Color3.new(1,0,0)
confirmText.BackgroundTransparency = 1
confirmText.Font = Enum.Font.SourceSansBold
confirmText.TextScaled = true
confirmText.Parent = confirmClose

local noBtn = Instance.new("TextButton")
noBtn.Size = UDim2.new(0,80,0,30)
noBtn.Position = UDim2.new(0.5,-40,0.6,0)
noBtn.Text = "No!"
noBtn.TextColor3 = Color3.new(1,1,1)
noBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
noBtn.Parent = confirmClose

-- Functions
closeBtn.MouseButton1Click:Connect(function()
    confirmClose.Visible = true
end)

noBtn.MouseButton1Click:Connect(function()
    confirmClose.Visible = false
end)

confirmClose.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        -- nothing here, just block click behind
    end
end)

local function CloseGUI()
    screenGui:Destroy()
end

confirmClose.MouseButton1Click:Connect(function()
    CloseGUI()
end)

minBtn.MouseButton1Click:Connect(function()
    frame.Visible = false
    miniBox.Visible = true
end)

miniBox.MouseButton1Click:Connect(function()
    frame.Visible = true
    miniBox.Visible = false
end)

-- Fly Function
local function Fly()
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(1e5,1e5,1e5)
    bodyVelocity.Velocity = Vector3.new(0,0,0)
    bodyVelocity.Parent = root
    
    while FlyEnabled do
        local moveDir = Vector3.new()
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + root.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - root.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - root.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + root.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0,1,0) end
        
        if moveDir.Magnitude > 0 then
            bodyVelocity.Velocity = moveDir.Unit * FlySpeed + Vector3.new(0,FlyHeight,0) + Vector3.new(0,0,0)*ExtraSpeed
        else
            bodyVelocity.Velocity = Vector3.new(0,FlyHeight,0)
        end
        RunService.RenderStepped:Wait()
    end
    bodyVelocity:Destroy()
end

-- GUI Inputs like previous (omitted for brevity)
-- Tambahkan TextBox untuk FlySpeed, FlyHeight, ExtraSpeed, WalkSpeed, JumpPower
-- Dengan tombol < dan > untuk mengurangi/menambah angka
-- Sama seperti template sebelumnya

-- Keyboard F Toggle Fly
UserInputService.InputBegan:Connect(function(input, processed)
    if input.KeyCode == Enum.KeyCode.F and not processed then
        FlyEnabled = not FlyEnabled
        if FlyEnabled then spawn(Fly) end
    end
end)

-- Set default WalkSpeed & JumpPower
humanoid.WalkSpeed = WalkSpeedValue
humanoid.JumpPower = JumpPowerValue
