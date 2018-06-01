with semantic.messages;--, semantic.g_codi_int;
package body semantic is

   procedure prepare (fname: in String) is
   begin
      --Prepare names table
      empty(nt);
      empty(st);

      error := false;

      fn := 0;

      semantic.messages.prepare_messages(fname);
   end prepare;


--   procedure conclou_analisi is
--   begin
--      semantic.missatges.conclou_missatges;
--  end conclou_analisi;

   function Trim(int: in String) return String is
   begin
      if integer'Value(int) < 0 then
         return int;
      end if;
      return int(int'First + 1..int'last);
   end Trim;


end semantic;
