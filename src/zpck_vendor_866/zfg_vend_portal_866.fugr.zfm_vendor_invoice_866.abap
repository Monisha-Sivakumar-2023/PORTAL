FUNCTION ZFM_VENDOR_INVOICE_866.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IV_VENDOR_ID) TYPE  LIFNR
*"  EXPORTING
*"     VALUE(ET_INVOICE) TYPE  ZVENDORINVOICE_866_T
*"----------------------------------------------------------------------


DATA: lv_vendor_id TYPE lifnr.

CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
  EXPORTING
    input  = iv_vendor_id
  IMPORTING
    output = lv_vendor_id.

zvend_invoice_866=>get_data(
  EXPORTING
    i_vendor_id = lv_vendor_id
  IMPORTING
    et_invoice  = et_invoice ).


ENDFUNCTION.
