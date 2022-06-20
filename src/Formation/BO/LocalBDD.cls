Class Formation.BO.LocalBDD Extends Ens.BusinessOperation
{

Parameter INVOCATION = "Queue";

Method InsertLocalBDD(pRequest As Formation.Msg.FormationInsertRequest, Output pResponse As Formation.Msg.FormationInsertResponse) As %Status
{
    set tStatus = $$$OK
    
    try{
        set pResponse = ##class(Formation.Msg.FormationInsertResponse).%New()
        if $RANDOM(10) < 5 {
            set pResponse.Double = 1
        } 
        else {
            set pResponse.Double = 0
        }
        set tFormation = ##class(Formation.Table.Formation).%New()
        set tFormation.Nom = pRequest.Formation.Nom
        set tFormation.Salle = pRequest.Formation.Salle
        $$$ThrowOnError(tFormation.%Save())
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
</MapItems>
}

}
