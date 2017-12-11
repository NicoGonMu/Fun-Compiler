with decls.general_defs, decls.d_lc_tree, decls.d_pm_tree, decls.d_description,
     semantic.messages;
use decls.general_defs, decls.d_lc_tree, decls.d_pm_tree, decls.d_description,
    semantic.messages;

package semantic.c_lc_tree is
   procedure generate_lc_tree (fname: in string);

   --Array of function ids
   type function_list is array(func_id) of name_id;
   flist: function_list;

   definition_count: integer;


   --Variable to know the function being analyzed
   current_fn: func_id;


end semantic.c_lc_tree;
