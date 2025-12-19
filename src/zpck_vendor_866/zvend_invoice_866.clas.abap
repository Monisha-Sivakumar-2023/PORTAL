CLASS zvend_invoice_866 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

  INTERFACES if_amdp_marker_hdb.

    CLASS-METHODS get_data
      IMPORTING
        VALUE(i_vendor_ID) TYPE lifnr
      EXPORTING
        VALUE(et_invoice)  TYPE zvendorinvoice_866_t.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zvend_invoice_866 IMPLEMENTATION.

METHOD get_data
        BY DATABASE PROCEDURE
        FOR HDB
        LANGUAGE SQLSCRIPT
        OPTIONS READ-ONLY
        USING rbkp lfa1 rseg.

    et_invoice = SELECT rbkp.belnr, rbkp.budat, rbkp.lifnr,
        rbkp.waers, lfa1.name1, lfa1.ort01, lfa1.land1, rseg.wrbtr

    FROM rbkp
    INNER JOIN rseg ON rbkp.belnr = rseg.belnr
                   AND rbkp.gjahr = rseg.gjahr
    INNER JOIN lfa1 ON rbkp.lifnr = lfa1.lifnr
    WHERE rbkp.lifnr = :i_vendor_ID;
  ENDMETHOD.

ENDCLASS.
