#! /usr/bin/lua

-- Copyright (c) 2013 Stephen Irons 
-- License included at end of file

package.path = './?/?.lua;' .. package.path
require('luaunit')
local serpent = require('serpent')

chords = require('chords')


Test_chords = {}


function Test_chords:test_bad_note()
   local chord = chords.parse('H')
   assertIsNil(chord)
end

function Test_chords:test_bad_chord()
   local chord = chords.parse('C&')
   assertIsNil(chord)
end

local notes = 
{
   'C' , 'D' , 'E' , 'F' , 'G' , 'A' , 'B' ,
   'C#', 'D#', 'E#', 'F#', 'G#', 'A#', 'B#',
   'Cb', 'Db', 'Eb', 'Fb', 'Gb', 'Ab', 'Bb',
}

function Test_chords:test_notes()
   for _, n in ipairs(notes) do
      local chord = chords.parse(n)
      assertIsNotNil(chord)
      assertEquals(chord.note, n)
   end
end


local numerals = 
{
   'I', 'II', 'III', 'IV', 'V', 'VI', 'VII',
}

function Test_chords:test_numerals()
   for _, n in ipairs(numerals) do
      local chord = chords.parse(n)
      assertIsNotNil(chord)
      assertEquals(chord.note, n)
   end
end

local qualities = 
{
   'C', 'CM', 'Cmaj', 'C-', 'Cm', 'Cmin',
   'Caug', 'Cdim', 'C+', 'Co', 'C0', 'Cdom',
}

function Test_chords:test_qualities()
   for _, q in ipairs(qualities) do
      local chord = chords.parse(q)
      assertIsNotNil(chord)
      --print(serpent.block(chord))
      assertEquals(chord.chord, string.sub(q, 2))
   end
end

local sevenths = 
{
   'C7', 'CM7', 'Cmaj7', 'CMM7',
   'Cm7',
}

function Test_chords:test_sevenths()
   for _, a in ipairs(sevenths) do
      local chord = chords.parse(a)
      assertIsNotNil(chord)
      assertEquals(chord.chord, string.sub(a, 2))
   end
end


local examples = 
{
   { 'C',    4, { 60, 64, 67 } },
   { 'Cm',   4, { 60, 63, 67 } },
   { 'D',    4, { 62, 66, 69 } },
   { 'C6',   4, { 60, 64, 67, 69 } },
}

function Test_chords:test_tones()
   for _, c in ipairs(examples) do
      local chord_tones = chords.make_chord(c[1], c[2])
      assertIsNotNil(chord_tones)

      for i = 1, #c[3] do
         assertEquals(chord_tones[i], c[3][i])
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

