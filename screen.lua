local mouse = libs.mouse;
local win = libs.win;

local WM_SYSCOMMAND = 0x0112;
local SC_MONITORPOWER = 0xF170;
local HWND_BROADCAST = 0xffff;

Screen = {}

--@help Turn monitor on
function actions.turn_on_monitor()
	mouse.moveby(0,0);
end

--@help Turn monitor off
function actions.turn_off_monitor()
	win.post(HWND_BROADCAST, WM_SYSCOMMAND, SC_MONITORPOWER, 2);
end

--@help Put monitor in standby
function Screen.standby()
	win.post(HWND_BROADCAST, WM_SYSCOMMAND, SC_MONITORPOWER, 1);
end