local waitingForAccept = false
local modelMeshs = {}
local mat = Material("models/debug/debugwhite")

local netMessageInterval = error_replacement.netMessageInterval

local count = 0 -- TODO:
local requestQueue = {}
local requestedModels = {}

local entsMissingModel = {}

net.Receive("error_replacement_accepted", function(len)
    waitingForAccept = false
    if timer.Exists("error_replacement") then
        timer.Remove("error_replacement")
    end
    print("Model request accepted")
end)

net.Receive("error_replacement", function(len)
    local tbl = util.JSONToTable(util.Decompress(net.ReadData(len)))
    local modelMesh = Mesh(mat)
    modelMesh:BuildFromTriangles(tbl[1])
    modelMeshs[tbl[2]] = modelMesh
    print("Model received: "..tbl[2])
end)

hook.Add("OnEntityCreated", "error_replacement", function(ent)
    timer.Simple(0,function()
        if IsValid(ent) and ent:GetModel() and !util.GetModelMeshes(ent:GetModel()) then
            local model = ent:GetModel()
            if string.sub(model, -4) == ".mdl"  then
                if !requestedModels[model] then
                    requestedModels[model] = true
                    table.insert(requestQueue, model)
                    count = count + 1
                    print("Requesting "..model)
                end
                table.insert(entsMissingModel, {ent, model})
            end
        end
    end)
end)

local lastTime = 0
hook.Add("Think", "error_replacement", function() -- Might change this to send 2 at a time.
    if lastTime > CurTime() or count == 0 or waitingForAccept then return end
    lastTime = CurTime() + netMessageInterval

    local request = requestQueue[1]
    table.remove(requestQueue, 1)
    count = count - 1
    net.Start("error_replacement")
        net.WriteString(request)
    net.SendToServer()
    waitingForAccept = true
    timer.Create("error_replacement", 2, 1, function()
        print("Model request declined")
        waitingForAccept = false
        requestedModels[request] = nil
    end)
end)

-- Looping all ents is gonna eat frames... :)
-- Need to make a table of all ents needing mesh's drawn.
hook.Add("PostDrawOpaqueRenderables", "error_replacement", function(depth, skybox, skybox3d)
    for k, tbl in ipairs(entsMissingModel) do
        if !IsValid(tbl[1]) then 
            table.remove(entsMissingModel, k)
            continue
        end
        if tbl[1]:GetNoDraw() then continue end
        if isstring(tbl[2]) then
            if modelMeshs[tbl[2]] then
                tbl[2] = modelMeshs[tbl[2]]
            end
            continue
        end
        render.ResetModelLighting(1, 1, 1, 1)
        render.SetMaterial(mat)
        surface.SetDrawColor(255, 255, 255, 255)
        cam.PushModelMatrix(tbl[1]:GetWorldTransformMatrix())
            tbl[2]:Draw()
        cam.PopModelMatrix() -- Lighting is being fucky...
    end
end)