with decls.general_defs, decls.d_lc_tree, decls.d_pm_tree, decls.d_description,
     semantic.messages, Ada.Text_IO;
use decls.general_defs, decls.d_lc_tree, decls.d_pm_tree, decls.d_description,
    semantic.messages, Ada.Text_IO;

package semantic.c_lc_tree is
   procedure generate_lc_tree (fname: in string; verbosity: in boolean);

   --Array of function ids
   type function_list is array(func_id) of name_id;
   flist: function_list;

   definition_count: integer;

   -- When analyzing the body of an equation, we may need its equation number
   eqn: Natural;

   -- Text file
   tf: File_Type;

   --Alternative ID counter
   alt_id: Natural;

   --Variable to know the function being analyzed
   current_fn: func_id;


end semantic.c_lc_tree;
