@AbapCatalog.sqlViewName: 'ZQAINSPECT866V'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for Inspection - Quality Portal'
@Metadata.ignorePropagatedAnnotations: true
@OData.publish: true  

define view Z_QA_INSPECTION_CDS_866 as select from qals

left outer join qave on qals.prueflos = qave.prueflos
{
    
    key qals.prueflos     as InspectionLot,
    qals.selmatnr         as MaterialNumber,
    qals.werk             as Plant,
    qals.art              as InspectionType,
    qals.enstehdat        as CreatedDate,
    qals.pastrterm        as StartDate,
    qals.paendterm        as EndDate,
    
    @Semantics.quantity.unitOfMeasure: 'UoM'
    qals.losmenge         as LotQuantity,
    qals.mengeneinh       as UoM,
    
    qals.ktextmat         as MaterialDesc,
    qave.kzart            as UDType,

    case 
        when qave.vcode is null then 'PENDING'
        else qave.vcode
    end as UsageDecisionCode
}
