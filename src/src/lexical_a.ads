-- A lexical scanner generated by aflex
with text_io; use text_io;
with fun_dfa; use fun_dfa; 
with fun_io; use fun_io; 
--# line 1 "fun.l"
--# line 6 "fun.l"

with fun_tokens;
use fun_tokens;
package lexical_a is
  procedure open(s: in string);
  procedure close;
  function YYlex return Token;
end lexical_a;
