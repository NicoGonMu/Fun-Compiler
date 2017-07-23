with Ada.Text_IO;
use Ada.Text_IO;
package body semantic.c_lc_tree is

   procedure lc_prog(p: in pnode; lc: out lc_pnode);
   procedure lc_defs(p: in pnode; lc: out lc_pnode);

   procedure lc_func_decl  (p: in pnode);

   procedure lc_data_decl  (p: in pnode; lc: out lc_pnode);
   procedure lc_alts       (p: in pnode; lc: out lc_pnode);
   procedure lc_alt        (p: in pnode; lc: out lc_pnode);
   procedure lc_alt_params (p: in pnode; lc: out lc_pnode; num_params: in out integer);

   procedure lc_eq_decl(p: in pnode; lc: out lc_pnode);

   procedure lc_data(p: in pnode; lc: out lc_pnode);


   function cons_pattern_tree(p: in pnode; i: in out Natural; eq: in Natural) return p_pm_node;



   procedure generate_lc_tree (fname: in string) is
   begin
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
      lc.appl_func.lambda_decl.lambda_decl := new lc_node(nd_lambda);

      lc_defs(defs, lc.appl_func.lambda_decl.lambda_decl);
      Put_Line("Defs converted to lambda calculus");
      lc_data(data, lc.appl_arg);
   end lc_prog;

   procedure lc_defs(p: in pnode; lc: out lc_pnode) is
      decls: pnode renames p.decls;
      decl:  pnode renames p.decl;
   begin
      case decl.nt is
         when nd_data_decl => lc_data_decl(decl.data_decl, lc); --TODO
         when nd_func_decl => lc_func_decl(decl.func_decl);
         when nd_eq_decl =>
            lc_eq_decl(decl.eq_decl, lc);
            lc := lc.lambda_decl;
         when others => null;
      end case;


      if decls /= null then
         lc_defs(decls, lc);
      end if;

   end lc_defs;

   procedure lc_func_decl  (p: in pnode) is
      d: description;
   begin
      --Register function in list
      d := cons(st, p.func_id.identifier_id);
      flist(d.fn_id) := p.func_id.identifier_id;
   end lc_func_decl;


   procedure lc_data_decl(p: in pnode; lc: out lc_pnode) is
      id:     pnode renames p.data_id;
      params: pnode renames p.data_params;
      alts:   pnode renames p.data_alts;
      d: description;
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
      num_params := 1;
      if params /= null then
         lc_alt_params(params, new_lc, num_params);
      end if;

      --Set TUPLE-n size
      lc.appl_func.cons_val := num_params;

      if new_lc /= null then
         new_lc.appl_func := lc;
         lc := new_lc;
      end if;

   end lc_alt;

   procedure lc_alt_params(p: in pnode; lc: out lc_pnode; num_params: in out integer) is
      el: pnode renames p.params_el;
   begin
      if el = null then return; end if; --No params must be constructed

      num_params := num_params + 1;


   end lc_alt_params;


   procedure lc_eq_decl(p: in pnode; lc: out lc_pnode) is
      patterns: pnode renames p.eq_pattern;
      index_count: Natural;
      d: description;
      pt, npt: p_pm_node;
   begin
      null;
      --TODO
      -- 1. Obtain function pm tree from description
      d := cons(st, p.eq_id.identifier_id);
      pt := d.fn_lc_tree;

      -- 2. Construct equation's pattern tree
      if patterns = null then
         --If no args, only 1 pattern
         npt := new pm_node(pm_leaf, 0, 0);
         npt.eq_number := d.fn_eq_count;
      else
         --For each E, create pm_node
         npt := cons_pattern_tree(patterns.params_el, index_count, d.fn_eq_count);
         while patterns /= null loop
            index_count := 0;

            index_count := index_count + 1;
            patterns := patterns.el_el;
         end loop;

         d := cons(st, p.eq);
         npt := new pm_node(pm_node, index_count, 0);
      end if;


      -- 3. Construct E lc tree

      -- 4. Merge pattern tree with function lc patern tree


   end lc_eq_decl;


   function cons_pattern_tree(p: in pnode; i: in out Natural; eq: in Natural) return p_pm_node is
      d: description;
      pt: pnode;
      ret: p_pm_node;
      derivations_count, position_count: integer;
      isFunctionOrConstructor: boolean;
   begin
      i := i + 1;

      if p.el_el /= null then
         pt := cons_pattern_tree(p.el_el, i, eq);
      end if;

      pt := getType(p.el_e, isFunctionOrConstructor);

      if (not isFunctionOrConstructor) then
         --If not function or constructor length = 1, else calculate
         position_count := 1;
         --If not function or constructor 1 pointer
         derivations_count := 1;
      else
         --Calculate position length
         --Calculate pts length

      end if;

      ret := new pm_node(pm_inner, position_count, derivations_count);

      --Fill positions


      --Fill pts (if p.el_el = null then pts = node leaf, else pts = pt)

      return ret;
   end cons_pattern_tree;


   procedure lc_data(p: in pnode; lc: out lc_pnode) is
   begin
      null; --TODO
   end lc_data;


















   -------------------AUXILIAR FUNCTIONS-------------------

   function getType(p: in pnode; functionOrConstructor: out boolean) return pnode is
      d: description;
      ret: pnode;
      tt, lastt, ctt: pnode;
      elem: pnode;
   begin
      functionOrConstructor := False;
      case p.nt is
         when nd_plus | nd_sub | nd_prod | nd_div | nd_mod | nd_usub =>
            ret := new node(nd_ident);
            ret.identifier_id := int_nid;
         when nd_oprel | nd_and | nd_or | nd_not =>
            ret := new node(nd_ident);
            ret.identifier_id := bool_nid;
         when nd_lit =>
            ret := new node(nd_ident);
            case p.lit_lit.sbt is
               when sbt_bool =>
                  ret.identifier_id := bool_nid;
               when sbt_int =>
                  ret.identifier_id := int_nid;
               when sbt_chr =>
                  ret.identifier_id := char_nid;
               when others => em_CompilerError(p.pos); raise tc_error;
            end case;
         when nd_elit =>
            return getType(p.elit);
         when nd_efcall =>
            d := cons(st, p.efcall.fcall_id.identifier_id);
            case d.dt is
               when null_d =>
                  -- Pattern matching new variable
                  ret := new node(nd_null);
               when vartype_d | var_d =>
                  -- No information necessary (will have to operate with T)
                  ret := new node(nd_typevar);
                  ret.typevar_lid := new node(nd_ident);
                  ret.typevar_lid.pos := p.pos;
                  if d.dt = var_d then
                     ret.typevar_lid.identifier_id := d.vtype;
                  else
                     ret.typevar_lid.identifier_id := p.efcall.fcall_id.identifier_id;
                  end if;

               when type_d =>
                  -- Return type information
                  ret := new node(nd_type);
                  ret.type_id := new node(nd_ident);
                  ret.type_id.pos := p.pos;
                  ret.type_id.identifier_id := d.type_id;
                  ret.type_decl := d.type_tree;
               when constructor_d =>
                  -- Return constructor information
                  ret := new node(nd_fcall);
                  ret.fcall_id := new node(nd_ident);
                  ret.fcall_id.pos := p.pos;
                  ret.fcall_id.identifier_id := d.cons_type;
                  ret.fcall_params := d.cons_tree;
                  functionOrConstructor := True;
               when func_d =>
                  ret := d.fn_type;
            end case;
         when nd_list =>
            ctt := p;
            lastt := new node(nd_tuple_type);
            ret := lastt;
            while (ctt /= null) loop
               tt := new node(nd_tuple_type);
               tt.tuple_type_ctt := new node(nd_c_tuple_type);
               elem := getType(ctt.list_e);
               tt.tuple_type_ctt.pos := elem.pos;
               if elem.nt = nd_ident then
                  tt.tuple_type_ctt.c_tuple_type_fcall := new node(nd_fcall);
                  tt.tuple_type_ctt.c_tuple_type_fcall.pos := elem.pos;
                  tt.tuple_type_ctt.c_tuple_type_fcall.fcall_id := elem;
               elsif elem.nt = nd_fcall then
                  tt.tuple_type_ctt.c_tuple_type_fcall := elem;
               elsif elem.nt = nd_typevar then
                  d := cons(st, ctt.list_e.efcall.fcall_id.identifier_id);
                  if d.dt = null_d then
                     em_undefinedName(p.pos); raise tc_error;
                  elsif d.dt = var_d then
                     tt.tuple_type_ctt.c_tuple_type_fcall := new node(nd_fcall);
                     tt.tuple_type_ctt.c_tuple_type_fcall.pos := elem.pos;
                     tt.tuple_type_ctt.c_tuple_type_fcall.fcall_id := new node(nd_ident);
                     tt.tuple_type_ctt.c_tuple_type_fcall.fcall_id.pos := elem.pos;
                     tt.tuple_type_ctt.c_tuple_type_fcall.fcall_id.identifier_id := d.vtype;
                  elsif d.dt = vartype_d then
                     em_vartypeNotExpected(p.pos); raise tc_error;
                  end if;
               elsif elem.nt = nd_null then
                  em_undefinedName(p.pos);
                  raise tc_error;
               else
                  em_CompilerError(p.pos);
                  raise tc_error;
               end if;

               --Save tt on ret
               tt.pos := elem.pos;
               lastt.tuple_type_tt := tt;
               lastt := tt;

               ctt := ctt.list_list;
            end loop;
            ret := ret.tuple_type_tt;

         when nd_elist =>
            ret := new node(nd_fcall);
            ret.fcall_id := new node(nd_ident);
            ret.fcall_id.pos := p.pos;
            ret.fcall_id.identifier_id := list_nid;
            ret.fcall_params := getType(p.list_e_list.list_e); --Obtain first element's type
         when nd_conc =>
            ret := new node(nd_fcall);
            ret.fcall_id := new node(nd_ident);
            ret.fcall_id.pos := p.pos;
            ret.fcall_id.identifier_id := list_nid;
            ret.fcall_params := getType(p.conc_e1);
            functionOrConstructor := True;
         when nd_tuple =>
            return getType(p.tuple_list);
         when others =>
            em_CompilerError(p.pos); raise tc_error;
      end case;

      ret.pos := p.pos;
      return ret;
   end getType;


end semantic.c_lc_tree;
