#! /usr/bin/lua

package.path = './?/?.lua;' .. package.path

local re = require 're'
local serpent = require('serpent')

function stringify(t) return serpent.line(t, { comment=false }) end

require('luaunit')


p1 = re.compile[[
	string <-  { .* }
]]



Test_lpeg = {}

function Test_lpeg:test_trivial()
   s = 'abcdef(ghi)jkl'
   expected = s
   
   err, actual = re.find(s, p1)
   assertEquals(actual, expected)
end


p2 = re.compile[[
	string <-  { <stuff> }
	stuff <- ( <nested> / <word> <nested>? )* -> {}
	word <- { %w+ }
	nonword <- %W*
	nested <- '(' <stuff> ')'
]]


tests2 = 
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

Test_p2 = {}

for i, test in ipairs(tests2) do
   Test_p2['test_p2_' .. i] = function()
      local err, a1, a2 = re.find(test[1], p2)
      assertEquals(a1, test[1])
      assertEquals(stringify(a2), stringify(test[2]))
   end
end



p3 = re.compile[[
	string <-  { <stuff> }
	stuff <- ( <nested> / <word> <nested>? )* -> {}
	word <- ( <pos> {:t: %w+ :} ) -> {}
	pos <- {:p: {} :}
	nonword <- %W*
	nested <- '(' <stuff> ')'
]]


tests3 = 
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

Test_p3 = {}

for i, test in ipairs(tests3) do
   Test_p3['test_p3_' .. i] = function()
      local err, a1, a2 = re.find(test[1], p3)
      assertEquals(a1, test[1])
      assertEquals(stringify(a2), stringify(test[2]))
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
