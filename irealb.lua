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
song <- prefix? ( ({:pos: {} :} {:text: <element> :}) -> {} * ) -> {}

prefix <- '1r34LbKcu7'

element <- <barline>
           / <label> 
           / <symbol>
           / <timesig> 
           / <chord>
           / <altchord>
           / <nochord>
           / <space> 
           / <repeatbar> 
           / <ending> 
           / <staff_text>
           / <vspace>
           / <end>
           / <unknown>


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
--         / 'T' %d %d

chord <- ((<note> / 'W') <quality>?) <rootnote>?
altchord <- '(' <chord> ')'
nochord <- 'n'

note <- ([ABCDEFG] [#b]?)
quality <-  ('*' [^*]* '*' ) / (( ( [-+^ho] / 'add')* <degree>? ( [#b]? <degree> )*  'sus'? )  'alt'?)
degree <- '5' / '6' / '7' / '9' / '11' / '13'
rootnote <- '/' <note>

staff_text <- '<' [^>]* '>'

ending <- 'N0'
        / 'N1'
        / 'N2'
        / 'N3'

repeatbar <- 'x'  -- repeat 1 bar 
           / 'r'  -- repeat 2 bars
           / 'p'  -- slash (beat)

space <- ' ' / ',' / %nl
vspace <- 'YYY' / 'YY' / 'Y'

end <- 'Z'

unknown <- 's' -- small size chord
         / 'l' -- normal size chord
         / 'U' -- ???

]])


local M = {}

M.url_parse = function(s) return re.find(url_decode(s), irealb_parser) end
M.parse = function(s) return re.find(s, irealb_parser) end
M.song_parse = function(s) return re.find(s, song_parser) end



M.transpose = 0

return M

