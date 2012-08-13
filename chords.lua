#! /usr/bin/lua

local M = {}

re = require('re')
local name_grammar = re.compile(
[[
   chord <- { root_note name !.}  -> {}
   
   name <- {:name: quality ? :} -> {}
   quality <- 'M' / 'maj' / 'min' / 'aug' / 'dim' / 'm' / '+' / '-' / 'o' / '0' / 'dom'
   root_note <- {:note: [ABCDEFG] sharp_or_flat? :} -> {}
   sharp_or_flat <- 'b' / '#'
]])

local chords = {
   ['']    = { 0, 4, 7 },
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
   ['C'] = 60,
   ['D'] = 62,
   ['E'] = 64,
   ['F'] = 65,
   ['G'] = 67,
   ['A'] = 69,
   ['B'] = 71,
}


local function make_chord(name, octave)
   root = string.sub(name, 1, 1)
end

M.chords = chords
M.parse = function(name) return re.find(name, name_grammar) end

return M

