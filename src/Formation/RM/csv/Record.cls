/// RECORDMAP: Generated from RecordMap 'Formation.RM.csv'
/// on 2022-04-14 at 09:43:18.891 [2022-04-14 09:43:18.891 UTC]
/// by user SuperUser
Class Formation.RM.csv.Record Extends (%Persistent, %XML.Adaptor, Ens.Request, EnsLib.RecordMap.Base) [ Inheritance = right, ProcedureBlock ]
{

Parameter INCLUDETOPFIELDS = 1;

Property id As %String;

Property nom As %String;

Property salle As %String;

Parameter RECORDMAPGENERATED = 1;

Relationship %ParentBatch As Formation.RM.csv.Batch [ Cardinality = one, Inverse = Records ];

Index %ParentBatchIdx On %ParentBatch;


}
