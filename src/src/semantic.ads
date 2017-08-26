with decls.d_names_table, decls.d_symbol_table, decls.general_defs, decls.d_tree,
     decls.d_lc_tree; --decls.d_c3a, decls.d_pila_proc;
use decls.d_names_table, decls.d_symbol_table, decls.general_defs, decls.d_tree,
    decls.d_lc_tree; --decls.d_c3a, decls.d_pila_proc;
package semantic is

   nt: names_table;
   st: symbol_table;

   fn: func_id;

   --Syntactic tree
   root: pnode;

   --Lambda calculus tree
   lc_root: lc_pnode;

   --Lambda calculus lifted tree
   lc_lift_root: lc_pnode;


   list_nid: name_id;
   cons_nid: name_id;
   nil_nid:  name_id;
   int_nid:  name_id;
   bool_nid: name_id;
   char_nid: name_id;

   alt_id: Natural;

   error: boolean;

   procedure prepare(fname: in String);
--   procedure conclou_analisi;
--   function imatge(int: in String) return String;


end semantic;
