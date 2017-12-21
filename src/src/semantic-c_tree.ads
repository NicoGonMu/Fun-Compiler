with decls.d_tree, decls.general_defs, decls.d_names_table, semantic.messages,
     decls.d_pm_tree;
     --semantic.g_codi_int;
use decls.d_tree, decls.general_defs, decls.d_names_table, semantic.messages,
     decls.d_pm_tree;
     --semantic.g_codi_int;

package semantic.c_tree is

   -- Lexical routines
   procedure lr_atom	(p: out pnode; pos: in position);
   procedure lr_gt	(p: out pnode; pos: in position);
   procedure lr_ge	(p: out pnode; pos: in position);
   procedure lr_lt	(p: out pnode; pos: in position);
   procedure lr_le	(p: out pnode; pos: in position);
   procedure lr_ne	(p: out pnode; pos: in position);
   procedure lr_eq	(p: out pnode; pos: in position);
   procedure lr_lit_int	(p: out pnode; pos: in position; s: in string);
   procedure lr_lit_chr	(p: out pnode; pos: in position; s: in string);
   procedure lr_ident	(p: out pnode; pos: in position; s: in string);
   procedure lr_lit_str	(p: out pnode; pos: in position; s: in string);


   -- Semantic routines
   procedure sr_s  (prog: in pnode);

   procedure sr_prog  (p: out pnode; decls: in pnode; e: in pnode);

   procedure sr_decls (p: out pnode; decl: in pnode; decls: in pnode);
   procedure sr_decls (p: out pnode);

   procedure sr_typevar_decl (p: out pnode; decl: in pnode);
   procedure sr_type_decl    (p: out pnode; decl: in pnode);
   procedure sr_data_decl    (p: out pnode; decl: in pnode);
   procedure sr_func_decl    (p: out pnode; decl: in pnode);
   procedure sr_eq_decl      (p: out pnode; decl: in pnode);

   procedure sr_typevar (p: out pnode; lid: in pnode);

   procedure sr_data (p: out pnode; id: in pnode; params: in pnode; alts: in pnode);

   procedure sr_typedef (p: out pnode; desc: in pnode);
   procedure sr_typedef (p: out pnode);

   procedure sr_desc (p: out pnode; desc_out: in pnode);
   procedure sr_desc (p: out pnode; desc_in: in pnode; desc_out: in pnode);

   procedure sr_lid (p: out pnode; lid: in pnode; id: in pnode);
   procedure sr_lid (p: out pnode; id: in pnode);

   procedure sr_type (p: out pnode; id: in pnode; params: in pnode; alts: in pnode);

   procedure sr_alts (p: out pnode; fcall: in pnode);
   procedure sr_alts (p: out pnode; alts: in pnode; fcall: in pnode);

   procedure sr_fcall(p: out pnode; id: in pnode; params: in pnode);

   procedure sr_params (p: out pnode; el: in pnode);
   procedure sr_params (p: out pnode);

   procedure sr_el (p: out pnode; e: in pnode);
   procedure sr_el (p: out pnode; el: in pnode; e: in pnode);

   procedure sr_func (p: out pnode; id: in pnode; desc: in pnode);

   procedure sr_tuple_type(p: out pnode; tuple_type: in pnode; c_tuple_type: in pnode);
   procedure sr_tuple_type(p: out pnode; c_tuple_type: in pnode);

   procedure sr_c_tuple_type(p: out pnode; ctt_in: in pnode; ctt_out: in pnode);
   procedure sr_c_tuple_type(p: out pnode; fcall: in pnode);

   procedure sr_equation (p: out pnode; id: in pnode; pattern: in pnode;
                          e: in pnode);

   procedure sr_pattern (p: out pnode; lmodels: in pnode);
   procedure sr_pattern (p: out pnode);

   procedure sr_lmodels (p: out pnode; lmodels: in pnode; e: in pnode);
   procedure sr_lmodels (p: out pnode; e: in pnode);

   procedure sr_e      (p: out pnode; e: in pnode);
   procedure sr_plus   (p: out pnode; e1: in pnode; e2: in pnode);
   procedure sr_sub    (p: out pnode; e1: in pnode; e2: in pnode);
   procedure sr_prod   (p: out pnode; e1: in pnode; e2: in pnode);
   procedure sr_div    (p: out pnode; e1: in pnode; e2: in pnode);
   procedure sr_mod    (p: out pnode; e1: in pnode; e2: in pnode);
   procedure sr_and    (p: out pnode; e1: in pnode; e2: in pnode);
   procedure sr_or     (p: out pnode; e1: in pnode; e2: in pnode);
   procedure sr_relop  (p: out pnode; e1: in pnode; sign: in pnode; e2: in pnode);
   procedure sr_econc  (p: out pnode; e1: in pnode; e2: in pnode);
   procedure sr_not    (p: out pnode; e: in pnode);
   procedure sr_usub   (p: out pnode; e: in pnode);
   procedure sr_econd  (p: out pnode; cond: in pnode);
   procedure sr_elist  (p: out pnode; list: in pnode);
   procedure sr_etuple (p: out pnode; tuple: in pnode);
   procedure sr_elit   (p: out pnode; lit: in pnode);
   procedure sr_efcall (p: out pnode; fcall: in pnode);

   procedure sr_cond (p: out pnode; cond: in pnode; e: in pnode; els: in pnode);

   procedure sr_tuple (p: out pnode; list: in pnode);

   procedure sr_list_e (p: out pnode; list: in pnode);

   procedure sr_list (p: out pnode; list: in pnode; e: in pnode);
   procedure sr_list (p: out pnode; e: in pnode);

   procedure sr_lit (p: out pnode; lit: in pnode);

end semantic.c_tree;
