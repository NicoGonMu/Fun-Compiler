with decls.general_defs;
use decls.general_defs;
package decls.d_pm_tree is

   type pm_node;
   type p_pm_node is access pm_node;

   --Type position
   type pm_position is array (Natural range <>) of Integer;
   type pm_pos_ref is access pm_position;

   --Override "=", ">", "<"
   function "=" (a: in pm_position; b: in pm_position) return Boolean;
   function ">" (a: in pm_position; b: in pm_position) return Boolean;
   function "<" (a: in pm_position; b: in pm_position) return Boolean;


   --Type derivations
   type pm_derivations is array (Natural range <>) of p_pm_node;
   type pm_derivs_ref is access pm_derivations;

   type pm_node_type is (pm_null, pm_leaf, pm_inner);

   --Type pm_tree
   type pm_node(nt: pm_node_type; p: Natural; d: Natural) is
      record
         case nt is
            when pm_null =>
               null;
            when pm_inner =>
               pos:    pm_position(1..p);
               derivs: pm_derivations(1..d);
            when pm_leaf =>
               eq_number: Integer;
         end case;
      end record;

end decls.d_pm_tree;
