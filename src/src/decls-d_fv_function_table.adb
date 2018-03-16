package body decls.d_fv_function_table is

   procedure init(t: in out p_fv_function_table; len: Natural) is
   begin
      t := new fv_function_table(1..len);
      for i in t'Range loop t(i) := (0, null); end loop;
   end init;

   procedure put(t: out p_fv_function_table; alpha: in Natural; arity: in Natural; tree: in lc_pnode) is
   begin
      if t /= null then
         t(alpha) := (arity, tree);
      end if;
   end put;

   function get(t: out p_fv_function_table; alpha: in Natural; arity: out Natural) return lc_pnode is
   begin
      arity := t(alpha).arity;
      return t(alpha).e;
   end get;

   function to_string(t: out p_fv_function_table; alpha: in Natural) return String is
      elem: fv_function_node;
   begin
      elem := t(alpha);
      if elem.e = null then
         return alpha'Img & " => No tree.";
      else
         return alpha'Img & " => Arity: " & elem.arity'Img & ", E: ";
      end if;
   end to_string;

end decls.d_fv_function_table;
