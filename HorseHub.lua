-- Horse Hub GUI v3 (Full) 
-- Paste this as a LocalScript (atau file .lua untuk loadstring)
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local root = character:WaitForChild("HumanoidRootPart")

-- Default values
local FlyEnabled = false
local FlySpeed = 50
local FlyHeight = 10
local ExtraSpeed = 0
local WalkSpeedValue = 16
local JumpPowerValue = 50
local VerticalSpeed = 1 -- kecepatan naik/turun per tick saat menekan Space/Shift

-- Ensure PlayerGui exists
local playerGui = player:WaitForChild("PlayerGui")

-- Remove existing HorseHubGUI if any (so re-run safe)
local old = playerGui:FindFirstChild("HorseHubGUI")
if old then old:Destroy() end

-- ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "HorseHubGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Top small title
local topTitle = Instance.new("TextLabel")
topTitle.Name = "TopTitle"
topTitle.Size = UDim2.new(0, 220, 0, 24)
topTitle.Position = UDim2.new(0.5, -110, 0, 8)
topTitle.BackgroundTransparency = 1
topTitle.Text = "Horse Hub"
topTitle.Font = Enum.Font.GothamSemibold
topTitle.TextSize = 18
topTitle.TextColor3 = Color3.fromRGB(255, 50, 50)
topTitle.TextStrokeTransparency = 0.7
topTitle.Parent = screenGui

-- Animated splash (center) - will tween then hide
local splashFrame = Instance.new("Frame")
splashFrame.Size = UDim2.new(0, 360, 0, 120)
splashFrame.Position = UDim2.new(0.5, -180, 0.3, -60)
splashFrame.BackgroundTransparency = 1
splashFrame.Parent = screenGui

local splashLabel = Instance.new("TextLabel")
splashLabel.Size = UDim2.new(1,0,1,0)
splashLabel.BackgroundTransparency = 1
splashLabel.Font = Enum.Font.Bangers
splashLabel.Text = "Horse Hub"
splashLabel.TextScaled = true
splashLabel.TextColor3 = Color3.fromRGB(255, 30, 30) -- merah
splashLabel.Parent = splashFrame

-- 3D-like shadow copies for "3D" feel
local shadow1 = splashLabel:Clone()
shadow1.TextColor3 = Color3.fromRGB(80,80,80)
shadow1.Position = UDim2.new(0,2,0,2)
shadow1.ZIndex = splashLabel.ZIndex - 1
shadow1.Parent = splashFrame

-- Tween animation
spawn(function()
    local info = TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    spawn(function()
        local t = TweenService:Create(splashFrame, info, {Position = UDim2.new(0.5, -180, 0.25, -60)})
        t:Play()
        t.Completed:Wait()
        wait(0.7)
        local t2 = TweenService:Create(splashFrame, TweenInfo.new(0.5), {Position = UDim2.new(0.5, -180, -0.6, -60), Transparency = 1})
        t2:Play()
        wait(0.5)
        splashFrame:Destroy()
    end)
end)

-- Main Frame
local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.new(0, 340, 0, 380)
frame.Position = UDim2.new(0.5, -170, 0.5, -190)
frame.BackgroundColor3 = Color3.fromRGB(28,28,28)
frame.BorderSizePixel = 0
frame.Parent = screenGui

-- Frame stroke for nicer border
local frameStroke = Instance.new("UIStroke")
frameStroke.Thickness = 2
frameStroke.Color = Color3.fromRGB(100,100,100)
frameStroke.Parent = frame

-- Header label inside frame (big-ish)
local header = Instance.new("TextLabel")
header.Size = UDim2.new(0,200,0,36)
header.Position = UDim2.new(0.5, -100, 0, 8)
header.BackgroundTransparency = 1
header.Text = "Horse Hub"
header.Font = Enum.Font.GothamSemibold
header.TextSize = 20
header.TextColor3 = Color3.fromRGB(255,50,50)
header.Parent = frame

-- Close (X) and Minimize [] buttons
local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseBtn"
closeBtn.Size = UDim2.new(0,34,0,30)
closeBtn.Position = UDim2.new(1, -38, 0, 6)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 18
closeBtn.TextColor3 = Color3.fromRGB(200,50,50)
closeBtn.BackgroundColor3 = Color3.fromRGB(45,45,45)
closeBtn.Parent = frame

local minBtn = Instance.new("TextButton")
minBtn.Name = "MinBtn"
minBtn.Size = UDim2.new(0,34,0,30)
minBtn.Position = UDim2.new(1, -78, 0, 6)
minBtn.Text = "▢"
minBtn.Font = Enum.Font.SourceSansSemibold
minBtn.TextSize = 18
minBtn.TextColor3 = Color3.fromRGB(230,230,230)
minBtn.BackgroundColor3 = Color3.fromRGB(45,45,45)
minBtn.Parent = frame

-- Mini box (3D-like) shown when minimized
local miniBox = Instance.new("TextButton")
miniBox.Name = "MiniBox"
miniBox.Size = UDim2.new(0,120,0,48)
miniBox.Position = UDim2.new(0, 10, 0, 60)
miniBox.Text = "Horse Hub"
miniBox.Font = Enum.Font.GothamBold
miniBox.TextSize = 18
miniBox.TextColor3 = Color3.fromRGB(255,50,50)
miniBox.BackgroundColor3 = Color3.fromRGB(28,28,28)
miniBox.BorderSizePixel = 0
miniBox.Visible = false
miniBox.Parent = screenGui

-- give miniBox a 3D-ish effect with multiple strokes and a slight gradient
local mbStroke = Instance.new("UIStroke"); mbStroke.Thickness = 2; mbStroke.Color = Color3.fromRGB(100,100,100); mbStroke.Parent = miniBox
local mbShadow = Instance.new("TextLabel"); mbShadow.Size = UDim2.new(1,0,1,0); mbShadow.Position = UDim2.new(0,2,0,2); mbShadow.BackgroundTransparency = 1; mbShadow.Text = "Horse Hub"; mbShadow.Font = miniBox.Font; mbShadow.TextSize = 18; mbShadow.TextColor3 = Color3.fromRGB(80,80,80); mbShadow.Parent = miniBox

-- Confirm close frame
local confirmFrame = Instance.new("Frame")
confirmFrame.Size = UDim2.new(0,260,0,120)
confirmFrame.Position = UDim2.new(0.5,-130,0.5,-60)
confirmFrame.BackgroundColor3 = Color3.fromRGB(35,35,35)
confirmFrame.BorderSizePixel = 0
confirmFrame.Visible = false
confirmFrame.Parent = screenGui
local cfStroke = Instance.new("UIStroke"); cfStroke.Thickness = 2; cfStroke.Color = Color3.fromRGB(100,100,100); cfStroke.Parent = confirmFrame

local confirmLabel = Instance.new("TextLabel")
confirmLabel.Size = UDim2.new(1,0,0,48)
confirmLabel.Position = UDim2.new(0,0,0,10)
confirmLabel.BackgroundTransparency = 1
confirmLabel.Text = "Close script?"
confirmLabel.Font = Enum.Font.GothamBold
confirmLabel.TextSize = 20
confirmLabel.TextColor3 = Color3.fromRGB(255,50,50)
confirmLabel.Parent = confirmFrame

local noBtn = Instance.new("TextButton")
noBtn.Size = UDim2.new(0,96,0,36)
noBtn.Position = UDim2.new(0.11,0,0,64)
noBtn.Text = "No!"
noBtn.Font = Enum.Font.GothamSemibold
noBtn.TextColor3 = Color3.fromRGB(255,255,255)
noBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
noBtn.Parent = confirmFrame

local yesBtn = Instance.new("TextButton")
yesBtn.Size = UDim2.new(0,96,0,36)
yesBtn.Position = UDim2.new(0.55,0,0,64)
yesBtn.Text = "Yes"
yesBtn.Font = Enum.Font.GothamSemibold
yesBtn.TextColor3 = Color3.fromRGB(255,255,255)
yesBtn.BackgroundColor3 = Color3.fromRGB(170,40,40)
yesBtn.Parent = confirmFrame

-- Utility to create a labeled numeric control row with <, value, >
local function createNumberRow(parent, y, labelText, initialValue)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0,120,0,28)
    lbl.Position = UDim2.new(0, 16, 0, y)
    lbl.BackgroundTransparency = 1
    lbl.Text = labelText
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 14
    lbl.TextColor3 = Color3.fromRGB(220,220,220)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = parent

    local dec = Instance.new("TextButton")
    dec.Size = UDim2.new(0,28,0,28)
    dec.Position = UDim2.new(0,150,0,y)
    dec.Text = "<"
    dec.Font = Enum.Font.GothamBold
    dec.TextSize = 18
    dec.Parent = parent

    local valLabel = Instance.new("TextLabel")
    valLabel.Size = UDim2.new(0,80,0,28)
    valLabel.Position = UDim2.new(0,186,0,y)
    valLabel.BackgroundColor3 = Color3.fromRGB(45,45,45)
    valLabel.BorderSizePixel = 0
    valLabel.Text = tostring(initialValue)
    valLabel.Font = Enum.Font.GothamBold
    valLabel.TextSize = 16
    valLabel.TextColor3 = Color3.fromRGB(255,255,255)
    valLabel.Parent = parent

    local inc = Instance.new("TextButton")
    inc.Size = UDim2.new(0,28,0,28)
    inc.Position = UDim2.new(0,268,0,y)
    inc.Text = ">"
    inc.Font = Enum.Font.GothamBold
    inc.TextSize = 18
    inc.Parent = parent

    return {label = lbl, dec = dec, val = valLabel, inc = inc}
end

-- Create controls
local flyRow = createNumberRow(frame, 60, "Fly Speed", FlySpeed)
local heightRow = createNumberRow(frame, 100, "Fly Height", FlyHeight)
local extraRow = createNumberRow(frame, 140, "Extra Speed", ExtraSpeed)
local walkRow = createNumberRow(frame, 180, "Walk Speed", WalkSpeedValue)
local jumpRow = createNumberRow(frame, 220, "Jump Power", JumpPowerValue)

-- Fly toggle button
local flyToggle = Instance.new("TextButton")
flyToggle.Size = UDim2.new(0,300,0,36)
flyToggle.Position = UDim2.new(0.5,-150,0,268)
flyToggle.Text = "Toggle Fly (F)"
flyToggle.Font = Enum.Font.GothamBold
flyToggle.TextSize = 18
flyToggle.TextColor3 = Color3.fromRGB(255,255,255)
flyToggle.BackgroundColor3 = Color3.fromRGB(60,60,60)
flyToggle.Parent = frame

-- Helpers to update labels
local function updateAllLabels()
    flyRow.val.Text = tostring(FlySpeed)
    heightRow.val.Text = tostring(FlyHeight)
    extraRow.val.Text = tostring(ExtraSpeed)
    walkRow.val.Text = tostring(WalkSpeedValue)
    jumpRow.val.Text = tostring(JumpPowerValue)
end
updateAllLabels()

-- Button connections for < and >
local function bindIncDec(row, getValFunc, setValFunc)
    row.dec.MouseButton1Click:Connect(function()
        local v = getValFunc()
        v = v - 1
        setValFunc(v)
        updateAllLabels()
    end)
    row.inc.MouseButton1Click:Connect(function()
        local v = getValFunc()
        v = v + 1
        setValFunc(v)
        updateAllLabels()
    end)
end

bindIncDec(flyRow, function() return FlySpeed end, function(v) FlySpeed = math.max(0, math.floor(v)) end)
bindIncDec(heightRow, function() return FlyHeight end, function(v) FlyHeight = math.floor(v) end)
bindIncDec(extraRow, function() return ExtraSpeed end, function(v) ExtraSpeed = math.floor(v) end)
bindIncDec(walkRow, function() return WalkSpeedValue end, function(v) WalkSpeedValue = math.max(1, math.floor(v)); humanoid.WalkSpeed = WalkSpeedValue end)
bindIncDec(jumpRow, function() return JumpPowerValue end, function(v) JumpPowerValue = math.max(1, math.floor(v)); humanoid.JumpPower = JumpPowerValue end)

-- Clicking values (optional: open numeric entry)
local function makeEditable(valLabel, setFunc)
    valLabel.MouseButton1Down:Connect(function()
        -- quick input: prompt via Roblox Prompt not available in all envs; skip to no-op
        -- we keep inc/dec as primary.
    end)
end

-- Fly implementation
local currentBV = nil
local function startFly()
    if currentBV and currentBV.Parent then currentBV:Destroy() end
    currentBV = Instance.new("BodyVelocity")
    currentBV.MaxForce = Vector3.new(1e5,1e5,1e5)
    currentBV.Velocity = Vector3.new(0,0,0)
    currentBV.P = 1250
    currentBV.Parent = root

    while FlyEnabled and currentBV.Parent do
        local moveDir = Vector3.new()
        -- horizontal movement from WASD relative to camera/root
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + root.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - root.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - root.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + root.CFrame.RightVector end

        -- vertical manual control: Space up, LeftShift down
        local vy = 0
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then vy = vy + VerticalSpeed end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then vy = vy - VerticalSpeed end

        -- if no horizontal input, allow slight hold altitude according to FlyHeight
        local horizontalVelocity = Vector3.new(0,0,0)
        if moveDir.Magnitude > 0.01 then
            horizontalVelocity = moveDir.Unit * FlySpeed
        else
            horizontalVelocity = Vector3.new(0,0,0)
        end

        -- vertical component: base FlyHeight used as upward boost to maintain altitude feel (small)
        local verticalComp = FlyHeight + vy + ExtraSpeed
        currentBV.Velocity = horizontalVelocity + Vector3.new(0, verticalComp, 0)
        RunService.RenderStepped:Wait()
    end

    if currentBV and currentBV.Parent then
        currentBV:Destroy()
        currentBV = nil
    end
end

-- Toggle fly
local function toggleFly()
    FlyEnabled = not FlyEnabled
    if FlyEnabled then
        spawn(startFly)
    else
        -- stopping handled by startFly loop
    end
end

flyToggle.MouseButton1Click:Connect(toggleFly)
UserInputService.InputBegan:Connect(function(input, gpe)
    if input.UserInputType == Enum.UserInputType.Keyboard then
        if input.KeyCode == Enum.KeyCode.F and not gpe then
            toggleFly()
        end
    end
end)

-- Minimize / restore functions
minBtn.MouseButton1Click:Connect(function()
    frame.Visible = false
    topTitle.Visible = false
    miniBox.Visible = true
end)

miniBox.MouseButton1Click:Connect(function()
    frame.Visible = true
    topTitle.Visible = true
    miniBox.Visible = false
end)

-- Close confirm flow
closeBtn.MouseButton1Click:Connect(function()
    confirmFrame.Visible = true
end)

noBtn.MouseButton1Click:Connect(function()
    confirmFrame.Visible = false
end)

yesBtn.MouseButton1Click:Connect(function()
    -- destroy GUI and cleanup
    if currentBV and currentBV.Parent then currentBV:Destroy() end
    screenGui:Destroy()
end)

-- Keep humanoid defaults
humanoid.WalkSpeed = WalkSpeedValue
humanoid.JumpPower = JumpPowerValue

-- Ensure labels reflect initial values
updateAllLabels()

-- Safety: if character respawns, reconnect root/humanoid
player.CharacterAdded:Connect(function(char)
    character = char
    humanoid = character:WaitForChild("Humanoid")
    root = character:WaitForChild("HumanoidRootPart")
    humanoid.WalkSpeed = WalkSpeedValue
    humanoid.JumpPower = JumpPowerValue
end)

-- Provide small instruction tooltip (optional)
local inst = Instance.new("TextLabel")
inst.Size = UDim2.new(0,300,0,20)
inst.Position = UDim2.new(0.5, -150, 1, -28)
inst.BackgroundTransparency = 1
inst.Text = "F = toggle fly | Space = up | LeftShift = down | Use < > to adjust values"
inst.Font = Enum.Font.SourceSans
inst.TextSize = 14
inst.TextColor3 = Color3.fromRGB(200,200,200)
inst.Parent = screenGui

-- End of script
