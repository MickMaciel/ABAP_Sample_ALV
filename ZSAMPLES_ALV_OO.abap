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
  