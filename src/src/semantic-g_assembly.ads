with decls.d_fpm, decls.general_defs;
use decls.d_fpm, decls.general_defs;

with Text_IO;
use Text_IO;

package semantic.g_assembly is

   procedure generate_assembly(fname: in String);

   -- Label counter
   lc: Natural := 0;

private

   use gci_file;

   bf: gci_file.File_Type;
   sf: Text_io.File_Type;


end semantic.g_assembly;
