with System.Machine_Code, stdio, Interfaces;
use System.Machine_Code, stdio, Interfaces;

procedure writer is

   procedure write_list(list_address: in Unsigned_32; type_address: in out Unsigned_32);
   procedure write_tuple(tuple_address: in Unsigned_32; type_address: in out Unsigned_32);


   procedure write_scalar(element: in Unsigned_32; result_type: in Unsigned_32) is
   begin
      if result_type = 0 then    -- Character
         putc(Character'Val(element));

      elsif result_type = 1 then -- Integer
         puti(Integer'Value(element'Img));

      else                       -- Boolean
         if element = 0 then
            puts("false");
         else
            puts("true");
         end if;
      end if;

   end write_scalar;


   procedure write(element: in Unsigned_32; type_address: in out Unsigned_32; result_type: in Unsigned_32) is
   begin
      -- For values 0, 1, 2, type is an scalar and can be directly written
      -- Value 3 indicates a list type. It will be necessary to catch it's inner type.
      -- Value 4 indicates a tuple, and then an iteration for the elements will be required.
      if result_type < 3 then
         write_scalar(element, result_type);

      elsif result_type = 3 then -- List
         type_address := type_address + 2;
         putc('[');
         write_list(element, type_address);
         putc(']');

      elsif result_type = 4 then -- Tuple
         type_address := type_address + 2;
         putc('(');
         write_tuple(element, type_address);
         putc(')');
      end if;
   end write;

   procedure write_list(list_address: in Unsigned_32; type_address: in out Unsigned_32) is
      result_type: Unsigned_32;
      element: Unsigned_32;
   begin
      -- Get type (move address to register and do indirect movl)
      Asm("movl (%1), %0",
          Outputs => Unsigned_32'Asm_Output("=a", result_type),
          Inputs  => Unsigned_32'Asm_Input ("a", type_address));

      -- Write each element
      while true loop
         -- Get element (move element address to a register and do indirect movl)
         Asm("movl (%1), %0",
             Outputs => Unsigned_32'Asm_Output("=a", element),
             Inputs  => Unsigned_32'Asm_Input ("a", list_address));

         write(element, type_address, result_type);
      end loop;
   end write_list;




   procedure write_tuple(tuple_address: in Unsigned_32; type_address: in out Unsigned_32) is
      element: Unsigned_32;             -- Will contain the element to write on each iteration
      element_type: Unsigned_32;        -- Will contain the element type on each iteration
      local_tuple_address: Unsigned_32; -- Will contain the element address on each iteration
      tuple_num_elements: Unsigned_32;  -- Will contain the tuple's number of elements
   begin
      -- Get number of elements (move address to register and do indirect movl)
      Asm("movl (%1), %0",
          Outputs => Unsigned_32'Asm_Output("=a", tuple_num_elements),
          Inputs  => Unsigned_32'Asm_Input ("a", type_address));

      local_tuple_address := tuple_address;

      -- Write each element
      for i in 1..tuple_num_elements loop
         -- Get element type (move address to register and do indirect movl)
         type_address := type_address + 2;
         Asm("movl (%1), %0",
             Outputs => Unsigned_32'Asm_Output("=a", element_type),
             Inputs  => Unsigned_32'Asm_Input ("a", type_address));

         -- Get element (move address to register and do indirect movl)
         local_tuple_address := local_tuple_address + 2;
         Asm("movl (%1), %0",
             Outputs => Unsigned_32'Asm_Output("=a", element),
             Inputs  => Unsigned_32'Asm_Input ("a", local_tuple_address));

         write(element, type_address, element_type);
      end loop;
   end write_tuple;


   result_type: Unsigned_32;
   type_address: Unsigned_32;
   element: Unsigned_32;
begin
   -- Get variable (containing the result type) address
   Asm("movl $res_type, %0",
       Outputs => Unsigned_32'Asm_Output("=a", type_address));

   -- Read variable containing the result type data structure
   Asm("movl (%%eax), %0",
       Outputs => Unsigned_32'Asm_Output("=a", result_type));

   -- Get element at top of stack
   Asm("movl (%%esi), %0",
       Outputs => Unsigned_32'Asm_Output("=a", element));


   write(element, type_address, result_type);
end writer;
