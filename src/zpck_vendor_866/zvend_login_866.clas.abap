CLASS zvend_login_866 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

  INTERFACES if_amdp_marker_hdb.
  data:  lv_passcode TYPE char30.

  CLASS-METHODS get_data
     IMPORTING
*        VALUE(i_mandt) TYPE mandt
        VALUE(i_vendor_ID) TYPE lifnr
      EXPORTING
        VALUE(lv_passcode)  TYPE  char30.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.




CLASS zvend_login_866 IMPLEMENTATION.

METHOD get_data
    BY DATABASE PROCEDURE
    FOR HDB
    LANGUAGE SQLSCRIPT
    OPTIONS READ-ONLY
    USING ZDT_VEND_CRD_866.

SELECT passcode
      INTO lv_passcode
      FROM ZDT_VEND_CRD_866
      WHERE  vendor_id = :i_vendor_ID;

    endMETHOD.

ENDCLASS.
