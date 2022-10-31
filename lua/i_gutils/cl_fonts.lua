local fonts = {}

-- Don't use this func yourself
local function makeFont(args, key)
    surface.CreateFont(key, {
        font = args[3],
        size = args[1],
        weight = args[2],
    })

    fonts[key] = key

    return key
end

-- returns font name for use
--[[
    1 = size
    2 = weight
    3 = font
]]
function getFont(...)
    local args = {...}

    args[1] = args[1] or 18
    args[2] = args[2] or 500
    args[3] = args[3] or "Roboto"
    local key = table.concat(args, ",")

    return fonts[key] or makeFont(args, key)
end

-- returns width and height of the text with the given font ( or already set font )
--[[
    1 = text
    2 = font
]]
function getTextSize(...)
    local args = {...}

    args[1] = args[1] or "ABC"

    if args[2] then
        surface.SetFont(args[2])
    end

    return {surface.GetTextSize(args[1])}
end
