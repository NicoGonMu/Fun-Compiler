package body semantic.type_checking is

   -- Procedure to set standard environment
   procedure set_std_env(nt: in out names_table; st: in out symbol_table);

   -- Node type-checking procedures
   procedure tc_prog (p: in pnode);
   procedure tc_defs(p: in pnode);
   procedure tc_type_decl(p: in pnode);
   procedure tc_alts(p: in pnode);-- palts: out pnode);
   procedure tc_fcall(p: in pnode; pt: in nodeType);
   procedure tc_params(p: in pnode; pt: in nodeType);
   procedure tc_el(p: in pnode; pt: in nodeType);
   procedure tc_func_decl(p: in pnode);
   procedure tc_e(p: in pnode; pt: in nodeType);
   procedure tc_data(p: in pnode);

   -- Main procedure
   procedure type_check is
   begin
      set_std_env(nt, st);
      tc_prog(root);
   end type_check;


   procedure set_std_env(nt: in out names_table; st: in out symbol_table) is
      nid: name_id;
      d: description;
      e: boolean;
   begin

--    when type_d =>
--       sbt: type_descr;
--       tid: name_id;

      put(nt, "bool", nid); d := (type_d, (sbt_bool, 0, 1), nid); put(st, nid, d, e);
      put(nt, "char", nid); d := (type_d, (sbt_chr, 0, 255), nid); put(st, nid, d, e);
      put(nt, "int", nid);  d := (type_d, (sbt_int, value'val(integer'First), value'val(integer'Last)), nid);
      put(nt, "list", nid); d := (constructor_d, nid); put(st, nid, d, e);
   end set_std_env;


   procedure tc_prog(p: in pnode) is
      data: pnode renames p.data;
      defs: pnode renames p.defs;
   begin
      tc_defs(defs);
      tc_data(data);
   end tc_prog;


   procedure tc_defs(p: in pnode) is
      decls: pnode renames p.decls;
      decl:  pnode renames p.decl;
   begin
      if decls /= null then
         tc_defs(decls);
      end if;
      case decl.nt is
         when nd_typevar => tc_typevar(decl);
         when nd_type_decl => tc_type_decl(decl.type_decl);
         when nd_func_decl => tc_func_decl(decl.func_decl);
         when nd_equation => tc_equation(decl);
         when others => null;
      end case;
   end tc_defs;


   procedure tc_type_decl(p: in pnode) is
      tid:  pnode renames p.type_id;
      alts: pnode renames p.type_alts;
      nid: name_id renames tid.identifier_id;
      d: description;
      e: boolean;
   begin
      put_type(altst, nid);
      d := (type_d, (sbt => sbt_null), nid);
      put(st, nid, d, e);
      if e then em_typeAlreadyExists(tid.pos); raise tc_error; end if;

      --Alternatives
      tc_alts(alts);
   end tc_type_decl;


   procedure tc_alts(p: in pnode) is
      alts:  pnode renames p.alts_alts;
      fcall: pnode renames p.alts_fcall;
      paux: pnode;
      d: description;
   begin
      -- Fcall treatment
      tc_fcall(fcall, nd_alts);
      --palts := new node(tc_alts);
      --palts.tc_alts_fcall := fcall;

      -- Alts treatment
      paux := null;
      if alts /= null then
         tc_alts(alts);--, paux);
      end if;
      --palts.tc_alts_alts := paux;
   end tc_alts;

   procedure tc_fcall(p: in pnode; pt: in nodeType) is
      params:   pnode renames p.fcall_params;
      fcall_id: pnode renames p.fcall_id;
      id:       name_id renames fcall_id.identifier_id;
      d:        description;
      e:        boolean;
   begin
      d := cons(st, id);
      case pt is
         -----------FROM ALTS-----------
         ----------FROM EFCALL----------
         when nd_alts | nd_efcall =>
            if d.dt = func_d then               --If func call -> Error
               em_FunctionAsConstructor(p.pos);
               raise tc_error;
            elsif d.dt = vartype_d then         --If vartype -> Check visibility
               --TODO check if visible vartype
               null;

            elsif d.dt /= type_d then           --If not type -> Error
               em_constructorExpected(p.pos);
               raise tc_error;
            end if;

         ----------FROM OTHERS----------
         when others =>
            em_CompilerError(p.pos);            --If others -> Compiler error
            raise tc_error;
      end case;

      --Treatment on efcall and alts must be the same except that
      --efcall happens when constructor as param of a constructor
      if pt = nd_alts then
      --When nd_alts, constructor must be new and saved
         put_alt(altst, id, e);
         if e then em_alternativeAlreadyUsed(p.pos); raise tc_error; end if;
         d := (constructor_d, id);
         put(st, id, d, e);

      elsif pt = nd_efcall then
      --When nd_efcall no alternative info must be saved and constructors used
      --must be already declared TODO
         null;

      end if;

      --Params are optional
      if params /= null then
         tc_params(params, pt);
      end if;

   end tc_fcall;

   procedure tc_params(p: in pnode; pt: in nodeType) is
      el: pnode renames p.params_el;
   begin
      tc_el(el, pt);
   end tc_params;

   procedure tc_el(p: in pnode; pt: in nodeType) is
      el: pnode renames p.el_el;
      e:  pnode renames p.el_e;
   begin
      if el /= null then
         tc_el(el, pt);
      end if;
      tc_e(e, pt);
   end tc_el;

   procedure tc_func_decl(p: in pnode) is
      fid:  pnode renames p.func_id;
      fin:  pnode renames p.func_in;
      fout: pnode renames p.func_out;
      d: description;
      e: error;
   begin
      fn := fn + 1;
      d := (func_d, fn);
      put(st, fid.identifier_id, d, e);
      if e then em_FunctionAlreadyDefined(p.pos); raise tc_error; end if;
   end tc_func_decl;


   procedure tc_e(p: in pnode; pt: in nodeType) is
      params:   pnode renames p.fcall_params;
      fcall_id: pnode renames p.fcall_id;
      id:       name_id renames fcall_id.identifier_id;
      d:        description;
   begin
      if p.nt = nd_fcall and pt = nd_alts then
         tc_fcall(p.efcall, nd_efcall);
      elsif p.nt = nd_fcall and pt = nd_efcall then
         tc_efcall(p.efcall);
      else
         em_IdentifierExpected(p.pos);
         raise tc_error;
      end if;
   end tc_e;


   procedure tc_data(p: in pnode) is
   begin
      null;
   end tc_data;



end semantic.type_checking;
