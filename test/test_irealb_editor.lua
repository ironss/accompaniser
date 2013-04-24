#! /usr/bin/env lua

local re = require('re')

function url_decode(str)
  str = string.gsub (str, "+", " ")
  str = string.gsub (str, "%%(%x%x)",
      function(h) return string.char(tonumber(h,16)) end)
  str = string.gsub (str, "\r\n", "\n")
  return str
end


f = io.open('test/files/irealb_test_urls')
for url in f:lines() do
   if url ~= '' then
		url_decoded = url_decode(url)
		tune = string.match(url_decoded, '1r34LbKcu7(.*)')
		p1 = string.find(tune, '%[')
		p2 = string.find(tune, 'W')
		print(tune, p1, p2)
   end
end

