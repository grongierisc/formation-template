Class Grongier.SQL.GatewayResultSet Extends EnsLib.SQL.GatewayResultSet
{

/*
		 *****************************************************
		 *                 ** N O T I C E **                 *
		 *               - TEST/DEMO SOFTWARE -              *
		 * This and related items are not supported by       *
		 * InterSystems as part of any released product.     *
		 * It is supplied by InterSystems as a demo/test     *
		 * tool for a specific product and version.          *
		 * The customer or partner is fully responsible for  *
		 * the maintenance of this software after delivery,  *
		 * and InterSystems shall bear no responsibility nor *
		 * liabilities for errors or misuse of this item.    *
		 *                                                   *
		 *****************************************************
*/
Property CurRow As %Integer;

Property RowInBatch As %Integer;

Property cJGProxy As %Net.Remote.Java.JDBCGateway;

Property BatchSize As %Integer [ InitialExpression = 1000 ];

Property BaseSubscript As %Integer;

Method %OnNew(pBatchSize As %Integer) As %Status [ Private, ServerOnly = 1 ]
{
	If pBatchSize="" set pBatchSize = 1000
    Set ..BatchSize=pBatchSize
    Quit $$$OK
}

Method Next(ByRef pSC As %Status) As %Integer
{
	s tCnt=$I(^zlog("Custom Next()"))
	if ('$D(%JCACHE(..%HS)) || (..RowInBatch=%JCACHE(..%HS))) {
		if ($G(%JCACHE(..%HS),0) && (%JCACHE(..%HS)<..BatchSize)) {
			// We've reached the end of the result set
			quit 0
		}

		set ..RowInBatch=0
		s tSC=..cJGProxy.getNRows(..%HS,..BatchSize)

		if (%JCACHE(..%HS)=0) {
			//No more rows to fetch
			quit 0
		}
	}

	set ..RowInBatch=..RowInBatch+1
	set ..CurRow=..CurRow+1
	set ..BaseSubscript=(..RowInBatch-1) * %JCACHE(..%HS,"n")

	quit 1
}

Method Get(pColName As %String) As %String [ CodeMode = expression ]
{
$Get(%JCACHE(..%HS,(..BaseSubscript +($Get(..ColID($ZCVT(pColName,"L")),0)))))
}

Method GetData(pCol As %Integer) As %String [ CodeMode = expression ]
{
$Get(%JCACHE(..%HS,(..BaseSubscript +($Get(pCol)))))
}

/// Populate an EnsLib.SQL.Snapshot object. If you pass one in, it will be populated using the values in its
/// FirstRow and MaxRowsToGet properties. Otherwise, GetSnapshot will construct a new one and use its default
/// values for FirstRow and MaxRowsToGet.
Method GetSnapshot(ByRef pSnap As EnsLib.SQL.Snapshot, pFetchAll As %Boolean = 0) As %Status
{
	Set $ZT="Trap", tSC=$$$OK, tNetDone=0
	Do {
		If '$$$IsdefObject(pSnap) { Set pSnap = ##class(EnsLib.SQL.Snapshot).%New()  $$$ASSERT($IsObject(pSnap)) }
		Else {
			$$$ASSERT(pSnap.%IsA("EnsLib.SQL.Snapshot"))
			Do pSnap.Clean()
		}
		Set tMaxRows = pSnap.MaxRowsToGet, tFirstRow = pSnap.FirstRow
		
		Set tGblRef = pSnap.%GblRef
		Merge @tGblRef@("ColNames") = ..ColName
		Merge @tGblRef@("ColIDs") = ..ColID
		Merge @tGblRef@("ColTypes") = ..ColType
		Merge @tGblRef@("ColSizes") = ..ColSize
		Do pSnap.GenerateIResultSetMetadata()

		#; Fast SkipNext() loop
		If tFirstRow>1 {
			For i=1:1:tFirstRow-1 {
				Set tSC=..%Connection.Fetch(..%HS)  If 100=..%Connection.sqlcode Set tSC=$$$OK Quit
				Quit:$$$ISERR(tSC)
			}
			Quit:100=..%Connection.sqlcode||$$$ISERR(tSC) 
		}
		
		#; Old Loop
		#; Next()/GetData() loop
		/*For i=1:1 { Quit:tMaxRows>=0&&(i>tMaxRows)
			Set tNetDone='..Next(.tSC)  Quit:tNetDone
			Merge @tGblRef@(i)=..Data
			Set nCols=..ColCount  For c=1:1:nCols { Set:$D(i%Data(c,"ref")) i%Data(c,"got")=1 }
			Set @tGblRef = $G(@tGblRef)+1
		} Quit:tNetDone*/
		
		#; Loop with new get
		#; Save data
		Set nCols=..ColCount
		Set r=0  While ..Next(.tSC) { 
			Set r=r+1 For c = 1:1:nCols { Set @tGblRef@(r,c) = $Get(%JCACHE(..%HS,(..BaseSubscript +($Get(c))))) } 
		} 
		Set @tGblRef=r

		#; Fast SkipNext() loop for remainder (in case of multi-RS SP calls)
		If tMaxRows>=0&&pFetchAll {
			For {
				Set tSC=..%Connection.Fetch(..%HS)  If 100=..%Connection.sqlcode Set tSC=$$$OK Quit
				Quit:$$$ISERR(tSC)
			}
		}
	} While 0
Exit
	If 'tNetDone&&$$$ISERR(tSC) {
		Set tNetErr=..%Adapter.isNetErr($$$StatusText(tSC))
		Set:..%HS'="" tSC=..%Adapter.addErrorList(tSC,..%HS,.tNetErr)
		Do:tNetErr ..%Adapter.Disconnect()
	}
	Quit tSC
Trap
	Set $ZT="",tSC=$$$EnsSystemError
	Goto Exit
}

Method Initialize(pQueryStatement As %String, pAdapter As EnsLib.SQL.OutboundAdapter, pHS As %String, pFinal As %Boolean, pMoreIndex As %Integer) As %Status
{
	set tSC=##super(.pQueryStatement, .pAdapter, .pHS, .pFinal, .pMoreIndex)

	set ..cJGProxy=..%Connection.%JGProxy
	set ..CurRow=0

	kill %JCACHE(..%HS)

	quit tSC
}

}
