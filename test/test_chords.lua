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

local good_notes = 
{
   'C' , 'D' , 'E' , 'F' , 'G' , 'A' , 'B' ,
   'C#', 'D#', 'E#', 'F#', 'G#', 'A#', 'B#',
   'Cb', 'Db', 'Eb', 'Fb', 'Gb', 'Ab', 'Bb',
}

function Test_chords:test_notes()
   for _, n in ipairs(good_notes) do
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
      assertEquals(chord[2].q, n)
   end
end


return LuaUnit:run()

