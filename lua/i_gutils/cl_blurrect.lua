local blur = Material( "pp/blurscreen" )
function gutils.blurRect(x, y, w, h, a, ...)
    surface.SetDrawColor( 255, 255, 255, a)
    surface.SetMaterial( blur )
    for i = 1, {...}[1] or 5 do
        blur:SetFloat( "$blur", ( i / 4 ) * 4 )
        blur:Recompute()

        render.UpdateScreenEffectTexture()
        surface.DrawTexturedRect( x, y, w, h )
    end
end