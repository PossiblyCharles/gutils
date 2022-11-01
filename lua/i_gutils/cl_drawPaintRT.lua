local renderTargets = {}
local renderTargetCount = 0
local renderTargetsInUse = {}

local function addRenderTarget()
    renderTargetCount = renderTargetCount + 1
    local uniqueName = "drawPaintRT"..renderTargetCount
    local rt = GetRenderTarget(uniqueName, 3440, 3440)
    
    local mat = CreateMaterial(uniqueName, "UnlitGeneric",{
        ['$basetexture'] = rt:GetName(),
        ["$translucent"] = 0,
        ["$vertexalpha"] = 1,
        ["$vertexcolor"] = 1,
        ['$nolod'] = 1
    })

    renderTargets[renderTargetCount] = {
        rt = rt,
        mat = mat,
        maxInactive = 60,
        inactiveStamp = 0,
        inUse = true
    }

    return renderTargets[renderTargetCount]
end

-- Returns the first not in use renderTargets value or nil if none.
-- Note: Make sure to set inUse back to false when no longer in use.
local function getUnusedRT()
    for i=1, #renderTargets do
        if !renderTargets[i].inUse then
            renderTargets[i].inUse = true
            return renderTargets[i]
        end
    end
    return addRenderTarget()
end

function gutils.drawMaterial(drawFunc, ...)
    local rt = getUnusedRT()
    
    local args = {...}
    if args[1] ~= -1 then -- Don't do this unless you
        rt.maxInactive = args[1] or 60
        rt.inactiveStamp = SysTime() + rt.maxInactive
        table.insert(renderTargetsInUse, renderTargets[renderTargetCount])
    end

    render.PushRenderTarget( rt.rt )
	cam.Start2D()
	    render.Clear( 0, 0, 0, 0 )
        drawFunc()
    cam.End2D()
    render.PopRenderTarget()

    return function()
        rt.inactiveStamp = SysTime() + rt.maxInactive
        surface.SetDrawColor(color_white)
        surface.SetMaterial(rt.mat)
        surface.DrawTexturedRect(0, 0, 3440, 3440)
    end
end

hook.Add("Think","gutils_drawPaintRT",function()
    local i = 1
    while true do
        if #renderTargetsInUse <= i then
            return
        end
        if renderTargetsInUse[i].inactiveStamp < SysTime() then
            renderTargetsInUse[i].inUse = false
            table.remove(renderTargetsInUse, i)
            i = i - 1
        end
        i = i + 1
    end
end)