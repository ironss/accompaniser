#! /usr/bin/lua

-- Copyright (c) 2013 Stephen Irons 
-- License included at end of file

package.path = './?/?.lua;' .. package.path
require('luaunit')
local serpent = require('serpent')
local function stringify(t) return serpent.line(t, {comment=false} ) end

local irealb = require('irealb_parser')


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



Test_irealb_obfusc = {}

function Test_irealb_obfusc:test_obfusc_050()
   local tune     = '[T44A BLZC DLZE FLZG, ALZA BLZC DLZE FLZG ALZA B | '
   local expected = '[T44A BLZC DLZE FLZG, ALZA BLZC DLZE FLZG ALZA B | '
   local actual = irealb.unobfusc(tune)
   assertEquals(actual, expected)
end

function Test_irealb_obfusc:test_obfusc_051()
   local tune     = '| B A BLZCZLF EZLD CZLB ZALA ,GZLF EZLD G ALZA44T[C '
   local expected = '[T44A BLZC DLZE FLZG, ALZA BLZC DLZE FLZG ALZA B |C '
   local actual = irealb.unobfusc(tune)
   assertEquals(actual, expected)
end

function Test_irealb_obfusc:test_obfusc_100()
   local tune     = 'ZLB A BLZCZLF EZLD CZLB ZALA ,GZLF EZLD G ALZA44T[C- DLZE FLZG A,LZA BLZC DLZE FLZG ALZA BLZC- D |E '
   local expected = '[T44A BLZC DLZE FLZG, ALZA BLZC DLZE FLZG ALZA BLZC- DLZE FLZG A,LZA BLZC DLZE FLZG ALZA BLZC- D |E '
   local actual = irealb.unobfusc(tune)
   assertEquals(actual, expected)
end

function Test_irealb_obfusc:test_obfusc_101()
   local tune     = 'ZLB A BLZCZLF EZLD CZLB ZALA ,GZLF EZLD G ALZA44T[ EZLDZE FLB AZLA GZLF EZDL CZLB AZL,A GZLZC- LD -CF '
   local expected = '[T44A BLZC DLZE FLZG, ALZA BLZC DLZE FLZG ALZA BLZC- DLZE FLZG A,LZA BLZC DLZE FLZG ALZA BLZC- DLZE F '
   local actual = irealb.unobfusc(tune)
   assertEquals(actual, expected)
end


local fn = 'test/files/jazz-1-irealbook.url'
local f = io.open(fn)
local s = f:read('*a')
local err, book = irealb.url_parse(s)
--print(serpent.block(book))

if true then
	Test_irealbook = {}

	function Test_irealbook:test_1_number_of_songs()
		assertEquals(#book, 300)
	end

	function Test_irealbook:test_2_book_params()
		assertEquals(book.title, "Jazz - 1 of 4\n")
		assertEquals(book.scheme, "irealbook")
	end
end

if true then
	Test_parse_irealbook_corpus = {}

	for i, song in ipairs(book) do
	--    print(i, song.composer, song.title)
		Test_parse_irealbook_corpus['test_' .. string.format("%03d", i)] = function()
		   assertNotEquals(song.composer, '')
        assertNotEquals(song.title, '')
	      assertNotEquals(song.style, '')
	      assertNotEquals(song.key, '')
	      assertNotEquals(song.tune.raw, '')
		   
		   if song.tune.key ~= nil then
		      song.tune.text = irealb.unobfusc(song.tune.raw, song.tune.key)
		   end

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


local fn = 'test/files/jazz-1-irealb.url'
local f = io.open(fn)
local s = f:read('*a')
local err, book = irealb.url_parse(s)
--print(url_decode(s))

if true then
	Test_irealb = {}

	function Test_irealb:test_1_number_of_songs()
		assertEquals(#book, 325)
	end

	function Test_irealb:test_2_book_params()
		assertEquals(book.title, "Jazz 1 of 4\n")
		assertEquals(book.scheme, "irealb")
	end
end

if true then
	Test_parse_irealb_corpus = {}

	for i, song in ipairs(book) do
	--    print(i, song.composer, song.title)
		Test_parse_irealb_corpus['test_' .. string.format("%03d", i)] = function()
		   assertNotEquals(song.composer, '')
	--      assertNotEquals(song.title, '')
	--      assertNotEquals(song.style, '')
	--      assertNotEquals(song.key, '')
	--      assertNotEquals(song.tune.raw, '')
		   
		   if song.tune.key ~= nil then
		      song.tune.text = irealb.unobfusc(song.tune.raw, song.tune.key)
		   end

--	      print(song.tune.raw)
--	      print(song.tune.text)
         err, tune_text, tune = irealb.song_parse(song.tune.text)
--      print(serpent.block(song))
--	      print(serpent.block(tune))
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

-- Copyright (C) 2013 Stephen Irons
-- 
-- Permission is hereby granted, free of charge, to any person
-- obtaining a copy of this software and associated documentation
-- files (the "Software"), to deal in the Software without
-- restriction, including without limitation the rights to use,
-- copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the
-- Software is furnished to do so, subject to the following
-- conditions:
-- 
-- The above copyright notice and this permission notice shall be
-- included in all copies or substantial portions of the Software.
-- 
-- The software is provided "as is", without warranty of any kind,
-- express or implied, including but not limited to the warranties
-- of merchantability, fitness for a particular purpose and
-- noninfringement. In no event shall the authors or copyright
-- holder be liable for any claim, damages or other liability,
-- whether in an action of contract, tort or otherwise, arising
-- from, out of or in connection with the software or the use or
-- other dealings in the software.

