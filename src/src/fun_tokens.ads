with  Decls.d_Arbre;
package Fun_Tokens is

subtype yystype is decls.d_arbre.pnode;
    YYLVal, YYVal : YYSType; 
    type Token is
        (End_Of_Input, Error, colon, assig_s,
         derivator, arrow, lambda, cart_prod,
	 pattern_s, conc, e_pattern, relop,
	 plus, mult, sub, div,
	 mod_op, o_par, c_par, o_braq,
	 c_braq, semicolon, comma, rw_dec,
         rw_let, rw_in, rw_where, rw_if,
	 rw_then, rw_else, rw_data, rw_type,
         and_s, or_s, not_s, chr_lit,
         int_lit, str_lit);

    Syntax_Error : exception;

end Psada_Tokens;
