CLASS zmaint_amdp_866 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

  INTERFACES if_amdp_marker_hdb.


    TYPES: tt_plant      TYPE zmaintenance_plant_866_t,
           tt_notif      TYPE zmaintenance_notif_866_t,
           tt_workorder  TYPE zmaintenance_workorder_866_t.


    CLASS-METHODS get_plant_details
      IMPORTING VALUE(iv_client)   TYPE mandt
                VALUE(iv_engineer) TYPE z_username_866_de
      EXPORTING VALUE(et_plant)    TYPE tt_plant.


    CLASS-METHODS get_notifications
      IMPORTING VALUE(iv_client) TYPE mandt
                VALUE(iv_plant)  TYPE werks_d
      EXPORTING VALUE(et_notif)  TYPE tt_notif.

    CLASS-METHODS get_work_orders
      IMPORTING VALUE(iv_client) TYPE mandt
                VALUE(iv_plant)  TYPE werks_d
      EXPORTING VALUE(et_orders) TYPE tt_workorder.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zmaint_amdp_866 IMPLEMENTATION.

METHOD get_plant_details BY DATABASE PROCEDURE FOR HDB
                           LANGUAGE SQLSCRIPT
                           OPTIONS READ-ONLY
                           USING zdt_plant_866 t001w.

    et_plant = SELECT
                 p.main_engineer,
                 p.plant AS werks,
                 t.name1,
                 t.ort01,
                 t.stras
               FROM zdt_plant_866 AS p
               INNER JOIN t001w AS t
                 ON p.mandt = t.mandt
                AND p.plant = t.werks
               WHERE p.mandt = :iv_client
                 AND p.main_engineer = :iv_engineer;

  ENDMETHOD.

  METHOD get_notifications BY DATABASE PROCEDURE FOR HDB
                           LANGUAGE SQLSCRIPT
                           OPTIONS READ-ONLY
                           USING viqmel.

    et_notif = SELECT
                 qmnum,
                 iwerk,
                 iloan,
                 equnr,
                 '' AS mainengineer, -- MOVED HERE (Position 5) to match Structure
                 ingrp,
                 ausvn,
                 qmart,
                 auztv,
                 artpr,
                 qmtxt,
                 priok,
                 LEFT(arbpl, 4) AS arbplwerk,
                 swerk,
                 qmdab
               FROM viqmel
               WHERE mandt = :iv_client
                 AND iwerk = :iv_plant;
  ENDMETHOD.

  METHOD get_work_orders BY DATABASE PROCEDURE FOR HDB
                         LANGUAGE SQLSCRIPT
                         OPTIONS READ-ONLY
                         USING aufk afih.

    et_orders = SELECT
                  a.aufnr,
                  a.auart,
                  a.ktext,
                  a.autyp,
                  a.bukrs,
                  '' AS mainengineer,
                  a.werks AS sowrk,
                  a.werks,
                  a.kappl,
                  a.kalsm,
                  b.gewrk AS vaplz,
                  a.kostl,
                  a.erdat,
                  a.objnr
                FROM aufk AS a
                INNER JOIN afih AS b
                  ON a.mandt = b.mandt
                 AND a.aufnr = b.aufnr
                WHERE a.mandt = :iv_client
                  AND a.werks = :iv_plant;
  ENDMETHOD.

ENDCLASS.
