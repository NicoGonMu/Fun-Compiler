
package body decls.alternatives is

   procedure empty (alts: out alternatives) is
      ids: alt_id     renames alts.nid;
      adt: disp_table renames alts.adt;
      alt: alts_table renames alts.alts;
   begin
      ids := alt_id'First;
      adt(hash_index'First) := (n, 0);
-- TODO Chek empty closed        for i in alt_id loop alt(i) := (); end loop;

   end empty;

   procedure put_type (alts: in out alternatives; type_name: in string;
                       nid: in name_id) is
      ids: alt_id     renames alts.nid;
      adt: disp_table renames alts.adt;
      alt: alts_table renames alts.alts;

      i: hash_index;
      c: cell;
   begin
      i := hash(type_name) mod b;
      while c.ct /= n and then not equal(name, nt, p) loop
         i := hash(type_name) mod b;
      end loop;
      adt(i) := (t, nid, ids);
   end put_type;

   procedure put_alt     (alts: in out alternatives; alt_name: in string, e: boolean);

   function  consult_type (alts: in alternatives; tname: in string) return name_id;
   function  consult_alt  (alts: in alternatives; aname: in string) return name_id;

end decls.alternatives;
