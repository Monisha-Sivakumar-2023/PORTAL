FUNCTION ZFM_VENDOR_GOODS_RECEIPT_866.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IV_VENDOR_ID) TYPE  LIFNR
*"  EXPORTING
*"     VALUE(ET_GOODS_RECEIPT) TYPE  ZVENDORGOODSRECEIPT_866_T
*"----------------------------------------------------------------------


DATA: lv_vendor_id TYPE lifnr,
         lt_mseg type table of mseg.

  " Convert external 100000 -> internal 0000100000
  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = iv_vendor_id
    IMPORTING
      output = lv_vendor_id.

  zvend_goods_receipt_866=>get_data(
    EXPORTING
      i_vendor_id = lv_vendor_id
    IMPORTING
      et_gr_data  = et_goods_receipt ).
select * from mseg into TABLE lt_mseg where mseg~lifnr = lv_vendor_id.


ENDFUNCTION.
