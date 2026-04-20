repeat wait() until game:IsLoaded() and game.Players.LocalPlayer

local API_URL = "https://bot-key-api.onrender.com/api/verify"
local SCRIPT_URL = "https://raw.githubusercontent.com/megumi668/AMETHYSTHUB/refs/heads/main/AMETHYSTHUB.lua"

local hwid = tostring(game:GetService("RbxAnalyticsService"):GetClientId())
if not hwid or hwid == "" then
    hwid = tostring(game.Players.LocalPlayer.UserId)
end

local ok, res = pcall(function()
    return (syn and syn.request or http_request or request)({
        Url = API_URL,
        Method = "POST",
        Headers = { ["Content-Type"] = "application/json" },
        Body = game:GetService("HttpService"):JSONEncode({
            key = getgenv().Key,
            hwid = hwid
        })
    })
end)

if not ok then error("❌ Không thể kết nối server!") return end

local data = game:GetService("HttpService"):JSONDecode(res.Body)

if data.success then
    print("✅ Key hợp lệ! Đang load...")
    loadstring(game:HttpGet(SCRIPT_URL))()
else
    local msg = data.message or ""
    if msg:find("does not exist") then error("❌ Key không tồn tại!")
    elseif msg:find("expired") then error("❌ Key đã hết hạn!")
    elseif msg:find("not redeemed") then error("❌ Chưa redeem! Vào Discord dùng /redeem")
    elseif msg:find("limit reached") then error("❌ Máy khác đã dùng key! Dùng /resethwid")
    elseif msg:find("blacklisted") then error("❌ Key bị khóa!")
    else error("❌ " .. msg) end
end
