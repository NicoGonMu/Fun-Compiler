package body semantic.g_FPM is

   procedure prepare_files(name: in String);
   procedure close_files;

   procedure generate_definitions(lc: in lc_pnode);
   procedure generate_data(lc: in lc_pnode);

   procedure trans_E(lc: in lc_pnode);
   procedure trans_F(lc: in lc_pnode);
   procedure trans_C(lc: in lc_pnode);

   -- PROG -> D* E
   procedure generate_FPM(name: in String) is
   begin
      prepare_files(name);
      generate_definitions(lc_root.appl_func.lambda_decl.lambda_decl);
      generate_data(lc_root.appl_arg);
   end generate_FPM;



   procedure prepare_files(name: in String) is
   begin
      Create(tf, Out_File, name&".c3a");
      Create(sf, Out_File, name&".c3as");
   end prepare_files;

   procedure close_files is
   begin
      close(tf);
      close(sf);
   end close_files;


   -- D[[ (n e) ]] k = LABEL FUN_n; <compiled exp, e>; DROP 1, n; RET;
   procedure generate_definitions(lc: in lc_pnode) is
   begin
      while lc.nt /= nd_apply loop
         null;
      end loop;

   end generate_definitions;


   procedure generate_data(lc: in lc_pnode) is
   begin
      trans_E(lc);
   end generate_data;

   procedure trans_E(lc: in lc_pnode) is
      it: lc_pnode;
   begin
      --Traverse tree until not application found
      it := lc;
      while it.nt = nd_apply loop
         it := it.appl_func;
      end loop;

      --E[[ (lv n) ]] d l = PUSH % (d-ln)
      if it.nt = nd_ident then
         null; --GENERATE Push

      elsif it.nt = nd_const then
         case it.cons_id is

            --E[[ (cv k) ]] d l = C[[ k ]]
            when c_val =>
               trans_C(it);


            --E[[ (mt E1 E2 ... En) ]] d l = E[[ En ]] d l; E[[ En-1 ]] d+1 l; ...;
            --                               E[[ E1 ]] dmn-1 l;
            --                               COPY n;
            when c_tuple =>
               for i in 0..it.cons_val loop
                  null;
               end loop;

               null; --TODO


            --E[[ (if P E1 E2 ... En) ]] d l = E[[ P ]] d l; CASE n;
            --                                 <Claim n+1>     (assume b, b+1, ..., b+n allocated)
            --                                 LABEL L_b
            --                                 LABEL L_b + 1; E[[ E1 ]] d l; JUMP L_b;
            --                                 LABEL L_b + 2; E[[ E2 ]] d l; JUMP L_b; ..;
            --                                 LABEL L_b + n; E[[ En ]] d l;
            --                                 LABEL L_b;
            when c_cond =>
               null; --TODO

            when others =>
               null; --TODO if other types needed to treat
         end case;
      end if;

      --E[[ (af F E1 E2 ... En) ]] d l = E[[ En ]] d l; E[[ En-1 ]] d+1 l; ...;
      --                                 E[[ E1 ]] d + n-1 l;
      --                                 F[[ F ]] d+n l n
   end trans_E;

   procedure trans_F(lc: in lc_pnode) is
   begin
      null; --TODO

      --F[[ (fe E) ]] d l n = E[[ E ]] d l; APPLY n

      --F[[ (bi c) ]] d l n = if n = Fc then Mc           else PUSH @Bl_c; PUSH Fc-n; COPY n+2;

      --F[[ (ud k) ]] d l n = if n = Fk then CALL FUN_k   else PUSH @FUN_k; PUSH Ak-n; COPY n+2;
   end trans_F;

   procedure trans_C(lc: in lc_pnode) is
   begin
      null; --TODO

      --C[[ 'c' ]] = PUSH $c

      --C[[ n ]] = PUSH #n   --n is integer

      --(C[[ "abcd..." ]] ~= C[[ ('a' 'b' 'c' 'd' ...) ]])
      --C[[ (E1 E2 ... En) ]] = C[[ [E1' E2' ... En' ] ]]
      --                      = <lift out the constant to be complied later>;
      --                        PUSH *k  (if this is the kth constant lifted)
   end trans_C;

end semantic.g_FPM;
