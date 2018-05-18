package body semantic.g_assembly is

   procedure prepare_assembly(fname: in String);
   procedure end_assembly;

   procedure generate;
   procedure generate_init;
   procedure generate_POP         (register: in string);
   procedure generate_PUSH        (register: in string);
   procedure generate_pushf       (fpm_item: in fpm);
   procedure generate_pushv       (fpm_item: in fpm);
   procedure generate_pushc       (fpm_item: in fpm);
   procedure generate_drop        (fpm_item: in fpm);
   procedure generate_goto        (fpm_item: in fpm);
   procedure generate_label       (fpm_item: in fpm);
   procedure generate_case        (fpm_item: in fpm);
   procedure generate_index;
   procedure generate_call        (fpm_item: in fpm);
   procedure generate_rtn;
   procedure generate_apply;
   procedure generate_pack        (fpm_item: in fpm);
   procedure generate_add;
   procedure generate_sub;
   procedure generate_prod;
   procedure generate_div;
   procedure generate_mod;
   procedure generate_and;
   procedure generate_or;
   procedure generate_not;
   procedure generate_gt;
   procedure generate_ge;
   procedure generate_lt;
   procedure generate_le;
   procedure generate_eq;
   procedure generate_neq;
   procedure generate_error; -- TODO


   procedure generate_assembly (fname: in String) is
   begin
      prepare_assembly(fname);
      generate;
      end_assembly;
   end generate_assembly;

   procedure prepare_assembly(fname: in String) is
   begin
      Open(bf, In_File, fname&".fpm");
      Create(sf, Out_File, fname&".s");
   end prepare_assembly;

   procedure generate is
      fpm_item: fpm;
   begin
      while not End_Of_File(bf) loop
         Read(bf, fpm_item);
         case fpm_item.op is
            when op_null =>
               null;
            when op_init =>
               generate_init;
            when op_error =>
               generate_error;
            when op_pushv =>
               generate_pushv(fpm_item);
            when op_pushf =>
               generate_pushc(fpm_item);
            when op_drop =>
               generate_drop(fpm_item);
            when op_goto =>
               generate_goto(fpm_item);
            when op_label =>
               generate_label(fpm_item);
            when op_case =>
               generate_case(fpm_item);
            when op_index =>
               generate_index;
            when op_call =>
               generate_call(fpm_item);
            when op_rtn =>
               generate_rtn;
            when op_apply =>
               generate_apply;
            when op_pack =>
               generate_pack(fpm_item);
            when op_add =>
               generate_add;
            when op_sub =>
               generate_sub;
            when op_prod =>
               generate_prod;
            when op_div =>
               generate_div;
            when op_mod =>
               generate_mod;
            when op_and =>
               generate_and;
            when op_or =>
               generate_or;
            when op_not =>
               generate_not;
            when op_gt =>
               generate_gt;
            when op_ge =>
               generate_ge;
            when op_lt =>
               generate_lt;
            when op_le =>
               generate_le;
            when op_eq =>
               generate_eq;
            when op_neq =>
               generate_neq;
            when op_write_write =>
               generate_write;
         end case;
      end loop;
   end generate;

   procedure end_assembly is
   begin
      close(bf);
      close(sf);
   end end_assembly;

   procedure generate_init is
   begin
      Put_Line(sf, ".section .bss");
      Put_Line(sf, ".comm iskt: 1000");
      Put_Line(sf, ".comm ihp: 1000");
      Put_Line(sf, ".section .data");
      Put_Line(sf, ".comm fun_t:");

      -- Add 2 variables for each defined function (@ and arity)
      for i in fvft'Range loop
         Put_Line(sf, ".long fl_" & Trim(i'Img));
         Put_Line(sf, ".long farity_" & Trim(i'Img));
      end loop;

      Put_Line(sf, ".section .text");
      Put_Line(sf, ".globl main");

      -- Prepare stack
      Put_Line(sf, "movl $istk, %esi"); -- SP := 0

      -- Prepare heap
      Put_Line(sf, "movl $ihp, %edi"); -- HP := 0
   end generate_init;

   procedure generate_POP(register: in string) is
   begin
      Put_Line(sf, "movl (%esi), %" & register);
      Put_Line(sf, "subl $4, %esi");
   end generate_POP;

   procedure generate_PUSH(register: in string) is
   begin
      Put_Line(sf, "addl $4, %esi");
      Put_Line(sf, "movl %" & register & ", (%esi)"); -- PUSH
   end generate_PUSH;

   procedure generate_error is
   begin
      null; --TODO
   end generate_error;

   procedure generate_pushf (fpm_item: in fpm) is
      nf: Natural renames fpm_item.addr;
   begin
      Put_Line(sf, "movl $fun_t, %eax");
      nf := nf * 4;
      Put_Line(sf, "movl " & Trim(nf'Img) & "(%eax), %eax");
      generate_PUSH("eax");
   end generate_pushf;

   procedure generate_pushv (fpm_item: in fpm) is
      v: Natural renames fpm_item.val;
   begin
      Put_Line(sf, "movl " & Trim(v) & "(%esi), %eax");
      Put_Line(sf, "addl $4, %esi");
      Put_Line(sf, "movl %eax, (%esi)");
   end generate_pushv;

   procedure generate_pushc (fpm_item: in fpm) is
      cons: Natural renames fpm_item.val;
   begin
      Put_Line(sf, "addl $4, %esi");
      Put_Line(sf, "movl $" & Trim(cons'Img) & ", (%esi)");
   end generate_pushc;

   procedure generate_drop (fpm_item: in fpm) is
   begin
      Put_Line(sf, "movl $" & Trim(fpm_item.n'Img) & ", %eax");
      Put_Line(sf, "imull $4, %eax");
      Put_Line(sf, "subl %eax, %esi");
   end generate_drop;

   procedure generate_goto (fpm_item: in fpm) is
      label: Natural renames fpm_item.addr;
   begin
      Put_Line(sf, "jmp e" & Trim(label'img));
   end generate_goto;

   procedure generate_label (fpm_item: in fpm) is
      label: Natural renames fpm_item.val;
   begin
      Put_Line(sf, "e_" & Trim(label'img) & " :nop");
   end generate_label;

   procedure generate_case (fpm_item: in fpm) is
      n: Natural renames fpm_item.n;
   begin
      generate_POP("eax");           -- Get case
      Put_Line(sf, "shll $2, %eax"); -- eax := eax * 2 (position of the jump label)
      lc := lc + 1;
      Put_Line(sf, "movl $l_case_" & Trim(case_label'Img) & ", &ebx");
      Put_Line(sf, "addl %ebx, %eax"); -- eax := eax + abx (jump address)
      Put_Line(sf, "jmp *(%eax)");

      -- Declare jump labels
      Put_Line(sf, "l_case_" & Trim(case_label'Img));
   end generate_case;

   procedure generate_index is
   begin
      generate_POP("eax"); -- eax := Index value
      generate_POP("ebx"); -- ebx := Pointer
      Put_Line(sf, "shll $2, %ebx");     -- eax := eax * 2 (Get element position)
      Put_Line(sf, "addl %eax, %ebx");   -- ebx := ebx + eax (Calculate position)
      Put_Line(sf, "movl (%ebx), %eax"); -- eax := (ebx)     (Address of the element)
      generate_PUSH("eax");
   end generate_index;

   procedure generate_call (fpm_item: in fpm) is
      addr: Natural renames fpm_item.addr;
   begin
      Put_Line(sf, "call " & Trim(addr'Img));
   end generate_call;

   procedure generate_rtn is
   begin
      Put_Line(sf, "ret");
   end generate_rtn;

   procedure generate_pack (fpm_item: in fpm) is
      n: Natural renames fpm_item.n;
   begin
      Put_Line(sf, "movl $" & Trim(n'Img) & ", %eax");
      Put_Line(sf, "addl $4, %edi");                     -- HP := HP + 4
      Put_Line(sf, "movl %eax, (%edi)");                 -- Top(H) := PAC
      lc := lc + 1;
      Put_Line(sf, "l_loop_" & Trim(lc'Img) & ": nop");
      Put_Line(sf, "cmpl $0, %eax");                     -- While eax > 0 loop
      Put_Line(sf, "je l_end_loop_" & Trim(lc'Img));
      generate_POP("ebx");
      Put_Line(sf, "addl $4, %edi");                     -- HP := HP + 4
      Put_Line(sf, "movl %ebx, (%edi)");                 -- Top(H) := Top(S)
      Put_Line(sf, "subl $1, %eax");                     -- eax := eax - 1
      Put_Line(sf, "jmp l_loop_" & Trim(lc'Img));
      Put_Line(sf, "l_end_loop_" & Trim(lc'Img));
      Put_Line(sf, "addl $4, %esi");                     -- SP := SP + 4
      Put_Line(sf, "addl %edi, (%esi)");                     -- Top(s) := Pointer to Packed items
   end generate_pack;

   procedure generate_apply is
   begin
      generate_POP("eax");
      Put_Line(sf, "addl $4, %eax");     -- eax := Pointer to PAC
      Put_Line(sf, "movl (%eax), %ebx"); -- ebx := PAC
      Put_Line(sf, "imull $4, %ebx");    -- ebx := PAC * 4 (Position of last element)
      Put_Line(sf, "addl %eax, %ebx");   -- ebx := Pointer to PAC + PAC * 4
      lc := lc + 1;
      -- Loop to push all the elements to the stack
      Put_Line(sf, "l_loop_" & Trim(lc'Img) & ": nop");
      Put_Line(sf, "cmpl %eax, %ebx");        -- While eax != ebx loop
      Put_Line(sf, "je l_end_loop_" & Trim(lc'Img));
      Put_Line(sf, "movl (%ebx), %ecx");      -- ecx := last remaining element
      generate_PUSH("ecx");                   -- Push element
      Put_Line(sf, "subl $4, %ebx");          -- ebx := ebx - 4 (One position bellow)
      Put_Line(sf, "jmp l_loop_" & Trim(lc'Img));
      Put_Line(sf, "l_end_loop_" & Trim(lc'Img) & ": nop");
   end generate_apply;

   procedure generate_add is
   begin
      generate_POP("eax");
      Put_Line(sf, "movl (%esi), %ebx");
      generate_PUSH("ebx");
   end generate_add;

   procedure generate_sub is
   begin
      generate_POP("eax");
      Put_Line(sf, "movl (%esi), %ebx");
      Put_Line(sf, "subl %eax, %ebx");
      generate_PUSH("ebx");
   end generate_sub;

   procedure generate_prod is
   begin
      generate_POP("eax");
      Put_Line(sf, "movl (%esi), %ebx");
      Put_Line(sf, "imull %eax, %ebx");
      generate_PUSH("ebx");
   end generate_prod;

   procedure generate_div is
   begin
      generate_POP("eax");
      Put_Line(sf, "movl %eax, %edx");
      Put_Line(sf, "sarl $31, %edx"); -- Shift number
      generate_POP("ebx");
      Put_Line(sf, "idivl %ebx");
      generate_PUSH("eax");
   end generate_div;

   procedure generate_mod is
   begin
      generate_POP("eax");
      Put_Line(sf, "movl %eax, %edx");
      Put_Line(sf, "sarl $31, %edx"); -- Shift number
      generate_POP("ebx");
      Put_Line(sf, "idivl %ebx");
      generate_PUSH("edx");
   end generate_mod;

   procedure generate_and is
   begin
      generate_POP("eax");
      generate_POP("ebx");
      Put_Line(sf, "andl %ebx, %eax");
      generate_PUSH("eax");
   end generate_and;

   procedure generate_or is
   begin
      generate_POP("eax");
      generate_POP("ebx");
      Put_Line(sf, "orl %ebx, %eax");
      generate_PUSH("eax");
   end generate_or;

   procedure generate_not is
   begin
      generate_POP("eax");
      Put_Line(sf, "negl %eax");
      generate_PUSH("eax");
   end generate_not;

   procedure generate_gt is
   begin
      lc := lc + 1;
      generate_POP("eax");
      generate_POP("ebx");
      Put_Line(sf, "addl $4, %esi");
      Put_Line(sf, "cmpl %ebx, %eax");
      Put_Line(sf, "jg l_"& Trim(lc'Img));
      Put_Line(sf, "movl $0, (%esi)");
      Put_Line(sf, "jmp end_l"& Trim(lc'Img));
      Put_Line(sf, "l_" & Trim(lc'Img) & ": nop");
      Put_Line(sf, "movl $1, (%esi)");
      Put_Line(sf, "end_l_" & Trim(lc'Img) & ": nop");
   end generate_gt;

   procedure generate_ge is
   begin
      lc := lc + 1;
      generate_POP("eax");
      generate_POP("ebx");
      Put_Line(sf, "addl $4, %esi");
      Put_Line(sf, "cmpl %ebx, %eax");
      Put_Line(sf, "jge l_"& Trim(lc'Img));
      Put_Line(sf, "movl $0, (%esi)");
      Put_Line(sf, "jmp end_l"& Trim(lc'Img));
      Put_Line(sf, "l_" & Trim(lc'Img) & ": nop");
      Put_Line(sf, "movl $1, (%esi)");
      Put_Line(sf, "end_l_" & Trim(lc'Img) & ": nop");
   end generate_ge;

   procedure generate_lt is
   begin
      lc := lc + 1;
      generate_POP("eax");
      generate_POP("ebx");
      Put_Line(sf, "addl $4, %esi");
      Put_Line(sf, "cmpl %ebx, %eax");
      Put_Line(sf, "jl l_"& Trim(lc'Img));
      Put_Line(sf, "movl $0, (%esi)");
      Put_Line(sf, "jmp end_l"& Trim(lc'Img));
      Put_Line(sf, "l_" & Trim(lc'Img) & ": nop");
      Put_Line(sf, "movl $1, (%esi)");
      Put_Line(sf, "end_l_" & Trim(lc'Img) & ": nop");
   end generate_lt;

   procedure generate_le is
   begin
      lc := lc + 1;
      generate_POP("eax");
      generate_POP("ebx");
      Put_Line(sf, "addl $4, %esi");
      Put_Line(sf, "cmpl %ebx, %eax");
      Put_Line(sf, "jle l_"& Trim(lc'Img));
      Put_Line(sf, "movl $0, (%esi)");
      Put_Line(sf, "jmp end_l"& Trim(lc'Img));
      Put_Line(sf, "l_" & Trim(lc'Img) & ": nop");
      Put_Line(sf, "movl $1, (%esi)");
      Put_Line(sf, "end_l_" & Trim(lc'Img) & ": nop");
   end generate_le;

   procedure generate_eq is
   begin
      lc := lc + 1;
      generate_POP("eax");
      generate_POP("ebx");
      Put_Line(sf, "addl $4, %esi");
      Put_Line(sf, "cmpl %ebx, %eax");
      Put_Line(sf, "je l_"& Trim(lc'Img));
      Put_Line(sf, "movl $0, (%esi)");
      Put_Line(sf, "jmp end_l"& Trim(lc'Img));
      Put_Line(sf, "l_" & Trim(lc'Img) & ": nop");
      Put_Line(sf, "movl $1, (%esi)");
      Put_Line(sf, "end_l_" & Trim(lc'Img) & ": nop");
   end generate_eq;

   procedure generate_neq is
   begin
      lc := lc + 1;
      generate_POP("eax");
      generate_POP("ebx");
      Put_Line(sf, "addl $4, %esi");
      Put_Line(sf, "cmpl %ebx, %eax");
      Put_Line(sf, "jne l_"& Trim(lc'Img));
      Put_Line(sf, "movl $0, (%esi)");
      Put_Line(sf, "jmp end_l"& Trim(lc'Img));
      Put_Line(sf, "l_" & Trim(lc'Img) & ": nop");
      Put_Line(sf, "movl $1, (%esi)");
      Put_Line(sf, "end_l_" & Trim(lc'Img) & ": nop");
   end generate_neq;

   procedure generate_write is
   begin
      null; -- TODO copy print assembly to sf
   end generate_write;

end semantic.g_assembly;
