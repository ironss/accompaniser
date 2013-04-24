#! /usr/bin/lua

package.path = './?/?.lua;' .. package.path
require('luaunit')
local serpent = require('serpent')
local function stringify(t) return serpent.line(t, {comment=false} ) end

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


Test_irealb_tune = {}

function Test_irealb_tune:test_1_bar_simple()
   local s = "|G C Z"
   local expected = {{pos=1, text="|", elem='barline'}, {pos=2, text="G", elem='chord'}, {pos=3, text=" ", elem='space'}, {pos=4, text="C", elem='chord'}, {pos=5, text=" ", elem='space'}, {pos=6, text = "Z", elem='end'}}
   local err, tune_text, tune = irealb.song_parse(s)

   assertEquals(tune_text, s)
   assertEquals(stringify(tune), stringify(expected))
end

function Test_irealb_tune:test_1_bar_repeat()
   local s = "{GC}"
   local expected = {{pos=1, text='{', elem='barline'}, {pos=2, text='G', elem='chord'}, {pos=3, text='C', elem='chord'}, {pos=4, text='}', elem='barline'}}
   local err, text, tune = irealb.song_parse(s)
   assertEquals(text, s)
   assertEquals(stringify(tune), stringify(expected))
end


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

