#! /usr/bin/env lua

require('luaunit')


irealb = require('irealb')

local fn = 'test/files/jazz-1.url'
local f = io.open(fn)
local s = f:read('*a')
local err, book = irealb.url_parse(s)

for i, v in ipairs(book) do
   --print(i, v.composer, v.title, v.staff.text)
   --a, b = re.find(v.staff.text, staff_parser)
   --print(a, serpent.block(b))
end


Test_irealb = {}

function Test_irealb:test_1_number_of_songs()
   assertEquals(#book, 300)
end

function Test_irealb:test_2_book_title()
   assertEquals(book.title, "Jazz - 1 of 4\n")
end


Test_irealb_songs = {}

for i, v in ipairs(book) do
--   print(i, v.composer, v.title)
   Test_irealb_songs['test_' .. i] = function()
      assertNotEquals(v.composer, '')
      assertNotEquals(v.title, '')
      assertNotEquals(v.staff, '')
   end
end


return LuaUnit:run()

