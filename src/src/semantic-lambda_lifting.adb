package body semantic.lambda_lifting is

   function lift(e: in lc_pnode) return lc_pnode;
   function is_applicative(e: in lc_pnode) return boolean;
   procedure FV(e: in lc_pnode; fvset: in out fv_set);

   procedure write_lc_tree;
   procedure write_lambda(lc: in lc_pnode);
   procedure write_lc_node(lc: in lc_pnode);


   procedure lambda_lift(fname: in string) is
   begin
      Create(tf, Out_File, fname&"_lifted_lc_tree.txt");
      init(fvft, Natural(fn) + alpha);
      lc_lift_root := lift(lc_root);
      write_lc_tree;
      close(tf);
   end lambda_lift;


   procedure write_lc_tree is
   begin
      write_lc_node(lc_lift_root);
      Put_Line(tf, "");
      Put_Line(tf, "Functions table:");
      for i in fvft'Range loop
         Put_Line(tf, to_string(fvft, i));
      end loop;
   end write_lc_tree;

   procedure write_lambda(lc: in lc_pnode) is
   begin
      if lc.appl_func /= null and then lc.appl_func.nt = nd_apply then
         write_lambda(lc.appl_func);
      elsif lc.appl_func = null then
         Put(tf, "NIL ");
      else
         write_lc_node(lc.appl_func);
      end if;

      -- Write appl_arg
      if lc.appl_arg = null then
         Put(tf, "NIL ");
      else
         write_lc_node(lc.appl_arg);
      end if;

   end write_lambda;

   procedure write_lc_node(lc: in lc_pnode) is
   begin
      case lc.nt is
         when nd_apply =>
            write_lambda(lc);
         when nd_ident =>
            Put(tf, "identof(" & consult(nt, lc.ident_id) & ") ");
         when nd_lambda =>
            Put(tf, "lmbd");
            write_lc_node(lc.lambda_id);
            Put(tf, ". ");
            write_lc_node(lc.lambda_decl);
         when nd_const =>
            case lc.cons_id is
               when c_case | c_tuple | c_index | c_val =>
                  Put(tf, lc.cons_id'Img & " " & lc.cons_val'Img & " ");
               when others =>
                  Put(tf, lc.cons_id'Img & " ");
            end case;
         when nd_null =>
            Put(tf, "ND_NULL ");
      end case;
   end write_lc_node;

   function lift(e: in lc_pnode) return lc_pnode is
      ret: lc_pnode;
      aux_lcn: lc_pnode;
      free_vars: p_fv_set;
      count: Natural;
   begin
      case e.nt is
         -- Error
         when nd_null => raise lc_error;

         -- lift(x) = x    as it is in applicative form
         -- lift(c) = c    as it is in applicative form
         when nd_ident | nd_const =>
            ret := e;

         -- lift(E1 E2) = lift(E1) lift(E2)
         when nd_apply =>
            ret := new lc_node(nd_apply);
            ret.appl_func := lift(e.appl_func);
            ret.appl_arg := lift(e.appl_arg);

         -- lift(x.E)
         when nd_lambda =>
            Put_Line("New Lmbd");
            -- lift(x.E) = lift(x.lift(E))    if E is not in applicative form
            if not is_applicative(e.lambda_decl) then
               ret := new lc_node(nd_lambda);
               ret.lambda_id := e.lambda_id;
               ret.lambda_decl := lift(e.lambda_decl);
               ret := lift(ret);

            -- lift(x.E) = alpha v1 ... vn x   if E is in applicative form with FV(x.E) = {v1 ... vn}
            else
               -- 1. Get FV(e) => FV(E) - {x}
               init(free_vars, last_nid);
               FV(e.lambda_decl, free_vars.all);

               -- 2. Calculate alpha
               alpha := alpha + 1;

               -- 3. Store alhpa so that alpha v1 ... vn x = E
               count := 0;
               for i in free_vars'Range loop if free_vars(i) then count := count + 1; end if; end loop;
               put(fvft, alpha, count, e);

               -- 4. Create new lc_node => alpha applied to vars applied to x
               -- Build parameters tree
               for i in free_vars'Range loop
                  if free_vars(i) then
                     --If first parameter, build first node
                     if ret = null then
                        ret := new lc_node(nd_const);
                        ret.cons_id := c_val;
                        ret.cons_val := Integer(i);

                     -- Else, build new node and add it to tree
                     else
                        aux_lcn := new lc_node(nd_apply);
                        aux_lcn.appl_func := ret;
                        aux_lcn.appl_arg := new lc_node(nd_const);
                        aux_lcn.appl_arg.cons_id := c_val;
                        aux_lcn.appl_arg.cons_val := Integer(i);
                        ret := aux_lcn;
                     end if;
                  end if;
               end loop;

               -- Build alpha applied to (v1, v2, ..., vn)
               aux_lcn := new lc_node(nd_apply);
               aux_lcn.appl_func := new lc_node(nd_const);
               aux_lcn.appl_func.cons_id := c_val;
               aux_lcn.appl_func.cons_val := alpha;
               aux_lcn.appl_arg := ret;

               -- Apply alpha(v1, v2,..., vn) to x
               ret := new lc_node(nd_apply);
               ret.appl_func := aux_lcn;
               ret.appl_arg := e.lambda_id;
            end if;
      end case;

      return ret;
   end lift;


   function is_applicative(e: in lc_pnode) return boolean is
   begin
      if e = null then
         return true;
      end if;
      case e.nt is
         when nd_null => raise lc_lift_error;
         -- A(c) = true
         when nd_const => return true;
         -- A(n) = true
         when nd_ident => return true;
         -- A(x.E) = false
         when nd_lambda => return false;
         -- A(E1 E2) = A(E1) and A(E2)
         when nd_apply =>
            if    e.appl_func = null then return is_applicative(e.appl_arg);
            elsif e.appl_arg  = null then return is_applicative(e.appl_func);
            else return is_applicative(e.appl_func) and is_applicative(e.appl_arg); end if;
      end case;
   end is_applicative;


   procedure FV(e: in lc_pnode; fvset: in out fv_set) is
      d: description;
   begin
      if e = null then
         return;
      end if;

      case e.nt is
         -- FV(n) = {n}    if n is var
         when nd_ident  =>
            d := cons(st, e.ident_id);
            if d.dt = var_d then
               put(fvset, e.ident_id);
               Put_Line(e.ident_id'Img);
            end if;

         -- FV(c) = null  if c is const
         when nd_const =>
            null;

         -- FV(E1 E2) = FV(E1) U FV(E2)
         when nd_apply =>
            FV(e.appl_func, fvset);
            FV(e.appl_arg, fvset);

         -- FV(x.E) = FV(E) - {x}
         when nd_lambda =>
            FV(e.lambda_decl, fvset);            -- FV(E)
            remove(fvset, e.lambda_id.ident_id); -- Remove {x}

         when nd_null =>
            raise lc_lift_error;
      end case;
   end FV;
end semantic.lambda_lifting;
