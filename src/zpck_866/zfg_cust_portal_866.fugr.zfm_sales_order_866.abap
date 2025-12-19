FUNCTION ZFM_SALES_ORDER_866.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IV_CUSTOMER_ID) TYPE  KUNNR
*"  EXPORTING
*"     VALUE(ET_SALESORDER) TYPE  ZSALES_ORDER_866_T
*"----------------------------------------------------------------------

DATA: lt_vbak     TYPE TABLE OF vbak,
        lt_vbap     TYPE TABLE OF vbap,
        wa_vbak     TYPE vbak,
        wa_vbap     TYPE vbap,
        wa_result   TYPE ZSALES_ORDER_866_S,
        lv_kunnr    TYPE kunnr,
        lv_matnr  TYPE matnr.


  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = iv_customer_id
    IMPORTING
      output = lv_kunnr.


  SELECT * FROM vbak
    INTO TABLE lt_vbak
    WHERE kunnr = lv_kunnr.

    LOOP AT lt_vbak INTO wa_vbak.


      SELECT * FROM vbap
        INTO TABLE lt_vbap
        WHERE vbeln = wa_vbak-vbeln.

      LOOP AT lt_vbap INTO wa_vbap.
        CLEAR wa_result.

        wa_result-vbeln  = wa_vbak-vbeln.
        wa_result-erdat  = wa_vbak-erdat.
        wa_result-vrkme  = wa_vbap-vrkme.
        " Convert MATNR to external format (remove leading zeros)
        lv_matnr = wa_vbap-matnr.
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
          EXPORTING
            input  = lv_matnr
          IMPORTING
            output = lv_matnr.
        wa_result-matnr  = lv_matnr.

        wa_result-arktx  = wa_vbap-arktx.
        wa_result-kwmeng = wa_vbap-kwmeng.
        wa_result-netwr  = wa_vbap-netwr.
        wa_result-waerk  = wa_vbak-waerk.
        wa_result-meins  = wa_vbap-meins.

        APPEND wa_result TO et_salesorder.
      ENDLOOP.

    ENDLOOP.



ENDFUNCTION.
