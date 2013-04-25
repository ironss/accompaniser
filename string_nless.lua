-- String compare with proper handling of numbers.


-- Copyright (c) 2013 Stephen Irons 
-- License text at end of file


local M = {}

local function string_nless_(a, b)
   local an = tonumber(a)
   local bn = tonumber(b)
   if an ~= nil and bn~= nil then
      return an < bn
   else
      return a < b
   end
end

function M.string_nless(a, b)
   return string_nless_(a, b)
end

return M

