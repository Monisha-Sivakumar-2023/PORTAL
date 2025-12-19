FUNCTION ZFM_VENDOR_QUOTATION_866.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IV_VENDOR_ID) TYPE  LIFNR
*"  EXPORTING
*"     VALUE(ET_QUOTATION) TYPE  ZVENDORQUOTATION_829_T
*"----------------------------------------------------------------------


DATA: lv_vendor_id TYPE lifnr.
  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = iv_vendor_id
    IMPORTING
      output = lv_vendor_id.
  CALL METHOD zvend_quotation_866=>get_data
    EXPORTING
      i_vendor_id  = lv_vendor_id
    IMPORTING
      et_quotation = et_quotation.


ENDFUNCTION.
