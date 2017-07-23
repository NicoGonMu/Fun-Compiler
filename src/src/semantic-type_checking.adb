with Ada.Text_IO;
use Ada.Text_IO;

package body semantic.type_checking is

   -- Procedure to set standard environment
   procedure set_std_env(nt: in out names_table; st: in out symbol_table);
   function list_tree(a_nid: in name_id) return pnode;
   function fcall_tree(id: in name_id) return pnode;

   -- Node type-checking procedures
   procedure tc_prog (p: in pnode);
   procedure tc_defs(p: in pnode);
   procedure tc_typevar_decl(p: in pnode);
   procedure tc_type_decl(p: in pnode);
   procedure tc_data_decl(p: in pnode);
   procedure tc_eq_decl(p: in pnode);
   procedure tc_pattern (p: in pnode; d: in pnode);
   procedure tc_lmodels (p: in pnode; d: in pnode);
   procedure tc_eq_e (p: in pnode; d: in pnode);
   procedure tc_lid(p: in pnode);
   procedure tc_alts(p: in pnode);-- palts: out pnode);
   procedure tc_fcall(p: in pnode; pt: in nodeType);
   procedure tc_params(p: in pnode; pt: in nodeType);
   procedure tc_el(p: in pnode; pt: in nodeType);
   procedure tc_func_decl(p: in pnode);
   procedure tc_tuple_type(p: in pnode);
   procedure tc_c_tuple_type(p: in pnode);
   procedure tc_desc(p: in pnode);
   procedure tc_e(p: in pnode; pt: in nodeType);
   procedure tc_efcall(p: in pnode; pt: in nodeType);
   procedure tc_id(p: in pnode; nt: in nodeType; type_p: in pnode := null);


   --Coordinated tree traversal
   procedure compareTrees_lmodel (p: in pnode; desc: in pnode);
   procedure compareParams       (p: in pnode; d: in pnode; c: in pnode);
   procedure compareParams_e     (p: in pnode; d: in pnode; c: in pnode);
   procedure compare_e           (p: in pnode; d: in pnode);
   function compareTrees         (p: in pnode; d: in pnode) return boolean;

   --Function that returns the type tree of a node
   function getType(p: in pnode) return pnode;



   -- Main procedure
   procedure type_check is
   begin
      enterbloc(st);
      set_std_env(nt, st);
      tc_prog(root);
   end type_check;


   procedure set_std_env(nt: in out names_table; st: in out symbol_table) is
      a_nid: name_id;
      d: description;
      e: boolean;
   begin
      put(nt, "list", list_nid); put(nt, "a", a_nid); put(nt, "nil", nil_nid); put(nt, "cons", cons_nid);
      d := (type_d, list_tree(a_nid), 0); put(st, list_nid, d, e);
      put(nt, "bool", bool_nid); d := (type_d, null, bool_nid); put(st, bool_nid, d, e);
      put(nt, "char", char_nid); d := (type_d, null, char_nid); put(st, char_nid, d, e);
      put(nt, "int", int_nid);  d := (type_d, null, int_nid); put(st, int_nid, d, e);
   end set_std_env;

   function list_tree(a_nid: in name_id) return pnode is
      p: pnode;
      params: pnode;
      alts: pnode;
      d: description;
      e: boolean;
   begin
      -- Insert tree for data type "list":
      -- dec list(a): nil ++ cons(a, list(a))
      p := new node(nd_type);
      p.type_id := new node(nd_ident);
      p.type_id.identifier_id := list_nid;

      params := new node(nd_params);
      params.params_el := new node(nd_el);
      params.params_el.el_el := null;
      params.params_el.el_e  := new node(nd_efcall);
      params.params_el.el_e.efcall := fcall_tree(a_nid);
      p.type_params := params;

      --alts
      alts := new node(nd_alts);
      --nil
      alts.alts_alts  := new node(nd_alts);
      alts.alts_alts.alts_alts := null;
      alts.alts_alts.alts_fcall := fcall_tree(nil_nid);
      --Store "nil" in st
      d := (constructor_d, list_nid, alt_id, alts.alts_alts.alts_fcall);
      put(st, nil_nid, d, e);
      alt_id := alt_id + 1;

      --cons
      alts.alts_fcall := fcall_tree(cons_nid);
      --(a, list(a))
      params := new node(nd_params);
      params.params_el := new node(nd_el);
      --(a
      params.params_el.el_e  := new node(nd_efcall);
      params.params_el.el_e.efcall := fcall_tree(a_nid);
      --, list(a))
      params.params_el.el_el := new node(nd_el);
      params.params_el.el_el.el_el := null;
      params.params_el.el_el.el_e  := new node(nd_efcall);
      params.params_el.el_el.el_e.efcall := fcall_tree(list_nid);
      params.params_el.el_el.el_e.efcall.fcall_params := new node(nd_params);
      params.params_el.el_el.el_e.efcall.fcall_params.params_el := new node(nd_el);
      params.params_el.el_el.el_e.efcall.fcall_params.params_el.el_el := null;
      params.params_el.el_el.el_e.efcall.fcall_params.params_el.el_e := new node(nd_efcall);
      params.params_el.el_el.el_e.efcall.fcall_params.params_el.el_e.efcall := fcall_tree(a_nid);
      alts.alts_fcall.fcall_params := params;

      p.type_alts := alts;

      --Store "cons" in st
      d := (constructor_d, list_nid, alt_id, alts.alts_fcall);
      put(st, cons_nid, d, e);

      return p;
   end list_tree;

   function fcall_tree(id: in name_id) return pnode is
      p: pnode;
   begin
      p := new node(nd_fcall);
      p.fcall_params := null;
      p.fcall_id := new node(nd_ident);
      p.fcall_id.identifier_id := id;
      return p;
   end fcall_tree;


   procedure tc_prog(p: in pnode) is
      data: pnode renames p.data;
      defs: pnode renames p.defs;
   begin
      tc_defs(defs);
      Put_Line("Definitions analyzed");
      tc_eq_e(data, null);
   end tc_prog;


   procedure tc_defs(p: in pnode) is
      decls: pnode renames p.decls;
      decl:  pnode renames p.decl;
   begin
      case decl.nt is
         when nd_typevar_decl => tc_typevar_decl(decl.typevar_decl);
         when nd_type_decl => tc_type_decl(decl.type_decl);
         when nd_data_decl => tc_data_decl(decl.data_decl);
         when nd_func_decl => tc_func_decl(decl.func_decl);
         when nd_eq_decl => tc_eq_decl(decl.eq_decl);
         when others => null;
      end case;
      if decls /= null then
         tc_defs(decls);
      end if;
   end tc_defs;


   procedure tc_typevar_decl(p: in pnode) is
      lid: pnode renames p.typevar_lid;
   begin
      if lid /= null then
         tc_lid(lid);
      else
         em_IdentifierExpected(p.pos); raise tc_error;
      end if;
   end tc_typevar_decl;

   procedure tc_data_decl(p: in pnode) is
      id:     pnode renames p.data_id;
      params: pnode renames p.data_params;
      alts:   pnode renames p.data_alts;
   begin
      -- Identifier
      tc_id(id, nd_data_decl);
      data_nid := id.identifier_id;

      enterbloc(st);

      --Parameters
      if (params /= null) then
         tc_params(params, nd_data_decl);
      end if;

      --Alternatives
      alt_id := 0;
      tc_alts(alts);

      exitbloc(st);
   end tc_data_decl;

   procedure tc_eq_decl(p: in pnode) is
      id:       pnode renames p.eq_id;
      pattern:  pnode renames p.eq_pattern;
      e_pnode:  pnode renames p.eq_e;
      d: description;
   begin
      -- Check if id is from declared function
      d := cons(st, id.identifier_id);
      if d.dt /= func_d then em_functionNameExpected(p.pos); raise tc_error; end if;

      enterbloc(st);
      empty(vtt);
      vpos := 0;

      -- Check pattern matching
      if (pattern /= null) then
         tc_pattern(pattern, d.fn_type.desc_in);
      end if;

      -- Check expression
      if e_pnode = null then em_expressionExpected(p.pos); raise tc_error; end if;
      tc_eq_e(e_pnode, d.fn_type.desc_out);

      exitbloc(st);
   end tc_eq_decl;


   procedure tc_pattern (p: in pnode; d: in pnode) is
      lmodels: pnode renames p.pat_lmodels;
   begin
      tc_lmodels(lmodels, d);
   end tc_pattern;

   procedure tc_lmodels (p: in pnode; d: in pnode) is
      tt, lmodel: pnode;
   begin
      --Prepare traversal variables
      tt := d; lmodel := p;

      --Comparing loop
      while (lmodel /= null and tt /= null) loop
         compareTrees_lmodel(lmodel.lmodels_model, tt.tuple_type_ctt);
         lmodel := lmodel.lmodels_lmodels;
         tt := tt.tuple_type_tt;
      end loop;

      if (lmodel /= null or tt /= null) then
         em_wrongNumberOfPatterns(p.pos); raise tc_error;
      end if;

   end tc_lmodels;

   procedure tc_eq_e (p: in pnode; d: in pnode) is
      tid: pnode;
      desc: description;
      e: boolean;
   begin
      if d = null then
         return; --TODO tc data
      end if;

      tid := getType(p);
      Put_Line(tid.nt'Img);
      case tid.nt is
         when nd_tuple_type =>
            e := compareTrees(tid, d); -- Compare TTs
            if e then
               em_incorrectType(p.pos, "");
               raise tc_error;
            end if;

         when nd_c_tuple_type =>
            null;--if tid.
         when nd_fcall =>
            -- Compare TT with fcall (function, constructor, list)
            if tid.fcall_id = null then
               null; -- Function call
            elsif tid.fcall_id.identifier_id = list_nid then --List
               --Check if d is a list
               if (d.tuple_type_tt /= null or else d.tuple_type_ctt.c_tuple_type_fcall = null
                   or else d.tuple_type_ctt.c_tuple_type_fcall.fcall_id.identifier_id /= list_nid) then
                  em_incorrectType(p.pos, "");
                  raise tc_error;
               end if;

               -- Check list type
               if p.nt = nd_conc then
                  compare_e(getType(p.conc_e1), d.tuple_type_ctt.c_tuple_type_fcall.fcall_params);
                  compare_e(getType(p.conc_e2), d.tuple_type_ctt.c_tuple_type_fcall.fcall_params);
               elsif p.efcall.fcall_id.identifier_id = cons_nid then
                  --First cons element
                  if (p.efcall.fcall_params = null or else p.efcall.fcall_params.params_el.el_e = null) then
                     em_paramsExpected(p.pos);
                     raise tc_error;
                  end if;
                  Put_Line(consult(nt, p.efcall.fcall_params.params_el.el_e.efcall.fcall_id.identifier_id));
                  compare_e(getType(p.efcall.fcall_params.params_el.el_e), d.tuple_type_ctt.c_tuple_type_fcall.fcall_params);

                  --Last cons element
                  if (p.efcall.fcall_params.params_el.el_el = null or else p.efcall.fcall_params.params_el.el_el.el_e = null) then
                     em_paramsExpected(p.pos);
                     raise tc_error;
                  end if;
                  compare_e(getType(p.efcall.fcall_params.params_el.el_el.el_e), d.tuple_type_ctt.c_tuple_type_fcall.fcall_params);

               elsif p.efcall.fcall_id.identifier_id /= nil_nid then
                  compare_e(tid.fcall_params, d.tuple_type_ctt.c_tuple_type_fcall.fcall_params);
               end if;

            else
               -- Constructor
               return;
               --Check if constructor belongs to expected type
               if (tid.fcall_id.identifier_id /= d.tuple_type_ctt.c_tuple_type_fcall.fcall_id.identifier_id) then
                  em_incorrectType(p.pos, consult(nt, d.tuple_type_ctt.c_tuple_type_fcall.fcall_id.identifier_id));
               end if;

               --Check constructor params
               compareParams_e(p.efcall.fcall_params, d.tuple_type_ctt.c_tuple_type_fcall, tid.fcall_params);
            end if;

         when nd_ident =>
            if (d.tuple_type_tt /= null or d.tuple_type_ctt.c_tuple_type_fcall = null) then
               em_incorrectType(p.pos, "");
               raise tc_error;
            end if;
            if (d.tuple_type_ctt.c_tuple_type_fcall.fcall_id.identifier_id /= tid.identifier_id) then
               em_incorrectType(p.pos, consult(nt, d.tuple_type_ctt.c_tuple_type_fcall.identifier_id));
               raise tc_error;
            end if;

         when nd_type =>
            em_typeNotExpected(p.pos); raise tc_error;

         when nd_typevar =>
            desc := cons(st, p.efcall.fcall_id.identifier_id);
            if (desc.dt = vartype_d) then
               em_vartypeNotExpected(p.pos); raise tc_error;
            else
               if (d.tuple_type_tt /= null or d.tuple_type_ctt.c_tuple_type_fcall = null) then
                  em_incorrectType(p.pos, "");
                  raise tc_error;
               end if;
               if (d.tuple_type_ctt.c_tuple_type_fcall.fcall_id.identifier_id /= desc.vtype) then
                  em_incorrectType(p.pos, consult(nt, d.tuple_type_ctt.c_tuple_type_fcall.identifier_id));
                  raise tc_error;
               end if;
            end if;

         when nd_null =>
            em_undefinedName(p.pos); raise tc_error;

         when others =>
            em_CompilerError(p.pos); raise tc_error;
      end case;

      --TODO check params if exist
   end tc_eq_e;

   procedure tc_lid(p: in pnode) is
      id:  pnode renames p.lid_id;
      lid: pnode renames p.lid_lid;
   begin
      tc_id(id, nd_lid);
      if lid /= null then
         tc_lid(lid);
      end if;
   end tc_lid;


   procedure tc_type_decl(p: in pnode) is
      tid:    pnode renames p.type_id;
      params: pnode renames p.type_params;
      alts:   pnode renames p.type_alts;
      nid: name_id renames tid.identifier_id;
      d: description;
      e: boolean;
   begin
      d := (type_d, p, nid);
      put(st, nid, d, e);
      if e then em_typeAlreadyExists(tid.pos); raise tc_error; end if;

      --Params
      if (params /= null) then
         tc_params(params, nd_type_decl);
      end if;

      -- Type definition
      tc_tuple_type(alts);
   end tc_type_decl;

   procedure tc_tuple_type(p: in pnode) is
      tt:  pnode renames p.tuple_type_tt;
      ctt: pnode renames p.tuple_type_ctt;
   begin
      tc_c_tuple_type(ctt);
      if tt /= null then
         tc_tuple_type(tt);
      end if;
   end tc_tuple_type;

   procedure tc_c_tuple_type(p: in pnode) is
      fcall:  pnode renames p.c_tuple_type_fcall;
      cttin:  pnode renames p.c_tuple_type_in;
      cttout: pnode renames p.c_tuple_type_out;
   begin
      if fcall /= null then
         tc_fcall(fcall, nd_c_tuple_type);
      elsif cttin /= null and cttout /= null then
         tc_tuple_type(cttin);
         tc_tuple_type(cttout);
      elsif cttin /= null or cttout /= null then
         em_completeFunctionTypeExpected(p.pos); raise tc_error;
      else
         em_typeDefinitionExpected(p.pos); raise tc_error;
      end if;
   end tc_c_tuple_type;


   procedure tc_alts(p: in pnode) is
      fcall: pnode renames p.alts_fcall;
      alts:  pnode renames p.alts_alts;
      d: description;
   begin
      -- Fcall treatment
      tc_fcall(fcall, nd_alts);

      -- Alts treatment
      if alts /= null then
         tc_alts(alts);
      end if;
   end tc_alts;

   procedure tc_fcall(p: in pnode; pt: in nodeType) is
      params:   pnode   renames p.fcall_params;
      fcall_id: pnode   renames p.fcall_id;
      id:       name_id renames fcall_id.identifier_id;
      d:        description;
      e:        boolean;
   begin
      d := cons(st, id);
      case pt is
         -----------FROM ALTS-----------
         when nd_alts =>
            case d.dt is
               when constructor_d =>
                  em_constructorAlreadyDefined(p.pos); raise tc_error;
               when type_d =>
                  null; --Accepted
               when func_d =>
                  em_FunctionAsConstructor(p.pos); raise tc_error;
               when null_d =>
                  d := (constructor_d, data_nid, alt_id, p);
                  putSub(st, id, d, e);
                  Put_Line("Put alt " & alt_id'Img & " of type " & consult(nt, data_nid) & ": " & consult(nt, id));
                  alt_id := alt_id + 1;
               when others =>
                  em_constructorExpected(p.pos); raise tc_error;
            end case;

            --In this case params belong to an alternative
            if params /= null then
               tc_params(params, nd_params);
            end if;


            ----------FROM PARAMS----------
         when nd_params =>
            if d.dt = null_d then
               em_undefinedName(p.pos); raise tc_error;
            elsif d.dt /= type_d and d.dt /= vartype_d then
               em_typeExpected(p.pos); raise tc_error;
            end if;

            if params /= null then
               tc_params(params, pt);
            end if;


            -------FROM C_TUPLE_TYPE-------
         when nd_c_tuple_type =>
            if d.dt = null_d then
               em_undefinedName(p.pos); raise tc_error;
            elsif d.dt /= type_d and d.dt /= vartype_d then
               em_typeExpected(p.pos); raise tc_error;
            end if;

            if params /= null then
               tc_params(params, pt);
            end if;


            ---------FROM DATA DECL--------
            --This case will happen when looking for data_decl params
         when nd_data_decl =>
            case d.dt is
               -- If vartype or not defined, insert in st prof 1
               when vartype_d | null_d =>
                  d := (dt => vartype_d);
                  put(st, id, d, e);
                  -- Else error
               when others =>
                  em_vartypeExpected(p.pos); raise tc_error;
            end case;

            if params /= null then
               tc_params(params, pt);
            end if;

            ----------FROM OTHERS----------
         when others =>
            em_CompilerError(p.pos);            --If others -> Compiler error
            raise tc_error;
      end case;

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
      fid:   pnode renames p.func_id;
      fdesc: pnode renames p.func_desc;
      d: description;
      e: boolean;
   begin
      fn := fn + 1;
      d := (func_d, fn, fdesc, null);
      put(st, fid.identifier_id, d, e);
      if e then em_nameAlreadyUsed(p.pos); raise tc_error; end if;

      tc_desc(fdesc);
   end tc_func_decl;

   procedure tc_desc(p: in pnode) is
      fin:  pnode renames p.desc_in;
      fout: pnode renames p.desc_out;
   begin
      -- Out function params
      if fout = null then em_returningTypeExpected(p.pos); raise tc_error; end if;
      tc_tuple_type(fout);

      -- In function params
      if fin /= null then
         tc_tuple_type(fin);
      end if;
   end tc_desc;


   procedure tc_e(p: in pnode; pt: in nodeType) is
      d:   description;
   begin
      case pt is
         when nd_data_decl =>
            tc_efcall(p, pt);
         when nd_alts | nd_params | nd_c_tuple_type =>
            if (p.nt = nd_efcall) then
               tc_efcall(p, pt);
            else
               em_typeExpected(p.pos); raise tc_error;
            end if;
         when others =>
            em_CompilerError(p.pos); raise tc_error;
      end case;
   end tc_e;

   procedure tc_efcall (p: in pnode; pt: in nodeType) is
   begin
      tc_fcall(p.efcall, pt);
   end tc_efcall;

   procedure tc_id(p: in pnode; nt: in nodeType; type_p: in pnode := null) is
      id: name_id renames p.identifier_id;
      e: boolean;
      d: description;
   begin
      case nt is
         when nd_lid =>
            d := (dt => vartype_d);
            put(st, id, d, e);
            if e then em_nameAlreadyUsed(p.pos); raise tc_error; end if;
         when nd_data_decl =>
            d := (type_d, type_p, id);
            put(st, id, d, e);
            if e then em_nameAlreadyUsed(p.pos); raise tc_error; end if;
         when nd_alts =>
            d := cons(st, id);
            if d.dt = null_d then
               d := (constructor_d, id, alt_id, p);
               put(st, id, d, e);
               if e then em_nameAlreadyUsed(p.pos); raise tc_error; end if;
            else
               em_constructorExpected(p.pos); raise tc_error;
            end if;
         when others =>
            em_CompilerError(p.pos); raise tc_error;
      end case;
   end tc_id;


   procedure compareTrees_lmodel (p: in pnode; desc: in pnode) is
      tid: pnode;
      pfcall, cttparams: pnode;
      d, auxd: description;
      e: boolean;
   begin
      case p.nt is
         when nd_plus | nd_sub | nd_prod | nd_div | nd_mod | nd_usub =>
            em_arithmeticOperationNotExpected(p.pos); raise tc_error;
         when others =>
            null;
      end case;

      --Obtain E type
      tid := getType(p);

      --If ctt is fcall, then compare 2 types or store vartype
      if (desc.c_tuple_type_fcall /= null) then
         d := cons(st, desc.c_tuple_type_fcall.fcall_id.identifier_id);
         if d.dt = vartype_d then
            -- If vartype, try to insert it on T
            if (tid.nt = nd_fcall) then
               put(vtt, desc.c_tuple_type_fcall.fcall_id.identifier_id, tid.fcall_id, e);
               if e then em_typeNotInferable(p.pos); raise tc_error; end if;
            elsif (tid.nt = nd_efcall) then
               put(vtt, desc.c_tuple_type_fcall.fcall_id.identifier_id, tid.efcall.fcall_id, e);
               if e then em_typeNotInferable(p.pos); raise tc_error; end if;
            elsif (tid.nt = nd_null) then
               put(vtt, desc.c_tuple_type_fcall.fcall_id.identifier_id, p.efcall.fcall_id, e);
               if e then em_typeNotInferable(p.pos); raise tc_error; end if;
               --New variable
               vpos := vpos + 1;
               auxd := (var_d, vpos, desc.c_tuple_type_fcall.fcall_id.identifier_id);
               Put_Line(consult(nt, p.efcall.fcall_id.identifier_id));
               put(st, p.efcall.fcall_id.identifier_id, auxd, e);
            elsif tid.nt = nd_ident then
               put(vtt, desc.c_tuple_type_fcall.fcall_id.identifier_id, p, e);
               if e then em_typeNotInferable(p.pos); raise tc_error; end if;
            else
               em_CompilerError(p.pos); raise tc_error;
            end if;

            if e then em_typeNotInferable(p.pos); raise tc_error; end if;
         else
            --If no vartype, compare types
            case tid.nt is
               when nd_ident =>
                  -- When identifier, check if they are equal
                  if (tid.identifier_id /= desc.c_tuple_type_fcall.fcall_id.identifier_id) then
                     em_incorrectType(p.pos, consult(nt, desc.c_tuple_type_fcall.fcall_id.identifier_id));
                     raise tc_error;
                  end if;

               when nd_null =>
                  --New variable
                  vpos := vpos + 1;
                  auxd := (var_d, vpos, desc.c_tuple_type_fcall.fcall_id.identifier_id);
                  Put_Line(consult(nt, p.efcall.fcall_id.identifier_id));
                  put(st, p.efcall.fcall_id.identifier_id, auxd, e);

               when nd_type =>
                  em_typeNotExpected(p.pos); raise tc_error;

               when nd_fcall =>
                  --If conc, type must be list
                  if (p.nt = nd_conc) then
                     if (desc.c_tuple_type_fcall.fcall_id.identifier_id /= list_nid) then
                        em_incorrectType(p.pos, consult(nt, desc.c_tuple_type_fcall.fcall_id.identifier_id));
                        raise tc_error;
                     end if;

                     --Compare list components
                     cttparams := desc.c_tuple_type_fcall.fcall_params;
                     --TT must have 1 param as it must be "list"
                     if (cttparams = null) then em_noListExpected(p.pos); raise tc_error; end if;
                     auxd := cons(st, cons_nid);

                     --Check fcall params (e1, e2)
                     pfcall := new node(nd_params);
                     pfcall.pos := p.pos;
                     pfcall.params_el := new node(nd_el);
                     pfcall.params_el.pos := p.conc_e2.pos;
                     pfcall.params_el.el_e := p.conc_e2;
                     pfcall.params_el.el_el := new node(nd_el);
                     pfcall.params_el.el_el.pos := p.conc_e1.pos;
                     pfcall.params_el.el_el.el_e := p.conc_e1;
                     pfcall.params_el.el_el.el_el := null;
                     compareParams(pfcall, desc.c_tuple_type_fcall, auxd.cons_tree);

                  else
                     --This can be an actual function call or a constructor. Only constructor is correct.
                     if (p.nt = nd_efcall) then
                        pfcall := p.efcall;
                     elsif (p.nt = nd_fcall) then
                        pfcall := p;
                     end if;

                     d := cons(st, pfcall.fcall_id.identifier_id);
                     if (d.dt /= constructor_d) then
                        em_functionCallsNotExpected(p.pos); raise tc_error;
                     else
                        if (d.cons_type /= desc.c_tuple_type_fcall.fcall_id.identifier_id) then
                           em_incorrectType(p.pos, consult(nt, desc.c_tuple_type_fcall.fcall_id.identifier_id));
                           raise tc_error;
                        end if;
                     end if;

                     --Check fcall params
                     compareParams(pfcall.fcall_params, desc.c_tuple_type_fcall, d.cons_tree);

                  end if;
               when others =>
                  em_CompilerError(p.pos); raise tc_error;
            end case;
         end if;


         --Else, if component is a function, compare descriptions
      elsif (desc.c_tuple_type_out /= null) then
         --If constructor then raise error
         if (tid.nt = nd_null) then
            fn := fn + 1;
            auxd := (func_d, fn, desc, null);
            Put_Line(consult(nt, p.efcall.fcall_id.identifier_id));
            put(st, p.efcall.fcall_id.identifier_id, auxd, e);
            if e then em_nameAlreadyUsed(p.pos); raise tc_error; end if;
         elsif (tid.nt /= nd_fcall or else tid.fcall_id /= null) then
            em_incorrectType(p.pos, consult(nt, desc.c_tuple_type_fcall.fcall_id.identifier_id));
            raise tc_error;
         else
            --Compare IN and OUT function types
            d := cons(st, p.fcall_id.identifier_id);

            --IN
            e := compareTrees(d.fn_type.func_desc.desc_in, desc.c_tuple_type_in);
            if e then
               em_incorrectType(p.pos, consult(nt, desc.c_tuple_type_fcall.fcall_id.identifier_id));
               raise tc_error;
            end if;

            --OUT
            e := compareTrees(d.fn_type.func_desc.desc_out, desc.c_tuple_type_out);
            if e then
               em_incorrectType(p.pos, consult(nt, desc.c_tuple_type_fcall.fcall_id.identifier_id));
               raise tc_error;
            end if;
         end if;
      else
         em_CompilerError(p.pos); raise tc_error;
      end if;

   end compareTrees_lmodel;


   function compareTrees(p: in pnode; d: in pnode) return boolean is
      ptt, pctt: pnode;
      dtt, dctt: pnode;
      desc: description;
      e: boolean;
   begin
      --Prepare traversal variables
      ptt := p; dtt := d;

      --Comparing loop
      while (ptt /= null and dtt /= null) loop
         pctt := ptt.tuple_type_ctt; dctt := dtt.tuple_type_ctt;
         --If ctts then compare them
         if (pctt /= null and dctt /= null) then
            --If ctt is FCALL, compare between FCALLs
            if (pctt.c_tuple_type_fcall /= null) then
               if (dctt.c_tuple_type_fcall = null or else
                     (dctt.c_tuple_type_fcall.fcall_id.identifier_id /= pctt.c_tuple_type_fcall.fcall_id.identifier_id)) then
                  return true;
               end if;

            --If ctt is composition of tts, compare IN and OUT tts
            elsif (pctt.c_tuple_type_out /= null) then
               e := compareTrees(pctt.c_tuple_type_out, dctt.c_tuple_type_out);
               if e then return true; end if;
               e := compareTrees(pctt.c_tuple_type_in, dctt.c_tuple_type_in);
               if e then return true; end if;
            end if;

         elsif (pctt /= null or dctt /= null) then
            return true;
         end if;
         ptt := ptt.tuple_type_tt;
         dtt := dtt.tuple_type_tt;
      end loop;

      if (ptt /= null or dtt /= null) then
         return true;
      end if;

      return false;
   end compareTrees;

   procedure compareParams (p: in pnode; d: in pnode; c: in pnode) is
      pparams: pnode; -- Constructor effective parameters
      dparams: pnode; -- Parameter definition parameters
      cparams: pnode; -- Constructor parameter definitions
      tparams: pnode; -- Constructor's type definition parameters
      ptype: pnode; -- Auxiliar variables
      desc: description;
      e: boolean;
   begin
      if (p /= null) then pparams := p.params_el; end if;
      if (d /= null and then d.fcall_params /= null) then dparams := d.fcall_params.params_el; end if;
      if (c /= null and then c.fcall_params /= null) then cparams := c.fcall_params.params_el; end if;

      while (pparams /= null and cparams /= null) loop
         desc := cons(st, cparams.el_e.efcall.fcall_id.identifier_id);
         case desc.dt is
            when constructor_d =>
               --When constructor, analyze it
               compareTrees_lmodel(pparams.el_e, desc.cons_tree);
            when vartype_d | type_d =>
               -- New variable of that type
               vpos := vpos + 1;
               desc := (var_d, vpos, cparams.el_e.efcall.fcall_id.identifier_id);
               Put_Line(consult(nt, pparams.el_e.efcall.fcall_id.identifier_id));
               put(st, pparams.el_e.efcall.fcall_id.identifier_id, desc, e);
               if e then em_nameAlreadyUsed(p.pos); raise tc_error; end if;
            when null_d =>
               --Generic parameter. Find it in the type definition parameters.
               tparams := cons(st, d.fcall_id.identifier_id).type_tree.type_params;
               if(tparams /= null) then tparams := tparams.params_el; end if;
               while (tparams /= null) loop
                  if (tparams.el_e.efcall.fcall_id.identifier_id = cparams.el_e.efcall.fcall_id.identifier_id) then
                     exit;
                  end if;
                  tparams := tparams.el_el;
                  dparams := dparams.el_el;
               end loop;
               if (tparams = null) then em_CompilerError(p.pos); raise tc_error; end if;

               ptype := getType(pparams.el_e);
               case ptype.nt is
                  when nd_ident | nd_type =>
                     --If literal or type, try to add in T
                     put(vtt, dparams.el_e.identifier_id, ptype, e);
                     if e then em_typeNotInferable(p.pos); raise tc_error; end if;
                  when nd_fcall =>
                     if (pparams.el_e.fcall_id.identifier_id /= dparams.el_e.identifier_id) then
                        em_incorrectType(p.pos, consult(nt, dparams.el_e.identifier_id));
                        raise tc_error;
                     end if;
                     compareTrees_lmodel(pparams.el_e, ptype.fcall_params);
                  when nd_null =>
                     -- New variable of type dparam
                     vpos := vpos + 1;
                     desc := (var_d, vpos, dparams.el_e.efcall.fcall_id.identifier_id);
                     Put_Line(consult(nt, pparams.el_e.efcall.fcall_id.identifier_id));
                     put(st, pparams.el_e.efcall.fcall_id.identifier_id, desc, e);
                     if e then em_nameAlreadyUsed(p.pos); raise tc_error; end if;
                  when nd_typevar =>
                     em_variableNotExpected(p.pos); raise tc_error;
                  when others =>
                     em_CompilerError(p.pos); raise tc_error;
               end case;

            when others =>
               em_CompilerError(p.pos); raise tc_error;
         end case;

         pparams := pparams.el_el;
         cparams := cparams.el_el;
      end loop;

      if cparams /= null or pparams /= null then em_incorrectType(p.pos, ""); end if;
   end compareParams;

   procedure compareParams_e (p: in pnode; d: in pnode; c: in pnode) is
      pparams: pnode; -- Constructor effective parameters
      dparams: pnode; -- Parameter definition parameters
      cparams: pnode; -- Constructor parameter definitions
      tparams: pnode; -- Constructor's type definition parameters
      ptype: pnode; -- Auxiliar variables
      desc: description;
      e: boolean;
   begin
      if (p /= null) then pparams := p.params_el; end if;
      if (d /= null and then d.fcall_params /= null) then dparams := d.fcall_params.params_el; end if;
      if (c /= null and then c.fcall_params /= null) then cparams := c.fcall_params.params_el; end if;

      while (pparams /= null and cparams /= null) loop
         Put_Line(consult(nt, cparams.el_e.efcall.fcall_id.identifier_id));
         desc := cons(st, cparams.el_e.efcall.fcall_id.identifier_id);
         case desc.dt is
            when constructor_d =>
               --When constructor, analyze it
               tc_eq_e(pparams.el_e, desc.cons_tree);

            when vartype_d | type_d =>
               -- Identify what parameter are we comparing and then compare it

               -- Get constructor type desctiption (with definition parameters)
               tparams := cons(st, d.fcall_id.identifier_id).type_tree.type_params;
               if(tparams /= null) then tparams := tparams.params_el; end if;
               while (tparams /= null) loop
                  if (tparams.el_e.efcall.fcall_id.identifier_id = cparams.el_e.efcall.fcall_id.identifier_id) then
                     exit;
                  end if;
                  tparams := tparams.el_el;
                  dparams := dparams.el_el;
               end loop;

               ptype := getType(pparams.el_e);
               case ptype.nt is
                  when nd_ident | nd_type =>
                     --If literal or type, try to add in T
                     put(vtt, dparams.el_e.identifier_id, ptype, e);
                     if e then em_typeNotInferable(p.pos); raise tc_error; end if;
                  when nd_fcall =>
                     if (pparams.el_e.fcall_id.identifier_id /= dparams.el_e.identifier_id) then
                        em_incorrectType(p.pos, consult(nt, dparams.el_e.identifier_id));
                        raise tc_error;
                     end if;
                     tc_eq_e(pparams.el_e, ptype.fcall_params);
                  when nd_null =>
                     em_nameAlreadyUsed(p.pos);

                  when nd_typevar =>
                     em_variableNotExpected(p.pos); raise tc_error;

                  when others =>
                     em_CompilerError(p.pos); raise tc_error;
               end case;

            when null_d =>
               em_undefinedName(p.pos);

            when others =>
               em_CompilerError(p.pos); raise tc_error;
         end case;

         pparams := pparams.el_el;
         cparams := cparams.el_el;
      end loop;

      if cparams /= null or pparams /= null then em_incorrectType(p.pos, ""); end if;
   end compareParams_e;

   procedure compare_e (p: in pnode; d: in pnode) is
      dit: pnode; -- d iterator
      pit: pnode; -- p iterator
      ptype: pnode;
      desc: description;
      e: boolean;
   begin
      -- If only 1 element is null, incorrect type
      if ((p =  null and then d /= null) or else (p /= null and then d = null)) then
         em_incorrectType(p.pos, "");
         raise tc_error;
      end if;

      -- If 2 elements are null, no typecheck must be done
      if (p = null or else p.nt = nd_null) and (d = null or else d.nt = nd_null) then
         return;
      end if;


      if d.nt = nd_params then
         dit := d.params_el;

         case p.nt is
            when nd_ident =>
               if (p.identifier_id /= dit.el_e.efcall.fcall_id.identifier_id) then
                  em_incorrectType(p.pos, consult(nt, dit.el_e.efcall.fcall_id.identifier_id));
               end if;
            when nd_tuple_type =>
               pit := p;
               while dit /= null loop
                  if pit.tuple_type_ctt.c_tuple_type_fcall /= null then
                     ptype := pit.tuple_type_ctt.c_tuple_type_fcall.fcall_params.params_el;
                  end if;
                  if (ptype.el_e.efcall.fcall_id.identifier_id /= dit.el_e.efcall.fcall_id.identifier_id) then
                     em_incorrectType(pit.pos, consult(nt, dit.el_e.efcall.fcall_id.identifier_id));
                  end if;

                  pit := pit.tuple_type_tt;
                  dit := dit.el_el;
               end loop;
               if (dit /= null or pit /= null) then
                  em_incorrectType(p.pos, "");
                  raise tc_error;
               end if;

            when nd_fcall =>
               if dit.el_el /= null then em_incorrectType(p.pos, ""); raise tc_error; end if;

               desc := cons(st, p.fcall_id.identifier_id);
               if desc.dt = constructor_d then
                  if dit.el_e.efcall.fcall_id.identifier_id /= desc.cons_type then
                     em_incorrectType(p.pos, consult(nt, dit.el_e.efcall.fcall_id.identifier_id));
                     raise tc_error;
                  end if;
               else
                  em_CompilerError(p.pos);
                  raise tc_error;
               end if;

            when nd_c_tuple_type => --Function call
               pit := getType(dit.el_e);
               Put_Line(consult(nt, pit.typevar_lid.identifier_id));
               if pit.nt = nd_c_tuple_type then
                  e := compareTrees(p.c_tuple_type_out, pit);
                  if e then em_incorrectType(p.pos, ""); raise tc_error; end if;
               elsif pit.nt = nd_typevar then
                  if(pit.typevar_lid.identifier_id /= p.c_tuple_type_out.tuple_type_ctt.c_tuple_type_fcall.fcall_id.identifier_id) then
                     em_incorrectType(p.pos, consult(nt, pit.typevar_lid.identifier_id));
                     raise tc_error;
                  end if;
               end if;

            when nd_params =>
               pit := p.params_el;
               while dit /= null and pit /= null loop
                  ptype := getType(pit.el_e);
                  if ptype.nt = nd_typevar then
                     Put_Line(consult(nt, ptype.typevar_lid.identifier_id) & " vs " & consult(nt, dit.el_e.efcall.fcall_id.identifier_id));
                     if (ptype.typevar_lid.identifier_id /= dit.el_e.efcall.fcall_id.identifier_id) then
                        em_incorrectType(p.pos, consult(nt, dit.el_e.efcall.fcall_id.identifier_id));
                     end if;
                  elsif ptype.nt = nd_fcall then
                     if (ptype.fcall_id.identifier_id /= dit.el_e.efcall.fcall_id.identifier_id) then
                        em_incorrectType(p.pos, consult(nt, dit.el_e.efcall.fcall_id.identifier_id));
                     end if;
                  else
                     em_incorrectType(p.pos, "");
                     raise tc_error;
                  end if;

                  pit := pit.el_el;
                  dit := dit.el_el;
               end loop;
               if (dit /= null or pit /= null) then
                  em_incorrectType(p.pos, "");
                  raise tc_error;
               end if;

            when nd_desc =>
               compare_e(p.desc_out, d);

            when nd_null =>
               em_undefinedName(p.pos);

            when nd_typevar =>
               null;
            when others =>
               em_CompilerError(p.pos); raise tc_error;
            end case;
      else
         em_CompilerError(p.pos); raise tc_error;
      end if;
   end compare_e;


   function getType(p: in pnode) return pnode is
      d: description;
      ret: pnode;
      tt, lastt, ctt: pnode;
      elem: pnode;
   begin
      case p.nt is
         when nd_plus | nd_sub | nd_prod | nd_div | nd_mod | nd_usub =>
            ret := new node(nd_ident);
            ret.identifier_id := int_nid;
         when nd_oprel | nd_and | nd_or | nd_not =>
            ret := new node(nd_ident);
            ret.identifier_id := bool_nid;
         when nd_lit =>
            ret := new node(nd_ident);
            case p.lit_lit.sbt is
               when sbt_bool =>
                  ret.identifier_id := bool_nid;
               when sbt_int =>
                  ret.identifier_id := int_nid;
               when sbt_chr =>
                  ret.identifier_id := char_nid;
               when others => em_CompilerError(p.pos); raise tc_error;
            end case;
         when nd_elit =>
            return getType(p.elit);
         when nd_efcall =>
            d := cons(st, p.efcall.fcall_id.identifier_id);
            case d.dt is
               when null_d =>
                  -- Pattern matching new variable
                  ret := new node(nd_null);
               when vartype_d | var_d =>
                  -- No information necessary (will have to operate with T)
                  ret := new node(nd_typevar);
                  ret.typevar_lid := new node(nd_ident);
                  ret.typevar_lid.pos := p.pos;
                  if d.dt = var_d then
                     ret.typevar_lid.identifier_id := d.vtype;
                  else
                     ret.typevar_lid.identifier_id := p.efcall.fcall_id.identifier_id;
                  end if;

               when type_d =>
                  -- Return type information
                  ret := new node(nd_type);
                  ret.type_id := new node(nd_ident);
                  ret.type_id.pos := p.pos;
                  ret.type_id.identifier_id := d.type_id;
                  ret.type_decl := d.type_tree;
               when constructor_d =>
                  -- Return constructor information
                  ret := new node(nd_fcall);
                  ret.fcall_id := new node(nd_ident);
                  ret.fcall_id.pos := p.pos;
                  ret.fcall_id.identifier_id := d.cons_type;
                  ret.fcall_params := d.cons_tree;
               when func_d =>
                  ret := d.fn_type;
            end case;
         when nd_list =>
            ctt := p;
            lastt := new node(nd_tuple_type);
            ret := lastt;
            while (ctt /= null) loop
               tt := new node(nd_tuple_type);
               tt.tuple_type_ctt := new node(nd_c_tuple_type);
               elem := getType(ctt.list_e);
               tt.tuple_type_ctt.pos := elem.pos;
               if elem.nt = nd_ident then
                  tt.tuple_type_ctt.c_tuple_type_fcall := new node(nd_fcall);
                  tt.tuple_type_ctt.c_tuple_type_fcall.pos := elem.pos;
                  tt.tuple_type_ctt.c_tuple_type_fcall.fcall_id := elem;
               elsif elem.nt = nd_fcall then
                  tt.tuple_type_ctt.c_tuple_type_fcall := elem;
               elsif elem.nt = nd_typevar then
                  d := cons(st, ctt.list_e.efcall.fcall_id.identifier_id);
                  if d.dt = null_d then
                     em_undefinedName(p.pos); raise tc_error;
                  elsif d.dt = var_d then
                     tt.tuple_type_ctt.c_tuple_type_fcall := new node(nd_fcall);
                     tt.tuple_type_ctt.c_tuple_type_fcall.pos := elem.pos;
                     tt.tuple_type_ctt.c_tuple_type_fcall.fcall_id := new node(nd_ident);
                     tt.tuple_type_ctt.c_tuple_type_fcall.fcall_id.pos := elem.pos;
                     tt.tuple_type_ctt.c_tuple_type_fcall.fcall_id.identifier_id := d.vtype;
                  elsif d.dt = vartype_d then
                     em_vartypeNotExpected(p.pos); raise tc_error;
                  end if;
               elsif elem.nt = nd_null then
                  em_undefinedName(p.pos);
                  raise tc_error;
               else
                  em_CompilerError(p.pos);
                  raise tc_error;
               end if;

               --Save tt on ret
               tt.pos := elem.pos;
               lastt.tuple_type_tt := tt;
               lastt := tt;

               ctt := ctt.list_list;
            end loop;
            ret := ret.tuple_type_tt;

         when nd_elist =>
            ret := new node(nd_fcall);
            ret.fcall_id := new node(nd_ident);
            ret.fcall_id.pos := p.pos;
            ret.fcall_id.identifier_id := list_nid;
            ret.fcall_params := getType(p.list_e_list.list_e); --Obtain first element's type
         when nd_conc =>
            ret := new node(nd_fcall);
            ret.fcall_id := new node(nd_ident);
            ret.fcall_id.pos := p.pos;
            ret.fcall_id.identifier_id := list_nid;
            ret.fcall_params := getType(p.conc_e1);
         when nd_tuple =>
            return getType(p.tuple_list);
         when others =>
            em_CompilerError(p.pos); raise tc_error;
      end case;

      ret.pos := p.pos;
      return ret;
   end getType;

end semantic.type_checking;
