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
    local headers = {}
    headers["Authorization"] = authorization()
    headers["Content-Type"] = "application/json"
    local req = {
        method = "post",
        mime = "application/json",
        url = "http://192.168.0.160:8123/api/services/switch/toggle",
        headers = headers,
        content = "{ \"entity_id\": \"switch.desk_lamp\" }"
    }
    http.request(req, print_callback)
end

actions.change_ceiling = function(progress)
    print("progress was changed to " .. progress);
    if (progress == 0) then 
        -- Turn off the light
        log.trace("Turning off ceiling light")
        local headers = {}
        headers["Authorization"] = authorization()
        headers["Content-Type"] = "application/json"

        content = {}
        content['entity_id'] = "light.bedroom_ceiling_lights"
        content = data.tojson(content)


        local req = {
            method = "post",
            mime = "application/json",
            url = "http://192.168.0.160:8123/api/services/light/turn_off",
            headers = headers,
            content = content
        }
        http.request(req, print_callback)
    else
        log.trace("Setting ceiling light to " .. progress .. "% brightness")

        content = {}
        content['entity_id'] = "light.bedroom_ceiling_lights"
        content['brightness_pct'] = progress
        content = data.tojson(content)
        print(content)

        local headers = {}
        headers["Authorization"] = authorization()
        headers["Content-Type"] = "application/json"
        local req = {
            method = "post",
            mime = "application/json",
            url = "http://192.168.0.160:8123/api/services/light/turn_on",
            headers = headers,
            content = content
        }
        http.request(req, print_callback)
    end 
end

update_progress_bar = function(err, resp)
    if err then
        print(err)
    else
        log.trace("Response: " .. resp.status .. " " .. resp.reason .. " " .. resp.content)
        local content = data.fromjson(resp.content)
        local brightness = content.attributes.brightness * 100 / 255
        -- log.trace('Brightness is ' .. brightness)
        -- layout.slider.progress = brightness
    end
end

poll_ceiling_brightness = function()
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