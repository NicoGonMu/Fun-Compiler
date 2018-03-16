with Text_IO, decls.general_defs, decls.d_tree, decls.d_fpm, semantic.messages, decls.d_stack;
use Text_IO, decls.general_defs, decls.d_tree, decls.d_fpm, semantic.messages;

package semantic.g_FPM is

   procedure generate_FPM(name: in String);

private

   lt: label_table(0..-1);  -- Label table
   k: Natural := 0;         -- Label counter
   cl: Natural := 1;        -- Case Label counter

   package node_stack is new decls.d_stack(lc_pnode); -- Node stack for IF translation
   package lab_stack is new decls.d_stack(Natural);   -- Natural stack for labels

   use gci_file;

   sf: Text_IO.File_Type;
   tf: gci_file.File_Type;

end semantic.g_FPM;
