#! /usr/bin/env luajit

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


local function new_synth(audio_driver, soundfont)
   local s = {}
   
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

