include("screen.lua")
include('media.lua')
include('kasa.lua')

local timer = require("timer");

tid = nil

events.create = function ()
    poll_ceiling_brightness()
	tid = timer.interval(poll_ceiling_brightness, 2000);
    print("Timer " .. tid .. " created")
end

events.destroy = function ()
    print("Timer " .. tid .. " cancled")
	timer.cancel(tid)
end