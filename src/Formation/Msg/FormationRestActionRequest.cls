Class Formation.Msg.FormationRestActionRequest Extends Ens.Request
{

/// Verbe
Property Verbe As %String;

Property Id As %String;

Property Formation As Formation.Obj.Formation;

Storage Default
{
<Data name="FormationRestActionRequestDefaultData">
<Subscript>"FormationRestActionRequest"</Subscript>
<Value name="1">
<Value>Verbe</Value>
</Value>
<Value name="2">
<Value>Id</Value>
</Value>
<Value name="3">
<Value>Formation</Value>
</Value>
</Data>
<DefaultData>FormationRestActionRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
