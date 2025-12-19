CLASS zemp_leave_request_866 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

  INTERFACES if_amdp_marker_hdb.
   CLASS-METHODS get_leave_data
      IMPORTING
        VALUE(iv_client) TYPE mandt
      EXPORTING
        VALUE(et_data)   TYPE ZEMPLOYEE_LEAVE_REQ_866_T.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zemp_leave_request_866 IMPLEMENTATION.

METHOD get_leave_data BY DATABASE PROCEDURE
                        FOR HDB
                        LANGUAGE SQLSCRIPT
                        OPTIONS READ-ONLY
                        USING pa2001 pa2006.

    et_data = SELECT
                h.pernr AS empid,
                h.begda AS sdate,
                h.endda AS edate,
                h.subty AS category,
                h.umsch AS descrip,
                i.ktart AS qtype,
                i.anzhl AS qtime,
                i.desta AS qstart,
                i.deend AS qend
              FROM pa2001 AS h
              INNER JOIN pa2006 AS i
                ON h.mandt = i.mandt
               AND h.pernr = i.pernr
              WHERE h.mandt = :iv_client;
     ENDMETHOD.

ENDCLASS.
