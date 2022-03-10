local log = libs.log
local ffi = require("ffi");

ffi.cdef[[
    bool toggle_device(const char* ipaddr);
]]

local kasa = ffi.load('C:/ProgramData/Unified Remote/Remotes/Custom/UnifiedRemoteControlPanel/kasa_lib')

actions.turn_on_lights = function()
    kasa.toggle_device("192.168.0.93")
end