-- Horse Hub GUI v5 (with RGB Opening + FE Black Hole)

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local root = character:WaitForChild("HumanoidRootPart")

-- Default values
local WalkSpeedValue = 16
local JumpPowerValue = 50
local ExtraSpeed = 0

-- PlayerGui
local playerGui = player:WaitForChild("PlayerGui")

-- Remove old GUI
local old = playerGui:FindFirstChild("HorseHubGUI")
if old then old:Destroy() end

-- ========== OPENING ANIMATION ==========
local openingGui = Instance.new("ScreenGui")
openingGui.IgnoreGuiInset = true
openingGui.Parent = playerGui

local bgFrame = Instance.new("Frame")
bgFrame.Size = UDim2.new(1,0,1,0)
bgFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
bgFrame.BackgroundTransparency = 0
bgFrame.Parent = openingGui

-- Optional: add background Image (horse)
local bgImage = Instance.new("ImageLabel")
bgImage.Size = UDim2.new(1,0,1,0)
bgImage.BackgroundTransparency = 1
bgImage.Image = "rbxassetid://0" -- default transparent
bgImage.ScaleType = Enum.ScaleType.Crop
bgImage.Parent = bgFrame
-- Ganti link custom kalau ada asset Roblox: bgImage.Image = "https://share.google/images/aJZJdGKIY943dFFUY" (harus upload ke Roblox Decal dulu)

local openingText = Instance.new("TextLabel")
openingText.Size = UDim2.new(1,0,1,0)
openingText.Text = ""
openingText.BackgroundTransparency = 1
openingText.TextColor3 = Color3.fromRGB(255,50,50)
openingText.Font = Enum.Font.GothamBlack
openingText.TextScaled = true
openingText.TextStrokeTransparency = 0
openingText.TextStrokeColor3 = Color3.fromRGB(80,80,80)
openingText.Parent = bgFrame

-- RGB loop for background
spawn(function()
    while bgFrame.Parent do
        for i = 0,255,5 do
            bgFrame.BackgroundColor3 = Color3.fromHSV(i/255,1,1)
            task.wait(0.03)
        end
    end
end)

-- Typing effect
local fullText = "HORSE HUB"
spawn(function()
    for i = 1, #fullText do
        openingText.Text = string.sub(fullText, 1, i)
        task.wait(0.18)
    end
    -- Fade out
    local tweenInfo = TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local t1 = TweenService:Create(openingText, tweenInfo, {TextTransparency = 1, TextStrokeTransparency = 1})
    local t2 = TweenService:Create(bgFrame, tweenInfo, {BackgroundTransparency = 1})
    t1:Play(); t2:Play()
    t2.Completed:Wait()
    openingGui:Destroy()
end)

task.wait(#fullText * 0.18 + 2.5)

-- ========== HORSE HUB MAIN GUI ==========
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "HorseHubGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Title
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
frame.Size = UDim2.new(0, 340, 0, 320)
frame.Position = UDim2.new(0.5, -170, 0.5, -160)
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

-- Close (X) and Minimize ([])
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
noBtn.Text = "No"
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

-- Create number rows
local function createNumberRow(parent, y, labelText, initialValue, callback)
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

    dec.MouseButton1Click:Connect(function()
        initialValue = initialValue - 1
        valLabel.Text = tostring(initialValue)
        callback(initialValue)
    end)
    inc.MouseButton1Click:Connect(function()
        initialValue = initialValue + 1
        valLabel.Text = tostring(initialValue)
        callback(initialValue)
    end)
end

-- Speed + Jump controls
createNumberRow(frame, 60, "Walk Speed", WalkSpeedValue, function(v)
    WalkSpeedValue = math.max(1,v)
    humanoid.WalkSpeed = WalkSpeedValue
end)

createNumberRow(frame, 100, "Jump Power", JumpPowerValue, function(v)
    JumpPowerValue = math.max(1,v)
    humanoid.JumpPower = JumpPowerValue
end)

-- ========== FE BLACK HOLE TOGGLE ==========
local blackholeBtn = Instance.new("TextButton")
blackholeBtn.Size = UDim2.new(0,300,0,36)
blackholeBtn.Position = UDim2.new(0.5,-150,0,160)
blackholeBtn.Text = "FE Black Hole: OFF"
blackholeBtn.Font = Enum.Font.GothamBold
blackholeBtn.TextSize = 18
blackholeBtn.TextColor3 = Color3.fromRGB(255,255,255)
blackholeBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
blackholeBtn.Parent = frame

local blackholeEnabled = false
local blackholeScript

blackholeBtn.MouseButton1Click:Connect(function()
    blackholeEnabled = not blackholeEnabled
    if blackholeEnabled then
        blackholeBtn.Text = "FE Black Hole: ON"
        blackholeBtn.BackgroundColor3 = Color3.fromRGB(40,170,40)
        blackholeScript = loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-FE-black-hole-18879"))()
    else
        blackholeBtn.Text = "FE Black Hole: OFF"
        blackholeBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
        if blackholeScript and typeof(blackholeScript)=="function" then
            pcall(function() blackholeScript(false) end)
        end
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
