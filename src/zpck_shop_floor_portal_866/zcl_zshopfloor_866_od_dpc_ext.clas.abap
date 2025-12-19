class ZCL_ZSHOPFLOOR_866_OD_DPC_EXT definition
  public
  inheriting from ZCL_ZSHOPFLOOR_866_OD_DPC
  create public .

public section.
protected section.

  methods ZSHOPFLOOR_LOGIN_GET_ENTITY
    redefinition .
  methods ZSHOPFLOOR_PLANO_GET_ENTITYSET
    redefinition .
  methods ZSHOPFLOOR_PRODO_GET_ENTITYSET
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZSHOPFLOOR_866_OD_DPC_EXT IMPLEMENTATION.


  method ZSHOPFLOOR_LOGIN_GET_ENTITY.
**TRY.
*CALL METHOD SUPER->ZSHOPFLOOR_LOGIN_GET_ENTITY
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

    DATA: lv_user TYPE ZDT_SF_LOGIN_866-empid,
        lv_password TYPE ZDT_SF_LOGIN_866-PASSWORD,
        lv_message  TYPE string,
        lt_key_tab  TYPE /iwbep/t_mgw_tech_pairs,
        ls_key      TYPE /iwbep/s_mgw_tech_pair,
        ls_login    TYPE ZDT_SF_LOGIN_866.

  " Get key values from URL
  lt_key_tab = io_tech_request_context->get_keys( ).

  LOOP AT lt_key_tab INTO ls_key.
    CASE ls_key-name.
      WHEN 'EMPID'.
        lv_user = ls_key-value.
      WHEN 'PASSWORD'.
        lv_password = ls_key-value.
    ENDCASE.
  ENDLOOP.

  " Check in the login table
  SELECT SINGLE * INTO @ls_login FROM ZDT_SF_LOGIN_866
    WHERE EMPID = @lv_user AND PASSWORD = @lv_password.

  IF sy-subrc = 0.
    lv_message = 'Login Successful'.
  ELSE.
    lv_message = 'Invalid Credentials'.
  ENDIF.

  " Return the result
  er_entity = VALUE #( EMPID = lv_user PASSWORD = lv_message ).

  endmethod.


  method ZSHOPFLOOR_PLANO_GET_ENTITYSET.
**TRY.
*CALL METHOD SUPER->ZSHOPFLOOR_PLANO_GET_ENTITYSET
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

    DATA: lt_amdp_data TYPE ZSHOPFLOOR_PLANORDER_866_T.
    CALL METHOD zshopfloor_amdp_866=>get_planned_orders
      EXPORTING
        iv_client = sy-mandt
      IMPORTING
        et_orders = lt_amdp_data
        .
    et_entityset = lt_amdp_data.
    IF it_filter_select_options IS NOT INITIAL.
      CALL METHOD /iwbep/cl_mgw_data_util=>filtering
        EXPORTING
          it_select_options = it_filter_select_options
        CHANGING
          ct_data           = et_entityset.
    ENDIF.

  endmethod.


  METHOD zshopfloor_prodo_get_entityset.
**TRY.
*CALL METHOD SUPER->ZSHOPFLOOR_PRODO_GET_ENTITYSET
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

    DATA: lt_amdp_data TYPE zshopfloor_prodorder_866_t.
    CALL METHOD zshopfloor_amdp_866=>get_prod_orders
      EXPORTING
        iv_client = sy-mandt
      IMPORTING
        et_orders = lt_amdp_data.


    et_entityset = lt_amdp_data.


    IF it_filter_select_options IS NOT INITIAL.
      CALL METHOD /iwbep/cl_mgw_data_util=>filtering
        EXPORTING
          it_select_options = it_filter_select_options
        CHANGING
          ct_data           = et_entityset.

    ENDIF.

  ENDMETHOD.
ENDCLASS.
