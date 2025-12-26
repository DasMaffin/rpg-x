local keysDown = {}
local function checkKey(key)
    if input.IsButtonDown(key) and not keysDown[key] then
        keysDown[key] = true
        hook.Run("keyPressed", key)
    elseif not input.IsButtonDown(key) then
        keysDown[key] = false
        hook.Run("keyReleased", key)
    end
end

hook.Add("Think", "InputManager", function(ply, key)
    checkKey(KEY_F1)
end)

hook.Add("keyPressed", "InputManager_Debug", function(key)
    local switch = {
        [KEY_F1] = function() 
            RPGX:ToggleHelpMenu()
        end
    }
    if switch[key] then
        switch[key]()
    end
end)

hook.Add("keyReleased", "InputManager_Debug", function(key)
    
end)