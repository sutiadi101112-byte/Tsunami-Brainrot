local module = {}

function module.UpgradeBrainrot(brainrotID, level)
    local args = {
        "Upgrade Brainrot",
        brainrotID,
        tostring(level or 1)
    }
    
    local success, result = pcall(function()
        return game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Net"):WaitForChild("RF/Plot.PlotAction"):InvokeServer(unpack(args))
    end)
    
    return success, result
end

return module
