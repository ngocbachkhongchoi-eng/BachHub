-- ============================================================
-- BÁCH EXECUTOR - FULL (KEY NHẬP TAY + SAVE + REJOIN)
-- ============================================================

if not game:IsLoaded() then game.Loaded:Wait() end
repeat task.wait() until game.Players and game.Players.LocalPlayer

local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local LocalPlayer = game.Players.LocalPlayer

for _, g in pairs(CoreGui:GetChildren()) do
    if g.Name == "BachExec" then g:Destroy() end
end

local PlaceId = game.PlaceId
local JobId = game.JobId
local Rejoining = false
local KeyVerified = false
local CORRECT_KEY = "bindepzai123"

local SAVE_FILE = "bach_saved.lua"

local function SaveScript(code)
    pcall(function()
        if writefile then writefile(SAVE_FILE, code) end
    end)
end

local function LoadScript()
    local code = ""
    pcall(function()
        if readfile and isfile and isfile(SAVE_FILE) then
            code = readfile(SAVE_FILE)
        end
    end)
    return code
end

local function DeleteSave()
    pcall(function()
        if delfile and isfile and isfile(SAVE_FILE) then
            delfile(SAVE_FILE)
        end
    end)
end

local function Rejoin()
    if Rejoining then return end
    Rejoining = true
    local queueCode = [[
        wait(3)
        local code = ""
        pcall(function()
            if readfile and isfile and isfile("]] .. SAVE_FILE .. [[") then
                code = readfile("]] .. SAVE_FILE .. [[")
            end
        end)
        if code ~= "" then
            pcall(function() loadstring(code)() end)
        end
    ]]
    pcall(function()
        if syn and syn.queue_on_teleport then syn.queue_on_teleport(queueCode) end
    end)
    pcall(function()
        if queue_on_teleport then queue_on_teleport(queueCode) end
    end)
    pcall(function()
        TeleportService:TeleportToPlaceInstance(PlaceId, JobId, LocalPlayer)
    end)
    task.wait(5)
    Rejoining = false
end

LocalPlayer.OnTeleport:Connect(function()
    task.wait(2)
    Rejoin()
end)

CoreGui.DescendantAdded:Connect(function(obj)
    pcall(function()
        if obj:IsA("TextLabel") then
            task.spawn(function()
                task.wait(0.5)
                local text = obj.Text
                if not text then return end
                local lower = text:lower()
                if lower:find("kicked") or lower:find("disconnected")
                   or lower:find("bạn đã bị kick") or lower:find("you have been kicked")
                   or lower:find("lost connection") or lower:find("mất kết nối") then
                    task.wait(3)
                    Rejoin()
                end
            end)
        end
    end)
end)

-- ============================================================
-- GUI
-- ============================================================
local gui = Instance.new("ScreenGui")
gui.Name = "BachExec"
gui.ResetOnSpawn = false
gui.Parent = CoreGui

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 480, 0, 400)
main.Position = UDim2.new(0.5, -240, 0.5, -200)
main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
main.Visible = true
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", main).Color = Color3.fromRGB(80, 180, 80)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, -110, 0, 35)
title.Position = UDim2.new(0, 12, 0, 0)
title.BackgroundTransparency = 1
title.Text = "✦ BÁCH EXECUTOR (F6)"
title.TextColor3 = Color3.fromRGB(100, 220, 100)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Left

-- NÚT INJECT NHỎ
local injectBtn = Instance.new("TextButton", main)
injectBtn.Size = UDim2.new(0, 60, 0, 25)
injectBtn.Position = UDim2.new(1, -90, 0, 5)
injectBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 60)
injectBtn.Text = "🚀 Inject"
injectBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
injectBtn.Font = Enum.Font.GothamBold
injectBtn.TextSize = 11
injectBtn.Active = true
injectBtn.Selectable = true
Instance.new("UICorner", injectBtn).CornerRadius = UDim.new(0, 5)

local closeBtn = Instance.new("TextButton", main)
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(1, -30, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 12
closeBtn.Active = true
closeBtn.Selectable = true
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1, 0)

-- THÔNG BÁO
local injectNotif = Instance.new("TextLabel", main)
injectNotif.Size = UDim2.new(1, -30, 0, 40)
injectNotif.Position = UDim2.new(0, 15, 0, 45)
injectNotif.BackgroundColor3 = Color3.fromRGB(100, 80, 0)
injectNotif.Text = "⚠ CHƯA INJECT - ẤN NÚT INJECT"
injectNotif.TextColor3 = Color3.fromRGB(255, 255, 255)
injectNotif.Font = Enum.Font.GothamBold
injectNotif.TextSize = 12
injectNotif.Visible = true
Instance.new("UICorner", injectNotif).CornerRadius = UDim.new(0, 8)

-- LABEL KEY
local keyLabel = Instance.new("TextLabel", main)
keyLabel.Size = UDim2.new(1, -30, 0, 20)
keyLabel.Position = UDim2.new(0, 15, 0, 92)
keyLabel.BackgroundTransparency = 1
keyLabel.Text = "🔑 NHẬP KEY:"
keyLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
keyLabel.Font = Enum.Font.GothamBold
keyLabel.TextSize = 11
keyLabel.TextXAlignment = Enum.TextXAlignment.Left
keyLabel.Visible = false

-- Ô NHẬP KEY
local keyBox = Instance.new("TextBox", main)
keyBox.Size = UDim2.new(1, -30, 0, 32)
keyBox.Position = UDim2.new(0, 15, 0, 115)
keyBox.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
keyBox.BorderSizePixel = 0
keyBox.Text = ""
keyBox.PlaceholderText = "Nhập key vào đây..."
keyBox.TextColor3 = Color3.fromRGB(220, 220, 220)
keyBox.PlaceholderColor3 = Color3.fromRGB(90, 90, 90)
keyBox.Font = Enum.Font.Code
keyBox.TextSize = 12
keyBox.ClearTextOnFocus = false
keyBox.Visible = false
Instance.new("UICorner", keyBox).CornerRadius = UDim.new(0, 6)

-- NÚT XÁC NHẬN KEY
local keyBtn = Instance.new("TextButton", main)
keyBtn.Size = UDim2.new(1, -30, 0, 35)
keyBtn.Position = UDim2.new(0, 15, 0, 152)
keyBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 60)
keyBtn.Text = "✅ XÁC NHẬN KEY"
keyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
keyBtn.Font = Enum.Font.GothamBold
keyBtn.TextSize = 13
keyBtn.Active = true
keyBtn.Selectable = true
keyBtn.Visible = false
Instance.new("UICorner", keyBtn).CornerRadius = UDim.new(0, 6)

-- LABEL SCRIPT
local guide = Instance.new("TextLabel", main)
guide.Size = UDim2.new(1, -30, 0, 20)
guide.Position = UDim2.new(0, 15, 0, 92)
guide.BackgroundTransparency = 1
guide.Text = "👇 ĐIỀN SCRIPT VÀO ĐÂY:"
guide.TextColor3 = Color3.fromRGB(200, 200, 200)
guide.Font = Enum.Font.GothamBold
guide.TextSize = 11
guide.TextXAlignment = Enum.TextXAlignment.Left
guide.Visible = false

-- Ô NHẬP SCRIPT
local scriptBox = Instance.new("TextBox", main)
scriptBox.Size = UDim2.new(1, -30, 0, 140)
scriptBox.Position = UDim2.new(0, 15, 0, 115)
scriptBox.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
scriptBox.BorderSizePixel = 0
scriptBox.Text = LoadScript()
scriptBox.PlaceholderText = "-- Dán code Lua vào đây..."
scriptBox.TextColor3 = Color3.fromRGB(220, 220, 220)
scriptBox.PlaceholderColor3 = Color3.fromRGB(90, 90, 90)
scriptBox.Font = Enum.Font.Code
scriptBox.TextSize = 11
scriptBox.TextXAlignment = Enum.TextXAlignment.Left
scriptBox.TextYAlignment = Enum.TextYAlignment.Top
scriptBox.MultiLine = true
scriptBox.ClearTextOnFocus = false
scriptBox.Visible = false
Instance.new("UICorner", scriptBox).CornerRadius = UDim.new(0, 8)

-- NÚT LƯU
local saveBtn = Instance.new("TextButton", main)
saveBtn.Size = UDim2.new(0, 85, 0, 35)
saveBtn.Position = UDim2.new(0, 15, 0, 265)
saveBtn.BackgroundColor3 = Color3.fromRGB(50, 100, 180)
saveBtn.Text = "💾 LƯU"
saveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
saveBtn.Font = Enum.Font.GothamBold
saveBtn.TextSize = 13
saveBtn.Active = true
saveBtn.Selectable = true
saveBtn.Visible = false
Instance.new("UICorner", saveBtn).CornerRadius = UDim.new(0, 8)

-- NÚT XÓA SAVE
local clearSaveBtn = Instance.new("TextButton", main)
clearSaveBtn.Size = UDim2.new(0, 85, 0, 35)
clearSaveBtn.Position = UDim2.new(0, 108, 0, 265)
clearSaveBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
clearSaveBtn.Text = "🗑 XÓA LƯU"
clearSaveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
clearSaveBtn.Font = Enum.Font.GothamBold
clearSaveBtn.TextSize = 12
clearSaveBtn.Active = true
clearSaveBtn.Selectable = true
clearSaveBtn.Visible = false
Instance.new("UICorner", clearSaveBtn).CornerRadius = UDim.new(0, 8)

-- NÚT RUN
local runBtn = Instance.new("TextButton", main)
runBtn.Size = UDim2.new(0, 120, 0, 35)
runBtn.Position = UDim2.new(0, 201, 0, 265)
runBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
runBtn.Text = "▶ RUN SCRIPT"
runBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
runBtn.Font = Enum.Font.GothamBold
runBtn.TextSize = 13
runBtn.Active = true
runBtn.Selectable = true
runBtn.Visible = false
Instance.new("UICorner", runBtn).CornerRadius = UDim.new(0, 8)

-- NÚT LÀM LẠI
local resetBtn = Instance.new("TextButton", main)
resetBtn.Size = UDim2.new(0, 100, 0, 35)
resetBtn.Position = UDim2.new(0, 329, 0, 265)
resetBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
resetBtn.Text = "🔄 Làm lại"
resetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
resetBtn.Font = Enum.Font.GothamBold
resetBtn.TextSize = 12
resetBtn.Active = true
resetBtn.Selectable = true
resetBtn.Visible = false
Instance.new("UICorner", resetBtn).CornerRadius = UDim.new(0, 8)

-- TRẠNG THÁI
local statusLabel = Instance.new("TextLabel", main)
statusLabel.Size = UDim2.new(1, -30, 0, 25)
statusLabel.Position = UDim2.new(0, 15, 1, -30)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = ""
statusLabel.TextColor3 = Color3.fromRGB(100, 220, 100)
statusLabel.Font = Enum.Font.GothamBold
statusLabel.TextSize = 11

-- ============================================================
-- NÚT INJECT - HIỆN Ô NHẬP KEY
-- ============================================================
injectBtn.Activated:Connect(function()
    if KeyVerified then
        statusLabel.Text = "✅ ĐÃ INJECT RỒI"
        statusLabel.TextColor3 = Color3.fromRGB(100, 220, 100)
        task.wait(2)
        statusLabel.Text = ""
        return
    end
    
    -- HIỆN Ô NHẬP KEY
    injectNotif.Text = "🔑 HÃY NHẬP KEY VÀO Ô BÊN DƯỚI"
    injectNotif.TextColor3 = Color3.fromRGB(255, 200, 0)
    injectNotif.BackgroundColor3 = Color3.fromRGB(100, 80, 0)
    injectNotif.Visible = true
    
    keyLabel.Visible = true
    keyBox.Visible = true
    keyBtn.Visible = true
end)

-- ============================================================
-- NÚT XÁC NHẬN KEY
-- ============================================================
keyBtn.Activated:Connect(function()
    if keyBox.Text == CORRECT_KEY then
        KeyVerified = true
        
        injectNotif.Text = "✅ INJECT THÀNH CÔNG"
        injectNotif.TextColor3 = Color3.fromRGB(255, 255, 255)
        injectNotif.BackgroundColor3 = Color3.fromRGB(0, 100, 50)
        
        task.wait(2)
        injectNotif.Visible = false
        keyLabel.Visible = false
        keyBox.Visible = false
        keyBtn.Visible = false
        
        -- HIỆN CÁC NÚT SCRIPT
        guide.Visible = true
        scriptBox.Visible = true
        saveBtn.Visible = true
        clearSaveBtn.Visible = true
        runBtn.Visible = true
        resetBtn.Visible = true
    else
        keyBox.Text = ""
        injectNotif.Text = "❌ KEY SAI - NHẬP LẠI"
        injectNotif.TextColor3 = Color3.fromRGB(255, 80, 80)
        injectNotif.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
    end
end)

-- ============================================================
-- NÚT LƯU
-- ============================================================
saveBtn.Activated:Connect(function()
    if scriptBox.Text == "" then
        statusLabel.Text = "⚠ Chưa có script để lưu"
        statusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
        task.wait(2)
        statusLabel.Text = ""
        return
    end
    SaveScript(scriptBox.Text)
    statusLabel.Text = "✅ ĐÃ LƯU SCRIPT"
    statusLabel.TextColor3 = Color3.fromRGB(100, 220, 100)
    saveBtn.Text = "✅ ĐÃ LƯU"
    task.wait(2)
    saveBtn.Text = "💾 LƯU"
    statusLabel.Text = ""
end)

clearSaveBtn.Activated:Connect(function()
    DeleteSave()
    scriptBox.Text = ""
    statusLabel.Text = "🗑 ĐÃ XÓA SCRIPT LƯU"
    statusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
    task.wait(2)
    statusLabel.Text = ""
end)

runBtn.Activated:Connect(function()
    if scriptBox.Text == "" then
        statusLabel.Text = "⚠ CHƯA NHẬP SCRIPT"
        statusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
        task.wait(2)
        statusLabel.Text = ""
        return
    end
    
    runBtn.Text = "⏳ Đang chạy..."
    runBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
    
    local ok = pcall(function()
        local fn = loadstring(scriptBox.Text) or load(scriptBox.Text)
        if fn then fn() end
    end)
    
    if ok then
        runBtn.Text = "✅ THÀNH CÔNG"
        runBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        statusLabel.Text = "✅ SCRIPT ĐÃ CHẠY"
        statusLabel.TextColor3 = Color3.fromRGB(100, 220, 100)
    else
        runBtn.Text = "❌ LỖI"
        runBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        statusLabel.Text = "❌ SCRIPT LỖI"
        statusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
    end
    task.wait(2)
    runBtn.Text = "▶ RUN SCRIPT"
    runBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    statusLabel.Text = ""
end)

resetBtn.Activated:Connect(function()
    scriptBox.Text = ""
    statusLabel.Text = "🔄 ĐÃ LÀM LẠI"
    statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    task.wait(1.5)
    statusLabel.Text = ""
end)

closeBtn.Activated:Connect(function()
    main.Visible = false
end)

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.F6 then
        main.Visible = not main.Visible
    end
end)

task.spawn(function()
    task.wait(3)
    local savedCode = LoadScript()
    if savedCode ~= "" then
        pcall(function()
            local fn = loadstring(savedCode) or load(savedCode)
            if fn then fn() end
        end)
    end
end)

print("=== BÁCH EXECUTOR ĐÃ TẢI ===")
print("1. Ấn Inject")
print("2. Nhập key: bindepzai123")
print("3. Ấn XÁC NHẬN KEY")
print("4. Nhập script và ấn LƯU + RUN")
print("5. Ấn F6 mở/đóng menu")
