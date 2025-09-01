-- Horse Hub GUI v4 (Full dengan Opening Animation)

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
local VerticalSpeed = 1

-- PlayerGui
local playerGui = player:WaitForChild("PlayerGui")

-- Remove old GUI
local old = playerGui:FindFirstChild("HorseHubGUI")
if old then old:Destroy() end

-- ========== OPENING ANIMATION ==========
local openingGui = Instance.new("ScreenGui")
openingGui.Name = "OpeningAnimation"
openingGui.IgnoreGuiInset = true
openingGui.Parent = playerGui

local bgFrame = Instance.new("Frame")
bgFrame.Size = UDim2.new(1,0,1,0)
bgFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
bgFrame.BackgroundTransparency = 0
bgFrame.Parent = openingGui

-- Background RGB effect
spawn(function()
    local time = 0
    while openingGui.Parent do
        time = time + 0.01
        local r = math.sin(time) * 0.5 + 0.5
        local g = math.sin(time + 2) * 0.5 + 0.5
        local b = math.sin(time + 4) * 0.5 + 0.5
        bgFrame.BackgroundColor3 = Color3.new(r, g, b)
        task.wait(0.05)
    end
end)

local openingText = Instance.new("TextLabel")
openingText.Size = UDim2.new(1,0,1,0)
openingText.Text = ""
openingText.BackgroundTransparency = 1
openingText.TextColor3 = Color3.fromRGB(255,255,255)
openingText.Font = Enum.Font.GothamBlack
openingText.TextScaled = true
openingText.TextStrokeTransparency = 0
openingText.TextStrokeColor3 = Color3.fromRGB(0,0,0)
openingText.Parent = bgFrame

-- Efek ketik huruf demi huruf (dengan kecepatan normal)
local fullText = "HORSE HUB"
spawn(function()
    for i = 1, #fullText do
        openingText.Text = string.sub(fullText, 1, i)
        task.wait(0.15) -- Kecepatan normal
    end
    -- Fade out setelah selesai
    local tweenInfo = TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local t1 = TweenService:Create(openingText, tweenInfo, {TextTransparency = 1, TextStrokeTransparency = 1})
    local t2 = TweenService:Create(bgFrame, tweenInfo, {BackgroundTransparency = 1})
    t1:Play(); t2:Play()
    t2.Completed:Wait()
    openingGui:Destroy()
end)

-- Delay sedikit sebelum GUI utama muncul
task.wait(#fullText * 0.15 + 2.5) -- Sesuai dengan kecepatan ketik normal

-- ========== HORSE HUB GUI ==========
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "HorseHubGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Top Title
local topTitle = Instance.new("TextLabel")
topTitle.Size = UDim2.new(0, 220, 0, 24)
topTitle.Position = UDim2.new(0.5, -110, 0, 8)
topTitle.BackgroundTransparency = 1
topTitle.Text = "Horse Hub"
topTitle.Font = Enum.Font.GothamSemibold
topTitle.TextSize = 18
topTitle.TextColor3 = Color3.fromRGB(255,50,50)
topTitle.TextStrokeTransparency = 0.7
topTitle.Parent = screenGui

-- Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 340, 0, 380)
frame.Position = UDim2.new(0.5, -170, 0.5, -190)
frame.BackgroundColor3 = Color3.fromRGB(28,28,28)
frame.BorderSizePixel = 0
frame.Parent = screenGui

local frameStroke = Instance.new("UIStroke")
frameStroke.Thickness = 2
frameStroke.Color = Color3.fromRGB(100,100,100)
frameStroke.Parent = frame

local header = Instance.new("TextLabel")
header.Size = UDim2.new(0,200,0,36)
header.Position = UDim2.new(0.5, -100, 0, 8)
header.BackgroundTransparency = 1
header.Text = "Horse Hub"
header.Font = Enum.Font.GothamSemibold
header.TextSize = 20
header.TextColor3 = Color3.fromRGB(255,50,50)
header.Parent = frame

-- Tombol Join Discord di pojok kiri atas (di dalam frame utama)
local discordBtn = Instance.new("TextButton")
discordBtn.Size = UDim2.new(0, 100, 0, 24)
discordBtn.Position = UDim2.new(0, 10, 0, 10)
discordBtn.BackgroundColor3 = Color3.fromRGB(45,45,45)
discordBtn.BorderSizePixel = 0
discordBtn.Text = "Join Discord"
discordBtn.Font = Enum.Font.Gotham
discordBtn.TextSize = 14
discordBtn.TextColor3 = Color3.fromRGB(200,200,200)
discordBtn.Parent = frame

discordBtn.MouseButton1Click:Connect(function()
    setclipboard("https://discord.gg/mVA26ZKr")
    
    -- Feedback bahwa link telah disalin
    local originalText = discordBtn.Text
    discordBtn.Text = "Copied!"
    task.wait(1)
    discordBtn.Text = originalText
end)

-- Close (X) dan Minimize ([])
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0,34,0,30)
closeBtn.Position = UDim2.new(1,-38,0,6)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 18
closeBtn.TextColor3 = Color3.fromRGB(200,50,50)
closeBtn.BackgroundColor3 = Color3.fromRGB(45,45,45)
closeBtn.Parent = frame

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0,34,0,30)
minBtn.Position = UDim2.new(1,-78,0,6)
minBtn.Text = "▢"
minBtn.Font = Enum.Font.SourceSansSemibold
minBtn.TextSize = 18
minBtn.TextColor3 = Color3.fromRGB(230,230,230)
minBtn.BackgroundColor3 = Color3.fromRGB(45,45,45)
minBtn.Parent = frame

-- Mini Box (muncul ketika minimize)
local miniBox = Instance.new("TextButton")
miniBox.Size = UDim2.new(0,120,0,48)
miniBox.Position = UDim2.new(0,10,0,60)
miniBox.Text = "Horse Hub"
miniBox.Font = Enum.Font.GothamBold
miniBox.TextSize = 18
miniBox.TextColor3 = Color3.fromRGB(255,50,50)
miniBox.BackgroundColor3 = Color3.fromRGB(28,28,28)
miniBox.BorderSizePixel = 0
miniBox.Visible = false
miniBox.Parent = screenGui

local mbStroke = Instance.new("UIStroke")
mbStroke.Thickness = 2
mbStroke.Color = Color3.fromRGB(100,100,100)
mbStroke.Parent = miniBox

-- Confirm close
local confirmFrame = Instance.new("Frame")
confirmFrame.Size = UDim2.new(0,260,0,120)
confirmFrame.Position = UDim2.new(0.5,-130,0.5,-60)
confirmFrame.BackgroundColor3 = Color3.fromRGB(35,35,35)
confirmFrame.BorderSizePixel = 0
confirmFrame.Visible = false
confirmFrame.Parent = screenGui

local cfStroke = Instance.new("UIStroke")
cfStroke.Thickness = 2
cfStroke.Color = Color3.fromRGB(100,100,100)
cfStroke.Parent = confirmFrame

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

-- Function buat baris angka dengan < angka >
local function createNumberRow(parent, y, labelText, initialValue)
local lbl = Instance.new("TextLabel")
lbl.Size = UDim2.new(0,120,0,28)
lbl.Position = UDim2.new(0,16,0,y)
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

return {dec=dec,val=valLabel,inc=inc}

end

-- Buat kontrol
local flyRow = createNumberRow(frame, 60, "Terbang Kecepatan", FlySpeed)
local heightRow = createNumberRow(frame, 100, "Fly Height", FlyHeight)
local extraRow = createNumberRow(frame, 140, "Extra Kecepatan", ExtraSpeed)
local walkRow = createNumberRow(frame, 180, "Kecepatan Berjalan", WalkSpeedValue)
local jumpRow = createNumberRow(frame, 220, "Daya Lompat", JumpPowerValue)

-- Tombol toggle fly
local flyToggle = Instance.new("TextButton")
flyToggle.Size = UDim2.new(0,300,0,36)
flyToggle.Position = UDim2.new(0.5,-150,0,268)
flyToggle.Text = "Toggle Fly (F)"
flyToggle.Font = Enum.Font.GothamBold
flyToggle.TextSize = 18
flyToggle.TextColor3 = Color3.fromRGB(255,255,255)
flyToggle.BackgroundColor3 = Color3.fromRGB(60,60,60)
flyToggle.Parent = frame

-- Update label angka
local function updateAllLabels()
flyRow.val.Text = tostring(FlySpeed)
heightRow.val.Text = tostring(FlyHeight)
extraRow.val.Text = tostring(ExtraSpeed)
walkRow.val.Text = tostring(WalkSpeedValue)
jumpRow.val.Text = tostring(JumpPowerValue)
end
updateAllLabels()

-- Binding tombol < >
local function bindIncDec(row, getVal, setVal)
row.dec.MouseButton1Click:Connect(function()
local v = getVal()-1
setVal(v)
updateAllLabels()
end)
row.inc.MouseButton1Click:Connect(function()
local v = getVal()+1
setVal(v)
updateAllLabels()
end)
end

bindIncDec(flyRow, function() return FlySpeed end, function(v) FlySpeed = math.max(0,v) end)
bindIncDec(heightRow, function() return FlyHeight end, function(v) FlyHeight = v end)
bindIncDec(extraRow, function() return ExtraSpeed end, function(v) ExtraSpeed = v end)
bindIncDec(walkRow, function() return WalkSpeedValue end, function(v) WalkSpeedValue = math.max(1,v); humanoid.WalkSpeed=WalkSpeedValue end)
bindIncDec(jumpRow, function() return JumpPowerValue end, function(v) JumpPowerValue = math.max(1,v); humanoid.JumpPower=JumpPowerValue end)

-- Fly logic
local currentBV
local function startFly()
if currentBV then currentBV:Destroy() end
currentBV = Instance.new("BodyVelocity")
currentBV.MaxForce = Vector3.new(1e5,1e5,1e5)
currentBV.P = 1250
currentBV.Parent = root

while FlyEnabled and currentBV.Parent do  
    local moveDir = Vector3.new()  
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir += root.CFrame.LookVector end  
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir -= root.CFrame.LookVector end  
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir -= root.CFrame.RightVector end  
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir += root.CFrame.RightVector end  

    local vy = 0  
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then vy += VerticalSpeed end  
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then vy -= VerticalSpeed end  

    local hv = (moveDir.Magnitude>0 and moveDir.Unit*FlySpeed) or Vector3.new()  
    currentBV.Velocity = hv + Vector3.new(0, FlyHeight+vy+ExtraSpeed, 0)  

    RunService.RenderStepped:Wait()  
end  
if currentBV then currentBV:Destroy() end

end

local function toggleFly()
FlyEnabled = not FlyEnabled
if FlyEnabled then spawn(startFly) end
end

flyToggle.MouseButton1Click:Connect(toggleFly)
UserInputService.InputBegan:Connect(function(i,gpe)
if i.UserInputType==Enum.UserInputType.Keyboard and i.KeyCode==Enum.KeyCode.F and not gpe then
toggleFly()
end
end)

-- Minimize/restore
minBtn.MouseButton1Click:Connect(function()
frame.Visible=false; topTitle.Visible=false; miniBox.Visible=true
end)
miniBox.MouseButton1Click:Connect(function()
frame.Visible=true; topTitle.Visible=true; miniBox.Visible=false
end)

-- Close confirm
closeBtn.MouseButton1Click:Connect(function() confirmFrame.Visible=true end)
noBtn.MouseButton1Click:Connect(function() confirmFrame.Visible=false end)
yesBtn.MouseButton1Click:Connect(function()
if currentBV then currentBV:Destroy() end
screenGui:Destroy()
end)

-- Defaults
humanoid.WalkSpeed=WalkSpeedValue
humanoid.JumpPower=JumpPowerValue

-- Respawn handling
player.CharacterAdded:Connect(function(char)
character=char
humanoid=char:WaitForChild("Humanoid")
root=char:WaitForChild("HumanoidRootPart")
humanoid.WalkSpeed=WalkSpeedValue
humanoid.JumpPower=JumpPowerValue
end)

-- Instruction bottom
local inst=Instance.new("TextLabel")
inst.Size=UDim2.new(0,300,0,20)
inst.Position=UDim2.new(0.5,-150,1,-28)
inst.BackgroundTransparency=1
inst.Text="F=Fly | Space=Up | Shift=Down | \(<\) > adjust values"
inst.Font=Enum.Font.SourceSans
inst.TextSize=14
inst.TextColor3=Color3.fromRGB(200,200,200)
inst.Parent=frame
