#! /usr/bin/lua

package.path = './?/?.lua;' .. package.path

require('luaunit')
local serpent = require('serpent')
local re = require('re')

local tune_parser = re.compile([[
tune <- ( <element> * ) -> {} .*

element <- { <barline> 
           / <label> 
           / <timesig> 
           / <chord>
           / <altchord>
           / <space> 
           / <repeatbar> 
           / <ending> 
           / <end>
           / <comment>
           / <unknown>
           }

barline <- '[' / ']' / '{' / '}' / '|'

label <- '*' <char>
char <- [%l%u]

timesig <- 'T' <digit> <digit>
digit <- %d

chord <- <note> <modifier>? <rootnote>?
altchord <- '(' <chord> ')'

note <- ([ABCDEFG] [#b]?)
modifier <- [-+^ho]? [679]? ( [#b] [579] )?
rootnote <- '/' <note>

comment <- '<' [^>]* '>'
ending <- 'N' [123]

space <- ' ' / ','
repeatbar <- 'x'
end <- 'Z' / 'z'

unknown <- 'Y' / 's' / 'l' / 'Q'
]])



local M = {}

M.url_parse = function(s) return re.find(url_decode(s), irealb_parser) end
M.parse = function(s) return re.find(s, irealb_parser) end
M.tune_parse = function(s) return re.match(s, tune_parser) end



local fn = 'test/files/jazz-1.tunes.txt'
local f = io.open(fn)

for l in f:lines() do
   a, b, c = M.tune_parse(l, staff_parser)
   s = table.concat(a)
   if s ~= l then
      print(serpent.block(a))
		print(s)   
   end
   print(l)
   print()
end










Test_irealb = {}

function Test_irealb:test_1_number_of_songs()
   assertEquals(#book, 300)
end

function Test_irealb:test_2_book_title()
   assertEquals(book.title, "Jazz - 1 of 4\n")
end

Test_irealb_staff = {}

function Test_irealb_staff:test_1_bar_simple()
   local s = "|G C Z"
   local err, staff = irealb.staff_parse(s)
   assertEquals(staff[1], s)
   assertEquals(staff[2][1], '|')
   assertEquals(staff[2][2], 'G C ')
   assertEquals(staff[2][3], 'Z')
end

function Test_irealb_staff:test_1_bar_repeat()
   local s = "{G C }"
   local err, staff = irealb.staff_parse(s)
   assertEquals(staff[1], s)
   assertEquals(staff[2][1], '{')
   assertEquals(staff[2][2], 'G C ')
   assertEquals(staff[2][3], '}')
end

function Test_irealb_staff:test_2_bar_repeat()
   local s = "{D G |C   }"
   local err, staff = irealb.staff_parse(s)
   assertEquals(staff[1], s)
   assertEquals(staff[2][1], '{')
   assertEquals(staff[2][2], 'D G ')
   assertEquals(staff[2][3], '|')
   assertEquals(staff[2][4], 'C   ')
   assertEquals(staff[2][5], '}')
end

function Test_irealb_staff:test_4_bar_repeat()
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

function Test_irealb_staff:test_1_bar_simple_initial_content()
   local s = "*a|G C Z"
   local err, staff = irealb.staff_parse(s)
   assertEquals(staff[1], s)
   assertEquals(staff[2][1], '*a')
   assertEquals(staff[2][2], '|')
   assertEquals(staff[2][3], 'G C ')
   assertEquals(staff[2][4], 'Z')
end

function Test_irealb_staff:test_1_bar_simple_trailing_space_content()
   local s = "|G C Z "
   local err, staff = irealb.staff_parse(s)
   print(serpent.block(staff))
   assertEquals(staff[1], s)
   assertEquals(staff[2][1], '|')
   assertEquals(staff[2][2], 'G C ')
   assertEquals(staff[2][3], 'Z')
end


if false then
Test_irealb_songbooks = {}


for i, v in ipairs(book) do
--   print(i, v.composer, v.title)
   Test_irealb_songbooks['test_' .. i] = function()
      assertNotEquals(v.composer, '')
      assertNotEquals(v.title, '')
      assertNotEquals(v.style, '')
      assertNotEquals(v.key, '')
      assertNotEquals(v.staff.text, '')
      
      print(v.staff.text)
      err, staff = irealb.staff_parse(v.staff.text)
      print(serpent.block(v.staff))
      print(serpent.block(staff))
--      assertNotEquals(staff, nil)
      assertEquals(staff[2][#staff[2]], string.sub(v.staff.text, -1, -1))
   end
end

end

return --LuaUnit:run()

