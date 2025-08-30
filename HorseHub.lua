-- Horse Hub v5 (Full) - Opening + Main GUI + FE Black Hole + Integrated Fly GUI (user-provided)
-- All GUI text in English. Replace image/decal IDs if needed.

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Ensure character/humanoid/root refs
local function getCharacterParts()
    local char = player.Character or player.CharacterAdded:Wait()
    local humanoid = char:FindFirstChildWhichIsA("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
    return char, humanoid, root
end

local character, humanoid, root = getCharacterParts()
player.CharacterAdded:Connect(function(char)
    character = char
    humanoid = char:WaitForChild("Humanoid")
    root = char:WaitForChild("HumanoidRootPart")
end)

-- Remove any previous HorseHub GUI to avoid duplicates
local prev = playerGui:FindFirstChild("HorseHubGUI_Final_v5")
if prev then prev:Destroy() end
local prev2 = playerGui:FindFirstChild("HorseHub_FlyGUI_v5")
if prev2 then prev2:Destroy() end

-------------------------
-- OPENING ANIMATION
-------------------------
local openingGui = Instance.new("ScreenGui")
openingGui.Name = "HorseHubOpening_v5"
openingGui.IgnoreGuiInset = true
openingGui.ResetOnSpawn = false
openingGui.Parent = playerGui

local bgFrame = Instance.new("Frame", openingGui)
bgFrame.Size = UDim2.new(1,0,1,0)
bgFrame.Position = UDim2.new(0,0,0,0)
bgFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
bgFrame.BorderSizePixel = 0
bgFrame.ZIndex = 1

-- background image (user link). If this doesn't display, upload to Roblox and use rbxassetid://...
local bgImage = Instance.new("ImageLabel", bgFrame)
bgImage.Size = UDim2.new(1,0,1,0)
bgImage.Position = UDim2.new(0,0,0,0)
bgImage.BackgroundTransparency = 1
bgImage.Image = "https://share.google/images/aJZJdGKIY943dFFUY" -- replace with rbxassetid://... if needed
bgImage.ScaleType = Enum.ScaleType.Crop
bgImage.ZIndex = 1

local overlay = Instance.new("Frame", openingGui)
overlay.Size = UDim2.new(1,0,1,0)
overlay.BackgroundTransparency = 0
overlay.BackgroundColor3 = Color3.fromRGB(0,0,0)
overlay.ZIndex = 2

local openingText = Instance.new("TextLabel", openingGui)
openingText.Size = UDim2.new(1,0,0.2,0)
openingText.Position = UDim2.new(0,0,0.4,0)
openingText.BackgroundTransparency = 1
openingText.Font = Enum.Font.GothamBlack
openingText.TextSize = 36
openingText.TextColor3 = Color3.fromRGB(255,50,50)
openingText.TextStrokeTransparency = 0
openingText.TextStrokeColor3 = Color3.fromRGB(80,80,80)
openingText.Text = ""
openingText.TextScaled = true
openingText.ZIndex = 3
openingText.TextWrapped = true

-- RGB cycling (affects overlay transparency color blend; keeps image visible)
local rainbowEnabled = true
spawn(function()
    local hue = 0
    while openingGui.Parent and rainbowEnabled do
        hue = (hue + 0.01) % 1
        local c = Color3.fromHSV(hue, 0.9, 0.9)
        -- subtle overlay tint so the image still shows
        overlay.BackgroundColor3 = c
        overlay.BackgroundTransparency = 0.35
        task.wait(0.02)
    end
end)

-- Typewriter effect, slow
local fullText = "HORSE HUB"
spawn(function()
    for i = 1, #fullText do
        openingText.Text = string.sub(fullText, 1, i)
        task.wait(0.16)
    end
    task.wait(0.8)
    -- fade out overlay and text
    local tweenT = TweenService:Create(openingText, TweenInfo.new(1.2, Enum.EasingStyle.Quad), {TextTransparency = 1, TextStrokeTransparency = 1})
    local tweenO = TweenService:Create(overlay, TweenInfo.new(1.2, Enum.EasingStyle.Quad), {BackgroundTransparency = 1})
    local tweenB = TweenService:Create(bgFrame, TweenInfo.new(1.2, Enum.EasingStyle.Quad), {BackgroundTransparency = 1})
    tweenT:Play(); tweenO:Play(); tweenB:Play()
    tweenT.Completed:Wait()
    openingGui:Destroy()
    rainbowEnabled = false
end)

-- Wait enough for typing+fade
task.wait(#fullText * 0.16 + 2.5)

-------------------------
-- MAIN HORSE HUB GUI
-------------------------
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "HorseHubGUI_Final_v5"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Top small title
local topTitle = Instance.new("TextLabel", screenGui)
topTitle.Size = UDim2.new(0, 220, 0, 24)
topTitle.Position = UDim2.new(0.5, -110, 0, 8)
topTitle.BackgroundTransparency = 1
topTitle.Text = "Horse Hub"
topTitle.Font = Enum.Font.GothamSemibold
topTitle.TextSize = 18
topTitle.TextColor3 = Color3.fromRGB(255,50,50)
topTitle.TextStrokeTransparency = 0.7

-- Main Frame
local frame = Instance.new("Frame", screenGui)
frame.Name = "MainFrame"
frame.Size = UDim2.new(0, 360, 0, 360)
frame.Position = UDim2.new(0.5, -180, 0.45, -180)
frame.BackgroundColor3 = Color3.fromRGB(28,28,28)
frame.BorderSizePixel = 0

local frameStroke = Instance.new("UIStroke", frame)
frameStroke.Thickness = 2
frameStroke.Color = Color3.fromRGB(100,100,100)

local header = Instance.new("TextLabel", frame)
header.Size = UDim2.new(0,220,0,36)
header.Position = UDim2.new(0.5, -110, 0, 8)
header.BackgroundTransparency = 1
header.Text = "Horse Hub"
header.Font = Enum.Font.GothamSemibold
header.TextSize = 20
header.TextColor3 = Color3.fromRGB(255,50,50)

-- Close & Minimize
local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0,34,0,30); closeBtn.Position = UDim2.new(1,-38,0,6)
closeBtn.Text = "X"; closeBtn.Font = Enum.Font.SourceSansBold; closeBtn.TextSize = 18
closeBtn.TextColor3 = Color3.fromRGB(200,50,50); closeBtn.BackgroundColor3 = Color3.fromRGB(45,45,45)

local minBtn = Instance.new("TextButton", frame)
minBtn.Size = UDim2.new(0,34,0,30); minBtn.Position = UDim2.new(1,-78,0,6)
minBtn.Text = "▢"; minBtn.Font = Enum.Font.SourceSansSemibold; minBtn.TextSize = 18
minBtn.TextColor3 = Color3.fromRGB(230,230,230); minBtn.BackgroundColor3 = Color3.fromRGB(45,45,45)

-- Mini box (when minimized)
local miniBox = Instance.new("TextButton", screenGui)
miniBox.Size = UDim2.new(0,140,0,46)
miniBox.Position = UDim2.new(0, 12, 0, 64)
miniBox.Text = "Horse Hub"
miniBox.Font = Enum.Font.GothamBold
miniBox.TextSize = 18
miniBox.TextColor3 = Color3.fromRGB(255,50,50)
miniBox.BackgroundColor3 = Color3.fromRGB(28,28,28)
miniBox.BorderSizePixel = 0
miniBox.Visible = false
local mbStroke = Instance.new("UIStroke", miniBox); mbStroke.Thickness = 2; mbStroke.Color = Color3.fromRGB(100,100,100)

-- Confirm close frame
local confirmFrame = Instance.new("Frame", screenGui)
confirmFrame.Size = UDim2.new(0,260,0,120)
confirmFrame.Position = UDim2.new(0.5,-130,0.5,-60)
confirmFrame.BackgroundColor3 = Color3.fromRGB(35,35,35)
confirmFrame.Visible = false
local cfStroke = Instance.new("UIStroke", confirmFrame); cfStroke.Thickness = 2; cfStroke.Color = Color3.fromRGB(100,100,100)
local confirmLabel = Instance.new("TextLabel", confirmFrame)
confirmLabel.Size = UDim2.new(1,0,0,48); confirmLabel.Position = UDim2.new(0,0,0,10)
confirmLabel.BackgroundTransparency = 1; confirmLabel.Font = Enum.Font.GothamBold; confirmLabel.Text = "Close script?"
confirmLabel.TextSize = 20; confirmLabel.TextColor3 = Color3.fromRGB(255,50,50)
local noBtn = Instance.new("TextButton", confirmFrame); noBtn.Size = UDim2.new(0,96,0,36); noBtn.Position = UDim2.new(0.11,0,0,64); noBtn.Text="No"; noBtn.Font=Enum.Font.GothamSemibold; noBtn.BackgroundColor3=Color3.fromRGB(60,60,60)
local yesBtn = Instance.new("TextButton", confirmFrame); yesBtn.Size = UDim2.new(0,96,0,36); yesBtn.Position = UDim2.new(0.55,0,0,64); yesBtn.Text="Yes"; yesBtn.Font=Enum.Font.GothamSemibold; yesBtn.BackgroundColor3=Color3.fromRGB(170,40,40)

-- Utility to create labeled numeric control row with <, value, >
local function createNumberRow(parent, y, labelText, initialValue, onChange)
    local lbl = Instance.new("TextLabel", parent)
    lbl.Size = UDim2.new(0,140,0,28); lbl.Position = UDim2.new(0,16,0,y)
    lbl.BackgroundTransparency = 1; lbl.Text = labelText; lbl.Font = Enum.Font.Gotham; lbl.TextSize = 14; lbl.TextColor3 = Color3.fromRGB(220,220,220); lbl.TextXAlignment = Enum.TextXAlignment.Left

    local dec = Instance.new("TextButton", parent); dec.Size = UDim2.new(0,28,0,28); dec.Position = UDim2.new(0,170,0,y); dec.Text="<"; dec.Font=Enum.Font.GothamBold; dec.TextSize=18
    local valLabel = Instance.new("TextLabel", parent); valLabel.Size = UDim2.new(0,80,0,28); valLabel.Position = UDim2.new(0,206,0,y); valLabel.BackgroundColor3=Color3.fromRGB(45,45,45); valLabel.BorderSizePixel=0; valLabel.Text=tostring(initialValue); valLabel.Font=Enum.Font.GothamBold; valLabel.TextSize=16; valLabel.TextColor3=Color3.fromRGB(255,255,255)
    local inc = Instance.new("TextButton", parent); inc.Size = UDim2.new(0,28,0,28); inc.Position = UDim2.new(0,288,0,y); inc.Text=">"; inc.Font=Enum.Font.GothamBold; inc.TextSize=18

    dec.MouseButton1Click:Connect(function()
        initialValue = initialValue - 1
        valLabel.Text = tostring(initialValue)
        if onChange then pcall(onChange, initialValue) end
    end)
    inc.MouseButton1Click:Connect(function()
        initialValue = initialValue + 1
        valLabel.Text = tostring(initialValue)
        if onChange then pcall(onChange, initialValue) end
    end)
    return {dec=dec, val=valLabel, inc=inc}
end

-- Default values
local WalkSpeedValue = 16
local JumpPowerValue = 50

-- Create control rows
local walkRow = createNumberRow(frame, 72, "Walk Speed", WalkSpeedValue, function(v)
    WalkSpeedValue = math.max(1, math.floor(v))
    if humanoid then pcall(function() humanoid.WalkSpeed = WalkSpeedValue end) end
end)
local jumpRow = createNumberRow(frame, 116, "Jump Power", JumpPowerValue, function(v)
    JumpPowerValue = math.max(1, math.floor(v))
    if humanoid then pcall(function() humanoid.JumpPower = JumpPowerValue end) end
end)

-- Instruction label
local inst = Instance.new("TextLabel", screenGui)
inst.Size = UDim2.new(0,380,0,20); inst.Position = UDim2.new(0.5,-190,1,-28); inst.BackgroundTransparency = 1
inst.Font = Enum.Font.SourceSans; inst.TextSize = 14; inst.TextColor3 = Color3.fromRGB(200,200,200)
inst.Text = "Use the Fly GUI (bottom-right) for flight controls. FE Black Hole toggle is bottom-left."

-- Minimize/restore
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

-- Close confirm
closeBtn.MouseButton1Click:Connect(function()
    confirmFrame.Visible = true
end)
noBtn.MouseButton1Click:Connect(function() confirmFrame.Visible = false end)
yesBtn.MouseButton1Click:Connect(function() 
    pcall(function() screenGui:Destroy() end)
end)

-- Apply defaults to current humanoid if available
if humanoid then
    pcall(function() humanoid.WalkSpeed = WalkSpeedValue; humanoid.JumpPower = JumpPowerValue end)
end

-- Keep updated on respawn
player.CharacterAdded:Connect(function(char)
    character = char
    humanoid = char:WaitForChild("Humanoid")
    root = char:WaitForChild("HumanoidRootPart")
    pcall(function() humanoid.WalkSpeed = WalkSpeedValue; humanoid.JumpPower = JumpPowerValue end)
end)

-------------------------
-- FE BLACK HOLE TOGGLE (bottom-left)
-------------------------
local blackholeBtn = Instance.new("TextButton", screenGui)
blackholeBtn.Size = UDim2.new(0,160,0,40)
blackholeBtn.Position = UDim2.new(0, 12, 1, -62) -- bottom-left margin
blackholeBtn.Text = "FE Black Hole: OFF"
blackholeBtn.Font = Enum.Font.GothamBold
blackholeBtn.TextSize = 16
blackholeBtn.TextColor3 = Color3.fromRGB(255,255,255)
blackholeBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
blackholeBtn.AutoButtonColor = true

local blackholeEnabled = false
local blackholeController = nil

blackholeBtn.MouseButton1Click:Connect(function()
    blackholeEnabled = not blackholeEnabled
    if blackholeEnabled then
        blackholeBtn.Text = "FE Black Hole: ON"
        blackholeBtn.BackgroundColor3 = Color3.fromRGB(40,170,40)
        -- Load FE Black Hole script (wrapped in pcall)
        local ok, res = pcall(function()
            return loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-FE-black-hole-18879"))()
        end)
        if not ok then
            warn("Failed to load FE Black Hole:", res)
            blackholeBtn.Text = "FE Black Hole: ERROR"
            blackholeBtn.BackgroundColor3 = Color3.fromRGB(170,40,40)
            blackholeEnabled = false
        else
            blackholeController = res -- may be nil or function depending on remote script design
        end
    else
        blackholeBtn.Text = "FE Black Hole: OFF"
        blackholeBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
        -- Attempt to disable if script returned a disable function
        if blackholeController and type(blackholeController) == "function" then
            pcall(function() blackholeController(false) end)
        end
        blackholeController = nil
    end
end)

-------------------------
-- INTEGRATED FLY GUI (user-provided) — placed bottom-right
-------------------------
-- We'll create a single parent ScreenGui for fly to avoid conflicts
local flyGui = Instance.new("ScreenGui")
flyGui.Name = "HorseHub_FlyGUI_v5"
flyGui.ResetOnSpawn = false
flyGui.Parent = playerGui

-- Reuse user's elements but anchor to bottom-right
-- Creating main frame and elements (copied from user's fly GUI)
local main = Instance.new("ScreenGui")
-- we'll attach the user's Frame into our flyGui to keep things tidy
main.Name = "FlyMain_temp"
main.Parent = flyGui
main.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
main.ResetOnSpawn = false

local Frame = Instance.new("Frame", main)
Frame.BackgroundColor3 = Color3.fromRGB(163, 255, 137)
Frame.BorderColor3 = Color3.fromRGB(103, 221, 213)
Frame.Size = UDim2.new(0, 190, 0, 57)
-- position to bottom-right with some margin
Frame.Position = UDim2.new(1, -210, 1, -90)

local up = Instance.new("TextButton", Frame)
up.Name = "up"; up.BackgroundColor3 = Color3.fromRGB(79, 255, 152); up.Size = UDim2.new(0,44,0,28); up.Font = Enum.Font.SourceSans; up.Text = "UP"; up.TextColor3 = Color3.fromRGB(0,0,0)

local down = Instance.new("TextButton", Frame)
down.Name = "down"; down.BackgroundColor3 = Color3.fromRGB(215, 255, 121); down.Position = UDim2.new(0,0,0.491228074,0); down.Size = UDim2.new(0,44,0,28); down.Font = Enum.Font.SourceSans; down.Text = "DOWN"; down.TextColor3 = Color3.fromRGB(0,0,0)

local onof = Instance.new("TextButton", Frame)
onof.Name = "onof"; onof.BackgroundColor3 = Color3.fromRGB(255,249,74); onof.Position = UDim2.new(0.702823281,0,0.491228074,0); onof.Size = UDim2.new(0,56,0,28); onof.Font = Enum.Font.SourceSans; onof.Text = "Fly"; onof.TextColor3 = Color3.fromRGB(0,0,0)

local TextLabel = Instance.new("TextLabel", Frame)
TextLabel.BackgroundColor3 = Color3.fromRGB(242,60,255); TextLabel.Position = UDim2.new(0.469327301,0,0,0); TextLabel.Size = UDim2.new(0,100,0,28); TextLabel.Font = Enum.Font.SourceSans; TextLabel.Text = "Fly GUI V3"; TextLabel.TextColor3 = Color3.fromRGB(0,0,0); TextLabel.TextScaled = true; TextLabel.TextWrapped = true

local plus = Instance.new("TextButton", Frame); plus.Name="plus"; plus.BackgroundColor3=Color3.fromRGB(133,145,255); plus.Position=UDim2.new(0.231578946,0,0,0); plus.Size=UDim2.new(0,45,0,28); plus.Font=Enum.Font.SourceSans; plus.Text="+"; plus.TextColor3=Color3.fromRGB(0,0,0); plus.TextScaled=true; plus.TextWrapped=true

local speedLabel = Instance.new("TextLabel", Frame); speedLabel.Name="speed"; speedLabel.BackgroundColor3=Color3.fromRGB(255,85,0); speedLabel.Position = UDim2.new(0.468421042,0,0.491228074,0); speedLabel.Size = UDim2.new(0,44,0,28); speedLabel.Font = Enum.Font.SourceSans; speedLabel.Text = "1"; speedLabel.TextColor3 = Color3.fromRGB(0,0,0); speedLabel.TextScaled = true; speedLabel.TextWrapped = true

local mine = Instance.new("TextButton", Frame); mine.Name="mine"; mine.BackgroundColor3=Color3.fromRGB(123,255,247); mine.Position=UDim2.new(0.231578946,0,0.491228074,0); mine.Size=UDim2.new(0,45,0,29); mine.Font=Enum.Font.SourceSans; mine.Text="-" ; mine.TextColor3=Color3.fromRGB(0,0,0); mine.TextScaled=true; mine.TextWrapped=true

local closebutton = Instance.new("TextButton", Frame); closebutton.Name="CloseBtn"; closebutton.BackgroundColor3=Color3.fromRGB(225,25,0); closebutton.Font=Enum.Font.SourceSans; closebutton.Size=UDim2.new(0,45,0,28); closebutton.Text="X"; closebutton.TextSize=18; closebutton.Position = UDim2.new(0,0,-1,27)

local mini = Instance.new("TextButton", Frame); mini.Name="minimize"; mini.BackgroundColor3=Color3.fromRGB(192,150,230); mini.Font=Enum.Font.SourceSans; mini.Size=UDim2.new(0,45,0,28); mini.Text="-"; mini.TextSize=24; mini.Position = UDim2.new(0,44,-1,27)

local mini2 = Instance.new("TextButton", Frame); mini2.Name="minimize2"; mini2.BackgroundColor3=Color3.fromRGB(192,150,230); mini2.Font=Enum.Font.SourceSans; mini2.Size=UDim2.new(0,45,0,28); mini2.Text="+"; mini2.TextSize=24; mini2.Position = UDim2.new(0,44,-1,57); mini2.Visible = false

-- Fly logic: reuse user's logic but localize variables to avoid global collisions
local speeds = 1
local speaker = player
local nowe = false
local tpwalking = false

-- Notification (kept in English)
pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Fly GUI V3",
        Text = "Fly module integrated",
        Duration = 5
    })
end)

Frame.Active = true
Frame.Draggable = true

-- helper to safely get Humanoid each time
local function getHum()
    local ch = player.Character
    if ch then return ch:FindFirstChildWhichIsA("Humanoid") end
    return nil
end

-- onof (toggle)
onof.MouseButton1Down:Connect(function()
    local hum = getHum()
    if nowe == true then
        nowe = false
        if hum then
            hum:SetStateEnabled(Enum.HumanoidStateType.Climbing,true)
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown,true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Flying,true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Freefall,true)
            hum:SetStateEnabled(Enum.HumanoidStateType.GettingUp,true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Jumping,true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Landed,true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Physics,true)
            hum:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding,true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Running,true)
            hum:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics,true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Seated,true)
            hum:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics,true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Swimming,true)
            if hum.Parent then pcall(function() hum:ChangeState(Enum.HumanoidStateType.RunningNoPhysics) end) end
        end
    else
        nowe = true
        -- spawn tpwalking threads
        for i = 1, speeds do
            spawn(function()
                local hb = RunService.Heartbeat
                tpwalking = true
                while tpwalking and hb:Wait() and player.Character and getHum() and getHum().Parent do
                    local currentHum = getHum()
                    if currentHum and currentHum.MoveDirection.Magnitude > 0 then
                        player.Character:TranslateBy(currentHum.MoveDirection)
                    end
                end
            end)
        end
        -- disable animate and freeze animations
        pcall(function()
            player.Character.Animate.Disabled = true
            local Hum = player.Character:FindFirstChildOfClass("Humanoid") or
