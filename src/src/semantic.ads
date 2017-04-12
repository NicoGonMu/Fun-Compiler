with decls.d_names_table, decls.d_symbol_table, decls.general_defs, decls.d_tree,
     decls.alternatives;
     --decls.d_c3a, decls.d_pila_proc;
use decls.d_names_table, decls.d_symbol_table, decls.general_defs, decls.d_tree,
    decls.alternatives;
     --decls.d_c3a, decls.d_pila_proc;
package semantic is

   nt: names_table;
   st: symbol_table;

   fn: func_id;
--   ne: num_etiq;

   root: pnode;

--   prof: profunditat;
--   pproc: pila_proc;

   --   tp: taula_procediments;
   altst: alternatives;

   error: boolean;

   procedure prepare(nom: in String);
--   procedure conclou_analisi;
--   function imatge(int: in String) return String;



end semantic;
