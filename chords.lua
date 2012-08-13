#! /usr/bin/lua

local M = {}

re = require('re')
local name_grammar = re.compile(
[[
   chord <- { root_note name !.}  -> {}
   
   root_note <- {:note: (note_name sharp_or_flat ?) / numeral :} -> {}
   note_name <- [ABCDEFG]
   sharp_or_flat <- 'b' / '#'
   numeral <- 'VII' / 'VI' / 'V' / 'IV' / 'III' / 'II' / 'I'

   name <- {:chord: quality ? addition ? :} -> {}
   quality <- 'M' / 'maj' / 'min' / 'aug' / 'dim' / 'm' / '+' / '-' / 'o' / '0' / 'dom'
   addition <- seventh
   seventh <- '7' / 'M7'
]])

local chord_tones_by_name = {
   ['']    = { 0, 4, 7 },
   ['M']   = { 0, 4, 7 },
   ['m']   = { 0, 3, 7 },
   ['-']   = { 0, 3, 7 },
   ['+']   = { 0, 4, 8 },
   ['o']   = { 0, 3, 6 },
   
   ['7']   = { 0, 4, 7, 10 },
   ['M7']  = { 0, 4, 7, 11 },
   ['mM7'] = { 0, 3, 7, 11 },
   ['m7']  = { 0, 3, 7, 10 },
   ['+M7'] = { 0, 4, 8, 11 },
   ['+7']  = { 0, 4, 8, 10 },
   ['07']  = { 0, 3, 6, 10 },
   ['o7']  = { 0, 3, 6, 9  },
   ['7b5'] = { 0, 4, 6, 10 },
}

local midi_name = 
{
   ['C']  = 60,
   ['C#'] = 61,
   ['Db'] = 61,
   ['D']  = 62,
   ['E']  = 64,
   ['F']  = 65,
   ['G']  = 67,
   ['A']  = 69,
   ['B']  = 71,
}

local function name_parse(name)
   return re.find(name, name_grammar)
end

serpent=require('serpent')
local function make_chord(name, octave)
   local octave = octave or 4
   local err, chord = name_parse(name)
   --print(serpent.block(chord))
   local root = chord[2].note
   local name = chord[3].chord
   --print(root, name)
   local tones = chord_tones_by_name[name]
   local octave_offset = (octave+1) * 12
   for i = 1, #tones do
       tones[i] = tones[i] + octave_offset
    end
   --print(serpent.block(tones))
   return tones
end

M.chords = chords
M.parse = name_parse
M.make_chord = make_chord

return M

