/// RECORDMAP: Generated from RecordMap 'Formation.RM.Csv'
/// on 2021-05-31 at 07:55:30.441 [2021-05-31 07:55:30.441 UTC]
/// by user SuperUser
Class Formation.RM.Csv.Record Extends (%Persistent, %XML.Adaptor, Ens.Request, EnsLib.RecordMap.Base) [ Inheritance = right, ProcedureBlock ]
{

Parameter INCLUDETOPFIELDS = 1;

Property id As %String;

Property nom As %String;

Property salle As %String;

Parameter RECORDMAPGENERATED = 1;

Storage Default
{
<Data name="RecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>id</Value>
</Value>
<Value name="3">
<Value>%Source</Value>
</Value>
<Value name="4">
<Value>salle</Value>
</Value>
<Value name="5">
<Value>nom</Value>
</Value>
</Data>
<DataLocation>^Formation.RM.Csv.RecordD</DataLocation>
<DefaultData>RecordDefaultData</DefaultData>
<ExtentSize>2000000</ExtentSize>
<IdLocation>^Formation.RM.Csv.RecordD</IdLocation>
<IndexLocation>^Formation.RM.Csv.RecordI</IndexLocation>
<StreamLocation>^Formation.RM.Csv.RecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
