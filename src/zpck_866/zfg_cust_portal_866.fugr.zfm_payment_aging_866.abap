FUNCTION ZFM_PAYMENT_AGING_866.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IV_CUSTOMER_ID) TYPE  KUNNR
*"  EXPORTING
*"     VALUE(ET_PAYMENTS_AGING) TYPE  ZPAYMENTS_AGING_866_T
*"----------------------------------------------------------------------


DATA: lv_kunnr TYPE kunnr,
        lv_days  TYPE i,
        ls_line  TYPE ZPAYMENTS_AGING_829_S.


  lv_kunnr = IV_customer_id.
  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING input = lv_kunnr
    IMPORTING output = lv_kunnr.


  SELECT vbrk~vbeln,
         vbrk~fkdat,
         vbrk~netwr,
         vbrk~waerk
    FROM vbpa
    INNER JOIN vbrk ON vbpa~vbeln = vbrk~vbeln
    INTO (@ls_line-vbeln, @ls_line-fkdat, @ls_line-netwr, @ls_line-waerk)
    WHERE vbpa~kunnr = @lv_kunnr
      AND vbpa~parvw = 'RE'.

    DATA(lv_due_date) = ls_line-fkdat + 30.
    ls_line-dats = lv_due_date.
    lv_days = abs( sy-datum - lv_due_date ).
    ls_line-aging = lv_days.



    APPEND ls_line TO et_payments_aging.
    CLEAR ls_line.

  ENDSELECT.


ENDFUNCTION.
