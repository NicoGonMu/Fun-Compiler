with  Decls.d_Tree;
package Fun_Tokens is

subtype yystype is decls.d_tree.pnode;
    YYLVal, YYVal : YYSType; 
    type Token is
        (End_Of_Input, Error, Colon, Assig_S,
         Derivator, Arrow, Cart_Prod,
         Pattern_S, Conc, O_Par,
         C_Par, O_Braq, C_Braq,
         Semicolon, Comma, Rw_Dec,
         Rw_If, Rw_Then, Rw_Else,
         Rw_Data, Rw_Typevar, Identifier,
         Chr_Lit, Int_Lit, Str_Lit,
         And_S, Or_S, Not_S,
         Relop, Plus, Sub,
         Prod, Div, Mod_Op );

    Syntax_Error : exception;

end Fun_Tokens;
