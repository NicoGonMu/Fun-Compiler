package decls.general_defs is
   -- Names table constants and types
   max_id:       constant integer:= 550;
   max_str: 	 constant integer:= 197;

   max_long_id:  constant integer:= 89;
   max_long_str: constant integer:= 97;

   type name_id is new integer range 0..max_id;
   type str_id  is new integer range 0..max_str;

   null_id:  constant name_id := 0;
   null_str: constant str_id  := 0;

   -- Symbol table constants
   max_ide: 	 constant integer:=100;
   max_prof: 	 constant integer:=100;

   type position is
      record
         row:    integer;
         column: integer;
      end record;

   -- Symbol table constants and types
   type value is new integer;

   type subj_type is (sbt_bool, sbt_chr, sbt_int, sbt_tuple,
                      sbt_list, sbt_null);


   -- Alternatives table
   type alt_id is new integer range 0..max_id;


   --type tuple_type is array name_id of name_id;

   subtype profundity is integer range -1..1;

   --Function identifier
   type func_id is new natural;

   type lambda_position is array (natural) of positive;

end decls.general_defs;
