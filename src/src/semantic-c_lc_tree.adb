with Ada.Text_IO;
use Ada.Text_IO;
package body semantic.c_lc_tree is

   procedure lc_prog(p: in pnode; lc: out lc_pnode);
   procedure lc_defs(p: in pnode; lc: out lc_pnode);

   procedure lc_data_decl (p: in pnode; lc: out lc_pnode);
   procedure lc_alts      (p: in pnode; lc: out lc_pnode);
   procedure lc_alt       (p: in pnode; lc: out lc_pnode);

   procedure lc_eq_decl(p: in pnode; lc: out lc_pnode);

   procedure lc_data(p: in pnode; lc: out lc_pnode);



   procedure generate_lc_tree (fname: in string) is
   begin
      enterbloc(st);
      lc_prog(root, lc_root);
      exitbloc(st);
   end generate_lc_tree;

   -------------------------------------------------------------------

   procedure lc_prog(p: in pnode; lc: out lc_pnode) is
      data: pnode renames p.data;
      defs: pnode renames p.defs;
   begin
      lc := new lc_node(nd_apply);
      lc.appl_func := new lc_node(nd_lambda);
      lc.appl_func.lambda_id := new lc_node(nd_const);
      lc.appl_func.lambda_id.cons_id := c_Y;
      lc.appl_func.lambda_decl := new lc_node(nd_lambda);
      lc.appl_func.lambda_decl.lambda_id := new lc_node(nd_const);
      lc.appl_func.lambda_decl.lambda_id.cons_id := c_T;
      lc.appl_func.lambda_decl.lambda_decl =

      lc_defs(defs, lc.appl_func.lambda_decl.lambda_decl);
      Put_Line("Defs converted to lambda calculus");
      lc_data(data, lc.appl_arg);
   end lc_prog;

   procedure lc_defs(p: in pnode; lc: out lc_pnode) is
      decls: pnode renames p.decls;
      decl:  pnode renames p.decl;
   begin
      case decl.nt is
         when nd_type_decl => null; --tc_type_decl(decl.type_decl);     --TODO ?
         when nd_data_decl => lc_data_decl(decl.data_decl, lc);
         when nd_func_decl => null; --lc_func_decl(decl.func_decl, lc); --TODO ?
         when nd_eq_decl => lc_eq_decl(decl.eq_decl, lc);
         when others => null;
      end case;

      lc := lc.lambda_decl;

      if decls /= null then
         lc_defs(decls, lc);
      end if;

   end lc_defs;

   procedure lc_data_decl(p: in pnode; lc: out lc_pnode) is
      id:     pnode renames p.data_id;
      params: pnode renames p.data_params;
      alts:   pnode renames p.data_alts;
   begin
      alt_id := 0;

      --New node TUPLE-n
      lc := new lc_node(nd_apply);
      lc.appl_func := new lc_node(nd_const);
      lc.appl_func.cons_id := c_tuple;

      lc_alts(alts, lc.appl_arg);

      --Set TUPLE-n size
      lc.appl_func.cons_val := alt_id;
   end lc_data_decl;


   procedure lc_alts(p: in pnode; lc: out lc_pnode) is
      fcall: pnode renames p.alts_fcall;
      alts:  pnode renames p.alts_alts;
      new_lc: lc_pnode;
   begin
      alt_id := alt_id + 1;

      new_lc := new lc_node(nd_apply);
      new_lc.appl_func := lc;
      lc_alt(fcall, new_lc.appl_arg);

      if alts /= null then
         lc_alts(alts, new_lc);
      end if;

      lc := new_lc;

   end lc_alts;

   procedure lc_alt(p: in pnode; lc: out lc_pnode) is
      params: pnode renames p.fcall_params;
      new_lc: lc_pnode;
      num_params: integer;
   begin
      --New node TUPLE-n
      lc := new lc_node(nd_apply);
      lc.appl_func := new lc_node(nd_const);
      lc.appl_func.cons_id := c_tuple;

      --First node: alternative id
      lc.appl_arg := new lc_node(nd_const);
      lc.appl_arg.cons_id := c_val;
      lc.appl_arg.cons_val := alt_id;

      --Params tree
      if params /= null then
         lc_params(params, new_lc, num_params);
      end if;

      --Set TUPLE-n size
      lc.appl_func.cons_val := num_params;

      if new_lc /= null then
         new_lc.appl_func := lc;
         lc := new_lc;
      end if;

   end lc_alt;


   procedure lc_eq_decl(p: in pnode; lc: out lc_pnode) is
   begin
      null;
   end lc_eq_decl;



   procedure lc_data(p: in pnode; lc: out lc_pnode) is
   begin
      null; --TODO
   end lc_data;

end semantic.c_lc_tree;
