Class Formation.BO.LocalBDD Extends Ens.BusinessOperation
{

Parameter INVOCATION = "Queue";

Method InsertLocalBDD(pRequest As Formation.Msg.FormationInsertRequest, Output pResponse As Ens.StringResponse) As %Status
{
    set tStatus = $$$OK
    
    try{
        set pResponse = ##class(Formation.Msg.FormationInsertResponse).%New()

        set tFormation = ##class(Formation.Table.Formation).%New()
        set tFormation.Name = pRequest.Formation.Nom
        set tFormation.Salle = pRequest.Formation.Salle
		
        $$$ThrowOnError(tFormation.%Save())

        set pResponse.Id = tFormation.%Id()

    }
    catch exp
    {
        Set tStatus = exp.AsStatus()
    }

    Quit tStatus
}

Method GetByIdRemoteBDD(pRequest As Formation.Msg.FormationGetByIdRequest, Output pResponse As Formation.Msg.FormationGetByIdResponse) As %Status
{
	set tStatus = $$$OK
	
	try{
		set pResponse = ##class(Formation.Msg.FormationGetByIdResponse).%New()

        if ##class(Formation.Table.Formation).%ExistsId(pRequest.Id)
        {
            set tFormation = ##class(Formation.Table.Formation).%OpenId(pRequest.Id)

            set pResponse.formation.Nom = tFormation.Name
            set pResponse.formation.Salle = tFormation.Salle
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
	<MapItem MessageType="Formation.Msg.FormationGetByIdRequest"> 
		<Method>GetByIdRemoteBDD</Method>
	</MapItem>
</MapItems>
}

}
