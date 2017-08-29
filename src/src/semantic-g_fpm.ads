with Text_IO, decls.d_c3a, decls.general_defs;
use Text_IO, decls.d_c3a, decls.general_defs;

package semantic.g_FPM is

      procedure generate_FPM;

private

   use gci_file;

   sf: gci_file.File_Type;
   tf: Text_io.File_Type;


end semantic.g_FPM;
