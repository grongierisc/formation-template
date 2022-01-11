Class Formation.BO.LocalBDD Extends Ens.BusinessOperation
{

Parameter INVOCATION = "Queue";

Method InsertLocalBDD(pRequest As Formation.Msg.FormationInsertRequest, Output pResponse As Ens.StringResponse) As %Status
{
    set tStatus = $$$OK
    
    try{
        set pResponse = ##class(Ens.StringResponse).%New()
        set pResponse.StringValue = pRequest.Formation.Nom_" "_pRequest.Formation.Salle
        set tFormation = ##class(Formation.Table.Formation).%New()
        set tFormation.Name = pRequest.Formation.Nom
        set tFormation.Salle = pRequest.Formation.Salle
        $$$ThrowOnError(tFormation.%Save())
    }
    catch exp
    {
        Set tStatus = exp.AsStatus()
    }

    Quit tStatus
}

Method SelectByIdLocalBDD(pRequest As Formation.Msg.FormationSelectByIdRequest, Output pResponse As Formation.Msg.FormationSelectByIdResponse) As %Status
{
    set tStatus = $$$OK
    
    try{
        set pResponse = ##class(Formation.Msg.FormationSelectByIdResponse).%New()
        if ##class(Formation.Table.Formation).%ExistsId(pRequest.ForamtionID) {
            set tFormation = ##class(Formation.Table.Formation).%OpenId(pRequest.ForamtionID)
            set pResponse.Formation.Nom = tFormation.Name
            set pResponse.Formation.Salle = tFormation.Salle
        }
    }
    catch exp
    {
        Set tStatus = exp.AsStatus()
    }

    Quit tStatus
}

XData MessageMap
{
<MapItems>
    <MapItem MessageType="Formation.Msg.FormationInsertRequest"> 
        <Method>InsertLocalBDD</Method>
    </MapItem>
    <MapItem MessageType="Formation.Msg.FormationSelectByIdRequest"> 
        <Method>SelectByIdLocalBDD</Method>
    </MapItem>
</MapItems>
}

}
