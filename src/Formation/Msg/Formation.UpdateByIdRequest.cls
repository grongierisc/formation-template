/// Description
Class Formation.Msg.FormationUpdateByIdRequest Extends Ens.Request
{

/// Description
Property ID As %Integer;

/// Description
Property Nom As %String;

/// Description
Property Salle As %String;

Storage Default
{
<Data name="FormationUpdateByIdRequestDefaultData">
<Subscript>"FormationUpdateByIdRequest"</Subscript>
<Value name="1">
<Value>ID</Value>
</Value>
<Value name="2">
<Value>Nom</Value>
</Value>
<Value name="3">
<Value>Salle</Value>
</Value>
</Data>
<DefaultData>FormationUpdateByIdRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
