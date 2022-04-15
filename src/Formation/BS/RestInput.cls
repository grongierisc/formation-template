Class Formation.BS.RestInput Extends Ens.BusinessService
{

Property TargetConfigNames As %String(MAXLEN = 1000) [ InitialExpression = "BuisnessProcess" ];

Parameter SETTINGS = "TargetConfigNames:Basic:selector?multiSelect=1&context={Ens.ContextSearch/ProductionItems?targets=1&productionName=@productionId}";

Method OnProcessInput(pDocIn As %RegisteredObject, Output pDocOut As %RegisteredObject) As %Status
{
    set status = $$$OK

    try {


		    $$$ThrowOnError(..SendRequestSync("Formation.BP.Rest",pDocIn,.pDocOut))
	    
    } catch ex {
        set status = ex.AsStatus()
    }

    Quit status
}

}
