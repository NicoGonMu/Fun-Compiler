with decls.general_defs, Ada.Sequential_IO;--
use decls.general_defs;
package decls.d_c3a is

   type op3a is (op_null, op_push, op_table, op_copy, op_drop,
                 op_unpack, op_case, op_jump, op_call,
                 op_ret, op_apply, op_add, op_sub, op_empty);

   type c3a(op: op3a := op_null) is
      record
         case op is
            when op_push | op_table | op_copy | op_case | op_apply =>
               val: Natural;

            when op_drop =>
               n: Natural;
               m: Natural;

            when op_jump | op_call =>
               addr: Natural; --TODO: Address?

            when op_null | op_ret | op_unpack | op_add | op_sub | op_empty =>
               null;

         end case;
      end record;

   package gci_file is new Ada.Sequential_IO(c3a);

end decls.d_c3a;
