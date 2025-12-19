CLASS zvend_goods_receipt_866 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

  INTERFACES if_amdp_marker_hdb.

    CLASS-METHODS get_data
      IMPORTING
        VALUE(i_vendor_id) TYPE lifnr
      EXPORTING
        VALUE(et_gr_data)  TYPE ZVENDORGOODSRECEIPT_866_T.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zvend_goods_receipt_866 IMPLEMENTATION.

METHOD get_data
    BY DATABASE PROCEDURE
    FOR HDB
    LANGUAGE SQLSCRIPT
    OPTIONS READ-ONLY
    USING NSDM_V_MSEG.
et_gr_data =
      SELECT
        a.mblnr      AS "MBLNR",
        a.bukrs      AS "BUKRS",
        a.BUDAT_MKPF AS "BUDAT",
        a.mjahr      AS "MJAHR",
        a.lifnr      AS "LIFNR",
        a.matnr      AS "MATNR",
        a.werks      AS "WERKS"
      FROM NSDM_V_MSEG as a
      WHERE  a.lifnr = :i_vendor_id;

  ENDMETHOD.

ENDCLASS.
