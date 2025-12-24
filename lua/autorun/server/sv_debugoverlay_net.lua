if game.SinglePlayer() then return end
util.AddNetworkString("debugoverlay_net")

-- Save old debugoverlay functions
_debugoverlay = _debugoverlay or nil
if not _debugoverlay then
    _debugoverlay = {}
    for k,v in pairs(debugoverlay) do
        _debugoverlay[k] = v
    end
end

local C_Developer = GetConVar("developer")
local debugoverlay_net = {}
local debugoverlay_net_clients = RecipientFilter(true)

-- debugoverlay functions
function debugoverlay_net.Line(pos1, pos2, lifetime, color, ignoreZ)
    if C_Developer:GetInt() == 0 then return end
    if not isvector(pos1) then error("debugoverlay_net.Line: [pos1] is not Vector") end
    if not isvector(pos2) then error("debugoverlay_net.Line: [pos2] is not Vector") end

    lifetime = lifetime or 1
    color = color or Color(255,255,255)
    ignoreZ = ignoreZ or false

    net.Start("debugoverlay_net")
        net.WriteUInt(1,8)
        net.WriteVector(pos1)
        net.WriteVector(pos2)
        net.WriteFloat(lifetime)
        net.WriteColor(color)
        net.WriteBool(ignoreZ)
    net.Send(debugoverlay_net_clients)
end

function debugoverlay_net.Box(origin, mins, maxs, lifetime, color)
    if C_Developer:GetInt() == 0 then return end
    if not isvector(origin) then error("debugoverlay_net.Box: [origin] is not Vector") end
    if not isvector(mins) then error("debugoverlay_net.Box: [mins] is not Vector") end
    if not isvector(maxs) then error("debugoverlay_net.Box: [maxs] is not Vector") end

    lifetime = lifetime or 1
    color = color or Color(255,255,255,255)

    net.Start("debugoverlay_net")
        net.WriteUInt(2,8)
        net.WriteVector(origin)
        net.WriteVector(mins)
        net.WriteVector(maxs)
        net.WriteFloat(lifetime)
        net.WriteColor(color)
    net.Send(debugoverlay_net_clients)
end

function debugoverlay_net.BoxAngles(origin, mins, maxs, ang, lifetime, color)
    if C_Developer:GetInt() == 0 then return end
    if not isvector(origin) then error("debugoverlay_net.Box: [origin] is not Vector") end
    if not isvector(mins) then error("debugoverlay_net.Box: [mins] is not Vector") end
    if not isvector(maxs) then error("debugoverlay_net.Box: [maxs] is not Vector") end
    if not isangle(ang) then error("debugoverlay_net.Box: [ang] is not Angle") end

    lifetime = lifetime or 1
    color = color or Color(255,255,255,255)

    net.Start("debugoverlay_net")
        net.WriteUInt(3,8)
        net.WriteVector(origin)
        net.WriteVector(mins)
        net.WriteVector(maxs)
        net.WriteAngle(ang)
        net.WriteFloat(lifetime)
        net.WriteColor(color)
    net.Send(debugoverlay_net_clients)
end

function debugoverlay_net.Cross(position, size, lifetime, color, ignoreZ)
    if C_Developer:GetInt() == 0 then return end
    if not isvector(position) then error("debugoverlay_net.Cross: [position] is not Vector") end
    if not isnumber(size) then error("debugoverlay_net.Cross: [position] is not Number") end

    lifetime = lifetime or 1
    color = color or Color(255,255,255)
    ignoreZ = ignoreZ or false

    net.Start("debugoverlay_net")
        net.WriteUInt(4,8)
        net.WriteVector(position)
        net.WriteFloat(size)
        net.WriteFloat(lifetime)
        net.WriteColor(color)
        net.WriteBool(ignoreZ)
    net.Send(debugoverlay_net_clients)
end

function debugoverlay_net.Text(origin, text, lifetime, viewCheck)
    if C_Developer:GetInt() == 0 then return end
    if not isvector(origin) then error("debugoverlay_net.Text: [origin] is not Vector") end
    if not isstring(text) then error("debugoverlay_net.Text: [text] is not String") end

    lifetime = lifetime or 1
    viewCheck = viewCheck or false

    net.Start("debugoverlay_net")
        net.WriteUInt(5,8)
        net.WriteVector(origin)
        net.WriteString(text)
        net.WriteFloat(lifetime)
        net.WriteBool(viewCheck)
    net.Send(debugoverlay_net_clients)
end

function debugoverlay_net.Sphere(origin, size, lifetime, color, ignoreZ)
    if C_Developer:GetInt() == 0 then return end
    if not isvector(origin) then error("debugoverlay_net.Sphere: [origin] is not Vector") end
    if not isnumber(size) then error("debugoverlay_net.Sphere: [size] is not Number") end

    lifetime = lifetime or 1
    color = color or Color(255,255,255)
    ignoreZ = ignoreZ or false

    net.Start("debugoverlay_net")
        net.WriteUInt(6,8)
        net.WriteVector(origin)
        net.WriteFloat(size)
        net.WriteFloat(lifetime)
        net.WriteColor(color)
        net.WriteBool(ignoreZ)
    net.Send(debugoverlay_net_clients)
end

function debugoverlay_net.Axis(origin, ang, size, lifetime, ignoreZ)
    if C_Developer:GetInt() == 0 then return end
    if not isvector(origin) then error("debugoverlay_net.Axis: [origin] is not Vector") end
    if not isangle(ang) then error("debugoverlay_net.Axis: [ang] is not Angle") end
    if not isnumber(size) then error("debugoverlay_net.Axis: [size] is not Number") end
    lifetime = lifetime or 1
    ignoreZ = ignoreZ or false
    
    net.Start("debugoverlay_net")
        net.WriteUInt(7,8)
        net.WriteVector(origin)
        net.WriteAngle(ang)
        net.WriteFloat(size)
        net.WriteFloat(lifetime)
        net.WriteBool(ignoreZ)
    net.Send(debugoverlay_net_clients)
end

function debugoverlay_net.Grid(position)
    if C_Developer:GetInt() == 0 then return end
    if not isvector(position) then error("debugoverlay.Grid: [position] is not Vector") end
    
    net.Start("debugoverlay_net")
        net.WriteUInt(8,8)
        net.WriteVector(position)
    net.Send(debugoverlay_net_clients)
end

function debugoverlay_net.ScreenText(x, y, text, lifetime, color)
    if C_Developer:GetInt() == 0 then return end
    if not isnumber(x) then error("debugoverlay_net.ScreenText: [x] is not Number") end
    if not isnumber(y) then error("debugoverlay_net.ScreenText: [y] is not Number") end
    if not isstring(text) then error("debugoverlay_net.ScreenText: [text] is not String") end

    lifetime = lifetime or 1
    color = color or Color(255,255,255)

    net.Start("debugoverlay_net")
        net.WriteUInt(9,8)
        net.WriteFloat(x)
        net.WriteFloat(y)
        net.WriteString(text)
        net.WriteFloat(lifetime)
        net.WriteColor(color)
    net.Send(debugoverlay_net_clients)
end

function debugoverlay_net.Triangle(pos1, pos2, pos3, lifetime, color, ignoreZ)
    if C_Developer:GetInt() == 0 then return end
    if not isvector(pos1) then error("debugoverlay_net.Triangle: [pos1] is not Vector") end
    if not isvector(pos2) then error("debugoverlay_net.Triangle: [pos2] is not Vector") end
    if not isvector(pos3) then error("debugoverlay_net.Triangle: [pos3] is not Vector") end

    lifetime = lifetime or 1
    color = color or Color(255,255,255)
    ignoreZ = ignoreZ or false

    net.Start("debugoverlay_net")
        net.WriteUInt(10,8)
        net.WriteVector(pos1)
        net.WriteVector(pos2)
        net.WriteVector(pos3)
        net.WriteFloat(lifetime)
        net.WriteColor(color)
        net.WriteBool(ignoreZ)
    net.Send(debugoverlay_net_clients)
end

function debugoverlay_net.SweptBox(vStart, vEnd, vMins, vMaxs, ang, lifetime, color)
    if C_Developer:GetInt() == 0 then return end
    if not isvector(vStart) then error("debugoverlay_net.SweptBox: [vStart] is not Vector") end
    if not isvector(vEnd) then error("debugoverlay_net.SweptBox: [vEnd] is not Vector") end
    if not isvector(vMins) then error("debugoverlay_net.SweptBox: [vMins] is not Vector") end
    if not isvector(vMaxs) then error("debugoverlay_net.SweptBox: [vMaxs] is not Vector") end
    if not isangle(ang) then error("debugoverlay_net.SweptBox: [ang] is not Angle") end

    lifetime = lifetime or 1
    color = color or Color(255,255,255)

    net.Start("debugoverlay_net")
        net.WriteUInt(11,8)
        net.WriteVector(vStart)
        net.WriteVector(vEnd)
        net.WriteVector(vMins)
        net.WriteVector(vMaxs)
        net.WriteAngle(ang)
        net.WriteFloat(lifetime)
        net.WriteColor(color)
    net.Send(debugoverlay_net_clients)
end

function debugoverlay_net.EntityTextAtPosition(pos, line, text, lifetime, color)
    if C_Developer:GetInt() == 0 then return end
    if not isvector(pos) then error("debugoverlay_net.EntityTextAtPosition: [pos] is not Vector") end
    if not isnumber(line) then error("debugoverlay_net.EntityTextAtPosition: [line] is not Number") end
    if not isstring(text) then error("debugoverlay_net.EntityTextAtPosition: [text] is not String") end

    lifetime = lifetime or 1
    color = color or Color(255,255,255)

    net.Start("debugoverlay_net")
        net.WriteUInt(12,8)
        net.WriteVector(pos)
        net.WriteFloat(line)
        net.WriteString(text)
        net.WriteFloat(lifetime)
        net.WriteColor(color)
    net.Send(debugoverlay_net_clients)
end

-- Overwrite original debugoverlay
debugoverlay = debugoverlay_net

-- Net callback for handle debugoverlay_net clients
net.Receive("debugoverlay_net", function(len, ply)
    local needSend = net.ReadBool()
    if needSend then
        debugoverlay_net_clients:AddPlayer(ply)
    else
        debugoverlay_net_clients:RemovePlayer(ply)
    end
end)