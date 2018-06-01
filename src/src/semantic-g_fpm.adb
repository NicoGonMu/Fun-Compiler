package body semantic.g_FPM is

   procedure prepare_files(name: in String);
   procedure close_files;

   procedure generate_functions;
   procedure generate_main_code;

   procedure trans_E(lc: in lc_pnode; d: in Natural);
   procedure trans_F(lc: in lc_pnode; num_parameters: in Natural; d: in Natural);
   procedure trans_C(lc: in lc_pnode);

   -- Function that, given a built-in function id, writes its code and returns its arity
   function write_builtin(k: in Natural) return Natural;
   procedure write_init;
   procedure write_main;
   procedure write_index;
   procedure write_case(n: in Natural);
   procedure write_label;
   procedure write_label(n: in Natural);
   procedure write_goto(n: in Natural);
   procedure write_drop(n: in Natural);
   procedure write_pushc(n: in Natural);
   procedure write_pushv(n: in Natural);
   procedure write_pushf(n: in Natural);
   procedure write_rtn;
   procedure write_pack(n: in Natural);
   procedure write_apply(n: in Natural);
   procedure write_call(n: in Natural);
   procedure write_write;
   procedure write_error;

   -- Builtin functions
   procedure write_add;
   procedure write_sub;
   procedure write_prod;
   procedure write_div;
   procedure write_mod;
   procedure write_and;
   procedure write_or;
   procedure write_not;
   procedure write_eq;
   procedure write_neq;
   procedure write_gt;
   procedure write_ge;
   procedure write_lt;
   procedure write_le;


   fpm_verbosity: Boolean;

   -- PROG -> D* E
   procedure generate_FPM(name: in String; verbosity: in boolean) is
   begin
      fpm_verbosity := verbosity;
      prepare_files(name);
      generate_functions;
      generate_main_code;
      close_files;
   end generate_FPM;

   procedure prepare_files(name: in String) is
   begin
      Create(bf, Out_File, name&".fpm");
      if fpm_verbosity then Create(sf, Out_File, name&".fpms"); end if;
   end prepare_files;

   procedure close_files is
   begin
      -- Object file must remain opened as it has to be consulted on assembly generation time
--      Reset(bf, In_File);
      close(bf);
      if fpm_verbosity then close(sf); end if;
   end close_files;

   -- Generate functions (+, -, *, /, mod, and, or, not, eq, ne, gt, ge, lt, le)
   -- TP[[ D1 ... Dn E ]] = TD[[ D1 ]] ... TD[[ Dn ]]
   -- D[[ (n e) ]] k = LABEL FUN_n; <compiled exp, e>; DROP n; RET;
   procedure generate_functions is
      n: natural;
   begin
      -- Special instruction
      write_init;

      for i in 1..builtin loop
         write_label;
         n := write_builtin(i);
         write_drop(n);
         write_rtn;
      end loop;

      -- User defined functions
      -- First, reserve function labels
      k := fvft'Last;
      -- Once reserved we can proceed to generate the functions
      for i in builtin + 1..fvft'Last loop
         write_label(i);
         trans_E(get(fvft, i, n), 0);
         write_drop(n);
         write_rtn;
      end loop;
   end generate_functions;

   procedure generate_main_code is
   begin
      write_main;

      -- TE [[ E ]] 0
      trans_E(lc_lift_root, 0);

      -- Output Instruction
      write_write;

      write_rtn;
   end generate_main_code;


   procedure trans_E(lc: in lc_pnode; d: in Natural) is
      ns: node_stack.stack; -- Stack for CASE translation
      ls: lab_stack.stack;  -- Stack for CASE labeling
      lf: Natural;          -- Label counter for CASE
      i: integer;           -- Iteration counter
      it: lc_pnode;         -- Iteration node
   begin
      --Traverse tree until not application found
      it := lc;
      while it.nt = nd_apply loop
         node_stack.push(ns, it.appl_arg);
         it := it.appl_func;
      end loop;

      if it.nt = nd_const then
         case it.cons_id is

            --E[[ (cv k) ]] d = C[[ k ]]
            when c_val =>
               trans_C(it);

            --E[[ (lv n) ]] d = PUSHV n+d-1
            when c_a =>
               write_pushv(d + 1); -- PUSH a

            --E[[ (nt E1 E2 ... En) ]] d = E[[ En ]] d; E[[ En-1 ]] d+1; ...;
            --                             E[[ E1 ]] d+n;
            --                             PACK n+1;
            when c_tuple =>
               it := lc;
               i := 0;
               while it.nt = nd_apply loop
                  trans_E(it.appl_arg, d + i);
                  it := it.appl_func;
                  i := i + 1;
               end loop;
               write_pack(i);


            --E[[ (if P E1 E2 ... En) ]] d = E[[ P ]] d; CASE n;
            --                               LABEL L_b + 1; E[[ E1 ]] d; JUMP L_b;
            --                               LABEL L_b + 2; E[[ E2 ]] d; JUMP L_b; ..;
            --                               LABEL L_b + n; E[[ En ]] d;
            --                               LABEL L_b;
            when c_case | c_cond =>
               -- E[[ P ]]
               trans_E(node_stack.top(ns), d);
               node_stack.pop(ns);
               -- CASE n
               write_case(it.cons_val);
               -- GOTOs
               lf := k + 1; -- Get LB
               for n in 1..it.cons_val loop
                  write_goto(lf);   -- GOTO LB+n
                  lf := lf + 1;
               end loop;

               -- Option translations
               while not node_stack.is_empty(ns) loop
                  write_label;          -- LB+1: SKIP
                  trans_E(node_stack.top(ns), d);  -- E[[ En ]] d
                  node_stack.pop(ns);
                  write_goto(lf);       -- GOTO @LF
               end loop;

               write_label;             -- LF: SKIP

           --E[[ (af F E1 E2 ... En) ]] d = E[[ En ]] d; E[[ En-1 ]] d+1; ...;
           --                               E[[ E1 ]] d+n-1;
           --                               F[[ F ]] n d
            when c_alpha =>
               it := lc;
               i := 0;
               while it.nt = nd_apply loop
                  trans_E(it.appl_arg, d + i);
                  it := it.appl_func;
                  i := i + 1;
               end loop;
               trans_F(it, i, d);

            when c_index =>
               write_pushc(it.cons_val);
               write_index;

            when c_error =>
               write_error;

            when c_plus => write_add; write_drop(2);
            when c_sub  => write_sub; write_drop(2);
            when c_prod => write_prod; write_drop(2);
            when c_div  => write_div; write_drop(2);
            when c_mod  => write_mod; write_drop(2);
            when c_usub => write_sub; write_drop(1);
            when c_and  => write_and; write_drop(2);
            when c_or   => write_or; write_drop(2);
            when c_not  => write_not; write_drop(1);
            when c_eq   => write_eq; write_drop(2);
            when c_neq  => write_neq; write_drop(2);
            when c_gt   => write_gt; write_drop(2);
            when c_lt   => write_lt; write_drop(2);
            when c_ge   => write_ge; write_drop(2);
            when c_le   => write_le; write_drop(2);

            when others =>
               raise fpm_error;
         end case;
      end if;


   end trans_E;

   procedure trans_F(lc: in lc_pnode; num_parameters: in Natural; d: in Natural) is
      e: lc_pnode;
      arity: Natural; -- Function arity
      n: Natural;
   begin
      e := get(fvft, lc.cons_val, arity); -- Check combinator

      if num_parameters >= arity then
         --F[[ (bi c) ]] d n = if n = Fc then Mc           else PUSH @Bl_c; PUSH Fc-n; PACK n+2;
         if lc.cons_val < 14 then
            n := write_builtin(lc.cons_val); -- addr won't be used

         --F[[ (ud k) ]] d n = if n = Fk then CALL FUN_k   else PUSH @FUN_k; PUSH Ak-n; PACK n+2;
         else
            write_call(lc.cons_val);
         end if;
      else
         write_pushf(lc.cons_val);          --@F
         write_pushc(arity-num_parameters); --PAC
         write_pack(num_parameters + 2);    --nº+2
      end if;

   end trans_F;

   procedure trans_C(lc: in lc_pnode) is
   begin
      --C[[ 'c' ]] = PUSH c
      write_pushc(lc.cons_val);
   end trans_C;



   ------------- INSTRUCTION GENERATION FUNCTIONS -------------
   function write_builtin(k: in Natural) return Natural is
   begin
      case k is
      when 1 => write_add;
      when 2 => write_sub;
      when 3 => write_prod;
      when 4 => write_div;
      when 5 => write_mod;
      when 6 => write_and;
      when 7 => write_or;
      when 8 => write_not; return 1;
      when 9 => write_eq;
      when 10 => write_neq;
      when 11 => write_gt;
      when 12 => write_ge;
      when 13 => write_lt;
      when 14 => write_le;
      when others => raise fpm_error;
      end case;
      return 2;
   end write_builtin;

   procedure write_init is
      instr: fpm(op_init);
   begin
      write(bf, instr);
      if fpm_verbosity then Put_Line(sf, "INIT"); end if;
   end write_init;

   procedure write_index is
      instr: fpm(op_index);
   begin
      write(bf, instr);
      if fpm_verbosity then Put_Line(sf, "INDEX"); end if;
   end write_index;

   procedure write_case(n: in Natural) is
      instr: fpm(op_case);
   begin
      instr.n := n;
      write(bf, instr);
      if fpm_verbosity then Put_Line(sf, "CASE-" & Trim(n'Img)); end if;
   end write_case;

   procedure write_label is
      instr: fpm(op_label);
   begin
      k := k + 1;
      instr.val := k;
      write(bf, instr);
      if fpm_verbosity then Put_Line(sf, k'Img & ": SKIP"); end if;
   end write_label;

   procedure write_main is
      instr: fpm(op_main);
   begin
      write(bf, instr);
      if fpm_verbosity then Put_Line(sf, "_MAIN: SKIP"); end if;
   end write_main;

   procedure write_label(n: in Natural) is
      instr: fpm(op_label);
   begin
      instr.val := n;
      write(bf, instr);
      if fpm_verbosity then Put_Line(sf, n'Img & ": SKIP"); end if;
   end write_label;

   procedure write_goto(n: in Natural) is
      instr: fpm(op_goto);
   begin
      instr.addr := n;
      write(bf, instr);
      if fpm_verbosity then Put_Line(sf, "GOTO " & n'Img); end if;
   end write_goto;

   procedure write_drop(n: in Natural) is
      instr: fpm(op_drop);
   begin
      instr.n := n;
      write(bf, instr);
      if fpm_verbosity then Put_Line(sf, "DROP " & n'Img); end if;
   end write_drop;

   procedure write_rtn is
      instr: fpm(op_rtn);
   begin
      write(bf, instr);
      if fpm_verbosity then Put_Line(sf, "RTN"); end if;
   end write_rtn;

   procedure write_pushc(n: in Natural) is
      instr: fpm(op_pushc);
   begin
      instr.val := n;
      write(bf, instr);
      if fpm_verbosity then Put_Line(sf, "PUSHC " & n'Img); end if;
   end write_pushc;

   procedure write_pushv(n: in Natural) is
      instr: fpm(op_pushv);
   begin
      instr.val := n;
      write(bf, instr);
      if fpm_verbosity then Put_Line(sf, "PUSHV " & n'Img); end if;
   end write_pushv;

   procedure write_pushf(n: in Natural) is
      instr: fpm(op_pushf);
   begin
      instr.addr := n;
      write(bf, instr);
      if fpm_verbosity then Put_Line(sf, "PUSHF " & n'Img); end if;
   end write_pushf;

   procedure write_pack(n: in Natural) is
      instr: fpm(op_pack);
   begin
      instr.n := n;
      write(bf, instr);
      if fpm_verbosity then Put_Line(sf, "PACK " & n'Img); end if;
   end write_pack;

   procedure write_apply(n: in Natural) is
      instr: fpm(op_apply);
   begin
      instr.n := n;
      write(bf, instr);
      if fpm_verbosity then Put_Line(sf, "APPLY " & n'Img); end if;
   end write_apply;

   procedure write_add is
      instr: fpm(op_add);
   begin
      write(bf, instr);
      if fpm_verbosity then Put_Line(sf, "ADD"); end if;
   end write_add;

   procedure write_sub is
      instr: fpm(op_sub);
   begin
      write(bf, instr);
      if fpm_verbosity then Put_Line(sf, "SUB"); end if;
   end write_sub;

   procedure write_prod is
      instr: fpm(op_prod);
   begin
      write(bf, instr);
      if fpm_verbosity then Put_Line(sf, "PROD"); end if;
   end write_prod;

   procedure write_div is
      instr: fpm(op_div);
   begin
      write(bf, instr);
      if fpm_verbosity then Put_Line(sf, "DIV"); end if;
   end write_div;

   procedure write_mod is
      instr: fpm(op_mod);
   begin
      write(bf, instr);
      if fpm_verbosity then Put_Line(sf, "MOD"); end if;
   end write_mod;

   procedure write_and is
      instr: fpm(op_and);
   begin
      write(bf, instr);
      if fpm_verbosity then Put_Line(sf, "AND"); end if;
   end write_and;

   procedure write_or is
      instr: fpm(op_or);
   begin
      write(bf, instr);
      if fpm_verbosity then Put_Line(sf, "OR"); end if;
   end write_or;

   procedure write_not is
      instr: fpm(op_not);
   begin
      write(bf, instr);
      if fpm_verbosity then Put_Line(sf, "NOT"); end if;
   end write_not;

   procedure write_eq is
      instr: fpm(op_eq);
   begin
      write(bf, instr);
      if fpm_verbosity then Put_Line(sf, "EQ"); end if;
   end write_eq;

   procedure write_neq is
      instr: fpm(op_neq);
   begin
      write(bf, instr);
      if fpm_verbosity then Put_Line(sf, "NEQ"); end if;
   end write_neq;

   procedure write_gt is
      instr: fpm(op_gt);
   begin
      write(bf, instr);
      if fpm_verbosity then Put_Line(sf, "GT"); end if;
   end write_gt;

   procedure write_ge is
      instr: fpm(op_ge);
   begin
      write(bf, instr);
      if fpm_verbosity then Put_Line(sf, "GE"); end if;
   end write_ge;

   procedure write_lt is
      instr: fpm(op_lt);
   begin
      write(bf, instr);
      if fpm_verbosity then Put_Line(sf, "LT"); end if;
   end write_lt;

   procedure write_le is
      instr: fpm(op_le);
   begin
      write(bf, instr);
      if fpm_verbosity then Put_Line(sf, "LE"); end if;
   end write_le;

   procedure write_write is
      instr: fpm(op_write_write);
   begin
      write(bf, instr);
      if fpm_verbosity then Put_Line(sf, "WRITE"); end if;
   end write_write;

   procedure write_error is
      instr: fpm(op_error);
   begin
      write(bf, instr);
      if fpm_verbosity then Put_Line(sf, "ERROR"); end if;
   end write_error;

   procedure write_call(n: in Natural) is
      instr: fpm(op_call);
   begin
      instr.addr := n;
      write(bf, instr);
      if fpm_verbosity then Put_Line(sf, "CALL " & Trim(n'Img)); end if;
   end write_call;

end semantic.g_FPM;
