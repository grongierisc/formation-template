/// Description
Class Formation.Table.Etudiant Extends %Persistent
{

/// Description
Property Nom As %String;

/// Description
Property IDFormation As %Integer;

/// Description
Property Fonction As %String;

Storage Default
{
<Data name="EtudiantDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Nom</Value>
</Value>
<Value name="3">
<Value>IDFormation</Value>
</Value>
<Value name="4">
<Value>Fonction</Value>
</Value>
</Data>
<DataLocation>^Formation.Table.EtudiantD</DataLocation>
<DefaultData>EtudiantDefaultData</DefaultData>
<IdLocation>^Formation.Table.EtudiantD</IdLocation>
<IndexLocation>^Formation.Table.EtudiantI</IndexLocation>
<StreamLocation>^Formation.Table.EtudiantS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
