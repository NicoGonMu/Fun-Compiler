
with lang_io, lang_dfa, decls.general_defs, semantic.tree_c;
use lang_io, lang_dfa, decls.general_defs, semantic.tree_c;
package body lexical_a is
  function pos return position is
    p: position;
  begin
    p.row := Yy_Line_Number;
    p.column := Yy_Begin_Column;
    return p;
  end pos;
  procedure open (s: in string) is 
  begin 
    Open_Input(s);
  end open;
  procedure close is 
  begin 
    Close_Input;
  end close;
function YYLex return Token is
subtype short is integer range -32768..32767;
    yy_act : integer;
    yy_c : short;

-- returned upon end-of-file
YY_END_TOK : constant integer := 0;
YY_END_OF_BUFFER : constant := 52;
subtype yy_state_type is integer;
yy_current_state : yy_state_type;
INITIAL : constant := 0;
yy_accept : constant array(0..87) of short :=
    (   0,
       44,   44,   52,   50,   48,   49,   41,   50,    6,   21,
       10,   50,   22,   23,   18,   17,   28,   19,   29,   20,
       44,    1,   26,   11,   15,   13,   42,   24,    5,   25,
        9,   42,   42,   42,   42,   42,   42,   40,   48,    0,
       46,   39,    0,    3,   47,    4,   16,   44,    0,    8,
       12,   27,    2,   14,   42,    0,   42,   42,   42,   34,
       32,   42,   42,   42,   42,   43,   47,    7,   44,    0,
       42,   30,   42,   31,   42,   42,   42,   44,    0,   37,
       36,   35,   38,   42,   45,   33,    0
    ) ;

yy_ec : constant array(ASCII.NUL..ASCII.DEL) of short :=
    (   0,
        1,    1,    1,    1,    1,    1,    1,    1,    2,    3,
        1,    1,    2,    1,    1,    1,    1,    1,    1,    1,
        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
        1,    4,    5,    6,    7,    8,    9,   10,   11,   12,
       13,   14,   15,   16,   17,   18,   19,   20,   20,   20,
       20,   20,   20,   20,   20,   20,   20,   21,   22,   23,
       24,   25,    8,    8,   26,   26,   26,   26,   26,   26,
       26,   26,   26,   26,   26,   26,   26,   26,   26,   26,
       26,   26,   26,   26,   26,   26,   26,   26,   26,   26,
       27,   28,   29,    8,   30,    8,   31,   26,   32,   33,

       34,   35,   26,   36,   37,   26,   26,   38,   26,   39,
       26,   40,   26,   41,   42,   43,   26,   26,   44,   26,
       45,   26,    8,   46,    8,    8,    1
    ) ;

yy_meta : constant array(0..46) of short :=
    (   0,
        1,    1,    2,    3,    3,    3,    3,    3,    3,    3,
        3,    3,    3,    3,    3,    3,    3,    3,    3,    4,
        3,    3,    3,    3,    3,    4,    3,    3,    3,    4,
        4,    4,    4,    4,    4,    4,    4,    4,    4,    4,
        4,    4,    4,    4,    4,    3
    ) ;

yy_base : constant array(0..91) of short :=
    (   0,
        0,    0,  138,  139,   45,  139,  139,  131,  139,  139,
      126,    0,  139,  139,  139,  120,  139,   31,  139,  110,
       30,  112,  139,   27,  108,  107,  100,  139,  139,  139,
      139,   23,   25,   29,   28,   31,   35,  139,   68,  123,
      122,  139,  116,  139,  109,  139,  139,   49,  105,  139,
      139,  139,  139,  139,   94,   93,   43,   45,   36,   92,
       91,   44,   50,   51,   55,  139,    0,    0,   62,  100,
       63,   89,   65,   88,   58,   66,   60,   97,   96,   85,
       84,   83,   82,   68,   81,   78,  139,  100,  102,   79,
      106

    ) ;

yy_def : constant array(0..91) of short :=
    (   0,
       87,    1,   87,   87,   87,   87,   87,   88,   87,   87,
       87,   89,   87,   87,   87,   87,   87,   87,   87,   87,
       87,   87,   87,   87,   87,   87,   90,   87,   87,   87,
       87,   90,   90,   90,   90,   90,   90,   87,   87,   88,
       87,   87,   87,   87,   91,   87,   87,   87,   87,   87,
       87,   87,   87,   87,   90,   90,   90,   90,   90,   90,
       90,   90,   90,   90,   90,   87,   91,   91,   87,   87,
       90,   90,   90,   90,   90,   90,   90,   87,   87,   90,
       90,   90,   90,   90,   87,   90,    0,   87,   87,   87,
       87

    ) ;

yy_nxt : constant array(0..185) of short :=
    (   0,
        4,    5,    6,    5,    7,    8,    9,    4,   10,   11,
       12,   13,   14,   15,   16,   17,   18,   19,   20,   21,
       22,   23,   24,   25,   26,   27,   28,   29,   30,   31,
       27,   27,   32,   33,   27,   27,   34,   35,   27,   27,
       27,   27,   36,   37,   27,   38,   39,   45,   39,   48,
       51,   52,   56,   57,   56,   46,   58,   56,   56,   49,
       56,   62,   59,   60,   56,   56,   63,   61,   69,   39,
       65,   39,   56,   56,   56,   64,   72,   73,   49,   56,
       56,   78,   55,   75,   56,   71,   74,   56,   77,   56,
       76,   49,   56,   80,   56,   56,   82,   56,   81,   83,

       84,   86,   40,   40,   43,   43,   67,   56,   67,   67,
       49,   56,   56,   56,   56,   85,   78,   56,   56,   79,
       56,   56,   87,   56,   70,   68,   66,   40,   41,   56,
       54,   53,   50,   47,   44,   42,   41,   87,    3,   87,
       87,   87,   87,   87,   87,   87,   87,   87,   87,   87,
       87,   87,   87,   87,   87,   87,   87,   87,   87,   87,
       87,   87,   87,   87,   87,   87,   87,   87,   87,   87,
       87,   87,   87,   87,   87,   87,   87,   87,   87,   87,
       87,   87,   87,   87,   87
    ) ;

yy_chk : constant array(0..185) of short :=
    (   0,
        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
        1,    1,    1,    1,    1,    1,    5,   18,    5,   21,
       24,   24,   32,   32,   33,   18,   32,   35,   34,   21,
       36,   35,   33,   34,   37,   59,   36,   34,   48,   39,
       37,   39,   57,   62,   58,   36,   58,   59,   48,   63,
       64,   69,   90,   63,   65,   57,   62,   75,   65,   77,
       64,   69,   71,   71,   73,   76,   75,   84,   73,   76,

       77,   84,   88,   88,   89,   89,   91,   86,   91,   91,
       85,   83,   82,   81,   80,   79,   78,   74,   72,   70,
       61,   60,   56,   55,   49,   45,   43,   41,   40,   27,
       26,   25,   22,   20,   16,   11,    8,    3,   87,   87,
       87,   87,   87,   87,   87,   87,   87,   87,   87,   87,
       87,   87,   87,   87,   87,   87,   87,   87,   87,   87,
       87,   87,   87,   87,   87,   87,   87,   87,   87,   87,
       87,   87,   87,   87,   87,   87,   87,   87,   87,   87,
       87,   87,   87,   87,   87
    ) ;


-- copy whatever the last rule matched to the standard output

procedure ECHO is
begin
   if (text_io.is_open(user_output_file)) then
     text_io.put( user_output_file, yytext );
   else
     text_io.put( yytext );
   end if;
end ECHO;

-- enter a start condition.
-- Using procedure requires a () after the ENTER, but makes everything
-- much neater.

procedure ENTER( state : integer ) is
begin
     yy_start := 1 + 2 * state;
end ENTER;

-- action number for EOF rule of a given start state
function YY_STATE_EOF(state : integer) return integer is
begin
     return YY_END_OF_BUFFER + state + 1;
end YY_STATE_EOF;

-- return all but the first 'n' matched characters back to the input stream
procedure yyless(n : integer) is
begin
        yy_ch_buf(yy_cp) := yy_hold_char; -- undo effects of setting up yytext
        yy_cp := yy_bp + n;
        yy_c_buf_p := yy_cp;
        YY_DO_BEFORE_ACTION; -- set up yytext again
end yyless;

-- redefine this if you have something you want each time.
procedure YY_USER_ACTION is
begin
        null;
end;

-- yy_get_previous_state - get the state just before the EOB char was reached

function yy_get_previous_state return yy_state_type is
    yy_current_state : yy_state_type;
    yy_c : short;
begin
    yy_current_state := yy_start;

    for yy_cp in yytext_ptr..yy_c_buf_p - 1 loop
	yy_c := yy_ec(yy_ch_buf(yy_cp));
	if ( yy_accept(yy_current_state) /= 0 ) then
	    yy_last_accepting_state := yy_current_state;
	    yy_last_accepting_cpos := yy_cp;
	end if;
	while ( yy_chk(yy_base(yy_current_state) + yy_c) /= yy_current_state ) loop
	    yy_current_state := yy_def(yy_current_state);
	    if ( yy_current_state >= 88 ) then
		yy_c := yy_meta(yy_c);
	    end if;
	end loop;
	yy_current_state := yy_nxt(yy_base(yy_current_state) + yy_c);
    end loop;

    return yy_current_state;
end yy_get_previous_state;

procedure yyrestart( input_file : file_type ) is
begin
   open_input(text_io.name(input_file));
end yyrestart;

begin -- of YYLex
<<new_file>>
        -- this is where we enter upon encountering an end-of-file and
        -- yywrap() indicating that we should continue processing

    if ( yy_init ) then
        if ( yy_start = 0 ) then
            yy_start := 1;      -- first start state
        end if;

        -- we put in the '\n' and start reading from [1] so that an
        -- initial match-at-newline will be true.

        yy_ch_buf(0) := ASCII.LF;
        yy_n_chars := 1;

        -- we always need two end-of-buffer characters. The first causes
        -- a transition to the end-of-buffer state. The second causes
        -- a jam in that state.

        yy_ch_buf(yy_n_chars) := YY_END_OF_BUFFER_CHAR;
        yy_ch_buf(yy_n_chars + 1) := YY_END_OF_BUFFER_CHAR;

        yy_eof_has_been_seen := false;

        yytext_ptr := 1;
        yy_c_buf_p := yytext_ptr;
        yy_hold_char := yy_ch_buf(yy_c_buf_p);
        yy_init := false;
-- UMASS CODES :
--   Initialization
        tok_begin_line := 1;
        tok_end_line := 1;
        tok_begin_col := 0;
        tok_end_col := 0;
        token_at_end_of_line := false;
        line_number_of_saved_tok_line1 := 0;
        line_number_of_saved_tok_line2 := 0;
-- END OF UMASS CODES.
    end if; -- yy_init

    loop                -- loops until end-of-file is reached

-- UMASS CODES :
--    if last matched token is end_of_line, we must
--    update the token_end_line and reset tok_end_col.
    if Token_At_End_Of_Line then
      Tok_End_Line := Tok_End_Line + 1;
      Tok_End_Col := 0;
      Token_At_End_Of_Line := False;
    end if;
-- END OF UMASS CODES.

        yy_cp := yy_c_buf_p;

        -- support of yytext
        yy_ch_buf(yy_cp) := yy_hold_char;

        -- yy_bp points to the position in yy_ch_buf of the start of the
        -- current run.
	yy_bp := yy_cp;
	yy_current_state := yy_start;
	loop
		yy_c := yy_ec(yy_ch_buf(yy_cp));
		if ( yy_accept(yy_current_state) /= 0 ) then
		    yy_last_accepting_state := yy_current_state;
		    yy_last_accepting_cpos := yy_cp;
		end if;
		while ( yy_chk(yy_base(yy_current_state) + yy_c) /= yy_current_state ) loop
		    yy_current_state := yy_def(yy_current_state);
		    if ( yy_current_state >= 88 ) then
			yy_c := yy_meta(yy_c);
		    end if;
		end loop;
		yy_current_state := yy_nxt(yy_base(yy_current_state) + yy_c);
	    yy_cp := yy_cp + 1;
if ( yy_current_state = 87 ) then
    exit;
end if;
	end loop;
	yy_cp := yy_last_accepting_cpos;
	yy_current_state := yy_last_accepting_state;

<<next_action>>
	    yy_act := yy_accept(yy_current_state);
            YY_DO_BEFORE_ACTION;
            YY_USER_ACTION;

        if aflex_debug then  -- output acceptance info. for (-d) debug mode
            text_io.put( Standard_Error, "--accepting rule #" );
            text_io.put( Standard_Error, INTEGER'IMAGE(yy_act) );
            text_io.put_line( Standard_Error, "(""" & yytext & """)");
        end if;

-- UMASS CODES :
--   Update tok_begin_line, tok_end_line, tok_begin_col and tok_end_col
--   after matching the token.
        if yy_act /= YY_END_OF_BUFFER and then yy_act /= 0 then
-- Token are matched only when yy_act is not yy_end_of_buffer or 0.
          Tok_Begin_Line := Tok_End_Line;
          Tok_Begin_Col := Tok_End_Col + 1;
          Tok_End_Col := Tok_Begin_Col + yy_cp - yy_bp - 1;
          if yy_ch_buf ( yy_bp ) = ASCII.LF then
            Token_At_End_Of_Line := True;
          end if;
        end if;
-- END OF UMASS CODES.

<<do_action>>   -- this label is used only to access EOF actions
            case yy_act is
		when 0 => -- must backtrack
		-- undo the effects of YY_DO_BEFORE_ACTION
		yy_ch_buf(yy_cp) := yy_hold_char;
		yy_cp := yy_last_accepting_cpos;
		yy_current_state := yy_last_accepting_state;
		goto next_action;



when 1 => 
--# line 8 "lang.l"
rl_atom(YYlval, pos);
	return colon;

when 2 => 
--# line 10 "lang.l"
rl_assig(YYlval, pos);
	return assig;

when 3 => 
--# line 12 "lang.l"
rl_derivator(YYlval, pos);
	return derivator;

when 4 => 
--# line 14 "lang.l"
rl_arrow(YYlval, pos);
	return arrow;

when 5 => 
--# line 16 "lang.l"
rl_lambda(YYlval, pos);
	return lambda;

when 6 => 
--# line 18 "lang.l"
rl_cart_prod(YYlval, pos);
	return cart_prod;

when 7 => 
--# line 20 "lang.l"
rl_pattern(YYlval, pos);
	return pattern;

when 8 => 
--# line 22 "lang.l"
rl_conc(YYlval, pos);
	return conc;

when 9 => 
--# line 24 "lang.l"
rl_e_pattern(YYlval, pos);
	return e_pattern;

when 10 => 
--# line 26 "lang.l"
rl_rename(YYlval, pos);
	return rename;

when 11 => 
--# line 28 "lang.l"
rl_lt(YYlval, pos);
	return oprel;

when 12 => 
--# line 30 "lang.l"
rl_le(YYlval, pos);
	return oprel;

when 13 => 
--# line 32 "lang.l"
rl_gt(YYlval, pos);
	return oprel;

when 14 => 
--# line 34 "lang.l"
rl_ge(YYlval, pos);
	return oprel;

when 15 => 
--# line 36 "lang.l"
rl_equal(YYlval, pos);
	return oprel;

when 16 => 
--# line 38 "lang.l"
rl_ne(YYlval, pos);
	return oprel;

when 17 => 
--# line 40 "lang.l"
rl_atom(YYlval, pos);
	return plus;

when 18 => 
--# line 42 "lang.l"
rl_atom(YYlval, pos);
	return mult;

when 19 => 
--# line 44 "lang.l"
rl_atom(YYlval, pos);
	return sub;

when 20 => 
--# line 46 "lang.l"
rl_atom(YYlval, pos);
	return div;

when 21 => 
--# line 48 "lang.l"
rl_atom(YYlval, pos);
	return mod;

when 22 => 
--# line 50 "lang.l"
rl_atom(YYlval, pos);
	return o_par;

when 23 => 
--# line 52 "lang.l"
rl_atom(YYlval, pos);
	return c_par;

when 24 => 
--# line 54 "lang.l"
rl_atom(YYlval, pos);
	return o_braq;

when 25 => 
--# line 56 "lang.l"
rl_atom(YYlval, pos);
	return c_braq;

when 26 => 
--# line 58 "lang.l"
rl_atom(YYlval, pos);
	return semicolon;

when 27 => 
--# line 60 "lang.l"
rl_atom(YYlval, pos);
	return cons;

when 28 => 
--# line 62 "lang.l"
rl_atom(YYlval, pos);
	return comma;

when 29 => 
--# line 64 "lang.l"
rl_atom(YYlval, pos);
	return dot;

when 30 => 
--# line 68 "lang.l"
rl_atom(YYlval, pos);
	return pc_dec;

when 31 => 
--# line 70 "lang.l"
rl_atom(YYlval, pos);
	return pc_let;

when 32 => 
--# line 72 "lang.l"
rl_atom(YYlval, pos);
	return pc_in;

when 33 => 
--# line 74 "lang.l"
rl_atom(YYlval, pos);
	return pc_where;

when 34 => 
--# line 78 "lang.l"
rl_atom(YYlval, pos);
		return pc_if;

when 35 => 
--# line 80 "lang.l"
rl_atom(YYlval, pos);
		return pc_then;

when 36 => 
--# line 82 "lang.l"
rl_atom(YYlval, pos);
		return pc_else;

when 37 => 
--# line 85 "lang.l"
rl_atom(YYlval, pos);
		return pc_data;

when 38 => 
--# line 87 "lang.l"
rl_atom(YYlval, pos);
		return pc_type;

when 39 => 
--# line 90 "lang.l"
rl_atom(YYlval, pos);
		return pc_and;

when 40 => 
--# line 92 "lang.l"
rl_atom(YYlval, pos);
		return pc_or;

when 41 => 
--# line 94 "lang.l"
rl_atom(YYlval, pos);
		return pc_not;

when 42 => 
--# line 98 "lang.l"
rl_ident(YYlval, pos, YYText);
							return identificador;

when 43 => 
--# line 100 "lang.l"
rl_lit_car(YYlval, pos, YYText);
							return lit_car;

when 44 => 
--# line 102 "lang.l"
rl_lit_ent(YYlval, pos, YYText);
							return lit_ent;

when 45 => 
--# line 104 "lang.l"
rl_lit_ent(YYlval, pos, YYText);
							return lit_ent;

when 46 => 
--# line 106 "lang.l"
rl_lit_str(YYlval, pos, YYText);
							return lit_str; 

when 47 => 
--# line 108 "lang.l"
null; 

when 48 => 
--# line 109 "lang.l"
null; 

when 49 => 
--# line 110 "lang.l"
null;

when 50 => 
--# line 111 "lang.l"
return Error;

when 51 => 
--# line 113 "lang.l"
ECHO;
when YY_END_OF_BUFFER + INITIAL + 1 => 
    return End_Of_Input;
                when YY_END_OF_BUFFER =>
                    -- undo the effects of YY_DO_BEFORE_ACTION
                    yy_ch_buf(yy_cp) := yy_hold_char;

                    yytext_ptr := yy_bp;

                    case yy_get_next_buffer is
                        when EOB_ACT_END_OF_FILE =>
                            begin
                            if ( yywrap ) then
                                -- note: because we've taken care in
                                -- yy_get_next_buffer() to have set up yytext,
                                -- we can now set up yy_c_buf_p so that if some
                                -- total hoser (like aflex itself) wants
                                -- to call the scanner after we return the
                                -- End_Of_Input, it'll still work - another
                                -- End_Of_Input will get returned.

                                yy_c_buf_p := yytext_ptr;

                                yy_act := YY_STATE_EOF((yy_start - 1) / 2);

                                goto do_action;
                            else
                                --  start processing a new file
                                yy_init := true;
                                goto new_file;
                            end if;
                            end;
                        when EOB_ACT_RESTART_SCAN =>
                            yy_c_buf_p := yytext_ptr;
                            yy_hold_char := yy_ch_buf(yy_c_buf_p);
                        when EOB_ACT_LAST_MATCH =>
                            yy_c_buf_p := yy_n_chars;
                            yy_current_state := yy_get_previous_state;

                            yy_cp := yy_c_buf_p;
                            yy_bp := yytext_ptr;
                            goto next_action;
                        when others => null;
                        end case; -- case yy_get_next_buffer()
                when others =>
                    text_io.put( "action # " );
                    text_io.put( INTEGER'IMAGE(yy_act) );
                    text_io.new_line;
                    raise AFLEX_INTERNAL_ERROR;
            end case; -- case (yy_act)
        end loop; -- end of loop waiting for end of file
end YYLex;
--# line 113 "lang.l"
end lexical_a;

