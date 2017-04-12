with Ada.Text_IO;
package body semantic.c_tree is


   procedure lr_atom(p: out pnode; pos: in position) is
   begin
      p := new node(nd_default);
      p.pos := pos;
   end lr_atom;

   procedure lr_ident(p: out pnode; pos: in position; s: in string) is
      id: name_id;
   begin
      p := new node(nd_ident);
      put(nt, s, id);
      p.identifier_id := id;
      p.pos := pos;
   end lr_ident;

   procedure lr_ge(p: out pnode; pos: in position) is
   begin
      p := new node(nd_oprel);
      p.pos := pos;
      p.op_type := ge;
   end lr_ge;

   procedure lr_le(p: out pnode; pos: in position) is
   begin
      p := new node(nd_oprel);
      p.pos := pos;
      p.op_type := le;
   end lr_le;

   procedure lr_lt(p: out pnode; pos: in position) is
   begin
      p := new node(nd_oprel);
      p.pos := pos;
      p.op_type := lt;
   end lr_lt;

   procedure lr_gt(p: out pnode; pos: in position) is
   begin
      p := new node(nd_oprel);
      p.pos := pos;
      p.op_type := gt;
   end lr_gt;

   procedure lr_eq(p: out pnode; pos: in position) is
   begin
      p := new node(nd_oprel);
      p.pos := pos;
      p.op_type := eq;
   end lr_eq;

   procedure lr_ne(p: out pnode; pos: in position) is
   begin
      p := new node(nd_oprel);
      p.pos := pos;
      p.op_type := ne;
   end lr_ne;

   procedure lr_lit_int(p: out pnode; pos: in position; s: in string) is
   begin
      p := new node(nd_literal);
      p.val := value'Value(s);
      p.sbt := sbt_int;
      p.pos := pos;
   end lr_lit_int;

   procedure lr_lit_chr(p: out pnode; pos: in position; s: in string) is
      c: character;
      i: integer;
   begin
      p := new node(nd_literal);
      c := s(s'First+1);
      i := Character'Pos(c);
      p.val := value'Val(i);
      p.sbt := sbt_chr;
      p.pos := pos;
   end lr_lit_chr;

   procedure lr_lit_str(p: out pnode; pos: in position; s: in string) is
      ids: str_id;
   begin
      p := new node(nd_literal);
      put(nt, s, ids);
      p.val := value'Val(ids);
      p.sbt := sbt_null;
      p.pos := pos;
   end lr_lit_str;



   -- Semantic routines
   procedure sr_s (prog: in pnode) is
   begin
      root := prog;
   end sr_s;

   procedure sr_prog  (p: out pnode; decls: in pnode; e: in pnode) is
   begin
      p := new node(nd_root);
      p.defs := decls;
      p.data := e;
   end sr_prog;

   procedure sr_decls (p: out pnode; decls: in pnode; decl: in pnode) is
   begin
      p := new node(nd_decls);
      p.decls := decls;
      p.decl  := decl;
   end sr_decls;

   procedure sr_decls (p: out pnode) is
   begin
      p := null;
   end sr_decls;

   procedure sr_typevar_decl (p: out pnode; decl: in pnode) is
   begin
      p := new node(nd_typevar_decl);
      p.typevar_decl := decl;
   end sr_typevar_decl;

   procedure sr_type_decl    (p: out pnode; decl: in pnode) is
   begin
      p := new node(nd_type_decl);
      p.type_decl := decl;
   end sr_type_decl;

   procedure sr_func_decl    (p: out pnode; decl: in pnode) is
   begin
      p := new node(nd_func_decl);
      p.func_decl := decl;
   end sr_func_decl;

   procedure sr_eq_decl      (p: out pnode; decl: in pnode) is
   begin
      p := new node(nd_eq_decl);
      p.eq_decl := decl;
   end sr_eq_decl;

   procedure sr_typevar (p: out pnode; lid: in pnode) is
   begin
      p := new node(nd_typevar);
      p.typevar_lid := lid;
   end sr_typevar;

   procedure sr_lid (p: out pnode; lid: in pnode; id: in pnode) is
   begin
      p := new node(nd_lid);
      lid.lid_lid := lid;
      lid.lid_id  := id;
   end sr_lid;

   procedure sr_lid (p: out pnode; id: in pnode) is
   begin
      p := new node(nd_lid);
      p.lid_lid := null;
      p.lid_id  := id;
   end sr_lid;

   procedure sr_type (p: out pnode; id: in pnode; alts: in pnode) is
   begin
      p := new node(nd_type);
      p.type_id   := id;
      p.type_alts := alts;
   end sr_type;

   procedure sr_alts (p: out pnode; fcall: in pnode) is
   begin
      p := new node(nd_alts);
      p.alts_alts  := null;
      p.alts_fcall := fcall;
   end sr_alts;

   procedure sr_alts (p: out pnode; alts: in pnode; fcall: in pnode) is
   begin
      p := new node(nd_alts);
      p.alts_alts  := alts;
      p.alts_fcall := fcall;
   end sr_alts;

   procedure sr_fcall(p: out pnode; id: in pnode; params: in pnode) is
   begin
      p := new node(nd_fcall);
      p.fcall_id     := id;
      p.fcall_params := params;
   end sr_fcall;

   procedure sr_params (p: out pnode; el: in pnode) is
   begin
      p := new node(nd_params);
      p.params_el := el;
   end sr_params;

   procedure sr_params (p: out pnode) is
   begin
      p := null;
   end sr_params;

   procedure sr_el (p: out pnode; e: in pnode) is
   begin
      p := new node(nd_el);
      p.el_el := null;
      p.el_e  := e;
   end sr_el;

   procedure sr_el (p: out pnode; el: in pnode; e: in pnode) is
   begin
      p := new node(nd_el);
      p.el_el := el;
      p.el_e  := e;
   end sr_el;

   procedure sr_func (p: out pnode; id: in pnode;
                      in_type: in pnode; out_type: in pnode) is
   begin
      p := new node(nd_func);
      p.func_id  := id;
      p.func_in  := in_type;
      p.func_out := out_type;
   end sr_func;

   procedure sr_fparam (p: out pnode; param_list: in pnode) is
   begin
      p := new node(nd_fparam);
      p.fparam_param := param_list;
   end sr_fparam;

   procedure sr_fparam (p: out pnode) is
   begin
      p := null;
   end sr_fparam;

   procedure sr_param_list (p: out pnode; fp: in pnode) is
   begin
      p := new node(nd_param_list);
      p.pl_param_list := null;
      p.pl_fp := fp;
   end sr_param_list;

   procedure sr_param_list (p: out pnode; param_list: in pnode; fp: in pnode) is
   begin
      p := new node(nd_param_list);
      p.pl_param_list := param_list;
      p.pl_fp := fp;
   end sr_param_list;

   procedure sr_fp (p: out pnode; fcall: in pnode) is
   begin
      p := new node(nd_fp);
      p.fp_fcall     := fcall;
      p.fp_fcall_in  := null;
      p.fp_fcall_out := null;
   end sr_fp;

   procedure sr_fp (p: out pnode; fcall_in: in pnode; fcall_out: in pnode) is
   begin
      p := new node(nd_fp);
      p.fp_fcall     := null;
      p.fp_fcall_in  := fcall_in;
      p.fp_fcall_out := fcall_out;
   end sr_fp;

   procedure sr_equation (p: out pnode; id: in pnode; pattern: in pnode;
                          e: in pnode) is
   begin
      p := new node(nd_equation);
      p.eq_id      := id;
      p.eq_pattern := pattern;
      p.eq_e       := e;
   end sr_equation;

   procedure sr_pattern (p: out pnode; lmodels: in pnode) is
   begin
      p := new node(nd_pattern);
      p.pat_lmodels := lmodels;
   end sr_pattern;

   procedure sr_pattern (p: out pnode) is
   begin
      p := null;
   end sr_pattern;

   procedure sr_lmodels (p: out pnode; lmodels: in pnode; model: in pnode) is
   begin
      p := new node(nd_lmodels);
      p.lmodels_lmodels := lmodels;
      p.lmodels_model   := model;
   end sr_lmodels;

   procedure sr_lmodels (p: out pnode; model: in pnode) is
   begin
      p := new node(nd_lmodels);
      p.lmodels_lmodels := null;
      p.lmodels_model   := model;
   end sr_lmodels;

   procedure sr_model (p: out pnode; e: in pnode) is
   begin
      p := new node(nd_model);
      p.model_e     := e;
      p.model_model := null;
   end sr_model;

   procedure sr_model (p: out pnode; model: in pnode; e: in pnode) is
   begin
      p := new node(nd_model);
      p.model_e     := e;
      p.model_model := model;
   end sr_model;

   procedure sr_e      (p: out pnode; e: in pnode) is
   begin
      p := e;
   end sr_e;

   procedure sr_plus   (p: out pnode; e1: in pnode; e2: in pnode) is
   begin
      p := new node(nd_plus);
      p.plus_e1 := e1;
      p.plus_e2 := e2;
   end sr_plus;

   procedure sr_sub    (p: out pnode; e1: in pnode; e2: in pnode) is
   begin
      p := new node(nd_sub);
      p.sub_e1 := e1;
      p.sub_e2 := e2;
   end sr_sub;

   procedure sr_prod   (p: out pnode; e1: in pnode; e2: in pnode) is
   begin
      p := new node(nd_prod);
      p.prod_e1 := e1;
      p.prod_e2 := e2;
   end sr_prod;

   procedure sr_div    (p: out pnode; e1: in pnode; e2: in pnode) is
   begin
      p := new node(nd_div);
      p.div_e1 := e1;
      p.div_e2 := e2;
   end sr_div;

   procedure sr_mod    (p: out pnode; e1: in pnode; e2: in pnode) is
   begin
      p := new node(nd_mod);
      p.mod_e1 := e1;
      p.mod_e2 := e2;
   end sr_mod;

   procedure sr_and    (p: out pnode; e1: in pnode; e2: in pnode) is
   begin
      p := new node(nd_and);
      p.and_e1 := e1;
      p.and_e2 := e2;
   end sr_and;

   procedure sr_or     (p: out pnode; e1: in pnode; e2: in pnode) is
   begin
      p := new node(nd_or);
      p.or_e1 := e1;
      p.or_e2 := e2;
   end sr_or;

   procedure sr_relop  (p: out pnode; sign: in pnode; e1: in pnode; e2: in pnode) is
   begin
      p := new node(nd_relop);
      p.relop_e1 := e1;
      p.relop_e2 := e2;
      p.relop := sign;
   end sr_relop;

   procedure sr_not    (p: out pnode; e: in pnode) is
   begin
      p := new node(nd_not);
      p.not_e := e;
   end sr_not;

   procedure sr_usub   (p: out pnode; e: in pnode) is
   begin
      p := new node(nd_usub);
      p.usub_e := e;
   end sr_usub;

   procedure sr_econd  (p: out pnode; cond: in pnode) is
   begin
      p := new node(nd_econd);
      p.econd := cond;
   end sr_econd;

   procedure sr_elist  (p: out pnode; list: in pnode) is
   begin
      p := new node(nd_elist);
      p.elist_list := list;
   end sr_elist;

   procedure sr_etuple (p: out pnode; tuple: in pnode) is
   begin
      p := new node(nd_etuple);
      p.etuple := tuple;
   end sr_etuple;

   procedure sr_elit   (p: out pnode; lit: in pnode) is
   begin
      p := new node(nd_elit);
      p.elit := lit;
   end sr_elit;

   procedure sr_efcall (p: out pnode; fcall: in pnode) is
   begin
      p := new node(nd_efcall);
      p.efcall := fcall;
   end sr_efcall;

   procedure sr_cond (p: out pnode; e: in pnode; els: in pnode) is
   begin
      p := new node(nd_cond);
      p.cond_e   := e;
      p.cond_els := els;
   end sr_cond;

   procedure sr_else (p: out pnode; e: in pnode) is
   begin
      p := new node(nd_else);
      p.else_e  := e;
      p.else_e1 := null;
      p.else_e2 := null;
   end sr_else;

   procedure sr_else (p: out pnode; e1: in pnode; e2: in pnode) is
   begin
      p := new node(nd_else);
      p.else_e  := null;
      p.else_e1 := e1;
      p.else_e2 := e2;
   end sr_else;

   procedure sr_tuple (p: out pnode; list: in pnode) is
   begin
      p := new node(nd_tuple);
      p.tuple_list := list;
   end sr_tuple;

   procedure sr_list_e (p: out pnode; list: in pnode) is
   begin
      p := new node(nd_list_e);
      p.list_e := list;
   end sr_list_e;

   procedure sr_list (p: out pnode; list: in pnode; e: in pnode) is
   begin
      p := new node(nd_list);
      p.list_list := list;
      p.list_e := e;
   end sr_list;

   procedure sr_list (p: out pnode; e: in pnode) is
   begin
      p := new node(nd_list);
      p.list_list := null;
      p.list_e := e;
   end sr_list;

   procedure sr_lit (p: out pnode; lit: in pnode) is
   begin
      p := new node(nd_lit);
      p.lit_lit := lit;
      p.pos     := lit.pos;
   end sr_lit;

end semantic.c_tree;
