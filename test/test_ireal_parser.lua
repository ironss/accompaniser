#! /usr/bin/lua

require('luaunit')
local serpent = require('serpent')
local irealb = require('irealb')

local fn = 'test/files/jazz-1.url'
local f = io.open(fn)
local s = f:read('*a')
local err, book = irealb.url_parse(s)


Test_irealb = {}

function Test_irealb:test_1_number_of_songs()
   assertEquals(#book, 300)
end

function Test_irealb:test_2_book_title()
   assertEquals(book.title, "Jazz - 1 of 4\n")
end

Test_irealb_staff = {}

function Test_irealb_staff:test_1_1_bar_simple()
   local s = "|G C Z"
   local err, staff = irealb.staff_parse(s)
   assertEquals(staff[1], s)
   assertEquals(staff[2][1], '|')
   assertEquals(staff[2][2], 'G C ')
   assertEquals(staff[2][3], 'Z')
end

function Test_irealb_staff:test_2_1_bar_repeat()
   local s = "{G C }"
   local err, staff = irealb.staff_parse(s)
   assertEquals(staff[1], s)
   assertEquals(staff[2][1], '{')
   assertEquals(staff[2][2], 'G C ')
   assertEquals(staff[2][3], '}')
end

function Test_irealb_staff:test_3_2_bar_repeat()
   local s = "{D G |C   }"
   local err, staff = irealb.staff_parse(s)
   assertEquals(staff[1], s)
   assertEquals(staff[2][1], '{')
   assertEquals(staff[2][2], 'D G ')
   assertEquals(staff[2][3], '|')
   assertEquals(staff[2][4], 'C   ')
   assertEquals(staff[2][5], '}')
end

function Test_irealb_staff:test_4_4_bar_repeat()
   local s = "{D G |C   }{G C |G   }"
   local err, staff = irealb.staff_parse(s)
   print(serpent.block(staff))
   assertEquals(staff[1], s)
   assertEquals(staff[2][1], '{')
   assertEquals(staff[2][2], 'D G ')
   assertEquals(staff[2][3], '|')
   assertEquals(staff[2][4], 'C   ')
   assertEquals(staff[2][5], '}')
   assertEquals(staff[2][6], '{')
   assertEquals(staff[2][7], 'G C ')
   assertEquals(staff[2][8], '|')
   assertEquals(staff[2][9], 'G   ')
   assertEquals(staff[2][10], '}')
end

function Test_irealb_staff:test_9_1_bar_simple_initial_content()
   local s = "*a|G C Z"
   local err, staff = irealb.staff_parse(s)
   assertEquals(staff[1], s)
   assertEquals(staff[2][1], '*a')
   assertEquals(staff[2][2], '|')
   assertEquals(staff[2][3], 'G C ')
   assertEquals(staff[2][4], 'Z')
end


Test_irealb_songbooks = {}


for i, v in ipairs(book) do
--   print(i, v.composer, v.title)
   Test_irealb_songbooks['test_' .. i] = function()
      assertNotEquals(v.composer, '')
      assertNotEquals(v.title, '')
      assertNotEquals(v.style, '')
      assertNotEquals(v.key, '')
      assertNotEquals(v.staff, '')
      
--      print(v.staff.text)
      err, staff = irealb.staff_parse(v.staff.text)
      print(serpent.block(v.staff))
      print(serpent.block(staff))
--      assertNotEquals(staff, nil)
--      assertEquals(staff[#staff], 'Z')
   end
end

return LuaUnit:run()

