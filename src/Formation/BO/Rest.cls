Class Formation.BO.Rest Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.HTTP.OutboundAdapter";

Property Adapter As EnsLib.HTTP.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method GetInfo(pRequest As Ens.StringRequest, Output pResponse As Ens.StringResponse) As %Status
{
	set tStatus = $$$OK
	
	try{
					
        set tURL = ""
        $$$ThrowOnError(..Adapter.GetURL(tURL,.tHttpResponse))

        Set pResponse = ##class(Ens.StringContainer).%New({}.%FromJSON(tHttpResponse.Data).%ToJSON())

		
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
	<MapItem MessageType="Ens.StringRequest"> 
		<Method>GetInfo</Method>
	</MapItem>
</MapItems>
}

}
