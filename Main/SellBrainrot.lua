local module = {}

function module.Sell(brainrotID, filter)
    local args = {
        "Sell Brainrot",
        brainrotID,
        filter or "1"
    }
    
    local success, result = pcall(function()
        return game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Net"):WaitForChild("RF/Plot.PlotAction"):InvokeServer(unpack(args))
    end)
    
    return success, result
end

return module
