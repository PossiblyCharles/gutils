--[[
    includes any lua folder starting with i_ at the start

    Files are included in ascending alphanumerical order
    sv_/cl_/sh_ can be anywhere in the file name.
    This means you could place numbers at the start of your file names to ensure run order.
]]

local function includeLuaDir(dir)
    local files, directories = file.Find(dir.."*", "LUA")

    local i = 1
    while #files >= i do
        local fil = files[i]
        if string.find(fil, "sh_") then
            local full = dir..fil
            print(full)
            include(full)
            if SERVER then
                AddCSLuaFile(full)
            end
            table.remove(files, i)
        else
            i = i + 1
        end
    end

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
        end
    end

    for i=1, #directories do
        local fil = directories[i]
        includeLuaDir(dir..fil.."/")
    end
end

local _, directories = file.Find("*", "LUA")
for i=1, #directories do
    local dir = directories[i]
    if string.StartWith(dir, "i_") then
        print(dir.." loading.")
        includeLuaDir(dir.."/")
        print(dir.." loaded.")
    end
end

