
with fun_io, fun_dfa, decls.general_defs, semantic.tree_c;
use fun_io, fun_dfa, decls.general_defs, semantic.tree_c;
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
YY_END_OF_BUFFER : constant := 49;
subtype yy_state_type is integer;
yy_current_state : yy_state_type;
INITIAL : constant := 0;
yy_accept : constant array(0..85) of short :=
    (   0,
       41,   41,   49,   47,   45,   46,   38,   47,    6,   20,
       47,   47,   21,   22,   17,   16,   26,   18,   19,   41,
        1,   25,   10,   14,   12,   39,   23,    5,   24,    9,
       39,   39,   39,   39,   39,   39,   37,   45,    0,   43,
       36,    0,    3,   44,    4,   15,   41,    0,    8,    2,
       11,   13,   39,    0,   39,   39,   39,   31,   29,   39,
       39,   39,   39,   40,   44,    7,   41,    0,   39,   27,
       39,   28,   39,   39,   39,   41,    0,   34,   33,   32,
       35,   39,   42,   30,    0
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
       26,   27,   28,    8,   29,    8,   30,   25,   31,   32,

       33,   34,   25,   35,   36,   25,   25,   37,   25,   38,
       25,   39,   25,   40,   41,   42,   25,   25,   43,   25,
       44,   25,    8,   45,    8,    8,    1
    ) ;

yy_meta : constant array(0..45) of short :=
    (   0,
        1,    1,    2,    3,    3,    3,    3,    3,    3,    3,
        3,    3,    3,    3,    3,    3,    3,    3,    4,    3,
        3,    3,    3,    3,    4,    3,    3,    3,    4,    4,
        4,    4,    4,    4,    4,    4,    4,    4,    4,    4,
        4,    4,    4,    4,    3
    ) ;

yy_base : constant array(0..89) of short :=
    (   0,
        0,    0,  136,  137,   44,  137,  137,  129,  137,  137,
      124,    0,  137,  137,  137,  118,  137,   30,  109,   30,
       30,  137,  108,  137,  107,  100,  137,  137,  137,  137,
       22,   27,   28,   32,   34,   38,  137,   56,  122,  121,
      137,  115,  137,  108,  137,  137,   51,  105,  137,  137,
      137,  137,   94,   93,   39,   43,   42,   92,   91,   46,
       53,   48,   56,  137,    0,    0,   65,  100,   61,   89,
       63,   88,   64,   66,   68,   95,   88,   77,   76,   74,
       72,   71,   69,   50,  137,  106,  108,   72,  112
    ) ;

yy_def : constant array(0..89) of short :=
    (   0,
       85,    1,   85,   85,   85,   85,   85,   86,   85,   85,
       85,   87,   85,   85,   85,   85,   85,   85,   85,   85,
       85,   85,   85,   85,   85,   88,   85,   85,   85,   85,
       88,   88,   88,   88,   88,   88,   85,   85,   86,   85,
       85,   85,   85,   89,   85,   85,   85,   85,   85,   85,
       85,   85,   88,   88,   88,   88,   88,   88,   88,   88,
       88,   88,   88,   85,   89,   89,   85,   85,   88,   88,
       88,   88,   88,   88,   88,   85,   85,   88,   88,   88,
       88,   88,   85,   88,    0,   85,   85,   85,   85
    ) ;

yy_nxt : constant array(0..182) of short :=
    (   0,
        4,    5,    6,    5,    7,    8,    9,    4,   10,   11,
       12,   13,   14,   15,   16,   17,   18,   19,   20,   21,
       22,   23,   24,   25,   26,   27,   28,   29,   30,   26,
       26,   31,   32,   26,   26,   33,   34,   26,   26,   26,
       26,   35,   36,   26,   37,   38,   44,   38,   47,   49,
       54,   55,   50,   45,   56,   54,   54,   38,   48,   38,
       54,   58,   54,   57,   60,   59,   54,   54,   61,   67,
       54,   54,   63,   70,   54,   53,   54,   62,   54,   48,
       69,   54,   71,   76,   54,   73,   74,   72,   75,   54,
       78,   54,   54,   48,   54,   79,   54,   48,   81,   54,

       54,   80,   54,   84,   54,   54,   83,   82,   39,   39,
       42,   42,   65,   76,   65,   65,   54,   54,   77,   54,
       54,   85,   54,   68,   66,   64,   39,   40,   54,   52,
       51,   46,   43,   41,   40,   85,    3,   85,   85,   85,
       85,   85,   85,   85,   85,   85,   85,   85,   85,   85,
       85,   85,   85,   85,   85,   85,   85,   85,   85,   85,
       85,   85,   85,   85,   85,   85,   85,   85,   85,   85,
       85,   85,   85,   85,   85,   85,   85,   85,   85,   85,
       85,   85
    ) ;

yy_chk : constant array(0..182) of short :=
    (   0,
        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
        1,    1,    1,    1,    1,    5,   18,    5,   20,   21,
       31,   31,   21,   18,   31,   32,   33,   38,   20,   38,
       34,   33,   35,   32,   34,   33,   36,   55,   35,   47,
       57,   56,   36,   56,   60,   88,   62,   35,   84,   47,
       55,   61,   57,   67,   63,   61,   62,   60,   63,   69,
       69,   71,   73,   67,   74,   71,   75,   83,   74,   82,

       81,   73,   80,   82,   79,   78,   77,   75,   86,   86,
       87,   87,   89,   76,   89,   89,   72,   70,   68,   59,
       58,   54,   53,   48,   44,   42,   40,   39,   26,   25,
       23,   19,   16,   11,    8,    3,   85,   85,   85,   85,
       85,   85,   85,   85,   85,   85,   85,   85,   85,   85,
       85,   85,   85,   85,   85,   85,   85,   85,   85,   85,
       85,   85,   85,   85,   85,   85,   85,   85,   85,   85,
       85,   85,   85,   85,   85,   85,   85,   85,   85,   85,
       85,   85
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
	    if ( yy_current_state >= 86 ) then
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
		    if ( yy_current_state >= 86 ) then
			yy_c := yy_meta(yy_c);
		    end if;
		end loop;
		yy_current_state := yy_nxt(yy_base(yy_current_state) + yy_c);
	    yy_cp := yy_cp + 1;
if ( yy_current_state = 85 ) then
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
rl_atom(YYlval, pos);
	return colon;

when 2 => 
--# line 10 "fun.l"
rl_assig(YYlval, pos);
	return assig_s;

when 3 => 
--# line 12 "fun.l"
rl_derivator(YYlval, pos);
	return derivator;

when 4 => 
--# line 14 "fun.l"
rl_arrow(YYlval, pos);
	return arrow;

when 5 => 
--# line 16 "fun.l"
rl_lambda(YYlval, pos);
	return lambda;

when 6 => 
--# line 18 "fun.l"
rl_cart_prod(YYlval, pos);
	return cart_prod;

when 7 => 
--# line 20 "fun.l"
rl_pattern(YYlval, pos);
	return pattern_s;

when 8 => 
--# line 22 "fun.l"
rl_conc(YYlval, pos);
	return conc;

when 9 => 
--# line 24 "fun.l"
rl_e_pattern(YYlval, pos);
	return e_pattern;

when 10 => 
--# line 26 "fun.l"
rl_lt(YYlval, pos);
	return relop;

when 11 => 
--# line 28 "fun.l"
rl_le(YYlval, pos);
	return relop;

when 12 => 
--# line 30 "fun.l"
rl_gt(YYlval, pos);
	return relop;

when 13 => 
--# line 32 "fun.l"
rl_ge(YYlval, pos);
	return relop;

when 14 => 
--# line 34 "fun.l"
rl_equal(YYlval, pos);
	return relop;

when 15 => 
--# line 36 "fun.l"
rl_ne(YYlval, pos);
	return relop;

when 16 => 
--# line 38 "fun.l"
rl_atom(YYlval, pos);
	return plus;

when 17 => 
--# line 40 "fun.l"
rl_atom(YYlval, pos);
	return mult;

when 18 => 
--# line 42 "fun.l"
rl_atom(YYlval, pos);
	return sub;

when 19 => 
--# line 44 "fun.l"
rl_atom(YYlval, pos);
	return div;

when 20 => 
--# line 46 "fun.l"
rl_atom(YYlval, pos);
	return mod_op;

when 21 => 
--# line 48 "fun.l"
rl_atom(YYlval, pos);
	return o_par;

when 22 => 
--# line 50 "fun.l"
rl_atom(YYlval, pos);
	return c_par;

when 23 => 
--# line 52 "fun.l"
rl_atom(YYlval, pos);
	return o_braq;

when 24 => 
--# line 54 "fun.l"
rl_atom(YYlval, pos);
	return c_braq;

when 25 => 
--# line 56 "fun.l"
rl_atom(YYlval, pos);
	return semicolon;

when 26 => 
--# line 58 "fun.l"
rl_atom(YYlval, pos);
	return comma;

when 27 => 
--# line 63 "fun.l"
rl_atom(YYlval, pos);
	return rw_dec;

when 28 => 
--# line 65 "fun.l"
rl_atom(YYlval, pos);
	return rw_let;

when 29 => 
--# line 67 "fun.l"
rl_atom(YYlval, pos);
	return rw_in;

when 30 => 
--# line 69 "fun.l"
rl_atom(YYlval, pos);
	return rw_where;

when 31 => 
--# line 73 "fun.l"
rl_atom(YYlval, pos);
		return rw_if;

when 32 => 
--# line 75 "fun.l"
rl_atom(YYlval, pos);
		return rw_then;

when 33 => 
--# line 77 "fun.l"
rl_atom(YYlval, pos);
		return rw_else;

when 34 => 
--# line 80 "fun.l"
rl_atom(YYlval, pos);
		return rw_data;

when 35 => 
--# line 82 "fun.l"
rl_atom(YYlval, pos);
		return rw_type;

when 36 => 
--# line 85 "fun.l"
rl_atom(YYlval, pos);
		return and_s;

when 37 => 
--# line 87 "fun.l"
rl_atom(YYlval, pos);
		return or_s;

when 38 => 
--# line 89 "fun.l"
rl_atom(YYlval, pos);
		return not_s;

when 39 => 
--# line 93 "fun.l"
rl_ident(YYlval, pos, YYText);
							return identifier;

when 40 => 
--# line 95 "fun.l"
rl_lit_car(YYlval, pos, YYText);
							return chr_lit;

when 41 => 
--# line 97 "fun.l"
rl_lit_ent(YYlval, pos, YYText);
							return int_lit;

when 42 => 
--# line 99 "fun.l"
rl_lit_ent(YYlval, pos, YYText);
							return int_lit;

when 43 => 
--# line 101 "fun.l"
rl_lit_str(YYlval, pos, YYText);
							return str_lit; 

when 44 => 
--# line 103 "fun.l"
null; 

when 45 => 
--# line 104 "fun.l"
null; 

when 46 => 
--# line 105 "fun.l"
null;

when 47 => 
--# line 106 "fun.l"
return Error;

when 48 => 
--# line 108 "fun.l"
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
--# line 108 "fun.l"
end lexical_a;

