if SERVER then
    util.AddNetworkString("gutils_chatAddText")
    -- plys can be a table of players or singular player.
    function gutils.chatAddText(plys, ...)
        local data = util.Compress(util.TableToJSON({...}))
        net.Start("gutils_chatAddText")
            net.WriteUInt(#data, 16)
            net.WriteData(data, #data)
        net.Send(plys)
    end
else
    net.Receive("gutils_chatAddtext", function(len)
        chat.PlaySound()
        chat.AddText(unpack(util.JSONToTable(util.Decompress(net.ReadData(net.ReadUInt(16))))))
    end)
end