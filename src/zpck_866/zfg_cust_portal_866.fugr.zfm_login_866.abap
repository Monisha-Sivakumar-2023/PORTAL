FUNCTION ZFM_LOGIN_866.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(CUSTOMER_ID) TYPE  KUNNR
*"     VALUE(PASSCODE) TYPE  Z_USERPASS_866_DE
*"  EXPORTING
*"     VALUE(STATUS) TYPE  CHAR30
*"----------------------------------------------------------------------

DATA: lv_password TYPE char30.

CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
  EXPORTING
    input         = customer_id
 IMPORTING
   OUTPUT        = customer_id
          .


  SELECT SINGLE passcode INTO @lv_password FROM ZDT_CUS_CRED_866
   WHERE customer_id = @CUSTOMER_ID.
  IF lv_password = passcode and sy-subrc = 0.
  status  = 'Login Sucess'.

  ELSE.
 status  = 'Login Fail'.
  ENDIF.



ENDFUNCTION.
