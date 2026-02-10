local module = {}

function module.Place(brainrotID, position)
    local args = {
        "Place Brainrot",
        brainrotID,
        tostring(position)
    }
    
    local success, result = pcall(function()
        return game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Net"):WaitForChild("RF/Plot.PlotAction"):InvokeServer(unpack(args))
    end)
    
    return success, result
end

return module
