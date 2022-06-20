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

XData MessageMap
{
<MapItems>
	<MapItem MessageType="Formation.Msg.FormationInsertRequest"> 
		<Method>InsertRemoteBDD</Method>
	</MapItem>
</MapItems>
}

}
