with Ada.Containers, decls.general_defs, decls.d_tree;
use Ada.Containers, decls.general_defs, decls.d_tree;

package decls.alternatives is

   type alternatives is limited private;

   procedure empty        (alts: out alternatives);
   procedure put_type     (alts: in out alternatives; tid: in name_id);
   procedure put_alt      (alts: in out alternatives; aid: in name_id; e: boolean);
   function  consult_type (alts: in alternatives; tid: name_id) return name_id;
   function  consult_alt  (alts: in alternatives; aid: name_id) return name_id;

private
   type cell_type is (n, t, p);

   type cell (ct: cell_type := n) is
      record
         tid: name_id;
         case ct is
            when t =>
               first_alt: alt_id;
            when p =>
               id: alt_id;
            when n =>
               null;
         end case;
      end record;

   type cell_table  is array (name_id) of cell;
   type alts_table  is array (alt_id) of natural;

   type alternatives is
      record
         nid:  alt_id;     --Last stored altertnative id
         tid:  name_id;    --Current type being stored
         alts: alts_table; --Alternatives table
         ct:   cell_table; --Cells table
      end record;


end decls.alternatives;
