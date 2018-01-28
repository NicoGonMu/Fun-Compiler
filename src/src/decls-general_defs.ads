package decls.general_defs is
   -- Names table constants and types
   max_id:       constant integer := 550;
   max_str: 	 constant integer := 197;

   max_long_id:  constant integer := 89;
   max_long_str: constant integer := 97;

   type name_id is new integer range 0..max_id;
   type str_id  is new integer range 0..max_str;

   null_id:  constant name_id := 0;
   null_str: constant str_id  := 0;

   -- Symbol table constants
   max_ide: 	 constant integer := 100;
   max_prof: 	 constant integer := 100;

   -- Max number of variables
   max_var: 	 constant integer := 1000;
   -- Max number of functions
   max_func: 	 constant integer := 200;
   -- Max number of equations
   max_eq: 	 constant integer := 600;

   --Max number of generics appearing in an instance
   max_gen:      constant integer := 20;

   type position is
      record
         row:    integer;
         column: integer;
      end record;

   -- Symbol table constants and types
   type value is new integer;

   type subj_type is (sbt_bool, sbt_chr, sbt_int, sbt_tuple,
                      sbt_list, sbt_null);

   --Symbol table profundity
   subtype profundity is integer range -1..2;

   --Function identifier
   type func_id is new integer range 0..max_func;

end decls.general_defs;
