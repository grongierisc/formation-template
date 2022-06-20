Class Formation.Table.Formation Extends %Persistent
{

Property Nom As %String;

Property Salle As %String;

Storage Default
{
<Data name="FormationDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Nom</Value>
</Value>
<Value name="3">
<Value>Salle</Value>
</Value>
</Data>
<DataLocation>^Formation.Table.FormationD</DataLocation>
<DefaultData>FormationDefaultData</DefaultData>
<IdLocation>^Formation.Table.FormationD</IdLocation>
<IndexLocation>^Formation.Table.FormationI</IndexLocation>
<StreamLocation>^Formation.Table.FormationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
