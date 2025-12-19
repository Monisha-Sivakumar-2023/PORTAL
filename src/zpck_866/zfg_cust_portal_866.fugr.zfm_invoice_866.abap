FUNCTION zfm_invoice_866.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IV_CUSTOMER_ID) TYPE  KUNNR
*"  EXPORTING
*"     VALUE(ET_INVOICE) TYPE  ZINVOICE_866_T
*"----------------------------------------------------------------------


  DATA: lv_customer TYPE kunag.

  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = iv_customer_id
    IMPORTING
      output = lv_customer.
  SELECT vbeln, fkdat, netwr, waerk, kunag, kunrg, vkorg, vtweg, erdat
    FROM vbrk
    WHERE kunag = @lv_customer
      AND fksto IS INITIAL
      AND vbtyp = 'M'
    INTO CORRESPONDING FIELDS OF TABLE @et_invoice.

  SORT et_invoice BY vbeln.


ENDFUNCTION.
