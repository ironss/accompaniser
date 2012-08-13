#! /usr/bin/lua

require('luaunit')
local serpent = require('serpent')

chords = require('chords')


Test_chords = {}


function Test_chords:test_bad_note()
   local err, chord = chords.parse('H')
   assertEquals(chord, nil)
end

function Test_chords:test_bad_chord()
   local err, chord = chords.parse('C&')
   assertEquals(chord, nil)
end

local notes = 
{
   'C' , 'D' , 'E' , 'F' , 'G' , 'A' , 'B' ,
   'C#', 'D#', 'E#', 'F#', 'G#', 'A#', 'B#',
   'Cb', 'Db', 'Eb', 'Fb', 'Gb', 'Ab', 'Bb',
}

function Test_chords:test_notes()
   for _, n in ipairs(notes) do
      local err, chord = chords.parse(n)
      assertIsNotNil(err)
      --print(err, serpent.block(chord))
      assertEquals(chord[2].note, n)
   end
end


local numerals = 
{
   'I', 'II', 'III', 'IV', 'V', 'VI', 'VII',
}

function Test_chords:test_numerals()
   for _, n in ipairs(numerals) do
      local err, chord = chords.parse(n)
      --print(err, serpent.block(chord))
      assertEquals(chord[2].note, n)
   end
end

local qualities = 
{
   'C', 'CM', 'Cmaj', 'C-', 'Cm', 'Cmin',
   'Caug', 'Cdim', 'C+', 'Co', 'C0', 'Cdom',
}

function Test_chords:test_qualities()
   for _, q in ipairs(qualities) do
      local err, chord = chords.parse(q)
      --print(serpent.block(chord))
      assertEquals(chord[2].chord, n)
   end
end

local sevenths = 
{
   'C7', 'CM7', 'Cmaj7', 'CMM7', 
}

function Test_chords:test_sevenths()
   for _, a in ipairs(sevenths) do
      local err, chord = chords.parse(a)
      print(serpent.block(chord))
      assertEquals(chord[2].chord, n)
   end
end


local examples = 
{
   { 'C',    4, { 60, 64, 67 } },
   { 'Cm',   4, { 60, 63, 67 } },
}

function Test_chords:test_tones()
   for _, c in ipairs(examples) do
      local chord_tones = chords.make_chord(c[1], c[2])
      for i = 1, #c[3] do
         assertEquals(c[3][i], chord_tones[i])
      end
   end
end


return LuaUnit:run()

