/// RECORDMAP: Generated from RecordMap 'Formation.RM.Csv'
/// on 2021-09-20 at 13:52:27.048 [2021-09-20 13:52:27.048 UTC]
/// by user SuperUser
Class Formation.RM.Csv.Record Extends (%Persistent, %XML.Adaptor, Ens.Request, EnsLib.RecordMap.Base) [ Inheritance = right, ProcedureBlock ]
{

Parameter INCLUDETOPFIELDS = 1;

Property id As %String;

Property nom As %String;

Property salle As %String;

Parameter RECORDMAPGENERATED = 1;

Relationship %ParentBatch As Formation.RM.Csv.Batch [ Cardinality = one, Inverse = Records ];

Index %ParentBatchIdx On %ParentBatch;


}
