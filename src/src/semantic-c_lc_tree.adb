with Ada.Text_IO;
use Ada.Text_IO;
package body semantic.c_lc_tree is

   procedure lc_prog(p: in pnode; lc: out lc_pnode);
   procedure lc_defs(p: in pnode; lc: out lc_pnode);

   procedure lc_func_decl  (p: in pnode);

   procedure lc_data_decl  (p: in pnode; lc: out lc_pnode);
   procedure lc_alts       (p: in pnode; lc: out lc_pnode);
   procedure lc_alt        (p: in pnode; lc: out lc_pnode);
   procedure lc_alt_params (p: in pnode; lc: in out lc_pnode; num_params: in out integer);

   procedure lc_eq_decl(p: in pnode);

   procedure lc_data(p: in pnode; lc: out lc_pnode);

   function e_to_lc_tree(p: in pnode) return lc_pnode;
   function fcall_to_lc_tree(p: in pnode) return lc_pnode;
   function list_to_lc_tree(p: in pnode; lc: in lc_pnode; i: out integer) return lc_pnode;

   function cons_pattern_tree(p: in pnode; i: in out Natural; pos: in pm_position; eq: in Natural)
                              return p_pm_node;
   function getType(p: in pnode; isConstructor: out boolean) return pnode;
   procedure merge_pattern_trees(base: in out p_pm_node; new_tree: in p_pm_node);

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
      --TODO add functions
      Put_Line("Defs converted to lambda calculus");
      lc_data(data, lc.appl_arg);
   end lc_prog;

   procedure lc_defs(p: in pnode; lc: out lc_pnode) is
      decls: pnode renames p.decls;
      decl:  pnode renames p.decl;
   begin
      case decl.nt is
         when nd_data_decl => lc_data_decl(decl.data_decl, lc);
         when nd_func_decl => lc_func_decl(decl.func_decl);
         when nd_eq_decl =>
            lc_eq_decl(decl.eq_decl);
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
      lc_it: lc_pnode;
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
         lc_alt_params(params, lc, num_params);
      end if;

      --Seek TUPLE-n node to set n
      lc_it := lc;
      while lc_it.appl_func.nt = nd_apply loop
         lc_it := lc_it.appl_func;
      end loop;
      lc_it.appl_arg.cons_val := num_params;

   end lc_alt;

   procedure lc_alt_params(p: in pnode; lc: in out lc_pnode; num_params: in out integer) is
      el: pnode renames p.params_el;
      aux_lc: lc_pnode;
   begin
      if el = null then return; end if; --No params must be constructed

      -- Construct params lc-tree
      while el /= null loop
         num_params := num_params + 1;

         aux_lc := new lc_node(nd_apply);
         aux_lc.appl_func := lc;
         aux_lc.appl_arg := e_to_lc_tree(el.el_e);

         lc := aux_lc;
         el := el.el_el;
      end loop;

   end lc_alt_params;


   procedure lc_eq_decl(p: in pnode) is
      patterns: pnode renames p.eq_pattern;
      eq_e: pnode renames p.eq_e;
      index_count: Natural := 0;
      d: description;
      pt, npt: p_pm_node;
      elc: lc_pnode;
      dummy_positions: pm_position(1..2);
   begin

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
         if patterns /= null then
            for i in dummy_positions'Range loop dummy_positions(i) := 1; end loop;
            npt := cons_pattern_tree(patterns.params_el, index_count, dummy_positions,
                                     d.fn_eq_count);
         end if;
      end if;


      -- 3. Construct E lc tree
      elc := e_to_lc_tree(eq_e);


      -- 4. Merge pattern tree with function lc patern tree
      merge_pattern_trees(pt, npt);
      d.fn_lc_tree := pt;
      update(st, p.eq_id.identifier_id, d);

   end lc_eq_decl;


   function cons_pattern_tree(p: in pnode; i: in out Natural; pos: in pm_position; eq: in Natural)
                              return p_pm_node is
      d: description;
      pt: pnode;
      ret, pts: p_pm_node;
      derivations_count, position_count: integer;
      cons_num, dummy_i: natural;
      isConstructor: boolean;
   begin
      if p.el_el /= null then
         pts := cons_pattern_tree(p.el_el, i, pos, eq);
      end if;

      i := i + 1;
      cons_num := natural'Last;
      pt := getType(p.el_e, isConstructor);

      if (not isConstructor) then
         --If not function or constructor -> 1 pointer
         derivations_count := 1;
         --If not constructor, pos array maintains its length
         position_count := pos'Length;
      else
         position_count := pos'Length + 1;

         --Calculate pts length
         d := cons(st, pt.fcall_id.identifier_id);
         derivations_count := d.fn_eq_count;
         --Extract constructor number
         d := cons(st, p.el_e.efcall.fcall_id.identifier_id);
         cons_num := d.cons_id;
      end if;

      ret := new pm_node(pm_inner, position_count, derivations_count);

      --Fill positions
      for j in pos'Range loop
         ret.pos(j) := pos(j);
      end loop;

      ret.pos(pos'Last - 1) := i;
      if isConstructor then
         ret.pos(pos'Last) := 1;

         --Iterate for constructor params and fill ret.pos
         dummy_i := 0;
         ret := cons_pattern_tree(p.efcall.fcall_params, dummy_i, ret.pos, eq);
      end if;


      --Fill pts
      for j in ret.derivs'Range loop
         if j = cons_num then
            --Create node (if p.el_el = null then deriv = leaf node, else deriv = pts)
            if p.el_el = null then
               ret.derivs(j) := new pm_node(pm_leaf, 0, 0);
               ret.derivs(j).eq_number := eq;
            else
               ret.derivs(j) := pts;
            end if;
         else
            ret.derivs(j) := null;
         end if;

      end loop;

      return ret;
   end cons_pattern_tree;


   procedure lc_data(p: in pnode; lc: out lc_pnode) is
   begin
      lc := e_to_lc_tree(p);
   end lc_data;


















   -------------------AUXILIAR FUNCTIONS-------------------
   procedure merge_pattern_trees(base: in out p_pm_node; new_tree: in p_pm_node) is
      bderivs: pm_derivations renames base.derivs;
      nderivs: pm_derivations renames new_tree.derivs;
      itb, itn: p_pm_node;   --Iterators for base and new trees
   begin
      itb := base;
      itn := new_tree;
      while itb.nt /= pm_leaf loop
         if itb.pos > itn.pos then
            null; --TODO

         elsif itb.pos = itn.pos then
            --If equal, then merge pointers
            for i in bderivs'Range loop
               if bderivs(i) = null and nderivs(i) /= null then
                  bderivs(i) := nderivs(i);
               end if;
            end loop;

         else -- itb.position < itn.position
            null; --TODO
         end if;

      end loop;

   end merge_pattern_trees;


   function e_to_lc_tree(p: in pnode) return lc_pnode is
      ret:    lc_pnode;
      ret_it: lc_pnode; --Iterator for tuple construction
      n: integer;       --Tuple counter
   begin
      case p.nt is
         -- T[[ n ]] = n      n is literal
         when nd_elit =>
            ret := new lc_node(nd_const);
            ret.cons_id := c_val;
--UNCOMMENT            ret.cons_val := p.elit.lit_lit.val;

         -- T[[ i ]] = i      i is var
         -- T[[ E1 E2 ]] = T[[ E1 ]] T[[ E2 ]]
         when nd_efcall =>
            null;
--UNCOMMENT            ret := fcall_to_lc_node(p.efcall);

         -- T[[ + E1 E2 ]] = plus T[[ E1 ]] T[[ E2 ]]
         when nd_plus =>
            ret := new lc_node(nd_apply);
            ret.appl_arg := e_to_lc_tree(p.plus_e2);
            ret.appl_func := new lc_node(nd_apply);
            ret.appl_func.appl_arg := e_to_lc_tree(p.plus_e1);
            ret.appl_func.appl_func := new lc_node(nd_const);
            ret.appl_func.appl_func.cons_id := c_plus;

         -- T[[ - E1 E2 ]] = sub T[[ E1 ]] T[[ E2 ]]
         when nd_sub =>
            ret := new lc_node(nd_apply);
            ret.appl_arg := e_to_lc_tree(p.sub_e2);
            ret.appl_func := new lc_node(nd_apply);
            ret.appl_func.appl_arg := e_to_lc_tree(p.sub_e1);
            ret.appl_func.appl_func := new lc_node(nd_const);
            ret.appl_func.appl_func.cons_id := c_sub;

         -- T[[ - E1 ]] = usub T[[ E1 ]]
         when nd_usub =>
            ret := new lc_node(nd_apply);
            ret.appl_arg := e_to_lc_tree(p.usub_e);
            ret.appl_func := new lc_node(nd_const);
            ret.appl_func.cons_id := c_usub;

         -- T[[ * E1 E2 ]] = prod T[[ E1 ]] T[[ E2 ]]
         when nd_prod =>
            ret := new lc_node(nd_apply);
            ret.appl_arg := e_to_lc_tree(p.prod_e2);
            ret.appl_func := new lc_node(nd_apply);
            ret.appl_func.appl_arg := e_to_lc_tree(p.prod_e1);
            ret.appl_func.appl_func := new lc_node(nd_const);
            ret.appl_func.appl_func.cons_id := c_prod;

         -- T[[ / E1 E2 ]] = div T[[ E1 ]] T[[ E2 ]]
         when nd_div =>
            ret := new lc_node(nd_apply);
            ret.appl_arg := e_to_lc_tree(p.div_e2);
            ret.appl_func := new lc_node(nd_apply);
            ret.appl_func.appl_arg := e_to_lc_tree(p.div_e1);
            ret.appl_func.appl_func := new lc_node(nd_const);
            ret.appl_func.appl_func.cons_id := c_div;

         -- T[[ mod E1 E2 ]] = mod T[[ E1 ]] T[[ E2 ]]
         when nd_mod =>
            ret := new lc_node(nd_apply);
            ret.appl_arg := e_to_lc_tree(p.mod_e2);
            ret.appl_func := new lc_node(nd_apply);
            ret.appl_func.appl_arg := e_to_lc_tree(p.mod_e1);
            ret.appl_func.appl_func := new lc_node(nd_const);
            ret.appl_func.appl_func.cons_id := c_mod;

         -- T[[ relop E1 E2 ]] = relop T[[ E1 ]] T[[ E2 ]]
         when nd_relop =>
            ret := new lc_node(nd_apply);
            ret.appl_arg := e_to_lc_tree(p.relop_e2);
            ret.appl_func := new lc_node(nd_apply);
            ret.appl_func.appl_arg := e_to_lc_tree(p.relop_e2);
            ret.appl_func.appl_func := new lc_node(nd_const);

            case p.relop.op_type is
               when eq =>
                  ret.appl_func.appl_func.cons_id := c_eq;   --relop = eq
               when ne =>
                  ret.appl_func.appl_func.cons_id := c_neq;  --relop = neq
               when lt =>
                  ret.appl_func.appl_func.cons_id := c_lt;   --relop = lt
               when gt =>
                  ret.appl_func.appl_func.cons_id := c_gt;   --relop = gt
               when le =>
                  ret.appl_func.appl_func.cons_id := c_le;   --relop = le
               when ge =>
                  ret.appl_func.appl_func.cons_id := c_ge;   --relop = ge
            end case;

         -- T[[ if E1 then E2 else E3 ]] = COND T[[ E1 ]] T[[ E2 ]] T[[ E3 ]]
         when nd_econd =>
            ret := new lc_node(nd_apply);
            if p.econd.cond_els.else_e = null then
               ret.appl_arg := e_to_lc_tree(p.econd.cond_els.else_e2);
               ret.appl_func := new lc_node(nd_apply);
               ret.appl_func.appl_arg := e_to_lc_tree(p.econd.cond_els.else_e1);
               ret.appl_func.appl_func := new lc_node(nd_const);
               ret.appl_func.appl_func.cons_id := c_cond;

            -- T[[ if E1 then E2 ]] = COND T[[ E1 ]] T[[ E2 ]]
            else
               ret.appl_arg := e_to_lc_tree(p.econd.cond_els.else_e);
               ret.appl_func := new lc_node(nd_apply);
               ret.appl_func.cons_id := c_cond;
            end if;


         -- T[[ [E1, E2,..., En] ]] = TUPLE-n T[[ E1 ]] T[[ E2 ]] ... T[[ En ]]
         when nd_elist =>
            ret := new lc_node(nd_apply);
            ret.appl_func := new lc_node(nd_const);
            ret.appl_func.cons_id := c_tuple;
            ret := list_to_lc_tree(p.elist_list.list_e_list, ret, n);

            --Seek TUPLE-n node to set n
            ret_it := ret;
            while ret_it.nt /= nd_const loop
              ret_it := ret_it.appl_func;
            end loop;
            ret_it.cons_val := n;
         when others => raise lc_error;

      end case;

      return ret;
   end e_to_lc_tree;


   function fcall_to_lc_tree(p: in pnode) return lc_pnode is
      ret: lc_pnode;
      aux_ret: lc_pnode;
      param: pnode;
      d: description;
   begin
      d := cons(st, p.fcall_id.identifier_id);

      -- T[[ i ]] = i      i is var
      if d.dt = var_d then
         ret := new lc_node(nd_const);
         ret.cons_id := c_ident;
--UNCOMENT         ret.cons_val := p.fcall_id.identifier_id;


      -- T[[ E1 E2 ]] = T[[ E1 ]] T[[ E2 ]]
      elsif d.dt = func_d then
         ret := new lc_node(nd_apply);
         ret.appl_func := new lc_node(nd_const);
         ret.appl_func.cons_id := c_ident;
       --UNCOMMENT  ret.appl_func.cons_val := p.fcall_id.identifier_id;

         param := p.fcall_params;
         if param = null or else param.params_el = null then return ret; end if;
         param := param.params_el;

         -- Construct params lc-tree
         while param /= null loop
            aux_ret := new lc_node(nd_apply);
            aux_ret.appl_func := ret;
            aux_ret.appl_arg := e_to_lc_tree(param.el_e);

            ret := aux_ret;
            param := param.el_el;
         end loop;

      else
         raise lc_error;
      end if;

      return ret;
   end fcall_to_lc_tree;


   --Recursively construct the tuple lambda calculus tree
   function list_to_lc_tree (p: in pnode; lc: in lc_pnode; i: out integer) return lc_pnode is
      elc: lc_pnode;
   begin
      elc := new lc_node(nd_apply);
      elc.appl_func := lc;
      elc.appl_arg := e_to_lc_tree(p.list_e);

      if p.list_list /= null then
         elc := list_to_lc_tree(p.list_list, elc, i);
      end if;

      i := i + 1;

      return elc;
   end list_to_lc_tree;

   function getType(p: in pnode; isConstructor: out boolean) return pnode is
      d: description;
      ret: pnode;
      tt, lastt, ctt: pnode;
      elem: pnode;
   begin
      isConstructor := False;
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
               when others => null;
            end case;
         when nd_elit =>
            return getType(p.elit, isConstructor);
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
                  isConstructor := True;
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
               elem := getType(ctt.list_e, isConstructor);
               tt.tuple_type_ctt.pos := elem.pos;
               if elem.nt = nd_ident then
                  tt.tuple_type_ctt.c_tuple_type_fcall := new node(nd_fcall);
                  tt.tuple_type_ctt.c_tuple_type_fcall.pos := elem.pos;
                  tt.tuple_type_ctt.c_tuple_type_fcall.fcall_id := elem;
               elsif elem.nt = nd_fcall then
                  tt.tuple_type_ctt.c_tuple_type_fcall := elem;
               elsif elem.nt = nd_typevar then
                  d := cons(st, ctt.list_e.efcall.fcall_id.identifier_id);
                  if d.dt = var_d then
                     tt.tuple_type_ctt.c_tuple_type_fcall := new node(nd_fcall);
                     tt.tuple_type_ctt.c_tuple_type_fcall.pos := elem.pos;
                     tt.tuple_type_ctt.c_tuple_type_fcall.fcall_id := new node(nd_ident);
                     tt.tuple_type_ctt.c_tuple_type_fcall.fcall_id.pos := elem.pos;
                     tt.tuple_type_ctt.c_tuple_type_fcall.fcall_id.identifier_id := d.vtype;
                  end if;
               else
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
            ret.fcall_params := getType(p.list_e_list.list_e, isConstructor); --Obtain first element's type
         when nd_conc =>
            ret := new node(nd_fcall);
            ret.fcall_id := new node(nd_ident);
            ret.fcall_id.pos := p.pos;
            ret.fcall_id.identifier_id := list_nid;
            ret.fcall_params := getType(p.conc_e1, isConstructor);
            isConstructor := True;
         when nd_tuple =>
            return getType(p.tuple_list, isConstructor);
         when others =>
            raise lc_error;
      end case;

      ret.pos := p.pos;
      return ret;
   end getType;


end semantic.c_lc_tree;
