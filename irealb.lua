#! /usr/bin/env lua

local re = require('re')

function url_decode(str)
  str = string.gsub (str, "+", " ")
  str = string.gsub (str, "%%(%x%x)",
      function(h) return string.char(tonumber(h,16)) end)
  str = string.gsub (str, "\r\n", "\n")
  return str
end


local irealb_parser = re.compile([[
irealbook <- ( <scheme> ? <songbook>  ) -> {}
scheme <- 'irealbook://'
songbook <- ( <song> ( <song> * ) {:title: <field>? :} '\n'* )
song <- ({:title: <field> :} <ssep> {:composer: <field> :} <ssep> {:style: <field> :} <ssep> {:key: <field> :} <ssep> {:xxx: <field> :} <ssep> {:tune: <tune> :} <ssep>) -> {} 

tune <- {:text: <field> :} -> {}
field <- [^=]*
ssep <- <sep> %s*
sep <- '='
]])


local song_parser = re.compile([[
song <- ( <element> * ) -> {} .*

element <- { <barline> 
           / <label> 
           / <timesig> 
           / <chord>
           / <altchord>
           / <space> 
           / <repeatbar> 
           / <ending> 
           / <end>
           / <comment>
           / <unknown>
           }

barline <- '[' / ']' / '{' / '}' / '|'

label <- '*' <char>
char <- [%l%u]

timesig <- 'T' <digit> <digit>
digit <- %d

chord <- <note> <modifier>? <rootnote>?
altchord <- '(' <chord> ')'

note <- ([ABCDEFG] [#b]?)
modifier <- ( ( [-+^ho] / 'add')* <degree>? ( [#b]? <degree> )*  'sus'? )  'alt'?
degree <- '5' / '6' / '7' / '9' / '11' / '13'
rootnote <- '/' <note>

comment <- '<' [^>]* '>'
ending <- 'N' [123]

space <- ' ' / ','
repeatbar <- 'x'
end <- 'Z' / 'z'

unknown <- 'Y' / 's' / 'l' / 'Q' / 'p' / 'r' / 'f' / 'U' / 'S' / 'n' / 'W'
]])


local M = {}

M.url_parse = function(s) return re.find(url_decode(s), irealb_parser) end
M.parse = function(s) return re.find(s, irealb_parser) end
M.song_parse = function(s) return re.find(s, song_parser) end



M.transpose = 0

return M

