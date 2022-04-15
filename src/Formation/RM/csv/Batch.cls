/// RECORDMAP: Modified during compilation of RecordMap 'Formation.RM.csv'
/// on 2022-04-14 at 09:43:18.967 [2022-04-14 09:43:18.967 UTC]
/// by user SuperUser
Class Formation.RM.csv.Batch Extends (%Library.Persistent, EnsLib.RecordMap.SimpleBatch)
{

Parameter XMLNAME = "Formation_RM_csv_Batch";

Parameter RECORDMAPGENERATED = 1;

Parameter BatchHeader = "id;nom;salle";

Parameter HeaderTerm = "\x0a";

Parameter BatchTrailer;

Parameter TrailerTerm;

Parameter IgnoreLeadingData = 0;

Relationship Records As Formation.RM.csv.Record [ Cardinality = many, Inverse = %ParentBatch ];

Trigger OnDelete [ Event = DELETE ]
{
	Set %ok = ..deleteRecords({ID})
}

Parameter XMLTYPE = "Formation_RM_csv_Batch";


}
