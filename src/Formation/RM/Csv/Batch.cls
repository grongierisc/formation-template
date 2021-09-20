/// RECORDMAP: Modified during compilation of RecordMap 'Formation.RM.Csv'
/// on 2021-09-20 at 13:52:31.148 [2021-09-20 13:52:31.148 UTC]
/// by user SuperUser
Class Formation.RM.Csv.Batch Extends (%Library.Persistent, EnsLib.RecordMap.SimpleBatch)
{

Parameter XMLNAME = "Formation_RM_Csv_Batch";

Parameter RECORDMAPGENERATED = 1;

Parameter BatchHeader;

Parameter HeaderTerm;

Parameter BatchTrailer;

Parameter TrailerTerm;

Parameter IgnoreLeadingData = 1;

Relationship Records As Formation.RM.Csv.Record [ Cardinality = many, Inverse = %ParentBatch ];

Trigger OnDelete [ Event = DELETE ]
{
	Set %ok = ..deleteRecords({ID})
}

Parameter XMLTYPE = "Formation_RM_Csv_Batch";

Storage Default
{
<Data name="BatchDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>%Source</Value>
</Value>
<Value name="3">
<Value>BatchHeader</Value>
</Value>
<Value name="4">
<Value>BatchTrailer</Value>
</Value>
</Data>
<DataLocation>^Formation.RM.Csv.BatchD</DataLocation>
<DefaultData>BatchDefaultData</DefaultData>
<IdLocation>^Formation.RM.Csv.BatchD</IdLocation>
<IndexLocation>^Formation.RM.Csv.BatchI</IndexLocation>
<StreamLocation>^Formation.RM.Csv.BatchS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
