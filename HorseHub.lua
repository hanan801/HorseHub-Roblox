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
local FlySpeed = 50
local ExtraSpeed = 0
local WalkSpeedValue = 16
local JumpPowerValue = 50

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
    
    -- Notifikasi setelah animasi pembukaan
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Horse Hub v1",
        Text = "Thanks for using my script btw script by h4000audio enjoy!",
        Duration = 5
    })
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
frame.Size = UDim2.new(0, 340, 0, 350)
frame.Position = UDim2.new(0.5, -170, 0.5, -175)
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
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Discord",
        Text = "Link discord telah disalin!",
        Duration = 3
    })
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
dec.TextColor3 = Color3.fromRGB(255,255,255) -- Warna putih untuk panah
dec.BackgroundColor3 = Color3.fromRGB(100,100,100) -- Abu-abu terang
dec.BorderSizePixel = 0
dec.Parent = parent  

local valLabel = Instance.new("TextLabel")  
valLabel.Size = UDim2.new(0,80,0,28)  
valLabel.Position = UDim2.new(0,186,0,y)  
valLabel.BackgroundColor3 = Color3.fromRGB(45,45,45) -- Abu-abu gelap
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
inc.TextColor3 = Color3.fromRGB(255,255,255) -- Warna putih untuk panah
inc.BackgroundColor3 = Color3.fromRGB(100,100,100) -- Abu-abu terang
inc.BorderSizePixel = 0
inc.Parent = parent  

return {dec=dec,val=valLabel,inc=inc}

end

-- Buat kontrol
local flyRow = createNumberRow(frame, 60, "Terbang Kecepatan", FlySpeed)
local extraRow = createNumberRow(frame, 100, "Extra Kecepatan", ExtraSpeed)
local walkRow = createNumberRow(frame, 140, "Kecepatan Berjalan", WalkSpeedValue)
local jumpRow = createNumberRow(frame, 180, "Daya Lompat", JumpPowerValue)

-- Frame untuk kontrol fly
local flyControlFrame = Instance.new("Frame")
flyControlFrame.Size = UDim2.new(0, 300, 0, 80)
flyControlFrame.Position = UDim2.new(0.5, -150, 0, 220)
flyControlFrame.BackgroundTransparency = 1
flyControlFrame.Parent = frame

-- Tombol Up
local upBtn = Instance.new("TextButton")
upBtn.Size = UDim2.new(0, 80, 0, 30)
upBtn.Position = UDim2.new(0, 10, 0, 0)
upBtn.BackgroundColor3 = Color3.fromRGB(45,45,45)
upBtn.BorderSizePixel = 0
upBtn.Text = "NAIK"
upBtn.Font = Enum.Font.GothamBold
upBtn.TextSize = 14
upBtn.TextColor3 = Color3.fromRGB(255,255,255)
upBtn.Parent = flyControlFrame

-- Tombol Down
local downBtn = Instance.new("TextButton")
downBtn.Size = UDim2.new(0, 80, 0, 30)
downBtn.Position = UDim2.new(0, 100, 0, 0)
downBtn.BackgroundColor3 = Color3.fromRGB(45,45,45)
downBtn.BorderSizePixel = 0
downBtn.Text = "TURUN"
downBtn.Font = Enum.Font.GothamBold
downBtn.TextSize = 14
downBtn.TextColor3 = Color3.fromRGB(255,255,255)
downBtn.Parent = flyControlFrame

-- Tombol Fly On/Off
local flyOnOffBtn = Instance.new("TextButton")
flyOnOffBtn.Size = UDim2.new(0, 80, 0, 30)
flyOnOffBtn.Position = UDim2.new(0, 190, 0, 0)
flyOnOffBtn.BackgroundColor3 = Color3.fromRGB(45,45,45)
flyOnOffBtn.BorderSizePixel = 0
flyOnOffBtn.Text = "FLY"
flyOnOffBtn.Font = Enum.Font.GothamBold
flyOnOffBtn.TextSize = 14
flyOnOffBtn.TextColor3 = Color3.fromRGB(255,255,255)
flyOnOffBtn.Parent = flyControlFrame

-- Update label angka
local function updateAllLabels()
flyRow.val.Text = tostring(FlySpeed)
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

bindIncDec(flyRow, function() return FlySpeed end, function(v) FlySpeed = math.max(1,v); updateAllLabels() end)
bindIncDec(extraRow, function() return ExtraSpeed end, function(v) ExtraSpeed = v end)
bindIncDec(walkRow, function() return WalkSpeedValue end, function(v) WalkSpeedValue = math.max(1,v); humanoid.WalkSpeed=WalkSpeedValue end)
bindIncDec(jumpRow, function() return JumpPowerValue end, function(v) JumpPowerValue = math.max(1,v); humanoid.JumpPower=JumpPowerValue end)

-- ========== SISTEM FLY DARI KODE ANDA ==========
local speaker = game:GetService("Players").LocalPlayer
local chr = game.Players.LocalPlayer.Character
local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
local nowe = false
local tpwalking = false
local speeds = FlySpeed

-- Notifikasi
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Fly GUI V3";
    Text = "By me_ozone and Quandale The Dinglish XII#3550";
    Duration = 5;
})

-- Fungsi untuk mengatur state humanoid
local function setHumanoidStates(enabled)
    hum:SetStateEnabled(Enum.HumanoidStateType.Climbing, enabled)  
    hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, enabled)  
    hum:SetStateEnabled(Enum.HumanoidStateType.Flying, enabled)  
    hum:SetStateEnabled(Enum.HumanoidStateType.Freefall, enabled)  
    hum:SetStateEnabled(Enum.HumanoidStateType.GettingUp, enabled)  
    hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, enabled)  
    hum:SetStateEnabled(Enum.HumanoidStateType.Landed, enabled)  
    hum:SetStateEnabled(Enum.HumanoidStateType.Physics, enabled)  
    hum:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, enabled)  
    hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, enabled)  
    hum:SetStateEnabled(Enum.HumanoidStateType.Running, enabled)  
    hum:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics, enabled)  
    hum:SetStateEnabled(Enum.HumanoidStateType.Seated, enabled)  
    hum:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics, enabled)  
    hum:SetStateEnabled(Enum.HumanoidStateType.Swimming, enabled)  
end

-- Tombol Fly On/Off
flyOnOffBtn.MouseButton1Click:Connect(function()
    if nowe == true then  
        nowe = false  
        flyOnOffBtn.Text = "FLY"
        flyOnOffBtn.BackgroundColor3 = Color3.fromRGB(45,45,45)
        
        setHumanoidStates(true)
        speaker.Character.Humanoid:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)  
    else   
        nowe = true  
        flyOnOffBtn.Text = "STOP"
        flyOnOffBtn.BackgroundColor3 = Color3.fromRGB(170,40,40)
        
        for i = 1, speeds do  
            spawn(function()  
                local hb = game:GetService("RunService").Heartbeat	  
                tpwalking = true  
                local chr = game.Players.LocalPlayer.Character  
                local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")  
                while tpwalking and hb:Wait() and chr and hum and hum.Parent do  
                    if hum.MoveDirection.Magnitude > 0 then  
                        chr:TranslateBy(hum.MoveDirection)  
                    end  
                end  
            end)  
        end  
        
        game.Players.LocalPlayer.Character.Animate.Disabled = true  
        local Char = game.Players.LocalPlayer.Character  
        local Hum = Char:FindFirstChildOfClass("Humanoid") or Char:FindFirstChildOfClass("AnimationController")  
        
        for i,v in next, Hum:GetPlayingAnimationTracks() do  
            v:AdjustSpeed(0)  
        end  
        
        setHumanoidStates(false)
        speaker.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Swimming)  
        
        -- Fly logic untuk R6 dan R15
        if game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").RigType == Enum.HumanoidRigType.R6 then  
            local plr = game.Players.LocalPlayer  
            local torso = plr.Character.Torso  
            local flying = true  
            local deb = true  
            local ctrl = {f = 0, b = 0, l = 0, r = 0}  
            local lastctrl = {f = 0, b = 0, l = 0, r = 0}  
            local maxspeed = FlySpeed
            local speed = 0  
            
            local bg = Instance.new("BodyGyro", torso)  
            bg.P = 9e4  
            bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)  
            bg.cframe = torso.CFrame  
            local bv = Instance.new("BodyVelocity", torso)  
            bv.velocity = Vector3.new(0,0.1,0)  
            bv.maxForce = Vector3.new(9e9, 9e9, 9e9)  
            
            if nowe == true then  
                plr.Character.Humanoid.PlatformStand = true  
            end  
            
            spawn(function()
                while nowe == true and humanoid.Health > 0 do  
                    game:GetService("RunService").RenderStepped:Wait()  
                    
                    if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then  
                        speed = speed+.5+(speed/maxspeed)  
                        if speed > maxspeed then  
                            speed = maxspeed  
                        end  
                    elseif not (ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0) and speed ~= 0 then  
                        speed = speed-1  
                        if speed < 0 then  
                            speed = 0  
                        end  
                    end  
                    
                    if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then  
                        bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (ctrl.f+ctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(ctrl.l+ctrl.r,(ctrl.f+ctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed  
                        lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}  
                    elseif (ctrl.l + ctrl.r) == 0 and (ctrl.f + ctrl.b) == 0 and speed ~= 0 then  
                        bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (lastctrl.f+lastctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(lastctrl.l+lastctrl.r,(lastctrl.f+lastctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed  
                    else  
                        bv.velocity = Vector3.new(0,0,0)  
                    end  
                    
                    bg.cframe = game.Workspace.CurrentCamera.CoordinateFrame * CFrame.Angles(-math.rad((ctrl.f+ctrl.b)*50*speed/maxspeed),0,0)  
                end  
                
                -- Cleanup
                ctrl = {f = 0, b = 0, l = 0, r = 0}  
                lastctrl = {f = 0, b = 0, l = 0, r = 0}  
                speed = 0  
                bg:Destroy()  
                bv:Destroy()  
                plr.Character.Humanoid.PlatformStand = false  
                game.Players.LocalPlayer.Character.Animate.Disabled = false  
                tpwalking = false  
            end)
        else  
            -- R15 fly logic
            local plr = game.Players.LocalPlayer  
            local UpperTorso = plr.Character.UpperTorso  
            local flying = true  
            local deb = true  
            local ctrl = {f = 0, b = 0, l = 0, r = 0}  
            local lastctrl = {f = 0, b = 0, l = 0, r = 0}  
            local maxspeed = FlySpeed
            local speed = 0  
            
            local bg = Instance.new("BodyGyro", UpperTorso)  
            bg.P = 9e4  
            bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)  
            bg.cframe = UpperTorso.CFrame  
            local bv = Instance.new("BodyVelocity", UpperTorso)  
            bv.velocity = Vector3.new(0,0.1,0)  
            bv.maxForce = Vector3.new(9e9, 9e9, 9e9)  
            
            if nowe == true then  
                plr.Character.Humanoid.PlatformStand = true  
            end  
            
            spawn(function()
                while nowe == true and humanoid.Health > 0 do  
                    wait()  
                    
                    if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then  
                        speed = speed+.5+(speed/maxspeed)  
                        if speed > maxspeed then  
                            speed = maxspeed  
                        end  
                    elseif not (ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0) and speed ~= 0 then  
                        speed = speed-1  
                        if speed < 0 then  
                            speed = 0  
                                    
