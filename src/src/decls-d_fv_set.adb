package body decls.d_fv_set is

   procedure init (t: out p_fv_set; len: in name_id) is
   begin
      t := new fv_set(name_id'First..len);
      for i in t'Range loop t(i) := false; end loop;
   end init;

   procedure put (t: out fv_set; elem: in name_id) is
   begin
      t(elem) := true;
   end put;

   procedure remove (t: out fv_set; elem: in name_id) is
   begin
      t(elem) := false;
   end remove;

   function exists  (t: in fv_set; elem: in name_id) return Boolean is
   begin
      return t(elem);
   end exists;

end decls.d_fv_set;
