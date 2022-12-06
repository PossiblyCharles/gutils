-- drawFunc(hoverFunc, pressFunc, )
-- buttonTable is used to set isHovered
--[[ Buttons:
    local button = {min = Vector(), max = Vector(), isHovered = false, isPressed = false, stateChanged}
    local button2 = .....
    local buttonTable = {button, button2}
]] 
-- TODO: Optimise the buttonTable.isHovered = false calls. Need a seperate table of only the hovered button ids to check against maybe.
function gutils.button3d2d(pos, ang, scale, drawFunc, buttonTable, ...)
    local args = {...}
    -- args[1] = -- cursor draw func, nil by default.

    local lp = LocalPlayer()
    local useDown = lp:KeyDown(IN_USE)
    local usePressed = lp:KeyPressed(IN_USE)
    local wpos = util.IntersectRayWithPlane(lp:EyePos(), lp:EyeAngles():Forward(), pos, ang:Up())
    local lpos
    if wpos then
        lpos = WorldToLocal(wpos, Angle(0,0,0), pos, ang)
        lpos.y = lpos.y * -1
        lpos.z = 0
        local button
        for i=1, #buttonTable do
            button = buttonTable[i]
            if lpos:WithinAABox(button.min*scale, button.max*scale) then
                local change = false
                -- This whole line of if statements feels shitty.
                -- TODO: Think of a way to do this better.
                if button.isHovered ~= true then
                    button.isHovered = true
                    change = true
                end

                if useDown then
                    if button.isPressed ~= true and usePressed then
                        button.isPressed = true
                        change = true
                    end
                else
                    if button.isPressed ~= false then
                        button.isPressed = false
                        change = true
                    end
                end
    
                if change then
                    button.stateChanged()
                end
            else
                if button.isHovered ~= false then
                    button.isHovered = false
                    button.isPressed = false
                    button.stateChanged()
                end
            end
        end
    else
        for i=1, #buttonTable do
            button = buttonTable[i]
            if button.isHovered ~= false then
                button.isHovered = false
                button.stateChanged()
            end
        end
    end

    cam.Start3D2D(pos, ang, scale)
        -- Where are we aiming?
        drawFunc()
        if args[1] and lpos then
            args[1](lpos)
        end
    cam.End3D2D()
end
