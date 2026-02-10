local module = {}

function module.Upgrade()
    local success, result = pcall(function()
        return game:GetService("ReplicatedStorage"):WaitForChild("RemoteFunctions"):WaitForChild("UpgradeCarry"):InvokeServer()
    end)
    
    return success, result
end

return module
