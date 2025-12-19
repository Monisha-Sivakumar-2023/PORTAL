FUNCTION ZFM_VENDOR_MEMO_866.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IV_VENDOR_ID) TYPE  LIFNR
*"  EXPORTING
*"     VALUE(ET_MEMO) TYPE  ZVENDORMEMO_866_T
*"----------------------------------------------------------------------


DATA: lv_vendor_id TYPE lifnr.
  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = iv_vendor_id
    IMPORTING
      output = lv_vendor_id.
  CALL METHOD zvend_memo_866=>get_data
    EXPORTING
      i_vendor_id = lv_vendor_id
    IMPORTING
      et_memo     = et_memo.


ENDFUNCTION.
