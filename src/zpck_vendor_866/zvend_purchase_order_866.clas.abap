CLASS zvend_purchase_order_866 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  INTERFACES if_amdp_marker_hdb.

    CLASS-METHODS get_data
      IMPORTING VALUE(i_vendor_id) TYPE lifnr
      EXPORTING VALUE(et_po_data) TYPE ZVENDORPURCHASEORDER_866_T.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zvend_purchase_order_866 IMPLEMENTATION.

METHOD get_data
    BY DATABASE PROCEDURE
    FOR HDB
    LANGUAGE SQLSCRIPT
    OPTIONS READ-ONLY
    USING ekko ekpo eket.

    et_po_data =
       SELECT
        ekko.ebeln  ,
        ekko.lifnr  ,
        ekko.bedat  ,
        ekko.ekorg  ,
        ekpo.matnr  ,
        ekpo.meins  ,
        ekpo.netpr  ,
        eket.eindt  ,
        ekko.waers
      FROM ekko
      INNER JOIN ekpo
          ON ekko.ebeln = ekpo.ebeln
      LEFT JOIN eket
          ON ekpo.ebeln = eket.ebeln
         AND ekpo.ebelp = eket.ebelp
      WHERE ekko.lifnr = :i_vendor_id;

  ENDMETHOD.

ENDCLASS.
