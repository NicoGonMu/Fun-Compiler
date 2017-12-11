with Ada.Text_IO;
use Ada.Text_IO;
package body semantic.c_lc_tree is
   procedure prepare_flist;

   procedure lc_prog(p: in pnode; lc: out lc_pnode);
   procedure lc_defs(p: in pnode);

   procedure lc_func_decl  (p: in pnode);

   procedure lc_data_decl  (p: in pnode);
   procedure lc_alts       (p: in pnode; lc: out lc_pnode);
   procedure lc_alt        (p: in pnode; lc: out lc_pnode);
   procedure lc_alt_params (p: in pnode; lc: in out lc_pnode; num_params: in out integer);

   procedure lc_eq_decl(p: in pnode);

   procedure lc_data(p: in pnode; lc: out lc_pnode);

   function e_to_lc_tree(p: in pnode; eqn: in Natural := 0) return lc_pnode;
   function fcall_to_lc_tree(p: in pnode; eq: in Natural) return lc_pnode;
   function list_to_lc_tree(p: in pnode; lc: in lc_pnode; i: out integer; eqn: in Natural) return lc_pnode;
   function tuple_to_lc_tree(p: in pnode; lc: in lc_pnode; i: out integer; eqn: in Natural) return lc_pnode;

   --Function that translates a Matching Tree
   function E(a: in lc_pnode; p: in p_pm_node) return lc_pnode;
   --Function that translates a PM_POSITION
   function P_translate(a: in lc_pnode; p: in pm_position) return lc_pnode;

   function build_pattern_tree(p: in pnode; i: in out Natural; pos: in pm_position; eq: in Natural)
                               return p_pm_node;
   function add_params_pattern_tree(p: in pnode; i: in out Natural; pos: in pm_position; eq: in Natural)
                              return p_pm_node;
   function getType(p: in pnode; isConstructor: out boolean) return pnode;
   procedure merge_pattern_trees(base: in out p_pm_node; new_tree: in p_pm_node);

   procedure generate_lc_tree (fname: in string) is
   begin
      prepare_flist;
      lc_prog(root, lc_root);
      exitbloc(st);
   end generate_lc_tree;

   procedure prepare_flist is
   begin
      for i in flist'Range loop
         flist(i) := null_id;
      end loop;
   end prepare_flist;

   -------------------------------------------------------------------

   procedure lc_prog(p: in pnode; lc: out lc_pnode) is
      data: pnode renames p.data;
      defs: pnode renames p.defs;
      def_lc_tree: lc_pnode;
      d: description;
   begin
      definition_count := 0;

      lc := new lc_node(nd_apply);
      lc.appl_func := new lc_node(nd_lambda);
      lc.appl_func.lambda_id := new lc_node(nd_const);
      lc.appl_func.lambda_id.cons_id := c_Y;
      lc.appl_func.lambda_decl := new lc_node(nd_lambda);
      lc.appl_func.lambda_decl.lambda_id := new lc_node(nd_const);
      lc.appl_func.lambda_decl.lambda_id.cons_id := c_T;
      lc.appl_func.lambda_decl.lambda_decl := new lc_node(nd_lambda);

      --Definitions lambda tree
      def_lc_tree := new lc_node(nd_apply);

      --First node: TUPLE-n DEF1 DEF2 ... DEFn
      def_lc_tree.appl_func := new lc_node(nd_const);
      def_lc_tree.appl_func.cons_id := c_tuple;
      def_lc_tree.appl_arg := new lc_node(nd_const);
      def_lc_tree.appl_arg.cons_id := c_null;
      lc.appl_func.lambda_decl.lambda_decl := def_lc_tree;

      --Construct definitions and store them
      lc_defs(defs);

      --Add function definitions
      for i in flist'Range loop
         definition_count := definition_count + 1;

         -- New application where appl_func = definitions_tree, applied to new definition
         def_lc_tree := new lc_node(nd_apply);
         def_lc_tree.appl_func := lc.appl_func.lambda_decl.lambda_decl;

         -- a.CASE-n (code from mathing tree) (error) (eq1) (eq2) ... (eqn)
         d := cons(st, flist(i));
         -- CASE
         def_lc_tree.appl_arg := new lc_node(nd_apply);
         def_lc_tree.appl_arg.appl_func := new lc_node(nd_const);
         def_lc_tree.appl_arg.appl_func.cons_id := c_case;
         def_lc_tree.appl_arg.appl_func.cons_val := d.fn_eq_total;

         --Get code from matching tree
         def_lc_tree.appl_arg.appl_arg := E(null, d.fn_pm_tree); --TODO check "a" parameter
         lc.appl_func.lambda_decl.lambda_decl := def_lc_tree;

         --Merge (CASE-n (code from mathing tree)) with ((error))
         def_lc_tree := new lc_node(nd_apply);
         def_lc_tree.appl_func := new lc_node(nd_apply);
         def_lc_tree.appl_func.appl_func := lc.appl_func.lambda_decl.lambda_decl;
         def_lc_tree.appl_func.appl_arg := new lc_node(nd_const);
         def_lc_tree.appl_func.appl_arg.cons_id := c_null; -- (error)
         lc.appl_func.lambda_decl.lambda_decl := def_lc_tree;

         --Merge (CASE-n (code from mathing tree) (error)) with ((def1) (def2) ... (defn))
         def_lc_tree := d.fn_lc_tree;
         while def_lc_tree.appl_func /= null loop
            def_lc_tree := def_lc_tree.appl_func;
         end loop;
         def_lc_tree.appl_func := lc.appl_func.lambda_decl.lambda_decl;
         lc.appl_func.lambda_decl.lambda_decl := def_lc_tree.appl_func;

      end loop;

      --Traverse tree to set n (from TUPLE-n)
      while def_lc_tree.nt /= nd_const loop
         def_lc_tree := def_lc_tree.appl_func;
      end loop;
      def_lc_tree.cons_val := definition_count;

      Put_Line("Defs converted to lambda calculus");
      lc_data(data, lc.appl_arg);
   end lc_prog;

   procedure lc_defs(p: in pnode) is
      decls: pnode renames p.decls;
      decl:  pnode renames p.decl;
   begin

      case decl.nt is
         --On data_decl, create node and add it to its description
         when nd_data_decl =>
            Put_Line("Decl");
            lc_data_decl(decl.data_decl);

         --On function declaration, only save name_id on flist
         when nd_func_decl =>
            Put_Line("Fun");
            lc_func_decl(decl.func_decl);

         --On eq_decl, create node and add it do function description
         when nd_eq_decl =>
            Put_Line("Eq");
            lc_eq_decl(decl.eq_decl);

         when others => null;
      end case;


      if decls /= null then
         lc_defs(decls);
      end if;

   end lc_defs;

   procedure lc_func_decl  (p: in pnode) is
      d: description;
   begin
      --Register function in list
      d := cons(st, p.func_id.identifier_id);
      flist(d.fn_id) := p.func_id.identifier_id;
   end lc_func_decl;


   procedure lc_data_decl(p: in pnode) is
      lc:     lc_pnode;
      id:     pnode renames p.data_id;
      params: pnode renames p.data_params;
      alts:   pnode renames p.data_alts;
      d:      description;
   begin
      alt_id := 0;

      --New node TUPLE-n
      lc := new lc_node(nd_apply);
      lc.appl_func := new lc_node(nd_const);
      lc.appl_func.cons_id := c_tuple;

      --lc_alts(alts, lc.appl_arg); TODO Check if necessary

      --Set TUPLE-n size
      lc.appl_func.cons_val := alt_id;

      --Obtain description in order to update it
      d := cons(st, id.identifier_id);
      d.type_lc_tree := lc;
      update(st, id.identifier_id, d);

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
      d: description;
      pt, npt: p_pm_node;
      elc: lc_pnode;
      dummy_positions: pm_position(1..2);
   begin

      -- 1. Obtain function pm tree from description
      d := cons(st, p.eq_id.identifier_id);
      pt := d.fn_pm_tree;
      current_fn := d.fn_id;

      -- 2. Upgrade functions equation count
      d.fn_eq_count := d.fn_eq_count + 1;

      -- 3. Construct equation's pattern tree
      if patterns = null then
         --If no args, only 1 pattern
         npt := new pm_node(pm_leaf, 0, 0);
         npt.eq_number := d.fn_eq_count;
      else
         --For each E, create pm_node
         if patterns /= null then
            -- Set dummy positions as [0,1] for correct looping
            dummy_positions(1) := 0;
            dummy_positions(2) := 1;
            npt := build_pattern_tree(patterns.pat_lmodels, dummy_positions, d.fn_eq_count);
         end if;
      end if;

      -- 4. Merge pattern tree with function lc pattern tree
      merge_pattern_trees(pt, npt);
      d.fn_pm_tree := pt;

      -- 5. Construct E lc tree
      elc := new lc_node(nd_apply);
      elc.appl_func := d.fn_lc_tree;
      elc.appl_arg := e_to_lc_tree(eq_e, d.fn_eq_count);

      -- 6. Add E lc tree to function lc tree
      d.fn_lc_tree := elc;

      -- 7. Save new pattern matching tree, equation count, and new lambda-calculus tree
      update(st, p.eq_id.identifier_id, d);
   end lc_eq_decl;


   function build_pattern_tree(p: in pnode; i: in out Natural; pos: in out pm_position; eq: in Natural)
                              return p_pm_node is
      d: description;
      pt: pnode;
      ret, pts: p_pm_node;
      derivations_count, position_count: integer;
      cons_num, dummy_i: natural;
      isConstructor: boolean;
   begin
      if p.lmodels_lmodels /= null then
         pts := build_pattern_tree(p.lmodels_lmodels, pos, eq);
      end if;

      cons_num := natural'Last;
      pt := getType(p.lmodels_model, isConstructor);

      -- If it's a constructor, build inner node
      if isConstructor then
         position_count := pos'Length;

         --Calculate pts length (number of derivations)
         d := cons(st, pt.fcall_id.identifier_id);
         derivations_count := d.type_alts;

         --Extract constructor number
         d := cons(st, p.lmodels_model.efcall.fcall_id.identifier_id);
         cons_num := d.cons_id;

         -- Declare inner node of calculated lengths
         ret := new pm_node(pm_inner, position_count, derivations_count);

         --Fill positions
         for j in pos'Range loop
            ret.pos(j) := pos(j);
         end loop;

         ret.pos(pos'Last - 1) := ret.pos(pos'Last - 1) + 1;

         ret.pos(pos'Last) := 1;

         --Iterate for constructor params and fill ret.pos
         --(For each effective parameter that is a constructor,
         -- add it recursively to the tree)
         if p.efcall.fcall_params /= null and then p.efcall.fcall_params.params_el /= null then
            dummy_i := 0;
            ret := add_params_pattern_tree(p.efcall.fcall_params.params_el, dummy_i, ret.pos, eq);
         end if;

      end if;

      --Save position on Symbol Table for Binding
      if (p.lmodels_model.nt = nd_efcall) then
         d := cons(st, p.lmodels_model.efcall.fcall_id.identifier_id);
         Put_Line(consult(nt, p.lmodels_model.efcall.fcall_id.identifier_id));
         if d.dt = null_d then
            -- Dummy description for posterior treatment
            d := (var_d, 0, null_id, null);
         end if;

         if d.dt = var_d then
            --Bind variable
            -- If no binds registered, create new array
            if d.vbinds = null then
               d.vbinds := new binding_list(0..fn);
               for i in 0..fn loop d.vbinds(i) := new binding; end loop;
            end if;

            -- If no binds registered on that function, create new array
            if d.vbinds(current_fn).element = null then
               d.vbinds(current_fn).element := new equation_bind(0..eq);
               for i in 0..eq loop d.vbinds(current_fn).element(i) := new pm_position(0..1); end loop;
            end if;

            --Register position
            for i in ret.pos'Range loop
               d.vbinds(current_fn).element(eq).all := ret.pos;
            end loop;

            -- Save new binded variable
            update(st, p.lmodels_model.efcall.fcall_id.identifier_id, d);

         -- If vartype, same process using vtbinds
         elsif d.dt = vartype_d then
            --Bind variable
            -- If no binds registered, create new array
            if d.vtbinds = null then
               d.vtbinds := new binding_list(0..fn);
               for i in 0..fn loop d.vtbinds(i) := new binding; end loop;
            end if;

            -- If no binds registered on that function, create new array
            if d.vtbinds(current_fn).element = null then
               d.vtbinds(current_fn).element := new equation_bind(0..eq);
               for i in 0..eq loop d.vtbinds(current_fn).element(i) := new pm_position(0..1); end loop;
            end if;

            --Register position
            for i in ret.pos'Range loop
               d.vtbinds(current_fn).element(eq).all := ret.pos;
            end loop;

            -- Save new binded variable
            update(st, p.lmodels_model.efcall.fcall_id.identifier_id, d);
         end if;
      end if;

      --Fill pts
      for j in ret.derivs'Range loop
         if j = cons_num then
            --Create node (if p.lmodels_model = null then deriv = leaf node, else deriv = pts)
            if p.lmodels_model = null then
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
   end build_pattern_tree;

   function add_params_pattern_tree(p: in pnode; i: in out Natural; pos: in pm_position; eq: in Natural)
                                    return p_pm_node is
      ret, pts: p_pm_node;
      d: description;
      isConstructor: Boolean;
   begin
      -- Iterate through each param looking for constructors and variables
      if p.el_el /= null then
         pts := add_params_pattern_tree(p.el_el, i, pos, eq);
      end if;

      -- If it's not an efcall node, it is not interesting for the tree
      if p.el_e.nt /= nd_efcall then
         return pts;
      end if;

      -- Get efcall type
      pt := getType(p.el_e.efcall, isConstructor);

      if isConstructor then

      end if;

      if pt.nt = null_d then
         -- Dummy description for posterior treatment
         d := (var_d, 0, null_id, null);
      end if;



   end add_params_pattern_tree;

   procedure lc_data(p: in pnode; lc: out lc_pnode) is
   begin
      lc := e_to_lc_tree(p);
   end lc_data;


















   -------------------AUXILIAR FUNCTIONS-------------------

   --M(T1 & <p1, [t10, t11, ..., t1n-1]>, T2 & <p2, [t20, t21, ..., t2n-1]>)
   procedure merge_pattern_trees(base: in out p_pm_node; new_tree: in p_pm_node) is
      bderivs: pm_derivs_ref;
      nderivs: pm_derivs_ref;
      itb, itn: p_pm_node;   --Iterators for base and new trees
   begin
      --If base is null, new_tree will be now the base
      if base = null then
         base := new_tree;
         return;
      end if;

      if new_tree.nt /= pm_inner then raise lc_error; end if;

      --If base is
      bderivs := new pm_derivations(base.derivs'Range);
      bderivs.all := base.derivs;
      nderivs := new pm_derivations(new_tree.derivs'Range);
      nderivs.all := new_tree.derivs;
      itb := base;
      itn := new_tree;
      while itb.nt /= pm_leaf loop
         --if p1 > p2 => <p2, [M(T1, t20), M(T1, t21), ..., M(T1, tsn-1)]>
         if itb.pos > itn.pos then
            for i in nderivs'Range loop
               if nderivs(i) = null and bderivs(i) /= null then
                  nderivs(i) := bderivs(i);
               end if;
            end loop;
            bderivs := nderivs;

         --if p1 = p2 => <p1, [M(t10, t20), M(t11, t21), ..., M(t1n-1, t2n-1)]>
         elsif itb.pos = itn.pos then
            for i in bderivs'Range loop
               if bderivs(i) = null and nderivs(i) /= null then
                  bderivs(i) := nderivs(i);
               end if;
            end loop;

         --if p1 < p2 => <p1, [M(t10, T2), M(t11, T2), ..., M(t1n-1, T2)]>
         else
            for i in bderivs'Range loop
               if bderivs(i) = null and nderivs(i) /= null then
                  bderivs(i) := nderivs(i);
               end if;
            end loop;

         end if;

      end loop;

   end merge_pattern_trees;


   function e_to_lc_tree(p: in pnode; eqn: Natural := 0) return lc_pnode is
      it: pnode;
      ret:    lc_pnode;
      ret_it: lc_pnode; --Iterator for tuple construction
      n: integer;       --Tuple counter
   begin
      case p.nt is
         -- T[[ n ]] = n      n is literal
         when nd_elit =>
            ret := new lc_node(nd_const);
            ret.cons_id := c_val;
            ret.cons_val := Integer(p.elit.lit_lit.val);

         -- T[[ i ]] = i      i is var
         -- T[[ E1 E2 ]] = T[[ E1 ]] T[[ E2 ]]
         when nd_efcall =>
            ret := fcall_to_lc_tree(p.efcall, eqn);

         -- T[[ + E1 E2 ]] = plus T[[ E1 ]] T[[ E2 ]]
         when nd_plus =>
            ret := new lc_node(nd_apply);
            ret.appl_arg := e_to_lc_tree(p.plus_e2, eqn);
            ret.appl_func := new lc_node(nd_apply);
            ret.appl_func.appl_arg := e_to_lc_tree(p.plus_e1, eqn);
            ret.appl_func.appl_func := new lc_node(nd_const);
            ret.appl_func.appl_func.cons_id := c_plus;

         -- T[[ - E1 E2 ]] = sub T[[ E1 ]] T[[ E2 ]]
         when nd_sub =>
            ret := new lc_node(nd_apply);
            ret.appl_arg := e_to_lc_tree(p.sub_e2, eqn);
            ret.appl_func := new lc_node(nd_apply);
            ret.appl_func.appl_arg := e_to_lc_tree(p.sub_e1, eqn);
            ret.appl_func.appl_func := new lc_node(nd_const);
            ret.appl_func.appl_func.cons_id := c_sub;

         -- T[[ - E1 ]] = usub T[[ E1 ]]
         when nd_usub =>
            ret := new lc_node(nd_apply);
            ret.appl_arg := e_to_lc_tree(p.usub_e, eqn);
            ret.appl_func := new lc_node(nd_const);
            ret.appl_func.cons_id := c_usub;

         -- T[[ * E1 E2 ]] = prod T[[ E1 ]] T[[ E2 ]]
         when nd_prod =>
            ret := new lc_node(nd_apply);
            ret.appl_arg := e_to_lc_tree(p.prod_e2, eqn);
            ret.appl_func := new lc_node(nd_apply);
            ret.appl_func.appl_arg := e_to_lc_tree(p.prod_e1, eqn);
            ret.appl_func.appl_func := new lc_node(nd_const);
            ret.appl_func.appl_func.cons_id := c_prod;

         -- T[[ / E1 E2 ]] = div T[[ E1 ]] T[[ E2 ]]
         when nd_div =>
            ret := new lc_node(nd_apply);
            ret.appl_arg := e_to_lc_tree(p.div_e2, eqn);
            ret.appl_func := new lc_node(nd_apply);
            ret.appl_func.appl_arg := e_to_lc_tree(p.div_e1, eqn);
            ret.appl_func.appl_func := new lc_node(nd_const);
            ret.appl_func.appl_func.cons_id := c_div;

         -- T[[ mod E1 E2 ]] = mod T[[ E1 ]] T[[ E2 ]]
         when nd_mod =>
            ret := new lc_node(nd_apply);
            ret.appl_arg := e_to_lc_tree(p.mod_e2, eqn);
            ret.appl_func := new lc_node(nd_apply);
            ret.appl_func.appl_arg := e_to_lc_tree(p.mod_e1, eqn);
            ret.appl_func.appl_func := new lc_node(nd_const);
            ret.appl_func.appl_func.cons_id := c_mod;

         -- T[[ relop E1 E2 ]] = relop T[[ E1 ]] T[[ E2 ]]
         when nd_relop =>
            ret := new lc_node(nd_apply);
            ret.appl_arg := e_to_lc_tree(p.relop_e2, eqn);
            ret.appl_func := new lc_node(nd_apply);
            ret.appl_func.appl_arg := e_to_lc_tree(p.relop_e2, eqn);
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
               ret.appl_arg := e_to_lc_tree(p.econd.cond_els.else_e2, eqn);
               ret.appl_func := new lc_node(nd_apply);
               ret.appl_func.appl_arg := e_to_lc_tree(p.econd.cond_els.else_e1, eqn);
               ret.appl_func.appl_func := new lc_node(nd_const);
               ret.appl_func.appl_func.cons_id := c_cond;

            -- T[[ if E1 then E2 ]] = COND T[[ E1 ]] T[[ E2 ]]
            else
               ret.appl_arg := e_to_lc_tree(p.econd.cond_els.else_e, eqn);
               ret.appl_func := new lc_node(nd_apply);
               ret.appl_func.cons_id := c_cond;
            end if;


         -- T[[ (E1, E2,..., En) ]] = TUPLE-n T[[ E1 ]] T[[ E2 ]] ... T[[ En ]]
         when nd_tuple =>
            ret := new lc_node(nd_const);
            ret.cons_id := c_tuple;
            ret := tuple_to_lc_tree(p.tuple_list, ret, n, eqn);

            --Seek TUPLE-n node to set n
            ret_it := ret;
            while ret_it.nt /= nd_const loop
               ret_it := ret_it.appl_func;
            end loop;
            ret_it.cons_val := n;

         -- T[[ [E1, ..., En] ]] = TUPLE-3 1 T[[ E1 ]] ... TUPLE-2 1 T[[ En ]]
         -- [E1, ..., En] is a list, so we must traduce it to the constructor "cons(a, list(a))"
         when nd_elist | nd_list =>

            it := p;
            if p.nt = nd_elist then
               it := it.elist_list;
            end if;

            while it /= null loop

               ret_it := new lc_node(nd_apply);
               ret_it.appl_func := ret;

               --TUPLE-(n+1)
               ret_it.appl_arg := new lc_node(nd_const);
               ret_it.appl_arg.cons_id  := c_tuple;
               if it.list_list = null then
                  ret_it.appl_arg.cons_val := 2;
               else
                  ret_it.appl_arg.cons_val := 3;
               end if;

               -- 1
               ret := new lc_node(nd_apply);
               ret.appl_func := ret_it;
               ret.appl_arg := new lc_node(nd_const);
               ret.appl_arg.cons_id := c_val;
               ret.appl_arg.cons_val := 1;

               -- T[[ E ]]
               ret_it := new lc_node(nd_apply);
               ret_it.appl_func := ret;
               ret_it.appl_arg := e_to_lc_tree(it.list_e, eqn);

               ret := ret_it;
               it := it.list_list;

            end loop;

         when others => raise lc_error;

      end case;

      return ret;
   end e_to_lc_tree;


   function fcall_to_lc_tree(p: in pnode; eq: in Natural) return lc_pnode is
      ret: lc_pnode;
      aux_ret: lc_pnode;
      param: pnode;
      d: description;
      i: Natural;
   begin
      d := cons(st, p.fcall_id.identifier_id);

      -- T[[ E1 E2 ]] = T[[ E1 ]] T[[ E2 ]]
      if d.dt = func_d then
         --T[[ E1 ]] = INDEX-i T
         ret := new lc_node(nd_apply);
         ret.appl_func := new lc_node(nd_const);
         ret.appl_func.cons_id := c_index;
         ret.appl_func.cons_val := Integer(d.fn_id);
         ret.appl_arg := new lc_node(nd_const);
         ret.appl_arg.cons_id := c_T;

         param := p.fcall_params;
         if param = null or else param.params_el = null then return ret; end if;
         param := param.params_el;

         -- Construct params lc-tree
         while param /= null loop
            aux_ret := new lc_node(nd_apply);
            aux_ret.appl_func := ret;
            aux_ret.appl_arg := e_to_lc_tree(param.el_e, eq);

            ret := aux_ret;
            param := param.el_el;
         end loop;


      -- T[[ c(E1, ..., En) ]] = TUPLE-(n+1) Nc T[[ E1 ]] ... T[[ En ]]
      elsif d.dt = constructor_d then

         ret := new lc_node(nd_apply);

         --TUPLE-(n+1)
         ret.appl_func := new lc_node(nd_const);
         ret.appl_func.cons_id  := c_tuple;

         --Nc
         ret.appl_arg := new lc_node(nd_const);
         ret.appl_arg.cons_id := c_val;
         ret.appl_arg.cons_val := d.cons_id;

         -- T[[ E1 ]] ... T[[ En ]]
         param := p.fcall_params;
         if param = null or else param.params_el = null then return ret; end if;
         param := param.params_el;
         i := 1;

         while param /= null loop
            aux_ret := new lc_node(nd_apply);
            aux_ret.appl_func := ret;
            aux_ret.appl_arg := e_to_lc_tree(param.el_e, eq);

            ret := aux_ret;
            param := param.el_el;
            i := i + 1;
         end loop;


         --Set the correct n value of TUPLE-n
         aux_ret := ret;
         while ret.nt /= nd_apply loop
            aux_ret := ret.appl_func;
         end loop;
         aux_ret.appl_func.cons_val := i;


      -- T[[ x ]] = POS(X)      x is var
      elsif d.dt = vartype_d then
         ret := P_translate(null, d.vtbinds(current_fn).element(eq).all);

      -- T[[ x ]] = POS(X)      x is var
      else
         ret := P_translate(null, d.vbinds(current_fn).element(eq).all);
      end if;

      return ret;
   end fcall_to_lc_tree;


   --Recursively construct the tuple lambda calculus tree
   function list_to_lc_tree (p: in pnode; lc: in lc_pnode; i: out integer; eqn: in Natural) return lc_pnode is
      elc: lc_pnode;
   begin
      elc := new lc_node(nd_apply);
      elc.appl_func := lc;
      elc.appl_arg := e_to_lc_tree(p.list_e, eqn);

      if p.list_list /= null then
         elc := list_to_lc_tree(p.list_list, elc, i, eqn);
      end if;

      i := i + 1;

      return elc;
   end list_to_lc_tree;

   --Recursively construct the tuple lambda calculus tree
   function tuple_to_lc_tree (p: in pnode; lc: in lc_pnode; i: out integer; eqn: in Natural) return lc_pnode is
      lc1, lc2: lc_pnode;
      it: pnode;
   begin
      lc1 := new lc_node(nd_apply);
      lc1.appl_func := lc;
      lc1.appl_arg := e_to_lc_tree(p.tuple_list.list_e, eqn);

      i := i + 1;

      it := p.tuple_list.list_list;
      while it /= null loop
         lc2 := new lc_node(nd_apply);
         lc2.appl_func := lc1;
         lc2.appl_arg  := e_to_lc_tree(it.list_e, eqn);
         lc1 := lc2;

         it := it.list_list;
         i := i + 1;
      end loop;

      return lc1;
   end tuple_to_lc_tree;

   --Function that translates a Matching Tree
   function E(a: in lc_pnode; p: in p_pm_node) return lc_pnode is
      ret:   lc_pnode;
      auxlc: lc_pnode;
   begin
      case p.nt is

         when pm_inner =>

            -- E( a, X ) = -1
            if p = null then
               ret := new lc_node(nd_const);
               ret.cons_id := c_val;
               ret.cons_val := -1;

          -- E( a <p, [t0, t1, ..., tn-1] > ) = CASE-n P(a, p) 0 E(t0) E(t1) ... E(tn)
            else
               ret := new lc_node(nd_apply);
               -- CASE-n P(a, p)
               ret.appl_func := new lc_node(nd_const);
               ret.appl_func.cons_id := c_case;
               ret.appl_func.cons_val := p.derivs'Length;
               ret.appl_arg := P_translate(a, p.pos);

               -- (CASE-n P(a, p)) 0
               auxlc := new lc_node(nd_apply);
               auxlc.appl_func := ret;
               auxlc.appl_arg := new lc_node(nd_null);
               ret := auxlc;

               for i in p.derivs'Range loop
                  auxlc := new lc_node(nd_apply);
                  auxlc.appl_func := ret;
                  auxlc.appl_arg := E(a, p.derivs(i));

                  ret := auxlc;
               end loop;

            end if;

         -- E( a, { n } ) = n
         when pm_leaf =>
            ret := new lc_node(nd_const);
            ret.cons_id := c_val;
            ret.cons_val := p.eq_number;

         when others =>
            raise lc_error;
      end case;

      return ret;
   end E;


   --Function that translates a PM_POSITION
   --P( a, [2, 3, 3] ) = INDEX 3 ( INDEX 3 ( INDEX 2 a ) )
   function P_translate(a: in lc_pnode; p: in pm_position) return lc_pnode is
      ret:   lc_pnode;
      auxlc: lc_pnode;
   begin
      ret := null;

      --Iterate for each position adding application arguments
      for i in 0..p'Length - 1 loop
         auxlc := new lc_node(nd_apply);
         auxlc.appl_func := ret;
         auxlc.appl_arg := new lc_node(nd_apply);
         auxlc.appl_arg := new lc_node(nd_const);
         auxlc.appl_arg.cons_id := c_index;
         auxlc.appl_arg.cons_val := p(i);

         ret := auxlc;
      end loop;

      --Add last aplication argument
      auxlc := new lc_node(nd_apply);
      auxlc.appl_func := ret;
      auxlc.appl_arg := a;

      return auxlc;
   end P_translate;



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
