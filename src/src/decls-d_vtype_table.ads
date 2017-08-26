with decls.general_defs, decls.d_tree;
use decls.general_defs, decls.d_tree;

package decls.d_vtype_table is
   type vtype_table is limited private;
   type vartype_array is private;
   type index is private;

   procedure empty   (vtt: out vtype_table);
   procedure put     (vtt: in out vtype_table; alpha: in name_id; p: in pnode; e: out boolean);
   function  consult (vtt: in vtype_table; alpha: in name_id) return pnode;

   out_of_capacity: exception;
   bad_use: exception;

private
   type assoc is
      record
         alpha: name_id;
         p: pnode;
      end record;

   type index is new integer range 1..max_gen;
   type vartype_array is array (index) of assoc;

   type vtype_table is
      record
         a: vartype_array;
         p: index;
      end record;

end decls.d_vtype_table;
