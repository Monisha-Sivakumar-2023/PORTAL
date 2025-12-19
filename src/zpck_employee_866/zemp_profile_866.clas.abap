CLASS zemp_profile_866 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
   INTERFACES if_amdp_marker_hdb.
   CLASS-METHODS get_profile_data
      IMPORTING
        VALUE(iv_client) TYPE mandt
      EXPORTING
        VALUE(et_data)   TYPE ZEMPLOYEE_PROFILE_866_T.


  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zemp_profile_866 IMPLEMENTATION.

METHOD get_profile_data BY DATABASE PROCEDURE
                            FOR HDB
                            LANGUAGE SQLSCRIPT
                            OPTIONS READ-ONLY
                            USING pa0002 pa0001 pa0006 pa0105.

    et_data =
      SELECT
        h.pernr                                    AS pernr,
        h.vorna                                    AS fname,
        h.nachn                                    AS lname,
        h.gesch                                    AS gender,
        a.stras                                    AS address,
        a.ort01                                    AS city,
        a.state                                    AS state,
        h.gblnd                                    AS country,
        h.natio                                    AS nationality,
        i.bukrs                                    AS company_code,
        i.kostl                                    AS cost_center,
        i.plans                                    AS job_position,
        i.stell                                    AS job,
         COALESCE(k.usrid_long, CONCAT(h.pernr, '@default.com')) AS email
      FROM pa0002 AS h
      INNER JOIN pa0001 AS i
        ON h.mandt = i.mandt
       AND h.pernr = i.pernr
      INNER JOIN pa0006 AS a
        ON h.mandt = a.mandt
       AND h.pernr = a.pernr
      LEFT JOIN pa0105 AS k
        ON h.mandt = k.mandt
       AND h.pernr = k.pernr
       AND k.subty = '0010'            -- email subtype
      WHERE h.mandt = :iv_client
        AND a.subty = '1'              -- Address Subtype (Permanent Residence)
        AND i.endda >= current_date    -- Ensure active employment record
        AND i.begda <= current_date
        AND a.endda >= current_date    -- Ensure active address record
        AND a.begda <= current_date;

  ENDMETHOD.

ENDCLASS.
