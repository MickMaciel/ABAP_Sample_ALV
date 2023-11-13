*&---------------------------------------------------------------------*
*&  Include           ZSAMPLES_ALV_OO_DEF
*&---------------------------------------------------------------------*
CLASS lcl_report_alv DEFINITION.
    PUBLIC SECTION.
      CLASS-DATA:
         my_instance TYPE REF TO lcl_report_alv.
  "    DATA: gt_output TYPE TABLE OF spfli.
  
      CLASS-METHODS:
        factoty
          RETURNING VALUE(re_instance) TYPE REF TO lcl_report_alv.
  
      METHODS:
        get_data
          IMPORTING
                    im_type         TYPE c
          EXPORTING
                    ex_exemplo      TYPE c
          CHANGING
                    ch_exempl       TYPE c
          "RETURNING VALUE(has_data) TYPE abap_bool,
        RETURNING VALUE(re_instance) TYPE REF TO lcl_report_alv,
       output_alv,
       hasdata
        RETURNING VALUE(re_has_data) TYPE abap_bool.
  
    PRIVATE SECTION.
    DATA: has_data TYPE abap_bool.
      DATA: gt_data_table TYPE TABLE OF spfli.
      TYPES:
        BEGIN OF ty_scarr,
          carrid   TYPE scarr-carrid,
          carrname TYPE scarr-carrname,
        END OF ty_scarr.
      TYPES:
        BEGIN OF ty_output.
          INCLUDE TYPE spfli.
      TYPES:
        carrname TYPE scarr-carrname,
        END OF ty_output.
  
      DATA gt_scarr TYPE TABLE OF ty_scarr.
      DATA gt_output TYPE TABLE OF ty_output.
      METHODS:
        process_data.
  ENDCLASS.
