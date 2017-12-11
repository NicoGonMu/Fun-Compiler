package body semantic.lambda_lifting is

   function lift(e: in lc_pnode) return lc_pnode;
   function is_applicative(e: in lc_pnode) return boolean;
   procedure FV(e: in lc_pnode);


   procedure lambda_lift is
   begin
      lc_lift_root := lift(lc_root);
   end lambda_lift;




   function lift(e: in lc_pnode) return lc_pnode is
      ret: lc_pnode;
   begin
      case e.nt is

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
               FV(e);
               -- 2. Obtain alpha so that alpha v1 ... vn x = E TODO
               null;
            end if;

         -- Error
         when nd_null =>
            raise lc_error;
      end case;

      return ret;
   end lift;


   function is_applicative(e: in lc_pnode) return boolean is
   begin
      case e.nt is
         -- A(n) = true
         -- A(c) = true
         when nd_ident | nd_const =>
            return true;

         -- A(E1 E2) = A(E1) and A(E2)
         when nd_apply =>
            return is_applicative(e.appl_func) and is_applicative(e.appl_arg);

         -- A(x.E) = false
         when nd_lambda | nd_null =>
            return false;

      end case;
   end is_applicative;


   procedure FV(e: in lc_pnode) is
      d: description;
      aux_FV: p_FV_list; --Used on element addition
      found: Boolean;    --Used in lambda expresions
   begin
      case e.nt is
         -- FV(n) = {n}    if n is var
         when nd_ident  =>
            d := cons(st, e.ident_id);
            if d.dt = var_d then
               aux_FV := new FV_list(1..free_vars'Length + 1);
               --Search n
               for i in free_vars'Range loop
                  if free_vars(i) = e.ident_id then return; end if;
                  aux_FV(i) := free_vars(i);
               end loop;

               --n not found -> Add n
               aux_FV(aux_FV'Last) := e.ident_id;
               free_vars := new FV_list(aux_FV'Range);
               free_vars := aux_FV;
            end if;

         -- FV(c) = null  if c is const
         when nd_const =>
            null;

         -- FV(E1 E2) = FV(E1) U FV(E2)
         when nd_apply =>
            FV(e.appl_func);
            FV(e.appl_arg);

         -- FV(x.E) = FV(E) - {x}
         when nd_lambda =>
            FV(e.lambda_decl); -- FV(E)

            aux_FV := new FV_list(1..free_vars'Length - 1);
            found := false;
            -- For each var, if it is {x}, do not place on aux_FV
            for i in free_vars'Range loop
               --If {x} already found, add element
               if found then
                  aux_FV(i - 1) := free_vars(i);
               else
                  --If {x} not found see if it is, and if not, add element
                  if free_vars(i) = e.lambda_id.ident_id then
                     found := true;
                  else
                     aux_FV(i) := free_vars(i);
                  end if;
               end if;
            end loop;

            free_vars := new FV_list(aux_FV'Range);
            free_vars := aux_FV;
         when nd_null =>
            raise lc_lift_error;
      end case;
   end FV;
end semantic.lambda_lifting;
