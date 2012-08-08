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
song <- ({:title: field :} ssep {:composer: field :} ssep {:style: field :} ssep {:key: field :} ssep {:xxx: field :} ssep {:staff: field :} ssep) -> {} 

field <- [^=]*
ssep <- sep %s*
sep <- '='
]])


local fn = arg[1]
local f = io.open(fn)
local s = f:read('*a')
local s = url_decode(s)
print(s)
local a, b = re.find(s, irealb_parser)
--print(serpent.block(b))

for i, v in ipairs(b) do
   print(i, v.composer, v.title, v.staff)
end

