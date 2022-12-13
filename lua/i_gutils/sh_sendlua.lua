-- This is for menus or general clientside lua code you don't want readily avalible in clients cache for reading.
-- It can ofc still be seen if someone trys- But does make it 1 step harder.

-- Keeping the netmessages down to a smaller size.
-- This is to keep the load spreadout. Large net messages tend to freeze up clients on low end machines.
-- Keep in mind this will cause a delay before your code runs if it's long. 25,000 chars would be a full second minimum delay.

local gutils = gutils

if SERVER then
    util.AddNetworkString("gutils_SendLua")
    local toSend = {}
    local count = 0
    function gutils.SendLua(stringLua, targets)
        table.insert(toSend, {stringLua,targets or player.GetAll()}) -- last so we can keep reading the strings as O(1)
        count = count + 1
    end

    local stringToBeSent = ""
    local target = 0
    local timeStamp = 0
    local endOfString = false
    hook.Add("Think", "gutils_SendLua", function()
        if count != 0 && timeStamp < CurTime() then
            timeStamp = CurTime() + 0.2 -- 5 per second

            if #toSend[1][1] > 5000 then
                stringToBeSent = string.sub(toSend[1][1], 1, 5000) -- 5000 char at a time.
                toSend[1][1] = string.sub(toSend[1][1], 5001)
                target = toSend[1][2]
                endOfString = false
            else
                stringToBeSent = toSend[1][1]
                target = toSend[1][2]
                count = count - 1
                endOfString = true
                table.remove(toSend, 1)
            end

            net.Start("gutils_SendLua")
                net.WriteString(stringToBeSent)
                net.WriteBool(endOfString)
            net.Send(target)
        end
    end)
else
    local beingReceived = ""
    net.Receive("gutils_SendLua", function()
        beingReceived = beingReceived..net.ReadString()
        if net.ReadBool() then
            RunString(beingReceived) -- This will create errors if it fails to compile. Maybe I should add a CompileString version that can't error?
        end
    end)
end