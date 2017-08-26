with decls.general_defs, decls.d_description, decls.d_lc_tree, semantic.messages;
use decls.general_defs, decls.d_description, decls.d_lc_tree, semantic.messages;

package semantic.lambda_lifting is

   type FV_list is array (Integer range <>) of name_id;
   type p_FV_list is access FV_list;
   free_vars: p_FV_list;

   procedure lambda_lift;


end semantic.lambda_lifting;
