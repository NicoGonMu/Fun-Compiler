package stdio is
   procedure putc (c: in character);
   procedure getc (c: in character);
   procedure puti (n: in integer);
   procedure geti (n: in integer);
   procedure puts (c: in string);
   procedure new_line;

private
   pragma Import(Fortran, putc);--, "putc");
   pragma Import(Fortran, getc);--, "getc");
   pragma Import(Fortran, puti);--, "puti");
   pragma Import(Fortran, geti);--, "geti");
   pragma Import(Fortran, puts);--, "puts");
   pragma Import(Fortran, new_line);

end stdio;
