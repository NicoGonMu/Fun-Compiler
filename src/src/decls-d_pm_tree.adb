package body decls.d_pm_tree is

   function "=" (a: in pm_position; b: in pm_position) return Boolean is
   begin
      if a'Length /= b'Length then return false; end if;

      for i in a'Range loop
         if a(i) /= b(i) then return false; end if;
      end loop;

      return true;
   end "=";

   function ">" (a: in pm_position; b: in pm_position) return Boolean is
   begin
      if a'Length > b'Length then
         for i in b'Range loop
            if a(i) /= b(i) then return a(i) > b(i); end if;
         end loop;
      else
         for i in a'Range loop
            if a(i) /= b(i) then return a(i) > b(i); end if;
         end loop;
      end if;

      --Positions are equal
      return false;
   end ">";

   function "<" (a: in pm_position; b: in pm_position) return Boolean is
   begin
      if a'Length > b'Length then
         for i in b'Range loop
            if a(i) /= b(i) then return a(i) < b(i); end if;
         end loop;
      else
         for i in a'Range loop
            if a(i) /= b(i) then return a(i) < b(i); end if;
         end loop;
      end if;

      --Positions are equal
      return false;
   end "<";
end decls.d_pm_tree;
