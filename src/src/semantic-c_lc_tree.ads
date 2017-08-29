with decls.general_defs, decls.d_lc_tree, decls.d_pm_tree, decls.d_description,
     semantic.messages;
use decls.general_defs, decls.d_lc_tree, decls.d_pm_tree, decls.d_description,
    semantic.messages;

package semantic.c_lc_tree is
   procedure generate_lc_tree (fname: in string);

   --Array of function ids
   type function_list is array(func_id range 1..fn) of name_id;
   flist: function_list;

   definition_count: integer;


end semantic.c_lc_tree;
