FUNCTION ZFM_PROFILE_866.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IV_CUSTOMER_ID) TYPE  KUNNR
*"  EXPORTING
*"     VALUE(ES_PROFILE) TYPE  ZUSERPROFILE_866_S
*"----------------------------------------------------------------------

*DATA: lv_customer_id type kunnr.

CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
  EXPORTING
    input         = iv_customer_id
 IMPORTING
   OUTPUT        = iv_customer_id.

SELECT single kunnr, land1, name1, ort01, stras, pstlz, adrnr
  into (@es_profile-customer_id, @es_profile-country,
  @es_profile-name, @es_profile-city,
  @es_profile-street, @es_profile-postal_code, @es_profile-address_number)
  from kna1
  where kunnr = @iv_customer_id.




ENDFUNCTION.
