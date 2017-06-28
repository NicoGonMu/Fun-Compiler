with decls.general_defs;
use decls.general_defs;
package decls.d_tree is

   type node;
   type pnode is access node;
   type oprel is (lt, gt, le, ge, eq, ne);
   type nodeType is (nd_literal, nd_ident, nd_null, nd_oprel,
                     nd_default, nd_root, nd_typevar, nd_lid,
                     nd_type, nd_data, nd_alts, nd_fcall, nd_params,
                     nd_el, nd_func, tc_alts, nd_typedef,
                     nd_desc, nd_equation, nd_pattern, nd_lmodels,
                     nd_conc, nd_plus, nd_sub, nd_prod,
                     nd_div, nd_mod, nd_and, nd_or,
                     nd_relop, nd_not, nd_usub, nd_econd,
                     nd_elist, nd_etuple, nd_elit, nd_efcall,
                     nd_cond, nd_else, nd_tuple, nd_list_e,
                     nd_list, nd_lit, nd_decls, nd_typevar_decl,
                     nd_type_decl, nd_data_decl, nd_func_decl, nd_eq_decl, nd_tuple_type, nd_c_tuple_type);

   type node (nt: nodeType := nd_null) is
      record
            pos: position;
         case nt is
            when nd_root =>
               defs: pnode;
               data: pnode;
            when nd_ident =>
               identifier_id: name_id;
               --ide_despl: despl;
            when nd_type_decl =>
               type_decl: pnode;
            when nd_data_decl =>
               data_decl: pnode;
            when nd_typevar_decl =>
               typevar_decl: pnode;
            when nd_eq_decl =>
               eq_decl: pnode;
            when nd_func_decl =>
               func_decl: pnode;
            when nd_oprel =>
               op_type: oprel;
            when nd_literal  =>
               val: value;
               sbt: subj_type;
            when nd_lit =>
               lit_lit: pnode;
            when nd_decls =>
               decls: pnode;
               decl: pnode;
            when nd_typevar =>
               typevar_lid: pnode;
            when nd_typedef =>
               typedef_desc: pnode;
            when nd_lid =>
               lid_lid: pnode;
               lid_id: pnode;
            when nd_type =>
               type_id: pnode;
               type_alts: pnode;
               type_params: pnode;
            when nd_alts =>
               alts_alts: pnode;
               alts_fcall: pnode;
            when nd_fcall =>
               fcall_id: pnode;
               fcall_params: pnode;
            when nd_params =>
               params_el: pnode;
            when nd_el =>
               el_el: pnode;
               el_e: pnode;
            when nd_data =>
               data_id: pnode;
               data_params: pnode;
               data_alts: pnode;
            when nd_func =>
               func_id: pnode;
               func_desc: pnode;
            when nd_desc =>
               desc_in: pnode;
               desc_out: pnode;
            when nd_tuple_type =>
               tuple_type_tt: pnode;
               tuple_type_ctt: pnode;
            when nd_c_tuple_type =>
               c_tuple_type_fcall: pnode;
               c_tuple_type_in: pnode;
               c_tuple_type_out: pnode;
            when nd_equation =>
               eq_id: pnode;
               eq_pattern: pnode;
               eq_e: pnode;
            when nd_pattern =>
               pat_lmodels: pnode;
            when nd_lmodels =>
               lmodels_lmodels: pnode;
               lmodels_model: pnode;
--              when nd_model =>
--                 model_model: pnode;
--                 model_e: pnode;
            when nd_plus =>
               plus_e1: pnode;
               plus_e2: pnode;
            when nd_sub =>
               sub_e1: pnode;
               sub_e2: pnode;
            when nd_prod =>
               prod_e1: pnode;
               prod_e2: pnode;
            when nd_div =>
               div_e1: pnode;
               div_e2: pnode;
            when nd_mod =>
               mod_e1: pnode;
               mod_e2: pnode;
            when nd_and =>
               and_e1: pnode;
               and_e2: pnode;
            when nd_or =>
               or_e1: pnode;
               or_e2: pnode;
            when nd_relop =>
               relop_e1: pnode;
               relop_e2: pnode;
               relop: pnode;
            when nd_conc =>
               conc_e1: pnode;
               conc_e2: pnode;
            when nd_not =>
               not_e: pnode;
            when nd_usub =>
               usub_e: pnode;
            when nd_econd =>
               econd: pnode;
            when nd_elist =>
               elist_list: pnode;
            when nd_etuple =>
               etuple: pnode;
            when nd_elit =>
               elit: pnode;
            when nd_efcall =>
               efcall: pnode;
            when nd_cond =>
               cond_e: pnode;
               cond_els: pnode;
            when nd_else =>
               else_e: pnode;
               else_e1: pnode;
               else_e2: pnode;
            when nd_tuple =>
               tuple_list: pnode;
            when nd_list_e =>
               list_e_list: pnode;
            when nd_list =>
               list_list: pnode;
               list_e: pnode;
            when nd_default =>
               null;
            when nd_null =>
               null;
            when tc_alts =>
               tc_alts_alts: pnode;
               tc_alts_fcall: pnode;
         end case;
      end record;

end decls.d_tree;
