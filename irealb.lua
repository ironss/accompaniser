#! /usr/bin/env lua

local re = require('re')
local serpent = require('serpent')

function url_decode(str)
  str = string.gsub (str, "+", " ")
  str = string.gsub (str, "%%(%x%x)",
      function(h) return string.char(tonumber(h,16)) end)
  str = string.gsub (str, "\r\n", "\n")
  return str
end


local irealb_parser = re.compile([[
-- irealb_url <- 'irealbook://' url_encoded_irealbook

irealbook <- ( scheme ? songbook  ) -> {}
scheme <- 'irealbook://'
songbook <- ( song ( song * ) {:book: field? :} )
song <- ({:title: field :} ssep {:composer: field :} ssep {:style: field :} ssep {:key: field :} ssep {:xxx: field :} ssep {:staff: staff :} ssep) -> {} 

staff <- {:text: field :} -> {}
field <- [^=]*
ssep <- sep %s*
sep <- '='
]])

local staff_parser = re.compile([[
staff <- { content? (barline content)* barline %s* } -> {} 
barline <- [][}[|zZ]
content <- [^][}[|zZ]+
]])


local M = {}

M.url_parse = function(s) return re.find(url_decode(s), irealb_parser) end
M.parse = function(s) return re.find(s, irealb_parser) end
M.staff_parse = function(s) return re.find(s, staff_parser) end

return M

