FUNCTION ZFM_VENDOR_PROFILE_866.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IV_VENDOR_ID) TYPE  LIFNR
*"  EXPORTING
*"     VALUE(ET_PROFILE) TYPE  ZVENDORPROFILE_866_T
*"----------------------------------------------------------------------


 DATA: lv_vendor_id TYPE lifnr.
  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = iv_vendor_id
    IMPORTING
      output = lv_vendor_id.
CALL METHOD zvend_profile_866=>get_data
  EXPORTING
    i_vendor_id = lv_vendor_id
  IMPORTING
    et_profile  = et_profile.


ENDFUNCTION.
