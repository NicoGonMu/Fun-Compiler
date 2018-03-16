with Ada.Text_IO, Ada.Strings.Unbounded;
use Ada.Text_IO, Ada.Strings.Unbounded;
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

   procedure lc_data(p: in pnode; lc: in out lc_pnode);

   function e_to_lc_tree(p: in pnode) return lc_pnode;
   function fcall_to_lc_tree(p: in pnode) return lc_pnode;
   function tuple_to_lc_tree(p: in pnode; lc: in lc_pnode; i: out integer) return lc_pnode;

   --Function that translates a Matching Tree
   function E(a: in lc_pnode; p: in p_pm_node) return lc_pnode;
   --Function that translates a PM_POSITION
   function P_translate(a: in lc_pnode; p: in pm_position) return lc_pnode;

   procedure build_pattern_tree(p: in pnode; pos: in out pm_position; eq: in Natural; eq_total: in Natural; tree: in out p_pm_node);

   procedure bind_variable(var_id: in name_id; pos: pm_position; eq: Integer; eq_total: Integer);
   function getType(p: in pnode; isConstructor: out boolean) return pnode;
   function merge_pattern_trees(base: in p_pm_node; new_tree: in p_pm_node) return p_pm_node;

   procedure swap_T(p: in out lc_pnode);



   procedure generate_lc_tree (fname: in string) is
   begin
      prepare_flist;
      Create(tf, Out_File, fname&"_lc_tree.txt");

      -- Build definition tree
      lc_prog(root, lc_root);
      --Build data tree
      lc_data(root.data, lc_root.appl_arg);
      lc_root := lc_root.appl_arg;

      write_lc_tree(lc_root, tf);
      close(tf);
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
      aux_lc_tree: lc_pnode; -- Aux pointer for tree construction
      d: description;
      text_lc_tree: Unbounded_String;
   begin
      definition_count := 0;

      lc := new lc_node(nd_apply);
      lc.appl_func := new lc_node(nd_apply);
      lc.appl_func.appl_func := new lc_node(nd_const);
      lc.appl_func.appl_func.cons_id := c_Y;
      lc.appl_func.appl_arg := new lc_node(nd_lambda);
      lc.appl_func.appl_arg.lambda_id := new lc_node(nd_const);
      lc.appl_func.appl_arg.lambda_id.cons_id := c_T;
      lc.appl_func.appl_arg.lambda_decl := new lc_node(nd_lambda);

      --First node: TUPLE-n DEF1 DEF2 ... DEFn
      def_lc_tree:= new lc_node(nd_const);
      def_lc_tree.cons_id := c_tuple;
      lc.appl_func.appl_arg.lambda_decl := def_lc_tree;

      --Construct definitions and store them
      lc_defs(defs);

      --Add function definitions
      for i in 1..fn loop

         -- If function has not appeared, continue
         if flist(i) = 0 then
            def_lc_tree := new lc_node(nd_apply);
            def_lc_tree.appl_func := lc.appl_func.appl_arg.lambda_decl;
            def_lc_tree.appl_arg := new lc_node(nd_const);
            def_lc_tree.appl_arg.cons_id := c_error;
            lc.appl_func.appl_arg.lambda_decl := def_lc_tree;

         else
            definition_count := definition_count + 1;

            -- Build function tree: CASE-n (code from mathing tree) (error) (eq1) (eq2) ... (eqn)
            d := cons(st, flist(i));
            def_lc_tree := new lc_node(nd_apply);

            -- CASE-n
            def_lc_tree.appl_func := new lc_node(nd_const);
            def_lc_tree.appl_func.cons_id := c_case;
            def_lc_tree.appl_func.cons_val := d.fn_eq_total + 1;

            -- Get code from pattern tree
            def_lc_tree.appl_arg := E(new lc_node'(nd_const, (0, 0), c_A, 0), d.fn_pm_tree);
            aux_lc_tree := def_lc_tree; -- Save tree

            --Merge (CASE-n (code from mathing tree)) with ((error))
            def_lc_tree := new lc_node(nd_apply);
            def_lc_tree.appl_func := aux_lc_tree;
            def_lc_tree.appl_arg := new lc_node(nd_const);
            def_lc_tree.appl_arg.cons_id := c_error; -- (error)
            aux_lc_tree := def_lc_tree; -- Save tree

            --Merge (CASE-n (code from mathing tree) (error)) with ((def1) (def2) ... (defn))
            def_lc_tree := new lc_node(nd_apply);
            def_lc_tree.appl_func := aux_lc_tree;
            def_lc_tree.appl_arg := d.fn_lc_tree;

            -- Create lambda.a node
            aux_lc_tree := new lc_node(nd_lambda);
            aux_lc_tree.lambda_id := new lc_node(nd_const);
            aux_lc_tree.lambda_id.cons_id := c_a;
            aux_lc_tree.lambda_decl := def_lc_tree;

            -- New application where appl_func = definitions_tree, applied to new definition
            def_lc_tree := new lc_node(nd_apply);
            def_lc_tree.appl_func := lc.appl_func.appl_arg.lambda_decl;
            def_lc_tree.appl_arg := aux_lc_tree;

            lc.appl_func.appl_arg.lambda_decl := def_lc_tree;

         end if;
      end loop;

      --Traverse tree to set n (from TUPLE-n)
      while def_lc_tree.nt /= nd_const loop
         def_lc_tree := def_lc_tree.appl_func;
      end loop;
      def_lc_tree.cons_val := Integer(fn);

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
      --Register function in list if it has equations
      d := cons(st, p.func_id.identifier_id);

      if d.fn_eq_total > 0 then
         flist(d.fn_id) := p.func_id.identifier_id;
      end if;
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
      pt, new_tree: p_pm_node;
      elc: lc_pnode;
      dummy_positions: pm_position(1..1);
   begin

      -- 1. Obtain function pm tree from description
      d := cons(st, p.eq_id.identifier_id);
      pt := d.fn_pm_tree;
      current_fn := d.fn_id;

      -- 2. Upgrade functions equation count
      d.fn_eq_count := d.fn_eq_count + 1;

      -- 3. Construct equation's pattern tree
      new_tree := new pm_node(pm_leaf, 0, 0);
      new_tree.eq_number := d.fn_eq_count;
      --For each E, create pm_node
      if patterns /= null then
         -- Set dummy positions as [0] for correct looping
         dummy_positions(1) := 0;
         -- Function returning pointer to deepest tree node, and full tree as parameter.
         build_pattern_tree(patterns.pat_lmodels, dummy_positions, d.fn_eq_count, d.fn_eq_total, new_tree);
      end if;

      -- 4. Merge pattern tree with function lc pattern tree
      d.fn_pm_tree := merge_pattern_trees(pt, new_tree);

      -- 5. Construct E lc tree
      eqn := d.fn_eq_count;
      elc := new lc_node(nd_apply);
      if d.fn_lc_tree = null then
         elc := e_to_lc_tree(eq_e);
      else
         elc.appl_func := d.fn_lc_tree;
         elc.appl_arg := e_to_lc_tree(eq_e);
      end if;

      -- 6. Add E lc tree to function lc tree
      d.fn_lc_tree := elc;

      -- 7. Save new pattern matching tree, equation count, and new lambda-calculus tree
      update(st, p.eq_id.identifier_id, d);
   end lc_eq_decl;


   procedure build_pattern_tree(p:  in pnode;             --Node with the pattern description
                                pos: in out pm_position;  --Increasing positon (from [0,1] to [n1, n2..., nm, 1])
                                eq: in Natural;           --Number of equation being treated
                                eq_total: in Natural;     --Total of equations of the function (needed by binding)
                                tree: in out p_pm_node)   --Parameter where binding tree will be placed
   is
      d: description;
      pt: pnode;
      e, temp_e: pnode;
      ret: p_pm_node;
      temp_pos: pm_pos_ref;
      derivations_count, position_count: integer;
      cons_num: natural;
      isConstructor: boolean;
   begin
      -- We will be analyzing models or params of a model
      if p.nt = nd_lmodels then
         if p.lmodels_lmodels /= null then
            build_pattern_tree(p.lmodels_lmodels, pos, eq, eq_total, tree);
         end if;
         e := p.lmodels_model;
      elsif p.nt = nd_el then
         if p.el_el /= null then
            build_pattern_tree(p.el_el, pos, eq, eq_total, tree);
         end if;
         e := p.el_e;
      else
         raise lc_error;
      end if;

      -- Increment actual position
      -- Old position [ p1, p2, ..., pn ] => New position [ p1+1, p2, ..., pn ]  [ p1, p2, ..., p(n-1)+1, pn ]
      pos(pos'First) := pos(pos'First) + 1;

      cons_num := natural'Last;
      pt := getType(e, isConstructor);

      if e.nt = nd_elist then
         temp_e := new node(nd_fcall);
         temp_e.fcall_id := new node(nd_ident);
         temp_e.fcall_id.identifier_id := cons_nid;
         temp_e.fcall_params := new node(nd_params);
         temp_e.fcall_params.params_el := new node(nd_params);
         temp_e.fcall_params.params_el.el_e := e.elist_list.list_e;
         e := temp_e;

      -- e1 :: e2 => cons(e1, e2)
      elsif e.nt = nd_conc then
         temp_e := new node(nd_efcall);
         temp_e.efcall := new node(nd_fcall);
         temp_e.efcall.fcall_id := new node(nd_ident);
         temp_e.efcall.fcall_id.identifier_id := cons_nid;
         temp_e.efcall.fcall_params := new node(nd_params);
         temp_e.efcall.fcall_params.params_el := new node(nd_el);
         temp_e.efcall.fcall_params.params_el.el_e := e.conc_e2;
         temp_e.efcall.fcall_params.params_el.el_el := new node(nd_el);
         temp_e.efcall.fcall_params.params_el.el_el.el_e := e.conc_e1;
         e := temp_e;
      end if;

      -- If it's a constructor, build inner node
      if isConstructor then
         position_count := pos'Length + 1;

         --Calculate pts length (number of derivations)
         d := cons(st, pt.fcall_id.identifier_id);
         Put_Line(consult(nt, pt.fcall_id.identifier_id));
         derivations_count := d.type_alts - 1;

         --Extract constructor number
         d := cons(st, e.efcall.fcall_id.identifier_id);
         cons_num := d.cons_id + 1;

         -- Declare inner node with calculated lengths
         ret := new pm_node(pm_inner, position_count, derivations_count);

         -- Fill positions
         -- Old position [ p1, p2, ..., pn ] => New position [ 1, p1, p2, ..., pn ]
         for j in pos'First..pos'Last loop
            ret.pos(j+1) := pos(j);
         end loop;
         ret.pos(pos'First) := 1;

         -- Initialize derivations
         for j in ret.derivs'Range loop
            ret.derivs(j) := null;
         end loop;

         --Iterate for constructor params
         --(For each effective parameter that is a constructor,
         --   add it recursively to the tree, and
         -- for reach effective parameter that is a variable,
         --   bind it)
         if e.efcall.fcall_params /= null and then e.efcall.fcall_params.params_el /= null then
            -- Copy positions in a new pointer
            temp_pos := new pm_position(pos'First..pos'Last + 1);
            for i in pos'Range loop temp_pos(i+1) := pos(i); end loop;
            temp_pos(pos'First) := 1;

            -- Loop through params
            build_pattern_tree(e.efcall.fcall_params.params_el, temp_pos.all, eq, eq_total, tree);
         end if;

         ret.derivs(cons_num) := tree;
         tree := ret;

         --Save position on Symbol Table for Binding
         if (e.nt = nd_efcall) then
            bind_variable(e.efcall.fcall_id.identifier_id, ret.pos, eq, eq_total);
         end if;
      else
         --Save position on Symbol Table for Binding
         if (e.nt = nd_efcall) then
            bind_variable(e.efcall.fcall_id.identifier_id, pos, eq, eq_total);
         end if;
      end if;

   end build_pattern_tree;

   procedure lc_data(p: in pnode; lc: in out lc_pnode) is
   begin
      lc := e_to_lc_tree(p);

      -- Switch all aparitions of T for the full construced definition tree
      swap_T(lc);
   end lc_data;


















   -------------------AUXILIAR FUNCTIONS-------------------

   --M(T1 & <p1, [t10, t11, ..., t1n-1]>, T2 & <p2, [t20, t21, ..., t2n-1]>)
   function merge_pattern_trees(base: in p_pm_node; new_tree: in p_pm_node) return p_pm_node is
      ret: p_pm_node;
   begin
      --If either T1 or T2 is empty then return the other
      --NOTE: This should cover leaf nodes fusion
      if base = null then
         return new_tree;
      elsif new_tree = null then
         return base;
      end if;


      --if p1 = p2 => <p1, [M(t10, t20), M(t11, t21), ..., M(t1n-1, t2n-1)]>
      if base.pos = new_tree.pos then
         ret := new pm_node(pm_inner, base.pos'Length, base.derivs'Length);
         ret.pos := base.pos;
         for i in ret.derivs'Range loop
            ret.derivs(i) := merge_pattern_trees(base.derivs(i), new_tree.derivs(i));
         end loop;

      --if p1 < p2 => <p1, [M(t10, T2), M(t11, T2), ..., M(t1n-1, T2)]>
      elsif base.pos < new_tree.pos then
         ret := new pm_node(pm_inner, base.pos'Length, base.derivs'Length);
         ret.pos := base.pos;
         for i in ret.derivs'Range loop
            ret.derivs(i) := merge_pattern_trees(base.derivs(i), new_tree);
         end loop;

      --if p1 > p2 => <p2, [M(T1, t20), M(T1, t21), ..., M(T1, t2n-1)]>
      else
         ret := new pm_node(pm_inner, new_tree.pos'Length, new_tree.derivs'Length);
         ret.pos := new_tree.pos;
         for i in new_tree.derivs'Range loop
            ret.derivs(i) := merge_pattern_trees(base, new_tree.derivs(i));
         end loop;
      end if;

      return ret;

   end merge_pattern_trees;


   function e_to_lc_tree(p: in pnode) return lc_pnode is
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
            ret := fcall_to_lc_tree(p.efcall);

         -- T[[ E1 E2 ]] = T[[ E1 ]] T[[ E2 ]]
         when nd_conc =>
            it := new node(nd_fcall);
            it.fcall_id := new node(nd_ident);
            it.fcall_id.identifier_id := cons_nid;
            it.fcall_params := new node(nd_params);
            it.fcall_params.params_el := new node(nd_el);
            it.fcall_params.params_el.el_e := p.conc_e1;
            it.fcall_params.params_el.el_el := new node(nd_el);
            it.fcall_params.params_el.el_el.el_e := p.conc_e2;
            ret := fcall_to_lc_tree(it);

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
            ret.appl_func.appl_arg := e_to_lc_tree(p.relop_e1);
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
            -- T[[ E3 ]]
            ret.appl_arg := e_to_lc_tree(p.econd.cond_els);
            ret.appl_func := new lc_node(nd_apply);
            -- T[[ E2 ]]
            ret.appl_func.appl_arg := e_to_lc_tree(p.econd.cond_e);
            ret.appl_func.appl_func := new lc_node(nd_apply);
            -- T[[ E1 ]]
            ret.appl_func.appl_func.appl_arg := e_to_lc_tree(p.econd.cond_cond);
            ret.appl_func.appl_func.appl_func := new lc_node(nd_const);
            -- COND
            ret.appl_func.appl_func.appl_func.cons_id := c_cond;



         -- T[[ (E1, E2,..., En) ]] = TUPLE-n T[[ E1 ]] T[[ E2 ]] ... T[[ En ]]
         when nd_tuple =>
            ret := new lc_node(nd_const);
            ret.cons_id := c_tuple;
            ret := tuple_to_lc_tree(p.tuple_list, ret, n);

            --Seek TUPLE-n node to set n
            ret_it := ret;
            while ret_it.nt /= nd_const loop
               ret_it := ret_it.appl_func;
            end loop;
            ret_it.cons_val := n;

         -- T[[ [E1, ..., En] ]] = TUPLE-3 1 T[[ E1 ]] ... TUPLE-3 1 T[[ En ]] 0
         -- [E1, ..., En] is a list, so we must traduce it to the constructor "cons(a, list(a))"
         when nd_elist =>

            it := p.elist_list.list_e_list;
            ret_it := new lc_node(nd_apply);

            --TUPLE-3 1
            ret := new lc_node(nd_apply);
            ret.appl_func := new lc_node(nd_const);
            ret.appl_func.cons_id := c_tuple;
            ret.appl_func.cons_val := 3;
            ret.appl_arg := new lc_node(nd_const);
            ret.appl_arg.cons_id := c_val;
            ret.appl_arg.cons_val := 1;

            -- T[[ E ]]
            ret_it := new lc_node(nd_apply);
            ret_it.appl_func := ret;
            ret_it.appl_arg := e_to_lc_tree(it.list_e);

            ret := ret_it;
            it := it.list_list;

            while it /= null loop

               ret_it := new lc_node(nd_apply);
               ret_it.appl_func := ret;

               --TUPLE-3
               ret_it.appl_arg := new lc_node(nd_const);
               ret_it.appl_arg.cons_id  := c_tuple;
               ret_it.appl_arg.cons_val := 3;

               -- 1
               ret := new lc_node(nd_apply);
               ret.appl_func := ret_it;
               ret.appl_arg := new lc_node(nd_const);
               ret.appl_arg.cons_id := c_val;
               ret.appl_arg.cons_val := 1;

               -- T[[ E ]]
               ret_it := new lc_node(nd_apply);
               ret_it.appl_func := ret;
               ret_it.appl_arg := e_to_lc_tree(it.list_e);

               ret := ret_it;
               it := it.list_list;

            end loop;

            -- Concat with "nil"
            ret_it := new lc_node(nd_apply);
            ret_it.appl_func := ret;
            ret_it.appl_arg := new lc_node(nd_apply);
            ret_it.appl_arg.appl_func := new lc_node(nd_const);
            ret_it.appl_arg.appl_func.cons_id := c_tuple;
            ret_it.appl_arg.appl_func.cons_val := 1;
            ret_it.appl_arg.appl_arg := new lc_node(nd_const);
            ret_it.appl_arg.appl_arg.cons_id := c_val;
            ret_it.appl_arg.appl_arg.cons_val := 0;

            ret := ret_it;

         when others => raise lc_error;

      end case;

      return ret;
   end e_to_lc_tree;


   function fcall_to_lc_tree(p: in pnode) return lc_pnode is
      ret: lc_pnode;
      aux_ret: lc_pnode;
      npointer: lc_pnode; --Pointer to n of the TUPLE-n node
      param: pnode;
      d: description;
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
         -- TUPLE-n T[[ E1 ]] T[[ E2 ]]
         aux_ret := new lc_node(nd_apply);
         aux_ret.appl_func := ret;
         aux_ret.appl_arg := new lc_node(nd_const);
         aux_ret.appl_arg.cons_id := c_tuple;
         ret := aux_ret;
         npointer := aux_ret.appl_arg;

         while param /= null loop
            aux_ret := new lc_node(nd_apply);
            aux_ret.appl_func := ret;
            aux_ret.appl_arg := e_to_lc_tree(param.el_e);

            ret := aux_ret;
            param := param.el_el;
            npointer.cons_val := npointer.cons_val + 1;
         end loop;


      -- T[[ c(E1, ..., En) ]] = TUPLE-(n+1) Nc T[[ E1 ]] ... T[[ En ]]
      elsif d.dt = constructor_d then

         ret := new lc_node(nd_apply);

         --TUPLE-(n+1)
         ret.appl_func := new lc_node(nd_const);
         ret.appl_func.cons_id  := c_tuple;
         npointer := ret.appl_func;
         npointer.cons_val := 1;

         --Nc
         ret.appl_arg := new lc_node(nd_const);
         ret.appl_arg.cons_id := c_val;
         ret.appl_arg.cons_val := d.cons_id;

         -- T[[ E1 ]] ... T[[ En ]]
         param := p.fcall_params;
         if param = null or else param.params_el = null then return ret; end if;
         param := param.params_el;

         while param /= null loop
            aux_ret := new lc_node(nd_apply);
            aux_ret.appl_func := ret;
            aux_ret.appl_arg := e_to_lc_tree(param.el_e);

            ret := aux_ret;
            param := param.el_el;
            npointer.cons_val := npointer.cons_val + 1;
         end loop;


      -- T[[ x ]] = POS(X)      x is var
      elsif d.dt = vartype_d then
         ret := P_translate(new lc_node'(nd_const, (0,0), c_a, 0), d.vtbinds(current_fn).element(eqn).all);

      -- T[[ x ]] = POS(X)      x is var
      else
         ret := P_translate(new lc_node'(nd_const, (0,0), c_a, 0), d.vbinds(current_fn).element(eqn).all);

         -- It is possible that this var references a function var appeared on patterh matching
         -- Check if it has params and proceed to add them
         param := p.fcall_params;
         if param = null or else param.params_el = null then return ret; end if;
         param := param.params_el;

         -- Construct params lc-tree
         -- TUPLE-n T[[ E1 ]] T[[ E2 ]]
         aux_ret := new lc_node(nd_apply);
         aux_ret.appl_func := ret;
         aux_ret.appl_arg := new lc_node(nd_const);
         aux_ret.appl_arg.cons_id := c_tuple;
         ret := aux_ret;
         npointer := aux_ret.appl_arg;

         while param /= null loop
            aux_ret := new lc_node(nd_apply);
            aux_ret.appl_func := ret;
            aux_ret.appl_arg := e_to_lc_tree(param.el_e);

            ret := aux_ret;
            param := param.el_el;
            npointer.cons_val := npointer.cons_val + 1;
         end loop;
      end if;

      return ret;
   end fcall_to_lc_tree;

   --Recursively construct the tuple lambda calculus tree
   -- p: tuple pnode, lc: applying node, i: tuple element counter
   function tuple_to_lc_tree (p: in pnode; lc: in lc_pnode; i: out integer) return lc_pnode is
      lc1, lc2: lc_pnode;
      it: pnode;
   begin
      lc1 := new lc_node(nd_apply);
      lc1.appl_func := lc;
      lc1.appl_arg := e_to_lc_tree(p.tuple_list.list_e);

      i := i + 1;

      it := p.tuple_list.list_list;
      while it /= null loop
         lc2 := new lc_node(nd_apply);
         lc2.appl_func := lc1;
         lc2.appl_arg  := e_to_lc_tree(it.list_e);
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
               ret.cons_val := 0;

            -- E( a <p, [t0, t1, ..., tn-1] > ) = CASE-n P(a, p) E(t0) E(t1) ... E(tn)
            else
               ret := new lc_node(nd_apply);
               -- CASE-n P(a, p)
               ret.appl_func := new lc_node(nd_const);
               ret.appl_func.cons_id := c_case;
               ret.appl_func.cons_val := p.derivs'Length;
               ret.appl_arg := P_translate(a, p.pos);

               for i in p.derivs'Range loop
                  auxlc := new lc_node(nd_apply);
                  auxlc.appl_func := ret;
                  if p.derivs(i) /= null then
                     auxlc.appl_arg := E(a, p.derivs(i));
                  else
                     auxlc.appl_arg := new lc_node(nd_const);
                     auxlc.appl_arg.cons_id := c_error;
                  end if;
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
      ret := new lc_node(nd_const);
      ret.cons_id := c_index;
      ret.cons_val := p(p'First);

      --Iterate for each position adding application arguments
      for i in p'First + 1..p'Last loop
         auxlc := new lc_node(nd_apply);
         auxlc.appl_func := ret;
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


   procedure bind_variable(var_id: in name_id; pos: pm_position; eq: Integer; eq_total: Integer) is
      d: description;
   begin
      d := cons(st, var_id);
      Put_Line(consult(nt, var_id));
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
            d.vbinds(current_fn).element := new equation_bind(0..eq_total);
            for i in 0..eq_total loop d.vbinds(current_fn).element(i) := new pm_position(0..-1); end loop;
         end if;

         --Register position
         d.vbinds(current_fn).element(eq) := new pm_position(pos'Range);
         for i in d.vbinds(current_fn).element(eq)'Range loop
            d.vbinds(current_fn).element(eq)(i) := pos(i);
         end loop;

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
            d.vtbinds(current_fn).element := new equation_bind(0..eq_total);
            for i in 0..eq_total loop d.vtbinds(current_fn).element(i) := new pm_position(0..1); end loop;
         end if;

         --Register position
         d.vtbinds(current_fn).element(eq) := new pm_position(pos'Range);
         for i in d.vtbinds(current_fn).element(eq)'Range loop
            d.vtbinds(current_fn).element(eq)(i) := pos(i);
         end loop;

      end if;

      -- Save new binded variable
      update(st, var_id, d);

   end bind_variable;

   procedure swap_T(p: in out lc_pnode) is
   begin
      case p.nt is
         when nd_const => if p.cons_id = c_T then p := lc_root.appl_func; end if;
         when nd_apply => swap_T(p.appl_func); swap_T(p.appl_arg);
         when nd_lambda => swap_T(p.lambda_decl);
         when nd_ident => null;
         when nd_null => raise lc_error;
      end case;
   end swap_T;


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
         when nd_relop | nd_and | nd_or | nd_not =>
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
            isConstructor := True;

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
