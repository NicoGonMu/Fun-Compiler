%token pc_procedure
%token pc_in
%token pc_out
%token pc_loop
%token pc_end
%token pc_is
%token pc_begin
%token pc_while
%token pc_if
%token pc_else
%token pc_record
%token pc_type
%token pc_of
%token pc_array
%token pc_then
%token pc_constante
%token pc_rango
%token pc_new
%token identificador
%token lit_car
%token lit_ent
%token lit_str
%token a_par
%token c_par
%token p_coma
%token coma
%token punto
%token dos_puntos
%token asig

%left pc_or
%left pc_and
%left pc_not
%nonassoc oprel
%left mas menos
%left  menysunit
%left por dividir pc_mod

%with decls.d_arbre
 {subtype yystype is decls.d_arbre.pnode;}

%%
S:
      DECL_PROG	     {rs_s($1);}
   ;

DECL_PROG:
     pc_procedure identificador ARGS pc_is DECLS pc_begin LSENT pc_end identificador p_coma  {rs_decl_proc($$, $2, $3, $5, $7, $9);}
  ; 
ARGS:
     a_par LARGS c_par {rs_args($$, $2);}
  |  		       {rs_args($$);}	
  ;
LARGS:
     LARGS p_coma ARG {rs_largs($$, $1, $3);}
  |  ARG	      {rs_largs($$, $1);}
  ;
ARG:
     identificador dos_puntos MODE identificador  {rs_arg($$, $1, $3, $4);}
  ;
MODE:
     pc_in     {rs_mode_in($$);}
  |  pc_out    {rs_mode_out($$);}
  ;
DECLS:
     DECLS DECL  {rs_decls($$, $1, $2);}
  |  		 {rs_decls($$);}
  ;
DECL:
     DECL_TIPO   {rs_decl($$, $1);}
  |  DECL_CONST  {rs_decl($$, $1);}
  |  DECL_VAR    {rs_decl($$, $1);}
  |  DECL_PROG   {rs_decl($$, $1);}
  ;
DECL_TIPO:
     DECL_SUBRANGO  {rs_decl_tipus($$, $1);}
  |  DECL_RECORD    {rs_decl_tipus($$, $1);}
  |  DECL_ARRAY     {rs_decl_tipus($$, $1);}
  ;
DECL_SUBRANGO:
     pc_type identificador pc_is pc_new identificador pc_rango VALOR punto punto VALOR p_coma   {rs_decl_subrango($$, $2, $5, $7, $10);}
  ;
DECL_RECORD:
     pc_type identificador pc_is pc_record campS pc_end pc_record p_coma {rs_decl_record($$, $2, $5);}
  ;
campS:
     campS camp  {rs_decl_camps($$, $1, $2);}
  |  camp         {rs_decl_camps($$, $1);}
  ;
camp:
     identificador dos_puntos identificador p_coma     {rs_decl_camp($$, $1, $3);}
  ;
DECL_ARRAY:
     pc_type identificador pc_is pc_array a_par LIND c_par pc_of identificador p_coma   {rs_decl_array($$, $2, $6, $9);}
  ;
LIND:
     LIND coma identificador  {rs_decl_lind($$, $1, $3);}
  |  identificador            {rs_decl_lind($$, $1);}
  ;
VALOR:
     LIT	       {rs_valor($$, $1);}
  |  menos LIT 	       {rs_valor_n($$, $2);}
  |  identificador     {rs_valor($$, $1);}
  |  menos identificador {rs_valor_n($$, $2);}
  ;
DECL_CONST:
     L_ID dos_puntos pc_constante identificador asig VALOR p_coma  {rs_decl_const($$, $1, $4, $6);}
  ;
DECL_VAR:
     L_ID dos_puntos identificador p_coma {rs_decl_var($$, $1, $3);}
  ;
L_ID: 
     L_ID coma identificador   {rs_l_id($$, $1, $3);}
  |  identificador	       {rs_l_id($$, $1);}
  ;
LSENT:
     LSENT SENT		       {rs_lsents($$, $1, $2);}
  |  			       {rs_lsents($$);}
  ;
SENT:
     ASIGN		       	{rs_sent($$, $1);}
  |  BUCLE 		       	{rs_sent($$, $1);}
  |  IF 		       	{rs_sent($$, $1);}
  |  LLAMADA  		       	{rs_sent($$, $1);}
  ;
BUCLE:
     pc_while E pc_loop  LSENT pc_end pc_loop p_coma  {rs_bucle($$, $2, $4);}
  ;
IF:
     pc_if E pc_then LSENT SINO pc_end pc_if p_coma   {rs_if($$, $2, $4, $5);}
  ;
SINO:
     pc_else LSENT              	{rs_sino($$, $2);}
  |  					{rs_sino($$);}
  ;
E:
     pc_not E           	{rs_not($$,$2);}
  |  menos E %prec menysunit    {rs_neg($$,$2);}
  |  E pc_and E		       	{rs_and($$,$1,$3);}
  |  E pc_or E			{rs_or($$,$1,$3);}
  |  E por E			{rs_mult($$,$1,$3);}
  |  E pc_mod E			{rs_mod($$,$1,$3);}
  |  E dividir E 		{rs_divisio($$,$1,$3);}
  |  E mas E 			{rs_suma($$,$1,$3);}
  |  E menos E 			{rs_resta($$,$1,$3);}
  |  a_par E c_par		{rs_par($$,$2);}
  |  E oprel E          	{rs_relac($$,$1,$2,$3);}
  |  LIT			{rs_elit($$,$1);}
  |  R				{rs_ref($$,$1);}
  ;
LLAMADA:
     R p_coma			{rs_llamada($$, $1);}
  ;
ASIGN:
     R asig E p_coma		{rs_asig($$,$1,$3);}
  ;
R:
     identificador QS		{rs_r($$,$1,$2);}
  ;
QS:
     QS Q			{rs_qs($$,$1,$2);}
  |  				{rs_qs($$);}
  ;
Q: 
     punto identificador	{rs_q($$,$2);}
  |  a_par LE c_par		{rs_q($$,$2);}
  ;
LE:
     LE coma E			{rs_le($$, $1, $3);}
  |  E				{rs_le($$, $1);}
  ;
LIT:
     lit_car			{rs_lit($$,$1);}
  |  lit_ent			{rs_lit($$,$1);}
  |  lit_str			{rs_lit($$,$1);}
;
%%
package a_sintactic is
  procedure yyparse;
end a_sintactic;
with a_lexic, psada_dfa, psada_io, psada_shift_reduce, psada_goto, psada_Tokens, text_io, semantic.c_arbre;
use a_lexic, psada_dfa, psada_io, psada_shift_reduce, psada_goto, psada_Tokens, text_io, semantic.c_arbre;
package body a_sintactic is
  procedure YYError(S: in string) is
  begin
    Put_Line(S&" a prop de linia: "& Yy_Line_Number'Img);
  end YYError;
##
end a_sintactic;
