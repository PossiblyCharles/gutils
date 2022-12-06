local function commandTest(ply, ...)
    ply:PrintMessage(HUD_PRINTTALK, "Hello World")
    return ""
end
gutils.addCommand({"testcommand", "asdasd"}, commandTest, nil, 5)