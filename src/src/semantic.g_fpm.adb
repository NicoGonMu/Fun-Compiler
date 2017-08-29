package body semantic.g_FPM is

   procedure prepare_files(name: in String);
   procedure close_files;

   procedure generate_definitions(lc: in lc_pnode);
   procedure generate_data(lc: in lc_pnode);

   -- PROG -> D* E
   procedure generate_FPM(name: in String) is
   begin
      prepare_files(name);
      generate_definitions(lc.appl_func.lambda_decl.lambda_decl);
      generate_data(lc.appl_args);
   end generate_FPM;



   procedure prepare_files(name: in String) is
   begin
      Create(tf, Out_File, name&".c3a");
      Create(sf, Out_File, name&".c3as");
   end prepare_files;

   procedure close_files is
   begin
      close(tf);
      close(sf);
   end close_files;


   -- D    -> num E
   procedure generate_definitions(lc: in lc_pnode) is
   begin
      null; --TODO
   end generate_definitions;

   procedure generate_data(lc: in lc_pnode) is
   begin
      null; --TODO
   end generate_data;

end semantic.g_FPM;
