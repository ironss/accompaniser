-- Copyright (c) 2013 Stephen Irons 
-- License included at end of file

local M = {}

re = require('re')
local name_grammar = re.compile([[
   chord <- ( root_note chord_name !. )  -> {}
   
   root_note <- {:note: (note_name sharp_or_flat ?) / numeral :}
   note_name <- [ABCDEFG]
   sharp_or_flat <- 'b' / '#'
   numeral <- 'VII' / 'VI' / 'V' / 'IV' / 'III' / 'II' / 'I'

   chord_name <- {:chord: quality ? addition ? :}
   quality <- 'M' / 'maj' / 'min' / 'aug' / 'dim' / 'm' / '+' / '-' / 'o' / '0' / 'dom'
   addition <- seventh
   seventh <- '7b5' / '7' / 'M7' / '6'
]])

local chord_tones_by_name = {
   ['']     = { 0, 4, 7 },
   ['maj']  = { 0, 4, 7 },
   ['M']    = { 0, 4, 7 },
   ['min']  = { 0, 3, 7 },
   ['m']    = { 0, 3, 7 },
   ['-']    = { 0, 3, 7 },
   ['+']    = { 0, 4, 8 },
   ['o']    = { 0, 3, 6 },
   
   ['7']    = { 0, 4, 7, 10 },
   ['M7']   = { 0, 4, 7, 11 },
   ['mM7']  = { 0, 3, 7, 11 },
   ['m7']   = { 0, 3, 7, 10 },
   ['+M7']  = { 0, 4, 8, 11 },
   ['+7']   = { 0, 4, 8, 10 },
   ['07']   = { 0, 3, 6, 10 },
   ['m7b5'] = { 0, 3, 6, 10 },
   ['o7']   = { 0, 3, 6, 9  },
   ['7b5']  = { 0, 4, 6, 10 },
   ['6']    = { 0, 4, 7, 9  },
}

local midi_name = 
{
   ['C']  =  0,
   ['C#'] =  1,
   ['Db'] =  1,
   ['D']  =  2,
   ['E']  =  4,
   ['F']  =  5,
   ['G']  =  7,
   ['A']  =  9,
   ['B']  = 11,
}

serpent=require('serpent')
local function name_parse(name)
   local n, result = re.find(name, name_grammar)
   --print(serpent.block(result))
   return result
end

-- Retrieve the chord tones, given a chord name
local function make_chord(name, octave)
   local octave = octave or 4
   local chord = name_parse(name)
   local note = chord.note
   local chord_name = chord.chord
   local tones = chord_tones_by_name[chord_name]
   local note_offset = midi_name[note]
   local octave_offset = (octave+1) * 12
   t = {}
   for i = 1, #tones do
       t[i] = tones[i] + note_offset + octave_offset
    end
   return t
end

M.chords = chords
M.parse = name_parse
M.make_chord = make_chord

return M

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

