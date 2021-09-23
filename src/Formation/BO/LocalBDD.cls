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
		set pResponse.ID = tFormation.%Id()
	}
	catch exp
	{
		Set tStatus = exp.AsStatus()
	}

	Quit tStatus
}

/// Description
Method SelectByIdLocalBDD(pRequest As Formation.Msg.FormationSelectByIdRequest, Output pResponse As Formation.Msg.FormationSelectByIdResponse) As %Status
{
	Set sc = $$$OK
	set pResponse = ##class(Formation.Msg.FormationSelectByIdResponse).%New()
	set tFormation = ##class(Formation.Table.Formation).%OpenId(pRequest.ID)
	set pResponse.Formation.Nom = tFormation.Name
	set pResponse.Formation.Salle = tFormation.Salle
	Return sc
}

/// Description
Method UpdateByIdLocalBDD(pRequest As Formation.Msg.FormationUpdateByIdRequest, Output pResponse As Formation.Msg.FormationUpdateByIdResponse) As %Status
{
	Set sc = $$$OK
	set pResponse = ##class(Formation.Msg.FormationUpdateByIdResponse).%New()
	set tFormation = ##class(Formation.Table.Formation).%OpenId(pRequest.ID)
	set tFormation.Name = pRequest.Nom 
	set tFormation.Salle = pRequest.Salle 
	set pResponse.Formation.Nom = tFormation.Name
	set pResponse.Formation.Salle = tFormation.Salle
	do tFormation.%Save()
	
	Return sc
}

/// Description
Method DeleteByIdLocalBDD(pRequest As Formation.Msg.FormationDeleteByIdRequest, Output pResponse As Formation.Msg.FormationDeleteByIdResponse) As %Status
{
	Set sc = $$$OK
		do ##class(Formation.Table.Formation).%DeleteId(pRequest.ID)
	Return sc
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

	<MapItem MessageType="Formation.Msg.FormationUpdateByIdRequest"> 
		<Method>UpdateByIdLocalBDD</Method>
	</MapItem>

	<MapItem MessageType="Formation.Msg.FormationDeleteByIdRequest"> 
		<Method>DeleteByIdLocalBDD</Method>
	</MapItem>

</MapItems>
}

}
