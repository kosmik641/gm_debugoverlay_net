if game.SinglePlayer() then return end

-- Save old debugoverlay functions
_debugoverlay = _debugoverlay or nil
if not _debugoverlay then
    _debugoverlay = {}
    for k,v in pairs(debugoverlay) do
        _debugoverlay[k] = v
    end
end

local C_Developer = GetConVar("developer")
local C_DbgOverlaySrv = CreateClientConVar("enable_debug_overlays_server", "0", false, false, "Enable rendering of debug overlays from server (0 - disable, 1 - only from server, 2 - both from server and client)")
local debugoverlay_net = {}

-- debugoverlay functions
function debugoverlay_net.Line(pos1, pos2, lifetime, color, ignoreZ, server)
    if C_DbgOverlaySrv:GetInt() == 1 and not server then return end
    _debugoverlay.Line(pos1, pos2, lifetime, color, ignoreZ)
end

function debugoverlay_net.Box(origin, mins, maxs, lifetime, color, server)
    if C_DbgOverlaySrv:GetInt() == 1 and not server then return end
    _debugoverlay.Box(origin, mins, maxs, lifetime, color)
end

function debugoverlay_net.BoxAngles(origin, mins, maxs, ang, lifetime, color, server)
    if C_DbgOverlaySrv:GetInt() == 1 and not server then return end
    _debugoverlay.BoxAngles(origin, mins, maxs, ang, lifetime, color)
end

function debugoverlay_net.Cross(position, size, lifetime, color, ignoreZ, server)
    if C_DbgOverlaySrv:GetInt() == 1 and not server then return end
    _debugoverlay.Cross(position, size, lifetime, color, ignoreZ)
end

function debugoverlay_net.Text(origin, text, lifetime, viewCheck, server)
    if C_DbgOverlaySrv:GetInt() == 1 and not server then return end
    _debugoverlay.Text(origin, text, lifetime, viewCheck)
end

function debugoverlay_net.Sphere(origin, size, lifetime, color, ignoreZ, server)
    if C_DbgOverlaySrv:GetInt() == 1 and not server then return end
    _debugoverlay.Sphere(origin, size, lifetime, color, ignoreZ)
end

function debugoverlay_net.Axis(origin, ang, size, lifetime, ignoreZ, server)
    if C_DbgOverlaySrv:GetInt() == 1 and not server then return end
    _debugoverlay.Axis(origin, ang, size, lifetime, ignoreZ)
end

function debugoverlay_net.Grid(position, server)
    if C_DbgOverlaySrv:GetInt() == 1 and not server then return end
    _debugoverlay.Grid(position)
end

function debugoverlay_net.ScreenText(x, y, text, lifetime, color, server)
    if C_DbgOverlaySrv:GetInt() == 1 and not server then return end
    _debugoverlay.ScreenText(x, y, text, lifetime, color)
end

function debugoverlay_net.Triangle(pos1, pos2, pos3, lifetime, color, ignoreZ, server)
    if C_DbgOverlaySrv:GetInt() == 1 and not server then return end
    _debugoverlay.Triangle(pos1, pos2, pos3, lifetime, color, ignoreZ)
end

function debugoverlay_net.SweptBox(vStart, vEnd, vMins, vMaxs, ang, lifetime, color, server)
    if C_DbgOverlaySrv:GetInt() == 1 and not server then return end
    _debugoverlay.SweptBox(vStart, vEnd, vMins, vMaxs, ang, lifetime, color)
end

function debugoverlay_net.EntityTextAtPosition(pos, line, text, lifetime, color, server)
    if C_DbgOverlaySrv:GetInt() == 1 and not server then return end
    _debugoverlay.EntityTextAtPosition(pos, line, text, lifetime, color)
end

-- Overwrite original debugoverlay (if need)
if C_DbgOverlaySrv:GetInt() > 0 then
    debugoverlay = debugoverlay_net
end

-- Add player to debugoverlay_net clients
cvars.AddChangeCallback("enable_debug_overlays_server", function(name, old, new)
    if C_DbgOverlaySrv:GetInt() > 0 then
        debugoverlay = debugoverlay_net
    else
        debugoverlay = _debugoverlay
    end

    net.Start("debugoverlay_net")
    net.WriteBool(C_DbgOverlaySrv:GetInt() > 0)
    net.SendToServer()
end,"debugoverlay_net_callback")

-- Draw on client from server's debugoverlay
net.Receive("debugoverlay_net", function()
    if C_Developer:GetInt() == 0 then return end
    if C_DbgOverlaySrv:GetInt() == 0 then return end
    local method = net.ReadUInt(8)

    if method == 1 then
        local pos1      = net.ReadVector()
        local pos2      = net.ReadVector()
        local lifetime  = net.ReadFloat()
        local color     = net.ReadColor()
        local ignoreZ   = net.ReadBool()
        debugoverlay_net.Line(pos1, pos2, lifetime, color, ignoreZ, true)
    elseif method == 2 then
        local origin    = net.ReadVector()
        local mins      = net.ReadVector()
        local maxs      = net.ReadVector()
        local lifetime  = net.ReadFloat()
        local color     = net.ReadColor()
        debugoverlay_net.Box(origin, mins, maxs, lifetime, color, true)
    elseif method == 3 then
        local origin    = net.ReadVector()
        local mins      = net.ReadVector()
        local maxs      = net.ReadVector()
        local ang       = net.ReadAngle()
        local lifetime  = net.ReadFloat()
        local color     = net.ReadColor()
        debugoverlay_net.BoxAngles(origin, mins, maxs, ang, lifetime, color, true)
    elseif method == 4 then
        local position  = net.ReadVector()
        local size      = net.ReadFloat()
        local lifetime  = net.ReadFloat()
        local color     = net.ReadColor()
        local ignoreZ   = net.ReadBool()
        debugoverlay_net.Cross(position, size, lifetime, color, ignoreZ, true)
    elseif method == 5 then
        local origin    = net.ReadVector()
        local text      = net.ReadString()
        local lifetime  = net.ReadFloat()
        local viewCheck = net.ReadBool()
        debugoverlay_net.Text(origin, text, lifetime, viewCheck, true)
    elseif method == 6 then
        local origin    = net.ReadVector()
        local size      = net.ReadFloat()
        local lifetime  = net.ReadFloat()
        local color     = net.ReadColor()
        local ignoreZ   = net.ReadBool()
        debugoverlay_net.Sphere(origin, size, lifetime, color, ignoreZ, true)
    elseif method == 7 then
        local origin    = net.ReadVector()
        local ang       = net.ReadAngle()
        local size      = net.ReadFloat()
        local lifetime  = net.ReadFloat()
        local ignoreZ   = net.ReadBool()
        debugoverlay_net.Axis(origin, ang, size, lifetime, ignoreZ, true)
    elseif method == 8 then
        local position  = net.ReadVector()
        debugoverlay_net.Grid(position, true)
    elseif method == 9 then
        local x         = net.ReadFloat()
        local y         = net.ReadFloat()
        local text      = net.ReadString()
        local lifetime  = net.ReadFloat()
        local color     = net.ReadColor()
        debugoverlay_net.ScreenText(x, y, text, lifetime, color, true)
    elseif method == 10 then
        local pos1      = net.ReadVector()
        local pos2      = net.ReadVector()
        local pos3      = net.ReadVector()
        local lifetime  = net.ReadFloat()
        local color     = net.ReadColor()
        local ignoreZ   = net.ReadBool()
        debugoverlay_net.Triangle(pos1, pos2, pos3, lifetime, color, ignoreZ, true)
    elseif method == 11 then
        local vStart    = net.ReadVector()
        local vEnd      = net.ReadVector()
        local vMins     = net.ReadVector()
        local vMaxs     = net.ReadVector()
        local ang       = net.ReadAngle()
        local lifetime  = net.ReadFloat()
        local color = net.ReadColor()
        debugoverlay_net.SweptBox(vStart, vEnd, vMins, vMaxs, ang, lifetime, color, true)
    elseif method == 12 then
        local pos       = net.ReadVector()
        local line      = net.ReadFloat()
        local text      = net.ReadString()
        local lifetime  = net.ReadFloat()
        local color     = net.ReadColor()
        debugoverlay_net.EntityTextAtPosition(pos, line, text, lifetime, color, true)
    else
        MsgC(Color(255,0,0,255),Format("debugoverlay_net: Unknown method (%d)\n",method))
    end
end)