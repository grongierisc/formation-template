Class Grongier.SQL.JDBCGateway Extends %Net.Remote.Java.JDBCGateway
{

Method executeParametersBatch(ByRef p0 As %Library.ObjectHandle, ByRef p1 As %Library.ObjectHandle) As %Library.ObjectHandle
{
	#; Corresponding Java method: execParamBatch arguments: SQL Statement ID, $list with the following order: 
	#;  ParamCount, ParamSets, Type1, Param1, Type2, Param2, Type3, Param3, Type11, Param11, TypeNN, ParamNN
	Quit ..%Execute2R(102,p0, p1)
}

}
