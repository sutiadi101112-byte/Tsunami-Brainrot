herelocal module = {}

function module.StartAutoCollect(brainrotID, position)
    local running = true
    local interval = 0.5 -- seconds between collections
    
    task.spawn(function()
        while running do
            local args = {
                "Collect Money",
                brainrotID,
                tostring(position)
            }
            pcall(function()
                game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Net"):WaitForChild("RF/Plot.PlotAction"):InvokeServer(unpack(args))
            end)
            task.wait(interval)
        end
    end)
    
    return function() 
        running = false 
    end
end

return module
