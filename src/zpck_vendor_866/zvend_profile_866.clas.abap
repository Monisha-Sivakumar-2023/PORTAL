CLASS zvend_profile_866 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

  INTERFACES if_amdp_marker_hdb.

    CLASS-METHODS get_data
      IMPORTING
        VALUE(i_vendor_ID) TYPE lifnr
      EXPORTING
        VALUE(et_profile) TYPE ZVENDORPROFILE_866_T.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zvend_profile_866 IMPLEMENTATION.

METHOD get_data
    BY DATABASE PROCEDURE
    FOR HDB
    LANGUAGE SQLSCRIPT
    OPTIONS READ-ONLY
    USING LFA1.

    et_profile = SELECT LIFNR  AS VENDOR_ID,
                        NAME1  AS NAME,
                        STRAS  AS STREET,
                        ORT01  AS CITY,
                        LAND1  AS COUNTRY,
                        PSTLZ  AS POSTAL_CODE,
                        ADRNR  AS ADDRESS
                 FROM LFA1
                 WHERE LIFNR = :i_vendor_ID;


  ENDMETHOD.

ENDCLASS.
