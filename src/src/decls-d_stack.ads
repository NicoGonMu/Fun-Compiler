generic
   type item is private;
package decls.d_stack is

   type stack is limited private;

   bad_use:        exception;
   space_overflow: exception;

   procedure empty   (s: out stack);
   procedure push    (s: in out stack; x: in item);
   procedure pop     (s: in out stack);
   function top      (s: in stack) return item;
   function is_empty (s: in stack) return boolean;

private
   type cell;
   type pcell is access cell;

   type cell is
      record
         x: item;
         next: pcell;
      end record;

   type stack is
      record
         top: pcell;
      end record;

end decls.d_stack;
