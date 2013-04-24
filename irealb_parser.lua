-- Copyright (c) 2013 Stephen Irons 
-- License included at end of file

local re = require('re')

function url_decode(str)
  str = string.gsub (str, "+", " ")
  str = string.gsub (str, "%%(%x%x)",
      function(h) return string.char(tonumber(h,16)) end)
  str = string.gsub (str, "\r\n", "\n")
  return str
end

local irealb_parser = re.compile([[
songbookurl <- ( <irealbookurl> / <irealburl> ) -> {}
irealbookurl <- {:scheme: 'irealbook' :} '://' <irealbooksongbook>
irealburl <- {:scheme: 'irealb' :} '://' <irealbsongbook>

irealbooksongbook <- ( <irealbooksong> ( <irealbooksong> * ) {:title: <field>? :} '\n'* )
irealbooksong <- ( {:title: <field> :} <ssep> 
                   {:composer: <field> :} <ssep> 
                   {:style: <field> :} <ssep> 
                   {:key: <field> :} <ssep> 
                   {:x1: <field> :} <ssep> 
                   {:tune: <tune> :} <ssep>
                 ) -> {} 

irealbsongbook <- ( <irealbsong> ( <irealbsong> * ) {:title: <field>? :} '\n'* )
irealbsong <- ( {:title: <field> :} <ssep> 
                {:composer: <field> :} <ssep> 
                {:x1: <field> :} <ssep> 
                {:style: <field> :} <ssep> 
                {:key: <field> :} <ssep> 
                {:x2: <field> :} <ssep> 
                {:tune: <tune> :} <ssep>
                {:x3: <field> :} <ssep> 
                {:x4: <field> :} <ssep> 
                {:x5: <field> :} <ssep> 
                {:x6: <field> :} <ssep> 
                {:x7: <field> :} <ssep> 
              ) -> {} 

tune <- <obfusctune> / <plaintune>
obfusctune <- ( {:key: '1r34LbKcu7' :} {:raw: <field> :} )-> {}
plaintune <- ( {:text: <field> :} )-> {}

field <- [^=]*
ssep <- <sep> %s*
sep <- '='
]])


local song_parser = re.compile([[
song <- { <songcapture> }
songcapture <- <prefix>? ( <elementcapture> )* -> {}

prefix <- '1r34LbKcu7'

elementcapture <- <element> -> {}
pos <- {:pos: {} :}

element <- <pos> {:text:  <barline>   :} {:elem: '' -> 'barline'   :}
         / <pos> {:text:  <label>     :} {:elem: '' -> 'label'     :}
         / <pos> {:text:  <symbol>    :} {:elem: '' -> 'symbol'    :}
         / <pos> {:text:  <timesig>   :} {:elem: '' -> 'timesig'   :}
         / <pos> {:text:  <chord>     :} {:elem: '' -> 'chord'     :}
         / <pos> {:text:  <altchord>  :} {:elem: '' -> 'altchord'  :}
         / <pos> {:text:  <nochord>   :} {:elem: '' -> 'nochord'   :}
         / <pos> {:text:  <space>     :} {:elem: '' -> 'space'     :}
         / <pos> {:text:  <repeatbar> :} {:elem: '' -> 'repeatbar' :} 
         / <pos> {:text:  <ending>    :} {:elem: '' -> 'ending'    :}
         / <pos> {:text:  <stafftext> :} {:elem: '' -> 'stafftext' :}
         / <pos> {:text:  <vspace>    :} {:elem: '' -> 'vspace'    :}
         / <pos> {:text:  <end>       :} {:elem: '' -> 'end'       :}
         / <pos> {:text:  <unknown>   :} {:elem: '' -> 'unknown'   :}

barline <- '[' / ']' / '{' / '}' / '|'

label <- '*' <labelchar>
labelchar <- [ABCDvi]

symbol <- 'Q' -- coda
        / 'S' -- segno
        / 'f' -- fermata


-- Valid time signatures are identified explicitly, but a fall-through that 
-- allows any digits is added at the end.

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

stafftext <- '<' [^>]* '>'

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

         / 'L'
         / 'X'
         / 'y'
         / 'K'
         / 'c'

]])



local separator = re.compile([[
   {: . :} * -> {}
]])


local function sep(s) return re.find(s, separator) end

local function obfusc50(s)
   local err, t = sep(s)
   for i = 1, 5 do
      t[i], t[51-i] = t[51-i], t[i]
   end

   for i = 11, 24 do
      t[i], t[51-i] = t[51-i], t[i]
   end

   return table.concat(t)
end


local function obfusc(s)
   local r = ''

   while s:len() > 50 do
      p = s:sub(1, 50)
      s = s:sub(51, -1)
      if s:len() < 2 then
         r = r .. p
      else
         r = r .. obfusc50(p)
      end
   end
   r = r .. s
   return r
end


local M = {}

M.url_parse = function(s) return re.find(url_decode(s), irealb_parser) end
M.parse = function(s) return re.find(s, irealb_parser) end
M.song_parse = function(s) return re.find(s, song_parser) end

M.obfusc = obfusc
M.unobfusc = obfusc


M.transpose = 0

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

