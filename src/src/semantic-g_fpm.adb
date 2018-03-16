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
   procedure write_index;
   procedure write_case;
   procedure write_label;
   procedure write_goto(n: in Natural);
   procedure write_drop(n: in Natural);
   procedure write_pushc(n: in Natural);
   procedure write_pushf(n: in Natural);
   procedure write_rtn;
   procedure write_pack(n: in Natural);
   procedure write_apply(n: in Natural);
   procedure write_call(n: in Natural);
   procedure write_writec;
   procedure write_writelc;
   procedure write_writei;
   procedure write_writeli;
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


   -- PROG -> D* E
   procedure generate_FPM(name: in String) is
   begin
      prepare_files(name);
      generate_functions;
      generate_main_code;
   end generate_FPM;

   procedure prepare_files(name: in String) is
   begin
      Create(tf, Out_File, name&".fpm");
      Create(sf, Out_File, name&".fpms");
   end prepare_files;

   procedure close_files is
   begin
      close(tf);
      close(sf);
   end close_files;

   -- Generate functions (+, -, *, /, mod, and, or, not, eq, ne, gt, ge, lt, le)
   -- TP[[ D1 ... Dn E ]] = TD[[ D1 ]] ... TD[[ Dn ]]
   -- D[[ (n e) ]] k = LABEL FUN_n; <compiled exp, e>; DROP n; RET;
   procedure generate_functions is
      k: natural;
   begin
      for i in 1..fvft'Last loop
         write_label;
         if i > 14 then
            trans_E(get(fvft, i, k), 0);
         else
            k := write_builtin(i);
         end if;
         write_drop(k);
         write_rtn;
      end loop;
   end generate_functions;

   procedure generate_main_code is
   begin
      write_label;
      -- Special instruction
      write_init;

      -- TE [[ E ]] 0
      trans_E(lc_lift_root, 0);

      -- Output Instruction
      if result_type.sbt = sbt_chr then
         write_writec;
      elsif result_type.sbt = sbt_int then
         write_writei;
      elsif result_type.sbt = sbt_list then
         if result_type.ftype = sbt_chr then
            write_writelc;
         else
            write_writeli;
         end if;
      end if;

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
               write_pushc(d + 1); -- PUSH a

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
               write_case;
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
      arity: Natural;
      n: Natural;
   begin
      e := get(fvft, lc.cons_val, arity); -- Check combinator

      if num_parameters >= arity then
         --F[[ (bi c) ]] d n = if n = Fc then Mc           else PUSH @Bl_c; PUSH Fc-n; PACK n+2;
         if lc.cons_val < 14 then
            n := write_builtin(lc.cons_val);

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
      write(tf, instr);
      Put_Line(sf, "INIT");
   end write_init;

   procedure write_index is
      instr: fpm(op_index);
   begin
      write(tf, instr);
      Put_Line(sf, "INDEX");
   end write_index;

   procedure write_case is
      instr: fpm(op_case);
   begin
      write(tf, instr);
      Put_Line(sf, "CASE");
   end write_case;

   procedure write_label is
      instr: fpm(op_label);
   begin
      k := k + 1;
      instr.val := k;
      write(tf, instr);
      Put_Line(sf, k'Img & ": SKIP");
   end write_label;

   procedure write_goto(n: in Natural) is
      instr: fpm(op_goto);
   begin
      instr.addr := n;
      write(tf, instr);
      Put_Line(sf, "GOTO " & n'Img);
   end write_goto;

   procedure write_drop(n: in Natural) is
      instr: fpm(op_drop);
   begin
      instr.n := n;
      write(tf, instr);
      Put_Line(sf, "DROP " & n'Img);
   end write_drop;

   procedure write_rtn is
      instr: fpm(op_rtn);
   begin
      write(tf, instr);
      Put_Line(sf, "RTN");
   end write_rtn;

   procedure write_pushc(n: in Natural) is
      instr: fpm(op_pushv);
   begin
      instr.val := n;
      write(tf, instr);
      Put_Line(sf, "PUSHC " & n'Img);
   end write_pushc;

   procedure write_pushf(n: in Natural) is
      instr: fpm(op_pushf);
   begin
      instr.val := n;
      write(tf, instr);
      Put_Line(sf, "PUSHF " & n'Img);
   end write_pushf;

   procedure write_pack(n: in Natural) is
      instr: fpm(op_pack);
   begin
      instr.n := n;
      write(tf, instr);
      Put_Line(sf, "PACK " & n'Img);
   end write_pack;

   procedure write_apply(n: in Natural) is
      instr: fpm(op_apply);
   begin
      instr.n := n;
      write(tf, instr);
      Put_Line(sf, "APPLY " & n'Img);
   end write_apply;

   procedure write_add is
      instr: fpm(op_add);
   begin
      write(tf, instr);
      Put_Line(sf, "ADD");
   end write_add;

   procedure write_sub is
      instr: fpm(op_sub);
   begin
      write(tf, instr);
      Put_Line(sf, "SUB");
   end write_sub;

   procedure write_prod is
      instr: fpm(op_prod);
   begin
      write(tf, instr);
      Put_Line(sf, "PROD");
   end write_prod;

   procedure write_div is
      instr: fpm(op_div);
   begin
      write(tf, instr);
      Put_Line(sf, "DIV");
   end write_div;

   procedure write_mod is
      instr: fpm(op_mod);
   begin
      write(tf, instr);
      Put_Line(sf, "MOD");
   end write_mod;

   procedure write_and is
      instr: fpm(op_and);
   begin
      write(tf, instr);
      Put_Line(sf, "AND");
   end write_and;

   procedure write_or is
      instr: fpm(op_or);
   begin
      write(tf, instr);
      Put_Line(sf, "OR");
   end write_or;

   procedure write_not is
      instr: fpm(op_not);
   begin
      write(tf, instr);
      Put_Line(sf, "NOT");
   end write_not;

   procedure write_eq is
      instr: fpm(op_eq);
   begin
      write(tf, instr);
      Put_Line(sf, "EQ");
   end write_eq;

   procedure write_neq is
      instr: fpm(op_neq);
   begin
      write(tf, instr);
      Put_Line(sf, "NEQ");
   end write_neq;

   procedure write_gt is
      instr: fpm(op_gt);
   begin
      write(tf, instr);
      Put_Line(sf, "GT");
   end write_gt;

   procedure write_ge is
      instr: fpm(op_ge);
   begin
      write(tf, instr);
      Put_Line(sf, "GE");
   end write_ge;

   procedure write_lt is
      instr: fpm(op_lt);
   begin
      write(tf, instr);
      Put_Line(sf, "LT");
   end write_lt;

   procedure write_le is
      instr: fpm(op_le);
   begin
      write(tf, instr);
      Put_Line(sf, "LE");
   end write_le;

   procedure write_writec is
      instr: fpm(op_write_char);
   begin
      write(tf, instr);
      Put_Line(sf, "WRITE_CHR");
   end write_writec;

   procedure write_writelc is
      instr: fpm(op_write_lchar);
   begin
      write(tf, instr);
      Put_Line(sf, "WRITE_LCHR");
   end write_writelc;

   procedure write_writei is
      instr: fpm(op_write_int);
   begin
      write(tf, instr);
      Put_Line(sf, "WRITE_INT");
   end write_writei;

   procedure write_writeli is
      instr: fpm(op_write_char);
   begin
      write(tf, instr);
      Put_Line(sf, "WRITE_LINT");
   end write_writeli;

   procedure write_error is
      instr: fpm(op_error);
   begin
      write(tf, instr);
      Put_Line(sf, "ERROR");
   end write_error;

   procedure write_call(n: in Natural) is
      instr: fpm(op_call);
   begin
      instr.addr := n;
      write(tf, instr);
      Put_Line(sf, "CALL " & n'Img);
   end write_call;

end semantic.g_FPM;
