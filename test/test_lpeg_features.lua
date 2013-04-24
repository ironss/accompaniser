#! /usr/bin/lua

-- Copyright (c) 2013 Stephen Irons 
-- License included at end of file

package.path = './?/?.lua;' .. package.path

local re = require 're'
local serpent = require('serpent')

function stringify(t) return serpent.line(t, { comment=false }) end

require('luaunit')


parsers =
{ 
	{
		name = "parser1",
		parser = re.compile([[
			string <-  { <stuff> }
			stuff <- ( <nested> / <word> <nested>? )* -> {}
			word <- { %w+ }
			nonword <- %W*
			nested <- '(' <stuff> ')'
		]]),

		tests = 
		{
			{ '',                   {}                                             },
			{ 'a',                  { 'a' }                                        },
			{ 'abc',                { 'abc' }                                      },
			{ '(abc)',              { { 'abc' } }                                  },
			{ '((abc))',            { { { 'abc' } } }                              },
			{ 'abc(def)',           { 'abc', { 'def' } }                           },
			{ '(abc)def',           { { 'abc' }, 'def' }                           },
			{ 'abc(def)ghi',        { 'abc', { 'def' }, 'ghi' }                    },
			{ 'abc(def)(ghi)',      { 'abc', { 'def' }, { 'ghi' } }                },
			{ 'abc(def)(ghi)jkl',   { 'abc', { 'def' }, { 'ghi' }, 'jkl' }         },
			{ 'abc(def)ghi(jkl)',   { 'abc', { 'def' }, 'ghi', { 'jkl' } }         },
			{ 'abc(def(ghi)jkl)',   { 'abc', { 'def', { 'ghi' }, 'jkl' } }         },
		}
	},

	{
		name = "parser2",
		parser = re.compile([[
			string <-  { <stuff> }
			stuff <- ( <nested> / <wordc> <nested>? )* -> {}
			wordc <- ( <pos> {:t: <word> :} ) -> {}
			word <- %w+
			pos <- {:p: {} :}
			nonword <- %W*
			nested <- '(' <stuff> ')'
		]]),

		tests = 
		{
			{ '',                   {}                                                          },
			{ 'a',                  { { p=1, t='a' } }                                          },
			{ 'abc',                { { p=1, t='abc' } }                                        },
			{ '(abc)',              { { { p=2, t='abc' } } }                                    },
			{ '((abc))',            { { { { p=3, t='abc' } } } }                                },
			{ 'abc(def)',           { { p=1, t='abc'} , { { p=5, t='def' } } }                  },
			{ '(abc)def',           { { { p=2, t='abc' } }, { p=6, t='def' } }                  },
			{ 'abc(def)ghi',        { { p=1, t='abc'} , { {p=5, t='def' } }, { p=9, t='ghi' } } },
		--   { 'abc(def)(ghi)',      { 'abc', { 'def' }, { 'ghi' } }                },
		--   { 'abc(def)(ghi)jkl',   { 'abc', { 'def' }, { 'ghi' }, 'jkl' }         },
		--   { 'abc(def)ghi(jkl)',   { 'abc', { 'def' }, 'ghi', { 'jkl' } }         },
		--   { 'abc(def(ghi)jkl)',   { 'abc', { 'def', { 'ghi' }, 'jkl' } }         },
		}
	},

	{
		name = "parser3",
		parser = re.compile([[
			string <-  { <stuff> }
			stuff <- ( <nested> / <wordornumc> <nested>? )* -> {}
			wordornumc <- <wordornum> -> {}
			wordornum <- <wordcap> / <numcap>
			wordcap <- <pos> {:t: <word> :} {:x: ''-> 'w' :}
			numcap  <- <pos> {:t: <num> :} {:x: ''-> 'd'  :}
			word <- %l+
			num <- %d+
			pos <- {:p: {} :}
			nonword <- %W*
			nested <- '(' <stuff> ')'
		]]),

		tests = 
		{
			{ '',                   { }                                                         },
			{ 'a',                  { { p=1, t='a', x='w' } }                                          },
			{ '1',                  { { p=1, t='1', x='d' } }                                          },
			{ 'abc',                { { p=1, t='abc', x='w' } }                                        },
			{ '123',                { { p=1, t='123', x='d' } }                                        },
			{ '(abc)',              { { { p=2, t='abc', x='w' } } }                                    },
			{ '((abc))',            { { { { p=3, t='abc', x='w' } } } }                                },
			{ 'abc(def)',           { { p=1, t='abc', x='w'} , { { p=5, t='def', x='w' } } }                  },
			{ 'abc(123)',           { { p=1, t='abc', x='w'} , { { p=5, t='123', x='d' } } }                  },
			{ '(abc)def',           { { { p=2, t='abc', x='w' } }, { p=6, t='def', x='w' } }                  },
			{ 'abc(def)ghi',        { { p=1, t='abc', x='w' } , { { p=5, t='def', x='w' } }, { p=9, t='ghi', x='w' } } },
			{ '---',                { }                                                         },
			{ 'abc(---)ghi',        { { p=1, t='abc', x='w' } }                                         },
		--   { 'abc(def)(ghi)',      { 'abc', { 'def' }, { 'ghi' } }                },
		--   { 'abc(def)(ghi)jkl',   { 'abc', { 'def' }, { 'ghi' }, 'jkl' }         },
		--   { 'abc(def)ghi(jkl)',   { 'abc', { 'def' }, 'ghi', { 'jkl' } }         },
		--   { 'abc(def(ghi)jkl)',   { 'abc', { 'def', { 'ghi' }, 'jkl' } }         },
		}
	},
}


Test_parsers = {}

for _, p in ipairs(parsers) do
	for i, test in ipairs(p.tests) do
		Test_parsers['test_' .. p.name .. '_' .. string.format("%02d", i)] = function()
		   local err, a1, a2 = re.find(test[1], p.parser)
--		   assertEquals(a1, test[1])
		   assertEquals(stringify(a2), stringify(test[2]))
		end
	end
end



return LuaUnit:run()

--[=[

local parser1 = re.compile[[
   sentence <- ((<nonwordchar>*  <word> )* <nonwordchar>*) -> {}
   word <- {<wordchar>+}
   wordchar <- [abcdef]
   sep <- <nonwordchar>+
   nonwordchar <- [ ,_]
]]

local tests = 
{
   { ''               , {       } }, -- empty string
   { 'x'              , {       } }, -- invalid
   { ',-'             , {       } }, -- spaces only
   { 'abc'            , { 'abc' } }, -- indidual word
   { ' abc'           , { 'abc' } }, -- leading separator
   { ', abc'          , { 'abc' } }, -- multiple leading separator
   { 'abc,'           , { 'abc' } }, -- trailing separator
   { 'abc, '          , { 'abc' } }, -- multiple trailing separators
   { ',abc,'          , { 'abc' } }, -- leading and trailing separators
   { 'abc,def'        , { 'abc', 'def' } }, -- two words words
   { ',abc,def, ghi,_', { 'abc', 'def', 'ghi' } },  -- multiple words, multiple separators
}

for _, test in ipairs(tests) do
   local text = test[1]
   local expected = test[2]
   local a, b, c = re.match(text, parser1)
   print(text, a, b, c, #a, #expected)
   
end
--]=]

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

