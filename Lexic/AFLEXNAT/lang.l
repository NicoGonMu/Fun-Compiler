LETTER	[A-Za-z]
DIGIT	[0-9]
REPCAR	[\040-\176]
REPCARNOQUO	[\040-\041\043-\176]

%%

":"	{rl_atom(YYlval, pos);
	return colon;}
"=="	{rl_assig(YYlval, pos);
	return assig;}
"++"	{rl_derivator(YYlval, pos);
	return derivator;}
"->"	{rl_arrow(YYlval, pos);
	return arrow;}
"\\"	{rl_lambda(YYlval, pos);
	return lambda;}
"#"	{rl_cart_prod(YYlval, pos);
	return cart_prod;}
"---"	{rl_pattern(YYlval, pos);
	return pattern;}
"::"	{rl_conc(YYlval, pos);
	return conc;}
"_"	{rl_e_pattern(YYlval, pos);
	return e_pattern;}
"&"	{rl_rename(YYlval, pos);
	return rename;}
"<"	{rl_lt(YYlval, pos);
	return oprel;}
"<="	{rl_le(YYlval, pos);
	return oprel;}
">"	{rl_gt(YYlval, pos);
	return oprel;}
">="	{rl_ge(YYlval, pos);
	return oprel;}
"="	{rl_equal(YYlval, pos);
	return oprel;}
"/="	{rl_ne(YYlval, pos);
	return oprel;}
"+"	{rl_atom(YYlval, pos);
	return plus;}
"*"	{rl_atom(YYlval, pos);
	return mult;}
"-"	{rl_atom(YYlval, pos);
	return sub;}
"/"	{rl_atom(YYlval, pos);
	return div;}
"%"	{rl_atom(YYlval, pos);
	return op_mod;}
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
"<>"	{rl_atom(YYlval, pos);
	return cons;}
","	{rl_atom(YYlval, pos);
	return comma;}
"."	{rl_atom(YYlval, pos);
	return dot;}


dec	{rl_atom(YYlval, pos);
	return pc_dec;}
let	{rl_atom(YYlval, pos);
	return pc_let;}
in	{rl_atom(YYlval, pos);
	return pc_in;}
where	{rl_atom(YYlval, pos);
	return pc_where;}


if		{rl_atom(YYlval, pos);
		return pc_if;}
then		{rl_atom(YYlval, pos);
		return pc_then;}
else		{rl_atom(YYlval, pos);
		return pc_else;}

data 		{rl_atom(YYlval, pos);
		return pc_data;}
type 		{rl_atom(YYlval, pos);
		return pc_type;}

"&&"		{rl_atom(YYlval, pos);
		return pc_and;}
"|"		{rl_atom(YYlval, pos);
		return pc_or;}
"!"		{rl_atom(YYlval, pos);
		return pc_not;}


{LETTER}(_?({LETTER}|{DIGIT}))*				{rl_ident(YYlval, pos, YYText);
							return identificador;}
'{REPCAR}'						{rl_lit_car(YYlval, pos, YYText);
							return lit_car;}
{DIGIT}*				        	{rl_lit_ent(YYlval, pos, YYText);
							return lit_ent;}
{DIGIT}{DIGIT}?{DIGIT}?(_{DIGIT}{DIGIT}{DIGIT})* 	{rl_lit_ent(YYlval, pos, YYText);
							return lit_ent;}
\"({REPCARNOQUO}|(\"\"))*\"				{rl_lit_str(YYlval, pos, YYText);
							return lit_str;} 
"--"[^\n]*				{null;} 
[ \t\r]+				{null;} 
\n					{null;}
.					{return Error;}

%%
with lang_tokens;
use lang_tokens;
package lexical_a is
  procedure open(s: in string);
  procedure close;
  function YYlex return Token;
end lexical_a;

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
##
end lexical_a;
