local a={["/"]=true,["!"]=true,["\\"]=true}local b={}hook.Add(SERVER and"PlayerSay"or"OnPlayerChat","gutils_commands",function(c,d)if a[string.sub(d,1,1)]then local e=string.Explode(" ",string.lower(string.sub(d,2)))local f=b[e[1]]if f then return f(c,unpack(e,2))end end end)function gutils.addCommand(...)local g={...}local h=g[1]local i=g[2]local j=g[3]print("gutils command added: ")PrintTable(h)if j then for k=1,#h do b[h[k]]=i end else local l=function(c,f,g)i(c,unpack(g))end;for k=1,#h do b[h[k]]=i;concommand.Add(h[k],l)end end end;function gutils.removeCommand(h)print("gutils command removed: ")PrintTable(h)local m=concommand.GetTable()for k=1,#h do b[h[k]]=nil;if m[h[k]]then concommand.Remove(h[k])end end end