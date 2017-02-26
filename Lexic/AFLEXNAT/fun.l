LETTER	[A-Za-z]
DIGIT	[0-9]
REPCHAR	[\040-\176]
REPCHARNOQUO	[\040-\041\043-\176]

%%

":"	{rl_atom(YYlval, pos);
	return colon;}
":="	{rl_assig(YYlval, pos);
	return assig_s;}
"++"	{rl_derivator(YYlval, pos);
	return derivator;}
"->"	{rl_arrow(YYlval, pos);
	return arrow;}
"\\"	{rl_lambda(YYlval, pos);
	return lambda;}
"#"	{rl_cart_prod(YYlval, pos);
	return cart_prod;}
"---"	{rl_pattern(YYlval, pos);
	return pattern_s;}
"::"	{rl_conc(YYlval, pos);
	return conc;}
"_"	{rl_e_pattern(YYlval, pos);
	return e_pattern;}
"<"	{rl_lt(YYlval, pos);
	return relop;}
"<="	{rl_le(YYlval, pos);
	return relop;}
">"	{rl_gt(YYlval, pos);
	return relop;}
">="	{rl_ge(YYlval, pos);
	return relop;}
"="	{rl_equal(YYlval, pos);
	return relop;}
"/="	{rl_ne(YYlval, pos);
	return relop;}
"+"	{rl_atom(YYlval, pos);
	return plus;}
"*"	{rl_atom(YYlval, pos);
	return mult;}
"-"	{rl_atom(YYlval, pos);
	return sub;}
"/"	{rl_atom(YYlval, pos);
	return div;}
"%"	{rl_atom(YYlval, pos);
	return mod_op;}
"("	{rl_atom(YYlval, pos);
	return o_par;}
")"	{rl_atom(YYlval, pos);
	return c_par;}
"["	{rl_atom(YYlval, pos);
	return o_braq;}
"]"	{rl_atom(YYlval, pos);
	return c_braq;}
";"	{rl_atom(YYlval, pos);
	return semicolon;}
","	{rl_atom(YYlval, pos);
	return comma;}



dec	{rl_atom(YYlval, pos);
	return rw_dec;}
let	{rl_atom(YYlval, pos);
	return rw_let;}
in	{rl_atom(YYlval, pos);
	return rw_in;}
where	{rl_atom(YYlval, pos);
	return rw_where;}


if		{rl_atom(YYlval, pos);
		return rw_if;}
then		{rl_atom(YYlval, pos);
		return rw_then;}
else		{rl_atom(YYlval, pos);
		return rw_else;}

data 		{rl_atom(YYlval, pos);
		return rw_data;}
type 		{rl_atom(YYlval, pos);
		return rw_type;}

"&&"		{rl_atom(YYlval, pos);
		return and_s;}
"|"		{rl_atom(YYlval, pos);
		return or_s;}
"!"		{rl_atom(YYlval, pos);
		return not_s;}


{LETTER}(_?({LETTER}|{DIGIT}))*				{rl_ident(YYlval, pos, YYText);
							return identifier;}
'{REPCHAR}'						{rl_lit_car(YYlval, pos, YYText);
							return chr_lit;}
{DIGIT}*				        	{rl_lit_ent(YYlval, pos, YYText);
							return int_lit;}
{DIGIT}{DIGIT}?{DIGIT}?(_{DIGIT}{DIGIT}{DIGIT})* 	{rl_lit_ent(YYlval, pos, YYText);
							return int_lit;}
\"({REPCHARNOQUO}|(\"\"))*\"				{rl_lit_str(YYlval, pos, YYText);
							return str_lit;} 
"--"[^\n]*				{null;} 
[ \t\r]+				{null;} 
\n					{null;}
.					{return Error;}

%%
with fun_tokens;
use fun_tokens;
package lexical_a is
  procedure open(s: in string);
  procedure close;
  function YYlex return Token;
end lexical_a;

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
##
end lexical_a;
