FUNCTION ZFM_LISTDELIVERIES_866.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IV_CUSTOMER_ID) TYPE  KUNNR
*"  EXPORTING
*"     VALUE(ET_DELIVERY) TYPE  ZLIST_DELIVERIES_866_T
*"----------------------------------------------------------------------

DATA: lt_likp   TYPE TABLE OF likp,
        lt_lips   TYPE TABLE OF lips,
        wa_likp   TYPE likp,
        wa_lips   TYPE lips,
        wa_result TYPE ZLIST_DELIVERIES_829_S,
        lv_kunnr  TYPE kunnr,
        lv_matnr  TYPE matnr.

  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = IV_customer_id
    IMPORTING
      output = lv_kunnr.


  SELECT * FROM likp
    INTO TABLE lt_likp
    WHERE kunnr = lv_kunnr.

  IF sy-subrc = 0.
    LOOP AT lt_likp INTO wa_likp.


      SELECT * FROM lips
        INTO TABLE lt_lips
        WHERE vbeln = wa_likp-vbeln.

      LOOP AT lt_lips INTO wa_lips.
        CLEAR wa_result.

        wa_result-vbeln_VL  = wa_likp-vbeln.
        wa_result-vstel = wa_likp-vstel.
        wa_result-erdat  = wa_likp-erdat.
        wa_result-POSNR_VL = wa_lips-posnr.
        lv_matnr = wa_lips-matnr.
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
          EXPORTING
            input  = lv_matnr
          IMPORTING
            output = lv_matnr.
        wa_result-matnr  = lv_matnr.
        wa_result-arktx  = wa_lips-arktx.
        wa_result-lfimg  = wa_lips-lfimg.
        wa_result-vrkme  = wa_lips-vrkme.

        APPEND wa_result TO et_delivery.
      ENDLOOP.

    ENDLOOP.
  ENDIF.



ENDFUNCTION.
