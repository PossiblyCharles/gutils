-- Single char only
local prefixes = {
    ["/"] = true,
    ["!"] = true,
}

local commands = {
    --[[
    ["example"] = {
        {
            0 = 1, -- index 0 being the cooldown for the command
            [steamid] = nextAllowedTime,
        },
        function(ply, ...)
            ply:SetHealth(ply:Health()+1)
            return ":O"
        end,
    },
    ]]
}

hook.Add(SERVER and "PlayerSay" or "OnPlayerChat", "gutils_commands", function( ply, text )
    if prefixes[string.sub(text,1,1)] then
        local split = string.Explode(" ", string.lower(string.sub(text,2)))
        local cmd = commands[split[1]]
        if cmd then
            if cmd[1] ~= nil then
                local time = (cmd[1][ply:SteamID()] and cmd[1][ply:SteamID()] or 0)
                if time > CurTime() then
                    local remaining = math.ceil(time-CurTime())
                    gutils.chatAddText(ply, Color(100,200,255), "That command's still on cooldown. Wait another ", Color(255,255,255), tostring(remaining), Color(100,200,255), remaining > 1 and " seconds." or " second.")
                    return ""
                else
                    cmd[1][ply:SteamID()] = CurTime()+cmd[1][0]
                end
            end
            return cmd[2](ply, unpack(split, 2))
        end
    end
end)

--[[
Params
[1] is a table of lower case strings that trigger the function
[2] must be a func with ...
[3] true to disable concommand creation
[4] cooldown in seconds

Usage: 
    (Clientside menu opening)
    gutils.addCommand({"menu","m","openmenu"}, function(ply, ...)
        openSomeMenu()
    end)

    (Serverside kick)
    gutils.addCommandaddCommand({"kick", "gtfo"}, function(ply, ...)
        if IsValid(ply) and ply:HasPerm("kick") then
            local args = {...}
            local vic = playerByName(args[1])
            if vic then
                PrintMessage(HUD_PRINTTALK, vic:Name() .. " has been kicked.")
                vic:Kick((args[2] or "") .. "\nKicked by " .. ply:Name())
            else
                ply:PrintMessage(HUD_PRINTTALK, "Invalid player name.")
            end
        end
    end)

adds the commands for the realm(SERVER/CLIENT) called on
console command created by default.
]]
function gutils.addCommand(strTable, func, noConcommand, cooldown)
    local cooldown = cooldown and {[0] = cooldown} or nil

    print("gutils command added: ")
    PrintTable(strTable)
    local cmd = {cooldown, func}

    if noConcommand then
        for i=1, #strTable do
            commands[strTable[i]] = cmd
        end
    else
        local concommandFunc = function(ply, cmda, args)
            if cmd[1] ~= nil then
                if (cmd[1][ply:SteamID()] and cmd[1][ply:SteamID()] or 0) > CurTime() then
                    return
                else
                    cmd[1][ply:SteamID()] = CurTime()+cmd[1][0]
                end
            end
            cmd[2](ply, unpack(args))
        end
        for i=1, #strTable do
            commands[strTable[i]] = cmd
            concommand.Add(strTable[i], concommandFunc)
        end
    end
end

-- Keep in mind than removed concommands CANNOT be remade
-- https://wiki.facepunch.com/gmod/concommand.Remove
function gutils.removeCommand(strTable)
    print("gutils command removed: ")
    PrintTable(strTable)

    local conCommands = concommand.GetTable()
    for i=1, #strTable do
        commands[strTable[i]] = nil
        if conCommands[strTable[i]] then
            concommand.Remove(strTable[i])
        end
    end
end