with decls.d_tree, decls.general_defs, decls.d_names_table;
     --semantic.c_tipus, semantic.g_codi_int, decls.d_descripcio;
use decls.d_tree, decls.general_defs, decls.d_names_table;
     --semantic.c_tipus, semantic.g_codi_int, decls.d_descripcio;

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

   procedure sr_decls (p: out pnode; decls: in pnode; decl: in pnode);
   procedure sr_decls (p: out pnode);

   procedure sr_typevar_decl (p: out pnode; decl: in pnode);
   procedure sr_type_decl    (p: out pnode; decl: in pnode);
   procedure sr_func_decl    (p: out pnode; decl: in pnode);
   procedure sr_eq_decl      (p: out pnode; decl: in pnode);

   procedure sr_typevar (p: out pnode; lid: in pnode);

   procedure sr_lid (p: out pnode; lid: in pnode; id: in pnode);
   procedure sr_lid (p: out pnode; id: in pnode);

   procedure sr_type (p: out pnode; id: in pnode; alts: in pnode);

   procedure sr_alts (p: out pnode; fcall: in pnode);
   procedure sr_alts (p: out pnode; alts: in pnode; fcall: in pnode);

   procedure sr_fcall(p: out pnode; id: in pnode; params: in pnode);

   procedure sr_params (p: out pnode; el: in pnode);
   procedure sr_params (p: out pnode);

   procedure sr_el (p: out pnode; e: in pnode);
   procedure sr_el (p: out pnode; el: in pnode; e: in pnode);

   procedure sr_func (p: out pnode; id: in pnode;
                      in_type: in pnode; out_type: in pnode);

   procedure sr_fparam (p: out pnode; param_list: in pnode);
   procedure sr_fparam (p: out pnode);

   procedure sr_param_list (p: out pnode; fp: in pnode);
   procedure sr_param_list (p: out pnode; param_list: in pnode; fp: in pnode);

   procedure sr_fp (p: out pnode; fcall: in pnode);
   procedure sr_fp (p: out pnode; fcall_in: in pnode; fcall_out: in pnode);

   procedure sr_equation (p: out pnode; id: in pnode; pattern: in pnode;
                          e: in pnode);

   procedure sr_pattern (p: out pnode; lmodels: in pnode);
   procedure sr_pattern (p: out pnode);

   procedure sr_lmodels (p: out pnode; lmodels: in pnode; model: in pnode);
   procedure sr_lmodels (p: out pnode; model: in pnode);

   procedure sr_model (p: out pnode; e: in pnode);
   procedure sr_model (p: out pnode; model: in pnode; e: in pnode);

   procedure sr_e      (p: out pnode; e: in pnode);
   procedure sr_plus   (p: out pnode; e1: in pnode; e2: in pnode);
   procedure sr_sub    (p: out pnode; e1: in pnode; e2: in pnode);
   procedure sr_prod   (p: out pnode; e1: in pnode; e2: in pnode);
   procedure sr_div    (p: out pnode; e1: in pnode; e2: in pnode);
   procedure sr_mod    (p: out pnode; e1: in pnode; e2: in pnode);
   procedure sr_and    (p: out pnode; e1: in pnode; e2: in pnode);
   procedure sr_or     (p: out pnode; e1: in pnode; e2: in pnode);
   procedure sr_relop  (p: out pnode; sign: in pnode; e1: in pnode; e2: in pnode);
   procedure sr_not    (p: out pnode; e: in pnode);
   procedure sr_usub   (p: out pnode; e: in pnode);
   procedure sr_econd  (p: out pnode; cond: in pnode);
   procedure sr_elist  (p: out pnode; list: in pnode);
   procedure sr_etuple (p: out pnode; tuple: in pnode);
   procedure sr_elit   (p: out pnode; lit: in pnode);
   procedure sr_efcall (p: out pnode; fcall: in pnode);

   procedure sr_cond (p: out pnode; e: in pnode; els: in pnode);

   procedure sr_else (p: out pnode; e: in pnode);
   procedure sr_else (p: out pnode; e1: in pnode; e2: in pnode);

   procedure sr_tuple (p: out pnode; list: in pnode);

   procedure sr_list_e (p: out pnode; list: in pnode);

   procedure sr_list (p: out pnode; list: in pnode; e: in pnode);
   procedure sr_list (p: out pnode; e: in pnode);

   procedure sr_lit (p: out pnode; lit: in pnode);

end semantic.c_tree;
