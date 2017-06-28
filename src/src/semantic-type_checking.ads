with decls.general_defs, decls.d_description, decls.d_vtype_table, semantic.messages;
use decls.general_defs, decls.d_description, decls.d_vtype_table, semantic.messages;

package semantic.type_checking is
   procedure type_check;

   list_nid: name_id;
   cons_nid: name_id;
   nil_nid:  name_id;
   int_nid:  name_id;
   bool_nid: name_id;
   char_nid: name_id;
   data_nid: name_id;

   --Vartype table
   vtt: vtype_table;

   vpos: integer;

private

     type var_table is array (name_id range <>) of pnode;

end semantic.type_checking;
