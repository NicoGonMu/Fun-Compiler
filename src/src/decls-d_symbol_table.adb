package body decls.d_symbol_table is

   procedure empty(st: out symbol_table) is
      dt: disp_table renames st.dt;
      pr: profundity renames st.prof;
      pt: prof_table renames st.pt;
      d: description;

   begin
      for id in name_id loop
         dt(id) := (0, d, 0);
      end loop;
      pt(0) := 0;
      pt(1) := 0;
      pt(2) := 0;
      pr := 0;
   end empty;

   procedure put(st: in out symbol_table; nid: in name_id; d: in description;
                 e: out boolean) is
      dt: disp_table renames st.dt;
      pr: profundity renames st.prof;
      pt: prof_table renames st.pt;
      et: expn_table renames st.et;
      ie: natural;
   begin
      e := false;
      if dt(nid).prof = pr then e := true; end if;
      if not e then
         ie := pt(pr); ie := ie + 1; pt(pr) := ie;
         et(ie).prof := dt(nid).prof;
         et(ie).desc := dt(nid).desc;
         et(ie).id := nid;
         dt(nid).prof := pr;
         dt(nid).desc := d;
         dt(nid).succ := 0;
      end if;
   end put;

   procedure putSub(st: in out symbol_table; nid: in name_id; d: in description;
                    e: out boolean) is
      dt: disp_table renames st.dt;
      pr: profundity renames st.prof;
      pt: prof_table renames st.pt;
      et: expn_table renames st.et;
      ie: natural;
   begin
      e := false;
      pr := pr - 1;
      if dt(nid).prof = pr then e := true; end if;
      if not e then
         ie := pt(pr); ie := ie + 1; pt(pr) := ie;
         et(ie).prof := dt(nid).prof;
         et(ie).desc := dt(nid).desc;
         et(ie).id := nid;
         dt(nid).prof := pr;
         dt(nid).desc := d;
         dt(nid).succ := 0;
      end if;
      pr := pr + 1;
   end putSub;

   function cons(st: in symbol_table; id: in name_id) return description is
      dt: disp_table renames st.dt;
   begin
      return dt(id).desc;
   end cons;

   procedure enterbloc(st: in out symbol_table) is
      ie: natural;
      pt: prof_table renames st.pt;
      pr: profundity renames st.prof;
   begin
      ie := pt(pr);
      pr := pr + 1;
      pt(pr) := ie;
   end enterbloc;

   procedure exitbloc (st: in out symbol_table) is
      dt: disp_table renames st.dt;
      pr: profundity renames st.prof;
      pt: prof_table renames st.pt;
      et: expn_table renames st.et;
      ie, il: natural;
      id: name_id;
   begin
      ie := pt(pr); pr := pr - 1; il := pt(pr);
      while ie > il loop
         if et(ie).prof /= -1 then
            id := et(ie).id;
            dt(id).prof := et(ie).prof; dt(id).desc := et(ie).desc;
            dt(id).succ := et(ie).succ;
         end if;
         ie := ie - 1;
      end loop;
   end exitbloc;

end decls.d_symbol_table;
