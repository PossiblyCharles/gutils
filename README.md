# gutils (Garry's Mod addon utilities)
This addon is for things that tend to be remade from addon to addon with the same functionality.
I'm going to be adding to this every time I make something that could be utilised by multiple addons.

# Running lua folders
As long as your addons lua file directory name is started with i_ gutils will handle including of any cl_ sh_ and sv_ files within that directory.
Check out [gutils_run.lua](https://github.com/PossiblyCharles/gutils/blob/main/lua/autorun/gutils_run.lua)

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
Used to add chat/console commands in a short way. Can be added on client, server or both. Add a third param as true to disable the concommand creation.

```lua
gutils.removeCommand({"table","of","trigger","commands"})
```
Removes the commands in the table. [Keep in mind removed concommands can cause problems when being readded.](https://wiki.facepunch.com/gmod/concommand.Remove)

```lua
local newDrawFunc, reDrawFunc = gutils.drawPaintRT(origDrawFunc, maxInactiveSeconds=60)
reDrawFunc(drawFunc=origDrawFunc, replaceDrawFunc=false)
```
Used to turn your draw functions into materials to save fps on recalculating the same things every frame. 
- The materials used are recycled if newDrawFunc isn't called for maxInactiveSeconds seconds. 
- maxInactiveSeconds = -1 to disable the recycling of your material.
- reDrawFunc can be called to update newDrawFunc. If the 2nd param is true, deawFunc will replace origDrawFunc. Making it the default function used if reDrawFunc is called with no params.

```lua
gutils.button3d2d(pos, ang, scale, drawFunc, buttonTable, cursorDrawFunc=nil)
```
Used to create 3d2d buttons. There's an example in test_scripts/test1.lua
https://user-images.githubusercontent.com/106554151/199559444-38744c00-b662-45d3-988e-7c05ae64c259.mp4

