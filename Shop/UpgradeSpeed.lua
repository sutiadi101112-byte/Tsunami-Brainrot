local module = {}

function module.Upgrade(level)
    local args = {level or 1}
    
    local success, result = pcall(function()
        return game:GetService("ReplicatedStorage"):WaitForChild("RemoteFunctions"):WaitForChild("UpgradeSpeed"):InvokeServer(unpack(args))
    end)
    
    return success, result
end

return module
