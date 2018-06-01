with lexical_a, syntactic_a, fun_dfa, fun_io, fun_tokens,
    Ada.Text_io, Ada.Command_Line, semantic, semantic.type_checking,
    semantic.c_lc_tree, semantic.lambda_lifting, semantic.g_FPM, semantic.g_assembly;
use lexical_a, syntactic_a, fun_dfa, fun_io, fun_tokens,
    Ada.Text_io, Ada.Command_Line, semantic, semantic.type_checking,
    semantic.c_lc_tree, semantic.lambda_lifting, semantic.g_FPM, semantic.g_assembly;

procedure Fun is
   error: boolean renames semantic.error;
   verbosity: boolean;
begin
   Put_Line("Compilation started...");
   open(Argument(1)&".fn");
   prepare(Argument(1));
   yyparse;
   close;

   if Argument_Count = 2 and then Argument(2) = "-v" then
      verbosity := true;
   else
      verbosity := false;
   end if;

   type_check;
   if error then
      return;
   end if;
   Put_Line("Type checking passed.");

   generate_lc_tree(Argument(1), verbosity);
   if error then
      return;
   end if;
   Put_Line("Lambda tree generated.");

   lambda_lift(Argument(1), verbosity);
   if error then
      return;
   end if;
   Put_Line("Lamda-lift done.");

   generate_FPM(Argument(1), verbosity);
   if error then
      return;
   end if;
   Put_Line("FPM code generated.");

   if not error then
      generate_assembly(Argument(1));
   end if;
   Put_Line("Successfully compiled");
exception

   when Syntax_error => null;
end Fun;
