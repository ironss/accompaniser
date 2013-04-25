#! /usr/bin/lua

-- Copyright (c) 2013 Stephen Irons 
-- License text at end of file

package.path = './?/?.lua;' .. package.path
require('luaunit')

local nless = require('string_nless')
local snless = nless.string_nless

local tests = 
{
   { 'a', 'a', false },
   { 'a', 'b', true  },
   { 'b', 'a', false },
   
   { '1', '1', false },
   { '1', '2', true  },
   { '2', '1', false },
   
   {  '1', '10', true  },
   { '10',  '1', false },
   {  '2', '10', true  },
   { '10',  '2', false },
   
   { 'a1', 'a1', false },
   { 'a1', 'a2', true  },
   { 'a2', 'a1', false },
   
   { 'a1', 'b1', true  },
   { 'b1', 'a1', false },
   
   {  'a1', 'a10', true  },
   { 'a10',  'a1', false },
--   {  'a2', 'a10', true  },
--   { 'a10',  'a2', false },
}

Test_nless = {}

for i, t in ipairs(tests) do
   local n = t[3] and '_true' or '_false'
   
   Test_nless['test_' .. t[1] .. '_lt_' .. t[2] .. n] = function()
      assertEquals(snless(t[1], t[2]),t[3]) 
   end 
end

return LuaUnit:run()

