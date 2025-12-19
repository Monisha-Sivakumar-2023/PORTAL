class ZCL_ZMAINTENANCE_866_O_DPC_EXT definition
  public
  inheriting from ZCL_ZMAINTENANCE_866_O_DPC
  create public .

public section.
protected section.

  methods ZMAINT_LOGIN_866_GET_ENTITY
    redefinition .
  methods ZMAINT_PLANT_866_GET_ENTITYSET
    redefinition .
  methods ZMAINT_WORKORDER_GET_ENTITYSET
    redefinition .
  methods ZMAINT_NOTIFICAT_GET_ENTITYSET
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZMAINTENANCE_866_O_DPC_EXT IMPLEMENTATION.


  method ZMAINT_LOGIN_866_GET_ENTITY.
**TRY.
*CALL METHOD SUPER->ZMAINT_LOGIN_866_GET_ENTITY
*  EXPORTING
*    IV_ENTITY_NAME          =
*    IV_ENTITY_SET_NAME      =
*    IV_SOURCE_NAME          =
*    IT_KEY_TAB              =
**    io_request_object       =
**    io_tech_request_context =
*    IT_NAVIGATION_PATH      =
**  IMPORTING
**    er_entity               =
**    es_response_context     =
*    .
**  CATCH /iwbep/cx_mgw_busi_exception.
**  CATCH /iwbep/cx_mgw_tech_exception.
**ENDTRY.

    DATA: ls_key_tab TYPE /iwbep/s_mgw_name_value_pair,
          lv_userid  TYPE z_username_866_de,
          ls_res     TYPE zmaintenance_login_866_s.

    " 1. Fix: Convert the Property Name to Upper Case for safe comparison
    LOOP AT it_key_tab INTO ls_key_tab.
      TRANSLATE ls_key_tab-name TO UPPER CASE.

      IF ls_key_tab-name = 'MAINENGINEER'.
        lv_userid = ls_key_tab-value.
      ENDIF.
    ENDLOOP.

    IF lv_userid IS NOT INITIAL.
      " 2. Select Data
      SELECT SINGLE * FROM zdt_mant_crd_866 INTO CORRESPONDING FIELDS OF ls_res
        WHERE main_engineer = lv_userid.

      IF sy-subrc = 0.
        " Success
        er_entity-main_engineer = lv_userid.
        er_entity-password      = ls_res-password.
        er_entity-status        = 'Success'.
      ELSE.
        " Failed - Return keys to avoid OData key mismatch error
        er_entity-main_engineer = lv_userid.
        er_entity-status        = 'Failed'.
      ENDIF.
    ENDIF.

  endmethod.


  method ZMAINT_NOTIFICAT_GET_ENTITYSET.
**TRY.
*CALL METHOD SUPER->ZMAINT_NOTIFICAT_GET_ENTITYSET
*  EXPORTING
*    IV_ENTITY_NAME           =
*    IV_ENTITY_SET_NAME       =
*    IV_SOURCE_NAME           =
*    IT_FILTER_SELECT_OPTIONS =
*    IS_PAGING                =
*    IT_KEY_TAB               =
*    IT_NAVIGATION_PATH       =
*    IT_ORDER                 =
*    IV_FILTER_STRING         =
*    IV_SEARCH_STRING         =
**    io_tech_request_context  =
**  IMPORTING
**    et_entityset             =
**    es_response_context      =
*    .
**  CATCH /iwbep/cx_mgw_busi_exception.
**  CATCH /iwbep/cx_mgw_tech_exception.
**ENDTRY.

    DATA: lv_engineer TYPE z_username_866_de,
          lt_plant    TYPE zmaintenance_plant_866_t,
          lt_notif    TYPE zmaintenance_notif_866_t,
          lt_temp_notif TYPE zmaintenance_notif_866_t. " Temporary table for the loop

    " 1. Get Engineer ID from Filter
    LOOP AT it_filter_select_options INTO DATA(ls_filter).
      IF ls_filter-property = 'Mainengineer' OR ls_filter-property = 'MAIN_ENGINEER'.
        READ TABLE ls_filter-select_options INDEX 1 INTO DATA(ls_so).
        lv_engineer = ls_so-low.
      ENDIF.
    ENDLOOP.

    IF lv_engineer IS NOT INITIAL.


      TRY.
          " 2. Get ALL plants assigned to this engineer
          zmaint_amdp_866=>get_plant_details(
            EXPORTING
              iv_client   = sy-mandt
              iv_engineer = lv_engineer
            IMPORTING
              et_plant    = lt_plant
          ).

          " 3. FIX: Loop through ALL plants, not just the first one
          LOOP AT lt_plant INTO DATA(ls_plant_row).

            CLEAR lt_temp_notif. " Clear previous loop data

            " Get notifications for THIS specific plant
            zmaint_amdp_866=>get_notifications(
              EXPORTING
                iv_client = sy-mandt
                iv_plant  = ls_plant_row-werks
              IMPORTING
                et_notif  = lt_temp_notif
            ).

            " Append these notifications to the final output list
            APPEND LINES OF lt_temp_notif TO et_entityset.

          ENDLOOP.

        CATCH cx_amdp_error.
          " Handle error
      ENDTRY.
    ENDIF.

  endmethod.


  method ZMAINT_PLANT_866_GET_ENTITYSET.
**TRY.
*CALL METHOD SUPER->ZMAINT_PLANT_866_GET_ENTITYSET
*  EXPORTING
*    IV_ENTITY_NAME           =
*    IV_ENTITY_SET_NAME       =
*    IV_SOURCE_NAME           =
*    IT_FILTER_SELECT_OPTIONS =
*    IS_PAGING                =
*    IT_KEY_TAB               =
*    IT_NAVIGATION_PATH       =
*    IT_ORDER                 =
*    IV_FILTER_STRING         =
*    IV_SEARCH_STRING         =
**    io_tech_request_context  =
**  IMPORTING
**    et_entityset             =
**    es_response_context      =
*    .
**  CATCH /iwbep/cx_mgw_busi_exception.
**  CATCH /iwbep/cx_mgw_tech_exception.
**ENDTRY.

    DATA: lv_engineer TYPE z_username_866_de,
          lt_plant    TYPE zmaintenance_plant_866_t.

    LOOP AT it_filter_select_options INTO DATA(ls_filter).
      IF ls_filter-property = 'MainEngineer' OR ls_filter-property = 'MAIN_ENGINEER'.
        READ TABLE ls_filter-select_options INDEX 1 INTO DATA(ls_so).
        lv_engineer = ls_so-low.
      ENDIF.
    ENDLOOP.


    IF lv_engineer IS NOT INITIAL.
      TRY.
        CALL METHOD zmaint_amdp_866=>get_plant_details
          EXPORTING
            iv_client   = sy-mandt
            iv_engineer = lv_engineer
          IMPORTING
            et_plant    = lt_plant
            .



          et_entityset = lt_plant.

        CATCH cx_amdp_error.

      ENDTRY.
    ENDIF.

  endmethod.


  method ZMAINT_WORKORDER_GET_ENTITYSET.
**TRY.
*CALL METHOD SUPER->ZMAINT_WORKORDER_GET_ENTITYSET
*  EXPORTING
*    IV_ENTITY_NAME           =
*    IV_ENTITY_SET_NAME       =
*    IV_SOURCE_NAME           =
*    IT_FILTER_SELECT_OPTIONS =
*    IS_PAGING                =
*    IT_KEY_TAB               =
*    IT_NAVIGATION_PATH       =
*    IT_ORDER                 =
*    IV_FILTER_STRING         =
*    IV_SEARCH_STRING         =
**    io_tech_request_context  =
**  IMPORTING
**    et_entityset             =
**    es_response_context      =
*    .
**  CATCH /iwbep/cx_mgw_busi_exception.
**  CATCH /iwbep/cx_mgw_tech_exception.
**ENDTRY.

    DATA: lv_engineer     TYPE z_username_866_de,
          lt_plant        TYPE zmaintenance_plant_866_t,
          lt_temp_orders  TYPE zmaintenance_workorder_866_t.

    LOOP AT it_filter_select_options INTO DATA(ls_filter).
      IF ls_filter-property = 'Mainengineer' OR ls_filter-property = 'MAIN_ENGINEER'.
        READ TABLE ls_filter-select_options INDEX 1 INTO DATA(ls_so).
        lv_engineer = ls_so-low.
      ENDIF.
    ENDLOOP.

    IF lv_engineer IS NOT INITIAL.


      TRY.

          zmaint_amdp_866=>get_plant_details(
            EXPORTING
              iv_client   = sy-mandt
              iv_engineer = lv_engineer
            IMPORTING
              et_plant    = lt_plant
          ).


          LOOP AT lt_plant INTO DATA(ls_plant_row).

            CLEAR lt_temp_orders.


            zmaint_amdp_866=>get_work_orders(
              EXPORTING
                iv_client = sy-mandt
                iv_plant  = ls_plant_row-werks
              IMPORTING
                et_orders = lt_temp_orders
            ).

            APPEND LINES OF lt_temp_orders TO et_entityset.

          ENDLOOP.

        CATCH cx_amdp_error.

      ENDTRY.
    ENDIF.

  endmethod.
ENDCLASS.
