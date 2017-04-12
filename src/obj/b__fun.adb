pragma Ada_95;
pragma Warnings (Off);
pragma Source_File_Name (ada_main, Spec_File_Name => "b__fun.ads");
pragma Source_File_Name (ada_main, Body_File_Name => "b__fun.adb");
pragma Suppress (Overflow_Check);
with Ada.Exceptions;

package body ada_main is

   E103 : Short_Integer; pragma Import (Ada, E103, "system__os_lib_E");
   E013 : Short_Integer; pragma Import (Ada, E013, "system__soft_links_E");
   E019 : Short_Integer; pragma Import (Ada, E019, "system__exception_table_E");
   E135 : Short_Integer; pragma Import (Ada, E135, "ada__containers_E");
   E096 : Short_Integer; pragma Import (Ada, E096, "ada__io_exceptions_E");
   E049 : Short_Integer; pragma Import (Ada, E049, "ada__strings_E");
   E051 : Short_Integer; pragma Import (Ada, E051, "ada__strings__maps_E");
   E055 : Short_Integer; pragma Import (Ada, E055, "ada__strings__maps__constants_E");
   E087 : Short_Integer; pragma Import (Ada, E087, "ada__tags_E");
   E095 : Short_Integer; pragma Import (Ada, E095, "ada__streams_E");
   E039 : Short_Integer; pragma Import (Ada, E039, "interfaces__c_E");
   E021 : Short_Integer; pragma Import (Ada, E021, "system__exceptions_E");
   E106 : Short_Integer; pragma Import (Ada, E106, "system__file_control_block_E");
   E098 : Short_Integer; pragma Import (Ada, E098, "system__file_io_E");
   E101 : Short_Integer; pragma Import (Ada, E101, "system__finalization_root_E");
   E099 : Short_Integer; pragma Import (Ada, E099, "ada__finalization_E");
   E063 : Short_Integer; pragma Import (Ada, E063, "system__object_reader_E");
   E044 : Short_Integer; pragma Import (Ada, E044, "system__dwarf_lines_E");
   E009 : Short_Integer; pragma Import (Ada, E009, "system__secondary_stack_E");
   E034 : Short_Integer; pragma Import (Ada, E034, "system__traceback__symbolic_E");
   E093 : Short_Integer; pragma Import (Ada, E093, "ada__text_io_E");
   E132 : Short_Integer; pragma Import (Ada, E132, "decls__d_names_table_E");
   E124 : Short_Integer; pragma Import (Ada, E124, "decls__d_symbol_table_E");
   E108 : Short_Integer; pragma Import (Ada, E108, "fun_dfa_E");
   E110 : Short_Integer; pragma Import (Ada, E110, "fun_io_E");
   E120 : Short_Integer; pragma Import (Ada, E120, "fun_tokens_E");
   E128 : Short_Integer; pragma Import (Ada, E128, "lexical_a_E");
   E130 : Short_Integer; pragma Import (Ada, E130, "semantic_E");
   E137 : Short_Integer; pragma Import (Ada, E137, "semantic__c_tree_E");
   E143 : Short_Integer; pragma Import (Ada, E143, "syntactic_a_E");

   Local_Priority_Specific_Dispatching : constant String := "";
   Local_Interrupt_States : constant String := "";

   Is_Elaborated : Boolean := False;

   procedure finalize_library is
   begin
      E093 := E093 - 1;
      declare
         procedure F1;
         pragma Import (Ada, F1, "ada__text_io__finalize_spec");
      begin
         F1;
      end;
      declare
         procedure F2;
         pragma Import (Ada, F2, "system__file_io__finalize_body");
      begin
         E098 := E098 - 1;
         F2;
      end;
      declare
         procedure Reraise_Library_Exception_If_Any;
            pragma Import (Ada, Reraise_Library_Exception_If_Any, "__gnat_reraise_library_exception_if_any");
      begin
         Reraise_Library_Exception_If_Any;
      end;
   end finalize_library;

   procedure adafinal is
      procedure s_stalib_adafinal;
      pragma Import (C, s_stalib_adafinal, "system__standard_library__adafinal");

      procedure Runtime_Finalize;
      pragma Import (C, Runtime_Finalize, "__gnat_runtime_finalize");

   begin
      if not Is_Elaborated then
         return;
      end if;
      Is_Elaborated := False;
      Runtime_Finalize;
      s_stalib_adafinal;
   end adafinal;

   type No_Param_Proc is access procedure;

   procedure adainit is
      Main_Priority : Integer;
      pragma Import (C, Main_Priority, "__gl_main_priority");
      Time_Slice_Value : Integer;
      pragma Import (C, Time_Slice_Value, "__gl_time_slice_val");
      WC_Encoding : Character;
      pragma Import (C, WC_Encoding, "__gl_wc_encoding");
      Locking_Policy : Character;
      pragma Import (C, Locking_Policy, "__gl_locking_policy");
      Queuing_Policy : Character;
      pragma Import (C, Queuing_Policy, "__gl_queuing_policy");
      Task_Dispatching_Policy : Character;
      pragma Import (C, Task_Dispatching_Policy, "__gl_task_dispatching_policy");
      Priority_Specific_Dispatching : System.Address;
      pragma Import (C, Priority_Specific_Dispatching, "__gl_priority_specific_dispatching");
      Num_Specific_Dispatching : Integer;
      pragma Import (C, Num_Specific_Dispatching, "__gl_num_specific_dispatching");
      Main_CPU : Integer;
      pragma Import (C, Main_CPU, "__gl_main_cpu");
      Interrupt_States : System.Address;
      pragma Import (C, Interrupt_States, "__gl_interrupt_states");
      Num_Interrupt_States : Integer;
      pragma Import (C, Num_Interrupt_States, "__gl_num_interrupt_states");
      Unreserve_All_Interrupts : Integer;
      pragma Import (C, Unreserve_All_Interrupts, "__gl_unreserve_all_interrupts");
      Detect_Blocking : Integer;
      pragma Import (C, Detect_Blocking, "__gl_detect_blocking");
      Default_Stack_Size : Integer;
      pragma Import (C, Default_Stack_Size, "__gl_default_stack_size");
      Leap_Seconds_Support : Integer;
      pragma Import (C, Leap_Seconds_Support, "__gl_leap_seconds_support");
      Bind_Env_Addr : System.Address;
      pragma Import (C, Bind_Env_Addr, "__gl_bind_env_addr");

      procedure Runtime_Initialize (Install_Handler : Integer);
      pragma Import (C, Runtime_Initialize, "__gnat_runtime_initialize");

      Finalize_Library_Objects : No_Param_Proc;
      pragma Import (C, Finalize_Library_Objects, "__gnat_finalize_library_objects");
   begin
      if Is_Elaborated then
         return;
      end if;
      Is_Elaborated := True;
      Main_Priority := -1;
      Time_Slice_Value := -1;
      WC_Encoding := 'b';
      Locking_Policy := ' ';
      Queuing_Policy := ' ';
      Task_Dispatching_Policy := ' ';
      Priority_Specific_Dispatching :=
        Local_Priority_Specific_Dispatching'Address;
      Num_Specific_Dispatching := 0;
      Main_CPU := -1;
      Interrupt_States := Local_Interrupt_States'Address;
      Num_Interrupt_States := 0;
      Unreserve_All_Interrupts := 0;
      Detect_Blocking := 0;
      Default_Stack_Size := -1;
      Leap_Seconds_Support := 0;

      Runtime_Initialize (1);

      Finalize_Library_Objects := finalize_library'access;

      System.Soft_Links'Elab_Spec;
      System.Exception_Table'Elab_Body;
      E019 := E019 + 1;
      Ada.Containers'Elab_Spec;
      E135 := E135 + 1;
      Ada.Io_Exceptions'Elab_Spec;
      E096 := E096 + 1;
      Ada.Strings'Elab_Spec;
      E049 := E049 + 1;
      Ada.Strings.Maps'Elab_Spec;
      Ada.Strings.Maps.Constants'Elab_Spec;
      E055 := E055 + 1;
      Ada.Tags'Elab_Spec;
      Ada.Streams'Elab_Spec;
      E095 := E095 + 1;
      Interfaces.C'Elab_Spec;
      System.Exceptions'Elab_Spec;
      E021 := E021 + 1;
      System.File_Control_Block'Elab_Spec;
      E106 := E106 + 1;
      System.Finalization_Root'Elab_Spec;
      E101 := E101 + 1;
      Ada.Finalization'Elab_Spec;
      E099 := E099 + 1;
      System.Object_Reader'Elab_Spec;
      System.Dwarf_Lines'Elab_Spec;
      System.File_Io'Elab_Body;
      E098 := E098 + 1;
      E039 := E039 + 1;
      Ada.Tags'Elab_Body;
      E087 := E087 + 1;
      E051 := E051 + 1;
      System.Soft_Links'Elab_Body;
      E013 := E013 + 1;
      System.Os_Lib'Elab_Body;
      E103 := E103 + 1;
      System.Secondary_Stack'Elab_Body;
      E009 := E009 + 1;
      E044 := E044 + 1;
      E063 := E063 + 1;
      System.Traceback.Symbolic'Elab_Body;
      E034 := E034 + 1;
      Ada.Text_Io'Elab_Spec;
      Ada.Text_Io'Elab_Body;
      E093 := E093 + 1;
      decls.d_names_table'elab_spec;
      E132 := E132 + 1;
      E124 := E124 + 1;
      E108 := E108 + 1;
      fun_io'elab_spec;
      E110 := E110 + 1;
      Fun_Tokens'Elab_Spec;
      E120 := E120 + 1;
      E130 := E130 + 1;
      E137 := E137 + 1;
      E128 := E128 + 1;
      E143 := E143 + 1;
   end adainit;

   procedure Ada_Main_Program;
   pragma Import (Ada, Ada_Main_Program, "_ada_fun");

   function main
     (argc : Integer;
      argv : System.Address;
      envp : System.Address)
      return Integer
   is
      procedure Initialize (Addr : System.Address);
      pragma Import (C, Initialize, "__gnat_initialize");

      procedure Finalize;
      pragma Import (C, Finalize, "__gnat_finalize");
      SEH : aliased array (1 .. 2) of Integer;

      Ensure_Reference : aliased System.Address := Ada_Main_Program_Name'Address;
      pragma Volatile (Ensure_Reference);

   begin
      gnat_argc := argc;
      gnat_argv := argv;
      gnat_envp := envp;

      Initialize (SEH'Address);
      adainit;
      Ada_Main_Program;
      adafinal;
      Finalize;
      return (gnat_exit_status);
   end;

--  BEGIN Object file/option list
   --   /home/nico/Documentos/Nico/UIB/TFG/Fun-Compiler/src/obj/decls.o
   --   /home/nico/Documentos/Nico/UIB/TFG/Fun-Compiler/src/obj/decls-general_defs.o
   --   /home/nico/Documentos/Nico/UIB/TFG/Fun-Compiler/src/obj/decls-d_description.o
   --   /home/nico/Documentos/Nico/UIB/TFG/Fun-Compiler/src/obj/decls-d_names_table.o
   --   /home/nico/Documentos/Nico/UIB/TFG/Fun-Compiler/src/obj/decls-d_symbol_table.o
   --   /home/nico/Documentos/Nico/UIB/TFG/Fun-Compiler/src/obj/decls-d_tree.o
   --   /home/nico/Documentos/Nico/UIB/TFG/Fun-Compiler/src/obj/fun_dfa.o
   --   /home/nico/Documentos/Nico/UIB/TFG/Fun-Compiler/src/obj/fun_goto.o
   --   /home/nico/Documentos/Nico/UIB/TFG/Fun-Compiler/src/obj/fun_io.o
   --   /home/nico/Documentos/Nico/UIB/TFG/Fun-Compiler/src/obj/fun_shift_reduce.o
   --   /home/nico/Documentos/Nico/UIB/TFG/Fun-Compiler/src/obj/fun_tokens.o
   --   /home/nico/Documentos/Nico/UIB/TFG/Fun-Compiler/src/obj/semantic.o
   --   /home/nico/Documentos/Nico/UIB/TFG/Fun-Compiler/src/obj/semantic-c_tree.o
   --   /home/nico/Documentos/Nico/UIB/TFG/Fun-Compiler/src/obj/lexical_a.o
   --   /home/nico/Documentos/Nico/UIB/TFG/Fun-Compiler/src/obj/syntactic_a.o
   --   /home/nico/Documentos/Nico/UIB/TFG/Fun-Compiler/src/obj/fun.o
   --   -L/home/nico/Documentos/Nico/UIB/TFG/Fun-Compiler/src/obj/
   --   -L/home/nico/Documentos/Nico/UIB/TFG/Fun-Compiler/src/obj/
   --   -L/usr/gnat/lib/gcc/x86_64-pc-linux-gnu/4.9.4/adalib/
   --   -static
   --   -lgnat
   --   -ldl
--  END Object file/option list   

end ada_main;