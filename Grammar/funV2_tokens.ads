package Funv2_Tokens is

    YYLVal, YYVal : YYSType; 
    type Token is
        (End_Of_Input, Error, Colon, Assig_S,
         Derivator, Arrow, Lambda,
         Cart_Prod, S_Pattern, Conc,
         E_Pattern, O_Par, C_Par,
         O_Braq, C_Braq, Semicolon,
         Comma, Rw_Dec, Rw_Let,
         Rw_In, Rw_Where, Rw_If,
         Rw_Then, Rw_Else, Rw_Data,
         Rw_Typevar, Identifier, Chr_Lit,
         Int_Lit, Str_Lit, And_S,
         Or_S, Not_S, Relop,
         Plus, Sub, Mult,
         Div, Mod_Op );

    Syntax_Error : exception;

end Funv2_Tokens;
