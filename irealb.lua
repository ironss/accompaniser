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
scheme <- 'irealbook://' / 'irealb://'
songbook <- ( <song> ( <song> * ) {:title: <field>? :} '\n'* )
song <- ({:title: <field> :} <ssep> {:composer: <field> :} <ssep> {:style: <field> :} <ssep> {:key: <field> :} <ssep> {:xxx: <field> :} <ssep> {:tune: <tune> :} <ssep>) -> {} 

tune <- {:text: <field> :} -> {}
field <- [^=]*
ssep <- <sep> %s*
sep <- '='
]])


local song_parser = re.compile([[
song <- ( <element> * ) -> {}

element <- { <barline> 
           / <label> 
           / <symbol>
           / <timesig> 
           / <chord>
           / <altchord>
           / <space> 
           / <repeatbar> 
           / <ending> 
           / <end>
           / <comment>
           / <vspace>
           / <unknown>
           }

barline <- '[' / ']' / '{' / '}' / '|'

label <- '*' <labelchar>
labelchar <- [ABCDvi]

symbol <- 'Q' -- coda
        / 'S' -- segno
        / 'f' -- fermata

-- Valid signatures are identified explicitly, but a fall-through that allows
-- any digits is added at the end.
timesig <- 'T22' 
         / 'T32'
         / 'T24'
         / 'T34'
         / 'T44'
         / 'T54'
         / 'T64'
         / 'T74'
         / 'T68'
         / 'T78'
         / 'T98'
         / 'T12'
         / 'T' %d %d

chord <- ((<note> <quality>?) / 'W') <rootnote>?
altchord <- '(' <chord> ')'

note <- ([ABCDEFG] [#b]?)
quality <- ( ( [-+^ho] / 'add')* <degree>? ( [#b]? <degree> )*  'sus'? )  'alt'?
degree <- '5' / '6' / '7' / '9' / '11' / '13'
rootnote <- '/' <note>

comment <- '<' [^>]* '>'
ending <- 'N' [123]

space <- ' ' / ',' / %nl
repeatbar <- 'x'
end <- 'Z' / 'z'

vspace <- 'YYY' / 'YY' / 'Y'

unknown <- 's' / 'l' / 'W' / 'p' / 'r' / 'U' / 'n'
]])


local M = {}

M.url_parse = function(s) return re.find(url_decode(s), irealb_parser) end
M.parse = function(s) return re.find(s, irealb_parser) end
M.song_parse = function(s) return re.find(s, song_parser) end



M.transpose = 0

return M

