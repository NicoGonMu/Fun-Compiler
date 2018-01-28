with decls.general_defs;
use decls.general_defs;

package decls.d_fv_set is

   type fv_set is array (name_id range <>) of Boolean;
   type p_fv_set is access fv_set;


   procedure init   (t: out p_fv_set; len: in name_id);
   procedure put    (t: out fv_set; elem: in name_id);
   procedure remove (t: out fv_set; elem: in name_id);
   function exists  (t: in fv_set; elem: in name_id) return Boolean;

end decls.d_fv_set;
