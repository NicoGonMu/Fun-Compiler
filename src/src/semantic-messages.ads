with decls.general_defs, Text_io;
use decls.general_defs, Text_io;

package semantic.messages is

   procedure prepare_messages(fname: in string);
   procedure end_messages;

   procedure em_TypeAlreadyExists              (pos: in position);
   procedure em_FunctionAsConstructor          (pos: in position);
   procedure em_CompilerError                  (pos: in position);
   procedure em_IdentifierExpected             (pos: in position);
   procedure em_constructorExpected            (pos: in position);
   procedure em_constructorAlreadyDefined      (pos: in position);
   procedure em_typeExpected                   (pos: in position);
   procedure em_paramsExpected                 (pos: in position);
   procedure em_noParamsExpected               (pos: in position);
   procedure em_returningTypeExpected          (pos: in position);
   procedure em_nameAlreadyUsed                (pos: in position);
   procedure em_completeFunctionTypeExpected   (pos: in position);
   procedure em_typeDefinitionExpected         (pos: in position);
   procedure em_undefinedName                  (pos: in position);
   procedure em_vartypeExpected                (pos: in position);
   procedure em_functionNameExpected           (pos: in position);
   procedure em_expressionExpected             (pos: in position);
   procedure em_expression_not_matching        (pos: in position);
   procedure em_wrongNumberOfPatterns          (pos: in position);
   procedure em_functionCallsNotExpected       (pos: in position);
   procedure em_arithmeticOperationNotExpected (pos: in position);
   procedure em_typeNotExpected                (pos: in position);
   procedure em_typeNotInferable               (pos: in position);
   procedure em_incorrectType                  (pos: in position; name: in string);
   procedure em_noListExpected                 (pos: in position);
   procedure em_variableNotExpected            (pos: in position);
   procedure em_vartypeNotExpected             (pos: in position);
   procedure em_malformedConditional           (pos: in position);

   tc_error: exception;
   lc_error: exception;
   lc_lift_error: exception;
   fpm_error: exception;


   procedure write_lc_tree(lc: in lc_pnode; tf: in File_Type);


private
   f: file_type;


end semantic.messages;
