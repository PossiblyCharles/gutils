-- Making our funcs early to allow buttons to access reDrawFunc
local drawFunc, reDrawFunc = gutils.drawPaintRT()

local text = "Testing"
local font = gutils.getFont(100)
local tW, tH = gutils.getTextSize(font, text)
local pad = 5

testButton = {
	min = Vector(1,0,0),
	max = Vector(tW + pad * 2, tH + pad * 2, 0),
	stateChanged = reDrawFunc
}

local buttonTable = {
	testButton
}

-- First drawn down here to allow for buttons to be setup fully in one place.
-- I'm bad at wording comments.
reDrawFunc(function()
	local c = testButton.isHovered and 50 or 0
	surface.SetDrawColor( c + (testButton.isPressed and 200 or 0), c, c, 255 )
	surface.DrawRect( 0, 0, tW + pad * 2, tH + pad * 2 )

	draw.SimpleText( text, font, 0, 0, color_white )
end, true)

-- This could be any drawing hook really... As long as it's a 3d context.
hook.Add("PostDrawOpaqueRenderables", "testi", function()
	local angle = Angle(0,0,0)
	angle.y = angle.y + math.sin( CurTime() ) * 10
	angle:RotateAroundAxis( angle:Up(), -90 )
	angle:RotateAroundAxis( angle:Forward(), 90 )

	local pos = Vector( 0, 0, math.cos( CurTime() / 2 ) + 20 )
	
	gutils.button3d2d(pos, angle, 0.1, drawFunc, buttonTable)
end)