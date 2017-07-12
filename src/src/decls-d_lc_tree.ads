with decls.general_defs;
use decls.general_defs;
package decls.d_lc_tree is

   type lc_node;
   type lc_pnode is access lc_node;
   type oprel is (lt, gt, le, ge, eq, ne);
   type lc_nodeType is (nd_null, nd_lambda, nd_ident, nd_apply, nd_const);
   type lc_cons_id is (c_null, c_case, c_tuple, c_cond, c_T, c_Y, c_index, c_val);

   type lc_node (nt: lc_nodeType := nd_null) is
      record
            pos: position;
         case nt is
            when nd_null =>
               null;
            when nd_lambda =>
               lambda_id: lc_pnode;
               lambda_decl: lc_pnode;
            when nd_ident =>
               ident_id: name_id;
            when nd_apply =>
               appl_func: lc_pnode;
               appl_arg:  lc_pnode;
            when nd_const =>
               cons_id: lc_cons_id;
               cons_val: integer;

         end case;
      end record;

end decls.d_lc_tree;
