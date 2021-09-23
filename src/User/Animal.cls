/// Description
Class User.Animal Extends %Persistent
{

/// Description
Property Nom As %String;

/// Description
Method Parler() As %Status
{
    
    Write "Bonjour"
    Return  $$$OK
}

Storage Default
{
<Data name="AnimalDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Nom</Value>
</Value>
</Data>
<DataLocation>^User.AnimalD</DataLocation>
<DefaultData>AnimalDefaultData</DefaultData>
<IdLocation>^User.AnimalD</IdLocation>
<IndexLocation>^User.AnimalI</IndexLocation>
<StreamLocation>^User.AnimalS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
