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