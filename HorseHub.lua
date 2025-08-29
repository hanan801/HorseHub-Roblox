-- Horse Hub GUI v5 (Opening + Key System + Full GUI)
-- NOTE: Isi placeholder URL/ID/TOKEN sesuai konfigurasi Luarmor/Proxy milikmu.

--// Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local root = character:WaitForChild("HumanoidRootPart")
local playerGui = player:WaitForChild("PlayerGui")

--========================================================
--= CONFIG (ISI SENDIRI)
--========================================================
local CONFIG = {
    -- URL tempat user mendapatkan key (Luarmor → Linkvertise → kembali Luarmor)
    LUARMOR_GET_KEY_URL = "https://YOUR_LUARMOR_GET_KEY_URL", -- TODO

    -- Endpoint verifikasi key (direkomendasikan lewat PROXY server milikmu)
    -- Contoh bentuk: https://your-proxy.domain/verify?key={key}&hwid={hwid}&script_id={id}
    VERIFY_ENDPOINT = "https://YOUR_VERIFY_ENDPOINT_URL", -- TODO

    -- Parameter tambahan
    SCRIPT_ID = "YOUR_SCRIPT_ID", -- TODO (opsional, jika Luarmor minta)
    USE_PROXY = true,             -- true jika kamu pakai proxy (disarankan)
    API_TOKEN = nil,              -- JANGAN taruh token rahasia di client! Biarkan nil jika pakai proxy

    -- Simpan key ke file (kalau executor mendukung writefile/isfile)
    SAVE_KEY_FILENAME = "HorseHub_Key.txt",
}

--========================================================
--= HELPER: REQUEST (syn.request/http_request/HttpService)
--========================================================
local request
do
    request = (syn and syn.request)
           or (http and http.request)
           or (http_request)
           or (fluxus and fluxus.request)
           or (krnl and krnl.request)
           or (function(opts)
               -- Fallback HttpService (GET saja) jika diizinkan
               if opts.Method == "GET" then
                   local url = opts.Url
                   local success, body = pcall(function()
                       return HttpService:GetAsync(url)
                   end)
                   return {Success = success, StatusCode = success and 200 or 500, Body = body or ""}
               else
                   return {Success = false, StatusCode = 405, Body = "Method Not Allowed"}
               end
           end)
end

--========================================================
--= OPENING ANIMATION
--========================================================
local openingGui = Instance.new("ScreenGui")
openingGui.IgnoreGuiInset = true
openingGui.Name = "HorseHubOpening"
openingGui.ResetOnSpawn = false
openingGui.Parent = playerGui

local bgFrame = Instance.new("Frame")
bgFrame.Size = UDim2.new(1,0,1,0)
bgFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
bgFrame.BackgroundTransparency = 0
bgFrame.Parent = openingGui

-- Teks 3D (stroke + shadow offset)
local openingText = Instance.new("TextLabel")
openingText.Size = UDim2.new(1,0,1,0)
openingText.BackgroundTransparency = 1
openingText.Text = ""
openingText.TextScaled = true
openingText.Font = Enum.Font.GothamBlack
openingText.TextColor3 = Color3.fromRGB(255, 50, 50)
openingText.TextStrokeTransparency = 0
openingText.TextStrokeColor3 = Color3.fromRGB(70,70,70)
openingText.Parent = bgFrame

local shadow = openingText:Clone()
shadow.TextColor3 = Color3.fromRGB(80,80,80)
shadow.TextStrokeTransparency = 1
shadow.Position = UDim2.new(0, 3, 0, 3)
shadow.ZIndex = openingText.ZIndex - 1
shadow.Parent = bgFrame

-- Efek ketik huruf per huruf
local fullText = "HORSE HUB"
spawn(function()
    for i = 1, #fullText do
        local sub = string.sub(fullText, 1, i)
        openingText.Text = sub
        shadow.Text = sub
        task.wait(0.12)
    end
    -- Efek scale kecil + fade out
    local zoomIn = Instance.new("UIScale")
    zoomIn.Parent = openingText
    zoomIn.Scale = 1.0
    TweenService:Create(zoomIn, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1.08}):Play()
    task.wait(0.4)
    local tweenInfo = TweenInfo.new(1.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(openingText, tweenInfo, {TextTransparency = 1, TextStrokeTransparency = 1}):Play()
    TweenService:Create(shadow, tweenInfo, {TextTransparency = 1}):Play()
    TweenService:Create(bgFrame, tweenInfo, {BackgroundTransparency = 1}):Play()
    task.wait(1.65)
    openingGui:Destroy()
end)

-- Tunggu opening selesai sebelum lanjut
task.wait(#fullText*0.12 + 2.1)

--========================================================
--= KEY GATE GUI
--========================================================
local keyGui = Instance.new("ScreenGui")
keyGui.Name = "HorseHubKeyGate"
keyGui.ResetOnSpawn = false
keyGui.Parent = playerGui

local kg = Instance.new("Frame")
kg.Size = UDim2.new(0, 420, 0, 230)
kg.Position = UDim2.new(0.5, -210, 0.5, -115)
kg.BackgroundColor3 = Color3.fromRGB(25,25,25)
kg.BorderSizePixel = 0
kg.Parent = keyGui
local kgStroke = Instance.new("UIStroke"); kgStroke.Thickness=2; kgStroke.Color=Color3.fromRGB(100,100,100); kgStroke.Parent=kg

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0, 36)
title.Position = UDim2.new(0,10,0,10)
title.BackgroundTransparency = 1
title.Text = "Horse Hub — Key System"
title.Font = Enum.Font.GothamSemibold
title.TextSize = 20
title.TextColor3 = Color3.fromRGB(255,50,50)
title.Parent = kg

local info = Instance.new("TextLabel")
info.Size = UDim2.new(1,-20,0,40)
info.Position = UDim2.new(0,10,0,46)
info.BackgroundTransparency = 1
info.TextWrapped = true
info.Text = "Dapatkan key lewat Luarmor → Linkvertise → kembali ke Luarmor, lalu paste key di bawah."
info.Font = Enum.Font.Gotham
info.TextSize = 14
info.TextColor3 = Color3.fromRGB(220,220,220)
info.Parent = kg

local keyBox = Instance.new("TextBox")
keyBox.Size = UDim2.new(1, -20, 0, 34)
keyBox.Position = UDim2.new(0,10,0,92)
keyBox.PlaceholderText = "Paste key di sini..."
keyBox.Text = ""
keyBox.Font = Enum.Font.Gotham
keyBox.TextSize = 16
keyBox.TextColor3 = Color3.fromRGB(255,255,255)
keyBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
keyBox.BorderSizePixel = 0
keyBox.ClearTextOnFocus = false
keyBox.Parent = kg

local row = Instance.new("Frame")
row.Size = UDim2.new(1,-20,0,36)
row.Position = UDim2.new(0,10,0,136)
row.BackgroundTransparency = 1
row.Parent = kg

local getKeyBtn = Instance.new("TextButton")
getKeyBtn.Size = UDim2.new(0.5, -6, 1, 0)
getKeyBtn.Position = UDim2.new(0,0,0,0)
getKeyBtn.Text = "Get Key"
getKeyBtn.Font = Enum.Font.GothamBold
getKeyBtn.TextSize = 16
getKeyBtn.TextColor3 = Color3.fromRGB(255,255,255)
getKeyBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
getKeyBtn.Parent = row

local verifyBtn = Instance.new("TextButton")
verifyBtn.Size = UDim2.new(0.5, -6, 1, 0)
verifyBtn.Position = UDim2.new(0.5, 6, 0, 0)
verifyBtn.Text = "Verify"
verifyBtn.Font = Enum.Font.GothamBold
verifyBtn.TextSize = 16
verifyBtn.TextColor3 = Color3.fromRGB(255,255,255)
verifyBtn.BackgroundColor3 = Color3.fromRGB(80,80,80)
verifyBtn.Parent = row

local statusLbl = Instance.new("TextLabel")
statusLbl.Size = UDim2.new(1,-20,0,28)
statusLbl.Position = UDim2.new(0,10,0,180)
statusLbl.BackgroundTransparency = 1
statusLbl.Text = ""
statusLbl.Font = Enum.Font.Gotham
statusLbl.TextSize = 14
statusLbl.TextColor3 = Color3.fromRGB(200,200,200)
statusLbl.Parent = kg

-- Auto-load key dari file kalau ada
pcall(function()
    if isfile and isfile(CONFIG.SAVE_KEY_FILENAME) then
        keyBox.Text = readfile(CONFIG.SAVE_KEY_FILENAME) or ""
    end
end)

-- HWID (gunakan ClientId supaya konsisten)
local function getHWID()
    local ok, id = pcall(function()
        return RbxAnalyticsService:GetClientId()
    end)
    if ok and id then return id end
    return tostring(player.UserId)
end

-- Open Luarmor get-key URL (copy ke clipboard; beberapa executor bisa open link)
local function openGetKey()
    local url = CONFIG.LUARMOR_GET_KEY_URL
    if setclipboard then setclipboard(url) end
    statusLbl.Text = "Link get-key dicopy ke clipboard. Buka di browser, selesaikan Linkvertise, lalu ambil key dari Luarmor."
end

getKeyBtn.MouseButton1Click:Connect(openGetKey)

-- Verifikasi key
local function verifyKey(key)
    statusLbl.Text = "Memverifikasi key..."
    local hwid = getHWID()

    -- Susun URL verifikasi (sesuaikan dengan skema endpoint/proxy kamu)
    -- Contoh query:
    --   /verify?key=<key>&hwid=<hwid>&script_id=<id>
    local url = string.format("%s?key=%s&hwid=%s&script_id=%s",
        CONFIG.VERIFY_ENDPOINT,
        HttpService:UrlEncode(key),
        HttpService:UrlEncode(hwid),
        HttpService:UrlEncode(CONFIG.SCRIPT_ID or "default")
    )

    local headers = {["Accept"]="application/json"}
    if CONFIG.API_TOKEN and not CONFIG.USE_PROXY then
        -- Tidak disarankan menaruh token di client. Pakai proxy jika butuh secret!
        headers["Authorization"] = "Bearer "..tostring(CONFIG.API_TOKEN)
    end

    local res = request({
        Url = url,
        Method = "GET",
        Headers = headers
    })

    if not res or (res.Success == false and res.StatusCode ~= 200) then
        statusLbl.Text = "Gagal menghubungi server verifikasi."
        return false
    end

    local body = res.Body or ""
    local ok, data = pcall(function() return HttpService:JSONDecode(body) end)

    -- Harapkan JSON: { success=true/false, message="...", expires="..." }
    if ok and type(data) == "table" then
        if data.success == true then
            statusLbl.Text = "Key valid! Membuka Horse Hub..."
            -- Simpan key ke file bila bisa
            pcall(function()
                if writefile then writefile(CONFIG.SAVE_KEY_FILENAME, key) end
            end)
            return true
        else
            statusLbl.Text = "Key tidak valid: " .. (data.message or "Unknown")
            return false
        end
    else
        -- Kalau endpointmu balas text sederhana: "OK" / "VALID"
        local plain = string.lower(body)
        if plain:find("ok") or plain:find("valid") or plain:find('"success":true') then
            statusLbl.Text = "Key valid! Membuka Horse Hub..."
            pcall(function()
                if writefile then writefile(CONFIG.SAVE_KEY_FILENAME, key) end
            end)
            return true
        end
        statusLbl.Text = "Respon verifikasi tidak dikenali."
        return false
    end
end

verifyBtn.MouseButton1Click:Connect(function()
    local key = (keyBox.Text or ""):gsub("^%s+",""):gsub("%s+$","")
    if #key < 4 then
        statusLbl.Text = "Masukkan key yang benar."
        return
    end
    local ok = verifyKey(key)
    if ok then
        keyGui:Destroy()
        -- lanjut tampilkan GUI utama
        -- (dibuat setelah verifikasi agar fitur tidak bisa dipakai tanpa key)
        --========================================================
        --= HORSE HUB MAIN GUI (v4 yang kamu kirim)
        --========================================================

        -- Default values
        local FlyEnabled = false
        local FlySpeed = 50
        local FlyHeight = 10
        local ExtraSpeed = 0
        local WalkSpeedValue = 16
        local JumpPowerValue = 50
        local VerticalSpeed = 1

        -- Hapus GUI lama jika ada
        local old = playerGui:FindFirstChild("HorseHubGUI")
        if old then old:Destroy() end

        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "HorseHubGUI"
        screenGui.ResetOnSpawn = false
        screenGui.Parent = playerGui

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
        local mbStroke = Instance.new("UIStroke"); mbStroke.Thickness=2; mbStroke.Color=Color3.fromRGB(100,100,100); mbStroke.Parent=miniBox

        local confirmFrame = Instance.new("Frame")
        confirmFrame.Size = UDim2.new(0,260,0,120)
        confirmFrame.Position = UDim2.new(0.5,-130,0.5,-60)
        confirmFrame.BackgroundColor3 = Color3.fromRGB(35,35,35)
        confirmFrame.BorderSizePixel = 0
        confirmFrame.Visible = false
        confirmFrame.Parent = screenGui
        local cfStroke = Instance.new("UIStroke"); cfStroke.Thickness=2; cfStroke.Color=Color3.fromRGB(100,100,100); cfStroke.Parent=confirmFrame

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

        local flyRow = createNumberRow(frame, 60, "Fly Speed", 50)
        local heightRow = createNumberRow(frame, 100, "Fly Height", 10)
        local extraRow = createNumberRow(frame, 140, "Extra Speed", 0)
        local walkRow = createNumberRow(frame, 180, "Walk Speed", 16)
        local jumpRow = createNumberRow(frame, 220, "Jump Power", 50)

        local flyToggle = Instance.new("TextButton")
        flyToggle.Size = UDim2.new(0,300,0,36)
        flyToggle.Position = UDim2.new(0.5,-150,0,268)
        flyToggle.Text = "Toggle Fly (F)"
        flyToggle.Font = Enum.Font.GothamBold
        flyToggle.TextSize = 18
        flyToggle.TextColor3 = Color3.fromRGB(255,255,255)
        flyToggle.BackgroundColor3 = Color3.fromRGB(60,60,60)
        flyToggle.Parent = frame

        local FlyEnabled=false
        local FlySpeed=50
        local FlyHeight=10
        local ExtraSpeed=0
        local WalkSpeedValue=16
        local JumpPowerValue=50
        local VerticalSpeed=1

        local function updateAllLabels()
            flyRow.val.Text = tostring(FlySpeed)
            heightRow.val.Text = tostring(FlyHeight)
            extraRow.val.Text = tostring(ExtraSpeed)
            walkRow.val.Text = tostring(WalkSpeedValue)
            jumpRow.val.Text = tostring(JumpPowerValue)
        end
        updateAllLabels()

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
        bindIncDec(jumpRow, function() ret
