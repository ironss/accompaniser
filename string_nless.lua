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

local re = require 're'
local pattern = re.compile([[
   t <- s -> {}
   s <- <word> <num> s? / <num> s? / <word> 
   word <- { %D+ }
   num  <- { %d+ }
]])

local function string_nsplit(s)
   local n, t, a, b, c = re.find(s, pattern)
   return t
end

local function string_nless(a, b)
   local at = string_nsplit(a)
   local bt = string_nsplit(b)
   
   for i = 1, math.min(#at, #bt) do
--      print(at[i], bt[i])
      if string_nless_(at[i], bt[i]) then
         return true
      end
   end
   return false
end

M.string_nsplit = string_nsplit
M.string_nless = string_nless

return M

