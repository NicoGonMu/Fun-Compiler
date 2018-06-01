with decls.general_defs, Ada.Sequential_IO;
use decls.general_defs;
package decls.d_fpm is

   type opfpm is (op_null, op_init, op_error,
                  op_pushc, op_pushv, op_pushf, op_drop,                        -- Stack operations
                  op_goto, op_label,                                            -- Jump operations
                  op_case,                                                      -- Case operation
                  op_index,                                                     -- Tuple selection operation
                  op_call, op_rtn, op_apply, op_pack,                           -- Macro operations
                  op_add, op_sub, op_prod, op_div, op_mod,                      -- Arithmetic operations
                  op_and, op_or, op_not,                                        -- Logic operations
                  op_gt, op_ge, op_lt, op_le, op_eq, op_neq,                    -- Coparison operations
                  op_write_write,                                               -- I/O operations
                  op_main);

   type fpm(op: opfpm := op_null) is
      record
         case op is
            when op_pushc | op_pushv | op_label =>
               val: Natural;
            when op_drop | op_apply | op_pack | op_case =>
               n: Natural;
            when op_goto | op_call| op_pushf =>
               addr: Natural;
            when others =>
               null;
         end case;
      end record;

   type label is
      record
         arity: Natural;
         addr: Natural;
      end record;

   type label_table is array (Natural range <>) of label;

   package gci_file is new Ada.Sequential_IO(fpm);

end decls.d_fpm;
