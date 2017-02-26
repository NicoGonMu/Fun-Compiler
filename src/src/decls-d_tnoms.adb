with Ada.Strings.Hash;
use Ada.Strings;

package body decls.d_names_table is

   procedure save_id(name: in string; ct: in out chr_table;
                     cn: in out natural) is
   begin
      for i in name'range loop
         cn := cn + 1; ct(cn) := name(i);
      end loop;
   end save_id;

   procedure save_str(name: in string; ct: in out chr_table;
                      cns: in out natural) is
   begin
      for i in reverse name'range loop
            scn := scn - 1; ct(scn) := name(i);
         end loop;
   end save_str;

   function equal(name: in string; tn: in names_table; p: in name_id)
                  return boolean is
      idt:    id_table  renames tn.idt;
      ct:     chr_table renames tn.ct;
      ip, fp: natural;
      i, j:   natural;
   begin
      ip := idt(p-1).ptc + 1; fp := idt(p).ptc;
      i := name'first; j := ip;
      while name(i) = ct(j) and i < name'last and j < fp loop
         i := i + 1; j := j + 1;
      end loop;
      return name(i) = ct(j) and i = name'last and j = fp;
   end equal;


   procedure empty (nt: out names_table) is
      dt:  disp_table renames nt.dt;
      idt: id_table   renames nt.idt;
      nid: name_id    renames nt.ids;
      cn:  natural    renames nt.cn;

      strt: str_table renames nt.strt;
      strs: str_id    renames nt.strs;
      scn:  natural   renames nt.scn;
   begin
      for i in hash_index loop dt(i) := null_id; end loop;
      nid := 0; cn := 0;
      dt(null_id) := (null_id, cn);

      --String table
      strs := 0; scn := max_ch + 1;
      strt(null_str) := (scn);
   end empty;

   procedure put (nt: in out names_table; name: in string; id: out name_id) is
      dt:  disp_table renames tn.dt;
      idt: id_table   renames tn.idt;
      ct:  chr_table  renames tn.ct;
      nid: name_id    renames tn.ids;
      cn:  natural    renames tn.cn;
      scn: natural    renames tn.scn;

      i: hash_type;
      p: name_id;
   begin
      i := hash(name) mod b; p := td(i);
      while p /= id_null and then not equal(name, nt, p) loop
         p := idt(p).psh;
      end loop;
      if p = null_id then
         if nid = name_id(max_id)  then raise out_of_capacity; end if;
         if cn + name'length > scn then raise out_of_capacity; end if;
         save_id(name, ct, cn);
         nid := nid + 1; idt(nid) := (td(i), cn);
         td(i) := nid; p := nid;
      end if;
      id := p;
   end put;

   procedure put (nt: in out names_table; name: in string; id: out id_str) is
      strt: taula_str renames nt.strt;
      ct:   chr_table renames nt.ct;
      strs: str_id    renames nt.strs;
      cn:   natural   renames nt.cn;
      scn:  natural   renames nt.scn;

      p: str_id;
   begin
      if strs = str_id(max_str) then raise out_of_capacity; end if;
      if cn + name'length > scn then raise out_of_capacity; end if;
      save_str(name, ct, scn);
      strs := strs + 1; strt(strs) := scn; p := strs;
      id := p;
   end put;


   function consult (nt: in names_table; id: in name_id) return string is
      idt: id_table  renames nt.idt;
      ct:  chr_table renames nt.ct;
      nid: name_id   renames nt.ids;
      ip, fp: natural;
   begin
      if id = null_id or id > nid then raise bad_use; end if;
      ip := idt(id - 1).pct + 1; fp := idt(id).pct;
      return ct(ip..fp);
   end consult;

   function consult (nt: in names_table; id: in id_str) return string is
      strt: str_table renames nt.strt;
      ct:   chr_table renames nt.ct;
      nstr: str_id    renames nt.strs;
      pi, pf: natural;
   begin
      if id = null_str or id > nstr then raise bad_use; end if;
      ip := strt(id); fp := strt(id - 1) - 1;
      return ct(ip..fp);
   end consult;


end decls.d_names_table;


