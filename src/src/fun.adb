with lexical_a, a_sintactic, psada_dfa, psada_io, psada_tokens,
    Ada.Text_io, Ada.Command_Line,
    decls, decls.d_c3a, decls.d_tnoms, decls.d_tsimbols,
     semantic, semantic.c_arbre, semantic.g_codi_int, semantic.c_tipus,
     semantic.g_codi_ass, semantic.missatges;
use lexical_a, a_sintactic, psada_dfa, psada_io, psada_tokens,
    Ada.Text_io, Ada.Command_Line,
    decls, decls.d_c3a, decls.d_tnoms, decls.d_tsimbols,
    semantic, semantic.c_arbre, semantic.g_codi_int, semantic.c_tipus,
    semantic.g_codi_ass, semantic.missatges;

procedure Fun is
   error: boolean renames semantic.error;
begin
   obre(Argument(1)&".psa");
   prepara_analisi(Argument(1));
   yyparse;
   tanca;
   --if not error then
   --   comprovacio_tipus;
   --end if;
   --if not error then
   --   generacio_codi_int(Argument(1));
   --end if;
   -- if not error then
   --   generacio_codi_ass(Argument(1));
   --end if;
   --m_finalitzat(error);

exception
      when Syntax_error => null;
end Fun;
