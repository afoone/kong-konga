local BasePlugin = require "kong.plugins.base_plugin"
local http = require "resty.http"
local https = require "ssl.https"

local ExternalAuthHandler = BasePlugin:extend()

function ExternalAuthHandler:new()
  ExternalAuthHandler.super.new(self, "external-auth")
end

function ExternalAuthHandler:access(conf)
  ExternalAuthHandler.super.access(self)

  local body, code, headers, status = https.request({
    url = conf.url,
    headers = { 
      ['Connection'] = 'close',
      ['Authorization'] = kong.request.get_header('Authorization'),
      ['Content-Type'] = 'application/json',
    }
    })

  if status == 'HTTP/1.1 403 Forbidden' then
    return kong.response.exit(403, status)
  end
end

ExternalAuthHandler.PRIORITY = 900

return ExternalAuthHandler