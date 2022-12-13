-- Calls the hook playerFullyLoaded when they're ready to run lua.

if SERVER then
    util.AddNetworkString("gutils_playerFullyLoaded")

    net.Receive("gutils_playerFullyLoaded", function(len, ply)
        hook.Run("gutils_playerFullyLoaded", ply)
    end)
else
    hook.Add("HUDPaint","gutils_playerFullyLoaded", function()
        net.Start("gutils_playerFullyLoaded")
        net.SendToServer()
        hook.Run("gutils_playerFullyLoaded", ply) -- Maybe better than having many many hooks in HUDPaint? Also means no hook.Remove needs to be called.
        hook.Remove("HUDPaint","gutils_playerFullyLoaded")
    end)
end