with Text_IO, decls.general_defs, decls.d_tree, decls.d_c3a;
use Text_IO, decls.general_defs, decls.d_tree, decls.d_c3a;

package semantic.g_FPM is

   procedure generate_FPM(name: in String);

private

   use gci_file;

   sf: Text_IO.File_Type;
   tf: gci_file.File_Type;

end semantic.g_FPM;
