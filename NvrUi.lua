-- NVR Dynamic UI Loader
-- Automatically loads all functions from Main/Settings/Shop folders

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/x2zu/OPEN-SOURCE-UI-ROBLOX/refs/heads/main/X2ZU%20UI%20ROBLOX%20OPEN%20SOURCE/DummyUi-leak-by-x2zu/fetching-main/Tools/Framework.luau"))()

-- Configuration
local REPO_BASE = "https://raw.githubusercontent.com/sutiadi101112-byte/Tsunami-Brainrot/main/"
local MODULE_PATHS = {
    Main = REPO_BASE .. "Main/",
    Settings = REPO_BASE .. "Settings/", 
    Shop = REPO_BASE .. "Shop/"
}

-- Global module storage
local NVR = {
    Modules = {},
    Config = {
        BrainrotID = "{642ea815-7da9-4c9d-97bf-62a8393bf6e4}",
        WalkSpeed = 16,
        CollectPosition = "2",
        AutoCollect = false,
        AutoUpgrade = false
    },
    Connections = {}
}

-- Function to load module from URL
local function loadModule(url)
    local success, content = pcall(function()
        return game:HttpGet(url, true)
    end)
    
    if success and content then
        local func, err = loadstring(content)
        if func then
            local moduleEnv = {}
            setfenv(func, setmetatable(moduleEnv, {__index = _G}))
            local success, result = pcall(func)
            if success then
                return moduleEnv
            end
        end
    end
    return nil
end

-- Scan and load all modules
local function loadAllModules()
    local moduleFiles = {
        Main = {"AutoCollectMoney.lua", "SellBrainrot.lua", "PlaceBrainrot.lua"},
        Settings = {"WalkSpeed.lua"},
        Shop = {"UpgradeCarry.lua", "UpgradeSpeed.lua", "UpgradeLevel.lua"}
    }
    
    for category, files in pairs(moduleFiles) do
        NVR.Modules[category] = {}
        for _, file in ipairs(files) do
            local url = MODULE_PATHS[category] .. file
            local module = loadModule(url)
            if module then
                local moduleName = file:gsub("%.lua$", "")
                NVR.Modules[category][moduleName] = module
                print("[NVR] Loaded: " .. category .. "/" .. moduleName)
            else
                warn("[NVR] Failed to load: " .. category .. "/" .. file)
            end
        end
    end
end

-- Execute module loading
loadAllModules()

-- Create Main Window
local Window = Library:Window({
    Title = "NVR | Dynamic v0.1",
    Desc = "Auto-Loaded Modules: " .. tostring(
        (NVR.Modules.Main and #NVR.Modules.Main or 0) +
        (NVR.Modules.Settings and #NVR.Modules.Settings or 0) +
        (NVR.Modules.Shop and #NVR.Modules.Shop or 0)
    ) .. " modules",
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

-- Dynamic Main Functions
if NVR.Modules.Main then
    -- Auto Collect Money
    if NVR.Modules.Main.AutoCollectMoney and NVR.Modules.Main.AutoCollectMoney.StartAutoCollect then
        local autoCollectToggle = false
        local stopCollectFunction = nil
        
        MainSection:Toggle({
            Title = "Auto Collect Money",
            Description = "Automatically collects money from Brainrot",
            Default = false,
            Callback = function(state)
                autoCollectToggle = state
                if state then
                    stopCollectFunction = NVR.Modules.Main.AutoCollectMoney.StartAutoCollect(
                        NVR.Config.BrainrotID, 
                        NVR.Config.CollectPosition,
                        0.5
                    )
                    NVR.Config.AutoCollect = true
                else
                    if stopCollectFunction and type(stopCollectFunction) == "function" then
                        stopCollectFunction()
                        stopCollectFunction = nil
                    end
                    NVR.Config.AutoCollect = false
                end
            end
        })
    else
        -- Fallback if module not loaded
        MainSection:Label({
            Title = "⚠ Auto Collect Money",
            Description = "Module not loaded properly"
        })
    end
    
    -- Sell Brainrot Button
    if NVR.Modules.Main.SellBrainrot and NVR.Modules.Main.SellBrainrot.Sell then
        MainSection:Button({
            Title = "Sell Brainrot",
            Description = "Sell Brainrot (Common Filter)",
            Callback = function()
                local success, result = NVR.Modules.Main.SellBrainrot.Sell(NVR.Config.BrainrotID, "1")
                if success then
                    Library:Notification({
                        Title = "Brainrot Sold",
                        Description = "Successfully sold Brainrot",
                        Duration = 3
                    })
                end
            end
        })
    end
    
    -- Place Brainrot Button
    if NVR.Modules.Main.PlaceBrainrot and NVR.Modules.Main.PlaceBrainrot.Place then
        MainSection:Button({
            Title = "Place Brainrot",
            Description = "Place Brainrot at selected position",
            Callback = function()
                local success, result = NVR.Modules.Main.PlaceBrainrot.Place(NVR.Config.BrainrotID, "3")
                if success then
                    Library:Notification({
                        Title = "Brainrot Placed",
                        Description = "Brainrot placed at position 3",
                        Duration = 3
                    })
                end
            end
        })
    end
    
    -- Quick Actions Section
    local QuickActions = MainTab:Section("Quick Actions", "Right")
    
    QuickActions:Button({
        Title = "Collect Once",
        Description = "Collect money once",
        Callback = function()
            local args = {
                "Collect Money",
                NVR.Config.BrainrotID,
                NVR.Config.CollectPosition
            }
            pcall(function()
                game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Net"):WaitForChild("RF/Plot.PlotAction"):InvokeServer(unpack(args))
            end)
        end
    })
    
    QuickActions:Button({
        Title = "Sell All Common",
        Description = "Sell all common Brainrot",
        Callback = function()
            for i = 1, 5 do
                local args = {
                    "Sell Brainrot",
                    NVR.Config.BrainrotID,
                    tostring(i)
                }
                pcall(function()
                    game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Net"):WaitForChild("RF/Plot.PlotAction"):InvokeServer(unpack(args))
                end)
                task.wait(0.2)
            end
        end
    })
end

-- ==================== SHOP TAB ====================
local UpgradeSection = ShopTab:Section("Upgrades", "Left")

-- Dynamic Shop Functions
if NVR.Modules.Shop then
    -- Upgrade Carry
    if NVR.Modules.Shop.UpgradeCarry and NVR.Modules.Shop.UpgradeCarry.Upgrade then
        UpgradeSection:Button({
            Title = "Upgrade Carry Capacity",
            Description = "Increase your carrying capacity",
            Callback = function()
                local success, result = NVR.Modules.Shop.UpgradeCarry.Upgrade()
                if success then
                    Library:Notification({
                        Title = "Carry Upgraded",
                        Description = "Carry capacity increased",
                        Duration = 3
                    })
                end
            end
        })
    end
    
    -- Upgrade Speed with level selector
    if NVR.Modules.Shop.UpgradeSpeed and NVR.Modules.Shop.UpgradeSpeed.Upgrade then
        local speedLevel = 1
        UpgradeSection:Slider({
            Title = "Upgrade Speed Level",
            Description = "Select speed level to upgrade",
            Default = 1,
            Min = 1,
            Max = 10,
            Callback = function(value)
                speedLevel = value
            end
        })
        
        UpgradeSection:Button({
            Title = "Upgrade Speed",
            Description = "Increase movement speed",
            Callback = function()
                local success, result = NVR.Modules.Shop.UpgradeSpeed.Upgrade(speedLevel)
                if success then
                    Library:Notification({
                        Title = "Speed Upgraded",
                        Description = "Movement speed increased to level " .. speedLevel,
                        Duration = 3
                    })
                end
            end
        })
    end
    
    -- Upgrade Brainrot Level
    if NVR.Modules.Shop.UpgradeLevel and NVR.Modules.Shop.UpgradeLevel.UpgradeBrainrot then
        local brainrotLevel = 1
        UpgradeSection:Slider({
            Title = "Brainrot Upgrade Level",
            Description = "Select Brainrot level to upgrade",
            Default = 1,
            Min = 1,
            Max = 10,
            Callback = function(value)
                brainrotLevel = value
            end
        })
        
        UpgradeSection:Button({
            Title = "Upgrade Brainrot Level",
            Description = "Upgrade Brainrot to selected level",
            Callback = function()
                local success, result = NVR.Modules.Shop.UpgradeLevel.UpgradeBrainrot(NVR.Config.BrainrotID, brainrotLevel)
                if success then
                    Library:Notification({
                        Title = "Brainrot Upgraded",
                        Description = "Brainrot upgraded to level " .. brainrotLevel,
                        Duration = 3
                    })
                end
            end
        })
    end
    
    -- Auto Upgrade Section
    local AutoUpgradeSection = ShopTab:Section("Auto Upgrades", "Right")
    
    -- Auto Upgrade Brainrot
    if NVR.Modules.Shop.UpgradeLevel then
        local autoBrainrotToggle = false
        local brainrotUpgradeConnection = nil
        
        AutoUpgradeSection:Toggle({
            Title = "Auto Upgrade Brainrot",
            Description = "Continuously upgrade Brainrot level",
            Default = false,
            Callback = function(state)
                autoBrainrotToggle = state
                if state then
                    brainrotUpgradeConnection = game:GetService("RunService").Heartbeat:Connect(function()
                        NVR.Modules.Shop.UpgradeLevel.UpgradeBrainrot(NVR.Config.BrainrotID, 1)
                    end)
                    NVR.Config.AutoUpgrade = true
                else
                    if brainrotUpgradeConnection then
                        brainrotUpgradeConnection:Disconnect()
                        brainrotUpgradeConnection = nil
                    end
                    NVR.Config.AutoUpgrade = false
                end
            end
        })
    end
    
    -- Bulk Upgrade Buttons
    local BulkSection = ShopTab:Section("Bulk Upgrades", "Left")
    
    BulkSection:Button({
        Title = "Upgrade All x5",
        Description = "Perform 5 upgrades of each type",
        Callback = function()
            for i = 1, 5 do
                -- Upgrade Carry
                if NVR.Modules.Shop.UpgradeCarry then
                    NVR.Modules.Shop.UpgradeCarry.Upgrade()
                end
                
                -- Upgrade Speed
                if NVR.Modules.Shop.UpgradeSpeed then
                    NVR.Modules.Shop.UpgradeSpeed.Upgrade(1)
                end
                
                -- Upgrade Brainrot
                if NVR.Modules.Shop.UpgradeLevel then
                    NVR.Modules.Shop.UpgradeLevel.UpgradeBrainrot(NVR.Config.BrainrotID, 1)
                end
                
                task.wait(0.5)
            end
        end
    })
end

-- Upgrade Base (hardcoded fallback)
UpgradeSection:Button({
    Title = "Upgrade Base",
    Description = "Upgrade your base level",
    Callback = function()
        pcall(function()
            game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Net"):WaitForChild("RE/Plot.UpgradeBase"):FireServer()
        end)
    end
})

-- ==================== SETTINGS TAB ====================
local MovementSection = SettingsTab:Section("Movement", "Left")

-- Dynamic Settings Functions
if NVR.Modules.Settings then
    -- WalkSpeed Control
    if NVR.Modules.Settings.WalkSpeed and NVR.Modules.Settings.WalkSpeed.SetWalkSpeed then
        MovementSection:Slider({
            Title = "WalkSpeed",
            Description = "Adjust your movement speed",
            Default = NVR.Config.WalkSpeed,
            Min = 16,
            Max = 200,
            Callback = function(value)
                NVR.Config.WalkSpeed = value
                NVR.Modules.Settings.WalkSpeed.SetWalkSpeed(value)
            end
        })
        
        -- Auto Apply Toggle
        local autoApplyConnection = nil
        MovementSection:Toggle({
            Title = "Auto Apply WalkSpeed",
            Description = "Automatically apply walk speed on respawn",
            Default = false,
            Callback = function(state)
                if state then
                    autoApplyConnection = NVR.Modules.Settings.WalkSpeed.AutoApply(NVR.Config.WalkSpeed)
                else
                    if autoApplyConnection then
                        autoApplyConnection:Disconnect()
                        autoApplyConnection = nil
                    end
                end
            end
        })
    else
        -- Fallback walk speed
        MovementSection:Slider({
            Title = "WalkSpeed (Fallback)",
            Description = "Adjust movement speed",
            Default = 16,
            Min = 16,
            Max = 200,
            Callback = function(value)
                pcall(function()
                    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
                end)
            end
        })
    end
end

-- Apply WalkSpeed Button (universal)
MovementSection:Button({
    Title = "Apply WalkSpeed Now",
    Description = "Immediately apply current walk speed",
    Callback = function()
        pcall(function()
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = NVR.Config.WalkSpeed
        end)
    end
})

-- Config Section
local ConfigSection = SettingsTab:Section("Configuration", "Right")

-- Brainrot ID Input
ConfigSection:Input({
    Title = "Brainrot ID",
    Description = "Change Brainrot ID for different instances",
    Default = NVR.Config.BrainrotID,
    Callback = function(value)
        NVR.Config.BrainrotID = value
    end
})

-- Position Selector
ConfigSection:Dropdown({
    Title = "Collect Position",
    Description = "Select Brainrot position for collecting",
    Default = NVR.Config.CollectPosition,
    Options = {"1", "2", "3", "4", "5"},
    Callback = function(value)
        NVR.Config.CollectPosition = value
    end
})

-- Collection Interval
local collectInterval = 0.5
ConfigSection:Slider({
    Title = "Collection Interval",
    Description = "Time between auto collections (seconds)",
    Default = 0.5,
    Min = 0.1,
    Max = 2.0,
    Precision = 0.1,
    Callback = function(value)
        collectInterval = value
    end
})

-- Save/Load Configuration
local ConfigActions = SettingsTab:Section("Data Management", "Left")

ConfigActions:Button({
    Title = "💾 Save Configuration",
    Description = "Save all current settings to file",
    Callback = function()
        local config = {
            BrainrotID = NVR.Config.BrainrotID,
            WalkSpeed = NVR.Config.WalkSpeed,
            CollectPosition = NVR.Config.CollectPosition,
            CollectInterval = collectInterval
        }
        if writefile then
            writefile("NVR_Config.json", game:GetService("HttpService"):JSONEncode(config))
            Library:Notification({
                Title = "Configuration Saved",
                Description = "Settings saved to NVR_Config.json",
                Duration = 3
            })
        end
    end
})

ConfigActions:Button({
    Title = "📂 Load Configuration",
    Description = "Load settings from saved file",
    Callback = function()
        if readfile and isfile("NVR_Config.json") then
            local config = game:GetService("HttpService"):JSONDecode(readfile("NVR_Config.json"))
            NVR.Config.BrainrotID = config.BrainrotID or NVR.Config.BrainrotID
            NVR.Config.WalkSpeed = config.WalkSpeed or NVR.Config.WalkSpeed
            NVR.Config.CollectPosition = config.CollectPosition or NVR.Config.CollectPosition
            collectInterval = config.CollectInterval or collectInterval
            
            Library:Notification({
                Title = "Configuration Loaded",
                Description = "Settings loaded from file",
                Duration = 3
            })
        end
    end
})

-- Module Status Section
local StatusSection = SettingsTab:Section("Module Status", "Right")

-- Display loaded modules
local loadedCount = 0
for category, modules in pairs(NVR.Modules) do
    for name, _ in pairs(modules) do
        loadedCount = loadedCount + 1
        StatusSection:Label({
            Title = "✓ " .. category .. "/" .. name,
            Description = "Successfully loaded"
        })
    end
end

StatusSection:Label({
    Title = "📊 Loaded Modules",
    Description = "Total: " .. loadedCount .. " modules"
})

-- Reload Modules Button
StatusSection:Button({
    Title = "🔄 Reload All Modules",
    Description = "Reload modules from GitHub",
    Callback = function()
        Library:Notification({
            Title = "Reloading Modules",
            Description = "Please wait...",
            Duration = 2
        })
        
        -- Reinitialize NVR modules
        loadAllModules()
        
        Library:Notification({
            Title = "Modules Reloaded",
            Description = loadedCount .. " modules loaded successfully",
            Duration = 3
        })
    end
})

-- Debug Section
local DebugSection = SettingsTab:Section("Debug", "Left")

DebugSection:Button({
    Title = "Test All Remotes",
    Description = "Test all remote connections",
    Callback = function()
        local testResults = {}
        
        -- Test Collect Money
        local args1 = {"Collect Money", NVR.Config.BrainrotID, NVR.Config.CollectPosition}
        local success1 = pcall(function()
            game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Net"):WaitForChild("RF/Plot.PlotAction"):InvokeServer(unpack(args1))
        end)
        table.insert(testResults, "Collect Money: " .. (success1 and "✓" or "✗"))
        
        -- Test Sell Brainrot
        local args2 = {"Sell Brainrot", NVR.Config.BrainrotID, "1"}
        local success2 = pcall(function()
            game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Net"):WaitForChild("RF/Plot.PlotAction"):InvokeServer(unpack(args2))
        end)
        table.insert(testResults, "Sell Brainrot: " .. (success2 and "✓" or "✗"))
        
        -- Display results
        Library:Notification({
            Title = "Remote Test Results",
            Description = table.concat(testResults, "\n"),
            Duration = 5
        })
    end
})

-- Notifications
Library:Notification({
    Title = "NVR Dynamic UI Loaded",
    Description = loadedCount .. " modules integrated | Press LeftControl",
    Duration = 5
})

-- Make NVR globally accessible
getgenv().NVR = NVR

return Window
