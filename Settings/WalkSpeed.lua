local module = {}

function module.SetWalkSpeed(speed)
    local success = pcall(function()
        if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = speed
            return true
        end
        return false
    end)
    
    return success
end

function module.AutoApply(speed)
    local connection
    local function applyToCharacter(character)
        character:WaitForChild("Humanoid")
        task.wait(1)
        character.Humanoid.WalkSpeed = speed
    end
    
    -- Apply to current character
    if game.Players.LocalPlayer.Character then
        applyToCharacter(game.Players.LocalPlayer.Character)
    end
    
    -- Connect to future characters
    connection = game.Players.LocalPlayer.CharacterAdded:Connect(applyToCharacter)
    
    return connection
end

return module
