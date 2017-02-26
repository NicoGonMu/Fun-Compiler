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
%token rw_type
%token identifier
%token chr_lit
%token int_lit
%token str_lit

%left and_s
%left or_s
%left not_s
%nonassoc relop
%left plus sub
%left mult div mod_op

%%
S:
     DECL_PROG {}
  ;

DECL_PROG:
     DECL      	    {}
  |  DECL_PROG DECL {}
  ;

DECL:
     DEF      {}
  |  BEHAVIOR {}
  |  SENT     {}
  ;

DEF: 
     DATA_DEF {}
  |  TYPE_DEF {}
  |  FUNC_DEF {}
  ;

DATA_DEF:
     rw_data identifier colon DERIVATIONS {}
  ;

DERIVATIONS:
     E			     {}
  |  E derivator DERIVATIONS {}
  ;

TYPE_DEF:
    rw_type identifier colon OPERATOR
  ;

OPERATOR:
     TYPE 		  {}
  |  OPERATOR arrow TYPE  {}
  |  o_par OPERATOR o_par {}
  ;

TYPE:
     identifier		       {}
  |  TYPE cart_prod identifier {}
  |  o_par  TYPE c_par	       {}
  |  o_braq TYPE o_braq	       {}
  ;

FUNC_DEF:
     rw_dec identifier colon OPERATOR semicolon {}
  ;

BEHAVIOR:
     s_pattern identifier o_par PATTERNS c_par assig_s E semicolon {}
  ;

PATTERNS:
     PATTERN                {}
  |  PATTERNS comma PATTERN {}
  ;

PATTERN:
     identifier              {}
  |  e_pattern               {}
  |  identifier conc PATTERN {}
  |  e_pattern  conc PATTERN {} 
  ;

SENT:
     ASSIG {}
  |  E	   {}
  ;

ASSIG:
     identifier assig_s E {}
  ;

E:
     o_par E c_par	     {}
  |  rw_let ASSIG rw_in E    {}
  |  E rw_where ASSIG        {}	     
  |  rw_if E rw_then ELSE    {}
  |  o_braq LIST c_braq	     {}
  |  o_par LIST c_par	     {}
  |  identifier		     {}
  |  LITERAL		     {}
  ;

ELSE:
     identifier			   {}
  |  identifier rw_else identifier {}
  ;

LIST:
     E	     	  {}
  |  LIST comma E {}
  ;

LITERAL:
     lit_chr {}
  |  lit_int {}
  |  lit_str {}
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
