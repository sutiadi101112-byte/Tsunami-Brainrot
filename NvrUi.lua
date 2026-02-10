local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/x2zu/OPEN-SOURCE-UI-ROBLOX/refs/heads/main/X2ZU%20UI%20ROBLOX%20OPEN%20SOURCE/DummyUi-leak-by-x2zu/fetching-main/Tools/Framework.luau"))()

-- Create Main Window
local Window = Library:Window({
    Title = "NVR | V0.1",
    Desc = "Complete Exploit",
    Icon = 105059922903197,
    Theme = "Dark",
    Config = {
        Keybind = Enum.KeyCode.LeftControl,
        Size = UDim2.new(0, 500, 0, 450)
    },
    CloseUIButton = {
        Enabled = true,
        Text = "NVR HUB",
        Icon = "https://files.catbox.moe/47p06p.jpg"
    }
})

-- Tab System
local MainTab = Window:Tab("Main", "rbxassetid://10734950215")
local ShopTab = Window:Tab("Shop", "rbxassetid://10734935688")
local SettingsTab = Window:Tab("Settings", "rbxassetid://10734946976")

-- ==================== MAIN TAB ====================
local MainSection = MainTab:Section("Auto Farming", "Left")

-- Auto Collect Money
local AutoCollectToggle = false
local CollectConnection

MainSection:Toggle({
    Title = "Auto Collect Money",
    Description = "Automatically collects money from Brainrot",
    Default = false,
    Callback = function(state)
        AutoCollectToggle = state
        if state then
            CollectConnection = game:GetService("RunService").Heartbeat:Connect(function()
                local args = {
                    "Collect Money",
                    "{642ea815-7da9-4c9d-97bf-62a8393bf6e4}",
                    "2"
                }
                pcall(function()
                    game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Net"):WaitForChild("RF/Plot.PlotAction"):InvokeServer(unpack(args))
                end)
            end)
        else
            if CollectConnection then
                CollectConnection:Disconnect()
                CollectConnection = nil
            end
        end
    end
})

-- Sell Brainrot
MainSection:Button({
    Title = "Sell Brainrot",
    Description = "Sell Brainrot (Common Filter)",
    Callback = function()
        local args = {
            "Sell Brainrot",
            "{642ea815-7da9-4c9d-97bf-62a8393bf6e4}",
            "1"
        }
        pcall(function()
            game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Net"):WaitForChild("RF/Plot.PlotAction"):InvokeServer(unpack(args))
        end)
    end
})

-- Place Brainrot
MainSection:Button({
    Title = "Place Brainrot",
    Description = "Place Brainrot at Position 3",
    Callback = function()
        local args = {
            "Place Brainrot",
            "{642ea815-7da9-4c9d-97bf-62a8393bf6e4}",
            "3"
        }
        pcall(function()
            game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Net"):WaitForChild("RF/Plot.PlotAction"):InvokeServer(unpack(args))
        end)
    end
})

-- ==================== SHOP TAB ====================
local UpgradeSection = ShopTab:Section("Upgrades", "Left")

-- Upgrade Carry
UpgradeSection:Button({
    Title = "Upgrade Carry Capacity",
    Description = "Increase your carrying capacity",
    Callback = function()
        pcall(function()
            game:GetService("ReplicatedStorage"):WaitForChild("RemoteFunctions"):WaitForChild("UpgradeCarry"):InvokeServer()
        end)
    end
})

-- Upgrade Base
UpgradeSection:Button({
    Title = "Upgrade Base",
    Description = "Upgrade your base level",
    Callback = function()
        pcall(function()
            game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Net"):WaitForChild("RE/Plot.UpgradeBase"):FireServer()
        end)
    end
})

-- Upgrade Speed
UpgradeSection:Button({
    Title = "Upgrade Speed",
    Description = "Increase movement speed (Level 1)",
    Callback = function()
        local args = {1}
        pcall(function()
            game:GetService("ReplicatedStorage"):WaitForChild("RemoteFunctions"):WaitForChild("UpgradeSpeed"):InvokeServer(unpack(args))
        end)
    end
})

-- Upgrade Level Brainrot
UpgradeSection:Button({
    Title = "Upgrade Brainrot Level",
    Description = "Upgrade Brainrot to next level",
    Callback = function()
        local args = {
            "Upgrade Brainrot",
            "{642ea815-7da9-4c9d-97bf-62a8393bf6e4}",
            "1"
        }
        pcall(function()
            game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Net"):WaitForChild("RF/Plot.PlotAction"):InvokeServer(unpack(args))
        end)
    end
})

-- Multi-Upgrade Option
local MultiUpgradeSection = ShopTab:Section("Auto Upgrades", "Right")

local UpgradeLevelToggle = false
local UpgradeLevelConnection

MultiUpgradeSection:Toggle({
    Title = "Auto Upgrade Brainrot",
    Description = "Continuously upgrade Brainrot level",
    Default = false,
    Callback = function(state)
        UpgradeLevelToggle = state
        if state then
            UpgradeLevelConnection = game:GetService("RunService").Heartbeat:Connect(function()
                local args = {
                    "Upgrade Brainrot",
                    "{642ea815-7da9-4c9d-97bf-62a8393bf6e4}",
                    "1"
                }
                pcall(function()
                    game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Net"):WaitForChild("RF/Plot.PlotAction"):InvokeServer(unpack(args))
                end)
            end)
        else
            if UpgradeLevelConnection then
                UpgradeLevelConnection:Disconnect()
                UpgradeLevelConnection = nil
            end
        end
    end
})

local AutoUpgradeSpeedToggle = false
local UpgradeSpeedConnection

MultiUpgradeSection:Toggle({
    Title = "Auto Upgrade Speed",
    Description = "Continuously upgrade movement speed",
    Default = false,
    Callback = function(state)
        AutoUpgradeSpeedToggle = state
        if state then
            UpgradeSpeedConnection = game:GetService("RunService").Heartbeat:Connect(function()
                local args = {1}
                pcall(function()
                    game:GetService("ReplicatedStorage"):WaitForChild("RemoteFunctions"):WaitForChild("UpgradeSpeed"):InvokeServer(unpack(args))
                end)
            end)
        else
            if UpgradeSpeedConnection then
                UpgradeSpeedConnection:Disconnect()
                UpgradeSpeedConnection = nil
            end
        end
    end
})

-- ==================== SETTINGS TAB ====================
local MovementSection = SettingsTab:Section("Movement", "Left")

-- WalkSpeed Slider
local currentWalkSpeed = 16
MovementSection:Slider({
    Title = "WalkSpeed",
    Description = "Adjust your movement speed",
    Default = 16,
    Min = 16,
    Max = 200,
    Callback = function(value)
        currentWalkSpeed = value
        pcall(function()
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
        end)
    end
})

-- Apply WalkSpeed Button
MovementSection:Button({
    Title = "Apply WalkSpeed",
    Description = "Apply the selected walk speed",
    Callback = function()
        pcall(function()
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = currentWalkSpeed
        end)
    end
})

-- Auto Apply WalkSpeed on Character Added
local AutoApplyToggle = false
MovementSection:Toggle({
    Title = "Auto Apply WalkSpeed",
    Description = "Automatically apply walk speed when character respawns",
    Default = false,
    Callback = function(state)
        AutoApplyToggle = state
        if state then
            game.Players.LocalPlayer.CharacterAdded:Connect(function(character)
                character:WaitForChild("Humanoid")
                task.wait(1)
                character.Humanoid.WalkSpeed = currentWalkSpeed
            end)
        end
    end
})

-- Config Section
local ConfigSection = SettingsTab:Section("Configuration", "Right")

-- Brainrot ID Input
local BrainrotID = "{642ea815-7da9-4c9d-97bf-62a8393bf6e4}"
ConfigSection:Input({
    Title = "Brainrot ID",
    Description = "Change Brainrot ID for different instances",
    Default = BrainrotID,
    Callback = function(value)
        BrainrotID = value
    end
})

-- Position Selector
local selectedPosition = "2"
ConfigSection:Dropdown({
    Title = "Collect Position",
    Description = "Select Brainrot position for collecting",
    Default = "2",
    Options = {"1", "2", "3", "4", "5"},
    Callback = function(value)
        selectedPosition = value
    end
})

-- Save Configuration
ConfigSection:Button({
    Title = "Save Configuration",
    Description = "Save current settings",
    Callback = function()
        local config = {
            BrainrotID = BrainrotID,
            WalkSpeed = currentWalkSpeed,
            CollectPosition = selectedPosition
        }
        writefile("NVR_Config.json", game:GetService("HttpService"):JSONEncode(config))
    end
})

-- Load Configuration
ConfigSection:Button({
    Title = "Load Configuration",
    Description = "Load saved settings",
    Callback = function()
        if isfile("NVR_Config.json") then
            local config = game:GetService("HttpService"):JSONDecode(readfile("NVR_Config.json"))
            BrainrotID = config.BrainrotID or BrainrotID
            currentWalkSpeed = config.WalkSpeed or currentWalkSpeed
            selectedPosition = config.CollectPosition or selectedPosition
        end
    end
})

-- Notifications
Library:Notification({
    Title = "NVR Hub Loaded",
    Description = "Exploit successfully injected. Use LeftControl to toggle UI.",
    Duration = 5
})

return Window
