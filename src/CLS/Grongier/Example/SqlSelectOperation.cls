Class Grongier.Example.SqlSelectOperation Extends Ens.BusinessOperation
{

Parameter ADAPTER = "Grongier.SQL.OutboundAdapter";

Property Adapter As Grongier.SQL.OutboundAdapter;

Parameter INVOCATION = "Queue";

Property FetchSize As %Integer [ InitialExpression = 500 ];

Parameter SETTINGS = "FetchSize";

// Set storage max pour ce processus

Method OnInit() As %Status
{
	Do ##super()
	SET $ZSTORAGE=2147483647
	q $$$OK
}

Method GetBatchSelect(pRequest As Ens.StringRequest, Output pResponse As Ens.StringResponse) As %Status
{
	
	set tStatus = $$$OK
	set nbRows = 0

	try{
		
		set pResponse = ##class(Ens.StringResponse).%New()
		set sqlGetView = "SELECT ID, ProductName FROM DemoData.ODS_Products"
		
		Set TimeStampStart = ##class(%Library.PosixTime).LogicalToUnixTime(##class(%Library.PosixTime).CurrentTimeStamp())

		$$$TRACE(sqlGetView)
			
		$$$ThrowOnError(..Adapter.ExecuteQueryBatch(.tRs,sqlGetView,..FetchSize))
		
		While tRs.%Next(){

			Set tID = tRs.Get("ID")

			If ##class(Grongier.Example.Product).%ExistsId(tID){
				Set tProduct = ##class(Grongier.Example.Product).%OpenId(tID)
			}
			Else {
				Set tProduct = ##class(Grongier.Example.Product).%New()
			}
			
			Set tProduct.ID = tID
			Set tProduct.Name = tRs.Get("ProductName")
			$$$ThrowOnError(tProduct.%Save())

			Do $INCREMENT(nbRows)
		}
		
		Set TimeStampEnd = ##class(%Library.PosixTime).LogicalToUnixTime(##class(%Library.PosixTime).CurrentTimeStamp())

		Set Delta = TimeStampEnd - TimeStampStart

		Set pResponse.StringValue = nbRows_" in "_Delta
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
		<Method>GetBatchSelect</Method>
	</MapItem>
</MapItems>
}

}
