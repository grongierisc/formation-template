Class Grongier.SQL.Snapshot Extends EnsLib.SQL.Snapshot
{

Method %OnNew(pBatchSize As %Integer) As %Status [ Private, ServerOnly = 1 ]
{
	set ..MaxRowsToGet = -1
    Quit $$$OK
}

/// Advance the result set cursor to the next row. Returns 0 if the cursor is at the end of the result set.
Method NextObject(pClassName As %String, ByRef pObject As %SerialObject, ByRef pSC As %Status) As %Integer
{
	
	#dim tProperty As  %Dictionary.CompiledProperty
	
	set pSC = $$$OK
	Set:pClassName=$$$NULLOREF pSC=$$$ERROR($$$EnsErrGeneral,"<NULLOREF> pClassName required ")
	Quit:'$$$ISOK(pSC) $$$NULLOREF
	
	set tCursor = ..Next(.pSC)
	
	
	set tClassName = pClassName
	set tObject = $classmethod(tClassName,"%New")

	
	set tProperties = ##class(%Dictionary.CompiledClass).%OpenId(tClassName).Properties
	
	set tKey = ""
	do {
		
			set tProperty = tProperties.GetNext(.tKey)
			
			if ($ISOBJECT($get(tProperty)) && ("%%OID" '= tProperty.Name ) && ("%Filtre" '= tProperty.Name) ) {
			set tColumnName = tProperty.SqlFieldName
			set:(tColumnName="") tColumnName = tProperty.Parameters.GetAt("EXTERNALSQLNAME")
			set:(tColumnName="") tColumnName = $ZCVT(tProperty.Name,"U")
			set $property(tObject,tProperty.Name) = ..Get(tColumnName)
			//$$$TRACE(tColumnName_"="_..Get(tColumnName))
		}
	} while tKey '= ""
	
	set pObject = tObject
		
	Quit tCursor
}

/// Return Result in List Of Object 
Method GetListObject(pClassName As %String, ByRef pSC As %Status) As %ListOfDataTypes
{
	
	set pSC = $$$OK
	
	set tLOO = ##class(%ListOfDataTypes).%New()
	
	while ..NextObject(pClassName, .tO,.tStatus)
	{
		set tStatus = tLOO.Insert(tO)
	}
	
	set pSC = tStatus
	Quit tLOO
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
