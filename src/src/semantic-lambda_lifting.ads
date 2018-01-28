with decls.d_description, decls.d_lc_tree, semantic.messages, decls.d_fv_set, Ada.Text_IO;
use decls.d_description, decls.d_lc_tree, semantic.messages, decls.d_fv_set, Ada.Text_IO;

package semantic.lambda_lifting is

   procedure lambda_lift(fname: in string);

   --Alpha counter for lift(x.E) = alpha {FV} x
   --Must be initiatet with the number of built-in operations
   --(+, -, *, /, mod, and, or, not, eq, ne, gt, ge, lt, le)
   alpha: Natural := 14;

   -- Text file
   tf: File_Type;


end semantic.lambda_lifting;
