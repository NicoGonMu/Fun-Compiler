with decls.d_names_table, decls.d_symbol_table, decls.general_defs, decls.d_tree,
     decls.d_lc_tree, decls.d_fv_function_table, decls.d_fpm;
use decls.d_names_table, decls.d_symbol_table, decls.general_defs, decls.d_tree,
    decls.d_lc_tree, decls.d_fv_function_table, decls.d_fpm;
package semantic is

   nt: names_table;
   st: symbol_table;
   fvft: p_fv_function_table;

   --Number of functions
   fn: func_id;

   --Last identifier stored
   last_nid: name_id;

   --Syntactic tree
   root: pnode;

   --Lambda calculus tree
   lc_root: lc_pnode;

   --Lambda lift resulting tree
   lc_lift_root: lc_pnode;

   --Nam ids of default types
   list_nid: name_id;
   cons_nid: name_id;
   nil_nid:  name_id;
   int_nid:  name_id;
   bool_nid: name_id;
   char_nid: name_id;

   --Variable that will tell the assembly generation part how to print the result
   result_type: pnode;

   --Variable to main function indicate when an error occurred
   error: boolean;



   procedure prepare(fname: in String);
--   procedure conclou_analisi;
   function Trim(int: in String) return String;


end semantic;
