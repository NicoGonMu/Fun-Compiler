with Ada.Containers, decls.general_defs;
use Ada.Containers, decls.general_defs;

package decls.d_names_table is
   type names_table is limited private;

   procedure empty   (nt: out names_table);
   procedure put     (nt: in out names_table; name: in string; id: out name_id);
   function  consult (nt: in names_table; id: in name_id) return string;
   procedure put     (nt: in out names_table; name: in string; id: out str_id);
   function  consult (nt: in names_table; id: in str_id) return string;

   out_of_capacity: exception;
   bad_use: exception;

private
   max_ch: constant natural := max_id*max_long_id + max_str*max_long_str;
   b:      constant Ada.Containers.Hash_Type:= Ada.Containers.Hash_Type(max_id);
   subtype hash_index is Ada.Containers.Hash_Type range 0..b-1;

   type id_elem is
      record
         psh: name_id;
         ptc: natural;
      end record;

   subtype str_elem is natural;

   type id_table   is array (name_id) of id_elem;
   type disp_table is array (hash_index) of name_id;
   type str_table  is array (str_id) of str_elem;

   subtype chr_table is string (1..max_ch);

   type names_table is
      record
         dt:  disp_table;	--Dispersion Table
         idt: id_table;		--name_ids Table
         ids: name_id;		--Saved name_ids

         strt: str_table;	--str_id Table
         strs: str_id;		--Saved str_ids

         scn: natural;		--Saved string characters
         cn:  natural;		--Saved identifier characters
         ct:  chr_table;	--Character Table
      end record;

end decls.d_names_table;


