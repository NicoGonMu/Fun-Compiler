%token colon
%token assig_s
%token derivator
%token arrow
%token lambda
%token cart_prod
%token s_pattern
%token conc
%token e_pattern
%token o_par
%token c_par
%token o_braq
%token c_braq
%token semicolon
%token comma
%token rw_dec
%token rw_let
%token rw_in
%token rw_where
%token rw_if
%token rw_then
%token rw_else
%token rw_data
%token rw_typevar
%token identifier
%token chr_lit
%token int_lit
%token str_lit

%left rw_where
%left rw_in
%left assig_s
%left and_s
%left or_s
%left not_s
%nonassoc relop
%left plus sub
%left mult div mod_op


%%
S:
     DECLS {}
  ;

DECLS:
     DECLS DECL {}
  |  		{}
  ;

DECL:
     TYPEVAR_DECL {}
  |  TYPE_DECL    {}
  |  FUNC_DECL    {}
  |  EQUATION     {}
  ;


TYPEVAR_DECL:
     rw_typevar LID semicolon
  ;

LID:
     identifier		  {}
  |  LID comma identifier {}
  ;


TYPE_DECL:
     rw_data identifier colon ALTS semicolon {}
  ;

ALTS:
     ALT                {}
  |  ALT derivator ALTS {}
  ;

ALT:
     identifier			{}
  |  identifier o_par LID c_par {}
  ;


FUNC_DECL:
     rw_dec identifier colon TYPE_EXP semicolon {}
  ;

TYPE_EXP:
     TYPE		  {}
  |  TYPE_EXP arrow TYPE  {}
  |  o_par TYPE_EXP c_par {}
  ;

TYPE:
     identifier		       {}
  |  TYPE cart_prod identifier {}
  |  o_braq identifier o_braq  {}
  ;

EQUATION:
     s_pattern identifier o_par LPATTERNS c_par assig_s E semicolon {}
  ;

LPATTERNS:
     PATTERN                 {}
  |  LPATTERNS comma PATTERN {}
  ;

PATTERN:
     identifier              {}
  |  e_pattern               {}
  |  PATTERN conc identifier {}
  |  PATTERN conc e_pattern  {} 
  ;


E:   
     rw_let ASSIG rw_in E    {}	
  |  E rw_where ASSIG	     {}     
  |  rw_if E rw_then ELSE    {}
  |  o_braq LIST c_braq	     {}
  |  o_par LIST c_par	     {}
  |  OP			     {}
  |  identifier		     {}
  |  LITERAL		     {}
  ;

ASSIG:
     identifier assig_s E {}
  ;


ELSE:
     identifier			   {}
  |  identifier rw_else identifier {}
  ;

LIST:
     E	     	  {}
  |  LIST comma E {}
  ;

OP:
     and_s	{}
  |  or_s	{}
  |  not_s	{}
  |  relop	{}
  |  plus	{}
  |  sub	{}
  |  mult	{}
  |  div	{}
  |  mod_op	{}     
  ;

LITERAL:
     chr_lit {}
  |  int_lit {}
  |  str_lit {}
  ;
     

%%
package syntactic_a is
  procedure yyparse;
end syntactic_a;
with lexical_a, fun_dfa, fun_io, fun_shift_reduce, fun_goto, fun_Tokens, text_io, semantic.c_arbre;
use lexical_a, fun_dfa, fun_io, fun_shift_reduce, fun_goto, fun_Tokens, text_io, semantic.c_arbre;
package body syntactic_a is
  procedure YYError(S: in string) is
  begin
    Put_Line(S&" around line: "& Yy_Line_Number'Img);
  end YYError;
##
end syntactic_a;
