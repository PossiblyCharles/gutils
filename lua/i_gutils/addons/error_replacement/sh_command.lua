-- This replaces error with their physics mesh

if SERVER then
    -- going to use ER for short.
    local EREnabled = CreateConVar("sv_error_replacement", "1", FCVAR_ARCHIVE, "Enable / Disable fully", 0, 1)
else
    local EREnabled = CreateConVar("cl_error_replacement", "1", FCVAR_ARCHIVE, "Enable / Disable for your client", 0, 1)
    -- Chat command to make changing it a little easier... Not at all needed.
    local function ERCommand(ply, state)
        if !state then
            state = !EREnabled:GetBool()
        else
            state = tobool(state)
        end
        EREnabled:SetBool(state)
        gutils.chatAddText(Color(255,255,255), "Error Replacements: "..tostring(state))
        return ""
    end
    gutils.addCommand({"errorreplacement", "errorr", "er"}, ERCommand, true, 1)
end