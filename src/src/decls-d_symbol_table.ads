with decls.general_defs, decls.d_description;
use decls.general_defs, decls.d_description;

package decls.d_symbol_table is
   type symbol_table is limited private;

   procedure empty(st: out symbol_table);
   procedure put(st: in out symbol_table; nid: in name_id; d: in description;
                 e: out boolean);
   procedure putSub(st: in out symbol_table; nid: in name_id; d: in description;
                    e: out boolean); --Put inf prof - 1
   procedure update(st: in out symbol_table; id: in name_id; d: in description);
   function cons(st: in symbol_table; id: in name_id) return description;

   procedure enterbloc(st: in out symbol_table);
   procedure exitbloc (st: in out symbol_table);

private

   subtype et_id is natural range 0..max_ide;

   type dt_elem is
      record
         prof: profundity;
         desc: description;
         succ: natural;
      end record;

    type et_elem is
      record
         id: name_id;
         prof: profundity;
         desc: description;
         succ: natural;
      end record;

   type disp_table is array (name_id) of dt_elem;
   type prof_table is array (profundity) of natural;
   type expn_table is array (et_id) of et_elem;

   type symbol_table is
      record
         dt: disp_table;
         et: expn_table;
         pt: prof_table;
         prof: profundity;
   end record;

end decls.d_symbol_table;
