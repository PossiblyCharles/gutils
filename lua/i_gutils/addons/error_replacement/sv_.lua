local modelMeshs = {
    /*
    ["model/dir.mdl"] = vertTable,
    */
}

local ignoredModels = error_replacement.ignoredModels

hook.Add("OnEntityCreated", "error_replacement", function(ent)
	timer.Simple(0, function()
        if !IsValid(ent) then return end
        local model = ent:GetModel()
        if model ~= nil and string.sub(model, -4) == ".mdl" and modelMeshs[model] == nil and ignoredModels[model] ~= true then
            local phys = ent:GetPhysicsObject()
            if IsValid(phys) then
                local tbl = phys:GetMesh()
                for k,v in ipairs(tbl) do
                    v.normal = vector_up
                end
                local dataString = util.Compress(util.TableToJSON({tbl, model})) -- TODO: GetMesh can be nil :/
                modelMeshs[model] = {dataString, #dataString}
                print("Model mesh compressed: "..model)
            end
        end
    end)
end)

util.AddNetworkString("error_replacement")
util.AddNetworkString("error_replacement_accepted")
local netMessageInterval = error_replacement.netMessageInterval

local playerCooldowns = {} -- To prevent someone spamming the table clogging it up.
local count = 0
local requests = {}
net.Receive("error_replacement", function(len, ply)
    if (playerCooldowns[ply:SteamID()] or 0) > CurTime() then return end
    playerCooldowns[ply:SteamID()] = CurTime() + netMessageInterval

    local requestedModel = net.ReadString()
    if modelMeshs[requestedModel] then
        print(ply:SteamID().." requested "..requestedModel)
        table.insert(requests, {ply, requestedModel})
        count = count + 1
        net.Start("error_replacement_accepted") -- Only sent on success to help reduce resource cost of net spammers.
        net.Send(ply) -- Client needs to try again after a while if they don't get this message.
    end
end)

local lastTime = 0
hook.Add("Think", "error_replacement", function() -- Might change this to send 2 at a time.
    if lastTime > CurTime() or count == 0 then return end
    lastTime = CurTime() + netMessageInterval

    local request = requests[1]
    local model = modelMeshs[request[2]]
    table.remove(requests, 1)
    count = count - 1
    net.Start("error_replacement")
        net.WriteData(model[1], model[2])
    net.Send(request[1])
end)