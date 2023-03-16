local log = libs.log
local http = require("http");
local data = require("data");

authorization = function()
    return "Bearer " .. settings.ha_token
end

print_callback = function (err, resp)
    if err then
        print(err)
    else
        log.trace("Response: " .. resp.status .. " " .. resp.reason .. " " .. resp.content)
    end
end

actions.toggle_desk_lamp = function()
    log.trace("Turning off desk lamp")
    toggle_switch("switch.desk_lamp")
end

actions.toggle_fan = function()
    log.trace("Turning off desk lamp")
    toggle_switch("switch.window_blower")
end

toggle_switch = function(entity_id)
    local headers = {}
    headers["Authorization"] = authorization()
    headers["Content-Type"] = "application/json"

    local content = {}
    content['entity_id'] = entity_id

    local req = {
        method = "post",
        mime = "application/json",
        url = "http://192.168.0.160:8123/api/services/switch/toggle",
        headers = headers,
        content = data.tojson(content)
    }
    http.request(req, print_callback)
end


actions.change_ceiling = function(brightness)
    if (brightness == 0) then 
        -- Turn off the light
        log.trace("Turning off ceiling light")
        local headers = {}
        headers["Authorization"] = authorization()
        headers["Content-Type"] = "application/json"

        local content = {}
        content['entity_id'] = "light.bedroom_ceiling_lights"

        local req = {
            method = "post",
            mime = "application/json",
            url = "http://192.168.0.160:8123/api/services/light/turn_off",
            headers = headers,
            content = data.tojson(content)
        }
        http.request(req, print_callback)
    else
        log.info("Setting ceiling light to " .. brightness .. "% brightness")

        local content = {}
        content['entity_id'] = "light.bedroom_ceiling_lights"
        content['brightness_pct'] = brightness
        -- print(content)

        local headers = {}
        headers["Authorization"] = authorization()
        headers["Content-Type"] = "application/json"
        local req = {
            method = "post",
            mime = "application/json",
            url = "http://192.168.0.160:8123/api/services/light/turn_on",
            headers = headers,
            content = data.tojson(content)
        }
        http.request(req, print_callback)
    end 
end

update_progress_bar = function(err, resp)
    if err then
        print(err)
    else
        -- log.info("Response: " .. resp.status .. " " .. resp.reason .. " " .. resp.content)
        log.trace(resp.content)
        local content = data.fromjson(resp.content)
        if content.state == "off" then
            layout.slider.progress = 0
        else
            local brightness = content.attributes.brightness * 100 / 255
            -- print('Brightness is ' .. brightness)
            layout.slider.progress = math.floor(brightness + 0.5)
        end

    end
end

poll_ceiling_brightness = function()
    -- print("Polling ceiling brightness")
    local headers = {}
    headers["Authorization"] = authorization()
    local req = {
        method = "get",
        mime = "application/json",
        url = "http://192.168.0.160:8123/api/states/light.bedroom_ceiling_lights",
        headers = headers,
    }
    http.request(req, update_progress_bar)
end
