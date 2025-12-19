FUNCTION ZFM_VENDOR_LOGIN_866.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(VENDOR_ID) TYPE  LIFNR
*"     VALUE(PASSCODE) TYPE  CHAR30
*"  EXPORTING
*"     VALUE(STATUS) TYPE  STRING
*"----------------------------------------------------------------------

DATA: lv_password type char30, vnd type lifnr.
CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input         = vendor_id
   IMPORTING
     OUTPUT        = vnd.
CALL METHOD zvend_login_866=>get_data
  EXPORTING
    i_vendor_id = vnd
  IMPORTING
    lv_passcode = lv_password
    .
if lv_password = passcode and sy-subrc = 0.
  status = 'Login Success'.
else.
  status = 'Login Fail'.
ENDIF.



ENDFUNCTION.
