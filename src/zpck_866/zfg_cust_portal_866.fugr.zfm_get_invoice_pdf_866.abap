FUNCTION zfm_get_invoice_pdf_866.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IV_VBELN) TYPE  VBELN
*"  EXPORTING
*"     VALUE(E_PDF) TYPE  STRING
*"----------------------------------------------------------------------

  DATA:
         inv_formoutput TYPE fpformoutput.

  SUBMIT zrp_invoice_report_866
    WITH Ivbeln = iv_vbeln
    AND RETURN.
  " Import Adobe form result from memory
  IMPORT lv_form TO inv_formoutput FROM MEMORY ID 'C_MEMORY'.
  " Convert XSTRING to Base64 STRING
  CALL FUNCTION 'SCMS_BASE64_ENCODE_STR'
    EXPORTING
      input  = inv_formoutput-pdf
    IMPORTING
      output = e_pdf.



ENDFUNCTION.
