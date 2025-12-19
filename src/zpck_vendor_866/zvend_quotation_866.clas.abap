class ZVEND_QUOTATION_866 definition
  public
  final
  create public .

public section.

INTERFACES if_amdp_marker_hdb.

    CLASS-METHODS get_data
      IMPORTING
        VALUE(i_vendor_ID)  TYPE lifnr
      EXPORTING
        VALUE(et_quotation) TYPE zvendorquotation_866_t.

protected section.
private section.
ENDCLASS.



CLASS ZVEND_QUOTATION_866 IMPLEMENTATION.

METHOD get_data
      BY DATABASE PROCEDURE
      FOR HDB
      LANGUAGE SQLSCRIPT
      OPTIONS READ-ONLY
      USING ekko ekpo.

    et_quotation = selECT ekko.lifnr,
    ekko.ebeln,
    ekko.bedat,
    ekpo.txz01,
    ekpo.menge,
    ekpo.meins from ekpo INNER JOIN ekko ON ekpo.ebeln = ekko.ebeln
    WHERE ekko.lifnr = i_vendor_ID
      AND ekko.bsart = 'AN';
  ENDMETHOD.

ENDCLASS.
