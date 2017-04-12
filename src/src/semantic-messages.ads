with decls.general_defs, Text_io;
use decls.general_defs, Text_io;

package semantic.messages is

   procedure prepare_messages(name: in string);
   procedure end_messages;

   procedure em_TypeAlreadyExists      (pos: in position);
   procedure em_FunctionAsConstructor  (pos: in position);
   procedure em_CompilerError          (pos: in position);
   procedure em_IdentifierExpected     (pos: in position);
   procedure em_constructorExpected    (pos: in position);
   procedure em_alternativeAlreadyUsed (pos: in position);


   tc_error: exception;


private
   f: file_type;


end semantic.messages;
