with semantic.messages;--, semantic.g_codi_int;
package body semantic is

   procedure prepare (fname: in String) is
   begin
      --Prepare names table
      empty(nt);
      empty(st);

      error := false;

      fn := 0;

      alt_id := 0;

      semantic.messages.prepare_messages(fname);
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
