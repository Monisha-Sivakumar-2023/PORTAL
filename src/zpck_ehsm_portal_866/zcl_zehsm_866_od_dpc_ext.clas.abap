class ZCL_ZEHSM_866_OD_DPC_EXT definition
  public
  inheriting from ZCL_ZEHSM_866_OD_DPC
  create public .

public section.
protected section.

  methods ZEHSM_LOGIN_866S_GET_ENTITY
    redefinition .
  methods ZEHSM_PROFILE_86_GET_ENTITY
    redefinition .
  methods ZEHSM_RISK_866SE_GET_ENTITYSET
    redefinition .
  methods ZEHSM_INCIDENT_8_GET_ENTITYSET
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZEHSM_866_OD_DPC_EXT IMPLEMENTATION.


  METHOD zehsm_incident_8_get_entityset.
**TRY.
*CALL METHOD SUPER->ZEHSM_INCIDENT_8_GET_ENTITYSET
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

    DATA: lv_empid TYPE persno,
          lt_inc   TYPE zehsm_incident_866_t,
          ls_inc   TYPE zehsm_incident_866_s.

    LOOP AT it_filter_select_options INTO DATA(ls_filter).
      IF ls_filter-property = 'EmployeeId'.
        READ TABLE ls_filter-select_options INTO DATA(ls_sel) INDEX 1.
        IF sy-subrc = 0.
          lv_empid = ls_sel-low.
        ENDIF.
        EXIT.
      ENDIF.
    ENDLOOP.
    IF lv_empid IS NOT INITIAL.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = lv_empid
        IMPORTING
          output = lv_empid.
    ENDIF.

    IF lv_empid IS INITIAL.
      RETURN.
    ENDIF.


    CALL METHOD zehsm_amdp_866=>get_incidents
      EXPORTING
        iv_client     = sy-mandt
        iv_employeeid = lv_empid
      IMPORTING
        et_incidents  = lt_inc.


    LOOP AT lt_inc INTO ls_inc.
      APPEND ls_inc TO et_entityset.
    ENDLOOP.

  ENDMETHOD.


  method ZEHSM_LOGIN_866S_GET_ENTITY.
**TRY.
*CALL METHOD SUPER->ZEHSM_LOGIN_866S_GET_ENTITY
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

    DATA: lv_employee_id TYPE Z_USERNAME_866_DE,
      lv_empid type pernr_d,
          lv_password  TYPE Z_USERPASS_866_DE.


    LOOP AT it_key_tab INTO DATA(ls_key).
      CASE ls_key-name.
        WHEN 'EmployeeId'.
          lv_employee_id = ls_key-value.
        WHEN 'Password'.
          lv_password = ls_key-value.
      ENDCASE.
    ENDLOOP.
lv_empid = |{ lv_employee_id WIDTH = 8 ALIGN = RIGHT PAD = '0' }|.
    SELECT SINGLE * FROM ZDT_EHSM_LGN_866 INTO @DATA(ls_auth)
      WHERE EMPLOYEE_ID = @lv_empid
       AND PASSWORD = @lv_password.

    CLEAR er_entity.
    IF sy-subrc = 0.
      " Login success
      er_entity-EMPLOYEE_ID        = lv_empid.
      er_entity-PASSWORD = lv_password.
      er_entity-STATUS          = 'Success'.

    ELSE.
      " Login failed
      er_entity-EMPLOYEE_ID        = lv_empid.
      er_entity-PASSWORD = ''.
      er_entity-STATUS          = 'Invalid'.

    ENDIF.

  endmethod.


  METHOD zehsm_profile_86_get_entity.
**TRY.
*CALL METHOD SUPER->ZEHSM_PROFILE_86_GET_ENTITY
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

    DATA: ls_entity     TYPE zehsm_profile_866_s,
          lt_profile    TYPE zehsm_profile_866_t,
          lv_employeeid TYPE z_username_866_de,
          lv_empid      TYPE pernr_d,
          ls_key_tab    TYPE /iwbep/s_mgw_name_value_pair.

    READ TABLE it_key_tab INTO ls_key_tab WITH KEY name = 'EmployeeId'.
    IF sy-subrc = 0.
      lv_employeeid = ls_key_tab-value.
    ENDIF.

    IF lv_employeeid IS INITIAL.
      RETURN.
    ENDIF.
    lv_empid = |{ lv_employeeid WIDTH = 8 ALIGN = RIGHT PAD = '0' }|.

    CALL METHOD zehsm_amdp_866=>get_profile
      EXPORTING
        iv_client     = sy-mandt
        iv_employeeid = lv_empid
      IMPORTING
        et_profile    = lt_profile.

    READ TABLE lt_profile INTO ls_entity INDEX 1.
    IF sy-subrc = 0.
      er_entity = ls_entity.
    ENDIF.

  ENDMETHOD.


  METHOD zehsm_risk_866se_get_entityset.
**TRY.
*CALL METHOD SUPER->ZEHSM_RISK_866SE_GET_ENTITYSET
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

    DATA: lv_empid TYPE persno,
          lt_risk  TYPE zehsm_risk_866_t,
          ls_risk  TYPE zehsm_risk_866_s.

    LOOP AT it_filter_select_options INTO DATA(ls_filter).
      IF ls_filter-property = 'EmployeeId'.
        READ TABLE ls_filter-select_options INTO DATA(ls_sel) INDEX 1.
        IF sy-subrc = 0.
          lv_empid = ls_sel-low.
        ENDIF.
        EXIT.
      ENDIF.
    ENDLOOP.
    IF lv_empid IS NOT INITIAL.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = lv_empid
        IMPORTING
          output = lv_empid.
    ENDIF.

    IF lv_empid IS INITIAL.
      RETURN.
    ENDIF.

    CALL METHOD zehsm_amdp_866=>get_risks
      EXPORTING
        iv_client     = sy-mandt
        iv_employeeid = lv_empid
      IMPORTING
        et_risks      = lt_risk.

    LOOP AT lt_risk INTO ls_risk.
      APPEND ls_risk TO et_entityset.
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
