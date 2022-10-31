--[[
    includes any lua folder starting with i_ at the start

    Files are included in ascending alphanumerical order
    sv_/cl_/bo_ can be anywhere in the file name.
    This means you could place numbers at the start of your file names to ensure run order.
]]

--[[
    TODO: do some sorting to ensure sh files run before sv and cl
    For now bo_ is used as it has the desired effect without any sorting.
]]
local function includeFiles(dir)
    local files, directories = file.Find(dir.."*", "LUA")

    for i=1, #files do
        local fil = files[i]
        local full = dir..fil
        if string.find(fil, "sv_") then
            if SERVER then
                print(full)
                include(full)
            end
        elseif string.find(fil, "cl_") then
            if SERVER then
                AddCSLuaFile(full)
            else
                print(full)
                include(full)
            end
        elseif string.find(fil, "bo_") then -- Using bo short for 'both' to ensure shared files run before client files due to ascending order
            print(full)
            include(full)
            if SERVER then
                AddCSLuaFile(full)
            end
        end
    end

    for i=1, #directories do
        local fil = directories[i]
        runFiles(dir..fil.."/")
    end
end

function includeLuaDir(dir)
    print(dir.." loading.")
    includeFiles(dir.."/")
    print(dir.." loaded.")
end

local _, directories = file.Find("*", "LUA")
for i=1, #directories do
    local dir = directories[1]
    if string.StartWith(dir, "i_") then
        includeLuaDir(dir)
    end
end

