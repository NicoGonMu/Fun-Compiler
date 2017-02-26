package decls.general_defs is
   max_id:       constant integer:= 550;
   max_str: 	 constant integer:= 197;

   max_long_id:  constant integer:= 89;
   max_long_str: constant integer:= 97;

   type name_id is new integer range 0..max_id;
   type str_id  is new integer range 0..max_str;

   null_id:  constant name_id := 0;
   null_str: constant str_id  := 0;

   type position is
      record
         row:    integer;
         column: integer;
      end record;


end decls.general_defs;
