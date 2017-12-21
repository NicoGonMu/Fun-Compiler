package body semantic.messages is

   procedure prepare_messages(fname: in string) is
   begin
      Create(f, out_file, fname&".log");
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
      error := true;
   end em_CompilerError;


   procedure em_TypeAlreadyExists (pos: in position) is
   begin
      write_pos(pos);
      Put_Line("Type already exists.");
      Put_Line(f, "Type already exists.");
      error := true;
   end em_TypeAlreadyExists;


   procedure em_FunctionAsConstructor (pos: in position) is
   begin
      write_pos(pos);
      Put_Line("Constructor expected: Regular function calls cannot be used as constructors.");
      Put_Line(f, "Constructor expected: Regular function calls cannot be used as constructors.");
      error := true;
   end em_FunctionAsConstructor;

   procedure em_IdentifierExpected (pos: in position) is
   begin
      write_pos(pos);
      Put_Line("Identifier expected.");
      Put_Line(f, "Identifier expected.");
      error := true;
   end em_IdentifierExpected;

   procedure em_constructorExpected (pos: in position) is
   begin
      write_pos(pos);
      Put_Line("Constructor or type expected.");
      Put_Line(f, "Constructor or type expected.");
      error := true;
   end em_constructorExpected;

   procedure em_constructorAlreadyDefined (pos: in position) is
   begin
      write_pos(pos);
      Put_Line("Alternative already defined.");
      Put_Line(f, "Alternative already defined.");
      error := true;
   end em_constructorAlreadyDefined;

   procedure em_typeExpected (pos: in position) is
   begin
      write_pos(pos);
      Put_Line("Type expected.");
      Put_Line(f, "Type expected.");
      error := true;
   end em_typeExpected;

   procedure em_paramsExpected (pos: in position) is
   begin
      write_pos(pos);
      Put_Line("Parameters expected.");
      Put_Line(f, "Parameters expeted.");
      error := true;
   end em_paramsExpected;

   procedure em_noParamsExpected (pos: in position) is
   begin
      write_pos(pos);
      Put_Line("No parameters expected.");
      Put_Line(f, "No parameters expeted.");
      error := true;
   end em_noParamsExpected;

   procedure em_returningTypeExpected (pos: in position) is
   begin
      write_pos(pos);
      Put_Line("No parameters expected.");
      Put_Line(f, "No parameters expeted.");
      error := true;
   end em_returningTypeExpected;

   procedure em_nameAlreadyUsed (pos: in position) is
   begin
      write_pos(pos);
      Put_Line("Name already used.");
      Put_Line(f, "Name already used.");
      error := true;
   end em_nameAlreadyUsed;

   procedure em_completeFunctionTypeExpected (pos: in position) is
   begin
      write_pos(pos);
      Put_Line("Input and output parameters expected.");
      Put_Line(f, "Input and output parameters expected.");
      error := true;
   end em_completeFunctionTypeExpected;

   procedure em_typeDefinitionExpected (pos: in position) is
   begin
      write_pos(pos);
      Put_Line("Type definition expected.");
      Put_Line(f, "Type definition expected.");
      error := true;
   end em_typeDefinitionExpected;

   procedure em_undefinedName (pos: in position) is
   begin
      write_pos(pos);
      Put_Line("Name is not defined.");
      Put_Line(f, "Name is not defined.");
      error := true;
   end em_undefinedName;

   procedure em_vartypeExpected (pos: in position) is
   begin
      write_pos(pos);
      Put_Line("Generic name expected (vartype or undefined name).");
      Put_Line(f, "Generic name expected (vartype or undefined name).");
      error := true;
   end em_vartypeExpected;

   procedure em_functionNameExpected (pos: in position) is
   begin
      write_pos(pos);
      Put_Line("Function not declared.");
      Put_Line(f, "Function not declared.");
      error := true;
   end em_functionNameExpected;

   procedure em_expressionExpected (pos: in position) is
   begin
      write_pos(pos);
      Put_Line("Expression expected.");
      Put_Line(f, "Expression expected.");
      error := true;
   end em_expressionExpected;

   procedure em_expression_not_matching (pos: in position) is
   begin
      write_pos(pos);
      Put_Line("Expression is not of the type expected.");
      Put_Line(f, "Expression is not of the type expected.");
      error := true;
   end em_expression_not_matching;

   procedure em_wrongNumberOfPatterns (pos: in position) is
   begin
      write_pos(pos);
      Put_Line("Wrong number of patterns given.");
      Put_Line(f, "Wrong number of patterns given.");
      error := true;
   end em_wrongNumberOfPatterns;

   procedure em_functionCallsNotExpected (pos: in position) is
   begin
      write_pos(pos);
      Put_Line("Patterns can not contain function calls.");
      Put_Line(f, "Patterns can not contain function calls.");
      error := true;
   end em_functionCallsNotExpected;

   procedure em_arithmeticOperationNotExpected (pos: in position) is
   begin
      write_pos(pos);
      Put_Line("Arithmetic operation not expected.");
      Put_Line(f, "Arithmetic operation not expected.");
      error := true;
   end em_arithmeticOperationNotExpected;

   procedure em_typeNotExpected (pos: in position) is
   begin
      write_pos(pos);
      Put_Line("Type not expected.");
      Put_Line(f, "Type not expected.");
      error := true;
   end em_typeNotExpected;

   procedure em_typeNotInferable (pos: in position) is
   begin
      write_pos(pos);
      Put_Line("Type not inferible (different possibilities appeared).");
      Put_Line(f, "Type not inferible (different possibilities appeared).");
      error := true;
   end em_typeNotInferable;

   procedure em_incorrectType (pos: in position; name: in string) is
   begin
      write_pos(pos);
      if (name /= "") then
         Put_Line("Type not matching the definition ('" & name & "' expected).");
         Put_Line(f, "Type not matching the definition ('" & name & "' expected).");
      else
         Put_Line("Type not matching the definition.");
         Put_Line(f, "Type not matching the definition.");
      end if;
      error := true;
   end em_incorrectType;

   procedure em_noListExpected (pos: in position) is
   begin
      write_pos(pos);
      Put_Line("No list expected.");
      Put_Line(f, "No list expected");
      error := true;
   end em_noListExpected;

   procedure em_variableNotExpected (pos: in position) is
   begin
      write_pos(pos);
      Put_Line("Variable not expected.");
      Put_Line(f, "Variable not expected.");
      error := true;
   end em_variableNotExpected;

   procedure em_vartypeNotExpected (pos: in position) is
   begin
      write_pos(pos);
      Put_Line("Generic type not expected.");
      Put_Line(f, "Generic type not expected.");
      error := true;
   end em_vartypeNotExpected;

   procedure em_malformedConditional (pos: in position) is
   begin
      write_pos(pos);
      Put_Line("Conditional must have condition, 'then' statment and 'else' statement.");
      Put_Line(f, "Conditional must have condition, 'then' statment and 'else' statement.");
      error := true;
   end em_malformedConditional;

end semantic.messages;
