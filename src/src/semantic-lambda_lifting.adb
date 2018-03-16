package body semantic.lambda_lifting is

   procedure replace_T(lc: in out lc_pnode);
   function lift(e: in lc_pnode) return lc_pnode;
   function is_applicative(e: in lc_pnode) return boolean;
   procedure FV(e: in lc_pnode; found: in out Boolean);

   procedure lambda_lift(fname: in string) is
      n: natural;
   begin
      Create(tf, Out_File, fname&"_lifted_lc_tree.txt");
      init(fvft, Natural(fn) + alpha + 1);
      lc_lift_root := lift(lc_root);
      write_lc_tree(lc_lift_root, tf);

      ------------ DEBUG: Print function table
      Put_Line(tf, "");
      Put_Line(tf, "Functions table:");
      for i in fvft'Range loop
         Put_Line(tf, to_string(fvft, i));
         write_lc_tree(get(fvft, i, n), tf);
      end loop;
      ------------

      close(tf);
   end lambda_lift;


   procedure replace_T(lc: in out lc_pnode) is
      new_node: lc_pnode;
   begin
      -- If node is application node, left child = INDEX-n and right child = c_T, make replacement
      if lc.nt = nd_apply and then lc.appl_func.nt = nd_const and then lc.appl_func.cons_id = c_index and then
        lc.appl_arg.nt = nd_const and then lc.appl_arg.cons_id = c_T then
         new_node := new lc_node(nd_const);
         new_node.cons_id := c_alpha;
         new_node.cons_val := lc.appl_func.cons_val + 14;
         lc := new_node;

      -- Else, if node is application node but not INDEX-n c_T, traverse nodes
      else
         case lc.nt is
           when nd_apply =>
         replace_T(lc.appl_func);
         replace_T(lc.appl_arg);
      when nd_lambda =>
               replace_T(lc.lambda_decl);
            when nd_null | nd_ident | nd_const =>
               null;
           end case;
      end if;

   end replace_T;

   function lift(e: in lc_pnode) return lc_pnode is
      ret: lc_pnode;
      found: Boolean;
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
            -- lift(x.E) = lift(x.lift(E))    if E is not in applicative form
            if not is_applicative(e.lambda_decl) then
               ret := new lc_node(nd_lambda);
               ret.lambda_id := e.lambda_id;
               ret.lambda_decl := lift(e.lambda_decl);
               ret := lift(ret);

            -- lift(x.E) = alpha v1 ... vn x   if E is in applicative form with FV(x.E) = {v1 ... vn}
            else
               -- 1. Get FV(e) => FV(E) - {x}
               found := false;
               FV(e.lambda_decl, found);

               -- 2. Calculate alpha
               alpha := alpha + 1;

               -- 3. Store alhpa so that alpha v1 ... vn x = E
               replace_T(e.lambda_decl);
               if found then
                  put(fvft, alpha, 2, e.lambda_decl);
               else
                  put(fvft, alpha, 1, e.lambda_decl);
               end if;

               -- 4. Create new lc_node => alpha applied to vars applied to x
               -- Build alpha applied to (v1, v2, ..., vn)
               ret := new lc_node(nd_const);
               ret.cons_id := c_alpha;
               ret.cons_val := alpha;
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


   procedure FV(e: in lc_pnode; found: in out Boolean) is
      d: description;
   begin
      if e = null then
         return;
      end if;

      case e.nt is
         -- FV(n) = {n}    if n is var --> Should not happen
         when nd_ident =>
            null;

         -- FV(c) = null  if c is const --> If c is "a", set found to true
         when nd_const =>
            if e.cons_id = c_a then
               found := true;
            end if;

         -- FV(E1 E2) = FV(E1) U FV(E2)
         when nd_apply =>
            FV(e.appl_func, found);
            FV(e.appl_arg, found);

         -- FV(x.E) = FV(E) - {x}
         when nd_lambda =>
            FV(e.lambda_decl, found); -- FV(E)

         when nd_null =>
            raise lc_lift_error;
      end case;
   end FV;
end semantic.lambda_lifting;
