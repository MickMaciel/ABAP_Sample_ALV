*&---------------------------------------------------------------------*
*& Report ZSAMPLES_ALV_OO
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zsamples_alv_oo.

INCLUDE zsamples_alv_oo_top.
INCLUDE zsamples_alv_oo_sel.
INCLUDE zsamples_alv_oo_def.
INCLUDE zsamples_alv_oo_imp.

DATA o_report TYPE REF TO lcl_report_alv.
DATA l_change TYPE c.

START-OF-SELECTION.
  o_report = lcl_report_alv=>factoty( )->get_data(
                                      EXPORTING
                                        im_type    = 'M'
*                                      IMPORTING
*                                        ex_exemplo =
                                      CHANGING
                                        ch_exempl  = l_change ).
*  IF o_report->get_data(
*    EXPORTING
*     im_type = 'X'
*    CHANGING
*     ch_exempl = l_change ) = abap_true.
*  ENDIF.

END-OF-SELECTION.
  IF o_report->hasdata( ) = abap_true.
    o_report->output_alv( ).
  ENDIF.


*&---------------------------------------------------------------------*
*&  Include           ZSAMPLES_ALV_OO_TOP
*&---------------------------------------------------------------------*

TABLES: SPFLI.


*&---------------------------------------------------------------------*
*&  Include           ZSAMPLES_ALV_OO_SEL
*&---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS: s_carrid FOR spfli-carrid.
SELECTION-SCREEN END OF BLOCK b1.


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


*&---------------------------------------------------------------------*
*&  Include           ZSAMPLES_ALV_OO_IMP
*&---------------------------------------------------------------------*
CLASS lcl_report_alv IMPLEMENTATION.

    METHOD hasdata.
      re_has_data = me->has_data.
    ENDMETHOD.
  
    METHOD factoty.
      IF my_instance IS NOT BOUND.
        CREATE OBJECT my_instance.
      ENDIF.
      re_instance = my_instance.
    ENDMETHOD.
  
    METHOD get_data.
      has_data = abap_false.
      SELECT * FROM spfli
        INTO CORRESPONDING FIELDS OF TABLE gt_data_table
        WHERE carrid IN s_carrid.
      IF sy-subrc IS INITIAL.
        has_data = abap_true.
      ENDIF.
      process_data( ).
      re_instance = my_instance.
    ENDMETHOD.
  
    METHOD output_alv.
      DATA local_object        TYPE REF TO cl_salv_table.
      DATA local_functions     TYPE REF TO cl_salv_functions_list.
      DATA local_object_fields TYPE REF TO cl_salv_columns_table.
      DATA local_object_column TYPE REF TO  cl_salv_column.
      DATA local_layout        TYPE REF TO cl_salv_layout.
      DATA layout_key          TYPE salv_s_layout_key.
      DATA tooltip             TYPE lvc_tip.
  
      CALL METHOD cl_salv_table=>factory
        IMPORTING
          r_salv_table = local_object
        CHANGING
          t_table      = gt_output.
  
      CALL METHOD local_object->display.
  
    ENDMETHOD.
  
    METHOD process_data.
      SELECT carrid carrname
        FROM scarr
        INTO TABLE gt_scarr
        FOR ALL ENTRIES IN gt_data_table
        WHERE carrid = gt_data_table-carrid.
      LOOP AT gt_data_table ASSIGNING FIELD-SYMBOL(<line_data>).
        APPEND INITIAL LINE TO gt_output
          ASSIGNING FIELD-SYMBOL(<output>).
        MOVE-CORRESPONDING <line_data> TO <output>.
        READ TABLE gt_scarr
          INTO DATA(ls_carr)  "<<< só a partir do abap 7.5
          WITH KEY carrid = <output>-carrid
          BINARY SEARCH.
        "<output>-carrname = gt_scarr[ carrid = <output>-carrid ]-carrname.
        IF sy-subrc IS INITIAL.
          <output>-carrname = ls_carr-carrname.
        ENDIF.
      ENDLOOP.
    ENDMETHOD.
  ENDCLASS.  