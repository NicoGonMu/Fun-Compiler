pragma Ada_95;
pragma Warnings (Off);
with System;
package ada_main is

   gnat_argc : Integer;
   gnat_argv : System.Address;
   gnat_envp : System.Address;

   pragma Import (C, gnat_argc);
   pragma Import (C, gnat_argv);
   pragma Import (C, gnat_envp);

   gnat_exit_status : Integer;
   pragma Import (C, gnat_exit_status);

   GNAT_Version : constant String :=
                    "GNAT Version: GPL 2016 (20160515-49)" & ASCII.NUL;
   pragma Export (C, GNAT_Version, "__gnat_version");

   Ada_Main_Program_Name : constant String := "_ada_fun" & ASCII.NUL;
   pragma Export (C, Ada_Main_Program_Name, "__gnat_ada_main_program_name");

   procedure adainit;
   pragma Export (C, adainit, "adainit");

   procedure adafinal;
   pragma Export (C, adafinal, "adafinal");

   function main
     (argc : Integer;
      argv : System.Address;
      envp : System.Address)
      return Integer;
   pragma Export (C, main, "main");

   type Version_32 is mod 2 ** 32;
   u00001 : constant Version_32 := 16#7563646d#;
   pragma Export (C, u00001, "funB");
   u00002 : constant Version_32 := 16#b6df930e#;
   pragma Export (C, u00002, "system__standard_libraryB");
   u00003 : constant Version_32 := 16#937076cc#;
   pragma Export (C, u00003, "system__standard_libraryS");
   u00004 : constant Version_32 := 16#3ffc8e18#;
   pragma Export (C, u00004, "adaS");
   u00005 : constant Version_32 := 16#e51537a7#;
   pragma Export (C, u00005, "ada__command_lineB");
   u00006 : constant Version_32 := 16#d59e21a4#;
   pragma Export (C, u00006, "ada__command_lineS");
   u00007 : constant Version_32 := 16#6326c08a#;
   pragma Export (C, u00007, "systemS");
   u00008 : constant Version_32 := 16#0f0cb66d#;
   pragma Export (C, u00008, "system__secondary_stackB");
   u00009 : constant Version_32 := 16#c8470fe3#;
   pragma Export (C, u00009, "system__secondary_stackS");
   u00010 : constant Version_32 := 16#b01dad17#;
   pragma Export (C, u00010, "system__parametersB");
   u00011 : constant Version_32 := 16#1d0ccdf5#;
   pragma Export (C, u00011, "system__parametersS");
   u00012 : constant Version_32 := 16#5f84b5ab#;
   pragma Export (C, u00012, "system__soft_linksB");
   u00013 : constant Version_32 := 16#fda218df#;
   pragma Export (C, u00013, "system__soft_linksS");
   u00014 : constant Version_32 := 16#e7214354#;
   pragma Export (C, u00014, "ada__exceptionsB");
   u00015 : constant Version_32 := 16#020f9e08#;
   pragma Export (C, u00015, "ada__exceptionsS");
   u00016 : constant Version_32 := 16#e947e6a9#;
   pragma Export (C, u00016, "ada__exceptions__last_chance_handlerB");
   u00017 : constant Version_32 := 16#41e5552e#;
   pragma Export (C, u00017, "ada__exceptions__last_chance_handlerS");
   u00018 : constant Version_32 := 16#87a448ff#;
   pragma Export (C, u00018, "system__exception_tableB");
   u00019 : constant Version_32 := 16#3e88a9c8#;
   pragma Export (C, u00019, "system__exception_tableS");
   u00020 : constant Version_32 := 16#ce4af020#;
   pragma Export (C, u00020, "system__exceptionsB");
   u00021 : constant Version_32 := 16#0b45ad7c#;
   pragma Export (C, u00021, "system__exceptionsS");
   u00022 : constant Version_32 := 16#4c9e814d#;
   pragma Export (C, u00022, "system__exceptions__machineS");
   u00023 : constant Version_32 := 16#aa0563fc#;
   pragma Export (C, u00023, "system__exceptions_debugB");
   u00024 : constant Version_32 := 16#1dac394e#;
   pragma Export (C, u00024, "system__exceptions_debugS");
   u00025 : constant Version_32 := 16#6c2f8802#;
   pragma Export (C, u00025, "system__img_intB");
   u00026 : constant Version_32 := 16#61fd2048#;
   pragma Export (C, u00026, "system__img_intS");
   u00027 : constant Version_32 := 16#39a03df9#;
   pragma Export (C, u00027, "system__storage_elementsB");
   u00028 : constant Version_32 := 16#4ee58a8e#;
   pragma Export (C, u00028, "system__storage_elementsS");
   u00029 : constant Version_32 := 16#39df8c17#;
   pragma Export (C, u00029, "system__tracebackB");
   u00030 : constant Version_32 := 16#3d041e4e#;
   pragma Export (C, u00030, "system__tracebackS");
   u00031 : constant Version_32 := 16#9ed49525#;
   pragma Export (C, u00031, "system__traceback_entriesB");
   u00032 : constant Version_32 := 16#637d36fa#;
   pragma Export (C, u00032, "system__traceback_entriesS");
   u00033 : constant Version_32 := 16#0162f862#;
   pragma Export (C, u00033, "system__traceback__symbolicB");
   u00034 : constant Version_32 := 16#dd19f67a#;
   pragma Export (C, u00034, "system__traceback__symbolicS");
   u00035 : constant Version_32 := 16#701f9d88#;
   pragma Export (C, u00035, "ada__exceptions__tracebackB");
   u00036 : constant Version_32 := 16#20245e75#;
   pragma Export (C, u00036, "ada__exceptions__tracebackS");
   u00037 : constant Version_32 := 16#5ab55268#;
   pragma Export (C, u00037, "interfacesS");
   u00038 : constant Version_32 := 16#769e25e6#;
   pragma Export (C, u00038, "interfaces__cB");
   u00039 : constant Version_32 := 16#70be4e8c#;
   pragma Export (C, u00039, "interfaces__cS");
   u00040 : constant Version_32 := 16#5f72f755#;
   pragma Export (C, u00040, "system__address_operationsB");
   u00041 : constant Version_32 := 16#702a7eb9#;
   pragma Export (C, u00041, "system__address_operationsS");
   u00042 : constant Version_32 := 16#13b71684#;
   pragma Export (C, u00042, "system__crtlS");
   u00043 : constant Version_32 := 16#f82008fb#;
   pragma Export (C, u00043, "system__dwarf_linesB");
   u00044 : constant Version_32 := 16#0aa7ccc7#;
   pragma Export (C, u00044, "system__dwarf_linesS");
   u00045 : constant Version_32 := 16#12c24a43#;
   pragma Export (C, u00045, "ada__charactersS");
   u00046 : constant Version_32 := 16#8f637df8#;
   pragma Export (C, u00046, "ada__characters__handlingB");
   u00047 : constant Version_32 := 16#3b3f6154#;
   pragma Export (C, u00047, "ada__characters__handlingS");
   u00048 : constant Version_32 := 16#4b7bb96a#;
   pragma Export (C, u00048, "ada__characters__latin_1S");
   u00049 : constant Version_32 := 16#af50e98f#;
   pragma Export (C, u00049, "ada__stringsS");
   u00050 : constant Version_32 := 16#e2ea8656#;
   pragma Export (C, u00050, "ada__strings__mapsB");
   u00051 : constant Version_32 := 16#1e526bec#;
   pragma Export (C, u00051, "ada__strings__mapsS");
   u00052 : constant Version_32 := 16#04ec3c16#;
   pragma Export (C, u00052, "system__bit_opsB");
   u00053 : constant Version_32 := 16#0765e3a3#;
   pragma Export (C, u00053, "system__bit_opsS");
   u00054 : constant Version_32 := 16#57a0bc09#;
   pragma Export (C, u00054, "system__unsigned_typesS");
   u00055 : constant Version_32 := 16#92f05f13#;
   pragma Export (C, u00055, "ada__strings__maps__constantsS");
   u00056 : constant Version_32 := 16#57a37a42#;
   pragma Export (C, u00056, "system__address_imageB");
   u00057 : constant Version_32 := 16#c2ca5db0#;
   pragma Export (C, u00057, "system__address_imageS");
   u00058 : constant Version_32 := 16#ec78c2bf#;
   pragma Export (C, u00058, "system__img_unsB");
   u00059 : constant Version_32 := 16#c85480fe#;
   pragma Export (C, u00059, "system__img_unsS");
   u00060 : constant Version_32 := 16#d7aac20c#;
   pragma Export (C, u00060, "system__ioB");
   u00061 : constant Version_32 := 16#fd6437c5#;
   pragma Export (C, u00061, "system__ioS");
   u00062 : constant Version_32 := 16#cf909744#;
   pragma Export (C, u00062, "system__object_readerB");
   u00063 : constant Version_32 := 16#27c18a1d#;
   pragma Export (C, u00063, "system__object_readerS");
   u00064 : constant Version_32 := 16#1a74a354#;
   pragma Export (C, u00064, "system__val_lliB");
   u00065 : constant Version_32 := 16#f902262a#;
   pragma Export (C, u00065, "system__val_lliS");
   u00066 : constant Version_32 := 16#afdbf393#;
   pragma Export (C, u00066, "system__val_lluB");
   u00067 : constant Version_32 := 16#2d52eb7b#;
   pragma Export (C, u00067, "system__val_lluS");
   u00068 : constant Version_32 := 16#27b600b2#;
   pragma Export (C, u00068, "system__val_utilB");
   u00069 : constant Version_32 := 16#cf867674#;
   pragma Export (C, u00069, "system__val_utilS");
   u00070 : constant Version_32 := 16#d1060688#;
   pragma Export (C, u00070, "system__case_utilB");
   u00071 : constant Version_32 := 16#472fa95d#;
   pragma Export (C, u00071, "system__case_utilS");
   u00072 : constant Version_32 := 16#84a27f0d#;
   pragma Export (C, u00072, "interfaces__c_streamsB");
   u00073 : constant Version_32 := 16#b1330297#;
   pragma Export (C, u00073, "interfaces__c_streamsS");
   u00074 : constant Version_32 := 16#931ff6be#;
   pragma Export (C, u00074, "system__exception_tracesB");
   u00075 : constant Version_32 := 16#47f9e010#;
   pragma Export (C, u00075, "system__exception_tracesS");
   u00076 : constant Version_32 := 16#8c33a517#;
   pragma Export (C, u00076, "system__wch_conB");
   u00077 : constant Version_32 := 16#785be258#;
   pragma Export (C, u00077, "system__wch_conS");
   u00078 : constant Version_32 := 16#9721e840#;
   pragma Export (C, u00078, "system__wch_stwB");
   u00079 : constant Version_32 := 16#554ace59#;
   pragma Export (C, u00079, "system__wch_stwS");
   u00080 : constant Version_32 := 16#a831679c#;
   pragma Export (C, u00080, "system__wch_cnvB");
   u00081 : constant Version_32 := 16#77ec58ab#;
   pragma Export (C, u00081, "system__wch_cnvS");
   u00082 : constant Version_32 := 16#ece6fdb6#;
   pragma Export (C, u00082, "system__wch_jisB");
   u00083 : constant Version_32 := 16#f79c418a#;
   pragma Export (C, u00083, "system__wch_jisS");
   u00084 : constant Version_32 := 16#41837d1e#;
   pragma Export (C, u00084, "system__stack_checkingB");
   u00085 : constant Version_32 := 16#ed99ab62#;
   pragma Export (C, u00085, "system__stack_checkingS");
   u00086 : constant Version_32 := 16#920eada5#;
   pragma Export (C, u00086, "ada__tagsB");
   u00087 : constant Version_32 := 16#13ca27f3#;
   pragma Export (C, u00087, "ada__tagsS");
   u00088 : constant Version_32 := 16#c3335bfd#;
   pragma Export (C, u00088, "system__htableB");
   u00089 : constant Version_32 := 16#e7e47360#;
   pragma Export (C, u00089, "system__htableS");
   u00090 : constant Version_32 := 16#089f5cd0#;
   pragma Export (C, u00090, "system__string_hashB");
   u00091 : constant Version_32 := 16#45ba181e#;
   pragma Export (C, u00091, "system__string_hashS");
   u00092 : constant Version_32 := 16#d5bfa9f3#;
   pragma Export (C, u00092, "ada__text_ioB");
   u00093 : constant Version_32 := 16#8d734ca7#;
   pragma Export (C, u00093, "ada__text_ioS");
   u00094 : constant Version_32 := 16#10558b11#;
   pragma Export (C, u00094, "ada__streamsB");
   u00095 : constant Version_32 := 16#2e6701ab#;
   pragma Export (C, u00095, "ada__streamsS");
   u00096 : constant Version_32 := 16#db5c917c#;
   pragma Export (C, u00096, "ada__io_exceptionsS");
   u00097 : constant Version_32 := 16#b29d05bd#;
   pragma Export (C, u00097, "system__file_ioB");
   u00098 : constant Version_32 := 16#c45721ef#;
   pragma Export (C, u00098, "system__file_ioS");
   u00099 : constant Version_32 := 16#cf417de3#;
   pragma Export (C, u00099, "ada__finalizationS");
   u00100 : constant Version_32 := 16#95817ed8#;
   pragma Export (C, u00100, "system__finalization_rootB");
   u00101 : constant Version_32 := 16#2cd4b31a#;
   pragma Export (C, u00101, "system__finalization_rootS");
   u00102 : constant Version_32 := 16#d3560627#;
   pragma Export (C, u00102, "system__os_libB");
   u00103 : constant Version_32 := 16#bf5ce13f#;
   pragma Export (C, u00103, "system__os_libS");
   u00104 : constant Version_32 := 16#1a817b8e#;
   pragma Export (C, u00104, "system__stringsB");
   u00105 : constant Version_32 := 16#1d99d1ec#;
   pragma Export (C, u00105, "system__stringsS");
   u00106 : constant Version_32 := 16#9eb95a22#;
   pragma Export (C, u00106, "system__file_control_blockS");
   u00107 : constant Version_32 := 16#2a5afc2f#;
   pragma Export (C, u00107, "fun_dfaB");
   u00108 : constant Version_32 := 16#0db0081f#;
   pragma Export (C, u00108, "fun_dfaS");
   u00109 : constant Version_32 := 16#1b2c028a#;
   pragma Export (C, u00109, "fun_ioB");
   u00110 : constant Version_32 := 16#6704e555#;
   pragma Export (C, u00110, "fun_ioS");
   u00111 : constant Version_32 := 16#608e2cd1#;
   pragma Export (C, u00111, "system__concat_5B");
   u00112 : constant Version_32 := 16#e47883a4#;
   pragma Export (C, u00112, "system__concat_5S");
   u00113 : constant Version_32 := 16#932a4690#;
   pragma Export (C, u00113, "system__concat_4B");
   u00114 : constant Version_32 := 16#1d42ebaa#;
   pragma Export (C, u00114, "system__concat_4S");
   u00115 : constant Version_32 := 16#2b70b149#;
   pragma Export (C, u00115, "system__concat_3B");
   u00116 : constant Version_32 := 16#68569c2f#;
   pragma Export (C, u00116, "system__concat_3S");
   u00117 : constant Version_32 := 16#fd83e873#;
   pragma Export (C, u00117, "system__concat_2B");
   u00118 : constant Version_32 := 16#6186175a#;
   pragma Export (C, u00118, "system__concat_2S");
   u00119 : constant Version_32 := 16#7dbbd31d#;
   pragma Export (C, u00119, "text_ioS");
   u00120 : constant Version_32 := 16#6a82149a#;
   pragma Export (C, u00120, "fun_tokensS");
   u00121 : constant Version_32 := 16#5a629ca4#;
   pragma Export (C, u00121, "declsS");
   u00122 : constant Version_32 := 16#330d1b0f#;
   pragma Export (C, u00122, "decls__d_treeS");
   u00123 : constant Version_32 := 16#1b6af8d9#;
   pragma Export (C, u00123, "decls__general_defsS");
   u00124 : constant Version_32 := 16#c79d24a8#;
   pragma Export (C, u00124, "lexical_aB");
   u00125 : constant Version_32 := 16#274b214b#;
   pragma Export (C, u00125, "lexical_aS");
   u00126 : constant Version_32 := 16#67260816#;
   pragma Export (C, u00126, "semanticB");
   u00127 : constant Version_32 := 16#efd2edca#;
   pragma Export (C, u00127, "semanticS");
   u00128 : constant Version_32 := 16#c46fba7e#;
   pragma Export (C, u00128, "semantic__messagesB");
   u00129 : constant Version_32 := 16#c66c25cc#;
   pragma Export (C, u00129, "semantic__messagesS");
   u00130 : constant Version_32 := 16#f46f6f7d#;
   pragma Export (C, u00130, "decls__d_lc_treeS");
   u00131 : constant Version_32 := 16#47e5afcb#;
   pragma Export (C, u00131, "decls__d_names_tableB");
   u00132 : constant Version_32 := 16#dc9e9f7d#;
   pragma Export (C, u00132, "decls__d_names_tableS");
   u00133 : constant Version_32 := 16#75de1dee#;
   pragma Export (C, u00133, "ada__strings__hashB");
   u00134 : constant Version_32 := 16#3655ad4c#;
   pragma Export (C, u00134, "ada__strings__hashS");
   u00135 : constant Version_32 := 16#5e196e91#;
   pragma Export (C, u00135, "ada__containersS");
   u00136 : constant Version_32 := 16#f7815c90#;
   pragma Export (C, u00136, "decls__d_symbol_tableB");
   u00137 : constant Version_32 := 16#e0e10993#;
   pragma Export (C, u00137, "decls__d_symbol_tableS");
   u00138 : constant Version_32 := 16#9715e2e7#;
   pragma Export (C, u00138, "decls__d_descriptionS");
   u00139 : constant Version_32 := 16#2ad27ceb#;
   pragma Export (C, u00139, "semantic__c_treeB");
   u00140 : constant Version_32 := 16#77971d79#;
   pragma Export (C, u00140, "semantic__c_treeS");
   u00141 : constant Version_32 := 16#d763507a#;
   pragma Export (C, u00141, "system__val_intB");
   u00142 : constant Version_32 := 16#2b83eab5#;
   pragma Export (C, u00142, "system__val_intS");
   u00143 : constant Version_32 := 16#1d9142a4#;
   pragma Export (C, u00143, "system__val_unsB");
   u00144 : constant Version_32 := 16#47085132#;
   pragma Export (C, u00144, "system__val_unsS");
   u00145 : constant Version_32 := 16#cc91ea10#;
   pragma Export (C, u00145, "semantic__c_lc_treeB");
   u00146 : constant Version_32 := 16#10146a9c#;
   pragma Export (C, u00146, "semantic__c_lc_treeS");
   u00147 : constant Version_32 := 16#4a2d972a#;
   pragma Export (C, u00147, "semantic__type_checkingB");
   u00148 : constant Version_32 := 16#d8a85ae4#;
   pragma Export (C, u00148, "semantic__type_checkingS");
   u00149 : constant Version_32 := 16#a83b7c85#;
   pragma Export (C, u00149, "system__concat_6B");
   u00150 : constant Version_32 := 16#b1e1ed38#;
   pragma Export (C, u00150, "system__concat_6S");
   u00151 : constant Version_32 := 16#6945aa05#;
   pragma Export (C, u00151, "decls__d_vtype_tableB");
   u00152 : constant Version_32 := 16#61354aad#;
   pragma Export (C, u00152, "decls__d_vtype_tableS");
   u00153 : constant Version_32 := 16#a1681889#;
   pragma Export (C, u00153, "syntactic_aB");
   u00154 : constant Version_32 := 16#3e726665#;
   pragma Export (C, u00154, "syntactic_aS");
   u00155 : constant Version_32 := 16#f6ae94e4#;
   pragma Export (C, u00155, "fun_gotoS");
   u00156 : constant Version_32 := 16#86ec8811#;
   pragma Export (C, u00156, "fun_shift_reduceS");
   u00157 : constant Version_32 := 16#d0432c8d#;
   pragma Export (C, u00157, "system__img_enum_newB");
   u00158 : constant Version_32 := 16#026ac64a#;
   pragma Export (C, u00158, "system__img_enum_newS");
   u00159 : constant Version_32 := 16#a6359005#;
   pragma Export (C, u00159, "system__memoryB");
   u00160 : constant Version_32 := 16#3a5ba6be#;
   pragma Export (C, u00160, "system__memoryS");
   --  BEGIN ELABORATION ORDER
   --  ada%s
   --  ada.characters%s
   --  ada.characters.handling%s
   --  ada.characters.latin_1%s
   --  ada.command_line%s
   --  interfaces%s
   --  system%s
   --  system.address_operations%s
   --  system.address_operations%b
   --  system.case_util%s
   --  system.case_util%b
   --  system.htable%s
   --  system.img_enum_new%s
   --  system.img_enum_new%b
   --  system.img_int%s
   --  system.img_int%b
   --  system.io%s
   --  system.io%b
   --  system.parameters%s
   --  system.parameters%b
   --  system.crtl%s
   --  interfaces.c_streams%s
   --  interfaces.c_streams%b
   --  system.standard_library%s
   --  system.exceptions_debug%s
   --  system.exceptions_debug%b
   --  system.storage_elements%s
   --  system.storage_elements%b
   --  system.stack_checking%s
   --  system.stack_checking%b
   --  system.string_hash%s
   --  system.string_hash%b
   --  system.htable%b
   --  system.strings%s
   --  system.strings%b
   --  system.os_lib%s
   --  system.traceback_entries%s
   --  system.traceback_entries%b
   --  ada.exceptions%s
   --  system.soft_links%s
   --  system.unsigned_types%s
   --  system.img_uns%s
   --  system.img_uns%b
   --  system.val_int%s
   --  system.val_lli%s
   --  system.val_llu%s
   --  system.val_uns%s
   --  system.val_util%s
   --  system.val_util%b
   --  system.val_uns%b
   --  system.val_llu%b
   --  system.val_lli%b
   --  system.val_int%b
   --  system.wch_con%s
   --  system.wch_con%b
   --  system.wch_cnv%s
   --  system.wch_jis%s
   --  system.wch_jis%b
   --  system.wch_cnv%b
   --  system.wch_stw%s
   --  system.wch_stw%b
   --  ada.exceptions.last_chance_handler%s
   --  ada.exceptions.last_chance_handler%b
   --  ada.exceptions.traceback%s
   --  system.address_image%s
   --  system.bit_ops%s
   --  system.bit_ops%b
   --  system.concat_2%s
   --  system.concat_2%b
   --  system.concat_3%s
   --  system.concat_3%b
   --  system.concat_4%s
   --  system.concat_4%b
   --  system.concat_5%s
   --  system.concat_5%b
   --  system.concat_6%s
   --  system.concat_6%b
   --  system.exception_table%s
   --  system.exception_table%b
   --  ada.containers%s
   --  ada.io_exceptions%s
   --  ada.strings%s
   --  ada.strings.hash%s
   --  ada.strings.hash%b
   --  ada.strings.maps%s
   --  ada.strings.maps.constants%s
   --  ada.tags%s
   --  ada.streams%s
   --  ada.streams%b
   --  interfaces.c%s
   --  system.exceptions%s
   --  system.exceptions%b
   --  system.exceptions.machine%s
   --  system.file_control_block%s
   --  system.file_io%s
   --  system.finalization_root%s
   --  system.finalization_root%b
   --  ada.finalization%s
   --  system.exception_traces%s
   --  system.exception_traces%b
   --  system.memory%s
   --  system.memory%b
   --  system.standard_library%b
   --  system.object_reader%s
   --  system.dwarf_lines%s
   --  system.secondary_stack%s
   --  system.file_io%b
   --  interfaces.c%b
   --  ada.tags%b
   --  ada.strings.maps%b
   --  system.soft_links%b
   --  system.os_lib%b
   --  ada.command_line%b
   --  ada.characters.handling%b
   --  system.secondary_stack%b
   --  system.dwarf_lines%b
   --  system.object_reader%b
   --  system.address_image%b
   --  ada.exceptions.traceback%b
   --  system.traceback%s
   --  system.traceback%b
   --  system.traceback.symbolic%s
   --  system.traceback.symbolic%b
   --  ada.exceptions%b
   --  ada.text_io%s
   --  ada.text_io%b
   --  text_io%s
   --  decls%s
   --  decls.general_defs%s
   --  decls.d_lc_tree%s
   --  decls.d_names_table%s
   --  decls.d_names_table%b
   --  decls.d_tree%s
   --  decls.d_description%s
   --  decls.d_symbol_table%s
   --  decls.d_symbol_table%b
   --  decls.d_vtype_table%s
   --  decls.d_vtype_table%b
   --  fun_dfa%s
   --  fun_dfa%b
   --  fun_goto%s
   --  fun_io%s
   --  fun_io%b
   --  fun_shift_reduce%s
   --  fun_tokens%s
   --  lexical_a%s
   --  semantic%s
   --  semantic.c_lc_tree%s
   --  semantic.c_lc_tree%b
   --  semantic.messages%s
   --  semantic.messages%b
   --  semantic%b
   --  semantic.c_tree%s
   --  semantic.c_tree%b
   --  lexical_a%b
   --  semantic.type_checking%s
   --  semantic.type_checking%b
   --  syntactic_a%s
   --  syntactic_a%b
   --  fun%b
   --  END ELABORATION ORDER


end ada_main;
