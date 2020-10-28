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
	}
	catch exp
	{
		Set tStatus = exp.AsStatus()
	}

	Quit tStatus
}

Method SelectByNameRemoteBDD(pRequest As Ens.StringRequest, Output pResponse As Formation.Msg.FormationSelectResponse) As %Status
{
	set tStatus = $$$OK
	
	try{
		set pResponse = ##class(Formation.Msg.FormationSelectResponse).%New()
		set pResponse.ListFormation = ##class(%Library.ListOfObjects).%New()

		set tSelectSql = "select * from public.formation where nom = ?"
		$$$LOGINFO(tSelectSql)
		$$$ThrowOnError(..Adapter.ExecuteQuery(.tRs,tSelectSql, pRequest.StringValue))

		While tRs.%Next(){

			set tFormation = ##class(Formation.Obj.Formation).%New()
			set tFormation.Nom = tRs.Get("nom")
			set tFormation.Salle = tRs.Get("salle")
			$$$ThrowOnError(pResponse.ListFormation.Insert(tFormation))
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
	<MapItem MessageType="Ens.StringRequest"> 
		<Method>SelectByNameRemoteBDD</Method>
	</MapItem>
</MapItems>
}

}
