#! /usr/bin/env luajit

-- Copyright (c) 2013 Stephen Irons 
-- License included at end of file

local fluid = require('fluidsynth')
local chords = require('chords')
local serpent = require('serpent')

local soundfont = '/usr/share/sounds/sf2/FluidR3_GM.sf2'
local audio_driver = 'pulseaudio'


local function schedule_callback(s, time)
   local ev = fluid.new_event()
   fluid.event_set_source(ev, -1)
--   print(ev, s.sched_client_id)
   fluid.event_set_dest(ev, s.sched_client_id)
   fluid.event_timer(ev, nil)
   local result = fluid.sequencer_send_at(s.sequencer, ev, time, 1)
end

local function schedule_noteon(time, channel, note, velocity)
   local ev = fluid.new_event()
   fluid.event_set_source(ev, -1)
   fluid.event_set_dest(ev, s.synth_client_id)
   fluid.event_noteon(ev, channel-1, note, velocity)
   local result = fluid.sequencer_send_at(s.sequencer, ev, time, 1)
end

local function schedule_bar(s)
   local sequence = s.selected_sequence
   local current_bar = s.current_bar
   local bar = sequence[current_bar]
   local beats = sequence[current_bar].beats or sequence.time_signature[1] or 4
   
   local tempo = bar.tempo or sequence.tempo or 60
   local beat_duration = 60/tempo * 1000
   
   for _, chord in ipairs(bar) do
      local chord_sum = 0
      for _, tone in ipairs(chord.tones) do
         chord_sum = chord_sum + tone
      end
      
      print(chord_sum, s.last_chord_sum)
      print(serpent.block(chord.tones))
      if s.last_chord_sum ~= nil then
         local diff = chord_sum - s.last_chord_sum
         if diff > 12 then
            chord.tones[#chord.tones] = chord.tones[#chord.tones] - 12
            chord_sum = chord_sum - 12
         elseif diff < -12 then
            chord.tones[1] = chord.tones[1] + 12
            chord_sum = chord_sum + 12
         end
      end
      print(chord_sum, s.last_chord_sum)
      print(serpent.block(chord.tones))
      s.last_chord_sum = chord_sum

      for _, tone in ipairs(chord.tones) do
         local t = s.now + chord[1] * beat_duration
         local channel = 1
         local velocity = 127
         schedule_noteon(t, channel, tone, velocity)
      end
      
   end
   
   
   
   local chords = tostring(current_bar)
   for _, chord in ipairs(bar) do
      chords = chords .. ' ' .. chord[2]
   end
   print(chords)
   
   for b = 1, beats do
         local t = s.now + b * beat_duration
         local channel = 10
         local note = 75
         local velocity = 127
         schedule_noteon(t, channel, note, velocity)
   end
   
   s.current_bar = s.current_bar + 1
   if s.current_bar > #sequence then
      s.repeat_count = s.repeat_count + 1
      s.current_bar = 1
      print(s.repeat_count, s.nrepeats)
      if not s.nrepeats and s.repeat_count > s.nrepeats then
         s.stop_now = true
      end
   end

   if s.stop_now == false then
      schedule_callback(s, s.now + beats * beat_duration)
      s.now = s.now + beats * beat_duration
   end
end


local callback = function(time, ev, seq, data)
   --print('**', a, b, c, d)
   s = global_sequencer
   schedule_bar(s)
end

ffi=require('ffi')

local function new_synth(audio_driver, soundfont)
   local s = {}

   print(ffi.cast('void *', 0))
   print(s)
--   print(ffi.cast('void *', s))
   
   
   s.audio_driver = audio_driver or 'pulseaudio'
   s.soundfont = soundfont or '/usr/share/sounds/sf2/FluidR3_GM.sf2'
   
   s.settings = fluid.new_settings()
   fluid.settings_setstr(s.settings, 'audio.driver', s.audio_driver)
   s.synth = fluid.new_synth(s.settings)
   s.audiodriver = fluid.new_audio_driver(s.settings, s.synth)
   s.sequencer = fluid.new_sequencer2(0)
   s.synth_client_id = fluid.sequencer_register_fluidsynth(s.sequencer, s.synth)
   s.sched_client_id = fluid.sequencer_register_client(s.sequencer, 'me', callback, nil)
   s.sfid = fluid.synth_sfload(s.synth, s.soundfont, true)
   
   return s
end


local function set_sequence(s, sequence)
   s.selected_sequence = sequence
   global_sequencer = s

   for _, bar in ipairs(sequence) do
      for _, c in ipairs(bar) do
         c.tones = chords.make_chord(c[2])
         --print(serpent.block(c))
      end
   end
end

local function start(s, repeats)
   s.nrepeats = repeats or 3
   s.repeat_count = 1
   s.current_bar = 1
   s.stop_now = false
   
   s.now = fluid.sequencer_get_tick(s.sequencer)
   schedule_bar(s)
end

local function stop(s)
   s.stop_now = true
end


local M = {}

M.new_synth = new_synth
M.set_sequence = set_sequence
M.start = start
M.stop = stop

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

