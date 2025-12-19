CLASS zvend_memo_866 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

  INTERFACES if_amdp_marker_hdb.

    CLASS-METHODS get_data
      IMPORTING
        VALUE(i_vendor_ID)  TYPE lifnr
      EXPORTING
        VALUE(et_memo) TYPE ZVENDORMEMO_866_T.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zvend_memo_866 IMPLEMENTATION.

METHOD get_data
    BY DATABASE PROCEDURE
    FOR HDB
    LANGUAGE SQLSCRIPT
    OPTIONS READ-ONLY
    USING bkpf bseg.


    et_memo =
      SELECT
        b.lifnr                          AS lifnr,
        b.belnr                          AS belnr,
        b.gjahr                          AS gjahr,
        b.buzei                          AS buzei,
        a.blart                          AS h_blart,
        a.budat                          AS h_budat,
        a.bldat                          AS h_bldat,
        b.dmbtr                          AS dmbtr,
        a.waers                          AS h_waers,
        b.menge                          AS menge,
        b.meins                          AS meins,
        b.matnr                          AS matnr,
        b.hkont                          AS hkont,
        b.shkzg                          AS shkzg,
        b.bschl                          AS bschl
      FROM bseg AS b
      INNER JOIN bkpf AS a
        ON a.bukrs = b.bukrs
       AND a.belnr = b.belnr
       AND a.gjahr = b.gjahr
      WHERE b.lifnr = :i_vendor_id;



  ENDMETHOD.

ENDCLASS.
