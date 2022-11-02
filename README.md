# gutils (Garry's Mod addon utilities)
This addon is for things that tend to be remade from addon to addon with the same functionality.
I'm going to be adding to this every time I make something that could be utilised by multiple addons.

# Functions
```lua
local fontName = gutils.getFont(size=18, weight=500, baseFont="Roboto")
```
Easier smaller faster way to get a font. No need to deal with surface.CreateFont. This allows the same font's to be used across multiple addons as long as they're using the same settings.

```lua
local width, height = gutils.getTextSize(font, text)
```
A short form replacement for surface.SetFont + surface.GetTextSize.

```lua
gutils.addCommand({"table","of","trigger","commands"}, function(ply, ...) ply:Kill() end)
```
Used to add commands in a short way. Can be added on client, server or both. Add a third param as true to disable the concommand creation.

```lua
gutils.removeCommand({"table","of","trigger","commands"})
```
Removes the commands in the table. [Keep in mind removed concommands can cause problems when being readded.](https://wiki.facepunch.com/gmod/concommand.Remove)

```lua
local drawFunc, reDrawFunc = gutils.drawPaintRT(drawFunc, maxInactiveSeconds=60)
reDrawFunc(drawFunc=drawFunc, replaceDrawFunc=false)
```
Used to turn your draw functions into materials to save fps on recalculating the same things every frame. The materials used are recycled if the draw function isn't called for maxInactiveSeconds seconds. If you know you'll never need to change the draw you can use -1 for infite time, however keep in mind that material will never be recycled. Avoid using -1 where possible.
