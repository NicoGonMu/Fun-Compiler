with decls.general_defs, decls.d_description, decls.d_vtype_table, semantic.messages;
use decls.general_defs, decls.d_description, decls.d_vtype_table, semantic.messages;

package semantic.type_checking is
   procedure type_check;

   data_nid: name_id;

   --Vartype table
   vtt: vtype_table;

   vpos: integer;

   --Alternative ID counter
   alt_id: Integer;

private

     type var_table is array (name_id range <>) of pnode;

end semantic.type_checking;
