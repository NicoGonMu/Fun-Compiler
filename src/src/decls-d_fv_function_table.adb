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

   function get(t: out p_fv_function_table; alpha: in Natural) return fv_function_node is
   begin
      return t(alpha);
   end get;

   function to_string(t: out p_fv_function_table; alpha: in Natural) return String is
   begin
      if t(alpha).e = null then
         return alpha'Img & " => No tree.";
      else
         return alpha'Img & " => Arity: " & t(alpha).arity'Img;
      end if;
   end to_string;

end decls.d_fv_function_table;
