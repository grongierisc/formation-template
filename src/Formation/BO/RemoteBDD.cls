Include EnsSQLTypes

Class Formation.BO.RemoteBDD Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Property Adapter As EnsLib.SQL.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method InsertRemoteBDD(pRequest As Formation.Msg.FormationInsertRequest, Output pResponse As Ens.StringResponse) As %Status
{
	set tStatus = $$$OK
	
	try{
		set pResponse = ##class(Ens.Response).%New()

		set ^inc = $I(^inc)

		set tInsertSql = "INSERT INTO public.formation (id, nom, salle) VALUES(?, ?, ?)"

		$$$ThrowOnError(..Adapter.ExecuteUpdate(.nrows,tInsertSql,^inc,pRequest.Formation.Nom, pRequest.Formation.Salle ))

		$$$LOGINFO("Nombre de ligne "_nrows)
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


		set tSql = "select * from public.formation"

		$$$ThrowOnError(..Adapter.ExecuteQuery(.pRs,tSql))

		while pRs.%Next() {
			set pResponse.formation = ##class(Formation.Obj.Formation).%New()
			set pResponse.formation.Nom = pRs.GetStream("nom").Read()
			set pResponse.formation.Salle = pRs.GetStream("salle").Read()
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
		<Method>InsertRemoteBDD</Method>
	</MapItem>
	<MapItem MessageType="Formation.Msg.FormationGetByIdRequest"> 
		<Method>GetByIdRemoteBDD</Method>
	</MapItem>
</MapItems>
}

}
