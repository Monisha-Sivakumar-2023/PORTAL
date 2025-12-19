FUNCTION zfm_inquiry_866.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IV_CUSTOMER_ID) TYPE  KUNNR
*"  EXPORTING
*"     VALUE(ET_INQUIRY) TYPE  ZINQUIRY_866_T
*"----------------------------------------------------------------------

  DATA: lt_vbak   TYPE TABLE OF vbak,
        lt_vbap   TYPE TABLE OF vbap,
        wa_vbak   TYPE vbak,
        wa_vbap   TYPE vbap,
        wa_result TYPE zinquiry_866_s,
        lv_kunnr  TYPE kunnr,
        lv_matnr  TYPE matnr.

  " Convert input customer number to internal format (add leading zeros)
  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = iv_customer_id
    IMPORTING
      output = lv_kunnr.

  " Get Inquiry Header data from VBAK (inquiry type: AUART like 'AF%')
  SELECT * FROM vbak
    INTO TABLE lt_vbak
    WHERE kunnr = lv_kunnr
      AND auart LIKE 'AF%'.

  IF sy-subrc = 0.
    LOOP AT lt_vbak INTO wa_vbak.

      " Get the item data from VBAP for the current inquiry
      SELECT * FROM vbap
        INTO TABLE lt_vbap
        WHERE vbeln = wa_vbak-vbeln.

      LOOP AT lt_vbap INTO wa_vbap.
        CLEAR wa_result.

        wa_result-vbeln  = wa_vbak-vbeln.   " Inquiry number
        wa_result-erdat  = wa_vbak-erdat.   " Created on
        wa_result-vrkme  = wa_vbap-vrkme.   " Sales unit

        " Convert MATNR to external format (remove leading zeros)
        lv_matnr = wa_vbap-matnr.
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
          EXPORTING
            input  = lv_matnr
          IMPORTING
            output = lv_matnr.
        wa_result-matnr  = lv_matnr.

        wa_result-arktx  = wa_vbap-arktx.   " Material description
        wa_result-kwmeng = wa_vbap-kwmeng.  " Order quantity
        wa_result-netwr  = wa_vbap-netwr.   " Net value
        wa_result-waerk  = wa_vbak-waerk.   " Currency
        wa_result-meins  = wa_vbap-meins.   " Base unit of measure

        APPEND wa_result TO et_inquiry.
      ENDLOOP.

    ENDLOOP.
  ENDIF.



ENDFUNCTION.
