/// RECORDMAP: Modified during compilation of RecordMap 'Formation.RM.Csv'
/// on 2021-09-20 at 13:52:27.053 [2021-09-20 13:52:27.053 UTC]
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


}
