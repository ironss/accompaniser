#! /usr/bin/env luajit

-- Copyright (c) 2013 Stephen Irons 
-- License included at end of file

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

