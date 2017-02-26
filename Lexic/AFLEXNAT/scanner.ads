with text_io; use text_io;
with ascan_dfa; use ascan_dfa; 
with ascan_io; use ascan_io; 
with misc_defs, misc, sym, parse_tokens, int_io;
with tstring, ascan_dfa, ascan_io, external_file_manager;
use misc_defs, parse_tokens, tstring;
use ascan_dfa, ascan_io, external_file_manager;

package scanner is
    call_yylex : boolean := false;
    function get_token return Token;
end scanner;

