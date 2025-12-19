CLASS zvend_payage_866 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

  INTERFACES if_amdp_marker_hdb.

    CLASS-METHODS get_data
      IMPORTING
        VALUE(i_vendor_ID)  TYPE lifnr
      EXPORTING
        VALUE(et_payage) TYPE ZVENDORPAYAGE_866_T.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zvend_payage_866 IMPLEMENTATION.

METHOD get_data
    BY DATABASE PROCEDURE
    FOR HDB
    LANGUAGE SQLSCRIPT
    OPTIONS READ-ONLY
    USING bkpf bseg.

    et_payage =
      SELECT
        b.lifnr                                            AS lifnr,
        a.belnr                                            AS belnr,
        a.budat                                            AS budat,
        a.bldat                                            AS bldat,
        a.waers                                            AS waers,
        b.mwskz                                            AS mwskz,
        b.wrbtr                                            AS wrbtr,
        b.zfbdt                                            AS zfbdt,
        b.zterm                                            AS zterm,
         TO_NVARCHAR(
          ADD_DAYS( TO_DATE( b.zfbdt, 'YYYYMMDD' ), 30 ),
          'YYYYMMDD'
        )        AS due_date,
        CAST( 0 AS integer )                               AS aging
      FROM bkpf AS a
      INNER JOIN bseg AS b
        ON a.bukrs = b.bukrs
       AND a.belnr = b.belnr
       AND a.gjahr = b.gjahr
      WHERE b.lifnr = :i_vendor_id
      AND b.zfbdt IS NOT NULL
        AND b.zfbdt <> ''
        AND b.zfbdt <> '00000000';

  ENDMETHOD.

ENDCLASS.
