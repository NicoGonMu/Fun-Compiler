with decls.d_lc_tree;
use decls.d_lc_tree;

package decls.d_fv_function_table is

   type fv_function_node is private;
   type fv_function_table is array (Natural range <>) of fv_function_node;
   type p_fv_function_table is access fv_function_table;

   procedure init(t: in out p_fv_function_table; len: Natural);
   procedure put(t: out p_fv_function_table; alpha: in Natural; arity: in Natural; tree: in lc_pnode);
   function get(t: out p_fv_function_table; alpha: in Natural) return fv_function_node;
   function to_string(t: out p_fv_function_table; alpha: in Natural) return String;

private
   --Define data structure for storing
   type fv_function_node is
      record
         arity: Natural;
         e: lc_pnode;
      end record;

end decls.d_fv_function_table;
