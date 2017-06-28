
with fun_io, fun_dfa, decls.general_defs, semantic.c_tree;
use fun_io, fun_dfa, decls.general_defs, semantic.c_tree;
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
YY_END_OF_BUFFER : constant := 45;
subtype yy_state_type is integer;
yy_current_state : yy_state_type;
INITIAL : constant := 0;
yy_accept : constant array(0..78) of short :=
    (   0,
       37,   37,   45,   43,   41,   42,   34,   43,    5,   18,
       43,   43,   19,   20,   15,   14,   24,   16,   17,   37,
        1,   23,    8,   12,   10,   35,   21,   22,   35,   35,
       35,   35,   33,   41,    0,   39,   32,    0,    3,    0,
        4,   40,   13,   37,    0,    7,    2,    9,   11,   35,
        0,   35,   35,   35,   26,   35,   35,   36,    6,   40,
       37,    0,   35,   25,   35,   35,   35,   37,    0,   29,
       28,   27,   30,   38,   35,   35,   31,    0
    ) ;

yy_ec : constant array(ASCII.NUL..ASCII.DEL) of short :=
    (   0,
        1,    1,    1,    1,    1,    1,    1,    1,    2,    3,
        1,    1,    2,    1,    1,    1,    1,    1,    1,    1,
        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
        1,    4,    5,    6,    7,    8,    9,   10,   11,   12,
       13,   14,   15,   16,   17,    8,   18,   19,   19,   19,
       19,   19,   19,   19,   19,   19,   19,   20,   21,   22,
       23,   24,    8,    8,   25,   25,   25,   25,   25,   25,
       25,   25,   25,   25,   25,   25,   25,   25,   25,   25,
       25,   25,   25,   25,   25,   25,   25,   25,   25,   25,
       26,    8,   27,    8,   28,    8,   29,   25,   30,   31,

       32,   33,   25,   34,   35,   25,   25,   36,   25,   37,
       25,   38,   25,   39,   40,   41,   25,   42,   25,   25,
       43,   25,    8,   44,    8,    8,    1
    ) ;

yy_meta : constant array(0..44) of short :=
    (   0,
        1,    1,    2,    3,    3,    3,    3,    3,    3,    3,
        3,    3,    3,    3,    3,    3,    3,    3,    4,    3,
        3,    3,    3,    3,    4,    3,    3,    4,    4,    4,
        4,    4,    4,    4,    4,    4,    4,    4,    4,    4,
        4,    4,    4,    3
    ) ;

yy_base : constant array(0..82) of short :=
    (   0,
        0,    0,  126,  127,   43,  127,  127,  119,  127,  127,
      114,    0,  127,  127,  127,  108,  127,   29,   31,   29,
       32,  127,   99,  127,   98,   92,  127,  127,   30,   28,
       32,   33,  127,   64,  113,  112,  127,  106,  127,   99,
      127,    0,  127,   44,   96,  127,  127,  127,  127,   86,
       85,   41,   43,   46,   84,   47,   42,  127,  127,    0,
       59,   92,   22,   80,   49,   55,   56,   82,   81,   70,
       69,   68,   57,   67,   61,   63,   66,  127,  100,  102,
       89,  106
    ) ;

yy_def : constant array(0..82) of short :=
    (   0,
       78,    1,   78,   78,   78,   78,   78,   79,   78,   78,
       78,   80,   78,   78,   78,   78,   78,   78,   78,   78,
       78,   78,   78,   78,   78,   81,   78,   78,   81,   81,
       81,   81,   78,   78,   79,   78,   78,   78,   78,   78,
       78,   82,   78,   78,   78,   78,   78,   78,   78,   81,
       81,   81,   81,   81,   81,   81,   81,   78,   78,   82,
       78,   78,   81,   81,   81,   81,   81,   78,   78,   81,
       81,   81,   81,   78,   81,   81,   81,    0,   78,   78,
       78,   78
    ) ;

yy_nxt : constant array(0..171) of short :=
    (   0,
        4,    5,    6,    5,    7,    8,    9,    4,   10,   11,
       12,   13,   14,   15,   16,   17,   18,   19,   20,   21,
       22,   23,   24,   25,   26,   27,   28,    4,   26,   26,
       29,   30,   26,   26,   31,   26,   26,   26,   26,   26,
       32,   26,   26,   33,   34,   40,   34,   44,   42,   51,
       70,   46,   41,   43,   47,   51,   45,   51,   52,   51,
       51,   53,   61,   54,   55,   34,   56,   34,   51,   51,
       51,   45,   64,   51,   51,   57,   51,   68,   66,   67,
       71,   63,   51,   51,   51,   65,   45,   73,   51,   76,
       51,   72,   50,   51,   45,   51,   51,   51,   75,   74,

       68,   77,   35,   35,   38,   38,   60,   51,   60,   60,
       69,   51,   78,   51,   62,   59,   58,   35,   36,   51,
       49,   48,   39,   37,   36,   78,    3,   78,   78,   78,
       78,   78,   78,   78,   78,   78,   78,   78,   78,   78,
       78,   78,   78,   78,   78,   78,   78,   78,   78,   78,
       78,   78,   78,   78,   78,   78,   78,   78,   78,   78,
       78,   78,   78,   78,   78,   78,   78,   78,   78,   78,
       78
    ) ;

yy_chk : constant array(0..171) of short :=
    (   0,
        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
        1,    1,    1,    1,    5,   18,    5,   20,   19,   63,
       63,   21,   18,   19,   21,   30,   20,   29,   29,   31,
       32,   29,   44,   30,   31,   34,   32,   34,   52,   57,
       53,   44,   53,   54,   56,   32,   65,   61,   56,   57,
       65,   52,   66,   67,   73,   54,   61,   67,   75,   75,
       76,   66,   81,   77,   74,   72,   71,   70,   73,   69,

       68,   76,   79,   79,   80,   80,   82,   64,   82,   82,
       62,   55,   51,   50,   45,   40,   38,   36,   35,   26,
       25,   23,   16,   11,    8,    3,   78,   78,   78,   78,
       78,   78,   78,   78,   78,   78,   78,   78,   78,   78,
       78,   78,   78,   78,   78,   78,   78,   78,   78,   78,
       78,   78,   78,   78,   78,   78,   78,   78,   78,   78,
       78,   78,   78,   78,   78,   78,   78,   78,   78,   78,
       78
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
	    if ( yy_current_state >= 79 ) then
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
		    if ( yy_current_state >= 79 ) then
			yy_c := yy_meta(yy_c);
		    end if;
		end loop;
		yy_current_state := yy_nxt(yy_base(yy_current_state) + yy_c);
	    yy_cp := yy_cp + 1;
if ( yy_current_state = 78 ) then
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
--# line 8 "fun.l"
lr_atom(YYlval, pos);
	return colon;

when 2 => 
--# line 10 "fun.l"
lr_atom(YYlval, pos);
	return assig_s;

when 3 => 
--# line 12 "fun.l"
lr_atom(YYlval, pos);
	return derivator;

when 4 => 
--# line 14 "fun.l"
lr_atom(YYlval, pos);
	return arrow;

when 5 => 
--# line 16 "fun.l"
lr_atom(YYlval, pos);
	return cart_prod;

when 6 => 
--# line 18 "fun.l"
lr_atom(YYlval, pos);
	return pattern_s;

when 7 => 
--# line 20 "fun.l"
lr_atom(YYlval, pos);
	return conc;

when 8 => 
--# line 22 "fun.l"
lr_lt(YYlval, pos);
	return relop;

when 9 => 
--# line 24 "fun.l"
lr_le(YYlval, pos);
	return relop;

when 10 => 
--# line 26 "fun.l"
lr_gt(YYlval, pos);
	return relop;

when 11 => 
--# line 28 "fun.l"
lr_ge(YYlval, pos);
	return relop;

when 12 => 
--# line 30 "fun.l"
lr_eq(YYlval, pos);
	return relop;

when 13 => 
--# line 32 "fun.l"
lr_ne(YYlval, pos);
	return relop;

when 14 => 
--# line 34 "fun.l"
lr_atom(YYlval, pos);
	return plus;

when 15 => 
--# line 36 "fun.l"
lr_atom(YYlval, pos);
	return prod;

when 16 => 
--# line 38 "fun.l"
lr_atom(YYlval, pos);
	return sub;

when 17 => 
--# line 40 "fun.l"
lr_atom(YYlval, pos);
	return div;

when 18 => 
--# line 42 "fun.l"
lr_atom(YYlval, pos);
	return mod_op;

when 19 => 
--# line 44 "fun.l"
lr_atom(YYlval, pos);
	return o_par;

when 20 => 
--# line 46 "fun.l"
lr_atom(YYlval, pos);
	return c_par;

when 21 => 
--# line 48 "fun.l"
lr_atom(YYlval, pos);
	return o_braq;

when 22 => 
--# line 50 "fun.l"
lr_atom(YYlval, pos);
	return c_braq;

when 23 => 
--# line 52 "fun.l"
lr_atom(YYlval, pos);
	return semicolon;

when 24 => 
--# line 54 "fun.l"
lr_atom(YYlval, pos);
	return comma;

when 25 => 
--# line 57 "fun.l"
lr_atom(YYlval, pos);
	return rw_dec;

when 26 => 
--# line 60 "fun.l"
lr_atom(YYlval, pos);
		return rw_if;

when 27 => 
--# line 62 "fun.l"
lr_atom(YYlval, pos);
		return rw_then;

when 28 => 
--# line 64 "fun.l"
lr_atom(YYlval, pos);
		return rw_else;

when 29 => 
--# line 67 "fun.l"
lr_atom(YYlval, pos);
		return rw_data;

when 30 => 
--# line 69 "fun.l"
lr_atom(YYlval, pos);
		return rw_type;

when 31 => 
--# line 71 "fun.l"
lr_atom(YYlval, pos);
		return rw_typevar;

when 32 => 
--# line 74 "fun.l"
lr_atom(YYlval, pos);
		return and_s;

when 33 => 
--# line 76 "fun.l"
lr_atom(YYlval, pos);
		return or_s;

when 34 => 
--# line 78 "fun.l"
lr_atom(YYlval, pos);
		return not_s;

when 35 => 
--# line 82 "fun.l"
lr_ident(YYlval, pos, YYText);
							return identifier;

when 36 => 
--# line 84 "fun.l"
lr_lit_chr(YYlval, pos, YYText);
							return chr_lit;

when 37 => 
--# line 86 "fun.l"
lr_lit_int(YYlval, pos, YYText);
							return int_lit;

when 38 => 
--# line 88 "fun.l"
lr_lit_int(YYlval, pos, YYText);
							return int_lit;

when 39 => 
--# line 90 "fun.l"
lr_lit_str(YYlval, pos, YYText);
							return str_lit; 

when 40 => 
--# line 92 "fun.l"
null; 

when 41 => 
--# line 93 "fun.l"
null; 

when 42 => 
--# line 94 "fun.l"
null;

when 43 => 
--# line 95 "fun.l"
return Error;

when 44 => 
--# line 97 "fun.l"
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
--# line 97 "fun.l"
end lexical_a;

