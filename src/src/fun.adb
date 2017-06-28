with lexical_a, syntactic_a, fun_dfa, fun_io, fun_tokens,
    Ada.Text_io, Ada.Command_Line, semantic, semantic.type_checking;
    --decls, decls.d_c3a, decls.d_tnoms, decls.d_tsimbols
     --semantic.c_arbre, semantic.g_codi_int,
     --semantic.g_codi_ass, semantic.missatges;
use lexical_a, syntactic_a, fun_dfa, fun_io, fun_tokens,
    Ada.Text_io, Ada.Command_Line, semantic, semantic.type_checking;
--    decls, decls.d_c3a, decls.d_tnoms, decls.d_tsimbols;
--    semantic.c_arbre, semantic.g_codi_int,
--    semantic.g_codi_ass, semantic.missatges;

procedure Fun is
   error: boolean renames semantic.error;
begin
   Put_Line("Compilation started...");
   open(Argument(1)&".fn");
   prepare(Argument(1));
   yyparse;
   close;
   if not error then
      type_check;
   end if;
   --if not error then
   --   generacio_codi_int(Argument(1));
   --end if;
   -- if not error then
   --   generacio_codi_ass(Argument(1));
   --end if;
   --m_finalitzat(error);
   Put_Line("Successfully compiled");
exception
      when Syntax_error => null;
end Fun;
