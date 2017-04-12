--with semantic.missatges, semantic.g_codi_int;
package body semantic is

   procedure prepare (nom: in String) is
   begin
      empty(nt);
      empty(st);
      empty(altst);
      error := false;


      fn := 0;
--      nv := 0;
--      np := 0;
--      ne := 0;
--      prof := 0;
--      semantic.missatges.prepara_missatges(nom);
   end prepare;

--   procedure conclou_analisi is
--   begin
--      semantic.missatges.conclou_missatges;
--  end conclou_analisi;

--   function imatge(int: in String) return String is --Lleva l'espai del img
--   begin
--      if integer'Value(int) < 0 then --Si es negatiu no fa res
--         return int;
--      end if;
--      return int(int'First + 1..int'last);
--   end imatge;


end semantic;
