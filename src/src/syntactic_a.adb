with lexical_a, fun_dfa, fun_io, fun_shift_reduce, fun_goto, fun_Tokens, text_io, semantic.c_tree;
use lexical_a, fun_dfa, fun_io, fun_shift_reduce, fun_goto, fun_Tokens, text_io, semantic.c_tree;
package body syntactic_a is
  procedure YYError(S: in string) is
  begin
    Put_Line(S&" around line: "& Yy_Line_Number'Img);
  end YYError;
procedure YYParse is

   -- Rename User Defined Packages to Internal Names.
    package yy_goto_tables         renames
      Fun_Goto;
    package yy_shift_reduce_tables renames
      Fun_Shift_Reduce;
    package yy_tokens              renames
      Fun_Tokens;

   use yy_tokens, yy_goto_tables, yy_shift_reduce_tables;

   procedure yyerrok;
   procedure yyclearin;


   package yy is

       -- the size of the value and state stacks
       stack_size : constant Natural := 300;

       -- subtype rule         is natural;
       subtype parse_state  is natural;
       -- subtype nonterminal  is integer;

       -- encryption constants
       default           : constant := -1;
       first_shift_entry : constant :=  0;
       accept_code       : constant := -3001;
       error_code        : constant := -3000;

       -- stack data used by the parser
       tos                : natural := 0;
       value_stack        : array(0..stack_size) of yy_tokens.yystype;
       state_stack        : array(0..stack_size) of parse_state;

       -- current input symbol and action the parser is on
       action             : integer;
       rule_id            : rule;
       input_symbol       : yy_tokens.token;


       -- error recovery flag
       error_flag : natural := 0;
          -- indicates  3 - (number of valid shifts after an error occurs)

       look_ahead : boolean := true;
       index      : integer;

       -- Is Debugging option on or off
        DEBUG : constant boolean := FALSE;

    end yy;


    function goto_state
      (state : yy.parse_state;
       sym   : nonterminal) return yy.parse_state;

    function parse_action
      (state : yy.parse_state;
       t     : yy_tokens.token) return integer;

    pragma inline(goto_state, parse_action);


    function goto_state(state : yy.parse_state;
                        sym   : nonterminal) return yy.parse_state is
        index : integer;
    begin
        index := goto_offset(state);
        while  integer(goto_matrix(index).nonterm) /= sym loop
            index := index + 1;
        end loop;
        return integer(goto_matrix(index).newstate);
    end goto_state;


    function parse_action(state : yy.parse_state;
                          t     : yy_tokens.token) return integer is
        index      : integer;
        tok_pos    : integer;
        default    : constant integer := -1;
    begin
        tok_pos := yy_tokens.token'pos(t);
        index   := shift_reduce_offset(state);
        while integer(shift_reduce_matrix(index).t) /= tok_pos and then
              integer(shift_reduce_matrix(index).t) /= default
        loop
            index := index + 1;
        end loop;
        return integer(shift_reduce_matrix(index).act);
    end parse_action;

-- error recovery stuff

    procedure handle_error is
      temp_action : integer;
    begin

      if yy.error_flag = 3 then -- no shift yet, clobber input.
      if yy.debug then
          text_io.put_line("Ayacc.YYParse: Error Recovery Clobbers " &
                   yy_tokens.token'image(yy.input_symbol));
      end if;
        if yy.input_symbol = yy_tokens.end_of_input then  -- don't discard,
        if yy.debug then
            text_io.put_line("Ayacc.YYParse: Can't discard END_OF_INPUT, quiting...");
        end if;
        raise yy_tokens.syntax_error;
        end if;

            yy.look_ahead := true;   -- get next token
        return;                  -- and try again...
    end if;

    if yy.error_flag = 0 then -- brand new error
        yyerror("Syntax Error");
    end if;

    yy.error_flag := 3;

    -- find state on stack where error is a valid shift --

    if yy.debug then
        text_io.put_line("Ayacc.YYParse: Looking for state with error as valid shift");
    end if;

    loop
        if yy.debug then
          text_io.put_line("Ayacc.YYParse: Examining State " &
               yy.parse_state'image(yy.state_stack(yy.tos)));
        end if;
        temp_action := parse_action(yy.state_stack(yy.tos), error);

            if temp_action >= yy.first_shift_entry then
                if yy.tos = yy.stack_size then
                    text_io.put_line(" Stack size exceeded on state_stack");
                    raise yy_Tokens.syntax_error;
                end if;
                yy.tos := yy.tos + 1;
                yy.state_stack(yy.tos) := temp_action;
                exit;
            end if;

        Decrement_Stack_Pointer :
        begin
          yy.tos := yy.tos - 1;
        exception
          when Constraint_Error =>
            yy.tos := 0;
        end Decrement_Stack_Pointer;

        if yy.tos = 0 then
          if yy.debug then
            text_io.put_line("Ayacc.YYParse: Error recovery popped entire stack, aborting...");
          end if;
          raise yy_tokens.syntax_error;
        end if;
    end loop;

    if yy.debug then
        text_io.put_line("Ayacc.YYParse: Shifted error token in state " &
              yy.parse_state'image(yy.state_stack(yy.tos)));
    end if;

    end handle_error;

   -- print debugging information for a shift operation
   procedure shift_debug(state_id: yy.parse_state; lexeme: yy_tokens.token) is
   begin
       text_io.put_line("Ayacc.YYParse: Shift "& yy.parse_state'image(state_id)&" on input symbol "&
               yy_tokens.token'image(lexeme) );
   end;

   -- print debugging information for a reduce operation
   procedure reduce_debug(rule_id: rule; state_id: yy.parse_state) is
   begin
       text_io.put_line("Ayacc.YYParse: Reduce by rule "&rule'image(rule_id)&" goto state "&
               yy.parse_state'image(state_id));
   end;

   -- make the parser believe that 3 valid shifts have occured.
   -- used for error recovery.
   procedure yyerrok is
   begin
       yy.error_flag := 0;
   end yyerrok;

   -- called to clear input symbol that caused an error.
   procedure yyclearin is
   begin
       -- yy.input_symbol := yylex;
       yy.look_ahead := true;
   end yyclearin;


begin
    -- initialize by pushing state 0 and getting the first input symbol
    yy.state_stack(yy.tos) := 0;


    loop

        yy.index := shift_reduce_offset(yy.state_stack(yy.tos));
        if integer(shift_reduce_matrix(yy.index).t) = yy.default then
            yy.action := integer(shift_reduce_matrix(yy.index).act);
        else
            if yy.look_ahead then
                yy.look_ahead   := false;

                yy.input_symbol := yylex;
            end if;
            yy.action :=
             parse_action(yy.state_stack(yy.tos), yy.input_symbol);
        end if;


        if yy.action >= yy.first_shift_entry then  -- SHIFT

            if yy.debug then
                shift_debug(yy.action, yy.input_symbol);
            end if;

            -- Enter new state
            if yy.tos = yy.stack_size then
                text_io.put_line(" Stack size exceeded on state_stack");
                raise yy_Tokens.syntax_error;
            end if;
            yy.tos := yy.tos + 1;
            yy.state_stack(yy.tos) := yy.action;
              yy.value_stack(yy.tos) := yylval;

        if yy.error_flag > 0 then  -- indicate a valid shift
            yy.error_flag := yy.error_flag - 1;
        end if;

            -- Advance lookahead
            yy.look_ahead := true;

        elsif yy.action = yy.error_code then       -- ERROR

            handle_error;

        elsif yy.action = yy.accept_code then
            if yy.debug then
                text_io.put_line("Ayacc.YYParse: Accepting Grammar...");
            end if;
            exit;

        else -- Reduce Action

            -- Convert action into a rule
            yy.rule_id  := -1 * yy.action;

            -- Execute User Action
            -- user_action(yy.rule_id);


                case yy.rule_id is

when  1 =>
--#line  37
sr_s(
yy.value_stack(yy.tos));

when  2 =>
--#line  41
sr_prog(
yyval, 
yy.value_stack(yy.tos-1), 
yy.value_stack(yy.tos));

when  3 =>
--#line  45
sr_decls(
yyval, 
yy.value_stack(yy.tos-1), 
yy.value_stack(yy.tos));

when  4 =>
--#line  46
sr_decls(
yyval);

when  5 =>
--#line  50
sr_typevar_decl(
yyval, 
yy.value_stack(yy.tos));

when  6 =>
--#line  51
sr_type_decl(
yyval, 
yy.value_stack(yy.tos));

when  7 =>
--#line  52
sr_func_decl(
yyval, 
yy.value_stack(yy.tos));

when  8 =>
--#line  53
sr_eq_decl(
yyval, 
yy.value_stack(yy.tos));

when  9 =>
--#line  58
sr_typevar(
yyval, 
yy.value_stack(yy.tos-1));

when  10 =>
--#line  62
sr_lid(
yyval, 
yy.value_stack(yy.tos-2), 
yy.value_stack(yy.tos));

when  11 =>
--#line  63
sr_lid(
yyval, 
yy.value_stack(yy.tos));

when  12 =>
--#line  68
sr_type(
yyval, 
yy.value_stack(yy.tos-3), 
yy.value_stack(yy.tos-1));

when  13 =>
--#line  72
sr_alts(
yyval, 
yy.value_stack(yy.tos));

when  14 =>
--#line  73
sr_alts(
yyval, 
yy.value_stack(yy.tos-2), 
yy.value_stack(yy.tos));

when  15 =>
--#line  77
sr_fcall(
yyval, 
yy.value_stack(yy.tos-1), 
yy.value_stack(yy.tos));

when  16 =>
--#line  81
sr_params(
yyval, 
yy.value_stack(yy.tos-1));

when  17 =>
--#line  82
sr_params(
yyval);

when  18 =>
--#line  86
sr_el(
yyval, 
yy.value_stack(yy.tos));

when  19 =>
--#line  87
sr_el(
yyval, 
yy.value_stack(yy.tos-2), 
yy.value_stack(yy.tos));

when  20 =>
--#line  91
sr_func(
yyval, 
yy.value_stack(yy.tos-5), 
yy.value_stack(yy.tos-3), 
yy.value_stack(yy.tos-1));

when  21 =>
--#line  95
sr_fparam(
yyval, 
yy.value_stack(yy.tos));

when  22 =>
--#line  96
sr_fparam(
yyval);

when  23 =>
--#line  100
sr_param_list(
yyval, 
yy.value_stack(yy.tos));

when  24 =>
--#line  101
sr_param_list(
yyval, 
yy.value_stack(yy.tos-2), 
yy.value_stack(yy.tos));

when  25 =>
--#line  105
sr_fp(
yyval, 
yy.value_stack(yy.tos));

when  26 =>
--#line  106
sr_fp(
yyval, 
yy.value_stack(yy.tos-3), 
yy.value_stack(yy.tos-1));

when  27 =>
--#line  110
sr_equation(
yyval, 
yy.value_stack(yy.tos-4), 
yy.value_stack(yy.tos-3), 
yy.value_stack(yy.tos-1));

when  28 =>
--#line  114
sr_pattern(
yyval, 
yy.value_stack(yy.tos-1));

when  29 =>
--#line  115
sr_pattern(
yyval);

when  30 =>
--#line  119
sr_lmodels(
yyval, 
yy.value_stack(yy.tos-2), 
yy.value_stack(yy.tos));

when  31 =>
--#line  120
sr_lmodels(
yyval, 
yy.value_stack(yy.tos));

when  32 =>
--#line  124
sr_model(
yyval, 
yy.value_stack(yy.tos));

when  33 =>
--#line  125
sr_model(
yyval, 
yy.value_stack(yy.tos-2), 
yy.value_stack(yy.tos));

when  34 =>
--#line  129
sr_e(
yyval, 
yy.value_stack(yy.tos-1));

when  35 =>
--#line  130
sr_plus(
yyval, 
yy.value_stack(yy.tos-2), 
yy.value_stack(yy.tos));

when  36 =>
--#line  131
sr_sub(
yyval, 
yy.value_stack(yy.tos-2), 
yy.value_stack(yy.tos));

when  37 =>
--#line  132
sr_prod(
yyval, 
yy.value_stack(yy.tos-2), 
yy.value_stack(yy.tos));

when  38 =>
--#line  133
sr_div(
yyval, 
yy.value_stack(yy.tos-2), 
yy.value_stack(yy.tos));

when  39 =>
--#line  134
sr_mod(
yyval, 
yy.value_stack(yy.tos-2), 
yy.value_stack(yy.tos));

when  40 =>
--#line  135
sr_and(
yyval, 
yy.value_stack(yy.tos-2), 
yy.value_stack(yy.tos));

when  41 =>
--#line  136
sr_or(
yyval, 
yy.value_stack(yy.tos-2), 
yy.value_stack(yy.tos));

when  42 =>
--#line  137
sr_relop(
yyval, 
yy.value_stack(yy.tos-2), 
yy.value_stack(yy.tos-1), 
yy.value_stack(yy.tos));

when  43 =>
--#line  138
sr_not(
yyval, 
yy.value_stack(yy.tos));

when  44 =>
--#line  139
sr_usub(
yyval, 
yy.value_stack(yy.tos));

when  45 =>
--#line  140
sr_econd(
yyval, 
yy.value_stack(yy.tos));

when  46 =>
--#line  141
sr_elist(
yyval, 
yy.value_stack(yy.tos));

when  47 =>
--#line  142
sr_tuple(
yyval, 
yy.value_stack(yy.tos));

when  48 =>
--#line  143
sr_elit(
yyval, 
yy.value_stack(yy.tos));

when  49 =>
--#line  144
sr_efcall(
yyval, 
yy.value_stack(yy.tos));

when  50 =>
--#line  148
sr_cond(
yyval, 
yy.value_stack(yy.tos-4), 
yy.value_stack(yy.tos-2));

when  51 =>
--#line  152
sr_tuple(
yyval, 
yy.value_stack(yy.tos-1));

when  52 =>
--#line  156
sr_list_e(
yyval, 
yy.value_stack(yy.tos-1));

when  53 =>
--#line  160
sr_list(
yyval, 
yy.value_stack(yy.tos-2), 
yy.value_stack(yy.tos));

when  54 =>
--#line  161
sr_list(
yyval, 
yy.value_stack(yy.tos));

when  55 =>
--#line  165
sr_lit(
yyval, 
yy.value_stack(yy.tos));

when  56 =>
--#line  166
sr_lit(
yyval, 
yy.value_stack(yy.tos));

when  57 =>
--#line  167
sr_lit(
yyval, 
yy.value_stack(yy.tos));

                    when others => null;
                end case;


            -- Pop RHS states and goto next state
            yy.tos      := yy.tos - rule_length(yy.rule_id) + 1;
            if yy.tos > yy.stack_size then
                text_io.put_line(" Stack size exceeded on state_stack");
                raise yy_Tokens.syntax_error;
            end if;
            yy.state_stack(yy.tos) := goto_state(yy.state_stack(yy.tos-1) ,
                                 get_lhs_rule(yy.rule_id));

              yy.value_stack(yy.tos) := yyval;

            if yy.debug then
                reduce_debug(yy.rule_id,
                    goto_state(yy.state_stack(yy.tos - 1),
                               get_lhs_rule(yy.rule_id)));
            end if;

        end if;


    end loop;


end yyparse;
end syntactic_a;
