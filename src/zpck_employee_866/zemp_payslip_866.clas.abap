CLASS zemp_payslip_866 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

  INTERFACES if_amdp_marker_hdb.

    " Use the Table Type created in Step 1
    CLASS-METHODS get_payslip_data
      IMPORTING
        VALUE(iv_client) TYPE mandt
        VALUE(iv_pernr)  TYPE pernr_d
      EXPORTING
        VALUE(et_data)   TYPE ZEMPLOYEE_PAYSLIP_866_T.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zemp_payslip_866 IMPLEMENTATION.

METHOD get_payslip_data BY DATABASE PROCEDURE
                          FOR HDB
                          LANGUAGE SQLSCRIPT
                          OPTIONS READ-ONLY
                          USING pa0001 pa0002 pa0008 pa0105.

   et_data =
  SELECT
      h.pernr AS emp_id,
      h.bukrs AS company_code,
      'GEXX-20XX' AS cost_center,
      h.stell AS stell,
      i.vorna AS name,
      i.gesch AS gender,
      i.natio AS nationality,
      j.trfgr AS pscale_group,
      j.trfst AS ps_level,
      j.bet01 AS amount,
      j.lga01 AS wage_type,
      j.waers AS currency_key,
      j.divgv AS working_hours,
      COALESCE(k.usrid_long, CONCAT(h.pernr, '@default.com')) AS email

  FROM pa0001 AS h
  INNER JOIN pa0002 AS i
      ON h.mandt = i.mandt
     AND h.pernr = i.pernr
  INNER JOIN pa0008 AS j
      ON h.mandt = j.mandt
     AND h.pernr = j.pernr
  LEFT OUTER JOIN pa0105 AS k
      ON h.mandt = k.mandt
     AND h.pernr = k.pernr
     AND k.subty = '0010'     -- Email subtype
  WHERE h.mandt = :iv_client
    AND h.pernr = :iv_pernr;


  ENDMETHOD.

ENDCLASS.
