FUNCTION ZFM_SALES_SUMMARY_866.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IV_CUSTOMER_ID) TYPE  KUNNR
*"  EXPORTING
*"     VALUE(ET_SALES_SUMMARY) TYPE  ZSALES_SUMMARY_866_T
*"----------------------------------------------------------------------


DATA: lv_kunnr     TYPE kunnr,
        lv_count     TYPE i VALUE 0,
        lv_total_amt TYPE netwr VALUE 0,
        lv_waerk     TYPE waerk,
        ls_summary   TYPE ZSALES_SUMMARY_829_S.


  lv_kunnr = iv_customer_id.
  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING input = lv_kunnr
    IMPORTING output = lv_kunnr.


SELECT vbrk~waerk, SUM( netwr ) AS total_amt, COUNT(*) AS inv_count
  FROM vbpa
  INNER JOIN vbrk ON vbpa~vbeln = vbrk~vbeln
  INTO (@lv_waerk, @lv_total_amt, @lv_count)
  WHERE vbpa~kunnr = @lv_kunnr
    AND vbpa~parvw = 'RE'
    AND vbrk~fkart = 'F2'
  GROUP BY vbrk~waerk.

  ENDSELECT.


  ls_summary-total_count  = lv_count.
  ls_summary-netwr = lv_total_amt.
  ls_summary-waerk    = lv_waerk.

  APPEND ls_summary TO et_sales_summary.


ENDFUNCTION.
