with decls.general_defs, decls.d_tree, decls.d_pm_tree, decls.d_lc_tree, decls.d_pm_tree;
use decls.general_defs, decls.d_tree, decls.d_pm_tree, decls.d_lc_tree, decls.d_pm_tree;
package decls.d_description is

   type description_type is (null_d, type_d, vartype_d, var_d, constructor_d, func_d);


   -- Array of positions indexed by equation number
   type equation_bind is array(Natural range <>) of pm_pos_ref;
   type eq_bind_ref is access equation_bind;
   -- Record containing an array of positions indexed by equation number
   type binding is record element: eq_bind_ref; end record;
   type bind_ref is access binding;
   -- Array indexed by function containing records containing array of positions indexed by equation number
   type binding_list is array(func_id range <>) of bind_ref;
   type binding_list_ref is access binding_list;

   type description (dt: description_type := null_d) is
      record
         case dt is
            when null_d =>
               null;
            when vartype_d =>
               vtbinds: binding_list_ref;
            when type_d =>
               type_tree: pnode;
               type_id: name_id;
               type_alts: Natural;
               type_lc_tree: lc_pnode;
            when var_d =>
               vpos:  natural;
               vtype: name_id;
               vbinds: binding_list_ref;
            when constructor_d =>
               cons_type: name_id;
               cons_id: natural;
               cons_tree: pnode;
            when func_d =>
               fn_id: func_id;
               fn_type: pnode;
               fn_pm_tree: p_pm_node; -- Pattern Matching tree
               fn_lc_tree: lc_pnode;  -- Lambda-Calculus tree
               fn_eq_count: Natural;
               fn_eq_total: Natural;
         end case;
      end record;
end decls.d_description;
