with lexical_a, syntactic_a, fun_dfa, fun_io, fun_tokens,
    Ada.Text_io, Ada.Command_Line, semantic, semantic.type_checking,
    semantic.c_lc_tree, semantic.lambda_lifting; --decls, decls.d_c3a, semantic.g_codi_ass;
use lexical_a, syntactic_a, fun_dfa, fun_io, fun_tokens,
    Ada.Text_io, Ada.Command_Line, semantic, semantic.type_checking,
    semantic.c_lc_tree, semantic.lambda_lifting; --decls, decls.d_c3a, semantic.g_codi_ass;

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
   if not error then
      generate_lc_tree(Argument(1));
   end if;
   if not error then
      lambda_lift;
   end if;
   -- if not error then
   --   FPM(Argument(1));
   --end if;
   -- if not error then
   --   generacio_codi_ass(Argument(1));
   --end if;
   --m_finalitzat(error);
   Put_Line("Successfully compiled");
exception
      when Syntax_error => null;
end Fun;
