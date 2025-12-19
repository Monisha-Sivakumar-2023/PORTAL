FUNCTION ZFM_MEMO_866.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IV_CUSTOMER_ID) TYPE  KUNNR
*"  EXPORTING
*"     VALUE(ET_MEMO) TYPE  ZMEMO_866_T
*"----------------------------------------------------------------------


DATA: lv_kunnr     TYPE kunnr,
        lt_vbrk      TYPE TABLE OF vbrk,
        wa_memo      TYPE ZMEMO_829_S.


  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = IV_customer_id
    IMPORTING
      output = lv_kunnr.


  SELECT * FROM vbrk
    INTO TABLE lt_vbrk
    WHERE kunrg = lv_kunnr AND
          fkart IN ('G2', 'L2').

  LOOP AT lt_vbrk INTO DATA(wa_vbrk).
    CLEAR wa_memo.

    wa_memo-vbeln     = wa_vbrk-vbeln.
    wa_memo-fkart     = wa_vbrk-fkart.
    wa_memo-fkdat     = wa_vbrk-fkdat.
    wa_memo-netwr     = wa_vbrk-netwr.
    wa_memo-waerk     = wa_vbrk-waerk.

    " Determine memo type
    IF wa_vbrk-fkart = 'G2'.
      wa_memo-memo_type = 'CREDIT'.
    ELSEIF wa_vbrk-fkart = 'L2'.
      wa_memo-memo_type = 'DEBIT'.
    ELSE.
      wa_memo-memo_type = 'UNKNOWN'.
    ENDIF.

    APPEND wa_memo TO et_memo.
  ENDLOOP.


ENDFUNCTION.
