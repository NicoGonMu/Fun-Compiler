with decls.general_defs, Ada.Sequential_IO;
use decls.general_defs;
package decls.d_c3a is

   type op3a is (copia, copia_index, consulta, suma, resta, multiplicacio,
               divisio, modul, c_signe, op_and, op_or, op_not, etiq, op_goto,
               major, major_igual, menor, menor_igual, igual, distint, pmb,
               rtn, crida, params, paramc, op_null);

   type c3a(top: op3a := op_null) is
      record
         case top is
            when etiq | op_goto =>
               --et_t0: num_etiq; TODO CHECK
               null;
            when major | major_igual | menor | menor_igual | igual | distint =>
               --rel_t0: num_etiq;
               --rel_t1: num_var;
               --rel_t2: num_var;
               --TODO CHECK
               null;
            when pmb | rtn | crida =>
               --pmb_t0: num_proc; TODO CHECK
               null;
            when op_null =>
               null;
            when others =>
               --t0: num_var;
               --t1: num_var;
               --t2: num_var;
               null; --TODO CHECK
         end case;
      end record;

   package gci_file is new Ada.Sequential_IO(c3a);

end decls.d_c3a;
