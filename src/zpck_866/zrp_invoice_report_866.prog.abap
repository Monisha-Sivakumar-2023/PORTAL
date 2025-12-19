*&---------------------------------------------------------------------*
*& Report ZRP_INVOICE_REPORT_866
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrp_invoice_report_866.

TYPE-POOLS: sfp.

DATA: lv_func     TYPE funcname VALUE 'ZF_INVOICE_866',
      lv_out      TYPE sfpoutputparams,
      lv_doc      TYPE sfpdocparams,
      lv_form     TYPE fpformoutput,
      lv_filename TYPE string,
      lv_path     TYPE string,
      lv_fullpath TYPE string.

DATA: i_header TYPE zivoiceheader_866_s,
      i_items  TYPE zinvoiceitem_866_t.

PARAMETERS: ivbeln TYPE vbeln.
SELECT
  vbrp~posnr,
  vbrk~fkdat,  " Billing date (from VBRK, not VBRP)
  vbrk~kunag,  " Sold-to party
  vbrp~matnr,  " Material number
  vbrp~arktx,  " Description
  vbrk~netwr,  " Net value
  vbrk~waerk   " Currency
  INTO TABLE @i_items
  FROM vbrk
  INNER JOIN vbrp ON vbrk~vbeln = vbrp~vbeln
  INNER JOIN kna1 ON vbrk~kunag = kna1~kunnr
  WHERE vbrk~vbeln = @ivbeln.

SELECT SINGLE
vbrk~vbeln,
kna1~name1,
*  vbrk~vkorg,
vbrk~kunag,
kna1~stras,
kna1~ort01,
kna1~land1,
kna1~pstlz
INTO @i_header
FROM vbrk
INNER JOIN vbrp ON vbrk~vbeln = vbrp~vbeln
INNER JOIN kna1 ON vbrk~kunag = kna1~kunnr
WHERE vbrk~vbeln = @ivbeln .
lv_out-nodialog = abap_true.
lv_out-getpdf   = abap_true.
lv_out-preview  = abap_true.
lv_out-dest     = 'LP01'.

lv_doc-dynamic = abap_true.
lv_doc-langu   = sy-langu.


"Get Adobe Form FM Name-
CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
  EXPORTING
    i_name     = lv_func
  IMPORTING
    e_funcname = lv_func.


"Open Form Job
CALL FUNCTION 'FP_JOB_OPEN'
  CHANGING
    ie_outputparams = lv_out
  EXCEPTIONS
    OTHERS          = 4.

CALL FUNCTION '/1BCDWB/SM00002379'
  EXPORTING
    /1bcdwb/docparams  = lv_doc
    wa_header          = i_header
    iv_doc_num         = ivbeln
    lt_item            = i_items
  IMPORTING
    /1bcdwb/formoutput = lv_form
  EXCEPTIONS
    usage_error        = 1
    system_error       = 2
    internal_error     = 3
    OTHERS             = 4.
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.



IF sy-subrc <> 0.
  MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
ELSE.
  EXPORT lv_form TO MEMORY ID 'C_MEMORY'.
  MESSAGE 'Adobe Form processed successfully' TYPE 'S'.
ENDIF.



CALL FUNCTION 'FP_JOB_CLOSE'
  EXCEPTIONS
    OTHERS = 4.

"Download PDF to Local
*IF lv_form-pdf IS NOT INITIAL.
*  DATA: it_pdf TYPE STANDARD TABLE OF x255,
*        lv_len TYPE i.
*
*  CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
*    EXPORTING
*      buffer        = lv_form-pdf
*    IMPORTING
*      output_length = lv_len
*    TABLES
*      binary_tab    = it_pdf.
*
*  CALL METHOD cl_gui_frontend_services=>file_save_dialog
*    EXPORTING
*      default_extension = 'pdf'
*      default_file_name = |Invoice_{ ivbeln }.pdf|
*      file_filter       = 'PDF Files (.pdf)|.pdf|'
*    CHANGING
*      filename          = lv_filename
*      path              = lv_path
*      fullpath          = lv_fullpath
*    EXCEPTIONS
*      OTHERS            = 1.
*
*  IF sy-subrc <> 0.
*    MESSAGE 'Download cancelled by user' TYPE 'I'.
*    RETURN.
*  ENDIF.
*
*  CALL FUNCTION 'GUI_DOWNLOAD'
*    EXPORTING
*      filename = lv_fullpath
*      filetype = 'BIN'
*    TABLES
*      data_tab = it_pdf.
*
*  MESSAGE |PDF saved to { lv_fullpath }| TYPE 'S'.
*ELSE.
*  MESSAGE 'PDF generation failed or empty.' TYPE 'E'.
*ENDIF.
