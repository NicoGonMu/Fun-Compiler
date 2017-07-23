with decls.general_defs, decls.d_lc_tree, decls.d_pm_tree, decls.d_description;
use decls.general_defs, decls.d_lc_tree, decls.d_pm_tree, decls.d_description;

package semantic.c_lc_tree is
   procedure generate_lc_tree (fname: in string);

      --Array of function ids
   type function_list is array(func_id range 1..fn) of name_id;
   flist: function_list;


end semantic.c_lc_tree;