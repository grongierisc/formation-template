Class Formation.BS.RestService Extends Ens.BusinessService
{

/// Description
Property TargetName As %String;

/// Description
Parameter SETTINGS = "Formation.BP.InsertLocalBDD";

/// Description
Method OnProcessInput(pRequest As Ens.Request, Output pResponse As Ens.Response) As %Status
{
    Set sc = $$$OK
    // do something
    Return sc
}

/// Description
Method SendToBP(pRequest As Formation.Msg.FormationInsertRequest, Output pResponse As Ens.Response) As %Status
{
    Return ..SendRequestSync(..TargetName,pRequest,.pResponse)
}

}
