with Ada.Strings.Hash;
use Ada.Strings;

package body decls.d_vtype_table is

   procedure empty (vtt: out vtype_table) is
      a:  vartype_array renames vtt.a;
      i:  index         renames vtt.p;
   begin
      for j in index loop a(j) := (null_id, null) ; end loop;
      i := 1;
   end empty;

   procedure put (vtt: in out vtype_table; alpha: in name_id; p: in pnode; e: out boolean) is
      a: vartype_array renames vtt.a;
      i: index         renames vtt.p;
   begin
      if (i = index'Last) then raise bad_use; end if;

      --Check if vartype already used
      for j in index range index'First..i loop
         if (a(j).alpha = alpha) then
            e := (a(j).p /= p);
            exit;
         end if;
      end loop;

      a(i) := (alpha, p);
      i := i + 1;
   end put;

   function consult (vtt: in vtype_table; alpha: in name_id) return pnode is
      a: vartype_array renames vtt.a;
      i: index         renames vtt.p;
   begin
      for j in index range index'First..i loop
         if (a(j).alpha = alpha) then
            return a(j).p;
         end if;
      end loop;
      return null;
   end consult;


end decls.d_vtype_table;
