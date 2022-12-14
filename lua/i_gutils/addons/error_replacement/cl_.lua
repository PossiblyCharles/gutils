local waitingForModel = ""
local waitingForAccept = false
local modelMeshs = {}
local mat = Material("models/debug/debugwhite")

local count = 0 -- TODO:
local requestQueue = {}

local entsMissingModel = {}

net.Receive("error_replacement_accepted", function(len)
    waitingForAccept = false
    -- Do the next. -- TODO:
end)

net.Receive("error_replacement", function(len)
    local vertTable = util.JSONToTable(util.Decompress(net.ReadData(len)))
    local modelMesh = Mesh()
    modelMesh:BuildFromTriangles(vertTable)
    modelMeshs[waitingForModel] = modelMesh
end)

hook.Add("OnEntityCreated", "error_replacement", function(ent)
    timer.Simple(0.7,function()
        -- Problem. The model still returns the intended one...
        -- 
        if IsValid(ent) and util.GetModelMeshes(ent:GetModel()) then
            table.insert(entsMissingModel, {ent, modelMeshs[ent:GetNWString("indendedModel")]})
        end
    end)
end)

-- Looping all ents is gonna eat frames... :)
-- Need to make a table of all ents needing mesh's drawn.
hook.Add("PostDrawOpaqueRenderables", "error_replacement", function(depth, skybox, skybox3d)
    if depth and !skybox and !skybox3d then
        for k, tbl in ipairs(entsMissingModel) do
            if !IsValid(tbl[1]) then 
                table.remove(entsMissingModel, k)
                continue
            end
            if tbl[1]:GetNoDraw() then continue end
            render.SetMaterial(tbl[1]:GetMaterial() or mat)
            cam.PushModelMatrix(tbl[1]:GetWorldTransformMatrix())
                tbl[2]:Draw()
		    cam.PopModelMatrix()
        end
    end
end)