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

%left assig_s
%left and_s
%left or_s
%left not_s
%nonassoc relop
%left plus sub
%left prod div mod_op


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
     rw_typevar LID semicolon {}
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
  |  ALTS derivator ALT {}
  ;

ALT:
     identifier		 {}
  |  identifier ALT_COMP {}
  ;

ALT_COMP:
     o_par COMP_L c_par {}
  |
  ;

COMP_L:
     ALT
  |  COMP_L comma ALT
  ;

FUNC_DECL:
     rw_dec identifier colon FORM_PARAM arrow FORM_PARAM semicolon {}
  ;

FORM_PARM:
     FORM_PARAM_L	  {}
  |  			  {}
  ;

FORM_PARAM_L:
     FORM_PARAM		       	       {}
  |  FORM_PARAM_L cart_prod FORM_PARAM {}
  ;

FORM_PARAM:
     ALT
  |  o_par ALT arrow ALT c_par
  ;

EQUATION:
     s_pattern identifier PATTERN assig_s E semicolon {}
  ;

PATTERN:
     o_par LMODELS c_par
  |
  ;

LMODELS:
     LMODELS comma MODEL
  |  MODEL
  ;

MODEL:
     ALT
  |  MODEL conc ALT
  ;

E:
     o_par E c_par       
  |  E plus E		     {}
  |  E sub E		     {}
  |  E prod E		     {}
  |  E div E		     {}
  |  E mod_op E		     {}
  |  E and_s E		     {}
  |  E or_s E		     {}
  |  not_s E		     {}
  |  sub E		     {}
  |  E relop E		     {}
  |  COND		     {}
  |  LIST_E		     {}
  |  NPLE		     {}
  |  identifier		     {}
  |  LITERAL		     {}
  |  ALT		     {}
  ;

COND:
     rw_if E rw_then ELSE {}
  ;

ELSE:
     identifier			   {}
  |  identifier rw_else identifier {}
  ;

NPLE:
     o_par LIST c_par {}
  ;

LIST:
     LIST comma E {}
  |  E            {}
  ;

LIST_E:
     o_braq LIST c_braq {}
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
