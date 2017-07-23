with decls.general_defs, decls.d_tree, decls.d_pm_tree;
use decls.general_defs, decls.d_tree, decls.d_pm_tree;
package decls.d_description is

   type type_descr (sbt: subj_type := sbt_null) is
      record
         case sbt is
            when sbt_bool | sbt_chr | sbt_int =>
               infl, supl: value;
            when sbt_list =>
               ftype: name_id;
               b: value;
            when sbt_tuple =>
               null;
            when sbt_null =>
               null;
         end case;
      end record;

   type description_type is (null_d, type_d, vartype_d, var_d, constructor_d, func_d);

   type description (dt: description_type := null_d) is
      record
         case dt is
            when null_d =>
               null;
            when vartype_d =>
               --tpos: natural;
               null;
            when type_d =>
               type_tree: pnode;
               type_id: name_id;
            when var_d =>
               vpos:  natural;
               vtype: name_id;
            when constructor_d =>
               cons_type: name_id;
               cons_id: natural;
               cons_tree: pnode;
            when func_d =>
               fn_id: func_id;
               fn_type: pnode;
               --Tree with the function lambda calculus tree:
               fn_lc_tree: p_pm_node;
               fn_eq_count: Natural;
         end case;
      end record;
end decls.d_description;
