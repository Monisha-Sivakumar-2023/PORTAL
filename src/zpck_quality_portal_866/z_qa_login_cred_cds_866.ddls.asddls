@AbapCatalog.sqlViewName: 'ZQALOGIN866V'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for Login - Quality Portal'
@Metadata.ignorePropagatedAnnotations: true
@OData.publish: true
define view Z_QA_LOGIN_CRED_CDS_866 as select from zdt_qa_login_866
{
    key username ,
    password,
    cast( 'Success' as abap.char(10) ) as login_status
}
