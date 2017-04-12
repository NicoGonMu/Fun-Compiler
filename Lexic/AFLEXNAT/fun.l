LETTER	[A-Za-z]
DIGIT	[0-9]
REPCHAR	[\040-\176]
REPCHARNOQUO	[\040-\041\043-\176]

%%

":"	{lr_atom(YYlval, pos);
	return colon;}
":="	{lr_atom(YYlval, pos);
	return assig_s;}
"++"	{lr_atom(YYlval, pos);
	return derivator;}
"->"	{lr_atom(YYlval, pos);
	return arrow;}
"#"	{lr_atom(YYlval, pos);
	return cart_prod;}
"---"	{lr_atom(YYlval, pos);
	return pattern_s;}
"::"	{lr_atom(YYlval, pos);
	return conc;}
"<"	{lr_lt(YYlval, pos);
	return relop;}
"<="	{lr_le(YYlval, pos);
	return relop;}
">"	{lr_gt(YYlval, pos);
	return relop;}
">="	{lr_ge(YYlval, pos);
	return relop;}
"="	{lr_eq(YYlval, pos);
	return relop;}
"/="	{lr_ne(YYlval, pos);
	return relop;}
"+"	{lr_atom(YYlval, pos);
	return plus;}
"*"	{lr_atom(YYlval, pos);
	return prod;}
"-"	{lr_atom(YYlval, pos);
	return sub;}
"/"	{lr_atom(YYlval, pos);
	return div;}
"%"	{lr_atom(YYlval, pos);
	return mod_op;}
"("	{lr_atom(YYlval, pos);
	return o_par;}
")"	{lr_atom(YYlval, pos);
	return c_par;}
"["	{lr_atom(YYlval, pos);
	return o_braq;}
"]"	{lr_atom(YYlval, pos);
	return c_braq;}
";"	{lr_atom(YYlval, pos);
	return semicolon;}
","	{lr_atom(YYlval, pos);
	return comma;}

dec	{lr_atom(YYlval, pos);
	return rw_dec;}

if		{lr_atom(YYlval, pos);
		return rw_if;}
then		{lr_atom(YYlval, pos);
		return rw_then;}
else		{lr_atom(YYlval, pos);
		return rw_else;}

data 		{lr_atom(YYlval, pos);
		return rw_data;}

"&&"		{lr_atom(YYlval, pos);
		return and_s;}
"|"		{lr_atom(YYlval, pos);
		return or_s;}
"!"		{lr_atom(YYlval, pos);
		return not_s;}


{LETTER}(_?({LETTER}|{DIGIT}))*				{lr_ident(YYlval, pos, YYText);
							return identifier;}
'{REPCHAR}'						{lr_lit_chr(YYlval, pos, YYText);
							return chr_lit;}
{DIGIT}*				        	{lr_lit_int(YYlval, pos, YYText);
							return int_lit;}
{DIGIT}{DIGIT}?{DIGIT}?(_{DIGIT}{DIGIT}{DIGIT})* 	{lr_lit_int(YYlval, pos, YYText);
							return int_lit;}
\"({REPCHARNOQUO}|(\"\"))*\"				{lr_lit_str(YYlval, pos, YYText);
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
##
end lexical_a;
