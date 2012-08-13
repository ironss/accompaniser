#! /usr/bin/env luajit


local chords = require('chords')


local sequence = 
{
   time_signature = { 4, 4 },
   key = 'C',
   tempo = 60,
   style = 'Medium Swing',
   {
      { 1, 'Am7' },
   },
   {
      { 1, 'Dm7' },
   },
   {
      { 1, 'G7'  },
   },
   {
      { 1, 'CM7' },
      { 3, 'C7'  },
   },
   {
      { 1, 'FM7' },
   },
}

local synth = require('synth-fluid')
s = synth.new_synth()
synth.set_sequence(s, sequence)
synth.start(s, true)
 
print('Press Enter to end')
l = io.read('*l')

