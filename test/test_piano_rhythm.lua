#! /usr/bin/env luajit

print(package.path)
print(package.cpath)

package.path = package.path .. ';/usr/share/lua/5.1/?.lua'
package.cpath = package.cpath .. ';/usr/lib/x86_64-linux-gnu/lua/5.1/?.so'


local chords = require('chords')


local sequence = 
{
   name = 'Fly Me To The Moon',
   composer = 'Bart Howard',
   time_signature = { 4, 4 },
   key = 'C',
   tempo = 100,
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
   {
      { 1, 'Bm7' },
   },
   {
      { 1, 'E7' },
   },
   {
      { 1, 'Am7' },
      { 3, 'A7' },
   },
   {
      { 1, 'Dm7' },
   },
   {
      { 1, 'G7'  },
   },
   {
      { 1, 'CM7' },
   },
   {
      { 1, 'Em7' },
      { 3, 'A7' },
   },
   {
      { 1, 'Dm7' },
   },
   {
      { 1, 'G7'  },
   },
   {
      { 1, 'CM7' },
   },
   {
      { 1, 'Bm7'  },
      { 3, 'E7' },
   },
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
   {
      { 1, 'Bm7' },
   },
   {
      { 1, 'E7' },
   },
   {
      { 1, 'Am7' },
      { 3, 'A7' },
   },
   {
      { 1, 'Dm7' },
   },
   {
      { 1, 'G7'  },
   },
   {
      { 1, 'Em7' },
   },
   {
      { 1, 'A7'  },
   },
   {
      { 1, 'Dm7' },
   },
   {
      { 1, 'G7'  },
   },
   {
      { 1, 'C6' },
   },
   {
      { 1, 'Bm7b5' },
      { 3, 'E7' },
   },
}

local synth = require('synth-fluid')
s = synth.new_synth()
synth.set_sequence(s, sequence)
synth.start(s, nil)
 
print('Press Enter to end')
l = io.read('*l')

