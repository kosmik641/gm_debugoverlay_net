# gm_debugoverlay_net
[debugoverlay on Garry's Mod Wiki](https://wiki.facepunch.com/gmod/debugoverlay)
[Steam Workshop](https://steamcommunity.com/sharedfiles/filedetails/?id=3630587067)
> The debugoverlay library is mainly useful for 3D debugging, it can be used to draw shapes on the screen for debug purposes.

This addon add netowrking for `debugoverlay` functions of server.
Clients with enabled serverside debug overlays will be render server's debug overlays.
Clients and server need to set `developer 1` or above

Client console variables:
- `enable_debug_overlays_server` - Enable rendering of debug overlays from server
    - `0` - disabled
    - `1` - draw debug overlays from server
    - `2` - draw debug overlays both from server and client
