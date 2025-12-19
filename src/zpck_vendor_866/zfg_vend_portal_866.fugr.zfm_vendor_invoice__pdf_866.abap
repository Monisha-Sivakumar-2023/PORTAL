FUNCTION ZFM_VENDOR_INVOICE__PDF_866.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IV_DOC_NUM) TYPE  RE_BELNR
*"  EXPORTING
*"     VALUE(EV_PDF) TYPE  STRING
*"----------------------------------------------------------------------


DATA:
       inv_formoutput TYPE fpformoutput.

 SUBMIT ZRP_VENDOR_INVOICE_REPORT_866
   WITH p_belnr = iv_doc_num
   AND RETURN.
 " Import Adobe form result from memory
 IMPORT lv_form TO inv_formoutput FROM MEMORY ID 'C_MEMORY'.
 " Convert XSTRING to Base64 STRING
 CALL FUNCTION 'SCMS_BASE64_ENCODE_STR'
   EXPORTING
     input  = inv_formoutput-pdf
   IMPORTING
     output = ev_pdf.


ENDFUNCTION.
