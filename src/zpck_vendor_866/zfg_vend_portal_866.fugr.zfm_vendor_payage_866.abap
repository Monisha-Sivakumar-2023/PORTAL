FUNCTION ZFM_VENDOR_PAYAGE_866.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IV_VENDOR_ID) TYPE  LIFNR
*"  EXPORTING
*"     VALUE(ET_PAYAGE) TYPE  ZVENDORPAYAGE_866_T
*"----------------------------------------------------------------------


DATA: lv_vendor_id TYPE lifnr,ls_row   TYPE ZVENDORPAYAGE_866_S,
        lv_aging TYPE i..
  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = iv_vendor_id
    IMPORTING
      output = lv_vendor_id.
  CALL METHOD zvend_payage_866=>get_data
    EXPORTING
      i_vendor_id = lv_vendor_id
    IMPORTING
      et_payage   = et_payage
      .
  LOOP AT et_payage INTO ls_row.
    IF ls_row-due_date IS NOT INITIAL.
      lv_aging = sy-datum - ls_row-due_date.
      ls_row-aging = lv_aging.
    ELSE.
      ls_row-aging = 0.
    ENDIF.
    MODIFY et_payage FROM ls_row.
  ENDLOOP.


ENDFUNCTION.
