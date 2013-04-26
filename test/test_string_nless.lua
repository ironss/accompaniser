#! /usr/bin/lua

-- Copyright (c) 2013 Stephen Irons 
-- License text at end of file

package.path = './?/?.lua;' .. package.path
require('luaunit')
local serpent = require('serpent')

local nless = require('string_nless')
local snless = nless.string_nless
local nsplit = nless.string_nsplit

local nless_tests = 
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
   {  'a2', 'a10', true  },
   { 'a10',  'a2', false },
   
   { 'a1b', 'a1b', false },
   { 'a1b', 'a1c', true  },
   { 'a1b', 'a2b', true  },
   { 'a1b', 'b1b', true  },

   { 'a1b', 'a10b', true },
   { 'a1b', 'a10c', true  },
   { 'a2b', 'a10b', true  },
   { 'a2b', 'a10c', true  },
   
   { '1.10', '1.100', true },
   { '1.2' , '1.10' , true },
}

Test_nless = {}

for i, t in ipairs(nless_tests) do
   local n = t[3] and '_true' or '_false'
   
   Test_nless['test_' .. t[1] .. '_lt_' .. t[2] .. n] = function()
      assertEquals(snless(t[1], t[2]),t[3]) 
   end 
end




local nsplit_tests = 
{
   { 'a',      { 'a'   } },
   { 'ab',     { 'ab'  } },
   { 'a1',     { 'a', '1' } },
   { 'a12',    { 'a', '12' } },
   { 'a12b',   { 'a', '12', 'b' } },
   { 'a12bc3', { 'a', '12', 'bc', '3' } },
   { '1'     , { '1' } },
   { '12b',    { '12', 'b' } },
   { '1.2b',   { '1' , '.', '2', 'b' } },
}


Test_nsplit = {}

for i, t in ipairs(nsplit_tests) do
   Test_nsplit['test_' .. t[1]] = function()
      local a = nsplit(t[1])
      local e = t[2]
      assertEquals(a, e) 
   end 
end


return LuaUnit:run()

