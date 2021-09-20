/// RECORDMAP: Generated from RecordMap 'Formation.RM.Csv'
/// on 2021-09-20 at 13:52:30.981 [2021-09-20 13:52:30.981 UTC]
/// by user SuperUser
Class Formation.RM.Csv.Record Extends (%Persistent, %XML.Adaptor, Ens.Request, EnsLib.RecordMap.Base) [ Inheritance = right, ProcedureBlock ]
{

Parameter INCLUDETOPFIELDS = 1;

Property Property1 As %String;

Property Property2 As %String;

Property Property3 As %String;

Parameter RECORDMAPGENERATED = 1;

Relationship %ParentBatch As Formation.RM.Csv.Batch [ Cardinality = one, Inverse = Records ];

Index %ParentBatchIdx On %ParentBatch;

Storage Default
{
<Data name="RecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Property1</Value>
</Value>
<Value name="3">
<Value>%Source</Value>
</Value>
<Value name="4">
<Value>Property3</Value>
</Value>
<Value name="5">
<Value>%ParentBatch</Value>
</Value>
<Value name="6">
<Value>Property2</Value>
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
