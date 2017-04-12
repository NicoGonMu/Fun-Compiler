package body semantic.messages is

   procedure prepare_messages(name: in string) is
   begin
      Create(f, out_file, name&".log");
   end prepare_messages;

   procedure end_messages is
   begin
      Close(f);
   end end_messages;


   procedure write_pos(pos: in position) is
   begin
      put(pos.row'Img&": "&pos.column'Img&": ");
      Put(f, pos.row'Img&": "&pos.column'Img&": ");
   end write_pos;


   procedure em_CompilerError (pos: in position) is
   begin
      write_pos(pos);
      Put_Line("Unexpected compiler error.");
      Put_Line(f, "Unexpected compiler error.");
   end em_FunctionAsConstructor;


   procedure em_TypeAlreadyExists (pos: in position) is
   begin
      write_pos(pos);
      Put_Line("Type already exists.");
      Put_Line(f, "Type already exists.");
   end em_TypeAlreadyExists;


   procedure em_FunctionAsConstructor (pos: in position) is
   begin
      write_pos(pos);
      Put_Line("Constructor expected: Regular function calls cannot be used as constructors.");
      Put_Line(f, "Constructor expected: Regular function calls cannot be used as constructors.");
   end em_FunctionAsConstructor;

   procedure em_IdentifierExpected (pos: in position) is
   begin
      write_pos(pos);
      Put_Line("Identifier expected.");
      Put_Line(f, "Identifier expected.");
   end em_IdentifierExpected;

   procedure em_constructorExpected (pos: in position) is
   begin
      write_pos(pos);
      Put_Line("Constructor or type expected.");
      Put_Line(f, "Constructor or type expected.");
   end em_constructorExpected;

   procedure em_alternativeAlreadyUsed (pos: in position) is
   begin
      write_pos(pos);
      Put_Line("Alternative already used.");
      Put_Line(f, "Alternative already used.");
   end em_alternativeAlreadyUsed;



end semantic.messages;
