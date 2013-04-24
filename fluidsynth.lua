-- Copyright (c) 2013 Stephen Irons 
-- License included at end of file

local ffi=require('ffi')

ffi.cdef[[
typedef struct _fluid_hashtable_t fluid_settings_t;             /**< Configuration settings instance */
typedef struct _fluid_synth_t fluid_synth_t;                    /**< Synthesizer instance */
typedef struct _fluid_synth_channel_info_t fluid_synth_channel_info_t;  /**< SoundFont channel info */
typedef struct _fluid_voice_t fluid_voice_t;                    /**< Synthesis voice instance */
typedef struct _fluid_sfloader_t fluid_sfloader_t;              /**< SoundFont loader plugin */
typedef struct _fluid_sfont_t fluid_sfont_t;                    /**< SoundFont */
typedef struct _fluid_preset_t fluid_preset_t;                  /**< SoundFont preset */
typedef struct _fluid_sample_t fluid_sample_t;                  /**< SoundFont sample */
typedef struct _fluid_mod_t fluid_mod_t;                        /**< SoundFont modulator */
typedef struct _fluid_audio_driver_t fluid_audio_driver_t;      /**< Audio driver instance */
typedef struct _fluid_file_renderer_t fluid_file_renderer_t;    /**< Audio file renderer instance */
typedef struct _fluid_player_t fluid_player_t;                  /**< MIDI player instance */
typedef struct _fluid_midi_event_t fluid_midi_event_t;          /**< MIDI event */
typedef struct _fluid_midi_driver_t fluid_midi_driver_t;        /**< MIDI driver instance */
typedef struct _fluid_midi_router_t fluid_midi_router_t;        /**< MIDI router instance */
typedef struct _fluid_midi_router_rule_t fluid_midi_router_rule_t;      /**< MIDI router rule */
typedef struct _fluid_hashtable_t fluid_cmd_handler_t;          /**< Command handler */
typedef struct _fluid_shell_t fluid_shell_t;                    /**< Command shell */
typedef struct _fluid_server_t fluid_server_t;                  /**< TCP/IP shell server instance */
typedef struct _fluid_event_t fluid_event_t;                    /**< Sequencer event */
typedef struct _fluid_sequencer_t fluid_sequencer_t;            /**< Sequencer instance */
typedef struct _fluid_ramsfont_t fluid_ramsfont_t;              /**< RAM SoundFont */
typedef struct _fluid_rampreset_t fluid_rampreset_t;            /**< RAM SoundFont preset */



fluid_settings_t* new_fluid_settings(void);
void delete_fluid_settings(fluid_settings_t* settings);
int fluid_settings_setstr(fluid_settings_t* settings, const char *name, const char *str);
int fluid_settings_getstr(fluid_settings_t* settings, const char *name, char** str);

int fluid_settings_setint(fluid_settings_t* settings, const char *name, int val);
int fluid_settings_getint(fluid_settings_t* settings, const char *name, int* val);
int fluid_settings_getint_default(fluid_settings_t* settings, const char *name);



fluid_synth_t* new_fluid_synth(fluid_settings_t* settings);
int fluid_synth_sfload(fluid_synth_t* synth, const char* filename, int reset_presets);
int fluid_synth_program_select(fluid_synth_t* synth, int chan, unsigned int sfont_id,
                               unsigned int bank_num, unsigned int preset_num);
int fluid_synth_noteon(fluid_synth_t* synth, int chan, int key, int vel);
int fluid_synth_noteoff(fluid_synth_t* synth, int chan, int key);
   
fluid_audio_driver_t* new_fluid_audio_driver(fluid_settings_t* settings, fluid_synth_t* synth);


typedef void (*fluid_event_callback_t)(unsigned int time, fluid_event_t* event, 
				      fluid_sequencer_t* seq, void* data);

fluid_sequencer_t* new_fluid_sequencer(void);
fluid_sequencer_t* new_fluid_sequencer2(int use_system_timer);
unsigned int fluid_sequencer_get_tick(fluid_sequencer_t* seq);
short fluid_sequencer_register_fluidsynth(fluid_sequencer_t* seq, fluid_synth_t* synth);
short fluid_sequencer_register_client(fluid_sequencer_t* seq, const char *name, 
				     fluid_event_callback_t callback, void* data);int fluid_sequencer_send_at(fluid_sequencer_t* seq, fluid_event_t* evt, 
			   unsigned int time, int absolute);

fluid_event_t* new_fluid_event(void);
void delete_fluid_event(fluid_event_t* evt);
void fluid_event_set_source(fluid_event_t* evt, short src);
void fluid_event_set_dest(fluid_event_t* evt, short dest);
void fluid_event_noteon(fluid_event_t* evt, int channel, short key, short vel);
void fluid_event_timer(fluid_event_t* evt, void* data);


]]



local paths = { '/usr/lib/i386-linux-gnu/libfluidsynth.so.1',
                '/usr/lib/libfluidsynth.so.1',
              }

local i = 0
local path
local success, fluid
repeat
   i = i + 1
   path = paths[i]
   success, fluid = pcall(ffi.load, path)
until success



local M = {}

M.new_settings = fluid.new_fluid_settings
M.delete_settings = fluid.delete_fluid_settings
M.settings_setstr = fluid.fluid_settings_setstr
M.settings_getstr = fluid.fluid_settings_getstr
M.settings_setint = fluid.fluid_settings_setint
M.settings_getint = fluid.fluid_settings_getint


M.new_synth = fluid.new_fluid_synth
M.synth_noteon = fluid.fluid_synth_noteon
M.synth_noteoff = fluid.fluid_synth_noteoff
M.synth_sfload = fluid.fluid_synth_sfload   
M.synth_program_select = fluid.fluid_synth_program_select

M.new_audio_driver = fluid.new_fluid_audio_driver


M.new_sequencer = fluid.new_fluid_sequencer
M.new_sequencer2 = fluid.new_fluid_sequencer2
M.sequencer_register_fluidsynth = fluid.fluid_sequencer_register_fluidsynth
M.sequencer_register_client = fluid.fluid_sequencer_register_client
M.sequencer_get_tick = fluid.fluid_sequencer_get_tick
M.sequencer_send_at = fluid.fluid_sequencer_send_at

M.new_event = fluid.new_fluid_event
M.event_set_source = fluid.fluid_event_set_source
M.event_set_dest = fluid.fluid_event_set_dest
M.event_noteon = fluid.fluid_event_noteon
M.event_timer = fluid.fluid_event_timer


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

