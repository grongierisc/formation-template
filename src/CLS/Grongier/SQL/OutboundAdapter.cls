Include EnsSQLTypes

Class Grongier.SQL.OutboundAdapter Extends (Ens.OutboundAdapter, Grongier.SQL.Common)
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
Method OnInit() As %Status
{
	
	//Pour rétro compactibilité vers 2016.2 à supprimer à paritr de 2017.2.2
	set ..JGClientEnsClassname = "Grongier.SQL.JDBCGateway"
	
	#; Create an instance of the SQLGateway object
	Set tSC=##super() Quit:$$$ISERR(tSC) tSC
	Set tSC=..init()  Quit:$$$ISERR(tSC) tSC
	Set:..StayConnected>0 ..KeepaliveInterval=..StayConnected
	If ..StayConnected<0 { Set tSC=..Connect(..ConnectTimeout)  If $$$ISERR(tSC) $$$LOGWARNING($$$StatusDisplayString(tSC)) } // timeout is not fatal at this point, but do log it
	Else { $$$SetJobMonitor(..BusinessHost.%ConfigName,$$$SystemName_":"_$Job,$$$eMonitorConnected,"0|"_$$$timeUTC) }
	// Comment this for Ensemble 2016.2
	// Do ..deleteRuntimeAppData()
	Quit $$$OK
}

/// Execute a query. A variable number of parameters may be passed in addition to the
/// query string. Results are returned as a new EnsLib.SQL.GatewayResultSet object in the pRS output argument, unless
/// you pass in a EnsLib.SQL.Snapshot object for the pRS argument. In that case, ExecuteQuery will populate the Snapshot
/// object instead, using the values of its FirstRow and MaxRowsToGet properties to choose the set of rows it will represent.
Method ExecuteQueryBatch(ByRef pRS As EnsLib.SQL.GatewayResultSet, pQueryStatement As %String, pBatchSize As %Integer, pParms...) As %Status
{
	Quit ..ExecuteQueryBatchParmArray(.pRS,pQueryStatement,pBatchSize,.pParms)
}

Method ExecuteQueryBatchParmArray(ByRef pRS As Grongier.SQL.GatewayResultSet, pQueryStatement As %String, pBatchSize As %Integer, ByRef pParms) As %Status
{
	If '$$$IsdefObject(pRS) || 'pRS.%IsA("EnsLib.SQL.Snapshot") Kill pRS  Set pRS=$$$NULLOREF
	Set $ZT="Trap", tHS="", tSC=$$$OK, tNetErr=0
	Do {
		#; Connect if not already connected
		Set tSC=..Connect(..ConnectTimeout) If $$$ISERR(tSC) Set:$$$StatusEquals(tSC,$$$EnsErrOutConnectExpired,$$$EnsErrOutConnectFailed)&&..BusinessHost.%Extends("Ens.BusinessOperation") ..BusinessHost.Retry=1  Quit

		#; Execute the statement
		If '..%Connection.%Extends("EnsLib.SQL.CommonJ") {
			Set tSC=..privPrepare(.tHS,pQueryStatement,.pParms,,,.tNetErr)  Quit:$$$ISERR(tSC)
			$$$sysTRACE("Executing...")
			Set tSC=..%Connection.Execute(tHS)
		} Else {
			Set tSC=..privPrepareJ(.tHS,pQueryStatement,.pParms,,,.tNetErr)  Quit:$$$ISERR(tSC)
			$$$sysTRACE("Executing...")
			Set tSC=..%Connection.execQuery(tHS)
		}
		Set:$$$SQLCODENeedData=..%Connection.sqlcode tSC=..putLOBStreams(tHS,.pParms)
		Quit:$$$ISERR(tSC)

		#; Succeeded, construct the custom result set
		Set tRS=##class(Grongier.SQL.GatewayResultSet).%New(pBatchSize)  $$$ASSERT($IsObject(tRS))
		Set tSC=tRS.Initialize(pQueryStatement,$this,tHS,1,"")  Quit:$$$ISERR(tSC)

		If $IsObject(pRS) { Set tSC=tRS.GetSnapshot(pRS) Quit:$$$ISERR(tSC) }
		Else { Set pRS = tRS }

	} While 0
Exit
	If $$$ISERR(tSC) {
		If 'tNetErr {
			#; if privPrepare() returned tNetErr already, we came direct and tSC is already decorated
			Set tNetErr=..isNetErr($$$StatusText(tSC))
			If tHS'=""&&'tNetErr {
				#; Add SQL detailed errors
				Set tSC=..addErrorList(tSC,tHS,.tNetErr)
				If 'tNetErr {
					#; Drop the statement; If the drop fails, record that error status too
					Set tSC1=..%Connection.DropStatement(tHS)
					If $$$ISERR(tSC1) {
						Set:'tNetErr tNetErr=..isNetErr($$$StatusText(tSC1))
						Set tSC=$$$ADDSC(tSC,tSC1)
					}
				}
			}
		}
		If tNetErr Do ..Disconnect()  Set:..BusinessHost.%Extends("Ens.BusinessOperation") ..BusinessHost.Retry=1
	}
	Do:'..StayConnected&&'$IsObject(pRS) ..Disconnect()
	Quit tSC
Trap
	Set $ZT="",tSC=$$$EnsSystemError
	Goto Exit
}

/// Structure of pParms is Caché Multidimensional Array
/// Where :
/// pParms indicate the number of row in batch
/// pParms(integer) indicate the number of parameters in the row
/// pParms(integer,integerParam) indicate the value of the parameter whose position is integerParam.
Method ExecuteUpdateBatchParamArray(Output pNumRowsAffected As %Integer, pUpdateStatement As %String, pParms...) As %Status
{
	
	set tStatus = $$$OK
	
	try{
		
		set pSQLStatement=pUpdateStatement

		// JDBCGwy is an instance of the JDBC Gateway object. EnsLib.SQL.OutboundAdapter instantiates this automatically and stores a reference to it in ..%Connection.%JGProxy

		// Prepare the SQL statement
		Set pHS=..%JGProxy.prepareStatement(..%ConnHandle,pSQLStatement)
		
		// executeParametersBatch expects tArgs to be a $LIST, with the following format:
		//     ParamCount, ParamSets, Type1, Param1, Type2, Param2, Type3, Param3, Type11,Param11 TypeNN,ParamNN
		// 
		// ParamCount is the number of parameters the query expects (in this example 2) 
		// ParamSets is the number of rows we will be inserting in this batch
		// Type1, Type2, ..., TypeN is an integer indicating the JDBC data type for the corresponding Param value (e.g. Param1, Param2, ..., ParamN)
		// Param1, Param2, ..., ParamN is the value for the query parameter

		set nbParam = pParms(1,1)
		set nbBatch = pParms(1)

		set $LIST(tArgs,1)=nbParam // How many parameters ("?") in it
		set $LIST(tArgs,2)=nbBatch // We will insert nbBatch rows in this batch
		
		set i = 2
		
		for k=1:1:nbBatch {
			
			
			for l=1:1:pParms(1,k){
				
				//Set the SqlType
				set i = i +1
				set $LIST(tArgs,i)=+$G(pParms(1,k,l,"SqlType"),+$G(pParms(1,k,l,"CType"),$$$SqlVarchar))

				//Set the value
				set i = i +1
				set $LIST(tArgs,i)=pParms(1,k,l) 
				
			}
			
		}

		
		// Perform the batch insert
		// tResultCodes is a $LIST of integers indicating success/failure for each row in the batch
		set tResultCodes = ..%JGProxy.executeParametersBatch(pHS,.tArgs)


		set tNbUpdate=0
		//Todo, Read list set pNumRowsAffected = $LISTLENGTH(tResultCodes)
		if $LISTVALID(tResultCodes){
			for i=1:1:$LISTLENGTH(tResultCodes)
			{
				//$$$LOGINFO($LG(tResultCodes,i))
				if ($LG(tResultCodes,i)'=-3){
					set tNbUpdate = tNbUpdate +1
				} Else {
					set tStatus = $$$ADDSC(tStatus, $$$ERROR($$$GeneralError,"One row not inserted"))
				}
				
			}
			set pNumRowsAffected = tNbUpdate
		} else {
			set tStatus = $$$ERROR($$$GeneralError,"No row inserted")
		}

		
		
		// Remove Statement to avoid CURSOR Leaks
		set sc = ..%JGProxy.removeStatement(pHS)
		
		k tArgs
		
	}
				
	catch exp{

		Set tStatus = exp.AsStatus()
	}
	
	Quit tStatus
}

Method ExecuteSelectStatement(ByRef pRS As EnsLib.SQL.GatewayResultSet, pObject As %SerialObject) As %Status
{
	set tStatus = $$$OK
	
	set tObject = pObject
	set tSqlStatement = ""
	set tClassName = $CLASSNAME(tObject)
	
	set tProperties = ##class(%Dictionary.CompiledClass).%OpenId(tClassName).Properties
	
	set key = ""
	set tQueryTableName = $PARAMETER(tClassName,"EXTERNALTABLENAME")
	set tQueryFiltres = ""
	set tQuerySelect = ""
	set tColumnQuery = ""
	
	set i = 0
			
	do {
		set tProperty = tProperties.GetNext(.key)
		
		if ($ISOBJECT($get(tProperty)) && ("%%OID" '= tProperty.Name )&& ("%Filtre" '= tProperty.Name)) {

			set tColumnName = tProperty.Parameters.GetAt("EXTERNALSQLNAME")
			set tColumnValue = $Property(tObject,tProperty.Name)
			set tColumnParameter = tProperty.Parameters.GetAt("XMLLISTPARAMETER")
			
			set tColumnQuery = $s(tColumnParameter'="":tColumnParameter,1:tColumnName )
			set tQuerySelect = $s(tQuerySelect'="":tQuerySelect_", ",1:tQuerySelect)_tColumnQuery
			
			if ( tColumnValue  '=  "" )  {
			/* Filtre */	
				set i = i+1					
				set tParms(i) = tColumnValue
				set tParms(i,"SqlType") =  tProperty.Parameters.GetAt("EXTERNALSQLTYPE")
				
				set tColumnQuery = $s(tColumnParameter'="":tColumnParameter,1:tColumnName _ " = ?")
				set tQueryFiltres = $s(tQueryFiltres'="":tQueryFiltres_" AND ",1:tQueryFiltres)_tColumnQuery
						
			} 
		}
	} while key '= ""
	
	set tParms = i

	set tQueryStatement = "SELECT "_tQuerySelect_" FROM "_tQueryTableName_$s(tQueryFiltres'="":" WHERE "_tQueryFiltres,1:"")

	$$$TRACE(tQueryStatement)
	
	set tStatus = ..ExecuteQueryParmArray(.pRS,tQueryStatement,.tParms)

	Quit tStatus
}

Method ExecuteInsertStatement(Output pNumRowsAffected As %Integer, pSqlObject As %SerialObject) As %Status
{
	set tStatus = $$$OK
	
	try{
		//$$$TRACE("OK")
		
		set tObject = pSqlObject
		set tSqlStatement = ""
		set tClassName = $CLASSNAME(tObject)
		
		//$$$TRACE("ClassName: "_tClassName)

		
		set tProperties = ##class(%Dictionary.CompiledClass).%OpenId(tClassName).Properties
		
		set key = ""
		set tQueryTableName = $PARAMETER(tClassName,"EXTERNALTABLENAME")
		set tQueryValues = ""
		set tQueryColumns = ""
		
		set i = 0
				
		do {
			set tProperty = tProperties.GetNext(.key)
			
			if ($ISOBJECT($get(tProperty)) && ("%%OID" '= tProperty.Name ) ) {

				set tColumnName = tProperty.Parameters.GetAt("EXTERNALSQLNAME")
				
				set tColumnQuery = tProperty.Parameters.GetAt("XMLLISTPARAMETER")
				
				set:(tColumnQuery="") tColumnQuery="?"
				
				set tColumnValue = $Property(tObject,tProperty.Name)
				
				if ( tColumnValue  '=  "" )  {
					
					set i = i+1					
					
					set tParms(i) = tColumnValue
					set tParms(i,"SqlType") =  tProperty.Parameters.GetAt("EXTERNALSQLTYPE")
					
					if (tQueryValues '= "") {
					
						set tQueryValues = tQueryValues_","_tColumnQuery
						set tQueryColumns = tQueryColumns_","_tColumnName
						
					}	
					else {
						set tQueryValues = tColumnQuery
						set tQueryColumns = tColumnName
						
					}		
				}
			}
		} while key '= ""
		
		set tParms = i
		//TODO001//
		set tSqlStatement = "INSERT INTO "_tQueryTableName_" ( "_tQueryColumns_" ) VALUES ( "_tQueryValues_" )"
		//tSqlStatement
		//$$$TRACE(tSqlStatement)
		
		$$$ThrowOnError( ..ExecuteUpdateParmArray(.pNumRowsAffected,tSqlStatement,.tParms))

		}
				
	catch exp{
		//$$$TRACE(tSqlStatement)
		Set tStatus = exp.AsStatus()
	}
	
	Quit tStatus
}

/// Execute an Update. A variable number of parameters may be passed in addition to the
/// query string. The pNumRowsAffected output value is the number of rows affected.
Method ExecuteUpdateStatement(Output pNumRowsAffected As %Integer, pUpdateStatement As %String, pParms...) As %Status
{
///	Quit ..ExecuteUpdateParmArray(.pNumRowsAffected,pUpdateStatement,.pParms)
}

/// Execute an Delete. A variable number of parameters may be passed in addition to the
/// query string. The pNumRowsAffected output value is the number of rows affected.
Method ExecuteDeleteStatement(Output pNumRowsAffected As %Integer, pUpdateStatement As %String, pParms...) As %Status
{
///	Quit ..ExecuteUpdateParmArray(.pNumRowsAffected,pUpdateStatement,.pParms)
}

/// Execute an Merge (Update OR Insert). A variable number of parameters may be passed in addition to the
/// query string. The pNumRowsAffected output value is the number of rows affected.
Method ExecuteMergeStatement(Output pNumRowsAffected As %Integer, pUpdateStatement As %String, pParms...) As %Status
{
///	Quit ..ExecuteUpdateParmArray(.pNumRowsAffected,pUpdateStatement,.pParms)
}

/// Execute an Truncate (drop storage). A variable number of parameters may be passed in addition to the
/// query string. The pNumRowsAffected output value is the number of rows affected.
/// Specify DROP STORAGE to deallocate all space from the deleted rows from the table 
/// except the space allocated by the MINEXTENTS parameter of the table or cluster. 
/// This space can subsequently be used by other objects in the tablespace.
Method ExecuteDropStorageStatement(Output pNumRowsAffected As %Integer, pUpdateStatement As %String, pParms...) As %Status
{
///	Quit ..ExecuteUpdateParmArray(.pNumRowsAffected,pUpdateStatement,.pParms)
}

/// Execute an Truncate (Reuse storage). A variable number of parameters may be passed in addition to the
/// query string. The pNumRowsAffected output value is the number of rows affected.
/// Specify REUSE STORAGE to retain the space from the deleted rows allocated to the table. 
/// Storage values are not reset to the values when the table or cluster was created. 
/// This space can subsequently be used only by new data in the table or cluster resulting 
/// from insert or update operations. 
/// This clause leaves storage parameters at their current settings.
Method ExecuteReuseStorageStatement(Output pNumRowsAffected As %Integer, pUpdateStatement As %String, pParms...) As %Status
{
///	Quit ..ExecuteUpdateParmArray(.pNumRowsAffected,pUpdateStatement,.pParms)
}

}
