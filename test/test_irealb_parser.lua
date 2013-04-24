#! /usr/bin/lua

package.path = './?/?.lua;' .. package.path
require('luaunit')
local serpent = require('serpent')

local irealb = require('irealb_parser')

local fn = 'test/files/jazz-1-irealbook.url'
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

--[[
function Test_irealb_staff:test_1_bar_simple()
   local s = "|G C Z"
   local err, staff = irealb.song_parse(s)
   print(serpent.block(staff))
   assertEquals(staff[1], s)
   assertEquals(staff[2][1].text, '|')
   assertEquals(staff[2][2], 'G C ')
   assertEquals(staff[2][3], 'Z')
end

function Test_irealb_staff:test_1_bar_repeat()
   local s = "{G C }"
   local err, staff = irealb.song_parse(s)
   assertEquals(staff[1], s)
   assertEquals(staff[2][1], '{')
   assertEquals(staff[2][2], 'G C ')
   assertEquals(staff[2][3], '}')
end

function Test_irealb_staff:test_2_bar_repeat()
   local s = "{D G |C   }"
   local err, staff = irealb.song_parse(s)
   assertEquals(staff[1], s)
   assertEquals(staff[2][1], '{')
   assertEquals(staff[2][2], 'D G ')
   assertEquals(staff[2][3], '|')
   assertEquals(staff[2][4], 'C   ')
   assertEquals(staff[2][5], '}')
end

function Test_irealb_staff:test_4_bar_repeat()
   local s = "{D G |C   }{G C |G   }"
   local err, staff = irealb.song_parse(s)
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
   local err, staff = irealb.song_parse(s)
   assertEquals(staff[1], s)
   assertEquals(staff[2][1], '*a')
   assertEquals(staff[2][2], '|')
   assertEquals(staff[2][3], 'G C ')
   assertEquals(staff[2][4], 'Z')
end

function Test_irealb_staff:test_1_bar_simple_trailing_space_content()
   local s = "|G C Z "
   local err, staff = irealb.song_parse(s)
   print(serpent.block(staff))
   assertEquals(staff[1], s)
   assertEquals(staff[2][1], '|')
   assertEquals(staff[2][2], 'G C ')
   assertEquals(staff[2][3], 'Z')
end

--]]


if true then
Test_parse_irealb_corpus = {}

for i, song in ipairs(book) do
--    print(i, song.composer, song.title)
   Test_parse_irealb_corpus['test_' .. string.format("%03d", i)] = function()
      assertNotEquals(song.composer, '')
      assertNotEquals(song.title, '')
      assertNotEquals(song.style, '')
      assertNotEquals(song.key, '')
      assertNotEquals(song.tune.text, '')
      
--      print(song.tune.text)
      err, tune_text, tune = irealb.song_parse(song.tune.text)
--      print(serpent.block(song.tune))
--      print(serpent.block(tune))
      r = ''
      for _, element in ipairs(tune) do
         r = r .. element.text
      end
      assertEquals(r, song.tune.text)
      assertEquals(tune_text, song.tune.text)
   end
end

end

return LuaUnit:run()

