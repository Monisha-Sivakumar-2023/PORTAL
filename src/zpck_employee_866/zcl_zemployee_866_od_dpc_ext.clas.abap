class ZCL_ZEMPLOYEE_866_OD_DPC_EXT definition
  public
  inheriting from ZCL_ZEMPLOYEE_866_OD_DPC
  create public .

public section.

  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~GET_STREAM
    redefinition .
protected section.

  methods ZEMP_LEAVE_REQ_8_GET_ENTITYSET
    redefinition .
  methods ZEMP_LOGIN_866SE_GET_ENTITY
    redefinition .
  methods ZEMP_PAYSLIP_866_GET_ENTITYSET
    redefinition .
  methods ZEMP_PROFILE_866_GET_ENTITYSET
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZEMPLOYEE_866_OD_DPC_EXT IMPLEMENTATION.


  method ZEMP_LEAVE_REQ_8_GET_ENTITYSET.
**TRY.
*CALL METHOD SUPER->ZEMP_LEAVE_REQ_8_GET_ENTITYSET
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

    CALL METHOD zemp_leave_request_866=>get_leave_data
  EXPORTING
    iv_client = sy-mandt
  IMPORTING
    et_data   = et_entityset
    .

      CALL METHOD /iwbep/cl_mgw_data_util=>filtering
      EXPORTING
        it_select_options = it_filter_select_options
      CHANGING
        ct_data           = et_entityset.

  endmethod.


  method ZEMP_LOGIN_866SE_GET_ENTITY.
**TRY.
*CALL METHOD SUPER->ZEMP_LOGIN_866SE_GET_ENTITY
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

      DATA: lv_employeeid TYPE pernr_d,
        lv_password   TYPE Z_USERPASS_866_DE,
        lt_key_tab    TYPE /iwbep/t_mgw_tech_pairs,
        ls_key        TYPE /iwbep/s_mgw_tech_pair,
        ls_login      TYPE ZDT_EMP_CRED_866.

  " Get key values from the request
  lt_key_tab = io_tech_request_context->get_keys( ).

  LOOP AT lt_key_tab INTO ls_key.
    CASE ls_key-name.
      WHEN 'EMPLOYEE_ID'.
        lv_employeeid = ls_key-value.
      WHEN 'PASSCODE'.
        lv_password = ls_key-value.
    ENDCASE.
  ENDLOOP.
  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = lv_employeeid
      IMPORTING
        output = lv_employeeid.

  " Check if the login credentials exist in the table
  SELECT SINGLE * INTO @ls_login
    FROM ZDT_EMP_CRED_866
    WHERE employee_id = @lv_employeeid
      AND passcode  = @lv_password.

  IF sy-subrc = 0.
    " Credentials are valid – return employee ID and success message
    er_entity = VALUE ZEMPLOYEE_LOGIN_866_S(
                    employee_id = lv_employeeid
                    passcode   = 'Login Successful'
                ).
  ELSE.
    " Invalid login – return error message
    er_entity = VALUE ZEMPLOYEE_LOGIN_866_S(
                    employee_id = lv_employeeid
                    passcode   = 'Invalid Credentials'
                ).
  ENDIF.

  endmethod.


  method ZEMP_PAYSLIP_866_GET_ENTITYSET.
**TRY.
*CALL METHOD SUPER->ZEMP_PAYSLIP_866_GET_ENTITYSET
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

    DATA: lv_pernr TYPE pernr_d.

    " 1. Extract Filter (Employee ID)
    LOOP AT it_filter_select_options INTO DATA(ls_filter).
      IF ls_filter-property = 'EmpId' OR ls_filter-property = 'EMP_ID'.
        READ TABLE ls_filter-select_options INTO DATA(ls_option) INDEX 1.
        IF sy-subrc = 0.
          lv_pernr = ls_option-low.
          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
            EXPORTING input = lv_pernr
            IMPORTING output = lv_pernr.
        ENDIF.
      ENDIF.
    ENDLOOP.


    IF lv_pernr IS NOT INITIAL.
      TRY.
CALL METHOD zemp_payslip_866=>get_payslip_data
  EXPORTING
    iv_client = sy-mandt
    iv_pernr  = lv_pernr
  IMPORTING
    et_data   = et_entityset
    .

        CATCH cx_amdp_error.
      ENDTRY.
    ENDIF.

  endmethod.


  method ZEMP_PROFILE_866_GET_ENTITYSET.
**TRY.
*CALL METHOD SUPER->ZEMP_PROFILE_866_GET_ENTITYSET
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

    TRY.
        CALL METHOD zemp_profile_866=>get_profile_data
          EXPORTING
            iv_client = sy-mandt
          IMPORTING
            et_data   = et_entityset.

      CATCH cx_amdp_error INTO DATA(lx_amdp).
        " Handle DB errors here
    ENDTRY.

*     2. Map AMDP Result to OData Entity Set
*     (MOVE-CORRESPONDING handles matching field names automatically)
*    MOVE-CORRESPONDING lt_amdp_data TO et_entityset.

    " 3. Apply Filtering ($filter)
    IF it_filter_select_options IS NOT INITIAL.
      CALL METHOD /iwbep/cl_mgw_data_util=>filtering
        EXPORTING
          it_select_options = it_filter_select_options
        CHANGING
          ct_data           = et_entityset.
    ENDIF.

    " 4. Apply Paging ($top/$skip) - Optional but recommended
    IF is_paging IS NOT INITIAL.
      /iwbep/cl_mgw_data_util=>paging(
        EXPORTING
          is_paging = is_paging
        CHANGING
          ct_data   = et_entityset ).
    ENDIF.

  endmethod.


  method /IWBEP/IF_MGW_APPL_SRV_RUNTIME~GET_STREAM.
**TRY.
*CALL METHOD SUPER->/IWBEP/IF_MGW_APPL_SRV_RUNTIME~GET_STREAM
**  EXPORTING
**    iv_entity_name          =
**    iv_entity_set_name      =
**    iv_source_name          =
**    it_key_tab              =
**    it_navigation_path      =
**    io_tech_request_context =
**  IMPORTING
**    er_stream               =
**    es_response_context     =
*    .
**  CATCH /iwbep/cx_mgw_busi_exception.
**  CATCH /iwbep/cx_mgw_tech_exception.
**ENDTRY.

TYPES: BEGIN OF ty_s_media_resource,
           mime_type TYPE string,
           value     TYPE xstring,
         END OF ty_s_media_resource.

  DATA: lv_funcname    TYPE funcname,
        ls_output      TYPE sfpoutputparams,
        ls_formoutput  TYPE fpformoutput,
        ls_stream      TYPE ty_s_media_resource,
        ls_pernr       TYPE pernr_d,
        ls_value       TYPE /iwbep/s_mgw_name_value_pair.

* Read EMP_ID or PERNR from key
  READ TABLE it_key_tab INTO ls_value WITH KEY name = 'EMPID'.
  IF sy-subrc <> 0.
    READ TABLE it_key_tab INTO ls_value WITH KEY name = 'PERNR'.
  ENDIF.

  IF sy-subrc = 0.
    ls_pernr = ls_value-value.
  ELSE.
    RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
      EXPORTING message = 'Missing Employee Number (EMPID/PERNR)'.
  ENDIF.

* Get Adobe Form function module
  CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
    EXPORTING i_name = 'ZF_EMPLOYEE_PAYSLIP_866'
    IMPORTING e_funcname = lv_funcname.

* Set output params
  ls_output-nodialog = abap_true.
  ls_output-getpdf   = abap_true.

  CALL FUNCTION 'FP_JOB_OPEN'
    CHANGING ie_outputparams = ls_output.

* Call Adobe Form FM dynamically
  CALL FUNCTION lv_funcname
    EXPORTING
      EMPID = ls_pernr
    IMPORTING
      /1bcdwb/formoutput = ls_formoutput.

  CALL FUNCTION 'FP_JOB_CLOSE'.

* Prepare PDF stream
  ls_stream-value     = ls_formoutput-pdf.
  ls_stream-mime_type = 'application/pdf'.

* Send response to client
  copy_data_to_ref(
    EXPORTING is_data = ls_stream
    CHANGING  cr_data = er_stream
  ).

  endmethod.
ENDCLASS.
